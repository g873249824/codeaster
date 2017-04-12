# coding=utf-8
# ======================================================================
# COPYRIGHT (C) 1991 - 2017  EDF R&D                  WWW.CODE-ASTER.ORG
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
# Normalizing a vector

def normalize(v):
    import numpy as NP
    norm = NP.sqrt(v[0] ** 2 + v[1] ** 2 + v[2] ** 2)
    return v / norm

#-------------------------------------------------------------------------
# Completed a vector with zero value

def complete(Tab):
    n = len(Tab)
    for i in range(n):
        if Tab[i] == None:
            Tab[i] = 0.
    return Tab

#---------------------------------------------------------------------------------------------------------------
# Sumation of the value divided by number

def moy(t):
    m = 0
    for value in t:
        m += value
    return (m / len(t))

#-------------------------------------------------------------------------
# Interpolation of the points of the crack tip ( XFEM )
# S0 = curvilinear abscissa of the point considered
# Coorfo=Coordonnees the bottom (from the sd fiss_xfem )
# Output : XYZA = Coordinates of the point and Easting

def InterpolFondFiss(s0, Coorfo):
    n = len(Coorfo) / 4
    if (s0 < Coorfo[3]):
        xyz = [Coorfo[0], Coorfo[1], Coorfo[2], s0]
        return xyz
    if (s0 > Coorfo[-1]):
        xyz = [Coorfo[-4], Coorfo[-3], Coorfo[-2], s0]
        return xyz
    i = 1
    while s0 > Coorfo[4 * i + 3]:
        i = i + 1
    xyz = [0.] * 4
    xyz[0] = (s0 - Coorfo[4 * (i - 1) + 3]) * (Coorfo[4 * i + 0] - Coorfo[4 * (i - 1) + 0]) / \
        (Coorfo[4 * i + 3] - Coorfo[4 * (i - 1) + 3]) + \
        Coorfo[4 * (i - 1) + 0]
    xyz[1] = (s0 - Coorfo[4 * (i - 1) + 3]) * (Coorfo[4 * i + 1] - Coorfo[4 * (i - 1) + 1]) / \
        (Coorfo[4 * i + 3] - Coorfo[4 * (i - 1) + 3]) + \
        Coorfo[4 * (i - 1) + 1]
    xyz[2] = (s0 - Coorfo[4 * (i - 1) + 3]) * (Coorfo[4 * i + 2] - Coorfo[4 * (i - 1) + 2]) / \
        (Coorfo[4 * i + 3] - Coorfo[4 * (i - 1) + 3]) + \
        Coorfo[4 * (i - 1) + 2]
    xyz[3] = s0
    return xyz

#-------------------------------------------------------------------------
# Interpolation of the local base in crack tip
# S0 = curvilinear abscissa of the point considered
# Basefo= local base base ( VNORx , VNORy , VNORz , VDIRx , VDIRy , VDIRz )
# Coorfo= Coordonnees and bottom abscissa (from the sd fiss_xfem )
# Output : VDIRVNORi = local base at the point considered (6 coordinated )

def InterpolBaseFiss(s0, Basefo, Coorfo):
    n = len(Coorfo) / 4
    if (s0 < Coorfo[3]):
        VDIRVNORi = Basefo[0:6]
        return VDIRVNORi
    if (s0 > Coorfo[-1]):
        VDIRVNORi = [Basefo[i] for i in range(-6, 0)]
        return VDIRVNORi
    i = 1
    while s0 > Coorfo[4 * i + 3]:
        i = i + 1
    VDIRVNORi = [0.] * 6
    for k in range(6):
        VDIRVNORi[k] = (s0 - Coorfo[4 * (i - 1) + 3]) * (Basefo[6 * i + k] - Basefo[6 * (i - 1) + k]) / (
            Coorfo[4 * i + 3] - Coorfo[4 * (i - 1) + 3]) + Basefo[6 * (i - 1) + k]
    return VDIRVNORi

#-------------------------------------------------------------------------
def expand_values(self, tabout, liste_noeu_a_extr, titre, type_para):

    from Accas import _F
    from Utilitai.Table import Table

    CREA_TABLE = self.get_cmd('CREA_TABLE')
    DETRUIRE = self.get_cmd('DETRUIRE')

    extrtabout = tabout.EXTR_TABLE()
    DETRUIRE(CONCEPT=_F(NOM=tabout), INFO=1)

    points_expand = extrtabout.values()['NUM_PT']
    abscisses_expand = extrtabout.values()['ABSC_CURV']

    instants_expand = extrtabout.values()[type_para]

    size = len(abscisses_expand)

    Td = extrtabout.values()['Td']
    ERR_Td = extrtabout.values()['ERR_Td']

    for i in range(size):
        if points_expand[i] - 1 in liste_noeu_a_extr:
            k_retenu = []
            for sign in [-1, 1]:
                trouve = 0
                k = 1 * sign
                while trouve == 0 and i + k < size and k + i > 0:
                    if points_expand[i + k] - 1 not in liste_noeu_a_extr and instants_expand[i] == instants_expand[i + k]:
                        k_retenu.append(k + i)
                        trouve = 1
                    k = k + 1 * sign
            if len(k_retenu) > 1:
                distance_gauche = abs(
                    abscisses_expand[i] - abscisses_expand[k_retenu[0]])
                distance_droite = abs(
                    abscisses_expand[i] - abscisses_expand[k_retenu[1]])
                if (distance_gauche < distance_droite):
                    k_retenu.remove[1]
                else:
                    k_retenu.remove[0]

            Td[i] = Td[k_retenu[0]]
            ERR_Td[i] = ERR_Td[k_retenu[0]]

            liste_noeu_a_extr.remove(points_expand[i] - 1)

    if 'FISSURE' in extrtabout.values().keys():
        tabout = CREA_TABLE(
            TITRE=titre, LISTE=(_F(LISTE_K=extrtabout.values()['FISSURE'],
                                   PARA='FISSURE'),
                                _F(LISTE_I=extrtabout.values()['NUME_FOND'],
                                   PARA='NUME_FOND'),
                                _F(LISTE_R=extrtabout.values()[type_para],
                                   PARA=type_para),
                                _F(LISTE_I=extrtabout.values()['NUM_PT'],
                                   PARA='NUM_PT'),
                                _F(LISTE_R=extrtabout.values()['ABSC_CURV'],
                                   PARA='ABSC_CURV'),
                                _F(LISTE_R=Td,
                                   PARA='Td'),
                                _F(LISTE_R=ERR_Td,
                                   PARA='ERR_Td'),
                                         ))
    else:
        tabout = CREA_TABLE(
            TITRE=titre, LISTE=(_F(LISTE_K=extrtabout.values()['FOND_FISS'],
                                   PARA='FOND_FISS'),
                                _F(LISTE_I=extrtabout.values()['NUME_FOND'],
                                   PARA='NUME_FOND'),
                                _F(LISTE_R=extrtabout.values()[type_para],
                                   PARA=type_para),
                                _F(LISTE_K=extrtabout.values()['NOEUD_FOND'],
                                   PARA='NOEUD_FOND'),
                                _F(LISTE_I=extrtabout.values()['NUM_PT'],
                                   PARA='NUM_PT'),
                                _F(LISTE_R=extrtabout.values()['ABSC_CURV'],
                                   PARA='ABSC_CURV'),
                                _F(LISTE_R=Td,
                                   PARA='Td'),
                                _F(LISTE_R=ERR_Td,
                                   PARA='ERR_Td'),
                                ))

    return tabout

#-------------------------------------------------------------------------

def verif_config_init(FOND_FISS):
    from Utilitai.Utmess import UTMESS
    import aster

    iret, ibid, config = aster.dismoi(
        'CONFIG_INIT', FOND_FISS.nom, 'FOND_FISS', 'F')
    if config != 'COLLEE':
        UTMESS('F', 'RUPTURE0_16')

#-------------------------------------------------------------------------

def verif_type_fond_fiss(ndim, FOND_FISS):
    from Utilitai.Utmess import UTMESS
    if ndim == 3:
        Typ = FOND_FISS.sdj.FOND_TYPE.get()
#     attention : Typ est un tuple contenant une seule valeur
        if Typ[0].rstrip() != 'SEG2' and Typ[0].rstrip() != 'SEG3':
            UTMESS('F', 'RUPTURE0_12')

#-------------------------------------------------------------------------
# Returns list of nodes FOND_FISS 

def get_noeud_fond_fiss(FOND_FISS):
    """ retourne la liste des noeuds de FOND_FISS"""
    import string as S
    from Utilitai.Utmess import UTMESS
    Lnoff = FOND_FISS.sdj.FOND_NOEU.get()
    if Lnoff == None:
# Cas double fond de fissure : par convention les noeuds sont ceux de
# fond_inf
        Lnoff = FOND_FISS.sdj.FONDINF_NOEU.get()
        if Lnoff == None:
            UTMESS('F', 'RUPTURE0_11')
    Lnoff = map(S.rstrip, Lnoff)
    return Lnoff

#-------------------------------------------------------------------------

# Returns a list of nodes FOND_FISS compute 

def get_noeud_a_calculer(Lnoff, ndim, FOND_FISS, MAILLAGE, EnumTypes, args):
    """ retourne la liste des noeuds de FOND_FISS a calculer"""
    import string as S
    from Utilitai.Utmess import UTMESS

    NOEUD = args['NOEUD']
    SANS_NOEUD = args['SANS_NOEUD']
    GROUP_NO = args['GROUP_NO']
    SANS_GROUP_NO = args['SANS_GROUP_NO']
    TOUT = args['TOUT']

    if ndim == 2:

        Lnocal = Lnoff
        assert (len(Lnocal) == 1)

    elif ndim == 3:

# determination du pas de parcours des noeuds : 1 (tous les noeuds) ou 2
# (un noeud sur 2)
        Typ = FOND_FISS.sdj.FOND_TYPE.get()
        Typ = Typ[0].rstrip()
        if (Typ == 'SEG2') or (Typ == 'SEG3' and TOUT == 'OUI'):
            pas = 1
        elif (Typ == 'SEG3'):
            pas = 2

#        construction de la liste des noeuds "AVEC" et des noeuds "SANS"
        NO_SANS = []
        NO_AVEC = []
        if GROUP_NO != None:
            collgrno = MAILLAGE.sdj.GROUPENO.get()
            cnom = MAILLAGE.sdj.NOMNOE.get()
            if type(GROUP_NO) not in EnumTypes:
                GROUP_NO = (GROUP_NO,)
            for m in xrange(len(GROUP_NO)):
                ngrno = GROUP_NO[m].ljust(24).upper()
                if ngrno not in collgrno.keys():
                    UTMESS('F', 'RUPTURE0_13', valk=ngrno)
                for i in xrange(len(collgrno[ngrno])):
                    NO_AVEC.append(cnom[collgrno[ngrno][i] - 1])
            NO_AVEC = map(S.rstrip, NO_AVEC)
        if NOEUD != None:
            if type(NOEUD) not in EnumTypes:
                NO_AVEC = (NOEUD,)
            else:
                NO_AVEC = NOEUD
        if SANS_GROUP_NO != None:
            collgrno = MAILLAGE.sdj.GROUPENO.get()
            cnom = MAILLAGE.sdj.NOMNOE.get()
            if type(SANS_GROUP_NO) not in EnumTypes:
                SANS_GROUP_NO = (SANS_GROUP_NO,)
            for m in xrange(len(SANS_GROUP_NO)):
                ngrno = SANS_GROUP_NO[m].ljust(24).upper()
                if ngrno not in collgrno.keys():
                    UTMESS('F', 'RUPTURE0_13', valk=ngrno)
                for i in xrange(len(collgrno[ngrno])):
                    NO_SANS.append(cnom[collgrno[ngrno][i] - 1])
            NO_SANS = map(S.rstrip, NO_SANS)
        if SANS_NOEUD != None:
            if type(SANS_NOEUD) not in EnumTypes:
                NO_SANS = (SANS_NOEUD,)
            else:
                NO_SANS = SANS_NOEUD

        set_tmp = set(NO_AVEC) - set(Lnoff)
        if set_tmp:
            UTMESS('F', 'RUPTURE0_15', valk=list(set_tmp)[0])
        set_tmp = set(NO_SANS) - set(Lnoff)
        if set_tmp:
            UTMESS('F', 'RUPTURE0_15', valk=list(set_tmp)[0])

#        creation de Lnocal
        if NO_AVEC:
            Lnocal = tuple(NO_AVEC)
        elif NO_SANS:
            Lnocal = tuple(set(Lnoff) - set(NO_SANS))
        else:
            Lnocal = tuple(Lnoff)
       
        Lnocal=Lnocal[::2] 
    return Lnocal

