#@ MODIF propa_fiss_ops Macro  DATE 07/01/2013   AUTEUR LADIER A.LADIER 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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

from math import atan, atan2, cos, sin, log, sqrt, acos, pi

import numpy as NP
from types import ListType, TupleType


def InterpolationLineaire(x0, points) :
   """
       Interpolation Lineaire de x0 sur la fonction discretisee yi=points(xi) i=1,..,n
   """
   # x0     = Une abscisse        (1 colonne, 1 ligne)
   # points = Tableau de n points (2 colonnes, n lignes)
   # on suppose qu'il existe au moins 2 points,
   # et que les points sont classes selon les abscisses croissantes

   n = len(points)
   if ( x0 < points[0][0] )  :
     y0 =  points[0][1]
     return y0
   if ( x0 > points[n-1][0] ) :
     y0 =  points[n-1][1]
     return y0
   i = 1
   while x0 > points[i][0]:
      i = i+1
   y0 = (x0-points[i-1][0]) * (points[i][1]-points[i-1][1]) / (points[i][0]-points[i-1][0]) + points[i-1][1]
   return y0

def InterpolFondFiss(s0, Coorfo) :
   """
       Interpolation des points du fond de fissure
   """
   # s0     = abscisse curviligne du point considere      (0 < s0 > 1)
   # Coorfo = Coordonnees du fond (extrait de la sd fiss_xfem)
   # xyz = Coordonnees du point

   n = len(Coorfo) / 4
   if ( s0 < Coorfo[3] )  :
     xyz =  [Coorfo[0],Coorfo[1],Coorfo[2]]
     return xyz
   if ( s0 > Coorfo[-1]  ) :
     xyz =  [Coorfo[-4],Coorfo[-3],Coorfo[-2]]
     return xyz
   i = 1
   while s0 > Coorfo[4*i+3]:
      i = i+1
   xyz = [0.]*3
   xyz[0] = (s0-Coorfo[4*(i-1)+3]) * (Coorfo[4*i+0]-Coorfo[4*(i-1)+0]) / (Coorfo[4*i+3]-Coorfo[4*(i-1)+3]) + Coorfo[4*(i-1)+0]
   xyz[1] = (s0-Coorfo[4*(i-1)+3]) * (Coorfo[4*i+1]-Coorfo[4*(i-1)+1]) / (Coorfo[4*i+3]-Coorfo[4*(i-1)+3]) + Coorfo[4*(i-1)+1]
   xyz[2] = (s0-Coorfo[4*(i-1)+3]) * (Coorfo[4*i+2]-Coorfo[4*(i-1)+2]) / (Coorfo[4*i+3]-Coorfo[4*(i-1)+3]) + Coorfo[4*(i-1)+2]
   return xyz

def NORMEV(v0) :
  NormeV = 0.
  for i in range(len(v0)) :
    NormeV = NormeV + v0[i]**2
  NormeV = sqrt(NormeV)
  v1 = [0.]*len(v0)
  for i in range(len(v0)) :
    v1[i] = v0[i]/NormeV
  return v1

def DDOT(u,v) :
  PS = 0
  for i in range(max(len(u),len(v))) :
    PS = PS + u[i]*v[i]
  return PS

def PROVEC3D(u,v) :
  w=[ u[1]*v[2] - u[2]*v[1] , \
      u[2]*v[0] - u[0]*v[2] , \
      u[0]*v[1] - u[1]*v[0] ]
  return w

def InterpolBaseFiss(s0, Basefo, Coorfo) :
# Interpolation de la base locale en fond de fissure
# s0     = abscisse curviligne du point considere
# Basefo = base locale du fond (VNx,VNy,VNz,VPx,VPy,VPz)
# Coorfo = Coordonnees et abscisses du fond (extrait de la sd fiss_xfem)
# en sortie : VPVNi = base locale au point considere (6 coordonnes)
   # Cas Particuliers
   if ( s0 < Coorfo[3] )  :
     np = [0.]*3
     tp = [0.]*3
     for k in range(3) :
       np[k] = Basefo[k]
       tp[k] = Basefo[k+3]
   elif ( s0 > Coorfo[-1]  ) :
     np = [0.]*3
     tp = [0.]*3
     for k in range(-3,0) :
       np[k] = Basefo[k-3]
       tp[k] = Basefo[k]
   else :
     # Cas General
     # on incremente jusqua arriver au bon intervalle
     i = 1
     while s0 > Coorfo[4*i+3] :
       i = i+1
     # Recherche de tous les elements pour reconstruire la rotation entre les deux bases
     # 1 - Calcul des reperes associes aux extremites du segment
     base1 = [[0.]*3 for j in range(3)]
     base2 = [[0.]*3 for j in range(3)]
     for k in range(3) :
       base1[1][k] = Basefo[6*(i-1)+k]
       base2[1][k] = Basefo[6*i+k]
       base1[0][k] = Basefo[6*(i-1)+k+3]
       base2[0][k] = Basefo[6* i+k+3]
     base1[0] = NORMEV(base1[0])
     base2[0] = NORMEV(base2[0])
     b11b10 = DDOT(base1[1],base1[0])
     b21b20 = DDOT(base2[1],base2[0])
     for k in range(3) :
       base1[1][k] =  base1[1][k] - b11b10*base1[0][k]
       base2[1][k] =  base2[1][k] - b21b20*base2[0][k]
     base1[1] = NORMEV(base1[1])
     base2[1] = NORMEV(base2[1])
     base1[2] = PROVEC3D(base1[0],base1[1])
     base2[2] = PROVEC3D(base2[0],base2[1])
     # 2 - Calcul de la matrice de rotation
     R = [[0.]*3 for j in range(3)]
     for k in range(3) :
       for l in range(3) :
         R[k][l] = DDOT(base1[k],base2[l])
     # 3 - Calcul de langle de rotation
     TraceR = 0.
     for k in range(3) :
       TraceR = TraceR + R[k][k]
     if TraceR >= 3. :
       VPVNi = [0.]*6
       for k in range(3) :
         VPVNi[k] = base1[1][k]
         VPVNi[k+3] = base1[0][k]
       return VPVNi
     if TraceR < -1 :
       TraceR = -1
     theta = acos( (TraceR-1)/2 )
     # 4 - Calcul de l'axe de rotation (d euler)
     sintheta = sin(theta)
     e = [ (R[1][2]-R[2][1])/(2*sintheta) , \
           (R[2][0]-R[0][2])/(2*sintheta) , \
           (R[0][1]-R[1][0])/(2*sintheta) ]
     #print'Axe de rotation = ',e
     # Construction de la nouvelle base en P
     # 1 - Interpolation lineaire de langle dans lintervalle considere
     s = ( s0 - Coorfo[4*(i-1)+3] ) / ( Coorfo[4*i+3] - Coorfo[4*(i-1)+3] )
     thetaP = s*theta
     # 2 - Calcul des coordonnees dans tp et np dans la base1
     costhetaP = cos(thetaP)
     sinthetaP = sin(thetaP)
     t = [ costhetaP + (1-costhetaP)*e[0]**2        , \
           (1-costhetaP)*e[0]*e[1] - sinthetaP*e[2] , \
           (1-costhetaP)*e[0]*e[2] + sinthetaP*e[1]   ]
     n = [ (1-costhetaP)*e[0]*e[1] + sinthetaP*e[2] , \
           costhetaP + (1-costhetaP)*e[1]**2        , \
           (1-costhetaP)*e[1]*e[2] - sinthetaP*e[0]   ]
     # 3 - Calcul de la base locale dans le repere de reference
     tp = [0.]*3
     np = [0.]*3
     for k in range(3) :
       tp[k] = t[0]*base1[0][k] + t[1]*base1[1][k] + t[2]*base1[2][k]
       np[k] = n[0]*base1[0][k] + n[1]*base1[1][k] + n[2]*base1[2][k]
   # orthogonalisation et normalisation au cas ou
   tp = NORMEV(tp)
   tpnp = DDOT(np,tp)
   for k in range(3) :
     np[k] =  np[k] - tpnp*tp[k]
   np = NORMEV(np)
   VPVNi = [0.]*6
   for k in range(3) :
      VPVNi[k] = np[k]
      VPVNi[k+3] = tp[k]
   return VPVNi

