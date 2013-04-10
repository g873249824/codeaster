#@ MODIF modelisa Messages  DATE 08/04/2013   AUTEUR FLEJOU J-L.FLEJOU 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
 l'option de calcul d'une abscisse curviligne sur un groupe de mailles
 n'est pas implant�e
"""),

2 : _(u"""
 il est possible de d�finir une abscisse curviligne uniquement
 pour des mailles de type: POI1 ou SEG2
"""),

3 : _(u"""
 point non trouv� parmi les SEG2
"""),

4 : _(u"""
 mauvaise d�finition pour l'abscisse curviligne
 d�tection de plusieurs chemins.
"""),

6 : _(u"""
 m�thode AU-YANG : la g�om�trie doit �tre cylindrique
"""),

7 : _(u"""
 BARRE : une erreur a �t� d�tect�e lors de l'affectation des valeurs dans le tampon
"""),

8 : _(u"""
 Vous affectez des caract�ristiques de type %(k1)s � la maille %(k2)s qui est pas de ce type.

 Conseil :
   V�rifier le r�sultat de la commande AFFE_MODELE pour la maille %(k2)s.
"""),

10 : _(u"""
 la norme de l'axe AXE d�finie sous le mot cl� facteur GRILLE ou MEMBRANE est nul.
"""),

11 : _(u"""
 L'axe AXE est colin�aire � la normale de l'�l�ment. On ne peut pas d�finir
 l'orientation des armatures.
"""),

12 : _(u"""
 orientation : une erreur a �t� d�tect�e lors de l'affectation des orientations
"""),

13 : _(u"""
 erreur(s) dans les donn�es.
"""),

14 : _(u"""
 POUTRE : une erreur a �t� d�tect�e lors de l'affectation des valeurs dans le tampon
"""),

15 : _(u"""
 poutre : une  erreur a �t� d�tect�e lors des v�rifications des valeurs entr�es
"""),

16 : _(u"""
 vous fournissez deux caract�ristiques �l�mentaires. Il est obligatoire de fournir une caract�ristique
 relative � l'amortissement et une caract�ristique relative � la rigidit�
"""),

17 : _(u"""
 caract�ristique  %(k1)s  non admise actuellement
"""),

18 : _(u"""
 le noeud  %(k1)s  non mod�lis� par un discret
"""),

19 : _(u"""
 pas de noeuds du Radier mod�lis�s par des discrets
"""),

20 : _(u"""
 le discret  %(k1)s  n'a pas le bon nombre de noeuds.
"""),

21 : _(u"""
 le noeud  %(k1)s  extr�mit� d'un des discrets n'existe pas dans la surface donn�e par GROUP_MA.
"""),

22 : _(u"""
 La temp�rature de r�f�rence doit �tre comprise entre %(r1)f et %(r2)f.
"""),

23 : _(u"""
 AFFE_CARA_ELEM :
 La caract�ristique %(k1)s, coefficient de cisaillement, pour les poutres doit toujours
�tre >=1.0
   Valeur donn�e : %(r1)f
"""),

24 : _(u"""
  GENE_TUYAU : pr�ciser un seul noeud par tuyau
"""),

25 : _(u"""
 ORIENTATION : GENE_TUYAU
 le noeud doit �tre une des extr�mit�s
"""),

26 : _(u"""
  Il y a un probl�me lors de l'affectation du mot cl� MODI_METRIQUE sur la maille %(k1)s
"""),

27 : _(u"""
 on ne peut pas m�langer des tuyaux � 3 et 4 noeuds pour le moment
"""),

28 : _(u"""
 ORIENTATION : GENE_TUYAU
 un seul noeud doit �tre affect�
"""),

29 : _(u"""
 vous ne pouvez affecter des valeurs de type "POUTRE" au mod�le  %(k1)s
 qui ne contient pas un seul �l�ment poutre
"""),

30 : _(u"""
 vous ne pouvez affecter des valeurs de type "COQUE" au mod�le  %(k1)s
 qui ne contient pas un seul �l�ment coque
"""),

31 : _(u"""
 vous ne pouvez affecter des valeurs de type "DISCRET" au mod�le  %(k1)s
 qui ne contient pas un seul �l�ment discret
"""),

32 : _(u"""
 vous ne pouvez affecter des valeurs de type "ORIENTATION" au mod�le  %(k1)s
 qui ne contient ni �l�ment poutre ni �l�ment DISCRET ni �l�ment BARRE
"""),

33 : _(u"""
 vous ne pouvez affecter des valeurs de type "CABLE" au mod�le  %(k1)s
 qui ne contient pas un seul �l�ment CABLE
"""),

34 : _(u"""
 vous ne pouvez affecter des valeurs de type "BARRE" au mod�le  %(k1)s
 qui ne contient pas un seul �l�ment BARRE
