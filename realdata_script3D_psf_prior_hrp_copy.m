%clear all
close all

% pathName = 'G:\Hu\Documents\Research\Hippocampal Network\Partial Volume Correction\ForChenhui_3D';
% cd(pathName);
% addpath(genpath(pwd));

load blurinterp;
%load PETMRHoffman;
%J = double(J); 
load('FDGsample.mat');
load('MRIsample.mat');

% nii = load_nii('mri_test_mask_volume.nii');
% mask = double(nii.img~=0);
load('mask.mat');

I=double(fdg).*mask*1e6;
J=double(mri_mapped).*mask;

%resize_images;
% I = double(pet)*1e3;
% J = double(my_image_registration(mri,pet));
%% Mask
%close all
params.mask=zeros(size(I));
params.mask(I>=1e-4)=1;
islice=40;
myfigure; myimagesc(params.mask(:,:,islice))
myfigure; myimagesc(I(:,:,islice).*params.mask(:,:,islice))
myfigure; myimagesc(J(:,:,islice).*params.mask(:,:,islice))


%% Prepare MR stuff
%close all

sigscale= 32; %32; %8; % USED 50 with 25 iterations
EPS = 1e-8; %1e-8;
params.EPS=EPS;
sig_y=max(I(:))/sigscale;
params.sig_x=max(I(:))/sigscale;
M = max(size(I))*3+1;%pdf sample number
params.M=M;
params.imy = initanat(J*max(I(:))/max(J(:)),M,sig_y,EPS,params.mask);
myfigure; plot(params.imy.pv);
params.imx = initanat(I,M,params.sig_x,EPS,params.mask);
myfigure; plot(params.imx.pv);
[puv0, U0, V0, ~, U, V]=computePxy(I(:),params);
myfigure;  myimagesc(puv0);


%% Parameters
params.sizex=size(I);
params.H=H;
params.D=D;


%% GP with prior **** USE!!

%close all
xinit=I;
step_size=1e-4; %1 and 2
%reg_par=4e8;
reg_par=4e10;
num_iter=5;
tic
[xsa fsa] = gp_gen_nq(xinit,I,params,reg_par,num_iter, @fwdprojH, @bckprojH, 'no', @gradanat, @farmijoH, 'con', 'on',1,step_size); % xsa is the corrected PET image
toc
Iana=xsa(:,:,:,end);
myfigure;
plot(fsa,'ro-','linewidth',4,'markerfacecolor','r')

%%
%close all
islice=40;
myfigure;
myimagesc(xsa(:,:,islice,1)), colorbar
myfigure;
myimagesc(xsa(:,:,islice,end)), colorbar
myfigure;
myimagesc(J(:,:,islice)), colormap gray, colorbar



