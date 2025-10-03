function [net,testdatamse] = CreateNetwork(traindatain,traindataout,testdatain,...
                                 testdataout,validatedatain,validatedataout)

% trains a network using dlnetwork

% Copyright 2024 The MathWorks, Inc.

rng('default')

layers = [
    featureInputLayer(6)
    fullyConnectedLayer(4)
    tanhLayer
    fullyConnectedLayer(2,'Name','output')
    ];

% Run this to visualise the dlnetwork
% analyzeNetwork(layers)

%dlnetwork object creation
net = dlnetwork(layers);
net = dlupdate(@double, net);

% training options

options = trainingOptions("adam", ...
    MaxEpochs=50, ...
    MiniBatchSize=1024, ...
    InitialLearnRate=0.01,...
    Shuffle="every-epoch", ...
    ValidationData= {validatedatain,validatedataout}, ...
    Verbose=1, ...
    OutputNetwork="best-validation", ...
    Plots="training-progress", ...
    VerboseFrequency = 100, ...
    ValidationFrequency = 100, ...
    LearnRateSchedule="piecewise",...
    LearnRateDropPeriod=25, ...
    LearnRateDropFactor=0.1);

net = trainnet(traindatain,traindataout,net,"mean-squared-error",options);

%testing the network

testdatamse = testnet(net, testdatain, testdataout,"mse");



end