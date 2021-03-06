clear classes;
close all;
topDir = 'C:/matdl/yaron/11-19-12/contextPCA-nohybrid/';
fitmeParallel = 1;
fitmeEtotOnly = 1;
psc = 0; % does not use optimization toolbox
includeMethane = 1;
includeEthane = 0;
includeCF4 = 0;
includeAdhoc = 1;
separateSP = 0;
include1s = 0;
hybrid = 1;
extType = {'','-diponly','-1c','-linrho'};
for imols = 1
   switch imols
      case 1
         includeMethane = 1; includeEthane = 0;
         types = 1:4;
      case 2
         includeMethane = 0; includeEthane = 1;
         types = 1;
      case 3
         includeMethane = 1; includeEthane = 1;
         types = 1;
      case 4
         includeMethane = 0; includeEthane = 0; includeCF4 = 1;
         types = 1;
   end
for itype = types
datasetExt = extType{itype}; %''; %  '-orig'   :   8 charges, 
                 %  ''        :   rand charge + dipoles,
                 %  '-linrho' :   1 linear charge + dipoles,
                 %  '-diponly' :   only dipoles



mtrain = cell(0,0);
HLtrain = cell(0,0);
envsTrain = cell(0,0);
mtest = cell(0,0);
HLtest = cell(0,0);
envsTest = cell(0,0);
files = cell(0,0);
fileprefix = '';

if (includeMethane)
   files{end+1} = ['datasets\ch4rDat',datasetExt,'.mat'];
   fileprefix = [fileprefix 'ch4rDat',datasetExt];
end
if (includeCF4)
   files{end+1} = ['datasets\cf4r',datasetExt,'.mat'];
   fileprefix = [fileprefix 'cf4r',datasetExt];
end
if (includeEthane)
   files{end+1} = 'datasets\ethanerDat.mat';
   fileprefix = [fileprefix 'ethanerDat'];
end
for i1 = 1:length(files)
   load(files{i1});
   train = 1:10;
   test = 11:20;
   envs1 = [6     7     8    13    16    24];
   envs2 = [5    10    14    17    20    25];
   envs1 = 1:2:20;
   envs2 = 2:2:20;
   %envs1 = 1:6;
   %envs2 = 7:12;
   for i = train
      mtrain{end+1} = Model3(LL{i,1},LL{i,1},LL{i,1});
      mtrain{end}.solveHF;
      HLtrain{end+1} = HL{i,1};
      envsTrain{1,end+1} = envs1;
   end
   for i = test
      mtest{end+1} = Model3(LL{i,1},LL{i,1},LL{i,2});
      mtest{end}.solveHF;
      HLtest{end+1} = HL{i,1};
      envsTest{end+1} = envs2;
   end
end
filePre=fileprefix;
dataDir = [topDir,filePre];
if (exist(dataDir,'dir') ~= 7)
   status = mkdir(dataDir);
end
summaryName = [topDir,filePre,'/summary.txt'];
% if (exist(summaryName,'file'))
%    delete(summaryName);
% end
summaryFile = fopen(summaryName,'a');
diaryName = [topDir,filePre,'/cfit.diary'];
% if (exist(diaryName,'file'))
%    delete(diaryName);
% end
diary(diaryName);
diary on;

% Create fitme object
[f1 ftest] = Context.makeFitme(mtrain,envsTrain,HLtrain, ...
   mtest,envsTest,HLtest,includeAdhoc,separateSP,include1s,hybrid);
%
f1.silent = 0;
ftest.silent = 0;
f1.parallel = fitmeParallel;
ftest.parallel = fitmeParallel;


if(fitmeEtotOnly)
   f1.includeKE = 1;
   f1.includeEN = ones(1,20);
   f1.includeE2 = 1;
   f1.includeEtot = 1;
   ftest.includeEtot = 1;
end
input('junk');

fprintf(summaryFile,'train and test starting error \n');
f1.printEDetails(summaryFile);
ftest.printEDetails(summaryFile);

%
startName = [topDir,filePre,'/start.mat'];
toSave = {'f1','ftest','currentTrainErr','currentPar','currentErr'};
if (exist(startName,'file'))
   fprintf(1,'LOADING START \n');
   fprintf(summaryFile,'LOADING START \n');
   load(startName,toSave{:});
else
   [currentTrainErr,currentPar,currentErr] = contextFit2(f1,ftest,0,0,0,500,psc);
   save(startName);
end

str1 = 'initial error %12.5f test %12.5f \n';
fprintf(1,str1,currentTrainErr,currentErr);
fprintf(summaryFile,str1,currentTrainErr,currentErr);
f1.printEDetails(summaryFile);
ftest.printEDetails(summaryFile);

ticID = tic;
for iter = 1:3
   allName = [topDir,filePre,'/all-',num2str(iter),'.mat'];
   if (exist(allName,'file'))
      fprintf(1,'LOADING ITERATION %i \n',iter);
      fprintf(summaryFile,'LOADING ITERATION %i \n',iter);
      load(allName,toSave{:});
   else
      fprintf(1,'STARTING ITERATION %i \n',iter);
      fprintf(summaryFile,'STARTING ITERATION %i \n',iter);
      % unfix 1 level of context
      for imix = 1:length(f1.mixers)
         mix = f1.mixers{imix};
         for ipar = 1:length(mix.fixed)
            if (mix.fixed(ipar) == 1)
               mix.fixed(ipar) = 0;
               break;
            end
         end
      end
      % if ((iter == 3) || (iter == 12))
      [currentTrainErr,currentPar,currentErr] = contextFit2(f1,ftest,0,0,0,500,psc);
      save(allName);
      %end
   end
   str2 = 'context error %12.5f test %12.5f \n';
   fprintf(1,str2,currentTrainErr,currentErr);
   fprintf(summaryFile,str2,currentTrainErr,currentErr);
   f1.printEDetails(summaryFile);
   ftest.printEDetails(summaryFile);

end

runTime = toc(ticID)
diary off;
fclose(summaryFile);
%    %%
%    for i=1:length(errors)
%       mix = f1.mixers{mixes{i}.imix};
%       ipar = mixes{i}.ipar;
%       etemp = errors(i);
%       disp([mix.desc,' context ',num2str(ipar),' err ', ...
%          num2str(etemp)]);
%       disp(['pars ',num2str(pars{i})]);
%    end
end
end