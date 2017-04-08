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
# person_in_charge: olivier.boiteau at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


INFO_MODE=OPER(nom="INFO_MODE",op=32,sd_prod=table_sdaster,
                fr=tr("Calculer, imprimer, et sauvegarder le nombre de valeurs propres dans un contour donné"),

         TYPE_MODE       =SIMP(statut='f',typ='TXM',defaut="DYNAMIQUE",into=("MODE_COMPLEXE","DYNAMIQUE",
                                                                             "MODE_FLAMB",   "GENERAL"),
                               fr=tr("Type d analyse") ),
         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2) ),

         b_dynamique =BLOC(condition = """equal_to("TYPE_MODE", 'DYNAMIQUE')""",fr=tr("Recherche du nombre de fréquences propres"),
           MATR_RIGI       =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_temp_r,matr_asse_pres_r,matr_asse_gene_r,
                                                 matr_asse_depl_c,matr_asse_gene_c) ),
           MATR_MASS       =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_temp_r,matr_asse_pres_r,matr_asse_gene_r) ),
           FREQ            =SIMP(statut='o',typ='R',min=2,max='**',
                                 validators=AndVal((OrdList('croissant'), NoRepeat())),
                                 fr=tr("Liste de frequences") ),
           COMPTAGE        =FACT(statut='d',
              METHODE          =SIMP(statut='f',typ='TXM',defaut="AUTO",into=("AUTO","STURM")),                
              SEUIL_FREQ       =SIMP(statut='f',typ='R',defaut= 1.E-2 ),  
              PREC_SHIFT       =SIMP(statut='f',typ='R',defaut= 5.E-2 ),
              NMAX_ITER_SHIFT  =SIMP(statut='f',typ='I',defaut= 3,val_min=0),
                                ),
         ),

         b_flambement =BLOC(condition = """equal_to("TYPE_MODE", 'MODE_FLAMB')""",fr=tr("Recherche du nombre de charges critiques"),
           MATR_RIGI       =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_temp_r,matr_asse_pres_r,matr_asse_gene_r,
                                                 matr_asse_depl_c,matr_asse_gene_c) ),
           MATR_RIGI_GEOM  =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_temp_r,matr_asse_pres_r,matr_asse_gene_r) ),
           CHAR_CRIT       =SIMP(statut='o',typ='R',min=2,max='**',
                                 validators=AndVal((OrdList('croissant'), NoRepeat())),
                                 fr=tr("Liste de charges critiques") ),
           COMPTAGE        =FACT(statut='d',
              METHODE          =SIMP(statut='f',typ='TXM',defaut="AUTO",into=("AUTO","STURM")),                
              SEUIL_CHAR_CRIT  =SIMP(statut='f',typ='R',defaut= 1.E-2 ),  
              PREC_SHIFT       =SIMP(statut='f',typ='R',defaut= 5.E-2 ),
              NMAX_ITER_SHIFT  =SIMP(statut='f',typ='I',defaut= 3,val_min=0),
                                ),
         ),         

         b_complexe  =BLOC(condition = """equal_to("TYPE_MODE", 'MODE_COMPLEXE')""",fr=tr("Recherche du nombre de fréquences propres"),
           MATR_RIGI       =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_temp_r,matr_asse_pres_r,matr_asse_gene_r,
                                                 matr_asse_depl_c,matr_asse_gene_c) ),
           MATR_MASS       =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_temp_r,matr_asse_pres_r,matr_asse_gene_r) ),
           MATR_AMOR       =SIMP(statut='f',typ=(matr_asse_depl_r,matr_asse_temp_r,matr_asse_pres_r,matr_asse_gene_r) ),
           TYPE_CONTOUR    =SIMP(statut='f',typ='TXM',defaut="CERCLE",into=("CERCLE","CERCLE") ),
           RAYON_CONTOUR   =SIMP(statut='o',typ='R',val_min=1.E-2 ),
           CENTRE_CONTOUR  =SIMP(statut='f',typ='C',defaut= 0.0+0.0j),
           COMPTAGE        =FACT(statut='d',
              METHODE          =SIMP(statut='f',typ='TXM',defaut="AUTO",into=("AUTO","APM")),                
              NBPOINT_CONTOUR  =SIMP(statut='f',typ='I',defaut= 40,val_min=10,val_max=1000),
              NMAX_ITER_CONTOUR=SIMP(statut='f',typ='I',defaut= 3, val_min=1,val_max=5),
                               ),
         ),

         b_general  =BLOC(condition = """equal_to("TYPE_MODE", 'GENERAL')""",fr=tr("Recherche du nombre de valeurs propres"),
           MATR_A          =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_temp_r,matr_asse_pres_r,matr_asse_gene_r,
                                                 matr_asse_depl_c,matr_asse_gene_c) ),
           MATR_B          =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_temp_r,matr_asse_pres_r,matr_asse_gene_r) ),
           MATR_C          =SIMP(statut='f',typ=(matr_asse_depl_r,matr_asse_temp_r,matr_asse_pres_r,matr_asse_gene_r) ),
           CHAR_CRIT       =SIMP(statut='f',typ='R',min=2,max='**',
                                 validators=AndVal((OrdList('croissant'), NoRepeat())),
                                 fr=tr("Liste de charges critiques") ),
           b_contour  =BLOC(condition = """not exists("CHAR_CRIT")""",
             TYPE_CONTOUR    =SIMP(statut='f',typ='TXM',defaut="CERCLE",into=("CERCLE","CERCLE") ),        
             RAYON_CONTOUR   =SIMP(statut='o',typ='R',val_min=1.E-2 ),
             CENTRE_CONTOUR  =SIMP(statut='f',typ='C',defaut= 0.0+0.0j),),
           COMPTAGE        =FACT(statut='d',
              METHODE          =SIMP(statut='f',typ='TXM',defaut="AUTO",into=("AUTO","STURM","APM")),                
              SEUIL_CHAR_CRIT  =SIMP(statut='f',typ='R',defaut= 1.E-2 ),  
              PREC_SHIFT       =SIMP(statut='f',typ='R',defaut= 5.E-2 ),
              NMAX_ITER_SHIFT  =SIMP(statut='f',typ='I',defaut= 3,val_min=0),                                 ),
              NBPOINT_CONTOUR  =SIMP(statut='f',typ='I',defaut= 40,val_min=10,val_max=1000),
              NMAX_ITER_CONTOUR=SIMP(statut='f',typ='I',defaut= 3, val_min=1,val_max=5),
                                ),

         TITRE           =SIMP(statut='f',typ='TXM'),  
                        
#-------------------------------------------------------------------
#        Catalogue commun SOLVEUR
         SOLVEUR         =C_SOLVEUR('INFO_MODE'),
#        Mot-cle pour piloter les niveaux de parallelismes de l'operateur (a ne pas confondre avec le mot-cle
#        cache PARALLELISME_MACRO)
         NIVEAU_PARALLELISME  =SIMP(statut='f',typ='TXM',defaut="COMPLET",into=("PARTIEL","COMPLET") ),  
#-------------------------------------------------------------------
#-------------------------------------------------------------------
#  Mot-cles caches pour activer le parallelisme au sein d'une macro-commande
         PARALLELISME_MACRO=FACT(statut='d',
           TYPE_COM   =SIMP(statut='c',typ='I',defaut=-999,into=(-999,1,2),fr=tr("Type de communication")),
         ),
#-------------------------------------------------------------------

)  ;
