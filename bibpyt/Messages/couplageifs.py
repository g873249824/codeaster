# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
cata_msg={

1 : _(u"""
 Erreur dans ENV_CINE_YACS : 
 il faut donner RESULTAT ou ETAT_INIT, pas les deux en m�me temps
"""),

2 : _(u"""
 Erreur dans ENV_CINE_YACS : probl�me avec VIS_A_VIS
"""),

3 : _(u"""
 Erreur dans ENV_CINE_YACS : probl�me avec ETAT_INIT :
 il faut donner DEPL, VITE et ACCE
"""),

4 : _(u"""
 Erreur dans ENV_CINE_YACS : incoh�rence entre maillage et champs
"""),

5 : _(u"""
 Erreur dans MODI_CHAR_YACS : probl�me avec VIS_A_VIS
"""),

6 : _(u"""
 Erreur dans MODI_CHAR_YACS : incoh�rence entre maillage et champs
"""),

7 : _(u"""
 Erreur dans MODI_CHAR_YACS : erreur lecture NUTIOC
"""),

8 : _(u"""
 Erreur dans PROJ_CHAMP option COUPLAGE      
     Nombre d'interfaces d�finies dans Code_Saturne : %(i1)i
     Nombre d'interfaces d�finies dans Code_Aster   : %(i2)i
     V�rifiez la coh�rence entre :
       Code_Aster   : Le mot-cl� GROUP_MA_IFS de la commande CALC_IFS_DNL
       Code_Saturne : La d�finition des structures dans USASTE.F
"""),

9 : _(u"""
 Erreur dans PROJ_CHAMP option COUPLAGE : type de maille non reconnue : %(k1)s
"""),


10 : _(u"""
 Routine %(k1)s : argument %(k2)s : %(i1)d
"""),

11 : _(u"""
 Routine %(k1)s : argument %(k2)s : %(k3)s
"""),

12 : _(u"""
 Erreur dans PROJ_CHAMP option COUPLAGE :
     le nombre de noeuds � l'interface : %(i1)i est sup�rieur � la limite autoris�e : %(i2)i
"""),

}
