function LI_exportPowspctrm( data )
% LI_EXPORTPOWSPCTRM exports power spectrum tables into excel spreadsheets.
%
% Use as
%   LI_exportPowspctrm( data )
%
% where the input data have to be a result of LI_POW.
%
% This function requires the fieldtrip toolbox
%
% See also LI_POW

% Copyright (C) 2018-2019, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Get and check input data
% -------------------------------------------------------------------------
powspctrm   = ft_getopt(data, 'powspctrm', []);

if isempty(powspctrm)
  error('Wrong dataset! The selected one has no field powspctrm');
end

% -------------------------------------------------------------------------
% Select file destination
% -------------------------------------------------------------------------
[file, filepath] = uiputfile('powspctrm.xls');
filepath = [filepath file];

% -------------------------------------------------------------------------
% Create and save table
% -------------------------------------------------------------------------
powspctrm = num2cell(data.powspctrm');
freq      = num2cell(data.freq');
table     = [freq powspctrm];
table     = cell2table(table);
table.Properties.VariableNames =  [{'freq'} data.label'];
writetable(table, filepath);

end
