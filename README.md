# CAGRA-HNSW tests
Download this repository
```
git clone --branch cagra_hnsw_cloudrun https://github.com/tfeher/cuvs_ace_test.git
```

## CAGRA index build

### Install cuvs
```
conda create -n cuvs_2608 -c rapidsai-nightly -c conda-forge cuvs=26.08 cmake=4.0
conda activate cuvs_2608
```
### Build example program

CUDA Toolkit is required for building the example

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
cuvs_ace_test/build/HNSW_EXAMPLE -o wiki_1M_cagra.bin wiki_all_1M/base.1M.fbin
```
expected output
```
Dataset shape: [4990000, 1536]
Building HNSW index (search graph)
[ 68030][06:30:07:962034][info  ] Considering CAGRA in memory build with IVF-PQ
[ 68030][06:30:07:975303][info  ] CAGRA in memory build, required host mem  4.4 GB, GPU mem  9.3 GB
[ 68030][06:30:07:975312][info  ] Available                       host mem 264.0 GB, GPU mem 23.7 GB
[ 68030][06:30:07:975315][info  ] We have sufficient memory to proceed with in memory build
[ 68030][06:30:23:612467][info  ] CAGRA graph build: reducing IVF-PQ search max_internal_batch_size from 131072 -> 52428 to fit the workspace
[ 68030][06:32:15:561414][info  ] hnsw::build - Converting CAGRA index to HNSW format
[ 68030][06:32:15:561783][info  ] hnsw::from_cagra - in-memory HNSW requires ~32.4 GB host mem, available 262.9 GB
[ 68030][06:32:16:872381][warning] Intermediate graph degree cannot be larger than number of rows in dataset, reducing it to 1
[ 68030][06:32:16:935662][warning] Intermediate graph degree cannot be larger than number of rows in dataset, reducing it to 1
[ 68030][06:32:16:956883][warning] Intermediate graph degree cannot be larger than number of rows in dataset, reducing it to 10
HNSW index file location: wiki_1M_cagra.bin
HNSW index created in in 153.874 seconds
```
