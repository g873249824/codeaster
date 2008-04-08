#@ MODIF algeline Messages  DATE 08/04/2008   AUTEUR MEUNIER S.MEUNIER 
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
 R�solution FETI : option invalide
"""),

2: _("""
 R�solution FETI : probleme objet  %(k1)s .fetg . il est de longueur impaire
"""),

3: _("""
 R�solution FETI : division par z�ro dans la construction du alpha
"""),

4: _("""
 valeur inf�rieure � la tol�rance
"""),

5: _("""
 Combinaison lin�aire de matrices :
 pour l'instant, on ne traite que le cas des matrices r�elles
"""),

7: _("""
 tbliva : impossible de r�cup�rer les valeurs dans la table
"""),

9: _("""
 l'origine de l'obstacle est mal positionn�e par rapport au noeud de choc
 de num�ro  %(k1)s , de nom  %(k2)s , par rapport au jeu.
"""),

10: _("""
 l'origine de l'obstacle est mal positionnee par rapport au noeud de choc
 de num�ro  %(k1)s , de nom  %(k2)s , dans le plan normal au choc.
"""),

11: _("""
 la normale � l'obstacle fait un angle nul avec le noeud de choc
 de num�ro  %(k1)s , avec l'axe du tube.
"""),

12: _("""
 la normale � l'obstacle fait un angle inferieur � 10 degr�s au noeud de choc
 de num�ro  %(k1)s , avec l'axe du tube.
"""),

13: _("""
 la normale � l'obstacle fait un angle inferieur � 45 degr�s au noeud de choc
 de num�ro  %(k1)s , avec l'axe du tube.
"""),

14: _("""
 les mailles doivent etre de type QUAD4 ou TRI3 et non de type  %(k1)s 
"""),

15: _("""
 l'angle au noeud  %(k1)s  form� par :
    - le vecteur normal de la maille  %(k2)s 
 et - le vecteur normal de la maille  %(k3)s
 est sup�rieur � 90 degr�s et vaut  %(k4)s  degr�s.
"""),

16: _("""
 PREF_NOEUD est trop long ou PREF_NUME est trop grand
"""),

17: _("""
 PREF_MAILLE est trop long ou PREF_NUME est trop grand
"""),

18: _("""
 mot-cl� facteur  %(k1)s  non trait�
"""),

19: _("""
 le GROUP_NO  %(k1)s  n'existe pas
"""),

20: _("""
 le nombre de noeuds n'est pas le meme pour les deux GROUP_NO
"""),

21: _("""
 les GROUP_NO ne contiennent qu'un seul noeud
"""),

22: _("""
 creation QUAD4 d�g�n�r�
"""),

23: _("""
 le noeud  %(k1)s  n'est pas �quidistant des noeuds  %(k2)s  et  %(k3)s  pour la maille : %(k4)s 
 Am�liorez le  maillage. Le code s'arrete pour �viter des r�sultats faux.
 - distance n1-n3 = %(r1)g
 - distance n2-n3 = %(r2)g
 - tol�rance      = %(r3)g
"""),

24: _("""
 valeur n�gative ou nulle pour la puissance quatri�me du nombre d'ondes.
 La valeur de l'ordre de coque est mal d�termin�e.
 Il faut affiner le maillage sur les coques :
 => r�duire le pas angulaire pour d�finir plus de noeuds sur les contours.
"""),

25: _("""
 Nombre de noeuds sur la g�n�ratrice inf�rieur � 4 :
 c'est insuffisant pour d�terminer les coefficients de la d�form�e axiale
"""),

26: _("""
 d�placement radial maximum nul sur la g�n�ratrice
"""),

27: _("""
  -> Il y a au moins un point d'une zone dont la vitesse r�duite locale est
     ext�rieure � la zone des vitesses r�duites explor�es exp�rimentalement.
  -> Risque & Conseil :
     Les valeurs sont extrapolees en dehors des donnees d'essais.
     Les resultats du calcul seront a prendre avec circonspection.
"""),

28: _("""
 D�termination des coefficients de la deform�e axiale,
 erreur relative sur la norme des d�placements radiaux : %(r1)g
"""),

29: _("""
 L'ordre de coque est peut-etre mal identifi�.
 La base modale est trop riche ou le nombre de noeuds du maillage sur une circonference
 est trop faible
"""),

30: _("""
 somme des carr�s des termes diagonaux nulle
 => crit�re ind�fini
"""),

31: _("""
 somme des carr�s des termes diagonaux n�gligeable
 => critere ind�fini
"""),

32: _("""
 CHAM_CINE diff�rent de z�ro sur des DDL non �limin�s.
"""),

33: _("""
 la carte des caract�ristiques g�ometriques des �l�ments de poutre n'existe pas
"""),

34: _("""
 caract�ristiques g�om�triques �l�mentaires de poutre non d�finies pour la maille  %(k1)s 
"""),

35: _("""
 l'une ou l'autre des composantes <R1> et <R2> n'existe pas dans le champ de la grandeur
"""),

36: _("""
 la section de l'�l�ment de poutre consid�r� n'est pas circulaire
"""),

37: _("""
 rayon ext�rieur nul � l'une ou l'autre des extr�mit�s de l'�l�ment consid�r�
"""),

38: _("""
 le rayon ext�rieur n'est pas constant sur l'�l�ment consid�r�
"""),

42: _("""
 les vitesses r�duites des fichiers .70 et .71 ne sont pas coh�rentes
"""),

43: _("""
 les vitesses etudiees doivent �tre strictement positives
 le sens de l'�coulement est d�fini par le choix de la configuration experimentale GRAPPE2 de r�f�rence
