# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

# person_in_charge: natacha.bereux at edf.fr

cata_msg = {

1 : _("""
Solveur PETSc :
 Erreur à l'initialisation de PETSc. Il y a certainement un problème dans l'installation.
"""),

2 : _("""
Solveur PETSc :
 On ne traite que des matrices réelles avec PETSc.
"""),

3 : _("""
Solveur PETSc :
  Limite atteinte : le solveur PETSc est utilisé par plus de 5 matrices simultanément.
Solution :
  Il faut corriger le programme
  Contactez l'assistance.
"""),

4 : _("""
Solveur PETSc :
  Le préconditionneur a déjà été calculé, on ne le recalcule pas.
"""),

5 : _("""
Solveur PETSc :
 La résolution du système linéaire a échoué car le critère de convergence n'a pu être satisfait avec le nombre d'itérations autorisées (%(i1)d).

 Conseils :
  * Augmentez le nombre d'itérations autorisées (SOLVEUR/NMAX_ITER).
  * Vérifiez la nature du problème résolu (symétrique ou non, mixte ou non, etc) et, le cas échéant, changez d'algorithme ou de préconditionneur (SOLVEUR/ALGORITHME ou SOLVEUR/PRE_COND).
  * Si vous utilisez une commande non-linéaire (STAT_NON_LINE par exemple), diminuez la précision demandée pour la convergence (SOLVEUR/RESI_RELA).
    Prenez garde cependant car cela peut empêcher la convergence de l'algorithme non-linéaire.
"""),

6 : _("""
Solveur PETSc :
  Le résidu a été multiplié par plus de %(i1)d par rapport au résidu initial : on diverge
  Vous pouvez utiliser un préconditionneur plus précis, voire changer d'algorithme.
"""),

7 : _("""
Solveur PETSc :
  On a rencontré un 'breakdown', on ne peut plus agrandir l'espace de Krylov, or on n'a pas encore
  convergé.
  Il faut changer de préconditionneur ou d'algorithme.
"""),

8 : _("""
Solveur PETSc :
  Le solveur a échoué : la norme du résidu est une valeur invalide. 
"""),

9 : _("""
Solveur PETSc :
  La matrice du système est non symétrique, or l'algorithme que vous utilisez requiert
  la symétrie.
  Changez d'algorithme ou bien utilisez le mot-clé MATR_RIGI_SYME  ='OUI' sous le mot-clé 
  facteur NEWTON  pour symétriser la matrice.
"""),

10 : _("""
Solveur PETSc :
  Le préconditionneur construit à partir de la matrice du système n'est défini positif, or l'algorithme
  que vous utilisez requiert la définie positivité.
  Changez d'algorithme.
"""),

11 : _("""
Solveur PETSc :
  La matrice du système n'est pas définie positive, or l'algorithme que vous utilisez requiert
  la définie positivité.
  Changez d'algorithme.
"""),

12 : _("""
Solveur PETSc :
  L'algorithme itératif a rencontré un erreur dont le code retourné par PETSC est : %(i1)d.
  Consulter le manuel de PETSc pour plus d'informations et prévenez l'assistance.
"""),

13 : _("""
Solveur PETSc :
  La résolution a échoué ; consultez le message ci-dessus.
  Cela peut être dû à une propriété particulière de la matrice du système non supportée par l'algorithme choisi.
  Par exemple, une matrice avec des zéros sur la diagonale et l'algorithme SOR, qui utilise ces entrées pour réaliser des divisions.
"""),

14 : _("""
Solveur PETSc :
  La création du préconditionneur a échoué ; consultez le message ci-dessus.
  Cela peut être dû à une propriété particulière de la matrice du système non supportée par le préconditionneur choisi.
  Par exemple, une matrice nécessitant des pivotages pour la factoriser ne peut pas utiliser le préconditionneur 'LDLT_INC'.

  Conseil : changez de préconditionneur.
"""),

15 : _("""
Solveur PETSc :
  La création du préconditionneur 'LDLT_SP' a échoué car on manque de mémoire.

  Conseil : augmentez la valeur du mot clé SOLVEUR/PCENT_PIVOT.
"""),

16 : _("""
Solveur PETSc :
  La résolution du système linéaire a abouti mais la solution obtenue ne vérifie pas le critère de convergence.
  Cela peut arriver: 
     - si la matrice du système linéaire est mal conditionnée
     - si vous avez utilisé le préconditionneur 'LDLT_SP' avec ALGORITHME='GMRES'

  Conseils : utilisez le préconditionneur 'LDLT_SP' avec ALGORITHME='FGMRES' ou un solveur direct ('MULT_FRONT' ou 'MUMPS')
"""),

17: _("""
Solveur PETSC : 
   Vous utilisez le préconditionneur LDLT_INC : l'option MATR_DISTRIBUEE='OUI' n'est pas
   disponible avec ce préconditionneur.

Conseils :
   Utilisez 'MATR_DISTRIBUEE='NON'. Vous pouvez également remplacer le préconditionneur 
   LDLT_INC par LDLT_SP, qui est compatible avec  MATR_DISTRIBUEE='OUI'.
"""),

18 : _("""
Solveur PETSc :
  Les préconditionneurs 'ML', 'BOOMER' et 'GAMG' ne doivent pas être utilisés lorsque:
  - soit le modèle comporte des charges dualisées issues de AFFE_CHAR_MECA,
  - soit les noeuds du modèle ne portent pas tous les mêmes degrés de liberté. 
  
  Conseils :
  - ne mélangez pas des modélisations dans votre calcul
  - remplacez AFFE_CHAR_MECA par AFFE_CHAR_CINE si cela est possible 
  - utilisez le préconditionneur 'LDLT_SP' ou un solveur direct ('MULT_FRONT' ou 'MUMPS').
"""),

19 : _("""
Solveur PETSc :
  La sélection du préconditionneur '%(k1)s' a échoué.
  L'installation de PETSc dont vous disposez n'a vraisemblablement pas été compilée avec le support de ce préconditionneur.

  Conseils :
  - reconstruisez une version de PETSc avec le support des préconditionneurs BOOMER, ML et GAMG
  - utilisez un autre préconditionneur (comme 'LDLT_SP' par exemple)
"""),

20 : _("""
 Erreur d'utilisation :
   On veut utiliser le préconditionneur SOLVEUR / PRE_COND='BLOC_LAGR'
   Il y a plusieurs processeurs actifs.
 Risques & conseils :
   Il faut utiliser la version MPI avec un seul processeur.
"""),


24 : _("""
Solveur PETSc :
  La résolution du système linéaire précédent s'est effectuée en %(i1)d itérations. 
  """),

26 : _("""
Solveur PETSc :
  On construit un nouveau préconditionneur de second niveau à partir des éléments de Ritz calculés au cours de la résolution du système linéaire précédent.   
  """),
27 : _("""
Solveur PETSc :
  On conserve le préconditionneur de second niveau pour les résolutions ultérieures.   
  """),
28 : _("""
Solveur PETSc :
  Vous avez demandé à utiliser un préconditionneur de second niveau. C'est seulement possible avec le préconditionneur de premier niveau 'LDLT_SP'. 
  Conseils:
  Vous pouvez :
  - soit changer de préconditionneur de premier niveau (choisir PRE_COND='LDLT_SP'),
  - soit désactiver le préconditionneur de second niveau (en choisissant ALGORITHME='GMRES' ou 'FGMRES' au lieu de 'GMRES_LMP').   
  """),

}
