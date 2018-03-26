# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

# person_in_charge: mickael.abbas at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


AFFE_MATERIAU=OPER(nom="AFFE_MATERIAU",op=6,sd_prod=cham_mater,
                   fr=tr("Affecter des matériaux à des zones géométriques d'un maillage"),
                         reentrant='n',
         regles=(AU_MOINS_UN('MAILLAGE','MODELE',),),
         MAILLAGE        =SIMP(statut='f',typ=maillage_sdaster),
         MODELE          =SIMP(statut='f',typ=modele_sdaster),

         #  affectation du nom du matériau (par mailles):
         #  ----------------------------------------------
         AFFE            =FACT(statut='o',max='**',
           regles=(UN_PARMI('TOUT','GROUP_MA','MAILLE'),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE          =SIMP(statut='c',typ=ma  ,validators=NoRepeat(),max='**'),
           MATER           =SIMP(statut='o',typ=mater_sdaster,max=30),
         ),

         #  affectation de comportement (multifibres pour l'instant):
         #  ----------------------------------------------
         AFFE_COMPOR        =FACT(statut='f',max='**',
           regles=(UN_PARMI('TOUT','GROUP_MA','MAILLE'),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE          =SIMP(statut='c',typ=ma  ,validators=NoRepeat(),max='**'),
           COMPOR          =SIMP(statut='o',typ=compor_sdaster,max=1),
         ),

         #  affectation des variables de commande :
         #  --------------------------------------------------
         # un mot clé caché qui ne sert qu'à boucler sur les VARC possibles :
         LIST_NOM_VARC =SIMP(statut='c',typ='TXM', max='**', defaut=("TEMP","GEOM","CORR","IRRA","HYDR","SECH","EPSA",
                                                           "M_ACIER","M_ZIRC","NEUT1","NEUT2","PTOT","DIVU",)),

         AFFE_VARC    =FACT(statut='f',max='**',
          regles=(PRESENT_ABSENT('TOUT','GROUP_MA','MAILLE'),
                  PRESENT_ABSENT('GROUP_MA','TOUT'),
                  PRESENT_ABSENT('MAILLE','TOUT'),
                  EXCLUS('EVOL','CHAM_GD'),
                  ),

          TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ), # [défaut]
          GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
          MAILLE          =SIMP(statut='c',typ=ma  ,validators=NoRepeat(),max='**'),

          NOM_VARC        =SIMP(statut='o',typ='TXM', into=("TEMP","GEOM","CORR","IRRA","HYDR","SECH","EPSA",
                               "M_ACIER","M_ZIRC","NEUT1","NEUT2","PTOT","DIVU",)),
          CHAM_GD        =SIMP(statut='f',typ=cham_gd_sdaster,),
          EVOL            =SIMP(statut='f',typ=evol_sdaster,),

          B_EVOL          =BLOC(condition="""exists("EVOL")""",
              NOM_CHAM      =SIMP(statut='f',typ='TXM',into=("TEMP","CORR","IRRA","NEUT","GEOM",
                                                             "HYDR_ELNO","HYDR_NOEU",
                                                             "META_ELNO","META_NOEU",
                                                             "EPSA_ELNO","EPSA_NOEU","PTOT","DIVU",)),
              PROL_DROITE   =SIMP(statut='f',typ='TXM',defaut="EXCLU",into=("CONSTANT","LINEAIRE","EXCLU") ),
              PROL_GAUCHE   =SIMP(statut='f',typ='TXM',defaut="EXCLU",into=("CONSTANT","LINEAIRE","EXCLU") ),
              FONC_INST     =SIMP(statut='f',typ=(fonction_sdaster,formule)),
          ),

          # VALE_REF est nécessaire pour certaines VARC :
          B_VALE_REF          =BLOC(condition="""is_in("NOM_VARC", ('TEMP','SECH'))""",
               VALE_REF          =SIMP(statut='o',typ='R'),
          ),

         ),

         #  mots clés cachés pour les variables de commande NEUT1/NEUT2 :
         #  --------------------------------------------------------------
         VARC_NEUT1   =FACT(statut='c',
           NOM_VARC        =SIMP(statut='c',typ='TXM',defaut="NEUT1"),
           GRANDEUR        =SIMP(statut='c',typ='TXM',defaut="NEUT_R"),
           CMP_GD          =SIMP(statut='c',typ='TXM',max=1,min=1,defaut=("X1")),
           CMP_VARC        =SIMP(statut='c',typ='TXM',max=1,min=1,defaut=("NEUT1")),
         ),
         VARC_NEUT2   =FACT(statut='c',
           NOM_VARC        =SIMP(statut='c',typ='TXM',defaut="NEUT2"),
           GRANDEUR        =SIMP(statut='c',typ='TXM',defaut="NEUT_R"),
           CMP_GD          =SIMP(statut='c',typ='TXM',max=1,min=1,defaut=("X1")),
           CMP_VARC        =SIMP(statut='c',typ='TXM',max=1,min=1,defaut=("NEUT2")),
         ),

         #  mots clés cachés pour variable de commande TEMP :
         #  --------------------------------------------------
         VARC_TEMP    =FACT(statut='c',
           NOM_VARC        =SIMP(statut='c',typ='TXM',defaut="TEMP"),
           GRANDEUR        =SIMP(statut='c',typ='TXM',defaut="TEMP_R"),
           CMP_GD          =SIMP(statut='c',typ='TXM',max=7,min=7,defaut=("TEMP","TEMP_MIL","TEMP_INF","TEMP_SUP","DTX","DTY","DTZ")),
           CMP_VARC        =SIMP(statut='c',typ='TXM',max=7,min=7,defaut=("TEMP","TEMP_MIL","TEMP_INF","TEMP_SUP","DTX","DTY","DTZ")),
         ),

         #  mots clés cachés pour variable de commande GEOM :
         #  --------------------------------------------------
         VARC_GEOM    =FACT(statut='c',
           NOM_VARC        =SIMP(statut='c',typ='TXM',defaut="GEOM"),
           GRANDEUR        =SIMP(statut='c',typ='TXM',defaut="GEOM_R"),
           CMP_GD          =SIMP(statut='c',typ='TXM',max=3,min=3,defaut=("X","Y","Z",)),
           CMP_VARC        =SIMP(statut='c',typ='TXM',max=3,min=3,defaut=("X","Y","Z",)),
         ),

         #  mots clés cachés pour variable de commande PTOT :
         #  -------------------------------------------------
         VARC_PTOT    =FACT(statut='c',
           NOM_VARC         =SIMP(statut='c',typ='TXM',defaut="PTOT"),
           GRANDEUR         =SIMP(statut='c',typ='TXM',defaut="DEPL_R"),
           CMP_GD           =SIMP(statut='c',typ='TXM',max=1,min=1,defaut=("PTOT",)),
           CMP_VARC         =SIMP(statut='c',typ='TXM',max=1,min=1,defaut=("PTOT",)),
         ),

         #  mots clés cachés pour variable de commande SECH :
         #  --------------------------------------------------
         VARC_SECH    =FACT(statut='c',
           NOM_VARC        =SIMP(statut='c',typ='TXM',defaut="SECH"),
           GRANDEUR        =SIMP(statut='c',typ='TXM',defaut="TEMP_R"),
           CMP_GD          =SIMP(statut='c',typ='TXM',max=1,min=1,defaut=("TEMP",)),
           CMP_VARC        =SIMP(statut='c',typ='TXM',max=1,min=1,defaut=("SECH",)),
         ),

         #  mots clés cachés pour variable de commande HYDR :
         #  --------------------------------------------------
         VARC_HYDR    =FACT(statut='c',
           NOM_VARC        =SIMP(statut='c',typ='TXM',defaut="HYDR"),
           GRANDEUR        =SIMP(statut='c',typ='TXM',defaut="HYDR_R"),
           CMP_GD          =SIMP(statut='c',typ='TXM',max=1,min=1,defaut=("HYDR",)),
           CMP_VARC        =SIMP(statut='c',typ='TXM',max=1,min=1,defaut=("HYDR",)),
         ),

         #  mots clés cachés pour variable de commande CORR :
         #  --------------------------------------------------
         VARC_CORR    =FACT(statut='c',
           NOM_VARC        =SIMP(statut='c',typ='TXM',defaut="CORR"),
           GRANDEUR        =SIMP(statut='c',typ='TXM',defaut="CORR_R"),
           CMP_GD          =SIMP(statut='c',typ='TXM',max=1,min=1,defaut=("CORR",)),
           CMP_VARC        =SIMP(statut='c',typ='TXM',max=1,min=1,defaut=("CORR",)),
         ),

         #  mots clés cachés pour variable de commande IRRA :
         #  --------------------------------------------------
         VARC_IRRA    =FACT(statut='c',
           NOM_VARC        =SIMP(statut='c',typ='TXM',defaut="IRRA"),
           GRANDEUR        =SIMP(statut='c',typ='TXM',defaut="IRRA_R"),
           CMP_GD          =SIMP(statut='c',typ='TXM',max=1,min=1,defaut=("IRRA",)),
           CMP_VARC        =SIMP(statut='c',typ='TXM',max=1,min=1,defaut=("IRRA",)),
         ),

         #  mots clés cachés pour variable de commande DIVU :
         #  --------------------------------------------------
         VARC_DIVU    =FACT(statut='c',
           NOM_VARC        =SIMP(statut='c',typ='TXM',defaut="DIVU"),
           GRANDEUR        =SIMP(statut='c',typ='TXM',defaut="EPSI_R"),
           CMP_GD          =SIMP(statut='c',typ='TXM',max=1,min=1,defaut=("DIVU",)),
           CMP_VARC        =SIMP(statut='c',typ='TXM',max=1,min=1,defaut=("DIVU",)),
         ),

         #  mots clés cachés pour variable de commande EPSA :
         #  --------------------------------------------------
         VARC_EPSA    =FACT(statut='c',
           NOM_VARC        =SIMP(statut='c',typ='TXM',defaut="EPSA"),
           GRANDEUR        =SIMP(statut='c',typ='TXM',defaut="EPSI_R"),
           CMP_GD          =SIMP(statut='c',typ='TXM',max=6,min=6,defaut=("EPXX","EPYY","EPZZ","EPXY","EPXZ","EPYZ",)),
           CMP_VARC        =SIMP(statut='c',typ='TXM',max=6,min=6,defaut=("EPSAXX","EPSAYY","EPSAZZ","EPSAXY","EPSAXZ","EPSAYZ",)),
         ),
         #  mots clés cachés pour variable de commande metallurgique ACIER :
         #  -----------------------------------------------------------------
         VARC_M_ACIER  =FACT(statut='c',
           NOM_VARC        =SIMP(statut='c',typ='TXM',defaut="M_ACIER"),
           GRANDEUR        =SIMP(statut='c',typ='TXM',defaut="VARI_R"),
           CMP_GD          =SIMP(statut='c',typ='TXM',max=8,min=8,defaut=("V1","V2","V3","V4","V5","V6","V7","V8")),
           CMP_VARC        =SIMP(statut='c',typ='TXM',max=8,min=8,defaut=("PFERRITE","PPERLITE","PBAINITE",
                                                                          "PMARTENS","PAUSTENI","TAUSTE","TRANSF","TACIER",)),
         ),
         #  mots clés cachés pour variable de commande metallurgique ZIRCALOY :
         #  --------------------------------------------------------------------
         VARC_M_ZIRC  =FACT(statut='c',
           NOM_VARC        =SIMP(statut='c',typ='TXM',defaut="M_ZIRC"),
           GRANDEUR        =SIMP(statut='c',typ='TXM',defaut="VARI_R"),
           CMP_GD          =SIMP(statut='c',typ='TXM',max=5,min=5,defaut=("V1","V2","V3","V4","V5")),
           CMP_VARC        =SIMP(statut='c',typ='TXM',max=5,min=5,defaut=("ALPHPUR","ALPHBETA","BETA","TZIRC","TEMPS")),
         ),

         INFO            =SIMP(statut='f',typ='I',defaut=1,into=(1,2) ),
         translation={
            "AFFE_MATERIAU": "Assign a material",
            "AFFE": "Material assignement",
            "AFFE_COMPOR": "Behavior assignement",
            "AFFE_VARC": "External state variable assignement",
            "NOM_VARC": "External state variable" ,
            "NOM_CHAM": "Field name",
            "TOUT": "Everywhere",    
         }
)  ;
