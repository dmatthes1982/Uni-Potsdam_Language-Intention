function [ data ] = LI_powerAverage( cfg ,data )
% LI_POWERAVERAGE averages the power over a defined frequency range for all
% channels
%
% Use as
%   LI_powerAverage(cfg, data)
%
% where the input data has to be a result of LI_POW
%
% The configuration options are
%   cfg.freqrange = frequency range [fmin fmax] (default: [7 9]
%
% This function requires the fieldtrip toolbox

% Copyright (C) 2018-2019, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Get and check config options
% -------------------------------------------------------------------------
freqrange = ft_getopt(cfg, 'freqrange', [7 9]);

begCol = find(data.freq >= freqrange(1), 1, 'first');                       % estimate matrix colums
endCol = find(data.freq <= freqrange(2), 1, 'last');

data.powspctrm = data.powspctrm(:,begCol:endCol);
data.freq = data.freq(begCol:endCol);

% -------------------------------------------------------------------------
% Estimate power average
% -------------------------------------------------------------------------
data.powspctrm = mean(data.powspctrm,2);
data = removefields(data, {'cfg'});

end