def recup_Elas(LOI):
      from SD.sd_mater     import sd_compor1
      if LOI == None :
         UTMESS('F','RUPTURE1_50')
      dLoi=LOI[0].cree_dict_valeurs(LOI[0].mc_liste)
      mat = dLoi['MATER']
      matph = mat.sdj.NOMRC.get()
      phenom=None
      for cmpt in matph :
         if cmpt[:4]=='ELAS' :
            phenom=cmpt
            break
      if phenom==None : UTMESS('F','RUPTURE0_5')
      compor = sd_compor1('%-8s.%s' % (mat.nom, phenom))
      valk = [s.strip() for s in compor.VALK.get()]
      valr = compor.VALR.get()
      dicmat=dict(zip(valk,valr))
      if dicmat.has_key('TEMP_DEF')  :
        nompar = ('TEMP',)
        valpar = (dicmat['TEMP_DEF'],)
        UTMESS('A','XFEM2_85',valr=valpar)
        nomres=['E','NU']
        valres,codret = MATER.RCVALE('ELAS',nompar,valpar,nomres,2)
        e  = valres[0]
        nu = valres[1]
      else :
        e  = dicmat['E']
        nu = dicmat['NU']
      return e,nu,dLoi

def nom_points_fonds(n_taille):
   """
   Construction des noms des points en fond de fissure
   """
   alphabet            = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
   if n_taille <= 26:
       return alphabet[:n_taille]
   else:
       tab_alphabet        = alphabet
       taille_tab_alphabet = int(log(n_taille,26))
       for l_let1 in range(1,taille_tab_alphabet):
               for l_let2 in range(26):
                   for l_let3 in range(26):
                       tab_alphabet =  tab_alphabet + [tab_alphabet[(l_let1-1)*26+l_let2]+alphabet[l_let3]]
       reste1 = int(n_taille-len(tab_alphabet))/26
       for l_let2 in range(reste1):
                  for l_let3 in range(26):
                      tab_alphabet =  tab_alphabet + [tab_alphabet[(taille_tab_alphabet-1)*26+l_let2]+alphabet[l_let3]]
       reste2 = int(n_taille-len(tab_alphabet))
       for l_let3 in range(reste2):
                   tab_alphabet =  tab_alphabet + [tab_alphabet[(taille_tab_alphabet-1)*26+reste1]+alphabet[l_let3]]
       return tab_alphabet

def propa_fiss_ops(self,METHODE_PROPA,INFO,**args):
  """
  Macro PROPA_FISS
  Propagation de fissure pour les modeles X-FEM : propagation par la methode de HAMILTON
  ou par projection sur un maillage
  """

  import aster
  import string
  from Accas import _F
  from Utilitai.Utmess     import  UTMESS
  from Utilitai.partition import MAIL_PY

  EnumTypes = (ListType, TupleType)

  macro = 'PROPA_FISS'
  ier=0
#------------------------------------------------------------------
  # On importe les definitions des commandes a utiliser dans la macro
  ASSE_MAILLAGE         =self.get_cmd('ASSE_MAILLAGE'  )
  LIRE_MAILLAGE    =self.get_cmd('LIRE_MAILLAGE'  )
  DEFI_FICHIER = self.get_cmd('DEFI_FICHIER'  )
  DEFI_GROUP = self.get_cmd('DEFI_GROUP'  )
  CREA_TABLE    =self.get_cmd('CREA_TABLE'  )
  CALC_TABLE    =self.get_cmd('CALC_TABLE'  )
  PROPA_XFEM = self.get_cmd('PROPA_XFEM'  )
  DEFI_FISS_XFEM = self.get_cmd('DEFI_FISS_XFEM'  )
  MODI_MODELE_XFEM = self.get_cmd('MODI_MODELE_XFEM'  )
  POST_RUPTURE = self.get_cmd('POST_RUPTURE'  )
  DETRUIRE = self.get_cmd('DETRUIRE'  )
  # La macro compte pour 1 dans la numerotation des commandes
  self.set_icmd(1)


#------------------------------------------------------------------
# CAS 1 : METHODE_PROPA = 'SIMPLEXE' OU 'UPWIND' OU 'GEOMETRIQUE'
#

  if (METHODE_PROPA == 'SIMPLEXE') or (METHODE_PROPA == 'UPWIND') or (METHODE_PROPA == 'GEOMETRIQUE'):

    TEST_MAIL=args['TEST_MAIL']

    if (TEST_MAIL == 'NON' ) :
      LOI= args['LOI_PROPA']
      e,nu,dLoi = recup_Elas(LOI)

# Construction catalogue PROPA_XFEM
      dLoix = {}
      dLoix['LOI'] = 'PARIS'
      dLoix['E'] = e
      dLoix['NU'] = nu
      dLoix['C'] = dLoi['C']
      dLoix['M'] = dLoi['M']
      dLoix['N'] = dLoi['N']

    # Retreive all the parameters of PROPA_FISS
    mcsimp = {}
    mcsimp['MODELE'] =  args['MODELE']
    mcsimp['RAYON'] =  args['RAYON']
    mcsimp['DA_MAX'] =  args['DA_MAX']
    mcsimp['TEST_MAIL']=TEST_MAIL
    mcsimp['ZONE_MAJ']=args['ZONE_MAJ']
    if mcsimp['ZONE_MAJ'] == 'TORE' :
       if args['RAYON_TORE']!=None :
          mcsimp['RAYON_TORE']=args['RAYON_TORE']
    Fissures = args['FISSURE']

