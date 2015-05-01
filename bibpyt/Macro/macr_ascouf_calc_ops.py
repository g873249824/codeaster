# coding=utf-8
# ======================================================================
# COPYRIGHT (C) 1991 - 2015  EDF R&D                  WWW.CODE-ASTER.ORG
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


def macr_ascouf_calc_ops(
    self, TYPE_MAILLAGE, MAILLAGE, MODELE, CHAM_MATER, CARA_ELEM,
    FOND_FISS, RESU_THER, AFFE_MATERIAU,
    PRES_REP, ECHANGE, TORS_P1, COMPORTEMENT,
    SOLVEUR, CONVERGENCE, NEWTON, RECH_LINEAIRE, ENERGIE,
        INCREMENT, THETA_3D, IMPR_TABLE, IMPRESSION, INFO, TITRE, **args):
    """
       Ecriture de la macro MACR_ASCOUF_CALC
    """
    from Accas import _F
    import types
    import math
    import aster
    from math import pi, sin, cos, sqrt, atan2
    from Utilitai.Utmess import UTMESS
    ier = 0
# On recopie les mots cles affe_materiau et impr_table pour les proteger
    mc_AFFE_MATERIAU = AFFE_MATERIAU
    mc_IMPR_TABLE = IMPR_TABLE
    # On importe les definitions des commandes a utiliser dans la macro
    AFFE_MODELE = self.get_cmd('AFFE_MODELE')
    AFFE_MATERIAU = self.get_cmd('AFFE_MATERIAU')
    AFFE_CARA_ELEM = self.get_cmd('AFFE_CARA_ELEM')
    AFFE_CHAR_THER_F = self.get_cmd('AFFE_CHAR_THER_F')
    DEFI_CONTACT = self.get_cmd('DEFI_CONTACT')
    THER_LINEAIRE = self.get_cmd('THER_LINEAIRE')
    AFFE_CHAR_MECA = self.get_cmd('AFFE_CHAR_MECA')
    STAT_NON_LINE = self.get_cmd('STAT_NON_LINE')
    CALC_CHAMP = self.get_cmd('CALC_CHAMP')
    IMPR_RESU = self.get_cmd('IMPR_RESU')
    IMPR_TABLE = self.get_cmd('IMPR_TABLE')
    DEFI_FOND_FISS = self.get_cmd('DEFI_FOND_FISS')
    CALC_THETA = self.get_cmd('CALC_THETA')
    CALC_G = self.get_cmd('CALC_G')
    POST_RCCM = self.get_cmd('POST_RCCM')
    POST_RELEVE_T = self.get_cmd('POST_RELEVE_T')

    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)
#------------------------------------------------------------------
# DATA
    GRMAIL = ('COUDE', 'PEAUINT', 'PEAUEXT',
              'EXTUBE', 'CLGV', 'FACE1', 'FACE2')
#------------------------------------------------------------------
#
    if mc_IMPR_TABLE != None:
        FLAG = 0
        if (mc_IMPR_TABLE['NOM_PARA'] == None) and (mc_IMPR_TABLE['POSI_ANGUL'] == None) and (mc_IMPR_TABLE['POSI_CURV_LONGI'] == None):
            UTMESS('E', 'ASCOUF0_3')
            return ier
        if (mc_IMPR_TABLE['NOM_PARA'] != None):
            impr_table_nom_para = mc_IMPR_TABLE['NOM_PARA']
            for impt in impr_table_nom_para:
                if impt in ('SI_LONG', 'SI_CIRC', 'SI_RADI'):
                    FLAG = 1
                    if (((impt['ANGLE'] == None) and (impt['POSI_ANGUL'] == None) and (impt['R_CINTR'] == None)) or
                            ((impt['ANGLE'] == None) and (impt['R_CINTR'] == None) and (impt['POSI_CURV_LONGI'] == None))):
                        UTMESS('E', 'ASCOUF0_4')
        if (mc_IMPR_TABLE['NOM_PARA'] == None):
            FLAG = 1
        if not FLAG:
            UTMESS('A', 'ASCOUF0_5')
#
#------------------------------------------------------------------
#
#     --- commande AFFE_MODELE ---
#
    self.DeclareOut('modele', MODELE)
    mcfact = []
    if (TYPE_MAILLAGE[:4] == 'FISS'):
        mcfact.append(
            _F(GROUP_MA=GRMAIL, PHENOMENE='MECANIQUE', MODELISATION='3D'))
    else:
        mcfact.append(
            _F(GROUP_MA=GRMAIL[:5], PHENOMENE='MECANIQUE', MODELISATION='3D'))
    if TORS_P1 != None:
        mcfact.append(
            _F(GROUP_MA='P1', PHENOMENE='MECANIQUE', MODELISATION='DIS_TR'))
        mcfact.append(
            _F(GROUP_MA='P2', PHENOMENE='MECANIQUE', MODELISATION='DIS_TR'))
    modele = AFFE_MODELE(MAILLAGE=MAILLAGE,
                         AFFE=mcfact)
    if ECHANGE != None:                                # modele thermique
        __modthe = AFFE_MODELE(MAILLAGE=MAILLAGE,
                               AFFE=_F(TOUT='OUI',
                                       PHENOMENE='THERMIQUE',
                                       MODELISATION='3D'))

