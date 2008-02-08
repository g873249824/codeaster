#@ MODIF algorith10 Messages  DATE 08/02/2008   AUTEUR MACOCCO K.MACOCCO 
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
 la variable  %(k1)s  n'existe pas dans la loi  %(k2)s 
"""),

2 : _("""
 tailles de matrices incompatibles
"""),

10 : _("""
 taille produit matrice-vecteur incompatible
"""),

11 : _("""
 le champ de d�placement n'a pas �t� calcul�
"""),

12 : _("""
 le champ de vitesse n'a pas �t� calcul�
"""),

13 : _("""
 le champ d'acc�l�ration n'a pas ete calcule.
"""),

14 : _("""
 d�veloppement non pr�vu pour le MULT_APPUI ou CORR_STAT.
"""),

15 : _("""
 d�veloppement non pr�vu pour la sous-structuration.
"""),

16 : _("""
 le champ  %(k1)s  n'a pas �t� calcul� dans le MODE_MECA  %(k2)s 
"""),

17 : _("""
 l'option  %(k1)s  s'applique sur toute la structure
"""),

20 : _("""
  le comportement :  %(k1)s  n'a pas etet defini
"""),

21 : _("""
 DIST_REFE est obligatoire � la premi�re occurence de RECO_GLOBAL
"""),

31 : _("""
 la bande de fr�quence retenue ne comporte pas de modes propres
"""),

32 : _("""
 vous avez demand� des modes qui ne sont pas calcul�s
"""),

33 : _("""
 il n y a pas de mode statique calcul� pour le couple noeud-cmp ci dessus
"""),

34 : _("""
 red�coupage demand� apr�s non convergence locale
 red�coupage global
"""),

35 : _("""
 red�coupage excessif du pas de temps interne
 r�duisez votre pas de temps ou augmenter abs(ITER_INTE_PAS)
 redecoupage global.
"""),

36 : _("""
 il manque SIGM_REFE
"""),

37 : _("""
 il manque RESI_HYD1_REFE
"""),

38 : _("""
 il manque RESI_HYD2_REFE
"""),

39 : _("""
 il manque RESI_THER_REFE
"""),

40 : _("""
 vecteur nul entrainant une division par z�ro dans NMCONV
"""),

41 : _("""
 incoh�rence de A ou H
"""),

42 : _("""
 incoh�rence de donn�es
"""),

43 : _("""
 incoh�rence de C, PHI ou A
"""),

44 : _("""
 champ 'DEPL' non calcul�
"""),

45 : _("""
 champ 'VITE' non calcul�
"""),

46 : _("""
 champ 'ACCE' non calcul�
"""),

47 : _("""
 lecture des instants erron�e
"""),

48 : _("""
 axe de rotation ind�fini.
"""),

49 : _("""
 la porosit� initiale F0 ne peut etre nulle ou n�gative
"""),

50 : _("""
 la porosit� initiale F0 ne peut etre sup�rieure ou �gale � 1.
"""),

51 : _("""
 comportement de Rousselier version PETIT_REAC non implant� en contraintes planes
"""),

52 : _("""
 la porosit� initiale F0 ne peut etre n�gative
"""),

53 : _("""
 pb2, variables de pilotages
"""),

54 : _("""
 erreur d'int�gration dans Runge-Kutta
 trop d'it�ration.
"""),

55 : _("""
 erreur d integration dans Runge-Kutta
"""),

56 : _("""
 on ne sait pas post-traiter le champ de type:  %(k1)s 
"""),

60 : _("""
 taille vecteurs incompatible
"""),

61 : _("""
 il faut definir une BANDE ou un NUME_ORDRE
"""),

62 : _("""
 il faut definir une "BANDE" ou une liste de "NUME_ORDRE"
"""),

63 : _("""
 dimension spectrale fausse
"""),

64 : _("""
 l'interspectre modal est de type "ACCE"
 on ne peut que restituer une acc�l�ration
"""),

65 : _("""
 l'interspectre modal est de type "VITE"
 on ne peut que restituer une vitesse
"""),

66 : _("""
 l'interspectre modal est de type "DEPL"
 on ne peut pas restituer une acc�l�ration
"""),

67 : _("""
 l'interspectre modal est de type "DEPL"
 on ne peut pas restituer une vitesse
"""),

68 : _("""
 il faut autant de "NOEUD" que de "NOM_CMP"
"""),

69 : _("""
 il faut autant de "MAILLE" que de "NOEUD"
"""),

72 : _("""
 il faut d�finir une liste de mailles pour post-traiter un CHAM_ELEM
"""),

73 : _("""
 la composante  %(k1)s  du noeud  %(k2)s  pour la maille  %(k3)s  n'existe pas.
"""),

74 : _("""
 on ne traite pas la maille "POI1"
"""),

75 : _("""
 type de maille non trait�e
"""),

76 : _("""
 mot-cl� nb_bloc inop�rant on prend 1 bloc
"""),

77 : _("""
 �l�ment d�g�n�r�
"""),

79 : _("""
 DDL inconnu sur le noeud ou la maille specifi�e pour le suivi
"""),

82 : _("""
 pas de suivi attach� � la demande d'affichage
"""),

83 : _("""
 trop de lignes dans le titre
"""),

84 : _("""
 erreur dvt dans le type d'extrema
"""),

85 : _("""
 le nombre de suivi DDL est limit� � 4
"""),

86 : _("""
 melange de champs de nature diff�rente dans le meme mot-cl� facteur SUIVI
"""),

87 : _("""
 vecteur de norme trop petite
"""),

88 : _("""
 COMP_ELAS non implant�
"""),

89 : _("""
 Z est n�gatif (phase m�tallurgique)
"""),

90 : _("""
 la d�finition de la temp�rature est obligatoire
 pour une loi de couplage de type  %(k1)s 
"""),

91 : _("""
 probl�me dans la d�finition de la saturation
"""),

92 : _("""
 �chec dans �limination temps
"""),

93 : _("""
 il faut un nom de champ
"""),

94 : _("""
 pas de champ autre que DEPL ou VITE ou ACCE
"""),

95 : _("""
 pour interpoler il faut fournir une liste de fr�quences ou instants.
"""),

96 : _("""
 calcul du transitoire: pas de solution trouv�e
 utiliser l'option ETAT_STAT = NON
"""),

97 : _("""
 dur�e de l'excitation trop courte pour le calcul du transitoire.
"""),

98 : _("""
 pivot nul
"""),

99 : _("""
 on ne sait pas encore traiter la sous structuration en axisym�trique
"""),

}
