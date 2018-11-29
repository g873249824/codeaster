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


cata_msg = {

    1 : _("""
Contact méthodes discrètes.
 -> Les méthodes de contact discrètes supposent la symétrie de la matrice obtenue après assemblage.

Il est possible de forcer la matrice à être symétrique en renseignant MATR_RIGI_SYME='OUI' sous le mot-clé facteur NEWTON ou d'utiliser la formulation CONTINUE du contact ou la méthode pénalisée par ALGO_CONT='PENALISATION'.
"""),

    3 : _("""
Contact méthode GCP. Nombre d'itérations maximal (%(i1)d) dépassé pour le préconditionneur.
Vous pouvez essayer d'augmenter ITER_PRE_MAXI
"""),

    4 : _("""
Contact méthode GCP. Le paramètre RESI_ABSO doit être obligatoirement renseigné.
"""),

    7 : _("""
Contact méthode GCP. Le pas d'avancement est négatif ; risque de comportement hasardeux de l'algorithme
"""),

    8 : _("""
Formulation discrète du contact.
 -> Il y a des éléments de type QUAD8 sur les surfaces de contact. Ces éléments ne permettent pas de respecter exactement la condition de contact.
    Afin d'empêcher une pénétration intempestive des surfaces, on a procédé à des liaisons cinématiques (LIAISON_DDL) entre les noeuds milieux et les noeuds sommets, sur les deux surfaces (maître et esclave).

 Risques et conseils :
   - Ces liaisons supplémentaires peuvent provoquer des incompatibilités avec les conditions limites en particulier dans le cas de symétries, ce qui se traduira par une matrice singulière.
     Dans ce cas, il est possible de n'appliquer les conditions aux limites concernées que sur les noeuds sommets (on pourra utiliser la commande DEFI_GROUP pour créer le groupe de noeuds adéquat).
   - Il est toutefois préférable d'utiliser sur les surfaces de contact des éléments de type QUAD9. Pour cela, transformez les éléments volumiques HEXA20 en HEXA27 ou PENTA15 en PENTA18 (par exemple avec la commande CREA_MAILLAGE).

"""),

    9 : _("""
Contact liaison glissière. Des noeuds se décollent plus que la valeur de ALARME_JEU:
"""),

    13 : _("""
La normale que vous avez prédéfinie (VECT_* = 'FIXE') sur le noeud %(k1)s est colinéaire à la tangente à la maille.
"""),

    14 : _("""
La normale que vous avez prédéfinie (VECT_* = 'FIXE') sur la maille %(k1)s est colinéaire à la tangente à la maille.
"""),

    15 : _("""
Le vecteur MAIT_FIXE ou ESCL_FIXE est nul !
"""),

    16 : _("""
Le vecteur MAIT_VECT_Y ou ESCL_VECT_Y est nul !
"""),

    17 : _("""
La taille d'un bloc vaut %(i1)d, elle est inférieure à la hauteur maximale qui vaut %(i2)d.
Changez la TAILLE_BLOC (dans la commande DEBUT) des profils. Prenez au moins : %(i3)d.
"""),

    20 : _("""
Contact méthode continue.
  La méthode de Newton généralisée pour la boucle de géométrie exige que le contact soit aussi résolu par le Newton généralisé.
"""),

    60 : _("""
La maille %(k1)s est de type 'SEG' (poutres) en 3D. Pour ces mailles la normale ne peut pas être déterminée automatiquement.
Vous devez utilisez l'option NORMALE :
- FIXE : qui décrit une normale constante pour la poutre
- ou VECT_Y : qui décrit une normale par construction d'un repère basé sur la tangente (voir documentation)
"""),

    61 : _("""
Le noeud %(k1)s fait partie d'une maille de type 'SEG' (poutres) en 3D. Pour ces mailles la normale ne peut pas être déterminée automatiquement.
Vous devez utilisez l'option NORMALE :
- FIXE : qui décrit une normale constante pour la poutre
- ou VECT_Y: qui décrit une normale par construction d'un repère basé sur la tangente (voir documentation)
"""),


    84 : _("""
Le modèle mélange des mailles avec des modélisations de dimensions différentes (2D avec 3D ou macro-éléments).
À ce moment du fichier de commandes, on ne peut dire si ce mélange sera compatible avec le contact.
"""),

    85 : _("""
Le modèle mélange des mailles avec des modélisations de dimensions différentes (2D avec 3D ou macro-éléments).
Il ne faut pas que les surfaces de contact mélangent des mailles affectées d'une modélisation plane (D_PLAN, C_PLAN ou AXIS)
avec des mailles affectées d'une modélisation 3D.
"""),

    88 : _("""
N'utilisez pas REAC_INCR=0 avec le frottement.
"""),

    93 : _("""
Contact méthode sans résolution.
 -> Interpénétrations des surfaces. Il y a %(i1)d noeuds qui s'interpénètrent.

 -> Risque & Conseil :
    Vérifier si le niveau d'interpénétration des surfaces est acceptable dans
    votre problème.
"""),

    94 : _("""
La modélisation COQUE_3D n'est pas encore compatible avec la formulation CONTINUE.
"""),


    95 : _("""L'option ADAPTATION du contact n'est pas disponible pour la méthode LAC."""),

    96 : _("""
La prise en compte d'un contact entre une maille '%(k1)s' et une maille '%(k2)s' n'est pas prévue avec la formulation CONTINUE.

Conseils :
- utilisez une formulation 'DISCRETE'
"""),

    97 : _("""
Contact méthode continue. Pour l'option SANS_GROUP_NO et SANS_GROUP_NO_FR, l'intégration de type 'AUTO' est obligatoire.
"""),

    98 : _("""
Contact méthode continue. Pour l'option NORMALE = 'MAIT_ESCL' ou NORMALE = 'ESCL', l'intégration de type 'AUTO' est obligatoire.
"""),

    99 : _("""
Contact méthode continue. Vos surfaces de contact esclaves comportent des QUAD8 et vous avez demandé l'option NORMALE = 'MAIT_ESCL' ou NORMALE = 'ESCL'
L'intégration de type 'AUTO' est incompatible avec cette option.

Conseil : utilisez un autre schéma d'intégration ou bien des QUAD9.

"""),

}
