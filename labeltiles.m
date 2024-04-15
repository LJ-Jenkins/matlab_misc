function labeltiles(nv,propArgs)
%
% plt.labeltiles - label tiles 'a' to 'z' in either row major or column major order
%
% -name-value arguments-
%   'tiles' - tiledlayout object,if blank function finds tiledlayout from current figure
%   'order' - 'row' (default) or 'col' 
%   'position' - x and y position on the axes for the labels, default [.05 .95] (see below)
%   - any public property name and value for the text() base function, 
%     the default in this function is: 'Units', 'normalized'

% Luke Jenkins Nov 2023
% L.Jenkins@soton.ac.uk

arguments
    nv.tiles
    nv.order char {mustBeMember(nv.order,{'row','col'})} = 'row'
    nv.position (1,2) double = [.05 .95]
    propArgs.?matlab.graphics.primitive.Text
end

if ~isfield(nv,'tiles')
    t=gcf().Children;
else
    t=nv.tiles;
end

extrainputs = namedargs2cell(propArgs);
u=find(cellfun(@(x)strcmpi(x,'units'),extrainputs),1);
if isempty(u); extrainputs=[{'Units','normalized'} extrainputs]; end
alphabet=('a':'z')';
% t.Children = flipud(t.Children);
to=1:t.GridSize(1)*t.GridSize(2);
if strcmpi(nv.order,'col'); to=reshape(to,[t.GridSize(2) t.GridSize(1)])'; end
for i = 1:numel(to)
    nexttile(to(i))
    text(nv.position(1),nv.position(2),alphabet(i),extrainputs{:})
end

end
% fini