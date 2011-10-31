#@ MODIF supervis Messages  DATE 31/10/2011   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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

cata_msg={

1 : _(u"""
 L'utilisation du mot-cl� PAR_LOT='NON' permet d'acc�der en lecture et en �criture
 au contenu des concepts Aster. De ce fait, votre �tude est exclue du p�rim�tre
 qualifi� de Code_Aster puisque toutes ses �tapes ne peuvent �tre certifi�es.

 Conseils :
   - Il n'y a pas particuli�rement de risque de r�sultat faux... sauf si votre
     programmation l'introduit.
   - Distinguez le calcul lui-m�me (qui doit sans doute passer en PAR_LOT='OUI')
     des post-traitements (qui n�cessiteraient le mode PAR_LOT='NON') qui peuvent
     �tre r�alis�s en POURSUITE.
"""),

2: _(u"""
 Arr�t sur erreur(s) utilisateur
"""),

3: _(u"""
 Erreur programmeur : %(k1)s non appari�s.
"""),

4: _(u"""
 Commande n  %(k1)s  :  "%(k2)s"  :   %(k3)s  erreur(s) d�tect�e(s)
"""),

5: _(u"""
 Erreur(s) � l'ex�cution de "%(k1)s" : arr�t imm�diat du programme.
"""),

7: _(u"""
 Le concept " %(k1)s " est inconnu.
 Il n'est ni parmi les cr��s, ni parmi ceux � cr�er.
"""),

8: _(u"""
 Un nom de concept interm�diaire doit commencer par '.' ou '_' et non :  %(k1)s
"""),

9: _(u"""
 Longueur nulle
"""),

10: _(u"""
   - le concept  "%(k1)s" est d�truit des bases de donn�es.
"""),

11: _(u"""
 Impossible d'allouer la m�moire JEVEUX demand�e : %(i1)d Mo.

 En g�n�ral, cette erreur se produit car la m�moire utilis�e hors du fortran
 (jeveux) est importante.

 Causes possibles :
   - le calcul produit de gros objets Python dans une macro-commande ou
     dans le jeu de commande lui-m�me,
   - le calcul appelle un solveur (MUMPS par exemple) ou un outil externe
     qui a besoin de m�moire hors jeveux,
   - utilisation de jeveux dynamique,
   - ...

 Solution :
   - distinguer la m�moire limite du calcul (case "M�moire totale" de astk)
     de la m�moire r�serv�e � jeveux (case "dont Aster"), le reste �tant
     disponible pour les allocations dynamiques.
"""),

12: _(u"""
 Ex�cution de JEVEUX en mode DEBUG
"""),

13: _(u"""
  %(k1)s  nom de base d�j� d�finie
"""),

14: _(u"""
  %(k1)s  statut impossible pour la base globale
"""),

15: _(u"""
 Probl�me d'allocation des bases de donn�es
"""),

16: _(u"""
  �criture des catalogues des �l�ments faite.
"""),

17: _(u"""
 Relecture des catalogues des �l�ments faite.
"""),

18: _(u"""
  Trop de catalogues (maximum = 10)
"""),

19: _(u"""
 D�but de lecture
"""),

20: _(u"""
  "%(k1)s" argument invalide du mot cl� "FICHIER" du mot cl� facteur "CATALOGUE"
"""),

21: _(u"""
  Erreur(s) fatale(s) lors de la lecture des catalogues
"""),

22 : { 'message' : _(u"""
   Les mots-cl�s facteurs CODE et DEBUG dans DEBUT/POURSUITE sont r�serv�s aux cas-tests.
   Il ne faut pas les utiliser dans les �tudes car ils modifient certaines valeurs par
   d�faut des commandes DEBUT/POURSUITE qui ont des cons�quences sur le comportement
   en cas d'erreur ou sur les performances.
"""), 'flags' : 'DECORATED',
},

23: _(u"""
 Debug JXVERI demand�
"""),

24: _(u"""
 Debug SDVERI demand�
"""),

25: _(u"""
 M�moire gestion : "COMPACTE"
 Ce mode de gestion peut augmenter sensiblement le temps syst�me de certaines commandes,
 les lectures/�critures sur les bases Jeveux �tant beaucoup plus fr�quentes
"""),

26: _(u"""
 Type allocation m�moire 2
"""),

27: _(u"""
 Type allocation m�moire 3
"""),

28: _(u"""
 Type allocation m�moire 4
"""),

31: _(u"""
 Valeur invalide pour le mot cl� RESERVE_CPU
"""),

32: _(u"""
 La proc�dure "%(k1)s" ne peut �tre appel�e en cours d'ex�cution des commandes
"""),

33: _(u"""
 Erreur fatale  **** appel � commande "superviseur".
"""),

34: _(u"""
 Arr�t de la lecture des commandes.
"""),

36: _(u"""
 Le concept de nom '%(k1)s' n'existe pas
"""),

38: _(u"""
 Il n'y a plus de temps pour continuer
"""),

39: _(u"""
Arr�t de l'ex�cution suite � la r�ception du signal utilisateur %(k1)s.
Fermeture des bases jeveux afin de permettre la POURSUITE ult�rieure du calcul.
"""),

40: _(u"""
 Vous utilisez une version dont les routines suivantes ont �t� surcharg�es :
   %(ktout)s
"""),

43: _(u"""
 Debug %(k1)s suspendu
"""),

44: _(u"""
 Debug %(k1)s demand�
"""),

50: _(u"""
 la commande a un num�ro non appelable dans cette version.
 le num�ro erron� est  %(i1)d
"""),

52: _(u"""
 fin de lecture (dur�e  %(r1)f  s.) %(k1)s
"""),

53: _(u"""
 vous ne pouvez utiliser plus de  %(i1)d
 niveaux de profondeur pour des appels par la proc�dure %(k1)s
"""),

56: _(u"""
 Incoh�rence entre le catalogue et le corps de la macro-commande.
"""),

60: _(u"""
 La proc�dure a un num�ro non appelable dans cette version.
 le num�ro erron� est %(i1)d.
"""),

61: _(u"""
  La commande a un num�ro non appelable dans cette version
  Le num�ro erron� est : %(i1)d
"""),

62: _(u"""
  Les messages d'erreurs pr�c�dent concerne la commande :
"""),

63: _(u"""
     ARRET PAR MANQUE DE TEMPS CPU
     Les commandes suivantes sont ignor�es, on passe directement dans FIN
     La base globale est sauvegard�e
     Temps consomm� de la r�serve CPU        :  %(r1).2f s\n
"""),

64: _(u"""
  Valeur initiale du temps CPU maximum =   %(i1)d secondes
  Valeur du temps CPU maximum pass� aux commandes =   %(i2)d secondes
  R�serve CPU pr�vue = %(i3)d secondes
"""),

65: _(u"""
   %(k1)s   %(k2)s   %(k3)s   %(k4)s
"""),

66: _(u"""
   %(k1)s   %(k2)s   %(k3)s   %(k4)s   %(k5)s
"""),

67: _(u"""
 Passage num�ro %(i1)d
"""),

68: _(u"""
 information sur les concepts devant �tre cr��s.
"""),

71: _(u"""
 rappel sur les ex�cutions pr�c�dentes
   - il a �t� ex�cut� %(i1)d proc�dures et op�rateurs.
"""),

72: _(u"""
   - l'ex�cution pr�c�dente s'est termin�e correctement.
"""),

73: _(u"""

   - l'ex�cution pr�c�dente s'est termin�e en erreur dans la proc�dure %(k1)s.
"""),

74: _(u"""

   - l'ex�cution pr�c�dente s'est termin�e en erreur dans l'op�rateur %(k1)s.
"""),

75: _(u"""
     le concept %(k1)s de type %(k2)s  est peut-�tre erron�.
"""),

76: _(u"""
   - l'ex�cution pr�c�dente s'est termin�e pr�matur�ment dans l'op�rateur %(k1)s.
"""),

77: _(u"""
     le concept %(k1)s de type %(k2)s a �t� n�anmoins valid� par l'op�rateur
"""),

78: _(u"""
     Message attach� au concept  %(k1)s
"""),

79: _(u"""
     Pas de message attach� au concept %(k1)s
"""),

81: _(u"""
 %(k1)s nom symbolique inconnu
  - nombre de valeurs attendues %(i1)d
  - valeurs attendues : %(k1)s, %(k2)s,...
"""),

82: _(u"""
 L'argument du mot cl� "CAS" est erron�.
 Valeur lue %(k1)s
 nombre de valeurs attendues %(i1)d
 valeurs attendues : %(k1)s,%(k2)s, ...
"""),

83: _(u"""

 Le nombre d'enregistrements (NMAX_ENRE) et leurs longueurs (LONG_ENRE) conduisent � un
 fichier dont la taille maximale en Mo (%(i1)d) est sup�rieure � limite autoris�e :  %(i2)d

 Vous pouvez augmenter cette limite en utilisant l'argument "-max_base" sur la ligne
 de commande suivi d'une valeur en Mo.

"""),

85: _(u"""
 information sur les concepts existants.
"""),

86: _(u"""
 Erreur � la relecture du fichier pick.1 : aucun objet sauvegard� ne sera r�cup�r�.
"""),

87: _(u"""
Types incompatibles entre glob.1 et pick.1 pour le concept de nom %(k1)s.
"""),

88: _(u"""
Concept de nom %(k1)s et de type %(k2)s introuvable dans la base globale"
"""),

89: _(u"""
 Il n'y a pas de fichier glob.1 ou bhdf.1 dans le r�pertoire courant.

Conseils:
   - V�rifiez que vous avez une base (de type base ou bhdf) dans votre �tude.
   - V�rifiez si elle doit �tre d�compress�e ou pas.
"""),

93 : _(u"""
La variable python "%(k1)s" fait r�f�rence au concept "%(k2)s".
Cela se produit avec ce type d'encha�nement :
   %(k2)s = COMMANDE(...)
   %(k1)s = %(k2)s

On d�truit cette variable ("%(k1)s" dans l'exemple ci-dessus).

-> Conseil :
   Pour �viter cette alarme, supprimer la r�f�rence dans le jeu de commandes
   qui produit la base :
      %(k1)s
"""),

94 : _(u"""
Le temps CPU syst�me (%(r1).1f) atteint une valeur sup�rieure � %(i1)d%% du temps CPU (%(r2).1f).
Ce comportement est peut-�tre anormal.
Le nombre d'appel au m�canisme de d�chargement de la m�moire depuis le d�but du
calcul est de %(i2)d.

-> Conseil :
   Augmenter la m�moire JEVEUX peut permettre de diminuer le temps syst�me.

"""),

95 : _(u"""
Le temps CPU syst�me (%(r1).1f) atteint une valeur sup�rieure � %(i1)d%% du temps CPU (%(r2).1f).
Ce comportement est peut-�tre anormal.

"""),

96 : { 'message' : _(u"""

    R�ception du signal USR1. Interruption du calcul demand�e...

"""), 'flags' : 'DECORATED',
},

97 : { 'message' : _(u"""

    Interruption du calcul suite � la r�ception d'un <Control-C>.

"""), 'flags' : 'DECORATED',
},

}
