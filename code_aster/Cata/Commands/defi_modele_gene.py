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


DEFI_MODELE_GENE=OPER(nom="DEFI_MODELE_GENE",op= 126,sd_prod=modele_gene,
                      reentrant='n',
            fr=tr("Créer la structure globale à partir des sous-structures en sous-structuration dynamique"), 
         SOUS_STRUC      =FACT(statut='o',max='**',
           NOM             =SIMP(statut='o',typ='TXM' ),
           MACR_ELEM_DYNA  =SIMP(statut='o',typ=macr_elem_dyna ),
           ANGL_NAUT       =SIMP(statut='o',typ='R',max=3),
           TRANS           =SIMP(statut='o',typ='R',max=3),
         ),
         LIAISON         =FACT(statut='o',max='**',
           SOUS_STRUC_1    =SIMP(statut='o',typ='TXM' ),
           INTERFACE_1     =SIMP(statut='o',typ='TXM' ),
           SOUS_STRUC_2    =SIMP(statut='o',typ='TXM' ),
           INTERFACE_2     =SIMP(statut='o',typ='TXM' ),
           regles=(EXCLUS('GROUP_MA_MAIT_1','GROUP_MA_MAIT_2','MAILLE_MAIT_2'),
                   EXCLUS('MAILLE_MAIT_1','GROUP_MA_MAIT_2','MAILLE_MAIT_2'),),
           GROUP_MA_MAIT_1   =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE_MAIT_1     =SIMP(statut='c',typ=ma  ,validators=NoRepeat(),max='**'),
           GROUP_MA_MAIT_2   =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE_MAIT_2     =SIMP(statut='c',typ=ma  ,validators=NoRepeat(),max='**'),
           OPTION            =SIMP(statut='f',typ='TXM',defaut="CLASSIQUE",into=("REDUIT","CLASSIQUE") ),
         ),
         VERIF           =FACT(statut='f',max='**',
#  dans la doc U stop_erreur est obligatoire         
           STOP_ERREUR     =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON") ),
           PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-3 ),
           CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU") ),
         ),
         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2) ),
)  ;
