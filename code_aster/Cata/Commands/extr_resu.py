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
# person_in_charge: j-pierre.lefebvre at edf.fr

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


def extr_resu_prod(RESULTAT,**args):
  if AsType(RESULTAT) == evol_elas    : return evol_elas
  if AsType(RESULTAT) == evol_noli    : return evol_noli
  if AsType(RESULTAT) == evol_ther    : return evol_ther
  if AsType(RESULTAT) == evol_varc    : return evol_varc
  if AsType(RESULTAT) == dyna_trans   : return dyna_trans
  if AsType(RESULTAT) == dyna_harmo   : return dyna_harmo
  if AsType(RESULTAT) == acou_harmo   : return acou_harmo
  if AsType(RESULTAT) == mode_meca    : return mode_meca
  if AsType(RESULTAT) == mode_acou    : return mode_acou
  if AsType(RESULTAT) == mult_elas    : return mult_elas
  if AsType(RESULTAT) == fourier_elas : return fourier_elas

  raise AsException("type de concept resultat non prevu")

EXTR_RESU=OPER(nom="EXTR_RESU",op=176,sd_prod=extr_resu_prod,reentrant='f',
            fr=tr("Extraire des champs au sein d'une SD Résultat"),
         reuse=SIMP(statut='c', typ=CO),
         RESULTAT        =SIMP(statut='o',typ=(evol_elas,dyna_trans,dyna_harmo,acou_harmo,mode_meca,
                                               mode_acou,evol_ther,evol_noli,evol_varc,
                                               mult_elas,fourier_elas,fourier_ther ) ),


         ARCHIVAGE       =FACT(statut='f',
           regles=(  UN_PARMI('NUME_ORDRE', 'INST', 'FREQ', 'NUME_MODE',
                        'NOEUD_CMP', 'LIST_INST', 'LIST_FREQ', 'LIST_ORDRE',
                        'NOM_CAS', 'LIST_ARCH', 'PAS_ARCH' ),
                     EXCLUS( 'CHAM_EXCLU','NOM_CHAM' ),   ),
           CHAM_EXCLU      =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**'),
           NOM_CHAM        =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**',into=C_NOM_CHAM_INTO()),
           CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU",),),
           b_prec_rela=BLOC(condition="""(equal_to("CRITERE", 'RELATIF'))""",
              PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
           b_prec_abso=BLOC(condition="""(equal_to("CRITERE", 'ABSOLU'))""",
              PRECISION       =SIMP(statut='o',typ='R',),),
           LIST_ARCH       =SIMP(statut='f',typ=listis_sdaster),
           PAS_ARCH        =SIMP(statut='f',typ='I'),
           NUME_ORDRE      =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
           LIST_ORDRE      =SIMP(statut='f',typ=listis_sdaster),
           INST            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
           LIST_INST       =SIMP(statut='f',typ=listr8_sdaster),
           FREQ            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
           LIST_FREQ       =SIMP(statut='f',typ=listr8_sdaster),
           NUME_MODE       =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
           NOEUD_CMP       =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**'),
           NOM_CAS         =SIMP(statut='f',typ='TXM'),
                               ),

         RESTREINT   =FACT(statut='f', max=1,
            fr=tr("Pour réduire une ou plusieurs sd_resultat sur un maillage ou un modèle réduit"),
            regles=(UN_PARMI('MAILLAGE','MODELE'),),
            MAILLAGE        =SIMP(statut='f',typ=maillage_sdaster),
            MODELE          =SIMP(statut='f',typ=modele_sdaster),
            CHAM_MATER      =SIMP(statut='f',typ=cham_mater,
               fr=tr("le CHAM_MATER est nécessaire, sauf si le modèle ne contient que des éléments discrets (modélisations DIS_XXX)"),),
            CARA_ELEM       =SIMP(statut='f',typ=cara_elem,
               fr=tr("le CARA_ELEM est nécessaire dès que le modèle contient des éléments de structure : coques, poutres, ..."),),
            ),

         TITRE           =SIMP(statut='f',typ='TXM' ),
         INFO            =SIMP(statut='f',typ='I',into=(1,2),defaut=1),
)  ;
