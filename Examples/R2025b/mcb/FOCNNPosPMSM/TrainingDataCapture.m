function [lowtohighspeeddata,zerotolowspeeddata] = TrainingDataCapture(model,datatimel2h,datatimz2l,DataPoints)

%% This function collects Valpha, Vbeta, Ibeta, Ibeta and thetae from model
% operating points are considered with speed and torque sweep 
% data capture time window for the model is adjusted based on the speed
% zone

% Copyright 2024 The MathWorks, Inc.

%% Data points for speed and torque sweep

speeddatapointszerotolow = 0.01+(rand(1,DataPoints(1))*0.1);% speed points from 0 to 0.1pu 
speeddatapointslowhigh = 0.1+(rand(1,DataPoints(2))*0.9); % Speed points from 0.1 pu to 1pu
torquesdatapoints = 0.1+(rand(1,DataPoints(3))*0.9); % torque points from 0.1pu to 1pu

lowtohighspeeddata = Simulink.SimulationOutput.empty(0,0);
zerotolowspeeddata = Simulink.SimulationOutput.empty(0,0);


%% Set the data capture enable, speed and torque operating point
dataenablepath= [model ...
'/Current Control/Control_System/Closed Loop Control/Data_Capture_ Control'];

speedpath = [model '/Serial Receive/SCI_Rx/Simulation/Speed_Training'];

torquepath =  [model ...
    '/Inverter and Motor - Plant Model/Simulation/Load_Profile (Torque)/Torque_Training'];



%% Run the simulation model for data capture
open_system(model);

timewindow1 = ['[' num2str(datatimel2h) ']'];
set_param(model,'LoggingIntervals',timewindow1); % time window for data capture for low to high speed

% Enable data capturing in model
set_param(dataenablepath,'Value','1')

% Enable accelerator mode for model
set_param(model,'SimulationMode','accelerator')


speeddatalength1 = length(speeddatapointslowhigh);
torquedatalenght = length(torquesdatapoints);

for ite1 = 1:speeddatalength1

    % Set the speed operating point
    omega  = speeddatapointslowhigh(ite1); 
    set_param(speedpath,'Value',num2str(omega)); % set the torque operating point

    for ite2 = 1:torquedatalenght
        torque = torquesdatapoints(ite2); 
        set_param(torquepath,'Value',num2str(torque)); % set the torque operating point
        simout = sim(model);
        lowtohighspeeddata(ite1,ite2) = simout;
    end
end


speeddatalength2 = length(speeddatapointszerotolow);

timewindow2 = ['[' num2str(datatimz2l) ']'];
set_param(bdroot,'LoggingIntervals',timewindow2); % time window for data capture for zero to low speed

for ite1 = 1:speeddatalength2
    omega  = speeddatapointszerotolow(ite1); 
    set_param(speedpath,'Value',num2str(omega)); % set the speed operating point    
    torque = 0.05; 
    set_param(torquepath,'Value',num2str(torque)); % set the torque operating point
    simout = sim(model);
    zerotolowspeeddata(ite1) = simout;
end

% Disable data capturing in model
set_param(dataenablepath,'Value','0')

% Set the model back to normal mode
set_param(model,'SimulationMode','normal')

end