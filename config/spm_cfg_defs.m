function defs = spm_cfg_defs
% SPM Configuration file for deformation jobs.
%_______________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% $Id: spm_cfg_defs.m 1827 2008-06-16 13:54:37Z guillaume $

% ---------------------------------------------------------------------
% matname Parameter File
% ---------------------------------------------------------------------
matname         = cfg_files;
matname.tag     = 'matname';
matname.name    = 'Parameter File';
matname.help    = {'Specify the _sn.mat to be used.'};
matname.filter = '.*_sn\.mat$';
matname.ufilter = '.*';
matname.num     = [1 1];
% ---------------------------------------------------------------------
% vox Voxel sizes
% ---------------------------------------------------------------------
vox         = cfg_entry;
vox.tag     = 'vox';
vox.name    = 'Voxel sizes';
vox.val{1} = double([NaN NaN NaN]);
vox.help    = {'Specify the voxel sizes of the deformation field to be produced. Non-finite values will default to the voxel sizes of the template imagethat was originally used to estimate the deformation.'};
vox.strtype = 'e';
vox.num     = [1 3];
% ---------------------------------------------------------------------
% bb Bounding box
% ---------------------------------------------------------------------
bb         = cfg_entry;
bb.tag     = 'bb';
bb.name    = 'Bounding box';
bb.val{1} = double([NaN NaN NaN
                    NaN NaN NaN]);
bb.help    = {'Specify the bounding box of the deformation field to be produced. Non-finite values will default to the bounding box of the template imagethat was originally used to estimate the deformation.'};
bb.strtype = 'e';
bb.num     = [2 3];
% ---------------------------------------------------------------------
% sn2def Imported _sn.mat
% ---------------------------------------------------------------------
sn2def         = cfg_branch;
sn2def.tag     = 'sn2def';
sn2def.name    = 'Imported _sn.mat';
sn2def.val     = {matname vox bb };
sn2def.help    = {'Spatial normalisation, and the unified segmentation model of SPM5 save a parameterisation of deformation fields.  These consist of a combination of an affine transform, and nonlinear warps that are parameterised by a linear combination of cosine transform basis functions.  These are saved in *_sn.mat files, which can be converted to deformation fields.'};
% ---------------------------------------------------------------------
% flowfield Flow field
% ---------------------------------------------------------------------
flowfield         = cfg_files;
flowfield.tag     = 'flowfield';
flowfield.name    = 'Flow field';
flowfield.help    = {'The flow field stores the deformation information. The same field can be used for both forward or backward deformations (or even, in principle, half way or exaggerated deformations).'};
flowfield.filter = 'nifti';
flowfield.ufilter = '^u_.*';
flowfield.num     = [1 1];
% ---------------------------------------------------------------------
% times Forward/Backwards
% ---------------------------------------------------------------------
times         = cfg_menu;
times.tag     = 'times';
times.name    = 'Forward/Backwards';
times.val{1} = double([1 0]);
times.help    = {'The direction of the DARTEL flow.  Note that a backward transform will warp an individual subject''s to match the template (ie maps from template to individual). A forward transform will warp the template image to the individual.'};
times.labels = {
                'Backward'
                'Forward'
}';
times.values{1} = double([1 0]);
times.values{2} = double([0 1]);
% ---------------------------------------------------------------------
% K Time Steps
% ---------------------------------------------------------------------
K         = cfg_menu;
K.tag     = 'K';
K.name    = 'Time Steps';
K.val{1} = double(6);
K.help    = {'The number of time points used for solving the partial differential equations.  A single time point would be equivalent to a small deformation model. Smaller values allow faster computations, but are less accurate in terms of inverse consistency and may result in the one-to-one mapping breaking down.'};
K.labels = {
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128'
            '256'
            '512'
}';
K.values{1} = double(0);
K.values{2} = double(1);
K.values{3} = double(2);
K.values{4} = double(3);
K.values{5} = double(4);
K.values{6} = double(5);
K.values{7} = double(6);
K.values{8} = double(7);
K.values{9} = double(8);
K.values{10} = double(9);
% ---------------------------------------------------------------------
% dartel DARTEL flow
% ---------------------------------------------------------------------
dartel         = cfg_branch;
dartel.tag     = 'dartel';
dartel.name    = 'DARTEL flow';
dartel.val     = {flowfield times K };
dartel.help    = {'Imported DARTEL flow field.'};
% ---------------------------------------------------------------------
% def Deformation Field
% ---------------------------------------------------------------------
def         = cfg_files;
def.tag     = 'def';
def.name    = 'Deformation Field';
def.help    = {'Deformations can be thought of as vector fields. These can be represented by three-volume images.'};
def.filter = '.*y_.*\.nii$';
def.ufilter = '.*';
def.num     = [1 1];
% ---------------------------------------------------------------------
% space Image to base Id on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base Id on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% id Identity
% ---------------------------------------------------------------------
id         = cfg_branch;
id.tag     = 'id';
id.name    = 'Identity';
id.val     = {space };
id.help    = {'This option generates an identity transform, but this can be useful for changing the dimensions of the resulting deformation (and any images that are generated from it).  Dimensions, orientation etc are derived from an image.'};
% ---------------------------------------------------------------------
% matname Parameter File
% ---------------------------------------------------------------------
matname         = cfg_files;
matname.tag     = 'matname';
matname.name    = 'Parameter File';
matname.help    = {'Specify the _sn.mat to be used.'};
matname.filter = '.*_sn\.mat$';
matname.ufilter = '.*';
matname.num     = [1 1];
% ---------------------------------------------------------------------
% vox Voxel sizes
% ---------------------------------------------------------------------
vox         = cfg_entry;
vox.tag     = 'vox';
vox.name    = 'Voxel sizes';
vox.val{1} = double([NaN NaN NaN]);
vox.help    = {'Specify the voxel sizes of the deformation field to be produced. Non-finite values will default to the voxel sizes of the template imagethat was originally used to estimate the deformation.'};
vox.strtype = 'e';
vox.num     = [1 3];
% ---------------------------------------------------------------------
% bb Bounding box
% ---------------------------------------------------------------------
bb         = cfg_entry;
bb.tag     = 'bb';
bb.name    = 'Bounding box';
bb.val{1} = double([NaN NaN NaN
                    NaN NaN NaN]);
bb.help    = {'Specify the bounding box of the deformation field to be produced. Non-finite values will default to the bounding box of the template imagethat was originally used to estimate the deformation.'};
bb.strtype = 'e';
bb.num     = [2 3];
% ---------------------------------------------------------------------
% sn2def Imported _sn.mat
% ---------------------------------------------------------------------
sn2def1         = cfg_branch;
sn2def1.tag     = 'sn2def';
sn2def1.name    = 'Imported _sn.mat';
sn2def1.val     = {matname vox bb };
sn2def1.help    = {'Spatial normalisation, and the unified segmentation model of SPM5 save a parameterisation of deformation fields.  These consist of a combination of an affine transform, and nonlinear warps that are parameterised by a linear combination of cosine transform basis functions.  These are saved in *_sn.mat files, which can be converted to deformation fields.'};
% ---------------------------------------------------------------------
% flowfield Flow field
% ---------------------------------------------------------------------
flowfield         = cfg_files;
flowfield.tag     = 'flowfield';
flowfield.name    = 'Flow field';
flowfield.help    = {'The flow field stores the deformation information. The same field can be used for both forward or backward deformations (or even, in principle, half way or exaggerated deformations).'};
flowfield.filter = 'nifti';
flowfield.ufilter = '^u_.*';
flowfield.num     = [1 1];
% ---------------------------------------------------------------------
% times Forward/Backwards
% ---------------------------------------------------------------------
times         = cfg_menu;
times.tag     = 'times';
times.name    = 'Forward/Backwards';
times.val{1} = double([1 0]);
times.help    = {'The direction of the DARTEL flow.  Note that a backward transform will warp an individual subject''s to match the template (ie maps from template to individual). A forward transform will warp the template image to the individual.'};
times.labels = {
                'Backward'
                'Forward'
}';
times.values{1} = double([1 0]);
times.values{2} = double([0 1]);
% ---------------------------------------------------------------------
% K Time Steps
% ---------------------------------------------------------------------
K         = cfg_menu;
K.tag     = 'K';
K.name    = 'Time Steps';
K.val{1} = double(6);
K.help    = {'The number of time points used for solving the partial differential equations.  A single time point would be equivalent to a small deformation model. Smaller values allow faster computations, but are less accurate in terms of inverse consistency and may result in the one-to-one mapping breaking down.'};
K.labels = {
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128'
            '256'
            '512'
}';
K.values{1} = double(0);
K.values{2} = double(1);
K.values{3} = double(2);
K.values{4} = double(3);
K.values{5} = double(4);
K.values{6} = double(5);
K.values{7} = double(6);
K.values{8} = double(7);
K.values{9} = double(8);
K.values{10} = double(9);
% ---------------------------------------------------------------------
% dartel DARTEL flow
% ---------------------------------------------------------------------
dartel1         = cfg_branch;
dartel1.tag     = 'dartel';
dartel1.name    = 'DARTEL flow';
dartel1.val     = {flowfield times K };
dartel1.help    = {'Imported DARTEL flow field.'};
% ---------------------------------------------------------------------
% def Deformation Field
% ---------------------------------------------------------------------
def1         = cfg_files;
def1.tag     = 'def';
def1.name    = 'Deformation Field';
def1.help    = {'Deformations can be thought of as vector fields. These can be represented by three-volume images.'};
def1.filter = '.*y_.*\.nii$';
def1.ufilter = '.*';
def1.num     = [1 1];
% ---------------------------------------------------------------------
% space Image to base Id on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base Id on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% id Identity
% ---------------------------------------------------------------------
id1         = cfg_branch;
id1.tag     = 'id';
id1.name    = 'Identity';
id1.val     = {space };
id1.help    = {'This option generates an identity transform, but this can be useful for changing the dimensions of the resulting deformation (and any images that are generated from it).  Dimensions, orientation etc are derived from an image.'};
% ---------------------------------------------------------------------
% matname Parameter File
% ---------------------------------------------------------------------
matname         = cfg_files;
matname.tag     = 'matname';
matname.name    = 'Parameter File';
matname.help    = {'Specify the _sn.mat to be used.'};
matname.filter = '.*_sn\.mat$';
matname.ufilter = '.*';
matname.num     = [1 1];
% ---------------------------------------------------------------------
% vox Voxel sizes
% ---------------------------------------------------------------------
vox         = cfg_entry;
vox.tag     = 'vox';
vox.name    = 'Voxel sizes';
vox.val{1} = double([NaN NaN NaN]);
vox.help    = {'Specify the voxel sizes of the deformation field to be produced. Non-finite values will default to the voxel sizes of the template imagethat was originally used to estimate the deformation.'};
vox.strtype = 'e';
vox.num     = [1 3];
% ---------------------------------------------------------------------
% bb Bounding box
% ---------------------------------------------------------------------
bb         = cfg_entry;
bb.tag     = 'bb';
bb.name    = 'Bounding box';
bb.val{1} = double([NaN NaN NaN
                    NaN NaN NaN]);
