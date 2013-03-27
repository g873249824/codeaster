#@ MODIF algorith6 Messages  DATE 25/03/2013   AUTEUR DELMAS J.DELMAS 
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
 GAMMA_T et GAMMA_C ne doivent pas �tre �gal � 1 en m�me temps.
"""),

2 : _(u"""
 -> La valeur de SYC %(r1)f ne permet pas de respecter GAMMA_C < 1.
 -> Conseil : Choisissez une valeur de SYC inf�rieure � %(r2)f
"""),

3 : _(u"""
 -> Les valeurs des param�tres de la loi GLRC_DM entra�ne un seuil d'endommagement nul.
 -> Conseil : Modifier les valeurs des param�tres mat�riaux
"""),

4 : _(u"""
  La valeur de %(k1)s est n�gative. Les r�sultats obtenus risquent d'�tre inattendus
"""),

5 : _(u"""
 -> La valeur de d�formation maximale %(r1)f est inf�rieur au seuil d'endommagement %(r2)f.
 -> Le mod�le GLRC_DM risque de donner des r�sultats inattendus.
 -> Conseil : Utilisez une loi �lastique ou v�rifiez les param�tres d'homog�n�isation.
"""),

6 : _(u"""
 -> Le pourcentage des aciers ou l'espace des armatures n'est pas identique dans les deux directions et ne respecte donc pas l'isotropie du mod�le.
 -> Le mod�le GLRC_DM peut donner des r�sultats inattendus.
 -> Conseil: Choisissez une autre loi de comportement ou couplez le mod�le avec un mod�le de grille d'acier.
"""),

7 : _(u"""
 -> Il faut d�finir au moins et seulement une armature d'acier.
"""),

8 : _(u"""
 -> L'objet sd_mater transmit au mot cl� MATER de BETON ne contient pas de propri�t�s �lastique.
 -> Risque & Conseil : Ajouter les propri�t�s �lastique dans le DEFI_MATERIAU du b�ton.
"""),

9 : _(u"""
 -> L'objet sd_mater transmit au mot cl� MATER de BETON ne contient pas de propri�t�s post �lastiques.
 -> Risque & Conseil : Ajouter les propri�t�s post �lastiques dans le DEFI_MATERIAU du b�ton.
"""),

10 : _(u"""
 -> L'objet sd_mater transmit au mot cl� MATER d'ACIER ne contient pas de propri�t�s �lastique.
 -> Risque & Conseil : Ajouter les propri�t�s �lastique dans le DEFI_MATERIAU de l'acier.
"""),

11 : _(u"""
 -> Il est impossible d'utiliser PENTE = ACIER_PLAS si la limite �lastique de l'acier SY n'est pas d�fini.
 -> Risque & Conseil : Ajouter le param�tre SY dans le DEFI_MATERIAU de l'acier
                       ou n'utilisez pas PENTE = ACIER_PLAS
"""),

13 : _(u"""
 dimension du probl�me inconnue
"""),

16 : _(u"""
 le fond de fissure d'un maillage 2d ne peut �tre d�fini par des mailles
"""),

17 : _(u"""
 les mailles � modifier doivent �tre de type "SEG3" ou "POI1"
"""),

18 : _(u"""
 le fond de fissure d'un maillage 2d est d�fini par un noeud unique
"""),

19 : _(u"""
  -> Code Aster a d�tect� des mailles de type diff�rent lors de la
     correspondance entre les maillages des deux mod�les (mesur�/num�rique).
     Ce cas n'est pas pr�vu, Code Aster initialise la correspondance au noeud
     le plus proche.
  -> Conseil :
     V�rifier la correspondance des noeuds et raffiner le maillage si besoin.
"""),

20 : _(u"""
 nombre noeuds mesur� sup�rieur au nombre de noeuds calcul�
"""),

21 : _(u"""
 NOEU_CALCUL non trouv�
"""),

22 : _(u"""
 NOEU_MESURE non trouv�
