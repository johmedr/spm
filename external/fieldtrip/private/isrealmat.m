function status = isrealmat(x)

% ISREALMAT returns true for a real matrix
%
% Use as
%   status = isrealmat(x)
%
% See also ISNUMERIC, ISREAL, ISVECTOR, ISREALVEC

% Copyright (C) 2012, Robert Oostenveld
%
% This file is part of FieldTrip, see http://www.ru.nl/neuroimaging/fieldtrip
% for the documentation and details.
%
%    FieldTrip is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    FieldTrip is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with FieldTrip. If not, see <http://www.gnu.org/licenses/>.
%
% $Id: isrealmat.m 5731 2012-05-03 19:38:23Z roboos $

% This is a drop-in replacement for MATLAB/toolbox/ident/idutils/isrealmat.m
% which requires the Ident toolbox. The following can be used instead to
% replicate the same functionality.
%
% built-in (/Applications/MATLAB_R2010a.app/toolbox/matlab/datatypes/isnumeric)
% built-in (/Applications/MATLAB_R2010a.app/toolbox/matlab/elfun/isreal)
% built-in (/Applications/MATLAB_R2010a.app/toolbox/matlab/elmat/isvector)
% /Applications/MATLAB_R2010a.app/toolbox/matlab/elmat/ndims.m

status = isnumeric(x) && isreal(x) && length(size(x))==2;