bb.help    = {'Specify the bounding box of the deformation field to be produced. Non-finite values will default to the bounding box of the template imagethat was originally used to estimate the deformation.'};
bb.strtype = 'e';
bb.num     = [2 3];
% ---------------------------------------------------------------------
% sn2def Imported _sn.mat
% ---------------------------------------------------------------------
sn2def2         = cfg_branch;
sn2def2.tag     = 'sn2def';
sn2def2.name    = 'Imported _sn.mat';
sn2def2.val     = {matname vox bb };
sn2def2.help    = {'Spatial normalisation, and the unified segmentation model of SPM5 save a parameterisation of deformation fields.  These consist of a combination of an affine transform, and nonlinear warps that are parameterised by a linear combination of cosine transform basis functions.  These are saved in *_sn.mat files, which can be converted to deformation fields.'};
% ---------------------------------------------------------------------
% flowfield Flow field
% ---------------------------------------------------------------------
flowfield         = cfg_files;
flowfield.tag     = 'flowfield';
flowfield.name    = 'Flow field';
flowfield.help    = {'The flow field stores the deformation information. The same field can be used for both forward or backward deformations (or even, in principle, half way or exaggerated deformations).'};
flowfield.filter = 'nifti';
flowfield.ufilter = '^u_.*';
flowfield.num     = [1 1];
% ---------------------------------------------------------------------
% times Forward/Backwards
% ---------------------------------------------------------------------
times         = cfg_menu;
times.tag     = 'times';
times.name    = 'Forward/Backwards';
times.val{1} = double([1 0]);
times.help    = {'The direction of the DARTEL flow.  Note that a backward transform will warp an individual subject''s to match the template (ie maps from template to individual). A forward transform will warp the template image to the individual.'};
times.labels = {
                'Backward'
                'Forward'
}';
times.values{1} = double([1 0]);
times.values{2} = double([0 1]);
% ---------------------------------------------------------------------
% K Time Steps
% ---------------------------------------------------------------------
K         = cfg_menu;
K.tag     = 'K';
K.name    = 'Time Steps';
K.val{1} = double(6);
K.help    = {'The number of time points used for solving the partial differential equations.  A single time point would be equivalent to a small deformation model. Smaller values allow faster computations, but are less accurate in terms of inverse consistency and may result in the one-to-one mapping breaking down.'};
K.labels = {
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128'
            '256'
            '512'
}';
K.values{1} = double(0);
K.values{2} = double(1);
K.values{3} = double(2);
K.values{4} = double(3);
K.values{5} = double(4);
K.values{6} = double(5);
K.values{7} = double(6);
K.values{8} = double(7);
K.values{9} = double(8);
K.values{10} = double(9);
% ---------------------------------------------------------------------
% dartel DARTEL flow
% ---------------------------------------------------------------------
dartel2         = cfg_branch;
dartel2.tag     = 'dartel';
dartel2.name    = 'DARTEL flow';
dartel2.val     = {flowfield times K };
dartel2.help    = {'Imported DARTEL flow field.'};
% ---------------------------------------------------------------------
% def Deformation Field
% ---------------------------------------------------------------------
def2         = cfg_files;
def2.tag     = 'def';
def2.name    = 'Deformation Field';
def2.help    = {'Deformations can be thought of as vector fields. These can be represented by three-volume images.'};
def2.filter = '.*y_.*\.nii$';
def2.ufilter = '.*';
def2.num     = [1 1];
% ---------------------------------------------------------------------
% space Image to base Id on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base Id on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% id Identity
% ---------------------------------------------------------------------
id2         = cfg_branch;
id2.tag     = 'id';
id2.name    = 'Identity';
id2.val     = {space };
id2.help    = {'This option generates an identity transform, but this can be useful for changing the dimensions of the resulting deformation (and any images that are generated from it).  Dimensions, orientation etc are derived from an image.'};
% ---------------------------------------------------------------------
% matname Parameter File
% ---------------------------------------------------------------------
matname         = cfg_files;
matname.tag     = 'matname';
matname.name    = 'Parameter File';
matname.help    = {'Specify the _sn.mat to be used.'};
matname.filter = '.*_sn\.mat$';
matname.ufilter = '.*';
matname.num     = [1 1];
% ---------------------------------------------------------------------
% vox Voxel sizes
% ---------------------------------------------------------------------
vox         = cfg_entry;
vox.tag     = 'vox';
vox.name    = 'Voxel sizes';
vox.val{1} = double([NaN NaN NaN]);
vox.help    = {'Specify the voxel sizes of the deformation field to be produced. Non-finite values will default to the voxel sizes of the template imagethat was originally used to estimate the deformation.'};
vox.strtype = 'e';
vox.num     = [1 3];
% ---------------------------------------------------------------------
% bb Bounding box
% ---------------------------------------------------------------------
bb         = cfg_entry;
bb.tag     = 'bb';
bb.name    = 'Bounding box';
bb.val{1} = double([NaN NaN NaN
                    NaN NaN NaN]);
bb.help    = {'Specify the bounding box of the deformation field to be produced. Non-finite values will default to the bounding box of the template imagethat was originally used to estimate the deformation.'};
bb.strtype = 'e';
bb.num     = [2 3];
% ---------------------------------------------------------------------
% sn2def Imported _sn.mat
% ---------------------------------------------------------------------
sn2def3         = cfg_branch;
sn2def3.tag     = 'sn2def';
sn2def3.name    = 'Imported _sn.mat';
sn2def3.val     = {matname vox bb };
sn2def3.help    = {'Spatial normalisation, and the unified segmentation model of SPM5 save a parameterisation of deformation fields.  These consist of a combination of an affine transform, and nonlinear warps that are parameterised by a linear combination of cosine transform basis functions.  These are saved in *_sn.mat files, which can be converted to deformation fields.'};
% ---------------------------------------------------------------------
% flowfield Flow field
% ---------------------------------------------------------------------
flowfield         = cfg_files;
flowfield.tag     = 'flowfield';
flowfield.name    = 'Flow field';
flowfield.help    = {'The flow field stores the deformation information. The same field can be used for both forward or backward deformations (or even, in principle, half way or exaggerated deformations).'};
flowfield.filter = 'nifti';
flowfield.ufilter = '^u_.*';
flowfield.num     = [1 1];
% ---------------------------------------------------------------------
% times Forward/Backwards
% ---------------------------------------------------------------------
times         = cfg_menu;
times.tag     = 'times';
times.name    = 'Forward/Backwards';
times.val{1} = double([1 0]);
times.help    = {'The direction of the DARTEL flow.  Note that a backward transform will warp an individual subject''s to match the template (ie maps from template to individual). A forward transform will warp the template image to the individual.'};
times.labels = {
                'Backward'
                'Forward'
}';
times.values{1} = double([1 0]);
times.values{2} = double([0 1]);
% ---------------------------------------------------------------------
% K Time Steps
% ---------------------------------------------------------------------
K         = cfg_menu;
K.tag     = 'K';
K.name    = 'Time Steps';
K.val{1} = double(6);
K.help    = {'The number of time points used for solving the partial differential equations.  A single time point would be equivalent to a small deformation model. Smaller values allow faster computations, but are less accurate in terms of inverse consistency and may result in the one-to-one mapping breaking down.'};
K.labels = {
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128'
            '256'
            '512'
}';
K.values{1} = double(0);
K.values{2} = double(1);
K.values{3} = double(2);
K.values{4} = double(3);
K.values{5} = double(4);
K.values{6} = double(5);
K.values{7} = double(6);
K.values{8} = double(7);
K.values{9} = double(8);
K.values{10} = double(9);
% ---------------------------------------------------------------------
% dartel DARTEL flow
% ---------------------------------------------------------------------
dartel3         = cfg_branch;
dartel3.tag     = 'dartel';
dartel3.name    = 'DARTEL flow';
dartel3.val     = {flowfield times K };
dartel3.help    = {'Imported DARTEL flow field.'};
% ---------------------------------------------------------------------
% def Deformation Field
% ---------------------------------------------------------------------
def3         = cfg_files;
def3.tag     = 'def';
def3.name    = 'Deformation Field';
def3.help    = {'Deformations can be thought of as vector fields. These can be represented by three-volume images.'};
def3.filter = '.*y_.*\.nii$';
def3.ufilter = '.*';
def3.num     = [1 1];
% ---------------------------------------------------------------------
% space Image to base Id on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base Id on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% id Identity
% ---------------------------------------------------------------------
id3         = cfg_branch;
id3.tag     = 'id';
id3.name    = 'Identity';
id3.val     = {space };
id3.help    = {'This option generates an identity transform, but this can be useful for changing the dimensions of the resulting deformation (and any images that are generated from it).  Dimensions, orientation etc are derived from an image.'};
% ---------------------------------------------------------------------
% comp Composition
% ---------------------------------------------------------------------
comp3         = cfg_repeat;
comp3.tag     = 'comp';
comp3.name    = 'Composition';
comp3.help    = {
                 'Deformation fields can be thought of as mappings. These can be combined by the operation of "composition", which is usually denoted by a circle "o". Suppose x:A->B and y:B->C are two mappings, where A, B and C refer to domains in 3 dimensions. Each element a in A points to element x(a) in B. This in turn points to element y(x(a)) in C, so we have a mapping from A to C. The composition of these mappings is denoted by yox:A->C. Compositions can be combined in an associative way, such that zo(yox) = (zoy)ox.'
                 ''
                 'In this utility, the left-to-right order of the compositions is from top to bottom (note that the rightmost deformation would actually be applied first). i.e. ...((first o second) o third)...o last. The resulting deformation field will have the same domain as the first deformation specified, and will map to voxels in the codomain of the last specified deformation field.'
}';
comp3.values  = {sn2def3 dartel3 def3 id3 };
comp3.num     = [0 Inf];
% ---------------------------------------------------------------------
% space Image to base inverse on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base inverse on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% inv Inverse
% ---------------------------------------------------------------------
inv2         = cfg_branch;
inv2.tag     = 'inv';
inv2.name    = 'Inverse';
inv2.val     = {comp3 space };
inv2.help    = {
                'Creates the inverse of a deformation field. Deformations are assumed to be one-to-one, in which case they have a unique inverse.  If y'':A->B is the inverse of y:B->A, then y'' o y = y o y'' = Id, where Id is the identity transform.'
                ''
                'Deformations are inverted using the method described in the appendix of:'
                '    * Ashburner J, Andersson JLR & Friston KJ (2000) "Image Registration using a Symmetric Prior - in Three-Dimensions." Human Brain Mapping 9(4):212-225'
}';
% ---------------------------------------------------------------------
% matname Parameter File
% ---------------------------------------------------------------------
matname         = cfg_files;
matname.tag     = 'matname';
matname.name    = 'Parameter File';
matname.help    = {'Specify the _sn.mat to be used.'};
matname.filter = '.*_sn\.mat$';
matname.ufilter = '.*';
matname.num     = [1 1];
% ---------------------------------------------------------------------
% vox Voxel sizes
% ---------------------------------------------------------------------
vox         = cfg_entry;
vox.tag     = 'vox';
vox.name    = 'Voxel sizes';
vox.val{1} = double([NaN NaN NaN]);
vox.help    = {'Specify the voxel sizes of the deformation field to be produced. Non-finite values will default to the voxel sizes of the template imagethat was originally used to estimate the deformation.'};
vox.strtype = 'e';
vox.num     = [1 3];
% ---------------------------------------------------------------------
% bb Bounding box
% ---------------------------------------------------------------------
bb         = cfg_entry;
bb.tag     = 'bb';
bb.name    = 'Bounding box';
bb.val{1} = double([NaN NaN NaN
                    NaN NaN NaN]);
