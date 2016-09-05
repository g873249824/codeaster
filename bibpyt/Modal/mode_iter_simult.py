# coding=utf-8
# ======================================================================
# COPYRIGHT (C) 1991 - 2016  EDF R&D                  WWW.CODE-ASTER.ORG
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
#

from Cata import cata
from Cata.cata import *


def mode_iter_simult_prod(TYPE_RESU, **args ):
    if (TYPE_RESU not in ["DYNAMIQUE","MODE_FLAMB","GENERAL"]):
       # on retourne un type fictif pour que le plantage aie lieu dans la lecture du catalogue
       return ASSD
    if TYPE_RESU == "MODE_FLAMB" : return mode_flamb
    if TYPE_RESU == "GENERAL" :    return mode_flamb
    # sinon on est dans le cas 'DYNAMIQUE' donc **args doit contenir les mots-clés
    # MATR_RIGI et (faculativement) MATR_AMOR, et on peut y accéder
    vale_rigi = args['MATR_RIGI']
    if (vale_rigi== None) : # si MATR_RIGI non renseigné
       # on retourne un type fictif pour que le plantage aie lieu dans la lecture du catalogue
       return ASSD
    vale_amor = args['MATR_AMOR']
    if (AsType(vale_amor)== matr_asse_depl_r) : return mode_meca_c
    if (AsType(vale_rigi)== matr_asse_depl_r) : return mode_meca
    if (AsType(vale_rigi)== matr_asse_temp_r) : return mode_meca
    if (AsType(vale_rigi)== matr_asse_depl_c) : return mode_meca_c
    if (AsType(vale_rigi)== matr_asse_pres_r) : return mode_acou
    if (AsType(vale_rigi)== matr_asse_gene_r) : return mode_gene
    if (AsType(vale_rigi)== matr_asse_gene_c) : return mode_gene
  
    raise AsException("type de concept resultat non prevu")



