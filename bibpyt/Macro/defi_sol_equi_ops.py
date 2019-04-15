# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

import os
import copy
from math import log, sqrt, floor, pi, sin, exp
from numpy import sqrt as nsqrt

def epeq(eps1, eps2, eps3):
    """Calcule la deformation equivalente"""
    from code_aster.Cata.Commands import (
         DEFI_FONCTION,
    )
    from Cata_Utils.t_fonction import t_fonction
    ep1 = eps1.convert('real')
    ep2 = eps2.convert('real')
    ep3 = eps3.convert('real')
    para = copy.copy(ep1.para)
    valx = ep1.vale_x
    valy = nsqrt(ep1.vale_y*ep1.vale_y + 3.0*ep2.vale_y*ep2.vale_y + 3.0*ep3.vale_y*ep3.vale_y)
    para['PROL_GAUCHE'] = 'CONSTANT'
    para['PROL_DROITE'] = 'CONSTANT'
    eptq = t_fonction(valx, valy, para)
    _epteq = DEFI_FONCTION(VALE=eptq.tabul(),
                                **eptq.para)
    return _epteq

#===================================================
#   FONCTION BYRNE POUR CALCULER RU MAX ET Ev
#===================================================

def fByrne (inst,GAMMA,E,NU,Y,RHO,N1):
    Liste_pos =[]
    Liste_ind_pos =[]
    Liste_neg =[]
    Liste_ind_neg =[]
    L_pos =[]
    L_neg =[]
    L_pos_ind =[]
    L_neg_ind =[]
    GAM_MAX=[]

    instant=[]
    EpsiV=[]
    Ru=[]

    # Boucle pour extraire et stocker les max de la liste des points positifs
    for indice,valeur in enumerate(GAMMA):
        if valeur > 0 :

           Liste_pos.append(valeur)
           Liste_ind_pos.append(indice)
        else:
            #stock = Liste_pos[0:i]
             # indice= Liste_pos.index
            if Liste_pos !=[]:
                L_pos.append(max(Liste_pos))
                # attention liste de liste de liste
                L_pos_ind.append(inst[Liste_ind_pos[Liste_pos.index(max(Liste_pos))]])
                Liste_pos =[]
                Liste_ind_pos =[]


    # Boucle pour extraire et stocker les max de la liste des points negatifs
    for indice,valeur in enumerate(GAMMA):
        if valeur <0 :

            Liste_neg.append(valeur)
            Liste_ind_neg.append(indice)
        else:
             if Liste_neg !=[]:
                L_neg.append(abs(min(Liste_neg)))
                L_neg_ind.append(inst[Liste_ind_neg[Liste_neg.index(min(Liste_neg))]])
                Liste_neg =[]
                Liste_ind_neg =[]

    L=min(len(L_neg),len(L_pos))

     # Boucle pour remmettre tous les sommets (+ et -) dans la meme liste et stocker les instants des maximums et minimums

    if L_pos_ind[0] < L_neg_ind[0]:
       for k in range (L):
           GAM_MAX.append(L_pos[k])
           GAM_MAX.append(L_neg[k])
       for k in range(L):
           instant.append(L_pos_ind[k])
           instant.append(L_neg_ind[k])
    else:
        for k in range (L):
            GAM_MAX.append(L_neg[k])
            GAM_MAX.append(L_pos[k])
        for k in range(L):
            instant.append(L_neg_ind[k])
            instant.append(L_pos_ind[k])

    # determiner la constante du module de recharge decharge proposée par Wu 2001
    K0=(10*N1+160)

    #initialisation des variables de déformations et ru
    EpsiV.append(0)
    Ru.append(0)

####identification des paramètres du modèle#####
    if N1==0:
       C1=0
       C2=0
    else:
        C1=8.7/(N1**1.25)
        C2=0.4/C1

   # Boucle  pour calculer les déformations et ru de chaque demi-cycle
    for i in range(1,len(GAM_MAX)):
        Gam=GAM_MAX[i]
        DeltaEpsi=0.5*Gam*C1*exp(-1*C2*(EpsiV[i-1]/Gam))
        EpsiV.append(EpsiV[i-1]+DeltaEpsi)
        Ru.append(1-exp(-1*K0*EpsiV[i]))

    return Ru, EpsiV, instant

#================================================
#            FIN DE LA FONCTION  BYRNE
#================================================


def defi_sol_equi_ops(self, TITRE, INFO, **args):
    """
       Macro DEFI_SOL_EQUI
    """
    import aster
    from code_aster.Cata.Syntax import _F
    from Utilitai.UniteAster import UniteAster
    from Utilitai.Utmess import UTMESS
    from Utilitai.Table import Table
    # from math import log, sqrt, floor, pi, sin
    from numpy import sqrt as nqsrt
    import numpy as np

  #--------------------------------------------------------------------------------
  # On importe les definitions des commandes a utiliser dans la macro
  #
    CREA_TABLE = self.get_cmd("CREA_TABLE")
    DYNA_VIBRA = self.get_cmd('DYNA_VIBRA')
    DETRUIRE = self.get_cmd('DETRUIRE')
    REST_SPEC_TEMP = self.get_cmd('REST_SPEC_TEMP')
    DEFI_INTE_SPEC = self.get_cmd('DEFI_INTE_SPEC')
    GENE_FONC_ALEA = self.get_cmd('GENE_FONC_ALEA')
    DEFI_FONCTION = self.get_cmd('DEFI_FONCTION')
    CALC_FONCTION = self.get_cmd('CALC_FONCTION')
    IMPR_FONCTION = self.get_cmd('IMPR_FONCTION')
    IMPR_TABLE = self.get_cmd('IMPR_TABLE')
    CALC_TABLE = self.get_cmd('CALC_TABLE')
    LIRE_TABLE = self.get_cmd('LIRE_TABLE')
    LIRE_FONCTION = self.get_cmd('LIRE_FONCTION')
    RECU_FONCTION = self.get_cmd('RECU_FONCTION')
    DEFI_LIST_REEL = self.get_cmd('DEFI_LIST_REEL')
    AFFE_CHAR_MECA = self.get_cmd('AFFE_CHAR_MECA')
    AFFE_CHAR_MECA_F = self.get_cmd('AFFE_CHAR_MECA_F')
    DEFI_GROUP = self.get_cmd('DEFI_GROUP')
    LIRE_MAILLAGE=self.get_cmd('LIRE_MAILLAGE')
    CREA_MAILLAGE = self.get_cmd('CREA_MAILLAGE')
    MODI_MAILLAGE = self.get_cmd('MODI_MAILLAGE')
    # PRE_GIBI=self.get_cmd('PRE_GIBI')
    IMPR_RESU=self.get_cmd('IMPR_RESU')
    AFFE_MODELE = self.get_cmd('AFFE_MODELE')
    NUME_DDL = self.get_cmd('NUME_DDL')
    CALC_MATR_ELEM = self.get_cmd('CALC_MATR_ELEM')
    ASSE_MATRICE = self.get_cmd('ASSE_MATRICE')
    CALC_VECT_ELEM = self.get_cmd('CALC_VECT_ELEM')
    ASSE_VECTEUR = self.get_cmd('ASSE_VECTEUR')
    CREA_RESU = self.get_cmd('CREA_RESU')
    CREA_CHAMP = self.get_cmd('CREA_CHAMP')
    CALC_CHAR_SEISME = self.get_cmd('CALC_CHAR_SEISME')
    CALC_CHAMP = self.get_cmd('CALC_CHAMP')
    CALC_FONC_INTERP = self.get_cmd('CALC_FONC_INTERP')
    FORMULE = self.get_cmd('FORMULE')
    AFFE_MATERIAU = self.get_cmd('AFFE_MATERIAU')
    DEFI_MATERIAU = self.get_cmd('DEFI_MATERIAU')
    DEFI_NAPPE = self.get_cmd('DEFI_NAPPE')
    AFFE_CARA_ELEM = self.get_cmd('AFFE_CARA_ELEM')
    POST_DYNA_ALEA = self.get_cmd('POST_DYNA_ALEA')
    ier = 0
    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)
    self.DeclareOut("tabout", self.sd)

    # Le concept sortant (de type table_sdaster)


# calculs de deconvolution ou reconvolution sur une colonne de sol en 2D
# avec approche harmonique lineaire equivalente (courbes G et D gamma)

    titre = 'Etude Reconvolution 500m TRI'

    nbsol = 1

    nbacc = 1

    SURF = args['SURF']

# coefficient de variabilite sur le profil de modules Emax : 2/3 ou 3/2
# par exemple
    cvar = args['COEF_VARI_MATE']

# formulation methode d'amortissement
    if args['CORR_AMOR'] == 'OUI':
      formulation = 'LYSMER'
    else:
      formulation = 'SCHNABEL'


# definition de l'operation a effectuer :
# input = 'CL' : l'accelerogramme est defini en champ libre et
# on calcule le signal deconvolue au Rocher Affleurant defini au toit du substratum
# input = 'RA' : l'accelerogramme est injecte au Rocher Affleurant defini au toit du substratum
# et on calcule le signal reconvolue au Rocher Affleurant defini au toit
# du substratum
    if args['LIEU_SIGNAL'] == 'AFFLEURANT':
        input = 'RA'
    elif args['LIEU_SIGNAL'] == 'CHAMP_LIBRE':
        input = 'CL'


    if 'DSP' in args:
      if args['DSP'] is not None  :
        TSM = args['DUREE']
      else :
        del args['DSP']



    lliaison = 'OUI'
    lmassp = 'NON'
    ltranin = 'NON'
    llcara = 'NON'

    # type de modelisation : 2D ou 3D
    dime = "2D"
    if "FONC_SIGNAL_X" in args:
        if args['FONC_SIGNAL_X'] is not None  :
            dime = "3D"

    if dime == "2D":
        name_dime = ("",)
        num_dime = 1
    elif dime == "3D":
        name_dime = ("X","Y","Z")
        dire_dime = ("DX","DY","DZ")
        num_dime = 3

    ldevi = args['TOUT_CHAM']
    if args['CHARGEMENT'] == 'ONDE_PLANE':
      liaison="OUI"
      if args['LIAISON'] == 'PERIODIQUE':
        lliaison = 'OUI'
      elif args['LIAISON'] == 'SANS':
        lliaison = 'NON'

        # Possibilite d utiliser des masses penalisées :
        # lmassp ='OUI' ou 'NON'
      if dime == "2D":
          if args['UNITE_TRAN_INIT'] is not None :
            ltranin = 'OUI'
            input = 'RA'
            lliaison = 'NON'
            if args['MASS_PENA'] is not None:
              lmassp = 'OUI'
        # Possibilite d utiliser une longueur caracteristique :
        # llcara ='OUI' ou 'NON'
            if args['LONG_CARA'] is not None :
              llcara = 'OUI'

# Possibilite de faire une verification en temporel avec coeff Rayleigh :
# veriftmp ='OUI' ou 'NON'

# formulation Byrne
    Byrne = False
    if dime == "2D":
        if args['CORRECTION'] == 'BYRNE':
          Byrne = True
    #Coefficient pour calculer ru eff / ru max
          xsieff = args['COEF_KSI']
          #0.66666667

    if 'DSP' in args:
      PARATAB = 'FREQ'
      ldevi = 'NON'
    else :
      PARATAB = 'INST'

    veriftmp = 'NON'

# Definition de  l'acceleration maximale du sol
# ATTENTION : verifier les unites m/s2 ou g
# coefu = 1;
    coefu = args['COEF_AMPL_ACCE']
    kh = 1
    zpa = 1
    coefzpa = kh / zpa
# frequence de coupure pour calcul des FDT
    fcoup = args['FREQ_COUP']

# Groupes de mailles et maillage
    mail0 = args['MAILLAGE']
    if dime == "2D":
        grma_droit = args['GROUP_MA_DROITE']
        grma_gauch = args['GROUP_MA_GAUCHE']

    if dime == "3D":
        grma_tot = args['GROUP_MA_LIGNE']

    grma_subst = args['GROUP_MA_SUBSTR']
    grma_colon = args['GROUP_MA_COL']
    #if args['GROUP_MA_LATE'] is not None:
    #  grma_late = args['GROUP_MA_LATE']
    #else:
    grma_late = 'LATE'
#

# impression des graphiques au format postscipt 'EPS' ou '' pour format GRACE
    pilimp = ''

# frequences pour le calcul des coefficients de Rayleigh
    f1 = 1.
    f2 = 15.
# definition des parametres alpha = aamult*AH et beta = abmult*AH
    aamult = 1 / (2. * 3.14 * (f1 + f2))
    abmult = 2. * 3.14 * f1 * f2 / (f1 + f2)
# definition d un facteur de correction sur les parametres de Rayleigh pour obtenir
# l amortissement hysteretique en moyenne sur la plage de frequence
    ca = 1 / (0.5 + f1 * f2 / (f1 + f2) * log(f2 / f1) / (f2 - f1))
    text = ('aamult=' + str(aamult) + ' abmult=' + str(abmult) + ' ca=' + str(ca) )
    aster.affiche('MESSAGE', text)

# coefficient pour calcul gamma_eff / gamma_max
    geff = args['COEF_GAMMA']
    # 0.65

# tolerance pour convergence sur evolution module E
    tole = args['RESI_RELA']
    # 0.05
    nmaxit = args['NMAX_ITER']
    # 10; # nombre maximal d'iteration
#  unites tables resu
    utabresu = args['UNITE_TABLE_RESU']
    utabtran = args['UNITE_RESU_TRAN']
    utabspec = args['UNITE_RESU_SPEC']
    if 'DSP' in args:
        utabdsp = args['UNITE_RESU_DSP']

# Parametres FFT ### TRES IMPORTANT ###
    fonc_acce=[None]*num_dime
    __fonc_acce=[None]*num_dime
    __AHX = [None]*num_dime
    if ltranin == 'OUI' :
      utranin = args['UNITE_TRAN_INIT']
      __fonc_acce[0]=LIRE_FONCTION(UNITE=utranin,NOM_PARA='INST',
               INTERPOL = 'LIN',PROL_DROITE = 'CONSTANT',
               INDIC_PARA=[1,1],INDIC_RESU=[1,3],
                   );

      tt, vale_s = __fonc_acce[0].Valeurs()
      dt = tt[1] - tt[0]
      nbdt = len(vale_s)
      tfin = tt[nbdt - 1]
      fmax = 0.5 / dt  # facteur 1/2 car FFT calculee avec SYME='NON'
      df = 2.0 * fmax / nbdt
      fmax = (0.5 / dt) - df

#### DSP ###tfin
    elif 'DSP' in args:
      fonc_dsp = args['DSP']
      fr, vale_s = fonc_dsp.Valeurs()
      df = fr[1] - fr[0]
      nbdt = len(vale_s)
      tfin = TSM
      dt = 0.01
      fmax = fr[- 1]

    # definition des frequences de calcul

      __lfreq = DEFI_LIST_REEL( VALE=list(fr) )
      __lfreq0 = DEFI_LIST_REEL(VALE=list(fr[1:]),)


      __fonc_dsp = DEFI_FONCTION(ABSCISSE = fr, ORDONNEE = vale_s,
                        PROL_DROITE='CONSTANT', NOM_PARA  = 'FREQ',
                        PROL_GAUCHE='CONSTANT',
                         );

      __fonc_acce[0] = DEFI_FONCTION(ABSCISSE = fr, ORDONNEE = np.sqrt(vale_s) ,
                        PROL_DROITE='CONSTANT', NOM_PARA  = 'FREQ',
                        PROL_GAUCHE='CONSTANT',
                         );

      __AHX[0]  = CALC_FONCTION(COMB_C=_F(FONCTION=__fonc_acce[0], COEF_C = 1.+0.j),
                       NOM_PARA='FREQ',);


      if fr[0] < 10**(-10):
        __VHX = DEFI_FONCTION(ABSCISSE = fr[1:], ORDONNEE = np.array(vale_s[1:])/np.array(fr[1:]),
                        PROL_DROITE='CONSTANT', NOM_PARA  = 'FREQ',
                        PROL_GAUCHE='CONSTANT',
                         );
      else:
        __VHX = DEFI_FONCTION(ABSCISSE = fr, ORDONNEE = np.array(vale_s)/np.array(fr),
                        PROL_DROITE='CONSTANT', NOM_PARA  = 'FREQ',
                        PROL_GAUCHE='CONSTANT',
                         );

####
    else :
      if dime == "2D":
          fonc_acce[0] = args['FONC_SIGNAL']
          __fonc_acce[0] = CALC_FONCTION(COMB=(
                   _F(FONCTION=fonc_acce[0], COEF=1.0),
                         ),
                    PROL_DROITE='CONSTANT',
                    PROL_GAUCHE='CONSTANT',
                     );
      elif dime == "3D":
          for n in range(num_dime):
              fonc_acce[n] = args['FONC_SIGNAL_'+name_dime[n]]
              __fonc_acce[n] = CALC_FONCTION(COMB=(
                   _F(FONCTION=fonc_acce[n], COEF=1.0),
                         ),
                    PROL_DROITE='CONSTANT',
                    PROL_GAUCHE='CONSTANT',
                     );

      tt, vale_s = __fonc_acce[0].Valeurs()
      dt = tt[1] - tt[0]
      nbdt = len(vale_s)
      tfin = tt[nbdt - 1]
      fmax = 0.5 / dt  # facteur 1/2 car FFT calculee avec SYME='NON'
      df = 2.0 * fmax / nbdt
      fmax = (0.5 / dt) - df


    if args['CHARGEMENT'] == 'ONDE_PLANE':
      n = 0
      while n < 50 :
          if 2**n >= nbdt :
             nbdt = 2**n
             break
          n = n+1

      tfin = (nbdt-1)*dt
      text = ('tfin=' + str(tfin) )
      aster.affiche('MESSAGE', text)
      fmax = 0.5 / dt  # facteur 1/2 car FFT calculee avec SYME='NON'
      df = 2.0 * fmax / nbdt
      fmax = (0.5 / dt) - df

    NB4 = 4*int(floor(nbdt / 4))

    if NB4 < nbdt :
       text = ('NB4 =' + str(NB4) + ' < NBDT =' + str(nbdt)
               + ' non multiple de 4')
       aster.affiche('MESSAGE', text)

    if args['FREQ_COUP'] is not None:
        fcoup = args['FREQ_COUP']
    else:
        fcoup = fmax
    fmaxc = fcoup
    if fmax < fcoup:
        fmaxc = fmax
    fmaxc2 = int((fmaxc+1.e-12)/df)*df
    text = ('df=' + str(df) + ' fmax=' + str(fmax) + ' fmaxc=' + str(fmaxc) )
    aster.affiche('MESSAGE', text)



# On genere les pas de temps pour lire laccelerogramme a deconvoluer
    __linst = DEFI_LIST_REEL(DEBUT=0.0, INTERVALLE=_F(JUSQU_A=tfin, PAS=dt),)


    if 'DSP' not in args:
# definition des frequences de calcul
      __lfreqc = DEFI_LIST_REEL(
        DEBUT=0.1, INTERVALLE=_F(JUSQU_A=fmaxc, PAS=0.1),)
      __lfreq = DEFI_LIST_REEL(DEBUT=0.0, INTERVALLE=_F(JUSQU_A=fmax, PAS=df),)
      __lfreq0 = DEFI_LIST_REEL(DEBUT=df, INTERVALLE=_F(JUSQU_A=fmaxc2, PAS=df),)
    else:
      __lfreqc = DEFI_LIST_REEL(
        DEBUT= df, INTERVALLE=_F(JUSQU_A=fmaxc, PAS= 0.1),)



# Definition de la fonction unite et du filtre en frequence
    __UN = DEFI_FONCTION(NOM_PARA='FREQ', VALE=(0., 1., fmax, 1.,),
                         INTERPOL='LIN', PROL_DROITE = 'CONSTANT', PROL_GAUCHE = 'CONSTANT',)

    __FILTRE = DEFI_FONCTION(NOM_PARA='FREQ',
                             VALE_C=(0., 0., 0., df, 1., 0., fmaxc, 1., 0., (fmaxc2+df), 0., 0.),
                                 INTERPOL='LIN', PROL_DROITE = 'CONSTANT', PROL_GAUCHE = 'CONSTANT',)



# Lecture des acceleros CL
#
    ifsax = []
    a = 1
    __ACCEX = [None]*num_dime
    __SAX = [None]*num_dime
    __ACCEX0 = [None]*num_dime
    __ACCEX0H = [None]*num_dime
    __VITEX = [None]*num_dime
    __SAX = [None]*num_dime
### Option DSP
    if 'DSP' in args  :

      if args['LIST_FREQ_SPEC_OSCI'] is not None:
        __SAX[0] = CALC_FONCTION(
          SPEC_OSCI=_F(FONCTION= __fonc_dsp, NATURE_FONC     ='DSP',DUREE=TSM ,
                       METHODE='RICE', NATURE = 'ACCE',
                       AMOR_REDUIT=0.05,LIST_FREQ=args['LIST_FREQ_SPEC_OSCI'],NORME=9.81))
      else:
        __SAX[0] = CALC_FONCTION(
          SPEC_OSCI=_F(FONCTION= __fonc_dsp, NATURE_FONC     ='DSP', DUREE = TSM,
                       METHODE ='RICE', NATURE = 'ACCE',
                       AMOR_REDUIT=0.05, NORME=9.81))
      ifsax.append(
          _F(FONCTION=__SAX, MARQUEUR=0, LEGENDE='SAXi_' + str(a)),)

      if input == 'CL' :
            __VITEX[0] = DEFI_FONCTION(ABSCISSE = fr[1:], ORDONNEE = 1./np.array(fr[1:]),
                        PROL_DROITE='CONSTANT', NOM_PARA  = 'FREQ',
                        PROL_GAUCHE='CONSTANT',
                         );
      if input == 'RA' :
            __VITEX[0] = CALC_FONCTION(COMB=( _F(FONCTION=__VHX, COEF=1. ),),);


    else:

#sinon

# for a in range (1,nbacc+1):
      for n in range(num_dime):
        __ACCEX[n] = CALC_FONCTION(LIST_PARA=__linst,
                            PROL_DROITE='CONSTANT',
                            PROL_GAUCHE='CONSTANT',
          COMB=_F(FONCTION=__fonc_acce[n], COEF=coefu * coefzpa))


        if args['LIST_FREQ_SPEC_OSCI'] is not None:
          __SAX[n] = CALC_FONCTION(
            SPEC_OSCI=_F(FONCTION=__ACCEX[n],AMOR_REDUIT=0.05,LIST_FREQ=args['LIST_FREQ_SPEC_OSCI'],NORME=9.81))
        else:
          __SAX[n] = CALC_FONCTION(
            SPEC_OSCI=_F(FONCTION=__ACCEX[n], AMOR_REDUIT=0.05, NORME=9.81))
        ifsax.append(
            _F(FONCTION=__SAX[n], MARQUEUR=0, LEGENDE='SAXi_' + str(a)),)

