#@ MODIF prepost3 Messages  DATE 18/09/2007   AUTEUR DURAND C.DURAND 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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

cata_msg={

1: _("""
 med: erreur efgaul numero  %(k1)s 
"""),

2: _("""
 med: erreur efgaue numero  %(k1)s 
"""),

3: _("""
 ecriture des localisations des points de gauss
"""),

4: _("""
  le nombre de noeuds selectionnes est superieur au nombre de noeuds du maillage. on va tronquer la liste.
"""),

5: _("""
 chaine de caracteres trop longues : imprimer moins de champs
"""),

6: _("""
 type inconnu" %(k1)s "
"""),

7: _("""
 le maillage  %(k1)s  a deja ete ecrit au format ensight: le contenu du fichier  %(k2)s  sera ecrase.
"""),

8: _("""
 probleme a l'ouverture du fichier " %(k1)s " pour impression du maillage  %(k2)s  au format ensight
"""),

9: _("""
 type de base inconnu:  %(k1)s 
"""),

10: _("""
 soit le fichier n'existe pas, soit c'est une mauvaise version de hdf (utilise par med).
"""),

11: _("""
 pas de maillage dans  %(k1)s 
"""),

12: _("""
 maillage  %(k1)s  inconnu dans  %(k2)s 
"""),

13: _("""
 instant inconnu pour ce champ et ces supports dans le fichier.
"""),

14: _("""
 champ inconnu.
"""),

15: _("""
 il manque des composantes.
"""),

16: _("""
 aucune valeur � cet instant.
"""),

17: _("""
 aucune valeur � ce num�ro d ordre.
"""),

18: _("""
 mauvais nombre de valeurs.
"""),

19: _("""
 lecture impossible.
"""),

20: _("""
 absence de numerotation des mailles  %(k1)s  dans le fichier med
"""),

21: _("""
 grandeur inconnue
"""),

22: _("""
 composante inconnue pour la grandeur
"""),

23: _("""
 trop de composantes pour la grandeur
"""),

24: _("""
 lecture impossible pour  %(k1)s  au format MED
"""),

25: _("""
 MODELE obligatoire pour lire un CHAM_ELEM
"""),

26: _("""
 med: erreur efchrl numero  %(k1)s 
"""),

27: _("""
 nom de composante tronquee a 8 caracteres ( %(k1)s  >>>  %(k2)s )
"""),

28: _("""
 impossible de trouver la composante ASTER associ�e a  %(k1)s 
"""),

29: _("""
 pour LIRE_RESU / FORMAT=IDEAS
 le maillage doit normalement avoir �t� lu au format IDEAS.
"""),

30: _("""
 on a trouve plusieurs champs pour le m�me DATASET
"""),

31: _("""
 on n'a pas trouv� le num�ro d'ordre � l'adresse indiqu�e
"""),

32: _("""
 on n'a pas trouv� l'instant � l'adresse indiqu�e
"""),

33: _("""
 on n'a pas trouv� la fr�quence � l'adresse indiqu�e
"""),

34: _("""
 on n'a pas trouv� dans le fichier UNV le type de champ
"""),

35: _("""
 on n'a pas trouv� dans le fichier UNV le nombre de composantes � lire
"""),

36: _("""
 on n'a pas trouv� dans le fichier UNV la nature du champ
 (r�el ou complexe)
"""),

37: _("""
 le type de champ demand� est diff�rent du type de champ � lire
"""),

38: _("""
 le champ demande n'est pas de m�me nature que le champ � lire
 (r�el/complexe)
"""),

39: _("""
 le mot cle MODELE est obligatoire pour un CHAM_ELEM
"""),

40: _("""
 pb correspondance noeud IDEAS
"""),

41: _("""
 le champ de type ELGA n'est pas support�
"""),

42: _("""
 probleme dans la lecture du nombre de champs
"""),

43: _("""
 probleme dans la lecture du nombre de composantes
"""),

44: _("""
 probleme dans la lecture du nom du champ et des ses composantes
"""),

45: _("""
 le champ  %(k1)s n existe pas dans le fichier med
"""),

46: _("""
 med: erreur efnpdt numero  %(k1)s 
"""),

47: _("""
 med: erreur efpdti numero  %(k1)s 
"""),

48: _("""
 med: on ne traite pas les maillages distants
"""),

49: _("""
 probleme a la fermeture
"""),

50: _("""
 probleme dans le diagnostic.
"""),

51: _("""
 med: erreur efnval numero  %(k1)s 
"""),

52: _("""
 probleme dans la lecture du nombre de maillages
"""),

53: _("""
 probleme dans la lecture du nom du maillage.
"""),

54: _("""
 attention le maillage n'est pas de type non structur�
"""),

55: _("""
 le maillage ' %(k1)s ' est inconnu dans le fichier.
"""),

56: _("""
 attention il s'agit d'un maillage structur�
"""),

57: _("""
 ==> transfert impossible.
"""),

58: _("""
 mauvaise definition de NORESU.
"""),

59: _("""
 mauvaise definition de NOMSYM.
"""),

60: _("""
 mauvaise definition de NOPASE.
"""),

61: _("""
 mauvais dimensionnement de NOMAST.
"""),

62: _("""
 impossible de d�terminer un nom de maillage MED
"""),

63: _("""
 on attend 10 ou 12 secteurs
"""),

64: _("""
 ******* percement tube *******
"""),

65: _("""
 pour la variable d'acces "noeud_cmp", il faut un nombre pair de valeurs.
"""),

66: _("""
 le mod�le et le maillage introduits ne sont pas coh�rents
"""),

67: _("""
 il faut donner le maillage pour une impression au format "CASTEM".
"""),

68: _("""
 vous voulez imprimer sur un m�me fichier le maillage et un champ
 ce qui est incompatible avec le format GMSH
"""),

69: _("""
 L'impression d'un champ complexe n�cessite l'utilisation du mot-cl� PARTIE.
 Ce mot-cl� permet de choisir la partie du champ � imprimer (r�elle ou imaginaire).
"""),

70: _("""
 le mot cle "info_maillage" est reserve au format med
"""),

71: _("""
 le mot cle "info_resu" est reserve au format resultat
"""),

72: _("""
 l'impression avec selection sur des entites topologiques n'a pas de sens au format ensight : les valeurs de tous les noeuds du maillage seront donc imprimees.
"""),

73: _("""
 l'impression avec selection sur des entites topologiques n'a pas de sens au format castem  : toutes les valeurs sur tout le maillage seront donc imprimees.
"""),

75: _("""
 fichier GIBI cr�� par SORT FORMAT non support� dans cette version
"""),

76: _("""
 version de GIBI non support�e, la lecture peut �chouer
"""),

77: _("""
 fichier GIBI erron�
"""),

78: _("""
 le fichier maillage GIBI est vide
"""),

79: _("""
 cette commande ne fait que compl�ter un r�sultat compos� d�j� existant.
 il faut donc que le r�sultat de la commande :  %(k1)s
 soit identique � l'argument "RESULTAT" :  %(k2)s 
"""),

80: _("""
 pour un r�sultat de type " %(k1)s ", on ne traite que l'option ..._NOEU_...
"""),

81: _("""
 lmat =0
"""),

84: _("""
 il faut autant de composantes en i et j
"""),

85: _("""
 il faut autant de composantes que de noeuds
"""),

92: _("""
 mot cl� "TEST_NOOK" non valid� avec le mot cl� facteur "INTE_SPEC".
"""),

93: _("""
 la fonction n'existe pas.
"""),

94: _("""
 il faut d�finir deux param�tres pour une nappe.
"""),

95: _("""
 pour le param�tre donn� on n'a pas trouv� la fonction.
"""),

}
