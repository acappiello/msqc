function propane-data()

%% Load data
clear classes;
root = 'c:\Users\Alex\Programming\msqc\';
% Generate environments for production runs
if (exist('propane1mp2/env1.mat','file'))
   disp('loading existing environments');
   load('propane1mp2/env1.mat');
else
   mag = 15.0;
   nenv = 100;
   cubSize = [6,6,6];
   cent = [0.77; 0; 0];
   for ienv = 1:nenv
      temp = Environment.newCube(cubSize,mag);
      temp.displace(cent);
      env{ienv} = temp;
   end
   save('propane1mp2/env1.mat','env');
end
nenv = size(env,2);
pars{1} = [1.54 1.08 0];
pars{2} = [1.54 1.08 30];
pars{3} = [1.54 1.08 -30];
pars{4} = [1.38 1.08 0];
pars{5} = [1.70 1.08 0];
pars{6} = [1.54 0.93 0];
pars{7} = [1.54 1.23 0];
npar = size(pars,2);
HLbasis = {'6-31G'};
HL = cell(npar,3);
LL = cell(npar,3);
%%
if (exist('propane1mp2/propaneDat.mat','file'))
   disp('loading existing data');
   load('propane1mp2/propaneDat.mat');
else
   for ipar = 1:size(pars,2)
      par = pars{ipar};
      disp(['rcc ',num2str(par(1)), ...
         ' rch ',num2str(par(2)), ...
         ' angle ',num2str(par(3))]);
      
      config = Fragment.defaultConfig();
      config.method = 'MP2';
      config.par = par;
      
      % HL
      for ihl = 1:size(HLbasis,2)
         config.template = 'propane';
         config.basisSet = HLbasis{ihl};
         disp(['ipar ',num2str(ipar),' loading HL ',num2str(ihl)]);
         frag1 = Fragment([root,'propane1mp2'], config);
         for ienv = 1:nenv
            display(['HL env ',num2str(ienv)]);
            frag1.addEnv(env{ienv});
         end
         HL{ipar,ihl} = frag1;
      end
      % LL 1
      config.basisSet = 'STO-3G';
      frag2 = Fragment([root,'propane1mp2'], config);
      disp(['ipar ',num2str(ipar),' loading LL 1']);
      for ienv = 1:nenv
         display(['LL env ',num2str(ienv)]);
         frag2.addEnv(env{ienv});
      end
      LL{ipar,1} = frag2;
      
      % LL 2
      config.template = 'propane-gen';
      config.basisSet = 'GEN';
      config.par = [par 0.9 0.9 0.9 0.9 0.9];
      frag3 = Fragment([root,'propane1mp2'], config);
      disp(['ipar ',num2str(ipar),' loading LL 2']);
      for ienv = 1:nenv
         display(['LL env ',num2str(ienv)]);
         frag3.addEnv(env{ienv});
      end
      LL{ipar,2} = frag3;
      % LL 3
      config.template = 'propane-gen';
      config.basisSet = 'GEN';
      config.par = [par 1.05 1.05 1.05 1.05 1.05];
      disp(['ipar ',num2str(ipar),' loading LL 3']);
      frag4 = Fragment([root,'propane1mp2'], config);
      for ienv = 1:nenv
         display(['LL env ',num2str(ienv)]);
         frag4.addEnv(env{ienv});
      end
      LL{ipar,3} = frag4;
   end
   
   % since even loading all the files will take time, we'll dave everything
   save('propane1mp2/propaneDat.mat');
end

end