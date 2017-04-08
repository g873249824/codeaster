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


def lire_fonction_prod(self,TYPE,**args):
  if   (TYPE == 'FONCTION')  : return fonction_sdaster
  elif (TYPE == 'FONCTION_C'): return fonction_c
  elif (TYPE == 'NAPPE'   )  : return nappe_sdaster
  raise AsException("type de concept resultat non prevu")

LIRE_FONCTION=MACRO(nom="LIRE_FONCTION",
                    op=OPS('Macro.lire_fonction_ops.lire_fonction_ops'),
                    sd_prod=lire_fonction_prod,
                    fr=tr("Lit les valeurs réelles dans un fichier de données représentant une "
                         "fonction et crée un concept de type fonction ou nappe"),
                    reentrant='n',
         FORMAT          =SIMP(statut='f',typ='TXM',into=("LIBRE","NUMPY"),
                               defaut="LIBRE"  ),
         TYPE            =SIMP(statut='f',typ='TXM',into=("FONCTION","FONCTION_C","NAPPE"),defaut="FONCTION"  ),
         SEPAR           =SIMP(statut='f',typ='TXM',into=("None",",",";","/"),defaut="None" ),
         INDIC_PARA      =SIMP(statut='f',typ='I',min=2,max=2,defaut=[1,1]),
         b_fonction      =BLOC(condition = """equal_to("TYPE", 'FONCTION') """,
           INDIC_RESU      =SIMP(statut='f',typ='I',min=2,max=2,defaut=[1,2]), ),
         b_fonction_c    =BLOC(condition = """equal_to("TYPE", 'FONCTION_C') """,
           FORMAT_C        =SIMP(statut='f',typ='TXM',defaut="REEL_IMAG",into=("REEL_IMAG","MODULE_PHASE") ),
           b_reel_imag     =BLOC(condition = """equal_to("FORMAT_C", 'REEL_IMAG') """,
             INDIC_REEL      =SIMP(statut='o',typ='I',min=2,max=2,defaut=[1,2]),
             INDIC_IMAG      =SIMP(statut='o',typ='I',min=2,max=2,defaut=[1,3]), ) ,
           b_modu_phas     =BLOC(condition = """equal_to("FORMAT_C", 'MODULE_PHASE') """,
             INDIC_MODU      =SIMP(statut='o',typ='I',min=2,max=2,defaut=[1,2]),
             INDIC_PHAS      =SIMP(statut='o',typ='I',min=2,max=2,defaut=[1,3]), ), ),
         b_nappe         =BLOC(condition = """equal_to("TYPE", 'NAPPE') """,
           NOM_PARA_FONC   =SIMP(statut='o',typ='TXM',into=C_PARA_FONCTION() ),
           INDIC_ABSCISSE  =SIMP(statut='o',typ='I',min=2,max=2,),
           INTERPOL_FONC   =SIMP(statut='f',typ='TXM',max=2,defaut="LIN",into=("NON","LIN","LOG"),
                                 fr=tr("Type d'interpolation pour les abscisses et les ordonnées de la fonction")),
           PROL_DROITE_FONC=SIMP(statut='f',typ='TXM',defaut="EXCLU",into=("CONSTANT","LINEAIRE","EXCLU") ),
           PROL_GAUCHE_FONC=SIMP(statut='f',typ='TXM',defaut="EXCLU",into=("CONSTANT","LINEAIRE","EXCLU") ),
           DEFI_FONCTION   =FACT(statut='f',max='**',
             INDIC_RESU      =SIMP(statut='o',typ='I',min=2,max=2,),),  ),
         UNITE           =SIMP(statut='o',typ=UnitType(), inout='in',),
         NOM_PARA        =SIMP(statut='o',typ='TXM',into=C_PARA_FONCTION() ),
         NOM_RESU        =SIMP(statut='f',typ='TXM',defaut="TOUTRESU"),
         INTERPOL        =SIMP(statut='f',typ='TXM',max=2,defaut="LIN",into=("NON","LIN","LOG"),
                               fr=tr("Type d'interpolation pour les abscisses et les ordonnées de la "
                                    "fonction ou bien pour le paramètre de la nappe.")),
         PROL_DROITE     =SIMP(statut='f',typ='TXM',defaut="EXCLU",into=("CONSTANT","LINEAIRE","EXCLU") ),
         PROL_GAUCHE     =SIMP(statut='f',typ='TXM',defaut="EXCLU",into=("CONSTANT","LINEAIRE","EXCLU") ),
         VERIF           =SIMP(statut='f',typ='TXM',defaut="CROISSANT",into=("CROISSANT","NON") ),
         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2) ),
         TITRE           =SIMP(statut='f',typ='TXM'),
)  ;
