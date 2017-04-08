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


DEFI_LIST_ENTI=OPER(nom="DEFI_LIST_ENTI",op=22,sd_prod=listis_sdaster,
                    fr=tr("Définir une liste d'entiers strictement croissante"),
                    reentrant='n',

         OPERATION    =SIMP(statut='o',typ='TXM',defaut='DEFI',into=('DEFI','NUME_ORDRE',)),


         # définition d'une liste d'entiers
         #----------------------------------
         b_defi       =BLOC(condition = """equal_to("OPERATION", 'DEFI')""",
             regles=(UN_PARMI('VALE','DEBUT'),
                     EXCLUS('VALE','INTERVALLE'),),
             VALE            =SIMP(statut='f',typ='I',max='**'),
             DEBUT           =SIMP(statut='f',typ='I'),
             INTERVALLE      =FACT(statut='f',max='**',
                 regles=(UN_PARMI('NOMBRE','PAS'),),
                 JUSQU_A         =SIMP(statut='o',typ='I'),
                 NOMBRE          =SIMP(statut='f',typ='I',val_min=1,),
                 PAS             =SIMP(statut='f',typ='I',val_min=1,),
             ),
         ),


         # extraction d'une liste de nume_ordre dans une sd_resultat :
         #------------------------------------------------------------
         b_extr       =BLOC(condition = """equal_to("OPERATION", 'NUME_ORDRE')""",
             RESULTAT   = SIMP(statut='o',typ=resultat_sdaster),
             PARAMETRE  = SIMP(statut='o',typ='TXM',),
             INTERVALLE = FACT(statut='o', max='**',
                               fr=tr("Définition des intervalles de recherche"),
                 VALE = SIMP(statut='o', typ='R', min=2, max=2),
             ),
         ),


         INFO            =SIMP(statut='f',typ='I',defaut=1,into=(1,2)),
         TITRE           =SIMP(statut='f',typ='TXM'),
)  ;