# On calcule la FFT

        __AHX[n] = CALC_FONCTION(FFT=_F(FONCTION=__ACCEX[n], METHODE='COMPLET',))


        __ASPEFCI = DEFI_FONCTION ( NOM_PARA='FREQ',
                              VALE_C=(
                0.0    ,  1.0,  0.0,
                df     ,  1.0,  0.0,
                fmaxc   ,  1.0,  0.0,
                fmaxc+df  ,  0.0,  0.0,
                      ),
               PROL_DROITE      =  'CONSTANT' ,
               PROL_GAUCHE     =  'CONSTANT' ,
        )

        __ACI01F = DEFI_INTE_SPEC ( DIMENSION= 1,
                      PAR_FONCTION =_F( NUME_ORDRE_I = 1,
                                        NUME_ORDRE_J = 1,
                                        FONCTION  =  __ASPEFCI ,),
                       INFO= 1,
                                  )


        __VCIF01X = GENE_FONC_ALEA ( INTE_SPEC =  __ACI01F,
                                 DUREE_TIRAGE   = tfin+dt ,
                                 FREQ_INIT=0.,
                                 FREQ_FIN=fmax,
                                 NB_TIRAGE=1,
                                 INFO= 1
                                  )


        __FCI01FX = RECU_FONCTION(INTE_SPEC=__VCIF01X ,
                         NUME_ORDRE = 1,
                         INTERPOL='LIN',
                         PROL_DROITE='CONSTANT',
                         PROL_GAUCHE='CONSTANT',
                        )

        __ACCEX0[n] = CALC_FONCTION(COMB=(
                           _F(FONCTION=__FCI01FX, COEF=1.0/sqrt(2.0*pi*fmax) ),
                                 ),
                            LIST_PARA=__linst,
                            PROL_DROITE='CONSTANT',
                            PROL_GAUCHE='CONSTANT',
                             );

        __ACCEX0H[n] = CALC_FONCTION(FFT=_F(FONCTION=__ACCEX0[n], METHODE='COMPLET',))

        if input == 'CL' :
            __VITEX[n] = CALC_FONCTION(INTEGRE=_F(FONCTION=__ACCEX0[n], ))
        if input == 'RA' :
            __VITEX[n] = CALC_FONCTION(INTEGRE=_F(FONCTION=__ACCEX[n], ))

#
# DEBUT DE LA BOUCLE       #
#
# for s in range (1,nbsol+1):
#  for v in range (1,len(cvar)+1) :
#    for a in range (1,nbacc+1):
    a = 1
    v = 1
    s = 1

    deltaE = 100
    # initialisation de l erreur sur E
    iter = 0
    # indicateur du nombre d iterations
    etat = 'debut'

    legendeT = 's' + str(s) + 'v' + str(v) + 'a' + str(a)
    legende = '-acce' + str(a) + '-sol' + str(s) + '-cvar=' + str(v)
    if args['TABLE_MATER_ELAS'] is not None:
        nom_para_table_elas = ['Y','M','RHO','Emax','NU','AH','GDgam']
        if Byrne :
            nom_para_table_elas.append('N1')
        __TMAT = CALC_TABLE( TABLE=args['TABLE_MATER_ELAS'],
         ACTION=_F(OPERATION='EXTR',NOM_PARA=nom_para_table_elas));
        tmat = __TMAT.EXTR_TABLE()
        NCOU = len(tmat) - 1
        text = ('NCOU=' + str(NCOU) )
        aster.affiche('MESSAGE', text)
        nbmat = 0
        for k in range(1, NCOU + 2):
            if __TMAT['GDgam', k] > nbmat:
                nbmat = __TMAT['GDgam', k]
        text = ('nbmat=' + str(nbmat) )
        aster.affiche('MESSAGE', text)
        __GG = [None] * (nbmat + 1)
        __DG = [None] * (nbmat + 1)

        UL = UniteAster()
        utabequ = UL.Libre(action='ASSOCIER')
        IMPR_TABLE(TABLE=args['TABLE_GEQUI_GMAX'], UNITE=utabequ)
        IMPR_TABLE(TABLE=args['TABLE_AMOR_EQUI'], UNITE=utabequ)

        for j in range(1, nbmat + 1):
            __GG[j] = LIRE_FONCTION(UNITE=utabequ, NOM_PARA='EPSI',
                                    INTERPOL=('LOG','LIN'), PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',
                                    INDIC_PARA=[1, 1], INDIC_RESU=[1, j + 1],
                                    )
            __DG[j] = LIRE_FONCTION(UNITE=utabequ, NOM_PARA='EPSI',
                                    INTERPOL=('LOG','LIN'), PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',
                                    INDIC_PARA=[2, 1], INDIC_RESU=[2, j + 1],
                                    )
        UL.EtatInit()
    else:
    # 1. dictionnaires des MATERIAUX
        MATERIAU = args['MATERIAU']
        l_mate = []
        for Mi in MATERIAU:
            dM = Mi.cree_dict_valeurs(Mi.mc_liste)
            l_mate.append(dM)
        nbmat = len(l_mate)

    # 2. dictionnaires des COUCHES
        COUCHE = args['COUCHE']
        l_couche = []
        for Ci in COUCHE:
            dC = Ci.cree_dict_valeurs(Ci.mc_liste)
            l_couche.append(dC)
        NCOU = len(l_couche) - 1

        __GG0 = [None] * (nbmat + 1)
        __DG0 = [None] * (nbmat + 1)
        __GG = [None] * (nbmat + 1)
        __DG = [None] * (nbmat + 1)

        j = 0
        for mate in l_mate:
            j += 1
            l_para = mate["GAMMA"]
            vale_G = mate["G_GMAX"]
            vale_D = mate["D"]
            __GG0[j] = DEFI_FONCTION(NOM_PARA='EPSI', NOM_RESU='G_Gmax',
                                    INTERPOL=('LOG','LIN'),
                                    PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT',
                                    ORDONNEE=tuple(vale_G),
                                    ABSCISSE=tuple(l_para))

            __DG0[j] = DEFI_FONCTION(NOM_PARA='EPSI', NOM_RESU='D',
                                    INTERPOL=('LOG','LIN'),
                                    PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT',
                                    ORDONNEE=tuple(vale_D),
                                    ABSCISSE=tuple(l_para))

        __lpara = DEFI_LIST_REEL(VALE=tuple(l_para))

        for j in range(1, nbmat + 1):
            if args['LIST_EPSI'] is not None:
              __GG[j] = CALC_FONCTION(
              COMB=_F(FONCTION=__GG0[j], COEF=1.), LIST_PARA=args['LIST_EPSI'],
              NOM_PARA='EPSI', NOM_RESU='G_Gmax',
              INTERPOL=('LOG','LIN'),
              PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',
              )
              __DG[j] = CALC_FONCTION(
              COMB=_F(FONCTION=__DG0[j], COEF=1.), LIST_PARA=args['LIST_EPSI'],
              NOM_PARA='EPSI', NOM_RESU='D',
              INTERPOL=('LOG','LIN'),
              PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',
              )
            else:
              __GG[j] = CALC_FONCTION(
              COMB=_F(FONCTION=__GG0[j], COEF=1.), LIST_PARA=__lpara,
              NOM_PARA='EPSI', NOM_RESU='G_Gmax',
              INTERPOL=('LOG','LIN'),
              PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',
              )
              __DG[j] = CALC_FONCTION(
              COMB=_F(FONCTION=__DG0[j], COEF=1.), LIST_PARA=__lpara,
              NOM_PARA='EPSI', NOM_RESU='D',
              INTERPOL=('LOG','LIN'),
              PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',
              )

            if j == 1:
                __tabfgg = CREA_TABLE(
                    FONCTION=_F(FONCTION=__GG[j], PARA=('EPSI', 'GG' + str(j))))
                __tabfdg = CREA_TABLE(
                    FONCTION=_F(FONCTION=__DG[j], PARA=('EPSI', 'DG' + str(j))))

            else:
                __tabtmpgg = CREA_TABLE(
                    FONCTION=_F(FONCTION=__GG[j], PARA=('EPSI', 'GG' + str(j))))
                __tabtmpdg = CREA_TABLE(
                    FONCTION=_F(FONCTION=__DG[j], PARA=('EPSI', 'DG' + str(j))))
                __tabfgg = CALC_TABLE(reuse=__tabfgg, TABLE=__tabfgg,
                                      ACTION=_F(OPERATION='COMB', TABLE=__tabtmpgg, NOM_PARA='EPSI'))

                __tabfdg = CALC_TABLE(reuse=__tabfdg, TABLE=__tabfdg,
                                      ACTION=_F(OPERATION='COMB', TABLE=__tabtmpdg, NOM_PARA='EPSI'))

                DETRUIRE(CONCEPT=_F(NOM=(__tabtmpgg, __tabtmpdg,),))

        IMPR_TABLE(TABLE=__tabfgg, UNITE=6,
                   TITRE=('Table des fonctions G_GMAX de Gamma par materiau'),)
        IMPR_TABLE(TABLE=__tabfdg, UNITE=6,
                   TITRE=('Table des fonctions AMOR de Gamma par materiau'),)

    # definition de la table initiale
    # para/typ pre-trie les colonnes
        tabini = Table(para=["Y", "M", "RHO", "Emax", "NU", "AH", "GDgam"],
                       typ=["R", "K8", "R", "R", "R", "R", "I"])
        if Byrne:
            tabini = Table(para=["Y", "M", "RHO", "Emax", "NU", "AH", "GDgam", "N1"],
               typ=["R", "K8", "R", "R", "R", "R", "I", "R"])

        Y = 0.
        for couche in l_couche:
            Y = Y + couche["EPAIS"]
            id_mate = couche["NUME_MATE"]
            if not Byrne:
                tabini.append(
                {'RHO': couche["RHO"], 'NU': couche["NU"], 'Emax': couche["E"],
                 'M': couche["GROUP_MA"], 'Y': Y, 'GDgam': id_mate,
                 'AH': couche["AMOR_HYST"]})
            if Byrne:
                tabini.append(
                {'RHO': couche["RHO"], 'NU': couche["NU"], 'Emax': couche["E"],
                 'M': couche["GROUP_MA"], 'Y': Y, 'GDgam': id_mate,
                 'AH': couche["AMOR_HYST"],
                 'N1': couche["N1"]})

     # creation de la table
        dprod = tabini.dict_CREA_TABLE()
        __TMAT = CREA_TABLE(**dprod)

    IMPR_TABLE(TABLE=__TMAT, UNITE=6)

    if SURF == 'NON' :
        NCOU2 = args['NIVE_COUCH_ENFO']
        if NCOU2 > NCOU:
            NCOU2 = NCOU
        # nombre de sous-couches par couche enfoncee
        nsco = args['NB_RECEPTEUR']

    CMP2 = 'DY'
    if dime == "2D":
        if args['NOM_CMP'] == 'DY':
            nmaxit = 1
            CMP2 = 'DX'