#-------------------------------------------------------------------------
# Returns the coordinates of nodes in FOND_FISS dictionary 
def get_coor_libre(self, Lnoff, RESULTAT, ndim):
    """ retourne les coordonnees des noeuds de FOND_FISS en dictionnaire"""

    import numpy as NP
    from Accas import _F
    import string as S

    POST_RELEVE_T = self.get_cmd('POST_RELEVE_T')
    DETRUIRE = self.get_cmd('DETRUIRE')

    __NCOFON = POST_RELEVE_T(
        ACTION=_F(INTITULE='Tab pour coordonnees noeuds du fond',
                  NOEUD=Lnoff,
                  RESULTAT=RESULTAT,
                  NOM_CHAM='DEPL',
                  NUME_ORDRE=1,
                  NOM_CMP=('DX',),
                  OPERATION='EXTRACTION',),)

    tcoorf = __NCOFON.EXTR_TABLE()
    DETRUIRE(CONCEPT=_F(NOM=__NCOFON), INFO=1)
    nbt = len(tcoorf['NOEUD'].values()['NOEUD'])
    xs = NP.array(tcoorf['COOR_X'].values()['COOR_X'][:nbt])
    ys = NP.array(tcoorf['COOR_Y'].values()['COOR_Y'][:nbt])
    if ndim == 2:
        zs = NP.zeros(nbt,)
    elif ndim == 3:
        zs = NP.array(tcoorf['COOR_Z'].values()['COOR_Z'][:nbt])
    ns = tcoorf['NOEUD'].values()['NOEUD'][:nbt]
    ns = map(S.rstrip, ns)
    l_coorf = [[ns[i], xs[i], ys[i], zs[i]] for i in range(0, nbt)]
    l_coorf = [(i[0], i[1:]) for i in l_coorf]

    return dict(l_coorf)

#-------------------------------------------------------------------------
# Returns to the normal at each point of the bottom ( VNOR ) and propagation direction vectors ( VDIR ) 

def get_direction(Nnoff, ndim, DTANOR, DTANEX, Lnoff, FOND_FISS):
    """ retourne les normales en chaque point du fond (VNOR)
        et les vecteurs de direction de propagation (VDIR)"""

    # cette fonction retourne 2 dictionnaires, il faudrait mettre
    # en conformite avec get_direction_xfem

    import numpy as NP

    Basefo = FOND_FISS.sdj.BASEFOND.get()

    VNOR = [None] * Nnoff
    VDIR = [None] * Nnoff

    if ndim == 2:
        VNOR[0] = NP.array([Basefo[0], Basefo[1], 0.])
        VDIR[0] = NP.array([Basefo[2], Basefo[3], 0.])
        dicVDIR = dict([(Lnoff[0], VDIR[0])])
        dicVNOR = dict([(Lnoff[0], VNOR[0])])
    elif ndim == 3:
        VNOR[0] = NP.array([Basefo[0], Basefo[1], Basefo[2]])
        if DTANOR != None:
            VDIR[0] = NP.array(DTANOR)
        else:
            VDIR[0] = NP.array([Basefo[3], Basefo[4], Basefo[5]])

        for i in range(1, Nnoff - 1):
            VDIR[i] = NP.array(
                [Basefo[3 + 6 * i], Basefo[3 + 6 * i + 1], Basefo[3 + 6 * i + 2]])
            VNOR[i] = NP.array(
                [Basefo[6 * i], Basefo[6 * i + 1], Basefo[6 * i + 2]])

        i = Nnoff - 1
        VNOR[i] = NP.array(
            [Basefo[6 * i], Basefo[6 * i + 1], Basefo[6 * i + 2]])
        if DTANEX != None:
            VDIR[i] = NP.array(DTANEX)
        else:
            VDIR[i] = NP.array(
                [Basefo[3 + 6 * i], Basefo[3 + 6 * i + 1], Basefo[3 + 6 * i + 2]])

        dicVDIR = dict([(Lnoff[i], VDIR[i]) for i in range(Nnoff)])
        dicVNOR = dict([(Lnoff[i], VNOR[i]) for i in range(Nnoff)])

    return (dicVDIR, dicVNOR)

#-------------------------------------------------------------------------
# Tables of sup and inf for displacements and stress for every crack points 

def get_tab_dep(self, Lnocal, Nnocal, d_coorf, dicVDIR, dicVNOR, RESULTAT, MODEL,
                ListmaS, ListmaI, NB_NOEUD_COUPE, hmax, syme_char, PREC_VIS_A_VIS,MAILLAGE):
    """ retourne les tables des deplacements sup et inf pour les noeuds perpendiculaires pour
    tous les points du fond de fissure"""

    from Accas import _F
    import numpy as NP
    DEFI_GROUP = self.get_cmd('DEFI_GROUP')

    MACR_LIGN_COUPE = self.get_cmd('MACR_LIGN_COUPE')
    CALC_TABLE = self.get_cmd('CALC_TABLE')

    dmax = hmax * PREC_VIS_A_VIS

    mcfact = []
    mcfactH = []
    mcfactV = []
    mcfactQ = []

    for i in xrange(Nnocal):
        Porig = NP.array(d_coorf[Lnocal[i]])
        Pextr = Porig - (1.*hmax * dicVDIR[Lnocal[i]])
        PextrH = Porig +(1.*hmax * dicVDIR[Lnocal[i]])
        PextrV = Porig +(1.*hmax * dicVNOR[Lnocal[i]])
        PextrQ = Porig +(5.*hmax * dicVDIR[Lnocal[i]])

        mcfact.append(_F(NB_POINTS=NB_NOEUD_COUPE,
                         COOR_ORIG=(Porig[0], Porig[1], Porig[2],),
                         TYPE='SEGMENT',
                         COOR_EXTR=(Pextr[0], Pextr[1], Pextr[2]),
                         DISTANCE_MAX=dmax),)

        mcfactH.append(_F(NB_POINTS=NB_NOEUD_COUPE,
                         COOR_ORIG=(Porig[0], Porig[1], Porig[2],),
                         TYPE='SEGMENT',
                         COOR_EXTR=(PextrH[0], PextrH[1], PextrH[2]),
                         DISTANCE_MAX=dmax,
                                  ),)

        mcfactV.append(_F(NB_POINTS=NB_NOEUD_COUPE,
                         COOR_ORIG=(Porig[0], Porig[1], Porig[2],),
                         TYPE='SEGMENT',
                         COOR_EXTR=(PextrV[0], PextrV[1], PextrV[2]),
                         DISTANCE_MAX=dmax,
                             ),)

        mcfactQ.append(_F(NB_POINTS=NB_NOEUD_COUPE,
                         COOR_ORIG=(Porig[0], Porig[1], Porig[2],),
                         TYPE='SEGMENT',
                         COOR_EXTR=(PextrQ[0], PextrQ[1], PextrQ[2]),
                         DISTANCE_MAX=dmax,
                           ),)

    __TlibSd = MACR_LIGN_COUPE(RESULTAT=RESULTAT,
                              NOM_CHAM='DEPL',
                              MODELE=MODEL,
                              VIS_A_VIS=_F(MAILLE_1=ListmaS),
                              LIGN_COUPE=mcfact)

    __TlibSs = MACR_LIGN_COUPE(RESULTAT=RESULTAT,
                              NOM_CHAM='SIGM_NOEU',
                              MODELE=MODEL,
                              VIS_A_VIS=_F(MAILLE_1=ListmaS),
                              LIGN_COUPE=mcfact)

    __TlibS = CALC_TABLE( TABLE= __TlibSd, 
                ACTION=_F(OPERATION='COMB',
                           TABLE=__TlibSs,
                           NOM_PARA=('NUME_ORDRE', 'COOR_X','COOR_Y', 'COOR_Z'),
                           RESTREINT='NON',),)

    __TlibHd = MACR_LIGN_COUPE(RESULTAT=RESULTAT,
                              NOM_CHAM='DEPL',
                              MODELE=MODEL,
                              LIGN_COUPE=mcfactH)

    __TlibHs = MACR_LIGN_COUPE(RESULTAT=RESULTAT,
                              NOM_CHAM='SIGM_NOEU',
                              MODELE=MODEL,
                              LIGN_COUPE=mcfactH)

    __TlibH = CALC_TABLE( TABLE= __TlibHd, 
                ACTION=_F(OPERATION='COMB',
                           TABLE=__TlibHs,
                           NOM_PARA=('NUME_ORDRE', 'COOR_X','COOR_Y', 'COOR_Z'),
                           RESTREINT='NON',),)

    __TlibVd = MACR_LIGN_COUPE(RESULTAT=RESULTAT,
                              NOM_CHAM='DEPL',
                              MODELE=MODEL,
                              LIGN_COUPE=mcfactV)

    __TlibVs = MACR_LIGN_COUPE(RESULTAT=RESULTAT,
                              NOM_CHAM='SIGM_NOEU',
                              MODELE=MODEL,
                              LIGN_COUPE=mcfactV)

    __TlibV = CALC_TABLE( TABLE= __TlibVd, 
                 ACTION=_F(OPERATION='COMB',
                           TABLE=__TlibVs,
                           NOM_PARA=('NUME_ORDRE', 'COOR_X','COOR_Y', 'COOR_Z'),
                           RESTREINT='NON',),)


    __TlibQd = MACR_LIGN_COUPE(RESULTAT=RESULTAT,
                              NOM_CHAM='DEPL',
                              MODELE=MODEL,
                              LIGN_COUPE=mcfactQ)


    __TlibQs = MACR_LIGN_COUPE(RESULTAT=RESULTAT,
                              NOM_CHAM='SIGM_NOEU',
                              MODELE=MODEL,
                              LIGN_COUPE=mcfactQ)

    __TlibQ = CALC_TABLE( TABLE= __TlibQd, 
               ACTION=_F(OPERATION='COMB',
                           TABLE=__TlibQs,
                           NOM_PARA=('NUME_ORDRE', 'COOR_X','COOR_Y', 'COOR_Z'),
                           RESTREINT='NON',),)

    if syme_char == 'NON':

        __TlibIs = MACR_LIGN_COUPE(RESULTAT=RESULTAT,
                                  NOM_CHAM='DEPL',
                                  MODELE=MODEL,
                                  VIS_A_VIS=_F(MAILLE_1=ListmaI),
                                  LIGN_COUPE=mcfact)


        __TlibId = MACR_LIGN_COUPE(RESULTAT=RESULTAT,
                             NOM_CHAM='SIGM_NOEU',
                                  MODELE=MODEL,
                                  VIS_A_VIS=_F(MAILLE_1=ListmaI),
                                  LIGN_COUPE=mcfact)


        __TlibI = CALC_TABLE( TABLE= __TlibIs, 
                   ACTION=_F(OPERATION='COMB',
                           TABLE=__TlibId,
                           NOM_PARA=('NUME_ORDRE', 'ABSC_CURV','COOR_X','COOR_Y', 'COOR_Z'),
                           RESTREINT='NON',),)

    else: 
         __TlibI=__TlibS

    return (__TlibS.EXTR_TABLE(), __TlibI.EXTR_TABLE(), __TlibH.EXTR_TABLE(), __TlibV.EXTR_TABLE(), __TlibQ.EXTR_TABLE() )
#-------------------------------------------------------------------------
def get_dico_levres(lev, FOND_FISS, ndim, Lnoff, Nnoff):
    "retourne ???"""
    import string as S
    from Utilitai.Utmess import UTMESS
    if lev == 'sup':
        Nnorm = FOND_FISS.sdj.SUPNORM_NOEU.get()
        if not Nnorm:
            UTMESS('F', 'RUPTURE0_19')
    elif lev == 'inf':
        Nnorm = FOND_FISS.sdj.INFNORM_NOEU.get()

    Nnorm = map(S.rstrip, Nnorm)
# pourquoi modifie t-on Nnoff dans ce cas, alors que rien n'est fait pour
# les maillages libres ?
    if Lnoff[0] == Lnoff[-1] and ndim == 3:
        Nnoff = Nnoff - 1  # Cas fond de fissure ferme
    Nnorm = [[Lnoff[i], Nnorm[i * 20:(i + 1) * 20]] for i in range(0, Nnoff)]
    Nnorm = [(i[0], i[1][0:]) for i in Nnorm]

    return dict(Nnorm)
#-------------------------------------------------------------------------

# Returns the dictionary of coordinates of the nodes of the lips to the rules meshes 

def get_coor_regle(self, RESULTAT, ndim, Lnoff, Lnocal, dicoS, syme_char, dicoI):
    """retourne le dictionnaire des coordonnees des noeuds des lèvres pour les maillages regles"""
    import numpy as NP
    import string as S
    import copy
    from Accas import _F

    POST_RELEVE_T = self.get_cmd('POST_RELEVE_T')
    CALC_TABLE = self.get_cmd('CALC_TABLE')