#   Build the list for the PROPA_XFEM operateur
    Table = []
    GrilleAux = []
    FissAct = []
    FissNou = []
    NbPointFond = []

    for Fiss in Fissures :
        FissAct.append(Fiss['FISS_ACTUELLE'])
        FissNou.append(Fiss['FISS_PROPAGEE'])
        if TEST_MAIL == 'NON':
            Table.append(Fiss['TABLE'])
            if Fiss['NB_POINT_FOND']!=None :
               if isinstance(Fiss['NB_POINT_FOND'],int) :
                  NbPointFond.append(Fiss['NB_POINT_FOND'])
               else :
                  for nbptfo in range(0,len(Fiss['NB_POINT_FOND'])) :
                      NbPointFond.append(Fiss['NB_POINT_FOND'][nbptfo])
            else :
               NbPointFond.append(-1)

    mcsimp['LISTE_FISS'] = FissAct

    if TEST_MAIL == 'NON':
       mcsimp['TABLE'] = Table
       mcsimp['NB_POINT_FOND'] = NbPointFond
       mcsimp['LOI_PROPA'      ] =dLoix

       COMP_LINE = args['COMP_LINE']
       if  COMP_LINE !=None :
           dcomp=COMP_LINE[0].cree_dict_valeurs(COMP_LINE[0].mc_liste)
           mcsimp  ['COMP_LINE'      ] =dcomp

    if TEST_MAIL == 'NON' :
#      Ok. It's time for propagation! Let's call PROPA_XFEM for each
#      propagating crack.
       for NumFiss in range(0,len(FissAct)) :
           mcsimp['FISS_PROP'] = FissAct[NumFiss]
           self.DeclareOut('nomfiss',FissNou[NumFiss])
           nomfiss = PROPA_XFEM(METHODE=METHODE_PROPA,INFO=INFO,**mcsimp )

    else :
#      Ok. I should make several crack propagation and check for the
#      distance between each propagated front and the corresponding one
#      at the beginning of the propagation.
       UTMESS('A','XFEM2_60')
       StepTot = args['ITERATIONS']
       __Fis = [None]*(StepTot*len(FissAct))
       __Mod = [None]*StepTot
       mcsimp['TOLERANCE'] = args['TOLERANCE']
       fiss = FissAct[0]
       import aster
       iret,ibid,mod_fiss = aster.dismoi('F','NOM_MODELE',fiss.nom,'FISS_XFEM')
       mod_fiss=mod_fiss.strip()
       MOD_FISS = self.get_concept(mod_fiss)

       for NumStep in range(0,StepTot) :

           aster.affiche('MESSAGE',' ------------------------')
           texte=' TEST_MAIL - ITERATION %d'%(NumStep+1)
           aster.affiche('MESSAGE',texte)
           aster.affiche('MESSAGE',' ------------------------')

           ListeFiss = []
           mcsimp['DISTANCE'] = args['DA_MAX']*(NumStep+1)

           for NumFiss in range(0,len(FissAct)) :
              if NumStep==0 :
                 mcsimp['FISS_PROP'] = FissAct[NumFiss]
              else :
                 mcsimp['MODELE'] = __Mod[NumStep-1]
                 mcsimp['FISS_PROP'] = __Fis[(NumStep-1)*len(FissAct)+NumFiss]
              mcsimp['FISS_INITIALE'] = FissAct[NumFiss]
              if NumStep==StepTot-1 :
                 self.DeclareOut('nomfiss',FissNou[NumFiss])
                 nomfiss = PROPA_XFEM(METHODE=METHODE_PROPA,INFO=INFO,**mcsimp )
              else:
                 __Fis[NumFiss+NumStep*len(FissAct)] = PROPA_XFEM(METHODE=METHODE_PROPA,INFO=INFO,**mcsimp )
                 ListeFiss.append(__Fis[NumFiss+NumStep*len(FissAct)])

           if NumStep<StepTot-1 :
              aster.affiche('MESSAGE',' ------------------------')
              aster.affiche('MESSAGE',' CREATION DU MODELE FISSURE TEMPORAIRE')
              aster.affiche('MESSAGE',' ')
              __Mod[NumStep] = MODI_MODELE_XFEM(MODELE_IN=MOD_FISS,FISSURE=(ListeFiss))
              mcsimp['LISTE_FISS'] = ListeFiss
              aster.affiche('MESSAGE',' ')
              aster.affiche('MESSAGE',' ------------------------')
              aster.affiche('MESSAGE',' ')


#------------------------------------------------------------------
# CAS 2 : METHODE_PROPA = 'MAILLAGE'
#

  if METHODE_PROPA == 'MAILLAGE' :
    Fissures =  args['FISSURE']

    LOI_PROPA = args['LOI_PROPA']
    if LOI_PROPA != None :
      coef_M =  LOI_PROPA['M']
      coef_C =  LOI_PROPA['C']
      MATER  =  LOI_PROPA['MATER']

    it = args['ITERATION']
    Damax =  args['DA_MAX']
    COMP_LINE = args['COMP_LINE']

    Nbfissure=len(Fissures)
    mm = [None]*Nbfissure
    __MMX = [None]*Nbfissure

    tab_BETA = [None]*Nbfissure
    tab_DELTA_A = [None]*Nbfissure

    __TAB_CUMUL = [None]*Nbfissure

    print '-------------------------------------------'
    print 'NOMBRE DE FISSURES A TRAITER : ',Nbfissure
    for numfis,Fiss in enumerate(Fissures) :
      print 'FISSURE ',numfis+1,'  : ',Fiss['FISS_ACTUELLE'].get_name()
      numfis=numfis+1
    print '-------------------------------------------'

# PREMIERE BOUCLE SUR LES FISSURES :
    for numfis, Fiss in enumerate(Fissures) :
      fiss0 =    Fiss['FISS_ACTUELLE']
      MAIL_FISS1 =  Fiss['MAIL_ACTUEL']
      dime= MAIL_FISS1.sdj.DIME.get()[5]

# Recuperation des K et de G
      SIF = Fiss['TABLE']
      __tabp = SIF.EXTR_TABLE()

      if (('K1' or 'G') not in __tabp.para) :
         UTMESS('F','RUPTURE1_44')

      __tab1 = __tabp.values()

      if (min(__tab1['G']) < 0.) :
           UTMESS('F','RUPTURE1_46')

# Verification que le calcul porte sur seulement un instant
      if 'INST' in __tabp.para :
        inst_tab=__tabp['INST'].values()['INST']
        l_inst_tab=set(inst_tab)
        if len(l_inst_tab) > 1 :
          UTMESS('F','XFEM2_70',valk = fiss0.get_name())

