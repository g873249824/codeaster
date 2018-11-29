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
    Informations extraites de Code_Aster
    %(k1)s:
    Instant : %(r1)f
    Abscisse(T)        : %(r2)f - %(r3)f
    Min T          : %(r4)f
    Max T          : %(r5)f
    Abscisse(position) : %(r6)f - %(r7)f
"""),

    2: _("""
    Informations en entrée de Écrevisse
    Instant : %(r1)f
    Abscisse(T)   : %(r2)f - %(r3)f
    Min Température moyenne   : %(r4)f
    Max Température moyenne   : %(r5)f
    Abscisse(Ouverture) : %(r6)f - %(r7)f
    Min Ouverture   : %(r8)e
    Max Ouverture   : %(r9)e
    Min Glissement  : %(r10)e
    Max Glissement  : %(r11)e
"""),

    3: _("""
 INSTANT : %(r1)f. Il n'y a pas de résultat thermique, on ne lance pas Écrevisse...
"""),

    4: _("""
 INSTANT : %(r1)f. Les ouvertures sont trop faibles %(r2)f, on ne lance pas Écrevisse...
"""),

    5: _("""
 INSTANT : %(r1)f. Les températures sont trop fortes %(r2)f, on ne lance pas Écrevisse...
"""),

    6: _("""
 INSTANT : %(r1)f. Les températures sont trop faibles %(r2)f, on ne lance pas Écrevisse...
"""),

    7: _("""
 INSTANT : %(r1)f. Le différentiel de pression est trop faible %(r2)f, on ne lance pas Écrevisse...
"""),

    8: _("""
 INSTANT : %(r1)f. On lance Écrevisse...
"""),

    9: _("""
 INSTANT : %(r1)f. Problème dans la récupération des résultats Écrevisse...
"""),


    11: _("""
 Erreur système : impossible de générer le fichier de données pour Écrevisse!
"""),

    12: _("""
 Impossible de créer le répertoire de travail pour le logiciel Écrevisse : %(k1)s
"""),

    13: _("""
 L'exécutable indique par le mot-clé LOGICIEL n'existe pas!
"""),

    14: _("""
 Impossible de faire un lien symbolique, on copie l'exécutable Écrevisse
"""),

    15: _("""
 Impossible de copier l'exécutable Écrevisse
"""),

    16: _("""
 Lancement de l'exécution d'écrevisse...
"""),

    17: _("""
 Fin de l'exécution de Écrevisse.
"""),

    18: _("""
 Il n'y a pas de fichiers résultats de Écrevisse.
 On renvoie une table vide.
 Penser a vérifier que le débit soit établi et non nul.
"""),

    20: _("""
 Il faut au minimum %(i1)d temps dans la liste d'instants
"""),

    23: _("""
 ATTENTION : l'ancienne version du couplage Code_Aster/Écrevisse (qui utilise le flux de chaleur)
 ne marche que avec fissures horizontales et verticales!!
 L'angle thêta forme avec la verticale est égal a  %(r1)f.
"""),

    24: _("""
 ERREUR : copie %(k1)s --> %(k2)s
"""),

    25: _("""
 ERREUR : le numéro d'ordre %(i1)d pour l'état initial n'existe pas.
"""),

    26: _("""
 ERREUR : le dernier instant %(r1)f de la liste précède ou est égal à l'instant de l'état initial %(r2)f.
 On ne fait pas la poursuite.
"""),

    30: _("""
 Nombre de découpage d'un pas de temps atteint. On arrête le processus.
 Tous les instants converges sont conserves.
   entre l'instant %(r1)f et l'instant %(r2)f
   MACR_ECREVISSE/MACR_CONVERGENCE/SUBD_NIVEAU : %(i1)d
"""),

    31: _("""
 Pas de temps mini atteint lors du découpage d'un pas de temps. On arrête le processus.
 Tous les instants converges sont conserves.
   entre l'instant %(r1)f et l'instant %(r2)f, on ne peut pas insérer l'instant %(r3)f
   MACR_ECREVISSE/MACR_CONVERGENCE/SUBD_PAS_MINI : %(r4)f
"""),

    32: _("""
 Non convergence, itération %(i1)d, ajout d'un pas temps dans l'intervalle de temps [ %(r1)f , %(r2)f ]
 Insertion de l'instant %(r3)f
"""),

    33: _("""
 Le NUME_ORDRE_MIN %(i1)d qui correspond a l'instant %(r1)f est <= %(i2)d ]
 La convergence est forcée.
"""),

    34: _("""
 CONVERGENCE MACR_ECREVISSE - Instant de calcul : %(r1)f
   Erreur en Température : %(r2)f ; Écart en Température : %(r3)f
   Erreur en Pression    : %(r4)f ; Écart en Pression    : %(r5)f
   Erreur Température/Pression     : %(r6)f  ]
"""),

    34: _("""
 CONVERGENCE MACR_ECREVISSE - Instant de calcul : %(r1)f
   Erreur en Température : %(r2)f ; Écart en Température : %(r3)f
   Erreur en Pression    : %(r4)f ; Écart en Pression    : %(r5)f
   Erreur Température/Pression     : %(r6)f  ]
"""),

    35: _("""
 CONVERGENCE MACR_ECREVISSE - Instant de calcul : %(r1)f
    Nature du critère : %(k1)s
    Valeur du critère : %(k2)s
    Convergence : %(k3)s
"""),

    36: _("""
 CONVERGENCE MACR_ECREVISSE - Premier instant de calcul : %(r1)f
   Pas de calcul de critère.
"""),

    37: _("""
Convergence atteinte a l'instant de calcul %(r1)f, on passe au pas de temps suivant
"""),

    38: _("""
ATTENTION : au moins pour une valeur des cotes, le glissement relatif des deux points
correspondants sur les lèvres de le fissure est plus grand que la dimension des mailles adjacentes
"""),

    39: _("""
ATTENTION : au moins pour une valeur des cotes, la distance entre deux points
correspondants sur les lèvres de la fissure est plus petite que l'ouverture rémanente
"""),

    40: _("""
ATTENTION : il n'y a pas le même nombre de noeuds sur les lèvres de la fissure.
"""),

    41: _("""
INFO : Le calcul d'écoulement a été fait avec un ouverture de fissure égale a l'ouverture rémanente pour %(r1)f points
"""),

    42: _("""
Le paramètre TORTUOSITE doit être strictement positif
"""),
}
