#@ MODIF fermetur Messages  DATE 16/08/2011   AUTEUR DESOZA T.DESOZA 
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

1: _("""
Le solveur "MUMPS" n'est pas install� dans cette version de Code_Aster.

Conseil : V�rifiez que vous avez s�lectionn� la bonne version de Code_Aster.
          Attention, certains solveurs ne sont disponibles que dans les versions parall�les de Code_Aster.
"""),

2: _("""
La biblioth�que "MED" n'est pas install�e dans cette version de Code_Aster.
"""),

3: _("""
La biblioth�que "HDF5" n'est pas install�e dans cette version de Code_Aster.
"""),

4: _("""
La biblioth�que "ZMAT" n'est pas install�e dans cette version de Code_Aster ou bien elle
n'a pas �t� trouv�e.

Conseil : V�rifiez que l'environnement est correctement d�fini,
          notamment la variable LD_LIBRARY_PATH.
"""),

5: _("""
Erreur de programmation :
    On essaie d'utiliser un op�rateur (op0xxx) qui n'est pas encore programm�.
"""),

6: _("""
Erreur de programmation :
    On essaie d'utiliser un op�rateur (ops0xx) qui n'est pas encore programm�.
"""),

7: _("""
Le renum�roteur "SCOTCH" n'est pas install� dans cette version de Code_Aster.
"""),

8: _("""
Erreur de programmation :
    On essaie d'utiliser une routine de calcul �l�mentaire (te0xxx)
    qui n'est pas encore programm�e.
"""),

9: _("""
Erreur de programmation :
    On essaie d'utiliser une routine d'initialisation �l�mentaire (ini0xx)
    qui n'est pas encore programm�e.
"""),

10: _("""
Le solveur "PETSc" n'est pas install� dans cette version de Code_Aster.

Conseil : V�rifiez que vous avez s�lectionn� la bonne version de Code_Aster.
          Attention, certains solveurs ne sont disponibles que dans les versions parall�les de Code_Aster.
"""),

11: _("""
Erreur de programmation :
    On essaie d'utiliser une routine de comportement (lc00xx)
    qui n'est pas encore programm�e.
"""),

12: _("""
La biblioth�que "YACS" n'est pas install�e dans cette version de Code_Aster.
"""),

13 : _("""
La biblioth�que %(k1)s n'a pas pu �tre charg�e.

Nom de la biblioth�que : %(k2)s

Conseil : V�rifiez que l'environnement est correctement d�fini,
          notamment la variable LD_LIBRARY_PATH.
"""),

14 : _("""
Le symbole demand� n'a pas �t� trouv� dans la biblioth�que %(k1)s.

Nom de la biblioth�que : %(k2)s
        Nom du symbole : %(k3)s

Conseil : V�rifiez que l'environnement est correctement d�fini,
          notamment la variable LD_LIBRARY_PATH.
"""),

}
