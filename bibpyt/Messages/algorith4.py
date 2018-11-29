# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

    10 : _("""
Pas de couplage possible avec UMLV et le comportement %(k1)s.
"""),

    35 : _("""
 rang supérieur a dimension vecteur
"""),

    36 : _("""
Il faut redécouper.
"""),

    45 : _("""
 la modélisation 1d n'est pas autorisée
"""),


    46 : _("""
  -> Le calcul de l opérateur tangent dans la phase %(k1)s a échoué.
     1. RIGI_MECA_TANG=première itération de prédiction tangente dans un pas de temps
     2. FULL_MECA=itérations de correction de Newton
  -> Risque & Conseil :
     1. On conseille l'utilisation de la PREDICTION=ELASTIQUE, REAC_ITER=n, avec n>1
     2. Vérifiez les paramètres d'entrée comme le matériau,... .
     3. Contactez l'assistance si le problème persiste
"""),


    48 : _("""
 élément à discontinuité avec une loi CZM_EXP : la matrice H est non inversible
"""),


    50 : _("""
  comportement inattendu :  %(k1)s
"""),

    51 : _("""
  SYT et D_SIGM_EPSI doivent être spécifiés sous l'opérande BETON_ECRO_LINE dans DEFI_MATERIAU pour utiliser la loi ENDO_ISOT_BETON
"""),

    52 : _("""
  SYC ne doit pas être valorisé pour NU nul dans DEFI_MATERIAU
"""),

    53 : _("""
  SYC doit être supérieur dans DEFI_MATERIAU pour prendre en compte le confinement
"""),

    54 : _("""
 loi ENDO_ORTH_BETON : le paramètre KSI n'est pas inversible
"""),

    57 : _("""
 Problème de convergence (l'accroissement de déformation plastique est négatif).
 On active le redécoupage du pas de temps.
"""),

    58 : _("""
 pas de solution
"""),

    59 : _("""
 erreur: Problème de convergence. Le nombre d'itération maximal est atteint. On active le redécoupage du pas de temps.
"""),

    60 : _("""
 Problème de convergence (l'accroissement de déformation plastique est négatif).
 Pensez à activer le redécoupage du pas de temps.
"""),

    61 : _("""
 erreur: Problème de convergence. Le nombre d'itération maximal est atteint. Pensez à activer le redécoupage du pas de temps.
"""),

    62 : _("""
 loi BETON_REGLE_PR utilisable uniquement en modélisation C_PLAN ou D_PLAN
"""),

    63 : _("""
 la méthode de localisation  %(k1)s  est indisponible actuellement
"""),

    65 : _("""
  %(k1)s  impossible actuellement
"""),


    72 : _("""
  jacobien du système non linéaire à résoudre nul
  lors de la projection au sommet du cône de traction
  les paramètres matériaux sont sans doute mal définis
"""),

    73 : _("""
  non convergence à itération max  %(k1)s
  - erreur calculée  %(k2)s  >  %(k3)s
  mais très faibles incréments de Newton pour la loi BETON_DOUBLE_DP
  - on accepte la convergence.
"""),

    74 : _("""
  non convergence à itération max  %(k1)s
  - erreur calculée  %(k2)s  >  %(k3)s
  - pour la loi BETON_DOUBLE_DP
  - redécoupage du pas de temps
"""),

    75 : _("""
 état converge non conforme
 lors de la projection au sommet du cône de traction
"""),

    76 : _("""
 état converge non conforme en compression
 lors de la projection au sommet du cône de traction
"""),

    77 : _("""
 jacobien du système non linéaire à résoudre nul
 lors de la projection au sommet des cônes de compression et traction
 - les paramètres matériaux sont sans doute mal définis.
"""),

    78 : _("""
 état convergé non conforme en traction
 lors de la projection au sommet des deux cônes
"""),

    79 : _("""
 état convergé non conforme en compression
 lors de la projection au sommet des deux cônes
"""),

    80 : _("""
  jacobien du système non linéaire à résoudre nul
  lors de la projection au sommet du cône de compression
  - les paramètres matériaux sont sans doute mal définis.
"""),

    81 : _("""
 état convergé non conforme
 lors de la projection au sommet du cône de compression
"""),

    82 : _("""
 état convergé non conforme en traction
 lors de la projection au sommet du cône de compression
"""),

    83 : _("""
  jacobien du système non linéaire a résoudre nul
  - les paramètres matériaux sont sans doute mal définis.
"""),

    84 : _("""
 intégration élastoplastique de loi multicritère : erreur de programmation
"""),

    85 : _("""
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    86 : _("""
  état convergé non conforme en traction et en compression
  pour la loi de comportement BETON_DOUBLE_DP
  pour les deux critères en même temps.
  il faut un saut élastique plus petit, ou redécouper le pas de temps
"""),

    87 : _("""
  état converge non conforme en compression
  pour la loi de comportement BETON_DOUBLE_DP
  pour les deux critères en même temps.
  il faut un saut élastique plus petit, ou redécouper le pas de temps
"""),

    88 : _("""
  état convergé non conforme en traction
  pour la loi de comportement BETON_DOUBLE_DP
  pour les deux critères en même temps.
  il faut un saut élastique plus petit, ou redécouper le pas de temps
"""),

    89 : _("""
 état convergé non conforme en traction
"""),

    90 : _("""
 état convergé non conforme en compression
"""),

    94 : _("""
 il faut déclarer FONC_DESORP sous ELAS_FO pour le fluage propre                                avec SECH comme paramètre
"""),

    98 : _("""
 nombre de valeurs dans le fichier UNV DATASET 58 non identique
"""),

    99 : _("""
 nature du champ dans le fichier UNV DATASET 58 non identique
"""),






}
