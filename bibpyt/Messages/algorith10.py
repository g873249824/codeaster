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
 la variable  %(k1)s  n'existe pas dans la loi  %(k2)s
"""),

2 : _(u"""
 tailles de matrices incompatibles
"""),

10 : _(u"""
 taille produit matrice vecteur incompatible
"""),

11 : _(u"""
 le champ de d�placement n'a pas �t� calcul�
"""),

12 : _(u"""
 le champ de vitesse n'a pas �t� calcul�
"""),

13 : _(u"""
 le champ d'acc�l�ration n'a pas �t� calcule.
"""),

14 : _(u"""
 d�veloppement non pr�vu pour le MULT_APPUI ou CORR_STAT.
"""),

15 : _(u"""
 d�veloppement non pr�vu pour la sous-structuration.
"""),

16 : _(u"""
 dans le cas harmonique les seuls champs restituables sont 
 'DEPL', 'VITE' et 'ACCE'.
"""),

17 : _(u"""
 l'option  %(k1)s  s'applique sur toute la structure
"""),

20 : _(u"""
  le comportement :  %(k1)s  n'a pas �t� d�fini
"""),

21 : _(u"""
 DIST_REFE est obligatoire � la premi�re occurrence de RECO_GLOBAL
"""),

31 : _(u"""
 la bande de fr�quence retenue ne comporte pas de modes propres
"""),

32 : _(u"""
 vous avez demand� des modes qui ne sont pas calcul�s
"""),

33 : _(u"""
 il n y a pas de mode statique calcul� pour le couple (noeud, composante) ci dessus
"""),

35 : _(u"""
 red�coupage excessif du pas de temps interne
 r�duisez votre pas de temps ou augmenter ABS(ITER_INTE_PAS)
 red�coupage global.
"""),

40 : _(u"""
 vecteur nul entra�nant une division par z�ro dans NMCONV
"""),

41 : _(u"""
 incoh�rence de A ou H
"""),

42 : _(u"""
 incoh�rence de donn�es
"""),

43 : _(u"""
 incoh�rence de C, PHI ou A
"""),

44 : _(u"""
 champ 'DEPL' non calcul�
"""),

45 : _(u"""
 champ 'VITE' non calcul�
"""),

46 : _(u"""
 champ 'ACCE' non calcul�
"""),

47 : _(u"""
 lecture des instants erron�e
"""),

48 : _(u"""
 axe de rotation ind�fini.
"""),

49 : _(u"""
 la porosit� initiale F0 ne peut �tre nulle ou n�gative
"""),

50 : _(u"""
 la porosit� initiale F0 ne peut �tre sup�rieure ou �gale � 1.
"""),

51 : _(u"""
 comportement de ROUSSELIER version PETIT_REAC non implant� en contraintes planes
"""),

52 : _(u"""
 la porosit� initiale F0 ne peut �tre n�gative
"""),

56 : _(u"""
 on ne sait pas post-traiter le champ de type:  %(k1)s
"""),

60 : _(u"""
 taille vecteurs incompatible
"""),

61 : _(u"""
 il faut d�finir une BANDE ou un NUME_ORDRE
"""),

62 : _(u"""
 il faut d�finir une "BANDE" ou une liste de "NUME_ORDRE"
"""),

63 : _(u"""
 dimension spectrale fausse
"""),

64 : _(u"""
 l'interspectre modal est de type "ACCE"
 on ne peut que restituer une acc�l�ration
"""),

65 : _(u"""
 l'interspectre modal est de type "VITE"
 on ne peut que restituer une vitesse
"""),

66 : _(u"""
 l'interspectre modal est de type "DEPL"
 on ne peut pas restituer une acc�l�ration
"""),

67 : _(u"""
 l'interspectre modal est de type "DEPL"
 on ne peut pas restituer une vitesse
"""),

68 : _(u"""
 il faut autant de "NOEUD" que de "NOM_CMP"
"""),

69 : _(u"""
 il faut autant de "MAILLE" que de "NOEUD"
"""),

72 : _(u"""
 il faut d�finir une liste de mailles pour post-traiter un CHAM_ELEM
"""),

73 : _(u"""
 la composante  %(k1)s  du noeud  %(k2)s  pour la maille  %(k3)s  n'existe pas.
"""),

76 : _(u"""
 mot-cl� NB_BLOC inop�rant on prend un bloc
"""),

87 : _(u"""
 vecteur de norme trop petite
"""),

88 : _(u"""
 COMP_ELAS non implant�
"""),

90 : _(u"""
 la d�finition de la temp�rature est obligatoire
 pour une loi de couplage de type  %(k1)s
"""),


93 : _(u"""
 il faut un nom de champ
"""),

94 : _(u"""
 pas de champ autre que DEPL ou VITE ou ACCE
"""),

95 : _(u"""
 pour interpoler il faut fournir une liste de fr�quences ou instants.
"""),

96 : _(u"""
 calcul du transitoire: pas de solution trouv�e
 utiliser l'option ETAT_STAT = NON
"""),

97 : _(u"""
 dur�e de l'excitation trop courte pour le calcul du transitoire.
"""),

98 : _(u"""
 pivot nul
"""),

99 : _(u"""
 on ne sait pas encore traiter la sous structuration en axisym�trique
"""),

}