"""),

35 : _(u"""
 vous ne pouvez affecter des valeurs de type "MASSIF" au mod�le  %(k1)s
 qui ne contient pas un seul �l�ment thermique ou m�canique
"""),

36 : _(u"""
 vous ne pouvez affecter des valeurs de type "GRILLE" au mod�le  %(k1)s
 qui ne contient pas un seul �l�ment GRILLE
"""),

37 : _(u"""
 impossible d'affecter des caract�ristiques � des noeuds de ce mod�le
 car aucun noeud ne supporte un �l�ment
"""),

38 : _(u"""
 la maille  %(k1)s  n'a pas �t� affect�e par des caract�ristiques de poutre.
"""),

39 : _(u"""
 la maille  %(k1)s  n'a pas �t� affect�e par une matrice (DISCRET).
"""),

40 : _(u"""
 la maille  %(k1)s  n'a pas �t� affect�e par des caract�ristiques de c�ble.
"""),

41 : _(u"""
 la maille  %(k1)s  n'a pas �t� affect�e par des caract�ristiques de barre.
"""),

42 : _(u"""
 la maille  %(k1)s  n'a pas �t� affect�e par des caract�ristiques de grille.
"""),

43 : _(u"""
 le noeud  %(k1)s  n'a pas �t� affect� par une matrice.
"""),

44 : _(u"""
 BARRE :
 occurrence :  %(k1)s
 "CARA"    :  %(k2)s
 arguments maximums pour une section " %(k3)s "
"""),

45 : _(u"""
 BARRE :
 occurrence  %(k1)s
 "CARA"   :  4
 arguments maximums pour une section " %(k2)s "
"""),

46 : _(u"""
 BARRE :
 occurrence  %(k1)s
 section " %(k2)s
 argument "h" incompatible avec "HY" ou "HZ"
"""),

47 : _(u"""
 barre :
 occurrence  %(k1)s
 section " %(k2)s
 argument "HY" ou "HZ" incompatible avec "h"
"""),

48 : _(u"""
 barre :
 occurrence  %(k1)s
 section " %(k2)s  argument "EP" incompatible avec "EPY" ou "EPZ"
"""),

49 : _(u"""
 barre :
 occurrence  %(k1)s
 section " %(k2)s
 argument "EPY" ou "EPZ" incompatible avec "EP"
"""),

50 : _(u"""
 barre :
 occurrence  %(k1)s
 "CARA" : nombre de valeurs entr�es incorrect
 il en faut  %(k2)s
"""),

51 : _(u"""
 barre :
 occurrence  %(k1)s
 section " %(k2)s
 valeur  %(k3)s  de "VALE" non admise (valeur test interne)
"""),

52 : _(u"""
 CABLE :
 occurrence 1
 le mot cl� "section" est obligatoire.
"""),

53 : _(u"""
 coque : occurrence 1
 le mot cl� "EPAIS" ou "EPAIS_FO" est obligatoire.
"""),

54 : _(u"""
 coque : avec un excentrement, la prise en compte des termes d'inertie de rotation est obligatoire.
"""),

55 : _(u"""
 vous ne pouvez affecter des valeurs de type "MEMBRANE" au mod�le  %(k1)s
 qui ne contient pas un seul �l�ment MEMBRANE
"""),

56 : _(u"""
 impossibilit�, la maille  %(k1)s  doit �tre une maille de type  %(k2)s , et elle est de type :  %(k3)s  pour la caract�ristique  %(k4)s
"""),

57 : _(u"""
 orientation :
 occurrence 1
 le mot cl� "VALE" est obligatoire
"""),

58 : _(u"""
 orientation :
 occurrence 1
 le mot cl� "CARA" est obligatoire
"""),

59 : _(u"""
 orientation :
 occurrence  %(k1)s
 pr�sence de "VALE" obligatoire si "CARA" est pr�sent
"""),

60 : _(u"""
 orientation :
 occurrence  %(k1)s
 val :  %(k2)s
 nombre de valeurs entr�es incorrect
"""),

61 : _(u"""
 DEFI_ARC:
 le rayon de courbure doit �tre positif.
"""),

62 : _(u"""
 DEFI_ARC:
 il faut 3 r�els pour d�finir le centre de courbure.
"""),

63 : _(u"""
 DEFI_ARC:
 il faut 3 r�els pour d�finir le point de concours des tangentes.
"""),

64 : _(u"""
 DEFI_ARC:
 le coefficient de flexibilit� doit �tre positif.
"""),

65 : _(u"""
 DEFI_ARC: l'indice de contrainte doit �tre positif.
"""),

66 : _(u"""
 poutre :
 occurrence  %(k1)s
 section "cercle", VARI_SECT "constant" la caract�ristique "r" est obligatoire
"""),





69 : _(u"""
 occurrence  %(k1)s de "barre" (maille  %(k2)s ) �crasement d un type de g�om�trie de section par un autre
