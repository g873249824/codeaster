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
 La base modale à normer (%(k1)s) est soit composée, soit issue d'une restitution
 sur base physique d'une autre base, mais en coordonnées généralisées.

 Pour pouvoir mettre à jour les paramètres modaux, des informations sur les
 matrices de rigidité et de masse sont nécessaires.
"""),

    2: _("""
 À défaut de trouver l'information exacte pour la matrice de rigidité sous le
 mot-clé RAIDE, on utilisera la matrice %(k1)s référencée dans la base.

 Conseil :

 Si la matrice %(k1)s ne correspond pas à la matrice de rigidité du système. Il
 faudra renseigner le mot-clé RAIDE pour forcer l'utilisation de la bonne matrice.
"""),

    3: _("""
 À défaut de trouver l'information exacte pour la matrice de masse sous le
 mot-clé MASSE, on utilisera la matrice %(k1)s référencée dans la base.

 Conseil :

 Si la matrice %(k1)s ne correspond pas à la matrice de masse du système. Il
 faudra renseigner le mot-clé MASSE pour forcer l'utilisation de la bonne matrice.
"""),

    4: _("""
 valeur inférieure à la tolérance
"""),

    5: _("""
 Combinaison linéaire de matrices :
 pour l'instant, on ne traite que le cas des matrices réelles
"""),

    6: _("""
 Conseil :

 Renseignez les mots-clés RAIDE et MASSE.
"""),

    7: _("""
