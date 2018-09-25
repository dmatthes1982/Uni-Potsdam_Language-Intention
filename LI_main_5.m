if ~exist('sessionStr', 'var')
  cfg           = [];
  cfg.subFolder = '02b_pwelch/';
  cfg.filename  = 'LI_incong_p30_02b_pwelch';
  sessionNum    = LI_getSessionNum( cfg );
  if sessionNum == 0
    sessionNum = 1;
  end
  sessionStr    = sprintf('%03d', sessionNum);                              % estimate current session number
end

if ~exist('desPath', 'var')
  desPath = ['/data/tu_dmatthes_temp/LanguageIntention/'...                 % destination path for processed data
             'eegData/EEG_LI_processedFT/'];
end

if ~exist('numOfPart', 'var')                                               % estimate number of participants in pwelch data folder
  sourceList    = dir([strcat(desPath, '02b_pwelch/'), ...
                       strcat('LI_incong*_', sessionStr, '.mat')]);
  sourceList    = struct2cell(sourceList);
  sourceList    = sourceList(1,:);
  numOfSources  = length(sourceList);
  numOfPart     = zeros(1, numOfSources);

  for i=1:1:numOfSources
    numOfPart(i)  = sscanf(sourceList{i}, ...
                    strcat('LI_incong_p%d_02b_pwelch_', sessionStr, '.mat'));
  end
  numOfPart = sort(numOfPart);
end

%% part 5
% 1. average psd results over participants
% 2. average pwelch results over participants

cprintf([0,0.6,0], '<strong>[5] - Averaging power over participants</strong>\n');
fprintf('\n');

%% load and structure data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_cong_psd       = cell(1, length(numOfPart));
data_cong_pwelch    = cell(1, length(numOfPart));
data_incong_psd     = cell(1, length(numOfPart));
data_incong_pwelch  = cell(1, length(numOfPart));

for i = 1:1:length(numOfPart)
  fprintf('<strong>Participant %d</strong>\n', numOfPart(i));
  % congruent data --------------------------------------------------------
  cfg             = [];
  cfg.srcFolder   = strcat(desPath, '02a_psd/');
  cfg.filename    = sprintf('LI_cong_p%02d_02a_psd', numOfPart(i));
  cfg.sessionStr  = sessionStr;

  fprintf('Load congruent psd data...\n');
  LI_loadData( cfg );
  data_cong_psd{i} = data_psd;
  
  cfg             = [];
  cfg.srcFolder   = strcat(desPath, '02b_pwelch/');
  cfg.filename    = sprintf('LI_cong_p%02d_02b_pwelch', numOfPart(i));
  cfg.sessionStr  = sessionStr;

  fprintf('Load congruent pwelch data...\n');
  LI_loadData( cfg );
  data_cong_pwelch{i} = data_pwelch;
  
  clear data_psd data_pwelch
  
  % incongruent data ------------------------------------------------------
  cfg             = [];
  cfg.srcFolder   = strcat(desPath, '02a_psd/');
  cfg.filename    = sprintf('LI_incong_p%02d_02a_psd', numOfPart(i));
  cfg.sessionStr  = sessionStr;

  fprintf('Load incongruent psd data...\n');
  LI_loadData( cfg );
  data_incong_psd{i} = data_psd;
  
  cfg             = [];
  cfg.srcFolder   = strcat(desPath, '02b_pwelch/');
  cfg.filename    = sprintf('LI_incong_p%02d_02b_pwelch', numOfPart(i));
  cfg.sessionStr  = sessionStr;

  fprintf('Load incongruent pwelch data...\n\n');
  LI_loadData( cfg );
  data_incong_pwelch{i} = data_pwelch;
  
  clear data_psd data_pwelch 
end

%% estimate power average over participants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cfgAvg                = [];
cfgAvg.keepindividual = 'no';
cfgAvg.foilim         = 'all';
cfgAvg.channel        = 'all';
cfgAvg.parameter      = 'powspctrm';
cfgAvg.feedback       = 'no';
cfgAvg.showcallinfo   = 'no';

ft_info off;

% congruent psd data ------------------------------------------------------
fprintf('<strong>Average congruent psd results over participants...</strong>\n');
data_psd            = ft_freqgrandaverage(cfgAvg, data_cong_psd{:});
data_psd.numOfPart  = numOfPart;

% export averaged congruent psd results into *.mat files
cfg             = [];
cfg.desFolder   = strcat(desPath, '05a_psdop/');
cfg.filename    = 'LI_05a_psdop_congruent';
cfg.sessionStr  = sessionStr;

file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                   '.mat');

fprintf('The averaged congruent psd results will be saved in:\n'); 
fprintf('%s ...\n', file_path);
LI_saveData(cfg, 'data_psd', data_psd);
fprintf('Data stored!\n\n');
clear data_psd data_cong_psd

% congruent pwelch data ---------------------------------------------------
fprintf('<strong>Average congruent pwelch results over participants...</strong>\n');
data_pwelch             = ft_freqgrandaverage(cfgAvg, data_cong_pwelch{:});
data_pwelch.numOfPart   = numOfPart;

% export averaged congruent pwelch results into *.mat files
cfg             = [];
cfg.desFolder   = strcat(desPath, '05b_pwelchop/');
cfg.filename    = 'LI_05a_pwelchop_congruent';
cfg.sessionStr  = sessionStr;

file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                   '.mat');

fprintf('The averaged congruent pwelch results will be saved in:\n'); 
fprintf('%s ...\n', file_path);
LI_saveData(cfg, 'data_pwelch', data_pwelch);
fprintf('Data stored!\n\n');
clear data_pwelch data_cong_pwelch

% incongruent psd data ----------------------------------------------------
fprintf('<strong>Average incongruent psd results over participants...</strong>\n');
data_psd            = ft_freqgrandaverage(cfgAvg, data_incong_psd{:});
data_psd.numOfPart  = numOfPart;

% export averaged incongruent psd results into *.mat files
cfg             = [];
cfg.desFolder   = strcat(desPath, '05a_psdop/');
cfg.filename    = 'LI_05a_psdop_incongruent';
cfg.sessionStr  = sessionStr;

file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                   '.mat');

fprintf('The averaged incongruent psd results will be saved in:\n'); 
fprintf('%s ...\n', file_path);
LI_saveData(cfg, 'data_psd', data_psd);
fprintf('Data stored!\n\n');
clear data_psd data_incong_psd

% incongruent pwelch data -------------------------------------------------
fprintf('<strong>Average incongruent pwelch results over participants...</strong>\n');
data_pwelch           = ft_freqgrandaverage(cfgAvg, data_incong_pwelch{:});
data_pwelch.numOfPart = numOfPart;

% export averaged incongruent pwelch results into *.mat files
cfg             = [];
cfg.desFolder   = strcat(desPath, '05b_pwelchop/');
cfg.filename    = 'LI_05a_pwelchop_incongruent';
cfg.sessionStr  = sessionStr;

file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                   '.mat');

fprintf('The averaged incongruent pwelch results will be saved in:\n'); 
fprintf('%s ...\n', file_path);
LI_saveData(cfg, 'data_pwelch', data_pwelch);
fprintf('Data stored!\n');
clear data_pwelch data_incong_pwelch

ft_info on;

%% clear workspace
clear i cfg file_path cfgAvg
