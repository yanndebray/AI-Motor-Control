function [completedata] = DataConcatenate(data1,data2)
% This function concatenates the data from zero to low-speed and low to
% high-speed.

% Copyright 2024 The MathWorks, Inc.


completedata = Simulink.SimulationOutput.empty(0);
data = {data1, data2};

count=1;
for ite =1:length(data)
    dataset =data{ite};
    [m,n] = size(dataset);

    for ite1 =1:m
        for ite2=1:n
            completedata(count) = dataset(ite1,ite2);
            count  = count+1;
        end
    end
end