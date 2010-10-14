#@ MODIF algorith6 Messages  DATE 11/10/2010   AUTEUR FLEJOU J-L.FLEJOU 
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
# RESPONSABLE DELMAS J.DELMAS

def _(x) : return x

cata_msg = {

1 : _("""
 GAMMA_T et GAMMA_C ne doivent pas �tre �gal � 1 en m�me temps.
"""),

2 : _("""
 -> La valeur de SYC %(r1)s ne permet pas de respecter GAMMA_C < 1.
 -> Conseil : Choisissez une valeur de SYC inf�rieure � %(r2)s
"""),

3 : _("""
 -> Les valeurs des param�tres de la loi GLRC_DM entra�ne un seuil d'endommagement nul.
 -> Conseil : Modifier les valeurs des param�tres mat�riaux
"""),

13 : _("""
 dimension du probl�me inconnue
"""),

16 : _("""
 le fond de fissure d'un maillage 2d ne peut �tre d�fini par des mailles
"""),

17 : _("""
 les mailles � modifier doivent �tre de type "SEG3" ou "POI1"
"""),

18 : _("""
 le fond de fissure d'un maillage 2d est d�fini par un noeud unique
"""),

19 : _("""
  -> Code Aster a d�tect� des mailles de type diff�rent lors de la
     correspondance entre les maillages des deux mod�les (mesur�/num�rique).
     Ce cas n'est pas pr�vu, Code Aster initialise la correspondance au noeud
     le plus proche.
  -> Risque & Conseil :
     ???
"""),

20 : _("""
 nombre noeuds mesur� sup�rieur au nombre de noeuds calcul�
"""),

21 : _("""
 NOEU_CALCUL non trouv�
"""),

22 : _("""
 NOEU_MESURE non trouv�
"""),

23 : _("""
 nombre de noeuds diff�rent
"""),

24 : _("""
 traitement manuel correspondance : un couple � la fois
"""),

25 : _("""
 �chec projection
"""),

26 : _("""
 norme vecteur dir. nulle
"""),

27 : _("""
 le nombre des coefficients de pond�ration est sup�rieur
 au nombre de vecteurs de base
"""),

28 : _("""
 le nombre des coefficients de pond�ration est inf�rieur
 au nombre de vecteurs de base
 le dernier coefficient est affect� aux autres
"""),

29 : _("""
 le nombre des fonctions de pond�ration est sup�rieur
 au nombre de vecteurs de base
"""),

30 : _("""
 le nombre des fonctions de pond�ration est inf�rieur
 au nombre de vecteurs de base
 la derni�re fonction est affect�e aux autres
"""),

31 : _("""
 le nombre dabscisses d'une des fonctions d'interpolation
 n'est pas identique au nombre d'abscisses du premier point
 de mesure exp�rimental
"""),

32 : _("""
  le crit�re d'�galite de la liste d'abscisses du premier dataset 58
  et de la liste d'abscisses d une des fonctions de pond�ration
  n'est pas verifi�
"""),

33 : _("""
 incompatibilit� NOM_PARA et donn�es mesur�es
"""),

37 : _("""
 pas de num�ro d'ordre pour le concept  %(k1)s
"""),

52 : _("""
 it�rations cycliques :
 changement de configuration ou variation trop importante
 du deplacement physique � l'issue de la derni�re it�ration
 Conseil: diminuez le pas de temps
"""),

53 : _("""
 pas de convergence de l'algorithme de NEWTON :
 - en  %(k1)s  iterations
 - � l'instant  %(k2)s
 il faut r�duire la rigidit� normale, ou le jeu.
"""),

54 : _("""
 dvp : trop de noeuds
"""),

55 : _("""
 THETA = 1 ou 0.5
"""),

56 : _("""
 fluence command�e et FLUX_PHI diff�rent de 1
"""),

57 : _("""
 fluence d�croissante (PHI<0)
"""),

58 : _("""
 relation ASSE_COMBU 1d sans loi de fluence appropri�e
"""),

59 : _("""
 erreur dir. grandissement
"""),

60 : _("""
 CAM_CLAY :
 la porosit� donnee dans CAM_CLAY doit etre la meme que dans THM_INIT
"""),

61 : _("""
 BARCELONE :
 il faut que la contrainte hydrostatique soit sup�rieure
 � la  pression de cohesion -KC*PC
"""),

62 : _("""
 ITER_INTE_MAXI insuffisant lors du calcul de la borne
"""),

63 : _("""
 CAM_CLAY :
 le cas des contraintes planes n'est pas trait� pour ce mod�le.
"""),

64 : _("""
 CAM_CLAY :
 il faut que la contrainte hydrostatique soit sup�rieure
 a la pression initiale PA
"""),

66 : _("""
 pour l'instant, on ne traite pas le cas des contraintes planes
 dans le modele de CHABOCHE � une variable cin�matique.
"""),

67 : _("""
 N doit etre strictementpositif.
"""),

68 : _("""
 param�tre UN_SUR_K �gal � z�ro cas incompatible avec VISC_CINX_CHAB
"""),

69 : _("""
 loi VISC_CINX_CHAB
 on doit obligatoirement avoir UN_SUR_M = z�ro
"""),

78 : _("""
 F reste toujours n�gative.
"""),

79 : _("""
 F reste toujours positive.
"""),

80 : _("""
 pb interp vari entiere ??
"""),

81 : _("""
 Utilisez ALGO_1D="DEBORST" sous %(k2)s pour le comportement %(k1)s.
"""),

86 : _("""
 erreur de programmation 1
"""),

87 : _("""
 loi de comportement inexistante
"""),

88 : _("""
 erreur dans le type de comportement
"""),

92 : _("""
 pas de contraintes planes
"""),

96 : _("""
 GROT_GDEP deformation required for ELAS_HYPER material
"""),

}