#------------------------------------------------------------------
#
#     --- commande AFFE_MATERIAU (thermique)---
#
    mcfact = []
    for mater in mc_AFFE_MATERIAU:
        if mater['TOUT'] != None:
            mcfact.append(_F(TOUT=mater['TOUT'], MATER=mater['MATER']))
            rccmat = mater['MATER']
        else:
            mcfact.append(_F(GROUP_MA=mater['GROUP_MA'], MATER=mater['MATER']))
            if mater['GROUP_MA'][:5] == 'COUDE':
                if TORS_P1 != None:
                    mcfact.append(_F(GROUP_MA='P1', MATER=mater['MATER']))
                    mcfact.append(_F(GROUP_MA='P2', MATER=mater['MATER']))
                elif (len(mc_AFFE_MATERIAU) == 1):
                    mcfact.append(_F(GROUP_MA='P2', MATER=mater['MATER']))
            elif (mater['BOL'][:3] == 'BOL'):
                mcfact.append(_F(GROUP_MA='P2', MATER=mater['MATER']))

    __affmat = AFFE_MATERIAU(MAILLAGE=MAILLAGE,
                             MODELE=modele,
                             AFFE=mcfact)

#------------------------------------------------------------------
#
#     --- commande AFFE_CARA_ELEM ---
#
    if (TORS_P1 != None):
        motscles = {}
        motscles['DISCRET'] = []
        if (TORS_P1 != None):
            motscles['DISCRET'].append(_F(GROUP_MA='P1',
                                          CARA='K_TR_D_N',
                                          VALE=(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)),)
        motscles['DISCRET'].append(_F(GROUP_MA='P2',
                                      CARA='K_TR_D_N',
                                      VALE=(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)),)
        if CARA_ELEM != None:
            self.DeclareOut('_carael', CARA_ELEM)
        _carael = AFFE_CARA_ELEM(MODELE=modele, **motscles)
#
    if ECHANGE != None:
#------------------------------------------------------------------
#
#     --- commande AFFE_CHAR_THER_F ---
#         condition aux limites
#
        __chther = AFFE_CHAR_THER_F(MODELE=__modthe,
                                    ECHANGE=_F(GROUP_MA='PEAUINT',
                                               COEF_H=ECHANGE['COEF_H'],
                                               TEMP_EXT=ECHANGE['TEMP_EXT'],), )
#------------------------------------------------------------------
#
#     --- calcul thermique ---
#
        if RESU_THER != None:
            self.DeclareOut('_resuth', RESU_THER)
        mcsimp = {}
        if INCREMENT['NUME_INST_INIT'] != None:
            mcsimp['NUME_INST_INIT'] = INCREMENT['NUME_INST_INIT']
        if INCREMENT['NUME_INST_FIN'] != None:
            mcsimp['NUME_INST_FIN'] = INCREMENT['NUME_INST_FIN']
        mcfact = _F(LIST_INST=INCREMENT['LIST_INST'], **mcsimp)
        _resuth = THER_LINEAIRE(MODELE=__modthe,
                                CHAM_MATER=__affmat,
                                ETAT_INIT=_F(STATIONNAIRE='OUI',),
                                EXCIT=_F(CHARGE=__chther,),
                                INCREMENT=mcfact, )
#
#------------------------------------------------------------------
#
#     --- commande AFFE_MATERIAU (mécanique)---
#
    if CHAM_MATER != None:
        self.DeclareOut('_affmth', CHAM_MATER)
    indther = ECHANGE
    mcfact = []
    mcfac2 = []
    for mater in mc_AFFE_MATERIAU:
        if mater['TOUT'] != None:
            mcfact.append(
                _F(TOUT=mater['TOUT'], MATER=mater['MATER'],))
            if indther:
                mcfac2.append(_F(NOM_VARC='TEMP', TOUT='OUI',
                                 EVOL=_resuth, NOM_CHAM='TEMP', VALE_REF=mater['TEMP_REF'],),)
            rccmat = mater['MATER']
        else:
            mcfact.append(
                _F(GROUP_MA=mater['GROUP_MA'], MATER=mater['MATER'],))
            if indther:
                mcfac2.append(_F(NOM_VARC='TEMP', GROUP_MA=mater['GROUP_MA'],
                                 EVOL=_resuth, NOM_CHAM='TEMP', VALE_REF=mater['TEMP_REF'],),)
            if mater['GROUP_MA'][:5] == 'COUDE':
                if TORS_P1 != None:
                    mcfact.append(_F(GROUP_MA='P1', MATER=mater['MATER'],))
                    mcfact.append(_F(GROUP_MA='P2', MATER=mater['MATER'],))
                    if indther:
                        mcfac2.append(_F(NOM_VARC='TEMP', GROUP_MA='P1',
                                         EVOL=_resuth, NOM_CHAM='TEMP', VALE_REF=mater['TEMP_REF'],),)
                        mcfac2.append(_F(NOM_VARC='TEMP', GROUP_MA='P2',
                                         EVOL=_resuth, NOM_CHAM='TEMP', VALE_REF=mater['TEMP_REF'],),)
                elif (len(mc_AFFE_MATERIAU) == 1):
                    mcfact.append(_F(GROUP_MA='P2', MATER=mater['MATER'],))
                    if indther:
                        mcfac2.append(_F(NOM_VARC='TEMP', GROUP_MA='P2',
                                         EVOL=_resuth, NOM_CHAM='TEMP', VALE_REF=mater['TEMP_REF'],),)
            elif (mater['BOL'][:3] == 'BOL'):
                mcfact.append(_F(GROUP_MA='P2', MATER=mater['MATER'],))
                if indther:
                    mcfac2.append(_F(NOM_VARC='TEMP', GROUP_MA='P2',
                                     EVOL=_resuth, NOM_CHAM='TEMP', VALE_REF=mater['TEMP_REF'],),)

    _affmth = AFFE_MATERIAU(MAILLAGE=MAILLAGE,
                            MODELE=modele,
                            AFFE=mcfact,
                            AFFE_VARC=mcfac2,)