# Recuperation du nombre de fonds de fissure
      Fondmult = fiss0.sdj.FONDMULT.get()
      Nbfond = len(Fondmult)/2

      if 'NUME_FOND' in __tabp.para and max(__tab1['NUME_FOND']) != Nbfond:
         UTMESS('F','XFEM_42',valk = fiss0.get_name())

# Calcul des angles de bifurcation, des avancees et du nombre de cycles

#       copie de SIF
      __COPIE_SIF = CALC_TABLE(TABLE = SIF,
                               ACTION =_F(OPERATION='EXTR',
                               NOM_PARA=__tabp.para))

#       beta
      __COPIE_SIF = POST_RUPTURE(TABLE=__COPIE_SIF,
                                 reuse=__COPIE_SIF,
                                 OPERATION='ANGLE_BIFURCATION',
                                 CRITERE='SITT_MAX',
                                 NOM_PARA='BETA_SITT_MAX',)

#       Keq
      __COPIE_SIF = POST_RUPTURE(TABLE=__COPIE_SIF,
                                 reuse=__COPIE_SIF,
                                 OPERATION='K_EQ',
                                 CUMUL='CUMUL_G',
                                 NOM_PARA='K_EQ',
                                 MATER=MATER)

#       DKeq
      CMIN = COMP_LINE['COEF_MULT_MINI']
      CMAX = COMP_LINE['COEF_MULT_MAXI']

      __TAB_DKEQ_DA=POST_RUPTURE(TABLE=__COPIE_SIF,
                                 OPERATION='COMPTAGE_CYCLES',
                                 NOM_PARA=('K_EQ'),
                                 COMPTAGE='UNITAIRE',
                                 COEF_MULT_MINI=CMIN,
                                 COEF_MULT_MAXI=CMAX)
       
#       Da
      __TAB_DKEQ_DA=POST_RUPTURE(TABLE=__TAB_DKEQ_DA,
                                 reuse=__TAB_DKEQ_DA,
                                 OPERATION='LOI_PROPA',
                                 LOI='PARIS',
                                 C=coef_C,
                                 M=coef_M)

#       somme Da
      __TAB_CUMUL[numfis]=POST_RUPTURE(TABLE=__TAB_DKEQ_DA,
                                       OPERATION='CUMUL_CYCLES')

      tab_cumul = __TAB_CUMUL[numfis].EXTR_TABLE()

      if ('ABSC_CURV' in tab_cumul.para):
        absc = tab_cumul.ABSC_CURV.values()
      else :
        absc = [0.]*len(tab_cumul)

      table_beta = tab_cumul.BETA_SITT_MAX.values()
      table_delta_a = tab_cumul.DELTA_A.values()
      n = len(table_beta)
       
      tab_BETA[numfis] = {}
      tab_DELTA_A[numfis] = {}

      if 'NUME_FOND' in tab_cumul.para:
        tab_nume_fond=tab_cumul.NUME_FOND.values()
        list_nume_fond=list(set(tab_nume_fond))

        for fond_i in list_nume_fond :
          tab_BETA[numfis][fond_i]=[[absc[i],table_beta[i]*pi/180.] for i in range(n) if tab_nume_fond[i]==fond_i]
          tab_DELTA_A[numfis][fond_i]=[[absc[i],table_delta_a[i]] for i in range(n) if tab_nume_fond[i]==fond_i]
      else :
        tab_BETA[numfis][1] = [[absc[i],table_beta[i]*pi/180.] for i in range(n)]
        tab_DELTA_A[numfis][1] = [[absc[i],table_delta_a[i]] for i in range(n)]         

      DETRUIRE(CONCEPT=_F(NOM=__TAB_DKEQ_DA),INFO=1)
      DETRUIRE(CONCEPT=_F(NOM=__COPIE_SIF),INFO=1)   


# CALCUL DU NOMBRE DE CYCLES EQUIVALENTS
    __TAB_PILO=POST_RUPTURE(OPERATION='PILO_PROPA',
                            TABLE=[__TAB_CUMUL[i] for i in range(Nbfissure)],
                            DELTA_A_MAX = Damax)

    NBCYCLE =__TAB_PILO.EXTR_TABLE().DELTA_CYCLE.values()[0]
    
    DETRUIRE(CONCEPT=_F(NOM=__TAB_PILO),INFO=1)

    print 'AVANCE MAXIMALE DU FOND DE FISSURE',Damax
    print 'NOMBRE DE CYCLES DE FATIGUE',NBCYCLE

# DEUXIEME BOUCLE SUR LES FISSURES : PROPAGATION
    for numfis, Fiss in enumerate(Fissures) :
      DETRUIRE(CONCEPT=_F(NOM=__TAB_CUMUL[numfis]),INFO=1)
      fiss0 = Fiss['FISS_ACTUELLE']
      print '-------------------------------------------'
      print 'TRAITEMENT DE LA FISSURE ',fiss0.get_name()
      print '-------------------------------------------'
      MAIL_FISS1 = Fiss['MAIL_ACTUEL']
      MFOND = Fiss['GROUP_MA_FOND']
      MFISS = Fiss['GROUP_MA_FISS']
#------------------------------------------------------------------
# CAS 2a : MODELE 3D
#
      if dime == 3 :
        mm[numfis] = MAIL_PY()
        mm[numfis].FromAster(MAIL_FISS1)

# Recuperation des informations sur le maillage
        nbno = mm[numfis].dime_maillage[0]
        nbma = mm[numfis].dime_maillage[2]
        groupma = mm[numfis].gma
        Fondmult = fiss0.sdj.FONDMULT.get()
        Nbfond = len(Fondmult)/2
        Coorfo = fiss0.sdj.FONDFISS.get()

# Recuperation de la liste des noeuds du fond
        connex = mm[numfis].co
        linomma  = list(mm[numfis].correspondance_mailles)
        lisnofo = []
        # recuperation des noeud du fond de fissure
        inofo = 1
        FmPrec = []
        lmafo = groupma[MFOND+'_'+str(it-1)]
        for i in range(len(lmafo)) :
          ma_i = linomma[lmafo[i]]
          no_i = connex[lmafo[i]]
          if i == 0 :
            FmPrec.append(no_i[0])
            lisnofo.append(no_i[0])
            lisnofo.append(no_i[1])
          # si on reste sur le meme fond
          elif lisnofo[inofo] == no_i[0] :
            lisnofo.append(no_i[1])
            inofo += 1
          # si on change de fond
          elif lisnofo[inofo] == no_i[0] - 1 :
            FmPrec.append(no_i[0] - 1)
            FmPrec.append(no_i[0])
            lisnofo.append(no_i[0])
            lisnofo.append(no_i[1])
            inofo += 2
          # le maillage en entree n'est pas bien ordonne
          else :
            UTMESS('F','RUPTURE1_51')
        FmPrec.append(lisnofo[-1])
        nbnofo = len(lisnofo)

