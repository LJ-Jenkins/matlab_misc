function [varargout] = coverage_greyed(times,var,period,fig)
%
% plt.coverage_greyed - gives grey shading colours/alphas representative of the percentage of non-nan data 
%                       over user-defined time periods within a timeseries
%
% Inputs:
%   times - times variable
%   var - data variable
%   period - (default) 'year','quin', or 'decade': time period over which to calculate percentages. If the 
%            last period is not whole, the percentage for the remaining length of time is calculated
% -name-value arguments-
%   'addtofig' - (default) 'y' or 'n' to plot the grey shading to the current open plot, or not!
%   'contrast' - 'high' or (default) 'low': contrast style of the face alphas of grey colours
%
% Outputs (in order):
%   1st - the associated percentages of non-nan data
%   2nd - face alphas used for plotting

% Luke Jenkins Feb 2023
% L.Jenkins@soton.ac.uk

arguments
    times (:,1) datetime
    var (:,1) double {mustBeNumeric}
    period char {mustBeMember(period,{'year','quin','decade'})} = 'year'
    fig.addtofig char {mustBeMember(fig.addtofig,{'y','n'})} = 'y'
    fig.contrast char {mustBeMember(fig.contrast,{'high','low'})} = 'low'
end

yrs = year(times(1)):year(times(end));
if strcmpi(period,'year')
    x = yrs;
    percs = get_percs(x,times,var);
elseif strcmpi(period,'quin')
    inte = ceil(length(yrs)/5);
    x = yrs(1:5:inte*5);
    if x(end) ~= yrs(end)
        x = [x yrs(end)];
    end
    percs = get_percs(x,times,var);
elseif strcmpi(period,'decade')
    inte = ceil(length(yrs)/10);
    x = yrs(1:10:inte*10);
    if x(end) ~= yrs(end)
        x = [x yrs(end)];
    end
    percs = get_percs(x,times,var);
end
percs(isnan(percs)) = 0;
if strcmpi(fig.contrast,'high')
    alphas = mat2gray(percs(:,1),[max(percs(:,1)) min(percs(:,1))]);
else 
    alphas = rescale(percs,.2,.8);
    alphas = 1 - alphas;
end
if isfield(fig,'addtofig')
    hold on
    yl = ylim;
    f = double.empty;
    for q = 1:length(x)-1
        if q ~= length(x)-1
            f(q) = fill([repmat(datetime(x(q),1,1,0,0,0),1,2) ...
                repmat(datetime(x(q+1),1,1,0,0,0),1,2)], ...
                [yl(1) yl(end) yl(end) yl(1)],[128 128 128]/255,'edgecolor', ...
                'none','FaceAlpha',alphas(q));
        else
            f(q) = fill([repmat(datetime(x(q),1,1,0,0,0),1,2) ...
                repmat(times(end),1,2)], ...
                [yl(1) yl(end) yl(end) yl(1)],[128 128 128]/255,'edgecolor', ...
                'none','FaceAlpha',alphas(q));
        end
    end
    uistack(f,'bottom')
end
if nargout >= 1
    out = {percs,alphas};
    varargout = cell(nargout,1);
    for k = 1:nargout
        varargout{k} = out{k};
    end
end
end

% fini

function [percs] = get_percs(x,times,var)
    percs = nan([length(x) 1]);
    idx = cell(length(x),1);
    for j = 1:length(x)-1
        if j ~= length(x)-1
            i = year(times) == x(j):1:x(j+1)-1;
        else
            i = year(times) == x(j):1:x(j+1);
        end
        idx{j,1} = logical(sum(i,2));
        percs(j,1) = 100 - (sum(isnan(var(idx{j,1}))) / length(var(idx{j,1})) * 100);
    end
end

% fini fini