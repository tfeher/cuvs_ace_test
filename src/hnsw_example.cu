/*
 * SPDX-FileCopyrightText: Copyright (c) 2025-2026, NVIDIA CORPORATION.
 * SPDX-License-Identifier: Apache-2.0
 */

#include <cstdint>
#include <filesystem>
#include <memory>

#include <raft/core/device_mdarray.hpp>
#include <raft/core/logger.hpp>
#include <raft/core/resources.hpp>
#include <string>

#include <cuvs/neighbors/cagra.hpp>
#include <cuvs/neighbors/hnsw.hpp>
#include <cuvs/neighbors/ivf_pq.hpp>
#include <cuvs/util/host_memory.hpp>

#include <rmm/mr/pool_memory_resource.hpp>

#include <cstdio>
#include <cstdlib> // for exit
#include <fcntl.h>
#include <optional>
#include <stdint.h>
#include <sys/mman.h>
#include <unistd.h>

template <typename T>
class BinaryFile
{
public:
  BinaryFile(const char *filepath, uint32_t max_rows = 0)
      : fd_(-1), mapped_ptr_(nullptr), data_(nullptr), file_size_(0)
  {

    fd_ = open(filepath, O_RDONLY);
    if (fd_ == -1)
    {
      throw std::runtime_error(std::string("Error opening file: ") + filepath);
    }

    uint32_t shape[2];
    ssize_t bytesRead = read(fd_, shape, 8);
    if (bytesRead != 8)
    {
      close(fd_);
      throw std::runtime_error(std::string("Error reading shape from file: ") + filepath);
    }

    shape_[0] = (max_rows > 0 && max_rows < shape[0]) ? max_rows : shape[0];
    shape_[1] = shape[1];

    size_t data_size = shape_[0] * static_cast<size_t>(shape_[1]);
    size_t header_size = 8;
    file_size_ = data_size * sizeof(T) + header_size;

    mapped_ptr_ = (uint8_t *)mmap(nullptr, file_size_, PROT_READ, MAP_SHARED, fd_, 0);
    if (mapped_ptr_ == MAP_FAILED)
    {
      close(fd_);
      throw std::runtime_error(std::string("Error mmapping file: ") + filepath);
    }

    data_ = reinterpret_cast<T *>(mapped_ptr_ + header_size);
  }

  ~BinaryFile()
  {
    if (mapped_ptr_ != nullptr && mapped_ptr_ != MAP_FAILED)
    {
      munmap(mapped_ptr_, file_size_);
    }
    if (fd_ != -1)
    {
      close(fd_);
    }
  }

  BinaryFile(const BinaryFile &) = delete;
  BinaryFile &operator=(const BinaryFile &) = delete;

  T *data() { return data_; }
  const T *data() const { return data_; }

  uint32_t rows() const { return shape_[0]; }
  uint32_t cols() const { return shape_[1]; }
  raft::host_matrix_view<const T, int64_t> view()
  {
    return raft::make_host_matrix_view<const T, int64_t>(data_, rows(), cols());
  }

private:
  int fd_;
  uint8_t *mapped_ptr_;
  T *data_;
  size_t file_size_;
  uint32_t shape_[2];
};

struct app_args
{
  std::string dataset_path;
  std::string index_path = "hnsw_index.bin";
  int max_dataset_rows = 0;
  int M = 24;
  int ef_construction = 200;
};