MODE_ITER_SIMULT=OPER(nom="MODE_ITER_SIMULT",op=  45, sd_prod= mode_iter_simult_prod,
                      fr=tr("Calcul des modes propres par itérations simultanées : valeurs propres et modes propres réels ou complexes"),
                      reentrant='n',
            UIinfo={"groupes":("CACHE",)},
         METHODE         =SIMP(statut='f',typ='TXM',defaut="SORENSEN",
                               into=("TRI_DIAG","JACOBI","SORENSEN","QZ") ),
         b_tri_diag =BLOC(condition = "METHODE == 'TRI_DIAG'",
           PREC_ORTHO      =SIMP(statut='f',typ='R',defaut= 1.E-12,val_min=0.E+0 ),
           NMAX_ITER_ORTHO =SIMP(statut='f',typ='I',defaut= 5,val_min=0 ),
           PREC_LANCZOS    =SIMP(statut='f',typ='R',defaut= 1.E-8,val_min=0.E+0 ),
           NMAX_ITER_QR    =SIMP(statut='f',typ='I',defaut= 30,val_min=0 ),
         ),
         b_jacobi =BLOC(condition = "METHODE == 'JACOBI'",
           PREC_BATHE      =SIMP(statut='f',typ='R',defaut= 1.E-10,val_min=0.E+0 ),
           NMAX_ITER_BATHE =SIMP(statut='f',typ='I',defaut= 40,val_min=0 ),
           PREC_JACOBI     =SIMP(statut='f',typ='R',defaut= 1.E-2,val_min=0.E+0 ),
           NMAX_ITER_JACOBI=SIMP(statut='f',typ='I',defaut= 12,val_min=0 ),
         ),
         b_sorensen =BLOC(condition = "METHODE == 'SORENSEN'",
           PREC_SOREN      =SIMP(statut='f',typ='R',defaut= 0.E+0,val_min=0.E+0 ),
           NMAX_ITER_SOREN =SIMP(statut='f',typ='I',defaut= 20,val_min=0 ),
           PARA_ORTHO_SOREN=SIMP(statut='f',typ='R',defaut= 0.717),
         ),
         b_qz =BLOC(condition = "METHODE == 'QZ'",
           TYPE_QZ      =SIMP(statut='f',typ='TXM',defaut="QZ_SIMPLE",into=("QZ_QR","QZ_SIMPLE","QZ_EQUI") ),
         ),
         TYPE_RESU       =SIMP(statut='f',typ='TXM',defaut="DYNAMIQUE",
                               into=("DYNAMIQUE","MODE_FLAMB","GENERAL"),
                               fr=tr("Type d analyse") ),
         OPTION          =SIMP(statut='f',typ='TXM',defaut="SANS",into=("MODE_RIGIDE","SANS"),
                               fr=tr("Calcul des modes de corps rigide, uniquement pour la méthode TRI_DIAG") ),


         b_dynam        =BLOC(condition = "TYPE_RESU == 'DYNAMIQUE'",
           MATR_RIGI          =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_depl_c,matr_asse_temp_r,
                                                    matr_asse_gene_r,matr_asse_gene_c,matr_asse_pres_r ) ),
           MATR_MASS          =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_gene_r,matr_asse_pres_r,matr_asse_temp_r ) ),
           MATR_AMOR          =SIMP(statut='f',typ=(matr_asse_depl_r,matr_asse_gene_r) ),
           CALC_FREQ       =FACT(statut='d',min=0,
             OPTION      =SIMP(statut='f',typ='TXM',defaut="PLUS_PETITE",into=("PLUS_PETITE","PLUS_GRANDE","BANDE","CENTRE","TOUT"),
                                   fr=tr("Choix de l option et par conséquent du shift du problème modal") ),
             b_plus_petite =BLOC(condition = "OPTION == 'PLUS_PETITE'",fr=tr("Recherche des plus petites fréquences propres"),
               NMAX_FREQ       =SIMP(statut='f',typ='I',defaut=10,val_min=0 ),
             ),
             b_plus_grande =BLOC(condition = "OPTION == 'PLUS_GRANDE'",fr=tr("Recherche des plus grandes fréquences propres"),
               NMAX_FREQ       =SIMP(statut='f',typ='I',defaut=1,val_min=0 ),
             ),
             b_centre       =BLOC(condition = "OPTION == 'CENTRE'",
                                  fr=tr("Recherche des fréquences propres les plus proches d'une valeur donnée"),
               FREQ            =SIMP(statut='o',typ='R',
                                     fr=tr("Fréquence autour de laquelle on cherche les fréquences propres")),
               AMOR_REDUIT     =SIMP(statut='f',typ='R',),
               NMAX_FREQ       =SIMP(statut='f',typ='I',defaut= 10,val_min=0 ),
             ),
             b_bande         =BLOC(condition = "(OPTION == 'BANDE')",
                                   fr=tr("Recherche des fréquences propres dans une bande donnée"),
               FREQ            =SIMP(statut='o',typ='R',min=2,max=2,
                                     validators=AndVal((OrdList('croissant'), NoRepeat())),
                                     fr=tr("Valeur des deux fréquences délimitant la bande de recherche")),
               TABLE_FREQ      =SIMP(statut= 'f',typ=table_sdaster),
             ),
             APPROCHE        =SIMP(statut='f',typ='TXM',defaut="REEL",into=("REEL","IMAG","COMPLEXE"),
                                   fr=tr("Choix du pseudo-produit scalaire pour la résolution du problème quadratique") ),
             regles=(EXCLUS('DIM_SOUS_ESPACE','COEF_DIM_ESPACE'),),
             DIM_SOUS_ESPACE =SIMP(statut='f',typ='I' ),
             COEF_DIM_ESPACE =SIMP(statut='f',typ='I' ),
             NMAX_ITER_SHIFT =SIMP(statut='f',typ='I',defaut= 3,val_min=0 ),
             PREC_SHIFT      =SIMP(statut='f',typ='R',defaut= 5.E-2,val_min=0.E+0 ),
             SEUIL_FREQ      =SIMP(statut='f',typ='R',defaut= 1.E-2,val_min=0.E+0 ),
             ),
           ),


         b_general        =BLOC(condition = "TYPE_RESU == 'GENERAL'",
           MATR_A          =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_gene_r,matr_asse_pres_r ) ),
           MATR_B          =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_gene_r,matr_asse_pres_r ) ),
           ),


         b_flamb         =BLOC(condition = "TYPE_RESU == 'MODE_FLAMB'",
           MATR_RIGI          =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_gene_r,matr_asse_pres_r ) ),
           MATR_RIGI_GEOM     =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_gene_r,matr_asse_pres_r ) ),
         ),


         b_flamb_general  =BLOC(condition = "(TYPE_RESU == 'MODE_FLAMB') or (TYPE_RESU == 'GENERAL')",
           CALC_CHAR_CRIT  =FACT(statut='d',min=0,
             OPTION       =SIMP(statut='f',typ='TXM',defaut="PLUS_PETITE",into=("PLUS_PETITE","BANDE","CENTRE","TOUT"),
                                   fr=tr("Choix de l option et par conséquent du shift du problème modal") ),
             b_plus_petite =BLOC(condition = "OPTION == 'PLUS_PETITE'",fr=tr("Recherche des plus petites valeurs propres"),
               NMAX_CHAR_CRIT  =SIMP(statut='f',typ='I',defaut= 10,val_min=0 ),
             ),
             b_centre      =BLOC(condition = "OPTION == 'CENTRE'",
                                 fr=tr("Recherche des valeurs propres les plus proches d une valeur donnée"),
               CHAR_CRIT       =SIMP(statut='o',typ='R',
                                     fr=tr("Charge critique autour de laquelle on cherche les charges critiques propres")),
               NMAX_CHAR_CRIT  =SIMP(statut='f',typ='I',defaut= 10,val_min=0 ),
             ),
             b_bande       =BLOC(condition = "(OPTION == 'BANDE')",
                                 fr=tr("Recherche des valeurs propres dans une bande donnée"),
               CHAR_CRIT       =SIMP(statut='o',typ='R',min=2,max=2,
                                     validators=AndVal((OrdList('croissant'), NoRepeat())),
                                     fr=tr("Valeur des deux charges critiques délimitant la bande de recherche")),
               TABLE_CHAR_CRIT =SIMP(statut= 'f',typ=table_sdaster),

             ),
             APPROCHE        =SIMP(statut='f',typ='TXM',defaut="REEL",into=("REEL","IMAG"),
                                   fr=tr("Choix du pseudo-produit scalaire pour la résolution du problème quadratique") ),
             regles=(EXCLUS('DIM_SOUS_ESPACE','COEF_DIM_ESPACE'),),
             DIM_SOUS_ESPACE =SIMP(statut='f',typ='I' ),
             COEF_DIM_ESPACE =SIMP(statut='f',typ='I' ),
             NMAX_ITER_SHIFT =SIMP(statut='f',typ='I',defaut= 3,val_min=0 ),
             PREC_SHIFT      =SIMP(statut='f',typ='R',defaut= 5.E-2,val_min=0.E+0 ),
             SEUIL_CHAR_CRIT =SIMP(statut='f',typ='R',defaut= 1.E-2,val_min=0.E+0 ),
             ),
           ),


