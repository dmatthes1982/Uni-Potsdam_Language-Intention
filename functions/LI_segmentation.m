function [ data ] = LI_segmentation(cfg, data )
% LI_SEGMENTATION segments the data of each trial into segments with a
% certain length
%
% Use as
%   [ data ] = LI_segmentation( cfg, data )
%
% where the input data can be the result from LI_IMPORTDATASET,
% LI_PRUNESEGMENTS or LI_REJECTBADINTERVALARTIFACTS
%
% The configuration options are
%   cfg.length    = length of segments
%   cfg.overlap   = percentage of overlapping (range: 0 ... 1, default: 0)
%
% This function requires the fieldtrip toolbox.
%
% See also LI_IMPORTDATASET, LI_PRUNESEGMENTS, 
% LI_REJECTBADINTERVALARTIFACTS

% Copyright (C) 2018, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Get and check config options
% -------------------------------------------------------------------------
segLength = ft_getopt(cfg, 'length', 1);
overlap   = ft_getopt(cfg, 'overlap', 0);

% -------------------------------------------------------------------------
% Segmentation settings
% -------------------------------------------------------------------------
cfg                 = [];
cfg.feedback        = 'no';
cfg.showcallinfo    = 'no';
cfg.trials          = 'all';                                                  
cfg.length          = segLength;
cfg.overlap         = overlap;

% -------------------------------------------------------------------------
% Segmentation
% -------------------------------------------------------------------------
fprintf('Segment data in segments of %d sec with %d %% overlapping...\n', ...
        segLength, overlap*100);
ft_info off;
ft_warning off;

data = ft_redefinetrial(cfg, data);

ft_info on;
ft_warning on;