bb.help    = {'Specify the bounding box of the deformation field to be produced. Non-finite values will default to the bounding box of the template imagethat was originally used to estimate the deformation.'};
bb.strtype = 'e';
bb.num     = [2 3];
% ---------------------------------------------------------------------
% sn2def Imported _sn.mat
% ---------------------------------------------------------------------
sn2def3         = cfg_branch;
sn2def3.tag     = 'sn2def';
sn2def3.name    = 'Imported _sn.mat';
sn2def3.val     = {matname vox bb };
sn2def3.help    = {'Spatial normalisation, and the unified segmentation model of SPM5 save a parameterisation of deformation fields.  These consist of a combination of an affine transform, and nonlinear warps that are parameterised by a linear combination of cosine transform basis functions.  These are saved in *_sn.mat files, which can be converted to deformation fields.'};
% ---------------------------------------------------------------------
% flowfield Flow field
% ---------------------------------------------------------------------
flowfield         = cfg_files;
flowfield.tag     = 'flowfield';
flowfield.name    = 'Flow field';
flowfield.help    = {'The flow field stores the deformation information. The same field can be used for both forward or backward deformations (or even, in principle, half way or exaggerated deformations).'};
flowfield.filter = 'nifti';
flowfield.ufilter = '^u_.*';
flowfield.num     = [1 1];
% ---------------------------------------------------------------------
% times Forward/Backwards
% ---------------------------------------------------------------------
times         = cfg_menu;
times.tag     = 'times';
times.name    = 'Forward/Backwards';
times.val{1} = double([1 0]);
times.help    = {'The direction of the DARTEL flow.  Note that a backward transform will warp an individual subject''s to match the template (ie maps from template to individual). A forward transform will warp the template image to the individual.'};
times.labels = {
                'Backward'
                'Forward'
}';
times.values{1} = double([1 0]);
times.values{2} = double([0 1]);
% ---------------------------------------------------------------------
% K Time Steps
% ---------------------------------------------------------------------
K         = cfg_menu;
K.tag     = 'K';
K.name    = 'Time Steps';
K.val{1} = double(6);
K.help    = {'The number of time points used for solving the partial differential equations.  A single time point would be equivalent to a small deformation model. Smaller values allow faster computations, but are less accurate in terms of inverse consistency and may result in the one-to-one mapping breaking down.'};
K.labels = {
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128'
            '256'
            '512'
}';
K.values{1} = double(0);
K.values{2} = double(1);
K.values{3} = double(2);
K.values{4} = double(3);
K.values{5} = double(4);
K.values{6} = double(5);
K.values{7} = double(6);
K.values{8} = double(7);
K.values{9} = double(8);
K.values{10} = double(9);
% ---------------------------------------------------------------------
% dartel DARTEL flow
% ---------------------------------------------------------------------
dartel3         = cfg_branch;
dartel3.tag     = 'dartel';
dartel3.name    = 'DARTEL flow';
dartel3.val     = {flowfield times K };
dartel3.help    = {'Imported DARTEL flow field.'};
% ---------------------------------------------------------------------
% def Deformation Field
% ---------------------------------------------------------------------
def3         = cfg_files;
def3.tag     = 'def';
def3.name    = 'Deformation Field';
def3.help    = {'Deformations can be thought of as vector fields. These can be represented by three-volume images.'};
def3.filter = '.*y_.*\.nii$';
def3.ufilter = '.*';
def3.num     = [1 1];
% ---------------------------------------------------------------------
% space Image to base Id on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base Id on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% id Identity
% ---------------------------------------------------------------------
id3         = cfg_branch;
id3.tag     = 'id';
id3.name    = 'Identity';
id3.val     = {space };
id3.help    = {'This option generates an identity transform, but this can be useful for changing the dimensions of the resulting deformation (and any images that are generated from it).  Dimensions, orientation etc are derived from an image.'};
% ---------------------------------------------------------------------
% comp Composition
% ---------------------------------------------------------------------
comp3         = cfg_repeat;
comp3.tag     = 'comp';
comp3.name    = 'Composition';
comp3.help    = {
                 'Deformation fields can be thought of as mappings. These can be combined by the operation of "composition", which is usually denoted by a circle "o". Suppose x:A->B and y:B->C are two mappings, where A, B and C refer to domains in 3 dimensions. Each element a in A points to element x(a) in B. This in turn points to element y(x(a)) in C, so we have a mapping from A to C. The composition of these mappings is denoted by yox:A->C. Compositions can be combined in an associative way, such that zo(yox) = (zoy)ox.'
                 ''
                 'In this utility, the left-to-right order of the compositions is from top to bottom (note that the rightmost deformation would actually be applied first). i.e. ...((first o second) o third)...o last. The resulting deformation field will have the same domain as the first deformation specified, and will map to voxels in the codomain of the last specified deformation field.'
}';
comp3.values  = {sn2def3 dartel3 def3 id3 };
comp3.num     = [0 Inf];
% ---------------------------------------------------------------------
% comp Composition
% ---------------------------------------------------------------------
comp2         = cfg_repeat;
comp2.tag     = 'comp';
comp2.name    = 'Composition';
comp2.check   = @check;
comp2.help    = {
                 'Deformation fields can be thought of as mappings. These can be combined by the operation of "composition", which is usually denoted by a circle "o". Suppose x:A->B and y:B->C are two mappings, where A, B and C refer to domains in 3 dimensions. Each element a in A points to element x(a) in B. This in turn points to element y(x(a)) in C, so we have a mapping from A to C. The composition of these mappings is denoted by yox:A->C. Compositions can be combined in an associative way, such that zo(yox) = (zoy)ox.'
                 ''
                 'In this utility, the left-to-right order of the compositions is from top to bottom (note that the rightmost deformation would actually be applied first). i.e. ...((first o second) o third)...o last. The resulting deformation field will have the same domain as the first deformation specified, and will map to voxels in the codomain of the last specified deformation field.'
}';
comp2.values  = {sn2def2 dartel2 def2 id2 inv2 comp3 };
comp2.num     = [0 Inf];
% ---------------------------------------------------------------------
% space Image to base inverse on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base inverse on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% inv Inverse
% ---------------------------------------------------------------------
inv1         = cfg_branch;
inv1.tag     = 'inv';
inv1.name    = 'Inverse';
inv1.val     = {comp2 space };
inv1.help    = {
                'Creates the inverse of a deformation field. Deformations are assumed to be one-to-one, in which case they have a unique inverse.  If y'':A->B is the inverse of y:B->A, then y'' o y = y o y'' = Id, where Id is the identity transform.'
                ''
                'Deformations are inverted using the method described in the appendix of:'
                '    * Ashburner J, Andersson JLR & Friston KJ (2000) "Image Registration using a Symmetric Prior - in Three-Dimensions." Human Brain Mapping 9(4):212-225'
}';
% ---------------------------------------------------------------------
% matname Parameter File
% ---------------------------------------------------------------------
matname         = cfg_files;
matname.tag     = 'matname';
matname.name    = 'Parameter File';
matname.help    = {'Specify the _sn.mat to be used.'};
matname.filter = '.*_sn\.mat$';
matname.ufilter = '.*';
matname.num     = [1 1];
% ---------------------------------------------------------------------
% vox Voxel sizes
% ---------------------------------------------------------------------
vox         = cfg_entry;
vox.tag     = 'vox';
vox.name    = 'Voxel sizes';
vox.val{1} = double([NaN NaN NaN]);
vox.help    = {'Specify the voxel sizes of the deformation field to be produced. Non-finite values will default to the voxel sizes of the template imagethat was originally used to estimate the deformation.'};
vox.strtype = 'e';
vox.num     = [1 3];
% ---------------------------------------------------------------------
% bb Bounding box
% ---------------------------------------------------------------------
bb         = cfg_entry;
bb.tag     = 'bb';
bb.name    = 'Bounding box';
bb.val{1} = double([NaN NaN NaN
                    NaN NaN NaN]);
bb.help    = {'Specify the bounding box of the deformation field to be produced. Non-finite values will default to the bounding box of the template imagethat was originally used to estimate the deformation.'};
bb.strtype = 'e';
bb.num     = [2 3];
% ---------------------------------------------------------------------
% sn2def Imported _sn.mat
% ---------------------------------------------------------------------
sn2def2         = cfg_branch;
sn2def2.tag     = 'sn2def';
sn2def2.name    = 'Imported _sn.mat';
sn2def2.val     = {matname vox bb };
sn2def2.help    = {'Spatial normalisation, and the unified segmentation model of SPM5 save a parameterisation of deformation fields.  These consist of a combination of an affine transform, and nonlinear warps that are parameterised by a linear combination of cosine transform basis functions.  These are saved in *_sn.mat files, which can be converted to deformation fields.'};
% ---------------------------------------------------------------------
% flowfield Flow field
% ---------------------------------------------------------------------
flowfield         = cfg_files;
flowfield.tag     = 'flowfield';
flowfield.name    = 'Flow field';
flowfield.help    = {'The flow field stores the deformation information. The same field can be used for both forward or backward deformations (or even, in principle, half way or exaggerated deformations).'};
flowfield.filter = 'nifti';
flowfield.ufilter = '^u_.*';
flowfield.num     = [1 1];
% ---------------------------------------------------------------------
% times Forward/Backwards
% ---------------------------------------------------------------------
times         = cfg_menu;
times.tag     = 'times';
times.name    = 'Forward/Backwards';
times.val{1} = double([1 0]);
times.help    = {'The direction of the DARTEL flow.  Note that a backward transform will warp an individual subject''s to match the template (ie maps from template to individual). A forward transform will warp the template image to the individual.'};
times.labels = {
                'Backward'
                'Forward'
}';
times.values{1} = double([1 0]);
times.values{2} = double([0 1]);
% ---------------------------------------------------------------------
% K Time Steps
% ---------------------------------------------------------------------
K         = cfg_menu;
K.tag     = 'K';
K.name    = 'Time Steps';
K.val{1} = double(6);
K.help    = {'The number of time points used for solving the partial differential equations.  A single time point would be equivalent to a small deformation model. Smaller values allow faster computations, but are less accurate in terms of inverse consistency and may result in the one-to-one mapping breaking down.'};
K.labels = {
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128'
            '256'
            '512'
}';
K.values{1} = double(0);
K.values{2} = double(1);
K.values{3} = double(2);
K.values{4} = double(3);
K.values{5} = double(4);
K.values{6} = double(5);
K.values{7} = double(6);
K.values{8} = double(7);
K.values{9} = double(8);
K.values{10} = double(9);
% ---------------------------------------------------------------------
% dartel DARTEL flow
% ---------------------------------------------------------------------
dartel2         = cfg_branch;
dartel2.tag     = 'dartel';
dartel2.name    = 'DARTEL flow';
dartel2.val     = {flowfield times K };
dartel2.help    = {'Imported DARTEL flow field.'};
% ---------------------------------------------------------------------
% def Deformation Field
% ---------------------------------------------------------------------
def2         = cfg_files;
def2.tag     = 'def';
def2.name    = 'Deformation Field';
def2.help    = {'Deformations can be thought of as vector fields. These can be represented by three-volume images.'};
def2.filter = '.*y_.*\.nii$';
def2.ufilter = '.*';
def2.num     = [1 1];
% ---------------------------------------------------------------------
% space Image to base Id on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base Id on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% id Identity
% ---------------------------------------------------------------------
id2         = cfg_branch;
id2.tag     = 'id';
id2.name    = 'Identity';
id2.val     = {space };
id2.help    = {'This option generates an identity transform, but this can be useful for changing the dimensions of the resulting deformation (and any images that are generated from it).  Dimensions, orientation etc are derived from an image.'};
% ---------------------------------------------------------------------
% matname Parameter File
% ---------------------------------------------------------------------
matname         = cfg_files;
matname.tag     = 'matname';
matname.name    = 'Parameter File';
matname.help    = {'Specify the _sn.mat to be used.'};
matname.filter = '.*_sn\.mat$';
matname.ufilter = '.*';
matname.num     = [1 1];
% ---------------------------------------------------------------------
% vox Voxel sizes
% ---------------------------------------------------------------------
vox         = cfg_entry;
vox.tag     = 'vox';
vox.name    = 'Voxel sizes';
vox.val{1} = double([NaN NaN NaN]);
vox.help    = {'Specify the voxel sizes of the deformation field to be produced. Non-finite values will default to the voxel sizes of the template imagethat was originally used to estimate the deformation.'};
vox.strtype = 'e';
vox.num     = [1 3];
% ---------------------------------------------------------------------
% bb Bounding box
% ---------------------------------------------------------------------
bb         = cfg_entry;
bb.tag     = 'bb';
bb.name    = 'Bounding box';
bb.val{1} = double([NaN NaN NaN
                    NaN NaN NaN]);
