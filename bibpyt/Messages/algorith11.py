#@ MODIF algorith11 Messages  DATE 18/03/2008   AUTEUR CNGUYEN C.NGUYEN 
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
 le sup de KMOD0 est nul
 on prend le sup de KMOD
"""),

2 : _("""
 le sup de KMOD est nul.
"""),

3 : _("""
 la variable AMOR est nulle
"""),

4 : _("""
 erreur de dimension (dvlp)
"""),

5 : _("""
 force normale nulle.
"""),

6 : _("""
 somme des "impacts-ecrouissage" < somme des "glissement"
"""),

7 : _("""
 "NOM_CAS" n'est pas une variable d'acc�s d'un r�sultat de type "EVOL_THER".
"""),

8 : _("""
 "NUME_MODE" n'est pas une variable d'acc�s d'un r�sultat de type "EVOL_THER".
"""),

9 : _("""
 "NUME_MODE" n'est pas une variable d'acc�s d'un r�sultat de type "MULT_ELAS".
"""),

10 : _("""
 "INST" n'est pas une variable d'acc�s d'un resultat de type "MULT_ELAS".
"""),

11 : _("""
 "NOM_CAS" n'est pas une variable d'acc�s d'un resultat de type "FOURIER_ELAS".
"""),

12 : _("""
 "INST" n'est pas une variable d'acc�s d'un resultat de type "FOURIER_ELAS".
"""),

13 : _("""
 "NOM_CAS" n'est pas une variable d'acc�s d'un resultat de type "FOURIER_THER".
"""),

14 : _("""
 "INST" n'est pas une variable d'acc�s d'un resultat de type "FOURIER_THER".
"""),

15 : _("""
 "RESU_INIT" est obligatoire
"""),

16 : _("""
 "MAILLAGE_INIT" est obligatoire
"""),

17 : _("""
 "resu_final" est obligatoire
"""),

18 : _("""
 "maillage_final" est obligatoire
"""),

20 : _("""
 TYPCAL invalide :  %(k1)s 
"""),

24 : _("""
 absence de potentiel permanent
"""),

25 : _("""
 le modele fluide n'est pas thermique
"""),

26 : _("""
 le modele interface n'est pas thermique
"""),

27 : _("""
 mod�le fluide incompatible avec le calcul de masse ajout�e
 seules les modelisations PLAN ou 3D ou AXIS sont utilis�es
"""),




29 : _("""
 le nombre d'amortissement modaux est diff�rent du nombre de modes dynamiques
"""),

30 : _("""
 il n y a pas le meme nombre de modes retenus
 dans l'excitation modale et dans la base modale
"""),

31 : _("""
 il faut autant d'indices en i et j
"""),

32 : _("""
 avec SOUR_PRESS et SOUR_FORCE, il faut deux points/ddls d'application
"""),

33 : _("""
 mauvais accord entre le nombre d'appuis et le nombre de valeur dans le mot-cl�: NUME_ORDRE_I
"""),

34 : _("""
 il faut autant de noms de composante que de noms de noeud
"""),

35 : _("""
  vous avez oubli� de pr�ciser le mode statique
"""),

36 : _("""
  mode statique non- n�cessaire
"""),

37 : _("""
 la fr�quence min doit etre plus faible que la fr�quence max
"""),

73 : _("""
 le parametre materiau taille limite d10 n'est pas defini
"""),

74 : _("""
 �chec de la recherche de z�ro (NITER)
"""),

75 : _("""
 �chec de la recherche de z�ro (bornes)
"""),

76 : _("""
 La valeur de F(XMIN) doit �tre n�gative.
"""),

77 : _("""
 f=0 : augmenter ITER_INTE_MAXI
"""),

79 : _("""
 pas d'interpolation possible
"""),

81 : _("""
 STOP_SINGULIER=DECOUPE n�cessite la subdivision automatique du pas de temps (SUBD_PAS).
"""),

82 : _("""
 NMVPIR erreur direction grandissement
 Angle ALPHA %(k1)s
 Angle BETA  %(k2)s
"""),

83 : _("""
 Arret par manque de temps CPU.
"""),

85 : _("""
 On veut affecter un comportement %(k1)s avec la relation %(k2)s
 sur une maille deja affect�e par un autre comportement %(k3)s %(k4)s
"""),

86 : _("""
 Perturbation trop petite, calcul impossible
"""),

87 : _("""
 Champ d�j� existant
 Le champ %(k1)s � l'instant %(r1)g est remplac� par le champ %(k2)s � l'instant %(r2)g avec la pr�cision %(r3)g.
"""),

88 : _("""
 arret d�bordement assemblage : ligne 
"""),

90 : _("""
 arret d�bordement assemblage : colonne 
"""),

92 : _("""
 arret nombre de sous-structures invalide : 
 il en faut au minimum : %(i1)d 
 vous en avez d�fini   : %(i2)d 
"""),

93 : _("""
 arret nombre de nom de sous-structures invalide :
 il en faut exactement : %(i1)d 
 vous en avez d�fini   : %(i2)d 
"""),

94 : _("""
 nombre de MACR_ELEM invalide :
 sous_structure %(k1)s
 il en faut exactement : %(i2)d 
 vous en avez d�fini   : %(i1)d 
"""),

95 : _("""
 nombre d'angles nautiques invalide
 sous_structure %(k1)s 
 il en faut exactement :  %(i2)d 
 vous en avez d�fini   : %(i1)d 
"""),

96 : _("""
 nombre de translations invalide
 sous_structure %(k1)s
 il en faut exactement :  %(i2)d 
 vous en avez defini   : %(i1)d 
"""),

97 : _("""
 nombre de liaison definies invalide
 il en faut au minimum : %(i2)d 
 vous en avez defini   : %(i1)d 
"""),

98 : _("""
 nombre de mot-cl�s invalide
 num�ro liaison: %(i1)d
 mot-cl�       : %(k1)s 
 il en faut exactement : %(i3)d 
 vous en avez defini   : %(i2)d 
"""),

99 : _("""
 sous-structure ind�finie
 num�ro liaison: %(i1)d
 nom sous-structure: %(k1)s 
"""),

}
