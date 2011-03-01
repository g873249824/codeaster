#@ MODIF execlogiciel0 Messages  DATE 01/03/2011   AUTEUR ASSIRE A.ASSIRE 
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

def _(x) : return x

cata_msg={
1 : _("""
Format Salome, l'argument 1 doit etre 
le nom du fichier med produit par le script python.
"""),

2 : _("""
On ne sait pas traiter le format %(k1)s
"""),

3 : _("""
Code retour incorrect (MAXI %(i1)d) : %(i2)d

"""),

4 : _("""
Le mot-cle logiciel n'est pas utilise avec ce format.
"""),

5 : _("""
Erreurs lors de l'execution du fichier ci-dessous :
<<<<<<<<<<<<<<< DEBUT DU FICHIER >>>>>>>>>>>>>>>
%(k1)s
<<<<<<<<<<<<<<<  FIN  DU FICHIER >>>>>>>>>>>>>>>
"""),

6 : _("""
Le fichier %(k1)s n'existe pas.
"""),

7 : _("""
Mode de lancement inconnu : %(k1)s
"""),

8 : _("""
----------------------------------------------------------------------------------
 Commande :
   %(k1)s
"""),

9 : _("""
----- Sortie standard (stdout) ---------------------------------------------------
%(k1)s
----- fin stdout -----------------------------------------------------------------
"""),

10 : _("""
----- Sortie erreur standard (stderr) --------------------------------------------
%(k1)s
----- fin stderr -----------------------------------------------------------------
"""),

11 : _("""
 Code retour = %(i1)d      (maximum tol�r� : %(i2)d)
"""),

#12 : _(""" """),

13 : _("""
 -> Le maillage n'a pas �t� produit par le logiciel externe (format "%(k1)s")
 
 -> Conseil :
    Vous devriez trouver ci-dessus des messages du logiciel en question
    expliquant les raisons de cet �chec.
"""),




14 : _("""
 -> Il y a eu une erreur lors de la connection � la machine distante via SSH :
    . Il est probable que les cl�s SSH ne soient pas configur�es correctement.

 -> Conseil :
    V�rifier que les cl�s SSH sont correctement configur�es sur les diff�rentes machines.
    Vous pouvez essayer de relancer manuellement la commande suivante depuis le serveur Aster :
%(k1)s
"""),


15 : _("""
 -> Il y a eu une erreur lors de la connection � la machine distante via SSH :
    . La machine distante n'a pas pus �tre contact�e.

 -> Conseil :
    V�rifier l'adresse de la machine.
    Vous pouvez essayer de relancer manuellement la commande suivante depuis le serveur Aster :
%(k1)s
"""),


16 : _("""
 -> Il y a eu une erreur lors de la connection � la machine distante via SSH :
    . Le serveur SSH de la machine distante n'a pas pus �tre contact�.

 -> Conseil :
    V�rifier le port SSH de la machine.
    Vous pouvez essayer de relancer manuellement la commande suivante depuis le serveur Aster :
%(k1)s
"""),

17 : _("""
 -> Il y a eu une erreur lors de la connection � la machine distante via SSH :
    . Il est probable que le logiciel defini par le mot cl� LOGICIEL ne soit pas pr�sent
      sur la machine distante.

 -> Conseil :
    V�rifier le mot-cl� LOGICIEL
    Vous pouvez essayer de relancer manuellement la commande suivante depuis le serveur Aster :
%(k1)s
"""),

18 : _("""
 -> Il y a eu une erreur lors de la connection � la machine distante via SSH :
    . Soit l'adresse (ou le port SSH) de la machine n'est pas correcte.
    . Soit les cl�s SSH ne sont pas configur�es correctement.
    . Soit le logiciel defini par le mot cl� LOGICIEL n'est pas pr�sent sur la machine distante.
    . Soit une autre raison est � l'origine de cet eche.

 -> Conseil :
    Vous devriez trouver ci-dessus des messages expliquant les raisons de cet �chec.
    Vous pouvez essayer de relancer manuellement la commande suivante depuis le serveur Aster :
%(k1)s
"""),

19 : _("""Info : le champs "%(k1)s" n'a pas �t� trouv� dans le script Salome, mais il n'est peut �tre pas n�cessaire."""),

20 : _("""


----------------------------------------------------------------------------------
----- Script Salome --------------------------------------------------------------

%(k1)s

----- fin Script Salome ----------------------------------------------------------
----------------------------------------------------------------------------------


"""),

21 : _("""

----------------------------------------------------------------------------------
----- Commandes � ex�cuter -------------------------------------------------------

%(k1)s

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

"""),

22 : _("""
Les mots-cl�s SALOME_HOST et SSH_ADRESSE ont �t� d�finis simultan�ment et sont diff�rents.
C'est SALOME_HOST qui d�finira l'adresse de la machine distante.
"""),

23 : _("""
Les listes de param�tres (mot-cl� NOM_PARA) et de valeurs (mot-cl� VALE) doivent �tre de m�me longueur !
"""),



}
