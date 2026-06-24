FROM "nvcr.io/nvidia/cuda:13.3.0-devel-ubuntu24.04" AS build
# FROM "nvcr.io/nvidia/cuda:12.9.2-devel-ubuntu24.04" AS build
ENV TERM=linux \
    DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "--login", "-c"]
ENV CONDA_DIR=/opt/conda
ENV PATH=${CONDA_DIR}/bin:${PATH}

# Install dependencies and Mambaforge
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    wget bzip2 ca-certificates git build-essential && \
    rm -rf /var/lib/apt/lists/* && \
    \
    wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" -O /tmp/mambaforge.sh && \
    bash /tmp/mambaforge.sh -b -p ${CONDA_DIR} && \
    rm /tmp/mambaforge.sh && \
    ${CONDA_DIR}/bin/conda clean --all --yes && \ 
    ${CONDA_DIR}/bin/conda init bash

RUN mamba create -n cuvs_2608 -c rapidsai-nightly -c conda-forge cuvs=26.08 cmake=4.0 \
    'cuda-version=13.3'

RUN echo 'if [ -f "${CONDA_DIR}/etc/profile.d/conda.sh" ]; then' >> /root/.bashrc && \
    echo '    . "${CONDA_DIR}/etc/profile.d/conda.sh"' >> /root/.bashrc && \
    echo '    conda activate cuvs_2608' >> /root/.bashrc && \
    echo 'fi' >> /root/.bashrc

RUN /bin/bash -lc "source ${CONDA_DIR}/etc/profile.d/conda.sh && \
    conda activate cuvs_2608 && \
    cd /opt && \
    git clone --branch cagra_hnsw_cloudrun https://github.com/tfeher/cuvs_ace_test.git && \
    mkdir cuvs_ace_test/build && cd cuvs_ace_test/build && \
    cmake .. -DCMAKE_CUDA_ARCHITECTURES='89;100' && \ 
    make -j"

CMD ["/bin/bash"]