#        a eclaircir
    Ltot = copy.copy(Lnoff)
    for ino in Lnocal:
        l = [elem for elem in dicoS[ino] if elem != '']
        Ltot += l
    if syme_char == 'NON':
        for ino in Lnocal:
            l = [elem for elem in dicoI[ino] if elem != '']
            Ltot += l

    Ltot = list(set(Ltot))

    dico = RESULTAT.LIST_VARI_ACCES()

    if ndim == 2:
        nomcmp = ('DX', 'DY')
        nomcms = ('SIXX', 'SIYY')

    elif ndim == 3:
        nomcmp = ('DX', 'DY', 'DZ')
        nomcms = ('SIXX', 'SIYY','SIZZ')

    __NCOOR1 = POST_RELEVE_T(
        ACTION=_F(INTITULE='Tab pour coordonnees noeuds des levres',
                           NOEUD=Ltot,
                           RESULTAT=RESULTAT,
                           NOM_CHAM='DEPL',
                           NOM_CMP=nomcmp,
                           OPERATION='EXTRACTION',),)

    __NCOOR2 = POST_RELEVE_T(
        ACTION=_F(INTITULE='Tab pour coordonnees noeuds des levres',
                           NOEUD=Ltot,
                           RESULTAT=RESULTAT,
#                           NOM_CHAM='SIEQ_ELNO',
                           NOM_CHAM='SIGM_NOEU',
                           NOM_CMP=nomcms,
                           OPERATION='EXTRACTION',),)

    __NCOOR = CALC_TABLE( TABLE= __NCOOR1, 
                 ACTION=_F(OPERATION='COMB',
                           TABLE=__NCOOR2,
#                           NOM_PARA=('ABSC_CURV', 'NUME_ORDRE'),
                           NOM_PARA=('ABSC_CURV'),
                           RESTREINT='NON',),)


    tcoor = __NCOOR.EXTR_TABLE().NUME_ORDRE == dico['NUME_ORDRE'][0]

    nbt = len(tcoor['NOEUD'].values()['NOEUD'])
    xs = NP.array(tcoor['COOR_X'].values()['COOR_X'][:nbt])
    ys = NP.array(tcoor['COOR_Y'].values()['COOR_Y'][:nbt])
    if ndim == 2:
        zs = NP.zeros(nbt)
    elif ndim == 3:
        zs = NP.array(tcoor['COOR_Z'].values()['COOR_Z'][:nbt])
    ns = tcoor['NOEUD'].values()['NOEUD'][:nbt]
    ns = map(S.rstrip, ns)
    l_coor = [[ns[i], xs[i], ys[i], zs[i]] for i in xrange(nbt)]
    l_coor = [(i[0], i[1:]) for i in l_coor]
    
    return (dict(l_coor), __NCOOR.EXTR_TABLE())

#-------------------------------------------------------------------------
# Returns the dictionary curvilinear Eastings the bottom

def get_absfon(Lnoff, Nnoff, d_coor):
    """ retourne le dictionnaire des Abscisses curvilignes du fond"""
    import numpy as NP
    absfon = [0, ]
    for i in xrange(Nnoff - 1):
        Pfon1 = NP.array(
            [d_coor[Lnoff[i]][0], d_coor[Lnoff[i]][1], d_coor[Lnoff[i]][2]])
        Pfon2 = NP.array(
            [d_coor[Lnoff[i + 1]][0], d_coor[Lnoff[i + 1]][1], d_coor[Lnoff[i + 1]][2]])
        absf = NP.sqrt(
            NP.dot(NP.transpose(Pfon1 - Pfon2), Pfon1 - Pfon2)) + absfon[i]
        absfon.append(absf)

    return dict([(Lnoff[i], absfon[i]) for i in xrange(Nnoff)])

#-------------------------------------------------------------------------
#  Returns a list of bottom nodes, the list of lists perpendicular nodes """

def get_noeuds_perp_regle(Lnocal, d_coor, dicoS, dicoI, Lnoff, PREC_VIS_A_VIS, hmax, syme_char):
    """retourne la liste des noeuds du fond (encore ?), la liste des listes des noeuds perpendiculaires"""
    import numpy as NP
    from Utilitai.Utmess import UTMESS

    NBTRLS = 0
    NBTRLI = 0
    Lnosup = [None] * len(Lnocal)
    Lnoinf = [None] * len(Lnocal)
    Nbnofo = 0
    Lnofon = []

    rmprec = hmax * (1. + PREC_VIS_A_VIS / 10.)

    precn = PREC_VIS_A_VIS * hmax

    for ino in Lnocal:
        Pfon = NP.array([d_coor[ino][0], d_coor[ino][1], d_coor[ino][2]])
        Tmpsup = []
        Tmpinf = []
        itots = 0
        itoti = 0
        NBTRLS = 0
        NBTRLI = 0
        for k in xrange(20):
            if dicoS[ino][k] != '':
                itots = itots + 1
                Nsup = dicoS[ino][k]
                Psup = NP.array(
                    [d_coor[Nsup][0], d_coor[Nsup][1], d_coor[Nsup][2]])
                abss = NP.sqrt(NP.dot(NP.transpose(Pfon - Psup), Pfon - Psup))
                if abss < rmprec:
                    NBTRLS = NBTRLS + 1
                    Tmpsup.append(dicoS[ino][k])
            if syme_char == 'NON':
                if dicoI[ino][k] != '':
                    itoti = itoti + 1
                    Ninf = dicoI[ino][k]
                    Pinf = NP.array(
                        [d_coor[Ninf][0], d_coor[Ninf][1], d_coor[Ninf][2]])
                    absi = NP.sqrt(
                        NP.dot(NP.transpose(Pfon - Pinf), Pfon - Pinf))

                    if abss < rmprec:
                        dist = NP.sqrt(
                            NP.dot(NP.transpose(Psup - Pinf), Psup - Pinf))
                        if dist > precn:
                            UTMESS('A', 'RUPTURE0_21', valk=ino)
                        else:
                            NBTRLI = NBTRLI + 1
                            Tmpinf.append(dicoI[ino][k])
        if NBTRLS < 3:
            UTMESS('A+', 'RUPTURE0_22', valk=ino)
            if ino == Lnoff[0] or ino == Lnoff[-1]:
                UTMESS('A+', 'RUPTURE0_23')
            if itots < 3:
                UTMESS('A', 'RUPTURE0_24')
            else:
                UTMESS('A', 'RUPTURE0_25')
        elif (syme_char == 'NON') and (NBTRLI < 3):
            UTMESS('A+', 'RUPTURE0_26', valk=ino)
            if ino == Lnoff[0] or ino == Lnoff[-1]:
                UTMESS('A+', 'RUPTURE0_23')
            if itoti < 3:
                UTMESS('A', 'RUPTURE0_24')
            else:
                UTMESS('A', 'RUPTURE0_25')
        else:
            Lnosup[Nbnofo] = Tmpsup
            if syme_char == 'NON':
                Lnoinf[Nbnofo] = Tmpinf
            Lnofon.append(ino)
            Nbnofo = Nbnofo + 1
    if Nbnofo == 0:
        UTMESS('F', 'RUPTURE0_30')
    return (Lnofon, Lnosup, Lnoinf)

#-------------------------------------------------------------------------

# XFEM
def verif_resxfem(self, RESULTAT):
    """ verifie que le resultat est bien compatible avec X-FEM et renvoie xcont et MODEL"""

    import aster
    from Utilitai.Utmess import UTMESS

    iret, ibid, n_modele = aster.dismoi(
        'MODELE', RESULTAT.nom, 'RESULTAT', 'F')
    n_modele = n_modele.rstrip()
    if len(n_modele) == 0:
        UTMESS('F', 'RUPTURE0_18')
    MODEL = self.get_concept(n_modele)
    xcont = MODEL.sdj.xfem.XFEM_CONT.get()
    return (xcont, MODEL)

#-------------------------------------------------------------------------
def get_resxfem(self, xcont, RESULTAT, MODELISATION, MODEL):
    """ retourne le resultat """
    from Accas import _F
    import aster

    AFFE_MODELE = self.get_cmd('AFFE_MODELE')
    PROJ_CHAMP = self.get_cmd('PROJ_CHAMP')
    DETRUIRE = self.get_cmd('DETRUIRE')
    CREA_MAILLAGE = self.get_cmd('CREA_MAILLAGE')

    iret, ibid, nom_ma = aster.dismoi(
        'NOM_MAILLA', RESULTAT.nom, 'RESULTAT', 'F')
    if xcont[0] != 3:
        __RESX = RESULTAT

#     XFEM + contact : il faut reprojeter sur le maillage lineaire
    elif xcont[0] == 3:
        __mail1 = self.get_concept(nom_ma.strip())
        __mail2 = CREA_MAILLAGE(MAILLAGE=__mail1,
                                QUAD_LINE=_F(TOUT='OUI',),)

        __MODLINE = AFFE_MODELE(MAILLAGE=__mail2,
                                AFFE=(_F(TOUT='OUI',
                                         PHENOMENE='MECANIQUE',
                                         MODELISATION=MODELISATION,),),)

        __RESX = PROJ_CHAMP(METHODE='COLLOCATION',
                            TYPE_CHAM='NOEU',
                            NOM_CHAM='DEPL',
                            RESULTAT=RESULTAT,
                            MODELE_1=MODEL,
                            MODELE_2=__MODLINE, )

    return __RESX

#-------------------------------------------------------------------------
def get_coor_xfem(args, FISSURE, ndim):
    """retourne la liste des coordonnees des points du fond, la base locale en fond et le nombre de points"""

    from Utilitai.Utmess import UTMESS

    Listfo = FISSURE.sdj.FONDFISS.get()
    Basefo = FISSURE.sdj.BASEFOND.get()
    NB_POINT_FOND = args['NB_POINT_FOND']

#     Traitement des fonds fermés
    TypeFond = FISSURE.sdj.INFO.get()[2]

#     Traitement du cas fond multiple
    Fissmult = FISSURE.sdj.FONDMULT.get()
    Nbfiss = len(Fissmult) / 2
    Numfiss = args['NUME_FOND']
    if Numfiss <= Nbfiss and (Nbfiss > 1 or TypeFond == 'FERME'):
        Ptinit = Fissmult[2 * (Numfiss - 1)]
        Ptfin = Fissmult[2 * (Numfiss - 1) + 1]
        Listfo2 = Listfo[((Ptinit - 1) * 4):(Ptfin * 4)]
        Listfo = Listfo2
        Basefo2 = Basefo[((Ptinit - 1) * (2 * ndim)):(Ptfin * (2 * ndim))]
        Basefo = Basefo2
    elif Numfiss > Nbfiss:
        UTMESS('F', 'RUPTURE1_38', vali=[Nbfiss, Numfiss])

    if NB_POINT_FOND != None and ndim == 3:
        Nnoff = NB_POINT_FOND
        absmax = Listfo[-1]
        Coorfo = [None] * 4 * Nnoff
        Vpropa = [None] * 3 * Nnoff
        for i in xrange(Nnoff):
            absci = i * absmax / (Nnoff - 1)
            Coorfo[(4 * i):(4 * (i + 1))] = InterpolFondFiss(absci, Listfo)
            Vpropa[(6 * i):(6 * (i + 1))] = InterpolBaseFiss(
                absci, Basefo, Listfo)
    else:
        Coorfo = Listfo
        Vpropa = Basefo
        Nnoff = len(Coorfo) / 4

    return (Coorfo, Vpropa, Nnoff)

#-------------------------------------------------------------------------
# Return the propagation direction , normal to the surface of the crack, and the curvilinear abscissa at each point of the background
def get_direction_xfem(Nnoff, Vpropa, Coorfo, ndim):
    """retourne la direction de propagation, la normale a la surface de la fissure,
    et l'abscisse curviligne en chaque point du fond"""

    import numpy as NP
    from Utilitai.Utmess import UTMESS

    VDIR = [None] * Nnoff
    VNOR = [None] * Nnoff
    absfon = [0, ]

    i = 0
    if ndim == 3:
        VNOR[0] = NP.array([Vpropa[0], Vpropa[1], Vpropa[2]])
        VDIR[0] = NP.array([Vpropa[3 + 0], Vpropa[3 + 1], Vpropa[3 + 2]])
        for i in xrange(1, Nnoff - 1):
            absf = Coorfo[4 * i + 3]
            absfon.append(absf)
            VNOR[i] = NP.array(
                [Vpropa[6 * i], Vpropa[6 * i + 1], Vpropa[6 * i + 2]])
            VDIR[i] = NP.array(
                [Vpropa[3 + 6 * i], Vpropa[3 + 6 * i + 1], Vpropa[3 + 6 * i + 2]])
            verif = NP.dot(NP.transpose(VNOR[i]), VNOR[i - 1])
            if abs(verif) < 0.98:
                UTMESS('A', 'RUPTURE1_35', vali=[i - 1, i])
        i = Nnoff - 1
        absf = Coorfo[4 * i + 3]
        absfon.append(absf)

        VNOR[i] = NP.array(
            [Vpropa[6 * i], Vpropa[6 * i + 1], Vpropa[6 * i + 2]])
        VDIR[i] = NP.array(
            [Vpropa[3 + 6 * i], Vpropa[3 + 6 * i + 1], Vpropa[3 + 6 * i + 2]])
    elif ndim == 2:
        for i in range(0, Nnoff):
            VNOR[i] = NP.array([Vpropa[0 + 4 * i], Vpropa[1 + 4 * i], 0.])
            VDIR[i] = NP.array([Vpropa[2 + 4 * i], Vpropa[3 + 4 * i], 0.])
    return (VDIR, VNOR, absfon)

#-------------------------------------------------------------------------
# Returns the jump table 

