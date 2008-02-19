#@ MODIF algorith14 Messages  DATE 19/02/2008   AUTEUR COURTOIS M.COURTOIS 
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

3 : _("""
 type d'interface non support�e en cyclique
 type interface -->  %(k1)s 
"""),

4 : _("""
 arr�t sur type de r�sultat non support�
 type donn�      -->  %(k1)s 
 types support�s -->  %(k2)s %(k3)s
"""),

8 : _("""
 il manque la d�form�e modale pour le mode  %(i1)d 
"""),

10 : _("""
 la maille %(k2)s n'existe pas dans le maillage %(k1)s 
"""),

11 : _("""
 le noeud %(k2)s n'existe pas dans le maillage %(k1)s
"""),

13 : _("""
 arr�t sur base modale de type illicite
 base modale  -->  %(k1)s
 type         -->  %(k2)s 
 type attendu -->  %(k3)s 
"""),

14 : _("""
 arr�t sur matrice de raideur non unique
"""),

15 : _("""
 arr�t sur matrice de masse non unique
"""),

16 : _("""
 arr�t sur matrice d'amortissement non unique en argument
"""),

17 : _("""
 Le type de matrice %(k1)s est inconnu. Erreur d�veloppeur
"""),

21 : _("""
 les matrices assembl�es n'ont pas la m�me num�rotation
 masse   = %(k1)s 
 raideur = %(k2)s 
"""),

22 : _("""
 les matrices assembl�es n'ont pas la m�me num�rotation
 amortissement = %(k1)s 
 raideur       = %(k2)s 
"""),

23 : _("""
 
 les matrices assembl�es et la base modale n'ont pas le m�me maillage initial
 maillage matrice     : %(k1)s 
 maillage base modale : %(k2)s 
"""),

24 : _("""
 arr�t sur probl�me de coh�rence
 MODE_MECA donn�       -->  %(k1)s 
 numerotation associ�e -->  %(k2)s 
 INTERF_DYNA donn�e    -->  %(k3)s 
 num�rotation associ�e -->  %(k4)s 
"""),

25 : _("""
 sous-structure inexistante dans le modele g�n�ralis�
 mod�le generalis� : %(k1)s 
 sous-structure    : %(k2)s 
"""),

26 : _("""
 probl�me de coh�rence du nombre de champs de la base modale
 base modale                  : %(k1)s 
 nombre de champs de la base  : %(i1)d 
 nombre de degr�s g�n�ralis�s : %(i2)d 
"""),

27 : _("""
 le maillage %(k1)s n'est pas un maillage SQUELETTE 
"""),

28 : _("""
  aucun type d'interface d�fini pour la sous-structure :  %(i1)d 
  pas de mode rigide d'interface
  le calcul de masses effectives risque d'�tre impr�cis %(i2)d 
"""),

30 : _("""
 incoherence d�tect�e dans le squelette
 objet non trouv� :  %(k1)s 
"""),

32 : _("""
 sd resultat  %(k1)s, le champ %(k2)s n'existe pas   
 pour le nume_ordre  %(i1)d 
"""),

33 : _("""
 sd resultat  %(k1)s, le champ %(k2)s n'a pas ete duplique   
 pour le nume_ordre  %(i1)d 
"""),

35 : _("""
 aucun champ n'est calcul� dans la structure de donnees  %(k1)s 
"""),

36 : _("""
 les numerotations des champs ne coincident pas celui de  %(k1)s  est :  %(k2)s 
 et celui de  %(k3)s 
  est :  %(k4)s 
"""),

50 : _("""
 il faut au moins 1 mode !
"""),

51 : _("""
 il faut un mode_meca a la 1ere occurence de ritz
"""),

55 : _("""
 le champ de "TEMP" n'existe pas pour le num�ro d'ordre  %(i1)d 
"""),

59 : _("""
 le champ de "META_ELNO_TEMP"  n'existe pas pour le num�ro d'ordre  %(i1)d 
"""),

61 : _("""
 le pas de temps du calcul m�tallurgique ne correspond pas
 au pas de temps du calcul thermique
 - numero d'ordre              : %(i1)d 
 - pas de temps thermique      : %(r1)f 
 - pas de temps m�tallurgique  : %(r2)f 
"""),

62 : _("""
 il manque la d�form�e modale nom_cham  %(k1)s  pour le mode  %(i1)d 
"""),

63 : _("""
 donn�es incompatibles :
 pour le mode_stat  :  %(k1)s 
 il manque le champ :  %(k2)s 
"""),

