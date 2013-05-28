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
 La mod�lisation C_PLAN n'est pas compatible avec la loi de comportement ELAS_VMIS_PUIS.
"""),

3 : _(u"""
 type de matrice inconnu.
"""),

10 : _(u"""
 impossible de diagonaliser la matrice de raideur en choc
"""),

11 : _(u"""
 PULS(I) = 0.
 initialisation � PULS0(I).
"""),

13 : _(u"""
 le VECT_ELEM n'existe pas :  %(k1)s
"""),

16 : _(u"""
 les charges cin�matiques sont pour l'instant proscrites avec FETI
"""),

21 : _(u"""
 le noeud  %(k1)s  n'appartient pas au maillage :  %(k2)s
"""),

25 : _(u"""
 donn�es incompatibles.
"""),

32 : _(u"""
  la num�rotation n'est pas coh�rente avec le mod�le g�n�ralis�
  si vous avez activ� l'option INITIAL dans NUME_DDL_GENE faites de m�me ici !
"""),

33 : _(u"""
 calcul des options RIGI_MECA_TANG, RAPH_MECA et FULL_MECA
 en m�canique des milieux poreux avec couplage THM
 ---> erreur de dimensionnement
"""),

34 : _(u"""
 il y a incoh�rence entre :
    la loi de couplage de DEFI_MATERIAU : %(k1)s
 et la loi de couplage de STAT_NON_LINE : %(k2)s
"""),

35 : _(u"""
 les champs " %(k1)s " et " %(k2)s " n'ont pas le m�me domaine de d�finition.
"""),

36 : _(u"""
 BARSOUM, erreur dans le traitement des mailles %(k1)s
"""),

42 : _(u"""
 BETON_DOUBLE_DP: incr�ment de d�formation plastique en traction n�gatif
 --> red�coupage automatique du pas de temps
"""),

43 : _(u"""
 BETON_DOUBLE_DP: incr�ment de d�formation plastique en compression n�gatif
 --> red�coupage automatique du pas de temps
"""),

44 : _(u"""
 int�gration �lastoplastique de la loi BETON_DOUBLE_DP :
 la condition d'applicabilit� sur la taille des �l�ments
 n'est pas respect�e en compression.
"""),

45 : _(u"""
 int�gration �lastoplastique de la loi BETON_DOUBLE_DP :
 la condition d'applicabilit� sur la taille des �l�ments
 n'est pas respect�e en compression pour la maille:  %(k1)s
"""),

46 : _(u"""
 int�gration �lastoplastique de la loi BETON_DOUBLE_DP :
 la condition d'applicabilit� sur la taille des �l�ments
 n est pas respect�e en traction.
"""),

47 : _(u"""
 int�gration �lastoplastique de la loi BETON_DOUBLE_DP :
 la condition d'applicabilit� sur la taille des �l�ments
 n'est pas respect�e en traction pour la maille:  %(k1)s
"""),

48 : _(u"""
  -> Int�gration �lastoplastique de loi multicrit�res BETON_DOUBLE_DP :
     la contrainte �quivalente est nulle pour la maille %(k1)s
     le calcul de la matrice tangente est impossible.
  -> Risque & Conseil :
"""),

51 : _(u"""
 BETON_DOUBLE_DP:
 le cas des contraintes planes n'est pas trait� pour ce mod�le.
"""),

52 : _(u"""
  Le nombre de modes et de degr� de libert� d'interface sont diff�rents.
"""),

53 : _(u"""
  Le nombre de modes dynamiques est %(i1)d,
  ce n'est pas un multiple du nombre de composante.
"""),

54 : _(u"""
  Le nombre de modes statiques est %(i1)d,
  ce n'est pas un multiple du nombre de composante.
"""),





60 : _(u"""
 certains coefficients de masse ajout�e sont n�gatifs.
 v�rifiez l'orientation des normales des �l�ments d'interface.
 convention adopt�e : structure vers fluide
"""),

61 : _(u"""
 certains coefficients d'amortissement ajout� sont n�gatifs.
 possibilit� d'instabilit� de flottement
"""),

62 : _(u"""
 erreur dans le calcul des valeurs propres de la matrice de raideur
"""),

63 : _(u"""
 valeurs propres de la matrice de raideur non r�elles
"""),

64 : _(u"""
 valeurs propres de la matrice de raideur r�elles n�gatives
"""),

65 : _(u"""
 erreur dans la s�lection des valeurs propres de la matrice de raideur
"""),

66 : _(u"""
 tailles des matrices incompatibles pour calcul matrice diagonale
"""),

67 : _(u"""
 option SECANTE non valide
"""),

68 : _(u"""
 trop de familles de syst�mes de glissement.
 augmenter la limite actuelle (5)
"""),

69 : _(u"""
 trop de familles de syst�mes de glissement.
 modifier GERPAS
"""),

70 : _(u"""
 Le nombre de syst�me de glissement est �gal � 0
"""),

71 : _(u"""
 tailles incompatibles pour le produit matrice * vecteur
"""),

72 : _(u"""
 traitement non pr�vu pour le type d'obstacle demand�
"""),

73 : _(u"""
 obstacle de type discret mal d�fini (un angle est sup�rieur � pi).
"""),

96 : _(u"""
 ce mot cl� de MODI_MAILLAGE attend un vecteur de norme non nulle.
"""),

97 : _(u"""
 le mot cl� REPERE de MODI_MAILLAGE attend deux vecteurs non nuls orthogonaux.
"""),

}
