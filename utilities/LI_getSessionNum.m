function [ num ] = LI_getSessionNum( cfg )
% LI_GETSESSIONNUM determines the highest session number of a specific 
% data file 
%
% Use as
%   [ num ] = LI_getSessionNum( cfg )
%
% The configuration options are
%   cfg.desFolder   = destination folder (default: '/home/raid/dmatthes/MATLAB/data/LanguageIntention/eegData/EEG_LI_processedFT/')
%   cfg.subFolder   = name of subfolder (default: '01a_import/')
%   cfg.filename    = filename (default: 'LI_incong_p01_01a_import')
%
% This function requires the fieldtrip toolbox.

% Copyright (C) 2018, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Get config options
% -------------------------------------------------------------------------
desFolder   = ft_getopt(cfg, 'desFolder', '/home/raid/dmatthes/MATLAB/data/LanguageIntention/eegData/EEG_LI_processedFT/');
subFolder   = ft_getopt(cfg, 'subFolder', '01a_import/');
filename    = ft_getopt(cfg, 'filename', 'LI_incong_p01_01a_import');

% -------------------------------------------------------------------------
% Estimate highest session number
% -------------------------------------------------------------------------
file_path = strcat(desFolder, subFolder, filename, '_*.mat');

sessionList    = dir(file_path);
if isempty(sessionList)
  num = 0;
else
  sessionList   = struct2cell(sessionList);
  sessionList   = sessionList(1,:);
  numOfSessions = length(sessionList);

  sessionNum    = zeros(1, numOfSessions);
  filenameStr   = strcat(filename, '_%d.mat');
  
  for i=1:1:numOfSessions
    sessionNum(i) = sscanf(sessionList{i}, filenameStr);
  end

  num = max(sessionNum);
end

end
