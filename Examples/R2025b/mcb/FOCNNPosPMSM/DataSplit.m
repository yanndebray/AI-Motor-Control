function [traindata,testdata,validatedata] = DataSplit(data)
% This function splits data into training, validation, and testing data
% sets.

% Copyright 2024 The MathWorks, Inc.

% Split the data into train and testorvalidate
datapoints = round(length(data));
partitionset = cvpartition(datapoints,'HoldOut',0.3);
idxtrainset = training(partitionset)';
idxtestorvalidateset = test(partitionset)';
traindata = data(:,idxtrainset);
testorvalidatedata = data(:,idxtestorvalidateset);

% further split the testorvalidate data to test and validate

datapointstest = round(length(testorvalidatedata));
partitionsettest = cvpartition(datapointstest,'HoldOut',0.5);
idxvalidateset = training(partitionsettest)';
idxtestset = test(partitionsettest)';
testdata = testorvalidatedata(:,idxtestset);
validatedata = testorvalidatedata(:,idxvalidateset);

end