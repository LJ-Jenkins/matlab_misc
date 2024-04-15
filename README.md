# matlab_misc
Some miscellaneous Matlab functions that I use frequently.

-Data manipulation-

searchsorted :  binary search in the style of numpy's searchsorted

thresh_cross_del :  make nan all values bar the max in every group of consecutive values over a threshold.

fnames :  gets the folder and file names within a directory.

groupbin :  bin data into groups specified by binvals, with option to make percentiles.


-Plotting-

nxtile :  Matlab's nexttile but with row,col input.

font :  change the font options all at once for text objects in an open plot.

labeltiles :  label tiles in a tiledlayout a-z in a specified position in row/col major order.

binlabels :  create binned labels from n - n+1 variable: e.g., 2013, 2014, 2015 into 2013-2014, 2014-2015 and add to plot.

change_nth_xylabel :  removes the nth x or y label and replaces it with a specified label on an open plot.

coverage_greyed :  gives grey shading colours/alphas representative of the percentage of non-nan data over user-defined time periods within a timeseries.

timeseries :  plots variables and their associated times, arguments are repeating so multiple tiles can be created in a single call.






