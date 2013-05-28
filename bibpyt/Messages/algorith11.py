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

1 : _(u"""
La valeur sup�rieure de KMOD0 est nulle.
On prend la valeur sup�rieure KMOD.
"""),

2 : _(u"""
La valeur sup�rieure de KMOD est nulle.
"""),

3 : _(u"""
La variable AMOR est nulle.
"""),

5 : _(u"""
La force normale est nulle.
"""),

6 : _(u"""
La somme des impacts �crouissage est inf�rieure � la somme des glissements.
"""),

7 : _(u"""
NOM_CAS n'est pas une variable d'acc�s d'un r�sultat de type EVOL_THER.
"""),

8 : _(u"""
NUME_MODE n'est pas une variable d'acc�s d'un r�sultat de type EVOL_THER.
"""),

9 : _(u"""
NUME_MODE n'est pas une variable d'acc�s d'un r�sultat de type MULT_ELAS.
"""),

10 : _(u"""
INST n'est pas une variable d'acc�s d'un r�sultat de type MULT_ELAS.
"""),

11 : _(u"""
NOM_CAS n'est pas une variable d'acc�s d'un r�sultat de type FOURIER_ELAS.
"""),

12 : _(u"""
INST n'est pas une variable d'acc�s d'un r�sultat de type FOURIER_ELAS.
"""),

13 : _(u"""
NOM_CAS n'est pas une variable d'acc�s d'un r�sultat de type FOURIER_THER.
"""),

14 : _(u"""
INST n'est pas une variable d'acc�s d'un r�sultat de type FOURIER_THER.
"""),

15 : _(u"""
Le mot-clef RESU_INIT est obligatoire.
"""),

16 : _(u"""
Le mot-clef MAILLAGE_INIT est obligatoire.
"""),

17 : _(u"""
Le mot-clef RESU_FINAL est obligatoire.
"""),

18 : _(u"""
Le mot-clef MAILLAGE_FINAL est obligatoire.
"""),

24 : _(u"""
Absence de potentiel permanent.
"""),

25 : _(u"""
Le mod�le fluide n'est pas thermique.
"""),

26 : _(u"""
Le mod�le interface n'est pas thermique.
"""),

27 : _(u"""
Le mod�le fluide est incompatible avec le calcul de masse ajout�e.
Utilisez les mod�lisations PLAN ou 3D ou AXIS.
"""),

29 : _(u"""
Le nombre d'amortissement modaux est diff�rent du nombre de modes dynamiques.
"""),

30 : _(u"""
Il n y a pas le m�me nombre de modes retenus  dans l'excitation modale et 
dans la base modale
"""),

31 : _(u"""
Il faut autant d'indices en i et j.
"""),

32 : _(u"""
Avec SOUR_PRESS et SOUR_FORCE, il faut deux points par degr� de libert� d'application
"""),

33 : _(u"""
Mauvais accord entre le nombre d'appuis et le nombre de valeur dans le mot-cl� NUME_ORDRE_I
"""),

34 : _(u"""
Il faut autant de noms de composantes que de noms de noeuds.
"""),

35 : _(u"""
Pr�cisez le mode statique.
"""),

36 : _(u"""
Le mode statique n'est pas n�cessaire.
"""),

37 : _(u"""
La fr�quence minimale doit �tre plus petite que la fr�quence maximale.
"""),

73 : _(u"""
Le param�tre mat�riau taille limite D10 n'est pas d�fini.
"""),

79 : _(u"""
Pas d'interpolation possible.
"""),

82 : _(u"""
Erreur de la direction de glissement dans NMVPIR.
 Angle ALPHA: %(k1)s
 Angle BETA : %(k2)s
"""),

83 : _(u"""
Arr�t par manque de temps CPU.
"""),

86 : _(u"""
La perturbation est trop petite, calcul impossible.
"""),

87 : _(u"""
Champ d�j� existant
Le champ %(k1)s � l'instant %(r1)g est remplac� par le champ %(k2)s � l'instant %(r2)g avec la pr�cision %(r3)g.
"""),

88 : _(u"""
Arr�t d�bordement assemblage : ligne. 
"""),

90 : _(u"""
Arr�t d�bordement assemblage : colonne. 
"""),

92 : _(u"""
Arr�t pour nombre de sous-structures invalide : 
 Il en faut au minimum : %(i1)d 
 Vous en avez d�fini   : %(i2)d 
"""),

93 : _(u"""
Arr�t pour nombre de noms de sous-structures invalide :
 Il en faut exactement : %(i1)d 
 Vous en avez d�fini   : %(i2)d 
"""),

94 : _(u"""
Arr�t pour nombre de MACR_ELEM invalide :
 Sous-structure %(k1)s
 Il en faut exactement : %(i2)d 
 Vous en avez d�fini   : %(i1)d 
"""),

95 : _(u"""
Arr�t pour nombre d'angles nautiques invalide :
 Sous-structure %(k1)s 
 Il en faut exactement : %(i2)d 
 Vous en avez d�fini   : %(i1)d 
"""),

96 : _(u"""
Arr�t pour nombre de translations invalide :
 Sous-structure %(k1)s 
 Il en faut exactement : %(i2)d 
 Vous en avez d�fini   : %(i1)d  
"""),

97 : _(u"""
Arr�t pour nombre de liaisons d�finies invalide :
 Il en faut exactement : %(i2)d 
 Vous en avez d�fini   : %(i1)d 
"""),

98 : _(u"""
Arr�t pour nombre de mots-cl�s invalide :
 Num�ro liaison : %(i1)d
 Mot-cl�        : %(k1)s 
 Il en faut exactement : %(i3)d 
 Vous en avez d�fini   : %(i2)d
"""),

99 : _(u"""
Arr�t pour sous-structure ind�finie :
 Num�ro liaison    : %(i1)d
 Nom sous-structure: %(k1)s 
"""),

}
