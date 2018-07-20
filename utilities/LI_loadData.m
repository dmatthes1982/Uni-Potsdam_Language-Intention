function LI_loadData( cfg )
% LI_LOADDATA loads a specific LI dataset
%
% Use as
%   LI_loadData( cfg )
%
% The configuration options are
%   cfg.srcFolder   = source folder (default: '/data/tu_dmatthes_cloud/LanguageIntention/eegData/EEG_LI_processedFT/01a_import/')
%   cfg.filename    = filename (default: 'LI_incong_p01_01a_import')
%   cfg.sessionStr  = number of session, format: %03d, i.e.: '003' (default: '001')
%
% This function requires the fieldtrip toolbox.
%
% SEE also LOAD

% Copyright (C) 2018, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Get config options
% -------------------------------------------------------------------------
srcFolder   = ft_getopt(cfg, 'srcFolder', '/data/tu_dmatthes_cloud/LanguageIntention/eegData/EEG_LI_processedFT/01a_import/');
filename    = ft_getopt(cfg, 'filename', 'LI_incong_p01_01a_import');
sessionStr  = ft_getopt(cfg, 'sessionStr', '001');

% -------------------------------------------------------------------------
% Load data and assign it to the base workspace
% -------------------------------------------------------------------------
file_path = strcat(srcFolder, filename, '_', sessionStr, '.mat');
file_num = length(dir(file_path));

if file_num ~= 0
  newData = load(file_path);
  vars = fieldnames(newData);
  for i = 1:length(vars)
    assignin('base', vars{i}, newData.(vars{i}));
  end
else
  error('File %s does not exist.', file_path);
end

end