bb.help    = {'Specify the bounding box of the deformation field to be produced. Non-finite values will default to the bounding box of the template imagethat was originally used to estimate the deformation.'};
bb.strtype = 'e';
bb.num     = [2 3];
% ---------------------------------------------------------------------
% sn2def Imported _sn.mat
% ---------------------------------------------------------------------
sn2def3         = cfg_branch;
sn2def3.tag     = 'sn2def';
sn2def3.name    = 'Imported _sn.mat';
sn2def3.val     = {matname vox bb };
sn2def3.help    = {'Spatial normalisation, and the unified segmentation model of SPM5 save a parameterisation of deformation fields.  These consist of a combination of an affine transform, and nonlinear warps that are parameterised by a linear combination of cosine transform basis functions.  These are saved in *_sn.mat files, which can be converted to deformation fields.'};
% ---------------------------------------------------------------------
% flowfield Flow field
% ---------------------------------------------------------------------
flowfield         = cfg_files;
flowfield.tag     = 'flowfield';
flowfield.name    = 'Flow field';
flowfield.help    = {'The flow field stores the deformation information. The same field can be used for both forward or backward deformations (or even, in principle, half way or exaggerated deformations).'};
flowfield.filter = 'nifti';
flowfield.ufilter = '^u_.*';
flowfield.num     = [1 1];
% ---------------------------------------------------------------------
% times Forward/Backwards
% ---------------------------------------------------------------------
times         = cfg_menu;
times.tag     = 'times';
times.name    = 'Forward/Backwards';
times.val{1} = double([1 0]);
times.help    = {'The direction of the DARTEL flow.  Note that a backward transform will warp an individual subject''s to match the template (ie maps from template to individual). A forward transform will warp the template image to the individual.'};
times.labels = {
                'Backward'
                'Forward'
}';
times.values{1} = double([1 0]);
times.values{2} = double([0 1]);
% ---------------------------------------------------------------------
% K Time Steps
% ---------------------------------------------------------------------
K         = cfg_menu;
K.tag     = 'K';
K.name    = 'Time Steps';
K.val{1} = double(6);
K.help    = {'The number of time points used for solving the partial differential equations.  A single time point would be equivalent to a small deformation model. Smaller values allow faster computations, but are less accurate in terms of inverse consistency and may result in the one-to-one mapping breaking down.'};
K.labels = {
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128'
            '256'
            '512'
}';
K.values{1} = double(0);
K.values{2} = double(1);
K.values{3} = double(2);
K.values{4} = double(3);
K.values{5} = double(4);
K.values{6} = double(5);
K.values{7} = double(6);
K.values{8} = double(7);
K.values{9} = double(8);
K.values{10} = double(9);
% ---------------------------------------------------------------------
% dartel DARTEL flow
% ---------------------------------------------------------------------
dartel3         = cfg_branch;
dartel3.tag     = 'dartel';
dartel3.name    = 'DARTEL flow';
dartel3.val     = {flowfield times K };
dartel3.help    = {'Imported DARTEL flow field.'};
% ---------------------------------------------------------------------
% def Deformation Field
% ---------------------------------------------------------------------
def3         = cfg_files;
def3.tag     = 'def';
def3.name    = 'Deformation Field';
def3.help    = {'Deformations can be thought of as vector fields. These can be represented by three-volume images.'};
def3.filter = '.*y_.*\.nii$';
def3.ufilter = '.*';
def3.num     = [1 1];
% ---------------------------------------------------------------------
% space Image to base Id on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base Id on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% id Identity
% ---------------------------------------------------------------------
id3         = cfg_branch;
id3.tag     = 'id';
id3.name    = 'Identity';
id3.val     = {space };
id3.help    = {'This option generates an identity transform, but this can be useful for changing the dimensions of the resulting deformation (and any images that are generated from it).  Dimensions, orientation etc are derived from an image.'};
% ---------------------------------------------------------------------
% comp Composition
% ---------------------------------------------------------------------
comp3         = cfg_repeat;
comp3.tag     = 'comp';
comp3.name    = 'Composition';
comp3.help    = {
                 'Deformation fields can be thought of as mappings. These can be combined by the operation of "composition", which is usually denoted by a circle "o". Suppose x:A->B and y:B->C are two mappings, where A, B and C refer to domains in 3 dimensions. Each element a in A points to element x(a) in B. This in turn points to element y(x(a)) in C, so we have a mapping from A to C. The composition of these mappings is denoted by yox:A->C. Compositions can be combined in an associative way, such that zo(yox) = (zoy)ox.'
                 ''
                 'In this utility, the left-to-right order of the compositions is from top to bottom (note that the rightmost deformation would actually be applied first). i.e. ...((first o second) o third)...o last. The resulting deformation field will have the same domain as the first deformation specified, and will map to voxels in the codomain of the last specified deformation field.'
}';
comp3.values  = {sn2def3 dartel3 def3 id3 };
comp3.num     = [0 Inf];
% ---------------------------------------------------------------------
% space Image to base inverse on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base inverse on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% inv Inverse
% ---------------------------------------------------------------------
inv2         = cfg_branch;
inv2.tag     = 'inv';
inv2.name    = 'Inverse';
inv2.val     = {comp3 space };
inv2.help    = {
                'Creates the inverse of a deformation field. Deformations are assumed to be one-to-one, in which case they have a unique inverse.  If y'':A->B is the inverse of y:B->A, then y'' o y = y o y'' = Id, where Id is the identity transform.'
                ''
                'Deformations are inverted using the method described in the appendix of:'
                '    * Ashburner J, Andersson JLR & Friston KJ (2000) "Image Registration using a Symmetric Prior - in Three-Dimensions." Human Brain Mapping 9(4):212-225'
}';
% ---------------------------------------------------------------------
% matname Parameter File
% ---------------------------------------------------------------------
matname         = cfg_files;
matname.tag     = 'matname';
matname.name    = 'Parameter File';
matname.help    = {'Specify the _sn.mat to be used.'};
matname.filter = '.*_sn\.mat$';
matname.ufilter = '.*';
matname.num     = [1 1];
% ---------------------------------------------------------------------
% vox Voxel sizes
% ---------------------------------------------------------------------
vox         = cfg_entry;
vox.tag     = 'vox';
vox.name    = 'Voxel sizes';
vox.val{1} = double([NaN NaN NaN]);
vox.help    = {'Specify the voxel sizes of the deformation field to be produced. Non-finite values will default to the voxel sizes of the template imagethat was originally used to estimate the deformation.'};
vox.strtype = 'e';
vox.num     = [1 3];
% ---------------------------------------------------------------------
% bb Bounding box
% ---------------------------------------------------------------------
bb         = cfg_entry;
bb.tag     = 'bb';
bb.name    = 'Bounding box';
bb.val{1} = double([NaN NaN NaN
                    NaN NaN NaN]);
bb.help    = {'Specify the bounding box of the deformation field to be produced. Non-finite values will default to the bounding box of the template imagethat was originally used to estimate the deformation.'};
bb.strtype = 'e';
bb.num     = [2 3];
% ---------------------------------------------------------------------
% sn2def Imported _sn.mat
% ---------------------------------------------------------------------
sn2def3         = cfg_branch;
sn2def3.tag     = 'sn2def';
sn2def3.name    = 'Imported _sn.mat';
sn2def3.val     = {matname vox bb };
sn2def3.help    = {'Spatial normalisation, and the unified segmentation model of SPM5 save a parameterisation of deformation fields.  These consist of a combination of an affine transform, and nonlinear warps that are parameterised by a linear combination of cosine transform basis functions.  These are saved in *_sn.mat files, which can be converted to deformation fields.'};
% ---------------------------------------------------------------------
% flowfield Flow field
% ---------------------------------------------------------------------
flowfield         = cfg_files;
flowfield.tag     = 'flowfield';
flowfield.name    = 'Flow field';
flowfield.help    = {'The flow field stores the deformation information. The same field can be used for both forward or backward deformations (or even, in principle, half way or exaggerated deformations).'};
flowfield.filter = 'nifti';
flowfield.ufilter = '^u_.*';
flowfield.num     = [1 1];
% ---------------------------------------------------------------------
% times Forward/Backwards
% ---------------------------------------------------------------------
times         = cfg_menu;
times.tag     = 'times';
times.name    = 'Forward/Backwards';
times.val{1} = double([1 0]);
times.help    = {'The direction of the DARTEL flow.  Note that a backward transform will warp an individual subject''s to match the template (ie maps from template to individual). A forward transform will warp the template image to the individual.'};
times.labels = {
                'Backward'
                'Forward'
}';
times.values{1} = double([1 0]);
times.values{2} = double([0 1]);
% ---------------------------------------------------------------------
% K Time Steps
% ---------------------------------------------------------------------
K         = cfg_menu;
K.tag     = 'K';
K.name    = 'Time Steps';
K.val{1} = double(6);
K.help    = {'The number of time points used for solving the partial differential equations.  A single time point would be equivalent to a small deformation model. Smaller values allow faster computations, but are less accurate in terms of inverse consistency and may result in the one-to-one mapping breaking down.'};
K.labels = {
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128'
            '256'
            '512'
}';
K.values{1} = double(0);
K.values{2} = double(1);
K.values{3} = double(2);
K.values{4} = double(3);
K.values{5} = double(4);
K.values{6} = double(5);
K.values{7} = double(6);
K.values{8} = double(7);
K.values{9} = double(8);
K.values{10} = double(9);
% ---------------------------------------------------------------------
% dartel DARTEL flow
% ---------------------------------------------------------------------
dartel3         = cfg_branch;
dartel3.tag     = 'dartel';
dartel3.name    = 'DARTEL flow';
dartel3.val     = {flowfield times K };
dartel3.help    = {'Imported DARTEL flow field.'};
% ---------------------------------------------------------------------
% def Deformation Field
% ---------------------------------------------------------------------
def3         = cfg_files;
def3.tag     = 'def';
def3.name    = 'Deformation Field';
def3.help    = {'Deformations can be thought of as vector fields. These can be represented by three-volume images.'};
def3.filter = '.*y_.*\.nii$';
def3.ufilter = '.*';
def3.num     = [1 1];
% ---------------------------------------------------------------------
% space Image to base Id on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base Id on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% id Identity
% ---------------------------------------------------------------------
id3         = cfg_branch;
id3.tag     = 'id';
id3.name    = 'Identity';
id3.val     = {space };
id3.help    = {'This option generates an identity transform, but this can be useful for changing the dimensions of the resulting deformation (and any images that are generated from it).  Dimensions, orientation etc are derived from an image.'};
% ---------------------------------------------------------------------
% comp Composition
% ---------------------------------------------------------------------
comp3         = cfg_repeat;
comp3.tag     = 'comp';
comp3.name    = 'Composition';
comp3.help    = {
                 'Deformation fields can be thought of as mappings. These can be combined by the operation of "composition", which is usually denoted by a circle "o". Suppose x:A->B and y:B->C are two mappings, where A, B and C refer to domains in 3 dimensions. Each element a in A points to element x(a) in B. This in turn points to element y(x(a)) in C, so we have a mapping from A to C. The composition of these mappings is denoted by yox:A->C. Compositions can be combined in an associative way, such that zo(yox) = (zoy)ox.'
                 ''
                 'In this utility, the left-to-right order of the compositions is from top to bottom (note that the rightmost deformation would actually be applied first). i.e. ...((first o second) o third)...o last. The resulting deformation field will have the same domain as the first deformation specified, and will map to voxels in the codomain of the last specified deformation field.'
}';
comp3.values  = {sn2def3 dartel3 def3 id3 };
comp3.num     = [0 Inf];
% ---------------------------------------------------------------------
% comp Composition
% ---------------------------------------------------------------------
comp2         = cfg_repeat;
comp2.tag     = 'comp';
comp2.name    = 'Composition';
comp2.check   = @check;
comp2.help    = {
                 'Deformation fields can be thought of as mappings. These can be combined by the operation of "composition", which is usually denoted by a circle "o". Suppose x:A->B and y:B->C are two mappings, where A, B and C refer to domains in 3 dimensions. Each element a in A points to element x(a) in B. This in turn points to element y(x(a)) in C, so we have a mapping from A to C. The composition of these mappings is denoted by yox:A->C. Compositions can be combined in an associative way, such that zo(yox) = (zoy)ox.'
                 ''
                 'In this utility, the left-to-right order of the compositions is from top to bottom (note that the rightmost deformation would actually be applied first). i.e. ...((first o second) o third)...o last. The resulting deformation field will have the same domain as the first deformation specified, and will map to voxels in the codomain of the last specified deformation field.'
}';
comp2.values  = {sn2def2 dartel2 def2 id2 inv2 comp3 };
comp2.num     = [0 Inf];
% ---------------------------------------------------------------------
% comp Composition
% ---------------------------------------------------------------------
comp1         = cfg_repeat;
comp1.tag     = 'comp';
comp1.name    = 'Composition';
comp1.check   = @check;
comp1.help    = {
                 'Deformation fields can be thought of as mappings. These can be combined by the operation of "composition", which is usually denoted by a circle "o". Suppose x:A->B and y:B->C are two mappings, where A, B and C refer to domains in 3 dimensions. Each element a in A points to element x(a) in B. This in turn points to element y(x(a)) in C, so we have a mapping from A to C. The composition of these mappings is denoted by yox:A->C. Compositions can be combined in an associative way, such that zo(yox) = (zoy)ox.'
                 ''
                 'In this utility, the left-to-right order of the compositions is from top to bottom (note that the rightmost deformation would actually be applied first). i.e. ...((first o second) o third)...o last. The resulting deformation field will have the same domain as the first deformation specified, and will map to voxels in the codomain of the last specified deformation field.'
}';
comp1.values  = {sn2def1 dartel1 def1 id1 inv1 comp2 };
comp1.num     = [0 Inf];
% ---------------------------------------------------------------------
% space Image to base inverse on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base inverse on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% inv Inverse
% ---------------------------------------------------------------------
inv         = cfg_branch;
inv.tag     = 'inv';
inv.name    = 'Inverse';
inv.val     = {comp1 space };
inv.help    = {
               'Creates the inverse of a deformation field. Deformations are assumed to be one-to-one, in which case they have a unique inverse.  If y'':A->B is the inverse of y:B->A, then y'' o y = y o y'' = Id, where Id is the identity transform.'
               ''
               'Deformations are inverted using the method described in the appendix of:'
               '    * Ashburner J, Andersson JLR & Friston KJ (2000) "Image Registration using a Symmetric Prior - in Three-Dimensions." Human Brain Mapping 9(4):212-225'
}';
% ---------------------------------------------------------------------
% matname Parameter File
% ---------------------------------------------------------------------
matname         = cfg_files;
matname.tag     = 'matname';
matname.name    = 'Parameter File';
matname.help    = {'Specify the _sn.mat to be used.'};
matname.filter = '.*_sn\.mat$';
matname.ufilter = '.*';
matname.num     = [1 1];
% ---------------------------------------------------------------------
% vox Voxel sizes
% ---------------------------------------------------------------------
vox         = cfg_entry;
vox.tag     = 'vox';
vox.name    = 'Voxel sizes';
vox.val{1} = double([NaN NaN NaN]);
vox.help    = {'Specify the voxel sizes of the deformation field to be produced. Non-finite values will default to the voxel sizes of the template imagethat was originally used to estimate the deformation.'};
vox.strtype = 'e';
vox.num     = [1 3];
% ---------------------------------------------------------------------
% bb Bounding box
% ---------------------------------------------------------------------
bb         = cfg_entry;
bb.tag     = 'bb';
bb.name    = 'Bounding box';
bb.val{1} = double([NaN NaN NaN
                    NaN NaN NaN]);
