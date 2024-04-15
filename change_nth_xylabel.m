function change_nth_xylabel(n,x_or_y,label_replacement,nv)
%
% plt.change_nth_xylabel - removes the nth x or y label and replaces it with a specified label
%                          on an open axis
%
% Inputs:
%   n - the position of the label to be replaced
%   x_or_y - 'x' or 'y' to specify which axis to remove the label from
%   label_replacement - the label to replace the nth label with
% -name-value arguments-
%   'formatSpec' - the format specifier for the tick labels (default is '%g')
%

% Luke Jenkins Apr 2024
% L.Jenkins@soton.ac.uk

arguments
    n (1,1) double
    x_or_y (1,1) char {mustBeMember(x_or_y,{'x','y'})}
    label_replacement
    nv.formatSpec char {mustBeMember(nv.formatSpec,{'%d','%i','%u','%o','%x','%X','%f','%e','%E','%g','%G','%c','%s'})} = '%g'
end

if ~isstring(label_replacement); label_replacement=string(label_replacement); end
switch x_or_y
    case 'x'
        tcks=xticks;
    case 'y'
        tcks=yticks;
end
if n == 1
    tcks=[{label_replacement} compose(nv.formatSpec,tcks(2:end))];
elseif n == length(tcks)
    tcks=[compose(nv.formatSpec,tcks(1:end-1)) {label_replacement}];
else
    tcks=[compose(nv.formatSpec,tcks(1:n-1)) {label_replacement} compose(nv.formatSpec,tcks(n+1:end))];
end

set(gca,[x_or_y,'TickLabel'],tcks)

% fini