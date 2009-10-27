#@ MODIF algorith9 Messages  DATE 26/10/2009   AUTEUR ABBAS M.ABBAS 
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
 le champ de temp�rature : TEMP_INIT(NUM_INIT) n'existe pas.
"""),

2 : _("""
 CHAM_NO invalide
"""),

4 : _("""
 valeur de THETA illicite
"""),

5 : _("""
 la charge  %(k1)s  n'est pas thermique
"""),

7 : _("""
 la charge  %(k1)s  n'est pas compatible avec FONC_MULT
"""),

10 : _("""
 nombre de vecteurs demand� trop grand
 on prend tous les modes du concept MODE_MECA 
"""),

12 : _("""
 borne inf�rieure incorrecte
"""),

16 : _("""
 le pas est nul
"""),

17 : _("""
 le nombre de pas est n�gatif
"""),

18 : _("""
 les matrices assembl�es g�n�ralis�es doivent avoir un stockage plein (cf. NUME_DDL_GENE)
"""),

19 : _("""
 COEFF_VAR_AMOR non nul et amortissement non pr�sent
"""),

24 : _("""
 charge de contact non trait�e
"""),

25 : _("""
 votre chargement contient plus d'une charge r�partie
 le calcul n'est pas possible pour les mod�les de poutre
"""),

26 : _("""
 le mod�le est obligatoire
"""),

27 : _("""
 impossible de combiner les mots cles CHARGE et VECT_ASSE en dehors des ondes planes
"""),

28 : _("""
 concept r�entrant : "RESULTAT" doit porter le meme nom que la sortie
"""),

29 : _("""
 concept r�entrant : "RESULTAT" est d'un type diff�rent
"""),

30 : _("""
 argument en double pour "NOM_CHAM"
"""),

34 : _("""
 les matrices ne poss�dent pas toutes la meme num�rotation 
"""),

35 : _("""
  un VECT_ASSE n'est ni � valeurs r�elles, ni � valeurs complexes.
"""),

39 : _("""
 base modale et MATR_ASSE avec num�rotations diff�rentes
"""),

40 : _("""
  type de matrice inconnu:  %(k1)s 
"""),

41 : _("""
 base modale et VECT_ASSE avec  num�rotations diff�rentes
"""),

42 : _("""
 la base constitu�e ne forme pas une famille libre 
"""),

43 : _("""
 le nombre de valeurs doit etre pair.
"""),

44 : _("""
 trop d'arguments pour "NOM_CHAM"
"""),

45 : _("""
 pour calculer une ACCE_ABSOLU, il faut "ACCE_MONO_APPUI"
"""),

46 : _("""
 pour restituer sur un squelette, il faut "MODE_MECA"
"""),

47 : _("""
 mots-cles'SOUS_STRUC' et'SQUELETTE'interdits
"""),

48 : _("""
 le mot-cl� 'MODE_MECA' doit etre pr�sent
"""),

49 : _("""
 l'instant de r�cuperation est en dehors du domaine de calcul.
"""),

50 : _("""
 pas de mailles fournies
"""),

55 : _("""
 mauvaise d�finition de l'interspectre.
"""),

56 : _("""
 le "NOMB_PTS" doit etre une puissance de 2.
"""),

57 : _("""
 si les mots-cles NUME_ORDRE et AMOR_REDUIT sont utilis�s,
 il faut autant d'arguments pour l'un et l'autre
"""),

58 : _("""
 le concept MODE_MECA d'entr�e doit etre celui correspondant � la base modale initiale
 pour le calcul de couplage fluide-structure
"""),

60 : _("""
 tous les modes non coupl�s �tant retenus, le nombre d'arguments valide
 pour le mot-cl� AMOR_REDUIT est la diff�rence entre le nombre de modes
 de la base modale initiale et le nombre de modes pris en compte pour
 le couplage fluide-structure
"""),

61 : _("""
 les num�ros d'ordre fournis ne correspondent pas � des modes non perturb�s
"""),

62 : _("""
 option sym�trie : la dimension de POINT et AXE_1 doit etre identique.
"""),

63 : _("""
 option sym�trie : AXE_2 est inutile en 2D, il est ignor�.
"""),

64 : _("""
 option sym�trie : la dimension de POINT et AXE_2 doit etre identique.
"""),

65 : _("""
 m�thode: ELEM autoris�e seulement pour les r�sultats EVOL_XXX.
"""),

66 : _("""
 methode: NUAGE_DEG__* autoris�e seulement pour les champs.
"""),

69 : _("""
 on ne sait pas traiter le champ de type:  %(k1)s
 champ :  %(k2)s 
"""),

74 : _("""
 attention, mode sur-amorti
"""),

75 : _("""
 attention, mode instable
"""),

80 : _("""
 pour utiliser le comportement "HYDR", il faut surcharger le code
 en "mode dev�loppement" avec les routines "PERMEA" et "SATURA".
"""),

81 : _("""
 le vecteur directeur est nul.
"""),

83 : _("""
 nombre maximum d'it�rations atteint
"""),

84 : _("""
 pr�cision machine depass�e
"""),

85 : _("""
 probl�me pilo : 3 solutions ou plus
"""),

86 : _("""
 matrice mat non inversible
"""),

87 : _("""
 probl�me pilo
"""),

88 : _("""
 loi de comportement non disponible pour le pilotage
"""),

89 : _("""
 le pilotage PRED_ELAS n�cessite ETA_PILO_MIN et ETA_PILO_MAX
 pour la loi ENDO_ISOT_BETON
"""),

90 : _("""
 le pilotage PRED_ELAS n�cessite ETA_PILO_MIN et ETA_PILO_MAX
 pour la loi ENDO_ORTH_BETON
"""),

91 : _("""
 le nombre de noeuds mesur� doit etre inf�rieur au nombre de noeuds du mod�le
"""),

92 : _("""
 maille SEG2 non trouv�e
"""),

93 : _("""
 int�gration �lastoplastique de loi BETON_DOUBLE_DP :
 pas de convergence lors de la projection au sommet des cones de traction et de compression
 --> utiliser le red�coupage automatique du pas de temps.
"""),

94 : _("""
 int�gration �lastoplastique de loi BETON_DOUBLE_DP :
 pas de convergence lors de la resolution pour NSEUIL =  %(k1)s
 --> utiliser le red�coupage automatique du pas de temps.
"""),

95 : _("""
 non convergence � la maille:  %(k1)s 
"""),

96 : _("""
 la saturation n'est pas une variable interne pour la loi de couplage  %(k1)s 
"""),

97 : _("""
 la pression de vapeur n'est pas une variable interne pour la loi de couplage  %(k1)s 
"""),

99 : _("""
 la variable  %(k1)s  n'existe pas dans la loi CJS en 2D
"""),

}
