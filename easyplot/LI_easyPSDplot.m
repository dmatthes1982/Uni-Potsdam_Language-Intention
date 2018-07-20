function LI_easyPSDplot(cfg, data)
% LI_EASYPSDPLOT is a function, which makes it easier to plot the power
% spectral density.
%
% Use as
%   LI_easyPSDplot(cfg, data)
%
% where the input data have to be a result from LI_PSD.
%
% The configuration options are 
%   cfg.freqrange   = frequency range [fmin fmax], (default: [0 50])
%   cfg.electrode   = number of electrodes (default: {'Cz'} repsectively [10])
%                     examples: {'Cz'}, {'F3', 'Fz', 'F4'}, [10] or [1, 3, 2]
%
% This function requires the fieldtrip toolbox
%
% See also LI_PSD

% Copyright (C) 2018, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Get and check config options
% -------------------------------------------------------------------------
freqrange   = ft_getopt(cfg, 'freqrange', [0 50]);
elec        = ft_getopt(cfg, 'electrode', {'Cz'});

begCol = find(data.freq >= freqrange(1), 1, 'first');                       % estimate desired powspctrm colums
endCol = find(data.freq <= freqrange(2), 1, 'last');

label     = data.label;                                                     % get labels 
if isnumeric(elec)                                                          % check cfg.electrode
  for i=1:length(elec)
    if elec(i) < 1 || elec(i) > 32
      error('cfg.elec has to be a numbers between 1 and 32 or a existing labels like {''Cz''}.');
    end
  end
else
  tmpElec = zeros(1, length(elec));
  for i=1:length(elec)
    tmpElec(i) = find(strcmp(label, elec{i}));
    if isempty(tmpElec(i))
      error('cfg.elec has to be a cell array of existing labels like ''Cz''or a vector of numbers between 1 and 32.');
    end
  end
  elec = tmpElec;
end

% -------------------------------------------------------------------------
% Plot power spectral density (PSD)
% -------------------------------------------------------------------------
plot(data.freq(begCol:endCol), data.powspctrm(elec, begCol:endCol));
labelString = strjoin(data.label(elec), ',');

title(sprintf('PSD - Electrode.: %s', labelString));
xlabel('frequency in Hz');                                                  % set xlabel
ylabel('PSD');                                                              % set ylabel

end
