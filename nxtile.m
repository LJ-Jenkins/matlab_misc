function varargout = nxtile(varargin)
    %
    % nxtile - Flexible use of nexttile(). Accepts index or row,col for tile position as well as/or span inputs and target tiled layout.
    %          grid will expand automatically onto a new figure if the index or row,col is out of bounds, and will close the old figure.
    %
    % Inputs:
    %   index (1,1) - index position of target tile
    % or:
    %   row (1,1) double - row position of target tile
    %   col (1,1) double - col position of target tile
    %   span - a (1,2) double of the form [r c] (default [1,1]). The axes spans r rows by c columns of tiles. 
    %          The upper left corner of the axes is positioned by row,col
    %   grid - TiledChartLayout object (default uses gcf.Children to access tiles object, will fail if multiple children)
    % Outputs (in order):
    %   1st - axes object 
    %   2nd - grid that matches the TiledLayout grid with matching indexes (just in case you wanted)...
    
    % Luke Jenkins Apr 2024
    % L.Jenkins@soton.ac.uk
    % Credit: Adam Danz for information on copying axis to new figure and grid
    % (https://uk.mathworks.com/matlabcentral/answers/849060-change-gridsize-of-existing-non-empty-tiledchartlayout-object)
    
    grid = matlab.graphics.layout.TiledChartLayout.empty;
    index = nan;
    row = nan;
    col = nan;
    nxtilein = cell(1,3);
    nxtilein{3} = [1,1]; % span

    if nargin > 0
        i = find(cellfun(@(x) isnumeric(x) && numel(x) > 1, varargin));
        if ~isempty(i)
            if numel(i) > 1
                error("Only one span input is allowed")
            end
            nxtilein{3} = varargin{i};
            varargin(i) = [];
        end
        i = find(cellfun(@(x) isnumeric(x) && numel(x) == 1, varargin));
        if ~isempty(i)
            if numel(i) > 2
                error("Only one index or two row and column inputs are allowed")
            end
            if numel(i) == 1
                index = varargin{i};
                nxtilein{2} = index;
            else
                row = varargin{i(1)};
                col = varargin{i(2)};
            end
            varargin(i) = [];
        end
        i = find(cellfun(@(x) isa(x,'matlab.graphics.layout.TiledChartLayout'), varargin));
        if ~isempty(i)
            if numel(i) > 2
                error("Only one TiledChartLayout input is allowed")
            end
            grid = varargin{i};
            varargin(i) = [];
            nxtilein{1} = grid;
        end
    end

    if isempty(grid)
        cf = gcf;
        grid = cf.Children;
    end
    gs = grid.GridSize;
    if row > gs(1) || col > gs(2)
        gs = copyfignewgrid('sub',gs);
    elseif index > gs(1) * gs(2)
        gs = copyfignewgrid('ind',gs);
    end
    if ~isnan(row) && ~isnan(col)
        nxtilein{2} = (row - 1) * gs(2) + col;
    end
    nxtilein = nxtilein(~cellfun('isempty',nxtilein));

    tile = nexttile(nxtilein{:});

    if nargout > 0
        varargout{1} = tile;
        varargout{2} = reshape(1:gs(1)*gs(2),gs(2),gs(1)).';
    end

    function [gs] = copyfignewgrid(ind_or_sub,gs)
        ax = flip(findobj(cf,'type','axes'));
        nf = figure('Position',cf.Position);
        if nxtilein{3}(1) > 1; row_offset = nxtilein{3}(1) - 1; else; row_offset = 0; end
        if nxtilein{3}(2) > 1; col_offset = nxtilein{3}(2) - 1; else; col_offset = 0; end
        if strcmpi(ind_or_sub,'sub')
            tlo = tiledlayout(nf,max([row,gs(1)]) + row_offset,max([col,gs(2)]) + col_offset);
        elseif strcmpi(ind_or_sub,'ind')
            grd = zeros(gs(1),gs(2));
            found = false;
            while ~found
                grd = [grd; zeros(1, size(grd, 2))];
                if numel(grd) >= index
                    break;
                end
                grd = [grd, zeros(size(grd, 1), 1)];
                if numel(grd) >= index
                    break;
                end
            end
            gs = size(grd);
            [r,c] = deal(ceil(index / gs(2)), mod(index- 1, gs(2)) + 1);
            col_diff = (c + col_offset + 1) - gs(2);
            if col_diff < 0
                col_diff = 0;
            end
            row_diff = (r + row_offset + 1) - gs(1);
            if row_diff < 0
                row_diff = 0;
            end
            tlo = tiledlayout(nf,gs(1) + row_diff,gs(2) + col_diff);
        end
        tpos = nan(length(ax),2);
        for j = 1:length(ax)
            tpos(j,:) = [ceil(tilenum(ax(j)) / gs(2)), mod(tilenum(ax(j)) - 1, gs(2)) + 1];
        end
        gs = tlo.GridSize;
        newax = gobjects(gs);
        tempax = gobjects(size(ax));
        for j = 1:numel(ax)
            tempax(j) = nexttile((tpos(j,1) - 1) * gs(2) + tpos(j,2));
            newax(j) = copyobj(ax(j),nf);
            set(newax(j), 'units', tempax(j).Units, 'Position', tempax(j).Position)
            tempax(j).Visible = 'off';
        end
        close(cf)
    end
end

% fini