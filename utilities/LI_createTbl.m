function LI_createTbl( cfg )
% JAI_CREATETBL generates '*.xls' files for the documentation of the data 
% processing process.
%
% Use as
%   JAI_createTbl( cfg )
%
% The configuration options are
%   cfg.desFolder   = destination folder (default: '/home/raid/dmatthes/MATLAB/data/LanguageIntention/eegData/EEG_LI_processedFT/00_settings/')
%   cfg.type        = type of documentation file (options: 'numoftrials')
%   cfg.sessionStr  = number of session, format: %03d, i.e.: '003' (default: '001')
%
% Explanation:
%   type numoftrials - holds the result of the bad interval rejection
%
% This function requires the fieldtrip toolbox.

% Copyright (C) 2018, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Get config options
% -------------------------------------------------------------------------
desFolder   = ft_getopt(cfg, 'desFolder', ...
          '/home/raid/dmatthes/MATLAB/data/LanguageIntention/eegData/EEG_LI_processedFT/00_settings/');
type        = ft_getopt(cfg, 'type', []);
sessionStr  = ft_getopt(cfg, 'sessionStr', []);

if isempty(type)
  error('cfg.type has to be specified. It has to be ''numoftrials''.');
end

if isempty(sessionStr)
  error('cfg.sessionStr has to be specified');
end

% -------------------------------------------------------------------------
% Create table
% -------------------------------------------------------------------------
switch type
  case 'numoftrials'
    T = table(1,0,0,{'unknown'},{'unknown'});
    T.Properties.VariableNames = ...
        {'participant', 'congNoT', 'incongNoT', 'congBad', 'incongBad'};
    filepath = [desFolder type '_' sessionStr '.xls'];
    writetable(T, filepath);
  otherwise
    error('cfg.type is not valid. Use ''numoftrials''.');
end

end
