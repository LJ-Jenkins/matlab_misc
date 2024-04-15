function varargout=fnames(directory,nv)
%
% fnames - gets the file and folder names within a directory
%
% Inputs:
%   directory - directory containing the files/folders
% -name-value arguments-
%   'contains' - (optional) string to filter the file names
%   'erase' - (optional) string to erase from the file names
%
% Outputs (in order):
%   files - names of the file/s
%   folders - names of the folder/s

% Luke Jenkins Jan 2024
% L.Jenkins@soton.ac.uk

arguments
    directory (1,1) string
    nv.erase (1,1) string
end

d = dir(directory);
files = string(extractfield(d,'name'));
id = cell2mat(extractfield(d,'isdir'));
j = ismember(files,[".",".."]);
files(j) = []; 
id(j) = []; 
folders = files(id);
files(id) = [];
if isfield(nv,'contains')
    files = files(contains(files,nv.contains));
end
if isfield(nv,'erase')
    files = erase(files,nv.erase);
end
varargout{1} = files;
varargout{2} = folders;

% fini