Impossible de récupérer les valeurs dans la table
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    8: _("""
 La base modale est issue de DEFI_BASE_MODALE et contient des modes complexes.
 Pour normer par rapport à RIGI_GENE ou MASS_GENE,
 il faut donner une matrice d'amortissement.

 Conseil :
  Renseignez le mot-clé AMOR.
"""),

    14: _("""
 les mailles doivent être de type QUAD4 ou TRI3 et non de type  %(k1)s
"""),

    15: _("""
 l'angle au noeud  %(k1)s  formé par :
    - le vecteur normal de la maille  %(k2)s
 et - le vecteur normal de la maille  %(k3)s
 est supérieur à 90 degrés et vaut  %(k4)s  degrés.
"""),

    16: _("""
 PREF_NOEUD est trop long ou PREF_NUME est trop grand
"""),

    17: _("""
 PREF_MAILLE est trop long ou PREF_NUME est trop grand
"""),

    18: _("""
 mot-clé facteur  %(k1)s  non traité
"""),

    19: _("""
 le GROUP_NO  %(k1)s  n'existe pas
"""),

    20: _("""
 le nombre de noeuds n'est pas le même pour les deux GROUP_NO
"""),

    21: _("""
 les GROUP_NO ne contiennent qu'un seul noeud
"""),

    22: _("""
 création QUAD4 dégénéré
"""),

    23: _("""
 le noeud  %(k1)s  n'est pas équidistant des noeuds  %(k2)s  et  %(k3)s  pour la maille : %(k4)s
 Améliorez le  maillage. Le code s'arrête pour éviter des résultats faux.
 - distance n1-n3 = %(r1)g
 - distance n2-n3 = %(r2)g
 - tolérance      = %(r3)g
"""),

    24: _("""
 valeur négative ou nulle pour la puissance quatrième du nombre d'ondes.
 La valeur de l'ordre de coque est mal déterminée.
 Il faut affiner le maillage sur les coques :
 => réduire le pas angulaire pour définir plus de noeuds sur les contours.
"""),

    25: _("""
 Nombre de noeuds sur la génératrice inférieur à 4 :
 c'est insuffisant pour déterminer les coefficients de la déformée axiale
"""),

    26: _("""
 déplacement radial maximum nul sur la génératrice
"""),

    27: _("""
  -> Il y a au moins un point d'une zone dont la vitesse réduite locale est
     extérieure à la zone des vitesses réduites explorées expérimentalement.
  -> Risque & Conseil :
     Les valeurs sont extrapolées en dehors des données d'essais.
     Les résultats du calcul seront a prendre avec circonspection.
"""),

    28: _("""
 Détermination des coefficients de la déformée axiale,
 erreur relative sur la norme des déplacements radiaux : %(r1)g
"""),

    29: _("""
 L'ordre de coque est peut-être mal identifié.
 La base modale est trop riche ou le nombre de noeuds du maillage sur une circonférence
 est trop faible
"""),

    30: _("""
 somme des carrés des termes diagonaux nulle
 => critère indéfini
"""),

    31: _("""
 somme des carrés des termes diagonaux négligeable
 => critère indéfini
"""),

    32: _("""
 CHAM_CINE différent de zéro sur des DDL non éliminés.
"""),

    33: _("""
 la carte des caractéristiques géométriques des éléments de poutre n'existe pas
"""),

    34: _("""
 caractéristiques géométriques élémentaires de poutre non définies pour la maille  %(k1)s
"""),

    35: _("""
 l'une ou l'autre des composantes <R1> et <R2> n'existe pas dans le champ de la grandeur
"""),

    36: _("""
 la section de l'élément de poutre considéré n'est pas circulaire
"""),

    37: _("""
 rayon extérieur nul à l'une ou l'autre des extrémités de l'élément considéré
"""),

    38: _("""
 le rayon extérieur n'est pas constant sur l'élément considéré
"""),

    42: _("""
 les vitesses réduites des fichiers .70 et .71 ne sont pas cohérentes
"""),

    43: _("""
 les vitesses étudiées doivent être strictement positives
 le sens de l'écoulement est défini par le choix de la configuration expérimentale GRAPPE2 de référence
"""),

    44: _("""
 seuls les cas d'enceintes circulaires et rectangulaires sont traités.
"""),

    45: _("""
 le nombre total de tubes ne correspond pas à la somme des tubes des groupes d'équivalence
"""),

    46: _("""
 la direction des tubes n'est pas parallèle à l'un des axes.
"""),

    47: _("""
 la direction des tubes n'est la même que celle de l'axe directeur.
"""),

    48: _("""
 les vitesses étudiées doivent toutes être du même signe
 sinon il y a ambiguïté sur les positions d entrée/sortie
"""),

    49: _("""
 nombre de noeuds insuffisant sur la coque interne
"""),

    50: _("""
 coque interne de longueur nulle
"""),

    51: _("""
 nombre de noeuds insuffisant sur la coque externe
"""),

    52: _("""
 coque externe de longueur nulle
"""),

    53: _("""
 le domaine de recouvrement des coques interne et externe n'existe pas
"""),

    54: _("""
 la carte des caractéristiques géométriques des éléments de coque n'existe pas. il faut préalablement affecter ces caractéristiques aux groupes de mailles correspondant aux coques interne et externe, par l opérateur <AFFE_CARA_ELEM>
"""),

55: _("""
  Des difficultés de convergence ont été rencontrées lors du calcul des
  coefficients de couplage pour le mode no. %(i1)d et la vitesse %(r1)f
"""),

    56: _("""
 les caractéristiques des éléments de coque n'ont pas été affectées
 distinctement à l'un ou(et) l'autre des groupes de mailles associés
 aux coques interne et externe
"""),

    57: _("""
 la composante <EP> n'existe pas dans le champ de la grandeur
"""),

    58: _("""
 pas d'épaisseur affectée aux éléments de la coque interne
"""),

    59: _("""
 épaisseur de la coque interne nulle
"""),

    60: _("""
 pas d'épaisseur affectée aux éléments de la coque externe
"""),

    61: _("""
 épaisseur de la coque externe nulle
"""),

    62: _("""
 incohérence dans la définition de la configuration : le rayon d une des coques est nul
"""),

    63: _("""
 incohérence dans la définition de la configuration :
 jeu annulaire négatif ou nul
"""),

    64: _("""
 élément  %(k1)s  non traite
"""),

    65: _("""
 on ne peut dépasser  %(k1)s  mailles
"""),

    66: _("""
 coefficient de type non prévu
"""),