app_args parse_args(int argc, char **argv)
{
  app_args args;
  bool has_dataset_path = false;
  bool arg_error = false;
  for (int i = 1; i < argc; ++i)
  {
    std::string a = argv[i];
    if (a == "--dataset" && i + 1 < argc)
    {
      args.dataset_path = argv[++i];
      has_dataset_path = true;
    }
    else if (a == "--index_path" && i + 1 < argc)
    {
      args.index_path = argv[++i];
    }
    else if (a == "--max_rows" && i + 1 < argc)
    {
      args.max_dataset_rows = std::stoi(argv[++i]);
    }
    else if (a == "--m" && i + 1 < argc)
    {
      args.M = std::stoi(argv[++i]);
    }
    else if (a == "--efc" && i + 1 < argc)
    {
      args.ef_construction = std::stoi(argv[++i]);
    }
    else
    {
      arg_error = true;
    }
  }
  if (argc <= 1 || arg_error)
  {
    std::cerr << "Usage: " << argv[0]
              << " --dataset <file> [--index_path <file>] [--m M] [--efc EF_CONSTRUCTION]\n"
              << "  dataset is a path to a dataset file in big-ann-benchmarks binary format\n"
              << "  index_path is the path of the index file to be created\n"
              << "  M and EF_CONSTRUCTION are hyperparameters for HNSW index build\n";
    std::exit(EXIT_FAILURE);
  }
  if (!has_dataset_path)
  {
    std::cerr << "Error: --dataset is required\n";
    std::exit(EXIT_FAILURE);
  }
  if (!std::filesystem::exists(args.dataset_path))
  {
    std::cerr << "Error: file not found: " << args.dataset_path << "\n";
    std::exit(EXIT_FAILURE);
  }
  return args;
}

std::string detect_dtype(const std::string &filename)
{
  if (filename.size() > 6 && filename.compare(filename.size() - 6, 6, "f16bin") == 0)
  {
    return "half";
  }
  else if (filename.size() > 9 && filename.compare(filename.size() - 9, 9, "fp16.fbin") == 0)
  {
    return "half";
  }
  else if (filename.size() > 4 && filename.compare(filename.size() - 4, 4, "fbin") == 0)
  {
    return "float";
  }
  else if (filename.size() > 5 && filename.compare(filename.size() - 5, 5, "u8bin") == 0)
  {
    return "uint8";
  }
  else if (filename.size() > 5 && filename.compare(filename.size() - 5, 5, "i8bin") == 0)
  {
    return "int8";
  }
  std::cerr << "Cannot determine data type from extension: " << filename << "\n";
  std::exit(EXIT_FAILURE);
}

template <typename T>
auto hnsw_build_example(raft::resources const &res, const app_args &args) -> int
{
  using namespace cuvs::neighbors;

  BinaryFile<T> dataset(args.dataset_path.c_str(), args.max_dataset_rows);

  hnsw::index_params params;
  params.M = args.M;
  params.ef_construction = args.ef_construction;

  auto start_time = std::chrono::high_resolution_clock::now();

  auto hnsw_index = hnsw::build(res, params, dataset.view());

  auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::high_resolution_clock::now() - start_time);
  double avg_time_seconds = duration.count() / 1000.0;
  std::cout << "HNSW index created in in " << avg_time_seconds << " seconds" << std::endl;

  cuvs::neighbors::hnsw::serialize(res, args.index_path, *hnsw_index);

  std::cout << "HNSW index file location: " << args.index_path << std::endl;

  return 0;
}

int main(int argc, char **argv)
{
  auto args = parse_args(argc, argv);

  raft::resources res;

  // Define a 2 GiB pool allocator for temporary arrays (used within cuvs algorithms). Only the internal
  // arrays use the pool, any other allocation uses the default RMM memory resource.
  // Manually configure pool to allocate up to its limit right away to avoid fragmentation.
  constexpr std::size_t kWorkspaceLimit = 2ull * 1024 * 1024 * 1024; // 2 GiB
  rmm::mr::pool_memory_resource pool_mr(
      rmm::mr::get_current_device_resource_ref(), kWorkspaceLimit, kWorkspaceLimit);
  raft::resource::set_workspace_resource(
      res, raft::mr::device_resource{std::move(pool_mr)}, kWorkspaceLimit);

  auto dtype = detect_dtype(args.dataset_path);
  int result = 0;
  if (dtype == "float")
  {
    result = hnsw_build_example<float>(res, args);
  }
  else if (dtype == "half")
  {
    result = hnsw_build_example<half>(res, args);
  }
  else if (dtype == "uint8")
  {
    result = hnsw_build_example<uint8_t>(res, args);
  }
  else if (dtype == "int8")
  {
    result = hnsw_build_example<int8_t>(res, args);
  }
  return result;
}
