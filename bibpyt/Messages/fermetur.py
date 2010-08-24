#@ MODIF fermetur Messages  DATE 24/08/2010   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
Le solveur "MUMPS" n'est pas install� sur cette machine.
"""),

2: _("""
La biblioth�que "MED" n'est pas install�e sur cette machine.
"""),

3: _("""
La biblioth�que "HDF5" n'est pas install�e sur cette machine.
"""),

4: _("""
La biblioth�que "ZMAT" n'est pas install�e sur cette machine ou bien elle
n'a pas �t� trouv�e.

Conseil : V�rifier que l'environnement est correctement d�fini,
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
Le logiciel "SCOTCH" n'est pas install� sur cette machine.
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
Le solveur "PETSc" n'est pas install� sur cette machine.
"""),

11: _("""
Erreur de programmation :
    On essaie d'utiliser une routine de comportement (lc00xx)
    qui n'est pas encore programm�e.
"""),

12: _("""
La biblioth�que "YACS" n'est pas install�e sur cette machine.
"""),

13 : _("""
La biblioth�que UMAT n'a pas pu �tre charg�e.

Nom de la biblioth�que : %(k1)s

Conseil : V�rifier que l'environnement est correctement d�fini,
          notamment la variable LD_LIBRARY_PATH.
"""),

14 : _("""
Le symbole demand� n'a pas �t� trouv� dans la biblioth�que UMAT.

Nom de la biblioth�que : %(k1)s
        Nom du symbole : %(k2)s

Conseil : V�rifier que l'environnement est correctement d�fini,
          notamment la variable LD_LIBRARY_PATH.
"""),

}
