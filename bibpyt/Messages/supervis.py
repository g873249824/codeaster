#@ MODIF supervis Messages  DATE 11/09/2007   AUTEUR DURAND C.DURAND 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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

cata_msg={

2: _("""
 Arret sur erreur(s) utilisateur
"""),

3: _("""
 Erreur programmeur : JEMARQ/JEDEMA non appari�s.
"""),

4: _("""
 Commande n  %(k1)s  :  "%(k2)s"  :   %(k3)s  erreur(s) d�tect�e(s)
"""),

5: _("""
 Erreur(s) � l'ex�cution de "%(k1)s" : arret imm�diat du programme.
"""),

6: _("""
 Fin � la suite de message(s) <E>
"""),

7: _("""
 Le concept " %(k1)s " est inconnu.
 Il n'est ni parmi les cr��s, ni parmi ceux � cr�er.
"""),

8: _("""
 Un nom de concept interm�diaire doit commencer par '.' ou '_' et non :  %(k1)s
"""),

9: _("""
 Longueur nulle
"""),

10: _("""
   - le concept  "%(k1)s" est d�truit des bases de donn�es.
"""),

11: _("""
 Impossible d'allouer la m�moire JEVEUX demand�e
"""),

12: _("""
 Ex�cution de JEVEUX en mode DEBUG
"""),

13: _("""
  %(k1)s  nom de base d�j� d�finie
"""),

14: _("""
  %(k1)s  statut impossible pour la base globale
"""),

15: _("""
 Probl�me d'allocation des bases de donn�es
"""),

16: _("""
  Ecriture des catalogues dans ELEMBASE faite.
"""),

17: _("""
 Relecture des catalogues dans ELEMBASE faite.
"""),

18: _("""
  Trop de catalogues (maximum = 10)
"""),

19: _("""
 Debut de lecture
"""),

20: _("""
  "%(k1)s" argument invalide du mot cl� "FICHIER" du mot cl� facteur "CATALOGUE"
"""),

21: _("""
  Erreur(s) fatale(s) lors de la lecture des catalogues
"""),

22: _("""
L'argument du mot cle "NOM" sous le mot cl� facteur "CODE" est tronqu� � 8 caract�res.
Le nom de code est donc "%(k1)s".
"""),

23: _("""
 Debug JXVERI demand�
"""),

24: _("""
 Debug SDVERI demand�
"""),

25: _("""
 M�moire gestion : "COMPACTE"
"""),

26: _("""
 Type allocation memoire 2
"""),

27: _("""
 Type allocation memoire 3
"""),

28: _("""
 Type allocation memoire 4
"""),

29: _("""
 Trop de noms d�finis dans la liste argument de "FICHIER"
"""),

30: _("""
  %(k1)s est d�j� (re-) d�fini
"""),

31: _("""
 Valeur invalide pour le mot cl� RESERVE_CPU
"""),

32: _("""
 La proc�dure "%(k1)s" ne peut etre appel�e en cours d'ex�cution des commandes
"""),

33: _("""
 Erreur fatale  **** appel � commande "superviseur".
"""),

34: _("""
 Arret de la lecture des commandes.
"""),

35: _("""
 La proc�dure "RETOUR" ne peut etre utilis�e dans le fichier principal de commandes.
"""),

36: _("""
 Le concept de nom '%(k1)s' n'existe pas
"""),

38: _("""
 Il n'y a plus de temps pour continuer
"""),

39: _("""
 Arret de l'ex�cution et fermeture des bases jeveux
"""),

40: _("""
 Vous utilisez une version dont les routines suivantes ont �t� surcharg�es :
   %(ktout)s
"""),

41 : _("""
Le message d'alarme '%(k1)s' a �t� �mis %(i1)d fois, il ne sera plus affich�.
"""),

43: _("""
 Debug SDVERI suspendu
"""),

44: _("""
 Debug JEVEUX demand�
"""),

45: _("""
 Debug JEVEUX suspendu
"""),

47: _("""
 Debug JXVERI suspendu
"""),

48: _("""
 Debug IMPR_MACRO demand�
"""),

49: _("""
 Debug IMPR_MACRO suspendu
"""),

50: _("""
 la commande a un num�ro non appelable dans cette version.
 le numero erron� est  %(i1)d 
"""),

52: _("""
 fin de lecture (dur�e  %(r1)f  s.) %(k1)s 
"""),

53: _("""
 vous ne pouvez utiliser plus de  %(i1)d 
 niveaux de profondeur pour des appels par la proc�dure %(k1)s 
"""),

55: _("""
 Appels r�cursifs de messages d'erreur ou d'alarme.
"""),

56: _("""
 Incoh�rence entre le catalogue et le corps de la macro.
"""),

57: _("""
   Impossible d'importer '%(k1)s' dans Messages.
   Le fichier %(k1)s.py n'existe pas dans le r�pertoire 'Messages'
   ou bien la syntaxe du fichier est incorrecte.
   
   Merci de signaler cette anomalie.
   
   Traceback :
   %(k2)s
"""),

58: _("""
 valeur initiale du temps CPU maximum =   %(i1)d secondes 
"""),

59: _("""
 valeur du temps CPU maximum pass� aux commandes =   %(i1)d secondes 
"""),

60: _("""
 la proc�dure a un num�ro non appelable dans cette version.
 le numero errone est  %(i1)d 
"""),

61: _("""
  La commande a un num�ro non appelable dans cette version
  Le num�ro erron� est : %(i1)d 
"""),

62: _("""
  Les messages d'erreurs pr�c�dent concerne la commande :
"""),

63: _("""
     ARRET PAR MANQUE DE TEMPS CPU
     Les commandes suivantes sont ignorees, on passe directement dans FIN
     La base globale est sauvegardee
     Temps consomme de la reserve CPU        :  %(r1).2f s\n
"""),

64: _("""
  R�serve CPU pr�vue = %(i1)d secondes
"""),

}
