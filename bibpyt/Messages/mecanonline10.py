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
# Attention a ne pas faire de retour � la ligne !

cata_msg = {

1  : _(u"""
 <Erreur> �chec dans l'int�gration de la loi de comportement
"""),

2 : _(u"""
 <Erreur> �chec dans le pilotage
"""),

3 : _(u"""
 <Erreur> Le nombre maximum d'it�rations de Newton est atteint
"""),

4 : _(u"""
 <Erreur> �chec dans le traitement du contact discret
"""),

5 : _(u"""
 <Erreur> Il n'y a pas assez de temps CPU pour continuer les pas de temps
"""),

6 : _(u"""
 <Erreur> La matrice du syst�me est singuli�re
"""),

7 : _(u"""
 <Erreur> Il n'y a pas assez de temps CPU pour continuer les it�rations de Newton
"""),

8 : _(u"""
 <Erreur> Arr�t demand� par l'utilisateur.
"""),

9 : _(u"""
 <Erreur> On d�passe le nombre de boucles de point fixe de g�om�trie.
 """),

10 : _(u"""
 <Erreur> On d�passe le nombre de boucles de point fixe de frottement.
 """),

11 : _(u"""
 <Erreur> On d�passe le nombre de boucles de point fixe de contact.
 """),

12 : _(u"""
 <Erreur> Nombre maximum d'it�rations atteint dans le solveur lin�aire it�ratif.
 """),

20 : _(u"""
 <�v�nement> Instabilit� d�tect�e.
 """),

21 : _(u"""
 <�v�nement> Collision d�tect�e.
 """),

22 : _(u"""
 <�v�nement> Interp�n�tration d�tect�e.
 """),

23 : _(u"""
 <�v�nement> Divergence du r�sidu (DIVE_RESI).
 """),

24 : _(u"""
 <�v�nement> Valeur atteinte (DELTA_GRANDEUR).
 """),

25 : _(u"""
 <�v�nement> La loi de comportement est utilis�e en dehors de son domaine de validit� (VERI_BORNE).
 """),

30 : _(u"""
 <Action> On arr�te le calcul.
 """),

31 : _(u"""
 <Action> On essaie de r�actualiser le pr�conditionneur.
 """),

32: _(u"""
 <Action> On essaie d'autoriser des it�rations de Newton suppl�mentaires.
"""),

33: _(u"""
 <Action> On essaie de d�couper le pas de temps.
"""),

34 : _(u"""
 <Action> On essaie d'utiliser la solution de pilotage rejet�e initialement.
 """),

35 : _(u"""
 <Action> On essaie d'adapter le coefficient de p�nalisation.
 """),

40 : _(u""" <Action><�chec> On a d�j� r�actualis� le pr�conditionneur LDLT_SP."""),

41 : _(u""" <Action> On r�actualise le pr�conditionneur LDLT_SP."""),

42 : _(u""" <Action><�chec> On a d�j� choisi l'autre solution de pilotage."""),

43 : _(u""" <Action> On choisit l'autre solution de pilotage."""),

44 : _(u""" <Action><�chec> On ne peut plus adapter le coefficient de p�nalisation (on atteint COEF_MAXI)."""),

45 : _(u""" <Action> On a adapt� le coefficient de p�nalisation."""),

46 : _(u"""          Sur la zone <%(i1)d>, le coefficient de p�nalisation adapt� vaut <%(r1)13.6G>.
 """),

}
