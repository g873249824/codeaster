# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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

3: _(u"""
  Erreur programmeur : %(k1)s non appari�s.
"""),

8: _(u"""
  Un nom de concept interm�diaire doit commencer par '.' ou '_' et non :  %(k1)s
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
  D�but de lecture..."""),

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
  D�bogage JXVERI demand�
"""),

24: _(u"""
  D�bogage SDVERI demand�
"""),

31: _(u"""
 Valeur invalide pour le mot cl� RESERVE_CPU
"""),

32: _(u"""
 La proc�dure "%(k1)s" ne peut �tre appel�e en cours d'ex�cution des commandes
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

41: _(u"""La version %(k1)s a �t� modifi�e par %(i1)d r�visions.
"""),

42: _(u"""Les fichiers suivants ont �t� modifi�s par rapport � la derni�re r�vision %(k1)s :

%(k2)s
"""),

43: _(u"""
  D�bogage %(k1)s suspendu
"""),

44: _(u"""
  D�bogage %(k1)s demand�
"""),

50: _(u"""
 La commande a un num�ro non appelable dans cette version.
 Le num�ro erron� est  %(i1)d
"""),

52: _(u"""
  Fin de lecture (dur�e  %(r1)f  s.) %(k1)s
"""),

56: _(u"""
  Incoh�rence entre le catalogue et le corps de la macro-commande.
"""),

60: _(u"""
  La proc�dure a un num�ro non appelable dans cette version.
  Le num�ro erron� est %(i1)d.
"""),

61: _(u"""
  La commande a un num�ro non appelable dans cette version
  Le num�ro erron� est : %(i1)d
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

65 : _(u"""
  Liste des concepts issus de la base :
    Nom         Type du concept
"""),

66 : _(u"""    %(k1)-8s    %(k2)-20s    %(k3)s"""),

67 : _(u"""    pas de concept
"""),

68: _(u"""
  La signature de la base sauvegard�e est (� l'adresse %(i1)d) :
    %(k1)s
"""),

69: _(u"""
Les fichiers glob.1 et pick.1 ne sont pas coh�rents !

D'apr�s le fichier pick.1, la signature de la base � l'adresse %(i1)d devrait �tre :
    %(k1)s
Or la signature de glob.1 est :
    %(k2)s
"""),

70: _(u"""
  La signature de la base relue est conforme � celle attendue (� l'adresse %(i1)d) :
    %(k1)s
"""),

71: _(u"""
  La signature de la base au format HDF ne peut pas �tre v�rifi�e.
"""),

72: _(u"""
  L'ex�cution pr�c�dente s'est termin�e correctement.
"""),

73 : _(u"""relu: %(k1)s = %(k2)s"""),

76: _(u"""
  L'ex�cution pr�c�dente a �t� interrompue au cours d'une commande qui a produit
  le concept '%(k1)s' de type <%(k2)s> qui a �t� n�anmoins valid� par l'op�rateur.
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

86: _(u"""
 Erreur � la relecture du fichier pick.1 : aucun objet sauvegard� ne sera r�cup�r�.
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

95 : _(u"""
Le temps CPU syst�me (%(r1).1f) atteint une valeur sup�rieure � %(i1)d%% du temps CPU (%(r2).1f).
Ce comportement est peut-�tre anormal.

-> Conseil :
   Augmenter la quantit� de m�moire peut permettre de diminuer le temps syst�me.
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
