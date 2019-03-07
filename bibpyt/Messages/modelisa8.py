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

    1 : _("""
 La section de la poutre affectée à la maille %(k1)s est nulle.
"""),

    2 : _("""
 L'inertie %(k2)s de la poutre affectée à la maille %(k1)s est nulle
"""),

    3: _("""
 Pour la poutre %(k1)s, l'une des composantes A, IY, IZ n'existe pas.
"""),

    4 : _("""
 La somme des aires des fibres est différente de l'aire de la section donnée sous
 le mot clef facteur POUTRE.
 L'erreur relative est supérieure à la précision définie par le mot clé PREC_AIRE :
   - occurrence de MULTIFIBRE : %(i1)d
   - maille                   : %(k1)s
   - aire de la poutre        : %(r1)12.5E
   - aire des fibres          : %(r2)12.5E
   - erreur relative          : %(r3)12.5E   > PREC_AIRE = %(r4)12.5E
"""),

    5 : _("""
 La somme des moments d'inertie des fibres par rapport à l'axe %(k2)s est différente
 du moment d'inertie donné sous le mot clef facteur POUTRE.
 L'erreur relative est supérieure à la précision définie par le mot clé PREC_INERTIE :
   - occurrence de MULTIFIBRE      : %(i1)d
   - maille                        : %(k1)s
   - moment d'inertie de la poutre : %(r1)12.5E
   - moment d'inertie des fibres   : %(r2)12.5E
   - erreur relative               : %(r3)12.5E   > PREC_INERTIE = %(r4)12.5E
"""),

    6 : _("""
 AFFE_CARA_ELEM / MULTIFIBRE
 Les mots clefs PREC_AIRE et/ou PREC_INERTIE servent à définir la tolérance entre les
 caractéristiques de poutres affectées sous le mot clef facteur POUTRE et celles
 calculées par intégration sur les fibres.
 Les critères imposés par PREC_AIRE et/ou PREC_INERTIE ne sont pas respectés.
"""),

    7 : _("""
 On ne peut mettre que %(i1)d groupes de fibres sur un élément.
"""),

    8 : _("""
 Le groupe de fibres %(k1)s n'a pas été défini dans DEFI_GEOM_FIBRE
"""),



    9 : _("""Vérification du maillage.
"""),

    10 : _("""Le noeud %(k1)s connecte plus de 200 mailles.
"""),

    11 : _("""Le noeud %(k1)s est orphelin.
"""),

    12 : _("""La maille %(k1)s est topologiquement dégénérée : noeud répété dans la connectivité.
    Type de maille : %(k2)s
"""),

    13 : _("""Les mailles %(k1)s et %(k2)s sont doubles (même noeuds en support).
    Type de maille : %(k3)s
"""),

    14 : _("""La maille POI1 %(k1)s est incluse dans une autre.
"""),

    15 : _("""La maille %(k1)s possède des noeuds confondus géométriquement.
    Rapport entre le plus petit côté et le plus grand = %(r1)f, type de maille : %(k2)s
"""),

    16 : _("""
 Le matériau ELAS_ORTH affecté sur la couche %(i1)d comporte le paramètre d'amortissement %(k1)s.
 Ce paramètre n'est pas pris en compte par DEFI_COMPOSITE.
"""),

    17 : _("""
 La première colonne de la table %(k1)s doit contenir des chaînes K8 ou K24.
"""),

    18 : _("""
 La table %(k1)s ne contient pas de nom de section %(k2)s.
"""),

    19 : _("""
 Pour l'occurrence %(i1)d de %(k1)s, il y a %(i2)d groupes de fibres, alors que dans
 DEFI_GEOM_FIBRE il y a %(i3)d groupes qui ont été renseignés.
"""),


    27 : _("""
 le ddl  %(k1)s est interdit pour le noeud %(k2)s
"""),

    28 : _("""
 affectation déjà effectuée du ddl  %(k1)s du noeud %(k2)s : on applique la règle de surcharge
"""),

    29 : _("""
 nombre de composantes %(i2)d supérieur au maximum %(i1)d 
"""),

    34 : _("""
 erreur dans les données le paramètre  %(k1)s n existe pas dans la table  %(k2)s
"""),

    35 : _("""
 erreur dans les données pas de valeur pour le paramètre  %(k1)s
"""),

    36 : _("""
 erreur dans les données plusieurs valeurs pour le GROUP_MA  %(k1)s
"""),

    43 : _("""

 le nombre de ddl_1 figurant dans  la liaison n'est pas égal au nombre de COEF_MULT_1 :
   %(i1)d
   %(i2)d
"""),

    44 : _("""

 le nombre de ddl_2 figurant dans  la liaison n'est pas égal au nombre de COEF_MULT_2 :
   %(i1)d
   %(i2)d
"""),

    46 : _("""

 le nombre de ddls figurant dans  la liaison n'est pas égal au nombre de  COEF_MULT/COEF_MULT_FONC :
   %(i1)d
   %(i2)d
"""),

    47 : _("""

 le nombre de ddls figurant dans  la liaison n'est pas égal au nombre de noeuds :
   %(i1)d
   %(i2)d
"""),

    48 : _("""
Erreur utilisateur pour LIAISON_MAIL :
   Il n'y a aucun noeud esclave à lier pour l'occurrence %(i1)d du mot clé LIAISON_MAIL.
   Peut-être que tous les noeuds esclaves ont déjà été éliminés dans des occurrences
   précédentes.
"""),

    49 : _("""
 la direction normale est calculée sur la face esclave. il faut donner des mailles
  de facettes, mots clés :  %(k1)s %(k2)s
"""),




    52 : _("""
 les noeuds n1 et n2 sont confondus COOR(n1): %(r1)f   %(r2)f COOR(n2): %(r3)f
   %(r4)f
 norme   : %(r5)f
"""),

    53 : _("""
 n3 colinéaires COOR(n1): %(r1)f   %(r2)f   %(r3)f COOR(n2): %(r4)f   %(r5)f
   %(r6)f
 COOR(n3): %(r7)f
   %(r8)f
   %(r9)f
 norme   : %(r10)f
"""),

    55 : _("""
Interpolation interdite pour un résultat de type :  %(k1)s
Seule l'extraction est possible : OPERATION='EXTR'
"""),

    56 : _("""
Dans le groupe de mailles %(k1)s, il y a %(i1)d mailles mal orientées. Utilisez la commande MODI_MAILLAGE pour orienter la normale aux surfaces.
"""),

    57 : _("""
La maille %(k1)s est mal orientée. Utilisez la commande MODI_MAILLAGE pour orienter la normale aux surfaces.
"""),


    68 : _("""
 Certaines mailles constituant le groupe de mailles %(k1)s ne sont pas
 des mailles surfaciques.
 Risques & Conseils :
 Vérifiez la constitution des groupes de mailles renseignées sous le
 mot-clé GROUP_MA_ESCL.
"""),



    71 : _("""
 matériau non valide matériau :  %(k1)s
"""),

    72 : _("""
 matériaux non valides on ne peut avoir a la fois  %(k1)s  et  %(k2)s
"""),

    75 : _("""
 erreur données le GROUP_NO n'existe pas  %(k1)s
"""),

    77 : _("""
 Il y a un conflit dans les vis-à-vis des noeuds. Le noeud  %(k1)s est
 à la fois le vis-à-vis du noeud %(k2)s et du noeud %(k3)s.

 Conseils :
   - Si la distance entre les deux surfaces à apparier est grande devant leurs dimensions, précisez l'isométrie qui permet de les superposer par l'intermédiaire des mots-clés CENTRE, ANGL_NAUT et TRAN.
   - Si les maillages sont incompatibles, utilisez plutôt le chargement LIAISON_MAIL.
"""),

    87 : _("""
 conflit dans les vis-à-vis  générés successivement a partir des listes  %(k1)s
 et  %(k2)s
 le noeud  %(k3)s
 a pour vis-à-vis le noeud %(k4)s
  et le noeud %(k5)s
"""),

    88 : _("""
 conflit dans les vis-à-vis  générés successivement a partir des listes
    %(k1)s et %(k2)s
 Le noeud de la première liste %(k3)s n'est l'image d"aucun  %(k4)s
 Noeud par la correspondance inverse %(k5)s
"""),

    89 : _("""
 on ne trouve pas dans la paroi 2 de maille de type :  %(i1)d
"""),

    90 : _("""
 conflit dans les VIS_A_VIS les mailles  %(k1)s  et  %(k2)s
  ont toutes les 2 comme VIS_A_VIS la maille %(k3)s
"""),

    93 : _("""
 évaluation impossible  d'une fonction matériau - on déborde à gauche  pour la température
 TEMP : %(r1)f
"""),

    94 : _("""
 évaluation impossible  d'une fonction matériau - on déborde à droite  pour la température
 TEMP : %(r1)f
"""),



}
