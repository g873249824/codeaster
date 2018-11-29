# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

def macro_bascule_schema_ops(self, MODELE, CHAM_MATER, CARA_ELEM,
                             INCR_IMPL, INCR_EXPL,
                             SCHEMA_TEMPS_IMPL, SCHEMA_TEMPS_EXPL, SCHEMA_TEMPS_EQUI,
                             COMPORTEMENT_IMPL, COMPORTEMENT_EXPL, CONVERGENCE,
                             EXCIT, NEWTON, ETAT_INIT, LIST_INST_BASCULE, SCHEMA_INIT, EQUILIBRAGE,
                             SOLVEUR, ARCHIVAGE, OBSERVATION, ENERGIE, **args):
    ier = 0
    import copy
    import aster
    import string
    import types
    from code_aster.Cata.Syntax import _F
    from Noyau.N_utils import AsType
    from Utilitai.Utmess import UTMESS, MasquerAlarme, RetablirAlarme
    # On importe les definitions des commandes a utiliser dans la macro
    DYNA_NON_LINE = self.get_cmd('DYNA_NON_LINE')
    CREA_CHAMP = self.get_cmd('CREA_CHAMP')
    DEFI_LIST_REEL = self.get_cmd('DEFI_LIST_REEL')
    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)
    # Le concept sortant (de type evol_noli) est nommé
    # 'nomres' dans le contexte de la macro
    self.DeclareOut('nomres', self.sd)
    #
    motscles = {}
    motscles['MODELE'] = MODELE
    motscles['CHAM_MATER'] = CHAM_MATER
    if CARA_ELEM != None:
        motscles['CARA_ELEM'] = CARA_ELEM

    #
    dexct = []
    for j in EXCIT:
        dexct.append(j.cree_dict_valeurs(j.mc_liste))
        for i in list(dexct[-1].keys()):
            if dexct[-1][i] == None:
                del dexct[-1][i]
    #
    dComp_incri = []
    for j in COMPORTEMENT_IMPL:
        dComp_incri.append(j.cree_dict_valeurs(j.mc_liste))
        for i in list(dComp_incri[-1].keys()):
            if dComp_incri[-1][i] == None:
                del dComp_incri[-1][i]
    #
    dComp_incre = []
    for j in COMPORTEMENT_EXPL:
        dComp_incre.append(j.cree_dict_valeurs(j.mc_liste))
        for i in list(dComp_incre[-1].keys()):
            if dComp_incre[-1][i] == None:
                del dComp_incre[-1][i]
    #
    dincri = []
    for j in INCR_IMPL:
        dincri.append(j.cree_dict_valeurs(j.mc_liste))
        for i in list(dincri[-1].keys()):
            if dincri[-1][i] == None:
                del dincri[-1][i]
    #
    dincre = []
    for j in INCR_EXPL:
        dincre.append(j.cree_dict_valeurs(j.mc_liste))
        for i in list(dincre[-1].keys()):
            if dincre[-1][i] == None:
                del dincre[-1][i]
    #
    dschi = []
    for j in SCHEMA_TEMPS_IMPL:
        dschi.append(j.cree_dict_valeurs(j.mc_liste))
        for i in list(dschi[-1].keys()):
            if dschi[-1][i] == None:
                del dschi[-1][i]
    #
    dsche = []
    for j in SCHEMA_TEMPS_EXPL:
        dsche.append(j.cree_dict_valeurs(j.mc_liste))
        for i in list(dsche[-1].keys()):
            if dsche[-1][i] == None:
                del dsche[-1][i]
    #
    dscheq = []
    for j in SCHEMA_TEMPS_EQUI:
        dscheq.append(j.cree_dict_valeurs(j.mc_liste))
        for i in list(dscheq[-1].keys()):
            if dscheq[-1][i] == None:
                del dscheq[-1][i]
    #
    dnew = []
    for j in NEWTON:
        dnew.append(j.cree_dict_valeurs(j.mc_liste))
        for i in list(dnew[-1].keys()):
            if dnew[-1][i] == None:
                del dnew[-1][i]
    #
    dconv = []
    for j in CONVERGENCE:
        dconv.append(j.cree_dict_valeurs(j.mc_liste))
        for i in list(dconv[-1].keys()):
            if dconv[-1][i] == None:
                del dconv[-1][i]
    #
    dini = []
    for j in ETAT_INIT:
        dini.append(j.cree_dict_valeurs(j.mc_liste))
        for i in list(dini[-1].keys()):
            if dini[-1][i] == None:
                del dini[-1][i]
    #
    dequi = []
    for j in EQUILIBRAGE:
        dequi.append(j.cree_dict_valeurs(j.mc_liste))
        for i in list(dequi[-1].keys()):
            if dequi[-1][i] == None:
                del dequi[-1][i]
    #
    dsolv = []
    for j in SOLVEUR:
        dsolv.append(j.cree_dict_valeurs(j.mc_liste))
        for i in list(dsolv[-1].keys()):
            if dsolv[-1][i] == None:
                del dsolv[-1][i]
    #
    dobs = []
    if type(OBSERVATION) is not type(None):
        for j in OBSERVATION:
            dobs.append(j.cree_dict_valeurs(j.mc_liste))
            for i in list(dobs[-1].keys()):
                if dobs[-1][i] == None:
                    del dobs[-1][i]
    #
    darch = []
    if type(ARCHIVAGE) is not type(None):
        for j in ARCHIVAGE:
            darch.append(j.cree_dict_valeurs(j.mc_liste))
            for i in list(darch[-1].keys()):
                if darch[-1][i] == None:
                    del darch[-1][i]
    #
    dener = []
    if type(ENERGIE) is not type(None):
        for j in ENERGIE:
            dener.append(j.cree_dict_valeurs(j.mc_liste))
            for i in list(dener[-1].keys()):
                if dener[-1][i] == None:
                    del dener[-1][i]
    #
    __L0 = LIST_INST_BASCULE['VALE']
    dincri1 = copy.copy(dincri)
    dincri1[-1]['INST_FIN'] = __L0[0]
    #
    __dtimp = dequi[-1]['PAS_IMPL']
    __dtexp = dequi[-1]['PAS_EXPL']
    #
    __dim = (-1) * len(dComp_incri)
    __lis = list(range(0, __dim, -1))
    __non_lin = 'NON'
    for i in __lis:
        if (dComp_incri[i]['RELATION'] != 'DIS_CHOC' and dComp_incri[i]['RELATION'] != 'ELAS'):
            __non_lin = 'OUI'
            break
    #
    #

    # alarme de DYNA_NON_LINE si les mot-cles de COMPORTEMENT sont renseignes
    # a tort
    MasquerAlarme('COMPOR4_70')

    if SCHEMA_INIT == 'IMPLICITE':
        dincri1 = copy.copy(dincri)
        dincri1[-1]['INST_FIN'] = __L0[0]
        nomres = DYNA_NON_LINE(EXCIT=dexct,
                               COMPORTEMENT=dComp_incri,
                               INCREMENT=dincri1,
                               SCHEMA_TEMPS=dschi,
                               NEWTON=dnew, CONVERGENCE=dconv,
                               SOLVEUR=dsolv, ENERGIE=dener, OBSERVATION=dobs, ARCHIVAGE=darch,
                               ETAT_INIT=dini, **motscles)
        __prc = 'IMPLICITE'
    #
    if SCHEMA_INIT == 'EXPLICITE':
        dincre1 = copy.copy(dincre)
        dincre1[-1]['INST_FIN'] = __L0[0]
        nomres = DYNA_NON_LINE(MASS_DIAG='OUI',
                               EXCIT=dexct,
                               COMPORTEMENT=dComp_incre,
                               INCREMENT=dincre1,
                               SCHEMA_TEMPS=dsche,
                               NEWTON=dnew, CONVERGENCE=dconv,
                               SOLVEUR=dsolv, ENERGIE=dener, OBSERVATION=dobs, ARCHIVAGE=darch,
                               ETAT_INIT=dini, **motscles)

        __prc = 'EXPLICITE'

  #
    __nb = len(__L0)
    j = 1
    while 1:
        #
        if __prc == 'IMPLICITE':
            __Ue = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='DEPL', INST=__L0[j - 1],)
            #
            __Ve = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='VITE', INST=__L0[j - 1],)
            #
            __Ae = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='ACCE', INST=__L0[j - 1],)
            #
            __Ce = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='ELGA_SIEF_R', NOM_CHAM='SIEF_ELGA', INST=__L0[j - 1],)
            #
            __Vae = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='ELGA_VARI_R', NOM_CHAM='VARI_ELGA', INST=__L0[j - 1],)
            dincre1 = copy.copy(dincre)
            dincre1[-1]['INST_INIT'] = __L0[j - 1]
            if (j < __nb):
                dincre1[-1]['INST_FIN'] = __L0[j]
            else:
                del dincre1[-1]['INST_FIN']
            nomres = DYNA_NON_LINE(reuse=nomres,
                                   EXCIT=dexct,
                                   ETAT_INIT=_F(
                                       DEPL=__Ue, VITE=__Ve, ACCE=__Ae,
                                   SIGM=__Ce, VARI=__Vae,),
                                   COMPORTEMENT=dComp_incre,
                                   INCREMENT=dincre1,
                                   SCHEMA_TEMPS=dsche,
                                   SOLVEUR=dsolv, ENERGIE=dener, OBSERVATION=dobs, ARCHIVAGE=darch,
                                   NEWTON=dnew, CONVERGENCE=dconv, **motscles)
            #
            __prc = 'EXPLICITE'
            bool = (j != (__nb))
            if (not bool):
                break
            j = j + 1
            #
        if __prc == 'EXPLICITE':
            # calcul sur la zone de recouvrement
            print('Calcul d''une solution explicite stabilisée')
            __U1 = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='DEPL', INST=__L0[j - 1],)
            #
            __V1 = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='VITE', INST=__L0[j - 1],)
            #
            __A1 = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='ACCE', INST=__L0[j - 1],)
            #
            __C1 = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='ELGA_SIEF_R', NOM_CHAM='SIEF_ELGA', INST=__L0[j - 1],)
            #
            __Va1 = CREA_CHAMP(
                OPERATION='EXTR', PRECISION=1.E-7, RESULTAT=nomres,
                TYPE_CHAM='ELGA_VARI_R', NOM_CHAM='VARI_ELGA', INST=__L0[j - 1],)
            #
            __lrec = DEFI_LIST_REEL(DEBUT=__L0[j - 1],
                                    INTERVALLE=_F(
                                    JUSQU_A=(__L0[j - 1]) + (10 * (__dtexp)),
                                    PAS=__dtexp),)
            schema_equi = dscheq[-1]['SCHEMA']
            if (schema_equi == 'TCHAMWA') or (schema_equi == 'DIFF_CENT'):
                masse_diago = 'OUI'
            else:
                masse_diago = 'NON'
            __u_rec = DYNA_NON_LINE(MASS_DIAG=masse_diago,
                                    EXCIT=dexct,
                                    ETAT_INIT=_F(
                                        DEPL=__U1, VITE=__V1, ACCE=__A1,
                                    SIGM=__C1, VARI=__Va1,),
                                    COMPORTEMENT=dComp_incre,
                                    INCREMENT=_F(LIST_INST=__lrec,
                                                 INST_INIT=__L0[j - 1],
                                                 INST_FIN=(
                                                 __L0[j - 1]) + (
                                                 10 * (__dtexp))),
                                    SCHEMA_TEMPS=dscheq,
                                    SOLVEUR=dsolv, ENERGIE=dener, OBSERVATION=dobs, ARCHIVAGE=darch,
                                    NEWTON=dnew, CONVERGENCE=dconv, **motscles)
            #
            __Ui = CREA_CHAMP(
                OPERATION='EXTR',        PRECISION=1.E-7,      RESULTAT=__u_rec,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='DEPL',      INST=(__L0[j - 1]) + (10 * (__dtexp)),)
            #
            __Vi = CREA_CHAMP(
                OPERATION='EXTR',        PRECISION=1.E-7,      RESULTAT=__u_rec,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='VITE',      INST=(__L0[j - 1]) + (10 * (__dtexp)),)
            #
            __Ai = CREA_CHAMP(
                OPERATION='EXTR',        PRECISION=1.E-7,      RESULTAT=__u_rec,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='ACCE',      INST=(__L0[j - 1]) + (10 * (__dtexp)),)
            #
            # equilibrage du premier pas implicite
            print('Equilibrage du pas explicite stabilisée')
            dincri1 = copy.copy(dincri)
            dincri1[-1]['INST_FIN'] = ((__L0[j - 1]) + (10 * (__dtexp)))
            dincri1[-1]['INST_INIT'] = (__L0[j - 1])
            nomres = DYNA_NON_LINE(reuse=nomres,
                                   EXCIT=dexct,
                                   ETAT_INIT=_F(
                                       DEPL=__Ui, VITE=__Vi, ACCE=__Ai,
                                   SIGM=__C1, VARI=__Va1,),
                                   COMPORTEMENT=dComp_incri,
                                   INCREMENT=dincri1,
                                   SCHEMA_TEMPS=dschi,
                                   SOLVEUR=dsolv, ENERGIE=dener, OBSERVATION=dobs, ARCHIVAGE=darch,
                                   NEWTON=dnew, CONVERGENCE=dconv, **motscles)
            #
            __Ui = CREA_CHAMP(
                OPERATION='EXTR',        PRECISION=1.E-7,      RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='DEPL',      INST=(__L0[j - 1]) + (10 * (__dtexp)),)
            #
            __Vi = CREA_CHAMP(
                OPERATION='EXTR',        PRECISION=1.E-7,      RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='VITE',      INST=(__L0[j - 1]) + (10 * (__dtexp)),)
            #
            __Ai = CREA_CHAMP(
                OPERATION='EXTR',        PRECISION=1.E-7,      RESULTAT=nomres,
                TYPE_CHAM='NOEU_DEPL_R', NOM_CHAM='ACCE',      INST=(__L0[j - 1]) + (10 * (__dtexp)),)
            #
            __Ci = CREA_CHAMP(
                OPERATION='EXTR',        PRECISION=1.E-7,      RESULTAT=nomres,
                TYPE_CHAM='ELGA_SIEF_R', NOM_CHAM='SIEF_ELGA', INST=(__L0[j - 1]) + (10 * (__dtexp)),)
            #
            __Vai = CREA_CHAMP(
                OPERATION='EXTR',        PRECISION=1.E-7,      RESULTAT=nomres,
                TYPE_CHAM='ELGA_VARI_R', NOM_CHAM='VARI_ELGA', INST=(__L0[j - 1]) + (10 * (__dtexp)),)
            #
            print('Calcul implicite après équilibrage')
            dincri1 = copy.copy(dincri)
            dincri1[-1]['INST_INIT'] = ((__L0[j - 1]) + (10 * (__dtexp)))
            if (j < __nb):
                dincri1[-1]['INST_FIN'] = __L0[j]
            else:
                del dincri1[-1]['INST_FIN']
            nomres = DYNA_NON_LINE(reuse=nomres,
                                   EXCIT=dexct,
                                   ETAT_INIT=_F(
                                       DEPL=__Ui, VITE=__Vi, ACCE=__Ai,
                                   SIGM=__Ci, VARI=__Vai,
                                   ),
                                   COMPORTEMENT=dComp_incri,
                                   INCREMENT=dincri1,
                                   SCHEMA_TEMPS=dschi,
                                   SOLVEUR=dsolv, ENERGIE=dener, OBSERVATION=dobs, ARCHIVAGE=darch,
                                   NEWTON=dnew, CONVERGENCE=dconv, **motscles)
            #
            __prc = 'IMPLICITE'
            bool = (j != (__nb))
            if (not bool):
                break
            j = j + 1
    #
    RetablirAlarme('COMPOR4_70')
    return ier