#------------------------------------------------------------------
#
#     --- commande AFFE_CHAR_MECA ---
#         condition aux limites de type raccord 3d-poutre
#         ou bien blocage de mouvements rigides en cas d embout
#         a section conique, bol de type gv
#
    motscles = {}
    motscles['LIAISON_ELEM'] = []
    if TORS_P1 != None:
        motscles['LIAISON_ELEM'].append(_F(OPTION='3D_POU',
                                           GROUP_MA_1='EXTUBE',
                                           GROUP_NO_2='P1'))
#
        motscles['LIAISON_ELEM'].append(_F(OPTION='3D_POU',
                                           GROUP_MA_1='CLGV',
                                           GROUP_NO_2='P2'))

        motscles['DDL_IMPO'] = _F(GROUP_NO='P2',
                                  DX=0.0,
                                  DY=0.0,
                                  DZ=0.0,
                                  DRX=0.0,
                                  DRY=0.0,
                                  DRZ=0.0, )
#
    _conlim = AFFE_CHAR_MECA(MODELE=modele, **motscles)
#
#     --- commande AFFE_CHAR_MECA ---
#         chargement mecanique :  pres_rep, effet de fond
#
    if PRES_REP != None:
        motscles = {}
        if (PRES_REP['PRES_LEVRE'] == 'OUI') and (TYPE_MAILLAGE[:4] == 'FISS'):
            motscles[
                'PRES_REP'] = _F(GROUP_MA=('PEAUINT', 'FACE1', 'FACE2'),
                                 PRES = PRES_REP['PRES'],)
        else:
            motscles['PRES_REP'] = _F(GROUP_MA='PEAUINT',
                                      PRES=PRES_REP['PRES'],)
        if PRES_REP['EFFE_FOND_P1'] != 'NON':
            motscles['EFFE_FOND'] = _F(GROUP_MA_INT='BORDTU',
                                       GROUP_MA='EXTUBE',
                                       PRES=PRES_REP['PRES'],)
#
        _chpres = AFFE_CHAR_MECA(MODELE=modele, **motscles)
#
#     --- commande AFFE_CHAR_MECA ---
#         chargement mecanique : torseur d efforts
#
    if TORS_P1 != None:
        _chtor = [None] * 6
        i = 0
        for tors in TORS_P1:
            mcsimp = {}
            if tors['FX'] != None:
                mcsimp['FX'] = tors['FX']
            if tors['FY'] != None:
                mcsimp['FY'] = tors['FY']
            if tors['FZ'] != None:
                mcsimp['FZ'] = tors['FZ']
            if tors['MX'] != None:
                mcsimp['MX'] = tors['MX']
            if tors['MY'] != None:
                mcsimp['MY'] = tors['MY']
            if tors['MZ'] != None:
                mcsimp['MZ'] = tors['MZ']
            mcfact = _F(GROUP_NO='P1', **mcsimp)
            _chtor[i] = AFFE_CHAR_MECA(MODELE=modele,
                                       FORCE_NODALE=mcfact, )
            i = i + 1
#
#     --- commande AFFE_CHAR_MECA ---
#         chargement mecanique :  verif contact levres
#
    if TYPE_MAILLAGE in ('FISS_COUDE', 'FISS_AXIS_DEB'):
        _chcont = DEFI_CONTACT(MODELE=modele,
                               FORMULATION='DISCRETE',
                               ZONE=_F(GROUP_MA_MAIT='FACE1',
                                       GROUP_MA_ESCL='FACE2',
                                       RESOLUTION='NON',
                                       TOLE_INTERP=1.E-6,
                                       SANS_GROUP_MA='FONDFISS'),)
