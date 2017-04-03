# -*- coding: utf-8 -*-
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

# person_in_charge: mathieu.corus at edf.fr


from Cata import cata
from Cata.cata import *


CALC_SPEC=MACRO(nom="CALC_SPEC",
                op=OPS('Macro.calc_spec_ops.calc_spec_ops'),
                sd_prod=interspectre,
                reentrant='n',
                fr=tr("Calcule une matrice interspectrale ou des fonctions de transferts"),
                regles=(UN_PARMI("ECHANT", "TAB_ECHANT"),
                        UN_PARMI("INTERSPE", "TRANSFERT"), ),
         TAB_ECHANT      =FACT(statut='f',
           NOM_TAB                  =SIMP(statut='o',typ=table_sdaster),
           LONGUEUR_DUREE           =SIMP(statut='f',typ='R'),
           LONGUEUR_POURCENT        =SIMP(statut='f',typ='R'),
           LONGUEUR_NB_PTS          =SIMP(statut='f',typ='I'),
           RECOUVREMENT_DUREE       =SIMP(statut='f',typ='R'),
           RECOUVREMENT_POURCENT    =SIMP(statut='f',typ='R'),
           RECOUVREMENT_NB_PTS      =SIMP(statut='f',typ='I'),
                              ),
         ECHANT          =FACT(statut='f',max='**',
           NUME_ORDRE_I    =SIMP(statut='o',typ='I' ),
           NUME_MES        =SIMP(statut='o',typ='I' ),
           FONCTION        =SIMP(statut='o',typ=fonction_sdaster),
                              ),
#-- Cas de la matrice interspectrale --#
         INTERSPE        =FACT(statut='f',
           FENETRE         =SIMP(statut='f',typ='TXM',defaut="RECT",into=("RECT","HAMM","HANN","EXPO","PART",)),
           BLOC_DEFI_FENE  =BLOC(condition = "FENETRE == 'EXPO' or FENETRE == 'PART' ",
             DEFI_FENE       =SIMP(statut='f',typ='R',max='**'),
                                 ),
                              ),
#-- Cas des transferts - estimateurs H1 / H2 / Hv + Coherence --#
         TRANSFERT       =FACT(statut='f',
           ESTIM           =SIMP(statut='f',typ='TXM',defaut="H1",into=("H1","H2","CO",)),
           REFER           =SIMP(statut='o',typ='I',max='**'),
           FENETRE         =SIMP(statut='f',typ='TXM',defaut="RECT",into=("RECT","HAMM","HANN","EXPO","PART",)),
#           DEFI_FENE       =SIMP(statut='f',typ='R',max='**'),
           BLOC_DEFI_FENE  =BLOC(condition = "FENETRE == 'EXPO' or FENETRE == 'PART' ",
             DEFI_FENE       =SIMP(statut='f',typ='R',max='**'),
                                 ),
                              ),
         TITRE           =SIMP(statut='f',typ='TXM',max='**'),
         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2) ),
);
