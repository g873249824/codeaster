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

2 : _(u"""
 la m�thode de Newmark est programm�e sous sa forme implicite:
 le param�tre BETA ne doit pas �tre nul.
 """),

4 : _(u"""
 valeur de THETA illicite
"""),

5 : _(u"""
 la charge  %(k1)s  n'est pas thermique
"""),

7 : _(u"""
 la charge  %(k1)s  n'est pas compatible avec FONC_MULT
"""),

10 : _(u"""
 nombre de vecteurs demand� trop grand
 on prend tous les modes du concept MODE_MECA
"""),

12 : _(u"""
 La borne inf�rieure est incorrecte.
"""),

15 : _(u"""
 Le pas (%(r3)f) est plus grand que l'intervalle [%(r1)f, %(r2)f].
"""),

16 : _(u"""
 Le pas est nul.
"""),

17 : _(u"""
 Le nombre de pas est n�gatif.
"""),

18 : _(u"""
 Les matrices assembl�es g�n�ralis�es doivent avoir un stockage plein (cf. NUME_DDL_GENE)
"""),

19 : _(u"""
 COEF_VAR_AMOR non nul et amortissement non pr�sent
"""),

26 : _(u"""
 le mod�le est obligatoire
"""),

27 : _(u"""
 impossible de combiner les mots cl�s CHARGE et VECT_ASSE en dehors des ondes planes
"""),

28 : _(u"""
 concept r�entrant : "RESULTAT" doit porter le m�me nom que la sortie
"""),

29 : _(u"""
 concept r�entrant : "RESULTAT" est d'un type diff�rent
"""),

30 : _(u"""
 argument en double pour "NOM_CHAM"
"""),

34 : _(u"""
 les matrices ne poss�dent pas toutes la m�me num�rotation
"""),

39 : _(u"""
 base modale et MATR_ASSE avec num�rotations diff�rentes
"""),

40 : _(u"""
  type de matrice inconnu:  %(k1)s
"""),

41 : _(u"""
 base modale et VECT_ASSE avec  num�rotations diff�rentes
"""),

42 : _(u"""
 la base constitu�e ne forme pas une famille libre
"""),

43 : _(u"""
 le nombre de valeurs doit �tre pair.
"""),

44 : _(u"""
 trop d'arguments pour "NOM_CHAM"
"""),

45 : _(u"""
 pour calculer une ACCE_ABSOLU, il faut "ACCE_MONO_APPUI"
"""),

46 : _(u"""
 pour restituer sur un squelette, il faut "MODE_MECA"
"""),

47 : _(u"""
 mots-cl�s 'SOUS_STRUC' et 'SQUELETTE' interdits
"""),

48 : _(u"""
 le mot-cl� 'MODE_MECA' doit �tre pr�sent
"""),

49 : _(u"""
 l'instant de r�cup�ration est en dehors du domaine de calcul.
"""),

50 : _(u"""
 la fr�quence  de r�cup�ration n'a pas �t� calcul�e.
"""),

51 : _(u"""
 Vous avez demand� de restituer sur une fr�quence (mot-cl� FREQ) pour un concept transitoire
 sur base g�n�ralis�e. Pour ce type de concept vous devez utiliser le mot-cl� 'INST'.
"""),
52 : _(u"""
 Vous avez demand� de restituer sur un instant (mot-cl� INST) pour un concept harmonique
 sur base g�n�ralis�e. Pour ce type de concept vous devez utiliser le mot-cl� 'FREQ'.
"""),

55 : _(u"""
 mauvaise d�finition de l'interspectre.
"""),

56 : _(u"""
 le "NB_PTS" doit �tre une puissance de 2.
"""),

57 : _(u"""
 si les mots-cl�s NUME_ORDRE et AMOR_REDUIT sont utilis�s,
 il faut autant d'arguments pour l'un et l'autre
"""),

58 : _(u"""
 le concept MODE_MECA d'entr�e doit �tre celui correspondant � la base modale initiale
 pour le calcul de couplage fluide-structure
"""),

60 : _(u"""
 tous les modes non coupl�s �tant retenus, le nombre d'arguments valide
 pour le mot-cl� AMOR_REDUIT est la diff�rence entre le nombre de modes
 de la base modale initiale et le nombre de modes pris en compte pour
 le couplage fluide-structure
"""),

61 : _(u"""
 les num�ros d'ordre fournis ne correspondent pas � des modes non perturb�s
"""),

62 : _(u"""
 option sym�trie : la dimension de POINT et AXE_1 doit �tre identique.
"""),

63 : _(u"""
 option sym�trie : AXE_2 est inutile en 2D, il est ignor�.
"""),

64 : _(u"""
 option sym�trie : la dimension de POINT et AXE_2 doit �tre identique.
"""),




69 : _(u"""
 on ne sait pas traiter le champ de type:  %(k1)s
 champ :  %(k2)s
"""),

74 : _(u"""
 attention, mode sur amorti
"""),

75 : _(u"""
 attention, mode instable
"""),

80 : _(u"""
 pour utiliser le comportement "HYDR", il faut surcharger le code
 en "mode d�veloppement" avec les routines "PERMEA" et "SATURA".
"""),

81 : _(u"""
 le vecteur directeur est nul.
"""),

84 : _(u"""
 pr�cision machine d�pass�e
"""),











91 : _(u"""
 le nombre de noeuds mesur� doit �tre inf�rieur au nombre de noeuds du mod�le
"""),

92 : _(u"""
 maille SEG2 non trouv�e
"""),

93 : _(u"""
 int�gration �lastoplastique de loi BETON_DOUBLE_DP :
 pas de convergence lors de la projection au sommet des c�nes de traction et de compression
 --> utiliser le red�coupage automatique du pas de temps.
"""),

94 : _(u"""
 int�gration �lastoplastique de loi BETON_DOUBLE_DP :
 pas de convergence lors de la r�solution pour NSEUIL =  %(k1)s
 --> utiliser le red�coupage automatique du pas de temps.
"""),

95 : _(u"""
 non convergence � la maille:  %(k1)s
"""),

96 : _(u"""
 la saturation n'est pas une variable interne pour la loi de couplage  %(k1)s
"""),

97 : _(u"""
 la pression de vapeur n'est pas une variable interne pour la loi de couplage  %(k1)s
"""),

99 : _(u"""
 la variable  %(k1)s  n'existe pas dans la loi CJS en 2D
"""),

100 : _(u"""
 Vous ne pouvez pas m�langer deux mod�lisations avec et sans d�pendance
des param�tres mat�riau � la temp�rature (mots-cl�s ELAS, ELAS_FO).
"""),

}
