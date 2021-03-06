# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

# person_in_charge: nicolas.greffet at edf.fr
#
# MACRO DE COUPLAGE IFS AVEC SATURNE VIA YACS
#

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


CALC_IFS_DNL= MACRO(nom='CALC_IFS_DNL',
                    op=OPS("Macro.calc_ifs_dnl_ops.calc_ifs_dnl_ops"),
                    sd_prod=evol_noli,
                    reentrant='f',
                    fr=tr("Calcul de l'évolution dynamique d'une structure couplée à un "
                         "domaine fluide (résolu avec le code Saturne) via YACS"),

#IFS
#=>
         GROUP_MA_IFS     =SIMP(statut='o',typ=grma,max='**'),
         NOM_CMP_IFS      =SIMP(statut='o',typ='TXM',validators=NoRepeat(),max='**'),
         UNITE_NOEUD      =SIMP(statut='f',typ='I',defaut= 81 ),
         UNITE_ELEM       =SIMP(statut='f',typ='I',defaut= 82 ),
         PAS_INIT         =SIMP(statut='o',typ='R' ),
#<=
#IFS
         MODELE          =SIMP(statut='o',typ=modele_sdaster),
         CHAM_MATER      =SIMP(statut='o',typ=cham_mater),
         MODE_STAT       =SIMP(statut='f',typ=mode_meca),
         CARA_ELEM       =SIMP(statut='f',typ=cara_elem),
         MASS_DIAG       =SIMP(statut='f',typ='TXM',into=("OUI","NON",) ),
#IFS
#=>
#(une charge force nodale est fournie par le couplage avec code_saturne
         EXCIT           =FACT(statut='f',max='**',
#<=
#IFS
           regles=(PRESENT_ABSENT('FONC_MULT','ACCE'),
                   PRESENT_PRESENT('ACCE','VITE','DEPL'),
                   ),
           TYPE_CHARGE     =SIMP(statut='f',typ='TXM',defaut="FIXE_CSTE",
                                 into=("FIXE_CSTE","SUIV","DIDI")),
#IFS
#=>
#(une charge force nodale est fournie par le couplage avec code_saturne
#           CHARGE          =SIMP(statut='o',typ=(char_meca,char_cine_meca)),
           CHARGE          =SIMP(statut='f',typ=(char_meca,char_cine_meca)),
#<=
#IFS
           FONC_MULT       =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule)),
           DEPL            =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule)),
           ACCE            =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule)),
           VITE            =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule)),
           MULT_APPUI      =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON") ),
           DIRECTION       =SIMP(statut='f',typ='R',max='**'),
           NOEUD           =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
           GROUP_NO        =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
         ),
         EXCIT_GENE      =FACT(statut='f',max='**',
           FONC_MULT       =SIMP(statut='f',typ=fonction_sdaster,max='**' ),
           VECT_GENE       =SIMP(statut='f',typ=vect_asse_gene,max='**' ),
         ),
         CONTACT         =SIMP(statut='f',typ=char_contact),
         SOUS_STRUC      =FACT(statut='f',min=0o1,max='**',
                regles=(UN_PARMI('TOUT','SUPER_MAILLE'),),
                CAS_CHARGE  =SIMP(statut='o',typ='TXM' ),
                TOUT        =SIMP(statut='f',typ='TXM',into=("OUI",) ),
                SUPER_MAILLE=SIMP(statut='f',typ=ma,validators=NoRepeat(),max='**',),
                FONC_MULT   =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule)),
              ),
         AMOR_RAYL_RIGI = SIMP(statut='f',typ='TXM',defaut="TANGENTE",into=("TANGENTE","ELASTIQUE"),),
         AMOR_MODAL      =FACT(statut='f',
           regles=(EXCLUS('AMOR_REDUIT','LIST_AMOR'),),
           MODE_MECA       =SIMP(statut='f',typ=mode_meca),
           AMOR_REDUIT     =SIMP(statut='f',typ='R',max='**' ),
           LIST_AMOR       =SIMP(statut='f',typ=listr8_sdaster ),
           NB_MODE         =SIMP(statut='f',typ='I',defaut= 9999 ),
           REAC_VITE       =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON") ),
         ),
         PROJ_MODAL      =FACT(statut='f',max='**',
           MODE_MECA       =SIMP(statut='o',typ=mode_meca),
           NB_MODE         =SIMP(statut='f',typ='I',defaut= 9999 ),
           regles=(PRESENT_PRESENT('MASS_GENE','RIGI_GENE'),),
           MASS_GENE       =SIMP(statut='f',typ=matr_asse_gene_r),
           RIGI_GENE       =SIMP(statut='f',typ=matr_asse_gene_r),
           AMOR_GENE       =SIMP(statut='f',typ=matr_asse_gene_r),
           DEPL_INIT_GENE  =SIMP(statut='f',typ=vect_asse_gene),
           VITE_INIT_GENE  =SIMP(statut='f',typ=vect_asse_gene),
           ACCE_INIT_GENE  =SIMP(statut='f',typ=vect_asse_gene),
         ),
