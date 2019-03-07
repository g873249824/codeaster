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

    1: _("""
 le paramètre %(k2)s n'existe pas dans la table %(k1)s
"""),

    2: _("""
 problème pour récupérer dans la table %(k1)s la valeur du paramètre %(k2)s
   pour le paramètre %(k3)s de valeur %(r1)12.5E et
   pour le paramètre %(k4)s de valeur %(r2)12.5E
"""),

    3: _("""
 l'option "AMORCAGE" est traitée seule
"""),

    4: _("""
 il manque la donnée de la limite d'élasticité (SY_MAX ou SY_02) pour le calcul du rochet thermique
"""),

    5: _("""
 le calcul du critère du rochet thermique pour une variation de température linéaire est impossible
        X = SIGM / SY MAX =  %(r1)12.5E
         SIGM =  %(r2)12.5E
        SY MAX =  %(r3)12.5E
        on doit avoir 0. < X < 1.
"""),

    6: _("""
 le calcul du critère du rochet thermique pour une variation de température parabolique est impossible
        X = SIGM / SY MAX =  %(r1)12.5E
         SIGM =  %(r2)12.5E
        SY MAX =  %(r3)12.5E
        on doit avoir 0.3 < X < 1.
"""),

    7: _("""
 il faut définir le comportement %(k1)s dans "DEFI_MATERIAU"
"""),

    8: _("""
 erreur données, pour le noeud %(k1)s de la maille %(k2)s
 il manque les caractéristiques élémentaires (le CARA_ELEM)
"""),

    9: _("""
 erreur données, pour le noeud %(k1)s de la maille %(k2)s
 il manque l'indice de contraintes %(k3)s
"""),

    10: _("""
 matériau non défini, maille %(k1)s
"""),

    12: _("""
 "NUME_GROUPE" est obligatoire, il doit contenir au moins 1 valeur qui 
 doit être strictement positive
"""),

    13: _("""
 Problème lors du passage du CH_MATER en CARTE
 Contactez le support
"""),

    14: _("""
 Problème lors du passage du TEMPE_REF en CARTE
 Contactez le support
"""),

    15: _("""
 erreur données, pour la situation numéro %(i1)d sur la maille numéro %(i2)d
 il manque le %(k1)s
"""),

    16: _("""
 problème pour récupérer dans la table %(k1)s la valeur du paramètre %(k2)s
   pour le paramètre %(k3)s de valeur %(k5)s et
   pour le paramètre %(k4)s de valeur %(r1)12.5E
"""),

    17: _("""
 problème pour récupérer dans la table  %(k1)s les valeurs du paramètre %(k4)s
   pour le paramètre %(k2)s de valeur %(k3)s
"""),

    18: _("""
 erreur données, il manque le %(k1)s
   pour la maille numéro %(i1)d et le noeud numéro %(i2)d
"""),

    19: _("""
 si on est la, y a un bogue!
 Contactez le support
"""),

    20: _("""
 champ de nom symbolique %(k1)s inexistant pour le RESULTAT %(k2)s
 défini sous l'occurrence numéro %(i1)d
"""),

    21: _("""
 il ne faut qu'un seul champ de nom symbolique %(k1)s pour le RESULTAT %(k2)s
 défini sous l'occurrence numéro %(i1)d
"""),






    23: _("""
 on n'a pas pu récupérer le résultat thermique correspondant au numéro %(i2)d
 défini par le mot clé "NUME_RESU_THER" sous le mot clé facteur "RESU_THER"
 occurrence numéro %(i1)d
"""),

    24: _("""
 erreur données, pour la situation numéro %(i1)d sur la maille numéro %(i2)d
   problème sur le résultat thermique
"""),

    25: _("""
 erreur données, pour la situation numéro %(i1)d sur la maille numéro %(i2)d et le noeud numéro %(i3)d
   problème sur le résultat thermique
"""),

    26: _("""
 il faut définir qu'un seul séisme dans un groupe
   groupe numéro %(i1)d
   occurrence situation %(i2)d et %(i3)d
"""),

    28: _("""
 erreur données, pour la situation numéro %(i1)d
 on n'a pas pu récupérer le "RESU_MECA" correspondant au numéro du cas de charge %(i2)d
"""),

    29: _("""
 erreur données, pour la situation numéro %(i1)d
 on ne peut pas avoir des charges de type "séisme" et "autre".
"""),

    31: _("""
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    32: _("""
 le nombre de cycles admissibles est négatif, vérifiez la courbe de WOHLER
   contrainte calculée: %(r1)12.5E
   Nombre de cycles admissibles: %(r2)12.5E
"""),

    33: _("""
 la distance calculée à partir des ABSC_CURV de la table fournie %(k1)s
 est supérieure à 1 pour cent à la distance récupérée dans le matériau. Vérifiez vos données.
   distance calculée: %(r1)12.5E
   D_AMORC          : %(r2)12.5E
"""),

    34: _("""
 "NUME_PASSAGE" contient les numéros des groupes reliés par la situation de passage, 
 ces numéros sont strictement positifs et différents. La situation de passage doit également appartenir
 à tous ces groupes.
"""),

    36: _("""
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    37: _("""
 -> L'ordre des noeuds de la table %(k1)s n'est pas respecté.
    Les noeuds doivent être rangés d'une des peaux vers l'autre.
 -> Risque & Conseil:
    Veuillez consulter la documentation U2.09.03.
"""),

    38: _("""
 -> Les noeuds de la ligne de coupe %(k2)s (table %(k1)s) ne sont pas alignés:
    - distance maximale à la ligne de coupe: %(r1)f
    - longueur de la ligne de coupe        : %(r2)f
 -> Risque & Conseil:
    Les calculs avec POST_RCCM ne sont théoriquement valides que pour des lignes
    de coupe rectilignes. Vérifier les données d'entrée ou utiliser
    MACR_LIGN_COUPE pour extraire le résultat sur un segment de droite.
"""),

    39: _("""
 -> Il est préférable de fournir des tables comportant les coordonnées des noeuds.
"""),

    40: _("""
 -> Pour le cas unitaire, il doit y avoir un seul ligament.
    La table %(k1)s contient %(i1)d ligaments.
 -> Risque & Conseil:
    Veuillez revoir le contenu de votre table.
 """),

    41: _("""
 -> Les tables %(k1)s et %(k2)s ont des noeuds possédant
    des coordonnées différentes:
    - table %(k1)s : %(k3)s = %(r1)f
    - table %(k2)s : %(k3)s = %(r2)f
 -> Risque & Conseil:
    Veuillez revoir le contenu de vos tables
"""),

    42: _("""
 -> Les tables %(k1)s et %(k2)s ne sont pas cohérentes en terme de nombre
    de ligaments:
    - table %(k1)s : %(i1)d ligaments
    - table %(k2)s : %(i2)d ligaments
 -> Risque & Conseil:
    Veuillez revoir le contenu de vos tables
"""),

    43: _("""
 -> Les tables %(k1)s et %(k2)s ne sont pas cohérentes en terme d'instant:
    Une différence a été observée entre les valeurs d'instant d'un même point
    - table %(k1)s : INST = %(r1)f
    - table %(k2)s : INST = %(r2)f
 -> Risque & Conseil:
    Veuillez revoir le contenu de vos tables

"""),

    44: _("""
 problème pour récupérer dans la table %(k1)s la valeur du paramètre %(k2)s
 pour le paramètre %(k3)s de valeur %(r1)12.5E.
"""),

    45: _("""
 Les tables en entrée ne sont pas définies sur les mêmes abscisses.
"""),

    46: _("""
 Les données sous CHAR_MECA et TUYAU/INDI_SIGM ne sont pas cohérentes (cas corps/tubulure).
"""),

    47: _("""
 Afin de permettre l'interpolation, les températures sous TEMP_A et TEMP_B doivent être
    différentes.
"""),

    48: _("""
 Deux situations ne peuvent avoir le même numéro.
"""),

    49: _("""
 Le mot clé facteur RESU_MECA_UNIT n'a pas été renseigné.
"""),

    50: _("""
 L'option 'PM_PB' pour un calcul en B3200 n'est compatible qu'avec des chargements unitaires.
"""),

    51: _("""
 Le numéro de chargement sous CHAR_ETAT n'existe pas sous CHAR_MECA.
"""),

    52: _("""
 Seules les 200 premières combinaisons interviennent dans le facteur d'usage.
"""),

    53: _("""
 Les situations d'un groupe de partage devraient appartenir au même groupe de fonctionnement
 et avoir le même nombre d'occurrences initial. 
 Le groupe de partage doit avoir un numéro strictement positif.
"""),

    54: _("""
 Il manque une donnée en fatigue environnementale. De plus, le FEN_INTEGRE doit être 
 strictement positif. 
"""),

    55: _("""
 Les instants des transitoires ne sont pas ordonnés de manière croissante. Cela peut 
 nuire aux résultats sur les sous-cycles ou la fatigue environnementale. 
"""),

    56: _("""
 Les sous-cycles ne seront pas pris en compte avec la méthode de sélection des instants 'TRESCA'. 
"""),

    57: _("""
 Seuls les 100 premiers sous-cycles extraits seront pris en compte. 
"""),

}
