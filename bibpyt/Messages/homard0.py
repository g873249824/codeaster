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
    1: _("""
Cette macro-commande est inconnue.
"""),

    2: _("""
Erreur : %(k1)s
"""),

    3: _("""
Impossible de tuer le fichier %(k1)s
"""),

    4: _("""
Impossible de créer le répertoire de travail pour HOMARD : %(k1)s
"""),

    5: _("""
Impossible de détruire le fichier :%(k1)s
"""),

    6: _("""
La vérification de l'interpénétration peut être très longue.
Il ne faut l'utiliser que volontairement. Voir la documentation.
"""),

    7: _("""
Dès que le nombre de mailles est important, la vérification de l'interpénétration peut devenir très longue.
En principe, on ne devrait l'utiliser que dans les cas suivants :
  . Informations sur un maillage avec MACR_INFO_MAIL
  . Débogage sur une adaptation avec MACR_ADAP_MAIL
Conseil :
Pour un usage courant de l'adaptation, il est recommandé de passer à NON toutes les
options de contrôle ; autrement dit, laisser les options par défaut.
"""),

    8: _("""
Impossible de trouver le répertoire de travail pour HOMARD : %(k1)s
Certainement un oubli dans le lancement de la poursuite.
"""),

    9: _("""
Vous demandez une adaptation du maillage %(k1)s vers %(k2)s
Auparavant, vous aviez déjà fait une adaptation qui a produit le maillage %(k3)s
Ce maillage %(k3)s est le résultat de %(i1)d adaptation(s) à partir du maillage initial %(k4)s

Les arguments que vous avez donnés à MACR_ADAP_MAIL ne permettront pas de tenir compte
de l'historique d'adaptation. Est-ce volontaire ?
Pour poursuivre la séquence, il faudrait partir maintenant de %(k3)s.

"""),

    10: _("""
Le fichier %(k1)s est inconnu.
"""),



}
