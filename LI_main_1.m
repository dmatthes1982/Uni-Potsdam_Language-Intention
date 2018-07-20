if ~exist('sessionStr', 'var')
  cfg           = [];
  cfg.subFolder = '01b_revised/';
  cfg.filename  = 'LI_incong_p30_01b_revised';
  sessionNum    = LI_getSessionNum( cfg );
  if sessionNum == 0
    sessionNum = 1;
  end
  sessionStr    = sprintf('%03d', sessionNum);                              % estimate current session number
end

if ~exist('srcPath', 'var')
  srcPath = ['/home/raid/dmatthes/MATLAB/data/LanguageIntention/'...        % source path to raw data
             'eegData/EEG_LI_processedBVA/'];                  
end

if ~exist('desPath', 'var')
  desPath = ['/home/raid/dmatthes/MATLAB/data/LanguageIntention/'...        % destination path for processed data
             'eegData/EEG_LI_processedFT/'];
end

if ~exist('numOfPart', 'var')                                               % estimate number of participants in raw data folder
  sourceList    = dir([srcPath, '/*Inkong_BL.vhdr']);
  sourceList    = struct2cell(sourceList);
  sourceList    = sourceList(1,:);
  numOfSources  = length(sourceList);
  numOfPart     = zeros(1, numOfSources);

  for i=1:1:numOfSources
    numOfPart(i)  = sscanf(sourceList{i}(7:end), '_%d_Inkong_BL.vhdr');
  end
  
  numOfPart = sort(numOfPart);
end

%% part 1
% 1. import data from brain vision eeg files
% 2. reject segments with bad intervals
% 3. prune segments --> remove pre stimulus offset

cprintf([0,0.6,0], '<strong>[1] - Data import, bad segments and pre-stimulus offset rejection</strong>\n');
fprintf('\n');

%% import data from brain vision eeg files %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = numOfPart
  fprintf('<strong>Paricipant %d</strong>\n\n', i);
  
  % congruent data
  cfg           = [];
  cfg.path      = srcPath;
  cfg.part      = i;
  cfg.condition = 'cong';
  
  fprintf('<strong>Import congruent data</strong> from: \n%s ...\n\n', cfg.path);
  data_import = LI_importDataset( cfg );
  
  % export imported data in a *.mat file
  cfg             = [];
  cfg.desFolder   = strcat(desPath, '01a_import/');
  cfg.filename    = sprintf('LI_cong_p%02d_01a_import', i);
  cfg.sessionStr  = sessionStr;

  file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                     '.mat');
  
  fprintf('The imported congruent data of participant %d will be saved in:\n', i); 
  fprintf('%s ...\n', file_path);
  LI_saveData(cfg, 'data_import', data_import);
  fprintf('Data stored!\n\n');
  clear data_import
  
  % incongruent data
  cfg           = [];
  cfg.path      = srcPath;
  cfg.part      = i;
  cfg.condition = 'incong';
  
  fprintf('<strong>Import incongruent data</strong> from: \n%s ...\n\n', cfg.path);
  data_import = LI_importDataset( cfg );
  
  % export imported data in a *.mat file
  cfg             = [];
  cfg.desFolder   = strcat(desPath, '01a_import/');
  cfg.filename    = sprintf('LI_incong_p%02d_01a_import', i);
  cfg.sessionStr  = sessionStr;

  file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                     '.mat');
  
  fprintf('The imported incongruent data of participant %d will be saved in:\n', i); 
  fprintf('%s ...\n', file_path);
  LI_saveData(cfg, 'data_import', data_import);
  fprintf('Data stored!\n\n');
  clear data_import
end

