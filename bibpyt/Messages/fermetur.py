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

1: _(u"""
Le solveur "MUMPS" n'est pas install� dans cette version de Code_Aster.

Conseil : V�rifiez que vous avez s�lectionn� la bonne version de Code_Aster.
          Attention, certains solveurs ne sont disponibles que dans les versions parall�les de Code_Aster.
"""),

2: _(u"""
La biblioth�que "MED" n'est pas install�e dans cette version de Code_Aster.
"""),

3: _(u"""
La biblioth�que "HDF5" n'est pas install�e dans cette version de Code_Aster.
"""),

4: _(u"""
La biblioth�que "ZMAT" n'est pas install�e dans cette version de Code_Aster ou bien elle
n'a pas �t� trouv�e.

Conseil : V�rifiez que l'environnement est correctement d�fini,
          notamment la variable LD_LIBRARY_PATH.
"""),

5: _(u"""
Erreur de programmation :
    On essaie d'utiliser un op�rateur qui n'est pas encore programm�.
"""),

# identique au pr�c�dent mais il faudrait modifier tous les appelants dans fermetur
6: _(u"""
Erreur de programmation :
    On essaie d'utiliser un op�rateur qui n'est pas encore programm�.
"""),

7: _(u"""
Le renum�roteur "SCOTCH" n'est pas install� dans cette version de Code_Aster.
"""),

8: _(u"""
Erreur de programmation :
    On essaie d'utiliser une routine de calcul �l�mentaire
    qui n'est pas encore programm�e.
"""),

9: _(u"""
Erreur de programmation :
    On essaie d'utiliser une routine d'initialisation �l�mentaire
    qui n'est pas encore programm�e.
"""),

10: _(u"""
Le solveur "PETSc" n'est pas install� dans cette version de Code_Aster.

Conseil : V�rifiez que vous avez s�lectionn� la bonne version de Code_Aster.
          Attention, certains solveurs ne sont disponibles que dans les versions parall�les de Code_Aster.
"""),

11: _(u"""
Erreur de programmation :
    On essaie d'utiliser une routine de comportement
    qui n'est pas encore programm�e.
"""),

12: _(u"""
La biblioth�que "YACS" n'est pas install�e dans cette version de Code_Aster.
"""),

13 : _(u"""
La biblioth�que %(k1)s n'a pas pu �tre charg�e.

Nom de la biblioth�que : %(k2)s

Conseil : V�rifiez que l'environnement est correctement d�fini,
          notamment la variable LD_LIBRARY_PATH.
"""),

14 : _(u"""
Le symbole demand� n'a pas �t� trouv� dans la biblioth�que %(k1)s.

Nom de la biblioth�que : %(k2)s
        Nom du symbole : %(k3)s

Conseil : V�rifiez que l'environnement est correctement d�fini,
          notamment la variable LD_LIBRARY_PATH.
"""),

15 : _(u"""
La biblioth�que "METIS" n'est pas install�e dans cette version de Code_Aster.
"""),

}
