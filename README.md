# CAGRA-HNSW tests

## Get datasets
### Wiki 1M
```
wget https://data.rapids.ai/raft/datasets/wiki_all_1M/wiki_all_1M.tar
mkdir wiki_all_1M
tar xf wiki_all_1M.tar -C wiki_all_1M
```

```
wget https://data.rapids.ai/raft/datasets/wiki_all_10M/wiki_all_10M.tar
mkdir wiki_all_10M
tar xf wiki_all_10M.tar -C wiki_all_10M
```

## HNSW build and search
```

```
## CAGRA index build

### Install cuvs
```
mamba create -n cuvs_test -c rapidsai -c conda-forge cuvs
mamba activate cuvs_test
```
### Build example program


