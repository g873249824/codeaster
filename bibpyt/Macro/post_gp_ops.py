#@ MODIF post_gp_ops Macro  DATE 25/09/2006   AUTEUR MCOURTOI M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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

from types import ListType, TupleType
EnumTypes = (ListType, TupleType)
from sets import Set

# -----------------------------------------------------------------------------
def post_gp_ops(self, **args):
   """
      Corps de la macro POST_GP
   """
   macro = 'POST_GP'
   ier=0
   from Accas import _F
   from Utilitai.Utmess     import UTMESS
   from Utilitai.Table      import Table, merge
   from Utilitai.t_fonction import t_fonction
   import aster
   
   # ----- On importe les definitions des commandes a utiliser dans la macro
   CALC_THETA    = self.get_cmd('CALC_THETA')
   CALC_G        = self.get_cmd('CALC_G')
   POST_ELEM     = self.get_cmd('POST_ELEM')
   POST_RELEVE_T = self.get_cmd('POST_RELEVE_T')
   CREA_TABLE    = self.get_cmd('CREA_TABLE')
   
   # ----- Comptage, commandes + d�claration concept sortant
   self.set_icmd(1)
   self.DeclareOut('result', self.sd)
   self.DeclareOut('tabresult', self['TABL_RESU'])
   info = self['INFO']
   
   # 0. ----- Type de calcul
   identification = self['IDENTIFICATION'] != None
   if identification:
      # 0.1. --- identification : on boule sur les valeurs de TEMP.
      #          Pour chaque couple (T, Kjc(T)), on �value les Ki, Kmoy et
      #          les valeurs de Gpmax, DeltaLmax, inst.max correspondantes.
      mccalc = self['IDENTIFICATION']
      l_crit = mccalc['KJ_CRIT']
      lv_ident = []
      l_temp = mccalc['TEMP']
   else:
      # 0.2. --- pr�diction : on ne fait qu'une it�ration.
      #          Il faut un RESU_THER (sinon on utilise la temp�rature du
      #          premier Gpcrit et c� n'a pas trop d'int�ret).
      #          A chaque instant, on regarde � quelle temp�rature est le
      #          fond d'entaille et on compare Gpmax � cet instant au Gpcrit.
      mccalc = self['PREDICTION']
      l_crit = mccalc['GP_CRIT']
      lv_pred = []
      l_temp = mccalc['TEMP'][0]
   
   if not type(l_temp) in EnumTypes:
      l_temp = [l_temp,]
   if not type(l_crit) in EnumTypes:
      l_crit = [l_crit,]
   
   # 1. ----- calcul de G-theta
   nbcour = len(self['THETA_2D'])
   l_tab = []
   for occ in self['THETA_2D']:
      dMC = occ.cree_dict_valeurs(occ.mc_liste)
      
      __theta = CALC_THETA(MODELE=self['MODELE'],
                           DIRECTION=self['DIRECTION'],
                           THETA_2D=_F(GROUP_NO=dMC['GROUP_NO'],
                                       MODULE=1.0,
                                       R_INF=dMC['R_INF'],
                                       R_SUP=dMC['R_SUP']),)

      __gtheta = CALC_G(MODELE=self['MODELE'],
                        CHAM_MATER=self['CHAM_MATER'],
                        THETA=_F(THETA=__theta),
                        EXCIT=self['EXCIT'].List_F(),
                        RESULTAT=self['RESULTAT'],
                        TOUT_ORDRE='OUI',
                        SYME_CHAR=self['SYME_CHAR'],
                        COMP_ELAS=self['COMP_ELAS'].List_F(),)

      tab = __gtheta.EXTR_TABLE()
      
      # une Table par couronne
      l_tab.append(tab)

   # 2. ----- Calcul de l'energie �lastique en exploitant les groupes de
   #          mailles fournis par la procedure de maillage
   l_copo = [grma.strip() for grma in self['GROUP_MA']]
   nbcop = len(l_copo)
   l_charg = [charg['CHARGE'] for charg in self['EXCIT']]
   
   __ener = POST_ELEM(MODELE=self['MODELE'],
                        RESULTAT=self['RESULTAT'],
                        CHARGE=l_charg,
                        TOUT_ORDRE='OUI',
                        ENER_ELAS=_F(GROUP_MA=l_copo),
                        TITRE='Energie �lastique',)

   t_enel = __ener.EXTR_TABLE()
   
   # 2.1. ----- Indice de chaque copeau et deltaL
   d_icop = dict(zip(l_copo, range(1, nbcop + 1)))
   
   l_lieu = [grma.strip() for grma in t_enel.LIEU.values()]
   l_icop = [d_icop[grma] for grma in l_lieu]
   t_enel['ICOP'] = l_icop
   t_enel.fromfunction('DELTAL', fDL, 'ICOP', { 'pascop' : self['PAS_ENTAILLE'] })
   
   # 2.2. ----- Calcul de Gp fonction de Ener.Totale et de deltaL
   t_enel.fromfunction('GP', fGp_Etot, ('TOTALE', 'ICOP'),
         { 'pascop' : self['PAS_ENTAILLE'], 'syme' : self['SYME_CHAR'] != 'SANS' })
   
   # 2.3. ----- Tableau de Gp = f(icop) pour chaque instant
   if info >= 2:
      tGp_t_icop = t_enel['INST', 'DELTAL', 'GP']
      tGp_t_icop.titr = "Gp � chaque instant en fonction de la distance au " \
                        "fond d'entaille"
      tGp_t_icop.ImprTabCroise()
   
   # 2.4. ----- Table Gpmax
   ttmp = t_enel['NUME_ORDRE', 'INST', 'ICOP', 'DELTAL', 'GP']
   l_numord = list(Set(ttmp.NUME_ORDRE.values()))
   l_numord.sort()
   for j in l_numord:
      t = (ttmp.NUME_ORDRE == j).GP.MAXI()
      if j == 1:
         tb_Gpmax = t
      else:
         tb_Gpmax = tb_Gpmax | t
   tb_Gpmax.Renomme('GP', 'GPMAX')
   tb_Gpmax.Renomme('ICOP', 'ICOPMAX')
   tb_Gpmax.Renomme('DELTAL', 'DELTALMAX')
   tb_Gpmax.titr = 'Gpmax � chaque instant'
   if info >= 2:
      print tb_Gpmax
   
   # 2.5. ----- extraction de la temp�rature en fond d'entaille
   if self['RESU_THER']:
      grno_fond = self['THETA_2D'][0]['GROUP_NO']
      __relev = POST_RELEVE_T(ACTION=_F(RESULTAT=self['RESU_THER'],
                                        OPERATION='EXTRACTION',
                                        INTITULE='Temperature',
                                        NOM_CHAM='TEMP',
                                        TOUT_ORDRE='OUI',
                                        NOM_CMP='TEMP',
                                        GROUP_NO=grno_fond,),)
      t_relev = __relev.EXTR_TABLE()['NUME_ORDRE', 'TEMP']
   
   
   # 3. ----- boucle sur les mots-cl�s facteurs
   #          op�rations d�pendant de la temp�rature
   MATER = self['MATER']
   flag_mat = True
   
   for iocc, TEMP in enumerate(l_temp):
      # 3.0. ----- Temperature fonction du temps : si on n'a pas de RESU_THER,
      #            on prend la temp�rature d'identification.
      if not self['RESU_THER']:
         l_rows = [{'NUME_ORDRE' : i, 'TEMP' : TEMP} for i in l_numord]
         t_relev = Table(rows=l_rows, para=('NUME_ORDRE', 'TEMP'), typ=('R', 'R'))
         flag_mat = True
      
      # 3.1. ----- extrait du mat�riau E(TEMP) et NU(TEMP) (si n�cessaire)
      if flag_mat:
         t_relev.fromfunction('YOUNG', CallRCVALE, 'TEMP',
               { 'para' : 'E', 'MATER' : MATER })
         t_relev.fromfunction('NU', CallRCVALE, 'TEMP',
               { 'para' : 'NU', 'MATER' : MATER })
         #tb_Gpmax = merge(tb_Gpmax, t_relev, 'NUME_ORDRE')
         flag_mat = False
      
      # 3.2. ----- param�tres
      dict_constantes = {
         'YOUNG' : CallRCVALE(TEMP, 'E', MATER),
         'NU'    : CallRCVALE(TEMP, 'NU', MATER),
         'R'     : self['RAYON_AXIS'],
      }
      
      # 3.3. ----- calcul de Kj(G)
      l_tabi = []
      for k, tab in enumerate(l_tab):
         # fusion avec TEMP, E et nu.
         tab = merge(tab, t_relev, 'NUME_ORDRE')
         
         # calcul de Kj(G) = K_i
         new_para = 'K_%d' % (k + 1)
         tab.fromfunction(new_para, fKj, ('G', 'YOUNG', 'NU'),
                          { 'R' : self['RAYON_AXIS'] })
         
         # renomme G en G_i
         tab.Renomme('G', 'G_%d' % (k + 1))
         l_tabi.append(tab)
      
      # 3.4 ----- Table des Gi, Ki sur les differentes couronnes + Kmoyen
      tabK_G = l_tabi[0]['NUME_ORDRE']
      for tab in l_tabi:
         tabK_G = merge(tabK_G, tab, 'NUME_ORDRE')
      tabK_G.titr = 'G et K sur les differentes couronnes + moyennes'
      tabK_G.fromfunction('GMOY', moyenne, ['G_%d' % (k + 1) for k in range(nbcour)])
      tabK_G.fromfunction('KMOY', moyenne, ['K_%d' % (k + 1) for k in range(nbcour)])
      
      # 3.5. ----- Contribution � la table globale
      tabres = merge(tabK_G, tb_Gpmax, 'NUME_ORDRE')
      tabres['OCCURRENCE'] = [iocc + 1] * len(l_numord)
      if info >= 2:
         print tabres
      
      # 3.5.1. --- Table globale
      if iocc == 0:
         tabl_glob = tabres
      else:
         tabl_glob = merge(tabl_glob, tabres)
      tabl_glob.titr = 'G, K sur les differentes couronnes, Gmoy, Kmoy et ' \
                       'Gpmax fonctions du temps'
      
      # 3.6. ----- traitement selon identification / pr�diction
      d_para = {
         'INTERPOL' : ['LIN', 'LIN'],
         'NOM_PARA' : 'INST',
         'PROL_DROITE' : 'CONSTANT',
         'PROL_GAUCHE' : 'CONSTANT',
      }
      # Gpmax fonction du temps
      d_para.update({ 'NOM_RESU' : 'GPMAX' })
      fGp = t_fonction(tabres.INST.values(), tabres.GPMAX.values(), d_para)
      
      # 3.6.1. --- identification
      if identification:
         KJ_CRIT = l_crit[iocc]
         # d�finition des fonctions pour faire les interpolations
         d_para.update({ 'NOM_RESU' : 'DELTALMAX' })
         fdL = t_fonction(tabres.INST.values(), tabres.DELTALMAX.values(), d_para)
   
         d_para.update({ 'NOM_PARA' : 'KMOY',
                         'NOM_RESU' : 'INST', })
         valkmoy = tabres.KMOY.values()
         finv = t_fonction(valkmoy, tabres.INST.values(), d_para)
         
         if not (min(valkmoy) <= KJ_CRIT <= max(valkmoy)):
            UTMESS('A', macro, 'Interpolation hors du domaine (prolongement ' \
                               'constant utilis�).')
         # valeurs � mettre dans la table
         ti   = finv(KJ_CRIT)
         Gpi  = fGp(ti)
         d_ident = {
            'KJ_CRIT'   : KJ_CRIT,
            'INST'      : ti,
            'GPMAX'     : Gpi,
            'KGPMAX'    : fKj(Gpi, **dict_constantes),
            'DELTALMAX' : fdL(ti),
         }
         lv_ident.append(d_ident)
      
      # 3.6.2. --- pr�diction
      else:
         pass
   
   # 4. ----- Construction de la table r�sultat si demand�e
   # 4.1. --- identification
   if identification:
      tab_ident = Table(rows=lv_ident,
                        para=('KJ_CRIT', 'INST', 'GPMAX', 'KGPMAX', 'DELTALMAX'),
                        typ= ('R',    'R',       'R',     'R',      'R'),
                        titr='Identification aux valeurs de tenacit�s critiques')
      dprod_result = tab_ident.dict_CREA_TABLE()
      if info >= 2:
         print tab_ident

   # 4.2. --- pr�diction
   else:
      # d�finition de la fonction GPcrit = f(TEMP)
      d_para.update({ 'NOM_PARA' : 'TEMP',
                      'NOM_RESU' : 'GP_CRIT', })
      fGpc = t_fonction(mccalc['TEMP'], mccalc['GP_CRIT'], d_para)
      
      tab_pred = tabl_glob['NUME_ORDRE', 'INST', 'TEMP', 'DELTALMAX', 'GPMAX']
      tab_pred.fromfunction('GP_CRIT', fGpc, 'TEMP')
      tab_pred.fromfunction('PREDICTION', crit, ('GP_CRIT', 'GPMAX'))
      tab_pred.titr = 'Comparaison Gpmax � Gpcrit(T)'
      dprod_result = tab_pred.dict_CREA_TABLE()
   
   # 9. ----- cr�ation de la table_sdaster r�sultat
   dprod = tabl_glob.dict_CREA_TABLE()
   result = CREA_TABLE(**dprod)
   tabresult = CREA_TABLE(**dprod_result)



