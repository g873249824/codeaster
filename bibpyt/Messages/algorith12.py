#@ MODIF algorith12 Messages  DATE 10/05/2012   AUTEUR MACOCCO K.MACOCCO 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

2 : _("""
 interface inexistante
 num�ro liaison            : %(i1)d
 nom sous-structure        : %(k1)s
 nom MACR_ELEM             : %(k2)s
 nom interface inexistante : %(k3)s
"""),

3 : _("""
 On ne trouve pas le nom de l'interface associ�e � la sous-structure
 %(k1)s. La base modale utilis�e pour d�finir le macro-�l�ment associ�
 � la sous-structure doit avoir �t� d�finie avec DEFI_BASE_MODALE, en
 mentionnant obligatoirement l'interface sous le mot-cl� INTERF_DYNA.
"""),


7 : _("""
 donn�es incompatibles :
 pour les modes mecaniques :  %(k1)s
 il manque l'option        :  %(k2)s
"""),

12 : _("""
 donn�es incompatibles :
 pour les MODE_CORR :  %(k1)s
 il manque le champ :  %(k2)s
"""),

13 : _("""
 donn�es incompatibles :
 pour les mode_corr :  %(k1)s
 pour le champ      :  %(k2)s
 le type n'est pas  %(k3)s
"""),

14 : _("""
 donnees incompatibles :
 pour les statiques :  %(k1)s
 il manque le champ :  %(k2)s
"""),

15 : _("""
 donn�es incompatibles :
 pour les statiques :  %(k1)s
 pour le champ      :  %(k2)s
 le type n'est pas  %(k3)s
"""),

16 : _("""
 La base modale %(k1)s contient des modes complexes.
 On ne peut pas projeter de matrice sur cette base.
 Conseil : calculez si possible une base modale avec vecteurs propres r�els.
"""),

18 : _("""
 on ne sait pas bien traiter l'option de calcul demand�e :  %(k1)s
"""),

20 : _("""
 donn�es incompatibles :
 pour les modes m�caniques :  %(k1)s
 pour l'option             :  %(k2)s
 il manque le champ d'ordre  %(i1)d
"""),

21 : _("""
 donn�es incompatibles :
 pour les mode_corr :  %(k1)s
 il manque l'option :  %(k2)s
"""),

22 : _("""
 donn�es incompatibles :
 pour les modes statiques :  %(k1)s
 il manque l'option       :  %(k2)s
"""),


26 : _("""
 arret sur manque argument
 base modale donn�e -->  %(k1)s
 interf_dyna donn�e -->  %(k2)s
"""),

27 : _("""
 arret sur type de base incorrecte
 base modale donn�e -->  %(k1)s
 type  base modale  -->  %(k2)s
 type attendu       -->  %(k3)s
"""),

28 : _("""
 arret sur incoh�rence donn�es
 base modale donn�e         -->  %(k1)s
 INTERF_DYNA correspondante -->  %(k2)s
 INTERF_DYNA donn�e         -->  %(k3)s
"""),

29 : _("""
 probl�me arguments de d�finition interface
 nom interface donn�    %(k1)s
 numero interface donn� %(i1)d
"""),

30 : _("""
 arret sur base modale sans INTERF_DYNA
 base modale donn�e -->  %(k1)s
"""),

31 : _("""
 arret sur manque arguments
 base modale donn�e -->  %(k1)s
 INTERF_DYNA donn�e -->  %(k2)s
"""),

38 : _("""
 arret sur probl�me coh�rence interface
"""),

39 : _("""
 arret sur matrice inexistante
 matrice %(k1)s
"""),

40 : _("""
  arret probl�me de factorisation:
  pr�sence probable de modes de corps rigide
  la methode de Mac-Neal ne fonctionne pas en pr�sence de modes de corps rigide
"""),

41 : _("""
  la taille bloc  : %(i1)d est < HAUTEUR_MAX : %(i2)d
  changez la taille_bloc des profils: %(k1)s
  prenez au moins : %(i3)d
"""),

42 : _("""
 le mot-cl�  %(k1)s est incompatible avec le champ %(k2)s
 utilisez 'GROUP_MA' ou 'MAILLE'  pour restreindre le changement de repere
 � certaines mailles. %(k3)s
"""),

43 : _("""
 �tude 2D
 angle nautique unique :  %(r1)f
"""),

44 : _("""
 noeud sur l'AXE_Z noeud :  %(k1)s
"""),

49 : _("""
 probl�me: sous-structure inconnue
 sous-structure -->  %(k1)s
"""),

50 : _("""
 pas de sous-structure dans le squelette
"""),

51 : _("""
 nom de sous-structure non trouv� 
 la sous-structure :  %(k1)s n existe pas  %(k2)s
"""),

