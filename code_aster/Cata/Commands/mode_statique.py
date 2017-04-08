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
# person_in_charge: georges-cc.devesa at edf.fr

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


MODE_STATIQUE=OPER(nom="MODE_STATIQUE",op= 93,sd_prod=mode_meca,
                   fr=tr("Calcul de déformées statiques pour un déplacement, une force ou une accélération unitaire imposé"),
                   reentrant='n',

         regles=(UN_PARMI('MODE_STAT','FORCE_NODALE','PSEUDO_MODE','MODE_INTERF'),
                 PRESENT_PRESENT('MODE_INTERF','MATR_MASS'),
                 PRESENT_PRESENT('PSEUDO_MODE','MATR_MASS'),
                 ),


         MATR_RIGI       =SIMP(statut='o',typ=matr_asse_depl_r ),
         MATR_MASS       =SIMP(statut='f',typ=matr_asse_depl_r ),



         MODE_STAT       =FACT(statut='f',max='**',
           regles=(UN_PARMI('TOUT','NOEUD','GROUP_NO'),
                   UN_PARMI('TOUT_CMP','AVEC_CMP','SANS_CMP'),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ,),
           NOEUD           =SIMP(statut='f',typ=no   ,max='**'),
           GROUP_NO        =SIMP(statut='f',typ=grno ,max='**'),
           TOUT_CMP        =SIMP(statut='f',typ='TXM',into=("OUI",) ,),
           AVEC_CMP        =SIMP(statut='f',typ='TXM',max='**'),
           SANS_CMP        =SIMP(statut='f',typ='TXM',max='**'),
         ),
         FORCE_NODALE    =FACT(statut='f',max='**',
           regles=(UN_PARMI('TOUT','NOEUD','GROUP_NO'),
                   UN_PARMI('TOUT_CMP','AVEC_CMP','SANS_CMP'),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",), ),
           NOEUD           =SIMP(statut='f',typ=no   ,max='**'),
           GROUP_NO        =SIMP(statut='f',typ=grno ,max='**'),
           TOUT_CMP        =SIMP(statut='f',typ='TXM',into=("OUI",), ),
           AVEC_CMP        =SIMP(statut='f',typ='TXM',max='**'),
           SANS_CMP        =SIMP(statut='f',typ='TXM',max='**'),
         ),
         PSEUDO_MODE       =FACT(statut='f',max='**',
           regles=(UN_PARMI('AXE','DIRECTION','TOUT','NOEUD','GROUP_NO' ),),
           AXE             =SIMP(statut='f',typ='TXM',into=("X","Y","Z"),max=3),
           DIRECTION       =SIMP(statut='f',typ='R',min=3,max=3),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",)),
           NOEUD           =SIMP(statut='f',typ=no   ,max='**'),
           GROUP_NO        =SIMP(statut='f',typ=grno ,max='**'),
           b_dir           =BLOC(condition = """exists("DIRECTION")""",
             NOM_DIR         =SIMP(statut='f',typ='TXM' ),),
           b_cmp          =BLOC(condition="""exists("TOUT") or exists("NOEUD") or exists("GROUP_NO")""",
             regles=(UN_PARMI('TOUT_CMP','AVEC_CMP','SANS_CMP'),),
             TOUT_CMP        =SIMP(statut='f',typ='TXM',into=("OUI",) ),
             AVEC_CMP        =SIMP(statut='f',typ='TXM',max='**'),
             SANS_CMP        =SIMP(statut='f',typ='TXM',max='**'),
           ),
         ),
         MODE_INTERF    =FACT(statut='f',max=1,
           regles=(UN_PARMI('TOUT','NOEUD','GROUP_NO'),
                   UN_PARMI('TOUT_CMP','AVEC_CMP','SANS_CMP'),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",), ),
           NOEUD           =SIMP(statut='f',typ=no   ,max='**'),
           GROUP_NO        =SIMP(statut='f',typ=grno ,max='**'),
           TOUT_CMP        =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           AVEC_CMP        =SIMP(statut='f',typ='TXM',max='**'),
           SANS_CMP        =SIMP(statut='f',typ='TXM',max='**'),
           NB_MODE         =SIMP(statut='o',typ='I',defaut= 1),
           SHIFT           =SIMP(statut='o',typ='R',defaut= 1.0),

         ),

#-------------------------------------------------------------------
#        Catalogue commun SOLVEUR
         SOLVEUR         =C_SOLVEUR('MODE_STATIQUE'),
#-------------------------------------------------------------------

         TITRE           =SIMP(statut='f',typ='TXM'),
         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2 ,) ),
)  ;
