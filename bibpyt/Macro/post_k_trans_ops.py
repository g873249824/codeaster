# coding=utf-8
# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
# THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY  
# IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY  
# THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR     
# (AT YOUR OPTION) ANY LATER VERSION.                                                  
#                                                                       
# THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT   
# WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF            
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU      
# GENERAL PUBLIC LICENSE FOR MORE DETAILS.                              
#                                                                       
# YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE     
# ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,         
#    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.        
# ======================================================================

def post_k_trans_ops(self,RESU_TRANS,K_MODAL,TOUT_ORDRE, NUME_ORDRE,  
                 LIST_ORDRE, INST, LIST_INST,INFO,**args):          
  """
     Ecriture de la macro post_k_trans
  """
  import aster
  import string
  from Accas import _F
  from Utilitai.Utmess     import  UTMESS
  from types import ListType, TupleType
  from Utilitai.Table      import Table, merge
  EnumTypes = (ListType, TupleType)
  
  macro = 'POST_K_TRANS'
  ier=0
#------------------------------------------------------------------
  # On importe les definitions des commandes a utiliser dans la macro
  CALC_G           =self.get_cmd('CALC_G'  )
  IMPR_TABLE       =self.get_cmd('IMPR_TABLE'      )
  CREA_TABLE       =self.get_cmd('CREA_TABLE'      )
  
  # La macro compte pour 1 dans la numerotation des commandes
  self.set_icmd(1)
  
  # Le concept sortant (de type table_sdaster ou dérivé) est tab
  self.DeclareOut('tabout', self.sd)

#------------------------------------------------------------------
  TABK = K_MODAL['TABL_K_MODA']
    
  __kgtheta=TABK
 
  tablin =__kgtheta.EXTR_TABLE()
   
#  sif_arg = args['tablin']
  if 'K3' in tablin.para :
     DIME = 3
  else :
     DIME = 2
   
#-----------------------------------------
#  
# Verification de cohérence sur le nombre de modes
#  
# RESULTAT TRANSITOIRE
  nomresu=RESU_TRANS.nom
  coef=aster.getvectjev(nomresu.ljust(19)+'.DEPL')
  nmodtr=aster.getvectjev(nomresu.ljust(19)+'.DESC')[1]
# BASE MODALE
  if DIME == 2 : 
    n_mode = len((__kgtheta.EXTR_TABLE())['K1'])
    nbno = 1
  else : 
    n_mode = max((__kgtheta.EXTR_TABLE())['NUME_MODE'].values()['NUME_MODE'])
    nbno = max((__kgtheta.EXTR_TABLE())['NUM_PT'].values()['NUM_PT'])
    labsc = (__kgtheta.EXTR_TABLE())['ABSC_CURV'].values()['ABSC_CURV'][0:nbno]
  if nmodtr != n_mode : 
      n_mode = min(nmodtr,n_mode)
      UTMESS('A','RUPTURE0_50',valk=nomresu,vali=n_mode)
 
#  
# Traitement des mots clés ORDRE/INST/LIST_INST et LIST_ORDRE
#  
  l0_inst = aster.getvectjev(nomresu.ljust(19)+'.DISC')
  l0_ord = aster.getvectjev(nomresu.ljust(19)+'.ORDR')
  nbtrans = len(l0_ord)
  li =  [[l0_ord[i],l0_inst[i]] for i in range(nbtrans)]
  ln =  [[l0_ord[i],i] for i in range(nbtrans)]
  lo =  [[l0_inst[i],l0_ord[i]] for i in range(nbtrans)]
  li = [(i[0],i[1:]) for i in li]
  ln = [(i[0],i[1:]) for i in ln]
  lo = [(i[0],i[1:]) for i in lo]
  d_ord = dict(lo) 
  d_ins = dict(li) 
  d_num = dict(ln) 


  l_ord =[]
  l_inst =[]
  if LIST_ORDRE or NUME_ORDRE :
    if  NUME_ORDRE  :
      if type(NUME_ORDRE) not in EnumTypes : NUME_ORDRE=(NUME_ORDRE,)
      ltmp = list(NUME_ORDRE)
    elif LIST_ORDRE :
      ltmp = aster.getvectjev(string.ljust(LIST_ORDRE.nom,19)+'.VALE') 
    for ord in ltmp :
      if ord in l0_ord :
         l_ord.append(ord)
         l_inst.append(d_ins[ord][0])
      else :
         UTMESS('A','RUPTURE0_51',vali=ord,valk=nomresu)
  elif LIST_INST or INST :
    CRITERE = args['CRITERE']
    PRECISION = args['PRECISION']
    if INST :
      if type(INST) not in EnumTypes : INST=(INST,)
      ltmp = list(INST)
    elif LIST_INST :
      ltmp = aster.getvectjev(string.ljust(LIST_INST.nom,19)+'.VALE') 
    for ins in ltmp :
      if CRITERE=='RELATIF' and ins!=0.: match=[x for x in l0_inst if abs((ins-x)/ins)<PRECISION]
      else                             : match=[x for x in l0_inst if abs(ins-x)<PRECISION]
      if len(match)==0 : 
         UTMESS('A','RUPTURE0_38',valr=ins)
      elif len(match)>=2 :
         UTMESS('A','RUPTURE0_39',valr=ins)
      else :
         l_inst.append(match[0])
         l_ord.append(d_ord[match[0]][0])
  else :
      l_ord = l0_ord
      l_inst = l0_inst
  nbarch = len(l_ord)
  if nbarch ==0 : UTMESS('F','RUPTURE0_54')
  

