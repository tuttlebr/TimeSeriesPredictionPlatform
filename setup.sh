#!/bin/bash

as_sudo(){
    cmd="sudo bash -c '$@'"
    eval $cmd
}

as_user(){
    cmd="bash -c '$@'"
    eval $cmd
}

# Update submodules
if command -v git &> /dev/null ; then
    echo "INFO: Updating Git submodule..."
    as_user git submodule update --init
else
    echo "ERROR: Unable to update Git submodules, 'git' command not found"
fi

# Source TSPP
echo "INFO: Copying Temporal Fusion Transformer model..."
as_sudo cp -r \
    submodules/DeepLearningExamples/PyTorch/Forecasting/TFT \
    submodules/DeepLearningExamples/Tools/PyTorch/TimeSeriesPredictionPlatform/models/tft_pyt

# Build Docker Images
if command -v docker-compose &> /dev/null ; then
    as_user docker-compose build
else
    echo "ERROR: Unable to build Docker images, 'docker-compose' command not found"
fi