# Dans le cas de la separation d'un front en deux
# on cherche les points du front les plus proches des nouvelles extremites des fronts de fissures
        FmAct = [-1]*2*Nbfond
        for j in range(2*Nbfond):
          xyz = Coorfo[4*(Fondmult[j]-1):4*Fondmult[j]-1]
          xyzk = mm[numfis].cn[nbno-nbnofo+0]
          dist0 = -1
          k0=0
          for k in range(nbnofo):
            xyzk=mm[numfis].cn[nbno-nbnofo+k]
            if (xyz[0]-xyzk[0])**2+(xyz[1]-xyzk[1])**2+(xyz[2]-xyzk[2])**2<=dist0 or dist0==-1:
              dist0 = (xyz[0]-xyzk[0])**2 + (xyz[1]-xyzk[1])**2 + (xyz[2]-xyzk[2])**2
              k0 = k
          FmAct[j] = nbno - nbnofo + k0

#         Correction de la position des noeuds les plus proches des bords libres
          mm[numfis].cn[FmAct[j]][0] = Coorfo[4*(Fondmult[j]-1) + 0]
          mm[numfis].cn[FmAct[j]][1] = Coorfo[4*(Fondmult[j]-1) + 1]
          mm[numfis].cn[FmAct[j]][2] = Coorfo[4*(Fondmult[j]-1) + 2]

# Critere pour calculer le nombre de noeuds total et par fond
        # nombre total de noeuds constant
        # repartition par fonds en fonction de leurs distance curviligne
        abstot = 0.
        nbnofobis = 0
        nbptfo = [0]*Nbfond
        for j in range(Nbfond) :
          abstot += Coorfo[4*Fondmult[2*j+1]-1]
        for j in range(Nbfond) :
          absmax = Coorfo[4*Fondmult[2*j+1]-1]
          nbptfo[j] = int(nbnofo*absmax/abstot)
          nbnofobis += nbptfo[j]
        # pour eviter les cas comme 10.2 (10) + 10.4 (10) + 10.4 (10) = 31 (30)
        if nbnofobis < nbnofo :
          liste = []
          for j in range(Nbfond) :
            absmax = Coorfo[4*Fondmult[2*j+1]-1]
            liste.append([nbnofo*absmax/abstot - nbptfo[j],j])
          # on ordonne les fonds en fonction de la longueur curviligne
          liste.sort()
          for i in range(nbnofo - nbnofobis) :
            nbptfo[liste[i][1]] += 1
            nbnofobis += 1
        nbnofo = nbnofobis

# Creation des points a partir desquels nous allons calculer le nouveau fond

        numptfo = [[0]*nbptfo[i] for i in range(Nbfond)]
        abscf=[[0.]*nbptfo[i] for i in range(Nbfond)]
        ALPHABET = nom_points_fonds(nbnofo)
        inofo = 0
        for j in range(Nbfond):
          absmax = Coorfo[4*Fondmult[2*j+1]-1]
          Coorfoj= Coorfo[4*(Fondmult[2*j]-1):4*Fondmult[2*j+1]]
          abscf[j][0] = 0
          abscf[j][-1] = absmax
          numptfo[j][0] = FmAct[2*j]
          numptfo[j][-1] = FmAct[2*j+1]
          for i in range(1,nbptfo[j]-1):
            abscf[j][i] = i * absmax / (nbptfo[j]-1)
            xyz = InterpolFondFiss(abscf[j][i], Coorfoj)
            numptfo[j][i] = nbno
            LesNoeudsEnPlus = NP.array([[xyz[0],xyz[1],xyz[2]]])
            mm[numfis].cn = NP.concatenate((mm[numfis].cn,LesNoeudsEnPlus))
            NomNoeudsEnPlus =     ('PS%s%i' %(ALPHABET[inofo],it),)
            mm[numfis].correspondance_noeuds = tuple(mm[numfis].correspondance_noeuds) + NomNoeudsEnPlus
            inofo += 1
            nbno += 1
        nbmafo = nbnofo - Nbfond
        nbno += nbnofo

# Recuperation des informations importantes pour la propagation
        Basefo = fiss0.sdj.BASEFOND.get()
        Listfo = fiss0.sdj.FONDFISS.get()

# Boucle sur le fond : calcul des coordonnees des points propages
        inofo = 0
        A = [0,0,0]
        B = [0,0,0]
        Damaxbis = Damax

        for j in range(Nbfond) :
          for i in range(len(numptfo[j])) :
             Xf =  mm[numfis].cn[numptfo[j][i]][0]
             Yf =  mm[numfis].cn[numptfo[j][i]][1]
             Zf =  mm[numfis].cn[numptfo[j][i]][2]
             C = [Xf,Yf,Zf]
             VPVNi = InterpolBaseFiss(abscf[j][i],Basefo[6*(Fondmult[2*j]-1):6*Fondmult[2*j+1]], Listfo[4*(Fondmult[2*j]-1):4*Fondmult[2*j+1]])
             # Calcul des points propages
             beta = InterpolationLineaire(abscf[j][i],tab_BETA[numfis][j+1])
             Vloc = NBCYCLE*InterpolationLineaire(abscf[j][i],tab_DELTA_A[numfis][j+1])
             Xf2 = Xf + (VPVNi[3]*cos(beta)+VPVNi[0]*sin(beta))*Vloc
             Yf2 = Yf + (VPVNi[4]*cos(beta)+VPVNi[1]*sin(beta))*Vloc
             Zf2 = Zf + (VPVNi[5]*cos(beta)+VPVNi[2]*sin(beta))*Vloc
             D = [Xf2,Yf2,Zf2]
             # Verification de la convexite du fond
             if i > 0 :
               AB = [B[0]-A[0],B[1]-A[1],B[2]-A[2]]
               AC = [C[0]-A[0],C[1]-A[1],C[2]-A[2]]
               AD = [D[0]-A[0],D[1]-A[1],D[2]-A[2]]
               CD = [D[0]-C[0],D[1]-C[1],D[2]-C[2]]
               # Calcul de produits scalaires pour savoir si cest un cas problematique
               # Calcul de E1 et E2 base orthonorme dans le plan ABC
               E1 = NORMEV(AB)
               ACE1 = DDOT(AC,E1)
               E2=[AC[k]-ACE1*E1[k] for k in range(3)]
               E2 = NORMEV(E2)
               # produit scalaire entre E2 (normal a AB) et CD pour savoir si convexe
               PS = DDOT(E2,CD)
               # Si fissure non convexe, verification de la grandeur du pas Damax
               # (en effet les mailles peuvent avoir leurs aretes qui se croisent
               #  ce qui risque de poser des problemes lors de lusage de DEFI_FISS)
               if PS < 0 :
                 # Recherche du point dintersection M, AM=xE1
                 x = (DDOT(AD,E2)*DDOT(AC,E1) - DDOT(AC,E2)*DDOT(AD,E1))/DDOT(CD,E2)
                 alpha = 1.2
                 Crit1 = x / (alpha * DDOT(AB,E1))
                 Crit2 = sqrt(((x - DDOT(AC,E1))**2 + DDOT(AC,E2)**2)/(DDOT(CD,E1)**2 + DDOT(CD,E2)**2))
                 if Crit1 < 1 :
                   Damaxbis = min(Damaxbis,Damax * Crit1)
                 if Crit2 < 1 :
                   Damaxbis = min(Damaxbis,Damax * Crit2)
             A=C
             B=D
             LesNoeudsEnPlus = NP.array([[Xf2,Yf2,Zf2]])
             NomNoeudsEnPlus =     ('NX%s%i' %(ALPHABET[inofo],it+1),)
             mm[numfis].cn = NP.concatenate((mm[numfis].cn,LesNoeudsEnPlus))
             mm[numfis].correspondance_noeuds = tuple(mm[numfis].correspondance_noeuds) + NomNoeudsEnPlus
             inofo+=1

