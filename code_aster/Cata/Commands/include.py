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

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


INCLUDE=MACRO(nom="INCLUDE",
              op=OPS("code_aster.Cata.ops.build_include"),
              fr=tr("Débranchement vers un fichier de commandes secondaires"),
              sd_prod=ops.INCLUDE,
              op_init=ops.INCLUDE_context,
              fichier_ini=1,
              regles=(UN_PARMI('UNITE', 'DONNEE')),
         UNITE = SIMP(statut='f', typ=UnitType(), inout='in',
                      fr=tr("Unité logique à inclure")),
         DONNEE = SIMP(statut='f', typ='TXM',
                       fr=tr("Nom du fichier de données à inclure")),
         INFO  = SIMP(statut='f', typ='I', defaut=1, into=(0, 1, 2)),
);