def get_sauts_xfem(self, Nnoff, Coorfo, VDIR, hmax, NB_NOEUD_COUPE, dmax, __RESX):
    """retourne la table des sauts"""
    from Accas import _F
    import numpy as NP

    MACR_LIGN_COUPE = self.get_cmd('MACR_LIGN_COUPE')

    mcfact = []
    for i in xrange(Nnoff):
        Porig = NP.array([Coorfo[4 * i], Coorfo[4 * i + 1], Coorfo[4 * i + 2]])
        Pextr = Porig - hmax * VDIR[i]

        mcfact.append(_F(NB_POINTS=NB_NOEUD_COUPE,
                         COOR_ORIG=(Porig[0], Porig[1], Porig[2],),
                         TYPE='SEGMENT',
                         COOR_EXTR=(Pextr[0], Pextr[1], Pextr[2]),
                         DISTANCE_MAX=dmax),)

    __TSo = MACR_LIGN_COUPE(RESULTAT=__RESX,
                            NOM_CHAM='DEPL',
                            LIGN_COUPE=mcfact)

    return __TSo.EXTR_TABLE()

#-------------------------------------------------------------------------

# XFEM displays information

def affiche_xfem(self, INFO, Nnoff, VNOR, VDIR):
    """affiche des infos"""
    from Accas import _F
    import aster

    CREA_TABLE = self.get_cmd('CREA_TABLE')
    DETRUIRE = self.get_cmd('DETRUIRE')

    if INFO == 2:
        mcfact = []
        mcfact.append(_F(PARA='NUM_PT', LISTE_I=range(Nnoff)))
        mcfact.append(
            _F(PARA='VN_X', LISTE_R=[VNOR[i][0] for i in xrange(Nnoff)]))
        mcfact.append(
            _F(PARA='VN_Y', LISTE_R=[VNOR[i][1] for i in xrange(Nnoff)]))
        mcfact.append(
            _F(PARA='VN_Z', LISTE_R=[VNOR[i][2] for i in xrange(Nnoff)]))
        mcfact.append(
            _F(PARA='VP_X', LISTE_R=[VDIR[i][0] for i in xrange(Nnoff)]))
        mcfact.append(
            _F(PARA='VP_Y', LISTE_R=[VDIR[i][1] for i in xrange(Nnoff)]))
        mcfact.append(
            _F(PARA='VP_Z', LISTE_R=[VDIR[i][2] for i in xrange(Nnoff)]))
        __resu2 = CREA_TABLE(LISTE=mcfact,
                             TITRE=' ' * 13 + 'VECTEUR NORMAL A LA FISSURE    -   DIRECTION DE PROPAGATION')
        aster.affiche('MESSAGE', __resu2.EXTR_TABLE().__repr__())
        DETRUIRE(CONCEPT=_F(NOM=__resu2), INFO=1)

#-------------------------------------------------------------------------
def affiche_traitement(FOND_FISS, Lnofon, ino):
    import aster
    if FOND_FISS:
        texte = "\n\n--> TRAITEMENT DU NOEUD DU FOND DE FISSURE: %s" % Lnofon[
            ino]
        aster.affiche('MESSAGE', texte)
    else:
        texte = "\n\n--> TRAITEMENT DU POINT DU FOND DE FISSURE NUMERO %s" % (
            ino + 1)
        aster.affiche('MESSAGE', texte)

#-------------------------------------------------------------------------

# Returns the table displacements perpendicular nodes """
def get_tab(self, lev, ino, Tlib, Lno, TTSo, FOND_FISS, TYPE_MAILLAGE, tabl_depl, syme_char):
    """retourne la table des deplacements des noeuds perpendiculaires"""
    import string as S

    if lev == 'sup' or (lev == 'inf' and syme_char == 'NON' and FOND_FISS):

        if FOND_FISS:
            if TYPE_MAILLAGE == 'LIBRE' or TYPE_MAILLAGE == 'REGLE':
                tab = Tlib.INTITULE == 'l.coupe%i' % (ino + 1)
            else:
#                Ls = [S.ljust(Lno[ino][i], 8) for i in range(len(Lno[ino]))]
                Ls = [S.ljust(Lno[ino][i], 15) for i in range(len(Lno[ino]))]
                tab = tabl_depl.NOEUD == Ls

        else:
            tab = TTSo.INTITULE == 'l.coupe%i' % (ino + 1)

    else:
        tab = None
    return tab

#-------------------------------------------------------------------------
# Returns a list of increment
def get_liste_inst(tabsup, args):
    """retourne la liste d'instants"""
    from Utilitai.Utmess import UTMESS

    l_inst = None
    l_inst_tab = tabsup['INST'].values()['INST']
    l_inst_tab = dict([(i, 0)
                      for i in l_inst_tab]).keys()  # elimine les doublons
    l_inst_tab.sort()
    if args['LIST_ORDRE'] != None or args['NUME_ORDRE'] != None:
        l_ord_tab = tabsup['NUME_ORDRE'].values()['NUME_ORDRE']
        l_ord_tab.sort()
        l_ord_tab = dict([(i, 0) for i in l_ord_tab]).keys()
        d_ord_tab = [[l_ord_tab[i], l_inst_tab[i]]
                     for i in range(0, len(l_ord_tab))]
        d_ord_tab = [(i[0], i[1]) for i in d_ord_tab]
        d_ord_tab = dict(d_ord_tab)
        if args['NUME_ORDRE'] != None:
            l_ord = args['NUME_ORDRE']
        elif args['LIST_ORDRE'] != None:
            l_ord = args['LIST_ORDRE'].sdj.VALE.get()
        l_inst = []
        for ord in l_ord:
            if ord in l_ord_tab:
                l_inst.append(d_ord_tab[ord])
            else:
                UTMESS('F', 'RUPTURE0_37', vali=ord)
        PRECISION = 1.E-6
        CRITERE = 'ABSOLU'
    elif args['INST'] != None or args['LIST_INST'] != None:
        CRITERE = args['CRITERE']
        PRECISION = args['PRECISION']
        if args['INST'] != None:
            l_inst = args['INST']
        elif args['LIST_INST'] != None:
            l_inst = args['LIST_INST'].Valeurs()

        if type(l_inst) == tuple:
            l_inst = list(l_inst)

        for i, inst in enumerate(l_inst):
            if CRITERE == 'RELATIF' and inst != 0.:
                match = [
                    x for x in l_inst_tab if abs((inst - x) / inst) < PRECISION]
            else:
                match = [x for x in l_inst_tab if abs(inst - x) < PRECISION]
            if len(match) == 0:
                UTMESS('F', 'RUPTURE0_38', valr=inst)
            if len(match) >= 2:
                UTMESS('F', 'RUPTURE0_39', valr=inst)
            l_inst[i] = match[0]
    else:
        l_inst = l_inst_tab
        PRECISION = 1.E-6
        CRITERE = 'ABSOLU'
    return (l_inst, PRECISION, CRITERE)

#-------------------------------------------------------------------------

# Returns a list of frequencies 
def get_liste_freq(tabsup, args):
    """retourne la liste des fréquences"""
    from Utilitai.Utmess import UTMESS

    l_freq = None
    l_freq_tab = tabsup['FREQ'].values()['FREQ']
    l_freq_tab = dict([(i, 0)
                      for i in l_freq_tab]).keys()  # elimine les doublons
    l_freq_tab.sort()
    if args['LIST_ORDRE'] != None or args['NUME_ORDRE'] != None:
        l_ord_tab = tabsup['NUME_ORDRE'].values()['NUME_ORDRE']
        l_ord_tab.sort()
        l_ord_tab = dict([(i, 0) for i in l_ord_tab]).keys()
        d_ord_tab = [(l_ord_tab[i], l_freq_tab[i])
                     for i in range(0, len(l_ord_tab))]
        d_ord_tab = dict(d_ord_tab)
        if args['NUME_ORDRE'] != None:
            l_ord = list(args['NUME_ORDRE'])
        elif args['LIST_ORDRE'] != None:
            l_ord = args['LIST_ORDRE'].sdj.VALE.get()
        l_freq = []
        for ord in l_ord:
            if ord in l_ord_tab:
                l_freq.append(d_ord_tab[ord])
            else:
                UTMESS('F', 'RUPTURE0_37', vali=ord)
        PRECISION = 1.E-6
        CRITERE = 'ABSOLU'
    elif args['LIST_MODE'] != None or args['NUME_MODE'] != None:
        l_mod_tab = tabsup['NUME_MODE'].values()['NUME_MODE']
        l_mod_tab.sort()
        l_mod_tab = dict([(i, 0) for i in l_mod_tab]).keys()
        d_mod_tab = [(l_mod_tab[i], l_freq_tab[i])
                     for i in range(0, len(l_mod_tab))]
        d_mod_tab = dict(d_mod_tab)
        if args['NUME_MODE'] != None:
            l_mod = args['NUME_MODE']
        elif args['LIST_MODE'] != None:
            l_mod = args['LIST_MODE'].sdj.VALE.get()
        l_freq = []
        for mod in l_mod:
            if mod in l_mod_tab:
                l_freq.append(d_mod_tab[mod])
            else:
                UTMESS('F', 'RUPTURE0_74', vali=mod)
        PRECISION = 1.E-6
        CRITERE = 'ABSOLU'
    elif args['FREQ'] != None or args['LIST_FREQ'] != None:
        CRITERE = args['CRITERE']
        PRECISION = args['PRECISION']
        if args['FREQ'] != None:
            l_freq = list(args['FREQ'])
        elif args['LIST_FREQ'] != None:
            l_freq = args['LIST_FREQ'].Valeurs()

        if type(l_freq) == tuple:
            l_freq = list(l_freq)

        for i, freq in enumerate(l_freq):
            if CRITERE == 'RELATIF' and freq != 0.:
                match = [
                    x for x in l_freq_tab if abs((freq - x) / freq) < PRECISION]
            else:
                match = [x for x in l_freq_tab if abs(freq - x) < PRECISION]

            if len(match) == 0:
                UTMESS('F', 'RUPTURE0_88', valr=freq)
            if len(match) >= 2:
                UTMESS('F', 'RUPTURE0_89', valr=freq)
            l_freq[i] = match[0]
    else:
        l_freq = l_freq_tab
        PRECISION = 1.E-6
        CRITERE = 'ABSOLU'
    return (l_freq, PRECISION, CRITERE)
#-------------------------------------------------------------------------

def affiche_instant(inst, type_para):
    import aster

    if inst != None:
        if type_para == 'FREQ':
            texte = "#" + "=" * 80 + "\n" + "==> FREQUENCE: %f" % inst
        else:
            texte = "#" + "=" * 80 + "\n" + "==> INSTANT: %f" % inst
        aster.affiche('MESSAGE', texte)

#-------------------------------------------------------------------------

# Returns the table of displacements of the nodes at the current time
def get_tab_inst(lev, inst, FISSURE, syme_char, PRECISION, CRITERE, tabsup, tabinf, type_para):
    """retourne la table des deplacements des noeuds à l'instant courant"""

    tab = None
    assert(lev == 'sup' or lev == 'inf')

    if lev == 'sup':
        tabres = tabsup
    elif lev == 'inf':
        if syme_char == 'NON' and not FISSURE:
            tabres = tabinf
        else:
            return tab

    if inst == 0.:
        crit = 'ABSOLU'
    else:
        crit = CRITERE
    if type_para == 'FREQ':
        tab = tabres.FREQ.__eq__(VALE=inst,
                                 CRITERE=crit,
                                 PRECISION=PRECISION)
    else:
        tab = tabres.INST.__eq__(VALE=inst,
                                 CRITERE=crit,
                                 PRECISION=PRECISION)
    return tab

#-------------------------------------------------------------------------
# returns the material properties as a function of the temperature at the time requested
def get_propmat_tempe(MATER, tabtemp, Lnofon, ino, inst, PRECISION):
    """retourne les proprietes materiaux en fonction de la temperature à l'instant demandé"""
    import numpy as NP
    from math import pi

    tempeno = tabtemp.NOEUD == Lnofon[ino]
    tempeno = tempeno.INST.__eq__(
        VALE=inst, CRITERE='ABSOLU', PRECISION=PRECISION)
    nompar = ('TEMP',)
    valpar = (tempeno.TEMP.values()[0],)
    nomres = ['E', 'NU']
    valres, codret = MATER.RCVALE('ELAS', nompar, valpar, nomres, 2)
    e = valres[0]
    nu = valres[1]

    coetd = e / ((1. - nu ** 2))

    coetg = (1. - nu ** 2) / e
    coetg3 = (1. + nu ) / e
    return (e, nu, coetd,  coetg, coetg3 )

#----------------------------------------------------------------------------------------------------