#
#     --- commande STAT_NON_LINE ---
#
    motscles = {}
#
    mcfex = []  # mot clé facteur EXCIT
    mcfex.append(_F(CHARGE=_conlim,))
    if PRES_REP != None:
        if PRES_REP['FONC_MULT'] != None:
            mcfex.append(_F(CHARGE=_chpres, FONC_MULT=PRES_REP['FONC_MULT']))
        else:
            mcfex.append(_F(CHARGE=_chpres,))
    if TORS_P1 != None:
        i = 0
        for tors in TORS_P1:
            if tors['FONC_MULT'] != None:
                mcfex.append(_F(CHARGE=_chtor[i], FONC_MULT=tors['FONC_MULT']))
            else:
                mcfex.append(_F(CHARGE=_chtor[i],))
            i = i + 1

    contact = None
    if TYPE_MAILLAGE in ('FISS_COUDE', 'FISS_AXIS_DEB'):
        contact = _chcont
    motscles['EXCIT'] = mcfex
#
    if COMPORTEMENT != None:
        mcfci = []
        mcfci.append(_F(GROUP_MA='COUDE', RELATION=COMPORTEMENT['RELATION']))
        if TORS_P1 != None:
            mcfci.append(_F(GROUP_MA='P1', RELATION='ELAS'))
        mcfci.append(_F(GROUP_MA='P2', RELATION='ELAS'))
        motscles['COMPORTEMENT'] = mcfci
#
    dSolveur = SOLVEUR[0].cree_dict_valeurs(SOLVEUR[0].mc_liste)
    for i in dSolveur.keys():
        if dSolveur[i] == None:
            del dSolveur[i]
#
    dConverg = CONVERGENCE[0].cree_dict_valeurs(CONVERGENCE[0].mc_liste)
    for i in dConverg.keys():
        if dConverg[i] == None:
            del dConverg[i]
#
    dNewton = NEWTON[0].cree_dict_valeurs(NEWTON[0].mc_liste)
    for i in dNewton.keys():
        if dNewton[i] == None:
            del dNewton[i]
#
    dRechlin = {}
    if RECH_LINEAIRE != None:
        dRechlin = RECH_LINEAIRE[0].cree_dict_valeurs(
            RECH_LINEAIRE[0].mc_liste)
        for i in dRechlin.keys():
            if dRechlin[i] == None:
                del dRechlin[i]
#
    dIncrem = INCREMENT[0].cree_dict_valeurs(INCREMENT[0].mc_liste)
    for i in dIncrem.keys():
        if dIncrem[i] == None:
            del dIncrem[i]
#
    dEnergie = {}
    if ENERGIE:
        dEnergie = ENERGIE[0].cree_dict_valeurs(ENERGIE[0].mc_liste)
#
    if TITRE != None:
        motscles['TITRE'] = TITRE
    motscles['SOLVEUR'] = dSolveur
    motscles['CONVERGENCE'] = dConverg
    motscles['NEWTON'] = dNewton
    motscles['RECH_LINEAIRE'] = dRechlin
    motscles['INCREMENT'] = dIncrem
    motscles['ENERGIE'] = dEnergie
    self.DeclareOut('nomres', self.sd)

    if contact == None:
        nomres = STAT_NON_LINE(MODELE=modele,
                               CHAM_MATER=_affmth,
                               CARA_ELEM=_carael,
                               INFO=INFO, **motscles)
    else:
        nomres = STAT_NON_LINE(MODELE=modele,
                               CHAM_MATER=_affmth,
                               CARA_ELEM=_carael,
                               CONTACT=contact,
                               INFO=INFO, **motscles)
#
#     --- commande CALC_CHAMP ---
#
    nomres = CALC_CHAMP(reuse=nomres,
                        RESULTAT=nomres,
                        TOUT_ORDRE='OUI',
                        CONTRAINTE='SIGM_ELNO',
                        CRITERES='SIEQ_ELNO',
                        INFO=INFO,)
#
#     --- post-traitements ---
#
    if TYPE_MAILLAGE == 'SOUS_EPAIS_COUDE':
#
#     --- post traitement sous-epaisseurs:  ligaments  ---
#
        if mc_IMPR_TABLE != None:
#
            SECT = ('MI', 'TU', 'GV')
            LIG = ('FDRO', 'EXDR', 'EXTR', 'EXGA',
                   'FGAU', 'INGA', 'INTR', 'INDR')
            if mc_IMPR_TABLE['POSI_ANGUL'] == None:
                ASEP = (mc_IMPR_TABLE['POSI_CURV_LONGI'] / mc_IMPR_TABLE['R_CINTR']) * (
                    180. / pi)
            else:
                ASEP = mc_IMPR_TABLE['POSI_ANGUL']
#
#     moyenne_rccm, invariant et moyenne sur les ligaments dans
#     l epaisseur
#
            l_grno = MAILLAGE.LIST_GROUP_NO()
            __tprl = [None] * 4
            __tlig = [None] * 4
