# Statistical Parametric Mapping

[![SPM: website](https://img.shields.io/badge/SPM-website-plum.svg)](https://www.fil.ion.ucl.ac.uk/spm/)
[![SPM: documentation](https://img.shields.io/badge/SPM-documentation-plum.svg)](https://www.fil.ion.ucl.ac.uk/spm/docs/)
[![SPM: help](https://img.shields.io/badge/SPM-help-plum.svg)](https://www.jiscmail.ac.uk/cgi-bin/webadmin?A0=SPM)
[![SPM: YouTube](https://img.shields.io/badge/SPM-YouTube-plum.svg)](https://www.youtube.com/@StatisticalParametricMapping)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)
[![Platform: MATLAB](https://img.shields.io/badge/MATLAB-orange.svg?style=plastic)](https://www.mathworks.com)
[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=spm/spm)
[![Tests](https://github.com/spm/spm/actions/workflows/matlab.yml/badge.svg)](https://github.com/spm/spm/actions/workflows/matlab.yml)
 
Statistical Parametric Mapping refers to the construction and assessment
of spatially extended statistical process used to test hypotheses about
functional imaging data. These ideas have been instantiated in software
that is called SPM.  The SPM software package has been designed for the
analysis of brain imaging data sequences.  The sequences can be a series
of images from different cohorts, or time-series from the same subject.
The current release is designed for the analysis of fMRI, PET, SPECT, EEG
and MEG.

## Software

The SPM software is a suite of MATLAB functions, scripts and data files,
with some externally compiled C routines, implementing Statistical
Parametric Mapping.  [MATLAB](https://www.mathworks.com/products/matlab.html)
is required to use SPM.  SPM requires only core MATLAB to run (no special
toolboxes are required).

Although SPM will read image files from previous versions of SPM, there
are differences in the algorithms, templates and models used.  Therefore,
we recommend you use a single SPM version for any given project.

## File formats

SPM uses the [NIFTI-1](https://nifti.nimh.nih.gov/) and
[GIFTI](https://www.nitrc.org/projects/gifti/) data formats as standard.

A number of DICOM flavours can also be converted to NIFTI-1 using tools
in SPM.

## Resources

* Website: https://www.fil.ion.ucl.ac.uk/spm/
* Documentation: https://www.fil.ion.ucl.ac.uk/spm/docs/
* YouTube: https://www.youtube.com/@StatisticalParametricMapping
* Courses: https://www.fil.ion.ucl.ac.uk/spm/course/
* Mailing list: https://www.fil.ion.ucl.ac.uk/spm/support/
* GitHub organisation: https://github.com/spm/
* Toolboxes and Extensions: https://www.fil.ion.ucl.ac.uk/spm/ext/

## Authors

SPM is developed under the auspices of Functional Imaging Laboratory
(FIL), The Wellcome Centre for Human NeuroImaging, in the Queen Square
Institute of Neurology at University College London (UCL), UK.

SPM94 was written primarily by Karl Friston in the first half of 1994,
with assistance from John Ashburner (MRC-CU), Jon Heather (WDoIN), and
Andrew Holmes (Department of Statistics, University of Glasgow).
Subsequent development, under the direction of Prof. Karl Friston at the
Wellcome Department of Imaging Neuroscience, has benefited from
substantial input (technical and theoretical) from: John Ashburner
(WDoIN), Andrew Holmes (WDoIN & Robertson Centre for Biostatistics,
University of Glasgow, Scotland), Jean-Baptiste Poline (WDoIN &
CEA/DRM/SHFJ, Orsay, France), Christian Buechel (WDoIN), Matthew Brett
(MRC-CBU, Cambridge, England), Chloe Hutton (WDoIN) and Keith Worsley
(Department of Statistics, McGill University, Montreal Canada).

See [`AUTHORS.txt`](AUTHORS.txt) for a complete list of SPM co-authors.

## Licensing

SPM is made freely available to the [neuro]imaging community, to promote
collaboration and a common analysis scheme across laboratories.

SPM is licensed under the terms of the MIT license. To view a copy of
this license, see [`LICENSE`](LICENSE) or visit
https://opensource.org/license/mit/.

Copyright (C) 1991,1994-2023 Wellcome Centre for Human Neuroimaging
