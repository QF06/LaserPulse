function FWHM = calculateFWHM(x, y)
% CALCULATEFWHM calculates the full width at half maximum of a signal.
%
% USAGE:
% FWHM = calculateFWHM(x, y)
%
% Notes:
%  It is a very basic implementation, valid for data with a single peak. It
%  finds the intervals where y-0.5*max(y) changes sign, then it makes a
%  linear interpolation to refine the result. If y is a multidimensional
%  vector, it first convert it to column form by summing over the other
%  dimensions (y --> sum(y,2)). This can be useful, for example, if y is a
%  (Nx3) array containing the intensities of the orthogonal polarization
%  components of a laser beam.

% Copyright (C) 2015 Alberto Comin, LMU Muenchen
% This file is part of LaserPulse. See README.txt in the LaserPulse folder
% for copyright and licence notice.

assert(isvector(x), 'the indipendent variable x must be a vector');

x = x(:);
y = reshape(y, size(y,1), []); % convert 'y' to 2D array
y = sum(y,2); % compact 'y' into one column

assert(numel(x)==numel(y), 'x and y must have compatible dimensions');

yNorm = abs(y(:)) / max(y(:));
trend = diff( sign( yNorm - 0.5-eps ) );

crossPoint = find(trend);
if length(crossPoint) == 2
  % take an extra point on both sides, otherwise interp1 may fail if the
  % crossing is exactly on a grid point
   firstInterv = [crossPoint(1)-1, crossPoint(1)+2];
   secondInterv = [crossPoint(2)-1, crossPoint(2)+2];
   x1 = interp1( yNorm(firstInterv), x(firstInterv),  0.5);
   x2 = interp1( yNorm(secondInterv), x(secondInterv), 0.5);  
   FWHM = abs(x2-x1);
else
   FWHM=NaN;
end
end

