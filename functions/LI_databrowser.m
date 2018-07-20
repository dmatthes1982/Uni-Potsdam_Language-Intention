function [ cfgArtifacts ] = LI_databrowser( cfg, data )
% LI_DATABROWSER displays a certain language and intention project 
% dataset using a appropriate scaling.
%
% Use as
%   LI_databrowser( cfg, data )
%
% where the input can be the result of LI_IMPORTDATASET,
% LI_PRUNESEGMENTS or LI_REJECTBADINTERVALARTIFACTS
%
% The configuration options are
%   cfg.part        = number of participant (default: [])
%   cfg.condition   = condition identifier, 'conf' or 'incong'
%   cfg.artifact    = Nx2 matrix with artifact segments (default: [])
%   cfg.channel     = channels of interest (default: 'all')
%   cfg.ylim        = vertical scaling (default: [-50 50]);
%   cfg.blocksize   = duration in seconds for cutting the data up (default: [])
%   cfg.plotevents  = 'yes' or 'no' (default: 'yes'), if it is no raw data
%                     you have to specify cfg.part and cf.condition, 
%                     otherwise the events will be not found and therefore
%                     not plotted
%
% This function requires the fieldtrip toolbox
%
% See also LI_IMPORTDATASET,LI_PRUNESEGMENTS, 
% LI_REJECTBADINTERVALARTIFACTS, FT_DATABROWSER

% Copyright (C) 2018, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Get and check config options
% -------------------------------------------------------------------------
part        = ft_getopt(cfg, 'part', []);
condition   = ft_getopt(cfg, 'condition', []);
artifact    = ft_getopt(cfg, 'artifact', []);
channel     = ft_getopt(cfg, 'channel', 'all');
ylim        = ft_getopt(cfg, 'ylim', [-50 50]);
blocksize   = ft_getopt(cfg, 'blocksize', []);
plotevents  = ft_getopt(cfg, 'plotevents', 'yes');

if ~isempty(condition)
  if ~ismember(condition, {'cong', 'incong'})
    error('cfg.condition has to be either ''cong'' or ''incong''.');
  end
  switch condition
    case 'cong'
      condition = 'Kong';
    case 'incong'
      condition = 'Inkong';
  end
end

if isempty(part) || isempty(condition)                                      % if part number or condition identifier is not specified
  event = [];                                                               % the associated markers cannot be loaded and displayed
else                                                                        % else, load the stimulus markers 
  source = ['/data/tu_dmatthes_cloud/LanguageIntention/eegData/'...
            'EEG_LI_processedBVA/'];
  filename = sprintf('*%02d_%s_BL.vhdr', part, condition);
  file_List = dir([source filename]);
  path = [source file_List(1).name];
  ft_warning off;
  event = ft_read_event(path);                                              % read stimulus markers
  ft_warning on; 
  
  eventCell = squeeze(struct2cell(event))';                                 % remove all bad interval markers
  match     = ~strcmp(eventCell(:,1), 'Bad Interval');
  event     = event(match);
  
  eventCell = squeeze(struct2cell(event))';                                 % remove all new segment markers
  match     = ~strcmp(eventCell(:,1), 'New Segment');
  event     = event(match);
  
  eventCell = squeeze(struct2cell(event))';                                 % remove all time 0 markers
  match     = ~strcmp(eventCell(:,1), 'Time 0');
  event     = event(match);
end


% -------------------------------------------------------------------------
% Configure and start databrowser
% -------------------------------------------------------------------------
cfg                               = [];
cfg.ylim                          = ylim;
cfg.blocksize                     = blocksize;
cfg.viewmode                      = 'vertical';
cfg.artfctdef.threshold.artifact  = artifact;
cfg.continuous                    = 'no';
cfg.channel                       = channel;
cfg.plotevents                    = plotevents;
cfg.event                         = event;
cfg.showcallinfo                  = 'no';

fprintf('Databrowser - Participant: %d\n', part);

if nargout > 0
  cfgArtifacts = ft_databrowser(cfg, data);
else
  ft_databrowser(cfg, data);
end

end