# 2eme Calcul des points avec le nouveau DAMAX si fissure probematique
        if Damaxbis < Damax :
          UTMESS('F','XFEM_70',valr = [Damax,Damaxbis])

# Ajouts Maille levre (quad4)
        imafo = 0
        nbma += 2*nbmafo
        fsi = mm[numfis].gma['%s_%i' %(MFISS,it-1)]
        for j in range(Nbfond) :
          for i in range(len(numptfo[j])-1) :
             i1 = numptfo[j][i]
             i2 = numptfo[j][i+1]
             i3 = nbno - nbnofo + imafo + j + 1
             i4 = nbno - nbnofo + imafo + j
             mm[numfis].co.append(NP.array([i1,i2,i3,i4]))
             typ_maille = mm[numfis].dic['QUAD4']
             mm[numfis].tm = NP.concatenate((mm[numfis].tm,NP.array([typ_maille])))
             mm[numfis].correspondance_mailles += ('MX%s%i' %(ALPHABET[imafo], it+1),)
             mm[numfis].gma['%s_%i' %(MFISS,it)] = NP.concatenate((fsi,NP.array([nbma - 2*nbmafo + imafo])))
             fsi = mm[numfis].gma['%s_%i' %(MFISS,it)]
             imafo += 1

# Ajout Maille fond (SEG2)
        imafo=0
        for j in range(Nbfond) :
          for i in range(len(numptfo[j])-1) :
            i3 = nbno - nbnofo + imafo + j
            i4 = nbno - nbnofo + imafo + j + 1
            mm[numfis].co.append(NP.array([i3,i4]))
            typ_maille = mm[numfis].dic['SEG2']
            mm[numfis].tm = NP.concatenate((mm[numfis].tm,NP.array([typ_maille])))
            mm[numfis].correspondance_mailles += ('MF%s%i' %(ALPHABET[imafo], it+1),)
            imafo += 1
        mm[numfis].gma['%s_%i' %(MFOND,it)] = NP.arange(nbma - nbmafo,nbma)

#------------------------------------------------------------------
# CAS 2b : MODELE 2D
#
      if dime == 2 :
        mm[numfis] = MAIL_PY()
        FISS_A = '%s_%i' %(MFISS,(it-1))
        DEFI_GROUP(reuse =MAIL_FISS1,
                 MAILLAGE=MAIL_FISS1,
                 CREA_GROUP_NO=_F(OPTION='NOEUD_ORDO',
                                  NOM='Nds_Plan',
                                  GROUP_MA=FISS_A,),INFO=2);
        DEFI_GROUP(reuse =MAIL_FISS1,
                 MAILLAGE=MAIL_FISS1,
                 DETR_GROUP_MA=_F(NOM='A',),
                 CREA_GROUP_MA=_F(OPTION='APPUI',
                                  NOM='A',
                                  TYPE_APPUI='TOUT',
                                  GROUP_NO='Nds_Plan',),INFO=2);
        DEFI_GROUP(reuse =MAIL_FISS1,
                 MAILLAGE=MAIL_FISS1,
                 DETR_GROUP_NO=_F(NOM='Nds_Plan',),);

        mm[numfis].FromAster(MAIL_FISS1)

        (nno,ndim) = mm[numfis].cn.shape

  # Recuperation des informations sur le maillage
        nbno = mm[numfis].dime_maillage[0]
        nbma = mm[numfis].dime_maillage[2]
        coord    = mm[numfis].cn
        linomno  = list(mm[numfis].correspondance_noeuds)
        linomno = map(string.rstrip,linomno)
        l_coorf =  [[linomno[i],coord[i]] for i in range(0,nbno)]
        d_coorf = dict(l_coorf)

  # Coordonnees du point propage
        Xf =  d_coorf['NXA%i' %(it)][0]
        Yf =  d_coorf['NXA%i' %(it)][1]

        VPVNi = fiss0.sdj.BASEFOND.get()
        Vloc = NBCYCLE*tab_DELTA_A[numfis][1][0][1]
        beta = tab_BETA[numfis][1][0][1]
        Xf2 = Xf + (VPVNi[2]*cos(beta)+VPVNi[0]*sin(beta))*Vloc
        Yf2 = Yf + (VPVNi[3]*cos(beta)+VPVNi[1]*sin(beta))*Vloc

        LesNoeudsEnPlus = NP.array([[Xf2,Yf2]])
        NomNoeudsEnPlus =     ('NXA%i' %(it+1),)
        mm[numfis].cn = NP.concatenate((mm[numfis].cn,LesNoeudsEnPlus))
        mm[numfis].correspondance_noeuds = tuple(linomno) + NomNoeudsEnPlus
        ALPHABET = nom_points_fonds(1)

  # Ajout Maille levre (SEG2)
        NomMaillesEnPlus =     ('MX%s%i' %(ALPHABET[0], it+1),)
        NoeudsMailles = [NP.array([nbno-1,nbno])]
        typ_maille = mm[numfis].dic['SEG2']
        mm[numfis].tm = NP.concatenate((mm[numfis].tm,NP.array([typ_maille])))
        mm[numfis].correspondance_mailles += NomMaillesEnPlus
        mm[numfis].co += NoeudsMailles
        fsi = mm[numfis].gma['%s_%i' %(MFISS,it-1)]
        fsi = NP.concatenate((fsi,NP.array([nbma])))
        mm[numfis].gma['%s_%i' %(MFISS,it)] = fsi.astype(int)

