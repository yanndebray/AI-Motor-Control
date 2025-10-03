function [traindatain,traindataout,testdatain,testdataout,validatedatain,validatedataout]...
         = DataPreparation(data,highspeedidx,lowspeedidx)
% This function splits data into training, validation, and testing data
% sets and prepares the data for training.

% Copyright 2024 The MathWorks, Inc.

datahighspeed = data(1,1:highspeedidx);
datalowspeed  = data(1,highspeedidx+1:lowspeedidx);

[traindatahighspeed,testdatahighspeed,validatedatahighspeed] = DataSplit(datahighspeed);
[traindatalowspeed,testdatalowspeed,validatedatalowspeed] = DataSplit(datalowspeed);


traindata = [traindatahighspeed traindatalowspeed];
testdata = [testdatahighspeed  testdatalowspeed];
validatedata = [validatedatahighspeed validatedatalowspeed];

[traindatain, traindataout] = DataPreparationIO(traindata);
[testdatain, testdataout] = DataPreparationIO(testdata);
[validatedatain, validatedataout] = DataPreparationIO(validatedata);

end

function[indata, outdata] = DataPreparationIO(data)

datalenght = length(data);
indata =[];
outdata =[];

for ite = 1:datalenght
    datatoprocess = data(ite);
    sintheta = sin(2*pi*datatoprocess.theta);
    costheta = cos(2*pi*datatoprocess.theta);
    sinthetadelayed =  [sintheta(end,1) sintheta(1:end-1,1)']'; % Delayed by a sample
    costhetadelayed =  [costheta(end,1) costheta(1:end-1,1)']'; % Delayed by a sample

    indata = [indata; datatoprocess.Valpha datatoprocess.Vbeta...
              datatoprocess.Ialpha datatoprocess.Ibeta sinthetadelayed...
              costhetadelayed];
    outdata = [outdata; sintheta costheta];
end

 indata = dlarray(indata',"CB");
 outdata = dlarray(outdata',"CB");
end