# Lecture du maillage
    if args['MAILLAGE'] is not None:
      if dime == "2D":
          __mailla = CREA_MAILLAGE(MAILLAGE=mail0,
                                 CREA_POI1=(
                                 _F(NOM_GROUP_MA='PCOL',
                                    GROUP_MA=grma_colon,),
                                 _F(NOM_GROUP_MA='PLATE',
                                    GROUP_MA=(grma_droit,grma_gauch,),),
                                 ),
                                 )

          __mailla = DEFI_GROUP(reuse=__mailla,
                              MAILLAGE=__mailla,
                              CREA_GROUP_NO=_F(GROUP_MA=(grma_droit,),),
                              )

          __mailla = DEFI_GROUP(reuse=__mailla,
                              MAILLAGE=__mailla,
                              CREA_GROUP_NO=_F(GROUP_MA=(grma_gauch,),),
                              )

          __mailla = DEFI_GROUP(reuse=__mailla,
                              MAILLAGE=__mailla,
                              CREA_GROUP_NO=_F(GROUP_MA=('PLATE',),),
                              )
      elif dime == "3D":
          __mailla = CREA_MAILLAGE(MAILLAGE=mail0,
                             CREA_POI1=(
                             _F(NOM_GROUP_MA='PCOL',
                                GROUP_MA=grma_colon,),),
                         )
    else:
      #maillage automatique uniquement en 2D
      text = ('NCOU=' + str(NCOU))
      aster.affiche('MESSAGE', text)
      NCOUB=NCOU+1
      larcol=1.0
      resultfile = open("dse.mail", 'w')
      resultfile.write( " TITRE \n")
      resultfile.write( " %  GIBI FECIT \n")
      resultfile.write( " FINSF \n")
      resultfile.write( " % \n")
      resultfile.write( " COOR_3D \n")
      resultfile.write( " N1        0.0000000000000D+00  0.000000000000D+00  0.0000000000000D+00 \n")
      for k in range(1,NCOUB+1):
        resultfile.write( " N"+str(k+1)+"        0.0000000000000D+00  "+str(-1*__TMAT['Y',k])+"   0.0000000000000D+00 \n")
      resultfile.write( " N"+str(NCOUB+2)+"        "+str(larcol)+"000000000000D+00  0.0000000000000D+00  0.0000000000000D+00 \n")
      for k in range(1,NCOUB+1):
        resultfile.write( " N"+str(NCOUB+2+k)+"        "+str(larcol)+"000000000000D+00  "+str(-1*__TMAT['Y',k])+" 0.0000000000000D+00 \n")
      resultfile.write( " FINSF \n")
      resultfile.write( " % \n")
      resultfile.write( " QUAD4  \n")
      for k in range(1,NCOUB+1):
        resultfile.write( "  M"+str(k)+"       N"+str(k)+"       N"+str(k+1)+"       N"+str(NCOUB+2+k)+"      N"+str(NCOUB+1+k)+" \n")
      resultfile.write( " FINSF \n")
      resultfile.write( " % \n")
      resultfile.write( " SEG2   \n")
      resultfile.write( " M"+str(NCOUB+1)+"      N"+str(NCOUB+1)+"      N"+str(2*NCOUB+2)+"      \n")
      resultfile.write( " FINSF \n")
      resultfile.write( " % \n")
      j = NCOUB+1
      resultfile.write( " SEG2   \n")
      for k in range(1,NCOUB+1):
        j = j+1
        resultfile.write( "  M"+str(j)+"       N"+str(k)+"       N"+str(k+1)+" \n")
      for k in range(1,NCOUB+1):
        j = j+1
        resultfile.write( "  M"+str(j)+"       N"+str(NCOUB+1+k)+"      N"+str(NCOUB+2+k)+" \n")
      resultfile.write( " FINSF \n")
      resultfile.write( " % \n")
      for k in range(1,NCOUB+2):
        resultfile.write( " GROUP_NO \n")
        resultfile.write( " P"+str(k-1)+"       N"+str(k)+"       \n")
        resultfile.write( " FINSF \n")
        resultfile.write( " % \n")
      resultfile.write( " GROUP_MA \n")
      resultfile.write( str(grma_colon)  + " \n")
      for k in range(1,NCOUB+1):
        resultfile.write( " M"+str(k)+" \n")
      resultfile.write( " FINSF \n")
      resultfile.write( " % \n")
      for k in range(1,NCOUB+1):
        resultfile.write( " GROUP_MA \n")
        resultfile.write( str(__TMAT['M',k])+"       \n")
        resultfile.write( " M"+str(k)+"       \n")
        resultfile.write( " FINSF \n")
        resultfile.write( " % \n")
      resultfile.write( " GROUP_MA \n")
      resultfile.write( str(grma_subst)  + " \n")
      resultfile.write( " M"+str(NCOUB+1)+"      \n")
      resultfile.write( " FINSF \n")
      resultfile.write( " % \n")
      resultfile.write( " GROUP_MA \n")
      resultfile.write( str(grma_late)  + " \n")
      for k in range(1,NCOUB+1):
        resultfile.write( " M"+str(NCOUB+1+k)+" \n")
      for k in range(1,NCOUB+1):
        resultfile.write( " M"+str(2*NCOUB+1+k)+" \n")
      resultfile.write( " FINSF \n")
      resultfile.write( " % \n")
      resultfile.write( " GROUP_MA \n")
      resultfile.write( str(grma_gauch)  + " \n")
      for k in range(1,NCOUB+1):
        resultfile.write( " M"+str(NCOUB+1+k)+" \n")
      resultfile.write( " FINSF \n")
      resultfile.write( " % \n")
      resultfile.write( " GROUP_MA \n")
      resultfile.write( str(grma_droit)  + " \n")
      for k in range(1,NCOUB+1):
        resultfile.write( " M"+str(2*NCOUB+1+k)+" \n")
      resultfile.write( " FINSF \n")
      resultfile.write( " % \n")
      for k in range(1,NCOUB+1):
        resultfile.write( " GROUP_MA \n")
        resultfile.write( " G"+str(__TMAT['M',k])+"      \n")
        resultfile.write( " M"+str(NCOUB+1+k)+"       \n")
        resultfile.write( " FINSF \n")
        resultfile.write( " % \n")
        resultfile.write( " GROUP_MA \n")
        resultfile.write( " D"+str(__TMAT['M',k])+"     \n")
        resultfile.write( " M"+str(2*NCOUB+1+k)+"       \n")
        resultfile.write( " FINSF \n")
        resultfile.write( " % \n")
        resultfile.write( " GROUP_MA \n")
        resultfile.write( " L"+str(__TMAT['M',k])+"     \n")
        resultfile.write( " M"+str(NCOUB+1+k)+"       \n")
        resultfile.write( " M"+str(2*NCOUB+1+k)+"       \n")
        resultfile.write( " FINSF \n")
        resultfile.write( " % \n")
      resultfile.write( " GROUP_NO \n")
      resultfile.write( str(grma_gauch)  + " \n")
      for k in range(1,NCOUB+2):
        resultfile.write( " N"+str(k)+" \n")
      resultfile.write( " FINSF \n")
      resultfile.write( " % \n")
      resultfile.write( " GROUP_NO \n")
      resultfile.write( str(grma_droit)  + " \n")
      for k in range(1,NCOUB+2):
        resultfile.write( " N"+str(NCOUB+1+k)+" \n")
      resultfile.write( " FINSF \n")
      resultfile.write( " % \n")
      resultfile.write( " FIN \n")

      resultfile.close()

      UL = UniteAster()
      umail = UL.Libre(action='ASSOCIER', nom='dse.mail')
      __mail0=LIRE_MAILLAGE(UNITE=umail, FORMAT='ASTER');
      __mailla = CREA_MAILLAGE(MAILLAGE=__mail0,
                             CREA_POI1=(
                             _F(NOM_GROUP_MA='PCOL',
                                GROUP_MA=grma_colon,),
                             _F(NOM_GROUP_MA='PLATE',
                                GROUP_MA=(grma_late,),),
                             ),
                              )
      __mailla = DEFI_GROUP(reuse=__mailla,
                          MAILLAGE=__mailla,
                          CREA_GROUP_NO=_F(GROUP_MA=('PLATE',),),
                           )
      UL.EtatInit()

    # cas uniquement en 2D pour l'instant
    if ltranin == 'OUI' :
      NPC = NCOU+3
      l_para = []
      l_foncx = []
      l_vitex = []
      l_deplx = []

      for k in range(1, NPC):
         if k < NPC-1 :
           if lmassp == 'OUI':
             __faccex0=LIRE_FONCTION(UNITE=utranin,NOM_PARA='INST',
               INTERPOL = 'LIN',PROL_DROITE = 'CONSTANT',
               INDIC_PARA=[1,1],INDIC_RESU=[1,NPC+2-k],
                   );
           else:
             __fvitex=LIRE_FONCTION(UNITE=utranin,NOM_PARA='INST',
               INTERPOL = 'LIN',PROL_DROITE = 'CONSTANT',
               INDIC_PARA=[2,1],INDIC_RESU=[2,NPC+2-k],
                   );
             __fdeplx=LIRE_FONCTION(UNITE=utranin,NOM_PARA='INST',
               INTERPOL = 'LIN',PROL_DROITE = 'CONSTANT',
               INDIC_PARA=[3,1],INDIC_RESU=[3,NPC+2-k],
                   );
           l_para.append(-1.0*__TMAT['Y',NPC-1-k])
         else:
           if lmassp == 'OUI':
             __faccex0=LIRE_FONCTION(UNITE=utranin,NOM_PARA='INST',
               INTERPOL = 'LIN',PROL_DROITE = 'CONSTANT',
               INDIC_PARA=[1,1],INDIC_RESU=[1,2],
                   );
           else:
             __fvitex=LIRE_FONCTION(UNITE=utranin,NOM_PARA='INST',
               INTERPOL = 'LIN',PROL_DROITE = 'CONSTANT',
               INDIC_PARA=[2,1],INDIC_RESU=[2,2],
                   );
             __fdeplx=LIRE_FONCTION(UNITE=utranin,NOM_PARA='INST',
               INTERPOL = 'LIN',PROL_DROITE = 'CONSTANT',
               INDIC_PARA=[3,1],INDIC_RESU=[3,2],
                   );
           l_para.append(0.0)
         if lmassp == 'OUI':
           __faccX=CALC_FONCTION(COMB=_F(FONCTION=__faccex0,COEF=1.0*args['MASS_PENA'],),);
           DETRUIRE(CONCEPT=_F(NOM=(__faccex0,),), INFO = 1);
           l_foncx.append(__faccX)
         else:
           l_vitex.append(__fvitex)
           l_deplx.append(__fdeplx)
      if lmassp == 'OUI':
        __NSEISMX = DEFI_NAPPE(NOM_PARA='Y', INTERPOL=('LIN','LIN',),
                               PROL_GAUCHE='CONSTANT', PROL_DROITE='CONSTANT',
                               PARA= tuple(l_para), FONCTION=tuple(l_foncx),);
      else:
        __FONCVX = DEFI_NAPPE(NOM_PARA='X', INTERPOL=('LIN','LIN',),
                               PROL_GAUCHE='CONSTANT', PROL_DROITE='CONSTANT',
                               PARA= tuple(l_para), FONCTION=tuple(l_vitex),);
        __FONCDX = DEFI_NAPPE(NOM_PARA='X', INTERPOL=('LIN','LIN',),
                               PROL_GAUCHE='CONSTANT', PROL_DROITE='CONSTANT',
                               PARA= tuple(l_para), FONCTION=tuple(l_deplx),);

    #IMPR_RESU(RESU=_F(MAILLAGE=__mailla,));
    if lliaison == 'OUI':
        if dime == "2D":
          __mailla=MODI_MAILLAGE(reuse =__mailla,
                    MAILLAGE=__mailla,
                    ORIE_PEAU_2D=_F(GROUP_MA=grma_subst,GROUP_MA_SURF=grma_colon,),
                    );
          __MODELE = AFFE_MODELE(MAILLAGE=__mailla,
                               AFFE=(
                               _F(GROUP_MA=grma_colon, PHENOMENE='MECANIQUE',
                                  MODELISATION='D_PLAN',),
                               _F(GROUP_MA=grma_subst, PHENOMENE='MECANIQUE',
                                  MODELISATION='D_PLAN_ABSO',),
                               ),)

    # Conditions de periodicite: relation d'egalite entre les deplacements
    # des noeuds des bords droit et gauche du modele
          __CON_LIM = AFFE_CHAR_MECA(MODELE=__MODELE,
                                   LIAISON_GROUP=
                                  (_F(GROUP_NO_1=grma_gauch,
                                      GROUP_NO_2=grma_droit,
                                      DDL_1=('DX',),
                                      DDL_2=('DX',),
                                      COEF_MULT_1=1.,
                                      COEF_MULT_2=-1.,
                                      COEF_IMPO=0.,),
                                  _F(GROUP_NO_1=grma_gauch,
                                     GROUP_NO_2=grma_droit,
                                     DDL_1=('DY',),
                                     DDL_2=('DY',),
                                     COEF_MULT_1 = 1.,
                                     COEF_MULT_2 = -1.,
                                     COEF_IMPO = 0.,),
                                   ),
                                 )
        else:
          __mailla=MODI_MAILLAGE(reuse =__mailla,
                    MAILLAGE=__mailla,
                    ORIE_PEAU_3D=_F(GROUP_MA=grma_subst,GROUP_MA_VOLU=grma_colon,),
                    );

          __MODELE = AFFE_MODELE(MAILLAGE=__mailla,
                               AFFE=(
                               _F(GROUP_MA=grma_colon, PHENOMENE='MECANIQUE',
                                  MODELISATION='3D',),
                               _F(GROUP_MA=grma_subst, PHENOMENE='MECANIQUE',
                                  MODELISATION='3D_ABSO',),
                               _F(GROUP_MA=grma_tot,
                                  PHENOMENE='MECANIQUE',
                                  MODELISATION='DIS_T',),
                               ),)

          __CARELE = AFFE_CARA_ELEM( MODELE=__MODELE,
                          DISCRET=(_F(GROUP_MA = grma_tot,
                                      CARA     = 'K_T_D_L',
                                      REPERE = 'GLOBAL',
                                      VALE     = (5.E13,5.E13,5.E13,),
                                     ),),)

    else:
    # uniquement en 2D
        __mailla=MODI_MAILLAGE(reuse =__mailla,
                MAILLAGE=__mailla,
                ORIE_PEAU_2D=_F(GROUP_MA=(grma_subst,grma_gauch,grma_droit),GROUP_MA_SURF=grma_colon,),
                );
        if lmassp == 'OUI':
            __MODELE = AFFE_MODELE(MAILLAGE=__mailla,
                               AFFE=(
                               _F(GROUP_MA=grma_colon, PHENOMENE='MECANIQUE',
                                  MODELISATION='D_PLAN',),
                               _F(GROUP_MA='PLATE', PHENOMENE='MECANIQUE',
                                  MODELISATION='2D_DIS_T',),
                               _F(GROUP_MA=(grma_subst,grma_gauch,grma_droit), PHENOMENE='MECANIQUE',
                                  MODELISATION='D_PLAN_ABSO',),
                               ),)
            __ELEM=AFFE_CARA_ELEM(MODELE=__MODELE,
                    DISCRET=(
                             _F(GROUP_MA='PLATE',
                                    REPERE='GLOBAL',
                                    CARA='M_T_D_N',
                                    VALE=args['MASS_PENA']),
                            ),
                    );
        else:
            __MODELE = AFFE_MODELE(MAILLAGE=__mailla,
                               AFFE=(
                               _F(GROUP_MA=grma_colon, PHENOMENE='MECANIQUE',
                                  MODELISATION='D_PLAN',),
                               _F(GROUP_MA=(grma_subst,grma_gauch,grma_droit), PHENOMENE='MECANIQUE',
                                  MODELISATION='D_PLAN_ABSO',),
                               ),)

    # On genere la liste initiale pour Emax AH ratio G/Gmax et des profondeurs
    E = [[]] * (nmaxit+1)
    AH = [[]] * (nmaxit+1)
    rat = [[]] * (nmaxit+1)

    E[0] = [] * (NCOU + 2)
    AH[0] = [] * (NCOU + 2)
    rat[0] = [] * (NCOU + 2)
    lprof = []
    lprof2 = []

    lprof.append(0.)
    lprof2.append(0.)
    E[0].append(0)
    AH[0].append(0)
    rat[0].append(1)
    __fEmax = FORMULE(NOM_PARA=('Emax'), VALE = 'cvar*Emax', cvar=cvar)
    __fAH = FORMULE(NOM_PARA=('AH'), VALE = 'AH')

    __TMAT = CALC_TABLE(reuse=__TMAT, TABLE=__TMAT,
                        ACTION=(
                                _F(OPERATION = 'OPER',
                                   FORMULE=__fEmax, NOM_PARA = 'E0',),
                                _F(OPERATION = 'OPER',
                                   FORMULE=__fAH, NOM_PARA = 'AH0',),
                                ))

    #for k in range(1, NCOU + 1):
    for k in range(1, NCOU + 2):
        if k < NCOU+1 :
          lprof.append(__TMAT['Y', k])
          rat[0].append(1)
        lprof2.append(__TMAT['Y', k])
        E[0].append(__TMAT['E0', k])
        AH[0].append(__TMAT['AH0', k])

    while etat != 'fin':
        text = ('iter=' + str(iter))
        aster.affiche('MESSAGE', text)

        if iter == 0:

            __SOLH = [None] * (NCOU + 2)

            for j in range(1, NCOU + 1):
              if formulation == 'LYSMER':
                if llcara == 'OUI':
                  __SOLH[j] = DEFI_MATERIAU(
                                ELAS=_F(E=__TMAT['E0', j]*(1.-__TMAT['AH0',j]*__TMAT['AH0',j]/2),
                                RHO=__TMAT['RHO', j],
                                NU=__TMAT['NU', j],
                                LONG_CARA=args['LONG_CARA'],
                                AMOR_HYST=__TMAT['AH0', j]*sqrt(1-__TMAT['AH0',j]*__TMAT['AH0',j]/4)/(1.-__TMAT['AH0',j]*__TMAT['AH0',j]/2),
                                ))
                else:
                  __SOLH[j] = DEFI_MATERIAU(
                                ELAS=_F(E=__TMAT['E0', j]*(1.-__TMAT['AH0',j]*__TMAT['AH0',j]/2),
                                RHO=__TMAT['RHO', j],
                                NU=__TMAT['NU', j],
                                AMOR_HYST=__TMAT['AH0', j]*sqrt(1-__TMAT['AH0',j]*__TMAT['AH0',j]/4)/(1.-__TMAT['AH0',j]*__TMAT['AH0',j]/2),
                                ))
              else:
                if llcara == 'OUI':
                  __SOLH[j] = DEFI_MATERIAU(ELAS=_F(E=__TMAT['E0', j],
                                                  RHO=__TMAT['RHO', j],
                                                  NU=__TMAT['NU', j],
                                                  LONG_CARA=args['LONG_CARA'],
                                                  AMOR_HYST=__TMAT['AH0', j],
                                                  ))
                else:
                  __SOLH[j] = DEFI_MATERIAU(ELAS=_F(E=__TMAT['E0', j],
                                                  RHO=__TMAT['RHO', j],
                                                  NU=__TMAT['NU', j],
                                                  AMOR_HYST=__TMAT['AH0', j],
                                                  ))

            if llcara == 'OUI':
              __SOLH[NCOU + 1] = DEFI_MATERIAU(ELAS=_F(E=__TMAT['E0', NCOU + 1],
                                                     RHO=__TMAT[
                                                         'RHO', NCOU + 1],
                                                     NU=__TMAT['NU', NCOU + 1],
                                                     LONG_CARA=args['LONG_CARA'],
                                                     AMOR_HYST=__TMAT[
                                                         'AH0', NCOU + 1],
                                                     ))
            else:
              __SOLH[NCOU + 1] = DEFI_MATERIAU(ELAS=_F(E=__TMAT['E0', NCOU + 1],
                                                     RHO=__TMAT[
                                                         'RHO', NCOU + 1],
                                                     NU=__TMAT['NU', NCOU + 1],
                                                     AMOR_HYST=__TMAT[
                                                         'AH0', NCOU + 1],
                                                     ))

        else:

            __SOLH = [None] * (NCOU + 2)

            for j in range(1, NCOU + 1):
              if formulation == 'LYSMER':
                if llcara == 'OUI':
                  __SOLH[j] = DEFI_MATERIAU(
                                ELAS=_F(E=__TMAT[('E' + str(iter)), j]*(1.-__TMAT[('AH'+str(iter)),j]*__TMAT[('AH'+str(iter)),j]/2),
                                RHO=__TMAT['RHO', j],
                                NU=__TMAT['NU', j],
                                LONG_CARA=args['LONG_CARA'],
                                AMOR_HYST=__TMAT[('AH' + str(iter)), j]*sqrt(1-__TMAT[('AH'+str(iter)),j]*__TMAT[('AH'+str(iter)),j]/4)/(1.-__TMAT[('AH'+str(iter)),j]*__TMAT[('AH'+str(iter)),j]/2),
                                ))
                else:
                  __SOLH[j] = DEFI_MATERIAU(
                                ELAS=_F(E=__TMAT[('E' + str(iter)), j]*(1.-__TMAT[('AH'+str(iter)),j]*__TMAT[('AH'+str(iter)),j]/2),
                                RHO=__TMAT['RHO', j],
                                NU=__TMAT['NU', j],
                                AMOR_HYST=__TMAT[('AH' + str(iter)), j]*sqrt(1-__TMAT[('AH'+str(iter)),j]*__TMAT[('AH'+str(iter)),j]/4)/(1.-__TMAT[('AH'+str(iter)),j]*__TMAT[('AH'+str(iter)),j]/2),
                                ))
              else:
                if llcara == 'OUI':
                  __SOLH[j] = DEFI_MATERIAU(
                    ELAS=_F(E=__TMAT[('E' + str(iter)), j],
                            RHO=__TMAT['RHO', j],
                            NU=__TMAT['NU', j],
                            LONG_CARA=args['LONG_CARA'],
                            AMOR_HYST=__TMAT[('AH' + str(iter)), j],
                            ))
                else:
                  __SOLH[j] = DEFI_MATERIAU(
                    ELAS=_F(E=__TMAT[('E' + str(iter)), j],
                            RHO=__TMAT['RHO', j],
                            NU=__TMAT['NU', j],
                            AMOR_HYST=__TMAT[
                            ('AH' + str(iter)), j],
                            ))
            if llcara == 'OUI':
              __SOLH[NCOU + 1] = DEFI_MATERIAU(ELAS=_F(E=__TMAT['E0', NCOU + 1],
                                                     RHO=__TMAT[
                                                         'RHO', NCOU + 1],
                                                     NU=__TMAT['NU', NCOU + 1],
                                                     LONG_CARA=args['LONG_CARA'],
                                                     AMOR_HYST=__TMAT['AH0', NCOU + 1],
                                                     ))
            else:
              __SOLH[NCOU + 1] = DEFI_MATERIAU(ELAS=_F(E=__TMAT['E0', NCOU + 1],
                                                     RHO=__TMAT[
                                                         'RHO', NCOU + 1],
                                                     NU=__TMAT['NU', NCOU + 1],
                                                     AMOR_HYST=__TMAT['AH0', NCOU + 1],
                                                     ))

            # Le substratum est considere comme elastique et garde les proprietes initiales
            # La valeur d'amortissement specifiee n'est pas prise en compte  :
            # l'amortissement des FA (rho.Vs) est calcule avec l'option
            # AMOR_MECA

        __SOLHSUBS = DEFI_MATERIAU(ELAS=_F(E=__TMAT['E0', NCOU + 1],
                                           RHO=__TMAT['RHO', NCOU + 1],
                                           NU=__TMAT['NU', NCOU + 1],
                                           AMOR_HYST=__TMAT['AH0', NCOU + 1],
                                           ))

            # Boucle pour affectation du materiau j au GROUP_MA 'Mj'

        tSOLH = tuple(__SOLH)

        affmat = []

        for j in range(1, NCOU + 2):

            affmat.append(_F(GROUP_MA=__TMAT['M', j], MATER=tSOLH[j]))
            if args['MAILLAGE'] is None:
              affmat.append(_F(GROUP_MA='L'+__TMAT['M', j], MATER=tSOLH[j]))
              #affmat.append(_F(GROUP_MA='G'+__TMAT['M', j], MATER=tSOLH[j]))
              #affmat.append(_F(GROUP_MA='D'+__TMAT['M', j], MATER=tSOLH[j]))

        affmat.append(_F(GROUP_MA=grma_subst, MATER=__SOLHSUBS))

        __CHAMPMAH = AFFE_MATERIAU(MAILLAGE=__mailla,
                                   AFFE=affmat,
                                   )
        if lliaison == 'OUI':
            # MATRICE DE RIGIDITE ELEMENTAIRE
          if dime == "2D":

              __RIGI_ELH = CALC_MATR_ELEM(OPTION='RIGI_MECA',
                                        MODELE=__MODELE, CHAM_MATER=__CHAMPMAH, CHARGE=__CON_LIM,)
                # Amor meca hyst pour colonne

              __RIGH_ELH = CALC_MATR_ELEM(OPTION='RIGI_MECA_HYST',
                                        MODELE=__MODELE, CHAM_MATER=__CHAMPMAH, RIGI_MECA=__RIGI_ELH, CHARGE=__CON_LIM,)
                # MATRICE DE MASSE ELEMENTAIRE

              __MASS_ELH = CALC_MATR_ELEM(OPTION='MASS_MECA',
                                        MODELE=__MODELE,
                                        CHAM_MATER=__CHAMPMAH,
                                        CHARGE=__CON_LIM,)
                # MATRICE D AMORTISSEMENT ELEMENTAIRE (pour prise en compte
                # amortissement frontiere absorbante)

              __AMOR_ELH = CALC_MATR_ELEM(OPTION='AMOR_MECA',
                                        MODELE=__MODELE,
                                        CHAM_MATER=__CHAMPMAH,
                                        RIGI_MECA=__RIGI_ELH,
                                        MASS_MECA=__MASS_ELH,
                                        CHARGE=__CON_LIM,)
          if dime == "3D":
              __RIGI_ELH = CALC_MATR_ELEM(OPTION='RIGI_MECA',
                                        MODELE=__MODELE, CHAM_MATER=__CHAMPMAH, CARA_ELEM=__CARELE)
                # Amor meca hyst pour colonne

              __RIGH_ELH = CALC_MATR_ELEM(OPTION='RIGI_MECA_HYST',
                                        MODELE=__MODELE, CHAM_MATER=__CHAMPMAH, RIGI_MECA=__RIGI_ELH, CARA_ELEM=__CARELE)
                # MATRICE DE MASSE ELEMENTAIRE

              __MASS_ELH = CALC_MATR_ELEM(OPTION='MASS_MECA',
                                        MODELE=__MODELE,
                                        CHAM_MATER=__CHAMPMAH,
                                        CARA_ELEM=__CARELE)
                # MATRICE D AMORTISSEMENT ELEMENTAIRE (pour prise en compte
                # amortissement frontiere absorbante)

              __AMOR_ELH = CALC_MATR_ELEM(OPTION='AMOR_MECA',
                                        MODELE=__MODELE,
                                        CHAM_MATER=__CHAMPMAH,
                                        RIGI_MECA=__RIGI_ELH,
                                        MASS_MECA=__MASS_ELH,
                                        CARA_ELEM=__CARELE)

        else:
          if lmassp == 'OUI':
            # MATRICE DE RIGIDITE ELEMENTAIRE

            __RIGI_ELH = CALC_MATR_ELEM(OPTION='RIGI_MECA',
                             MODELE=__MODELE, CARA_ELEM=__ELEM, CHAM_MATER=__CHAMPMAH,)
            # Amor meca hyst pour colonne

            __RIGH_ELH = CALC_MATR_ELEM(OPTION='RIGI_MECA_HYST',
                             MODELE=__MODELE, CARA_ELEM=__ELEM, CHAM_MATER=__CHAMPMAH, RIGI_MECA=__RIGI_ELH,)
            # MATRICE DE MASSE ELEMENTAIRE

            __MASS_ELH = CALC_MATR_ELEM(OPTION='MASS_MECA',
                             MODELE=__MODELE, CARA_ELEM=__ELEM, CHAM_MATER=__CHAMPMAH,)

            # MATRICE D AMORTISSEMENT ELEMENTAIRE (pour prise en compte
            # amortissement frontiere absorbante)

            __AMOR_ELH = CALC_MATR_ELEM(OPTION='AMOR_MECA',
                                    MODELE=__MODELE, CARA_ELEM=__ELEM, CHAM_MATER=__CHAMPMAH,
                                    RIGI_MECA=__RIGI_ELH,
                                    MASS_MECA=__MASS_ELH,)
          else:
            # MATRICE DE RIGIDITE ELEMENTAIRE

            __RIGI_ELH = CALC_MATR_ELEM(OPTION='RIGI_MECA',
                             MODELE=__MODELE, CHAM_MATER=__CHAMPMAH,)
            # Amor meca hyst pour colonne

            __RIGH_ELH = CALC_MATR_ELEM(OPTION='RIGI_MECA_HYST',
                             MODELE=__MODELE, CHAM_MATER=__CHAMPMAH, RIGI_MECA=__RIGI_ELH,)
            # MATRICE DE MASSE ELEMENTAIRE

            __MASS_ELH = CALC_MATR_ELEM(OPTION='MASS_MECA',
                                    MODELE=__MODELE, CHAM_MATER=__CHAMPMAH,)

            # MATRICE D AMORTISSEMENT ELEMENTAIRE (pour prise en compte
            # amortissement frontiere absorbante)

            __AMOR_ELH = CALC_MATR_ELEM(OPTION='AMOR_MECA',
                                    MODELE=__MODELE, CHAM_MATER=__CHAMPMAH,
                                    RIGI_MECA=__RIGI_ELH,
                                    MASS_MECA=__MASS_ELH,)

            # NUMEROTATION DES DDL

        __NUMEDDL = NUME_DDL(MATR_RIGI=__RIGI_ELH,)
            #
            # MATRICE DE RIGIDITE GLOBALE

        __RIGIHYST = ASSE_MATRICE(MATR_ELEM=__RIGH_ELH, NUME_DDL=__NUMEDDL,)
        __RIGIDITE = ASSE_MATRICE(MATR_ELEM=__RIGI_ELH, NUME_DDL=__NUMEDDL,)

            #
            # MATRICE DE MASSE GLOBALE

        __MASSEH = ASSE_MATRICE(MATR_ELEM=__MASS_ELH, NUME_DDL=__NUMEDDL,)

            #
            # MATRICE D AMORTISSEMENT GLOBALE

        __AMORTIH = ASSE_MATRICE(MATR_ELEM=__AMOR_ELH, NUME_DDL=__NUMEDDL,)

            # Chargement sismique monoappui sur la base du modele
        __ONDEX = [None]*num_dime
        if dime == "2D":
            if args['NOM_CMP'] == 'DX':
              __VECASX = CALC_CHAR_SEISME(
                MATR_MASS=__MASSEH, DIRECTION=(1., 0., 0.,), MONO_APPUI='OUI')
              if lliaison == 'OUI':
                __ONDEX[0]=AFFE_CHAR_MECA_F(  MODELE=__MODELE,
                    ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,),
                    TYPE_ONDE = 'S',
                    DIST=-1.0*__TMAT['Y', NCOU + 1],
                    FONC_SIGNAL = __VITEX[0], GROUP_MA=grma_subst)
                         );
              else:
                if ltranin == 'OUI' :
                  if lmassp == 'OUI' :
                    __ONDEX[0]=AFFE_CHAR_MECA_F(  MODELE=__MODELE,
                      ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,),
                      TYPE_ONDE = 'S',
                      DIST=-1.0*__TMAT['Y', NCOU + 1], #DIST_REFLECHI=0.,
                      FONC_SIGNAL = __VITEX[0], GROUP_MA=(grma_subst,))
                          );
                    __FSEISMX=AFFE_CHAR_MECA_F(MODELE=__MODELE,
                      FORCE_NODALE=(_F(GROUP_NO='PLATE',FX=__NSEISMX,),),
                          );
                  else:
                    __FSEISMX=AFFE_CHAR_MECA_F(  MODELE=__MODELE,
                      ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,),
                      TYPE_ONDE = 'S',
                      DEPL_IMPO=__FONCDX,
                      FONC_SIGNAL = __FONCVX, GROUP_MA=(grma_gauch,grma_droit))
                          );
                    __ONDEX[0]=AFFE_CHAR_MECA_F(  MODELE=__MODELE,
                    ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,),
                    TYPE_ONDE = 'S',
                    DIST=-1.0*__TMAT['Y', NCOU + 1],
                    FONC_SIGNAL = __VITEX[0], GROUP_MA=grma_subst)
                         );
                else:
                  __ONDEX[0]=AFFE_CHAR_MECA_F(  MODELE=__MODELE,
                    ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,),
                    TYPE_ONDE = 'S',
                    DIST=-1.0*__TMAT['Y', NCOU + 1], DIST_REFLECHI=0.,
                    FONC_SIGNAL = __VITEX[0], GROUP_MA=(grma_subst,grma_gauch,grma_droit))
                         );
            else:
              __VECASX = CALC_CHAR_SEISME(
                MATR_MASS=__MASSEH, DIRECTION=(0., 1., 0.,), MONO_APPUI='OUI')
              if lliaison == 'OUI':
                __ONDEX[0]=AFFE_CHAR_MECA_F(  MODELE=__MODELE,
                    ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,),
                    TYPE_ONDE = 'P',
                    DIST=-1.0*__TMAT['Y', NCOU + 1],
                    FONC_SIGNAL = __VITEX[0], GROUP_MA=grma_subst)
                         );
              else:
                if ltranin == 'OUI' :
                  if lmassp == 'OUI' :
                    __ONDEX[0]=AFFE_CHAR_MECA_F(  MODELE=__MODELE,
                      ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,),
                      TYPE_ONDE = 'P',
                      DIST=-1.0*__TMAT['Y', NCOU + 1], #DIST_REFLECHI=0.,
                      FONC_SIGNAL = __VITEX[0], GROUP_MA=(grma_subst,))
                          );
                    __FSEISMX=AFFE_CHAR_MECA_F(MODELE=__MODELE,
                      FORCE_NODALE=(_F(GROUP_NO='PLATE',FY=__NSEISMX,),),
                          );
                  else:
                    __FSEISMX=AFFE_CHAR_MECA_F(  MODELE=__MODELE,
                      ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,),
                      TYPE_ONDE = 'P',
                      DEPL_IMPO=__FONCDX,
                      FONC_SIGNAL = __FONCVX, GROUP_MA=(grma_gauch,grma_droit))
                          );
                    __ONDEX[0]=AFFE_CHAR_MECA_F(  MODELE=__MODELE,
                    ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,),
                    TYPE_ONDE = 'P',
                    DIST=-1.0*__TMAT['Y', NCOU + 1],
                    FONC_SIGNAL = __VITEX[0], GROUP_MA=grma_subst)
                         );
                else:
                  __ONDEX[0]=AFFE_CHAR_MECA_F(  MODELE=__MODELE,
                    ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,),
                    TYPE_ONDE = 'P',
                    DIST=-1.0*__TMAT['Y', NCOU + 1], DIST_REFLECHI=0.,
                    FONC_SIGNAL = __VITEX[0], GROUP_MA=(grma_subst,grma_gauch,grma_droit))
                         );
        # modèle 3D
        else:
            __VECASX = CALC_CHAR_SEISME(
                MATR_MASS=__MASSEH, DIRECTION=(1., 0., 0.), MONO_APPUI='OUI')
            __VECASY = CALC_CHAR_SEISME(
                MATR_MASS=__MASSEH, DIRECTION=(0., 1., 0.), MONO_APPUI='OUI')
            __VECASZ = CALC_CHAR_SEISME(
                MATR_MASS=__MASSEH, DIRECTION=(0., 0., 1.), MONO_APPUI='OUI')
            if lliaison == 'OUI':
                __ONDEX[1]=AFFE_CHAR_MECA_F(  MODELE=__MODELE,
                    ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,),
                                    TYPE_ONDE = 'P',
                                    DIST=-1.0*__TMAT['Y', NCOU + 1],
                                    FONC_SIGNAL = __VITEX[1], GROUP_MA=grma_subst),);
                __ONDEX[0]=AFFE_CHAR_MECA_F(  MODELE=__MODELE,
                    ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,),
                                    TYPE_ONDE = 'SH',
                                    DIST=-1.0*__TMAT['Y', NCOU + 1],
                                    FONC_SIGNAL = __VITEX[0], GROUP_MA=grma_subst),);
                __ONDEX[2]=AFFE_CHAR_MECA_F(  MODELE=__MODELE,
                    ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,),
                                    TYPE_ONDE = 'SV',
                                    DIST=-1.0*__TMAT['Y', NCOU + 1],
                                    FONC_SIGNAL = __VITEX[2], GROUP_MA=grma_subst),);
            else:
                __ONDEX[1]=AFFE_CHAR_MECA_F(  MODELE=__MODELE,
                    ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,),
                                    TYPE_ONDE = 'P',
                                    DIST=-1.0*__TMAT['Y', NCOU + 1],
                                    DIST_REFLECHI=0.,
                                    FONC_SIGNAL = __VITEX[1],
                                    GROUP_MA=(grma_subst,grma_gauch,grma_droit)),);
                __ONDEX[0]=AFFE_CHAR_MECA_F(  MODELE=__MODELE,
                    ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,),
                                    TYPE_ONDE = 'SH',
                                    DIST=-1.0*__TMAT['Y', NCOU + 1],
                                    DIST_REFLECHI=0.,
                                    FONC_SIGNAL = __VITEX[0],
                                    GROUP_MA=(grma_subst,grma_gauch,grma_droit)),);
                __ONDEX[2]=AFFE_CHAR_MECA_F(  MODELE=__MODELE,
                    ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,),
                                    TYPE_ONDE = 'SV',
                                    DIST=-1.0*__TMAT['Y', NCOU + 1],
                                    DIST_REFLECHI=0.,
                                    FONC_SIGNAL = __VITEX[2],
                                    GROUP_MA=(grma_subst,grma_gauch,grma_droit)),);
            #
            # CALCUL HARMONIQUE SUR BASE PHYSIQUE #
            #

            # On excite la base de la colonne avec un bruit blanc

        if args['CHARGEMENT'] == 'ONDE_PLANE':

          if ltranin == 'OUI' :
            __CHA_ON=CREA_RESU(OPERATION='CONV_CHAR',
                  TYPE_RESU='DYNA_TRANS',
                  CONV_CHAR=_F(
                          MATR_RIGI=__RIGIDITE,
                          CHARGE=(__ONDEX[0],__FSEISMX),
                          PRECISION=1.E-6,CRITERE='RELATIF',
                          LIST_INST=__linst,),
                );
          else:
            if dime == "2D":
              __CHA_ON=CREA_RESU(OPERATION='CONV_CHAR',
                  TYPE_RESU='DYNA_TRANS',
                  CONV_CHAR=_F(
                          MATR_RIGI=__RIGIDITE,
                          CHARGE=(__ONDEX[0]),
                          PRECISION=1.E-6,CRITERE='RELATIF',
                          LIST_INST=__linst,),
                );
            else:
              __CHA_ON=CREA_RESU(OPERATION='CONV_CHAR',
                  TYPE_RESU='DYNA_TRANS',
                  CONV_CHAR=_F(
                          MATR_RIGI=__RIGIDITE,
                          CHARGE=(__ONDEX[0],__ONDEX[1],__ONDEX[2]),
                          PRECISION=1.E-6,CRITERE='RELATIF',
                          LIST_INST=__linst,),
                );

          __CHAONF = REST_SPEC_TEMP( RESULTAT = __CHA_ON ,
                          METHODE = 'PROL_ZERO' ,
                          SYMETRIE = 'NON' ,
                          NOM_CHAM = 'DEPL' ,  );

          __DYNHARM = DYNA_VIBRA    (TYPE_CALCUL='HARM', BASE_CALCUL='PHYS',
                        MODELE=__MODELE,
                        CHAM_MATER=__CHAMPMAH,
                        MATR_RIGI=__RIGIHYST,
                        MATR_MASS=__MASSEH,
                        MATR_AMOR = __AMORTIH,
                        SOLVEUR=_F(
                                STOP_SINGULIER='NON',
                                NPREC=15,
                                METHODE='MUMPS',),
                        EXCIT_RESU=(
                                 _F( RESULTAT = __CHAONF,
                                     COEF_MULT_C= 1.0 -0.0j,),
                                 ),
                        LIST_FREQ= __lfreq0,
                        TOUT_CHAM= 'OUI'
                      );
            # On excite la base de la colonne avec un bruit blanc
