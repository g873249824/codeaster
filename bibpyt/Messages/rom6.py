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

# person_in_charge: mickael.abbas at edf.fr

cata_msg = {

   2  : _("""Le modèle doit être le même sur les deux bases."""),

   3  : _("""Initialisations pour le post-traitement du calcul réduit."""),

   4  : _("""On ne trouve pas la table des coordonnées réduites dans la structure de données résultat. Vérifiez qu'il vient bien d'un calcul réduit et que les résultats n'ont pas été produits par LIRE_RESU ou CREA_RESU."""),

   7  : _("""Le résultat sur le modèle complet sera de type %(k1)s."""),

   8  : _("""Le modèle est le même pour la reconstruction que le modèle réduit d'origine."""),

   9  : _("""Le modèle de la base %(k1)s n'est pas celui du modèle complet. Vérifiez que vous n'utilisez pas la base tronquée."""),

   11 : _("""Le résultat sur le modèle réduit contient %(i1)d numéros d'ordre."""),

   12 : _("""La base empirique est construite sur un maillage différent du modèle. Ce n'est pas possible."""),

   13 : _("""Les deux modèles sont identiques, on ne peut rien tronquer !"""),

   14 : _("""On évalue le champ dual."""),

   15 : _("""Correction par le calcul éléments finis."""),

   20 : _("""Reconstruction des champs sur tout le domaine."""),

   21 : _("""Reconstruction du champ primal."""),

   22 : _("""Reconstruction du champ dual."""),

   30 : _("""Construction de la matrice des modes. Dimensions: [%(i1)d,%(i2)d]."""),

   31 : _("""Calcul des coordonnées réduites."""),

   32 : _("""Échec lors du calcul des coordonnées réduites."""),

   33 : _("""Le mode empirique de numéro d'ordre %(i1)d dans la base est mis à zéro."""),

   34 : _("""Création de la liste des noeuds appartenant au domaine réduit."""),

   35 : _("""Le nombre de composantes par noeud n'est pas constant."""),

   36 : _("""Le modèle est variable pendant le calcul, ce n'est pas possible en réduction de modèle."""),

   37 : _("""Préparation de la liste des équations appartenant au domaine réduit."""),

   38 : _("""Initialisations pour le post-traitement du calcul réduit, quantités primales."""),

   39 : _("""Initialisations pour le post-traitement du calcul réduit, quantités duales."""),

   40 : _("""Vous avez donné le nom de la base à tronquer (BASE_INIT) alors que vous voulez tronquer une base déjà existante."""),
}
