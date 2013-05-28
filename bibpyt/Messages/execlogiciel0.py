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

cata_msg={
1 : _(u"""
Format Salom�, l'argument 1 doit �tre
le nom du fichier MED produit par le script python.
"""),

2 : _(u"""
On ne sait pas traiter le format %(k1)s
"""),

3 : _(u"""
Code retour incorrect (MAXI %(i1)d) : %(i2)d

"""),

4 : _(u"""
Le mot-cl� logiciel n'est pas utilise avec ce format.
"""),

5 : _(u"""
Erreurs lors de l'ex�cution du fichier ci-dessous :
<<<<<<<<<<<<<<< DEBUT DU FICHIER >>>>>>>>>>>>>>>
%(k1)s
<<<<<<<<<<<<<<<  FIN  DU FICHIER >>>>>>>>>>>>>>>
"""),

6 : _(u"""
Le fichier %(k1)s n'existe pas.
"""),

7 : _(u"""
Mode de lancement inconnu : %(k1)s
"""),

8 : _(u"""
----------------------------------------------------------------------------------
 Commande :
   %(k1)s
"""),

9 : _(u"""
----- Sortie standard (stdout) ---------------------------------------------------
%(k1)s
----- fin stdout -----------------------------------------------------------------
"""),

10 : _(u"""
----- Sortie erreur standard (stderr) --------------------------------------------
%(k1)s
----- fin stderr -----------------------------------------------------------------
"""),

11 : _(u"""
 Code retour = %(i1)d      (maximum tol�r� : %(i2)d)
"""),

#12 : _(u""" """),

13 : _(u"""
 -> Le maillage n'a pas �t� produit par le logiciel externe (format "%(k1)s")

 -> Conseil :
    Vous devriez trouver ci-dessus des messages du logiciel en question
    expliquant les raisons de cet �chec.
"""),




14 : _(u"""
 -> Il y a eu une erreur lors de la connexion � la machine distante via SSH :
    . Il est probable que les cl�s SSH ne soient pas configur�es correctement.

 -> Conseil :
    V�rifier que les cl�s SSH sont correctement configur�es sur les diff�rentes machines.
    Vous pouvez essayer de relancer manuellement la commande suivante depuis le serveur Aster :
%(k1)s
"""),


15 : _(u"""
 -> Il y a eu une erreur lors de la connexion � la machine distante via SSH :
    . La machine distante n'a pas pus �tre contact�e.

 -> Conseil :
    V�rifier l'adresse de la machine.
    Vous pouvez essayer de relancer manuellement la commande suivante depuis le serveur Aster :
%(k1)s
"""),


16 : _(u"""
 -> Il y a eu une erreur lors de la connexion � la machine distante via SSH :
    . Le serveur SSH de la machine distante n'a pas pus �tre contact�.

 -> Conseil :
    V�rifier le port SSH de la machine.
    Vous pouvez essayer de relancer manuellement la commande suivante depuis le serveur Aster :
%(k1)s
"""),

17 : _(u"""
 -> Il y a eu une erreur lors de la connexion � la machine distante via SSH :
    . Il est probable que le logiciel d�fini par le mot cl� LOGICIEL ne soit pas pr�sent
      sur la machine distante.

 -> Conseil :
    V�rifier le mot-cl� LOGICIEL
    Vous pouvez essayer de relancer manuellement la commande suivante depuis le serveur Aster :
%(k1)s
"""),

18 : _(u"""
 -> Il y a eu une erreur lors de la connexion � la machine distante via SSH :
    . Soit l'adresse (ou le port SSH) de la machine n'est pas correcte.
    . Soit les cl�s SSH ne sont pas configur�es correctement.
    . Soit le logiciel d�fini par le mot cl� LOGICIEL n'est pas pr�sent sur la machine distante.
    . Soit une autre raison est � l'origine de cet �chec.

 -> Conseil :
    Vous devriez trouver ci-dessus des messages expliquant les raisons de cet �chec.
    Vous pouvez essayer de relancer manuellement la commande suivante depuis le serveur Aster :
%(k1)s
"""),

19 : _(u"""Information : le champs "%(k1)s" n'a pas �t� trouv� dans le script Salom�, mais il n'est peut �tre pas n�cessaire."""),

20 : _(u"""


----------------------------------------------------------------------------------
----- Script Salom� --------------------------------------------------------------

%(k1)s

----- fin Script Salom� ----------------------------------------------------------
----------------------------------------------------------------------------------


"""),

21 : _(u"""

----------------------------------------------------------------------------------
----- Commandes � ex�cuter -------------------------------------------------------

%(k1)s

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

"""),

22 : _(u"""
Les mots-cl�s SALOME_HOST et SSH_ADRESSE ont �t� d�finis simultan�ment et sont diff�rents.
C'est SALOME_HOST qui d�finira l'adresse de la machine distante.
"""),

23 : _(u"""
Les listes de param�tres (mot-cl� NOM_PARA) et de valeurs (mot-cl� VALE) doivent �tre de m�me longueur !
"""),

24 : _(u"""
Le nom du r�pertoire contenant les outils externes est trop long pour �tre stock�
dans la variable pr�vue (de longueur %(i1)d).

Conseil :
    - Vous pouvez d�placer/copier les outils dans un autre r�pertoire de nom plus court
      et utiliser l'argument optionnel "-rep_outils /nouveau/chemin" pour contourner
      le probl�me.
"""),

}
