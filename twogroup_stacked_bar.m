function [varargout] = twogroup_stacked_bar(var,bins,groups,opts,lgnd)
%
% twogroup_stacked_bar - plots a bar of a binned variable that is also stacked by a different grouping
%
% Inputs:
%   var - data for binning
%   bins - the bin edges, where bins(1) is the left edge of the first bin, and bins(end) is the right edge of the last bin
%   groups - the groups from which to do the stacking (usually 1,2,3, etc)
% -name-value arguments-
%   'colors' - (required) a nx3 double of RBG triplets, 1 triplet for each group
%   'percentages' - 'y' to plot the bars as percentages (aka:'Normalisation','probability * 100)
%   'addtofig' - 'y' adds plot to an open figure as the next tile
%   'xlabel' - xlabel string
%   'lgtitle' - title for the legend
%    - any public property name and value for the legend() base function ,e.g., 'String',{'Label1','Label2'}
%
% Outputs (in order):
%   1st - cell array of bar handles (one for each bar/bin)

% Luke Jenkins Feb 2023
% L.Jenkins@soton.ac.uk

arguments
    var (1,:) double
    bins (1,:) double
    groups (1,:) double
    opts.colors
    opts.percentages {mustBeMember(opts.percentages,{'y','n'})} = 'n'
    opts.addtofig {mustBeMember(opts.addtofig,{'y','n'})} = 'n'
    opts.xlabel string
    opts.lgtitle string
    lgnd.?matlab.graphics.illustration.Legend
end

lgnd = namedargs2cell(lgnd);
bins = [bins ; 1:width(bins)];
varg = nan(1,width(var));
for i = 1:width(bins)-1
    varg(1,var >= bins(1,i) & var < bins(1,i+1)) = bins(2,i);
end
if opts.addtofig == 'n'
    figure('units','normalized','outerposition',[.225 .2 .55 .70]);
end
nexttile
b = cell(1,width(bins)-1);
for i = 1:width(bins)-1
    if opts.percentages == 'y'
        b{i} = bar(i,histcounts(groups(varg == bins(2,i)))/length(var)*100,'stacked');
    else
        b{i} = bar(i,histcounts(groups(varg == bins(2,i))),'stacked');
    end
    hold on
    for j = 1:length(b{i})
        b{i}(j).FaceColor = opts.colors(j,:);
    end
end
xl = bins(1,:);
xl(:,2) = [xl(2:end) ; string(double(xl(end,1)) + 1)];
xlbs = append(xl(:,1),'-' ,xl(:,2));
xlim([.5 length(b)+.5])
xtick(1:length(xlbs)-1)
xticklabels(xlbs(1:end-1))
if opts.percentages ~= 'y'
    ylabel('Counts')
else
    ylabel('Percentage (%)')
end
if isfield(opts,'xlabel')
    xlabel(opts.xlabel);
end
[~,mxi] = max(cellfun(@(x) length(x), b));
lg = legend(b{mxi},lgnd{:});
if isfield(opts,'lgtitle')
    title(lg,opts.lgtitle)
end

if nargout == 1
    varargout{1} = b;
end

% fini