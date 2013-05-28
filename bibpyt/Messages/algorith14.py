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
# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

3 : _(u"""
 type d'interface non support�e en cyclique
 type interface -->  %(k1)s
"""),

4 : _(u"""
 arr�t sur type de r�sultat non support�
 type donn�      -->  %(k1)s
 types support�s -->  %(k2)s %(k3)s
"""),


10 : _(u"""
 la maille %(k2)s n'existe pas dans le maillage %(k1)s
"""),

11 : _(u"""
 le noeud %(k2)s n'existe pas dans le maillage %(k1)s
"""),

13 : _(u"""
 arr�t sur base modale de type illicite
 base modale  -->  %(k1)s
 type         -->  %(k2)s
 type attendu -->  %(k3)s
"""),

14 : _(u"""
 arr�t sur matrice de raideur non unique
"""),

15 : _(u"""
 arr�t sur matrice de masse non unique
"""),

16 : _(u"""
 arr�t sur matrice d'amortissement non unique en argument
"""),

17 : _(u"""
 Le type de matrice %(k1)s est inconnu. Erreur d�veloppeur
"""),

21 : _(u"""
 les matrices assembl�es n'ont pas la m�me num�rotation
 masse   = %(k1)s
 raideur = %(k2)s
"""),

22 : _(u"""
 les matrices assembl�es n'ont pas la m�me num�rotation
 amortissement = %(k1)s
 raideur       = %(k2)s
"""),

23 : _(u"""

 les matrices assembl�es et la base modale n'ont pas le m�me maillage initial
 maillage matrice     : %(k1)s
 maillage base modale : %(k2)s
"""),

24 : _(u"""
 arr�t sur probl�me de coh�rence
 MODE_MECA donn�       -->  %(k1)s
 num�rotation associ�e -->  %(k2)s
 INTERF_DYNA donn�e    -->  %(k3)s
 num�rotation associ�e -->  %(k4)s
"""),

25 : _(u"""
 sous-structure inexistante dans le mod�le g�n�ralis�
 mod�le g�n�ralis� : %(k1)s
 sous-structure    : %(k2)s
"""),

26 : _(u"""
 probl�me de coh�rence du nombre de champs de la base modale
 base modale                  : %(k1)s
 nombre de champs de la base  : %(i1)d
 nombre de degr�s g�n�ralis�s : %(i2)d
"""),

27 : _(u"""
 le maillage %(k1)s n'est pas un maillage SQUELETTE
"""),

28 : _(u"""
  aucun type d'interface d�fini pour la sous-structure :  %(i1)d
  pas de mode rigide d'interface
  le calcul de masses effectives risque d'�tre impr�cis %(i2)d
"""),

30 : _(u"""
 incoh�rence d�tect�e dans le squelette
 objet non trouv� :  %(k1)s
"""),

31 : _(u"""
 probl�me de coh�rence entre le nombre de concepts MODE_MECA et
 la liste des NMAX_MODE:
 nombre de concepts MODE_MECA dans la liste MODE_MECA     : %(i1)d
 nombre de valeurs de la liste NMAX_MODE                  : %(i2)d
 Conseils & solution:
  Les deux listes doivent avoir la m�me taille.
"""),


35 : _(u"""
 aucun champ n'est calcul� dans la structure de donn�es  %(k1)s
"""),

50 : _(u"""
 il faut au moins 1 mode !
"""),

51 : _(u"""
 il faut au moins un MODE_MECA a la 1�re occurrence de RITZ
"""),

61 : _(u"""
 le pas de temps du calcul m�tallurgique ne correspond pas
 au pas de temps du calcul thermique
 - num�ro d'ordre              : %(i1)d
 - pas de temps thermique      : %(r1)f
 - pas de temps m�tallurgique  : %(r2)f
"""),



63 : _(u"""
 donn�es incompatibles :
 pour le MODE_STAT  :  %(k1)s
 il manque le champ :  %(k2)s
"""),


66 : _(u"""
 Taille de bloc insuffisante
 taille de bloc demand�e (kr8): %(r1)f
 taille de bloc utilis�e (kr8): %(r2)f
"""),

68 : _(u"""
  Estimation de la dur�e du r�gime transitoire :
  valeur minimale conseill�e :  %(r1)f
"""),

