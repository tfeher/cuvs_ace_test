# CAGRA-HNSW tests

This repository demonstrates how to build a CAGRA-HNSW index using a dataset file as input. The dataset file is assumed to be in big-ann-benchmarks.com [binary format](https://big-ann-benchmarks.com/neurips21.html#bench-datasets:~:text=All%20datasets%20are,are%20listed%20below.)

The dataset can be larger than host or GPU memory, the file is memory mapped and processed in chunks that fits the available memory.

The hnsw index is saved in [hnswlib](https://github.com/nmslib/hnswlib) binary format, and [can be loaded and searched with HNSW](https://github.com/nmslib/hnswlib/blob/d9b3608c83d83b46c96e25088cb1d729b29dcfe9/examples/cpp/example_search.cpp#L45).

## CAGRA index build

### Download this repository
```
git clone --branch cagra_hnsw_cloudrun https://github.com/tfeher/cuvs_ace_test.git
```

### Install cuvs

It is assumed that CUDA Toolkit is already installed.

```
conda create -n cuvs_2608 -c rapidsai-nightly -c conda-forge cuvs=26.08 cmake=4.0
conda activate cuvs_2608
```
### Build example program

```
mkdir cuvs_ace_test/build
cd cuvs_ace_test/build
cmake .. -DCMAKE_CUDA_ARCHITECTURES="89"
make
```

### Wiki 1M
Get dataset
```
wget https://data.rapids.ai/raft/datasets/wiki_all_1M/wiki_all_1M.tar
mkdir wiki_all_1M
tar xf wiki_all_1M.tar -C wiki_all_1M
```
Build with cuVS
```
cuvs_hnsw_test/build/HNSW_EXAMPLE --index_path wiki_hnsw_index.bin --dataset wiki_all_1M/base.1M.fbin
```
expected output
```
HNSW_EXAMPLE --index_path wiki_hnsw_index.bin --dataset wiki_all_1M/base.1M.fbin 
[ 79005][08:13:58:707605][info  ] Considering CAGRA in memory build with IVF-PQ
[ 79005][08:13:58:708249][info  ] CAGRA in memory build, required host mem  2.1 GB, GPU mem  5.5 GB
[ 79005][08:13:58:708258][info  ] Available                       host mem 264.1 GB, GPU mem 23.7 GB
[ 79005][08:13:58:708262][info  ] We have sufficient memory to proceed with in memory build
[ 79005][08:14:00:628487][info  ] CAGRA graph build: reducing IVF-PQ search max_internal_batch_size from 131072 -> 78643 to fit the workspace
[ 79005][08:14:10:569913][info  ] hnsw::build - Converting CAGRA index to HNSW format
[ 79005][08:14:10:570222][info  ] hnsw::from_cagra - in-memory HNSW requires ~ 3.4 GB host mem, available 263.4 GB
HNSW index created in in 12.753 seconds
HNSW index file location: wiki_hnsw_index.bin

```
