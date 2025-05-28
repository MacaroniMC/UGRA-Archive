function brightness = brightnessCalibration(Data, gps_time, twtt, GPS_time, Time, binRange, layerBinRange)

% interpolate GPS_time
layer = interp1(gps_time, twtt(2,:), GPS_time);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data: M x N double array where M is fast time and N is slow time (M row & N columns)
%   measures radad echogram data
%   Units: Relative received power (Watts) 
%
% "fast time is the y axis since that's in terms of the two way travel time of the radar 
% which ofc goes very fast, and slow time is the x axis since 
% that's in terms of the plane's movement, which is relatively slow"
%   - Elijah

% Time: M by 1 double vector where M is fast time Size/Axes  
% Surface: 1 by N double vector where N is slow time (uses the same frame
% of reference as the Time variable.)
%   Units: Seconds

% GPS_time = x axis variable
% y axis: Data input given GPS time & twtt point ?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% layer range should be LESS than ambBins variables

% initialize index & brightness arrays (?)
layerIndex = zeros(1, size(Data, 2));    
layerIndexBrightness = zeros(binRange + binRange + 1, size(Data, 2));
localLayerBrightness = zeros(binRange + binRange + 1, size(Data,2));

% Loops to create data in layerindex/brightnessIndex/localLayerBrightness

for i = 1:size(Data,2) % for all indices up to the length of Data column
    % fills in layerIndex matrix w/ corresponding location in Data (?) matrix
    [~, layerIndex(1, i)] = min(abs(Time-layer(i)));
    if layerIndex(1, i) < binRange + 1
        % corrects "out of bounds" layerIndex values
        layerIndex(1, i) = binRange + 1;
    end 

    % fills in localLayerBrightness using layerIndex indicies that correspond to Data matrix
    % previously "localLayerBrightness"
    for j = [-binRange:binRange] % ex: [-5:5] array
        localLayerBrightness(j + binRange + 1, i) = Data(layerIndex(1, i) + j, i);
    end
    
    % fills in brightnessIndex using layerIndex indicies that correspond to Data matrix
    for j = [-layerBinRange:layerBinRange]
        layerIndexBrightness(j + layerBinRange + 1, i) = Data(layerIndex(1, i) + j, i);
    end

brightness = {'localLayerBrightness', localLayerBrightness ; 'layerIndexBrightness', layerIndexBrightness};

    end 
end
