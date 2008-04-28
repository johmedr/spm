function spm_eeg_inv_group(S);
% Source reconstruction for a group ERP or ERF study
% FORMAT spm_eeg_inv_group
%
% S  - matrix of names of EEG/MEG mat files for inversion
%__________________________________________________________________________
%
% spm_eeg_inv_group inverts forward models for a group of subjects or ERPs
% under the simple assumption that the [empirical prior] variance on each
% source can be factorised into source-specific and subject-specific terms.
% These covariance components are estimated using ReML (a form of Gaussian
% process modelling) to give empirical priors on sources.  Source-specific
% covariance parameters are estimated first using the sample covariance
% matrix in sensor space over subjects and trials using multiple sparse
% priors (and,  by default, a greedy search).  The subject-specific terms
% are then estimated by pooling over trials for each subject separately.
% All trials in D.events.types will be inverted in the order specified.
% The result is a contrast (saved in D.mat) and a 3-D volume of MAP or
% conditional estimates of source activity that are constrained to the
% same subset of voxels.  These would normally be passed to a second-level
% SPM for classical inference about between-trial effects, over subjects.
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Karl Friston
% $Id: spm_eeg_inv_group.m 1490 2008-04-28 11:16:29Z vladimir $


% check if to proceed
%--------------------------------------------------------------------------
str = questdlg('this will overwrite previous source reconstructions OK?');
if ~strcmp(str,'Yes'), return, end

% Load data
%==========================================================================

% Gile file names
%--------------------------------------------------------------------------
if ~nargin
    S = spm_select(Inf, '.mat','Select EEG/MEG mat files');
end
Ns    = size(S,1);
PWD   = pwd;
val   = 1;

% Load data and set method
%==========================================================================
for i = 1:Ns
    D{i}                 = spm_eeg_load(deblank(S(i,:)));
    D{i}.val             = 1;
    D{i}.inv{1}.method = 'Imaging';
    
    % clear redundant models
    %----------------------------------------------------------------------
    D{i}.inv = D{i}.inv(1);
    
    
    % clear previous inversions
    %----------------------------------------------------------------------
    try, D{i}.inv{1} = rmfield(D{i}.inv{1},'inverse' ); end
    try, D{i}.inv{1} = rmfield(D{i}.inv{1},'contrast'); end
    
    % save forward model parameters
    %----------------------------------------------------------------------
    spm_eeg_inv_save(D{i})
    
end

% Check for existing forward models and consistent Gain matrices
%--------------------------------------------------------------------------
for i = 1:Ns
    try
        L     = spm_eeg_lgainmat(D{i});
        Nd(i) = size(L,2);                             % number of dipoles
    catch
        Nd(i) = 0;
    end
end


% use template head model where necessary
%==========================================================================
NS    = find(Nd ~= 7204);               % subjects to compute forward model
for i = NS

    cd(D{i}.path)

    % specify cortical mesh size (1 tp 4; 1 = 3004, 4 = 7204 dipoles)
    %----------------------------------------------------------------------
    D{i}.inv{val}.mesh.Msize  = 4;

    % use a template head model and associated meshes
    %======================================================================
    D{i} = spm_eeg_inv_template(D{i});

%     % specify forward model
%     %----------------------------------------------------------------------
%     if strcmp(D{i}.modality,'EEG')
%         D{i}.inv{val}.forward.method = 'eeg_3sphereBerg';
%     else
%         D{i}.inv{val}.forward.method = 'meg_sphere';
%     end
    
    % save forward model parameters
    %----------------------------------------------------------------------
    spm_eeg_inv_save(D{i})

end

% Get inversion parameters
%==========================================================================
inverse = spm_eeg_inv_custom_ui(D{1});

% and save them (assume trials = types)
%--------------------------------------------------------------------------
for i = 1:Ns
    D{i}.inv{val}.inverse = inverse;
end

% specify time-frequency window contrast
%==========================================================================
str = questdlg('Would you like to specify a time-frequency contrast?');
if strcmp(str,'Yes')

    % get time window
    %----------------------------------------------------------------------
    woi              = spm_input('Time window (ms)','+1','r',[100 200]);
    woi              = sort(woi);
    contrast.woi     = round([woi(1) woi(end)]);

    % get frequency window
    %----------------------------------------------------------------------
    fboi             = spm_input('Frequency [band] of interest (Hz)','+1','r',0);
    fboi             = sort(fboi);
    contrast.fboi    = round([fboi(1) fboi(end)]);
    contrast.display = 0;
    contrast.smooth  = 4;
    
else
    contrast = [];
end

% Register and compute a forward model
%==========================================================================
for i = NS

    fprintf('Registering and computing forward model (subject: %i)\n',i)

    % Forward model
    %----------------------------------------------------------------------
    iseeg = ~isempty(strmatch('EEG', D{1}.chantype));
    ismeg = ~isempty(strmatch('MEG', D{1}.chantype));

    if iseeg && ismeg
        modality = spm_input('Which modality?','+1','EEG|MEG');
    elseif iseeg
        modality = 'EEG';
    elseif ismeg
        modality = 'MEG';
    else
        error('No MEEG channels in the data');
    end
    
    D{i} = spm_eeg_inv_datareg_ui(D{i}, 1, modality);
    
    D{i} = spm_eeg_inv_forward_ui(D{i});
    
    % save forward model
    %----------------------------------------------------------------------
    spm_eeg_inv_save(D{i})

end

% Invert the forward model
%==========================================================================
D     = spm_eeg_invert(D);
if ~iscell(D), D = {D}; end

% Save
%==========================================================================
for i = 1:Ns
    spm_eeg_inv_save(D{i})
end
clear D


% Compute conditional expectation of contrast and produce image
%==========================================================================
if length(contrast)

    % evaluate contrast and write image
    %----------------------------------------------------------------------
    for i = 1:Ns
        [p f] = fileparts(deblank(S(i,:)));
        D     = spm_eeg_load(fullfile(p,f));
        D.inv{val}.contrast = contrast;
        D     = spm_eeg_inv_results(D);
        D     = spm_eeg_inv_Mesh2Voxels(D);
    end
end