bb.help    = {'Specify the bounding box of the deformation field to be produced. Non-finite values will default to the bounding box of the template imagethat was originally used to estimate the deformation.'};
bb.strtype = 'e';
bb.num     = [2 3];
% ---------------------------------------------------------------------
% sn2def Imported _sn.mat
% ---------------------------------------------------------------------
sn2def1         = cfg_branch;
sn2def1.tag     = 'sn2def';
sn2def1.name    = 'Imported _sn.mat';
sn2def1.val     = {matname vox bb };
sn2def1.help    = {'Spatial normalisation, and the unified segmentation model of SPM5 save a parameterisation of deformation fields.  These consist of a combination of an affine transform, and nonlinear warps that are parameterised by a linear combination of cosine transform basis functions.  These are saved in *_sn.mat files, which can be converted to deformation fields.'};
% ---------------------------------------------------------------------
% flowfield Flow field
% ---------------------------------------------------------------------
flowfield         = cfg_files;
flowfield.tag     = 'flowfield';
flowfield.name    = 'Flow field';
flowfield.help    = {'The flow field stores the deformation information. The same field can be used for both forward or backward deformations (or even, in principle, half way or exaggerated deformations).'};
flowfield.filter = 'nifti';
flowfield.ufilter = '^u_.*';
flowfield.num     = [1 1];
% ---------------------------------------------------------------------
% times Forward/Backwards
% ---------------------------------------------------------------------
times         = cfg_menu;
times.tag     = 'times';
times.name    = 'Forward/Backwards';
times.val{1} = double([1 0]);
times.help    = {'The direction of the DARTEL flow.  Note that a backward transform will warp an individual subject''s to match the template (ie maps from template to individual). A forward transform will warp the template image to the individual.'};
times.labels = {
                'Backward'
                'Forward'
}';
times.values{1} = double([1 0]);
times.values{2} = double([0 1]);
% ---------------------------------------------------------------------
% K Time Steps
% ---------------------------------------------------------------------
K         = cfg_menu;
K.tag     = 'K';
K.name    = 'Time Steps';
K.val{1} = double(6);
K.help    = {'The number of time points used for solving the partial differential equations.  A single time point would be equivalent to a small deformation model. Smaller values allow faster computations, but are less accurate in terms of inverse consistency and may result in the one-to-one mapping breaking down.'};
K.labels = {
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128'
            '256'
            '512'
}';
K.values{1} = double(0);
K.values{2} = double(1);
K.values{3} = double(2);
K.values{4} = double(3);
K.values{5} = double(4);
K.values{6} = double(5);
K.values{7} = double(6);
K.values{8} = double(7);
K.values{9} = double(8);
K.values{10} = double(9);
% ---------------------------------------------------------------------
% dartel DARTEL flow
% ---------------------------------------------------------------------
dartel1         = cfg_branch;
dartel1.tag     = 'dartel';
dartel1.name    = 'DARTEL flow';
dartel1.val     = {flowfield times K };
dartel1.help    = {'Imported DARTEL flow field.'};
% ---------------------------------------------------------------------
% def Deformation Field
% ---------------------------------------------------------------------
def1         = cfg_files;
def1.tag     = 'def';
def1.name    = 'Deformation Field';
def1.help    = {'Deformations can be thought of as vector fields. These can be represented by three-volume images.'};
def1.filter = '.*y_.*\.nii$';
def1.ufilter = '.*';
def1.num     = [1 1];
% ---------------------------------------------------------------------
% space Image to base Id on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base Id on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% id Identity
% ---------------------------------------------------------------------
id1         = cfg_branch;
id1.tag     = 'id';
id1.name    = 'Identity';
id1.val     = {space };
id1.help    = {'This option generates an identity transform, but this can be useful for changing the dimensions of the resulting deformation (and any images that are generated from it).  Dimensions, orientation etc are derived from an image.'};
% ---------------------------------------------------------------------
% matname Parameter File
% ---------------------------------------------------------------------
matname         = cfg_files;
matname.tag     = 'matname';
matname.name    = 'Parameter File';
matname.help    = {'Specify the _sn.mat to be used.'};
matname.filter = '.*_sn\.mat$';
matname.ufilter = '.*';
matname.num     = [1 1];
% ---------------------------------------------------------------------
% vox Voxel sizes
% ---------------------------------------------------------------------
vox         = cfg_entry;
vox.tag     = 'vox';
vox.name    = 'Voxel sizes';
vox.val{1} = double([NaN NaN NaN]);
vox.help    = {'Specify the voxel sizes of the deformation field to be produced. Non-finite values will default to the voxel sizes of the template imagethat was originally used to estimate the deformation.'};
vox.strtype = 'e';
vox.num     = [1 3];
% ---------------------------------------------------------------------
% bb Bounding box
% ---------------------------------------------------------------------
bb         = cfg_entry;
bb.tag     = 'bb';
bb.name    = 'Bounding box';
bb.val{1} = double([NaN NaN NaN
                    NaN NaN NaN]);
bb.help    = {'Specify the bounding box of the deformation field to be produced. Non-finite values will default to the bounding box of the template imagethat was originally used to estimate the deformation.'};
bb.strtype = 'e';
bb.num     = [2 3];
% ---------------------------------------------------------------------
% sn2def Imported _sn.mat
% ---------------------------------------------------------------------
sn2def2         = cfg_branch;
sn2def2.tag     = 'sn2def';
sn2def2.name    = 'Imported _sn.mat';
sn2def2.val     = {matname vox bb };
sn2def2.help    = {'Spatial normalisation, and the unified segmentation model of SPM5 save a parameterisation of deformation fields.  These consist of a combination of an affine transform, and nonlinear warps that are parameterised by a linear combination of cosine transform basis functions.  These are saved in *_sn.mat files, which can be converted to deformation fields.'};
% ---------------------------------------------------------------------
% flowfield Flow field
% ---------------------------------------------------------------------
flowfield         = cfg_files;
flowfield.tag     = 'flowfield';
flowfield.name    = 'Flow field';
flowfield.help    = {'The flow field stores the deformation information. The same field can be used for both forward or backward deformations (or even, in principle, half way or exaggerated deformations).'};
flowfield.filter = 'nifti';
flowfield.ufilter = '^u_.*';
flowfield.num     = [1 1];
% ---------------------------------------------------------------------
% times Forward/Backwards
% ---------------------------------------------------------------------
times         = cfg_menu;
times.tag     = 'times';
times.name    = 'Forward/Backwards';
times.val{1} = double([1 0]);
times.help    = {'The direction of the DARTEL flow.  Note that a backward transform will warp an individual subject''s to match the template (ie maps from template to individual). A forward transform will warp the template image to the individual.'};
times.labels = {
                'Backward'
                'Forward'
}';
times.values{1} = double([1 0]);
times.values{2} = double([0 1]);
% ---------------------------------------------------------------------
% K Time Steps
% ---------------------------------------------------------------------
K         = cfg_menu;
K.tag     = 'K';
K.name    = 'Time Steps';
K.val{1} = double(6);
K.help    = {'The number of time points used for solving the partial differential equations.  A single time point would be equivalent to a small deformation model. Smaller values allow faster computations, but are less accurate in terms of inverse consistency and may result in the one-to-one mapping breaking down.'};
K.labels = {
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128'
            '256'
            '512'
}';
K.values{1} = double(0);
K.values{2} = double(1);
K.values{3} = double(2);
K.values{4} = double(3);
K.values{5} = double(4);
K.values{6} = double(5);
K.values{7} = double(6);
K.values{8} = double(7);
K.values{9} = double(8);
K.values{10} = double(9);
% ---------------------------------------------------------------------
% dartel DARTEL flow
% ---------------------------------------------------------------------
dartel2         = cfg_branch;
dartel2.tag     = 'dartel';
dartel2.name    = 'DARTEL flow';
dartel2.val     = {flowfield times K };
dartel2.help    = {'Imported DARTEL flow field.'};
% ---------------------------------------------------------------------
% def Deformation Field
% ---------------------------------------------------------------------
def2         = cfg_files;
def2.tag     = 'def';
def2.name    = 'Deformation Field';
def2.help    = {'Deformations can be thought of as vector fields. These can be represented by three-volume images.'};
def2.filter = '.*y_.*\.nii$';
def2.ufilter = '.*';
def2.num     = [1 1];
% ---------------------------------------------------------------------
% space Image to base Id on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base Id on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% id Identity
% ---------------------------------------------------------------------
id2         = cfg_branch;
id2.tag     = 'id';
id2.name    = 'Identity';
id2.val     = {space };
id2.help    = {'This option generates an identity transform, but this can be useful for changing the dimensions of the resulting deformation (and any images that are generated from it).  Dimensions, orientation etc are derived from an image.'};
% ---------------------------------------------------------------------
% matname Parameter File
% ---------------------------------------------------------------------
matname         = cfg_files;
matname.tag     = 'matname';
matname.name    = 'Parameter File';
matname.help    = {'Specify the _sn.mat to be used.'};
matname.filter = '.*_sn\.mat$';
matname.ufilter = '.*';
matname.num     = [1 1];
% ---------------------------------------------------------------------
% vox Voxel sizes
% ---------------------------------------------------------------------
vox         = cfg_entry;
vox.tag     = 'vox';
vox.name    = 'Voxel sizes';
vox.val{1} = double([NaN NaN NaN]);
vox.help    = {'Specify the voxel sizes of the deformation field to be produced. Non-finite values will default to the voxel sizes of the template imagethat was originally used to estimate the deformation.'};
vox.strtype = 'e';
vox.num     = [1 3];
% ---------------------------------------------------------------------
% bb Bounding box
% ---------------------------------------------------------------------
bb         = cfg_entry;
bb.tag     = 'bb';
bb.name    = 'Bounding box';
bb.val{1} = double([NaN NaN NaN
                    NaN NaN NaN]);
