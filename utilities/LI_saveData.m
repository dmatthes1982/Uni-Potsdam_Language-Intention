function LI_saveData( cfg, varargin )
% LI_SAVEDATA stores the data of various structure elements into a
% MAT_File.
%
% Use as
%   LI_saveData( cfg, varargin )
%
% The configuration options are
%   cfg.desFolder   = destination folder (default: '/data/tu_dmatthes_cloud/LanguageIntention/eegData/EEG_LI_processedFT/01a_import/')
%   cfg.filename    = filename (default: 'LI_incong_p01_01a_import')
%   cfg.sessionStr  = number of session, format: %03d, i.e.: '003' (default: '001')
%
% This function requires the fieldtrip toolbox.
%
% SEE also SAVE

% Copyright (C) 2017, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Get config options
% -------------------------------------------------------------------------
desFolder   = ft_getopt(cfg, 'desFolder', '/data/tu_dmatthes_cloud/LanguageIntention/eegData/EEG_LI_processedFT/01a_import/');
filename    = ft_getopt(cfg, 'filename', 'LI_incong_p01_01a_import');
sessionStr  = ft_getopt(cfg, 'sessionStr', '001');

% -------------------------------------------------------------------------
% Save data
% -------------------------------------------------------------------------
file_path = strcat(desFolder, filename, '_', sessionStr, '.mat');
inputElements = length(varargin);

if inputElements == 0
  error('No elements to save!');
elseif mod(inputElements, 2)
  error('Numbers of input are not even!');
else
  for i = 1:2:inputElements-1
    if ~isvarname(varargin{i})
      error('varargin{%d} is not a valid varname');
    else
      str = [varargin{i}, ' = varargin{i+1};'];
      eval(str);
    end
  end
end

if (~isempty(who('-regexp', '^data')))
  save(file_path, '-regexp','^data', '-v7.3');
elseif (~isempty(who('-regexp', '^cfg_')))
  save(file_path, '-regexp','^cfg_', '-v7.3');
end

end