%% reject segments with bad intervals %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = numOfPart
  fprintf('<strong>Participant %d</strong>\n\n', i);
  
  % Create settings file if not existing
  NoT_file = [desPath '00_settings/' ...
                    sprintf('numoftrials_%s', sessionStr) '.xls'];
  if ~(exist(NoT_file, 'file') == 2)                                        % check if number of trials file already exist
    cfg = [];
    cfg.desFolder   = [desPath '00_settings/'];
    cfg.type        = 'numoftrials';
    cfg.sessionStr  = sessionStr;

    LI_createTbl(cfg);                                                      % create number of trials file
  end

  % congruent data
  cfg             = [];
  cfg.srcFolder   = strcat(desPath, '01a_import/');
  cfg.filename    = sprintf('LI_cong_p%02d_01a_import', i);
  cfg.sessionStr  = sessionStr;
    
  fprintf('Load imported congruent data...\n\n');
  LI_loadData( cfg );
  
  % reject segments with bad intervals
  data_revised = LI_rejectBadIntervalArtifacts(data_import);
  
  numOfTrialsCong = length(data_import.trial);
  CongTrials      = 1:1:numOfTrialsCong;
  CongBadTrials   = CongTrials(~ismember(CongTrials, ...
                      data_revised.sampleinfo(:,2)/1500));

  % export revised data in a *.mat file
  cfg             = [];
  cfg.desFolder   = strcat(desPath, '01b_revised/');
  cfg.filename    = sprintf('LI_cong_p%02d_01b_revised', i);
  cfg.sessionStr  = sessionStr;

  file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                     '.mat');
  
  fprintf('\nThe revised congruent data of participant %d will be saved in:\n', i); 
  fprintf('%s ...\n', file_path);
  LI_saveData(cfg, 'data_revised', data_revised);
  fprintf('Data stored!\n\n');
  clear data_import data_revised
  
  % incongruent data
  cfg             = [];
  cfg.srcFolder   = strcat(desPath, '01a_import/');
  cfg.filename    = sprintf('LI_incong_p%02d_01a_import', i);
  cfg.sessionStr  = sessionStr;
    
  fprintf('Load imported incongruent data...\n\n');
  LI_loadData( cfg );
  
  % reject segments with bad intervals
  data_revised = LI_rejectBadIntervalArtifacts(data_import);
  
  numOfTrialsInCong = length(data_import.trial);
  IncongTrials      = 1:1:numOfTrialsInCong;
  IncongBadTrials   = IncongTrials(~ismember(IncongTrials, ...
                      data_revised.sampleinfo(:,2)/1500));

  % export revised data in a *.mat file
  cfg             = [];
  cfg.desFolder   = strcat(desPath, '01b_revised/');
  cfg.filename    = sprintf('LI_incong_p%02d_01b_revised', i);
  cfg.sessionStr  = sessionStr;

  file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                     '.mat');
  
  fprintf('\nThe revised incongruent data of participant %d will be saved in:\n', i); 
  fprintf('%s ...\n', file_path);
  LI_saveData(cfg, 'data_revised', data_revised);
  fprintf('Data stored!\n\n');
  clear data_import data_revised

  % Load number of trials file
  T = readtable(NoT_file);
  warning off;
  T.participant(numOfPart - 29) = numOfPart;
  T.congNoT(numOfPart - 29)     = numOfTrialsCong;
  T.incongNoT(numOfPart - 29)   = numOfTrialsInCong;
  T.congBad(numOfPart - 29)     = {vec2str(CongBadTrials, [], [], 0)};
  T.incongBad(numOfPart - 29)   = {vec2str(IncongBadTrials, [], [], 0)};
  warning on;

  clear numOfTrialsCong numOfTrialsInCong CongBadTrials IncongBadTrials ...
        CongTrials IncongTrials

  % store settings table
  delete(NoT_file);
  writetable(T, NoT_file);
end

%% prune segments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = numOfPart
  fprintf('<strong>Participant %d</strong>\n\n', i);
  
  % congruent data
  cfg             = [];
  cfg.srcFolder   = strcat(desPath, '01b_revised/');
  cfg.filename    = sprintf('LI_cong_p%02d_01b_revised', i);
  cfg.sessionStr  = sessionStr;
    
  fprintf('Load revised congruent data...\n');
  LI_loadData( cfg );
  
  % prune segments --> remove pre stimulus offset
  cfg         = [];
  cfg.begtime = 0;
  cfg.endtime = 1.4;

  data_pruned = LI_pruneSegments(cfg, data_revised);
  
  cfg             = [];
  cfg.desFolder   = strcat(desPath, '01c_pruned/');
  cfg.filename    = sprintf('LI_cong_p%02d_01c_pruned', i);
  cfg.sessionStr  = sessionStr;

  file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                     '.mat');
  
  fprintf('\nThe pruned congruent data of participant %d will be saved in:\n', i); 
  fprintf('%s ...\n', file_path);
  LI_saveData(cfg, 'data_pruned', data_pruned);
  fprintf('Data stored!\n\n');
  clear data_revised data_pruned
  
  % incongruent data
  cfg             = [];
  cfg.srcFolder   = strcat(desPath, '01b_revised/');
  cfg.filename    = sprintf('LI_incong_p%02d_01b_revised', i);
  cfg.sessionStr  = sessionStr;
    
  fprintf('Load revised incongruent data...\n');
  LI_loadData( cfg );
  
  % prune segments --> remove pre stimulus offset
  cfg         = [];
  cfg.begtime = 0;
  cfg.endtime = 1.4;

  data_pruned = LI_pruneSegments(cfg, data_revised);
  
  cfg             = [];
  cfg.desFolder   = strcat(desPath, '01c_pruned/');
  cfg.filename    = sprintf('LI_incong_p%02d_01c_pruned', i);
  cfg.sessionStr  = sessionStr;

  file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                     '.mat');
  
  fprintf('\nThe pruned incongruent data of participant %d will be saved in:\n', i); 
  fprintf('%s ...\n', file_path);
  LI_saveData(cfg, 'data_pruned', data_pruned);
  fprintf('Data stored!\n\n');
  clear data_revised data_pruned
end

%% clear workspace
clear i cfg file_path T NoT_file
