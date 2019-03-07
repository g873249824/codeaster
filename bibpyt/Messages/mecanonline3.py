# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

# person_in_charge: josselin.delmas at edf.fr

cata_msg = {


    2 : _("""
 Votre modèle contient des variables de commandes (température, irradiation, etc.)
 or on utilise une matrice élastique constante au cours du temps.
 Si vous faites de l'amortissement de Rayleigh, il y a un risque de résultats faux
 si l'amortissement dépend de cette variable de commande (via les coefficients élastiques).

 """),



    87 : _("""
Le contact de type LAC n'est pas utilisable avec le préconditionneur LDLT_INC, il faut utiliser LDLT_SP.
"""),

    88 : _("""
  -> Vous utilisez l'algorithme de contact 'GCP' avec un préconditionneur qui n'est pas adapté.

  -> Conseil :
     Utilisez le préconditionneur 'LDLT_SP' en spécifiant PRE_COND='LDLT_SP' sous le mot-clé SOLVEUR.
"""),

    89 : _("""
 contact et recherche linéaire peuvent poser des problèmes de convergence
"""),

    90 : _("""
  -> Vous utilisez une formulation 'DISCRETE' de contact conjointement avec le solveur linéaire '%(k1)s'.
     Le solveur '%(k1)s' n'est actuellement autorisé qu'avec les algorithmes de contact 'GCP','VERIF' et 'PENALISATION'.

  -> Conseil :
     Changez d'algorithme de contact en utilisant le mot-clé ALGO_CONT de DEFI_CONTACT ou bien changez de solveur linéaire
     en utilisant le mot-clé METHODE de SOLVEUR.
"""),

    91 : _("""
Contact méthode continue et recherche linéaire sont incompatibles
"""),

    92 : _("""
Contact méthode continue et pilotage sont incompatibles
"""),

    93 : _("""
 Le contact de type CONTINUE et l'amortissement modal AMOR_MODAL sont des fonctionnalités incompatibles
"""),

    94 : _("""
 Le contact de type liaison unilatérale (sans appariement) et le pilotage sont des fonctionnalités incompatibles
"""),

    95 : _("""
 Le contact de type liaison unilatérale (sans appariement) et la recherche linéaire peuvent poser des problèmes de convergence
"""),

    96 : _("""
  -> Vous utilisez la formulation 'LIAISON_UNIL' conjointement avec le solveur linéaire '%(k1)s'.
     Ce dernier n'est pas compatible avec le traitement de conditions unilatérales.

  -> Conseil :
     Changez de solveur linéaire en utilisant le mot-clé METHODE de SOLVEUR.
"""),

    97 : _("""
  -> Vous utilisez la formulation 'CONTINUE' de contact conjointement avec un solveur itératif et le préconditionneur '%(k1)s'.
     Le préconditionneur '%(k1)s' ne supporte pas les matrices issues de cette formulation du contact.

  -> Conseil :
     Changez de préconditionneur.
"""),

    98 : _("""
  -> Vous utilisez la formulation 'CONTINUE' de contact avec le solveur linéaire 'PETSC' et vous demandez la distribution de la matrice (MATR_DISTRIBUEE='OUI').
     La distribution de la matrice n'est pas possible dans ce cas d'utilisation.

  -> Conseil :
     Désactivez la distribution de la matrice en parallèle.
"""),

    99 : _("""
Le contact de type LAC et le contact XFEM avec ELIM_ARETE='ELIM' ne sont pas utilisables avec le solveur MULT_FRONT, il faut utiliser MUMPS.
"""),

}
