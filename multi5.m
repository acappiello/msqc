%% Fitting multiple molecules, using makeFitme
clear classes;
topDir = 'cdebug/';
% if (Aprocess == 1)
%    ics = [1 4 7];
% elseif (Aprocess == 2)
%    ics = [2 5];
% else
%    ics = [3 6];
% end
ftypeDiag = 3;
ftypeBond = 2;
%trainC{1}  = {'h2',2:7,'envs',1:10};
%testC{1} = {'h2',2:7,'envs',20:30};
trainC{1}  = {'h2',[],'ch4',1:3,'envs',1:10};
testC{1} = {'h2',[],'ch4',1:3,'envs',20:30};
filePrefix{1} = 'ch4';

trainC{2}  = {'h2',[],'ethane',1:7,'envs',1:10};
testC{2} = {'h2',[],'ethane',1:7,'envs',20:30};
filePrefix{2} = 'c2h6';

trainC{3}  = {'h2',[],'ethylene',1:7,'envs',1:10};
testC{3} = {'h2',[],'ethylene',1:7,'envs',20:30};
filePrefix{3} = 'c2h4z2';

trainC{4}  = {'h2',[],'ch4',1:7,'ethane',1:7,'envs',1:10};
testC{4} = {'h2',[],'ch4',1:7,'ethane',1:7,'envs',20:30};
filePrefix{4} = 'ch4-c2h6';

trainC{5}  = {'h2',[],'ch4',1:7,'ethane',1:7,'ethylene',1:7,'envs',1:10};
testC{5} = {'h2',[],'ch4',1:7,'ethane',1:7,'ethylene',1:7,'envs',20:30};
filePrefix{5} = 'ch4-c2h6-c2h4';

trainC{6}  = {'h2',[],'ch4',1:19,'ethane',1:7,'envs',1:10};
testC{6} = {'h2',[],'ch4',1:19,'ethane',1:7,'envs',20:30};
filePrefix{6} = 'ch4f-c2h6';

trainC{7}  = {'h2',[],'ch4',1:19,'ethane',1:7,'ethylene',1:7,'envs',1:10};
testC{7} = {'h2',[],'ch4',1:19,'ethane',1:7,'ethylene',1:7,'envs',20:30};
filePrefix{7} = 'ch4f-c2h6-c2h4';

commonIn = {};

