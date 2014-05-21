function DCM = spm_dcm_voi(DCM,VOIs)
% Insert new regions into a DCM
% FORMAT DCM = spm_dcm_voi(DCM,VOIs)
%
% DCM   - DCM structure or its filename
% VOIs  - cell array of new VOI filenames 
%         eg. {'VOI_V1','VOI_V5','VOI_SPC'}
%
% The RT is assumed to be the same as before.
%
% This function can be used, for example, to replace subject X's data by 
% subject Y's. The model can then be re-estimated without having to go 
% through model specification again.
%__________________________________________________________________________
% Copyright (C) 2002-2014 Wellcome Trust Centre for Neuroimaging

% Will Penny
% $Id: spm_dcm_voi.m 6006 2014-05-21 18:09:05Z guillaume $


%-Get input arguments
%--------------------------------------------------------------------------
if ~nargin
    [DCM, sts] = spm_select(1,'^DCM.*\.mat$','select DCM_???.mat');
    if ~sts, return; end
end
if ~isstruct(DCM)
    DCMfile = DCM;
    load(DCM);
end

if nargin < 2
    [VOIs, sts] = spm_select(Inf,'^VOI.*\.mat$','select VOIs');
    if ~sts, return; end
end
VOIs = cellstr(VOIs);

%-Check we have matching number of regions
%--------------------------------------------------------------------------
if DCM.n ~= numel(VOIs)
    error('DCM contains %d regions while %d VOI files were given.',...
        DCM.n, numel(VOIs));
end

%-Replace relevant fields in DCM with xY
%--------------------------------------------------------------------------
DCM               = rmfield(DCM,'xY');
DCM.Y.y           = [];
for i=1:DCM.n
    load(VOIs{i});
    
    DCM.v         = size(xY.u,1);
    DCM.Y.y(:,i)  = xY.u;
    DCM.Y.name{i} = xY.name;
    DCM.Y.X0      = xY.X0;
    DCM.Y.Q       = spm_Ce(ones(1,DCM.n)*DCM.v);
    DCM.xY(i)     = xY;
end

%-Save (overwrite) new DCM file
%--------------------------------------------------------------------------
if exist('DCMfile','var')
    save(DCMfile, 'DCM', spm_get_defaults('mat.format'));
end
