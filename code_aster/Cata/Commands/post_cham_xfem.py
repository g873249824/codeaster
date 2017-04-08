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
# person_in_charge: sam.cuvilliez at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


def post_cham_xfem_prod(RESULTAT,**args ):

  if AsType(RESULTAT) == evol_noli  : return evol_noli
  if AsType(RESULTAT) == mode_meca  : return mode_meca
  if AsType(RESULTAT) == evol_elas  : return evol_elas
  if AsType(RESULTAT) == evol_ther  : return evol_ther

  raise AsException("type de concept resultat non prevu")

POST_CHAM_XFEM=OPER(nom="POST_CHAM_XFEM",op= 196,sd_prod=post_cham_xfem_prod,
                    reentrant='n',
            fr=tr("Calcul des champs DEPL, SIEF_ELGA et VARI_ELGA sur le maillage de visualisation (fissuré)"),
    RESULTAT      = SIMP(statut='o',typ=resultat_sdaster),
    MODELE_VISU   = SIMP(statut='o',typ=modele_sdaster,),
    INFO          = SIMP(statut='f',typ='I',defaut= 1,into=(1,2,) ),
);
