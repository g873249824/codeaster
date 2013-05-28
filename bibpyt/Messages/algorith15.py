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
# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

1 : _(u"""
 arr�t sur nombres de DDL interface non identiques
 nombre de ddl interface droite:  %(i1)d
 nombre de ddl interface gauche:  %(i2)d
"""),

2 : _(u"""
 arr�t sur dimension matrice TETA incorrecte
 dimension effective :  %(i1)d
 dimension en argument:  %(i2)d
"""),

3 : _(u"""
  erreur de r�p�titivit� cyclique
"""),

4 : _(u"""
  il manque un DDL sur un noeud gauche
  type du DDL  -->  %(k1)s
  nom du noeud -->  %(k2)s
"""),



6 : _(u"""
  il manque un DDL sur un noeud droite
  type du ddl  -->  %(k1)s
  nom du noeud -->  %(k2)s
"""),

7 : _(u"""
 arr�t sur probl�me de r�p�titivit� cyclique
"""),

8 : _(u"""
 la composante : %(k1)s  est une composante ind�finie
"""),




10 : _(u"""
 arr�t sur type de DDL non d�fini
"""),

11 : _(u"""
 "NB_POIN" est inf�rieur au nombre de points de l'interspectre.
 le spectre est tronqu� � la fr�quence :  %(r1)f
"""),

12 : _(u"""
 le "NB_POIN" donn� est modifi�
 (en une puissance de 2 compatible avec l'interspectre)
 le "NB_POIN" retenu est :   %(i1)d
"""),

13 : _(u"""
 la dur�e est trop grande ou NB_POIN et trop petit par rapport
 � la fr�quence max (th�or�me de Shannon).
 on choisit NBPOIN =  %(i1)d
"""),

14 : _(u"""
 la dur�e est petite par rapport au pas de discr�tisation de l'interspectre.
 choisir plut�t : dur�e >  %(r1)f
"""),

15 : _(u"""
 "NB_POIN" est petit par rapport au pas de discr�tisation de l'interspectre.
 NB_POIN =  %(i1)d
 il faudrait un nombre sup�rieur � :  %(r1)f
"""),

16 : _(u"""
 on n'a pas trouve le DDL pour le noeud :  %(k1)s
"""),

17 : _(u"""
    de la sous-structure :  %(k1)s
"""),

18 : _(u"""
    et sa composante :  %(k1)s
"""),

19 : _(u"""
  il manque le seuil  pour la fonction interpr�t�e  %(k1)s
"""),

20 : _(u"""
 l'abscisse lin�aire est nulle pour la courbe :  %(k1)s
 abscisse :  %(r1)f
"""),







24 : _(u"""
 au moins un terme de ALPHA est n�gatif � l'abscisse :  %(i1)d
"""),

25 : _(u"""
 ALPHA est nul et le nombre de mesures est strictement inf�rieur au nombre de modes
 risque de matrice singuli�re
"""),

26 : _(u"""
 calcul moindre norme
"""),

27 : _(u"""
  probl�me calcul valeurs singuli�res
  pas      =   %(i1)d
  abscisse =    %(r1)f
"""),

28 : _(u"""
  la matrice (PHI)T*PHI + ALPHA n'est pas inversible
  pas      =   %(i1)d
  abscisse =    %(r1)f
"""),






















45 : _(u"""
  on ne trouve pas DPMAX
"""),

46 : _(u"""
  nombre d'it�rations insuffisant
"""),

47 : _(u"""
  F(XMIN) > 0
"""),

48 : _(u"""
  maille :  %(k1)s
  nombre d it�rations =  %(i1)d
  ITER_INTE_MAXI =  %(i2)d
"""),

49 : _(u"""
  DP    actuel =  %(r1)f
  F(DP) actuel =  %(r2)f
"""),

50 : _(u"""
  DP    initial   =  %(r1)f
  F(DP) initial   =  %(r2)f
"""),

51 : _(u"""
  DP    maximum   =  %(r1)f
  F(DP) maximum   =  %(r2)f
"""),

52 : _(u"""
  allure de la fonction
  nombre points :  %(i1)d
"""),

53 : _(u"""
  DP     =  %(r1)f
  F(DP)  =  %(r2)f
"""),




55 : _(u"""
  incoh�rence d�tect�e
"""),

56 : _(u"""
  le noeud :  %(k1)s  de l'interface dynamique :  %(k2)s
  n'appartient pas la sous-structure:  %(k3)s
"""),





58 : _(u"""
  le noeud :  %(k1)s  de l interface dynamique :  %(k2)s
  n'est pas correctement r�f�renc� dans le squelette :  %(k3)s
"""),

59: _(u"""
  Le nombre de secteur doit �tre sup�rieur ou �gal � 2 (mot cl� NB_SECTEUR)
"""),

60 : _(u"""
  le noeud :  %(k1)s  de l'interface dynamique :  %(k2)s
  n'appartient pas la sous-structure:  %(k3)s
"""),




62 : _(u"""
  le noeud :  %(k1)s  de l'interface dynamique :  %(k2)s
  n'est pas correctement r�f�renc� dans le squelette :  %(k3)s
"""),