"""),

23 : _(u"""
 nombre de noeuds diff�rent
"""),

24 : _(u"""
 traitement manuel correspondance : un couple � la fois
"""),

25 : _(u"""
 �chec projection
"""),

26 : _(u"""
 norme vecteur direction nulle
"""),

27 : _(u"""
 le nombre des coefficients de pond�ration est sup�rieur
 au nombre de vecteurs de base
"""),

28 : _(u"""
 le nombre des coefficients de pond�ration est inf�rieur
 au nombre de vecteurs de base
 le dernier coefficient est affect� aux autres
"""),

29 : _(u"""
 le nombre des fonctions de pond�ration est sup�rieur
 au nombre de vecteurs de base
"""),

30 : _(u"""
 le nombre des fonctions de pond�ration est inf�rieur
 au nombre de vecteurs de base
 la derni�re fonction est affect�e aux autres
"""),

31 : _(u"""
 le nombre d'abscisses d'une des fonctions d'interpolation
 n'est pas identique au nombre d'abscisses du premier point
 de mesure exp�rimental
"""),

32 : _(u"""
  le crit�re d'�galit� de la liste d'abscisses du premier DATASET 58
  et de la liste d'abscisses d une des fonctions de pond�ration
  n'est pas v�rifi�
"""),

33 : _(u"""
 incompatibilit� NOM_PARA et donn�es mesur�es
"""),

52 : _(u"""
 it�rations cycliques :
 changement de configuration ou variation trop importante
 du d�placement physique � l'issue de la derni�re it�ration
 Conseil: diminuez le pas de temps
"""),

53 : _(u"""
 pas de convergence de l'algorithme de NEWTON :
 - en  %(k1)s  it�rations
 - � l'instant  %(k2)s
 il faut r�duire la rigidit� normale, ou le jeu.
"""),

55 : _(u"""
 THETA = 1 ou 0.5
"""),

56 : _(u"""
 fluence command�e et FLUX_PHI diff�rent de 1
"""),

57 : _(u"""
 fluence d�croissante (PHI<0)
"""),

58 : _(u"""
 relation ASSE_COMBU 1d sans loi de fluence appropri�e
"""),

59 : _(u"""
 erreur direction grandissement
"""),

60 : _(u"""
 CAM_CLAY :
 la porosit� donn�e dans CAM_CLAY doit �tre la m�me que dans THM_INIT
"""),

61 : _(u"""
 BARCELONE :
 il faut que la contrainte hydrostatique soit sup�rieure
 � la  pression de coh�sion -KC*PC
"""),

62 : _(u"""
 ITER_INTE_MAXI insuffisant lors du calcul de la borne
"""),

63 : _(u"""
 CAM_CLAY :
 le cas des contraintes planes n'est pas trait� pour ce mod�le.
"""),

64 : _(u"""
 CAM_CLAY :
 il faut que la contrainte hydrostatique soit sup�rieure
 a la pression initiale PA
"""),

67 : _(u"""
 N doit �tre strictement positif.
"""),

68 : _(u"""
 param�tre UN_SUR_K �gal � z�ro cas incompatible avec VISC_CINX_CHAB
"""),

69 : _(u"""
 loi VISC_CINX_CHAB
 on doit obligatoirement avoir UN_SUR_M = z�ro
"""),

79 : _(u"""
 F reste toujours positive.
"""),

80 : _(u"""
 Probl�me interpr�tation vari enti�re ??
"""),

81 : _(u"""
 Utilisez ALGO_1D="DEBORST" sous %(k2)s pour le comportement %(k1)s.
"""),

86 : _(u"""
 erreur de programmation 1
"""),

87 : _(u"""
 loi de comportement inexistante
"""),

88 : _(u"""
 erreur dans le type de comportement
"""),

92 : _(u"""
 pas de contraintes planes
"""),

96 : _(u"""
 Grandes d�formations GROT_GDEP requises pour le mat�riau ELAS_HYPER.
"""),

}
