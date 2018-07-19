function [ data ] = LI_rejectBadIntervalArtifacts( data )
% LI_REJECTBADINTERVALARTIFACTS reject all trials which contains bad
% interval markers
%
% Use as
%   [ data ] = LI_rejectBadIntervalArtifacts( data )
%
% where the input data has to be either a result of LI_IMPORTDATASET
%
% This function requires the fieldtrip toolbox
%
% See also FT_REJECTARTIFACT

% Copyright (C) 2018, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Estimate artifacts
% -------------------------------------------------------------------------
events = data.cfg.event;                                                    % extract all events
artifact = zeros(length(events), 2);                                        % allocate memory
j = 1;

for i=1:1:length(events)
  if(strcmp(events(i).type, 'Bad Interval'))                                % search for bad interval events          
    artifact(j,1)=events(i).sample;                                         % create artifact matrix
    artifact(j,2)=events(i).sample + events(i).duration - 1;
    j = j +1;
  end
end

artifact = artifact(1:j-1, :);

% -------------------------------------------------------------------------
% Revise data
% -------------------------------------------------------------------------
cfg                           = [];
cfg.event                     = events;
cfg.artfctdef.reject          = 'complete';
cfg.artfctdef.feedback        = 'no';
cfg.artfctdef.xxx.artifact    = artifact;
cfg.showcallinfo              = 'no';

fprintf('<strong>Reject segments with bad intervals...\n</strong>');
data = ft_rejectartifact(cfg, data);

end
