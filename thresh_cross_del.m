function [var_tcd] = thresh_cross_del(var,threshold)
%
% thresh_cross_del - for every group of consecutive values over a threshold, all but the max in the group are deleted (made nan)
%
% Inputs:
%   var - data for the calculation
%   threshold - threshold to calculate groups from
%
% Outputs:
%   var_tcd - variable with group data deleted bar the max values

% Luke Jenkins Feb 2023
% L.Jenkins@soton.ac.uk

arguments
    var (:,1) double 
    threshold (:,1) double
end

groups = regionprops(var > threshold,var, 'Area', 'PixelValues'); % get groups of above threshold
j = find(var > threshold); % indices

% min index of group is gszi + 1
% target index of max is gmxi
% max index of group is gszi + groups(i).Area
gszi = 0;
for i = 1:height(groups)
    if i == 1
        [~,gmxi] = max(groups(i).PixelValues);
        var(j(1:gmxi - 1)) = nan;
        var(j(gmxi + 1:groups(i).Area)) = nan;
    else
        if groups(i).Area == 1
            gszi = gszi + groups(i-1).Area;
        else
            gszi = gszi + groups(i-1).Area;
            [~,gmxi] = max(groups(i).PixelValues); % max of each group
            var(j(gszi + 1:gszi + gmxi - 1)) = nan; % indexes before
            var(j(gszi + gmxi + 1:gszi + groups(i).Area)) = nan; % indexes after
        end
    end
end
var_tcd = var;

% fini