#
#     prelevements des ligaments circonferentiels et longitudinaux
#     de la sous-epaisseur
#
            lgrno = []
            for tgrno in l_grno:
                if tgrno[0][:3] in ('CIR', 'LON'):
                    lgrno.append(tgrno[0])
                elif tgrno[0][:5] == 'PCENT':
                    lgrno.append(tgrno[0])
                elif (tgrno[0][:4] in LIG) and (tgrno[0][4:6] not in ('GV', 'TU', 'MI')):
                    lgrno.append(tgrno[0])
#
            motscles = {}
            motscles['ACTION'] = []
            for grno in lgrno:
                motscles['ACTION'].append(_F(RESULTAT=nomres,
                                             NOM_CHAM='SIGM_ELNO',
                                             TOUT_CMP='OUI',
                                             INTITULE=grno,
                                             GROUP_NO=grno,
                                             OPERATION='EXTRACTION',))
            motscles[
                'TITRE'] = 'TABLE DE POST-TRAITEMENT SECTION SOUS-EPAISSEUR'
            __tprl[1] = POST_RELEVE_T(**motscles)
            __tlig[1] = POST_RCCM(MATER=rccmat,
                                  TYPE_RESU_MECA='EVOLUTION',
                                  OPTION='PM_PB',
                                  TRANSITOIRE=_F(TABL_RESU_MECA=__tprl[1],),)
#
            motscles = {}
            motscles['ACTION'] = []
            for tgrno in lgrno:
                motscles['ACTION'].append(_F(RESULTAT=nomres,
                                             NOM_CHAM='SIGM_ELNO',
                                             INTITULE=tgrno,
                                             GROUP_NO=tgrno,
                                             INVARIANT='OUI',
                                             OPERATION='EXTRACTION',))
            motscles[
                'TITRE'] = 'TABLE DE POST-TRAITEMENT SECTION SOUS-EPAISSEUR'

            __tlig[2] = POST_RELEVE_T(**motscles)
#
            motscles = {}
            nommail = MAILLAGE.nom
            coord = aster.getvectjev(nommail.ljust(8) + '.COORDO    .VALE')
            linomno = aster.getvectjev(nommail.ljust(8) + '.NOMNOE')
            collgrno = aster.getcolljev(nommail.ljust(8) + '.GROUPENO')

            motscles['ACTION'] = []
            for tgrno in lgrno:
                if tgrno[:3] != 'LON':
                    if mc_IMPR_TABLE['TRANSFORMEE'] == 'TUBE':
                        vecty = (0., 0., 1.)
                    else:
                        vecty = (
                            sin(ASEP * pi / 180.), 0., cos(ASEP * pi / 180.))
                else:
                    if mc_IMPR_TABLE['TRANSFORMEE'] == 'TUBE':
                        vecty = (0., 0., 1.)
                    else:
                        grpn = collgrno['FGAUTU'.ljust(24)]
                        LT1 = coord[3 * (grpn[0] - 1) + 2]
                        for node in grpn:
                            X = coord[3 * (node - 1)]
                            Y = coord[3 * (node - 1) + 1]
                            Z = coord[3 * (node - 1) + 2]
                            RCIN = mc_IMPR_TABLE['R_CINTR']
                            if Z < LT1:
                                ANGSEC = 0.
                            elif X < (-1 * RCIN):
                                ANGSEC = mc_IMPR_TABLE['ANGLE'] * pi / 180.
                            else:
                                VCOS = cos(
                                    (-LT1 - Z) / (sqrt((X + RCIN) ** 2 + Y ** 2)))
                                VSIN = sin(
                                    (-LT1 - Z) / (sqrt((X + RCIN) ** 2 + Y ** 2)))
                                ANGSEC = atan2(VSIN, VCOS)
                        vecty = (sin(ANGSEC), 0., cos(ANGSEC))
                motscles['ACTION'].append(_F(RESULTAT=nomres,
                                             NOM_CHAM='SIGM_ELNO',
                                             INTITULE=tgrno,
                                             GROUP_NO=tgrno,
                                             NOM_CMP=(
                                                 'SIXX', 'SIYY', 'SIZZ', 'SIXY', 'SIXZ', 'SIYZ',),
                                             REPERE='LOCAL',
                                             VECT_Y=vecty,
                                             OPERATION='MOYENNE',))
            motscles[
                'TITRE'] = 'TABLE DE POST-TRAITEMENT SECTION SOUS-EPAISSEUR'
            __tlig[3] = POST_RELEVE_T(**motscles)
#
#     prelevements des ligaments sur les sections MI,TU et GV
#     les 8 ligaments sont tous les 45 degres
#
            ACOUR = mc_IMPR_TABLE['ANGLE'] * pi / 180.0
            __sprl = [None] * 3
            __srcm = [None] * 3
            __sinv = [None] * 3
            __smoy = [None] * 3
            for i in range(3):
                if mc_IMPR_TABLE['TRANSFORMEE'] == 'TUBE':
                    vecty = (0., 0., 1.)
                else:
                    if i == 0:
                        vecty = (sin(ACOUR / 2.), 0., cos(ACOUR / 2.))
                    if i == 1:
                        vecty = (0., 0., 1.)
                    if i == 2:
                        vecty = (sin(ACOUR), 0., cos(ACOUR))
                motscles = {}
                motscles[
                    'TITRE'] = 'TABLE DE POST-TRAITEMENT MOYENNE RCCM SECTION ' + SECT[i]
