if ~exist('sessionStr', 'var')
  cfg           = [];
  cfg.subFolder = '01c_pruned/';
  cfg.filename  = 'LI_incong_p30_01c_pruned';
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

if ~exist('numOfPart', 'var')                                               % estimate number of participants in repaired data folder
  sourceList    = dir([strcat(desPath, '01c_pruned/'), ...
                       strcat('LI_incong*_', sessionStr, '.mat')]);
  sourceList    = struct2cell(sourceList);
  sourceList    = sourceList(1,:);
  numOfSources  = length(sourceList);
  numOfPart     = zeros(1, numOfSources);

  for i=1:1:numOfSources
    numOfPart(i)  = sscanf(sourceList{i}, ...
                    strcat('LI_incong_p%d_01c_pruned_', sessionStr, '.mat'));
  end
  numOfPart = sort(numOfPart);
end

%% part 2
% 1. estimate the power for each trial without subsegmentation and average
%    over trials.
% 2. estimate the power using Welch's method for each trial and average
%    over trials. (segment length 1 sec, overlapping 60% --> each trial
%    will be divided into 2 subsegments)

cprintf([0,0.6,0], '<strong>[2] - Power analysis</strong>\n');
fprintf('\n');

%% power estimation without subsegmentation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
choise = false;
while choise == false
  cprintf([0,0.6,0], 'Do you want to estimate pure power?\n');
  x = input('Select [y/n]: ','s');
  if strcmp('y', x)
    choise = true;
    pow = true;
  elseif strcmp('n', x)
    choise = true;
    pow = false;
  else
    choise = false;
  end
end
fprintf('\n');

if pow == true
  for i = numOfPart
    fprintf('<strong>Participant %d</strong>\n\n', i);
    
    % congruent data ------------------------------------------------------
    cfg             = [];
    cfg.srcFolder   = strcat(desPath, '01c_pruned/');
    cfg.filename    = sprintf('LI_cong_p%02d_01c_pruned', i);
    cfg.sessionStr  = sessionStr;

    fprintf('Load pruned congruent data...\n\n');
    LI_loadData( cfg );

    % estimate power
    fprintf('<strong>Estimate pure power...</strong>\n');
    data_pow = LI_pow(data_pruned);
    
    % export power data in a *.mat file
    cfg             = [];
    cfg.desFolder   = strcat(desPath, '02a_pow/');
    cfg.filename    = sprintf('LI_cong_p%02d_02a_pow', i);
    cfg.sessionStr  = sessionStr;

    file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                       '.mat');

    fprintf('\nThe power data of participant %d in the congruent condition will be saved in:\n', i);
    fprintf('%s ...\n', file_path);
    LI_saveData(cfg, 'data_pow', data_pow);
    fprintf('Data stored!\n\n');
    clear data_pruned data_pow

    % incongruent data ----------------------------------------------------
    cfg             = [];
    cfg.srcFolder   = strcat(desPath, '01c_pruned/');
    cfg.filename    = sprintf('LI_incong_p%02d_01c_pruned', i);
    cfg.sessionStr  = sessionStr;

    fprintf('Load pruned incongruent data...\n\n');
    LI_loadData( cfg );
    
    % estimate power
    fprintf('<strong>Estimate pure power...</strong>\n');
    data_pow = LI_pow(data_pruned);
    
    % export power data in a *.mat file
    cfg             = [];
    cfg.desFolder   = strcat(desPath, '02a_pow/');
    cfg.filename    = sprintf('LI_incong_p%02d_02a_pow', i);
    cfg.sessionStr  = sessionStr;

    file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                       '.mat');

    fprintf('\nThe power data of participant %d in the incongruent condition will be saved in:\n', i);
    fprintf('%s ...\n', file_path);
    LI_saveData(cfg, 'data_pow', data_pow);
    fprintf('Data stored!\n\n');
    clear data_pruned data_pow
  end
end

%% power estimation using Welch's method %%%%%%%%%%%%%%%%%
choise = false;
while choise == false
  cprintf([0,0.6,0], 'Do you want to estimate power using Welch''s method?\n');
  x = input('Select [y/n]: ','s');
  if strcmp('y', x)
    choise = true;
    pwelch = true;
  elseif strcmp('n', x)
    choise = true;
    pwelch = false;
  else
    choise = false;
  end
end
fprintf('\n');

if pwelch == true
  for i = numOfPart
    fprintf('<strong>Participant %d</strong>\n\n', i);
    
    % congruent data ------------------------------------------------------
    cfg             = [];
    cfg.srcFolder   = strcat(desPath, '01c_pruned/');
    cfg.filename    = sprintf('LI_cong_p%02d_01c_pruned', i);
    cfg.sessionStr  = sessionStr;

    fprintf('Load pruned congruent data...\n\n');
    LI_loadData( cfg );

    % Segmentation of trials in segments of one second with 60 percent
    % overlapping
    cfg          = [];
    cfg.length   = 1;                                                       % window length: 1 sec       
    cfg.overlap  = 0.60;                                                    % 60 percent overlap
    
    data_pruned = LI_segmentation( cfg, data_pruned );
    
    % estimate power using Welch's method
    fprintf('<strong>Estimate power using Welch''s method...</strong>\n');
    data_pwelch = LI_pow(data_pruned);
    
    % export power data in a *.mat file
    cfg             = [];
    cfg.desFolder   = strcat(desPath, '02b_pwelch/');
    cfg.filename    = sprintf('LI_cong_p%02d_02b_pwelch', i);
    cfg.sessionStr  = sessionStr;

    file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                       '.mat');

    fprintf('\nThe pwelch data of participant %d in the congruent condition will be saved in:\n', i); 
    fprintf('%s ...\n', file_path);
    LI_saveData(cfg, 'data_pwelch', data_pwelch);
    fprintf('Data stored!\n\n');
    clear data_pruned data_pwelch
    
    % incongruent data ----------------------------------------------------
    cfg             = [];
    cfg.srcFolder   = strcat(desPath, '01c_pruned/');
    cfg.filename    = sprintf('LI_incong_p%02d_01c_pruned', i);
    cfg.sessionStr  = sessionStr;

    fprintf('Load pruned incongruent data...\n\n');
    LI_loadData( cfg );
    
    % Segmentation of trials in segments of one second with 60 percent
    % overlapping
    cfg          = [];
    cfg.length   = 1;                                                       % window length: 1 sec       
    cfg.overlap  = 0.60;                                                    % 60 percent overlap
    
    data_pruned = LI_segmentation( cfg, data_pruned );
    
    % estimate power using Welch's method
    fprintf('<strong>Estimate power using Welch''s method...</strong>\n');
    data_pwelch = LI_pow(data_pruned);
    
    % export power data in a *.mat file
    cfg             = [];
    cfg.desFolder   = strcat(desPath, '02b_pwelch/');
    cfg.filename    = sprintf('LI_incong_p%02d_02b_pwelch', i);
    cfg.sessionStr  = sessionStr;

    file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                       '.mat');

    fprintf('\nThe pwelch data of participant %d in the incongruent condition will be saved in:\n', i);
    fprintf('%s ...\n', file_path);
    LI_saveData(cfg, 'data_pwelch', data_pwelch);
    fprintf('Data stored!\n\n');
    clear data_pruned data_pwelch
  end
end

%% clear workspace
clear i cfg file_path pow pwelch choise x
