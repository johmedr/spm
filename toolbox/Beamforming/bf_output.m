function out = bf_output
% Outputs the results of beamforming analysis
% Copyright (C) 2012 Wellcome Trust Centre for Neuroimaging

% Vladimir Litvak
% $Id: bf_output.m 4847 2012-08-16 17:29:23Z vladimir $

% dir Directory
% ---------------------------------------------------------------------
BF = cfg_files;
BF.tag = 'BF';
BF.name = 'BF.mat file';
BF.filter = '^BF.mat$';
BF.num = [1 1];
BF.help = {'Select BF.mat file.'};

%--------------------------------------------------------------------------
% method
%--------------------------------------------------------------------------
plugin      = cfg_choice;
plugin.tag  = 'plugin';
plugin.name = 'Output method';

output_funs = spm_select('List', fullfile(spm('dir'), 'toolbox', 'Beamforming'), '^bf_output_.*\.m$');
output_funs = cellstr(output_funs );
for i = 1:numel(output_funs)
    plugin.values{i} = feval(spm_file(output_funs{i},'basename'));
end

out = cfg_exbranch;
out.tag = 'bf_output';
out.name = 'Output';
out.val = {BF, plugin};
out.help = {'Generate output'};
out.prog = @bf_output_run;
out.vout = @bf_output_vout;
out.modality = {'EEG'};
end

function  out = bf_output_run(job)

outdir = spm_file(job.BF{1}, 'fpath');

cd(outdir);

BF = bf_load('BF.mat', {'data', 'sources', 'postprocessing'});

plugin_name   = cell2mat(fieldnames(job.plugin));

outfield_name =  strtok('plugin_name', '_');

BF.output.(outfield_name) = feval(['bf_output_' plugin_name], BF, job.plugin.(plugin_name));

bf_save(BF);

out.BF{1} = fullfile(outdir, 'BF.mat');
end

function dep = bf_output_vout(job)
% Output is always in field "D", no matter how job is structured
dep = cfg_dep;
dep.sname = 'BF.mat file';
% reference field "B" from output
dep.src_output = substruct('.','BF');
% this can be entered into any evaluated input
dep.tgt_spec   = cfg_findspec({{'filter','mat'}});
end
