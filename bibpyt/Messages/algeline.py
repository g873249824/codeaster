#@ MODIF algeline Messages  DATE 12/10/2011   AUTEUR COURTOIS M.COURTOIS 
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

cata_msg={

1: _(u"""
 R�solution FETI : option invalide
"""),

2: _(u"""
 R�solution FETI : probleme objet  %(k1)s .fetg . il est de longueur impaire
"""),

3: _(u"""
 R�solution FETI : division par z�ro dans la construction du alpha
"""),

4: _(u"""
 valeur inf�rieure � la tol�rance
"""),

5: _(u"""
 Combinaison lin�aire de matrices :
 pour l'instant, on ne traite que le cas des matrices r�elles
"""),

7: _(u"""
 tbliva : impossible de r�cup�rer les valeurs dans la table
"""),

9: _(u"""
 l'origine de l'obstacle est mal positionn�e par rapport au noeud de choc
 de num�ro  %(k1)s , de nom  %(k2)s , par rapport au jeu.
"""),

10: _(u"""
 l'origine de l'obstacle est mal positionnee par rapport au noeud de choc
 de num�ro  %(k1)s , de nom  %(k2)s , dans le plan normal au choc.
"""),

11: _(u"""
 la normale � l'obstacle fait un angle nul avec le noeud de choc
 de num�ro  %(k1)s , avec l'axe du tube.
"""),

12: _(u"""
 la normale � l'obstacle fait un angle inferieur � 10 degr�s au noeud de choc
 de num�ro  %(k1)s , avec l'axe du tube.
"""),

13: _(u"""
 la normale � l'obstacle fait un angle inferieur � 45 degr�s au noeud de choc
 de num�ro  %(k1)s , avec l'axe du tube.
"""),

14: _(u"""
 les mailles doivent etre de type QUAD4 ou TRI3 et non de type  %(k1)s 
"""),

15: _(u"""
 l'angle au noeud  %(k1)s  form� par :
    - le vecteur normal de la maille  %(k2)s 
 et - le vecteur normal de la maille  %(k3)s
 est sup�rieur � 90 degr�s et vaut  %(k4)s  degr�s.
"""),

16: _(u"""
 PREF_NOEUD est trop long ou PREF_NUME est trop grand
"""),

17: _(u"""
 PREF_MAILLE est trop long ou PREF_NUME est trop grand
"""),

18: _(u"""
 mot-cl� facteur  %(k1)s  non trait�
"""),

19: _(u"""
 le GROUP_NO  %(k1)s  n'existe pas
"""),

20: _(u"""
 le nombre de noeuds n'est pas le meme pour les deux GROUP_NO
"""),

21: _(u"""
 les GROUP_NO ne contiennent qu'un seul noeud
"""),

22: _(u"""
 creation QUAD4 d�g�n�r�
"""),

23: _(u"""
 le noeud  %(k1)s  n'est pas �quidistant des noeuds  %(k2)s  et  %(k3)s  pour la maille : %(k4)s 
 Am�liorez le  maillage. Le code s'arrete pour �viter des r�sultats faux.
 - distance n1-n3 = %(r1)g
 - distance n2-n3 = %(r2)g
 - tol�rance      = %(r3)g
"""),

24: _(u"""
 valeur n�gative ou nulle pour la puissance quatri�me du nombre d'ondes.
 La valeur de l'ordre de coque est mal d�termin�e.
 Il faut affiner le maillage sur les coques :
 => r�duire le pas angulaire pour d�finir plus de noeuds sur les contours.
"""),

25: _(u"""
 Nombre de noeuds sur la g�n�ratrice inf�rieur � 4 :
 c'est insuffisant pour d�terminer les coefficients de la d�form�e axiale
"""),

26: _(u"""
 d�placement radial maximum nul sur la g�n�ratrice
"""),

27: _(u"""
  -> Il y a au moins un point d'une zone dont la vitesse r�duite locale est
     ext�rieure � la zone des vitesses r�duites explor�es exp�rimentalement.
  -> Risque & Conseil :
     Les valeurs sont extrapolees en dehors des donnees d'essais.
     Les resultats du calcul seront a prendre avec circonspection.
"""),

28: _(u"""
 D�termination des coefficients de la deform�e axiale,
 erreur relative sur la norme des d�placements radiaux : %(r1)g
"""),

29: _(u"""
 L'ordre de coque est peut-etre mal identifi�.
 La base modale est trop riche ou le nombre de noeuds du maillage sur une circonference
 est trop faible
"""),

30: _(u"""
 somme des carr�s des termes diagonaux nulle
 => crit�re ind�fini
"""),

31: _(u"""
 somme des carr�s des termes diagonaux n�gligeable
 => critere ind�fini
"""),

32: _(u"""
 CHAM_CINE diff�rent de z�ro sur des DDL non �limin�s.
"""),

33: _(u"""
 la carte des caract�ristiques g�ometriques des �l�ments de poutre n'existe pas
"""),

34: _(u"""
 caract�ristiques g�om�triques �l�mentaires de poutre non d�finies pour la maille  %(k1)s 
"""),

35: _(u"""
 l'une ou l'autre des composantes <R1> et <R2> n'existe pas dans le champ de la grandeur
"""),

36: _(u"""
 la section de l'�l�ment de poutre consid�r� n'est pas circulaire
"""),

37: _(u"""
 rayon ext�rieur nul � l'une ou l'autre des extr�mit�s de l'�l�ment consid�r�
"""),

38: _(u"""
 le rayon ext�rieur n'est pas constant sur l'�l�ment consid�r�
"""),

42: _(u"""
 les vitesses r�duites des fichiers .70 et .71 ne sont pas coh�rentes
"""),

43: _(u"""
 les vitesses etudiees doivent �tre strictement positives
 le sens de l'�coulement est d�fini par le choix de la configuration experimentale GRAPPE2 de r�f�rence
"""),

44: _(u"""
 seuls les cas d'enceintes circulaires et rectangulaires sont trait�s.
"""),

45: _(u"""
 le nombre total de tubes ne correspond pas � la somme des tubes des groupes d'�quivalence 
"""),

46: _(u"""
 la direction des tubes n'est pas parall�le � l'un des axes.
"""),

47: _(u"""
 la direction des tubes n'est la meme que celle de l'axe directeur.
"""),

48: _(u"""
 les vitesses �tudi�es doivent toutes �tre du meme signe
 sinon il y a ambiguit� sur les positions d entr�e/sortie
"""),

49: _(u"""
 nombre de noeuds insuffisant sur la coque interne
"""),

50: _(u"""
 coque interne de longueur nulle
"""),

51: _(u"""
 nombre de noeuds insuffisant sur la coque externe
"""),

52: _(u"""
 coque externe de longueur nulle
"""),

53: _(u"""
 le domaine de recouvrement des coques interne et externe n'existe pas
"""),

54: _(u"""
 la carte des caract�ristiques g�ometriques des �l�ments de coque n'existe pas. il faut prealablement affecter ces caracteristiques aux groupes de mailles correspondant aux coques interne et externe, par l operateur <affe_cara_elem>
"""),

56: _(u"""
 les caract�ristiques des �l�ments de coque n'ont pas �t� affect�es
 distinctement � l'un ou(et) l'autre des groupes de mailles associ�s
 aux coques interne et externe
"""),

57: _(u"""
 la composante <EP> n'existe pas dans le champ de la grandeur
"""),

58: _(u"""
 pas d'�paisseur affect�e aux �l�ments de la coque interne
"""),

59: _(u"""
 �paisseur de la coque interne nulle
"""),

60: _(u"""
 pas d'epaisseur affect�e aux �l�ments de la coque externe
"""),

61: _(u"""
 �paisseur de la coque externe nulle
"""),

62: _(u"""
 incoherence dans la definition de la configuration : le rayon d une des coques est nul
"""),

63: _(u"""
 incoh�rence dans la d�finition de la configuration :
 jeu annulaire n�gatif ou nul
"""),

64: _(u"""
 element  %(k1)s  non traite
"""),

65: _(u"""
 on ne peut depasser  %(k1)s  mailles
"""),

66: _(u"""
 coefficient de type non pr�vu
"""),


68: _(u"""
 la zone d excitation du fluide, de nom  %(k1)s , est reduite a un point.
"""),

69: _(u"""
 la zone d'excitation du fluide, de nom  %(k1)s , recoupe une autre zone.
"""),

70: _(u"""
 le noeud d'application de l'excitation doit appartenir � deux mailles
 ni plus ni moins
"""),

71: _(u"""
 le noeud d'application de l excitation est situe � la jonction
 de deux �l�ments de diam�tres ext�rieurs diff�rents
 => ambiguit� pour le dimensionnement de l'excitation
"""),

72: _(u"""
 autres configurations non traitees
"""),

73: _(u"""
 le cylindre  %(k1)s  n a pas un axe rectiligne
"""),

75: _(u"""
 la composante n'est pas dans le CHAM_ELEM
"""),

76: _(u"""
 r�solution impossible matrice singuli�re
 peut �tre � cause des erreurs d'arrondis
"""),

77: _(u"""
 erreur dans l'inversion de la masse
"""),

78: _(u"""
 erreur dans la recherche des valeurs propres
 pas de convergence de l algorithme QR 
"""),

79: _(u"""
 le nombre de modes r�sultats:  %(k1)s  n'est pas correct 
"""),

80: _(u"""
 les cylindres  %(k1)s  et  %(k2)s  se touchent
"""),

81: _(u"""
 le cylindre  %(k1)s d�borde de l'enceinte circulaire
"""),

82: _(u"""
 pas de groupes de noeuds � cr�er 
"""),

83: _(u"""
 la grille numero  %(k1)s  deborde du domaine de definition du faisceau
"""),

84: _(u"""
 les grilles numero  %(k1)s  et numero  %(k2)s  se recouvrent
"""),

85: _(u"""
 cas d enceintes circulaire etet rectangulaire seulement 
"""),

86: _(u"""
 pas de groupe de mailles sous la racine commune  %(k1)s 
"""),

87: _(u"""
 pas de groupes de mailles sous la racine commune 
"""),

88: _(u"""
 une cote de l'enceinte est de longueur nulle
"""),

89: _(u"""
 les quatres sommets de l'enceinte ne forment pas un rectangle
"""),

90: _(u"""
 le cylindre  %(k1)s  d�borde de l'enceinte rectangulaire
"""),

91: _(u"""
  la renum�rotation  %(k1)s est incompatible avec le solveur multi_frontal.
"""),

92: _(u"""
 absence de relation de comportement de type <ELAS> pour le mat�iau constitutif de la coque interne
"""),

93: _(u"""
 absence d'un ou de plusieurs param�tres de la relation de comportement <ELAS>
 pour le mat�riau constitutif de la coque interne
"""),

94: _(u"""
 La valeur du module d'Young est nulle pour le mat�riau constitutif de la coque interne
"""),

95: _(u"""
 absence de relation de comportement de type <ELAS>
 pour le materiau constitutif de la coque externe
"""),

96: _(u"""
 absence d'un ou de plusieurs parametres de la relation de comportement <ELAS>
 pour le mat�riau constitutif de la coque externe
"""),

97: _(u"""
 La valeur du module d'Young est nulle pour le mat�riau constitutif de la coque externe
"""),

98: _(u"""
 Les deux coques (interne et externe) sont en mouvement pour le  %(k1)s i�me mode.
"""),

99: _(u"""
 non convergence pour le calcul des modes en eau au repos
"""),
}
