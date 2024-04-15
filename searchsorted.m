function indices = searchsorted(x, values, nv)
% Finds indices in sorted vector x where values would be inserted to maintain sorted order.
% in style of numpy searchsorted
% e.g., side='left':  x = [1, 3, 5, 5, 7], values = [2, 5, 7] -> indices = [2, 3, 5]
%       side='right': x = [1, 3, 5, 5, 7], values = [2, 5, 7] -> indices = [2, 4, 5]
%
% Input:
%   x - A vector of sorted values from low to high.
%   values - Array of values to find indices for.
%
% Name-Value Pair Arguments:
%   side - Side to insert values. 'left' (default) or 'right'.
%   sortfirst - If true, x is sorted before searching. Default is false.
%
% Output:
%   indices - Indices where values would be inserted into x.

% Credit: DrGar
% (https://stackoverflow.com/questions/20166847/faster-version-of-find-for-sorted-vectors-matlab)
% Amended by Luke Jenkins, Apr 2024

arguments
    x double
    values double
    nv.side char {mustBeMember(nv.side, {'left', 'right'})} = 'left'
    nv.sortfirst logical = false
end

if nv.sortfirst
    x = sort(x);
end

% Initialize variables
lower_index_a = 1;
lower_index_b = length(x);

upper_index_a = 1;
upper_index_b = length(x);

indices = zeros(size(values));

% Determine the lower and upper bound conditions based on side
switch nv.side
case 'left'
    lower_cond = @(lw,LowerBound) x(lw) >= LowerBound;
    upper_cond = @(up,UpperBound) x(up) > UpperBound;
case 'right'
    lower_cond = @(lw,LowerBound) x(lw) > LowerBound;
    upper_cond = @(up,UpperBound) x(up) >= UpperBound;
end

% Binary search to find indices
for i = 1:length(values)
    LowerBound = values(i);

    % Find lower bound index
    while lower_index_a + 1 < lower_index_b
        lw = floor((lower_index_a + lower_index_b) / 2);
        
        if lower_cond(lw, LowerBound)
            lower_index_b = lw;
        else
            lower_index_a = lw;
            if lw > upper_index_a && lw < upper_index_b
                upper_index_a = lw;
            end
        end
    end

    % Set upper bound if it wasn't set by lower bound
    if upper_index_a == 1
        upper_index_a = lower_index_b;
    end

    UpperBound = x(upper_index_a);

    % Find upper bound index
    while upper_index_a + 1 < upper_index_b
        up = ceil((upper_index_a + upper_index_b) / 2);
        
        if upper_cond(up, UpperBound)
            upper_index_a = up;
        else
            upper_index_b = up;
            if up < lower_index_b && up > lower_index_a
                lower_index_b = up;
            end
        end
    end

    % Set lower bound index
    if x(lower_index_a) >= LowerBound
        lower_index = lower_index_a;
    else
        lower_index = lower_index_b;
    end

    % Set upper bound index
    if x(upper_index_b) <= UpperBound
        upper_index = upper_index_b;
    else
        upper_index = upper_index_a;
    end

    indices(i) = lower_index;

    % Reset indices for next iteration
    lower_index_a = 1;
    lower_index_b = length(x);
    upper_index_a = 1;
    upper_index_b = length(x);
end

end

% fini