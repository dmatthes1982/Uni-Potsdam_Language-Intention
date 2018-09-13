function [ channel, chnNum ] = LI_channelselection( channel, label )
% LI_CHANNELSELECTION makes a selection of EEG labels. This function 
% translates the user-specified list of channels into channel numbers as 
% they occur in the data.
%
% You can specify a mixture of real channel labels and of special strings.
% For example, the following selection {'C3', 'P*', '*4', 'F3+F4'} says:
%   channel 1: C3
%   channel 2: the average of all parietal channels
%   channel 3: the average of all channels with number 4
%   channel 4: the average of F3 and F4
%
% Note: Definitions like F*+C* are not supported!

% Copyright (C) 2018, Daniel Matthes, MPI CBS


channel = unique(channel);                                                  % remove duplicates
numChan = length(channel);                                                  % calculate number of channels
chnNum{numChan} = [];                                                       % allocate output cell array

starlets = strfind(channel, '*');                                           % find all starlets
channel = erase(channel, '*');                                              % remove all starlets in the channel name vector
plus = strfind(channel, '+');                                               % find all plus signs

for i=1:1:numChan
  if ~isempty(starlets{i}) && ~isempty(plus{i})                             % throw an error if a certain channel consists of startlets and plus signs
    error('Use either * or + in channel definition. Definitions like F*+C* are not supported');
  elseif isempty(starlets{i}) && isempty(plus{i})                           % if channel has neigther starlets nor plus signs
    num = find(strcmp(label, channel{i}));
    if ~isempty(num)
      chnNum{i} = num;
    else
      error('%s is not available in data', channel{i});                     % throw an error if the certain channel was not found
    end
  elseif ~isempty(starlets{i})                                              % if channel includes a starlet
    if starlets{i} == 1                                                     % if starlet is at first position
      num = find(~cellfun('isempty',(strfind(label, channel{i}))));
      if ~isempty(num)
        chnNum{i} = num';
      else
        error('No channel with number/letter %s is in data', channel{i});   % throw an error if no channel was not found    
      end
    else                                                                    % if startlet is not at the first position
      num = find(startsWith(label, channel{i}));
      if strlength(channel{i}) == 1                                         % if starlet is at the second position
        switch channel{i}                                                   % search for false friends
          case 'F'
            wrongNum = find(startsWith(label, 'FC'));
          case 'C'
            wrongNum = find(startsWith(label, 'CP'));
          otherwise
            wrongNum = [];
        end
      else
        wrongNum = [];
      end
      num = num(~ismember(num, wrongNum));                                  % remove false friends
      if ~isempty(num)
        chnNum{i} = num';
      else
        error('No channel starts with letter %s', channel{i});              % throw an error if no channel was not found  
      end
    end
  elseif ~isempty(plus{i})                                                  % if channel includes a plus sign
    channel{i} = strsplit(channel{i}, '+');
    numOfElements = length(channel{i});
    num = zeros(1, numOfElements);
    
    for j=1:1:numOfElements
      tmp = find(strcmp(label, channel{i}{j}));
      if ~isempty(tmp)
        num(j) = tmp;
      else
        error('%s is not available in data', channel{i}{j});                % throw an error if a certain channel was not found 
      end
    end
    
    chnNum{i} = num;
    tmp = [];
    for j=1:1:numOfElements
      tmp=strcat(tmp,channel{i}{j});
    end
    channel{i} = tmp;
  end
end
