# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
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
# person_in_charge: mathieu.courtois at edf.fr

"""Macro-commande INCLUDE_MATERIAU

D�finition des mots-cl�s et fonctions utilisables dans les catalogues :
  - extraction : indique si un mot-cl� facteur doit �tre conserv� en
    fonction de la pr�sence d'EXTRACTION.
      - Si extraction == True, on conserve le mot-cl� facteur si
        EXTRACTION est pr�sent.
      - Si extraction == False, on conserve le mot-cl� facteur si
        EXTRACTION est absent.
      - Si extraction n'est pas indiqu� (vaut None), le mot-cl� facteur
        est conserv� que EXTRACTION soit pr�sent ou non.
  - temp_eval : indique qu'une fonction doit �tre �valu�e en fonction de
    la temp�rature.
  - coef_unit : fonction qui renvoie un coefficient multiplicatif selon
    l'unit�
      - en m : retourne 1.
      - en mm : retourne 10^expo
  - defi_motscles : fonction qui d�finit tous les mots-cl�s, filtr�s
    ensuite en fonction de EXTRACTION.
  - motscles : objet r�sultat de DEFI_MOTSCLES contenant les mots-cl�s
    � utiliser dans DEFI_MATERIAU.

On d�finit ici la liste des commandes utilisables dans un mat�riau.
"""

import os.path as osp
import pprint
from math import pow

import aster_core

EXTR = 'extraction'
FTEMP = 'temp_eval'
FCOEF = 'coef_unit'
DEFI_MOTSCLES = 'defi_motscles'
MOTSCLES = 'motscles'
COMMANDES = [
    'DEFI_LIST_REEL', 'DEFI_FONCTION', 'DEFI_CONSTANTE', 'DEFI_NAPPE',
    'FORMULE', 'CALC_FONCTION', 'CALC_FONC_INTERP',
    'DETRUIRE',
]

def build_context(unite, temp):
    """Construit le contexte pour ex�cuter un catalogue mat�riau."""
    # d�finition du coefficient multiplicatif selon l'unit�.
    unite = unite.lower()
    assert unite in ("m", "mm")
    if unite == "m":
        coef_unit = lambda expo : 1.
    else:
        coef_unit = lambda expo : pow(10., expo)

    # extraction � une temp�rature donn�e
    if temp is not None:
        func_temp = lambda f : f(temp)
    else:
        func_temp = lambda x : x

    # fonction pour r�cup�rer les mots cl�s
    def defi_motscles(**kwargs):
        return kwargs

    context = {
        FCOEF : coef_unit,
        FTEMP : func_temp,
        DEFI_MOTSCLES : defi_motscles,
    }
    return context


def include_materiau_ops(self, NOM_AFNOR, TYPE_MODELE, VARIANTE, TYPE_VALE,
                         EXTRACTION, UNITE_LONGUEUR, INFO, **args):
    """Macro INCLUDE_MATERIAU"""
    import aster
    from Accas import _F
    from Cata.cata import formule
    from Utilitai.Utmess import UTMESS

    DEFI_MATERIAU  = self.get_cmd('DEFI_MATERIAU')
    self.set_icmd(1)
    self.DeclareOut('MAT', self.sd)

    bnmat = ''.join([NOM_AFNOR, '_', TYPE_MODELE, '_', VARIANTE, '.', TYPE_VALE])
    repmat = aster_core.get_option("repmat")
    fmat = osp.join(repmat, bnmat)
    if not osp.exists(fmat):
        UTMESS('F', 'FICHIER_1', valk=fmat)

    # extraction � une temp�rature donn�e
    extract = EXTRACTION is not None
    if extract:
        TEMP_EVAL = EXTRACTION['TEMP_EVAL']
        keep_compor = lambda compor : compor in EXTRACTION['COMPOR']
    else:
        TEMP_EVAL = None
        keep_compor = lambda compor : True

    context = build_context(UNITE_LONGUEUR, TEMP_EVAL)
    # ajout des commandes autoris�es
    commandes = dict([(cmd, self.get_cmd(cmd)) for cmd in COMMANDES])
    context.update(commandes)
    context['_F'] = _F

    # ex�cution du catalogue
    execfile(fmat, context)
    kwcata = context.get(MOTSCLES)
    if kwcata is None:
        UTMESS('F', 'SUPERVIS2_6', valk=bnmat)
    # certains concepts cach�s doivent �tre connus plus tard (au moins les objets FORMULE)
    to_add = dict([(v.nom, v) for k, v in context.items() if isinstance(v, formule)])
    self.sdprods.extend(to_add.values())
    if INFO == 2:
        aster.affiche('MESSAGE', " Mots-cl�s issus du catalogue : \n%s" \
            % pprint.pformat(kwcata))
        aster.affiche('MESSAGE', 'Concepts transmis au contexte global :\n%s' % to_add)

    # filtre des mots-cl�s
    for mcf, value in kwcata.items():
        if not keep_compor(mcf):
            del kwcata[mcf]
            continue
        if type(value) not in (list, tuple):
            value = [value, ]
        if type(value) in (list, tuple) and len(value) != 1:
            UTMESS('F', 'SUPERVIS2_7', valk=(bnmat, mcf))
        for occ in value:
            if occ.get(EXTR) in (None, extract):
                if occ.get(EXTR) is not None:
                    del occ[EXTR]
            else:
                del kwcata[mcf]
    MAT = DEFI_MATERIAU(**kwcata)
    return 0