67: _("""
  Nous sauvegardons quand-même les paramètres de couplage qui n'ont pas convergé
  pour cette vitesse. (STOP_ERREUR='NON')
"""),

    68: _("""
 la zone d excitation du fluide, de nom  %(k1)s , est réduite a un point.
"""),

    69: _("""
 la zone d'excitation du fluide, de nom  %(k1)s , recoupe une autre zone.
"""),

    70: _("""
 le noeud d'application de l'excitation doit appartenir à deux mailles
 ni plus ni moins
"""),

    71: _("""
 le noeud d'application de l excitation est situe à la jonction
 de deux éléments de diamètres extérieurs différents
 => ambiguïté pour le dimensionnement de l'excitation
"""),

    72: _("""
 autres configurations non traitées
"""),

    73: _("""
 le cylindre  %(k1)s  n a pas un axe rectiligne
"""),

74: _("""
  -> Conseil :
  Soit : - relancer le calcul en modifiant la discrétisation en vitesses
           afin d'éviter ce point singulier.
         - retenir les résultats qui n'ont pas convergé avec STOP_ERREUR = 'NON'.
"""),

    75: _("""
 la composante n'est pas dans le CHAM_ELEM
"""),

    76: _("""
 résolution impossible matrice singulière
 peut être à cause des erreurs d'arrondis
"""),

    77: _("""
 erreur dans l'inversion de la masse
"""),

    78: _("""
 erreur dans la recherche des valeurs propres
 pas de convergence de l algorithme QR
"""),

    79: _("""
 le nombre de modes résultats:  %(k1)s  n'est pas correct
"""),

    80: _("""
 les cylindres  %(k1)s  et  %(k2)s  se touchent
"""),

    81: _("""
 le cylindre  %(k1)s déborde de l'enceinte circulaire
"""),

    82: _("""
 pas de groupes de noeuds à créer
"""),

    83: _("""
 la grille numéro  %(k1)s  déborde du domaine de définition du faisceau
"""),

    84: _("""
 les grilles numéro  %(k1)s  et numéro  %(k2)s  se recouvrent
"""),

    85: _("""
 cas d enceintes circulaire et rectangulaire seulement
"""),

    86: _("""
 pas de groupe de mailles sous la racine commune  %(k1)s
"""),

    87: _("""
 pas de groupes de mailles sous la racine commune
"""),

    88: _("""
 une cote de l'enceinte est de longueur nulle
"""),

    89: _("""
 les quatre sommets de l'enceinte ne forment pas un rectangle
"""),

    90: _("""
 le cylindre  %(k1)s  déborde de l'enceinte rectangulaire
"""),

    91: _("""
  la renumérotation  %(k1)s est incompatible avec le solveur MULT_FRONT.
"""),

    92: _("""
 absence de relation de comportement de type <ELAS> pour le matériau constitutif de la coque interne
"""),

    93: _("""
 absence d'un ou de plusieurs paramètres de la relation de comportement <ELAS>
 pour le matériau constitutif de la coque interne
"""),

    94: _("""
 La valeur du module de YOUNG est nulle pour le matériau constitutif de la coque interne
"""),

    95: _("""
 absence de relation de comportement de type <ELAS>
 pour le matériau constitutif de la coque externe
"""),

    96: _("""
 absence d'un ou de plusieurs paramètres de la relation de comportement <ELAS>
 pour le matériau constitutif de la coque externe
"""),

    97: _("""
 La valeur du module de YOUNG est nulle pour le matériau constitutif de la coque externe
"""),

    98: _("""
 Les deux coques (interne et externe) sont en mouvement pour le  %(k1)s ème mode.
"""),

    99: _("""
 non convergence pour le calcul des modes en eau au repos
"""),
}
