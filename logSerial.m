%% logSerial.m
% Reads serial port data and appends a text log file continuously
% Press CTRL + C twice quickly to stop
% TO DO: Severe delay between logging and live plot.

clear all; close all; clc
s = serialport("COM3",9600);
configureTerminator(s,"CR/LF")
dataline = readline(s); % first line is bad. TO DO figure out why. e.g.:
% dataline = 
% 
%     "
%      þ136"

numPoints = 200; % for live plot
data = zeros(numPoints,1);

fileName = 'outLog';
outFID = fopen(fileName,'w'); %overwrite old
outFID = fclose(outFID);
n=0;
while 1
    n=n+1;
    dataline = readline(s);
    num = str2num(dataline);
    if ~isempty(num)
        data(end) = num;
    end
    data = circshift(data,-1);
    outFID = fopen(fileName,'a');
    fprintf(outFID,'%.2f\n',data(end));
    outFID = fclose(outFID);
    if n == numPoints % this does not help
        plot(data);drawnow
        n=0;
    end
end

clear s