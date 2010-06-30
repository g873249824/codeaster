#@ MODIF algorith7 Messages  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
# RESPONSABLE DELMAS J.DELMAS

def _(x) : return x

cata_msg = {

1 : _("""
 couplage fluage/fissuration :
 il faut d�finir deux lois de comportement exactement. 
"""),

2 : _("""
 GRANGER et ENDO_ISOT_BETON ou MAZARS non encore d�velopp�
"""),

3 : _("""
 loi de comportement non autoris�e dans le couplage fluage/fissuration
"""),

4 : _("""
 DEBORST non compatible avec couplage UMLV/Mazars.
 Mais le traitement analytique est r�alis�, il suffit de supprimer le
 mot-cl� DEBORST),
 
"""),
5 : _("""
 pas de C_PLAN pour ENDO_ISOT_BETON
 utiliser C_PLAN_DEBORST
"""),

6 : _("""
 loi de fluage non autorisee dans le couplage fluage/fissuration
"""),

7 : _("""
 pas d'orthotropie non lin�aire
"""),

8 : _("""
 loi de comportement hyper-�lastique non prevue
"""),

9 : _("""
 C_PLAN m�thode DEBORST et SIMO_MIEHE incompatibles
"""),

10 : _("""
 COMP1D et SIMO_MIEHE incompatibles
"""),

11 : _("""
 couplage fluage/fissuration :
 la premi�re loi doit etre une loi de fluage de type GRANGER_FP ou GRANGER_FP_V.
"""),

12 : _("""
 couplage fluage/fissuration :
 nombre total de variables internes incoh�rent <--> erreur de programmation. 
"""),

15 : _("""
  le concept EVOL_CHAR :  %(k1)s  n'en est pas un !
"""),

16 : _("""
  le concept EVOL_CHAR :  %(k1)s  ne contient aucun champ de type EVOL_CHAR.
"""),

20 : _("""
 le champ de d�placement DIDI n'est pas trouv� dans le concept  %(k1)s 
"""),









56 : _("""
 liste RELATION_KIT vide
"""),

57 : _("""
 liste RELATION_KIT trop longue
"""),

58 : _("""
 1D ou C_PLAN ?
"""),


60 : _("""
  -> Le crit�re de convergence pour int�grer le comportement 'RESI_INTE_RELA'
     est lache (tr�s sup�rieur � la valeur par d�faut).
  -> Risque & Conseil :
     Cela peut nuire � la qualit� de la solution et � la convergence.
"""),

61 : _("""
 option  %(k1)s  non traitee
"""),

63 : _("""
 pas existence de solution pour le saut
"""),

64 : _("""
 existence d'un �l�ment � discontinuit� trop grand
 non unicit� du saut
"""),

65 : _("""
 non convergence du NEWTON pour le calcul du saut num�ro 1
"""),

66 : _("""
 non convergence du NEWTON pour le calcul du saut num�ro 2
"""),

67 : _("""
 non convergence du NEWTON pour le calcul du saut num�ro 3
"""),

68 : _("""
 erreur dans le calcul du saut
"""),

69 : _("""
 loi %(k1)s  non implantee pour les elemdisc 
"""),

73 : _("""
 le tenseur EPSEQ vaut  0 on a donc une deriv�e lagrangienne DEPSEQ tr�s grande !
"""),

74 : _("""
  valeur de D_SIGM_EPSI non trouv�e
"""),

75 : _("""
  valeur de SY non trouv�e
"""),

76 : _("""
 d�veloppement non implant�
"""),

79 : _("""
 loi de comportement avec irradiation, le param�tre N doit etre sup�rieur � 0
"""),

80 : _("""
 loi de comportement avec irradiation, le param�tre PHI_ZERO doit etre sup�rieur � 0
"""),

81 : _("""
 loi de comportement avec irradiation, le param�tre phi/K.PHI_ZERO+L doit etre sup�rieur ou �gal � 0
"""),

82 : _("""
 loi de comportement avec irradiation, le param�tre phi/K.PHI_ZERO+L vaut 0. Dans ces conditions le param�tre BETA doit �tre positif ou nul
"""),

96 : _("""
 comportement ZMAT obligatoire
"""),

98 : _("""
 il faut d�clarer FONC_DESORP sous ELAS_FO pour le fluage de dessication
 intrinseque avec SECH comme param�tre
"""),

}
