# CAGRA-HNSW tests
Download this repository
```
git clone --branch cagra_hnsw_cloudrun https://github.com/tfeher/cuvs_ace_test.git
```

## CAGRA index build

### Install cuvs
```
conda create -n cuvs_2606 -c rapidsai-nightly -c conda-forge cuvs=26.06 cmake=3.30.4
conda activate cuvs_2606
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
cuvs_ace_test/build/HNSW_EXAMPLE -o wiki_1M_cagra.bin wiki_all_1M/base.1M.fbin
```
expected output
```
Dataset shape: [1000000, 768]
Building CAGRA index (search graph)
[1414576][17:24:53:915357][info  ] CAGRA graph build: reducing IVF-PQ search max_internal_batch_size from 131072 -> 78643 to fit the workspace
Converting CAGRA index to HNSW
[1414576][17:25:06:727888][warning] Intermediate graph degree cannot be larger than number of rows in dataset, reducing it to 1
HNSW index file location: wiki_1M_cagra.bin
HNSW index created in in 23.797 seconds
```