69 : _(u"""
 non-lin�arit� incompatible avec la d�finition du mod�le g�n�ralis�
 NOEUD_1      :  %(k1)s
 SOUS_STRUC_1 :  %(k2)s
 NOEUD_2      :  %(k3)s
 SOUS_STRUC_2 :  %(k4)s
"""),

70 : _(u"""
 probl�me de coh�rence du nombre de noeuds d'interface
 sous-structure1            : %(k1)s
 interface1                 : %(k2)s
 nombre de noeuds interface1: %(i1)d
 sous-structure2            : %(k3)s
 interface2                 : %(k4)s
 nombre de noeuds interface2: %(i2)d
"""),

71 : _(u"""
 probl�me de coh�rence des interfaces orient�es
 sous-structure1           : %(k1)s
 interface1                : %(k2)s
 pr�sence composante sur 1 : %(k3)s
 sous-structure2           : %(k4)s
 interface2                : %(k5)s
 composante inexistante sur 2 %(k6)s
"""),

72 : _(u"""
 probl�me de coh�rence des interfaces orient�es
 sous-structure2           : %(k1)s
 interface2                : %(k2)s
 pr�sence composante sur 2 : %(k3)s
 sous-structure1           : %(k4)s
 interface1                : %(k5)s
 composante inexistante sur 1 %(k6)s
"""),

73 : _(u"""
 Sous-structures incompatibles
 sous-structure 1             : %(k1)s
 MACR_ELEM associ�            : %(k2)s
 num�ro grandeur sous-jacente : %(i1)d
 sous-structure 2             : %(k3)s
 MACR_ELEM associ�            : %(k4)s
 num�ro grandeur sous-jacente : %(i2)d
"""),

74 : _(u"""
 arr�t sur incompatibilit� de sous-structures
"""),

75 : _(u"""
  Erreur d�veloppement : code retour 1 dans NMCOMP en calculant la matrice tangente
 """),

77 : _(u"""
 les types des deux matrices sont diff�rents
 type de la matrice de raideur :  %(k1)s
 type de la matrice de masse   :  %(k2)s
"""),

78 : _(u"""
 les num�rotations des deux matrices sont diff�rentes
 num�rotation matrice de raideur :  %(k1)s
 num�rotation matrice de masse   :  %(k2)s
"""),

79 : _(u"""
 coefficient de conditionnement des multiplicateurs de Lagrange :  %(r1)f
"""),

80 : _(u"""
 affichage des coefficients d'amortissement :
 premier coefficient d'amortissement : %(r1)f
 second  coefficient d'amortissement : %(r2)f
"""),

82 : _(u"""
 calcul du nombre de diam�tres modaux demand� impossible
 nombre de diam�tres demand� --> %(i1)d
"""),

83 : _(u"""
 calcul des modes propres limit� au nombre de diam�tres maximum --> %(i1)d
"""),

84 : _(u"""
 calcul cyclique :
 aucun nombre de diam�tres nodaux licite
"""),

85 : _(u"""
 liste de fr�quences incompatible avec l'option
 nombre de fr�quences --> %(i1)d
 option               --> %(k1)s
"""),

87 : _(u"""
  r�solution du probl�me g�n�ralis� complexe
  nombre de modes dynamiques:  %(i1)d
  nombre de ddl droite      :  %(i2)d
"""),

88 : _(u"""
  nombre de ddl axe         :  %(i1)d
         dont cycliques     :  %(i2)d
         dont non cycliques :  %(i3)d
"""),

89 : _(u"""
  dimension max du probl�me :  %(i1)d
"""),

91 : _(u"""
 noeud sur l'AXE_Z
 noeud :  %(k1)s
"""),

93 : _(u"""
 arr�t sur dimension matrice TETA incorrecte
 dimension effective   :  %(i1)d
 dimension en argument :  %(i2)d
"""),

94: _(u"""
 erreur de r�p�titivit� cyclique
"""),

95: _(u"""
 il manque un ddl sur un noeud  axe type du ddl -->  %(k1)s
 nom du noeud -->  %(k2)s
"""),

99 : _(u"""
 arr�t sur nombres de noeuds interface non identiques
 nombre de noeuds interface droite:  %(i1)d
 nombre de noeuds interface gauche:  %(i2)d
"""),

}