# Return the sup travel 
def get_depl_sup(FOND_FISS, tabsupi, ndim, Lnofon, d_coor, ino, TYPE_MAILLAGE):
    """retourne les déplacements sup"""

    import numpy as NP
    import copy
    from Utilitai.Utmess import UTMESS

    abscs = getattr(tabsupi, 'ABSC_CURV').values()

    if FOND_FISS:

        nbval = len(abscs)

        if TYPE_MAILLAGE != 'LIBRE':
            coxs = NP.array(tabsupi['COOR_X'].values()['COOR_X'][:nbval])
            coys = NP.array(tabsupi['COOR_Y'].values()['COOR_Y'][:nbval])
            if ndim == 2:
                cozs = NP.zeros(nbval)
            elif ndim == 3:
                cozs = NP.array(tabsupi['COOR_Z'].values()['COOR_Z'][:nbval])

            Pfon = NP.array(
                [d_coor[Lnofon[ino]][0], d_coor[Lnofon[ino]][1], d_coor[Lnofon[ino]][2]])
            abscs = NP.sqrt(
                (coxs - Pfon[0]) ** 2 + (coys - Pfon[1]) ** 2 + (cozs - Pfon[2]) ** 2)
            tabsupi['Abs_fo'] = abscs
            tabsupi.sort('Abs_fo')
            abscs = getattr(tabsupi, 'Abs_fo').values()

        abscs = NP.array(abscs[:nbval])

        dxs = NP.array(tabsupi['DX'].values()['DX'][:nbval])
        dys = NP.array(tabsupi['DY'].values()['DY'][:nbval])

        Sxs = NP.array(tabsupi['SIXX'].values()['SIXX'][:nbval])
        Sys = NP.array(tabsupi['SIYY'].values()['SIYY'][:nbval])

        if ndim == 2:
            dzs = NP.zeros(nbval)
            Szs = NP.zeros(nbval)

        elif ndim == 3:
            dzs = NP.array(tabsupi['DZ'].values()['DZ'][:nbval])
            Szs = NP.array(tabsupi['SIZZ'].values()['SIZZ'][:nbval])

#     ---  CAS FISSURE X-FEM ---
    else:
        H1 = getattr(tabsupi, 'H1X').values()
        nbval = len(H1)
        H1 = complete(H1)
        E1 = getattr(tabsupi, 'E1X').values()
        E1 = complete(E1)
        dxs = 2 * (H1 + NP.sqrt(abscs) * E1)
#         dxs = xcoef_he()*H1 + 2*NP.sqrt(abscs)*E1
        H1 = getattr(tabsupi, 'H1Y').values()
        E1 = getattr(tabsupi, 'E1Y').values()
        H1 = complete(H1)
        E1 = complete(E1)
        dys = 2 * (H1 + NP.sqrt(abscs) * E1)
#         dys = xcoef_he()*H1 + 2*NP.sqrt(abscs)*E1
        H1 = getattr(tabsupi, 'H1Z').values()
        E1 = getattr(tabsupi, 'E1Z').values()
        H1 = complete(H1)
        E1 = complete(E1)
        dzs = 2 * (H1 + NP.sqrt(abscs) * E1)
#         dzs = xcoef_he()*H1 + 2*NP.sqrt(abscs)*E1
        abscs = NP.array(abscs[:nbval])


    ds = NP.asarray([dxs, dys, dzs])
    Ss = NP.asarray([Sxs, Sys, Szs])
    return (abscs, ds, Ss)

#-------------------------------------------------------------------------

# returns inf travel 
def get_depl_inf(FOND_FISS, tabinfi, ndim, Lnofon, syme_char, d_coor, ino, TYPE_MAILLAGE):
    """retourne les déplacements inf"""
    import numpy as NP
    import copy
    from Utilitai.Utmess import UTMESS

    if syme_char == 'NON' and FOND_FISS:
        absci = getattr(tabinfi, 'ABSC_CURV').values()

        nbval = len(absci)
        if TYPE_MAILLAGE != 'LIBRE':
            coxi = NP.array(tabinfi['COOR_X'].values()['COOR_X'][:nbval])
            coyi = NP.array(tabinfi['COOR_Y'].values()['COOR_Y'][:nbval])
            if ndim == 2:
                cozi = NP.zeros(nbval)
            elif ndim == 3:
                cozi = NP.array(tabinfi['COOR_Z'].values()['COOR_Z'][:nbval])

            Pfon = NP.array(
                [d_coor[Lnofon[ino]][0], d_coor[Lnofon[ino]][1], d_coor[Lnofon[ino]][2]])
            absci = NP.sqrt(
                (coxi - Pfon[0]) ** 2 + (coyi - Pfon[1]) ** 2 + (cozi - Pfon[2]) ** 2)
            tabinfi['Abs_fo'] = absci
            tabinfi.sort('Abs_fo')
            absci = getattr(tabinfi, 'Abs_fo').values()

        absci = NP.array(absci[:nbval])

        dxi = NP.array(tabinfi['DX'].values()['DX'][:nbval])
        dyi = NP.array(tabinfi['DY'].values()['DY'][:nbval])

        Sxi = NP.array(tabinfi['SIXX'].values()['SIXX'][:nbval])
        Syi = NP.array(tabinfi['SIYY'].values()['SIYY'][:nbval])


        if ndim == 2:
            dzi = NP.zeros(nbval)
            Szi = NP.zeros(nbval)

        elif ndim == 3:
            dzi = NP.array(tabinfi['DZ'].values()['DZ'][:nbval])
            Szi = NP.array(tabinfi['SIZZ'].values()['SIZZ'][:nbval])

        di = NP.asarray([dxi, dyi, dzi])
        Si = NP.asarray([Sxi, Syi, Szi])

    else:

        absci = []
        di = []
        Si = []
    return (absci, di, Si)
#------------------------------------------------------------------------------------

# Horizental table
def get_depl_H (FOND_FISS, tabHi, ndim,syme_char, Lnofon, d_coor, ino, TYPE_MAILLAGE):
    """retourne les déplacements sup"""

    import numpy as NP
    import copy
    from Utilitai.Utmess import UTMESS

    absch = getattr(tabHi, 'ABSC_CURV').values()

    if FOND_FISS:

        nbval = len(absch)
        absch = NP.array(absch[:nbval])

        dxs = NP.array(tabHi['DX'].values()['DX'][:nbval])
        dys = NP.array(tabHi['DY'].values()['DY'][:nbval])

        Sxs = NP.array(tabHi['SIXX'].values()['SIXX'][:nbval])
        Sys = NP.array(tabHi['SIYY'].values()['SIYY'][:nbval])

        if ndim == 2:
            dzs = NP.zeros(nbval)
            Szs = NP.zeros(nbval)

        elif ndim == 3:
            dzs = NP.array(tabHi['DZ'].values()['DZ'][:nbval])
            Szs = NP.array(tabHi['SIZZ'].values()['SIZZ'][:nbval])

    dh = NP.asarray([dxs, dys, dzs])
    Sh = NP.asarray([Sxs, Sys, Szs])
    return (absch, dh, Sh)

#----------------------------------------------------------------------------------------
# Vertical table

def get_depl_V (FOND_FISS, tabVi, ndim, Lnofon, syme_char,d_coor, ino, TYPE_MAILLAGE):

    """retourne les déplacements sup"""

    import numpy as NP
    import copy
    from Utilitai.Utmess import UTMESS

    abscv = getattr(tabVi, 'ABSC_CURV').values()

    if FOND_FISS:

        nbval = len(abscv)
        abscv = NP.array(abscv[:nbval])

        dxs = NP.array(tabVi['DX'].values()['DX'][:nbval])
        dys = NP.array(tabVi['DY'].values()['DY'][:nbval])

        Sxs = NP.array(tabVi['SIXX'].values()['SIXX'][:nbval])
        Sys = NP.array(tabVi['SIYY'].values()['SIYY'][:nbval])

        if ndim == 2:
            dzs = NP.zeros(nbval)
            Szs = NP.zeros(nbval)

        elif ndim == 3:
            dzs = NP.array(tabVi['DZ'].values()['DZ'][:nbval])
            Szs = NP.array(tabVi['SIZZ'].values()['SIZZ'][:nbval])

    dv = NP.asarray([dxs, dys, dzs])
    Sv = NP.asarray([Sxs, Sys, Szs])
    return (abscv, dv, Sv)

#--------------------------------------------------------------------------------------------

def get_depl_Q (FOND_FISS, tabQi, ndim, Lnofon, syme_char,d_coor, ino, TYPE_MAILLAGE):

    """retourne les déplacements sup"""

    import numpy as NP
    import copy
    from Utilitai.Utmess import UTMESS

    abscq = getattr(tabQi, 'ABSC_CURV').values()

    if FOND_FISS:

        nbval = len(abscq)
        abscq = NP.array(abscq[:nbval])

        dxs = NP.array(tabQi['DX'].values()['DX'][:nbval])
        dys = NP.array(tabQi['DY'].values()['DY'][:nbval])

        Sxs = NP.array(tabQi['SIXX'].values()['SIXX'][:nbval])
        Sys = NP.array(tabQi['SIYY'].values()['SIYY'][:nbval])

        if ndim == 2:
            dzs = NP.zeros(nbval)
            Szs = NP.zeros(nbval)

        elif ndim == 3:
            dzs = NP.array(tabQi['DZ'].values()['DZ'][:nbval])
            Szs = NP.array(tabQi['SIZZ'].values()['SIZZ'][:nbval])

    dq = NP.asarray([dxs, dys, dzs])
    Sq = NP.asarray([Sxs, Sys, Szs])
    return (abscq, dq, Sq)

#-------------------------------------------------------------------------
# Returns the matrix of change of reference """

def get_pgl(syme_char, FISSURE, ino, VDIR, VNOR, dicVDIR, dicVNOR, Lnofon, ndim):
    """retourne la matrice du changement de repère"""
    import numpy as NP

    if FISSURE:
        v1 = VNOR[ino]
        v2 = VDIR[ino]

    elif not FISSURE:
        v1 = dicVNOR[Lnofon[ino]]
        v2 = dicVDIR[Lnofon[ino]]

    v1 = normalize(v1)
    v2 = normalize(v2)

    if ndim == 2:
        # on prend comme vecteur de direction de propa une rotation de -90 du
        # vecteur normal
        v2 = NP.array([v1[1], -v1[0], 0])

    v3 = NP.cross(v1, v2)
    pgl = NP.asarray([v1, v2, v3])
    return (pgl)

#-------------------------------------------------------------------------
# Jump displacement  

def get_saut(self, pgl, ds, Ss, di, Si, Sh, Sv, Sq, INFO, FISSURE, syme_char, abscs, ndim):
    """retourne le saut de déplacements dans le nouveau repère"""

    from Accas import _F
    import aster
    import numpy as NP
    from Utilitai.Utmess import UTMESS

    CREA_TABLE = self.get_cmd('CREA_TABLE')
    DETRUIRE = self.get_cmd('DETRUIRE')

    Sig_Y=1.

    dpls = NP.dot(pgl, ds)
    Spls = NP.dot(pgl, Ss)
    Splh = NP.dot(pgl, Sh)
    Splv = NP.dot(pgl, Sv)
    Splq = NP.dot(pgl, Sq)

    sauttt=NP.zeros (shape=(3,len (Spls[0])))
    sauttt [0]= NP.array ([[abs(Splh[1][j])-abs(Splv[0][j]) for j in range (len (Spls[1]))]])
    sauttt [1]= NP.array ([[(Splq[0][j])/Sig_Y for j in range (len (Spls[1]))]])

    if ndim == 3:
        sauttt [2]= NP.array ([[Spls[2][j]/((Spls[1][j])+(Spls[0][j])) for j in range (len (Spls[2]))]])

    sautt = Spls
 
    for i in range(1,len(dpls[0])):
        dpls[1][i]=dpls[1][i]-dpls[1][0]
    
        dpls[0][i]=0
        dpls[2][i]=0
    
    dpls[1][0]=0

    if FISSURE:
        saut = 2.*dpls
        sautt = Spls      

    elif syme_char == 'NON':
        dpli = NP.dot(pgl, di)
        Spli = NP.dot(pgl, Si)
        for i in range(1,len(dpli[0])):
                dpli[1][i]=dpli[1][i]-dpli[1][0]
                dpli[0][i]=0
                dpli[2][i]=0
    
        dpli[1][0]=0
        saut = -2.*dpls
        sautt = Spls 

    else:
        dpli = [NP.multiply(dpls[0], -1.), dpls[1], dpls[2]]
        Spli = [NP.multiply(Spls[0], -1.), Spls[1], Spls[2]]

        saut = -1.*dpls
        sautt = Spls

    if INFO == 2 :

        mcfact = []
        mcfact.append(_F(PARA='ABSC_CURV', LISTE_R=abscs.tolist()))
        if not FISSURE:
            mcfact.append(_F(PARA='DEPL_SUP_1', LISTE_R=dpls[1].tolist()))
            mcfact.append(_F(PARA='DEPL_INF_1', LISTE_R=dpli[1].tolist()))

            mcfact.append(_F(PARA='STRESS_SUP_1', LISTE_R=Spls[1].tolist()))
            mcfact.append(_F(PARA='STRESS_INF_1', LISTE_R=Spli[1].tolist()))


        mcfact.append(_F(PARA='T_Dis_B', LISTE_R=saut[1].tolist()))
        mcfact.append(_F(PARA='T_Str_B', LISTE_R=sautt[1].tolist()))

        mcfact.append(_F(PARA='T_Str_F', LISTE_R=sauttt[0].tolist()))
        mcfact.append(_F(PARA='Q_Parameter', LISTE_R=sauttt[1].tolist()))

        if ndim == 3:
               mcfact.append(_F(PARA='Tz_parameter', LISTE_R=sauttt[2].tolist()))

        __resu0 = CREA_TABLE(LISTE=mcfact, TITRE='--> SAUTS')
        aster.affiche('MESSAGE', __resu0.EXTR_TABLE().__repr__())
        DETRUIRE(CONCEPT=_F(NOM=__resu0), INFO=1)

    return (saut,sautt,sauttt)

