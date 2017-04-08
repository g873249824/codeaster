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
# person_in_charge: mathieu.courtois at edf.fr
#

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


def C_TYPE_CHAM_INTO( type_cham=None ):
    """Retourne la liste des valeurs possibles pour le mot-clef TYPE_CHAM"""
    type_cham = type_cham or ["ELEM", "ELNO", "ELGA", "CART", "NOEU"]

    types = []
    for phys in C_NOM_GRANDEUR() :
        if phys != "VARI_R" :
            for typ in type_cham :
                types.append(typ + "_" + phys)
        else :
            # il ne peut pas exister NOEU_VARI_R ni CART_VARI_R (il faut utiliser VAR2_R):
            for typ in type_cham :
                if typ not in ("CART", "NOEU") :
                    types.append(typ + "_" + phys)
    return tuple(types)
