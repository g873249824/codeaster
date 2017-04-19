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
# person_in_charge: sylvie.michel-ponnelle at edf.fr


from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


DEFI_CABLE_BP=MACRO(nom="DEFI_CABLE_BP",
                    op=OPS('Macro.defi_cable_bp_ops.defi_cable_bp_ops'),
                    sd_prod=cabl_precont,
                    fr=tr("Calculer les profils initiaux de tension le long des cables "
                         "de précontrainte d'une structure en béton"),
                    reentrant='n',
         MODELE          =SIMP(statut='o',typ=modele_sdaster ),
         CHAM_MATER      =SIMP(statut='o',typ=cham_mater ),
         CARA_ELEM       =SIMP(statut='o',typ=cara_elem ),
         GROUP_MA_BETON  =SIMP(statut='o',typ=grma,max='**'),
         DEFI_CABLE      =FACT(statut='o',max='**',
           regles=(UN_PARMI('MAILLE','GROUP_MA'),
                   UN_PARMI('NOEUD_ANCRAGE','GROUP_NO_ANCRAGE'),),
           MAILLE          =SIMP(statut='c',typ=ma,min=2,validators=NoRepeat(),max='**'),
           GROUP_MA        =SIMP(statut='f',typ=grma),
           NOEUD_ANCRAGE   =SIMP(statut='c',typ=no  ,validators=NoRepeat(),max=2),
           GROUP_NO_ANCRAGE=SIMP(statut='f',typ=grno,validators=NoRepeat(),max=2),
           TENSION_CT      =SIMP(statut='f',typ=table_sdaster),
         ),
         ADHERENT        =SIMP(statut='o',typ='TXM',defaut='OUI',into=("OUI","NON") ),
         TYPE_ANCRAGE    =SIMP(statut='o',typ='TXM',min=2,max=2,into=("ACTIF","PASSIF") ),
         TENSION_INIT    =SIMP(statut='o',typ='R',val_min=0.E+0 ),
         RECUL_ANCRAGE   =SIMP(statut='o',typ='R',val_min=0.E+0 ),
         b_adherent=BLOC(condition="""(equal_to("ADHERENT", 'OUI'))""",
            TYPE_RELAX      =SIMP(statut='o',typ='TXM',into=("SANS","BPEL","ETCC_DIRECT","ETCC_REPRISE"),defaut="SANS",),
                b_relax_bpel  =BLOC(condition = """equal_to("TYPE_RELAX", 'BPEL')""",
                       R_J   =SIMP(statut='o',typ='R',val_min=0.E+0),
                                                ),
                b_relax_etcc  =BLOC(condition = """((equal_to("TYPE_RELAX", 'ETCC_DIRECT')) or (equal_to("TYPE_RELAX", 'ETCC_REPRISE')))""",
                      NBH_RELAX   =SIMP(statut='o',typ='R',val_min=0.E+0),
                       ),
#         PERT_ELAS       =SIMP(statut='o',typ='TXM',into=("OUI","NON"),defaut="NON"),
#           b_pert_elas   =BLOC(condition = """equal_to("PERT_ELAS", 'OUI')""",
#                  EP_BETON  = SIMP(statut='o',typ='R',val_min=0.E+0),
#                  ESP_CABLE = SIMP(statut='o',typ='R',val_min=0.E+0)
#                  ) ,
            CONE            =FACT(statut='f',
                RAYON             =SIMP(statut='o',typ='R',val_min=0.E+0 ),
                LONGUEUR          =SIMP(statut='o',typ='R',val_min=0.E+0 ),
                PRESENT           =SIMP(statut='o',typ='TXM',min=2,max=2,into=("OUI","NON") ),
              ),
            ),
         b_non_adherent=BLOC(condition="""(equal_to("ADHERENT", 'NON'))""",
            TYPE_RELAX      =SIMP(statut='c',typ='TXM',into=("SANS",),defaut="SANS",),
            ),
         TITRE           =SIMP(statut='f',typ='TXM' ),
         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2) ),
)  ;
