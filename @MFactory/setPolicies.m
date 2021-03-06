function res = setPolicies(m1,type)
all = '*';
switch type
   case 'h2fits'
      m1.addPolicy('o',all,       'i',1, ...
         'f','scale',  'sp','separate',    'c','r q bo');
      m1.addPolicy('o',all,       'i',1, 'j',1, ...
         'f','scale',  'sp','hybrid',      'c','r bo q');
      res = m1.policy;
   case 'hybridslater1'
      % Diag core on C only
      m1.addPolicy('o',all,        'i',6, ...
         'f','scale',  'sp','core');
      % Diag terms
      m1.addPolicy('o','KE',       'i',all, ...
         'f','scale',  'sp','separate',     'c','r q bo');
      m1.addPolicy('o','EN',       'i',all, ...
         'f','scale',  'sp','separate',     'c','r q bo');
      m1.addPolicy('o','E2',       'i',all, ...
         'f','scale',  'sp','slater',       'c','r q bo');     
      % Bonding terms
      m1.addPolicy('o',all,        'i',all, 'j',all, ...
         'f','scale',  'sp','hybrid',       'c','r bo q');
      % nonbond between hydrogen only
      m1.addPolicy('o','E2',       'i',1,   'j',1,  ...
         'f','scale',  'sp','sonly',        'c','bo',       'nb',1);
      res = m1.policy;
   otherwise
      error(['MFactory.getPolicies unrecognized policy',type]);
end