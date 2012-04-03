#@ MODIF mecanonline9 Messages  DATE 02/04/2012   AUTEUR ABBAS M.ABBAS 
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
# RESPONSABLE DELMAS J.DELMAS

cata_msg = {

1 : _(u"""
   Arr�t par manque de temps CPU pendant les it�rations de Newton, au num�ro d'instant < %(i1)d >
      - Temps moyen par it�ration de Newton : %(r1)f
      - Temps CPU restant                   : %(r2)f
   Conseil:
      - Augmenter le temps CPU.   
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
"""),

2 : _(u"""
   Arr�t par manque de temps CPU au num�ro d'instant < %(i1)d >
      - Temps moyen par pas de temps        : %(r1)f
      - Temps CPU restant                   : %(r2)f
   Conseil:
      - Augmenter le temps CPU.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
"""),

3 : _(u"""
   Arr�t suite � l'�chec de l'int�gration de la loi de comportement.
   Conseils:
      - V�rifier vos param�tres, la coh�rence des unit�s.
      - Essayer d'augmenter ITER_INTE_MAXI, ou de subdiviser le pas de temps localement via ITER_INTE_PAS.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
"""),

4 : _(u"""
   Arr�t pour cause de matrice non inversible.
   Conseils:
      - V�rifier vos conditions limites.
      - V�rifier votre mod�le, la coh�rence des unit�s.
      - Si vous faites du contact, il ne faut pas que la structure ne "tienne" que par le contact.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
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
   Arr�t pour cause d'absence de convergence avec le nombre d'it�rations requis.
   Conseils:
   - Augmenter ITER_GLOB_MAXI.
   - R�actualiser plus souvent la matrice tangente.
   - Raffiner votre discr�tisation temporelle.
   - Essayer d'activer la gestion des �v�nements (d�coupe du pas de temps par exemple) dans la commande DEFI_LIST_INST.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
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
   Arr�t par �chec du traitement de la collision.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
"""),

13  : _(u"""
   Arr�t par d�tection d'instabilit� (mot-cl� CRIT_STAB dans STAT_NON_LINE / DYNA_NON_LINE).
   La charge critique correspondante est accessible de deux mani�res :
     - dans le fichier de message,
     - dans la SD r�sultat EVOL_NOLI, elle correspond au param�tre CHAR_CRIT.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
"""),

14 : _(u"""
   Arr�t par �chec de l'adaptation du coefficient de p�nalisation pour limiter l'interp�n�tration.
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
"""),

}