"""),

44: _("""
 seuls les cas d'enceintes circulaires et rectangulaires sont trait�s.
"""),

45: _("""
 le nombre total de tubes ne correspond pas � la somme des tubes des groupes d'�quivalence 
"""),

46: _("""
 la direction des tubes n'est pas parall�le � l'un des axes.
"""),

47: _("""
 la direction des tubes n'est la meme que celle de l'axe directeur.
"""),

48: _("""
 les vitesses �tudi�es doivent toutes �tre du meme signe
 sinon il y a ambiguit� sur les positions d entr�e/sortie
"""),

49: _("""
 nombre de noeuds insuffisant sur la coque interne
"""),

50: _("""
 coque interne de longueur nulle
"""),

51: _("""
 nombre de noeuds insuffisant sur la coque externe
"""),

52: _("""
 coque externe de longueur nulle
"""),

53: _("""
 le domaine de recouvrement des coques interne et externe n'existe pas
"""),

54: _("""
 la carte des caract�ristiques g�ometriques des �l�ments de coque n'existe pas. il faut prealablement affecter ces caracteristiques aux groupes de mailles correspondant aux coques interne et externe, par l operateur <affe_cara_elem>
"""),

56: _("""
 les caract�ristiques des �l�ments de coque n'ont pas �t� affect�es
 distinctement � l'un ou(et) l'autre des groupes de mailles associ�s
 aux coques interne et externe
"""),

57: _("""
 la composante <EP> n'existe pas dans le champ de la grandeur
"""),

58: _("""
 pas d'�paisseur affect�e aux �l�ments de la coque interne
"""),

59: _("""
 �paisseur de la coque interne nulle
"""),

60: _("""
 pas d'epaisseur affect�e aux �l�ments de la coque externe
"""),

61: _("""
 �paisseur de la coque externe nulle
"""),

62: _("""
 incoherence dans la definition de la configuration : le rayon d une des coques est nul
"""),

63: _("""
 incoh�rence dans la d�finition de la configuration :
 jeu annulaire n�gatif ou nul
"""),

64: _("""
 element  %(k1)s  non traite
"""),

65: _("""
 on ne peut depasser  %(k1)s  mailles
"""),

66: _("""
 coefficient de type non pr�vu
"""),

67: _("""
 caract. de matrice non prevue
"""),

68: _("""
 la zone d excitation du fluide, de nom  %(k1)s , est reduite a un point.
"""),

69: _("""
 la zone d'excitation du fluide, de nom  %(k1)s , recoupe une autre zone.
"""),

70: _("""
 le noeud d'application de l'excitation doit appartenir � deux mailles
 ni plus ni moins
"""),

71: _("""
 le noeud d'application de l excitation est situe � la jonction
 de deux �l�ments de diam�tres ext�rieurs diff�rents
 => ambiguit� pour le dimensionnement de l'excitation
"""),

72: _("""
 autres configurations non traitees
"""),

73: _("""
 le cylindre  %(k1)s  n a pas un axe rectiligne
"""),

75: _("""
 la composante n'est pas dans le CHAM_ELEM
"""),

76: _("""
 r�solution impossible matrice singuli�re
 peut �tre � cause des erreurs d'arrondis
"""),

77: _("""
 erreur dans l'inversion de la masse
"""),

78: _("""
 erreur dans la recherche des valeurs propres
 pas de convergence de l algorithme QR 
"""),

79: _("""
 le nombre de modes r�sultats:  %(k1)s  n'est pas correct 
"""),

80: _("""
 les cylindres  %(k1)s  et  %(k2)s  se touchent
"""),

81: _("""
 le cylindre  %(k1)s d�borde de l'enceinte circulaire
"""),

82: _("""
 pas de groupes de noeuds � cr�er 
"""),

83: _("""
 la grille numero  %(k1)s  deborde du domaine de definition du faisceau
"""),

84: _("""
 les grilles numero  %(k1)s  et numero  %(k2)s  se recouvrent
"""),

85: _("""
 cas d enceintes circulaire etet rectangulaire seulement 
"""),

86: _("""
 pas de groupe de mailles sous la racine commune  %(k1)s 
"""),

87: _("""
 pas de groupes de mailles sous la racine commune 
"""),

88: _("""
 une cote de l'enceinte est de longueur nulle
"""),

89: _("""
 les quatres sommets de l'enceinte ne forment pas un rectangle
"""),

90: _("""
 le cylindre  %(k1)s  d�borde de l'enceinte rectangulaire
"""),

91: _("""
  la renum�rotation  %(k1)s est incompatible avec le solveur multi_frontal.
"""),

92: _("""
 absence de relation de comportement de type <ELAS> pour le mat�iau constitutif de la coque interne
"""),

93: _("""
 absence d'un ou de plusieurs param�tres de la relation de comportement <ELAS>
 pour le mat�riau constitutif de la coque interne
"""),

94: _("""
 La valeur du module d'Young est nulle pour le mat�riau constitutif de la coque interne
"""),

95: _("""
 absence de relation de comportement de type <ELAS>
 pour le materiau constitutif de la coque externe
"""),

96: _("""
 absence d'un ou de plusieurs parametres de la relation de comportement <ELAS>
 pour le mat�riau constitutif de la coque externe
"""),

97: _("""
 La valeur du module d'Young est nulle pour le mat�riau constitutif de la coque externe
"""),

98: _("""
 Les deux coques (interne et externe) sont en mouvement pour le  %(k1)s i�me mode.
"""),

99: _("""
 non convergence pour le calcul des modes en eau au repos
"""),
}
