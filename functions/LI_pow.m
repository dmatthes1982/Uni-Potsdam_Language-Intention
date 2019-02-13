function [ data ] = LI_pow( data )
% LI_POW estimates the power for all trials of the dataset and averages the
% results over all existing trials.
%
% Use as 
%   [ data ] = LI_pow( data )
%
% where the input data has to be either the result of LI_PRUNESEGMENTS or 
% LI_SEGMENTATION.
%
% This function requires the fieldtrip toolbox
%
% See also FT_FREQANALYSIS

% Copyright (C) 2018-2019, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% power settings
% -------------------------------------------------------------------------
fsample = data.fsample;
L       = length(data.time{1});

cfg                 = [];
cfg.method          = 'mtmfft';
cfg.output          = 'pow';
cfg.channel         = 'all';                                                % calculate spectrum for all channels
cfg.trials          = 'all';                                                % calculate spectrum for every trial  
cfg.keeptrials      = 'no';                                                 % average over trials
cfg.pad             = 'maxperlen';                                          % no padding
cfg.taper           = 'hanning';                                            % hanning taper the segments
cfg.foi             = 0:fsample/L:fsample/2;                                % range from zero to Fs/2 
cfg.feedback        = 'no';                                                 % suppress feedback output
cfg.showcallinfo    = 'no';                                                 % suppress function call output

% -------------------------------------------------------------------------
% calculate power
% -------------------------------------------------------------------------
warning('off','all');
data = ft_freqanalysis(cfg, data);                                          % calculate power spectrum
warning('on','all');

end
