# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

    4 : _(u"""
  le nombre de noeuds sélectionnés est supérieur au nombre de noeuds du maillage. on va tronquer la liste.
"""),

    6 : _(u"""
 type inconnu" %(k1)s "
"""),

    7 : _(u"""
 Le fichier correspondant à l'unité logique renseignée pour l'écriture de résultats au format MED
 est de type ASCII. Cela peut engendrer l'affichage de messages intempestifs provenant de la 
 bibliothèque MED. Il n'y a toutefois aucun risque de résultats faux.
 
 Conseils : pour supprimer l'émission de ce message d'alarme, il faut donner la valeur BINARY au
 mot-clé TYPE de DEFI_FICHIER."
"""),

    9 : _(u"""
 type de base inconnu:  %(k1)s
"""),

    10 : _(u"""
 soit le fichier n'existe pas, soit c'est une mauvaise version de HDF (utilise par MED).
"""),


    31 : _(u"""
 on n'a pas trouvé le numéro d'ordre à l'adresse indiquée
"""),

    32 : _(u"""
 on n'a pas trouvé l'instant à l'adresse indiquée
"""),

    33 : _(u"""
 on n'a pas trouvé la fréquence à l'adresse indiquée
"""),

    34 : _(u"""
 on n'a pas trouvé dans le fichier UNV le type de champ
"""),

    35 : _(u"""
 on n'a pas trouvé dans le fichier UNV le nombre de composantes à lire
"""),

    36 : _(u"""
 on n'a pas trouvé dans le fichier UNV la nature du champ
 (réel ou complexe)
"""),

    37 : _(u"""
 le type de champ demandé est différent du type de champ à lire
"""),

    38 : _(u"""
 le champ demande n'est pas de même nature que le champ à lire
 (réel/complexe)
"""),

    39 : _(u"""
 le mot clé MODELE est obligatoire pour un CHAM_ELEM
"""),

    40 : _(u"""
 Problème correspondance noeud IDEAS
"""),

    41 : _(u"""
 le champ de type ELGA n'est pas supporté
"""),




    65 : _(u"""
 pour la variable d'accès "NOEUD_CMP", il faut un nombre pair de valeurs.
"""),

    66 : _(u"""
 le modèle et le maillage introduits ne sont pas cohérents
"""),

    68 : _(u"""
 vous voulez imprimer sur un même fichier le maillage et un champ
 ce qui est incompatible avec le format GMSH
"""),

    69 : _(u"""
 L'impression d'un champ complexe nécessite l'utilisation du mot-clé PARTIE.
 Ce mot-clé permet de choisir la partie du champ à imprimer (réelle ou imaginaire).
"""),

    70 : _(u"""
 Vous avez demandé une impression au format ASTER sans préciser de MAILLAGE.
 Aucune impression ne sera réalisée car IMPR_RESU au format ASTER n'imprime qu'un MAILLAGE.
"""),

    74 : _(u"""
 Le maillage %(k1)s n'est pas cohérent avec le maillage %(k2)s portant le résultat %(k3)s
"""),

    75 : _(u"""
 fichier GIBI créé par SORT FORMAT non supporté dans cette version
"""),

    76 : _(u"""
 version de GIBI non supportée, la lecture peut échouer
"""),

    77 : _(u"""
 fichier GIBI erroné
"""),

    78 : _(u"""
 le fichier maillage GIBI est vide
"""),

    81 : _(u"""
 Il n'a pas été possible de récupérer d'information concernant la matrice de masse
 assemblée de la structure. Le calcul de l'option %(k1)s n'est donc pas possible.
 """),

    84 : _(u"""
 il faut autant de composantes en i et j
"""),

    85 : _(u"""
 il faut autant de composantes que de noeuds
"""),

    93 : _(u"""
 la fonction n'existe pas.
"""),

    94 : _(u"""
 il faut définir deux paramètres pour une nappe.
"""),

    95 : _(u"""
 pour le paramètre donné on n'a pas trouvé la fonction.
"""),

    96 : _(u"""
 Pour les calculs harmoniques, la version actuelle du code ne permet pas de
 restreindre l'estimation de REAC_NODA sur un groupe de mailles.
"""),


}