######## cas classique et DSP
        else:
          if dime == "2D":
              if args['LIST_FREQ'] is not None:
                __DYNHARM = DYNA_VIBRA    (TYPE_CALCUL='HARM', BASE_CALCUL='PHYS',
                                       MODELE=__MODELE,
                                       CHAM_MATER=__CHAMPMAH,
                                       MATR_MASS=__MASSEH,
                                       MATR_RIGI=__RIGIHYST,
                                       MATR_AMOR=__AMORTIH,
                                       LIST_FREQ=args['LIST_FREQ'],
                                       EXCIT=(
                                       _F(VECT_ASSE=__VECASX, FONC_MULT=__UN,),
                                       ),
                                       SOLVEUR=_F(RENUM='METIS',
                                                  STOP_SINGULIER='OUI',
                                                  METHODE='MUMPS',
                                                  NPREC=17,
                                                  ),
                                       )

              else:
                __DYNHARM = DYNA_VIBRA    (TYPE_CALCUL='HARM', BASE_CALCUL='PHYS',
                                       MODELE=__MODELE,
                                       CHAM_MATER=__CHAMPMAH,
                                       MATR_MASS=__MASSEH,
                                       MATR_RIGI=__RIGIHYST,
                                       MATR_AMOR=__AMORTIH,
                                       LIST_FREQ=__lfreqc,
                                       EXCIT=(
                                       _F(VECT_ASSE=__VECASX, FONC_MULT=__UN,),
                                       ),
                                       SOLVEUR=_F(RENUM='METIS',
                                                  STOP_SINGULIER='OUI',
                                                  METHODE='MUMPS',
                                                  NPREC=17,
                                                  ),
                                       )
          else:
              if args['LIST_FREQ'] is not None:
                __DYNHARM = DYNA_VIBRA    (TYPE_CALCUL='HARM', BASE_CALCUL='PHYS',
                                       MODELE=__MODELE,
                                       CHAM_MATER=__CHAMPMAH,
                                       MATR_MASS=__MASSEH,
                                       MATR_RIGI=__RIGIHYST,
                                       MATR_AMOR=__AMORTIH,
                                       LIST_FREQ=args['LIST_FREQ'],
                                       EXCIT=(
                                       _F(VECT_ASSE=__VECASX, FONC_MULT=__UN,),
                                       _F(VECT_ASSE=__VECASY, FONC_MULT=__UN,),
                                       _F(VECT_ASSE=__VECASZ, FONC_MULT=__UN,),
                                       ),
                                       SOLVEUR=_F(RENUM='METIS',
                                                  STOP_SINGULIER='OUI',
                                                  METHODE='MUMPS',
                                                  NPREC=17,
                                                  ),
                                       )

              else:
                __DYNHARM = DYNA_VIBRA    (TYPE_CALCUL='HARM', BASE_CALCUL='PHYS',
                                       MODELE=__MODELE,
                                       CHAM_MATER=__CHAMPMAH,
                                       MATR_MASS=__MASSEH,
                                       MATR_RIGI=__RIGIHYST,
                                       MATR_AMOR=__AMORTIH,
                                       LIST_FREQ=__lfreqc,
                                       EXCIT=(
                                       _F(VECT_ASSE=__VECASX, FONC_MULT=__UN,),
                                       _F(VECT_ASSE=__VECASY, FONC_MULT=__UN,),
                                       _F(VECT_ASSE=__VECASZ, FONC_MULT=__UN,),
                                       ),
                                       SOLVEUR=_F(RENUM='METIS',
                                                  STOP_SINGULIER='OUI',
                                                  METHODE='MUMPS',
                                                  NPREC=17,
                                                  ),
                                       )
        if ( (dime == "2D") and (ldevi=='OUI') ):
          __DYNHARM=CALC_CHAMP(reuse =__DYNHARM,
                             RESULTAT=__DYNHARM,
                             MODELE=__MODELE,
                             CHAM_MATER=__CHAMPMAH,
                             GROUP_MA=(grma_colon,),
                             FORCE=('FORC_NODA',),
                            );

            #
            #
            #                    DEBUT DU POST TRAITEMENT
            #

        if iter == 0:
            __mailla = DEFI_GROUP(reuse=__mailla,
                                  MAILLAGE=__mailla,
                                  CREA_GROUP_NO=_F(GROUP_MA=__TMAT['M', 1],),
                                  )

            __mailla = DEFI_GROUP(reuse=__mailla,
                                  MAILLAGE=__mailla,
                                  CREA_GROUP_NO=_F(
                                      NOM='PN0', GROUP_NO=__TMAT['M', 1],
                                  POSITION='INIT'),
                                  )

            __mailla = DEFI_GROUP(reuse=__mailla,
                                  MAILLAGE=__mailla,
                                  CREA_GROUP_NO=_F(
                                      GROUP_MA=__TMAT['M', NCOU + 1],),
                                  )

            __mailla = DEFI_GROUP(reuse=__mailla,
                                  MAILLAGE=__mailla,
                                  CREA_GROUP_NO=_F(
                                  NOM='PNRA', GROUP_NO=__TMAT['M', NCOU + 1],
                                  NUME_INIT=2, NUME_FIN=2,),
                                  #POSITION='FIN'),
                                  )

            #

            # On recupere le signal en Champ Libre (CL) et au substratum (Bore
            # Hole)

        __AHuXrCL = [None]*num_dime
        __AHuXrBH  = [None]*num_dime
        __FHuXrCL = [None]*num_dime
        __FHuXrBH  = [None]*num_dime
        __mAHuXrCL = [None]*num_dime
        __mAHuXrBH = [None]*num_dime
        __formFDT = [None]*num_dime
        __formFDT2 = [None]*num_dime
        if dime == "2D":
            __AHuXrCL[0] = RECU_FONCTION(RESULTAT=__DYNHARM,
                                      NOM_CHAM='ACCE',
                                      NOM_CMP=args['NOM_CMP'],
                                      GROUP_NO='PN0',
                                      INTERPOL='LIN',
                                      PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',)

            __AHuXrBH[0] = RECU_FONCTION(RESULTAT=__DYNHARM,
                                      NOM_CHAM='ACCE',
                                      NOM_CMP=args['NOM_CMP'],
                                      GROUP_NO='PNRA',
                                      INTERPOL='LIN',
                                      PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',)

            if ldevi=='OUI':

              __FHuXrCL[0] = RECU_FONCTION(RESULTAT=__DYNHARM,
                                      NOM_CHAM='FORC_NODA',
                                      NOM_CMP=CMP2,
                                      GROUP_NO='PN0',
                                      INTERPOL='LIN',
                                      PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',)

              __FHuXrBH[0] = RECU_FONCTION(RESULTAT=__DYNHARM,
                                      NOM_CHAM='FORC_NODA',
                                      NOM_CMP=CMP2,
                                      GROUP_NO='PNRA',
                                      INTERPOL='LIN',
                                      PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',)

            __mAHuXrCL[0] = CALC_FONCTION(
                EXTRACTION=_F(FONCTION=__AHuXrCL[0], PARTIE='MODULE'))
            __mAHuXrBH[0] = CALC_FONCTION(
                EXTRACTION=_F(FONCTION=__AHuXrBH[0], PARTIE='MODULE'))
            const_context = {
                'FILTRE': __FILTRE,
                'AHuXrCL': __AHuXrCL[0],
                'AHuXrBH': __AHuXrBH[0],
                'AHX': __AHX[0],
                'ACCEX0H': __ACCEX0H[0]
            }
            if args['CHARGEMENT'] == 'MONO_APPUI':
                __formFDT[0] = FORMULE(
                    NOM_PARA='FREQ',
                    VALE_C='FILTRE(FREQ)*(1.+0.j )/(1.+0.j + AHuXrCL(FREQ))',
                    **const_context)
                __formFDT2[0] = FORMULE(
                    NOM_PARA='FREQ',
                    VALE_C='FILTRE(FREQ)*(1.+0.j + AHuXrCL(FREQ))/(1.+0.j + AHuXrBH(FREQ))',
                    **const_context)
            else:
                __formFDT[0] = FORMULE(
                    NOM_PARA='FREQ',
                    VALE_C='FILTRE(FREQ)*AHX(FREQ)/AHuXrCL(FREQ)',
                    **const_context)
                __formFDT2[0] = FORMULE(
                    NOM_PARA='FREQ',
                    VALE_C='FILTRE(FREQ)*AHuXrCL(FREQ)/ACCEX0H(FREQ)',
                    **const_context)

        else:
            for n in range(num_dime):
                __AHuXrCL[n] = RECU_FONCTION(RESULTAT=__DYNHARM,
                                          NOM_CHAM='ACCE',
                                          NOM_CMP=dire_dime[n],
                                          GROUP_NO='PN0',
                                          INTERPOL='LIN',
                                          PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',)

                __AHuXrBH[n] = RECU_FONCTION(RESULTAT=__DYNHARM,
                                          NOM_CHAM='ACCE',
                                          NOM_CMP=dire_dime[n],
                                          GROUP_NO='PNRA',
                                          INTERPOL='LIN',
                                          PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',)
                __mAHuXrCL[n] = CALC_FONCTION(
                    EXTRACTION=_F(FONCTION=__AHuXrCL[n], PARTIE='MODULE'))
                __mAHuXrBH[n] = CALC_FONCTION(
                    EXTRACTION=_F(FONCTION=__AHuXrBH[n], PARTIE='MODULE'))

            const_context = {
                'FILTRE': __FILTRE,
                'AHuXrCL0': __AHuXrCL[0],
                'AHuXrCL1': __AHuXrCL[1],
                'AHuXrCL2': __AHuXrCL[2],
                'AHuXrBH0': __AHuXrBH[0],
                'AHuXrBH1': __AHuXrBH[1],
                'AHuXrBH2': __AHuXrBH[2],
                'AHX0': __AHX[0],
                'AHX1': __AHX[1],
                'AHX2': __AHX[2],
                'ACCEX0H0': __ACCEX0H[0],
                'ACCEX0H1': __ACCEX0H[1],
                'ACCEX0H2': __ACCEX0H[2],
            }
            if args['CHARGEMENT'] == 'MONO_APPUI':
                __formFDT[0] = FORMULE(
                    NOM_PARA='FREQ',
                    VALE_C='FILTRE(FREQ)*(1.+0.j )/(1.+0.j + AHuXrCL0(FREQ))',
                    **const_context)
                __formFDT2[0] = FORMULE(
                    NOM_PARA='FREQ',
                    VALE_C='FILTRE(FREQ)*(1.+0.j + AHuXrCL0(FREQ))/(1.+0.j + AHuXrBH0(FREQ))',
                    **const_context)

                __formFDT[1] = FORMULE(
                    NOM_PARA='FREQ',
                    VALE_C='FILTRE(FREQ)*(1.+0.j )/(1.+0.j + AHuXrCL1(FREQ))',
                    **const_context)
                __formFDT2[1] = FORMULE(
                    NOM_PARA='FREQ',
                    VALE_C='FILTRE(FREQ)*(1.+0.j + AHuXrCL1(FREQ))/(1.+0.j + AHuXrBH1(FREQ))',
                    **const_context)

                __formFDT[2] = FORMULE(
                    NOM_PARA='FREQ',
                    VALE_C='FILTRE(FREQ)*(1.+0.j )/(1.+0.j + AHuXrCL2(FREQ))',
                    **const_context)
                __formFDT2[2] = FORMULE(
                    NOM_PARA='FREQ',
                    VALE_C='FILTRE(FREQ)*(1.+0.j + AHuXrCL2(FREQ))/(1.+0.j + AHuXrBH2(FREQ))',
                    **const_context)
            else:
                __formFDT[0] = FORMULE(
                    NOM_PARA='FREQ',
                    VALE_C='FILTRE(FREQ)*AHX0(FREQ)/AHuXrCL0(FREQ)',
                    **const_context)
                __formFDT2[0] = FORMULE(
                    NOM_PARA='FREQ',
                    VALE_C='FILTRE(FREQ)*AHuXrCL0(FREQ)/ACCEX0H0(FREQ)',
                    **const_context)

                __formFDT[1] = FORMULE(
                    NOM_PARA='FREQ',
                    VALE_C='FILTRE(FREQ)*AHX1(FREQ)/AHuXrCL1(FREQ)',
                    **const_context)
                __formFDT2[1] = FORMULE(
                    NOM_PARA='FREQ',
                    VALE_C='FILTRE(FREQ)*AHuXrCL1(FREQ)/ACCEX0H1(FREQ)',
                    **const_context)

                __formFDT[2] = FORMULE(
                    NOM_PARA='FREQ',
                    VALE_C='FILTRE(FREQ)*AHX2(FREQ)/AHuXrCL2(FREQ)',
                    **const_context)
                __formFDT2[2] = FORMULE(
                    NOM_PARA='FREQ',
                    VALE_C='FILTRE(FREQ)*AHuXrCL2(FREQ)/ACCEX0H2(FREQ)',
                    **const_context)


            #
            # Definition de la fonction de transfert entre RA et CL #
            #

        __FDT_RACL = [None]*num_dime
        __FDT_CLBH = [None]*num_dime
        __mFDTRACL = [None]*num_dime
        __mFDTCLBH = [None]*num_dime
        __AHX_RA = [None]*num_dime
        __AX_RAf = [None]*num_dime
        __AX_RA = [None]*num_dime
        __SAX_RA = [None]*num_dime
        __AHXrCL = [None]*num_dime
        __AHXrBH = [None]*num_dime
        __FHXrCL = [None]*num_dime
        __FHXrBH = [None]*num_dime
        __AXrCL = [None]*num_dime
        __AXrBH = [None]*num_dime
        __AX_CL = [None]*num_dime
        __AX_BH = [None]*num_dime
        __FXrCL = [None]*num_dime
        __FXrBH = [None]*num_dime
        __FX_CL = [None]*num_dime
        __FX_BH = [None]*num_dime
        __SAX_CL = [None]*num_dime
        __SAX_BH = [None]*num_dime
        __VX_CL = [None]*num_dime
        __DX_CL = [None]*num_dime
        __VX_RA = [None]*num_dime
        __DX_RA = [None]*num_dime
        __VX_BH = [None]*num_dime
        __DX_BH = [None]*num_dime

        for n in range(num_dime):
            if args['CHARGEMENT'] == 'ONDE_PLANE':
              __FDT_RACL[n] = CALC_FONC_INTERP(NOM_PARA='FREQ',
                                          LIST_PARA=__lfreq0,
                                          FONCTION=__formFDT[n],
                                          INTERPOL='LIN',
                                          PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',)

              __FDT_CLBH[n] = CALC_FONC_INTERP(NOM_PARA='FREQ',
                                          LIST_PARA=__lfreq0,
                                          FONCTION=__formFDT2[n],
                                          INTERPOL='LIN',
                                          PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',)
            elif args['LIST_FREQ'] is not None:
              __FDT_RACL[n] = CALC_FONC_INTERP(NOM_PARA='FREQ',
                                          LIST_PARA=args['LIST_FREQ'],
                                          FONCTION=__formFDT[n],
                                          INTERPOL='LIN',
                                          PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',)

              __FDT_CLBH[n] = CALC_FONC_INTERP(NOM_PARA='FREQ',
                                          LIST_PARA=args['LIST_FREQ'],
                                          FONCTION=__formFDT2[n],
                                          INTERPOL='LIN',
                                          PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',)
            else:
              __FDT_RACL[n] = CALC_FONC_INTERP(NOM_PARA='FREQ',
                                          LIST_PARA=__lfreqc,
                                          FONCTION=__formFDT[n],
                                          INTERPOL='LIN',
                                          PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',)

              __FDT_CLBH[n] = CALC_FONC_INTERP(NOM_PARA='FREQ',
                                          LIST_PARA=__lfreqc,
                                          FONCTION=__formFDT2[n],
                                          INTERPOL='LIN',
                                          PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',)

            __mFDTRACL[n] = CALC_FONCTION(
                EXTRACTION=_F(FONCTION=__FDT_RACL[n], PARTIE='MODULE'))
            __mFDTCLBH[n] = CALC_FONCTION(
                EXTRACTION=_F(FONCTION=__FDT_CLBH[n], PARTIE='MODULE'))

            #
            # Definition de l accelerogramme au Rocher Affleurant   #
            #


            if 'DSP'  in args:
              if input == 'CL':
                if args['CHARGEMENT'] == 'MONO_APPUI':
                  __AHX_RA[n] = CALC_FONCTION(
                      MULT=(_F(FONCTION= __AHX[n],), _F(FONCTION=__FDT_RACL[n],), ), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                else:
                  __AHX_RA[n] = CALC_FONCTION(
                      MULT=(_F(FONCTION= __ACCEX0H[n],), _F(FONCTION=__FDT_RACL[n],), ), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
              elif input == 'RA':
                  __AHX_RA[n]  = CALC_FONCTION(COMB_C=_F(FONCTION=__AHX[n], COEF_R = 1.), LIST_PARA=__lfreq,   NOM_PARA='FREQ',);


            else:

                if input == 'CL':
                  if args['CHARGEMENT'] == 'MONO_APPUI':
                    __AHX_RA[n] = CALC_FONCTION(
                        MULT=(_F(FONCTION= __AHX[n],), _F(FONCTION=__FDT_RACL[n],), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                  else:
                    __AHX_RA[n] = CALC_FONCTION(
                        MULT=(_F(FONCTION= __ACCEX0H[n],), _F(FONCTION=__FDT_RACL[n],), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)

                if input == 'RA':
                    __AHX_RA[n] = CALC_FONCTION(
                        MULT=(_F(FONCTION=__AHX[n],), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)


             # Calcul des accelerogrammes et spectres de sol au RA
            if 'DSP' not in args:
                __AX_RAf[n] = CALC_FONCTION(FFT=_F(FONCTION=__AHX_RA[n],
                                                METHODE='COMPLET',
                                                SYME='NON',),PROL_DROITE='CONSTANT',
                                         )
                __AX_RA[n] = CALC_FONCTION(
                    COMB=_F(FONCTION=__AX_RAf[n], COEF=1.), LIST_PARA=__linst,
                    INTERPOL='LIN',
                    PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT', )
                DETRUIRE(CONCEPT=_F(NOM=__AX_RAf[n],))

                if args['LIST_FREQ_SPEC_OSCI'] is not None:
                  __SAX_RA[n] = CALC_FONCTION(
                    SPEC_OSCI=_F(FONCTION=__AX_RA[n],AMOR_REDUIT=0.05,LIST_FREQ=args['LIST_FREQ_SPEC_OSCI'],NORME=9.81))
                else:
                  __SAX_RA[n] = CALC_FONCTION(
                    SPEC_OSCI=_F(FONCTION=__AX_RA[n], AMOR_REDUIT=0.05, NORME=9.81))
           # Calcul des accelerogrammes et spectres de sol au RA pour DSP#
            else:

              __AHX_RAf = CALC_FONCTION(EXTRACTION =_F(FONCTION=__AHX_RA[n], PARTIE='MODULE'), )
              __PAX_RA = CALC_FONCTION(
                PUISSANCE=_F(FONCTION=__AHX_RAf, EXPOSANT = 2.,),
                PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT', )
              DETRUIRE(CONCEPT=_F(NOM= __AHX_RAf,))

              if args['LIST_FREQ_SPEC_OSCI'] is not None:
                __SAX_RA[n] = CALC_FONCTION(
                  SPEC_OSCI=_F(FONCTION= __PAX_RA, NATURE_FONC ='DSP', DUREE = TSM,
                           METHODE ='RICE', NATURE = 'ACCE', LIST_FREQ=args['LIST_FREQ_SPEC_OSCI'],
                           AMOR_REDUIT=0.05, NORME=9.81))
              else:
                __SAX_RA[n] = CALC_FONCTION(
                  SPEC_OSCI=_F(FONCTION= __PAX_RA, NATURE_FONC ='DSP', DUREE = TSM,
                           METHODE ='RICE', NATURE = 'ACCE',
                           AMOR_REDUIT=0.05, NORME=9.81))

                # Calcul des accelerogrammes et spectres de sol en CL et BH
            if args['CHARGEMENT'] == 'MONO_APPUI':
              __AHXrCL[n] = CALC_FONCTION(
                 MULT=(_F(FONCTION=__AHX_RA[n],), _F(FONCTION=__AHuXrCL[n],), _F(FONCTION=__FILTRE,)),
                 LIST_PARA=__lfreq, NOM_PARA='FREQ',)
              __AHXrBH[n] = CALC_FONCTION(
                 MULT=(_F(FONCTION=__AHX_RA[n],), _F(FONCTION=__AHuXrBH[n],), _F(FONCTION=__FILTRE,)),
                 LIST_PARA=__lfreq, NOM_PARA='FREQ',)
              if dime == "2D":
                if ldevi=='OUI':
                  __FHXrCL[n] = CALC_FONCTION(
                   MULT=(_F(FONCTION=__AHX_RA[n],), _F(FONCTION=__FHuXrCL[n],), _F(FONCTION=__FILTRE,)),
                   LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                  __FHXrBH[n] = CALC_FONCTION(
                   MULT=(_F(FONCTION=__AHX_RA[n],), _F(FONCTION=__FHuXrBH[n],), _F(FONCTION=__FILTRE,)),
                   LIST_PARA=__lfreq, NOM_PARA='FREQ',)
            else:
              if input == 'CL':
                __AHXrCL[n] = CALC_FONCTION(
                  MULT=(_F(FONCTION=__AHX[n]), _F(FONCTION=__FILTRE,)),
                  LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                __AHXrBH[n] = CALC_FONCTION(
                   MULT=(_F(FONCTION=__FDT_RACL[n],), _F(FONCTION=__AHuXrBH[n],), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                if dime == "2D":
                  if ldevi=='OUI':
                    __FHXrCL[n] = CALC_FONCTION(
                     MULT=(_F(FONCTION=__FDT_RACL[n],), _F(FONCTION=__FHuXrCL[n]), _F(FONCTION=__FILTRE,)),
                     LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                    __FHXrBH[n] = CALC_FONCTION(
                     MULT=(_F(FONCTION=__FDT_RACL[n],), _F(FONCTION=__FHuXrBH[n],), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
              if input == 'RA':
                __AHXrCL[n] = CALC_FONCTION(
                  MULT=(_F(FONCTION=__AHuXrCL[n]), _F(FONCTION=__FILTRE,)),
                  LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                __AHXrBH[n] = CALC_FONCTION(
                  MULT=(_F(FONCTION=__AHuXrBH[n]), _F(FONCTION=__FILTRE,)),
                  LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                if dime == "2D":
                  if ldevi=='OUI':
                    __FHXrCL[n] = CALC_FONCTION(
                     MULT=(_F(FONCTION=__FHuXrCL[n]), _F(FONCTION=__FILTRE,)),
                     LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                    __FHXrBH[n] = CALC_FONCTION(
                     MULT=(_F(FONCTION=__FHuXrBH[n]), _F(FONCTION=__FILTRE,)),
                     LIST_PARA=__lfreq, NOM_PARA='FREQ',)

            #MODIF POUR DSP: on reste en domaine fréquentiel
            if 'DSP' in args:
              __AHX_CL = CALC_FONCTION(
                COMB_C=(_F(FONCTION=__AHXrCL[n], COEF_R=1.,), _F(FONCTION=__AHX_RA[n], COEF_R=1.,),), LIST_PARA=__lfreq,)
              __AHX_BH = CALC_FONCTION(
                COMB_C=(_F(FONCTION=__AHXrBH[n], COEF_R=1.,), _F(FONCTION=__AHX_RA[n], COEF_R=1.,),), LIST_PARA=__lfreq,)

              __AHXCLf = CALC_FONCTION(EXTRACTION =_F(FONCTION=__AHX_CL, PARTIE='MODULE'), )
              __PAX_CL = CALC_FONCTION(PUISSANCE=_F(FONCTION=__AHXCLf, EXPOSANT = 2.,),
                                    PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT', )

              __AHXBHf = CALC_FONCTION( EXTRACTION=_F(FONCTION=__AHX_BH, PARTIE='MODULE'), )
              __PAX_BH = CALC_FONCTION( PUISSANCE=_F(FONCTION=__AHXBHf, EXPOSANT = 2.,),
                            PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT', )

              DETRUIRE(CONCEPT=_F(NOM= (__AHXCLf, __AHXBHf), ),)

            else:
                __AXrCL[n] = CALC_FONCTION(
                    FFT=_F(FONCTION=__AHXrCL[n], METHODE='COMPLET', SYME='NON',),PROL_DROITE='CONSTANT',)
                __AXrBH[n] = CALC_FONCTION(
                    FFT=_F(FONCTION=__AHXrBH[n], METHODE='COMPLET', SYME='NON',),PROL_DROITE='CONSTANT',)
                if dime == "2D":
                  if ldevi=='OUI':
                    __FXrCL[n] = CALC_FONCTION(
                     FFT=_F(FONCTION=__FHXrCL[n], METHODE='COMPLET', SYME='NON',),PROL_DROITE='CONSTANT',)
                    __FXrBH[n] = CALC_FONCTION(
                     FFT=_F(FONCTION=__FHXrBH[n], METHODE='COMPLET', SYME='NON',),PROL_DROITE='CONSTANT',)
                    __FX_CL[n] = CALC_FONCTION(
                     COMB=(_F(FONCTION=__FXrCL[n], COEF=1.,), ), LIST_PARA=__linst,)
                    __FX_BH[n] = CALC_FONCTION(
                     COMB=(_F(FONCTION=__FXrBH[n], COEF=1.,), ), LIST_PARA=__linst,)

                if args['CHARGEMENT'] == 'MONO_APPUI':
                  __AX_CL[n] = CALC_FONCTION(
                    COMB=(_F(FONCTION=__AXrCL[n], COEF=1.,), _F(FONCTION=__AX_RA[n], COEF=1.,),), LIST_PARA=__linst,)
                  __AX_BH[n] = CALC_FONCTION(
                    COMB=(_F(FONCTION=__AXrBH[n], COEF=1.,), _F(FONCTION=__AX_RA[n], COEF=1.,),), LIST_PARA=__linst,)
                else:
                  __AX_CL[n] = CALC_FONCTION(
                    COMB=(_F(FONCTION=__AXrCL[n], COEF=1.,), ), LIST_PARA=__linst,)
                  __AX_BH[n] = CALC_FONCTION(
                    COMB=(_F(FONCTION=__AXrBH[n], COEF=1.,), ), LIST_PARA=__linst,)

            #MODIF POR DSP: calcul des DSP puis SRO
            if 'DSP' in args:

              if args['LIST_FREQ_SPEC_OSCI'] is not None:

                __SAX_CL[n] = CALC_FONCTION(
                   SPEC_OSCI=_F(FONCTION=__PAX_CL, NATURE_FONC ='DSP', DUREE = TSM,
                             METHODE ='RICE', NATURE = 'ACCE',
                             AMOR_REDUIT=0.05, LIST_FREQ=args['LIST_FREQ_SPEC_OSCI'],NORME=9.81))
                __SAX_BH[n] = CALC_FONCTION(
                   SPEC_OSCI=_F(FONCTION=__PAX_BH,NATURE_FONC ='DSP', DUREE = TSM,
                             METHODE ='RICE', NATURE = 'ACCE',
                             AMOR_REDUIT=0.05,LIST_FREQ=args['LIST_FREQ_SPEC_OSCI'],NORME=9.81))
              else:
                __SAX_CL[n] = CALC_FONCTION(
                   SPEC_OSCI=_F(FONCTION=__PAX_CL, NATURE_FONC ='DSP', DUREE = TSM,
                             METHODE ='RICE', NATURE = 'ACCE', AMOR_REDUIT=0.05,NORME=9.81))
                __SAX_BH[n] = CALC_FONCTION(
                   SPEC_OSCI=_F(FONCTION=__PAX_BH,NATURE_FONC ='DSP', DUREE = TSM,
                             METHODE ='RICE', NATURE = 'ACCE',  AMOR_REDUIT=0.05,NORME=9.81))
            else:

                if args['LIST_FREQ_SPEC_OSCI'] is not None:
                  __SAX_CL[n] = CALC_FONCTION(
                    SPEC_OSCI=_F(FONCTION=__AX_CL[n],AMOR_REDUIT=0.05,LIST_FREQ=args['LIST_FREQ_SPEC_OSCI'],NORME=9.81))
                  __SAX_BH[n] = CALC_FONCTION(
                    SPEC_OSCI=_F(FONCTION=__AX_BH[n],AMOR_REDUIT=0.05,LIST_FREQ=args['LIST_FREQ_SPEC_OSCI'],NORME=9.81))
                else:
                  __SAX_CL[n] = CALC_FONCTION(
                    SPEC_OSCI=_F(FONCTION=__AX_CL[n], AMOR_REDUIT=0.05, NORME=9.81))
                  __SAX_BH[n] = CALC_FONCTION(
                    SPEC_OSCI=_F(FONCTION=__AX_BH[n], AMOR_REDUIT=0.05, NORME=9.81))


#On prend: DSP ldevi = NON # RIEN A FAIRE ICI

            if ldevi == 'OUI':

              __VX_CL[n] = CALC_FONCTION(INTEGRE=_F(FONCTION=__AX_CL[n],),
                     PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT',);

              __DX_CL[n]=CALC_FONCTION(INTEGRE=_F(FONCTION=__VX_CL[n],),
                     PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT',);

              __VX_RA[n] = CALC_FONCTION(INTEGRE=_F(FONCTION=__AX_RA[n],),
                     PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT',);

              __DX_RA[n]=CALC_FONCTION(INTEGRE=_F(FONCTION=__VX_RA[n],),
                     PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT',);

              __VX_BH[n] = CALC_FONCTION(INTEGRE=_F(FONCTION=__AX_BH[n],),
                     PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT',);

              __DX_BH[n]=CALC_FONCTION(INTEGRE=_F(FONCTION=__VX_BH[n],),
                     PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT',);

        # Calcul des contraintes et deformations dans tous les elements de
        # la colonne
        if args['LIST_FREQ'] is not None:
          __DYNHARM = CALC_CHAMP(
            RESULTAT=__DYNHARM,
            reuse=__DYNHARM,
            MODELE=__MODELE,
            CHAM_MATER=__CHAMPMAH,

            GROUP_MA=(grma_colon,),

            LIST_FREQ=args['LIST_FREQ'],
            CONTRAINTE = ('SIGM_ELGA',
                          ),
            DEFORMATION = ('EPSI_ELGA',
                           'EPSI_NOEU',
                           ),
          )
        elif args['CHARGEMENT'] == 'ONDE_PLANE':
          __DYNHARM = CALC_CHAMP(
            RESULTAT=__DYNHARM,
            reuse=__DYNHARM,
            MODELE=__MODELE,
            CHAM_MATER=__CHAMPMAH,

            GROUP_MA=(grma_colon,),

            LIST_FREQ=__lfreq0,
            CONTRAINTE = ('SIGM_ELGA',
                          ),
            DEFORMATION = ('EPSI_ELGA',
                           'EPSI_NOEU',
                           ),
          )
        else:
          __DYNHARM = CALC_CHAMP(
            RESULTAT=__DYNHARM,
            reuse=__DYNHARM,
            MODELE=__MODELE,
            CHAM_MATER=__CHAMPMAH,

            GROUP_MA=(grma_colon,),

            LIST_FREQ=__lfreqc,
            CONTRAINTE = ('SIGM_ELGA',
                          ),
            DEFORMATION = ('EPSI_ELGA',
                           'EPSI_NOEU',
                           ),
          )
        # Boucle de postraitement

        maccx = [None] * num_dime

        gamax = []
        gamax.append(0)
        rumax=[]
        rumax.append(0)
        evmax=[]
        evmax.append(0)

        maccxcl = [None] * num_dime

        # POUR DSP LE MAX SE CALCULE PAR LE FACTEUR DE PIC

        if 'DSP' in args:

          __DSP_CL = DEFI_INTE_SPEC ( DIMENSION= 1,
                  PAR_FONCTION =_F( NUME_ORDRE_I = 1,
                                    NUME_ORDRE_J = 1,
                                    FONCTION  =  __PAX_CL ,), )

          __accxcla = POST_DYNA_ALEA( INTERSPECTRE=_F( INTE_SPEC = __DSP_CL,
                             NUME_ORDRE_I = 1, NUME_ORDRE_J = 1,   DUREE = TSM, ) ,)
          maccxcl[0] = __accxcla.EXTR_TABLE().MAX_MOY[0] / 9.81
          DETRUIRE(CONCEPT=_F(NOM=(__DSP_CL,__accxcla)), INFO = 1)

        else:
          for n in range(num_dime):
            __accxcla = CALC_FONCTION(ABS=_F(FONCTION=__AX_CL[n]))
            maccxcl[n] = max(__accxcla.Ordo()) / 9.81
            DETRUIRE(CONCEPT=_F(NOM=(__accxcla)), INFO = 1)

        if dime == "2D":
            __axa = [None] * (NCOU + 1)
            __paxa = [None] * (NCOU + 1)
            if ldevi=='OUI':
              __vix = [None] * (NCOU + 1)
              __dex = [None] * (NCOU + 1)
              __foy = [None] * (NCOU + 1)
            __epxy = [None] * (NCOU + 1)
            __gam = [None] * (NCOU + 1)
            __tau = [None] * (NCOU + 1)
            __ru = [None] * (NCOU + 1)
            __ev = [None] * (NCOU + 1)
            __foy = [None] * (NCOU + 1)
            __axa.append(0)
            if ldevi=='OUI':
              __vix.append(0)
              __dex.append(0)
              __foy.append(0)
            __epxy.append(0)
            __tau.append(0)
            __ru.append(0)
            __ev.append(0)
            __foy.append(0)
            lmaccx = []
            lmaccx.append(maccxcl[0])

        elif dime == "3D":
            __axa = [None] * num_dime
            if ldevi=='OUI':
              __vix = [None] * num_dime
              __dex = [None] * num_dime
            __axaX = [None] * (NCOU + 1)
            __axaY = [None] * (NCOU + 1)
            __axaZ = [None] * (NCOU + 1)
            if ldevi=='OUI':
              __vixX = [None] * (NCOU + 1)
              __vixY = [None] * (NCOU + 1)
              __vixZ = [None] * (NCOU + 1)
              __dexX = [None] * (NCOU + 1)
              __dexY = [None] * (NCOU + 1)
              __dexZ = [None] * (NCOU + 1)
            __epxy = [None] * (NCOU + 1)
            __gam = [None] * (NCOU + 1)
            __tau = [None] * (NCOU + 1)
            __ru = [None] * (NCOU + 1)
            __ev = [None] * (NCOU + 1)
            lmaccxX = []
            lmaccxY = []
            lmaccxZ = []
            lmaccxX.append(maccxcl[0])
            lmaccxY.append(maccxcl[1])
            lmaccxZ.append(maccxcl[2])

        for k in range(1, NCOU + 1):
            if iter == 0:
                if k !=  NCOU:
                   __mailla = DEFI_GROUP(reuse=__mailla,
                                      MAILLAGE=__mailla,
                                      CREA_GROUP_NO=_F(
                                          GROUP_MA=__TMAT['M', k + 1],),
                                      )

                __mailla = DEFI_GROUP(reuse=__mailla,
                                      MAILLAGE=__mailla,
                                      CREA_GROUP_NO=_F(
                                      NOM=('PN' + str(k)), GROUP_NO=__TMAT['M', k + 1],
                                      POSITION='INIT'),
                                      )

            if dime =="2D" :
                __fthr = RECU_FONCTION(
                    GROUP_NO=('PN' + str(k)), RESULTAT=__DYNHARM, NOM_CHAM='ACCE', NOM_CMP=args['NOM_CMP'], INTERPOL='LIN',
                              PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT')
                if args['CHARGEMENT'] == 'ONDE_PLANE':
                  if input == 'CL':
                    __axhr = CALC_FONCTION(
                      MULT=(_F(FONCTION=__FDT_RACL[0],), _F(FONCTION=__fthr,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                  if input == 'RA':
                    __axhr = CALC_FONCTION(
                      MULT=(_F(FONCTION=__fthr,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                else:
                  __axhr = CALC_FONCTION(
                    MULT=(_F(FONCTION=__AHX_RA[0],), _F(FONCTION=__fthr,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)

                if 'DSP' not in args:
                  __axr = CALC_FONCTION(
                    FFT=_F(FONCTION=__axhr, METHODE='COMPLET', SYME='NON',),PROL_DROITE='CONSTANT',)

                if args['CHARGEMENT'] == 'ONDE_PLANE':
                  __axa[k] = CALC_FONCTION(
                    COMB=(_F(FONCTION=__axr, COEF=1.,),), LIST_PARA=__linst,)
                else:
                  if 'DSP' in args:
                    __axa[k] = CALC_FONCTION(
                      COMB_C=(_F(FONCTION=__axhr, COEF_R=1.,), _F(FONCTION=__AHX_RA[0], COEF_R=1.,),), LIST_PARA=__lfreq,)
                  else:
                    __axa[k] = CALC_FONCTION(
                     COMB=(_F(FONCTION=__axr, COEF=1.,), _F(FONCTION=__AX_RA[0], COEF=1.,),), LIST_PARA=__linst,)

                if ldevi == 'OUI':
                  __vix[k] = CALC_FONCTION(INTEGRE=_F(FONCTION=__axa[k],),
                     PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT',);

                  __dex[k]=CALC_FONCTION(INTEGRE=_F(FONCTION=__vix[k],),
                     PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT',);

                  __ftfy = RECU_FONCTION(
                    GROUP_NO=('PN' + str(k)), RESULTAT=__DYNHARM, NOM_CHAM='FORC_NODA', NOM_CMP=CMP2, INTERPOL='LIN',
                              PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT')

                __ftep = RECU_FONCTION(
                    GROUP_MA=__TMAT['M', k], RESULTAT=__DYNHARM, NOM_CHAM='EPSI_ELGA', POINT=1, NOM_CMP='EPXY', INTERPOL='LIN',
                    PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT')


                if args['CHARGEMENT'] == 'ONDE_PLANE':
                  if input == 'CL':
                    __eph = CALC_FONCTION(
                      MULT=(_F(FONCTION=__FDT_RACL[0],), _F(FONCTION=__ftep,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                    if ldevi == 'OUI':
                      __fyh = CALC_FONCTION(
                       MULT=(_F(FONCTION=__FDT_RACL[0],), _F(FONCTION=__ftfy,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                  if input == 'RA':
                    __eph = CALC_FONCTION(
                      MULT=(_F(FONCTION=__ftep,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                    if ldevi == 'OUI':
                      __fyh = CALC_FONCTION(
                       MULT=(_F(FONCTION=__ftfy,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                else:
                  __eph = CALC_FONCTION(
                    MULT=(_F(FONCTION=__AHX_RA[0],), _F(FONCTION=__ftep,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                  if ldevi == 'OUI':
                    __fyh = CALC_FONCTION(
                     MULT=(_F(FONCTION=__AHX_RA[0],), _F(FONCTION=__ftfy,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)

                if formulation == 'LYSMER':
                  f2Getoil = E[iter][k] / (1+ __TMAT['NU',k]) * (1.-AH[iter][k]*AH[iter][k]/2 + (AH[iter][k]*sqrt(1-AH[iter][k]*AH[iter][k]/4))*1.j) ;
                else:
                  f2Getoil = (E[iter][k] / (1+ __TMAT['NU',k]) ) * (1.+ (AH[iter][k])*1.j);

                if 'DSP' not in args:
                  __epxy[k] = CALC_FONCTION(
                     FFT=_F(FONCTION=__eph, METHODE='COMPLET', SYME='NON',),PROL_DROITE='CONSTANT',)
                # Calcul de la distorsion : gamma = 2*epxy ; tau = sixy
                  __gam[k] = CALC_FONCTION(LIST_PARA=__linst,
                            COMB=(_F(FONCTION=__epxy[k], COEF=(2),),)  ,)
                  __tauh = CALC_FONCTION(COMB_C=_F(FONCTION=__eph,COEF_C = f2Getoil),LIST_PARA=__lfreq,NOM_PARA='FREQ',);

                  __tau[k] = CALC_FONCTION(FFT=_F(FONCTION=__tauh,METHODE='COMPLET',SYME='NON',),PROL_DROITE='CONSTANT',);
                  if ldevi == 'OUI':
                    __foy[k] = CALC_FONCTION(FFT=_F(FONCTION=__fyh,METHODE='COMPLET',SYME='NON',),PROL_DROITE='CONSTANT',);
                else:
                  __gam[k] = CALC_FONCTION( LIST_PARA=__lfreq,
                          COMB_C=(_F(FONCTION=__eph, COEF_R=(2),), )    ,)

                  __tau[k] = CALC_FONCTION(COMB_C=_F(FONCTION=__eph,COEF_C = f2Getoil),LIST_PARA=__lfreq,NOM_PARA='FREQ',);

                # Calcul des max
                if 'DSP' in args:

                  __axaf = CALC_FONCTION( EXTRACTION=_F(FONCTION= __axa[k],PARTIE='MODULE' ), )

                  __paxa[k] = CALC_FONCTION(
                      PUISSANCE=_F(FONCTION=__axaf, EXPOSANT = 2.,),
                       PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT', )

                  __DSP = DEFI_INTE_SPEC ( DIMENSION= 1,
                      PAR_FONCTION =_F( NUME_ORDRE_I = 1,
                                        NUME_ORDRE_J = 1,
                           FONCTION  =  __paxa[k] ,),)

                  __accxa = POST_DYNA_ALEA( INTERSPECTRE=_F( INTE_SPEC = __DSP,
                         NUME_ORDRE_I = 1, NUME_ORDRE_J = 1,    DUREE = TSM, ) ,)
                  maccx = __accxa.EXTR_TABLE().MAX_MOY[0]
                  DETRUIRE(CONCEPT=_F(NOM=(  __DSP,)), INFO = 1)

                  __gamf = CALC_FONCTION( EXTRACTION=_F(FONCTION= __gam[k], PARTIE='MODULE'), )

                  __pgam = CALC_FONCTION(
                      PUISSANCE=_F(FONCTION=__gamf, EXPOSANT = 2.,),
                       PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT', )

                  __DSP = DEFI_INTE_SPEC ( DIMENSION= 1,
                       PAR_FONCTION =_F( NUME_ORDRE_I = 1,
                                        NUME_ORDRE_J = 1,
                                        FONCTION  =  __pgam ,), )

                  __gama = POST_DYNA_ALEA( INTERSPECTRE=_F( INTE_SPEC = __DSP,
                              NUME_ORDRE_I = 1, NUME_ORDRE_J = 1,  DUREE = TSM, ) ,)
                  mgam = __gama.EXTR_TABLE().MAX_MOY[0]
                  DETRUIRE(CONCEPT=_F(NOM=(  __DSP, __pgam )), INFO = 1)

                else:
                  __accxa = CALC_FONCTION(ABS=_F(FONCTION=__axa[k]))
                  __gama = CALC_FONCTION(ABS=_F(FONCTION=__gam[k]))
                  maccx = max(__accxa.Ordo())
                  mgam = max(__gama.Ordo())

                lmaccx.append(maccx / 9.81)
                gamax.append(mgam)

                if 'DSP' in args:
                  DETRUIRE(CONCEPT=_F(NOM=(__accxa, __axaf,  __gama,__gamf,
                                         __axhr,  __eph, __ftep, __fthr,
                                         )), INFO = 1)

                else:
                  DETRUIRE(CONCEPT=_F(NOM=(__accxa, __gama,
                                         __axhr, __axr, __eph,
                                         __ftep, __fthr,
                                         )), INFO = 1)

            elif dime == "3D":
                for n in range(num_dime):
                    __fthr = RECU_FONCTION(
                            GROUP_NO=('PN' + str(k)), RESULTAT=__DYNHARM, NOM_CHAM='ACCE', NOM_CMP=dire_dime[n], INTERPOL='LIN',
                                      PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT')
                    if args['CHARGEMENT'] == 'ONDE_PLANE':
                      if input == 'CL':
                        __axhr = CALC_FONCTION(
                          MULT=(_F(FONCTION=__FDT_RACL[n],), _F(FONCTION=__fthr,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                      if input == 'RA':
                        __axhr = CALC_FONCTION(
                          MULT=(_F(FONCTION=__fthr,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                    else:
                      __axhr = CALC_FONCTION(
                        MULT=(_F(FONCTION=__AHX_RA[n],), _F(FONCTION=__fthr,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)

                    __axr = CALC_FONCTION(
                        FFT=_F(FONCTION=__axhr, METHODE='COMPLET', SYME='NON',),PROL_DROITE='CONSTANT',)

                    if args['CHARGEMENT'] == 'ONDE_PLANE':
                      __axa[n] = CALC_FONCTION(
                        COMB=(_F(FONCTION=__axr, COEF=1.,),), LIST_PARA=__linst,)
                    else:
                      __axa[n] = CALC_FONCTION(
                        COMB=(_F(FONCTION=__axr, COEF=1.,), _F(FONCTION=__AX_RA[n], COEF=1.,),), LIST_PARA=__linst,)

                    __accxa = CALC_FONCTION(ABS=_F(FONCTION=__axa[n]))
                    maccx[n] = max(__accxa.Ordo())
                    DETRUIRE(CONCEPT=_F(NOM=(__accxa,
                             __axhr, __axr,
                             )), INFO = 1)

                    if ldevi == 'OUI':

                      __vix[n] = CALC_FONCTION(INTEGRE=_F(FONCTION=__axa[n],),
                         PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT',);

                      __dex[n]=CALC_FONCTION(INTEGRE=_F(FONCTION=__vix[n],),
                         PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT',);

                    DETRUIRE(CONCEPT=_F(NOM=(
                                       __fthr,
                                       )), INFO = 1)

                __axaX[k] = __axa[0]
                __axaY[k] = __axa[1]
                __axaZ[k] = __axa[2]
                if ldevi == 'OUI':
                  __vixX[k] = __vix[0]
                  __vixY[k] = __vix[1]
                  __vixZ[k] = __vix[2]
                  __dexX[k] = __dex[0]
                  __dexY[k] = __dex[1]
                  __dexZ[k] = __dex[2]

                __ftepYY = RECU_FONCTION(
                GROUP_MA=__TMAT['M', k], RESULTAT=__DYNHARM, NOM_CHAM='EPSI_ELGA', POINT=1, NOM_CMP='EPYY', INTERPOL='LIN',
                PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT')
                __ftepXY = RECU_FONCTION(
                GROUP_MA=__TMAT['M', k], RESULTAT=__DYNHARM, NOM_CHAM='EPSI_ELGA', POINT=1, NOM_CMP='EPXY', INTERPOL='LIN',
                PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT')
                __ftepYZ = RECU_FONCTION(
                GROUP_MA=__TMAT['M', k], RESULTAT=__DYNHARM, NOM_CHAM='EPSI_ELGA', POINT=1, NOM_CMP='EPYZ', INTERPOL='LIN',
                PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT')

                #onde P (YY) : signal Y, n=1
                #onde SV (XY) : signal X, n=0
                #onde SH (YZ): signal Z, n=2
                if args['CHARGEMENT'] == 'ONDE_PLANE':
                  if input == 'CL':
                    __ephYY = CALC_FONCTION(
                      MULT=(_F(FONCTION=__FDT_RACL[1],), _F(FONCTION=__ftepYY,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                    __ephXY = CALC_FONCTION(
                      MULT=(_F(FONCTION=__FDT_RACL[0],), _F(FONCTION=__ftepXY,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                    __ephYZ = CALC_FONCTION(
                      MULT=(_F(FONCTION=__FDT_RACL[2],), _F(FONCTION=__ftepYZ,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                  if input == 'RA':
                    __ephYY = CALC_FONCTION(
                      MULT=(_F(FONCTION=__ftepYY,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                    __ephXY = CALC_FONCTION(
                      MULT=(_F(FONCTION=__ftepXY,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                    __ephYZ = CALC_FONCTION(
                      MULT=(_F(FONCTION=__ftepYZ,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                else:
                  __ephYY = CALC_FONCTION(
                    MULT=(_F(FONCTION=__AHX_RA[1],), _F(FONCTION=__ftepYY,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                  __ephXY = CALC_FONCTION(
                    MULT=(_F(FONCTION=__AHX_RA[0],), _F(FONCTION=__ftepXY,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)
                  __ephYZ = CALC_FONCTION(
                    MULT=(_F(FONCTION=__AHX_RA[2],), _F(FONCTION=__ftepYZ,), _F(FONCTION=__FILTRE,)), LIST_PARA=__lfreq, NOM_PARA='FREQ',)


                __ephYYt = CALC_FONCTION(
                    FFT=_F(FONCTION=__ephYY, METHODE='COMPLET', SYME='NON',),PROL_DROITE='CONSTANT',)
                __ephXYt = CALC_FONCTION(
                    FFT=_F(FONCTION=__ephXY, METHODE='COMPLET', SYME='NON',),PROL_DROITE='CONSTANT',)
                __ephYZt = CALC_FONCTION(
                    FFT=_F(FONCTION=__ephYZ, METHODE='COMPLET', SYME='NON',),PROL_DROITE='CONSTANT',)

                __epsXYt = epeq(__ephYYt,__ephXYt,__ephYZt)
                __epxy[k] = CALC_FONCTION(
                    LIST_PARA=__linst, COMB=(_F(FONCTION=__epsXYt, COEF=1.0,),
                                             ),)

                __eph = CALC_FONCTION(
                    FFT=_F(FONCTION=__epxy[k], METHODE='COMPLET',),PROL_DROITE='CONSTANT',)

                DETRUIRE(CONCEPT=_F(NOM=(__ephYYt, __ephXYt,
                                         __ephYZt,
                                         __epsXYt,
                          )), INFO = 1)

                coef = (2./3.)*nsqrt(3.)
                __gam[k] = CALC_FONCTION(
                    LIST_PARA=__linst, COMB=(_F(FONCTION=__epxy[k], COEF=coef,),
                    #LIST_PARA=__linst, COMB=(_F(FONCTION=__epxy[k], COEF=2.0,),
                                             ),)

                # coef = (1/3)*np.sqrt(3)
                if formulation == 'LYSMER':
                  f2Getoil = (1./nsqrt(3.))*E[iter][k] / (1+ __TMAT['NU',k]) * (1.-AH[iter][k]*AH[iter][k]/2 + (AH[iter][k]*sqrt(1-AH[iter][k]*AH[iter][k]/4))*1.j) ;
                  #f2Getoil = 1.0*E[iter][k] / (1+ __TMAT['NU',k]) * (1.-AH[iter][k]*AH[iter][k]/2 + (AH[iter][k]*sqrt(1-AH[iter][k]*AH[iter][k]/4))*1.j) ;
                else:
                  f2Getoil = (1./np.sqrt(3.))*(E[iter][k] / (1+ __TMAT['NU',k]) ) * (1.+ (AH[iter][k])*1.j);
                  #f2Getoil = 1.0*(E[iter][k] / (1+ __TMAT['NU',k]) ) * (1.+ (AH[iter][k])*1.j);

                __qh = CALC_FONCTION(COMB_C=_F(FONCTION=__eph,COEF_C = f2Getoil),LIST_PARA=__lfreq,NOM_PARA='FREQ',);

                __tau[k] = CALC_FONCTION(FFT=_F(FONCTION=__qh,METHODE='COMPLET',SYME='NON',),PROL_DROITE='CONSTANT',);

                __gama = CALC_FONCTION(ABS=_F(FONCTION=__gam[k]))
                mgam = max(__gama.Ordo())

                lmaccxX.append(maccx[0] / 9.81)
                lmaccxY.append(maccx[1] / 9.81)
                lmaccxZ.append(maccx[2] / 9.81)
                gamax.append(mgam)

                DETRUIRE(CONCEPT=_F(NOM=(__gama,
                                         __eph,
                                         __qh,
                                         __ephYY,__ephYZ,__ephXY,
                                         __ftepYY,__ftepYZ,__ftepXY,
                                         )), INFO = 1)

            #===================================
            # APPLICATION DE LA FONCTION BYRNE
            #===================================
            if Byrne:
                Ru,EpsiV,instant = fByrne(__gam[k].Absc(),__gam[k].Ordo(),__TMAT['E0', k],
                                        __TMAT['NU', k],__TMAT['Y', k],__TMAT['RHO', k],__TMAT['N1', k],)

                rumax.append(max(Ru))
                evmax.append(max(EpsiV))

                __ru[k] = DEFI_FONCTION(NOM_PARA='INST', NOM_RESU='RU',
                                    ORDONNEE=tuple(Ru),
                                    ABSCISSE=tuple(instant,),
                                    PROL_DROITE='CONSTANT',
                                    PROL_GAUCHE='CONSTANT',)

                __ev[k] = DEFI_FONCTION(NOM_PARA='INST', NOM_RESU='EV',
                                     ORDONNEE=tuple(EpsiV),
                                     ABSCISSE=tuple(instant,),
                                     PROL_DROITE='CONSTANT',
                                     PROL_GAUCHE='CONSTANT',)

        # construction des profils
        __paccx = [None] * num_dime
        if dime == "2D":
            __paccx[0] = DEFI_FONCTION(NOM_PARA='Y', NOM_RESU='accxmax',
                                    ORDONNEE=tuple(lmaccx),
                                    ABSCISSE=tuple(lprof,))
        elif dime == "3D":
            __paccx[0] = DEFI_FONCTION(NOM_PARA='Y', NOM_RESU='accmax' + name_dime[0],
                                        ORDONNEE=tuple(lmaccxX),
                                        ABSCISSE=tuple(lprof,))
            __paccx[1] = DEFI_FONCTION(NOM_PARA='Y', NOM_RESU='accmax' + name_dime[1],
                                        ORDONNEE=tuple(lmaccxY),
                                        ABSCISSE=tuple(lprof,))
            __paccx[2] = DEFI_FONCTION(NOM_PARA='Y', NOM_RESU='accmax' + name_dime[2],
                                        ORDONNEE=tuple(lmaccxZ),
                                        ABSCISSE=tuple(lprof,))

        __pgamax = DEFI_FONCTION(NOM_PARA='Y', NOM_RESU='gamma_max',
                                     ORDONNEE=tuple(gamax),
                                     ABSCISSE=tuple(lprof,))

        if Byrne:
            __prumax = DEFI_FONCTION(NOM_PARA='Y', NOM_RESU='ru_max',
                                    ORDONNEE=tuple(rumax),
                                    ABSCISSE=tuple(lprof,))

            __pevmax = DEFI_FONCTION(NOM_PARA='Y', NOM_RESU='ev_max',
                                     ORDONNEE=tuple(evmax),
                                     ABSCISSE=tuple(lprof,))

        # Lecture sur les courbes G/Gmax et D
        ind = []
        diff = []

        iter = iter + 1

        ind = []
        diff = []

        E[iter] = [] * (NCOU + 2)
        AH[iter] = [] * (NCOU + 2)
        rat[iter] = [] * (NCOU + 2)

        E[iter].append(0)
        AH[iter].append(0)
        rat[iter].append(1)

        ind.append(0)
        diff.append(0)
#--------------------------------CALCUL G ------------------------------
        for k in range(1, NCOU + 1):

            ind.append(__TMAT['GDgam', k])
            if Byrne :
                if rumax[k]>0.95:                          #condition dans le cas de la liquefaction pour avoir un G résiduel non nul
                   rat[iter].append(0.05)
                else:
                 rat[iter].append(__GG[ind[k]](geff * gamax[k])*(1-(xsieff*rumax[k]))**0.5)

            else:
                rat[iter].append(__GG[ind[k]](geff * gamax[k]))

            AH[iter].append(2 * __DG[ind[k]](geff * gamax[k]))

            E[iter].append((rat[iter][k]) * __TMAT['E0', k])

            diff.append(
                abs(((E[iter - 1][k]) - (E[iter][k]))) / (E[iter - 1][k]))

        AH[iter].append(__TMAT['AH0', NCOU + 1])
        E[iter].append(__TMAT['E0', NCOU + 1])

        deltaE = max(max(diff), abs(min(diff)))

        text = ('deltaE=' + str(deltaE))
        aster.affiche('MESSAGE', text)

        __Enew = DEFI_FONCTION(NOM_PARA='Y', NOM_RESU='DX',
                               ORDONNEE=tuple(E[iter]),
                               ABSCISSE=tuple(lprof2,))

        __AHnew = DEFI_FONCTION(NOM_PARA='Y', NOM_RESU='DX',
                                ORDONNEE=tuple(AH[iter]),
                                ABSCISSE=tuple(lprof2,))

        __rGnew = DEFI_FONCTION(NOM_PARA='Y', NOM_RESU='G/Gmax',
                                ORDONNEE=tuple(rat[iter]),
                                ABSCISSE=tuple(lprof,))

        __rGold = DEFI_FONCTION(NOM_PARA='Y', NOM_RESU='G/Gmax',
                                ORDONNEE=tuple(rat[iter - 1]),
                                ABSCISSE=tuple(lprof,))

        if deltaE > tole:
            if iter == nmaxit:
                etat = 'fin'

            else:

              __TEnew = CREA_TABLE(FONCTION=_F(FONCTION=__Enew),)
              __TAHnew = CREA_TABLE(FONCTION=_F(FONCTION=__AHnew),)

              __TEnew = CALC_TABLE(reuse=__TEnew, TABLE=__TEnew,
                                     ACTION=_F(OPERATION='RENOMME', NOM_PARA=('DX', ('E' + str(iter)))))

              __TAHnew = CALC_TABLE(reuse=__TAHnew, TABLE=__TAHnew,
                                      ACTION=_F(OPERATION='RENOMME', NOM_PARA=('DX', ('AH' + str(iter)))))

              __TMAT = CALC_TABLE(reuse=__TMAT, TABLE=__TMAT,
                                    ACTION=(
                                    _F(OPERATION='COMB',
                                       TABLE=__TEnew, NOM_PARA='Y'),
                                    _F(OPERATION='COMB',
                                       TABLE=__TAHnew, NOM_PARA='Y'),
                                    ))
              if 'DSP' in args:
                DETRUIRE(CONCEPT=_F(NOM=(
                    __NUMEDDL, __RIGIHYST, __RIGH_ELH, __RIGIDITE,
                    __SOLHSUBS, __CHAMPMAH, __RIGI_ELH, __MASS_ELH, __MASSEH, __AMOR_ELH, __AMORTIH,
                    __VECASX, __DYNHARM,
                    __PAX_RA, __PAX_CL,
                    __PAX_BH,
                    __pgamax,
                    __rGnew, __rGold,
                    __Enew, __AHnew, __TEnew, __TAHnew,
                ),), INFO = 1)
                for n in range(num_dime):
                    DETRUIRE(CONCEPT=_F(NOM=(
                    __ONDEX[n],
                    __formFDT[n], __FDT_RACL[n], __mFDTRACL[n],
                    __formFDT2[n], __FDT_CLBH[n], __mFDTCLBH[n],
                    __AHuXrCL[n], __AHuXrBH[n], __mAHuXrCL[n], __mAHuXrBH[n],
                    __AHX_RA[n], __SAX_RA[n],
                    __AHXrCL[n], __SAX_CL[n],
                    __paccx[n],
                ),), INFO = 1)

              else:
                DETRUIRE(CONCEPT=_F(NOM=(
                    __NUMEDDL, __RIGIHYST, __RIGH_ELH, __RIGIDITE,
                    __SOLHSUBS, __CHAMPMAH, __RIGI_ELH, __MASS_ELH, __MASSEH, __AMOR_ELH, __AMORTIH,
                    __VECASX, __DYNHARM,
                    __pgamax,
                    __rGnew, __rGold,
                    __Enew, __AHnew, __TEnew, __TAHnew,
                  ),), INFO = 1)

                for n in range(num_dime):
                    DETRUIRE(CONCEPT=_F(NOM=(
                    __ONDEX[n],
                    __formFDT[n], __FDT_RACL[n], __mFDTRACL[n],
                    __formFDT2[n], __FDT_CLBH[n], __mFDTCLBH[n],
                    __AHuXrCL[n], __AHuXrBH[n], __mAHuXrCL[n], __mAHuXrBH[n],
                    __AHX_RA[n], __AX_RA[n], __SAX_RA[n],
                    __AX_CL[n], __AHXrCL[n], __AXrCL[n], __SAX_CL[n],
                    __AX_BH[n], __AHXrBH[n], __AXrBH[n], __SAX_BH[n],
                    __paccx[n],
                ),), INFO = 1)

              if args['CHARGEMENT'] == 'ONDE_PLANE':
                DETRUIRE(CONCEPT=_F(NOM=(
                    __CHA_ON, __CHAONF,
                  ),), INFO = 1)

              for k in range(1, NCOU + 1):
                    DETRUIRE(
                        CONCEPT=_F(NOM=(__SOLH[k], __gam[k], __tau[k]),), INFO = 1)
                    if 'DSP' not in args:
                        DETRUIRE( CONCEPT=_F(NOM=( __epxy[k],),), )
                        if dime == "2D" :
                          if ldevi == 'OUI':
                            DETRUIRE( CONCEPT=_F(NOM=(__foy[k],),), )

              if dime == "2D":
                for k in range(1, NCOU + 1):
                    DETRUIRE(
                        CONCEPT=_F(NOM=(__axa[k] ),), INFO = 1)
              elif dime == "3D":
                for k in range(num_dime):
                    DETRUIRE(
                        CONCEPT=_F(NOM=(__axa[k],  ),), INFO = 1)

        if deltaE < tole:
            etat = 'fin'

        if etat == 'fin':

            __tabred = CREA_TABLE(FONCTION=_F(FONCTION=__rGold),)
            __tabgam = CREA_TABLE(FONCTION=_F(FONCTION=__pgamax),)

            if Byrne:
                __tabru = CREA_TABLE(FONCTION=_F(FONCTION=__prumax),)      #ajout des profils de rumax et ev max dans le fichier resu / unite=39
                __tabev = CREA_TABLE(FONCTION=_F(FONCTION=__pevmax),)

            if dime == "2D":
                __tabacc = CREA_TABLE(FONCTION=_F(FONCTION=__paccx[0]),)
            elif dime == "3D":
                __tabaccX = CREA_TABLE(FONCTION=_F(FONCTION=__paccx[0]),)
                __tabaccY = CREA_TABLE(FONCTION=_F(FONCTION=__paccx[1]),)
                __tabaccZ = CREA_TABLE(FONCTION=_F(FONCTION=__paccx[2]),)
            const_context = {'ca': ca, 'aamult': aamult, 'abmult': abmult}
            __fAB = FORMULE(NOM_PARA=('AHfin'), VALE = 'ca*abmult*AHfin',
                **const_context)
            __fAA = FORMULE(NOM_PARA=('AHfin'), VALE = 'ca*aamult*AHfin',
                **const_context)
            __fEf = FORMULE(NOM_PARA=('Efin'), VALE = 'Efin',
                **const_context)
            __fAHf = FORMULE(NOM_PARA=('AHfin'), VALE = 'AHfin',
                **const_context)
            __fGf = FORMULE(NOM_PARA=('Efin','NU'), VALE = 'Efin/(2.0*(1+NU))',
                **const_context)
            __fVSf = FORMULE(NOM_PARA=('Efin','NU','RHO'),
                VALE = 'sqrt(Efin/(2.0*(1+NU)*RHO))',
                **const_context)
            __fVPf = FORMULE(NOM_PARA=('Efin','NU','RHO'),
                VALE = 'sqrt(Efin*(1-NU)/((1-2.0*NU)*(1+NU)*RHO))',
                **const_context)

            act_table = []
            act_table.append(_F(OPERATION='COMB',
                                TABLE=__tabred, NOM_PARA='Y'),)
            act_table.append(_F(OPERATION='COMB',
                                TABLE=__tabgam, NOM_PARA='Y'),)
            if dime == "2D":
                act_table.append(_F(OPERATION='COMB',
                                    TABLE=__tabacc, NOM_PARA='Y'),)
            elif dime == "3D":
                act_table.append(_F(OPERATION='COMB',
                                   TABLE=__tabaccX, NOM_PARA='Y'),)
                act_table.append(_F(OPERATION='COMB',
                                   TABLE=__tabaccY, NOM_PARA='Y'),)
                act_table.append(_F(OPERATION='COMB',
                                   TABLE=__tabaccZ, NOM_PARA='Y'),)
            if Byrne:
                act_table.append(_F(OPERATION='COMB',
                                    TABLE=__tabru, NOM_PARA='Y'),)
                act_table.append(_F(OPERATION='COMB',
                                    TABLE=__tabev, NOM_PARA='Y'),),
            act_table.append(_F(OPERATION='RENOMME', NOM_PARA=(
                               ('E' + str(iter - 1)), 'Efin'),),)
            act_table.append(_F(OPERATION='RENOMME', NOM_PARA=(
                               ('AH' + str(iter - 1)), 'AHfin'),),)
            act_table.append(_F(OPERATION = 'OPER',
                                FORMULE=__fAA, NOM_PARA = 'AAfin',),)
            act_table.append(_F(OPERATION = 'OPER',
                                FORMULE=__fAB, NOM_PARA = 'ABfin',),)
            act_table.append(_F(OPERATION = 'OPER',
                                FORMULE=__fGf, NOM_PARA = 'Gfin',),)
            act_table.append(_F(OPERATION = 'OPER',
                                FORMULE=__fVSf, NOM_PARA = 'VSfin',),)
            act_table.append(_F(OPERATION = 'OPER',
                                FORMULE=__fVPf, NOM_PARA = 'VPfin',),)

            __TMAT = CALC_TABLE(reuse=__TMAT, TABLE=__TMAT,
                                ACTION=act_table)

            if dime == "2D":
                DETRUIRE(
                CONCEPT=_F(NOM=(__tabacc),))
            elif dime == "3D":
                DETRUIRE(
                CONCEPT=_F(NOM=(__tabaccX,__tabaccY,__tabaccZ,),))

            if iter == 1 :
              __TMAT = CALC_TABLE(reuse=__TMAT, TABLE=__TMAT,
                            ACTION=(
                                    _F(OPERATION = 'OPER',
                                       FORMULE=__fEf, NOM_PARA = 'E0',),
                                    _F(OPERATION = 'OPER',
                                       FORMULE=__fAHf, NOM_PARA = 'AH0',),
                                ))

            DETRUIRE(
                CONCEPT=_F(NOM=(__tabred, __tabgam, __fAA, __fAB),))
            # Recuperation des historiques d acceleration et deformation dans
            # chaque couche

            if dime == "2D":
                __SPEC = [None] * (NCOU + 1)
            elif dime == "3D":
                __SPECX = [None] * (NCOU + 1)
                __SPECY = [None] * (NCOU + 1)
                __SPECZ = [None] * (NCOU + 1)

            __SPEC = [None] * (NCOU + 1)

            for k in range(1, NCOU + 1):
                if dime == "2D":
                    if 'DSP' in args:
                      if args['LIST_FREQ_SPEC_OSCI'] is not None:
                        __SPEC[k] = CALC_FONCTION(
                            SPEC_OSCI=_F(FONCTION=__paxa[k], AMOR_REDUIT=0.05,
                            LIST_FREQ=args['LIST_FREQ_SPEC_OSCI'],NORME=9.81))
                      else:
                        __SPEC[k] = CALC_FONCTION(
                            SPEC_OSCI=_F(FONCTION=__paxa[k], AMOR_REDUIT=0.05,  NORME=9.81))
                    else:
                      if args['LIST_FREQ_SPEC_OSCI'] is not None:
                        __SPEC[k] = CALC_FONCTION(
                            SPEC_OSCI=_F(FONCTION=__axa[k],AMOR_REDUIT=0.05,LIST_FREQ=args['LIST_FREQ_SPEC_OSCI'],NORME=9.81))
                      else:
                        __SPEC[k] = CALC_FONCTION(
                            SPEC_OSCI=_F(FONCTION=__axa[k], AMOR_REDUIT=0.05, NORME=9.81))

                elif dime == "3D":
                    if args['LIST_FREQ_SPEC_OSCI'] is not None:
                          __SPECX[k] = CALC_FONCTION(
                            SPEC_OSCI=_F(FONCTION=__axaX[k],AMOR_REDUIT=0.05,LIST_FREQ=args['LIST_FREQ_SPEC_OSCI'],NORME=9.81))
                          __SPECY[k] = CALC_FONCTION(
                            SPEC_OSCI=_F(FONCTION=__axaY[k],AMOR_REDUIT=0.05,LIST_FREQ=args['LIST_FREQ_SPEC_OSCI'],NORME=9.81))
                          __SPECZ[k] = CALC_FONCTION(
                            SPEC_OSCI=_F(FONCTION=__axaZ[k],AMOR_REDUIT=0.05,LIST_FREQ=args['LIST_FREQ_SPEC_OSCI'],NORME=9.81))
                    else:
                          __SPECX[k] = CALC_FONCTION(
                            SPEC_OSCI=_F(FONCTION=__axaX[k], AMOR_REDUIT=0.05, NORME=9.81))
                          __SPECY[k] = CALC_FONCTION(
                            SPEC_OSCI=_F(FONCTION=__axaY[k], AMOR_REDUIT=0.05, NORME=9.81))
                          __SPECZ[k] = CALC_FONCTION(
                            SPEC_OSCI=_F(FONCTION=__axaZ[k], AMOR_REDUIT=0.05, NORME=9.81))

            if veriftmp == 'NON':

                for n in range(num_dime):

                    IMPR_FONCTION(UNITE=6,
                                  FORMAT='TABLEAU',
                                  TITRE='Spectre CL et RA - input =' + input,
                                  COURBE=(
                                  _F(FONCTION=__SAX_CL[n], MARQUEUR=0.,
                                     LEGENDE='SAX_CL' + name_dime[n] + legende + 'deltaE =' + str(deltaE),),
                                  _F(FONCTION=__SAX_RA[n], MARQUEUR=0.,
                                     LEGENDE='SAX_RA' + name_dime[n] + legende + 'deltaE =' + str(deltaE),),
                                  ))

            IMPR_TABLE(UNITE=utabresu, TABLE=__TMAT, SEPARATEUR=args['SEPARATEUR'],FORMAT_R='E13.7',
                           TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                   Les valeurs max sont calculees au 1er Point de Gauss de la couche definie par sa cote inferieure Y'),
                           )

            if dime == "2D" :
                ifacc = []
                if 'DSP' in args:
                  ifacc.append(
                    _F(FONCTION=__AHX_CL, MARQUEUR=0, LEGENDE='AX_CL' + legende + 'deltaE =' + str(deltaE)),)
                  ifacc.append(
                    _F(FONCTION=__AHX_RA[0], MARQUEUR=0, LEGENDE='AX_RA' + legende + 'deltaE =' + str(deltaE)),)
                else:
                  ifacc.append(
                    _F(FONCTION=__AX_CL[0], MARQUEUR=0, LEGENDE='AX_CL' + legende + 'deltaE =' + str(deltaE)),)
                  ifacc.append(
                    _F(FONCTION=__AX_RA[0], MARQUEUR=0, LEGENDE='AX_RA' + legende + 'deltaE =' + str(deltaE)),)

                for d in range(1, NCOU + 1):
                    ifacc.append(
                        _F(FONCTION=__axa[d], MARQUEUR=0, LEGENDE='AX_' + str(d) + legende + 'deltaE =' + str(deltaE)),)

                if 'DSP' in args:
                  ifacc.append(
                        _F(FONCTION=__AHX_BH, MARQUEUR=0, LEGENDE='AX_BH' + legende + 'deltaE =' + str(deltaE)),)
                else:
                  ifacc.append(
                        _F(FONCTION=__AX_BH[0], MARQUEUR=0, LEGENDE='AX_BH' + legende + 'deltaE =' + str(deltaE)),)

                IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                   Les acce max sont calculees a la base de la couche definie par sa cote inferieure Y'),
                              COURBE=(ifacc
                                      ))

                if ldevi == 'OUI':
                  ifvit = []
                  ifdep = []

                  ifvit.append(
                    _F(FONCTION=__VX_CL[0], MARQUEUR=0, LEGENDE='VX_CL' + legende + 'deltaE =' + str(deltaE)),)
                  ifvit.append(
                    _F(FONCTION=__VX_RA[0], MARQUEUR=0, LEGENDE='VX_RA' + legende + 'deltaE =' + str(deltaE)),)

                  for d in range(1, NCOU + 1):
                    ifvit.append(
                        _F(FONCTION=__vix[d], MARQUEUR=0, LEGENDE='VX_' + str(d) + legende + 'deltaE =' + str(deltaE)),)

                  ifvit.append(
                        _F(FONCTION=__VX_BH[0], MARQUEUR=0, LEGENDE='VX_BH' + legende + 'deltaE =' + str(deltaE)),)

                  IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                   Les vitesses sont calculees a la base de la couche definie par sa cote inferieure Y'),
                              COURBE=(ifvit
                                      ))
                  ifdep.append(
                    _F(FONCTION=__DX_CL[0], MARQUEUR=0, LEGENDE='DX_CL' + legende + 'deltaE =' + str(deltaE)),)
                  ifdep.append(
                    _F(FONCTION=__DX_RA[0], MARQUEUR=0, LEGENDE='DX_RA' + legende + 'deltaE =' + str(deltaE)),)

                  for d in range(1, NCOU + 1):
                    ifdep.append(
                        _F(FONCTION=__dex[d], MARQUEUR=0, LEGENDE='DX_' + str(d) + legende + 'deltaE =' + str(deltaE)),)

                  ifdep.append(
                        _F(FONCTION=__DX_BH[0], MARQUEUR=0, LEGENDE='DX_BH' + legende + 'deltaE =' + str(deltaE)),)

                  IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                   Les deplacements sont calcules a la base de la couche definie par sa cote inferieure Y'),
                              COURBE=(ifdep
                                      ))
                ifgam = []

                for d in range(1, NCOU + 1):
                    ifgam.append(
                        _F(FONCTION=__gam[d], MARQUEUR=0, LEGENDE='GAM_' + str(d) + legende + 'deltaE =' + str(deltaE)),)

                IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                Les valeurs max sont calculees au 1er Point de Gauss de la couche definie par sa cote inferieure Y'),
                              COURBE=(ifgam
                                      ))
                iftau = []

                for d in range(1, NCOU + 1):
                    iftau.append(
                        _F(FONCTION=__tau[d], MARQUEUR=0, LEGENDE='TAU_' + str(d) + legende + 'deltaE =' + str(deltaE)),)

                IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                Les valeurs max sont calculees au 1er Point de Gauss de la couche definie par sa cote inferieure Y'),
                              COURBE=(iftau
                                      ))
                if ldevi == 'OUI':
                  iffoy = []
                  iffoy.append(
                    _F(FONCTION=__FX_CL[0], MARQUEUR=0, LEGENDE='FY_CL' + legende + 'deltaE =' + str(deltaE)),)

                  for d in range(1, NCOU + 1):
                    iffoy.append(
                        _F(FONCTION=__foy[d], MARQUEUR=0, LEGENDE='FY_' + str(d) + legende + 'deltaE =' + str(deltaE)),)

                  iffoy.append(
                    _F(FONCTION=__FX_BH[0], MARQUEUR=0, LEGENDE='FY_BH' + legende + 'deltaE =' + str(deltaE)),)

                  IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                  Les forces sont calculees a la base de la couche definie par sa cote inferieure Y'),
                              COURBE=(iffoy
                                      ))

                if Byrne:
                    ifru = []

                    for d in range(1, NCOU + 1):
                        ifru.append(
                            _F(FONCTION=__ru[d], MARQUEUR=0, LEGENDE='RU_' + str(d) + legende + 'deltaE =' + str(deltaE),),)

                    IMPR_FONCTION(UNITE=utabtran,
                                  FORMAT='TABLEAU',
                                  SOUS_TITRE=titre,
                                  TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                    Les valeurs max sont calculees au 1er Point de Gauss de la couche definie par sa cote inferieure Y'),
                                  COURBE=(ifru
                                          ))

                    ifev = []

                    for d in range(1, NCOU + 1):
                        ifev.append(
                            _F(FONCTION=__ev[d], MARQUEUR=0, LEGENDE='EV_' + str(d) + legende + 'deltaE =' + str(deltaE)),)

                    IMPR_FONCTION(UNITE=utabtran,
                                  FORMAT='TABLEAU',
                                  SOUS_TITRE=titre,
                                  TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                    Les valeurs max sont calculees au 1er Point de Gauss de la couche definie par sa cote inferieure Y'),
                                  COURBE=(ifev
                                          ))

            if dime == "2D" :
                ifspec = []

                ifspec.append(
                    _F(FONCTION=__SAX_CL[0], MARQUEUR=0, LEGENDE='SAX_CL' + legende + 'deltaE =' + str(deltaE)),)
                ifspec.append(
                    _F(FONCTION=__SAX_RA[0], MARQUEUR=0, LEGENDE='SAX_RA' + legende + 'deltaE =' + str(deltaE)),)

                for d in range(1, NCOU + 1):
                    ifspec.append(
                        _F(FONCTION=__SPEC[d], MARQUEUR=0, LEGENDE='SAX_' + str(d) + legende + 'deltaE =' + str(deltaE)),)

                ifspec.append(
                        _F(FONCTION=__SAX_BH[0], MARQUEUR=0, LEGENDE='SAX_BH' + legende + 'deltaE =' + str(deltaE)),)

                IMPR_FONCTION(UNITE=utabspec,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE='Spectres CL et RA et ppt - input =' + input,
                              COURBE=(ifspec
                                      ))

                IMPR_FONCTION(UNITE=utabspec,
                          FORMAT='TABLEAU',
                          TITRE='Fonctions de Transfert entre CL et RA et Module des FFT',
                          COURBE=(_F(FONCTION=__FDT_RACL[0]),
                                  _F(FONCTION=__mFDTRACL[0]),
                                 ) )

                if 'DSP' in args:
                  ifdsp = []

                  ifdsp.append(
                      _F(FONCTION=__PAX_CL, MARQUEUR=0, LEGENDE='DSP_CL' + legende + 'deltaE =' + str(deltaE)),)
                  ifdsp.append(
                      _F(FONCTION=__PAX_RA, MARQUEUR=0, LEGENDE='DSP_RA' + legende + 'deltaE =' + str(deltaE)),)

                  ifdsp.append(
                    _F(FONCTION=__PAX_BH, MARQUEUR=0, LEGENDE='DSP_BH' + legende + 'deltaE =' + str(deltaE)),)

                  IMPR_FONCTION(UNITE=utabdsp,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE='DSP CL et RA et ppt - input =' + input,
                              COURBE=(ifdsp
                                      ))
            elif dime == "3D":
                ifaccX = []
                ifaccY = []
                ifaccZ = []

                ifaccX.append(
                    _F(FONCTION=__AX_CL[0], MARQUEUR=0, LEGENDE='AX_CL' + name_dime[0] + legende + 'deltaE =' + str(deltaE)),)
                ifaccX.append(
                    _F(FONCTION=__AX_RA[0], MARQUEUR=0, LEGENDE='AX_RA' + name_dime[0] + legende + 'deltaE =' + str(deltaE)),)

                for d in range(1, NCOU + 1):
                    ifaccX.append(
                        _F(FONCTION=__axaX[d], MARQUEUR=0, LEGENDE='AX_' + str(d) + name_dime[0] + legende + 'deltaE =' + str(deltaE)),)

                ifaccX.append(
                        _F(FONCTION=__AX_BH[0], MARQUEUR=0, LEGENDE='AX_BH' + name_dime[0] + legende + 'deltaE =' + str(deltaE)),)

                ifaccY.append(
                    _F(FONCTION=__AX_CL[1], MARQUEUR=0, LEGENDE='AX_CL' + name_dime[1] + legende + 'deltaE =' + str(deltaE)),)
                ifaccY.append(
                    _F(FONCTION=__AX_RA[1], MARQUEUR=0, LEGENDE='AX_RA' + name_dime[1] + legende + 'deltaE =' + str(deltaE)),)

                for d in range(1, NCOU + 1):
                    ifaccY.append(
                        _F(FONCTION=__axaY[d], MARQUEUR=0, LEGENDE='AX_' + str(d) + name_dime[1] + legende + 'deltaE =' + str(deltaE)),)

                ifaccY.append(
                        _F(FONCTION=__AX_BH[1], MARQUEUR=0, LEGENDE='AX_BH' + name_dime[1] + legende + 'deltaE =' + str(deltaE)),)

                ifaccZ.append(
                    _F(FONCTION=__AX_CL[2], MARQUEUR=0, LEGENDE='AX_CL' + name_dime[2] + legende + 'deltaE =' + str(deltaE)),)
                ifaccZ.append(
                    _F(FONCTION=__AX_RA[2], MARQUEUR=0, LEGENDE='AX_RA' + name_dime[2] + legende + 'deltaE =' + str(deltaE)),)

                for d in range(1, NCOU + 1):
                    ifaccZ.append(
                        _F(FONCTION=__axaZ[d], MARQUEUR=0, LEGENDE='AX_' + str(d) + name_dime[2] + legende + 'deltaE =' + str(deltaE)),)

                ifaccZ.append(
                        _F(FONCTION=__AX_BH[2], MARQUEUR=0, LEGENDE='AX_BH' + name_dime[2] + legende + 'deltaE =' + str(deltaE)),)


                if ldevi == 'OUI':
                  ifvitX = []
                  ifdepX = []
                  ifvitY = []
                  ifdepY = []
                  ifvitZ = []
                  ifdepZ = []
                  ifvitX.append(
                    _F(FONCTION=__VX_CL[0], MARQUEUR=0, LEGENDE='VX_CL' + name_dime[0] + legende + 'deltaE =' + str(deltaE)),)
                  ifvitX.append(
                    _F(FONCTION=__VX_RA[0], MARQUEUR=0, LEGENDE='VX_RA' + name_dime[0] + legende + 'deltaE =' + str(deltaE)),)

                  for d in range(1, NCOU + 1):
                      ifvitX.append(
                        _F(FONCTION=__vixX[d], MARQUEUR=0, LEGENDE='VX_' + str(d) + name_dime[0] + legende + 'deltaE =' + str(deltaE)),)

                  ifvitX.append(
                        _F(FONCTION=__VX_BH[0], MARQUEUR=0, LEGENDE='VX_BH' + name_dime[0] + legende + 'deltaE =' + str(deltaE)),)

                  ifvitY.append(
                    _F(FONCTION=__VX_CL[1], MARQUEUR=0, LEGENDE='VX_CL' + name_dime[1] + legende + 'deltaE =' + str(deltaE)),)
                  ifvitY.append(
                    _F(FONCTION=__VX_RA[1], MARQUEUR=0, LEGENDE='VX_RA' + name_dime[1] + legende + 'deltaE =' + str(deltaE)),)

                  for d in range(1, NCOU + 1):
                      ifvitY.append(
                        _F(FONCTION=__vixY[d], MARQUEUR=0, LEGENDE='VX_' + str(d) + name_dime[1] + legende + 'deltaE =' + str(deltaE)),)

                  ifvitY.append(
                        _F(FONCTION=__VX_BH[1], MARQUEUR=0, LEGENDE='VX_BH' + name_dime[1] + legende + 'deltaE =' + str(deltaE)),)

                  ifvitZ.append(
                    _F(FONCTION=__VX_CL[2], MARQUEUR=0, LEGENDE='VX_CL' + name_dime[2] + legende + 'deltaE =' + str(deltaE)),)
                  ifvitZ.append(
                    _F(FONCTION=__VX_RA[2], MARQUEUR=0, LEGENDE='VX_RA' + name_dime[2] + legende + 'deltaE =' + str(deltaE)),)

                  for d in range(1, NCOU + 1):
                      ifvitZ.append(
                        _F(FONCTION=__vixZ[d], MARQUEUR=0, LEGENDE='VX_' + str(d) + name_dime[2] + legende + 'deltaE =' + str(deltaE)),)

                  ifvitZ.append(
                        _F(FONCTION=__VX_BH[2], MARQUEUR=0, LEGENDE='VX_BH' + name_dime[2] + legende + 'deltaE =' + str(deltaE)),)

                  ifdepX.append(
                    _F(FONCTION=__DX_CL[0], MARQUEUR=0, LEGENDE='DX_CL' + name_dime[0] + legende + 'deltaE =' + str(deltaE)),)
                  ifdepX.append(
                    _F(FONCTION=__DX_RA[0], MARQUEUR=0, LEGENDE='DX_RA' + name_dime[0] + legende + 'deltaE =' + str(deltaE)),)

                  for d in range(1, NCOU + 1):
                      ifdepX.append(
                        _F(FONCTION=__dexX[d], MARQUEUR=0, LEGENDE='DX_' + str(d) + name_dime[0] + legende + 'deltaE =' + str(deltaE)),)

                  ifdepX.append(
                        _F(FONCTION=__DX_BH[0], MARQUEUR=0, LEGENDE='DX_BH' + name_dime[0] + legende + 'deltaE =' + str(deltaE)),)

                  ifdepY.append(
                    _F(FONCTION=__DX_CL[1], MARQUEUR=0, LEGENDE='DX_CL' + name_dime[1] + legende + 'deltaE =' + str(deltaE)),)
                  ifdepY.append(
                    _F(FONCTION=__DX_RA[1], MARQUEUR=0, LEGENDE='DX_RA' + name_dime[1] + legende + 'deltaE =' + str(deltaE)),)

                  for d in range(1, NCOU + 1):
                      ifdepY.append(
                        _F(FONCTION=__dexY[d], MARQUEUR=0, LEGENDE='DX_' + str(d) + name_dime[1] + legende + 'deltaE =' + str(deltaE)),)

                  ifdepY.append(
                        _F(FONCTION=__DX_BH[1], MARQUEUR=0, LEGENDE='DX_BH' + name_dime[1] + legende + 'deltaE =' + str(deltaE)),)

                  ifdepZ.append(
                    _F(FONCTION=__DX_CL[2], MARQUEUR=0, LEGENDE='DX_CL' + name_dime[2] + legende + 'deltaE =' + str(deltaE)),)
                  ifdepZ.append(
                    _F(FONCTION=__DX_RA[2], MARQUEUR=0, LEGENDE='DX_RA' + name_dime[2] + legende + 'deltaE =' + str(deltaE)),)

                  for d in range(1, NCOU + 1):
                      ifdepZ.append(
                        _F(FONCTION=__dexZ[d], MARQUEUR=0, LEGENDE='DX_' + str(d) + name_dime[2] + legende + 'deltaE =' + str(deltaE)),)

                  ifdepZ.append(
                        _F(FONCTION=__DX_BH[2], MARQUEUR=0, LEGENDE='DX_BH' + name_dime[2] + legende + 'deltaE =' + str(deltaE)),)

                IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                   Les acce max sont calculees a la base de la couche definie par sa cote inferieure Y'),
                              COURBE=(ifaccX
                                      ))
                if ldevi == 'OUI':
                  IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                     Les vitesses sont calculees a la base de la couche definie par sa cote inferieure Y'),
                              COURBE=(ifvitX
                                      ))
                  IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                     Les deplacements sont calcules a la base de la couche definie par sa cote inferieure Y'),
                              COURBE=(ifdepX
                                      ))
                IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                   Les acce max sont calculees a la base de la couche definie par sa cote inferieure Y'),
                              COURBE=(ifaccY
                                      ))
                if ldevi == 'OUI':
                  IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                     Les vitesses sont calculees a la base de la couche definie par sa cote inferieure Y'),
                              COURBE=(ifvitY
                                      ))
                  IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                     Les deplacements sont calcules a la base de la couche definie par sa cote inferieure Y'),
                              COURBE=(ifdepY
                                      ))
                IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                   Les acce max sont calculees a la base de la couche definie par sa cote inferieure Y'),
                              COURBE=(ifaccZ
                                      ))
                if ldevi == 'OUI':
                  IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                     Les vitesses sont calculees a la base de la couche definie par sa cote inferieure Y'),
                              COURBE=(ifvitZ
                                      ))
                  IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                     Les deplacements sont calcules a la base de la couche definie par sa cote inferieure Y'),
                              COURBE=(ifdepZ
                                      ))
                ifgam = []

                for d in range(1, NCOU + 1):
                    ifgam.append(
                        _F(FONCTION=__gam[d], MARQUEUR=0, LEGENDE='GAM_' + str(d) + legende + 'deltaE =' + str(deltaE)),)

                IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                Les valeurs max sont calculees au 1er Point de Gauss de la couche definie par sa cote inferieure Y'),
                              COURBE=(ifgam
                                      ))
                iftau = []

                for d in range(1, NCOU + 1):
                    iftau.append(
                        _F(FONCTION=__tau[d], MARQUEUR=0, LEGENDE='TAU_' + str(d) + legende + 'deltaE =' + str(deltaE)),)

                IMPR_FONCTION(UNITE=utabtran,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                Les valeurs max sont calculees au 1er Point de Gauss de la couche definie par sa cote inferieure Y'),
                              COURBE=(iftau
                                      ))

                if Byrne:
                    ifru = []

                    for d in range(1, NCOU + 1):
                        ifru.append(
                            _F(FONCTION=__ru[d], MARQUEUR=0, LEGENDE='RU_' + str(d) + legende + 'deltaE =' + str(deltaE)),)

                    IMPR_FONCTION(UNITE=utabtran,
                                  FORMAT='TABLEAU',
                                  SOUS_TITRE=titre,
                                  TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                    Les valeurs max sont calculees au 1er Point de Gauss de la couche definie par sa cote inferieure Y'),
                                  COURBE=(ifru
                                          ))

                    ifev = []

                    for d in range(1, NCOU + 1):
                        ifru.append(
                            _F(FONCTION=__ev[d], MARQUEUR=0, LEGENDE='RU_' + str(d) + legende + 'deltaE =' + str(deltaE)),)

                    IMPR_FONCTION(UNITE=utabtran,
                                  FORMAT='TABLEAU',
                                  SOUS_TITRE=titre,
                                  TITRE=('Resultats du calcul lineaire equivalent pour le sol' + str(s) + 'avec E=' + str(cvar) + '*E0 \
                    Les valeurs max sont calculees au 1er Point de Gauss de la couche definie par sa cote inferieure Y'),
                                  COURBE=(ifev
                                          ))

                ifspecX = []
                ifspecY = []
                ifspecZ = []

                ifspecX.append(
                    _F(FONCTION=__SAX_CL[0], MARQUEUR=0, LEGENDE='SAX_CL' + name_dime[0] + legende + 'deltaE =' + str(deltaE)),)
                ifspecX.append(
                    _F(FONCTION=__SAX_RA[0], MARQUEUR=0, LEGENDE='SAX_RA' + name_dime[0] + legende + 'deltaE =' + str(deltaE)),)
                ifspecY.append(
                    _F(FONCTION=__SAX_CL[1], MARQUEUR=0, LEGENDE='SAX_CL' + name_dime[1] + legende + 'deltaE =' + str(deltaE)),)
                ifspecY.append(
                    _F(FONCTION=__SAX_RA[1], MARQUEUR=0, LEGENDE='SAX_RA' + name_dime[1] + legende + 'deltaE =' + str(deltaE)),)
                ifspecZ.append(
                    _F(FONCTION=__SAX_CL[2], MARQUEUR=0, LEGENDE='SAX_CL' + name_dime[2] + legende + 'deltaE =' + str(deltaE)),)
                ifspecZ.append(
                    _F(FONCTION=__SAX_RA[2], MARQUEUR=0, LEGENDE='SAX_RA' + name_dime[2] + legende + 'deltaE =' + str(deltaE)),)

                for d in range(1, NCOU + 1):
                    ifspecX.append(
                        _F(FONCTION=__SPECX[d], MARQUEUR=0, LEGENDE='SAX_' + str(d) + name_dime[0] + legende + 'deltaE =' + str(deltaE)),)
                    ifspecY.append(
                        _F(FONCTION=__SPECY[d], MARQUEUR=0, LEGENDE='SAX_' + str(d) + name_dime[1] + legende + 'deltaE =' + str(deltaE)),)
                    ifspecZ.append(
                        _F(FONCTION=__SPECZ[d], MARQUEUR=0, LEGENDE='SAX_' + str(d) + name_dime[2] + legende + 'deltaE =' + str(deltaE)),)


                ifspecX.append(
                    _F(FONCTION=__SAX_BH[0], MARQUEUR=0, LEGENDE='SAX_BH' + name_dime[0] + legende + 'deltaE =' + str(deltaE)),)
                ifspecY.append(
                    _F(FONCTION=__SAX_BH[1], MARQUEUR=0, LEGENDE='SAX_BH' + name_dime[1] +legende + 'deltaE =' + str(deltaE)),)
                ifspecZ.append(
                    _F(FONCTION=__SAX_BH[2], MARQUEUR=0, LEGENDE='SAX_BH' + name_dime[2] +legende + 'deltaE =' + str(deltaE)),)

                IMPR_FONCTION(UNITE=utabspec,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE='Spectres CL et RA et ppt - input =' + input + 'direction ' + dire_dime[0],
                              COURBE=(ifspecX
                                      ))
                IMPR_FONCTION(UNITE=utabspec,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE='Spectres CL et RA et ppt - input =' + input + 'direction ' + dire_dime[1],
                              COURBE=(ifspecY
                                      ))
                IMPR_FONCTION(UNITE=utabspec,
                              FORMAT='TABLEAU',
                              SOUS_TITRE=titre,
                              TITRE='Spectres CL et RA et ppt - input =' + input + 'direction ' + dire_dime[2],
                              COURBE=(ifspecZ
                                      ))

            # Destruction de tous les concepts pour permettre une utilisation
            # en INCLUDE dans boucle
       # pour DSP veriftmp = 'NON'
            if veriftmp == 'OUI':

                __SOLR = [None] * (NCOU + 2)

                for j in range(1, NCOU + 1):

                    __SOLR[j] = DEFI_MATERIAU(ELAS=_F(E=__TMAT['Efin', j],
                                                      RHO=__TMAT['RHO', j],
                                                      NU=__TMAT['NU', j],
                                                      AMOR_ALPHA=__TMAT[
                                                          'AAfin', j],
                                                      AMOR_BETA=__TMAT[
                                                          'ABfin', j],
                                                      ))

                __SOLR[NCOU + 1] = DEFI_MATERIAU(
                    ELAS=_F(E=__TMAT['E0', NCOU + 1],
                            RHO=__TMAT['RHO', NCOU + 1],
                            NU=__TMAT['NU', NCOU + 1],
                            ))

                __SOLRSUBS = DEFI_MATERIAU(ELAS=_F(E=__TMAT['E0', NCOU + 1],
                                           RHO=__TMAT['RHO', NCOU + 1],
                                           NU=__TMAT['NU', NCOU + 1],
                                                   ))

            # Boucle pour affectation du materiau j au GROUP_MA 'Mj'

                tSOLR = tuple(__SOLR)

                affmatR = []

                for j in range(1, NCOU + 2):

                    affmatR.append(
                        _F(GROUP_MA=__TMAT['M', j], MATER=tSOLR[j]))

                affmatR.append(_F(GROUP_MA=grma_subst, MATER=__SOLRSUBS))

                __CHAMPMAR = AFFE_MATERIAU(MAILLAGE=__mailla,
                                           AFFE=affmatR,
                                           )

                __RIGI_ELR = CALC_MATR_ELEM(OPTION='RIGI_MECA',
                                            MODELE=__MODELE, CHAM_MATER=__CHAMPMAR, CHARGE=__CON_LIM,)

                __NUMEDDLR = NUME_DDL(MATR_RIGI=__RIGI_ELR,)

                __RIGIDITE = ASSE_MATRICE(
                    MATR_ELEM=__RIGI_ELR, NUME_DDL=__NUMEDDLR,)

                __MASS_ELR = CALC_MATR_ELEM(OPTION='MASS_MECA',
                                            MODELE=__MODELE,
                                            CHAM_MATER=__CHAMPMAR,
                                            CHARGE=__CON_LIM,)

                __MASSER = ASSE_MATRICE(
                    MATR_ELEM=__MASS_ELR, NUME_DDL=__NUMEDDLR,)

                __AMOR_ELR = CALC_MATR_ELEM(OPTION='AMOR_MECA',
                                            MODELE=__MODELE,
                                            CHAM_MATER=__CHAMPMAR,
                                            RIGI_MECA=__RIGI_ELR,
                                            MASS_MECA=__MASS_ELR,
                                            CHARGE=__CON_LIM,)

                __AMORTIR = ASSE_MATRICE(
                    MATR_ELEM=__AMOR_ELR, NUME_DDL=__NUMEDDLR,)

                __VECASXR = CALC_CHAR_SEISME(
                    MATR_MASS=__MASSER, DIRECTION=(1., 0., 0.,), MONO_APPUI='OUI')

                __DYNTEMP = DYNA_VIBRA    (TYPE_CALCUL='TRAN', BASE_CALCUL='PHYS',
                                           MATR_MASS=__MASSER,
                                           MATR_RIGI=__RIGIDITE,
                                           MATR_AMOR=__AMORTIR,

                                           INCREMENT=_F(LIST_INST=__linst,),

                                           EXCIT=_F(VECT_ASSE=__VECASXR,
                                                    FONC_MULT=__AX_RA,),
                                           SOLVEUR=_F(RENUM='METIS',
                                                      STOP_SINGULIER='OUI',
                                                      METHODE='MUMPS',
                                                      NPREC=15,
                                                      ),
                                           )

                __AXrCLv = RECU_FONCTION(RESULTAT=__DYNTEMP,
                                         NOM_CHAM='ACCE',
                                         NOM_CMP=args['NOM_CMP'],
                                         GROUP_NO='P0',
                                         INTERPOL='LIN',
                                         PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',)

                __AX_CLv = CALC_FONCTION(
                    COMB=(_F(FONCTION=__AXrCLv, COEF=1.,), _F(FONCTION=__AX_RA, COEF=1.,),), LIST_PARA=__linst,)
                if args['LIST_FREQ_SPEC_OSCI'] is not None:
                  __SAX_CLv = CALC_FONCTION(
                    SPEC_OSCI=_F(FONCTION=__AX_CLv,AMOR_REDUIT=0.05,LIST_FREQ=args['LIST_FREQ_SPEC_OSCI'],NORME=9.81))
                else:
                  __SAX_CLv = CALC_FONCTION(
                    SPEC_OSCI=_F(FONCTION=__AX_CLv, AMOR_REDUIT=0.05, NORME=9.81))

                IMPR_FONCTION(UNITE=6,
                              FORMAT='XMGRACE', PILOTE=pilimp,
                              BORNE_X=(0., 35),
                              GRILLE_X = 5.,
                              GRILLE_Y = 0.1,
                              LEGENDE_X = 'Frequence (Hz)',
                              LEGENDE_Y = 'Acceleration (g)',
                              SOUS_TITRE = titre,
                              TITRE = 'Spectres CL et RA - input = ' + input,
                              COURBE = (
                              _F(FONCTION=__SAX_CL, MARQUEUR=0.,
                                 LEGENDE='SAX_CL' + legende + 'deltaE =' + str(deltaE),),
                              _F(FONCTION=__SAX_RA, MARQUEUR=0.,
                                 LEGENDE='SAX_RA' + legende + 'deltaE =' + str(deltaE),),
                              ))

                DETRUIRE(CONCEPT=_F(NOM=(
                    __NUMEDDLR, __RIGIDITE,
                    __SOLRSUBS, __CHAMPMAR, __RIGI_ELR,
                    __MASS_ELR, __MASSER, __AMOR_ELR, __AMORTIR,
                    __VECASXR,
                    __DYNTEMP,
                    __AXrCLv, __AX_CLv, __SAX_CLv,
                ),), INFO = 1)

                for k in range(1, NCOU + 2):
                    DETRUIRE(CONCEPT=_F(NOM=__SOLR[k],), INFO=1)

            DETRUIRE(CONCEPT=_F(NOM=(
                            __NUMEDDL,
                            __RIGIHYST, __RIGH_ELH,
                            __SOLHSUBS, __CHAMPMAH, __RIGI_ELH, __MASS_ELH, __MASSEH,
                            __AMOR_ELH, __AMORTIH,
                            __VECASX,
                            __DYNHARM,
                            __pgamax, __rGnew, __rGold,
                            __Enew, __AHnew,
                            ),), INFO = 1)

            for n in range(num_dime):
                if 'DSP' in args:
                    DETRUIRE(CONCEPT=_F(NOM=(
                                    __formFDT[n], __FDT_RACL[n], __mFDTRACL[n],
                                    __formFDT2[n], __FDT_CLBH[n], __mFDTCLBH[n],
                                    __AHuXrCL[n], __AHuXrBH[n], __mAHuXrCL[n], __mAHuXrBH[n],
                                    __AHX_RA[n], __SAX_RA[n],
                                    __AHXrCL[n], __SAX_CL[n],
                                    __paccx[n],
                                    ),), INFO = 1)
                else:
                    DETRUIRE(CONCEPT=_F(NOM=(
                                    __formFDT[n], __FDT_RACL[n], __mFDTRACL[n],
                                    __formFDT2[n], __FDT_CLBH[n], __mFDTCLBH[n],
                                    __AHuXrCL[n], __AHuXrBH[n], __mAHuXrCL[n], __mAHuXrBH[n],
                                    __AHX_RA[n], __AX_RA[n], __SAX_RA[n],
                                    __AX_CL[n], __AHXrCL[n], __AXrCL[n], __SAX_CL[n],
                                    __paccx[n],
                                    ),), INFO = 1)

            for k in range(1, NCOU + 1):
                    DETRUIRE(
                        CONCEPT=_F(NOM=(__gam[k], __tau[k]),), INFO = 1)
            if dime == "2D":
                for k in range(1, NCOU + 1):
                    if ldevi == 'OUI':
                      DETRUIRE(
                        CONCEPT=_F(NOM=(__vix[k], __dex[k], __foy[k],),), INFO = 1)
                    DETRUIRE(
                            CONCEPT=_F(NOM=(__SPEC[k],__axa[k]),), INFO = 1)
                    if 'DSP' not in args:
                        DETRUIRE( CONCEPT=_F(NOM=(__epxy[k],)), INFO = 1)
            elif dime == "3D":
                for k in range(1, NCOU + 1):
                    DETRUIRE(
                        CONCEPT=_F(NOM=(__epxy[k],),), INFO = 1)
                for k in range(num_dime):
                    if ldevi == 'OUI':
                      DETRUIRE(
                        CONCEPT=_F(NOM=(__vix[k], __dex[k], ),), INFO = 1)
                    DETRUIRE(
                        CONCEPT=_F(NOM=(__axa[k],),), INFO = 1)

            for k in range(1, NCOU + 2):
                DETRUIRE(CONCEPT=_F(NOM=__SOLH[k],), INFO=1)

            if deltaE > tole:
                text = ('CONVERGENCE NON ATTEINTE NOMBRE ITERATIONS=' + str(iter) + ' deltaE=' + str(deltaE))
                aster.affiche('MESSAGE', text)

            else:
                text = ('CONVERGENCE ATTEINTE NOMBRE ITERATIONS=' + str(iter) + ' deltaE=' + str(deltaE))
                aster.affiche('MESSAGE', text)

    # definition de la table
    # para/typ pre-trie les colonnes
    tab = Table(
        para=["NUME_COUCHE", "EPAIS", "RHO", "E", "NU", "AMOR_HYST",
              "RECEPTEUR", "SOURCE", "NUME_MATE", "SUBSTRATUM"],
        typ=["I", "R", "R", "R", "R", "R", "K8", "K8", "I", "K8"])


    if SURF == 'OUI':
        ic = 0
        for k in range(1, NCOU + 1):
            if k > 1:
                ic = ic + 1
                tab.append(
                    {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['Efin', k],
                     'NUME_COUCHE': k, 'NUME_MATE': k,
                     'EPAIS': (__TMAT['Y', k] - __TMAT['Y', k - 1]), 'SOURCE': 'NON',
                     'RECEPTEUR': 'NON', 'AMOR_HYST': __TMAT['AHfin', k]})
            else:
                ic = ic + 1
                tab.append(
                    {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['Efin', k],
                     'NUME_COUCHE': k, 'NUME_MATE': k,
                     'EPAIS': __TMAT['Y', k], 'SOURCE': 'OUI',
                     'RECEPTEUR': 'OUI', 'AMOR_HYST': __TMAT['AHfin', k]})

        ic = ic + 1
        tab.append(
            {'RHO': __TMAT['RHO', ic], 'NU': __TMAT['NU', ic], 'E': __TMAT['E0', ic],
             'NUME_COUCHE': ic, 'NUME_MATE': ic,
             'EPAIS': (__TMAT['Y', ic] - __TMAT['Y', ic - 1]), 'SOURCE': 'NON',
             'RECEPTEUR': 'NON', 'AMOR_HYST': __TMAT['AH0', ic]})

        tab.append(
            {'RHO': __TMAT['RHO', ic], 'NU': __TMAT['NU', ic], 'E': __TMAT['E0', ic],
             'NUME_COUCHE': (ic + 1), 'NUME_MATE': ic, 'SUBSTRATUM': 'OUI',
             'EPAIS': 0.0, 'SOURCE': 'NON',
             'RECEPTEUR': 'NON', 'AMOR_HYST': __TMAT['AH0', ic]})

    else:
        ic = 0
        for k in range(1, NCOU2 + 1):
            if k > 1:
              if nsco == 4:
                ic = ic + 1
                tab.append(
                    {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['Efin', k],
                     'NUME_COUCHE': ic, 'NUME_MATE': k,
                     'EPAIS': (0.25 * (__TMAT['Y', k] - __TMAT['Y', k - 1])), 'SOURCE': 'NON',
                     'RECEPTEUR': 'OUI', 'AMOR_HYST': __TMAT['AHfin', k]})

                ic = ic + 1
                tab.append(
                    {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['Efin', k],
                     'NUME_COUCHE': ic, 'NUME_MATE': k,
                     'EPAIS': (0.25 * (__TMAT['Y', k] - __TMAT['Y', k - 1])), 'SOURCE': 'NON',
                     'RECEPTEUR': 'OUI', 'AMOR_HYST': __TMAT['AHfin', k]})
                ic = ic + 1
                tab.append(
                    {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['Efin', k],
                     'NUME_COUCHE': ic, 'NUME_MATE': k,
                     'EPAIS': (0.25 * (__TMAT['Y', k] - __TMAT['Y', k - 1])), 'SOURCE': 'OUI',
                     'RECEPTEUR': 'OUI', 'AMOR_HYST': __TMAT['AHfin', k]})

                ic = ic + 1
                tab.append(
                    {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['Efin', k],
                     'NUME_COUCHE': ic, 'NUME_MATE': k,
                     'EPAIS': (0.25 * (__TMAT['Y', k] - __TMAT['Y', k - 1])), 'SOURCE': 'NON',
                     'RECEPTEUR': 'OUI', 'AMOR_HYST': __TMAT['AHfin', k]})
              else:
                ic = ic + 1
                tab.append(
                    {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['Efin', k],
                     'NUME_COUCHE': ic, 'NUME_MATE': k,
                     'EPAIS': (0.5 * (__TMAT['Y', k] - __TMAT['Y', k - 1])), 'SOURCE': 'NON',
                     'RECEPTEUR': 'OUI', 'AMOR_HYST': __TMAT['AHfin', k]})

                ic = ic + 1
                tab.append(
                    {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['Efin', k],
                     'NUME_COUCHE': ic, 'NUME_MATE': k,
                     'EPAIS': (0.5 * (__TMAT['Y', k] - __TMAT['Y', k - 1])), 'SOURCE': 'OUI',
                     'RECEPTEUR': 'OUI', 'AMOR_HYST': __TMAT['AHfin', k]})
            else:
              if nsco == 4:
                ic = ic + 1
                tab.append(
                    {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['Efin', k],
                     'NUME_COUCHE': ic, 'NUME_MATE': k,
                     'EPAIS': (0.25 * __TMAT['Y', k]), 'SOURCE': 'NON',
                     'RECEPTEUR': 'OUI', 'AMOR_HYST': __TMAT['AHfin', k]})

                ic = ic + 1
                tab.append(
                    {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['Efin', k],
                     'NUME_COUCHE': ic, 'NUME_MATE': k,
                     'EPAIS': (0.25 * __TMAT['Y', k]), 'SOURCE': 'NON',
                     'RECEPTEUR': 'OUI', 'AMOR_HYST': __TMAT['AHfin', k]})

                ic = ic + 1
                tab.append(
                    {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['Efin', k],
                     'NUME_COUCHE': ic, 'NUME_MATE': k,
                     'EPAIS': (0.25 * __TMAT['Y', k]), 'SOURCE': 'OUI',
                     'RECEPTEUR': 'OUI', 'AMOR_HYST': __TMAT['AHfin', k]})

                ic = ic + 1
                tab.append(
                    {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['Efin', k],
                     'NUME_COUCHE': ic, 'NUME_MATE': k,
                     'EPAIS': (0.25 * __TMAT['Y', k]), 'SOURCE': 'NON',
                     'RECEPTEUR': 'OUI', 'AMOR_HYST': __TMAT['AHfin', k]})
              else:
                ic = ic + 1
                tab.append(
                    {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['Efin', k],
                     'NUME_COUCHE': ic, 'NUME_MATE': k,
                     'EPAIS': (0.5 * __TMAT['Y', k]), 'SOURCE': 'NON',
                     'RECEPTEUR': 'OUI', 'AMOR_HYST': __TMAT['AHfin', k]})

                ic = ic + 1
                tab.append(
                    {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['Efin', k],
                     'NUME_COUCHE': ic, 'NUME_MATE': k,
                     'EPAIS': (0.5 * __TMAT['Y', k]), 'SOURCE': 'OUI',
                     'RECEPTEUR': 'OUI', 'AMOR_HYST': __TMAT['AHfin', k]})

        if NCOU2 < NCOU:
            ic = ic + 1
            k = NCOU2 + 1
            tab.append(
                {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['Efin', k],
                 'NUME_COUCHE': ic, 'NUME_MATE': k,
                 'EPAIS': (__TMAT['Y', k] - __TMAT['Y', k - 1]), 'SOURCE': 'OUI',
                 'RECEPTEUR': 'OUI', 'AMOR_HYST': __TMAT['AHfin', k]})

            for k in range(NCOU2 + 2, NCOU + 1):
                ic = ic + 1
                tab.append(
                    {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['Efin', k],
                     'NUME_COUCHE': ic, 'NUME_MATE': k,
                     'EPAIS': (__TMAT['Y', k] - __TMAT['Y', k - 1]), 'SOURCE': 'NON',
                     'RECEPTEUR': 'NON', 'AMOR_HYST': __TMAT['AHfin', k]})

            ic = ic + 1
            k = NCOU + 1
            tab.append(
                {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['E0', k],
                 'NUME_COUCHE': ic, 'NUME_MATE': k,
                 'EPAIS': (__TMAT['Y', k] - __TMAT['Y', k - 1]), 'SOURCE': 'NON',
                 'RECEPTEUR': 'NON', 'AMOR_HYST': __TMAT['AH0', k]})

        else:
            ic = ic + 1
            k = NCOU + 1
            tab.append(
                {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['E0', k],
                 'NUME_COUCHE': ic, 'NUME_MATE': k,
                 'EPAIS': (__TMAT['Y', k] - __TMAT['Y', k - 1]), 'SOURCE': 'OUI',
                 'RECEPTEUR': 'OUI', 'AMOR_HYST': __TMAT['AH0', k]})

        tab.append(
            {'RHO': __TMAT['RHO', k], 'NU': __TMAT['NU', k], 'E': __TMAT['E0', k],
             'NUME_COUCHE': (ic + 1), 'NUME_MATE': k, 'SUBSTRATUM': 'OUI',
             'EPAIS': 0.0, 'SOURCE': 'NON',
             'RECEPTEUR': 'NON', 'AMOR_HYST': __TMAT['AH0', k]})

    DETRUIRE(CONCEPT=_F(NOM=__TMAT), INFO=1)
    IMPR_RESU(RESU=_F(MAILLAGE=__mailla,),FORMAT='ASTER',UNITE=6);

    # creation de la table
    dprod = tab.dict_CREA_TABLE()
    tabout = CREA_TABLE(**dprod)

    return ier
