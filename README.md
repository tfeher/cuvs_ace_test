# CAGRA-HNSW tests

git clone --branch cagra_hnsw https://github.com/tfeher/cuvs_ace_test.git

## Get datasets
### Wiki 1M
```
wget https://data.rapids.ai/raft/datasets/wiki_all_1M/wiki_all_1M.tar
mkdir wiki_all_1M
tar xf wiki_all_1M.tar -C wiki_all_1M
```

### Wiki 10M
```
wget https://data.rapids.ai/raft/datasets/wiki_all_10M/wiki_all_10M.tar
mkdir wiki_all_10M
tar xf wiki_all_10M.tar -C wiki_all_10M
```
### OpenAI 5M

## HNSW build and search
```
git clone --branch v0.8.0 --single-branch https://github.com/nmslib/hnswlib.git
g++ -std=c++11 -O3 -Ihnswlib -o example_mt_search cuvs_ace_test/src/example_mt_search.cpp -lpthread
```

## CAGRA index build

### Install cuvs
```
mamba create -n cuvs_2512 -c rapidsai -c conda-forge cuvs=25.12 cmake=3.30.4
mamba activate cuvs_test
```
### Build example program
```
cd cuvs_ace_test/
mkdir build
cd build
cmake .. -DCMAKE_CUDA_ARCHITECTURES="89"
make
```

```
./cuvs_ace_test/build/HNSW_OPENAI_EXAMPLE -o wiki_1M_cagra.bin wiki_all_1M/base.1M.fbin
```


