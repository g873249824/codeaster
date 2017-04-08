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
# person_in_charge: irmela.zentner at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


DYNA_ALEA_MODAL=OPER(nom="DYNA_ALEA_MODAL",op= 131,sd_prod=interspectre,
                     fr=tr("Calcul de la réponse spectrale d'une structure linéaire sous une excitation connue par sa DSP"),
                     reentrant='n',
         BASE_MODALE     =FACT(statut='o',
           regles=(UN_PARMI('NUME_ORDRE','BANDE'),),
           MODE_MECA       =SIMP(statut='o',typ=mode_meca ),
           BANDE           =SIMP(statut='f',typ='R',validators=NoRepeat(),max=2),
           NUME_ORDRE      =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
           b_bande =BLOC(condition = """exists("BANDE")""",
             AMOR_UNIF       =SIMP(statut='o',typ='R' ),
           ),
           b_nume_ordre =BLOC(condition = """exists("NUME_ORDRE")""",
             AMOR_REDUIT     =SIMP(statut='o',typ='R',max='**'),
           ),
         ),
         MODE_STAT       =SIMP(statut='f',typ=mode_meca),
# MODE_STAT devrait etre dans EXCIT car est utile et obligatoire que si NOM_CMP=depl_r, on pourrait
# ainsi rajouter un bloc du genre  b_mod_stat= BLOC(condition = """(not exists("GRANDEUR")) or (equal_to("GRANDEUR", 'DEPL_R'))""",
         EXCIT           =FACT(statut='o',
           INTE_SPEC       =SIMP(statut='o',typ=interspectre),
           NUME_VITE_FLUI  =SIMP(statut='f',typ='I' ),
           OPTION          =SIMP(statut='f',typ='TXM',defaut="TOUT",into=("TOUT","DIAG",) ),
           MODAL           =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON") ),
           b_modal_non = BLOC(condition = """(not exists("MODAL")) or (equal_to("MODAL", 'NON'))""",
             regles=(UN_PARMI('NOEUD_I','NUME_ORDRE_I'),),
             NUME_ORDRE_I    =SIMP(statut='f',typ='I',max='**'),
             NOEUD_I         =SIMP(statut='f',typ=no,max='**'),
             b_nume_ordre_i  =BLOC(condition = """exists("NUME_ORDRE_I")""",
               regles=(EXCLUS('CHAM_NO','NOEUD'),),
# on devrait rajouter EXCLUS('GRANDEUR','CHAM_NO') pour eviter ambiguite car CHAM_NO => GRANDEUR='EFFO'
# cela impliquerait d'enlever la valeur par defaut a GRANDEUR
               NUME_ORDRE_J    =SIMP(statut='o',typ='I',max='**'),
               CHAM_NO         =SIMP(statut='f',typ=cham_no_sdaster),
               NOEUD           =SIMP(statut='f',typ=no,max='**'),
               b_noeud         =BLOC(condition = """exists("NOEUD")""",
                  NOM_CMP         =SIMP(statut='o',typ='TXM',max='**'),
                ),
               GRANDEUR        =SIMP(statut='f',typ='TXM',defaut="DEPL_R",
                           into=("DEPL_R","EFFO","SOUR_DEBI_VOLU","SOUR_DEBI_MASS","SOUR_PRESS","SOUR_FORCE")),
# que se passe-t-il en cas d'incompatibilite entre GRANDEUR et NOM_CMP
               DERIVATION      =SIMP(statut='f',typ='I',defaut= 0,into=( 0 , 1 , 2 ) ),
             ),
             b_noeud_i       =BLOC(condition = """exists("NOEUD_I")""",
               NOEUD_J         =SIMP(statut='o',typ=no,max='**'),
               NOM_CMP_I       =SIMP(statut='o',typ='TXM',max='**'),
               NOM_CMP_J       =SIMP(statut='o',typ='TXM',max='**'),
               NOEUD           =SIMP(statut='o',typ=no,max='**'),
               NOM_CMP         =SIMP(statut='o',typ='TXM',max='**'),
# ne serait-il pas bien que NOEUD et NOM_CMP soient facultatifs, car l'information peut etre contenue dans
# NOEUD_I, NOM_CMP_I ...  => modif. du Fortran
               GRANDEUR        =SIMP(statut='f',typ='TXM',defaut="DEPL_R",
                           into=("DEPL_R","EFFO","SOUR_DEBI_VOLU","SOUR_DEBI_MASS","SOUR_PRESS","SOUR_FORCE")),
# que se passe-t-il en cas d'incompatibilite entre GRANDEUR et NOM_CMP_I
               DERIVATION      =SIMP(statut='f',typ='I',defaut= 0,into=( 0 , 1 , 2 ) ),
             ),
           ),
           b_modal_oui = BLOC(condition = """(equal_to("MODAL", 'OUI'))""",
# dans ce cas, y-a-t-il vraiment la possibilite d'une matrice interspectrale avec plusieurs termes
             NUME_ORDRE_I    =SIMP(statut='o',typ='I',max='**'),
             NUME_ORDRE_J    =SIMP(statut='o',typ='I',max='**'),
             GRANDEUR        =SIMP(statut='f',typ='TXM',defaut="DEPL_R",
                           into=("DEPL_R","EFFO","SOUR_DEBI_VOLU","SOUR_DEBI_MASS","SOUR_PRESS","SOUR_FORCE")),
             DERIVATION      =SIMP(statut='f',typ='I',defaut= 0,into=( 0 , 1 , 2 ) ),
# dans le cas MODAL=OUI, GRANDEUR peut-il etre different de EFFO et doit il etre impose a EFFO   On devrait
# pouvoir supprimer GRANDEUR et DERIVATION ici
           ),

         ),
         REPONSE         =FACT(statut='f',
           regles=( ENSEMBLE('FREQ_MIN','FREQ_MAX'),),
           DERIVATION      =SIMP(statut='f',typ='I',defaut= 0,into=( 0 , 1 , 2 ,) ),
           OPTION          =SIMP(statut='f',typ='TXM',defaut="TOUT",into=("TOUT","DIAG") ),
           FREQ_MIN        =SIMP(statut='f',typ='R' ),
           FREQ_MAX        =SIMP(statut='f',typ='R' ),
           PAS             =SIMP(statut='f',typ='R' ),
           b_defaut_freq   =BLOC(condition = """not exists("FREQ_MIN")""",
              FREQ_EXCIT      =SIMP(statut='f',typ='TXM',defaut="AVEC",into=("AVEC","SANS") ),
              NB_POIN_MODE    =SIMP(statut='f',typ='I',defaut= 50 ),
           ),
         ),
         TITRE           =SIMP(statut='f',typ='TXM'),
         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2) ),
)  ;
