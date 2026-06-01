FROM "nvcr.io/nvidia/cuda:13.1.2-devel-ubuntu24.04"
ENV TERM=linux \
    DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "--login", "-c"]
# Where Mambaforge will be installed
ENV CONDA_DIR=/opt/conda
ENV PATH=${CONDA_DIR}/bin:${PATH}

# Install dependencies and Mambaforge
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    wget bzip2 ca-certificates git && \
    rm -rf /var/lib/apt/lists/* && \
    \
    # Download latest Mambaforge 
    wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" -O /tmp/mambaforge.sh && \
    bash /tmp/mambaforge.sh -b -p ${CONDA_DIR} && \
    rm /tmp/mambaforge.sh && \
    \
    # Clean up conda caches to keep image small
    ${CONDA_DIR}/bin/conda clean --all --yes

RUN mamba create -n cuvs_2606 -c rapidsai-nightly -c conda-forge cuvs=26.06 cmake=3.30.4

RUN cd /opt && git clone --branch cagra_hnsw_cloudrun https://github.com/tfeher/cuvs_ace_test.git && \
    mkdir cuvs_ace_test/build && cd cuvs_ace_test/build && \
    cmake .. -DCMAKE_CUDA_ARCHITECTURES="89" && \
    make -j

ENTRYPOINT ["/bin/bash"]