# Ajout Maille fond (POI1)
        NomMaillesEnPlus =     ('MF%s%i' %(ALPHABET[0], it+1),)
        NoeudsMailles = [NP.array([nbno])]
        typ_maille = mm[numfis].dic['POI1']
        mm[numfis].tm = NP.concatenate((mm[numfis].tm,NP.array([typ_maille]*1)))
        mm[numfis].correspondance_mailles += NomMaillesEnPlus
        mm[numfis].co += NoeudsMailles
        mm[numfis].gma['%s_%i' %(MFOND,it)] = NP.array([nbma+1], dtype=int)
# Fin du 2D

      if INFO==2 :
        texte="Maillage produit par l operateur PROPA_FISS"
        aster.affiche('MESSAGE',texte)
        print mm[numfis]

# Sauvegarde maillage xfem
      MAIL_FISS2 = Fiss['MAIL_PROPAGE']
      if MAIL_FISS2 != None : self.DeclareOut('ma_xfem2',MAIL_FISS2)

      unit = mm[numfis].ToAster()
      DEFI_FICHIER(UNITE=unit, ACTION="LIBERER")
      ma_xfem2=LIRE_MAILLAGE(UNITE=unit);

      if numfis == 0 :
        __MMX[0]=LIRE_MAILLAGE(UNITE=unit);
      else:
        __MMX[numfis]=ASSE_MAILLAGE(MAILLAGE_1 = __MMX[numfis-1],
                      MAILLAGE_2 = ma_xfem2,
                      OPERATION='SUPERPOSE')


# Sauvegarde maillage concatene
    MAIL_TOTAL = args['MAIL_TOTAL']
    if MAIL_TOTAL != None : self.DeclareOut('ma_tot',MAIL_TOTAL)
    MAIL_STRUC = args['MAIL_STRUC']
    ma_tot = ASSE_MAILLAGE(MAILLAGE_1 = MAIL_STRUC,
                      MAILLAGE_2 = __MMX[Nbfissure-1],
                      OPERATION='SUPERPOSE',)


#------------------------------------------------------------------
# CAS 3 : METHODE_PROPA = 'INITIALISATION'
#
  if METHODE_PROPA == 'INITIALISATION' :
    form = args['FORM_FISS']
    MFOND = args['GROUP_MA_FOND']
    MFISS = args['GROUP_MA_FISS']

# 3-a : demi-droite
    if form == 'DEMI_DROITE' :
      PF = args['PFON']
      DTAN = args['DTAN']
      PI = NP.array([[PF[0]-DTAN[0],PF[1]-DTAN[1]],])

      ndim = 2
      mm = MAIL_PY()
      mm.__init__()

# Ajout des noeuds
      LesNoeudsEnPlus = NP.concatenate((PI,NP.array([PF[0:2]])))
      NomNoeudsEnPlus =     ['NXA0','NXA1']
      mm.cn = LesNoeudsEnPlus
      mm.correspondance_noeuds = tuple( NomNoeudsEnPlus )
      ALPHABET = nom_points_fonds(1)

# Ajout Maille levre (SEG2)
      it = 1
      nbma = 0
      nbno = 0
      NomMaillesEnPlus =     ['MX%s%i' %(ALPHABET[0], it)]
      num_maille = [ nbma + 1 ]
      num_maille.append( nbma + 1 )
      NoeudsMailles = [NP.array([nbno,nbno+1])]
      typ_maille = mm.dic['SEG2']
      NbMailleAjoute = 1
      mm.tm = NP.concatenate((mm.tm,NP.array([typ_maille]*NbMailleAjoute)))
      mm.correspondance_mailles += tuple(NomMaillesEnPlus)
      mm.co += NoeudsMailles
      mm.gma['%s_0' %(MFISS)] = NP.array([nbma], dtype=int)

# Ajout Maille fond (POI1)
      NomMaillesEnPlus =     ['MF%s%i' %(ALPHABET[0], it)]
      num_maille = [ nbma + 2 ]
      NoeudsMailles = [NP.array([nbno+1])]
      typ_maille = mm.dic['POI1']
      mm.tm = NP.concatenate((mm.tm,NP.array([typ_maille]*1)))
      mm.correspondance_mailles += tuple(NomMaillesEnPlus)
      mm.co += NoeudsMailles
      mm.gma['%s_0' %(MFOND)] = NP.array([nbma+1], dtype=int)


# 3-b : demi-plan
    if form == 'DEMI_PLAN' :
      P0 = args['POINT_ORIG']
      P1 = args['POINT_EXTR']
      dpropa = args['DTAN']
      nbpt = args['NB_POINT_FOND']
      ALPHABET = nom_points_fonds(nbpt)
      Q0 = NP.array([[P0[0]-dpropa[0],P0[1]-dpropa[1],P0[2]-dpropa[2]]])

      mm = MAIL_PY()
      mm.__init__()
      x=[None]*nbpt
      y=[None]*nbpt
      z=[None]*nbpt
      xx=[None]*nbpt
      yy=[None]*nbpt
      zz=[None]*nbpt
      LesNoeudsEnPlus = Q0
      NomNoeudsEnPlus =     ['NXA0']
      mm.cn = LesNoeudsEnPlus
      mm.correspondance_noeuds = tuple( NomNoeudsEnPlus )

      for i in range(1,nbpt) :
        x[i] = P0[0]+i*(P1[0]-P0[0])/(nbpt-1)
        y[i] = P0[1]+i*(P1[1]-P0[1])/(nbpt-1)
        z[i] = P0[2]+i*(P1[2]-P0[2])/(nbpt-1)
        xx[i] = x[i] - dpropa[0]
        yy[i] = y[i] - dpropa[1]
        zz[i] = z[i] - dpropa[2]
        LesNoeudsEnPlus = NP.array([[xx[i],yy[i],zz[i]]])
        NomNoeudsEnPlus =     ['NX%s0' %(ALPHABET[i]) ]
        mm.cn = NP.concatenate((mm.cn,LesNoeudsEnPlus))
        mm.correspondance_noeuds = tuple(list(mm.correspondance_noeuds)  +NomNoeudsEnPlus )
      LesNoeudsEnPlus = NP.array([P0])
      NomNoeudsEnPlus =     ['NXA1']
      mm.cn = NP.concatenate((mm.cn,LesNoeudsEnPlus))
      mm.correspondance_noeuds = tuple(list(mm.correspondance_noeuds)  + NomNoeudsEnPlus )
      for i in range(1,nbpt) :
        LesNoeudsEnPlus = NP.array([[x[i],y[i],z[i]]])
        NomNoeudsEnPlus =     ['NX%s1' %(ALPHABET[i]) ]
        mm.cn = NP.concatenate((mm.cn,LesNoeudsEnPlus))
        mm.correspondance_noeuds = tuple(list(mm.correspondance_noeuds)  +NomNoeudsEnPlus )

