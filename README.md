# CAGRA-HNSW index building example

CAGRA-HNSW index building in memory constrained environment.

## Prerequsite
- CUDA driver compatible with CTK 12.9

## Prepare container
Using docker
```
git clone https://github.com/tfeher/cuvs_ace_test.git
cd cuvs_ace_test
docker build -t cuvs_ace_test-1 .
docker run  --gpus=all -it  --rm --shm-size=1GB -v $PWD:/workspace -w /workspace cuvs_ace_test-1
```

or alterantively using docker compose
```
git clone https://github.com/tfeher/cuvs_ace_test.git
cd cuvs_ace_test
docker compose up -d
```




This will download a rapids devcontainer, install the conda packages, compile the library and the example program that we want to run.

## OpenAI-5M test

### Get data
```
docker exec -it cuvs_ace_test-1 /bin/bash
bash /opt/download_openai_5M.sh
```


### Run test
```
/opt/cuvs/examples/cpp/build/CAGRA_HNSW_ACE_EXAMPLE 
```

Expected output
```
Dataset size 7680000000                                                                                                                                                                    
shape [5000000, 1536]                                                                                                                                                                      
Building CAGRA index (search graph)                                                                                                                                                        
[   987][17:03:44:800259][info  ] ACE: Starting partitioned CAGRA build with 10 partitions                                                                                                 
[   987][17:03:44:800365][info  ] ACE: Estimated host memory required: 13.07 GiB, available: 244.04 GiB                                                                                    
[   987][17:03:44:800392][info  ] ACE: Estimated GPU memory required: 1.19 GiB, available: 139.80 GiB                                                                                      
[   987][17:03:44:800514][info  ] ACE: Graph fits in host and GPU memory but disk mode is forced. Using disk-mode with temporary storage /tmp/ace_build                                    
[   987][17:03:45:019874][info  ] ACE: Processing chunk 0 / 5000000 (0.0%)                                                                                                                 
[   987][17:03:45:323370][info  ] ACE: Processing chunk 491520 / 5000000 (9.8%)                                                                                                            
[   987][17:03:45:607727][info  ] ACE: Processing chunk 983040 / 5000000 (19.7%)                                                                                                           
[   987][17:03:45:894420][info  ] ACE: Processing chunk 1474560 / 5000000 (29.5%)                                                                                                          
[   987][17:03:46:180298][info  ] ACE: Processing chunk 1966080 / 5000000 (39.3%)                                                                                                          
[   987][17:03:46:466134][info  ] ACE: Processing chunk 2457600 / 5000000 (49.2%)                                                                                                          
[   987][17:03:46:752979][info  ] ACE: Processing chunk 2949120 / 5000000 (59.0%)                                                                                                          
[   987][17:03:47:043912][info  ] ACE: Processing chunk 3440640 / 5000000 (68.8%)                                                                                                          
[   987][17:03:47:328686][info  ] ACE: Processing chunk 3932160 / 5000000 (78.6%)                                                                                                          
[   987][17:03:47:614200][info  ] ACE: Processing chunk 4423680 / 5000000 (88.5%)                                                                                                          
[   987][17:03:47:901182][info  ] ACE: Processing chunk 4915200 / 5000000 (98.3%)                                                                                                          
[   987][17:03:47:999509][info  ] ACE: Core vectors        - Total: 5000000, Avg: 500000.0, Min: 234223, Max: 713941                                                                       
[   987][17:03:47:999595][info  ] ACE: Augmented vectors   - Total: 5000000, Avg: 500000.0, Min: 233580, Max: 733970                                                                       
[   987][17:03:47:999635][info  ] ACE: Total per partition - Total: 10000000, Avg: 1000000.0, Min: 467803, Max: 1326815                                                                    
[   987][17:03:47:999675][info  ] ACE: Partition labeling completed in 3144 ms (min_partition_size: 50000)                                                                                 
[   987][17:03:48:056629][info  ] ACE: Vector list creation completed in 56 ms                                                                                                             
[   987][17:03:51:965865][info  ] ACE: Processed 500000/5000000 vectors (10.0%)                                                                                                            
[   987][17:03:55:763328][info  ] ACE: Processed 1000000/5000000 vectors (20.0%)                                                                                                           
[   987][17:03:59:467637][info  ] ACE: Processed 1500000/5000000 vectors (30.0%)                                                                                                           
[   987][17:04:03:161961][info  ] ACE: Processed 2000000/5000000 vectors (40.0%)                                                                                                           
[   987][17:04:06:844260][info  ] ACE: Processed 2500000/5000000 vectors (50.0%)                                                                                                           
[   987][17:04:10:928653][info  ] ACE: Processed 3000000/5000000 vectors (60.0%)                                                                                                           
[   987][17:04:14:658431][info  ] ACE: Processed 3500000/5000000 vectors (70.0%)                                                                                                           
[   987][17:04:18:718287][info  ] ACE: Processed 4000000/5000000 vectors (80.0%)                                                                                                           
[   987][17:04:22:784533][info  ] ACE: Processed 4500000/5000000 vectors (90.0%)                                                                                                           
[   987][17:04:26:824042][info  ] ACE: Processed 5000000/5000000 vectors (100.0%)                                                                                                          
[   987][17:04:27:061334][info  ] ACE: Dataset (28.61 GiB reordered, 28.61 GiB augmented, 0.02 GiB mapping) reordering completed in 39004 ms (1502.7 MiB/s)                                
[   987][17:04:38:310658][info  ] ACE: Partition    0 (  537360 +   536389) completed in  11149 ms: read   1769 ms ( 3556.5 MiB/s), optimize   9206 ms, adjust     85 ms, write     88 ms (35779.5 MiB/s)
[   987][17:04:52:394130][info  ] ACE: Partition    1 (  512285 +   733970) completed in  13557 ms: read   2350 ms ( 3107.4 MiB/s), optimize  11044 ms, adjust     79 ms, write     83 ms (36164.7 MiB/s)
[   987][17:05:04:495305][info  ] ACE: Partition    2 (  520795 +   529167) completed in  11543 ms: read   1750 ms ( 3515.5 MiB/s), optimize   9619 ms, adjust     82 ms, write     92 ms (33168.8 MiB/s)
[   987][17:05:17:083724][info  ] ACE: Partition    3 (  594027 +   473553) completed in  12112 ms: read   1931 ms ( 3239.4 MiB/s), optimize   9985 ms, adjust     97 ms, write     98 ms (35516.6 MiB/s)
[   987][17:05:17:083724][info  ] ACE: Partition    3 (  594027 +   473553) completed in  12112 ms: read   1931 ms ( 3239.4 MiB/s), optimize   9985 ms, adjust     97 ms, write     98 ms (35516.6 MiB/s)
[   987][17:05:23:422649][info  ] ACE: Partition    4 (  234223 +   233580) completed in   5857 ms: read    794 ms ( 3452.2 MiB/s), optimize   4979 ms, adjust     41 ms, write     42 ms (32676.2 MiB/s)
[   987][17:05:38:280751][info  ] ACE: Partition    5 (  713941 +   519874) completed in  14618 ms: read   2297 ms ( 3147.3 MiB/s), optimize  12093 ms, adjust    111 ms, write    116 ms (36062.5 MiB/s)
[   987][17:05:54:337842][info  ] ACE: Partition    6 (  643808 +   683007) completed in  15503 ms: read   2215 ms ( 3509.8 MiB/s), optimize  13076 ms, adjust    105 ms, write    105 ms (35926.8 MiB/s)
[   987][17:06:07:601370][info  ] ACE: Partition    7 (  527177 +   492853) completed in  12671 ms: read   1700 ms ( 3515.7 MiB/s), optimize  10797 ms, adjust     83 ms, write     89 ms (34707.1 MiB/s)
[   987][17:06:16:606131][info  ] ACE: Partition    8 (  327714 +   295611) completed in   8541 ms: read   1089 ms ( 3353.8 MiB/s), optimize   7342 ms, adjust     51 ms, write     58 ms (33106.9 MiB/s)
[   987][17:06:28:817268][info  ] ACE: Partition    9 (  388670 +   501996) completed in  11904 ms: read   1634 ms ( 3193.8 MiB/s), optimize  10143 ms, adjust     58 ms, write     68 ms (33490.6 MiB/s)
[   987][17:06:29:237669][info  ] ACE: All partition processing completed in 122076 ms (10 partitions)
[   987][17:06:29:237751][info  ] ACE: Removed augmented dataset file to save disk space
[   987][17:06:29:237832][info  ] ACE: Set disk storage at /tmp/ace_build (dataset shape [5000000, 1536], graph shape [5000000, 64])
[   987][17:06:29:237837][info  ] ACE: Final index creation completed in 0 ms
[   987][17:06:29:237841][info  ] ACE: Partitioned CAGRA build completed in 164437 ms total
Converting CAGRA index to HNSW
[   987][17:06:34:343502][info  ] Saving CAGRA index to hnswlib format, size 5000000, dim 1536, graph_degree 64
[   987][17:06:34:385159][info  ] Writing base level
[   987][17:06:36:898301][info  ] # Writing rows       500001 /      5000000 (10.00 %), 1.19 GiB/sec, ETA 0:22.6, written 2.99 GiB
[   987][17:06:39:382916][info  ] # Writing rows      1000001 /      5000000 (20.00 %), 1.19 GiB/sec, ETA 0:20.0, written 5.97 GiB
[   987][17:06:41:834775][info  ] # Writing rows      1500001 /      5000000 (30.00 %), 1.20 GiB/sec, ETA 0:17.4, written 8.96 GiB
[   987][17:06:44:282702][info  ] # Writing rows      2000001 /      5000000 (40.00 %), 1.21 GiB/sec, ETA 0:14.8, written 11.94 GiB
[   987][17:06:46:749624][info  ] # Writing rows      2500001 /      5000000 (50.00 %), 1.21 GiB/sec, ETA 0:12.4, written 14.93 GiB
[   987][17:06:49:220378][info  ] # Writing rows      3000001 /      5000000 (60.00 %), 1.21 GiB/sec, ETA 0:9.9, written 17.91 GiB
[   987][17:06:51:817093][info  ] # Writing rows      3500001 /      5000000 (70.00 %), 1.20 GiB/sec, ETA 0:7.5, written 20.90 GiB
[   987][17:06:54:295273][info  ] # Writing rows      4000001 /      5000000 (80.00 %), 1.20 GiB/sec, ETA 0:5.0, written 23.89 GiB
[   987][17:06:56:912700][info  ] # Writing rows      4500001 /      5000000 (90.00 %), 1.19 GiB/sec, ETA 0:2.5, written 26.87 GiB
[   987][17:06:59:711414][info  ] HNSW serialization from disk complete in 25367 ms
[   987][17:06:59:722594][info  ] HNSW index written to disk at: /tmp/ace_build/hnsw_index.bin
HNSW index file location: /tmp/ace_build/hnsw_index.bin
```

## BIGANN-1B Test

### Build container
```
git clone ssh://git@gitlab-master.nvidia.com:12051/tfeher/cuvs_ace_test.git
cd cuvs_ace_test
docker build -t cuvs_ace_test-1 .
```
### Get data

```
wget https://dl.fbaipublicfiles.com/billion-scale-ann-benchmarks/bigann/base.1B.u8bin
```

### Run test

```
docker run  --gpus=all -it  --rm --shm-size=1GB -v $PWD:/workspace -w /workspace cuvs_ace_test-1

# in the container
/opt/cuvs/examples/cpp/build/CAGRA_HNSW_ACE_BIGANN
```