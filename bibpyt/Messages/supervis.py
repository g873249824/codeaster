#@ MODIF supervis Messages  DATE 19/07/2010   AUTEUR LEFEBVRE J-P.LEFEBVRE 
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
# RESPONSABLE DELMAS J.DELMAS

def _(x) : return x

cata_msg={

1 : _("""
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
 Impossible d'allouer la m�moire JEVEUX demand�e : %(i1)d Moctets.

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

# on ne veut pas �mettre d'alarme mais que le message se voit, donc on fait la mise en forme ici !
22 : _("""
   !---------------------------------------------------------------------------------------!
   !                                                                                       !
   ! Les mot-cl�s facteurs CODE et DEBUG dans DEBUT/POURSUITE sont r�serv�s aux cas-tests. !
   ! Il ne faut pas les utiliser dans les �tudes car ils modifient certaines valeurs par   !
   ! d�faut des commandes DEBUT/POURSUITE qui ont des cons�quences sur le comportement     !
   ! en cas d'erreur ou sur les performances.                                              !
   !                                                                                       !
   !---------------------------------------------------------------------------------------!
"""),

23: _("""
 Debug JXVERI demand�
"""),

24: _("""
 Debug SDVERI demand�
"""),

25: _("""
 M�moire gestion : "COMPACTE"
 Ce mode de gestion peut augmenter sensiblement le temps syst�me de certaines commandes,
 les lectures/�critures sur les bases Jeveux �tant beaucoup plus fr�quentes
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

56: _("""
 Incoh�rence entre le catalogue et le corps de la macro.
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
  Valeur initiale du temps CPU maximum =   %(i1)d secondes
  Valeur du temps CPU maximum pass� aux commandes =   %(i2)d secondes
  R�serve CPU pr�vue = %(i3)d secondes
"""),

65: _("""
   %(k1)s   %(k2)s   %(k3)s   %(k4)s
"""),

66: _("""
   %(k1)s   %(k2)s   %(k3)s   %(k4)s   %(k5)s
"""),

67: _("""
 Passage num�ro %(i1)d
"""),

68: _("""
 information sur les concepts devant etre cr��s.
"""),

71: _("""
 rappel sur les executions pr�c�dentes
   - il a ete execut� %(i1)d proc�dures et op�rateurs.
"""),

72: _("""
   - l'execution pr�c�dente s'est termin�e correctement.
"""),

73: _("""

   - l'execution pr�c�dente s'est termin�e en erreur dans la proc�dure %(k1)s.
"""),

74: _("""

   - l'execution pr�c�dente s'est termin�e en erreur dans l'op�rateur %(k1)s.
"""),

75: _("""
     le concept %(k1)s de type %(k2)s  est peut-etre errone.
"""),

76: _("""
   - l'execution precedente s'est terminee prematurement dans l'operateur %(k1)s.
"""),

77: _("""
     le concept %(k1)s de type %(k2)s  a ete n�anmoims valid� par l'op�rateur
"""),

78: _("""
     Message attache au concept  %(k1)s
"""),

79: _("""
     Pas de message attache au concept %(k1)s
"""),

80: _("""

"""),

81: _("""
 %(k1)s nom symbolique inconnu
  - nombre de valeurs attendues %(i1)d
  - valeurs attendues : %(k1)s, %(k2)s,...
"""),

82: _("""
 L'argument du mot cle "CAS"  est errone.
 Valeur lue %(k1)s
 nombre de valeurs attendues %(i1)d
 valeurs attendues : %(k1)s,%(k2)s, ...
"""),

83: _("""

 le nombre d'enregistrements (nmax_enre) et leurs longueurs (long_enre) conduisent a un
 fichier dont la taille maximale en Moctets (%(i1)d) est superieure a limite autorisee :  %(i2)d
 
 Vous pouvez augmenter cette limite en utilisant l'argument "-max_base" sur la ligne
 de commande suivi d'une valeur en Moctets. 

"""),

84: _("""
 Nom symbolique errone pour un fichier de s.ortie
 Valeur lue %(k1)s
 - nombre de valeurs attendues %(i2)d
 - valeurs attendues           %(k2)s, %(k3)s

"""),

85: _("""
 information sur les concepts existants.
"""),

86: _("""
 Erreur a la relecture du fichier pick.1 : aucun objet sauvegard� ne sera r�cup�r�.
"""),

87: _("""
Types incompatibles entre glob.1 et pick.1 pour le concept de nom %(k1)s.
"""),

88: _("""
Concept de nom %(k1)s et de type %(k2)s introuvable dans la base globale"
"""),

93 : _("""
La variable python "%(k1)s" fait r�f�rence au concept "%(k2)s".
Cela se produit avec ce type d'enchainement :
   %(k2)s = COMMANDE(...)
   %(k1)s = %(k2)s

On d�truit cette variable ("%(k1)s" dans l'exemple ci-dessus).

-> Conseil :
   Pour �viter cette alarme, supprimer l'alias dans le jeu de commandes
   qui produit la base :
      del %(k1)s
"""),

94 : _("""
Le temps CPU system (%(r1)f) atteint une valeur sup�rieure � %(i1)d%% du temps CPU (%(r2)f).
Ce comportement est peut-�tre anormal. 
%(i2)d appels au m�canisme de d�chargement de la m�moire ont �t� effectu�s. 
 
-> Conseil :
   Augmenter la m�moire JEVEUX, peut permettre de diminuer le temps syst�me.
   
"""),

95 : _("""
Le temps CPU system (%(r1)f) atteint une valeur sup�rieure � %(i1)d%% du temps CPU (%(r2)f).
Ce comportement est peut-�tre anormal. 
 
"""),

}
