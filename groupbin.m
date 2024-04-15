function groupbin_var = groupbin(var,binvals,nv)
%
% groupbin - bin data into groups specified by binvals, with option to make percentiles
%
% Inputs:
%   var - data
%   binvals - bin edges
% -name value arguments-
%   'prcntile' - 'y' to make the binvals percentiles of the data
%
% Outputs (in order):
%   groupbin_var - matching length array as var with groups

% Luke Jenkins May 2023
% L.Jenkins@soton.ac.uk

arguments
    var (:,1) double
    binvals (1,:) double
    nv.prcntile (1,1) char {mustBeMember(nv.prcntile,{'y','n'})} = 'n'
end

if nv.prcntile == 'y'
    binvals = prctile(var,binvals);
end
i = var > binvals;
i = double(i);
if width(i) > 1
    i = [i(:,1) == 0 i];
    for j = 2:width(i)-1
        ix = i(:,j) == 1 & i(:,j+1) == 1;
        i(ix,j) = 0;
    end
    for j = 1:width(i)
        i(i(:,j) == 1,j) = j;
    end
else
    i(i == 1) = 2;
    i(i == 0) = 1;
end
groupbin_var = sum(i,2);

% fini