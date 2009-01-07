function [vol, cfg] = prepare_concentricspheres(cfg)

% PREPARE_CONCENTRICSPHERES creates a MEG volume conductor model with a sphere
% for every sensor. You can also use it to create a single sphere
% model that is fitted to the MRI or to the head shape points.
%
% Use as
%   [vol, cfg] = prepare_concentricspheres(cfg)
%
% The input configuration should contain
%   cfg.headshape     = filename containing headshape, or Nx3 matrix with
%                       surface points, can possibly be a structure array
%                       with several boundaries
%   cfg.conductivity  = conductivity values for the model (default = [0.3300 1 0.0042 0.3300])
%   cfg.fitind        = indices of shapes to use for fitting the center (default = 'all')
%   cfg.nonlinear     = 'yes' or 'no' (default = 'yes')
%   cfg.feedback      = 'yes' or 'no' (default = 'yes')
%
%
% Example:
%
%   cfg = [];
%   % first create 4 surfaces that represent the brain, csf, skull and skin
%   radius = [86 88 92 100];
%   for i=1:4
%     pnt = randn(100,3);
%     for j=1:size(pnt,1)
%       pnt(j,:) = pnt(j,:) ./ norm(pnt(j,:));
%     end
%     cfg.headshape(i).pnt = radius(i) .* pnt + 0.1*randn(size(pnt));
%   end
%   % then construct a volume conduction model of the head by fitting 4 concentric spheres
%   cfg.conductivity = [0.3300 1 0.0042 0.3300]
%   [vol, cfg] = prepare_concentricspheres(cfg)


% Copyright (C) 2009, Vladimir Litvak & Robert Oostenveld
%
% $Log: prepare_concentricspheres.m,v $
% Revision 1.1  2009/01/05 13:06:39  roboos
% initial version of Vladimir with some extensions/improvements
%

fieldtripdefs

if ~isfield(cfg, 'fitind'),        cfg.fitind = 'all';                            end
if ~isfield(cfg, 'nonlinear'),     cfg.nonlinear = 'yes';                         end
if ~isfield(cfg, 'feedback'),      cfg.feedback = 'yes';                          end
if ~isfield(cfg, 'conductivity'),  cfg.conductivity = [0.3300 1 0.0042 0.3300];   end

% use the headshape points that are specified in the configuration
if ischar(cfg.headshape)
  shape = read_headshape(cfg.headshape);
else
  shape = cfg.headshape;
end

if strcmp(cfg.fitind, 'all')
  fitind = 1:numel(shape);
else
  fitind = cfg.fitind;
end

% concatenate the vertices of all surfaces
pnt = [];
for i = fitind
  pnt = [pnt ; shape(i).pnt];
end
% remove double vertices
pnt = unique(pnt, 'rows');

Npnt = size(pnt, 1);

% set up an empty figure
if strcmp(cfg.feedback, 'yes')
  figure
  hold on
  axis equal
  axis vis3d
  axis off
  drawnow
  colors = {'b', 'y', 'm', 'r'};
  [sphere_pnt, sphere_tri] = icosahedron162;
end

% fit a single sphere to all headshape points
ini = mean(pnt,1);
[single_o, single_r] = fit_sphere(pnt, ini, strcmp(cfg.nonlinear, 'yes'));
fprintf('initial sphere: number of surface points = %d\n', Npnt);
fprintf('initial sphere: center = [%.1f %.1f %.1f]\n', single_o(1), single_o(2), single_o(3));
fprintf('initial sphere: radius = %.1f\n', single_r);

% fit the radius of each concentric sphere to the corresponding surface points
vol = [];
vol.o = single_o;
for i = 1:numel(shape)
  dist     = sqrt(sum(((shape(end-i+1).pnt - repmat(single_o, size(shape(end-i+1).pnt,1), 1)).^2), 2));
  vol.r(i) = mean(dist);

  if strcmp(cfg.feedback, 'yes')
    if ~isfield(shape(end-i+1), 'tri')
      shape(end-i+1).tri = [];
    end

    % plot the original surface
    triplot(shape(end-i+1).pnt, shape(end-i+1).tri, [], 'edges');

    % plot the sphere surface
    spnt = sphere_pnt*vol.r(i) + repmat(single_o, size(sphere_pnt, 1), 1);
    hs = triplot(spnt, sphere_tri, [], 'edges');
    set(hs, 'EdgeColor', colors{mod(i, numel(colors)) + 1});
  end
end

if numel(cfg.conductivity)==numel(shape)
  vol.c = cfg.conductivity;
else
  error('incorrect specification of cfg.conductivity');
end

vol.type = 'concentric';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% helper function that fits a sphere to a cloud of points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [center, radius] = fit_sphere(pnt, initial, nonlinear)

if nonlinear
  % start the nonlinear search for the optimal sphere with default options
  options = optimset('TolFun',1e-10,...
    'TypicalX',norm(range(pnt))/100,...
    'Display','none');
  warning off
  center = fminunc(@fit_sphere_error, initial, options, pnt);
  warning on
  [err, radius] = fit_sphere_error(center, pnt);
else
  % use a linear approach for fitting the sphere
  center = mean(pnt,1);
  dist   = sqrt(sum(((pnt - repmat(center, size(pnt,1), 1)).^2), 2));
  radius = mean(dist);
  err    = std(dist,1);
end
fprintf('error after fitting sphere = %f\n', err);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% helper function that computes the goal function to be minimized
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [err, radius] = fit_sphere_error(center, pnt)
dist   = sqrt(sum(((pnt - repmat(center, size(pnt,1), 1)).^2), 2));
radius = mean(dist);
err    = std(dist,1);
