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

cata_msg = {

1 : _(u"""
Solveur PETSc :
 Erreur � l'initialisation de PETSc. Il y a certainement un probl�me dans l'installation.
"""),

2 : _(u"""
Solveur PETSc :
 On ne traite que des matrices r�elles avec PETSc.
"""),

3 : _(u"""
Solveur PETSc :
  Limite atteinte : le solveur PETSc est utilis� par plus de 5 matrices simultan�ment.
Solution :
  Il faut corriger le programme (PARAMETER (NMXINS=5) dans apetsc.F)
  Contactez l'assistance.
"""),

4 : _(u"""
Solveur PETSc :
  Le pr�conditionneur a d�j� �t� calcul�, on ne le recalcule pas.
"""),

5 : _(u"""
Solveur PETSc :
 La r�solution du syst�me lin�aire a �chou� car le crit�re de convergence n'a pu �tre satisfait avec le nombre d'it�rations autoris�es (%(i1)d).

 Conseils :
  * Augmentez le nombre d'it�rations autoris�es (SOLVEUR/NMAX_ITER).
  * V�rifiez la nature du probl�me r�solu (sym�trique ou non, mixte ou non, etc) et, le cas �ch�ant, changez d'algorithme ou de pr�conditionneur (SOLVEUR/ALGORITHME ou SOLVEUR/PRE_COND).
  * Si vous utilisez une commande non-lin�aire (STAT_NON_LINE par exemple), diminuez la pr�cision demand�e pour la convergence (SOLVEUR/RESI_RELA).
    Prenez garde cependant car cela peut emp�cher la convergence de l'algorithme non-lin�aire.
"""),

6 : _(u"""
Solveur PETSc :
  Le r�sidu a �t� multipli� par plus de %(i1)d par rapport au r�sidu initial : on diverge
  Vous pouvez utiliser un pr�conditionneur plus pr�cis, voire changer d'algorithme.
"""),

7 : _(u"""
Solveur PETSc :
  On a rencontr� un 'breakdown', on ne peut plus agrandir l'espace de Krylov, or on n'a pas encore
  converg�.
  Il faut changer de pr�conditionneur ou d'algorithme.
"""),

8 : _(u"""
Solveur PETSc :
  On a rencontr� un 'breakdown' dans l'algorithme BiCG, le r�sidu initial est orthogonal au r�sidu
  initial pr�conditionn�.
  Il faut changer de pr�conditionneur ou d'algorithme.
"""),

9 : _(u"""
Solveur PETSc :
  La matrice du syst�me est non sym�trique, or l'algorithme que vous utilisez requiert
  la sym�trie.
  Changez d'algorithme ou bien utilisez le mot-cl� SYME='OUI' pour sym�triser la matrice.
"""),

10 : _(u"""
Solveur PETSc :
  Le pr�conditionneur construit � partir de la matrice du syst�me n'est d�fini positif, or l'algorithme
  que vous utilisez requiert la d�finie positivit�.
  Changez d'algorithme.
"""),

11 : _(u"""
Solveur PETSc :
  La matrice du syst�me n'est pas d�finie positive, or l'algorithme que vous utilisez requiert
  la d�finie positivit�.
  Changez d'algorithme.
"""),

12 : _(u"""
Solveur PETSc :
  L'algorithme it�ratif a rencontr� un erreur dont le code retourn� par PETSC est : %(i1)d.
  Consulter le manuel de PETSc pour plus d'informations et pr�venez l'assistance.
"""),

13 : _(u"""
Solveur PETSc :
  La r�solution a �chou� ; consultez le message ci-dessus.
  Cela peut �tre d� � une propri�t� particuli�re de la matrice du syst�me non support�e par l'algorithme choisi.
  Par exemple, une matrice avec des z�ros sur la diagonale et l'algorithme SOR, qui utilise ces entr�es pour r�aliser des divisions.
"""),

14 : _(u"""
Solveur PETSc :
  La cr�ation du pr�conditionneur a �chou� ; consultez le message ci-dessus.
  Cela peut �tre d� � une propri�t� particuli�re de la matrice du syst�me non support�e par le pr�conditionneur choisi.
  Par exemple, une matrice n�cessitant des pivotages pour la factoriser ne peut pas utiliser le pr�conditionneur 'LDLT_INC'.

  Conseil : changez de pr�conditionneur.
"""),

15 : _(u"""
Solveur PETSc :
  La cr�ation du pr�conditionneur 'LDLT_SP' a �chou� car on manque de m�moire.

  Conseil : augmentez la valeur du mot cl� SOLVEUR/PCENT_PIVOT.
"""),

16 : _(u"""
Solveur PETSc :
  La r�solution du syst�me lin�aire a abouti mais la solution obtenue ne v�rifie pas le crit�re de convergence.
  Cela peut arriver lorsque la matrice du syst�me lin�aire est mal conditionn�e.

  Conseil : utilisez le pr�conditionneur 'LDLT_SP' ou un solveur direct ('MULT_FRONT' ou 'MUMPS')
"""),

17 : _(u"""
Solveur PETSc :
  La matrice du syst�me lin�aire comporte des multiplicateurs de Lagrange.
  Les pr�conditionneurs 'ML' et 'BOOMER' ne supportent pas ce type de matrice.

  Conseils :
  - utilisez la commande AFFE_CHAR_CINE pour imposer des conditions aux limites
  - utilisez le pr�conditionneur 'LDLT_SP' ou un solveur direct ('MULT_FRONT' ou 'MUMPS')
"""),

18 : _(u"""
Solveur PETSc :
  La matrice du syst�me lin�aire ne comporte pas le m�me nombre de degr�s de libert� en chaque noeud du mod�le.
  Les pr�conditionneurs 'ML' et 'BOOMER' ne supportent pas ce type de matrice.

  Conseils :
  - ne m�langez pas des mod�lisations dans votre calcul
  - utilisez le pr�conditionneur 'LDLT_SP' ou un solveur direct ('MULT_FRONT' ou 'MUMPS')
"""),

19 : _(u"""
Solveur PETSc :
  La s�lection du pr�conditionneur '%(k1)s' a �chou�.
  L'installation de PETSc dont vous disposez n'a vraisemblablement pas �t� compil�e avec le support de ce pr�conditionneur.

  Conseils :
  - reconstruisez une version de PETSc avec le support des pr�conditionneurs BOOMER et ML
  - utilisez un autre pr�conditionneur (comme 'LDLT_SP' par exemple)
"""),

}