#
#        moyenne RCCM sur les sections MI,TU et GV
#
                motscles = {}
                motscles['ACTION'] = []
                for j in range(8):
                    motscles['ACTION'].append(_F(RESULTAT=nomres,
                                                 NOM_CHAM='SIGM_ELNO',
                                                 TOUT_CMP='OUI',
                                                 INTITULE=LIG[j] + SECT[i],
                                                 GROUP_NO=LIG[j] + SECT[i],
                                                 OPERATION='EXTRACTION',))
                motscles[
                    'TITRE'] = 'TABLE DE POST-TRAITEMENT MOYENNE RCCM SECTION ' + SECT[i]
                __sprl[i] = POST_RELEVE_T(**motscles)
                __srcm[i] = POST_RCCM(MATER=rccmat,
                                      TYPE_RESU_MECA='EVOLUTION',
                                      OPTION='PM_PB',
                                      TRANSITOIRE=_F(TABL_RESU_MECA=__sprl[i],),)
#
#        invariants sur les sections MI,TU et GV
#
                motscles = {}
                motscles[
                    'TITRE'] = 'TABLE DE POST-TRAITEMENT INVARIANTS SECTION ' + SECT[i]
                motscles['ACTION'] = []
                for j in range(8):
                    motscles['ACTION'].append(_F(INTITULE=LIG[j] + SECT[i],
                                                 GROUP_NO=LIG[
                                                 j] + SECT[
                                                 i],
                                                 RESULTAT=nomres,
                                                 NOM_CHAM='SIGM_ELNO',
                                                 INVARIANT='OUI',
                                                 OPERATION='EXTRACTION'))
                __sinv[i] = POST_RELEVE_T(**motscles)
#
#        moyennes contraintes sur les sections MI,TU et GV
#
                motscles = {}
                motscles[
                    'TITRE'] = 'TABLE DE POST-TRAITEMENT MOYENNE SECTION ' + SECT[i]
                motscles['ACTION'] = []
                for j in range(8):
                    motscles['ACTION'].append(_F(INTITULE=LIG[j] + SECT[i],
                                                 REPERE='LOCAL',
                                                 VECT_Y=vecty,
                                                 GROUP_NO=LIG[
                                                 j] + SECT[
                                                 i],
                                                 RESULTAT=nomres,
                                                 NOM_CHAM='SIGM_ELNO',
                                                 NOM_CMP=(
                                                 'SIXX', 'SIYY', 'SIZZ', 'SIXY', 'SIXZ', 'SIYZ'),
                                                 OPERATION='MOYENNE'))
                __smoy[i] = POST_RELEVE_T(**motscles)

#
#     impression des valeurs maximales pour chaque sous-epaisseur
#
            if mc_IMPR_TABLE['TOUT_PARA'] == 'OUI':
                list_para = ['TRESCA_MEMBRANE', 'TRESCA_MFLE',
                             'TRESCA', 'SI_LONG', 'SI_RADI', 'SI_CIRC']
            else:
                list_para = mc_IMPR_TABLE['NOM_PARA']
            if 'TRESCA_MEMBRANE' in list_para:
                IMPR_TABLE(TABLE=__tlig[1],
                           FILTRE=_F(NOM_PARA='PM', CRIT_COMP='MAXI'),
                           NOM_PARA=('INTITULE', 'PM'))
            if 'TRESCA_MFLE' in list_para:
                IMPR_TABLE(TABLE=__tlig[1],
                           FILTRE=(_F(NOM_PARA='LIEU', VALE_K='ORIG'),
                                   _F(NOM_PARA='PMB', CRIT_COMP='MAXI'),),
                           NOM_PARA = ('INTITULE', 'PMB'))
                IMPR_TABLE(TABLE=__tlig[1],
                           FILTRE=(_F(NOM_PARA='LIEU', VALE_K='EXTR'),
                                   _F(NOM_PARA='PMB', CRIT_COMP='MAXI'),),
                           NOM_PARA = ('INTITULE', 'PMB'))
            if 'SI_RADI' in list_para:
                IMPR_TABLE(TABLE=__tlig[3],
                           FILTRE=(
                               _F(NOM_PARA='QUANTITE', VALE_K='MOMENT_0'),
                           _F(NOM_PARA='SIXX',   CRIT_COMP='MAXI'),),
                           NOM_PARA = ('INTITULE', 'SIXX'))
            if 'SI_LONG' in list_para:
                IMPR_TABLE(TABLE=__tlig[3],
                           FILTRE=(
                               _F(NOM_PARA='QUANTITE', VALE_K='MOMENT_0'),
                           _F(NOM_PARA='SIYY',   CRIT_COMP='MAXI'),),
                           NOM_PARA = ('INTITULE', 'SIYY'))
            if 'SI_CIRC' in list_para:
                IMPR_TABLE(TABLE=__tlig[3],
                           FILTRE=(
                               _F(NOM_PARA='QUANTITE', VALE_K='MOMENT_0'),
                           _F(NOM_PARA='SIZZ',   CRIT_COMP='MAXI'),),
                           NOM_PARA = ('INTITULE', 'SIZZ'))
            if 'TRESCA' in list_para:
                IMPR_TABLE(TABLE=__tlig[2],
                           NOM_PARA=('INTITULE', 'NOEUD', 'TRESCA',),
                           PAGINATION = 'INTITULE',
                           FILTRE = _F(NOM_PARA='TRESCA',
                                       CRIT_COMP='MAXI'))
