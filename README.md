# cuvs-bench HNSW benchmark
This repository demonstrate how to run cuvs-bench with custom settings for HNSW index building

### Download this repository
```
git clone --branch hnsw_cuvs_bench https://github.com/tfeher/cuvs_ace_test.git
```

## OpenAI-5M benchmarks

### Get dataset
TODO

### Run benchmark

Start the cuvs-bench container
```
docker run --user root  --gpus=all -it --rm -v $PWD:/workspace -w /workspace --entrypoint=/bin/bash rapidsai/cuvs-bench:26.06-cuda13-py3.12 
```

Inside the container, run the following command to start the benchmark

```
python -m cuvs_bench.run --dataset openai_5M --dataset-path='.' --dataset-configuration=datasets.yaml --configuration=hnswlib_m24.yaml -k 10 -bs 1000 --algorithms=hnswlib --groups=alloy --search-mode=latency
```


expected output
```
[Registry] Registered backend: cpp_gbench (CppGoogleBenchmarkBackend)
[Registry] Registered config loader: cpp_gbench (CppGBenchConfigLoader)
-- Using cuVS bench found in conda environment.
[I] [21:05:43.417048] Using the dataset file '././openai_5M/base.5M.fbin'
2026-07-06T21:05:43+00:00
Running /opt/conda/bin/ann/HNSWLIB_ANN_BENCH
Run on (32 X 3668.75 MHz CPU s)
CPU Caches:
  L1 Data 32 KiB (x16)
  L1 Instruction 32 KiB (x16)
  L2 Unified 512 KiB (x16)
  L3 Unified 32768 KiB (x4)
Load Average: 0.02, 0.12, 0.26
command_line: /opt/conda/bin/ann/HNSWLIB_ANN_BENCH --build --data_prefix=. --benchmark_out_format=json --benchmark_counters_tabular=true --benchmark_out=openai_5M/result/build/hnswlib,alloy.json.lock /tmp/openai_5M_build_x0nj9_26.json
dataset: openai_5M
dim: 1536
distance: euclidean
gpu_driver_version: 13.2
...
n_records: 5000000
***WARNING*** ASLR is enabled, the results may have unreproducible noise in them.
2026-07-06 21:05:57 building 0 / 151515
2026-07-06 21:08:17 building 10000 / 151515
2026-07-06 21:10:39 building 20000 / 151515
...

```


## WIKI-10M benchmarks

### Get the dataset
```
wget https://data.rapids.ai/raft/datasets/wiki_all_10M/wiki_all_10M.tar
mkdir wiki_all_10M
tar xf wiki_all_10M.tar -C wiki_all_10M
```
Reference [cuvs-bench doc](https://docs.rapids.ai/api/cuvs/stable/cuvs_bench/wiki_all_dataset/#m-and-10m-subsets)

### Run the benchmark

start the cuvs-bench container
```
docker run --user root  --gpus=all -it --rm -v $PWD:/workspace -w /workspace --entrypoint=/bin/bash rapidsai/cuvs-bench:26.06-cuda13-py3.12 
```

Inside the container, run the following command to start the benchmark

```
python -m cuvs_bench.run --dataset wiki_all_10M --dataset-path='.'  --configuration=hnswlib_m24.yaml -k 10 -bs 1000 --algorithms=hnswlib --groups=alloy --search-mode=latency
```

Expected output

```
[Registry] Registered backend: cpp_gbench (CppGoogleBenchmarkBackend)
[Registry] Registered config loader: cpp_gbench (CppGBenchConfigLoader)
-- Using cuVS bench found in conda environment.
[I] [21:35:42.930737] Using the dataset file '././wiki_all_10M/base.10M.fbin'
2026-07-06T21:35:42+00:00
Running /opt/conda/bin/ann/HNSWLIB_ANN_BENCH
Run on (32 X 3656.37 MHz CPU s)
CPU Caches:
  L1 Data 32 KiB (x16)
  L1 Instruction 32 KiB (x16)
  L2 Unified 512 KiB (x16)
  L3 Unified 32768 KiB (x4)
Load Average: 0.57, 1.73, 7.34
command_line: /opt/conda/bin/ann/HNSWLIB_ANN_BENCH --build --data_prefix=. --benchmark_out_format=json --benchmark_counters_tabular=true --benchmark_out=wiki_all_10M/result/build/hnswlib,alloy.json.lock /tmp/wiki_all_10M_build_stiutmjg.json
dataset: wiki_all_10M
dim: 768
distance: euclidean
...
n_records: 10000000
***WARNING*** ASLR is enabled, the results may have unreproducible noise in them.
2026-07-06 21:35:57 building 0 / 303030
...
```
