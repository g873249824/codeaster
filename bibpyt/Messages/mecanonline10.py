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

# Attention a ne pas faire de retour à la ligne !

cata_msg = {

    1  : _("""
 <Erreur> Échec dans l'intégration de la loi de comportement
"""),

    2 : _("""
 <Erreur> Échec dans le pilotage
"""),

    3 : _("""
 <Erreur> Le nombre maximum d'itérations de Newton est atteint
"""),

    4 : _("""
 <Erreur> Échec dans le traitement du contact discret
"""),

    5 : _("""
 <Erreur> Il n'y a pas assez de temps CPU pour continuer les pas de temps
"""),

    6 : _("""
 <Erreur> La matrice du système est singulière
"""),

    7 : _("""
 <Erreur> Il n'y a pas assez de temps CPU pour continuer les itérations de Newton
"""),

    8 : _("""
 <Erreur> Arrêt demandé par l'utilisateur.
"""),

    9 : _("""
 <Erreur> On dépasse le nombre de boucles de point fixe de géométrie.
 """),

    10 : _("""
 <Erreur> On dépasse le nombre de boucles de point fixe de frottement.
 """),

    11 : _("""
 <Erreur> On dépasse le nombre de boucles de point fixe de contact.
 """),

    12 : _("""
 <Erreur> Nombre maximum d'itérations atteint dans le solveur linéaire itératif.
 """),

    13 : _("""
 <Erreur> Une valeur non-physique a été atteinte (porosité négative ou supérieure à un par exemple).
 """),

    20 : _("""
 <Évènement> Instabilité détectée.
 """),

    21 : _("""
 <Évènement> Collision détectée.
 """),

    22 : _("""
 <Évènement> Interpénétration détectée.
 """),

    23 : _("""
 <Évènement> Divergence du résidu (DIVE_RESI).
 """),

    24 : _("""
 <Évènement> Valeur atteinte (DELTA_GRANDEUR).
 """),

    25 : _("""
 <Évènement> La loi de comportement est utilisée en dehors de son domaine de validité (VERI_BORNE).
 """),

   26 : _("""
 <Évènement> Divergence du résidu (RESI_MAXI).
 """),

    30 : _("""
 <Action> On arrête le calcul.
 """),

    32: _("""
 <Action> On essaie d'autoriser des itérations de Newton supplémentaires.
"""),

    33: _("""
 <Action> On essaie de découper le pas de temps.
"""),

    34 : _("""
 <Action> On essaie d'utiliser la solution de pilotage rejetée initialement.
 """),

    35 : _("""
 <Action> On essaie d'adapter le coefficient de pénalisation.
 """),

    42 : _(""" <Action><Échec> On a déjà choisi l'autre solution de pilotage."""),

    43 : _(""" <Action> On choisit l'autre solution de pilotage."""),

    44 : _(""" <Action><Échec> On ne peut plus adapter le coefficient de pénalisation (on atteint COEF_MAXI)."""),

    45 : _(""" <Action> On a adapté le coefficient de pénalisation."""),

    46 : _("""          Sur la zone <%(i1)d>, le coefficient de pénalisation adapté vaut <%(r1)13.6G>.
 """),

}
