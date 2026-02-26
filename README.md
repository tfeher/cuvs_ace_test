# CAGRA-HNSW tests
Download this repository
```
git clone --branch cagra_hnsw https://github.com/tfeher/cuvs_ace_test.git
```

## CAGRA index build

### Install cuvs
```
conda create -n cuvs_2602 -c rapidsai -c conda-forge cuvs=26.02 cmake=3.30.4
conda activate cuvs_2602
```
### Build example program
```
mkdir cuvs_ace_test/build
cd cuvs_ace_test/build
cmake .. -DCMAKE_CUDA_ARCHITECTURES="89"
make
```




## Create index for openai1m.dat
Run the executable `CAGRA_HNSW_2` from the same folder where the datafile `openai1m.dat` is located
```
build/CAGRA_HNSW_2

```

## Additional test using HNSW search examples

## HNSW build and search
```
git clone --branch v0.8.0 --single-branch https://github.com/nmslib/hnswlib.git
g++ -std=c++11 -O3 -Ihnswlib -o example_mt_search cuvs_ace_test/src/example_mt_search.cpp -lpthread
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
cuvs_ace_test/build/HNSW_OPENAI_EXAMPLE -o wiki_1M_cagra.bin wiki_all_1M/base.1M.fbin
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
Search CAGRA-HNSW index with HNSW
```
$ ./example_mt_search wiki_all_1M/base.1M.fbin wiki_all_1M/queries.fbin wiki_all_1M/groundtruth.1M.neighbors.ibin -i wiki_1M_cagra.bin 
Dataset shape: [1000000, 768]
Queries shape: [10000, 768]
Groundtruth shape: [10000, 100]
Using 48 threads (based on CPU affinity)
Loading index from wiki_1M_cagra.bin...
Index loaded with 1000000 elements

ef,recall,qps
10,0.78976,44608
20,0.89212,29725.6
40,0.95267,18326.4
80,0.98049,11016
120,0.98871,8040.62
200,0.99364,5394.42
400,0.99711,3113.47
800,0.99863,1779.03
```

Build and search with HNSW
```
$ ./example_mt_search wiki_all_1M/base.1M.fbin wiki_all_1M/queries.fbin wiki_all_1M/groundtruth.1M.neighbors.ibin -o wiki_1M_hnsw.bin 
Dataset shape: [1000000, 768]   
Queries shape: [10000, 768]     
Groundtruth shape: [10000, 100] 
Using 48 threads (based on CPU affinity)
Building index with 1000000 points...
  Progress: 10000/1000000 (1%)  
  Progress: 20000/1000000 (2%)  
...
  Progress: 1000000/1000000 (100%)
Index built successfully in 81.023 seconds
Saving index to wiki_1M_hnsw.bin...
Index saved successfully

ef,recall,qps
10,0.6561,70726.9
20,0.78416,46002.4
40,0.87838,28221.1
80,0.93467,16425.6
120,0.95668,11845.6
200,0.97242,7723.48
400,0.98563,4365.25
800,0.99272,2476.24
```
### Wiki 10M
Get dataset
```
wget https://data.rapids.ai/raft/datasets/wiki_all_10M/wiki_all_10M.tar
mkdir wiki_all_10M
tar xf wiki_all_10M.tar -C wiki_all_10M
```
Run CUVS-HNSW
```
./cuvs_ace_test/build/HNSW_OPENAI_EXAMPLE -o wiki_10M_cagra.bin wiki_all_10M/base.10M.fbin
Dataset shape: [10000000, 768]
Building CAGRA index (search graph)
[1420446][17:34:20:566616][info  ] CAGRA graph build: reducing IVF-PQ search max_internal_batch_size from 131072 -> 78643 to fit the workspace
Converting CAGRA index to HNSW
[1420446][17:37:02:892931][warning] Intermediate graph degree cannot be larger than number of rows in dataset, reducing it to 3
[1420446][17:37:02:961251][warning] Intermediate graph degree cannot be larger than number of rows in dataset, reducing it to 3
[1420446][17:37:02:993936][warning] Intermediate graph degree cannot be larger than number of rows in dataset, reducing it to 29
[1420446][17:37:05:674396][info  ] CAGRA graph build: reducing IVF-PQ search max_internal_batch_size from 131072 -> 104857 to fit the workspace
HNSW index file location: wiki_10M_cagra.bin
HNSW index created in in 215.733 seconds
```
Search using HNSW
```
./example_mt_search wiki_all_10M/base.10M.fbin wiki_all_10M/queries.fbin wiki_all_10M/groundtruth.10M.neighbors.ibin -i wiki_10M_cagra.bin 
Dataset shape: [10000000, 768]
Queries shape: [10000, 768]
Groundtruth shape: [10000, 100]
Using 48 threads (based on CPU affinity)
Loading index from wiki_10M_cagra.bin...
Index loaded with 10000000 elements

