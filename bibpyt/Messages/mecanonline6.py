#@ MODIF mecanonline6 Messages  DATE 02/04/2012   AUTEUR ABBAS M.ABBAS 
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

1 : _(u"""
 Instant de calcul: %(r1)19.12e - Niveau de d�coupe: %(i1)d
"""),

2 : _(u"""
 Post-traitement: calcul d'un mode de flambement
"""),

3 : _(u"""
 Post-traitement: calcul d'un mode vibratoire
"""),

4 : _(u"""
 La gestion automatique du pas de temps (DEFI_LIST_INST/METHODE='AUTO')
 avec le sch�ma IMPLEX (DEFI_LIST_INST/MODE_CALCUL_TPLUS='IMPLEX') n�cessite
 de traiter la r�solution par la m�thode IMPLEX (STAT/DYNA_NON_LINE/METHODE='IMPLEX').
 Conseil :
   - Choisissez STAT/DYNA_NON_LINE/METHODE='IMPLEX'
   - ou bien choisissez un autre sch�ma d'adaptation du pas de temps (DEFI_LIST_INST/MODE_CALCUL_TPLUS).
 """),

5 : _(u"""
 Nombre total de noeuds esclaves pour le contact: %(i1)d
"""),

6 : _(u"""
 Instant de calcul: %(r1)19.12e
"""),

10 : _(u"""
  Le mode vibratoire de num�ro d'ordre %(i1)d a pour fr�quence %(r1)19.12e
"""),

11 : _(u"""
  Le mode de flambement de num�ro d'ordre %(i1)d a pour charge critique %(r1)19.12e
"""),

12 : _(u"""
  Le mode de stabilit� de num�ro d'ordre %(i1)d a pour charge critique %(r1)19.12e
"""),

29 : _(u"""
 <Erreur> �chec dans l'int�gration de la loi de comportement
"""),

30 : _(u"""
 <Erreur> �chec dans le pilotage
"""),

31 : _(u"""
 <Erreur> Le nombre maximum d'it�rations de Newton est atteint
"""),

32 : _(u"""
 <Erreur> �chec dans le traitement du contact discret
"""),

33 : _(u"""
 <Erreur> Il n'y a pas assez de temps CPU pour continuer les pas de temps
"""),

34 : _(u"""
 <Erreur> La matrice du syst�me est singuli�re
"""),

35 : _(u"""
 <Erreur> Il n'y a pas assez de temps CPU pour continuer les it�rations de Newton
"""),

36 : _(u"""
 <Erreur> Arr�t demand� par l'utilisateur.
"""),

37 : _(u"""
 <Erreur> On d�passe le nombre de boucles de point fixe de g�om�trie.
 """),

38 : _(u"""
 <Erreur> On d�passe le nombre de boucles de point fixe de frottement.
 """),

39 : _(u"""
 <Erreur> On d�passe le nombre de boucles de point fixe de contact.
 """),

40 : _(u"""
 <Erreur> Instabilit� d�tect�e.
 """),

41 : _(u"""
 <Erreur> Collision d�tect�e.
 """),

42 : _(u"""
 <Erreur> Interp�n�tration d�tect�e.
 """),

50 : _(u"""
 <Action> On recommence le pas de temps en utilisant la solution de pilotage rejet�e initialement.
 """),

51 : _(u"""
 <Action> On arr�te le calcul.
 """),

52 : _(u"""
 <Action> On recommence le pas de temps en ayant adapt� le coefficient de p�nalisation.
 """),

53 : _(u"""
 <Erreur> On ne peut plus adapter le coefficient de p�nalisation (on atteint COEF_MAXI).
 """),

54 : _(u"""
          Sur la zone <%(i1)d>, le coefficient de p�nalisation adapt� vaut <%(r1)13.6G>.
 """),

60 : _(u"""
  Crit�re(s) de convergence atteint(s)
"""),

61 : _(u"""
      Attention ! Convergence atteinte avec RESI_GLOB_RELA car on est au premier instant avec RESI_COMP_RELA.
"""),

62 : _(u"""
      Attention ! Convergence atteinte avec RESI_GLOB_MAXI au lieu de RESI_GLOB_RELA pour cause de chargement presque nul.
"""),

70 : _(u"""    Le r�sidu de type <%(k1)s> vaut %(r1)19.12e au noeud et degr� de libert� <%(k2)s>"""),


}
