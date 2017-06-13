function data = importfile1(workbookFile, sheetName, range)
%IMPORTFILE1 Import data from a spreadsheet
%   DATA = IMPORTFILE1(FILE) reads data from the first worksheet in the
%   Microsoft Excel spreadsheet file named FILE and returns the data as a
%   cell array.
%
%   DATA = IMPORTFILE1(FILE,SHEET) reads from the specified worksheet.
%
%   DATA = IMPORTFILE1(FILE,SHEET,RANGE) reads from the specified worksheet
%   and from the specified RANGE. Specify RANGE using the syntax
%   'C1:C2',where C1 and C2 are opposing corners of the region.%
% Example:
%   TradefinalS13 = importfile1('Trade final.xlsx','Trade 2016','A42:A68');
%
%   See also XLSREAD.

% Auto-generated by MATLAB on 2017/05/22 21:28:13

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If no range is specified, read all data
if nargin <= 2 || isempty(range)
    range = '';
end

%% Import the data
[~, ~, data] = xlsread(workbookFile, sheetName, range);
data(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),data)) = {''};