#-------------------------------------------------------------------------

def get_kgsig(saut, sautt, sauttt, nbval, coetd):
    """retourne des trucs...."""
    import numpy as NP

    isig = NP.sign(NP.transpose(NP.resize(saut[:, -1], (nbval - 1, 3))))
    isig = NP.sign(isig + 0.001)

    isigt = NP.sign(NP.transpose(NP.resize(sautt[:, -1], (nbval - 1, 3))))
    isigt = NP.sign(isigt +0.001)

    isigtt = NP.sign(NP.transpose(NP.resize(sauttt[:, -1], (nbval - 1, 3))))
    isigtt = NP.sign(isigtt +0.001)


    saut2 = saut * \
        NP.array([[coetd] * nbval, [coetd] * nbval, [coetd] * nbval])

    sautt2 = sautt * \
        NP.array([[1] * nbval, [1] * nbval, [1] * nbval])

    sauttt2 = sauttt * \
        NP.array([[1] * nbval, [1] * nbval, [1] * nbval])

    tsig = isig[:, 1]
    tsig = NP.array([tsig, tsig])
    tsig = NP.transpose(tsig)
    tgsig = NP.resize(tsig, (1, 6))[0]


    ttsig = isigt[:, 1]
    ttsig = NP.array([ttsig, ttsig])
    ttsig = NP.transpose(ttsig)
    ttgsig = NP.resize(ttsig, (1, 6))[0]


    tttsig = isigtt[:, 1]
    tttsig = NP.array([tttsig, tttsig])
    tttsig = NP.transpose(tttsig)
    tttgsig = NP.resize(tttsig, (1, 6))[0]
    return (isig, isigt, isigtt, tgsig, ttgsig, tttgsig, saut2, sautt2 , sauttt2)

#-------------------------------------------------------------------------

def get_meth1(self, abscs, absch, abscq, coetd, isig, tgsig,isigt,ttgsig, isigtt, tttgsig, saut2, sautt2, sauttt2, INFO, ndim):
    """retourne kg1"""
    from Accas import _F
    import aster
    import numpy as NP
    import math 

    CREA_TABLE = self.get_cmd('CREA_TABLE')
    DETRUIRE = self.get_cmd('DETRUIRE')

    nabs = len(abscs)
    nabh = len (absch)  
    nabq = len (abscq) 


# --- Calculation of T
    x1= abscs[5:-1]
    x2 = abscs[6:nabs]

    xt1= absch[5:-1]
    xt2= absch[6:nabh]

    xq1 = abscq[5:-1]
    xq2 = abscq[6:nabq]

    y1 = saut2[:, 5:-1] / x1
    y2 = saut2[:, 6:nabs] / x2

    ys1 = sautt2[:, 5:-1] 
    ys2 = sautt2[:, 6:nabs]

    yt1 = sauttt2[:, 5:-1] 
    yt2 = sauttt2[:, 6:nabh]

    yq1 = sauttt2[:, 5:-1] 
    yq2 = sauttt2[:, 6:nabq]

    t = y1 - x1 * (y2 - y1) / (x2 - x1)
    ts = ys1 - x1 * (ys2 - ys1) / (x2 - x1)
    th = y1 - x1 * (y2 - y1) / (x2 - x1)
    tq = y1 - x1 * (y2 - y1) / (x2 - x1)

    vt = abs(t)  * isig[:, 4:-1]
    st = abs(ts) * isigt [:, 4:-1]
    sh = abs(th) * isigtt[:, 4:-1]
    sq = abs(tq) * isigtt[:, 4:-1]

    tg1 = [max(vt[1.,:]), min(vt[1.,:]), max(vt[1.,:]), min(vt[1.,:]), max(vt[1.,:]), min(vt[1.,:]), max(vt[1,:]), min(vt[1,:]), max(vt[1,:]), min(vt[1.,:]),]

    if INFO == 2:
        mcfact = []
        mcfact.append(_F(PARA='ABSC_CURV_1', LISTE_R=x1.tolist()))
        mcfact.append(_F(PARA='Td', LISTE_R=vt[1].tolist()))
        __resu1 = CREA_TABLE(LISTE=mcfact, TITRE='--> METHODE 1')
        aster.affiche('MESSAGE', __resu1.EXTR_TABLE().__repr__())
        DETRUIRE(CONCEPT=_F(NOM=__resu1), INFO=1)

    return (tg1)

#-------------------------------------------------------------------------

def get_erreur(self, ndim, __tabi, type_para):
    """retourne l'erreur selon les méthodes.
    En FEM/X-FEM, on ne retient que le K_MAX de la méthode 1."""
    from Accas import _F
    import aster
    import string
    import numpy as NP

    CREA_TABLE = self.get_cmd('CREA_TABLE')
    CALC_TABLE = self.get_cmd('CALC_TABLE')
    DETRUIRE = self.get_cmd('DETRUIRE')
    FORMULE = self.get_cmd('FORMULE')

    labels = ['Td_MAX', 'Td_MIN']

    index = 1

    py_tab = __tabi.EXTR_TABLE()

    nlines = len(py_tab.values()[py_tab.values().keys()[0]])
    err = NP.zeros((index, nlines / 3))
    kmax = [0.] * index
    kmin = [0.] * index

    for i in range(nlines / 3):
        for j in range(index):
            kmax[j] = max(__tabi[labels[2 * j], 3 * i + 1], __tabi[
                          labels[2 * j], 3 * i + 2], __tabi[labels[2 * j], 3 * i + 3])
            kmin[j] = min(__tabi[labels[2 * j + 1], 3 * i + 1], __tabi[
                          labels[2 * j + 1], 3 * i + 2], __tabi[labels[2 * j + 1], 3 * i + 3])
        kmaxmax = max(kmax)
        if NP.fabs(kmaxmax) > 1e-15:
            for j in range(index):
                err[j, i] = (kmax[j] - kmin[j]) / kmaxmax

    # filter method 1 line
    imeth = 1
    __tabi = CALC_TABLE(TABLE=__tabi,
                        reuse=__tabi,
                        ACTION=_F(OPERATION='FILTRE',
                                  CRIT_COMP='EQ',
                                  VALE=imeth,
                                  NOM_PARA='METHODE')
                        )

    # rename k parameters
    __tabi = CALC_TABLE(TABLE=__tabi,
                        reuse=__tabi,
                        ACTION=(
                            _F(OPERATION='RENOMME', NOM_PARA=('Td_MAX', 'Td')),
                        ))
    # create error
    if ndim != 3:
        __tini = CREA_TABLE(
            LISTE=(
                _F(LISTE_R=(
                    tuple(
                        __tabi.EXTR_TABLE().values()['Td'])), PARA='Td'),

                _F(LISTE_R=(
                   tuple(
                   err[0].tolist())), PARA='ERR_Td'),
               ))
    else:
        __tini = CREA_TABLE(
            LISTE=(
                _F(LISTE_R=(
                    tuple(
                        __tabi.EXTR_TABLE().values()['Td'])), PARA='Td'),
                _F(LISTE_R=(
                   tuple(
                   err[0].tolist())), PARA='ERR_Td'),
                    ))



    # add error
    __tabi = CALC_TABLE(TABLE=__tabi, reuse=__tabi, ACTION=(
        _F(OPERATION='COMB', NOM_PARA='Td', TABLE=__tini)), INFO=1)

    # remove kj_min + sort data
    params = ()
    if ('FISSURE' in __tabi.EXTR_TABLE().para):
        params = ('FISSURE',)
    elif ('FOND_FISS' in __tabi.EXTR_TABLE().para):
        params = ('FOND_FISS',)

    if ('NUME_FOND' in __tabi.EXTR_TABLE().para):
        params = params + ('NUME_FOND',)

    if (type_para in __tabi.EXTR_TABLE().para):
        params = params + (type_para,)

    if ('NUME_ORDRE' in __tabi.EXTR_TABLE().para):
        params = params + ('NUME_ORDRE',)

    if ('NOEUD_FOND' in __tabi.EXTR_TABLE().para):
        params = params + ('NOEUD_FOND',)
    if ('NUM_PT' in __tabi.EXTR_TABLE().para):
        params = params + ('NUM_PT',)

    if ('ABSC_CURV' in __tabi.EXTR_TABLE().para):
        params = params + ('ABSC_CURV',)

    params = params + ('Td', 'ERR_Td')

    __tabi = CALC_TABLE(TABLE=__tabi,
                        reuse=__tabi, ACTION=(
                            _F(OPERATION='EXTR', NOM_PARA=tuple(params))),
                        TITRE="CALCUL DES FACTEURS D'INTENSITE DES CONTRAINTES PAR LA METHODE POST_T_Q")
    return __tabi

#-------------------------------------------------------------------------
def get_tabout(
    self, tg, args, TITRE, FOND_FISS, MODELISATION, FISSURE, ndim, ino, inst, iord,
        Lnofon, dicoF, absfon, Nnoff, tabout, type_para, nume):
    """retourne la table de sortie"""
    from Accas import _F
    from Utilitai.utils import get_titre_concept
    import numpy as NP

    CREA_TABLE = self.get_cmd('CREA_TABLE')
    DETRUIRE = self.get_cmd('DETRUIRE')
    CALC_TABLE = self.get_cmd('CALC_TABLE')

    mcfact = []

    if TITRE != None:
        titre = TITRE
    else:
        titre = get_titre_concept()

    if FOND_FISS and MODELISATION == '3D':
        mcfact.append(_F(PARA='FOND_FISS', LISTE_K=[FOND_FISS.nom, ] * 3))
        mcfact.append(_F(PARA='NUME_FOND', LISTE_I=[1, ] * 3))
        mcfact.append(_F(PARA='NOEUD_FOND', LISTE_K=[Lnofon[ino], ] * 3))
        mcfact.append(_F(PARA='NUM_PT', LISTE_I=[ino + 1, ] * 3))
        mcfact.append(_F(PARA='ABSC_CURV', LISTE_R=[dicoF[Lnofon[ino]]] * 3))

    if FISSURE and MODELISATION == '3D':
        mcfact.append(_F(PARA='FISSURE', LISTE_K=[FISSURE.nom, ] * 3))
        mcfact.append(_F(PARA='NUME_FOND', LISTE_I=[args['NUME_FOND'], ] * 3))
        mcfact.append(_F(PARA='NUM_PT', LISTE_I=[ino + 1, ] * 3))
        mcfact.append(_F(PARA='ABSC_CURV', LISTE_R=[absfon[ino], ] * 3))

    if FISSURE and MODELISATION != '3D' and Nnoff != 1:
        mcfact.append(_F(PARA='FISSURE', LISTE_K=[FISSURE.nom, ] * 3))
        mcfact.append(_F(PARA='NUM_PT', LISTE_I=[ino + 1, ] * 3))

    mcfact.append(_F(PARA='METHODE', LISTE_I=(1, 2, 3)))
    mcfact.append(_F(PARA='Td_MAX', LISTE_R=tg[2].tolist()))
    mcfact.append(_F(PARA='Td_MIN', LISTE_R=tg[3].tolist()))

    if (ino == 0 and iord == 0) and inst == None:
        tabout = CREA_TABLE(LISTE=mcfact, TITRE=titre)

        get_erreur(self, ndim, tabout, type_para)
    elif iord == 0 and ino == 0 and inst != None:
        mcfact = [_F(PARA='NUME_ORDRE', LISTE_I=nume)] + mcfact
        mcfact = [_F(PARA=type_para, LISTE_R=[inst, ] * 3)] + mcfact
        tabout = CREA_TABLE(LISTE=mcfact, TITRE=titre)
        get_erreur(self, ndim, tabout, type_para)
    else:
        if inst != None:
            mcfact = [_F(PARA='NUME_ORDRE', LISTE_I=nume)] + mcfact
            mcfact = [_F(PARA=type_para, LISTE_R=[inst, ] * 3)] + mcfact
        __tabi = CREA_TABLE(LISTE=mcfact,)

        npara = ['Td']

        if inst != None:
            npara.append(type_para)
        if not FISSURE and MODELISATION == '3D':
            npara.append('NOEUD_FOND')
        elif FISSURE and MODELISATION == '3D':
            npara.append('NUM_PT')

        get_erreur(self, ndim, __tabi, type_para)
        tabout = CALC_TABLE(reuse=tabout,
                            TABLE=tabout,
                            TITRE=titre,
                            ACTION=_F(OPERATION='COMB',
                                      NOM_PARA=npara,
                                      TABLE=__tabi,))


    return tabout

