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
#
# person_in_charge: jean-luc.flejou at edf.fr
#

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


IMPR_RESU_SP=MACRO(nom="IMPR_RESU_SP",
    op=OPS('Macro.impr_resu_sp_ops.impr_resu_sp_ops'),
    reentrant='n',
    fr=tr("Sortie des champs à sous-points pour visu avec Salomé_Méca"),

    regles=(EXCLUS('INST','LIST_INST','NUME_ORDRE'),),

    # SD résultat et champ à post-traiter :
    RESULTAT   =SIMP(statut='o',typ=evol_noli,fr=tr("RESULTAT à post-traiter."),),
    #
    NUME_ORDRE =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
    INST       =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
    LIST_INST  =SIMP(statut='f',typ=listr8_sdaster),
    #
    GROUP_MA   =SIMP(statut='o',typ=grma,validators=NoRepeat(),max='**'),
    #
    RESU =FACT(statut='o',max='**',
        NOM_CHAM =SIMP(statut='o',typ='TXM',into=("SIEF_ELGA","VARI_ELGA","SIGM_ELGA","SIEQ_ELGA")),
        NOM_CMP  =SIMP(statut='o',typ='TXM',validators=NoRepeat(),max='**',),
    ),
    UNITE =SIMP(statut='o',typ=UnitType(),max=1,min=1, inout='out', fr=tr("Unité du fichier d'archive.")),
)