64 : _("""
 il manque le mode statique nom_cham  %(k1)s  pour le mode  %(i1)d 
"""),

66 : _("""
 Taille de bloc insuffisante
 taille de bloc demand�e (kr8): %(r1)f 
 taille de bloc utilis�e (kr8): %(r2)f 
"""),

68 : _("""
  Estimation de la dur�e du r�gime transitoire :
  valeur minimale conseill�e :  %(r1)f 
"""),

69 : _("""
 non-linearit� incompatible avec la d�finition du mod�le g�n�ralis�
 noeud_1      :  %(k1)s 
 sous_struc_1 :  %(k2)s 
 noeud_2      :  %(k3)s 
 sous_struc_2 :  %(k4)s 
"""),

70 : _("""
 probl�me de coh�rence du nombre de noeuds d'interface
 sous-structure1            : %(k1)s 
 interface1                 : %(k2)s 
 nombre de noeuds interface1: %(i1)d 
 sous-structure2            : %(k3)s 
 interface2                 : %(k4)s 
 nombre de noeuds interface2: %(i2)d 
"""),

71 : _("""
 probl�me de coh�rence des interfaces orient�es
 sous-structure1           : %(k1)s 
 interface1                : %(k2)s 
 presence composante sur 1 : %(k3)s 
 sous-structure2           : %(k4)s 
 interface2                : %(k5)s 
 composante inexistante sur 2 %(k6)s 
"""),

72 : _("""
 probl�me de coh�rence des interfaces orient�es
 sous-structure2           : %(k1)s 
 interface2                : %(k2)s 
 presence composante sur 2 : %(k3)s 
 sous-structure1           : %(k4)s 
 interface1                : %(k5)s 
 composante inexistante sur 1 %(k6)s 
"""),

73 : _("""
 Sous-structures incompatibles
 sous-structure 1             : %(k1)s
 MACR_ELEM associ�            : %(k2)s 
 num�ro grandeur sous-jacente : %(i1)d 
 sous-structure 2             : %(k3)s 
 MACR_ELEM associ�            : %(k4)s 
 num�ro grandeur sous-jacente : %(i2)d 
"""),

74 : _("""
 arret sur incompatibilit� de sous-structures
"""),

75 : _("""
  Erreur d�veloppement : code retour 1 dans nmcomp en calculant la matrice tangente
 """),

77 : _("""
 les types des deux matrices sont diff�rents
 type de la matrice de raideur :  %(k1)s 
 type de la matrice de masse   :  %(k2)s 
"""),

78 : _("""
 les num�rotations des deux matrices sont diff�rentes
 num�rotation matrice de raideur :  %(k1)s 
 num�rotation matrice de masse   :  %(k2)s 
"""),

79 : _("""
 coefficient de conditionnement des lagranges :  %(r1)f 
"""),

80 : _("""
 affichage des coefficients d'amortissement :
 premier coefficient d'amortissement : %(r1)f 
 second  coefficient d'amortissement : %(r2)f 
"""),

82 : _("""
 calcul du nombre de diam�tres modaux demand� impossible
 nombre de diam�tres demand� --> %(i1)d 
"""),

83 : _("""
 calcul des modes propres limit� au nombre de diam�tres maximum --> %(i1)d 
"""),

84 : _("""
 calcul cyclique :
 aucun nombre de diam�tres nodaux licite
"""),

85 : _("""
 liste de fr�quences incompatible avec l'option
 nombre de fr�quences --> %(i1)d 
 option               --> %(k1)s 
"""),

87 : _("""
  r�solution du probl�me g�n�ralis� complexe
  nombre de modes dynamiques:  %(i1)d 
  nombre de ddl droite      :  %(i2)d 
"""),

88 : _("""
  nombre de ddl axe         :  %(i1)d
         dont cycliques     :  %(i2)d 
         dont non cycliques :  %(i3)d 
"""),

89 : _("""
  dimension max du probl�me :  %(i1)d 
"""),

91 : _("""
 noeud sur l'axe_z
 noeud :  %(k1)s 
"""),

93 : _("""
 arr�t sur dimension matrice TETA incorrecte
 dimension effective   :  %(i1)d 
 dimension en argument :  %(i2)d 
"""),

99 : _("""
 arr�t sur nombres de noeuds interface non identiques 
 nombre de noeuds interface droite:  %(i1)d 
 nombre de noeuds interface gauche:  %(i2)d 
"""),

}