ef,recall,qps
10,0.67068,33388.2
20,0.80138,24122.3
40,0.891,14783.8
80,0.94672,8548.25
120,0.96651,6170.08
200,0.98242,4027.13
400,0.99307,2239.85
800,0.99726,1250.66
```
Build and search using HNSW
```
./example_mt_search wiki_all_10M/base.10M.fbin wiki_all_10M/queries.fbin wiki_all_10M/groundtruth.10M.neighbors.ibin -o wiki_10M_hnsw.bin 
Dataset shape: [10000000, 768]
Queries shape: [10000, 768]
Groundtruth shape: [10000, 100]
Using 48 threads (based on CPU affinity)
Building index with 10000000 points...
  Progress: 100000/10000000 (1%)
  Progress: 200000/10000000 (2%)
...
  Progress: 9900000/10000000 (99%)
  Progress: 10000000/10000000 (100%)
Index built successfully in 1507.77 seconds
Saving index to wiki_10M_hnsw.bin...
Index saved successfully

ef,recall,qps
10,0.61477,38199.4
20,0.74397,30936.1
40,0.84443,19181.1
80,0.91188,11249.4
120,0.93582,8076.64
200,0.95649,5259.41
400,0.97427,2909.04
800,0.98403,1623.46
```
### OpenAI 5M

Build with CAGRA-HNSW
```
$ ./cuvs_ace_test/build/HNSW_OPENAI_EXAMPLE /ssd/openai_5M/base.5M.fbin  -o openai_5M_cagra.bin 
Dataset shape: [5000000, 1536]
Building CAGRA index (search graph)
[1427392][18:49:38:746130][info  ] CAGRA graph build: reducing IVF-PQ search max_internal_batch_size from 131072 -> 52428 to fit the workspace
Converting CAGRA index to HNSW
[1427392][18:52:00:039392][warning] Intermediate graph degree cannot be larger than number of rows in dataset, reducing it to 1
[1427392][18:52:00:121247][warning] Intermediate graph degree cannot be larger than number of rows in dataset, reducing it to 1
[1427392][18:52:00:152596][warning] Intermediate graph degree cannot be larger than number of rows in dataset, reducing it to 16
HNSW index file location: openai_5M_cagra.bin
HNSW index created in in 191.442 seconds
```
Build CAGRA-HNSW on 4 CPU and limited host mem
```
$ numactl -C 0-3 ./cuvs_ace_test/build/HNSW_OPENAI_EXAMPLE /ssd/openai_5M/base.5M.fbin  -o openai_5M_cagra.bin 
Dataset shape: [5000000, 1536]
Building CAGRA index (search graph)
[1434316][19:31:58:192723][info  ] CAGRA graph build: reducing IVF-PQ search max_internal_batch_size from 131072 -> 52428 to fit the workspace
Converting CAGRA index to HNSW
[1434316][19:35:57:343508][warning] Intermediate graph degree cannot be larger than number of rows in dataset, reducing it to 12
HNSW index file location: openai_5M_cagra.bin
HNSW index created in in 410.487 seconds
```

Search with HNSW
```
$ ./example_mt_search /ssd/openai_5M/base.5M.fbin /ssd/openai_5M/gt_old/queries.fbin /ssd/openai_5M/groundtruth.5M.neighbors.ibin -i openai_5M_cagra.bin 
Dataset shape: [5000000, 1536]
Queries shape: [1000, 1536]
Groundtruth shape: [1000, 1000]
Using 48 threads (based on CPU affinity)
Loading index from openai_5M_cagra.bin...
Index loaded with 5000000 elements
ef,recall,qps
10,0.8277,11469.2
20,0.9015,15400
40,0.9499,9726.02
80,0.9775,5791.86
120,0.9841,4195.14
200,0.9909,2773.12
400,0.9957,1555.26
800,0.9975,866.659
```

Build and Search with HNSW
```
$ ./example_mt_search /ssd/openai_5M/base.5M.fbin /ssd/openai_5M/gt_old/queries.fbin /ssd/openai_5M/groundtruth.5M.neighbors.ibin -o o
penai_5M_hnsw.bin                                                                                   
Dataset shape: [5000000, 1536]   
Queries shape: [1000, 1536]      
Groundtruth shape: [1000, 1000]                                                                    
Using 48 threads (based on CPU affinity)
Building index with 5000000 points...
  Progress: 50000/5000000 (1%) 
  ...
  Progress: 4950000/5000000 (99%)
  Progress: 5000000/5000000 (100%)
Index built successfully in 1612.16 seconds
Saving index to openai_5M_hnsw.bin...
Index saved successfully

ef,recall,qps
10,0.7828,23815.8
20,0.8763,17903.5
40,0.9363,11383.7
80,0.9664,6757.94
120,0.9789,4848.27
200,0.9886,3184.93
400,0.9954,1751
800,0.9975,969.071
```


