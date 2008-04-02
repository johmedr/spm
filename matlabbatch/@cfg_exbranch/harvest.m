function [tag, val, typ, dep, chk, cj] = harvest(item, cj, dflag, rflag)

% function [tag, val, typ, dep, chk, cj] = harvest(item, cj, dflag, rflag)
% harvest function for cfg_exbranch
% item  - cfg_exbranch to harvest
% dflag - part of tree to harvest (false for filled cfg_item(s), true for
%         default values
% cj    - job tree
% 0) harvest this branch
% if something has changed
% 1) remove target references from source dependencies
% 2) add target references to new source dependencies 
% 3) if all_leafs, offer new possible source references. Note: all_leafs will
% return true regardless of any contents of leaf items. Thus, @vout must
% not rely on any contents of the job tree. This behaviour is intended to
% provide virtual outputs even in the case that the input structure of a
% job is defined, but not its contents.
% if something has changed wrt outputs
% 4) invalidate targets of source references (recursively)
% cj should be modified in an exbranch only, it is passed as an argument
% for consistency of harvest() calls only. 
% Currently, it is the obligation of a management utility outside the
% configuration tree to set and maintain the .id fields of cfg_exbranch
% items.
% Input arguments:
% item  - item to be harvested
% cj    - configuration tree (passed unmodified)
% dflag - if true, harvest defaults tree, otherwise filled tree
% rflag - if true, resolve dependencies in leaf nodes
% Output arguments:
% tag - tag of harvested item
% val - harvested value
% typ - class of harvested item (currently unused)
% dep - list of unresolved dependencies
% chk - meaningful if ~dflag and all dependencies are resolved. Then it
%       returns success status of this items .check function and its
%       childrens check functions. A job is ready to run if all
%       dependencies are resolved and chk status is true.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: harvest.m 1293 2008-04-02 14:20:43Z volkmar $

rev = '$Rev: 1293 $';

[tag val typ tdeps chk cj] = harvest(item.cfg_branch, cj, dflag, rflag);
if dflag
    dep = [];
else
    if ~isempty(tdeps)
        [tdeps.tgt_exbranch] = deal(item.cfg_branch.id);
    end;
    if ~isequal(tdeps, item.tdeps)
        if ~isempty(item.tdeps)
            cj = del_in_source(item.tdeps, cj);
        end;
        if ~isempty(tdeps)
            cj = add_to_source(tdeps, cj);
        end;
        item.tdeps = tdeps;
    end;
    if all_leafs(item)
        osout = item.sout;
        if ~isempty(item.vout)
            item.sout = feval(item.vout, val);
            [item.sout.src_exbranch] = deal(item.cfg_branch.id);
        elseif ~isempty(item.vfiles)
            warning('matlabbatch:harvest:vfiles', 'Using deprecated ''vfiles'' output from node ''%s''.', tag);
            item.sout = cfg_dep;
            item.sout.sname = sprintf('Output from ''%s''', subsref(item, substruct('.','name')));
            item.sout.src_exbranch = item.cfg_branch.id;
            item.sout.src_output = substruct('.','vfiles');
        end;
        if ~isempty(osout) && ~isempty(item.sout)
            % isequalsource is only defined on cfg_dep objects
            ochange = ~isequalsource(osout, item.sout);
        else
            ochange = numel(osout) ~= numel(item.sout);
        end;
    else
        ochange = true; % no outputs specified (may be they were before)
    end;

    if ochange && ~isempty(item.sdeps)
        % delete changed outputs from dependent modules
        sdeps = item.sdeps;
        item.sdeps = [];
        cj = del_in_target(sdeps, cj);
        % invalidate already computed outputs
        item.jout = cfg_inv_out;
    end;

    % even if no sources changed, source names may have changed
    for k = 1:numel(item.sdeps)
        for l = 1:numel(item.sout)
            if isequalsource(item.sdeps(k), item.sout(l))
                item.sdeps(k).sname = item.sout(l).sname;
                cdeps = subsref(cj, [item.sdeps(k).tgt_exbranch ...
                                    item.sdeps(k).tgt_input ...
                                    substruct('.','val','{}',{1})]);
                for m = 1:numel(cdeps)
                    if isequalsource(item.sdeps(k), cdeps(m))
                        cdeps(m).sname = item.sdeps(k).sname;
                    end;
                end;
                cj = subsasgn(cj, [item.sdeps(k).tgt_exbranch ...
                                   item.sdeps(k).tgt_input ...
                                   substruct('.','val','{}',{1})], cdeps);
            end;
        end;
    end;
    
    dep = tdeps;
    % save chk status
    item.chk = chk;
    cj = subsasgn(cj, item.cfg_branch.id, item);
end;