63 : _(u"""
  conflit mot cl�s TOUT et GROUP_NO dans RECO_GLOBAL
"""),

64 : _(u"""
  erreur de nom
  la sous-structure :  %(k1)s  n a pas �t� trouv�e
"""),

65 : _(u"""
  incoh�rence de nom
  l interface dynamique  :  %(k1)s
  de la sous-structure   :  %(k2)s
  a pour groupe de noeud :  %(k3)s
  or GROUP_NO_1 =  %(k4)s
"""),

66 : _(u"""
  erreur de nom
  la sous-structure :  %(k1)s  n'a pas �t� trouv�e
"""),

67 : _(u"""
  incoh�rence de nom
  l interface dynamique  :  %(k1)s
  de la sous-structure   :  %(k2)s
  a pour groupe de noeud :  %(k3)s
  or GROUP_NO_2 =  %(k4)s
"""),

68 : _(u"""
 nombre de points pas p�riode             :  %(i1)d
 coefficient de remont�e du pas de temps  :  %(r1)f
 coefficient de division du pas de temps  :  %(r2)f
 pas de temps minimal                     :  %(r3)f
 pas de temps maximal                     :  %(r4)f
 nombre maximal de r�ductions du pas      :  %(i2)d
 vitesse minimale variable                :  %(k1)s
"""),

69 : _(u"""
 nombre incorrect de sous-structures
 il vaut :  %(i1)d
 alors que le nombre total de sous-structures vaut :  %(i2)d
"""),

70 : _(u"""
 nombre incorrect de sous-structures
 pour le chargement num�ro : %(i1)d
 il en faut exactement :  %(i2)d
 vous en avez          :  %(i3)d
"""),

71 : _(u"""
 nombre incorrect de vecteurs chargements
 pour le chargement num�ro : %(i1)d
 il en faut exactement :  %(i2)d
 vous en avez          :  %(i3)d
"""),

72 : _(u"""
 un PROF_CHNO n'est pas d�fini
 il manque pour le chargement : %(k1)s
"""),

73 : _(u"""
 on doit avoir le m�me type de forces pour un m�me chargement global
 or, la grandeur vaut   :  %(i1)d
 pour la sous-structure    %(k1)s
 et elle vaut           :  %(i2)d
 pour la sous-structure    %(k2)s
"""),

74 : _(u"""
 une des bases modales a un type incorrect
 elle est associ�e � la sous-structure  %(k1)s
"""),

75 : _(u"""
 les num�rotations ne co�ncident pas pour la sous-structure : %(k1)s
 le PROF_CHNO pour la base modale est :  %(k2)s
 et celui pour le second membre       :  %(k3)s
"""),

85 : _(u"""
  L'interface de droite %(k1)s n'existe pas
  Conseil: v�rifiez si vous avez d�fini cette interface dans le mod�le
"""),

86 : _(u"""
  l'interface de gauche %(k1)s n'existe pas
  Conseil: v�rifiez si vous avez d�fini cette interface dans le mod�le
"""),

87 : _(u"""
  l'interface axe %(k1)s n'existe pas
  Conseil: v�rifiez si vous avez d�fini cette interface dans le mod�le
"""),

88 : _(u"""
 arr�t sur probl�me interfaces de type diff�rents
"""),

89 : _(u"""
 arr�t sur probl�me de type interface non support�
 type interface -->  %(k1)s
"""),

90 : _(u"""
 le nombre d'amortissements r�duits est trop grand
 le nombre de modes propres vaut  %(i1)d
 et le nombre de coefficients  :  %(i2)d
 on ne garde donc que les  %(i3)d premiers coefficients
"""),

91 : _(u"""
 le nombre d'amortissements r�duits est insuffisant
 il en manque :  %(i1)d
 car le nombre de modes vaut :  %(i2)d
 on rajoute %(i3)d coefficients avec la valeur du dernier coefficient.
"""),

92 : _(u"""
 Nombre de modes propres calcul�s insuffisant.
"""),

93 : _(u"""
 MODE_MECA : %(k1)s
"""),

94 : _(u"""
 Nombre de modes propres limit�s � : %(i1)d
"""),

95 : _(u"""
 l'entr�e d'amortissements r�duits est incompatible
 avec des matrices de type  %(k1)s
 Il faut des matrices de type MATR_ASSE_GENE_*
"""),

96 : _(u"""
 le nombre d'amortissements r�duits est trop grand
 le nombre de modes propres vaut  %(i1)d
 et le nombre de coefficients :  %(i2)d
 on ne garde donc que les  %(i3)d premiers coefficients

"""),

97 : _(u"""
 le nombre d'amortissements r�duits est insuffisant
 il en manque :  %(i1)d
 car le nombre de modes vaut :  %(i2)d
 on rajoute  %(i3)d amortissement r�duits avec la valeur du dernier mode propre.
"""),

98 : _(u"""
 incoh�rence dans le DATASET 58
 le nombre de valeurs fournies ne correspond pas au nombre de valeurs attendues
 mesure concern�e :  %(i1)d

"""),

99 : _(u"""
 le nombre maximum d'it�rations  %(i1)d  est atteint sans converger
 le r�sidu relatif final est  : %(r1)f
 l instant de calcul vaut     : %(r2)f

"""),

}