for iC = 1
   trainIn = trainC{iC};
   testIn = testC{iC};
   filePre = filePrefix{iC};
   for iPar = 1:5
      if (iPar == 1)
         if (ftype == 2)
            iP = 1;
         else
            iP = 0;
         end
         ke.H = Mixer(iP,1,'ke.H',ftype);
         ke.Cs = Mixer(iP,1,'ke.C',ftype);
         ke.Cp = ke.Cs;
         ke.HH = Mixer(iP,1,'ke.HH',ftype);
         ke.CsH = Mixer(iP,1,'ke.CH',ftype);
         ke.CpH = ke.CsH;
         ke.CsCs = Mixer(iP,1,'ke.CC',ftype);
         ke.CsCp = ke.CsCs;
         ke.CpCp = ke.CsCs;
         
         en.H = Mixer(iP,1,'en.H',ftype);
         en.Cs = Mixer(iP,1,'en.C',ftype);
         en.Cp = en.Cs;
         en.HH = Mixer(iP,1,'en.HH',ftype);
         en.CsH = Mixer(iP,1,'en.CH',ftype);
         en.CpH = en.CsH;
         en.HCs = en.CsH;
         en.HCp = en.CsH;
         en.CsCs = Mixer(iP,1,'en.CC',ftype);
         en.CsCp = en.CsCs;
         en.CpCp = en.CsCs;
         
         e2.H = Mixer(iP,1,'e2.H',ftype);
         e2.C = Mixer(iP,1,'e2.C',ftype);
         e2.HH = Mixer(iP,1,'e2.HH',ftype);
         e2.CC = Mixer(iP,1,'e2.CC',ftype);
         e2.CH = Mixer(iP,1,'e2.CH',ftype);
         ftest = makeFitme(testIn{:},commonIn{:},'enstruct1',en, ...
            'kestruct',ke,'e2struct',e2,'plot',2);
         f1 = makeFitme(trainIn{:},commonIn{:},'enstruct1',en,'kestruct',ke, ...
            'e2struct',e2,'testFitme',ftest);
      elseif (iPar == 2)
         en.HCs = en.CsH.deepCopy(); en.HCs.desc = 'en.HCs';
         en.HCp = en.HCs;
      elseif (iPar == 3)
         ke.H.mixType = 2;    ke.H.par(2) = 0;    ke.H.fixed(2) = 0;
         ke.Cs.mixType = 2;   ke.Cs.par(2) = 0;   ke.Cs.fixed(2) = 0;
         ke.HH.mixType = 3;   ke.HH.par(2) = 0;   ke.HH.fixed(2) = 0;
         ke.CsH.mixType = 3;  ke.CsH.par(2) = 0;  ke.CsH.fixed(2) = 0;
         ke.CsCs.mixType = 3; ke.CsCs.par(2) = 0; ke.CsCs.fixed(2) = 0;
      elseif (iPar == 4)
         en.H.mixType = 2;    en.H.par(2) = 0;      en.H.fixed(2) = 0;
         en.Cs.mixType = 2;   en.Cs.par(2) = 0;     en.Cs.fixed(2) = 0;
         en.HH.mixType = 3;   en.HH.par(2) = 0;     en.HH.fixed(2) = 0;
         en.CsH.mixType = 3;  en.CsH.par(2) = 0;    en.CsH.fixed(2) = 0;
         en.HCs.mixType = 3;  en.HCs.par(2) = 0;    en.HCs.fixed(2) = 0;
         en.CsCs.mixType = 3; en.CsCs.par(2) = 0;   en.CsCs.fixed(2) = 0;
      elseif (iPar == 5)
         e2.H.mixType = 2;   e2.H.par(2) = 0;   e2.H.fixed(2) = 0;
         e2.C.mixType = 2;   e2.C.par(2) = 0;   e2.C.fixed(2) = 0;
         e2.HH.mixType = 3;  e2.HH.par(2) = 0;  e2.HH.fixed(2) = 0;
         e2.CC.mixType = 3;  e2.CC.par(2) = 0;  e2.CC.fixed(2) = 0;
         e2.CH.mixType = 3;  e2.CH.par(2) = 0;  e2.CH.fixed(2) = 0;
      elseif (iPar == 6)
         ke.Cp = ke.Cs.deepCopy();     ke.Cs.desc ='ke.Cs';     ke.Cp.desc = 'ke.Cp';
         ke.CpH = ke.CsH.deepCopy();   ke.CsH.desc ='ke.CsH';   ke.CpH.desc = 'ke.CpH';
         ke.CsCp = ke.CsCs.deepCopy(); ke.CsCs.desc ='ke.CsCs'; ke.CsCp.desc = 'ke.CsCp';
         ke.CpCp = ke.CsCs.deepCopy();                          ke.CpCp.desc = 'ke.CpCp';
         
         en.Cp = en.Cs.deepCopy();     en.Cs.desc ='en.Cs';     en.Cp.desc = 'en.Cp';
         en.CpH = en.CsH.deepCopy();   en.CsH.desc ='en.CsH';   en.CpH.desc = 'en.CpH';
         en.CpH = en.CsH.deepCopy();   en.CsH.desc ='en.CsH';   en.CpH.desc = 'en.CpH';
         en.CsCp = en.CsCs.deepCopy(); en.CsCs.desc ='en.CsCs'; en.CsCp.desc = 'en.CsCp';
         en.CpCp = en.CsCs.deepCopy();                          en.CpCp.desc = 'en.CpCp';
         
      end
      
      dataDir = [topDir,filePre,'/fit-',num2str(iPar),'/'];
      options = optimset('DiffMinChange',1.0e-5,'TolFun',1.0e-4,'TolX',1.0e-3);
      if (exist(dataDir,'dir') ~= 7)
         status = mkdir(dataDir);
      end
      diary([dataDir,'out.diary']);
      diary on;
      tic
      lowLimits = zeros(f1.npar,1);
      highLimits = lowLimits;
      i1 = 1;
      for imix = 1:length(f1.mixers)
         mix = f1.mixers{imix};
         if ((mix.funcType == 2)||(mix.functype == 3))
            lowLimits(i1) = 0.0;
            highLimits(i1) = 10.0;
            i1 = i1+1;
            for i2 = 2:mix.npar
               lowLimits(i1) = -inf;
               highLimits(i1) = inf;
               i1 = i1+1;
            end
         else
            for i2 = 1:mix.npar
               lowLimits(i1) = -inf;
               highLimits(i1) = inf;
               i1 = i1+1;
            end
         end
      end
      start = f1.getPars;
      [pt,resnorm,residual,exitflag,output,lambda,jacobian] = ...
         lsqnonlin(@f1.err, start,lowLimits,highLimits,options);
      clockTime = toc
      pt
      resnorm
      f1.printMixers;
      save([dataDir,'all.mat']);
      diary off;
      figure(799); saveas(gcf,[dataDir,'error.fig']);
      if (~isempty(find(cellfun(@(x)isequal(lower(x),'ch4'),trainIn)) ))
         figure(801); saveas(gcf,[dataDir,'ch4-train.fig']);
         figure(811); saveas(gcf,[dataDir,'ch4-test.fig']);
      end
      if (~isempty(find(cellfun(@(x)isequal(lower(x),'ethane'),trainIn)) ))
         figure(802); saveas(gcf,[dataDir,'c2h6-train.fig']);
         figure(812); saveas(gcf,[dataDir,'c2h6-test.fig']);
      end
      if (~isempty(find(cellfun(@(x)isequal(lower(x),'ethylene'),trainIn)) ))
         figure(803); saveas(gcf,[dataDir,'c2h4-train.fig']);
         figure(813); saveas(gcf,[dataDir,'c2h4-test.fig']);
      end
   end
end


