function LI_easyExtPowPlot(cfg)
% LI_EASYEXTPOWPLOT is a function, which makes it easier to plot the power
% of multiple participants in one graphik.
%
% Use as
%   LI_easyExtPowPlot(cfg)
%
% where the input data have to be a result from LI_POW.
%
% The configuration options are
%   cfg.sessionStr  = session string (default: '001')
%   cfg.condition   = options: 'cong' or 'incong' (default: 'cong')
%   cfg.freqrange   = frequency range [fmin fmax], (default: [0 50])
%   cfg.electrode   = number of electrodes (default: {'Cz'} repsectively [10])
%                     examples: {'Cz'}, {'F3', 'Fz', 'F4'}, [10] or [1, 3, 2]
%
% This function requires the fieldtrip toolbox
%
% See also LI_POW

% Copyright (C) 2018-2019, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Get config options
% -------------------------------------------------------------------------
sessionStr  = ft_getopt(cfg, 'sessionStr', '001');
condition   = ft_getopt(cfg, 'condition', 'cong');
freqrange   = ft_getopt(cfg, 'freqrange', [0 50]);
elec        = ft_getopt(cfg, 'electrode', {'Cz'});

switch condition
  case 'cong'
  case 'incong'
  otherwise
    error('cfg. condition has to be either ''cong'' or ''incong''');
end

% -------------------------------------------------------------------------
% Path settings
% -------------------------------------------------------------------------
clc;
fprintf('Select source folder from your data storage!\n');
selection = false;
srcPath = pwd;
while(selection == false)
  fprintf('Choose either 02a_pow or 02b_pwelch!\n\n');

  srcPath = uigetdir(srcPath, 'Select Source Folder...');
  if strcmp(computer, 'GLNXA64')
    srcPath = strcat(srcPath, '/');
  elseif strcmp(computer, 'PCWIN64')
    srcPath = strcat(srcPath, '\');
  end

  if strcmp(computer, 'GLNXA64')
    folderID = strsplit(srcPath,'/');
  elseif strcmp(computer, 'PCWIN64')
    folderID = strsplit(srcPath,'\');
  end
  folderID = folderID{end-1};

  switch folderID
    case '02a_pow'
      selection = true;
    case '02b_pwelch'
      selection = true;
    otherwise
      selection = false;
  end
end

fprintf('Select Participants...\n\n');
fileList     = dir([srcPath 'LI_' condition '_p*_' folderID '_' ...
                    sessionStr '.mat']);
fileList     = struct2cell(fileList);
fileList     = fileList(1,:);                                               % generate list with file names of all existing participants
numOfFiles   = length(fileList);

listOfPart = zeros(numOfFiles, 1);

for i = 1:1:numOfFiles
  listOfPart(i) = sscanf(fileList{i}, ['LI_' condition '_p%d_' folderID ... % generate a list of all available numbers of participants
                                        '_' sessionStr '.mat']);
end

listOfPartStr = num2cell(listOfPart);
listOfPartStr = cellfun(@(x) num2str(x), listOfPartStr, ...
                        'UniformOutput', false);
part = listdlg('ListString', listOfPartStr);                                % open the dialog window --> the user can select the participants of interest

fileList      = fileList(ismember(1:1:numOfFiles, part));                   % reduce file list to selection
listOfPart    = listOfPart(ismember(1:1:numOfFiles, part));
listOfPartStr = num2cell(listOfPart);
listOfPartStr = cellfun(@(x) num2str(x), listOfPartStr, ...
                        'UniformOutput', false);
numOfFiles    = length(fileList);                                           % estimate actual number of files (participants)

% -------------------------------------------------------------------------
% Check freqrange electrode 
% -------------------------------------------------------------------------
load([srcPath fileList{1}]);                                                %#ok<LOAD> % load data of first participant

datasetID = strsplit(folderID, '_');
datasetID = datasetID{end};

eval(['data =' sprintf('data_%s', datasetID) ';']);
eval(['clear ' sprintf('data_%s', datasetID)]);

begCol = find(data.freq >= freqrange(1), 1, 'first');                       % estimate desired powspctrm colums
endCol = find(data.freq <= freqrange(2), 1, 'last');

label     = data.label;                                                     % get labels 
if isnumeric(elec)                                                          % check cfg.electrode
  for i=1:length(elec)
    if elec(i) < 1 || elec(i) > 32
      error('cfg.elec has to be a numbers between 1 and 32 or a existing labels like {''Cz''}.');
    end
  end
else
  tmpElec = zeros(1, length(elec));
  for i=1:length(elec)
    tmpElec(i) = find(strcmp(label, elec{i}));
    if isempty(tmpElec(i))
      error('cfg.elec has to be a cell array of existing labels like ''Cz''or a vector of numbers between 1 and 32.');
    end
  end
  elec = tmpElec;
end

labelString = strjoin(data.label(elec), ',');

% -------------------------------------------------------------------------
% Plot power
% -------------------------------------------------------------------------
fprintf('Plot signals...\n');
figure();
if length(elec) == 1
  title(sprintf('%s - %s - %s', datasetID, condition, labelString));
else
  title(sprintf('%s - %s - %s (averaged)', datasetID, condition, labelString));
end
xlabel('frequency in Hz');                                                  % set xlabel
ylabel('power in \muV^2');                                                  % set ylabel
hold on;

f = waitbar(0,'Please wait...');

for i = 1:1:numOfFiles
  load([srcPath fileList{i}]);                                              %#ok<LOAD>
  waitbar(i/numOfFiles, f, 'Please wait...');
  eval(['data =' sprintf('data_%s', datasetID) ';']);
  eval(['clear ' sprintf('data_%s', datasetID)]);
  
  plot(data.freq(begCol:endCol), mean(data.powspctrm(elec, begCol:endCol),1));

  clear data
end

close(f);                                                                   % close waitbar
legend(listOfPartStr);                                                      % add legend

end