#
#     impression des resultats pour chaque sous-epaisseur
#
            if 'TRESCA_MEMBRANE' in list_para:
                IMPR_TABLE(TABLE=__tlig[1],
                           FILTRE=_F(NOM_PARA='LIEU', VALE_K='ORIG'),
                           NOM_PARA=('INTITULE', 'PM'))
            if 'TRESCA_MFLE' in list_para:
                IMPR_TABLE(TABLE=__tlig[1],
                           FILTRE=_F(NOM_PARA='LIEU', VALE_K='ORIG'),
                           NOM_PARA=('INTITULE', 'PMB'))
                IMPR_TABLE(TABLE=__tlig[1],
                           FILTRE=_F(NOM_PARA='LIEU', VALE_K='EXTR'),
                           NOM_PARA=('INTITULE', 'PMB'))
            if 'SI_RADI' in list_para:
                IMPR_TABLE(TABLE=__tlig[3],
                           FILTRE=_F(
                               NOM_PARA='QUANTITE', VALE_K='MOMENT_0'),
                           NOM_PARA=('INTITULE', 'SIXX'))
            if 'SI_LONG' in list_para:
                IMPR_TABLE(TABLE=__tlig[3],
                           FILTRE=_F(
                               NOM_PARA='QUANTITE', VALE_K='MOMENT_0'),
                           NOM_PARA=('INTITULE', 'SIYY'))
            if 'SI_CIRC' in list_para:
                IMPR_TABLE(TABLE=__tlig[3],
                           FILTRE=_F(
                               NOM_PARA='QUANTITE', VALE_K='MOMENT_0'),
                           NOM_PARA=('INTITULE', 'SIZZ'))
            if 'TRESCA' in list_para:
                IMPR_TABLE(TABLE=__tlig[2],
                           NOM_PARA=('INTITULE', 'NOEUD', 'TRESCA',),
                           PAGINATION = 'INTITULE')
#
#     impression des resultats pour les sections MI, TU et GV
#
            for k in range(3):
                if 'TRESCA_MEMBRANE' in list_para:
                    IMPR_TABLE(TABLE=__srcm[k],
                               FILTRE=_F(NOM_PARA='LIEU', VALE_K='ORIG'),
                               NOM_PARA=('INTITULE', 'PM'))
                if 'TRESCA_MFLE' in list_para:
                    IMPR_TABLE(TABLE=__srcm[k],
                               FILTRE=_F(NOM_PARA='LIEU', VALE_K='ORIG'),
                               NOM_PARA=('INTITULE', 'PMB'))
                    IMPR_TABLE(TABLE=__srcm[k],
                               FILTRE=_F(NOM_PARA='LIEU', VALE_K='EXTR'),
                               NOM_PARA=('INTITULE', 'PMB'))
                if 'SI_RADI' in list_para:
                    IMPR_TABLE(TABLE=__smoy[k],
                               FILTRE=_F(
                                   NOM_PARA='QUANTITE', VALE_K='MOMENT_0'),
                               NOM_PARA=('INTITULE', 'SIXX'))
                if 'SI_LONG' in list_para:
                    IMPR_TABLE(TABLE=__smoy[k],
                               FILTRE=_F(
                                   NOM_PARA='QUANTITE', VALE_K='MOMENT_0'),
                               NOM_PARA=('INTITULE', 'SIYY'))
                if 'SI_CIRC' in list_para:
                    IMPR_TABLE(TABLE=__smoy[k],
                               FILTRE=_F(
                                   NOM_PARA='QUANTITE', VALE_K='MOMENT_0'),
                               NOM_PARA=('INTITULE', 'SIZZ'))
                if 'TRESCA' in list_para:
                    IMPR_TABLE(TABLE=__sinv[k],
                               NOM_PARA=('INTITULE', 'NOEUD', 'TRESCA',),
                               PAGINATION = 'INTITULE')
#
    if TYPE_MAILLAGE in ('FISS_COUDE', 'FISS_AXIS_DEB'):