"""),

70 : _(u"""
 barre :
 maille  %(k1)s
 section GENERALE
 il manque la caract�ristique  %(k2)s
"""),

71 : _(u"""
 barre :
 maille  %(k1)s
 section GENERALE
 la valeur de  %(k2)s  doit �tre  strictement positive.
"""),

72 : _(u"""
 barre :
 maille  %(k1)s
 section rectangle
 il manque  la caract�ristique  %(k2)s
"""),

73 : _(u"""
 barre :
 maille  %(k1)s
 section rectangle
 la valeur de  %(k2)s  doit �tre  strictement positive.
"""),

74 : _(u"""
 barre :
 maille  %(k1)s
 section cercle
 il manque  la caract�ristique  %(k2)s
"""),

75 : _(u"""
 barre :
 maille  %(k1)s
 section cercle
 la valeur de  %(k2)s  doit �tre  strictement positive.
"""),

76 : _(u"""
 barre :
 maille  %(k1)s
 section cercle
 la valeur de  %(k2)s  doit �tre positive.
"""),

77 : _(u"""
 poutre :
 maille  %(k1)s
 section GENERALE
 il manque la caract�ristique  %(k2)s
"""),

78 : _(u"""
 poutre :
 maille  %(k1)s
 section GENERALE
 �l�ment poutre : il manque la caract�ristique  %(k2)s
"""),

79 : _(u"""
 poutre :
 maille  %(k1)s
 section rectangle
 il manque  la caract�ristique  %(k2)s
"""),

80 : _(u"""
 poutre :
 maille  %(k1)s
 section cercle
 il manque la caract�ristique  %(k2)s
"""),

81 : _(u"""
 poutre :
 maille  %(k1)s
 section g�n�rale
 la valeur de  %(k2)s  doit �tre strictement positive
"""),

82 : _(u"""
 poutre :
 maille  %(k1)s
 section rectangle
 la valeur de  %(k2)s  doit �tre strictement positive
"""),

83 : _(u"""
 poutre :
 maille  %(k1)s
 section cercle
 la valeur de  %(k2)s  doit �tre strictement positive
"""),

84 : _(u"""
 poutre :
 maille  %(k1)s
 section rectangle
 la valeur de  %(k2)s  ne doit pas d�passer  %(k3)s /2
"""),

85 : _(u"""
 poutre :
 maille  %(k1)s
 section cercle
 la valeur de  %(k2)s  ne doit pas d�passer celle de  %(k3)s
"""),

86 : _(u"""
 section CIRCULAIRE/RECTANGULAIRE non support�e par POUTRE/TUYAU/FAISCEAU
"""),

87 : _(u"""
 orientation :
 pas d'affectation d'orientation du type  %(k1)s  sur la maille  %(k2)s
 qui n est pas un SEG2
"""),

88 : _(u"""
 orientation :
 pas d'affectation d'orientation du type  %(k1)s sur la maille  %(k2)s
 de longueur nulle
"""),

89 : _(u"""
 orientation :
 pas d affectation d orientation du type  %(k1)s  sur le noeud  %(k2)s
"""),

90 : _(u"""
 orientation :
 pas d'affectation d'orientation du type  %(k1)s  sur la maille  %(k2)s
 de longueur non nulle
"""),

91 : _(u"""
 orientation :
 pas d affectation d orientation du type  %(k1)s  sur la maille  %(k2)s
 qui n est pas SEG2
"""),

92 : _(u"""
 occurrence  %(k1)s de "poutre" (maille  %(k2)s )
 �crasement d'un type de variation de section par un autre
"""),

93 : _(u"""
 occurrence  %(k1)s de "poutre" (maille  %(k2)s )
 �crasement d'un type de g�om�trie de section par un autre
"""),

94 : _(u"""
 le DESCRIPTEUR_GRANDEUR des d�placements ne tient pas sur dix entiers cod�s
"""),

95 : _(u"""
 la carte :  %(k1)s  n'existe pas
"""),

97 : _(u"""
 tous les coefficients sont nuls
"""),

98 : _(u"""
 type de coefficient inconnu: %(k1)s
"""),

99 : _(u"""
Probl�me :
  Une relation lin�aire entre ddls a un second membre de type "fonction".
  On ne peut pas la normaliser (afin que son plus grand coefficient soit 1.) car on ne
  sait pas "diviser" une fonction par un r�el.

  Le plus grand coefficient de la relation est tr�s diff�rent de 1.  (<1.d-3 ou > 1.d3).
  Cette �quation (non normalis�e) peut conduire � des difficult�s num�riques lors de
  la r�solution des syst�mes lin�aires.

Conseil :
  Utilisez le solveur MUMPS afin de contr�ler la qualit� de la r�solutions des syst�mes lin�aires.
"""),

}
