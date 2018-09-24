% -------------------------------------------------------------------------
% Add directory and subfolders to path
% -------------------------------------------------------------------------

filepath = fileparts(mfilename('fullpath'));

if strcmp(computer, 'GLNXA64')
  addpath(sprintf('%s/:%s/easyplot:%s/functions:%s/utilities:%s/export',...
          filepath, filepath, filepath, filepath, filepath));
elseif strcmp(computer, 'PCWIN64')
  addpath(filepath);
  addpath([filepath '\easyplot']);
  addpath([filepath '\functions']);
  addpath([filepath '\utilities']);
  addpath([filepath '\export']);
end

clear filepath