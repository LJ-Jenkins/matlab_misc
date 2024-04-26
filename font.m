function font(varargin,fig)
%
% plt.font - changes font options (weight, size, and name) for a currently opened plot
%            in the syntax: plt.font('scale',5.1,'weight','bold','name','courier','object',ax1)
%
% Inputs:
%   size - any acceptable input to the Matlab base function fontsize():
%          https://uk.mathworks.com/help/matlab/ref/fontsize.html
%          use same format input, but do not use name value, e.g., for
%          scale use 'scale',1.2 NOT scale=1.2
% -name-value arguments-
%   'weight' - 'bold' to make fontweight bold
%   'name' - any public property name and value for the fontname() base function
%            (for available fonts on your computer use: listfonts() )
%   'object' - what object to apply font settings to: (default) gcf ,
%              if you wish for it not to be the whole figure, input specific
%              axes objects e.g, ax1 or [ax1 ax2]

% Luke Jenkins Feb 2023
% L.Jenkins@soton.ac.uk

arguments (Repeating)
    varargin
end
arguments
    fig.weight char {mustBeMember(fig.weight,{'bold'})}
    fig.name (1,1) string
    fig.object = gcf
end

if isfield(fig,'weight')
    set(findall(fig.object,'Type','text'),'FontWeight','bold')
end
if nargin > 0
    fontsize(fig.object,varargin{:})
end
if isfield(fig,'name')
    fontname(fig.object,fig.name)
end

% fini