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
   Arr�t par manque de temps CPU pendant les it�rations de Newton, au num�ro d'instant < %(i1)d >
      - Temps moyen par it�ration de Newton : %(r1)f
      - Temps CPU restant                   : %(r2)f
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.

   Conseil :
      - Augmentez le temps CPU.
"""),

2 : _(u"""
   Arr�t par manque de temps CPU au num�ro d'instant < %(i1)d >
      - Temps moyen par pas de temps        : %(r1)f
      - Temps CPU restant                   : %(r2)f
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.

   Conseil :
      - Augmentez le temps CPU.
"""),

3 : _(u"""
   Arr�t suite � l'�chec de l'int�gration de la loi de comportement.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.

   Conseils :
      - V�rifiez vos param�tres, la coh�rence des unit�s.
      - Essayez d'augmenter ITER_INTE_MAXI, ou de subdiviser le pas de temps localement via ITER_INTE_PAS.
"""),

4 : _(u"""
   Arr�t pour cause de matrice non inversible.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.

   Conseils :
      - V�rifiez vos conditions aux limites.
      - V�rifiez votre mod�le, la coh�rence des unit�s.
      - Si vous faites du contact, il ne faut pas que la structure ne "tienne" que par le contact.
"""),

5 : _(u"""
   Arr�t pour cause d'�chec lors du traitement du contact discret.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
"""),

6 : _(u"""
   Arr�t pour cause de matrice de contact singuli�re.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
"""),

7 : _(u"""
   Arr�t pour cause d'absence de convergence avec le nombre d'it�rations requis dans l'algorithme non-lin�aire de Newton.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.

   Conseils :
   - Augmentez ITER_GLOB_MAXI.
   - R�actualisez plus souvent la matrice tangente.
   - Raffinez votre discr�tisation temporelle.
   - Essayez d'activer la gestion des �v�nements (d�coupe du pas de temps par exemple) dans la commande DEFI_LIST_INST.
"""),

8  : _(u"""
   Arr�t par �chec dans le pilotage.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
"""),

9  : _(u"""
   Arr�t par �chec dans la boucle de point fixe sur la g�om�trie.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
"""),

10  : _(u"""
   Arr�t par �chec dans la boucle de point fixe sur le seuil de frottement.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
"""),

11  : _(u"""
   Arr�t par �chec dans la boucle de point fixe sur le statut de contact.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
"""),

12 : _(u"""
   Arr�t pour cause d'absence de convergence avec le nombre d'it�rations requis dans le solveur lin�aire it�ratif.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.

   Conseils :
   - Si vous utilisez le pr�conditionneur LDLT_SP, activez la r�actualisation en cas d'�chec (ACTION='REAC_PRECOND' dans DEFI_LIST_INST).
   - Augmentez le nombre maximum d'it�rations (NMAX_ITER).
   - Utilisez un pr�conditionneur plus pr�cis ou changez d'algorithme.
"""),

50 : _(u"""Arr�t par �chec de l'action <%(k1)s>  pour le traitement de l'�v�nement <%(k2)s>. """),
51 : _(u"""Arr�t demand� pour le d�clenchement de l'�v�nement <%(k1)s>. """),

}