#---------------------------------------------------------------------------------------------------------------
#                 CORPS DE LA MACRO POST_T_Q
#-------------------------------------------------------------------------
def post_t_q_ops(self, MODELISATION, FOND_FISS, FISSURE, MATER, RESULTAT,
                      ABSC_CURV_MAXI, PREC_VIS_A_VIS, INFO, TITRE, **args):
    """
    Macro POST_T_Q
    Calcul des facteurs d'intensité de contraintes en 2D et en 3D
    par extrapolation des sauts de déplacements sur les lèvres de
    la fissure. Produit une table.

    """
    import aster
    import string as S
    import numpy as NP
    from math import pi
    from types import ListType, TupleType
    from Accas import _F
    from Utilitai.Table import Table, merge
    from SD.sd_mater import sd_compor1
    from Cata.cata import mode_meca
    from Utilitai.Utmess import UTMESS, MasquerAlarme, RetablirAlarme

    EnumTypes = (ListType, TupleType)

    ier = 0
    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)

    # Le concept sortant (de type table_sdaster ou dérivé) est tab
    self.DeclareOut('tabout', self.sd)

    tabout = []
    liste_noeu_a_extr = []

    # On importe les definitions des commandes a utiliser dans la macro
    # Le nom de la variable doit etre obligatoirement le nom de la commande
    CALC_TABLE = self.get_cmd('CALC_TABLE')
    POST_RELEVE_T = self.get_cmd('POST_RELEVE_T')
    DETRUIRE = self.get_cmd('DETRUIRE')

    LIRE_MAILLAGE = self.get_cmd('LIRE_MAILLAGE')
    DEFI_GROUP = self.get_cmd('DEFI_GROUP')

    EVOL_THER = None

#  on masque cette alarme, voire explication fiche 18070
    MasquerAlarme('CALCULEL4_9')


    if args.has_key('EVOL_THER'):
        if args['EVOL_THER'] != None:
            EVOL_THER = args['EVOL_THER']

#   ------------------------------------------------------------------
#                         CARACTERISTIQUES MATERIAUX
#   ------------------------------------------------------------------
    matph = MATER.sdj.NOMRC.get()
    phenom = None
    ind = 0
    for cmpt in matph:
        ind = ind + 1
        if cmpt[:4] == 'ELAS':
            phenom = cmpt
            break
    if phenom == None:
        UTMESS('F', 'RUPTURE0_5')
    ns = '{:06d}'.format(ind)

#  RECHERCHE SI LE MATERIAU DEPEND DE LA TEMPERATURE:

    compor = sd_compor1('%-8s.CPT.%s' % (MATER.nom, ns))
    valk = [s.strip() for s in compor.VALK.get()]
    valr = compor.VALR.get()
    dicmat = dict(zip(valk, valr))

#  PROPRIETES MATERIAUX INDEPENDANTES DE LA TEMPERATURE
    e = dicmat['E']
    nu = dicmat['NU']

#  PROPRIETES MATERIAUX DEPENDANTES DE LA TEMPERATURE
    Tempe3D = False

    if e == 0.0 and nu == 0.0:
        list_oper = valk[: len(valk) / 2]
        list_fonc = valk[len(valk) / 2:]
#     valk contient les noms des operandes mis dans defi_materiau dans une premiere partie et
#     et les noms des concepts de type [fonction] (ecrits derriere les operandes) dans une
#     une seconde partie

        try:
            list_oper.remove("B_ENDOGE")
        except ValueError:
            pass
        try:
            list_oper.remove("RHO")
        except ValueError:
            pass
        try:
            list_oper.remove("PRECISION")
        except ValueError:
            pass
        try:
            list_oper.remove("K_DESSIC")
        except ValueError:
            pass
        try:
            list_oper.remove("TEMP_DEF_ALPHA")
        except ValueError:
            pass

        nom_fonc_e = self.get_concept(list_fonc[list_oper.index("E")])
        nom_fonc_nu = self.get_concept(list_fonc[list_oper.index("NU")])
        nom_fonc_e_prol = nom_fonc_e.sdj.PROL.get()[0].strip()
        nom_fonc_nu_prol = nom_fonc_nu.sdj.PROL.get()[0].strip()

#        on verifie que les fonctions dependent bien que de la temperature
        if ((nom_fonc_e.Parametres()['NOM_PARA'] != 'TEMP' and nom_fonc_e_prol != 'CONSTANT') or
                (nom_fonc_nu.Parametres()['NOM_PARA'] != 'TEMP' and nom_fonc_nu_prol != 'CONSTANT')):
            UTMESS('F', 'RUPTURE1_67')

        if dicmat.has_key('TEMP_DEF_ALPHA') and not EVOL_THER:
            nompar = ('TEMP',)
            valpar = (dicmat['TEMP_DEF_ALPHA'],)
            UTMESS('A', 'RUPTURE0_6', valr=valpar)
            nomres = ['E', 'NU']
            valres, codret = MATER.RCVALE('ELAS', nompar, valpar, nomres, 2)
            if (nom_fonc_e_prol == 'CONSTANT'):
                e = nom_fonc_e.Ordo()[0]
            else:
                e = valres[0]

            if (nom_fonc_nu_prol == 'CONSTANT'):
                nu = nom_fonc_nu.Ordo()[0]
            else:
                nu = valres[1]

        if not dicmat.has_key('TEMP_DEF_ALPHA') and not EVOL_THER:
            UTMESS('F', 'RUPTURE0_33')

    if FOND_FISS and EVOL_THER:
# on recupere juste le nom du resultat thermique (la température est
# variable de commande)
        ndim = 3
        Tempe3D = True
        resuth = S.ljust(EVOL_THER.nom, 8).rstrip()

    if not Tempe3D:

        if e == 0.0:
            UTMESS('F', 'RUPTURE0_53')

        coetd = e * 1

        unmnu2 = 1. - nu ** 2
        unpnu = 1. + nu


        if MODELISATION == '3D':
            coefk = 'Td '
            ndim = 3
            coetd = coetd / (1. * unmnu2)
            coetg3 = unpnu / e

        elif MODELISATION == 'AXIS':
            ndim = 2
            coetd = coetd / (1. * unmnu2)
            coetg3 = unpnu / e

        elif MODELISATION == 'D_PLAN':
            coefk = 'Td'
            ndim = 2
            coetd = coetd / (1. * unmnu2)
            coetg3 = unpnu / e

        elif MODELISATION == 'C_PLAN':
            coefk = 'Td'
            ndim = 2
            coetd = coetd / 1.
            coetg3 = unpnu / e

        else:
            UTMESS('F', 'RUPTURE0_33')

    assert (ndim == 2 or ndim == 3)

    try:
        TYPE_MAILLAGE = args['TYPE_MAILLAGE']
    except KeyError:
        TYPE_MAILLAGE = []

#  ------------------------------------------------------------------
#  I. CAS FOND_FISS
#  ------------------------------------------------------------------
    if FOND_FISS:

        iret, ibid, nom_ma = aster.dismoi(
            'NOM_MAILLA', RESULTAT.nom, 'RESULTAT', 'F')
        MAILLAGE = self.get_concept(nom_ma.strip())

        NB_NOEUD_COUPE = args['NB_NOEUD_COUPE']

#     Verification que les levres sont bien en configuration initiale collees
#     -----------------------------------------------------------------------

        verif_config_init(FOND_FISS)

#     Verification du type des mailles de FOND_FISS
#     ---------------------------------------------
        verif_type_fond_fiss(ndim, FOND_FISS)

#     Recuperation de la liste des noeuds du fond issus de la sd_fond_fiss : Lnoff, de longueur Nnoff
#     --------------------------------------------------------------------

        Lnoff = get_noeud_fond_fiss(FOND_FISS)
        Nnoff = len(Lnoff)

#     Creation de la liste des noeuds du fond a calculer : Lnocal, de longueur Nnocal
#     (obtenue par restriction de Lnoff avec TOUT, NOEUD, SANS_NOEUD)
#     --------------------------------------------------------------------

        Lnocal = get_noeud_a_calculer(
            Lnoff, ndim, FOND_FISS, MAILLAGE, EnumTypes, args)
        Nnocal = len(Lnocal)

#     Recuperation de la liste des mailles de la lèvre supérieure
#     ------------------------------------------------------------

        ListmaS = FOND_FISS.sdj.LEVRESUP_MAIL.get()

        if not ListmaS:
            UTMESS('F', 'RUPTURE0_19')

#     Verification de la presence de symetrie
#     ----------------------------------

        iret, ibid, syme_char = aster.dismoi(
            'SYME', FOND_FISS.nom, 'FOND_FISS', 'F')

#     Recuperation de la liste des tailles de maille en chaque noeud du fond
#     ----------------------------------------------------------------------

        if not ABSC_CURV_MAXI:
            list_tail = FOND_FISS.sdj.FOND_TAILLE_R.get()
            tailmax = max(list_tail)
            hmax = tailmax * 4
            UTMESS('I', 'RUPTURE0_32', valr=hmax)
            tailmin = min(list_tail)
            if tailmax > 2 * tailmin:
                UTMESS('A', 'RUPTURE0_17', vali=4, valr=[tailmin, tailmax])
        else:
            hmax = ABSC_CURV_MAXI

#     ------------------------------------------------------------------
#     I.1 SOUS-CAS MAILLAGE LIBRE
#     ------------------------------------------------------------------

#     creation des directions normales et macr_lign_coup
        if TYPE_MAILLAGE == 'LIBRE' or TYPE_MAILLAGE == 'REGLE':

            if syme_char == 'NON':
                ListmaI = FOND_FISS.sdj.LEVREINF_MAIL.get()

#        Dictionnaire des coordonnees des noeuds du fond
            d_coorf = get_coor_libre(self, Lnoff, RESULTAT, ndim)

#        Dictionnaire des vecteurs normaux (allant de la levre inf vers la levre sup) et
#        dictionnaire des vecteurs de propagation
            if ndim == 3:
                DTANOR = FOND_FISS.sdj.DTAN_ORIGINE.get()
                DTANEX = FOND_FISS.sdj.DTAN_EXTREMITE.get()
            elif ndim == 2:
                DTANOR = None
                DTANEX = None
            (dicVDIR, dicVNOR) = get_direction(
                Nnoff, ndim, DTANOR, DTANEX, Lnoff, FOND_FISS)

#        Abscisse curviligne du fond
            if ndim == 3:
                dicoF = get_absfon(Lnoff, Nnoff, d_coorf)


#        Extraction dep sup/inf sur les normales
            iret, ibid, n_modele = aster.dismoi(
                'MODELE', RESULTAT.nom, 'RESULTAT', 'F')
            n_modele = n_modele.rstrip()
            if len(n_modele) == 0:
                UTMESS('F', 'RUPTURE0_18')
            MODEL = self.get_concept(n_modele)

            (__TlibS,__TlibI,__TlibH, __TlibV, __TlibQ) = get_tab_dep(self, Lnocal, Nnocal, d_coorf, dicVDIR, dicVNOR, RESULTAT, MODEL,
                                             ListmaS, ListmaI, NB_NOEUD_COUPE, hmax, syme_char, PREC_VIS_A_VIS, MAILLAGE)

#        A eclaircir
            Lnofon = Lnocal
            Nbnofo = Nnocal

#     ------------------------------------------------------------------
#     I.2 SOUS-CAS MAILLAGE REGLE
#     ------------------------------------------------------------------

        else:
#        Dictionnaires des levres
            dicoS = get_dico_levres('sup', FOND_FISS, ndim, Lnoff, Nnoff)
            dicoI = {}
            if syme_char == 'NON':
                dicoI = get_dico_levres('inf', FOND_FISS, ndim, Lnoff, Nnoff)

#        Dictionnaire des coordonnees et tableau des deplacements
            (d_coor, __tabl_depl) = get_coor_regle(
                self, RESULTAT, ndim, Lnoff, Lnocal, dicoS, syme_char, dicoI)

#        Dictionnaire des vecteurs normaux (allant de la levre inf vers la levre sup) et
#        dictionnaire des vecteurs de propagation
            DTANOR = None
            DTANEX = None
            (dicVDIR, dicVNOR) = get_direction(
                Nnoff, ndim, DTANOR, DTANEX, Lnoff, FOND_FISS)

#        Abscisse curviligne du fond
            if ndim == 3:
                dicoF = get_absfon(Lnoff, Nnoff, d_coor)

#        Noeuds LEVRE_SUP et LEVRE_INF
            (Lnofon, Lnosup, Lnoinf) = get_noeuds_perp_regle(Lnocal, d_coor, dicoS, dicoI, Lnoff,
                                                             PREC_VIS_A_VIS, hmax, syme_char)

            Nbnofo = len(Lnofon)

#  ------------------------------------------------------------------
#  II. CAS X-FEM
#  ------------------------------------------------------------------

    elif FISSURE:

        iret, ibid, nom_ma = aster.dismoi(
            'NOM_MAILLA', RESULTAT.nom, 'RESULTAT', 'F')
        MAILLAGE = self.get_concept(nom_ma.strip())

