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
# person_in_charge: mathieu.corus at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


DEFI_SQUELETTE=OPER(nom="DEFI_SQUELETTE",op= 110,sd_prod=squelette,
                    fr=tr("Définit un maillage pour visualiser les résultats d'une sous-structuration dynamique"),
                    reentrant='n',
         regles=(UN_PARMI('CYCLIQUE','MODELE_GENE','MAILLAGE'),
                 PRESENT_PRESENT('CYCLIQUE','SECTEUR'),
                 EXCLUS('SOUS_STRUC','SECTEUR'),
                 PRESENT_PRESENT('NOM_GROUP_MA','MODELE_GENE'),
                 PRESENT_PRESENT('NOM_GROUP_MA','SOUS_STRUC'),),
         CYCLIQUE    =FACT(statut='f',
           regles=(UN_PARMI('MODE_CYCL','MAILLAGE'),
                   PRESENT_PRESENT('NB_SECTEUR','MAILLAGE'),),
           MODE_CYCL       =SIMP(statut='f',typ=mode_cycl ),
           NB_SECTEUR      =SIMP(statut='f',typ='I',max=1 ),
           MAILLAGE        =SIMP(statut='f',typ=maillage_sdaster ),
         ),
         MODELE_GENE     =SIMP(statut='f',typ=modele_gene ),
         SQUELETTE       =SIMP(statut='f',typ=squelette ),
         RECO_GLOBAL     =FACT(statut='f', max='**',
           regles=(EXCLUS('TOUT','GROUP_NO_1'),
                   PRESENT_PRESENT('GROUP_NO_1','GROUP_NO_2'),
                   PRESENT_PRESENT('GROUP_NO_1','SOUS_STRUC_1'),
                   PRESENT_PRESENT('GROUP_NO_2','SOUS_STRUC_2'),
                   PRESENT_PRESENT('SOUS_STRUC_1','SOUS_STRUC_2'),),
           TOUT            =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI",) ),
           GROUP_NO_1      =SIMP(statut='f',typ=grno),
           SOUS_STRUC_1    =SIMP(statut='f',typ='TXM' ),
           GROUP_NO_2      =SIMP(statut='f',typ=grno),
           SOUS_STRUC_2    =SIMP(statut='f',typ='TXM' ),
           PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-3 ),
           CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU") ),
           DIST_REFE       =SIMP(statut='f',typ='R' ),
         ),
         NOM_GROUP_MA    =FACT(statut='f',max='**',
           NOM             =SIMP(statut='o',typ='TXM' ),
           SOUS_STRUC      =SIMP(statut='o',typ='TXM' ),
           GROUP_MA        =SIMP(statut='o',typ=grma),
         ),
         EXCLUSIF        =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON") ),
         MAILLAGE        =SIMP(statut='f',typ=maillage_sdaster ),
         MAILLE          =SIMP(statut='c',typ=ma  ,validators=NoRepeat(),max='**'),
         GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
         TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
         TRANS           =SIMP(statut='f',typ='R',min=3,max=3),
         ANGL_NAUT       =SIMP(statut='f',typ='R',min=3,max=3),
         SOUS_STRUC      =FACT(statut='f',max='**',
           regles=(UN_PARMI('TOUT','MAILLE','GROUP_MA'),),
           NOM             =SIMP(statut='o',typ='TXM' ),
           MAILLE          =SIMP(statut='c',typ=ma  ,validators=NoRepeat(),max='**'),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
         ),
         SECTEUR         =FACT(statut='f',max='**',
           MAILLE          =SIMP(statut='c',typ=ma  ,validators=NoRepeat(),max='**'),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
         ),
         TITRE           =SIMP(statut='f',typ='TXM'),
)  ;