bb.help    = {'Specify the bounding box of the deformation field to be produced. Non-finite values will default to the bounding box of the template imagethat was originally used to estimate the deformation.'};
bb.strtype = 'e';
bb.num     = [2 3];
% ---------------------------------------------------------------------
% sn2def Imported _sn.mat
% ---------------------------------------------------------------------
sn2def3         = cfg_branch;
sn2def3.tag     = 'sn2def';
sn2def3.name    = 'Imported _sn.mat';
sn2def3.val     = {matname vox bb };
sn2def3.help    = {'Spatial normalisation, and the unified segmentation model of SPM5 save a parameterisation of deformation fields.  These consist of a combination of an affine transform, and nonlinear warps that are parameterised by a linear combination of cosine transform basis functions.  These are saved in *_sn.mat files, which can be converted to deformation fields.'};
% ---------------------------------------------------------------------
% flowfield Flow field
% ---------------------------------------------------------------------
flowfield         = cfg_files;
flowfield.tag     = 'flowfield';
flowfield.name    = 'Flow field';
flowfield.help    = {'The flow field stores the deformation information. The same field can be used for both forward or backward deformations (or even, in principle, half way or exaggerated deformations).'};
flowfield.filter = 'nifti';
flowfield.ufilter = '^u_.*';
flowfield.num     = [1 1];
% ---------------------------------------------------------------------
% times Forward/Backwards
% ---------------------------------------------------------------------
times         = cfg_menu;
times.tag     = 'times';
times.name    = 'Forward/Backwards';
times.val{1} = double([1 0]);
times.help    = {'The direction of the DARTEL flow.  Note that a backward transform will warp an individual subject''s to match the template (ie maps from template to individual). A forward transform will warp the template image to the individual.'};
times.labels = {
                'Backward'
                'Forward'
}';
times.values{1} = double([1 0]);
times.values{2} = double([0 1]);
% ---------------------------------------------------------------------
% K Time Steps
% ---------------------------------------------------------------------
K         = cfg_menu;
K.tag     = 'K';
K.name    = 'Time Steps';
K.val{1} = double(6);
K.help    = {'The number of time points used for solving the partial differential equations.  A single time point would be equivalent to a small deformation model. Smaller values allow faster computations, but are less accurate in terms of inverse consistency and may result in the one-to-one mapping breaking down.'};
K.labels = {
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128'
            '256'
            '512'
}';
K.values{1} = double(0);
K.values{2} = double(1);
K.values{3} = double(2);
K.values{4} = double(3);
K.values{5} = double(4);
K.values{6} = double(5);
K.values{7} = double(6);
K.values{8} = double(7);
K.values{9} = double(8);
K.values{10} = double(9);
% ---------------------------------------------------------------------
% dartel DARTEL flow
% ---------------------------------------------------------------------
dartel3         = cfg_branch;
dartel3.tag     = 'dartel';
dartel3.name    = 'DARTEL flow';
dartel3.val     = {flowfield times K };
dartel3.help    = {'Imported DARTEL flow field.'};
% ---------------------------------------------------------------------
% def Deformation Field
% ---------------------------------------------------------------------
def3         = cfg_files;
def3.tag     = 'def';
def3.name    = 'Deformation Field';
def3.help    = {'Deformations can be thought of as vector fields. These can be represented by three-volume images.'};
def3.filter = '.*y_.*\.nii$';
def3.ufilter = '.*';
def3.num     = [1 1];
% ---------------------------------------------------------------------
% space Image to base Id on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base Id on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% id Identity
% ---------------------------------------------------------------------
id3         = cfg_branch;
id3.tag     = 'id';
id3.name    = 'Identity';
id3.val     = {space };
id3.help    = {'This option generates an identity transform, but this can be useful for changing the dimensions of the resulting deformation (and any images that are generated from it).  Dimensions, orientation etc are derived from an image.'};
% ---------------------------------------------------------------------
% comp Composition
% ---------------------------------------------------------------------
comp3         = cfg_repeat;
comp3.tag     = 'comp';
comp3.name    = 'Composition';
comp3.help    = {
                 'Deformation fields can be thought of as mappings. These can be combined by the operation of "composition", which is usually denoted by a circle "o". Suppose x:A->B and y:B->C are two mappings, where A, B and C refer to domains in 3 dimensions. Each element a in A points to element x(a) in B. This in turn points to element y(x(a)) in C, so we have a mapping from A to C. The composition of these mappings is denoted by yox:A->C. Compositions can be combined in an associative way, such that zo(yox) = (zoy)ox.'
                 ''
                 'In this utility, the left-to-right order of the compositions is from top to bottom (note that the rightmost deformation would actually be applied first). i.e. ...((first o second) o third)...o last. The resulting deformation field will have the same domain as the first deformation specified, and will map to voxels in the codomain of the last specified deformation field.'
}';
comp3.values  = {sn2def3 dartel3 def3 id3 };
comp3.num     = [0 Inf];
% ---------------------------------------------------------------------
% space Image to base inverse on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base inverse on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% inv Inverse
% ---------------------------------------------------------------------
inv2         = cfg_branch;
inv2.tag     = 'inv';
inv2.name    = 'Inverse';
inv2.val     = {comp3 space };
inv2.help    = {
                'Creates the inverse of a deformation field. Deformations are assumed to be one-to-one, in which case they have a unique inverse.  If y'':A->B is the inverse of y:B->A, then y'' o y = y o y'' = Id, where Id is the identity transform.'
                ''
                'Deformations are inverted using the method described in the appendix of:'
                '    * Ashburner J, Andersson JLR & Friston KJ (2000) "Image Registration using a Symmetric Prior - in Three-Dimensions." Human Brain Mapping 9(4):212-225'
}';
% ---------------------------------------------------------------------
% matname Parameter File
% ---------------------------------------------------------------------
matname         = cfg_files;
matname.tag     = 'matname';
matname.name    = 'Parameter File';
matname.help    = {'Specify the _sn.mat to be used.'};
matname.filter = '.*_sn\.mat$';
matname.ufilter = '.*';
matname.num     = [1 1];
% ---------------------------------------------------------------------
% vox Voxel sizes
% ---------------------------------------------------------------------
vox         = cfg_entry;
vox.tag     = 'vox';
vox.name    = 'Voxel sizes';
vox.val{1} = double([NaN NaN NaN]);
vox.help    = {'Specify the voxel sizes of the deformation field to be produced. Non-finite values will default to the voxel sizes of the template imagethat was originally used to estimate the deformation.'};
vox.strtype = 'e';
vox.num     = [1 3];
% ---------------------------------------------------------------------
% bb Bounding box
% ---------------------------------------------------------------------
bb         = cfg_entry;
bb.tag     = 'bb';
bb.name    = 'Bounding box';
bb.val{1} = double([NaN NaN NaN
                    NaN NaN NaN]);
bb.help    = {'Specify the bounding box of the deformation field to be produced. Non-finite values will default to the bounding box of the template imagethat was originally used to estimate the deformation.'};
bb.strtype = 'e';
bb.num     = [2 3];
% ---------------------------------------------------------------------
% sn2def Imported _sn.mat
% ---------------------------------------------------------------------
sn2def3         = cfg_branch;
sn2def3.tag     = 'sn2def';
sn2def3.name    = 'Imported _sn.mat';
sn2def3.val     = {matname vox bb };
sn2def3.help    = {'Spatial normalisation, and the unified segmentation model of SPM5 save a parameterisation of deformation fields.  These consist of a combination of an affine transform, and nonlinear warps that are parameterised by a linear combination of cosine transform basis functions.  These are saved in *_sn.mat files, which can be converted to deformation fields.'};
% ---------------------------------------------------------------------
% flowfield Flow field
% ---------------------------------------------------------------------
flowfield         = cfg_files;
flowfield.tag     = 'flowfield';
flowfield.name    = 'Flow field';
flowfield.help    = {'The flow field stores the deformation information. The same field can be used for both forward or backward deformations (or even, in principle, half way or exaggerated deformations).'};
flowfield.filter = 'nifti';
flowfield.ufilter = '^u_.*';
flowfield.num     = [1 1];
% ---------------------------------------------------------------------
% times Forward/Backwards
% ---------------------------------------------------------------------
times         = cfg_menu;
times.tag     = 'times';
times.name    = 'Forward/Backwards';
times.val{1} = double([1 0]);
times.help    = {'The direction of the DARTEL flow.  Note that a backward transform will warp an individual subject''s to match the template (ie maps from template to individual). A forward transform will warp the template image to the individual.'};
times.labels = {
                'Backward'
                'Forward'
}';
times.values{1} = double([1 0]);
times.values{2} = double([0 1]);
% ---------------------------------------------------------------------
% K Time Steps
% ---------------------------------------------------------------------
K         = cfg_menu;
K.tag     = 'K';
K.name    = 'Time Steps';
K.val{1} = double(6);
K.help    = {'The number of time points used for solving the partial differential equations.  A single time point would be equivalent to a small deformation model. Smaller values allow faster computations, but are less accurate in terms of inverse consistency and may result in the one-to-one mapping breaking down.'};
K.labels = {
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128'
            '256'
            '512'
}';
K.values{1} = double(0);
K.values{2} = double(1);
K.values{3} = double(2);
K.values{4} = double(3);
K.values{5} = double(4);
K.values{6} = double(5);
K.values{7} = double(6);
K.values{8} = double(7);
K.values{9} = double(8);
K.values{10} = double(9);
% ---------------------------------------------------------------------
% dartel DARTEL flow
% ---------------------------------------------------------------------
dartel3         = cfg_branch;
dartel3.tag     = 'dartel';
dartel3.name    = 'DARTEL flow';
dartel3.val     = {flowfield times K };
dartel3.help    = {'Imported DARTEL flow field.'};
% ---------------------------------------------------------------------
% def Deformation Field
% ---------------------------------------------------------------------
def3         = cfg_files;
def3.tag     = 'def';
def3.name    = 'Deformation Field';
def3.help    = {'Deformations can be thought of as vector fields. These can be represented by three-volume images.'};
def3.filter = '.*y_.*\.nii$';
def3.ufilter = '.*';
def3.num     = [1 1];
% ---------------------------------------------------------------------
% space Image to base Id on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base Id on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% id Identity
% ---------------------------------------------------------------------
id3         = cfg_branch;
id3.tag     = 'id';
id3.name    = 'Identity';
id3.val     = {space };
id3.help    = {'This option generates an identity transform, but this can be useful for changing the dimensions of the resulting deformation (and any images that are generated from it).  Dimensions, orientation etc are derived from an image.'};
% ---------------------------------------------------------------------
% comp Composition
% ---------------------------------------------------------------------
comp3         = cfg_repeat;
comp3.tag     = 'comp';
comp3.name    = 'Composition';
comp3.help    = {
                 'Deformation fields can be thought of as mappings. These can be combined by the operation of "composition", which is usually denoted by a circle "o". Suppose x:A->B and y:B->C are two mappings, where A, B and C refer to domains in 3 dimensions. Each element a in A points to element x(a) in B. This in turn points to element y(x(a)) in C, so we have a mapping from A to C. The composition of these mappings is denoted by yox:A->C. Compositions can be combined in an associative way, such that zo(yox) = (zoy)ox.'
                 ''
                 'In this utility, the left-to-right order of the compositions is from top to bottom (note that the rightmost deformation would actually be applied first). i.e. ...((first o second) o third)...o last. The resulting deformation field will have the same domain as the first deformation specified, and will map to voxels in the codomain of the last specified deformation field.'
}';
comp3.values  = {sn2def3 dartel3 def3 id3 };
comp3.num     = [0 Inf];
% ---------------------------------------------------------------------
% comp Composition
% ---------------------------------------------------------------------
comp2         = cfg_repeat;
comp2.tag     = 'comp';
comp2.name    = 'Composition';
comp2.check   = @check;
comp2.help    = {
                 'Deformation fields can be thought of as mappings. These can be combined by the operation of "composition", which is usually denoted by a circle "o". Suppose x:A->B and y:B->C are two mappings, where A, B and C refer to domains in 3 dimensions. Each element a in A points to element x(a) in B. This in turn points to element y(x(a)) in C, so we have a mapping from A to C. The composition of these mappings is denoted by yox:A->C. Compositions can be combined in an associative way, such that zo(yox) = (zoy)ox.'
                 ''
                 'In this utility, the left-to-right order of the compositions is from top to bottom (note that the rightmost deformation would actually be applied first). i.e. ...((first o second) o third)...o last. The resulting deformation field will have the same domain as the first deformation specified, and will map to voxels in the codomain of the last specified deformation field.'
}';
comp2.values  = {sn2def2 dartel2 def2 id2 inv2 comp3 };
comp2.num     = [0 Inf];
% ---------------------------------------------------------------------
% space Image to base inverse on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base inverse on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% inv Inverse
% ---------------------------------------------------------------------
inv1         = cfg_branch;
inv1.tag     = 'inv';
inv1.name    = 'Inverse';
inv1.val     = {comp2 space };
inv1.help    = {
                'Creates the inverse of a deformation field. Deformations are assumed to be one-to-one, in which case they have a unique inverse.  If y'':A->B is the inverse of y:B->A, then y'' o y = y o y'' = Id, where Id is the identity transform.'
                ''
                'Deformations are inverted using the method described in the appendix of:'
                '    * Ashburner J, Andersson JLR & Friston KJ (2000) "Image Registration using a Symmetric Prior - in Three-Dimensions." Human Brain Mapping 9(4):212-225'
}';
% ---------------------------------------------------------------------
% matname Parameter File
% ---------------------------------------------------------------------
matname         = cfg_files;
matname.tag     = 'matname';
matname.name    = 'Parameter File';
matname.help    = {'Specify the _sn.mat to be used.'};
matname.filter = '.*_sn\.mat$';
matname.ufilter = '.*';
matname.num     = [1 1];
% ---------------------------------------------------------------------
% vox Voxel sizes
% ---------------------------------------------------------------------
vox         = cfg_entry;
vox.tag     = 'vox';
vox.name    = 'Voxel sizes';
vox.val{1} = double([NaN NaN NaN]);
vox.help    = {'Specify the voxel sizes of the deformation field to be produced. Non-finite values will default to the voxel sizes of the template imagethat was originally used to estimate the deformation.'};
vox.strtype = 'e';
vox.num     = [1 3];
% ---------------------------------------------------------------------
% bb Bounding box
% ---------------------------------------------------------------------
bb         = cfg_entry;
bb.tag     = 'bb';
bb.name    = 'Bounding box';
bb.val{1} = double([NaN NaN NaN
                    NaN NaN NaN]);
