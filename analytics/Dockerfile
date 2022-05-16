#SPDX-License-Identifier: Apache-2.0
ARG FROM_IMAGE_NAME=nvcr.io/nvidia/rapidsai/rapidsai:22.04-cuda11.5-base-ubuntu20.04
FROM ${FROM_IMAGE_NAME}

# Set workdir and paths
WORKDIR /workspace
ENV PYTHONPATH /workspace

RUN \
    DISTRO_ID=$(grep '^ID=' /etc/os-release | sed 's/^.*=//') \
    && DISTRO_RELEASE=$(grep '^VERSION_ID=' /etc/os-release | sed 's/^.*=//' | sed 's/[^0-9]*//g') \
    && ARCH=$(uname -p) \
    && DISTRO="$DISTRO_ID$DISTRO_RELEASE"

# NVIDIA Signing Key Update, if needed
# RUN apt-key del 7fa2af80 \
#     && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/$DISTRO/$ARCH/3bf863cc.pub

ADD analytics/code-server.sh .
RUN ./code-server.sh \
    && code-server --install-extension=ms-toolsai.jupyter --install-extension=ms-python.python

EXPOSE 8080

ADD submodules/DeepLearningExamples/Tools/PyTorch/TimeSeriesPredictionPlatform/ /workspace/TimeSeriesPredictionPlatform

RUN pip install -r TimeSeriesPredictionPlatform/requirements.txt
RUN pip install -r TimeSeriesPredictionPlatform/triton/requirements.txt
RUN pip install nvidia-pyindex
RUN pip install git+https://github.com/NVIDIA/dllogger#egg=dllogger
RUN pip install --no-cache-dir -r TimeSeriesPredictionPlatform/requirements.txt -f https://data.dgl.ai/wheels/repo.html
# Install JupyterLab NVDashboard
RUN pip3 install jupyterlab_nvdashboard
RUN rm -rf /workspace/examples
RUN rm -rf /workspace/docker-examples
RUN rm -rf /workspace/tutorial

RUN mkdir -p /certs
ADD analytics/certificates /certs