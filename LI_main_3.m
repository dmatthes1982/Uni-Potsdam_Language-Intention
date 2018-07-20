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
  desPath = ['/data/tu_dmatthes_cloud/LanguageIntention/'...                % destination path for processed data
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

%% part 3
% 1. estimate power average in the range from 6 to 9 Hz using data_psd
% 3. estimate power average in the range from 6 to 9 Hz using data_pwelch
% 2. estimate power average in the range from 7 to 9 Hz using data_psd
% 4. estimate power average in the range from 7 to 9 Hz using data_pwelch

cprintf([0,0.6,0], '<strong>[3] - Averaging power over frequencies</strong>\n');
fprintf('\n');

%% estimate power average %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = numOfPart
  fprintf('<strong>Participant %d</strong>\n\n', i);
  
  % congruent data --------------------------------------------------------
  cfg             = [];
  cfg.srcFolder   = strcat(desPath, '02a_psd/');
  cfg.filename    = sprintf('LI_cong_p%02d_02a_psd', i);
  cfg.sessionStr  = sessionStr;

  fprintf('Load congruent psd data...\n');
  LI_loadData( cfg );
  
  cfg             = [];
  cfg.srcFolder   = strcat(desPath, '02b_pwelch/');
  cfg.filename    = sprintf('LI_cong_p%02d_02b_pwelch', i);
  cfg.sessionStr  = sessionStr;

  fprintf('Load congruent pwelch data...\n\n');
  LI_loadData( cfg );
  
  % estimate power average in the range from 6 to 9 Hz
  fprintf('<strong>Estimate power average in the range from 6 to 9 Hz...</strong>\n');
  cfg           = [];
  cfg.freqrange = [5.7 9.3];
  
  data_psdavg     = LI_powerAverage(cfg, data_psd);
  data_pwelchavg  = LI_powerAverage(cfg, data_pwelch);
  
  % export averaged data into *.mat files
  cfg             = [];
  cfg.desFolder   = strcat(desPath, '03a_psd_avgpow6to9/');
  cfg.filename    = sprintf('LI_cong_p%02d_03a_psd_avgpow6to9', i);
  cfg.sessionStr  = sessionStr;

  file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                     '.mat');

  fprintf('\nThe averaged power (data_psd, 6-9 Hz) of participant %d in the congruent condition will be saved in:\n', i); 
  fprintf('%s ...\n', file_path);
  LI_saveData(cfg, 'data_psdavg', data_psdavg);
  fprintf('Data stored!\n');
  clear data_psdavg
  
  cfg             = [];
  cfg.desFolder   = strcat(desPath, '03b_pwelch_avgpow6to9/');
  cfg.filename    = sprintf('LI_cong_p%02d_03b_pwelch_avgpow6to9', i);
  cfg.sessionStr  = sessionStr;

  file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                     '.mat');

  fprintf('The averaged power (data_pwelch, 6-9 Hz) of participant %d in the congruent condition will be saved in:\n', i); 
  fprintf('%s ...\n', file_path);
  LI_saveData(cfg, 'data_pwelchavg', data_pwelchavg);
  fprintf('Data stored!\n\n');
  clear data_pwelchavg
  
  % estimate power average in the range from 7 to 9 Hz
  fprintf('<strong>Estimate power average in the range from 7 to 9 Hz...</strong>\n');
  cfg           = [];
  cfg.freqrange = [7 9.3];
  
  data_psdavg     = LI_powerAverage(cfg, data_psd);
  data_pwelchavg  = LI_powerAverage(cfg, data_pwelch);
  
  % export averaged data into *.mat files
  cfg             = [];
  cfg.desFolder   = strcat(desPath, '03c_psd_avgpow7to9/');
  cfg.filename    = sprintf('LI_cong_p%02d_03c_psd_avgpow7to9', i);
  cfg.sessionStr  = sessionStr;

  file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                     '.mat');

  fprintf('\nThe averaged power (data_psd, 7-9 Hz) of participant %d in the congruent condition will be saved in:\n', i); 
  fprintf('%s ...\n', file_path);
  LI_saveData(cfg, 'data_psdavg', data_psdavg);
  fprintf('Data stored!\n');
  clear data_psdavg data_psd
  
  cfg             = [];
  cfg.desFolder   = strcat(desPath, '03d_pwelch_avgpow7to9/');
  cfg.filename    = sprintf('LI_cong_p%02d_03d_pwelch_avgpow7to9', i);
  cfg.sessionStr  = sessionStr;

  file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                     '.mat');

  fprintf('The averaged power (data_pwelch, 7-9 Hz) of participant %d in the congruent condition will be saved in:\n', i); 
  fprintf('%s ...\n', file_path);
  LI_saveData(cfg, 'data_pwelchavg', data_pwelchavg);
  fprintf('Data stored!\n\n');
  clear data_pwelchavg data_pwelch 
  
  % incongruent data --------------------------------------------------------
  cfg             = [];
  cfg.srcFolder   = strcat(desPath, '02a_psd/');
  cfg.filename    = sprintf('LI_incong_p%02d_02a_psd', i);
  cfg.sessionStr  = sessionStr;

  fprintf('Load incongruent psd data...\n');
  LI_loadData( cfg );
  
  cfg             = [];
  cfg.srcFolder   = strcat(desPath, '02b_pwelch/');
  cfg.filename    = sprintf('LI_incong_p%02d_02b_pwelch', i);
  cfg.sessionStr  = sessionStr;

  fprintf('Load incongruent pwelch data...\n\n');
  LI_loadData( cfg );
  
  % estimate power average in the range from 6 to 9 Hz
  fprintf('<strong>Estimate power average in the range from 6 to 9 Hz...</strong>\n');
  cfg           = [];
  cfg.freqrange = [5.7 9.3];
  
  data_psdavg     = LI_powerAverage(cfg, data_psd);
  data_pwelchavg  = LI_powerAverage(cfg, data_pwelch);
  
  % export averaged data into *.mat files
  cfg             = [];
  cfg.desFolder   = strcat(desPath, '03a_psd_avgpow6to9/');
  cfg.filename    = sprintf('LI_incong_p%02d_03a_psd_avgpow6to9', i);
  cfg.sessionStr  = sessionStr;

  file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                     '.mat');

  fprintf('\nThe averaged power (data_psd, 6-9 Hz) of participant %d in the incongruent condition will be saved in:\n', i); 
  fprintf('%s ...\n', file_path);
  LI_saveData(cfg, 'data_psdavg', data_psdavg);
  fprintf('Data stored!\n');
  clear data_psdavg
  
  cfg             = [];
  cfg.desFolder   = strcat(desPath, '03b_pwelch_avgpow6to9/');
  cfg.filename    = sprintf('LI_incong_p%02d_03b_pwelch_avgpow6to9', i);
  cfg.sessionStr  = sessionStr;

  file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                     '.mat');

  fprintf('\nThe averaged power (data_pwelch, 6-9 Hz) of participant %d in the incongruent condition will be saved in:\n', i); 
  fprintf('%s ...\n', file_path);
  LI_saveData(cfg, 'data_pwelchavg', data_pwelchavg);
  fprintf('Data stored!\n\n');
  clear data_pwelchavg
  
  % estimate power average in the range from 7 to 9 Hz
  fprintf('<strong>Estimate power average in the range from 7 to 9 Hz...</strong>\n');
  cfg           = [];
  cfg.freqrange = [7 9.3];
  
  data_psdavg     = LI_powerAverage(cfg, data_psd);
  data_pwelchavg  = LI_powerAverage(cfg, data_pwelch);
  
  % export averaged data into *.mat files
  cfg             = [];
  cfg.desFolder   = strcat(desPath, '03c_psd_avgpow7to9/');
  cfg.filename    = sprintf('LI_incong_p%02d_03c_psd_avgpow7to9', i);
  cfg.sessionStr  = sessionStr;

  file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                     '.mat');

  fprintf('\nThe averaged power (data_psd, 7-9 Hz) of participant %d in the incongruent condition will be saved in:\n', i); 
  fprintf('%s ...\n', file_path);
  LI_saveData(cfg, 'data_psdavg', data_psdavg);
  fprintf('Data stored!\n');
  clear data_psdavg data_psd
  
  cfg             = [];
  cfg.desFolder   = strcat(desPath, '03d_pwelch_avgpow7to9/');
  cfg.filename    = sprintf('LI_incong_p%02d_03d_pwelch_avgpow7to9', i);
  cfg.sessionStr  = sessionStr;

  file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                     '.mat');

  fprintf('The averaged power (data_pwelch, 7-9 Hz) of participant %d in the incongruent condition will be saved in:\n', i); 
  fprintf('%s ...\n', file_path);
  LI_saveData(cfg, 'data_pwelchavg', data_pwelchavg);
  fprintf('Data stored!\n\n');
  clear data_pwelchavg data_pwelch
end

%% clear workspace
clear i cfg file_path