bb.help    = {'Specify the bounding box of the deformation field to be produced. Non-finite values will default to the bounding box of the template imagethat was originally used to estimate the deformation.'};
bb.strtype = 'e';
bb.num     = [2 3];
% ---------------------------------------------------------------------
% sn2def Imported _sn.mat
% ---------------------------------------------------------------------
sn2def2         = cfg_branch;
sn2def2.tag     = 'sn2def';
sn2def2.name    = 'Imported _sn.mat';
sn2def2.val     = {matname vox bb };
sn2def2.help    = {'Spatial normalisation, and the unified segmentation model of SPM5 save a parameterisation of deformation fields.  These consist of a combination of an affine transform, and nonlinear warps that are parameterised by a linear combination of cosine transform basis functions.  These are saved in *_sn.mat files, which can be converted to deformation fields.'};
% ---------------------------------------------------------------------
% flowfield Flow field
% ---------------------------------------------------------------------
flowfield         = cfg_files;
flowfield.tag     = 'flowfield';
flowfield.name    = 'Flow field';
flowfield.help    = {'The flow field stores the deformation information. The same field can be used for both forward or backward deformations (or even, in principle, half way or exaggerated deformations).'};
flowfield.filter = 'nifti';
flowfield.ufilter = '^u_.*';
flowfield.num     = [1 1];
% ---------------------------------------------------------------------
% times Forward/Backwards
% ---------------------------------------------------------------------
times         = cfg_menu;
times.tag     = 'times';
times.name    = 'Forward/Backwards';
times.val{1} = double([1 0]);
times.help    = {'The direction of the DARTEL flow.  Note that a backward transform will warp an individual subject''s to match the template (ie maps from template to individual). A forward transform will warp the template image to the individual.'};
times.labels = {
                'Backward'
                'Forward'
}';
times.values{1} = double([1 0]);
times.values{2} = double([0 1]);
% ---------------------------------------------------------------------
% K Time Steps
% ---------------------------------------------------------------------
K         = cfg_menu;
K.tag     = 'K';
K.name    = 'Time Steps';
K.val{1} = double(6);
K.help    = {'The number of time points used for solving the partial differential equations.  A single time point would be equivalent to a small deformation model. Smaller values allow faster computations, but are less accurate in terms of inverse consistency and may result in the one-to-one mapping breaking down.'};
K.labels = {
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128'
            '256'
            '512'
}';
K.values{1} = double(0);
K.values{2} = double(1);
K.values{3} = double(2);
K.values{4} = double(3);
K.values{5} = double(4);
K.values{6} = double(5);
K.values{7} = double(6);
K.values{8} = double(7);
K.values{9} = double(8);
K.values{10} = double(9);
% ---------------------------------------------------------------------
% dartel DARTEL flow
% ---------------------------------------------------------------------
dartel2         = cfg_branch;
dartel2.tag     = 'dartel';
dartel2.name    = 'DARTEL flow';
dartel2.val     = {flowfield times K };
dartel2.help    = {'Imported DARTEL flow field.'};
% ---------------------------------------------------------------------
% def Deformation Field
% ---------------------------------------------------------------------
def2         = cfg_files;
def2.tag     = 'def';
def2.name    = 'Deformation Field';
def2.help    = {'Deformations can be thought of as vector fields. These can be represented by three-volume images.'};
def2.filter = '.*y_.*\.nii$';
def2.ufilter = '.*';
def2.num     = [1 1];
% ---------------------------------------------------------------------
% space Image to base Id on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base Id on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% id Identity
% ---------------------------------------------------------------------
id2         = cfg_branch;
id2.tag     = 'id';
id2.name    = 'Identity';
id2.val     = {space };
id2.help    = {'This option generates an identity transform, but this can be useful for changing the dimensions of the resulting deformation (and any images that are generated from it).  Dimensions, orientation etc are derived from an image.'};
% ---------------------------------------------------------------------
% matname Parameter File
% ---------------------------------------------------------------------
matname         = cfg_files;
matname.tag     = 'matname';
matname.name    = 'Parameter File';
matname.help    = {'Specify the _sn.mat to be used.'};
matname.filter = '.*_sn\.mat$';
matname.ufilter = '.*';
matname.num     = [1 1];
% ---------------------------------------------------------------------
% vox Voxel sizes
% ---------------------------------------------------------------------
vox         = cfg_entry;
vox.tag     = 'vox';
vox.name    = 'Voxel sizes';
vox.val{1} = double([NaN NaN NaN]);
vox.help    = {'Specify the voxel sizes of the deformation field to be produced. Non-finite values will default to the voxel sizes of the template imagethat was originally used to estimate the deformation.'};
vox.strtype = 'e';
vox.num     = [1 3];
% ---------------------------------------------------------------------
% bb Bounding box
% ---------------------------------------------------------------------
bb         = cfg_entry;
bb.tag     = 'bb';
bb.name    = 'Bounding box';
bb.val{1} = double([NaN NaN NaN
                    NaN NaN NaN]);
bb.help    = {'Specify the bounding box of the deformation field to be produced. Non-finite values will default to the bounding box of the template imagethat was originally used to estimate the deformation.'};
bb.strtype = 'e';
bb.num     = [2 3];
% ---------------------------------------------------------------------
% sn2def Imported _sn.mat
% ---------------------------------------------------------------------
sn2def3         = cfg_branch;
sn2def3.tag     = 'sn2def';
sn2def3.name    = 'Imported _sn.mat';
sn2def3.val     = {matname vox bb };
sn2def3.help    = {'Spatial normalisation, and the unified segmentation model of SPM5 save a parameterisation of deformation fields.  These consist of a combination of an affine transform, and nonlinear warps that are parameterised by a linear combination of cosine transform basis functions.  These are saved in *_sn.mat files, which can be converted to deformation fields.'};
% ---------------------------------------------------------------------
% flowfield Flow field
% ---------------------------------------------------------------------
flowfield         = cfg_files;
flowfield.tag     = 'flowfield';
flowfield.name    = 'Flow field';
flowfield.help    = {'The flow field stores the deformation information. The same field can be used for both forward or backward deformations (or even, in principle, half way or exaggerated deformations).'};
flowfield.filter = 'nifti';
flowfield.ufilter = '^u_.*';
flowfield.num     = [1 1];
% ---------------------------------------------------------------------
% times Forward/Backwards
% ---------------------------------------------------------------------
times         = cfg_menu;
times.tag     = 'times';
times.name    = 'Forward/Backwards';
times.val{1} = double([1 0]);
times.help    = {'The direction of the DARTEL flow.  Note that a backward transform will warp an individual subject''s to match the template (ie maps from template to individual). A forward transform will warp the template image to the individual.'};
times.labels = {
                'Backward'
                'Forward'
}';
times.values{1} = double([1 0]);
times.values{2} = double([0 1]);
% ---------------------------------------------------------------------
% K Time Steps
% ---------------------------------------------------------------------
K         = cfg_menu;
K.tag     = 'K';
K.name    = 'Time Steps';
K.val{1} = double(6);
K.help    = {'The number of time points used for solving the partial differential equations.  A single time point would be equivalent to a small deformation model. Smaller values allow faster computations, but are less accurate in terms of inverse consistency and may result in the one-to-one mapping breaking down.'};
K.labels = {
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128'
            '256'
            '512'
}';
K.values{1} = double(0);
K.values{2} = double(1);
K.values{3} = double(2);
K.values{4} = double(3);
K.values{5} = double(4);
K.values{6} = double(5);
K.values{7} = double(6);
K.values{8} = double(7);
K.values{9} = double(8);
K.values{10} = double(9);
% ---------------------------------------------------------------------
% dartel DARTEL flow
% ---------------------------------------------------------------------
dartel3         = cfg_branch;
dartel3.tag     = 'dartel';
dartel3.name    = 'DARTEL flow';
dartel3.val     = {flowfield times K };
dartel3.help    = {'Imported DARTEL flow field.'};
% ---------------------------------------------------------------------
% def Deformation Field
% ---------------------------------------------------------------------
def3         = cfg_files;
def3.tag     = 'def';
def3.name    = 'Deformation Field';
def3.help    = {'Deformations can be thought of as vector fields. These can be represented by three-volume images.'};
def3.filter = '.*y_.*\.nii$';
def3.ufilter = '.*';
def3.num     = [1 1];
% ---------------------------------------------------------------------
% space Image to base Id on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base Id on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% id Identity
% ---------------------------------------------------------------------
id3         = cfg_branch;
id3.tag     = 'id';
id3.name    = 'Identity';
id3.val     = {space };
id3.help    = {'This option generates an identity transform, but this can be useful for changing the dimensions of the resulting deformation (and any images that are generated from it).  Dimensions, orientation etc are derived from an image.'};
% ---------------------------------------------------------------------
% comp Composition
% ---------------------------------------------------------------------
comp3         = cfg_repeat;
comp3.tag     = 'comp';
comp3.name    = 'Composition';
comp3.help    = {
                 'Deformation fields can be thought of as mappings. These can be combined by the operation of "composition", which is usually denoted by a circle "o". Suppose x:A->B and y:B->C are two mappings, where A, B and C refer to domains in 3 dimensions. Each element a in A points to element x(a) in B. This in turn points to element y(x(a)) in C, so we have a mapping from A to C. The composition of these mappings is denoted by yox:A->C. Compositions can be combined in an associative way, such that zo(yox) = (zoy)ox.'
                 ''
                 'In this utility, the left-to-right order of the compositions is from top to bottom (note that the rightmost deformation would actually be applied first). i.e. ...((first o second) o third)...o last. The resulting deformation field will have the same domain as the first deformation specified, and will map to voxels in the codomain of the last specified deformation field.'
}';
comp3.values  = {sn2def3 dartel3 def3 id3 };
comp3.num     = [0 Inf];
% ---------------------------------------------------------------------
% space Image to base inverse on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base inverse on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% inv Inverse
% ---------------------------------------------------------------------
inv2         = cfg_branch;
inv2.tag     = 'inv';
inv2.name    = 'Inverse';
inv2.val     = {comp3 space };
inv2.help    = {
                'Creates the inverse of a deformation field. Deformations are assumed to be one-to-one, in which case they have a unique inverse.  If y'':A->B is the inverse of y:B->A, then y'' o y = y o y'' = Id, where Id is the identity transform.'
                ''
                'Deformations are inverted using the method described in the appendix of:'
                '    * Ashburner J, Andersson JLR & Friston KJ (2000) "Image Registration using a Symmetric Prior - in Three-Dimensions." Human Brain Mapping 9(4):212-225'
}';
% ---------------------------------------------------------------------
% matname Parameter File
% ---------------------------------------------------------------------
matname         = cfg_files;
matname.tag     = 'matname';
matname.name    = 'Parameter File';
matname.help    = {'Specify the _sn.mat to be used.'};
matname.filter = '.*_sn\.mat$';
matname.ufilter = '.*';
matname.num     = [1 1];
% ---------------------------------------------------------------------
% vox Voxel sizes
% ---------------------------------------------------------------------
vox         = cfg_entry;
vox.tag     = 'vox';
vox.name    = 'Voxel sizes';
vox.val{1} = double([NaN NaN NaN]);
vox.help    = {'Specify the voxel sizes of the deformation field to be produced. Non-finite values will default to the voxel sizes of the template imagethat was originally used to estimate the deformation.'};
vox.strtype = 'e';
vox.num     = [1 3];
% ---------------------------------------------------------------------
% bb Bounding box
% ---------------------------------------------------------------------
bb         = cfg_entry;
bb.tag     = 'bb';
bb.name    = 'Bounding box';
bb.val{1} = double([NaN NaN NaN
                    NaN NaN NaN]);