#-------------------------------------------------------------------
#        Catalogue commun SOLVEUR
         SOLVEUR         =C_SOLVEUR('MODE_ITER_SIMULT'),
#-------------------------------------------------------------------
#-------------------------------------------------------------------
#  Mot-cles caches pour activer le parallelisme au sein d'une macro-commande
         PARALLELISME_MACRO=FACT(statut='d',min=0,
           TYPE_COM   =SIMP(statut='c',typ='I',defaut=-999,into=(-999,1),fr=tr("Type de communication")),
           IPARA1_COM  =SIMP(statut='c',typ='I',defaut=-999,fr=tr("Parametre entier n 1 de la communication")),
           IPARA2_COM  =SIMP(statut='c',typ='I',defaut=-999,fr=tr("Parametre entier n 2 de la communication")),
         ),
#-------------------------------------------------------------------
         VERI_MODE       =FACT(statut='d',min=0,
           STOP_ERREUR     =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON") ),
           PREC_SHIFT      =SIMP(statut='f',typ='R',defaut= 5.E-3,val_min=0.E+0 ),
           SEUIL           =SIMP(statut='f',typ='R',defaut= 1.E-6,val_min=0.E+0,
                                 fr=tr("Valeur limite admise pour l'erreur a posteriori des modes") ),
           STURM           =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON") ),
         ),
         STOP_BANDE_VIDE =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON") ),
         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2) ),
         TITRE           =SIMP(statut='f',typ='TXM',max='**'),
)  ;
