function [ data ] = LI_pruneSegments( cfg, data )
% LI_PRUNESEGMENTS prunes the trials to a certain part.
%
% Use as
%   [ data ] = LI_pruneSegments( cfg, data )
%
% where the input data has to be either a result of LI_IMPORTDATASET or
% LI_REJECTBADINTERVALLARTIFACTS
%
% The configuration options are
%   cfg.begtime = starting sample time of the desired segment (in seconds, i.e. 0.052)
%   cfg.endtime = final sample time of the desired segment (in seconds, i.e. 1.382)
%
% This function requires the fieldtrip toolbox
%
% See also FT_REDEFINETRIAL, LI_IMPORTDATASET, LI_REJECTBADINTERVALARTIFACTS

% Copyright (C) 2018, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Get and check config options
% -------------------------------------------------------------------------
begtime = ft_getopt(cfg, 'begtime', []);
endtime = ft_getopt(cfg, 'endtime', []);

begsample = find(data.time{1} >= begtime, 1, 'first');
endsample = find(data.time{1} <= endtime, 1, 'last');

begdiff = begsample - 1;
enddiff = length(data.time{1}) - endsample;

trl = data.sampleinfo;                                                      % estimate trl definition
trl(:,1) = trl(:,1) + begdiff;
trl(:,2) = trl(:,2) - enddiff;
trl(:,3) = 0; 

% -------------------------------------------------------------------------
% Prune data
% -------------------------------------------------------------------------
cfg               = [];
cfg.trials        = 'all';
cfg.trl           = trl;
cfg.showcallinfo  = 'no';

fprintf('<strong>Prune segments...\n</strong>');
ft_info off;
ft_warning off;
data = ft_redefinetrial(cfg, data);

end