bb.help    = {'Specify the bounding box of the deformation field to be produced. Non-finite values will default to the bounding box of the template imagethat was originally used to estimate the deformation.'};
bb.strtype = 'e';
bb.num     = [2 3];
% ---------------------------------------------------------------------
% sn2def Imported _sn.mat
% ---------------------------------------------------------------------
sn2def3         = cfg_branch;
sn2def3.tag     = 'sn2def';
sn2def3.name    = 'Imported _sn.mat';
sn2def3.val     = {matname vox bb };
sn2def3.help    = {'Spatial normalisation, and the unified segmentation model of SPM5 save a parameterisation of deformation fields.  These consist of a combination of an affine transform, and nonlinear warps that are parameterised by a linear combination of cosine transform basis functions.  These are saved in *_sn.mat files, which can be converted to deformation fields.'};
% ---------------------------------------------------------------------
% flowfield Flow field
% ---------------------------------------------------------------------
flowfield         = cfg_files;
flowfield.tag     = 'flowfield';
flowfield.name    = 'Flow field';
flowfield.help    = {'The flow field stores the deformation information. The same field can be used for both forward or backward deformations (or even, in principle, half way or exaggerated deformations).'};
flowfield.filter = 'nifti';
flowfield.ufilter = '^u_.*';
flowfield.num     = [1 1];
% ---------------------------------------------------------------------
% times Forward/Backwards
% ---------------------------------------------------------------------
times         = cfg_menu;
times.tag     = 'times';
times.name    = 'Forward/Backwards';
times.val{1} = double([1 0]);
times.help    = {'The direction of the DARTEL flow.  Note that a backward transform will warp an individual subject''s to match the template (ie maps from template to individual). A forward transform will warp the template image to the individual.'};
times.labels = {
                'Backward'
                'Forward'
}';
times.values{1} = double([1 0]);
times.values{2} = double([0 1]);
% ---------------------------------------------------------------------
% K Time Steps
% ---------------------------------------------------------------------
K         = cfg_menu;
K.tag     = 'K';
K.name    = 'Time Steps';
K.val{1} = double(6);
K.help    = {'The number of time points used for solving the partial differential equations.  A single time point would be equivalent to a small deformation model. Smaller values allow faster computations, but are less accurate in terms of inverse consistency and may result in the one-to-one mapping breaking down.'};
K.labels = {
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128'
            '256'
            '512'
}';
K.values{1} = double(0);
K.values{2} = double(1);
K.values{3} = double(2);
K.values{4} = double(3);
K.values{5} = double(4);
K.values{6} = double(5);
K.values{7} = double(6);
K.values{8} = double(7);
K.values{9} = double(8);
K.values{10} = double(9);
% ---------------------------------------------------------------------
% dartel DARTEL flow
% ---------------------------------------------------------------------
dartel3         = cfg_branch;
dartel3.tag     = 'dartel';
dartel3.name    = 'DARTEL flow';
dartel3.val     = {flowfield times K };
dartel3.help    = {'Imported DARTEL flow field.'};
% ---------------------------------------------------------------------
% def Deformation Field
% ---------------------------------------------------------------------
def3         = cfg_files;
def3.tag     = 'def';
def3.name    = 'Deformation Field';
def3.help    = {'Deformations can be thought of as vector fields. These can be represented by three-volume images.'};
def3.filter = '.*y_.*\.nii$';
def3.ufilter = '.*';
def3.num     = [1 1];
% ---------------------------------------------------------------------
% space Image to base Id on
% ---------------------------------------------------------------------
space         = cfg_files;
space.tag     = 'space';
space.name    = 'Image to base Id on';
space.help    = {'Specify the image file on which to base the dimensions, orientation etc.'};
space.filter = 'image';
space.ufilter = '.*';
space.num     = [1 1];
% ---------------------------------------------------------------------
% id Identity
% ---------------------------------------------------------------------
id3         = cfg_branch;
id3.tag     = 'id';
id3.name    = 'Identity';
id3.val     = {space };
id3.help    = {'This option generates an identity transform, but this can be useful for changing the dimensions of the resulting deformation (and any images that are generated from it).  Dimensions, orientation etc are derived from an image.'};
% ---------------------------------------------------------------------
% comp Composition
% ---------------------------------------------------------------------
comp3         = cfg_repeat;
comp3.tag     = 'comp';
comp3.name    = 'Composition';
comp3.help    = {
                 'Deformation fields can be thought of as mappings. These can be combined by the operation of "composition", which is usually denoted by a circle "o". Suppose x:A->B and y:B->C are two mappings, where A, B and C refer to domains in 3 dimensions. Each element a in A points to element x(a) in B. This in turn points to element y(x(a)) in C, so we have a mapping from A to C. The composition of these mappings is denoted by yox:A->C. Compositions can be combined in an associative way, such that zo(yox) = (zoy)ox.'
                 ''
                 'In this utility, the left-to-right order of the compositions is from top to bottom (note that the rightmost deformation would actually be applied first). i.e. ...((first o second) o third)...o last. The resulting deformation field will have the same domain as the first deformation specified, and will map to voxels in the codomain of the last specified deformation field.'
}';
comp3.values  = {sn2def3 dartel3 def3 id3 };
comp3.num     = [0 Inf];
% ---------------------------------------------------------------------
% comp Composition
% ---------------------------------------------------------------------
comp2         = cfg_repeat;
comp2.tag     = 'comp';
comp2.name    = 'Composition';
comp2.check   = @check;
comp2.help    = {
                 'Deformation fields can be thought of as mappings. These can be combined by the operation of "composition", which is usually denoted by a circle "o". Suppose x:A->B and y:B->C are two mappings, where A, B and C refer to domains in 3 dimensions. Each element a in A points to element x(a) in B. This in turn points to element y(x(a)) in C, so we have a mapping from A to C. The composition of these mappings is denoted by yox:A->C. Compositions can be combined in an associative way, such that zo(yox) = (zoy)ox.'
                 ''
                 'In this utility, the left-to-right order of the compositions is from top to bottom (note that the rightmost deformation would actually be applied first). i.e. ...((first o second) o third)...o last. The resulting deformation field will have the same domain as the first deformation specified, and will map to voxels in the codomain of the last specified deformation field.'
}';
comp2.values  = {sn2def2 dartel2 def2 id2 inv2 comp3 };
comp2.num     = [0 Inf];
% ---------------------------------------------------------------------
% comp Composition
% ---------------------------------------------------------------------
comp1         = cfg_repeat;
comp1.tag     = 'comp';
comp1.name    = 'Composition';
comp1.check   = @check;
comp1.help    = {
                 'Deformation fields can be thought of as mappings. These can be combined by the operation of "composition", which is usually denoted by a circle "o". Suppose x:A->B and y:B->C are two mappings, where A, B and C refer to domains in 3 dimensions. Each element a in A points to element x(a) in B. This in turn points to element y(x(a)) in C, so we have a mapping from A to C. The composition of these mappings is denoted by yox:A->C. Compositions can be combined in an associative way, such that zo(yox) = (zoy)ox.'
                 ''
                 'In this utility, the left-to-right order of the compositions is from top to bottom (note that the rightmost deformation would actually be applied first). i.e. ...((first o second) o third)...o last. The resulting deformation field will have the same domain as the first deformation specified, and will map to voxels in the codomain of the last specified deformation field.'
}';
comp1.values  = {sn2def1 dartel1 def1 id1 inv1 comp2 };
comp1.num     = [0 Inf];
% ---------------------------------------------------------------------
% comp Composition
% ---------------------------------------------------------------------
comp         = cfg_repeat;
comp.tag     = 'comp';
comp.name    = 'Composition';
comp.check   = @check;
comp.help    = {
                'Deformation fields can be thought of as mappings. These can be combined by the operation of "composition", which is usually denoted by a circle "o". Suppose x:A->B and y:B->C are two mappings, where A, B and C refer to domains in 3 dimensions. Each element a in A points to element x(a) in B. This in turn points to element y(x(a)) in C, so we have a mapping from A to C. The composition of these mappings is denoted by yox:A->C. Compositions can be combined in an associative way, such that zo(yox) = (zoy)ox.'
                ''
                'In this utility, the left-to-right order of the compositions is from top to bottom (note that the rightmost deformation would actually be applied first). i.e. ...((first o second) o third)...o last. The resulting deformation field will have the same domain as the first deformation specified, and will map to voxels in the codomain of the last specified deformation field.'
}';
comp.values  = {sn2def dartel def id inv comp1 };
comp.num     = [0 Inf];
% ---------------------------------------------------------------------
% ofname Save as
% ---------------------------------------------------------------------
ofname         = cfg_entry;
ofname.tag     = 'ofname';
ofname.name    = 'Save as';
ofname.val = {};
ofname.help    = {'Save the result as a three-volume image.  "y_" will be prepended to the filename.  The result will be written to the current directory.'};
ofname.strtype = 's';
ofname.num     = [1 Inf];
% ---------------------------------------------------------------------
% fnames Apply to
% ---------------------------------------------------------------------
fnames         = cfg_files;
fnames.tag     = 'fnames';
fnames.name    = 'Apply to';
fnames.val{1} = {''};
fnames.help    = {'Apply the resulting deformation field to some images. The warped images will be written to the current directory, and the filenames prepended by "w".  Note that trilinear interpolation is used to resample the data, so the original values in the images will not be preserved.'};
fnames.filter = 'image';
fnames.ufilter = '.*';
fnames.num     = [0 Inf];
% ---------------------------------------------------------------------
% interp Interpolation
% ---------------------------------------------------------------------
interp         = cfg_menu;
interp.tag     = 'interp';
interp.name    = 'Interpolation';
interp.val{1} = double(1);
interp.help    = {
                  'The method by which the images are sampled when being written in a different space.'
                  '    Nearest Neighbour:     - Fastest, but not normally recommended.'
                  '    Bilinear Interpolation:     - OK for PET, or realigned fMRI.'
                  '    B-spline Interpolation:     - Better quality (but slower) interpolation/* \cite{thevenaz00a}*/, especially       with higher degree splines.  Do not use B-splines when       there is any region of NaN or Inf in the images. '
}';
interp.labels = {
                 'Nearest neighbour'
                 'Trilinear'
                 '2nd Degree B-spline'
                 '3rd Degree B-Spline '
                 '4th Degree B-Spline '
                 '5th Degree B-Spline'
                 '6th Degree B-Spline'
                 '7th Degree B-Spline'
}';
interp.values{1} = double(0);
interp.values{2} = double(1);
interp.values{3} = double(2);
interp.values{4} = double(3);
interp.values{5} = double(4);
interp.values{6} = double(5);
interp.values{7} = double(6);
interp.values{8} = double(7);
% ---------------------------------------------------------------------
% defs Deformations
% ---------------------------------------------------------------------
defs         = cfg_exbranch;
defs.tag     = 'defs';
defs.name    = 'Deformations';
defs.val     = {comp ofname fnames interp };
defs.help    = {
                'This is a utility for working with deformation fields. They can be loaded, inverted, combined etc, and the results either saved to disk, or applied to some image.'
                ''
                'Note that ideal deformations can be treated as members of a Lie group. Future versions of SPM may base its warping on such principles.'
}';
defs.prog = @spm_defs;

%=======================================================================
function str = check(job)
str = '';
if isempty(job),
    str = 'Empty Composition';
end;
return
