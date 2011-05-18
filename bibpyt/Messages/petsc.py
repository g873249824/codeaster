#@ MODIF petsc Messages  DATE 19/05/2011   AUTEUR DELMAS J.DELMAS 
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
Solveur PETSc :
 Erreur � l'initialisation de PETSc. Il y a certainement un probl�me dans l'installation.
"""),

2 : _("""
Solveur PETSc :
 On ne traite que des matrices r�elles avec PETSc.
"""),

3 : _("""
Solveur PETSc :
  Limite atteinte : le solveur PETSc est utilis� par plus de 5 matrices simultan�ment.
Solution :
  Il faut corriger le programme (PARAMETER (NMXINS=5) dans apetsc.F)
  Contactez l'assistance.
"""),

4 : _("""
Solveur PETSc :
  Le pr�conditionneur a d�j� �t� calcul�, on ne le recalcule pas.
"""),

5 : _("""
Solveur PETSc :
  Le nombre maximum d'it�rations de l'algorithme (%(i1)d) a �t� atteint.
  Vous pouvez soit augmenter ce chiffre � l'aide du mot-cl� NMAX_ITER, soit augmenter RESI_RELA,
  ou bien utiliser un pr�conditionneur plus pr�cis, voire changer d'algorithme.
"""),

6 : _("""
Solveur PETSc :
  Le r�sidu a �t� multipli� par plus de %(i1)d par rapport au r�sidu initial : on diverge
  Vous pouvez utiliser un pr�conditionneur plus pr�cis, voire changer d'algorithme.
"""),

7 : _("""
Solveur PETSc :
  On a rencontr� un 'breakdown', on ne peut plus agrandir l'espace de Krylov, or on n'a pas encore
  converg�.
  Il faut changer de pr�conditionneur ou d'algorithme.
"""),

8 : _("""
Solveur PETSc :
  On a rencontr� un 'breakdown' dans l'algorithme BiCG, le r�sidu initial est orthogonal au r�sidu
  initial pr�conditionn�.
  Il faut changer de pr�conditionneur ou d'algorithme.
"""),

9 : _("""
Solveur PETSc :
  La matrice du syst�me est non sym�trique, or l'algorithme que vous utilisez requiert
  la sym�trie.
  Changez d'algorithme ou bien utilisez le mot-cl� SYME='OUI' pour sym�triser la matrice.
"""),

10 : _("""
Solveur PETSc :
  Le pr�conditionneur construit � partir de la matrice du syst�me n'est d�fini positif, or l'algorithme
  que vous utilisez requiert la d�finie-positivit�.
  Changez d'algorithme.
"""),

11 : _("""
Solveur PETSc :
  La matrice du syst�me n'est pas d�finie positive, or l'algorithme que vous utilisez requiert
  la d�finie-positivit�.
  Changez d'algorithme.
"""),

12 : _("""
Solveur PETSc :
  L'algorithme it�ratif a rencontr� un erreur dont le code retourn� par PETSC est : %(i1)d.
  Consulter le manuel de PETSc pour plus d'informations et pr�venez l'assistance.
"""),

13 : _("""
Solveur PETSc :
  La r�solution a �chou� ; consultez le message ci-dessus.
  Cela peut �tre d� � une propri�t� particuli�re de la matrice du syst�me non support�e par l'algorithme choisi.
  Par exemple, une matrice avec des z�ros sur la diagonale et l'algorithme SOR, qui utilise ces entr�es pour r�aliser des divisions.
"""),

14 : _("""
Solveur PETSc :
  La cr�ation du pr�conditionneur a �chou� ; consultez le message ci-dessus.
  Cela peut �tre d� � une propri�t� particuli�re de la matrice du syst�me non support�e par le pr�conditionneur choisi.
  Par exemple, une matrice n�cessitant des pivotages pour la factoriser ne peut pas utiliser le pr�conditionneur 'LDLT_INC'.
  
  Conseil : changez de pr�conditionneur.
"""),

15 : _("""
Solveur PETSc :
  La cr�ation du pr�conditionneur 'LDLT_SP' a �chou� car on manque de m�moire.

  Conseil : augmentez la valeur du mot cl� SOLVEUR/PCENT_PIVOT.
"""),
}