#-------------------------------------------------------------------
         COMPORTEMENT       =C_COMPORTEMENT('DYNA_NON_LINE'),
#-------------------------------------------------------------------
         b_reuse =BLOC(condition = "reuse",fr=tr("en mode concept reentrant : ETAT_INIT obligatoire"),
            ETAT_INIT         =C_ETAT_INIT('DYNA_NON_LINE','o'),),
         b_notreuse =BLOC(condition = "not reuse",fr=tr("en mode concept reentrant : ETAT_INIT facultatif"),
            ETAT_INIT         =C_ETAT_INIT('DYNA_NON_LINE','f'),),
#-------------------------------------------------------------------
#IFS : pas besoin d'INCREMENT
#         INCREMENT       =C_INCREMENT('MECANIQUE'),
#-------------------------------------------------------------------
         SCHEMA_TEMPS     =FACT(statut='o',
            SCHEMA          =SIMP(statut='o',min=1,max=1,typ='TXM',
            into=("DIFF_CENT","TCHAMWA","NEWMARK","HHT","THETA_METHODE","KRENK"),),
            COEF_MASS_SHIFT =SIMP(statut='f',typ='R',defaut= 0.0E+0 ),
            b_tchamwa = BLOC(condition="SCHEMA=='TCHAMWA'",
               PHI          =SIMP(statut='f',typ='R',defaut= 1.05),),

            b_newmark = BLOC(condition="SCHEMA=='NEWMARK'",
               BETA         =SIMP(statut='f',typ='R',defaut= 0.25),
               GAMMA        =SIMP(statut='f',typ='R',defaut= 0.5),),

            b_hht     = BLOC(condition="SCHEMA=='HHT'",
               ALPHA        =SIMP(statut='f',typ='R',defaut= -0.3 ),
               MODI_EQUI    =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON"),),),

            b_theta   = BLOC(condition="SCHEMA=='THETA_METHODE'",
               THETA         =SIMP(statut='f',typ='R',defaut= 1.,val_min=0.5,val_max=100. ),),

            b_krenk   = BLOC(condition="SCHEMA=='KRENK'",
               KAPPA         =SIMP(statut='f',typ='R',defaut= 1.0,val_min=1.0,val_max=100. ),),

            b_explicit= BLOC(condition="SCHEMA=='TCHAMWA'or SCHEMA=='DIFF_CENT'",
               STOP_CFL     =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON"),),
               FORMULATION  =SIMP(statut='o',typ='TXM',into=("ACCELERATION",),),),

            b_implicit= BLOC(condition="SCHEMA!='TCHAMWA'and SCHEMA!='DIFF_CENT'",
               FORMULATION  =SIMP(statut='o',max=1,typ='TXM',into=("DEPLACEMENT","VITESSE","ACCELERATION"),),),
         ),
#-------------------------------------------------------------------
         NEWTON          =C_NEWTON(),
#-------------------------------------------------------------------
         RECH_LINEAIRE   =C_RECH_LINEAIRE(),
#-------------------------------------------------------------------
         CONVERGENCE     =C_CONVERGENCE(),
#-------------------------------------------------------------------
         SOLVEUR         =C_SOLVEUR('CALC_IFS_DNL'),
#-------------------------------------------------------------------
         OBSERVATION     =C_OBSERVATION('MECANIQUE'),
#-------------------------------------------------------------------
         SUIVI_DDL       =C_SUIVI_DDL(),
#-------------------------------------------------------------------
         AFFICHAGE       =C_AFFICHAGE(),
#-------------------------------------------------------------------
         ARCHIVAGE       =C_ARCHIVAGE(),
#-------------------------------------------------------------------
         CRIT_STAB      =FACT(statut='f',min=1,max=1,
           NB_FREQ         =SIMP(statut='f',typ='I',max=1,val_min=1,defaut=3),
           COEF_DIM_ESPACE =SIMP(statut='f',typ='I',max=1,val_min=2,defaut=5),
           RIGI_GEOM     =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON")),
           b_char_crit=BLOC(condition="(RIGI_GEOM=='OUI')",
              CHAR_CRIT       =SIMP(statut='f',typ='R',min=2,max=2,
                                    fr=tr("Valeur des deux charges critiques délimitant la bande de recherche en HPP")),),
           MODI_RIGI     =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON")),
           TYPE          =SIMP(statut='f',typ='TXM',defaut="FLAMBEMENT",into=("FLAMBEMENT","STABILITE")),
           PREC_INSTAB   =SIMP(statut='f',typ='R',defaut=1.E-6,max=1,),
           SIGNE         =SIMP(statut='f',typ='TXM',defaut=("POSITIF_NEGATIF"),into=("NEGATIF","POSITIF","POSITIF_NEGATIF"),max=1,),
           bloc_rigi_geom=BLOC(condition="(RIGI_GEOM=='NON'or MODI_RIGI=='OUI')",
              DDL_EXCLUS      =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max=40,
                                    into=('DX','DY','DZ','DRX','DRY','DRZ','GRX','PRES','PHI',
                                          'TEMP','PRE1','PRE2','UI2','UI3','VI2','VI3','WI2','WI3','UO2',
                                          'UO3','VO2','VO3','WO2','WO3','UI4','UI5','VI4','VI5','WI4',
                                          'WI5','UO4','UO5','VO4','VO5','WO4','WO5','UI6','UO6','VI6',
                                          'VO6','WI6','WO6','WO','WI1','WO1','GONF','LIAISON','DCX',
                                          'DCY','DCZ','H1X','H1Y','H1Z','E1X','E1Y','E1Z','E2X','E2Y','E2Z',
                                          'E3X','E3Y','E3Z','E4X','E4Y','E4Z','LAGS_C','V11','V12','V13','V21','V22',
                                          'V23','V31','V32','V33','PRES11','PRES12','PRES13','PRES21','PRES22','PRES23',
                                          'PRES31','PRES32','PRES33','VARI','LAG_GV','DAMG','DH')),
           bloc_type_stab =BLOC(condition= "TYPE == 'STABILITE' and RIGI_GEOM == 'NON'",
              DDL_STAB        =SIMP(statut='o',typ='TXM',validators=NoRepeat(),min=1,max=40,
                                       into=('DX','DY','DZ','DRX','DRY','DRZ','GRX','PRES','PHI',
                                             'TEMP','PRE1','PRE2','UI2','UI3','VI2','VI3','WI2','WI3','UO2',
                                             'UO3','VO2','VO3','WO2','WO3','UI4','UI5','VI4','VI5','WI4',
                                             'WI5','UO4','UO5','VO4','VO5','WO4','WO5','UI6','UO6','VI6',
                                             'VO6','WI6','WO6','WO','WI1','WO1','GONF','LIAISON','DCX',
                                             'DCY','DCZ','H1X','H1Y','H1Z','E1X','E1Y','E1Z','E2X','E2Y','E2Z',
                                             'E3X','E3Y','E3Z','E4X','E4Y','E4Z','LAGS_C','V11','V12','V13','V21','V22',
                                             'V23','V31','V32','V33','PRES11','PRES12','PRES13','PRES21','PRES22','PRES23',
                                             'PRES31','PRES32','PRES33','VARI','LAG_GV','DAMG','DH')),),
                            ),
           regles         = (EXCLUS('PAS_CALC','LIST_INST','INST'),),
           LIST_INST      = SIMP(statut='f',typ=(listr8_sdaster) ),
           INST           = SIMP(statut='f',typ='R',validators=NoRepeat(),max='**' ),
           PAS_CALC       = SIMP(statut='f',typ='I' ),
           CRITERE        = SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU") ),
              b_prec_rela=BLOC(condition="(CRITERE=='RELATIF')",
                 PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
              b_prec_abso=BLOC(condition="(CRITERE=='ABSOLU')",
                 PRECISION       =SIMP(statut='o',typ='R',),),
         ),
         MODE_VIBR     =FACT(statut='f',min=1,max=1,
           MATR_RIGI        =SIMP(statut='f',typ='TXM',defaut="ELASTIQUE",into=("ELASTIQUE","TANGENTE","SECANTE",) ),
           NB_FREQ          =SIMP(statut='f',typ='I',max=1,val_min=1,defaut=3,
                            fr=tr("Nombre de fréquences propres à calculer")),
           COEF_DIM_ESPACE  =SIMP(statut='f',typ='I',max=1,val_min=2,defaut=5),
           BANDE            =SIMP(statut='f',typ='R',min=2,max=2,
                            fr=tr("Valeur des deux fréquences délimitant la bande de recherche"),),
           regles         = (EXCLUS('PAS_CALC','LIST_INST','INST'),),
           LIST_INST      = SIMP(statut='f',typ=(listr8_sdaster) ),
           INST           = SIMP(statut='f',typ='R',validators=NoRepeat(),max='**' ),
           PAS_CALC       = SIMP(statut='f',typ='I' ),
           CRITERE        = SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU") ),
              b_prec_rela=BLOC(condition="(CRITERE=='RELATIF')",
                 PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
              b_prec_abso=BLOC(condition="(CRITERE=='ABSOLU')",
                 PRECISION       =SIMP(statut='o',typ='R',),),
         ),
#-------------------------------------------------------------------

         INFO            =SIMP(statut='f',typ='I',defaut=1,into=(1,2) ),
         b_info=BLOC(condition="(INFO==2)",
               fr=tr("filtre les messages émis dans le .mess selon le type de message demandé"),
               INFO_DBG = SIMP(statut='f',typ='TXM',max='**',validators=NoRepeat(),
                               into=("CONTACT",
                                     "MECA_NON_LINE",
                                     "PILOTAGE",
                                     "FACTORISATION",
                                     "APPARIEMENT"),
                             ),
                    ),
         TITRE           =SIMP(statut='f',typ='TXM',max='**'),
)  ;
