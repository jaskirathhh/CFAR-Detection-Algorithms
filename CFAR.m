%Radar Systems Final Project
%Jaskirath Singh
%IIIT Delhi
%11/05/2022

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;          %clears memory
close all;          % closes all figures and plottings
clc;                %clears command window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CFAR DETECTOR PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



cfar = phased.CFARDetector('NumTrainingCells',200,'NumGuardCells',50,'Method','CA');
%%%%%%%%%%%%%%%%%%%%%%%%% ABOUT FUNCTION
% creates a CFAR detector System object named "cfar" The object performs CFAR detection on data provided.
% 'NumTrainingCells' => Number of training cells is provided as even
%                       integer which is divided equally before and after the gaurd cells adjacent to
%                       Cell Under Test.
% 'NumGuardCells' => Number of Guard cells is provided as even
%                    integer which is divided equally before and after the
%                    Cell Under Test.
% 'Method'=>    Specify CFAR detection Algorithm (Cell Averaging in this case)




% Expected probability of False Alarm (no units)
pfa_expected = 1e-2;

% Setting parameters for CFAR Detector object
cfar.ThresholdFactor = 'Auto';
cfar.ProbabilityFalseAlarm = pfa_expected;

% 'Auto' Threshold Fcator means that threshold is calculated automatically
% based upon the probability of false alarm rate which is specified in
% probabilityFalseAlarm parameter.
%% ASSUMPTIONS
% Each independent signal in the input is a single pulse coming out of 
% a square law detector with no pulse integration.
% The noise is white Gaussian.


% Assume 10dB SNR ratio
npower = db2pow(-10);
% Total number of points
Total_points = 1e3;
%Number of trials done 
Num_of_Trials = 1;
% Total cells in window
Num_of_Cells = 251;
% Index of Cell Under test
Cut_Id = 126;

% To obtain the detection threshold
cfar.ThresholdOutputPort = true;


% Seed to generate random number
rs = RandStream('mt19937ar','Seed',2010);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Modeling Received Signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rsamp = randn(rs,Total_points,1)+1i*randn(rs,Total_points,1);
%Rx_Signal = wgn(Total_points,1,-6,'complex');
Rx_Signal = linspace(1,10,Total_points)';
Rx_sld = abs(sqrt(npower*Rx_Signal./2).*rsamp).^2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Applying CFAR funtion to get thresholds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[x_detected,th] = cfar(Rx_sld,1:length(Rx_sld));
%th = 0.2*ones(1000,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Output Viewgraphs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot(1:length(Rx_sld),Rx_sld,1:length(Rx_sld),th,find(x_detected),Rx_sld(x_detected),'o')
legend('Signal','Threshold','Detections','Location','northwest')
title('Cell Averaging CFAR Detection ')
xlabel('Time Index')
ylabel('Threshold')