#
#   --- post traitement fissure :  interpénétration des lèvres ----
#
        __tcont = POST_RELEVE_T(ACTION=_F(INTITULE='Contact levres',
                                          GROUP_NO='FACE2',
                                          RESULTAT=nomres,
                                          TOUT_ORDRE='OUI',
                                          NOM_CHAM='VALE_CONT',
                                          NOM_CMP=('CONT', 'JEU'),
                                          OPERATION='EXTRACTION'))
        IMPR_TABLE(TABLE=__tcont,)
        tcont = __tcont.EXTR_TABLE()
        numo = tcont['NUME_ORDRE'].values()['NUME_ORDRE']
        numo = dict([(i, 0) for i in numo]).keys()
        nbinst = len(numo)
        for i in range(1, nbinst + 1):
            tabi = tcont.NUME_ORDRE == i
            nbtot = len(tabi)
            cont_actif = tabi.CONT > 2.5
            nb_no_cont = len(cont_actif)
            if nb_no_cont > 0:
                UTMESS('A', 'ASCOUF0_58', vali=[i, nbtot, nb_no_cont])
#
#   --- post traitement fissure :  calcul de g ----
#
        motscles = {}
        if FOND_FISS != None:
            self.DeclareOut('_fonfis', FOND_FISS)
        if TYPE_MAILLAGE == 'FISS_COUDE':
            motscles['FOND_FISS'] = _F(GROUP_NO='FONDFISS',
                                       VECT_GRNO_ORIG=('PFOR', 'THOR'),
                                       VECT_GRNO_EXTR= ('PFEX', 'THEX'))
        else:
            motscles['FOND_FISS'] = _F(TYPE_FOND='FERME',
                                       GROUP_MA='FONDFISS',
                                       GROUP_NO_ORIG='PFOR',
                                       GROUP_MA_ORIG='MAIL_ORI')
        _fonfis = DEFI_FOND_FISS(MAILLAGE=MAILLAGE,
                                 LEVRE_SUP=_F(GROUP_MA='FACE1'),
                                 LEVRE_INF=_F(GROUP_MA='FACE2'),
                                 INFO=INFO, **motscles
                                 )
        if THETA_3D != None:
            for thet in THETA_3D:
                _nothet = CALC_THETA(MODELE=modele,
                                     FOND_FISS=_fonfis,
                                     THETA_3D=_F(TOUT='OUI',
                                                 MODULE=1.,
                                                 R_INF=thet['R_INF'],
                                                 R_SUP=thet['R_SUP'],),
                                     )
                motscles = {}
                if COMPORTEMENT != None:
                    motscles['COMPORTEMENT'] = _F(
                        RELATION=COMPORTEMENT['RELATION'])
                _nogthe = CALC_G(RESULTAT=nomres,
                                 OPTION='CALC_G_GLOB',
                                 TOUT_ORDRE='OUI',
                                 THETA=_F(THETA=_nothet), **motscles)
#
                IMPR_TABLE(TABLE=_nogthe,)
#
            for thet in THETA_3D:
                motscles = {}
                if COMPORTEMENT != None:
                    motscles['COMPORTEMENT'] = _F(
                        RELATION=COMPORTEMENT['RELATION'])
                if TYPE_MAILLAGE == 'FISS_COUDE':
                    motscles['LISSAGE'] = _F(LISSAGE_THETA='LEGENDRE',
                                             LISSAGE_G='LEGENDRE',
                                             DEGRE=4,)
                elif TYPE_MAILLAGE == 'FISS_AXIS_DEB':
                    motscles['LISSAGE'] = _F(LISSAGE_THETA='LAGRANGE',
                                             LISSAGE_G='LAGRANGE',)
                _nogloc = CALC_G(RESULTAT=nomres,
                                 TOUT_ORDRE='OUI',
                                 THETA=_F(FOND_FISS=_fonfis,
                                          R_INF=thet['R_INF'],
                                          R_SUP=thet['R_SUP'],), **motscles)

                IMPR_TABLE(TABLE=_nogloc,)
#
#     --- commande IMPR_RESU  ---
#
    if IMPRESSION != None:
        mcfresu = []
        motscles = {}
        if IMPRESSION['FORMAT'] == 'IDEAS':
            motscles['VERSION'] = IMPRESSION['VERSION']
        if IMPRESSION['FORMAT'] == 'CASTEM':
            motscles['NIVE_GIBI'] = IMPRESSION['NIVE_GIBI']
        mcfresu.append(_F(MAILLAGE=MAILLAGE, RESULTAT=nomres,))
        if ECHANGE != None:
            motscles = {}
            if IMPRESSION['FORMAT'] == 'IDEAS':
                motscles['VERSION'] = IMPRESSION['VERSION']
            if IMPRESSION['FORMAT'] == 'CASTEM':
                motscles['NIVE_GIBI'] = IMPRESSION['NIVE_GIBI']
            mcfresu.append(_F(RESULTAT=_resuth,))
        IMPR_RESU(MODELE=modele,
                  RESU=mcfresu,
                  FORMAT=IMPRESSION['FORMAT'], **motscles)
#
    return ier
