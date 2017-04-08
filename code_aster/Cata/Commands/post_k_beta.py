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
# person_in_charge: david.haboussa at edf.fr
#
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


POST_K_BETA=OPER(nom="POST_K_BETA",op=198,sd_prod=table_sdaster,
                   fr=tr("Calcul des facteurs d'intensité de contraintes par la méthode K_BETA"),
                   reentrant='n',
         MAILLAGE      = SIMP(statut='o',typ=maillage_sdaster),
         MATER_REV     = SIMP(statut='o',typ=mater_sdaster),
         EPAIS_REV     = SIMP(statut='f',typ='R'),
         MATER_MDB     = SIMP(statut='f',typ=mater_sdaster),
         EPAIS_MDB     = SIMP(statut='f',typ='R'),
         FISSURE       = FACT(statut='o',
            FORM_FISS      =SIMP(statut='o',typ='TXM',defaut="ELLIPSE",
                                 into=("ELLIPSE","SEMI_ELLIPSE") ),
            b_fissure=BLOC(condition="""equal_to("FORM_FISS", 'ELLIPSE')""",
              DECALAGE       = SIMP(statut='f',typ='R',defaut=-2.e-04),
            ),
            PROFONDEUR     = SIMP(statut='o',typ='R'),
            LONGUEUR       = SIMP(statut='o',typ='R'),
            ORIENTATION    = SIMP(statut='o',typ='TXM',
                                 into=("CIRC","LONGI"),),
         ),
         K1D           = FACT(statut='o',max='**',
            TABL_MECA_REV  = SIMP(statut='f',typ=(table_sdaster)),
            TABL_MECA_MDB  = SIMP(statut='o',typ=(table_sdaster)),
            TABL_THER      = SIMP(statut='o',typ=(table_sdaster)),
            INTITULE       = SIMP(statut='o',typ='TXM' ),
         ),
         TITRE         = SIMP(statut='f',typ='TXM'),
);
