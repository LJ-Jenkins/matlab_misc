function varargout = nxtile(row,col,span,grid,g)
%
% plt.nxtile - calls nexttile() using a row,col positional input as opposed to a scalar. 
%                  Set up rigidly with positional arguments (aka each input arg requires the one/s prior, except the name-value 'onlygrid') 
%                  as if not giving a row,col positional input then there would be no benefit over base nexttile,
%                  however calling nxtile with no inputs functions the same as nexttile with no inputs.
%
% Inputs:
%   row - row position of target tile
%   col - col position of target tile
%   span - a vector of the form [r c] (default [1,1]). The axes spans r rows by c columns of tiles. 
%          The upper left corner of the axes is positioned by row,col
%   grid - TiledChartLayout object (default uses gcf.Children to access tiles object, will fail if multiple children)
% -name-value arguments-
%   'onlygrid' - specify 'y' to ignore all nexttile calls and give only the grid output (*this switches the grid output to the first position!*)
% Outputs (in order) (*unless 'onlygrid','y' is specified! then positions are switched*):
%   1st - axes object 
%   2nd - grid that matches the TiledLayout grid with matching indexes (just in case you wanted)...

% Luke Jenkins Apr 2023
% L.Jenkins@soton.ac.uk

arguments
    row (1,1) double = [nan]
    col (1,1) double = [nan]
    span (1,2) double = [1,1]
    grid = matlab.graphics.layout.TiledChartLayout.empty
    g.onlygrid (1,1) char {mustBeMember(g.onlygrid,{'y'})}
end

% ax = gca;
% grid = ax.Parent;
if isempty(grid)
    cf = gcf;
    grid = cf.Children;
end
if ~isfield(g,'onlygrid')
    if isempty(row) && isempty(col)
        tile = nexttile(grid,span);
    elseif ~isempty(row) && ~isempty(col)
        tile = nexttile(grid,sub2ind([grid.GridSize(2) grid.GridSize(1)],col,row),span);
        % alternative is: pos = grid(2)*row - (grid(2) - col)
    else
        error("Row and column inputs must both be provided or neither provided")
    end
end
if nargout > 0
    varargout{1} = reshape(1:grid.GridSize(1)*grid.GridSize(2),grid.GridSize(2),grid.GridSize(1)).';
    if ~isfield(g,'onlygrid')
        varargout{2} = tile;
        varargout = fliplr(varargout);
    end
end

% fini