function [varargout] = binlabels(var,fig)
%
% plt.binlabels - creates binned labels from n - n+1 variable: e.g., 2013, 2014, 2015 into 2013-2014, 2014-2015
%                 with option to add to an open plot as xticklabels
%
% Inputs:
%   var - string array input to be binned
% -name-value arguments-
%   'rightedge' - default is +1, input a string to override default, e.g., "my right edge label"
%                 or input "delete" to delete right edge
%   'addtofig' - 'y' to add the new binlabels to the plot on the x axis as xticklabels (will fail with datetiime rulers as bins not typically used for timeseries)
%   'fontweight' - 'bold' for bold fontweight 
%   'fontsize' - numeric value for fontsize
%   'xtickangle' - numeric value for xtickangle
%
% Outputs (in order):
%   1st - new binned labels (string array), includes right edge bin: (var(end) - var(end)+1)

% Luke Jenkins Feb 2023
% L.Jenkins@soton.ac.uk

arguments
    var (:,1) string
    fig.rightedge (1,1) string
    fig.addtofig char {mustBeMember(fig.addtofig,{'y'})}
    fig.fontweight (1,4) char {mustBeMember(fig.fontweight,{'bold'})}
    fig.fontsize (1,1) double
    fig.xtickangle (1,1) double
end

var(:,2) = [var(2:end) ; string(double(var(end,1)) + 1)];
xlbs = append(var(:,1),'-' ,var(:,2));
if length(fieldnames(fig)) > 1 && ~isfield(fig,'addtofig')
    error("'addtofig' must equal 'y' for other plot inputs to be considered")
end
if isfield(fig,'rightedge')
    if strcmpi(fig.rightedge,'delete')
        xlbs(end) = [];
    else
        xlbs(end) = append(var(end,1),'-',fig.rightedge);
    end
end
if isfield(fig,'addtofig')
    xtick(1:1:height(var))
    xlim([.5 height(var)+.5])
    xticklabels(xlbs)
    ax = gca;
    if isfield(fig,'fontweight')
        ax.XAxis.FontWeight = fig.fontweight;
    end
    if isfield(fig,'fontsize')
        ax.XAxis.FontSize = fig.fontsize;
    end
    if isfield(fig,'xtickangle')
        xtickangle(fig.xtickangle);
    end
end
varargout = {xlbs};

% fini