function params = spm_coregister(PGF, PFF, PGG, PFG, others)
% Between and within mode image coregistration.
%
% FORMAT spm_coregister
%
% OR     spm_coregister(PGF, PFF, PGG, PFG, others)
% 		PGF    - target image
% 		PFF    - object image
% 		PGG    - image to affine normalise target image to.
% 		PFG    - image to affine normalise object image to.
% 		others - other images to apply same transformation to.
%____________________________________________________________________________
%
% Without any arguments, spm_coregister acts as its own user interface.
%
% The program has two modes of operation:
% 1) If the modalities of the target image(s) and the object image(s) are
%    the same, then the program performs within mode coregistration by
%    minimising the sum of squares difference between the pair of images.
% 2) If the modalities differ, the images are partitioned into gray
%    matter, white matter, csf and (possibly) scalp. These partitions are
%    then registered together simultaneously. The partitioning is performed
%    by "spm_segment".
%
% Realignment parameters are stored in the ".mat" files of the "object" and
% the "other" images.

% %W% John Ashburner %E%


global SWD sptl_WhchPtn
if (nargin == 0)
	% Act as user interface if there are no arguments
	%_______________________________________________________________________

	spm_figure('Clear','Interactive');
	set(spm_figure('FindWin','Interactive'),'Name','Coregistration');

	% get number of subjects
	nsubjects = spm_input('number of subjects',1);

	if (sptl_WhchPtn ~= 1)
		p = spm_input('Which option?',2,'m',...
			'Coregister only|Reslice Only|Coregister & Reslice',...
			[1 2 3]);
	else
		p = 3;
	end

	if (p == 1 | p == 3)
		templates = str2mat([SWD '/mni/cbf.img'], [SWD '/mni/sT1_ss.img'], [SWD '/mni/t2.img']);

		% Get modality of target
		%-----------------------------------------------------------------------
		respt = spm_input('Modality of first target image selected?',3,'m',...
			'target - PET|target - T1 MRI|target - T2 MRI',...
			[1 2 3]);
		PGG = deblank(templates(respt,:));

		% Get modality of object
		%-----------------------------------------------------------------------
		respo = spm_input('Modality of first object image selected?',4,'m',...
			'object - PET|object - T1 MRI|object - T2 MRI',...
			[1 2 3]);
		PFG = deblank(templates(respo,:));

		if (respt == respo)
		n_images = 1;
		else
			n_images = Inf;
		end

		for i = 1:nsubjects
			% select target(s)
			PGF = [];
			while size(PGF,1)<1
				PGF = spm_get(n_images,'.img',...
					['select target image for subject ' num2str(i)]);
			end
			eval(['PGF' num2str(i) ' = PGF;']);

			% select object(s)
			PFF = [];
				while size(PFF,1)<1
				PFF = spm_get(n_images,'.img',...
					['select object image for subject ' num2str(i)]);
			end
			eval(['PFF' num2str(i) ' = PFF;']);

			% select others
			others = spm_get(Inf,'.img',...
				['select other images for subject ' num2str(i)]);
			eval(['others' num2str(i) ' = others;']);
		end
	end

	if (p==2)
		for i = 1:nsubjects
			% select target space
			PGF = spm_get(1,'.img',...
					['select image defining space for subject ' num2str(i)]);
			eval(['PGF' num2str(i) ' = PGF;']);

			% select images to reslice
			PFF = [];
			PFF = spm_get(Inf,'.img',...
				['select images to reslice ' num2str(i)]);
			eval(['PFF' num2str(i) ' = PFF;']);
		end
	end


	% For each subject, recursively call the program to perform the
	% registration.
	%-----------------------------------------------------------------------
	for i=1:nsubjects
		set(spm_figure('FindWin','Interactive'),...
			'Name',['Coregistering subject ' num2str(i)],'Pointer','Watch');
		drawnow;
		eval(['PGF    =    PGF' num2str(i) ';']);
		eval(['PFF    =    PFF' num2str(i) ';']);
		eval(['others = others' num2str(i) ';']);
		if (p == 1 | p == 3)
			params = spm_coregister(PGF, PFF, PGG, PFG, others);
		end
		if (p == 2 | p == 3)
			% Write the coregistered images
			%-----------------------------------------------------------------------
			P = str2mat(PGF(1,:),PFF(1,:));
			if prod(size(others))>1
				P = str2mat(P,others);
			end
			spm_realign(P,'rn');
		end
		spm_figure('Clear','Interactive'); drawnow;
	end
	return;
end


% Do the work
%_______________________________________________________________________

% Get the space of the images
%-----------------------------------------------------------------------
MG = spm_get_space(deblank(PGF(1,:)));
MF = spm_get_space(deblank(PFF(1,:)));