# -----------------------------------------------------------------------------
def CallRCVALE(TEMP, para, MATER):
   """Fonction appelant RCVALE et retourne la valeur d'un param�tre.
   """
   valres, flag_ok = MATER.RCVALE('ELAS', 'TEMP', TEMP, para)
   assert list(flag_ok).count('OK') != 1, \
         'Erreur lors de la r�cup�ration des valeurs du mat�riau.'
   return valres

# -----------------------------------------------------------------------------
def fKj(G, YOUNG, NU, R):
   """Calcul de Kj � partir de G (formule d'Irwin)
   """
   return (G / R * YOUNG / (1.0 - NU**2))**0.5

# -----------------------------------------------------------------------------
def fDL(ICOP, pascop):
   """DeltaL = num�ro copeau * pas d'entaille
   """
   return ICOP * pascop

# -----------------------------------------------------------------------------
def fGp_Etot(TOTALE, ICOP, pascop, syme=False):
   """Gp(Etotale, K), deltal pris dans le context global.
      ICOP   : num�ro du copeau,
      pascop : pas d'entaille.
      syme   : True s'il y a sym�trie.
   """
   fact_axis = 1.
   if syme:
      fact_axis = 2.
   return fact_axis * TOTALE / fDL(ICOP, pascop)

# -----------------------------------------------------------------------------
def crit(GP_CRIT, GPMAX):
   """Retourne 1 quand GP_CRIT > GPMAX
   """
   if GPMAX > GP_CRIT:
      return 1
   else:
      return 0

# -----------------------------------------------------------------------------
def moyenne(*args):
   """Fonction moyenne
   """
   return sum(args)/len(args)