# Ajout Maille levre (quad4)
      NomMaillesEnPlus = []
      num_maille = []
      NoeudsMailles = []
      for ifond in range(nbpt-1) :
         NomMaillesEnPlus.append( 'MX%s1' %(ALPHABET[ifond]) )
         num_maille.append( [ ifond +1 ] )
         num_maille.append( ifond + 1 )
         i1 = ifond
         i2 = ifond+1
         i3 = nbpt+ifond
         i4 = nbpt+ifond+1
         NoeudsMailles.append( NP.array([i1,i2,i4,i3]))

      typ_maille = mm.dic['QUAD4']
      NbMailleAjoute = nbpt-1
      mm.tm = NP.concatenate((mm.tm,NP.array([typ_maille]*NbMailleAjoute)))
      mm.correspondance_mailles += tuple(NomMaillesEnPlus)
      mm.co += NoeudsMailles
      mm.gma['%s_0' %(MFISS) ] = NP.arange(nbpt-1)

# Ajout Maille fond (SEG2)
      NomMaillesEnPlus = []
      num_maille = []
      NoeudsMailles = []
      for ifond in range(nbpt-1) :
         NomMaillesEnPlus.append( 'MF%s1' %(ALPHABET[ifond]) )
         num_maille.append( [ ifond +nbpt ] )
         num_maille.append( ifond + nbpt )
         i3 = nbpt+ifond
         i4 = nbpt+ifond+1
         NoeudsMailles.append( NP.array([i3,i4]))

      typ_maille = mm.dic['SEG2']
      NbMailleAjoute = nbpt-1
      mm.tm = NP.concatenate((mm.tm,NP.array([typ_maille]*NbMailleAjoute)))
      mm.correspondance_mailles += tuple(NomMaillesEnPlus)
      mm.co += NoeudsMailles
      mm.gma['%s_0' %(MFOND)] = NP.arange(nbpt-1, 2*(nbpt-1))

# 3-c : ellipse
    if form == 'ELLIPSE' :
      P0 = args['CENTRE']
      alpha0 = args['ANGLE_ORIG']
      alpha1 = args['ANGLE_EXTR']
      vect_x = args['VECT_X']
      vect_y = args['VECT_Y']
      gdax = args['DEMI_GRAND_AXE']
      ptax = args['DEMI_PETIT_AXE']
      normale = NP.cross(vect_x,vect_y)
      verif = NP.dot(vect_x,vect_y)
      if abs(verif) > 0.01:
          UTMESS('F','RUPTURE1_52')
      nbpt = args['NB_POINT_FOND']
      ALPHABET = nom_points_fonds(nbpt)

      mm = MAIL_PY()
      mm.__init__()
      LesNoeudsEnPlus = NP.array([[P0[0],P0[1],P0[2]]])
      NomNoeudsEnPlus =     ['NXA0']
      mm.cn = LesNoeudsEnPlus
      mm.correspondance_noeuds = tuple( NomNoeudsEnPlus )

# Coordonnees des noeuds
      matr = NP.asarray([vect_x,vect_y,normale])
      matr2 = NP.transpose(matr)
      alpha0 = alpha0*NP.pi/180.
      alpha1 = alpha1*NP.pi/180.
      for i in range(nbpt) :
         alphai = alpha0 + i*(alpha1-alpha0) / (nbpt-1)
         coor_r1 = NP.asarray([gdax*cos(alphai), ptax*sin(alphai), 0])
         coor_r0 = NP.dot(matr2,coor_r1) + P0
         LesNoeudsEnPlus = NP.array([[coor_r0[0],coor_r0[1],coor_r0[2]]])
         NomNoeudsEnPlus =     ['NX%s1' %(ALPHABET[i]) ]
         mm.cn = NP.concatenate((mm.cn,LesNoeudsEnPlus))
         mm.correspondance_noeuds = tuple(list(mm.correspondance_noeuds)  +NomNoeudsEnPlus )

# Ajout Maille levre (TRIA3)
      NomMaillesEnPlus = []
      num_maille = []
      NoeudsMailles = []
      typ_maille = mm.dic['TRIA3']
      for ifond in range(nbpt-1) :
         NomMaillesEnPlus.append( 'MX%s1' %(ALPHABET[ifond]) )
         num_maille.append( [ ifond +1 ] )
         num_maille.append( ifond + 1 )
         i1 = 0
         i2 = ifond + 1
         i3 = ifond + 2
         NoeudsMailles.append( NP.array([i1,i2,i3]))
      NbMailleAjoute = nbpt-1
      mm.tm = NP.concatenate((mm.tm,NP.array([typ_maille]*NbMailleAjoute)))
      mm.correspondance_mailles += tuple(NomMaillesEnPlus)
      mm.co += NoeudsMailles
      mm.gma['%s_0' %(MFISS) ] = NP.arange(NbMailleAjoute)



# Ajout Maille fond (SEG2)
      NomMaillesEnPlus = []
      num_maille = []
      NoeudsMailles = []
      typ_maille = mm.dic['SEG2']
      for ifond in range(nbpt-1) :
         NomMaillesEnPlus.append( 'MF%s1' %(ALPHABET[ifond]) )
         num_maille.append( [ ifond +nbpt ] )
         num_maille.append( ifond + nbpt )
         i3 = ifond + 1
         i4 = ifond + 2
         NoeudsMailles.append( NP.array([i3,i4]))

      NbMailleAjoute = nbpt-1
      mm.tm = NP.concatenate((mm.tm,NP.array([typ_maille]*NbMailleAjoute)))
      mm.correspondance_mailles += tuple(NomMaillesEnPlus)
      mm.co += NoeudsMailles
      mm.gma['%s_0' %(MFOND)] = NP.arange(nbpt-1, 2*(nbpt-1))


    if INFO==2 :
      texte="Maillage produit par l operateur PROPA_FISS"
      aster.affiche('MESSAGE',texte)
      print mm

# Sauvegarde (maillage xfem et maillage concatene)
    MAIL_FISS2 = args['MAIL_FISS']
    if MAIL_FISS2 != None : self.DeclareOut('ma_xfem2',MAIL_FISS2)
    unit = mm.ToAster()
    DEFI_FICHIER(UNITE=unit, ACTION="LIBERER")
    self.DeclareOut('ma_xfem2',MAIL_FISS2)
    ma_xfem2=LIRE_MAILLAGE(UNITE=unit);

    MAIL_TOTAL = args['MAIL_TOTAL']
    if MAIL_TOTAL != None : self.DeclareOut('ma_tot',MAIL_TOTAL)
    MAIL_STRUC = args['MAIL_STRUC']
    ma_tot = ASSE_MAILLAGE(MAILLAGE_1 = MAIL_STRUC,
                      MAILLAGE_2 = ma_xfem2,
                      OPERATION='SUPERPOSE')

  return