if strcmp(PGG,PFG) 	% Same modality

	% Extra code has been written here to provide future versions of the
	% program to handle the matching together of multiple images. This
	% has however been disabled in order to keep things simple.

	inameG = [];
	inameF = [];
	VG = [];
	VF = [];

	% Smooth the images, and map the smoothed images
	%-----------------------------------------------------------------------
	disp('Smoothing:')
	disp(PGF);
	disp(PFF);
	for i=1:size(PFF,1)
		inameG = str2mat(inameG, [spm_str_manip(PGF(i,:),'rd') '_tmpG']);
		spm_smooth(deblank(PGF(i,:)),[deblank(inameG(i+1,:)) '.img'],8);
		VG = [VG spm_map([deblank(inameG(i+1,:)) '.img'])];

		inameF = str2mat(inameF, [spm_str_manip(PFF(i,:),'rd') '_tmpF']);
		spm_smooth(deblank(PFF(i,:)),[deblank(inameF(i+1,:)) '.img'],8);
		VF = [VF spm_map([deblank(inameF(i+1,:)) '.img'])];
	end
	inameG = inameG(2:(size(PFF,1)+1),:);
	inameF = inameF(2:(size(PFF,1)+1),:);

	% Coregister the images together.
	% If there is more than one pair of images to coregister, then a crude
	% (equally weighted) mean of the coregistration parameters is computed.
	%-----------------------------------------------------------------------
	disp('Coregistering:')
	params = kron([0 0 0 0 0 0 1 1 1 0 0 0]', ones(1,size(PFF,1)));
	samp   = [8   8   8   6  4];
	tol    = [1.0 0.5 0.5 0.1 0.1];
	free   = [1 1 1 1 1 1 0 0 0 0 0 0];
	for j=1:4
		for i=1:size(PGG,1)
			params(:,i) = spm_affine(VG, VF, MG, MF, params(:,i), free, 1, tol(j), samp(j));
		end
		if (size(params,2)>1)
			params = kron(mean(params')', ones(1,size(PGG,1)));
		end
	end

	% Unmap, and delete temporary files
	%-----------------------------------------------------------------------
	for i=1:size(PFF,1)
		spm_unmap(VG(:,i));
		iname  = deblank(inameG(i,:));
		spm_unlink([iname '.img'], [iname '.hdr'], [iname '.mat']);

		spm_unmap(VF(:,i));
		iname  = deblank(inameF(i,:));
		spm_unlink([iname '.img'], [iname '.hdr'], [iname '.mat']);
	end




else 	% Different modalities

	% Partition the target image(s) into smoothed segments
	%-----------------------------------------------------------------------
	disp('Segmenting and smoothing:')
	disp(PGF);
	spm_segment(PGF,PGG);
	VG = [];
	for i=1:4
		iname1 = [spm_str_manip(PGF(1,:),'rd') '_seg'  num2str(i)];
		iname2 = [spm_str_manip(PGF(1,:),'rd') '_sseg' num2str(i)];
		spm_smooth([iname1 '.img'],[iname2 '.img'],8);
		spm_unlink([iname1 '.img'], [iname1 '.hdr'], [iname1 '.mat']);
		VG = [VG spm_map([iname2 '.img'])];
	end

	% Partition the object image(s) into smoothed segments
	%-----------------------------------------------------------------------
	disp('Segmenting and smoothing:')
	disp(PFF);
	spm_segment(PFF,PFG);
	VF = [];
	for i=1:4
		iname1 = [spm_str_manip(PFF(1,:),'rd') '_seg'  num2str(i)];
		iname2 = [spm_str_manip(PFF(1,:),'rd') '_sseg' num2str(i)];
		spm_smooth([iname1 '.img'],[iname2 '.img'],8);
		spm_unlink([iname1 '.img'], [iname1 '.hdr'], [iname1 '.mat']);
		VF = [VF spm_map([iname2 '.img'])];
	end

	% Coregister the segments together
	%-----------------------------------------------------------------------
	disp('Coregistering:')
	params = [0 0 0 0 0 0 1 1 1 0 0 0];
	free   = [1 1 1 0 0 0 0 0 0 0 0 0]; % translations only
	params = spm_affine2(VG,        VF,        MG, MF, params, free, 1, 1.0, 12); % all segments
	free   = [1 1 1 1 1 1 0 0 0 0 0 0]; % rigid body only
	params = spm_affine2(VG,        VF,        MG, MF, params, free, 1, 1.0, 12); % all segments
	params = spm_affine2(VG(:,1:1), VF(:,1:1), MG, MF, params, free, 1, 0.5,  8); % GM
	params = spm_affine2(VG(:,1:2), VF(:,1:2), MG, MF, params, free, 1, 0.5,  8); % GM & WM
	params = spm_affine2(VG(:,1:3), VF(:,1:3), MG, MF, params, free, 1, 0.2,  8); % GM, WM & CSF
	params = spm_affine2(VG(:,1:3), VF(:,1:3), MG, MF, params, free, 1, 0.1,  4); % GM, WM & CSF

	% Unmap, and delete temporary files
	%-----------------------------------------------------------------------
	for i=1:4
		spm_unmap(VG(:,i));
		iname2 = [spm_str_manip(PGF(1,:),'rd') '_sseg' num2str(i)];
		spm_unlink([iname2 '.img'], [iname2 '.hdr'], [iname2 '.mat']);

		spm_unmap(VF(:,i));
		iname2 = [spm_str_manip(PFF(1,:),'rd') '_sseg' num2str(i)];
		spm_unlink([iname2 '.img'], [iname2 '.hdr'], [iname2 '.mat']);
	end
end

% Save parameters
%-----------------------------------------------------------------------
for imge = PFF'
	M = spm_get_space(deblank(imge'));
	spm_get_space(deblank(imge'), spm_matrix(params)*M);
end
for imge = others'
	M = spm_get_space(deblank(imge'));
	spm_get_space(deblank(imge'), spm_matrix(params)*M);
end

spm_figure('Clear','Interactive');

