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


POST_DECOLLEMENT=MACRO(nom="POST_DECOLLEMENT",
                       op=OPS('Macro.post_decollement_ops.post_decollement_ops'),
                       sd_prod=table_sdaster,
                       fr=tr("calcul du rapport de surfaces de contact radier/sol"),
                       reentrant='n',
         RESULTAT   =SIMP(statut='o',typ=(evol_noli,dyna_trans) ),
         NOM_CHAM   =SIMP(statut='f',typ='TXM',defaut='DEPL',into=C_NOM_CHAM_INTO(),max=1),
         NOM_CMP    =SIMP(statut='f',typ='TXM',defaut='DZ',max=1),
         GROUP_MA   =SIMP(statut='o',typ=grma,max=1),
         INFO       =SIMP(statut='f',typ='I',defaut=1,into=(1,2) ),
)
