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

# person_in_charge: mathieu.courtois at edf.fr

import os.path

# ------------------------------------------------------------------------


def impr_fonction_ops(self, FORMAT, COURBE, INFO, **args):
    """
    Macro IMPR_FONCTION permettant d'imprimer dans un fichier des fonctions,
    colonnes de table...
    Erreurs<S> dans IMPR_FONCTION pour ne pas perdre la base.
    """
    macro = 'IMPR_FONCTION'
    import pprint
    import aster
    from code_aster.Cata.Syntax import _F
    from code_aster.Cata.DataStructure import (nappe_sdaster, fonction_c,
                                               formule, formule_c)
    from Utilitai import Graph
    from Utilitai.Utmess import UTMESS
    from Utilitai.UniteAster import UniteAster
    from Utilitai.utils import fmtF2PY

    ier = 0
    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)

    # On importe les definitions des commandes a utiliser dans la macro
    # Le nom de la variable doit etre obligatoirement le nom de la commande
    CALC_FONC_INTERP = self.get_cmd('CALC_FONC_INTERP')
    DEFI_LIST_REEL = self.get_cmd('DEFI_LIST_REEL')

    #----------------------------------------------
    # 0. Traitement des arguments, initialisations
    # unité logique des fichiers réservés
    ul_reserve = (8,)
    UL = UniteAster()

    # 0.1. Fichier
    nomfich = None
    UNITE = args.get('UNITE', 6)
    if UNITE != 6:
        nomfich = UL.Nom(UNITE)
        if INFO == 2:
            aster.affiche('MESSAGE', ' Nom du fichier :' + nomfich)
    if nomfich and os.path.exists(nomfich) and os.stat(nomfich).st_size != 0:
        if FORMAT == 'XMGRACE':
            niv = 'I'
        else:
            niv = 'I'
        UTMESS(niv, 'FONCT0_1', valk=nomfich)

    # 0.2. Récupération des valeurs sous COURBE
    unparmi = ('FONCTION', 'LIST_RESU', 'FONC_X', 'ABSCISSE' ,'NAPPE','NAPPE_LISSEE')

    # i0 : indice du mot-clé facteur qui contient LIST_PARA, sinon i0=0
    i0 = 0
    Courbe = []
    iocc = -1
    for Ci in COURBE:
        iocc += 1
        dC = Ci.cree_dict_valeurs(Ci.mc_liste)
        if 'LIST_PARA' in dC and dC['LIST_PARA'] is not None and i0 == 0:
            i0 = iocc
        for mc in list(dC.keys()):
            if dC[mc] is None:
                del dC[mc]
        Courbe.append(dC)
    if INFO == 2:
        aster.affiche(
            'MESSAGE', ' Nombre de fonctions à analyser : ' + str(len(Courbe)))

    # 0.3. Devra-t-on interpoler globalement ?
    #      Dans ce cas, __linter est le LIST_PARA
    #      ou, à défaut, les abscisses de la première courbe
    interp = False
    if FORMAT == 'TABLEAU':
        interp = True
        dCi = Courbe[i0]
        if 'LIST_PARA' in dCi:
            __linter = dCi['LIST_PARA']
        else:
            obj = None
            for typi in unparmi:
                if typi in dCi:
                    obj = dCi[typi]
                    break
            if obj is None:
                UTMESS('S', 'SUPERVIS_56')
            if typi == 'FONCTION' or typi == 'NAPPE' or typi =='NAPPE_LISSEE' :
                if isinstance(obj, nappe_sdaster):
                    lpar, lval = obj.Valeurs()
                    linterp = lval[0][0]
                else:
                    linterp = obj.Valeurs()[0]
            elif typi == 'FONC_X':
                lbid, linterp = obj.Valeurs()
            elif typi == 'ABSCISSE':
                linterp = obj
            __linter = DEFI_LIST_REEL(VALE=linterp)
        if INFO == 2:
            aster.affiche('MESSAGE', ' Interpolation globale sur la liste :')
            aster.affiche('MESSAGE', pprint.pformat(__linter.Valeurs()))

    #----------------------------------------------
    # 1. Récupération des valeurs des N courbes sous forme
    #    d'une liste de N listes
    #----------------------------------------------
    graph = Graph.Graph()
    iocc = -1
    isnappelisse = 0
    for dCi in Courbe:
        iocc += 1

        # 1.1. Type d'objet à traiter
        obj = None
        for typi in unparmi:
            if typi in dCi:
                obj = dCi[typi]
                break
        if 'LEGENDE' not in dCi and hasattr(obj, 'get_name'):
            dCi['LEGENDE'] = obj.get_name()
        if obj is None:
            UTMESS('S', 'SUPERVIS_56')

        # 1.2. Extraction des valeurs

        # 1.2.1. Mot-clé FONCTION
        if typi == 'FONCTION' or typi=='NAPPE' or typi=='NAPPE_LISSEE' :
            # formule à un paramètre seulement
            if isinstance(obj, formule):
                dpar = obj.Parametres()
                if len(dpar['NOM_PARA']) != 1:
                    UTMESS(
                        'S', 'FONCT0_50', valk=obj.nom, vali=len(dpar['NOM_PARA']))

            if isinstance(obj, nappe_sdaster):
                lpar, lval = obj.Valeurs()
                dico, ldicf = obj.Parametres()
                Leg = dCi['LEGENDE']
                for i in range(len(lpar)):
                    p = lpar[i]
                    lx = lval[i][0]
                    ly = lval[i][1]
                    # sur quelle liste interpoler chaque fonction
                    if i == 0:
                        if interp:
                            __li = __linter
                        elif 'LIST_PARA' in dCi:
                            __li = dCi['LIST_PARA']
                        else:
                            __li = DEFI_LIST_REEL(VALE=lx)
                    # compléter les paramètres d'interpolation
                    dic = dico.copy()
                    dic.update(ldicf[i])

                    if interp or 'LIST_PARA' in dCi:

                        try:
                            __ftmp = CALC_FONC_INTERP(
                                FONCTION=obj,
                                VALE_PARA=p,
                                LIST_PARA_FONC=__li,
                                **dic
                            )
                            pv, lv2 = __ftmp.Valeurs()
                            lx = lv2[0][0]
                            ly = lv2[0][1]
                        except aster.error as err:
                            # on verifie que la bonne exception a ete levee
                            assert err.id_message == "FONCT0_9", 'unexpected id : %s' % err.id_message
                            continue

                    # on stocke les données dans le Graph
                    nomresu = dic['NOM_RESU'].strip() + '_' + str(
                        len(graph.Legendes))
                    dicC = {
                        'Val': [lx, ly],
                        'Lab': [dic['NOM_PARA_FONC'], nomresu]
                    }
                    # ajoute la valeur du paramètre
                    dCi['LEGENDE'] = '%s %s=%g' % (
                        Leg, dic['NOM_PARA'].strip(), p)
                    if typi == 'NAPPE' or (typi == 'NAPPE_LISSEE' and isnappelisse):
                        dCi['LEGENDE'] = '%s %s=%g' % (Leg, dic['NOM_PARA'].strip(), p)
                    elif typi == 'NAPPE_LISSEE':
                        dCi['LEGENDE'] = 'NAPPE_LISSEE %s %s=%g' % (Leg, dic['NOM_PARA'].strip(), p)
                    Graph.AjoutParaCourbe(dicC, args=dCi)
                    graph.AjoutCourbe(**dicC)
                if typi == 'NAPPE_LISSEE':
                    isnappelisse=1
            else:
                __ftmp = obj
                dpar = __ftmp.Parametres()
                # pour les formules à un paramètre (test plus haut)
                if type(dpar['NOM_PARA']) in (list, tuple):
                    dpar['NOM_PARA'] = dpar['NOM_PARA'][0]
                if interp:
                    try:
                        __ftmp = CALC_FONC_INTERP(
                            FONCTION=obj,
                            LIST_PARA=__linter,
                            **dpar
                        )
                    except aster.error as err:

                            # on verifie que la bonne exception a ete levee
                            assert err.id_message == "FONCT0_9", 'unexpected id : %s' % err.id_message
                            continue
                elif 'LIST_PARA' in dCi:
                    try:
                        __ftmp = CALC_FONC_INTERP(
                            FONCTION=obj,
                            LIST_PARA=dCi['LIST_PARA'],
                            **dpar
                        )
                    except aster.error as err:
                            # on verifie que la bonne exception a ete levee
                            assert err.id_message == "FONCT0_9", 'unexpected id : %s' % err.id_message
                            continue
                lval = list(__ftmp.Valeurs())
                lx = lval[0]
                lr = lval[1]
                if isinstance(obj, (fonction_c, formule_c)) and dCi.get('PARTIE') == 'IMAG':
                    lr = lval[2]
                # on stocke les données dans le Graph
                if isinstance(obj, (fonction_c, formule_c)) and 'PARTIE' not in dCi:
                    nomresu = dpar['NOM_RESU'].strip() + '_' + str(
                        len(graph.Legendes))
                    dicC = {
                        'Val': lval,
                        'Lab': [dpar['NOM_PARA'], nomresu + '_R', nomresu + '_I']
                    }
                else:
                    nomresu = dpar['NOM_RESU'].strip() + '_' + str(
                        len(graph.Legendes))
                    dicC = {
                        'Val': [lx, lr],
                        'Lab': [dpar['NOM_PARA'], nomresu]
                    }
                Graph.AjoutParaCourbe(dicC, args=dCi)
                graph.AjoutCourbe(**dicC)

        # 1.2.2. Mot-clé LIST_RESU
        elif typi == 'LIST_RESU':
            if interp and iocc > 0:
                UTMESS('S', 'FONCT0_2')
            lx = dCi['LIST_PARA'].Valeurs()
            lr = obj.Valeurs()
            if len(lx) != len(lr):
                UTMESS('S', 'FONCT0_3')
            # on stocke les données dans le Graph
            dicC = {
                'Val': [lx, lr],
                'Lab': [dCi['LIST_PARA'].get_name(), obj.get_name()]
            }
            Graph.AjoutParaCourbe(dicC, args=dCi)
            graph.AjoutCourbe(**dicC)

        # 1.2.3. Mot-clé FONC_X
        # exemple : obj(t)=sin(t), on imprime x=sin(t), y=cos(t)
        #           ob2(t)=cos(t)
        elif typi == 'FONC_X':
            ob2 = dCi['FONC_Y']
            # peut-on blinder au niveau du catalogue
            if isinstance(obj, nappe_sdaster) or isinstance(ob2, nappe_sdaster):
                UTMESS('S', 'FONCT0_4')
            if interp and iocc > 0:
                UTMESS('S', 'FONCT0_5')
            __ftmp = obj
            dpar = __ftmp.Parametres()
            __ftm2 = ob2
            dpa2 = __ftm2.Parametres()
            intloc = False
            if interp and 'LIST_PARA' not in dCi:
                # dans ce cas, __linter contient les ordonnées de FONC_X
                intloc = False
                __li = __linter
            elif 'LIST_PARA' in dCi:
                intloc = True
                __li = dCi['LIST_PARA']
            if intloc:
                __ftmp = CALC_FONC_INTERP(
                    FONCTION=obj,
                    LIST_PARA=__li,
                    **dpar
                )
                lt, lx = __ftmp.Valeurs()
                __ftm2 = CALC_FONC_INTERP(
                    FONCTION=ob2,
                    LIST_PARA=__li,
                    **dpa2
                )
            else:
                lt, lx = __ftmp.Valeurs()
                __li = DEFI_LIST_REEL(VALE=lt)
                __ftm2 = CALC_FONC_INTERP(
                    FONCTION=ob2,
                    LIST_PARA=__li,
                    **dpa2
                )

            lbid, ly = __ftm2.Valeurs()
            # on stocke les données dans le Graph
            # on imprime la liste des paramètres seulement si LIST_PARA
            if intloc:
                nomresur = dpar['NOM_RESU'].strip() + '_' + str(
                    len(graph.Legendes))
                nomresu2 = dpa2['NOM_RESU'].strip() + '_' + str(
                    len(graph.Legendes) + 1)
                dicC = {
                    'Val': [lt, lx, ly],
                    'Lab': [dpar['NOM_PARA'], nomresur, nomresu2]
                }
            else:
                nomresur = dpar['NOM_RESU'].strip() + '_' + str(
                    len(graph.Legendes))
                nomresu2 = dpa2['NOM_RESU'].strip() + '_' + str(
                    len(graph.Legendes) + 1)
                dicC = {
                    'Val': [lx, ly],
                    'Lab': [nomresur, nomresu2]
                }
            Graph.AjoutParaCourbe(dicC, args=dCi)
            graph.AjoutCourbe(**dicC)

        # 1.2.4. Mot-clé ABSCISSE / ORDONNEE
        elif typi == 'ABSCISSE':
            if interp and iocc > 0:
                UTMESS('S', 'FONCT0_6')
            lx = obj
            lr = dCi['ORDONNEE']
            if len(lx) != len(lr):
                UTMESS('S', 'FONCT0_7')
            # on stocke les données dans le Graph
            dicC = {
                'Val': [lx, lr],
                'Lab': ['Absc', 'Ordo']
            }
            Graph.AjoutParaCourbe(dicC, args=dCi)
            graph.AjoutCourbe(**dicC)

    # 1.3. dbg
    if INFO == 2:
        message = '\n' + '-' * 70 + \
            '\n Contenu du Graph : \n' + '-' * 70 + '\n'
        message = message + graph.__repr__()
        message = message + '-' * 70 + '\n'
        aster.affiche('MESSAGE', message)

    #----------------------------------------------
    # 2. Impression du 'tableau' de valeurs
    #----------------------------------------------

    # 2.0. Surcharge des propriétés du graphique et des axes
    # (bloc quasiment identique dans Table)
    if args['TITRE'] is not None:
        graph.Titre = args['TITRE']
    if args['SOUS_TITRE'] is not None:
        graph.SousTitre = args['SOUS_TITRE']
    if FORMAT in ('XMGRACE', 'AGRAF','LISS_ENVELOP'):
        if args['BORNE_X'] is not None:
            graph.Min_X = args['BORNE_X'][0]
            graph.Max_X = args['BORNE_X'][1]
        if args['BORNE_Y'] is not None:
            graph.Min_Y = args['BORNE_Y'][0]
            graph.Max_Y = args['BORNE_Y'][1]
        if args['LEGENDE_X'] is not None:
            graph.Legende_X = args['LEGENDE_X']
        if args['LEGENDE_Y'] is not None:
            graph.Legende_Y = args['LEGENDE_Y']
        if args['ECHELLE_X'] is not None:
            graph.Echelle_X = args['ECHELLE_X']
        if args['ECHELLE_Y'] is not None:
            graph.Echelle_Y = args['ECHELLE_Y']
        if args['GRILLE_X'] is not None:
            graph.Grille_X = args['GRILLE_X']
        if args['GRILLE_Y'] is not None:
            graph.Grille_Y = args['GRILLE_Y']

    kargs = {
        'FORMAT': FORMAT,
        'FICHIER': nomfich,
    }

    # 2.1. au format TABLEAU
    if FORMAT == 'TABLEAU':
        # surcharge par les formats de l'utilisateur
        kargs['dform'] = {
            'csep': args['SEPARATEUR'],
            'ccom': args['COMMENTAIRE'],
            'ccpara': args['COMM_PARA'],
            'cdeb': args['DEBUT_LIGNE'],
            'cfin': args['FIN_LIGNE'],
            'formR': fmtF2PY(args['FORMAT_R'])
        }

    # 2.2. au format AGRAF
    elif FORMAT == 'AGRAF':
        nomdigr = None
        if args['UNITE_DIGR'] != 6:
            nomdigr = UL.Nom(args['UNITE_DIGR'])
        kargs['FICHIER'] = [nomfich, nomdigr]
        kargs['dform'] = {'formR': '%12.5E'}

    # 2.3. au format XMGRACE et dérivés
    elif FORMAT == 'XMGRACE':
        kargs['dform'] = {'formR': '%.8g'}
        kargs['PILOTE'] = args['PILOTE']

    # 2.4. au format LISS_ENVELOP
    elif FORMAT == 'LISS_ENVELOP':
        kargs['FICHIER'] = nomfich
    # 2.39. Format inconnu
    else:
        UTMESS('S', 'FONCT0_8', valk=FORMAT)

    if FORMAT == 'AGRAF' and args['UNITE_DIGR'] != UNITE \
            and args['UNITE_DIGR'] in ul_reserve:
        UL.Etat(args['UNITE_DIGR'], etat='F')

    # 2.4. On trace !
    graph.Trace(**kargs)

    # 99. Traiter le cas des UL réservées
    UL.EtatInit()

    return ier
