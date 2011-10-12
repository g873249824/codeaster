#@ MODIF prepost Messages  DATE 12/10/2011   AUTEUR COURTOIS M.COURTOIS 
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
# RESPONSABLE DELMAS J.DELMAS

cata_msg = {

1 : _(u"""
 GROUP_NO :  %(k1)s  inconnu dans le maillage
"""),

4 : _(u"""
 m�thode  %(k1)s  illicite
"""),

5 : _(u"""
 la longueur du d�faut n'est pas en accord avec les tables d�finies
 cot� revetement et cot� m�tal de base
"""),

8 : _(u"""
 prolongement � gauche exclu
"""),

9 : _(u"""
 prolongement � droite exclu
"""),

10 : _(u"""
 ph�nom�ne non valide
"""),

11 : _(u"""
 nous ne pouvons pas r�cup�rer la valeur du module d'Young : E.
"""),

12 : _(u"""
 nous ne pouvons pas r�cup�rer la valeur du coefficient de Poisson : NU.
"""),

13 : _(u"""
 Les valeurs non existantes du champ %(k1)s lues sur le maillage donn�
 sont consid�r�es nulles.
"""),

14 : _(u"""
 NUME_DDL a �t� d�termin� � partir de la matrice de masse MATR_B.
"""),

21 : _(u"""
 Intersection Droite / Cercle
 pas d'intersection trouv�e
"""),

28 : _(u"""
 volume sup�rieur � 1.d6
"""),

31 : _(u"""
 structure de donn�es RESULTAT inconnue  %(k1)s 
"""),

32 : _(u"""
  l'impression de la SD_RESULTAT  %(k1)s  a d�j� �t� effectu�e
  avec une liste de num�ros d'ordre dont le premier num�ro etait
  le meme que celui de la liste actuelle.
  on arrete l'impression afin d'�viter l'�crasement des fichiers �crits.
"""),

33 : _(u"""
 probl�me � l'ouverture du fichier r�sultat ENSIGHT  %(k1)s
 pour l'impression du CHAM_GD  %(k2)s 
"""),

34 : _(u"""
 probleme � l'ouverture du fichier r�sultat ENSIGHT  %(k1)s
 pour l'impression du CONCEPT  %(k2)s 
"""),

36 : _(u"""
 le champ de:  %(k1)s  a des �l�ments ayant des sous-points.
 ces �l�ments ne seront pas trait�s.
"""),

38 : _(u"""
 le vecteur d�fini sous le mot cl� ACTION/AXE_Z a une norme nulle.
"""),

46 : _(u"""
 erreur dans la cr�ation du fichier de maillage au format GIBI.
 Celui-ci ne contient pas d'objet de type maillage.
 
 Risque & Conseil:
 Assurez vous que votre proc�dure gibi sauvegarde bien les objets du maillage (pile 32 dans le formalisme GIBI)
"""),

51 : _(u"""
 l'option de calcul " %(k1)s " n'existe pas dans la structure de donn�es %(k2)s 
"""),

52 : _(u"""
 le champ " %(k1)s " pour l'option de calcul " %(k2)s ", n'a pas �t� not�e
 dans la structure de donn�es %(k3)s 
"""),

53 : _(u"""
 la dimension du probl�me est invalide : il faut : 1d, 2d ou 3d.
"""),

54 : _(u"""
 nombre de noeuds sup�rieur au maximum autoris� : 27.
"""),

55 : _(u"""
 objet &&GILIRE.INDIRECT inexistant
 probl�me � la lecture des points 
"""),

56 : _(u"""
 type de maille :  %(k1)s  inconnu de la commande PRE_GIBI.
"""),

57 : _(u"""
 nombre d'objets sup�rieur au maximum autoris� : 99999.
"""),

59 : _(u"""
 le maillage GIBI est peut etre erron� :
 il est �crit : "NIVEAU RREUR N_ERR"  avec N_ERR est >0 .
 on continue quand meme, mais si vous avez des probl�mes plus loin ...
"""),

60 : _(u"""
 arret sur erreur(s)
"""),

69 : _(u"""
 probl�me � l'ouverture du fichier
"""),

70 : _(u"""
 probl�me � la fermeture du fichier
"""),

74 : _(u"""
 la variable  %(k1)s  n'existe pas
"""),

75 : _(u"""
 pas d'impression du champ
"""),

76 : _(u"""
  -> Il y a des groupes de noeuds dans le maillage %(k1)s.
     Ils  n'apparaitront pas dans le fichier g�om�trie ENSIGHT.
     Seuls des groupes de mailles peuvent y etre int�gr�s.
"""),

77 : _(u"""
  incompatibilit� entre les GREL
"""),

79 : _(u"""
  le nombre de couches est sup�rieur � 1 
"""),

80 : _(u"""
 on traite les TRIA7 QUAD9 en oubliant le noeud centre
"""),

83: _(u"""
 Certaines composantes selectionn�es ne font pas partie du LIGREL
"""),

84 : _(u"""
 �l�ment PYRA5 non disponible dans IDEAS
"""),

85 : _(u"""
 �l�ment PYRA13 non disponible dans IDEAS
"""),

86 : _(u"""
 on traite les PENTA18 en oubliant le(s) noeud(s)
 au centre et les SEG4 en oubliant les 2 noeuds centraux.
"""),

87 : _(u"""
 on ne sait pas imprimer le champ de type:  %(k1)s 
 champ :  %(k2)s 
"""),

88 : _(u"""
  on ne sait pas imprimer au format ENSIGHT le champ  %(k1)s
  correspondant � la grandeur : %(k2)s
  il faut imprimer des champs aux noeuds � ce format.
"""),

90 : _(u"""
 on ne sait pas imprimer le champ  %(k1)s  au format  %(k2)s 
"""),

97 : _(u"""
 on ne sait pas imprimer les champs de type " %(k1)s "
"""),

98 : _(u"""
 le champ:  %(k1)s  a des �l�ments ayant des sous-points.
 il est �crit avec un format diff�rent.
"""),

99 : _(u"""
 le champ:  %(k1)s  a des �l�ments ayant des sous-points.
 ces �l�ments ne seront pas �crits.
"""),

}