#  
# Calcul des K(t)
#  

  K1mod = [None]*n_mode*nbno
  K2mod = [None]*n_mode*nbno
  K1t = [None]*nbarch*nbno
  K2t = [None]*nbarch*nbno
  if DIME == 3 : 
    K3mod = [None]*n_mode*nbno
    K3t = [None]*nbarch*nbno
    k1 = 'K1'
    k2 = 'K2'
    k3 = 'K3'
  else :
    k1 = 'K1'
    k2 = 'K2'
  
  
  for x in range(0,nbno) :
    for k in range(0,n_mode) :
      K1mod[k*nbno + x] = __kgtheta[k1,k*nbno + x+1]
      K2mod[k*nbno + x] = __kgtheta[k2,k*nbno + x+1]
      if DIME == 3 : K3mod[k*nbno + x] = __kgtheta[k3,k*nbno + x+1]
   
    for num in range(0,nbarch) :
      K1t[num*nbno + x] = 0.0
      K2t[num*nbno + x] = 0.0
      if DIME == 3 : K3t[num*nbno + x] = 0.0
      for k in range(0,n_mode) :
        num_ord = d_num[l_ord[num]][0]
        alpha = coef[n_mode*num_ord+k]
        K1t[num*nbno + x] = K1t[num*nbno + x] + alpha*K1mod[k*nbno + x]
        K2t[num*nbno + x] = K2t[num*nbno + x] + alpha*K2mod[k*nbno + x]
        if DIME == 3 : K3t[num*nbno + x] = K3t[num*nbno + x] + alpha*K3mod[k*nbno + x]
 
  v = aster.__version__
  titre = 'ASTER %s - CONCEPT CALCULE PAR POST_K_TRANS LE &DATE A &HEURE \n'%v
  if DIME == 2 :
    tabout = CREA_TABLE(LISTE = (_F(LISTE_I =l_ord, PARA = 'NUME_ORDRE'),
                           _F(LISTE_R =l_inst, PARA = 'INST'),
                           _F(LISTE_R =K1t, PARA = k1),
                           _F(LISTE_R =K2t, PARA = k2),),
                        TITRE = titre,  );
  else : 
   lo = []
   li = []
   for i in range(nbarch) :
     for j in range(nbno) :
        lo.append(l_ord[i])
        li.append(l_inst[i])
   tabout = CREA_TABLE(LISTE = (_F(LISTE_I =lo, PARA = 'NUME_ORDRE'),
                           _F(LISTE_R =li, PARA = 'INST'),
                           _F(LISTE_I =range(nbno)*nbarch, PARA ='NUM_PT' ),
                           _F(LISTE_R =labsc*nbarch, PARA = 'ABSC_CURV'),
                           _F(LISTE_R =K1t, PARA = k1),
                           _F(LISTE_R =K2t, PARA = k2),
                           _F(LISTE_R =K3t, PARA = k3),),
                        TITRE = titre,
                  );
   
#------------------------------------------------------------------
  return ier