53 : _("""
 arret sur pivot nul
 ligne -->  %(i1)d
"""),

55 : _("""
 le MAILLAGE : %(k1)s ne contient pas de GROUP_MA
"""),

56 : _("""
 le GROUP_MA : %(k2)s n'existe pas dans le MAILLAGE : %(k1)s
"""),

57 : _("""
 le MAILLAGE : %(k1)s ne contient pas de GROUP_NO  
"""),

58 : _("""
 le GROUP_NO : %(k2)s n'existe pas dans le MAILLAGE : %(k1)s
"""),

59 : _("""
 nombre de noeuds communs NBNOCO =  %(i1)d
"""),

62 : _("""
 les deux num�rotations n'ont pas meme maillage d'origine
  num�rotation 1: %(k1)s
  maillage     1: %(k2)s
  num�rotation 2: %(k3)s
  maillage     2: %(k4)s
"""),

63 : _("""
 perte d'information sur DDL physique � la conversion de num�rotation
 noeud num�ro    :  %(i1)d
 type DDL num�ro :  %(i2)d
"""),

64 : _("""
 arret sur perte d'information DDL physique
"""),

66 : _("""
 champ inexistant
 CHAMP      :  %(k1)s
 NUME_ORDRE :  %(i1)d
 MODE_MECA  :  %(k2)s
"""),

67 : _("""
 arret sur probl�me de conditions d'interface
"""),

68 : _("""
 le maillage final n'est pas 3D
 maillage : %(k1)s
"""),

69 : _("""
 l'origine du maillage 1D n'est pas 0
"""),

70 : _("""
 les noeuds du maillage sont confondus
"""),

71 : _("""

 le noeud se trouve en dehors du domaine de d�finition avec un profil gauche de type EXCLU
 noeud :  %(k1)s
"""),

72 : _("""

 le noeud se trouve en dehors du domaine de definition avec un profil droit de type EXCLU
 noeud :  %(k1)s
"""),

73 : _("""
 probl�me pour stocker le champ dans le r�sultat :  %(k1)s
 pour le NUME_ORDRE :  %(i1)d
"""),

74 : _("""
 champ d�j� existant
 il sera remplac� par le champ %(k1)s
 pour le NUME_ORDRE  %(i1)d
"""),

76 : _("""
  probl�me de r�cuperation CHAMNO
  concept r�sultat:  %(k1)s
  num�ro d'ordre  :  %(i1)d
"""),

77 : _("""
 pas d'interface d�finie
"""),

78 : _("""
 arret sur interface d�j� d�finie
 mot-cl� interface numero  -->  %(i1)d
 interface                 -->  %(k1)s
"""),

79 : _("""
 les deux interfaces n'ont pas le meme nombre de noeuds
 nombre noeuds interface droite -->  %(i1)d
 nombre noeuds interface gauche -->  %(i2)d
"""),

80 : _("""
 les deux interfaces n'ont pas le meme nombre de degr�s de libert�
 nombre ddl interface droite -->  %(i1)d
 nombre ddl interface gauche -->  %(i2)d
"""),

81 : _("""
 arret sur base modale ne comportant pas de modes propres
"""),

82 : _("""

 nombre de modes propres demand� sup�rieur au nombre de modes dynamiques de la base
 nombre de modes demand�s       --> %(i1)d
 nombre de modes de la base     --> %(i2)d
 nombre de fr�quences douteuses --> %(i3)d
"""),

83 : _("""
 plusieurs champs correspondant � l'acces demand�
 resultat     : %(k1)s
 acces "INST" : %(r1)f
 nombre       : %(i1)d
"""),

84 : _("""
 pas de champ correspondant � un acc�s demand�
 r�sultat     :  %(k1)s
 acces "INST" :  %(r1)f
"""),

89 : _("""
 instant de reprise sup�rieur � la liste des instants
 instant de reprise :  %(r1)f
 instant max        :  %(r2)f
"""),

90 : _("""
 on n'a pas trouv� l'instant
 instant de reprise:  %(r1)f
 pas de temps      :  %(r2)f
 borne min         :  %(r3)f
 borne max         :  %(r4)f
"""),

91 : _("""
 instant final inf�rieur � la liste des instants
 instant final:  %(r1)f
 instant min  :  %(r2)f
"""),

92 : _("""
 on n'a pas trouv� l'instant
 instant final:  %(r1)f
 pas de temps :  %(r2)f
 borne min    :  %(r3)f
 borne max    :  %(r4)f
"""),

97 : _("""
 donn�es erron�es
 pas d'instant de calcul pour l'instant d'archivage :  %(r1)f
"""),

98 : _("""
 donn�es erron�es
 plusieurs instants de calcul pour l'instant d'archivage:  %(r1)f
"""),

}
