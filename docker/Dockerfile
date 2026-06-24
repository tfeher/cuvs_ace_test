#FROM "nvcr.io/nvidia/cuda:13.3.0-devel-ubuntu24.04"
FROM "nvcr.io/nvidia/cuda:12.9.2-devel-ubuntu24.04" AS build
ENV TERM=linux \
    DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "--login", "-c"]
# Where Mambaforge will be installed
ENV CONDA_DIR=/opt/conda
ENV PATH=${CONDA_DIR}/bin:${PATH}

# Install dependencies and Mambaforge
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    wget bzip2 ca-certificates git build-essential && \
    rm -rf /var/lib/apt/lists/* && \
    \
    # Download latest Mambaforge 
    wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" -O /tmp/mambaforge.sh && \
    bash /tmp/mambaforge.sh -b -p ${CONDA_DIR} && \
    rm /tmp/mambaforge.sh && \
    ${CONDA_DIR}/bin/conda clean --all --yes && \ 
    ${CONDA_DIR}/bin/conda init bash

RUN mamba create -n cuvs_2608 -c rapidsai-nightly -c conda-forge cuvs=26.08 cmake=4.0 \
    'cuda-version>=12.2,<=12.9'

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

# Decrease image size from 18 GB to 7 GB.

# RUN mkdir /opt/runtime_libs && \
#     cp /opt/conda/envs/cuvs_2608/lib/libcuvs.so \
#     /opt/conda/envs/cuvs_2608/lib/libstdc++.so.6 \
#     /opt/conda/envs/cuvs_2608/lib/librmm.so \
#     /opt/conda/envs/cuvs_2608/lib/librapids_logger.so \
#     /opt/conda/envs/cuvs_2608/lib/libgcc_s.so.1 \
#     /usr/lib/x86_64-linux-gnu/libc.so.6 \
#     /lib64/ld-linux-x86-64.so.2 \
#     /opt/conda/envs/cuvs_2608/lib/libcublas.so.12 \
#     /opt/conda/envs/cuvs_2608/lib/libcusolver.so.11 \
#     /opt/conda/envs/cuvs_2608/lib/libcusparse.so.12 \
#     /opt/conda/envs/cuvs_2608/lib/libcurand.so.10 \
#     /opt/conda/envs/cuvs_2608/lib/libnccl.so.2 \
#     /opt/conda/envs/cuvs_2608/lib/libnvJitLink.so.12 \
#     /opt/conda/envs/cuvs_2608/lib/libnvrtc.so.12 \
#     /usr/lib/x86_64-linux-gnu/libdl.so.2 \
#     /usr/lib/x86_64-linux-gnu/librt.so.1 \
#     /opt/conda/envs/cuvs_2608/lib/libcublasLt.so.12 \
#     /opt/conda/envs/cuvs_2608/lib/libgomp.so.1 \
#     /usr/lib/x86_64-linux-gnu/libpthread.so.0 \
#     /usr/lib/x86_64-linux-gnu/libm.so.6 \
#     /opt/runtime_libs/

# FROM "nvcr.io/nvidia/cuda:12.9.2-runtime-ubuntu24.04"
# WORKDIR /app

# COPY --from=build /opt/cuvs_ace_test /opt/
# COPY --from=build /opt/runtime_libs/ /usr/local/lib/

# ENV LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}

CMD ["/bin/bash"]