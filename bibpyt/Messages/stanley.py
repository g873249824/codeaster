#@ MODIF stanley Messages  DATE 24/05/2011   AUTEUR MACOCCO K.MACOCCO 
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

cata_msg = {

1 : _("""
Red�finition du DISPLAY vers %(k1)s.
"""),

2 : _("""
Stanley fonctionne en mode validation de non-regression.
"""),

3 : _("""
Aucune variable d'environnement DISPLAY d�finie !
%(k1)s ne pourra pas fonctionner. On l'ignore.

Si vous etes en Interactif, cochez le bouton Suivi Interactif
dans ASTK.

Vous pouvez �galement pr�ciser votre DISPLAY dans les arguments
de la commande STANLEY :

STANLEY(DISPLAY='adresse_ip:0.0');
"""),

4 : _("""
Une erreur est intervenue. Raison : %(k1)s
"""),

5 : _("""
Cette action n'est pas r�alisable: %(k1)s
"""),

6 : _("""
En mode DISTANT, la variable %(k1)s est obligatoire. On abandonne.
"""),

7 : _("""
Le parametre 'machine_gmsh_exe' ou 'machine_visu' n'est pas renseign�, 
il faut ouvrir le fichier manuellement.
"""),

8 : _("""
Lancement termin�.
"""),

9 : _("""
Ex�cution de %(k1)s
"""),

10 : _("""
Erreur de lancement de la commande!
"""),

11 : _("""
Dans le mode WINDOWS, la variable %(k1)s est obligatoire. On abandonne.
"""),

12 : _("""
Les fichiers de post-traitement sont copi�s.
Veuillez maintenant ouvrir manuellement skin.pos avec GMSH.
"""),

13 : _("""
Le fichier de post-traitement est copie.
Veuillez maintenant ouvrir manuellement fort.33.pos avec GMSH.
"""),

14 : _("""
Impossible de contacter le serveur SALOME! V�rifier qu'il est bien lanc�.
"""),

15 : _("""
Impossible de r�cup�rer le nom de la machine locale! 
Solution alternative : utiliser le mode DISTANT en indiquant l'adresse IP
ou le nom de la machine dans la case 'machine de salome'.
"""),

16 : _("""
Pour visualisation dans Salome, la variable %(k1)s est obligatoire. On abandonne.
"""),

17 : _("""
Pour visualisation dans Salome, la variable machine_salome_port est obligatoire. 
On abandonne.
"""),

18 : _("""
Erreur : mode WINDOWS non impl�ment�
"""),

19 : _("""
Erreur: il est possible que Stanley ne puisse pas contacter Salome :

 - machine Salome definie   : %(k1)s
 - port de Salome           : %(k2)s
 - lanceur runSalomeScript  : %(k3)s

Vous pouvez modifier ces valeurs dans les parametres dans Stanley. 

Si Stanley est bien lanc�, vous pouvez essayer d'activer le module VISU.

"""),

20 : _("""
Execution termin�e.
"""),

#21 : _(""" """),

22 : _("""
Impossible d'affecter la variable [%(k1)s / %(k2)s].
"""),

23 : _("""
Lecture du fichier d'environnement : %(k1)s
"""),

24 : _("""
Il n'y a pas de fichier d'environnement. 
On d�marre avec une configuration par d�faut.
"""),

25 : _("""
Le fichier d'environnement n'a pas la version attendue. 
On continue mais en cas de probl�me, effacer le repertoire ~/%(k1)s et relancer.
"""),

26 : _("""
Le fichier d'environnement n'est pas exploitable (par exemple c'est une ancienne version).
On d�marre avec une configuration par d�faut.
"""),

27 : _("""
On initialise une configuration par d�faut.
"""),

28 : _("""
Nouveaux param�tres sauvegard�s dans : %(k1)s
"""),

29 : _("""
Impossible de sauvegarder les param�tres dans : %(k1)s
"""),

30 : _("""
La visualisation aux points de Gauss n'est pas permise avec la sensibilit�.
"""),

31 : _("""
Probl�me : %(k1)s
"""),

32 : _("""
Impossible d'ouvrir en �criture le fichier %(k1)s
"""),

33 : _("""
Attention : on ne peut pas tracer un champ aux points de Gauss sur la d�form�e...
"""),

34 : _("""
Le champ est trac� avec la d�form�e.
"""),

35 : _("""
Concept ignor� : %(k1)s
"""),

36 : _("""
On ne peut pas tracer une courbe avec une seule abscisse.
"""),

37 : _("""
Tous les concepts Aster n�cessaires � Stanley n'ont pas �t� calcul�s. 
Il manque :
%(k1)s
"""),

38 : _("""
Stanley - Erreur lors de l'appel � la commande Aster:

%(k1)s
Raison:
%(k2)s
"""),

40 : _("""
Stanley - Projection aux points de Gauss: type de r�sultat non d�velopp�
%(k1)s
"""),

}
