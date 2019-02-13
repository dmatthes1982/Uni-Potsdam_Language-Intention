if ~exist('sessionStr', 'var')
  cfg           = [];
  cfg.subFolder = '03d_pwelch_avgpow7to9/';
  cfg.filename  = 'LI_incong_p30_03d_pwelch_avgpow7to9';
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
  sourceList    = dir([strcat(desPath, '03d_pwelch_avgpow7to9/'), ...
                       strcat('LI_incong*_', sessionStr, '.mat')]);
  sourceList    = struct2cell(sourceList);
  sourceList    = sourceList(1,:);
  numOfSources  = length(sourceList);
  numOfPart     = zeros(1, numOfSources);

  for i=1:1:numOfSources
    numOfPart(i)  = sscanf(sourceList{i}, ...
                    strcat('LI_incong_p%d_03d_pwelch_avgpow7to9_', sessionStr, '.mat'));
  end
  numOfPart = sort(numOfPart);
end

%% part 4
% 1. select specific results
% 2. load and structure data
% 3. do repeated measures ANOVA (rmANOVA)

cprintf([0,0.6,0], '<strong>[4] - Repeated measures ANOVA (rmANOVA)</strong>\n');
fprintf('\n');

%% select specific datasets %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

selection = false;
while selection == false
  cprintf([0,0.6,0], 'Which result do you want to use for the analysis:\n');
  fprintf('[1] - Power result in a range from 6 to 9 Hz\n');
  fprintf('[2] - pWelch result in a range from 6 to 9 Hz\n');
  fprintf('[3] - Power result in a range from 7 to 9 Hz\n');
  fprintf('[4] - pWelch result in a range from 7 to 9 Hz\n');
  x = input('Option: ');

  switch x
    case 1
      selection = true;
      filename = '03a_pow_avgpow6to9';
    case 2
      selection = true;
      filename = '03b_pwelch_avgpow6to9';
    case 3
      selection = true;
      filename = '03c_pow_avgpow7to9';
    case 4
      selection = true;
      filename = '03d_pwelch_avgpow7to9';
    otherwise
      cprintf([1,0.5,0], 'Wrong input!\n');
  end
end
fprintf('\n');

%% load and structure data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_cong   = cell(1, length(numOfPart));
data_incong = cell(1, length(numOfPart));

for i = 1:1:length(numOfPart)
  fprintf('<strong>Participant %d</strong>\n', numOfPart(i));
  % congruent data --------------------------------------------------------
  cfg             = [];
  cfg.srcFolder   = strcat(desPath, filename, '/');
  cfg.filename    = sprintf('LI_cong_p%02d_%s', numOfPart(i), filename);
  cfg.sessionStr  = sessionStr;

  fprintf('Load congruent data...\n');
  LI_loadData( cfg );
  
  if exist('data_powavg', 'var')
    data_cong{i} = data_powavg;
  elseif exist('data_pwelchavg', 'var') 
    data_cong{i} = data_pwelchavg;
  end   
  
  % incongruent data ------------------------------------------------------
  cfg             = [];
  cfg.srcFolder   = strcat(desPath, filename, '/');
  cfg.filename    = sprintf('LI_incong_p%02d_%s', numOfPart(i), filename);
  cfg.sessionStr  = sessionStr;

  fprintf('Load incongruent data...\n');
  LI_loadData( cfg );
  
  if exist('data_powavg', 'var')
    data_incong{i} = data_powavg;
  elseif exist('data_pwelchavg', 'var') 
    data_incong{i} = data_pwelchavg;
  end
  
end

clear data_powavg data_pwelchavg

%% do repeated measures ANOVA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cprintf([0,0.6,0], '\nMake your channel selection in curly brackets.\n');
cprintf([0,0.6,0], 'Here is an example which includes all possible mixtures: ''C3'',''P*'',''*4'',''F3+F4''\n');
cprintf([0,0.6,0], ['If you press just enter, the default setting:\n' ... 
                    '{''F3'',''F4'',''Fz'',''C3'',''C4'',''Cz'',''P3'',''P4'',''Pz''} will be used\n\n']);
    
x = input('Selection: ');
fprintf('\n');

cfg           = [];
cfg.numOfPart = numOfPart;
cfg.ident     = filename;
if ~isempty(x)
  cfg.channel   = x;
end

fprintf('<strong>Run repeated measures analysis of variance with selected datasets...\n</strong>');
data_rmanova  = LI_rmAnova(cfg, data_cong, data_incong);

% export ANOVA results into *.mat files
cfg             = [];
cfg.desFolder   = strcat(desPath, '04_rmanova/');
cfg.filename    = 'LI_04_rmanova';
cfg.sessionStr  = sessionStr;

file_path = strcat(cfg.desFolder, cfg.filename, '_', cfg.sessionStr, ...
                   '.mat');

fprintf('The result of the repeated measures ANOVA will be saved in:\n');
fprintf('%s ...\n', file_path);
LI_saveData(cfg, 'data_rmanova', data_rmanova);
fprintf('Data stored!\n\n');
clear data_rmanova data_cong data_incong

%% clear workspace
clear i cfg file_path selection filename x
