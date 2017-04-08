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
# person_in_charge: mickael.abbas at edf.fr
#

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


DEFI_DOMAINE_REDUIT=OPER(nom="DEFI_DOMAINE_REDUIT",op=50,
              sd_prod=maillage_sdaster,
              reentrant='o',
     reuse=SIMP(statut='c', typ=CO),
     BASE_PRIMAL     = SIMP(statut='o',typ=mode_empi,max=1),
     BASE_DUAL       = SIMP(statut='o',typ=mode_empi,max=1),
     NOM_DOMAINE     = SIMP(statut='o',typ='TXM',max=1),
     NB_COUCHE_SUPPL = SIMP(statut='f',typ='I',defaut=0),
     NOM_INTERFACE   = SIMP(statut='o',typ='TXM',max=1),
     
     DOMAINE_INCLUS  = FACT(statut='f',max=1,
         GROUP_NO        = SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
         NOEUD           = SIMP(statut='c',typ=no  ,validators=NoRepeat(),max='**'),
         GROUP_MA        = SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
         MAILLE          = SIMP(statut='c',typ=ma  ,validators=NoRepeat(),max='**'),
     ),

     CORR_COMPLET  = SIMP(statut='f',typ='TXM',defaut='NON',into=('OUI','NON')),
     p_correcteur   =BLOC(condition="""(equal_to("CORR_COMPLET", 'OUI'))""",
        NOM_ENCASTRE     = SIMP(statut='o',typ='TXM',max=1),),
     INFO          = SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2) ),
     TITRE         = SIMP(statut='f',typ='TXM'),
);
