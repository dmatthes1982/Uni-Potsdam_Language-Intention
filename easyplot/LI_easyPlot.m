function LI_easyPlot( cfg, data )
% LI_EASYPLOT is a function, which makes it easier to plot the data of a 
% specific trial.
%
% Use as
%   LI_easyPlot(cfg, data)
%
% where the input data can be the results of LI_IMPORTDATASET,
% LI_PRUNESEGMENTS or LI_REJECTBADINTERVALARTIFACTS
%
% The configuration options are
%   cfg.electrode = number of electrode (default: 'Cz')
%   cfg.trial     = number of trial (default: 1)
%
% This function requires the fieldtrip toolbox.
%
% See also LI_IMPORTDATASET, LI_PRUNESEGMENTS, 
% LI_REJECTBADINTERVALARTIFACTS, PLOT

% Copyright (C) 2018, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Get and check config options
% -------------------------------------------------------------------------
elec = ft_getopt(cfg, 'electrode', 'Cz');
trl  = ft_getopt(cfg, 'trial', 1);

if trl > length(data.trialinfo)
  error('This dataset has only %d trials', length(data.trialinfo));
end

label     = data.label;                                                     % get labels
if isnumeric(elec)                                                          % check cfg.electrode definition
  if elec < 1 || elec > 32
    error('cfg.elec hast to be a number between 1 and 32 or a existing label like ''Cz''.');
  end
else
  elec = find(strcmp(label, elec));
  if isempty(elec)
    error('cfg.elec hast to be a existing label like ''Cz''or a number between 1 and 32.');
  end
end

% -------------------------------------------------------------------------
% Plot timeline
% -------------------------------------------------------------------------
plot(data.time{trl}, data.trial{trl}(elec,:));
title(sprintf('Electrode.: %s - Trial: %d', ...
      strrep(data.label{elec}, '_', '\_'), trl));      

xlabel('time in seconds');
ylabel('voltage in \muV');

end