#     Recuperation de la liste des tailles de maille en chaque noeud du fond
        if not ABSC_CURV_MAXI:
            list_tail = FISSURE.sdj.FOND_TAILLE_R.get()
            tailmax = max(list_tail)
            hmax = tailmax * 5
            UTMESS('I', 'RUPTURE0_32', valr=hmax)
            tailmin = min(list_tail)
            if tailmax > 2 * tailmin:
                UTMESS('A', 'RUPTURE0_17', vali=5, valr=[tailmin, tailmax])
        else:
            hmax = ABSC_CURV_MAXI

        dmax = PREC_VIS_A_VIS * hmax
#        dmax = 5.0* PREC_VIS_A_VIS * hmax

        (xcont, MODEL) = verif_resxfem(self, RESULTAT)
        # incohérence entre le modèle et X-FEM
        if not xcont:
            UTMESS('F', 'RUPTURE0_4')

#     Recuperation du resultat
        __RESX = get_resxfem(self, xcont, RESULTAT, MODELISATION, MODEL)

# Recuperation des coordonnees des points du fond de fissure
# (x,y,z,absc_curv)
        (Coorfo, Vpropa, Nnoff) = get_coor_xfem(args, FISSURE, ndim)

#     Calcul de la direction de propagation en chaque point du fond
        (VDIR, VNOR, absfon) = get_direction_xfem(Nnoff, Vpropa, Coorfo, ndim)

#     Extraction des sauts sur la fissure
        NB_NOEUD_COUPE = args['NB_NOEUD_COUPE']
        TTSo = get_sauts_xfem(
            self, Nnoff, Coorfo, VDIR, hmax, NB_NOEUD_COUPE, dmax, __RESX)

        Lnofon = []
        Nbnofo = Nnoff

#     menage du resultat projete si contact
        if xcont[0] == 3:
            DETRUIRE(CONCEPT=_F(NOM=__RESX), INFO=1)

        affiche_xfem(self, INFO, Nnoff, VNOR, VDIR)

#  ------------------------------------------------------------------

    #  creation des objets vides s'ils n'existent pas
    #  de maniere a pouvoir les passer en argument des fonctions
    # c'est pas terrible : il faudrait harmoniser les noms entre les
    # différents cas
    if '__TlibS' not in locals():
        __TlibS = []
    if '__TlibI' not in locals():
        __TlibI = []
    if '__TlibH' not in locals():
        __TlibH = []
    if '__TlibV' not in locals():
        __TlibV = []
    if '__TlibQ' not in locals():
        __TlibQ = []
    if 'Lnosup' not in locals():
        Lnosup = []
    if 'Lnoinf' not in locals():
        Lnoinf = []
    if 'TTSo' not in locals():
        TTSo = []
    if 'VDIR' not in locals():
        VDIR = []
    if 'VNOR' not in locals():
        VNOR = []
    if 'dicoF' not in locals():
        dicoF = []
    if 'dicVDIR' not in locals():
        dicVDIR = []
    if 'dicVNOR' not in locals():
        dicVNOR = []
    if 'absfon' not in locals():
        absfon = []
    if 'd_coor' not in locals():
        d_coor = []
    if '__tabl_depl' not in locals():
        __tabl_depl = []
    if 'syme_char' not in locals():
        syme_char = 'NON'

#  ------------------------------------------------------------------
#  IV. RECUPERATION DE LA TEMPERATURE AU FOND
#  ------------------------------------------------------------------
    if Tempe3D:
        Rth = self.get_concept(resuth)

        __TEMP = POST_RELEVE_T(
            ACTION=_F(INTITULE='Temperature fond de fissure',
                              NOEUD=Lnofon,
                              TOUT_CMP='OUI',
                                       RESULTAT=Rth,
                                       NOM_CHAM='TEMP',
                                       TOUT_ORDRE='OUI',
                                       OPERATION='EXTRACTION',),)

        tabtemp = __TEMP.EXTR_TABLE()
        DETRUIRE(CONCEPT=_F(NOM=__TEMP), INFO=1)

#  ------------------------------------------------------------------
#  V. BOUCLE SUR NOEUDS DU FOND
#  ------------------------------------------------------------------

    if isinstance(RESULTAT, mode_meca) == True:
        type_para = 'FREQ'
    else:
        type_para = 'INST'

    dico_list_var = RESULTAT.LIST_VARI_ACCES()

    for ino in range(0, Nbnofo):

        if INFO == 2:
            affiche_traitement(FOND_FISS, Lnofon, ino)

#     table 'depsup' et 'depinf'
        

        if ndim == 2:
            if syme_char == 'NON' or syme_char == 'OUI':
                ListmaI = FOND_FISS.sdj.LEVREINF_MAIL.get()

#        Dictionnaire des coordonnees des noeuds du fond
            d_coorf = get_coor_libre(self, Lnoff, RESULTAT, ndim)

#        Dictionnaire des vecteurs normaux (allant de la levre inf vers la levre sup) et
#        dictionnaire des vecteurs de propagation
            if ndim == 3:
                DTANOR = FOND_FISS.sdj.DTAN_ORIGINE.get()
                DTANEX = FOND_FISS.sdj.DTAN_EXTREMITE.get()
            elif ndim == 2:
                DTANOR = None
                DTANEX = None
            (dicVDIR, dicVNOR) = get_direction(
                Nnoff, ndim, DTANOR, DTANEX, Lnoff, FOND_FISS)

#        Abscisse curviligne du fond
            if ndim == 3:
                dicoF = get_absfon(Lnoff, Nnoff, d_coorf)


#        Extraction dep sup/inf sur les normales
            iret, ibid, n_modele = aster.dismoi(
                'MODELE', RESULTAT.nom, 'RESULTAT', 'F')
            n_modele = n_modele.rstrip()
            if len(n_modele) == 0:
                UTMESS('F', 'RUPTURE0_18')
            MODEL = self.get_concept(n_modele)

            (__TlibS,__TlibI,__TlibH, __TlibV, __TlibQ) = get_tab_dep(self, Lnocal, Nnocal, d_coorf, dicVDIR, dicVNOR, RESULTAT, MODEL,
                                             ListmaS, ListmaI, NB_NOEUD_COUPE, hmax, syme_char, PREC_VIS_A_VIS, MAILLAGE)

            tabsup=__TlibS
            tabinf=__TlibI
            tabH  =__TlibH
            tabV  =__TlibV
            tabQ  =__TlibQ
        else:
 
                tabsup = get_tab(self, 'sup', ino, __TlibS, Lnosup, TTSo,
                         FOND_FISS, TYPE_MAILLAGE, __tabl_depl, syme_char)
                
                tabinf = get_tab(self, 'inf', ino, __TlibI, Lnoinf, TTSo,
                         FOND_FISS, TYPE_MAILLAGE, __tabl_depl, syme_char)

                tabH = get_tab(self, 'sup', ino, __TlibH, Lnosup, TTSo,
                         FOND_FISS, TYPE_MAILLAGE, __tabl_depl, syme_char)

                tabV = get_tab(self, 'sup', ino, __TlibV, Lnosup, TTSo,
                         FOND_FISS, TYPE_MAILLAGE, __tabl_depl, syme_char)

                tabQ = get_tab(self, 'sup', ino, __TlibQ, Lnosup, TTSo,
                         FOND_FISS, TYPE_MAILLAGE, __tabl_depl, syme_char)


#     les instants de post-traitement : creation de l_inst
        if type_para == 'FREQ':
            (l_inst, PRECISION, CRITERE) = get_liste_freq(tabsup, args)
        else:
            (l_inst, PRECISION, CRITERE) = get_liste_inst(tabsup, args)

#     récupération de la matrice de changement de repère
        (pgl) = get_pgl(syme_char, FISSURE, ino,
                      VDIR, VNOR, dicVDIR, dicVNOR, Lnofon, ndim)

#     ------------------------------------------------------------------
#                         BOUCLE SUR LES INSTANTS/FREQUENCES
#     ------------------------------------------------------------------
        for iord, inst in enumerate(l_inst):

#        impression de l'instant de calcul
            if INFO == 2:
                affiche_instant(inst, type_para)

#        recuperation de la table au bon instant : tabsupi (et tabinfi)
            tabsupi = get_tab_inst(
                'sup', inst, FISSURE, syme_char, PRECISION, CRITERE, tabsup, tabinf, type_para)

            tabinfi = get_tab_inst(
                'inf', inst, FISSURE, syme_char, PRECISION, CRITERE, tabsup, tabinf, type_para)

            tabHi = get_tab_inst(
                'sup', inst, FISSURE, syme_char, PRECISION, CRITERE, tabH, tabinf, type_para)

            tabVi = get_tab_inst(
                'sup', inst, FISSURE, syme_char, PRECISION, CRITERE, tabV, tabinf, type_para)

            tabQi = get_tab_inst(
                'sup', inst, FISSURE, syme_char, PRECISION, CRITERE, tabQ, tabinf, type_para)


#        recupération des déplacements sup et inf : ds et di
            (abscs, ds, Ss) = get_depl_sup(FOND_FISS, tabsupi,
                                       ndim, Lnofon, d_coor, ino, TYPE_MAILLAGE)

            (absci, di, Si) = get_depl_inf(FOND_FISS, tabinfi, ndim,
                                       Lnofon, syme_char, d_coor, ino, TYPE_MAILLAGE)


            (absch, dh, Sh) = get_depl_H(FOND_FISS, tabHi, ndim,
                                       Lnofon, syme_char, d_coor, ino, TYPE_MAILLAGE) 

            (abscv, dv, Sv) = get_depl_V (FOND_FISS, tabVi, ndim,
                                       Lnofon, syme_char, d_coor, ino, TYPE_MAILLAGE)

            (abscq, dq, Sq) = get_depl_Q (FOND_FISS, tabQi, ndim,
                                       Lnofon, syme_char, d_coor, ino, TYPE_MAILLAGE)


#        récupération des propriétés materiau avec temperature
            if Tempe3D:
                (e, nu, coetd,  coetg,  coetg3 ) = get_propmat_tempe(
                    MATER, tabtemp, Lnofon, ino, inst, PRECISION)

#        TESTS NOMBRE DE NOEUDS
            nbval = len(abscs)

            if nbval < 3:

                UTMESS('A+', 'RUPTURE0_46')
                if FOND_FISS:
                    UTMESS('A+', 'RUPTURE0_47', valk=Lnofon[ino])
                if FISSURE:
                    UTMESS('A+', 'RUPTURE0_99', vali=ino)
                UTMESS('A', 'RUPTURE0_25')

                tg1 = [0.] * 10
                tg2 = [0.] * 10
                tg3 = [0.] * 10

                ts1 = [0.] * 8
                ts2 = [0.] * 8
                ts3 = [0.] * 8

                liste_noeu_a_extr.append(ino)

            else:

#           SI NBVAL >= 3 :

#           calcul du saut de déplacements dans le nouveau repère
                (saut,sautt,sauttt) = get_saut(
                    self, pgl, ds, Ss, di, Si, Sh, Sv, Sq, INFO, FISSURE, syme_char, abscs, ndim)


#           CALCUL T, Tz, Q
                (isig, isigt, isigtt, tgsig, ttgsig, tttgsig, saut2, sautt2, sauttt2) = get_kgsig(saut, sautt, sauttt, nbval, coetd)

#           calcul des K et de G par les methodes 1, 2 et 3
                (tg1) = get_meth1(
                    self, abscs, absch, abscq, coetd, isig, tgsig,isigt,ttgsig, isigtt, tttgsig, saut2, sautt2, sauttt2, INFO, ndim)

            tg = NP.array([tg1, tg1, tg1])
            tg = NP.transpose(tg)


            nume = dico_list_var['NUME_ORDRE'][
                dico_list_var[type_para].index(inst)]

            tabout = get_tabout(
                self, tg, args, TITRE, FOND_FISS, MODELISATION, FISSURE, ndim, ino, inst, iord,
                Lnofon, dicoF, absfon, Nnoff, tabout, type_para, nume)

#     Fin de la boucle sur les instants

#  Fin de la boucle sur les noeuds du fond de fissure

# Si le nombre de noeuds dans la direction normale au fond de fissure est
# insuffisant, on extrapole
    if (ndim == 3) and liste_noeu_a_extr != []:
        expand_values(self, tabout, liste_noeu_a_extr, TITRE, type_para)

#  Tri de la table si nécessaire
    if len(l_inst) != 1 and ndim == 3:
        if type_para == 'FREQ':
            tabout = CALC_TABLE(reuse=tabout,
                                TABLE=tabout,
                                ACTION=_F(OPERATION='TRI',
                                          NOM_PARA=('FREQ', 'ABSC_CURV'),
                                          ORDRE='CROISSANT'))
    
        else:
            tabout = CALC_TABLE(reuse=tabout,
                                TABLE=tabout,
                                ACTION=_F(OPERATION='TRI',
                                          NOM_PARA=('INST', 'ABSC_CURV'),
                                          ORDRE='CROISSANT'))

    return ier
