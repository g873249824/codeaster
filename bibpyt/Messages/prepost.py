#@ MODIF prepost Messages  DATE 08/02/2008   AUTEUR MACOCCO K.MACOCCO 
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

def _(x) : return x

cata_msg = {

1 : _("""
 GROUP_NO :  %(k1)s  inconnu dans le maillage
"""),





4 : _("""
 m�thode  %(k1)s  illicite
"""),

5 : _("""
 la longueur du d�faut n'est pas en accord avec les tables d�finies
 cot� revetement et cot� m�tal de base
"""),

8 : _("""
 prolongement � gauche exclu
"""),

9 : _("""
 prolongement � droite exclu
"""),

10 : _("""
 ph�nom�ne non valide
"""),

11 : _("""
 nous ne pouvons pas r�cup�rer la valeur du module d'Young : E.
"""),

12 : _("""
 nous ne pouvons pas r�cup�rer la valeur du coefficient de Poisson : NU.
"""),

21 : _("""
 Intersection Droite / Cercle
 pas d'intersection trouv�e
"""),











27 : _("""
 volume n�gatif
"""),

28 : _("""
 volume sup�rieur � 1.d6
"""),








31 : _("""
 structure de donn�es RESULTAT inconnue  %(k1)s 
"""),

32 : _("""
  l'impression de la SD_RESULTAT  %(k1)s  a d�j� �t� effectu�e
  avec une liste de num�ros d'ordre dont le premier num�ro etait
  le meme que celui de la liste actuelle.
  on arrete l'impression afin d'�viter l'�crasement des fichiers �crits.
"""),

33 : _("""
 probl�me � l'ouverture du fichier r�sultat ENSIGHT  %(k1)s
 pour l'impression du CHAM_GD  %(k2)s 
"""),

34 : _("""
 probleme � l'ouverture du fichier r�sultat ENSIGHT  %(k1)s
 pour l'impression du CONCEPT  %(k2)s 
"""),



36 : _("""
 le champ de:  %(k1)s  a des �l�ments ayant des sous-points.
 ces �l�ments ne seront pas trait�s.
"""),





38 : _("""
 le vecteur d�fini sous le mot cl� ACTION/AXE_Z a une norme nulle.
"""),

46 : _("""
 erreur dans la cr�ation du fichier de maillage au format GIBI.
 Celui-ci ne contient pas d'objet de type maillage.
 
 Risque & Conseil:
 Assurez vous que votre proc�dure gibi sauvegarde bien les objets du maillage (pile 32 dans le formalisme GIBI)
"""),

51 : _("""
 l'option de calcul " %(k1)s " n'existe pas dans la structure de donn�es %(k2)s 
"""),

52 : _("""
 le champ " %(k1)s " pour l'option de calcul " %(k2)s ", n'a pas �t� not�e
 dans la structure de donn�es %(k3)s 
"""),

53 : _("""
 la dimension du probl�me est invalide : il faut : 1d, 2d ou 3d.
"""),

54 : _("""
 nombre de noeuds sup�rieur au maximum autoris� : 27.
"""),

55 : _("""
 objet &&GILIRE.INDIRECT inexistant
 probl�me � la lecture des points 
"""),

56 : _("""
 type de maille :  %(k1)s  inconnu de la commande PRE_GIBI.
"""),

57 : _("""
 nombre d'objets sup�rieur au maximum autoris� : 99999.
"""),





59 : _("""
 le maillage GIBI est peut etre erron� :
 il est �crit : "NIVEAU RREUR N_ERR"  avec N_ERR est >0 .
 on continue quand meme, mais si vous avez des probl�mes plus loin ...
"""),

60 : _("""
 arret sur erreur(s)
"""),

61 : _("""
 erreur dans la r�cup�ration du NUME.PRNO
"""),

62 : _("""
 probl�me dans la r�cup�ration du num�ro de bloc auquel appartient la ligne courante.
"""),

63 : _("""
 les seuls types de valeurs accept�s pour les RESU_ELEM sont les r�els et les complexes
 le descripteur de type  %(k1)s  est inad�quat.
"""),

64 : _("""
 les seuls types de structures de donn�es autoris�s sont :
 MATR_ASSE , MATR_ELEM , VECT_ELEM , RESU_ELEM
 le type donn�  %(k1)s  n'est pas reconnu .
"""),

65 : _("""
 la valeur du grain d'impression est  %(k1)s  alors que
 les seules valeurs possibles sont "NOEUD" ou "VALEUR" ou "MAILLE".
"""),

66 : _("""
 la valeur du grain d'impression est  %(k1)s  alors que
 les seules valeurs possibles sont "NOEUD" et "VALEUR".
"""),

67 : _("""
 probleme dans le descripteur de la matrice :
 l'indicateur de sym�trie ne correspond ni � une matrice sym�trique,
 ni � une matrice non-sym�trique . 
"""),

68 : _("""
 probl�me dans le descripteur de la matrice :
 l'indicateur type de valeur de la matrice ne correspond ni � une matrice r�elle,
 ni � une matrice complexe . 
"""),

69 : _("""
 probl�me � l'ouverture du fichier
"""),

74 : _("""
 la variable  %(k1)s  n'existe pas
"""),

75 : _("""
 pas d'impression du champ
"""),

76 : _("""
  -> Il y a des groupes de noeuds dans le maillage %(k1)s.
     Ils  n'apparaitront pas dans le fichier g�om�trie ENSIGHT.
     Seuls des groupes de mailles peuvent y etre int�gr�s.
"""),

77 : _("""
  incompatibilit� entre les GREL
"""),




79 : _("""
  le nombre de couches est sup�rieur � 1 
"""),

80 : _("""
 on traite les TRIA7 QUAD9 en oubliant le noeud centre
"""),

84 : _("""
 �l�ment PYRA5 non disponible dans IDEAS
"""),

85 : _("""
 �l�ment PYRA13 non disponible dans IDEAS
"""),

86 : _("""
 on traite les TRIA7 QUAD9 HEXA27 en oubliant le noeud centre
"""),

87 : _("""
 on ne sait pas imprimer le champ de type:  %(k1)s 
 champ :  %(k2)s 
"""),

88 : _("""
  on ne sait pas imprimer au format ENSIGHT le champ  %(k1)s
  correspondant � la grandeur : %(k2)s
  il faut imprimer des champs aux noeuds � ce format.
"""),







90 : _("""
 on ne sait pas imprimer le champ  %(k1)s  au format  %(k2)s 
"""),

97 : _("""
 on ne sait pas imprimer les champs de type " %(k1)s "
"""),

98 : _("""
 le champ:  %(k1)s  a des �l�ments ayant des sous-points.
 il est �crit avec un format diff�rent.
"""),

99 : _("""
 le champ:  %(k1)s  a des �l�ments ayant des sous-points.
 ces �l�ments ne seront pas �crits.
"""),

}
