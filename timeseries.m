function [varargout] = timeseries(times,var,line_clr,labels)
%
% plt.timeseries - plots variables and their associated times, arguments
%                  are repeating so for multiple plots use the syntax:
%                  plot.timeseries(var1,times1,line_clr1,labels1,var2,times2,line_clr2,labels2,etc...)
%
% Inputs:
%   times - times of type datetime
%   var - variables of type double
%   line_clr - colour of each line, either Matlab full name, short name,
%              RGB triplet, or Hex code
%   labels - string array of ylabel and title
%
% Outputs (in order):
%   1st - cell array of axes objects (tile by tile)
%   2nd - cell array of line objects (tile by tile)

% Luke Jenkins Feb 2023
% L.Jenkins@soton.ac.uk

arguments (Repeating)
    times (:,1) datetime
    var (:,1) double
    line_clr 
    labels (1,2) string
end

f = figure('units','normalized');
tld = tiledlayout('flow','TileSpacing','compact','Padding','compact');
tiles = cell(1,width(var));
lines = cell(1,width(var));
for i = 1:width(var)
    tiles{1,i} = nexttile;
    grid on
    box on
    lines{1,i} = plot(times{1,i},var{1,i},'Color',line_clr{1,i});
    ylabel(labels{1,i}(1))
    title(labels{1,i}(2))
end
set(findobj(gcf,'type','axes'),'fontweight','bold')
if tld.GridSize(1)*tld.GridSize(2) <= 2
    figsize = [.225 .2 .55 .70];
elseif tld.GridSize(1)*tld.GridSize(2) > 3 && tld.GridSize(1)*tld.GridSize(2) <= 4
    figsize = [.075 .125 .85 .80];
elseif tld.GridSize(1)*tld.GridSize(2) > 5
    figsize = [.025 .05 .95 .90];
end
set(f,'outerposition',figsize)

if nargout >= 1
    out = {tiles,lines};
    varargout = cell(nargout,1);
    for k = 1:nargout
        varargout{k} = out{k};
    end
end

% fini