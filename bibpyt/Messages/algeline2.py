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

    1 : _("""
 L'argument de "BLOC_DEBUT" doit être strictement positif,
 il est pris à 1
"""),

    2 : _("""
 Calcul des modes en eau au repos :
 une des valeurs propres de la matrice n'est pas réelle
"""),

    3 : _("""
 Calcul des modes en eau au repos :
 une des valeurs propres obtenues est nulle
"""),

    4 : _("""
 Erreur sur la recherche des multiplicateurs de Lagrange
"""),

    6 : _("""
 Type de matrice " %(k1)s " inconnu.
"""),

    7 : _("""
 On ne traite pas cette option
"""),

    8 : _("""
 L'argument de "BLOC_FIN" est plus grand que le nombre de blocs de la matrice,
 il est ramené à cette valeur
"""),

    9 : _("""
 Les matrices à combiner ne sont pas construites sur le même maillage.
"""),

    10 : _("""
 Erreur de programmation :
 On cherche à combiner 2 matrices qui n'ont pas les mêmes charges cinématiques.
 Noms des 2 matrices :
    %(k1)s
    %(k2)s

 Solution :
    1) émettre une fiche d'anomalie / évolution
    2) En attendant : ne pas utiliser de charges cinématiques :
       remplacer AFFE_CHAR_CINE par AFFE_CHAR_MECA
"""),

    11 : _("""
 Les matrices "%(k1)s"  et  "%(k2)s"  n'ont pas la même structure.
"""),

    12 : _("""
 Résolution système linéaire méthode de Crout.
 Attention: une dimension nulle ou incorrecte
"""),

    13 : _("""
 Résolution système linéaire méthode de Crout.
 Attention: une dimension négative ou nulle
"""),

    14 : _("""
 Résolution système linéaire méthode de Crout.
 Attention: les dimensions des tableaux ne sont pas correctes
"""),

    15 : _("""
 Pas de charge critique  dans l'intervalle demandé
"""),

    16 : _("""
  %(k1)s charges critiques  dans l'intervalle demandé
"""),

    17 : _("""
 Au moins une valeur propre calculée est en dehors de la bande demandée.
 Ces valeurs propres extérieures n'apparaîtront pas dans le résultat de l'opérateur.
"""),

    18 : _("""
 Les matrices " %(k1)s " et " %(k2)s " n'ont pas le même domaine de définition
"""),

    19 : _("""
 Problèmes a l'allocation des descripteurs de la matrice " %(k1)s "
"""),

    20 : _("""
 L'argument de "BLOC_DEBUT" est plus grand que le nombre de blocs de la matrice
"""),

    21 : _("""
 L'argument de "BLOC_FIN" doit être strictement positif
"""),

    22 : _("""
Erreur d'utilisation pour AFFE_CHAR_CINE :
 On veut éliminer un degré de liberté de translation (%(k1)s) sur le noeud %(k2)s.
 Mais ce noeud est un noeud XFEM et cette translation correspond à une combinaison
 de plusieurs degrés de liberté.
 On ne peut donc pas éliminer cette translation avec AFFE_CHAR_CINE.
 Il faut utiliser AFFE_CHAR_MECA.
"""),

    23 : _("""
 On a rencontré un problème à la lecture de la table %(k1)s.

 --> Conseil:
 Vérifiez que cette carte a bien été générée précédemment par un appel à INFO_MODE.
"""),

    24 : _("""
 On a rencontré un problème à la lecture de la table %(k1)s. Elle ne comporte aucune ligne
 dont les bornes sont strictement comprises entre les valeurs de la bande de test:
                                    [ %(r1)f , %(r2)f ]

 --> Conseil:
 Vérifiez le contenu de la table via un IMPR_TABLE et modifiez les bornes de l'option BANDE
 en conséquence.

 Au pire, relancez votre calcul sans spécifier de nom de table. L'opérateur effectuera alors
 l'étape complète de prétraitement de manière transparente.
 Mais le calcul sera un peu plus coûteux puisqu'il ne mutualisera pas cette étape commune avec
 INFO_MODE.
"""),

    25 : _("""
 On a rencontré un problème à la lecture de la table %(k1)s. Elle comporte des trous ou des
 recouvrements par  rapport aux bornes choisies. Le solveur modal risque donc de pas calculer
 strictement tous les modes requis.

 --> Conseil:
 Vérifiez le contenu de la table via un IMPR_TABLE.

 Modifiez éventuellement la valeur par défaut du paramètre VERI_MODE/PREC_SHIFT. Elle détermine
 l'écartement entre les bornes de la bande de test et celles de la bande recherchée.


 Au pire, relancez votre calcul sans spécifier de nom de table. L'opérateur effectuera alors
 l'étape complète de prétraitement de manière transparente.
 Mais le calcul sera un plus coûteux puisqu'il ne mutualisera pas cette étape commune avec
 INFO_MODE.
"""),

    26 : _("""
 Attention, la bande sélectionnée dans la table %(k1)s comporte au moins une de ses bornes légèrement
 décalée. Ce décalage a été opéré afin de ne pas perturber la méthode de comptage (méthode de
 Sturm). Il a été effectué en se basant sur la paramétrage (NMAX_ITER_SHIFT/PREC_SHIFT/SEUIL_**)
 de l'opérateur INFO_MODE qui a générer la TABLE.
"""),

    27 : _("""
 Opérateur INFO_MODE + COMPTAGE/METHODE='AUTO'.
 Compte-tenu des propriétés des matrices fournies (nombre, type, symétrie), on a choisi pour vous la
 méthode de comptage: %(k1)s.
"""),

    28 : _("""
 les "MATR_ASSE" %(k1)s "  et  " %(k2)s "  ne sont pas combinables.
"""),

    29 : _("""
Erreur utilisateur dans COMB_MATR_ASSE:
 On cherche à combiner des matrices généralisées qui n'ont pas
 les mêmes dimensions.
"""),




    31 : _("""
 Cas TYPE_MODE='GENERAL'.
 Compte-tenu des propriétés des matrices fournies (type, symétrie), on bascule automatiquement
 en mode de fonctionnement : %(k1)s.
"""),

    33 : _("""
 Type de mode inconnu :  %(k1)s.
 Les modes donnés en entrée doivent être de type MODE_MECA, MODE_MECA_C OU MODE_FLAMB.
"""),

    34 : _("""
 Il n'est pas permis de modifier un objet père
"""),

    35 : _("""
 Mode non calculé à partir de matrices assemblées
"""),

    36 : _("""
 Normalisation impossible, le noeud n'est pas présent dans le modèle.
"""),

    37 : _("""
 Normalisation impossible, la composante n'est pas présente dans le modèle.
"""),

    38 : _("""
 Il manque des paramètres de type entier.
"""),

    39 : _("""
 Il manque des paramètres de type réel.
"""),

    40 : _("""
 IL manque des paramètres de type caractère.
"""),

    41 : _("""
 Normalisation impossible : aucune composante n'est présente dans le modèle.
"""),



    43 : _("""
 on ne tient pas compte du mot-clé facteur MODE_SIGNE pour une base modale de type MODE_MECA_C.
"""),

    44 : _("""
 " %(k1)s "  type de mode non traité
"""),



    46 : _("""
 Le calcul de flambement ne peut pas être mené pour un problème avec une matrice %(k1)s complexe.
"""),






    52 : _("""
 Avec l'option %(k1)s, il faut au moins deux valeurs sous le mot-clé %(k2)s.
"""),





    55 : _("""
 Pour un problème généralisé, le mot-clé AMOR_REDUIT ne peut pas être utilisé.
"""),

    56 : _("""
 Pour un problème quadratique, si le mot-clé AMOR_REDUIT est présent,
 seule l'option 'PROCHE' est utilisable.
"""),

    57 : _("""
 Le mot-clé AMOR_REDUIT étant présent, le nombre de valeurs renseignées sous ce mot-clé
 doit être le même que celui sous le mot-clé FREQ.
"""),

    58 : _("""
 Les matrices "%(k1)s" et "%(k2)s" ne sont pas compatibles entre elles.

 --> Conseil : vérifier la manière dont elles sont construites
 (elles doivent notamment reposer sur le même maillage, être calculées avec les mêmes conditions aux limites,
 avoir la même numérotation de DDL, avoir les mêmes propriétés de (non) symétrie, ...).
"""),

    59 : _("""
 présence de fréquences négatives dans les données.
"""),

    62 : _("""
 pas de valeurs propres dans la bande de calcul, le concept ne peut donc pas être créé.
"""),



    64 : _("""
 La valeur de PARAM_ORTHO_SOREN n'est pas valide.
 Elle doit être dans l'intervalle [1,2*epsilon ; 0,83-epsilon]
 où epsilon est la précision machine.
"""),

    65 : _("""
 La détection des modes de corps rigide (demandée avec OPTION='MODE_RIGIDE')
 est utilisable uniquement avec la méthode 'TRI_DIAG'.
"""),

    66 : _("""
 L'option 'BANDE' n'est pas autorisée pour un problème avec amortissement
 (%(k1)s complexe et/ou présence du mot-clé %(k2)s).

 -> Conseil :
 utiliser l'option 'CENTRE'.
"""),

    67 : _("""
 L'approche imaginaire ou complexe n'est pas compatible avec une borne inférieure nulle de l'intervalle de recherche
 (par exemple, si l'option 'PLUS_PETITE' est utilisée, c'est le cas).
"""),

    68 : _("""
 La détection des modes de corps rigide (OPTION='MODE_RIGIDE') n'est pas utilisable pour un problème avec amortissement
 (%(k1)s complexe, et/ou présence du mot-clé %(k2)s).
"""),

    69 : _("""
 Pour un problème avec matrice complexe,
 seules les méthodes 'SORENSEN' et 'QZ' sont utilisables.
"""),

    70 : _("""
 Pour un problème avec matrice complexe, le calcul ne peut pas être fait si la borne inférieure de l'intervalle de recherche est nulle
 (par exemple, si l'option 'PLUS_PETITE' est utilisée, c'est le cas ; conseil : utiliser l'option 'CENTRE').
"""),

    71 : _("""
 Pour un problème quadratique, la méthode de 'SORENSEN' n'est pas utilisable si la borne inférieure de l'intervalle de recherche est nulle
 (par exemple, si l'option 'PLUS_PETITE' est utilisée, c'est le cas ; conseil : utiliser l'option 'CENTRE').
"""),

    72 : _("""
 La dimension du sous-espace de travail (mot-clé DIM_SOUS_ESPACE)
 est inférieure au nombre de modes de corps rigide.
"""),

    73 : _("""
 Attention : pour l'instant, il n'y a pas de vérification de type STURM (comptage du bon nombre des valeurs propres calculées)
 lorsqu'on est dans le plan complexe :
       problème modal généralisé avec %(k1)s complexe,
    ou problème modal généralisé avec matrice(s) non symétrique(s),
    ou problème modal quadratique (présence du mot-clé %(k2)s).
   """),

    74 : _("""
 Erreur de vérification des modes calculés : au moins un des critères de validation renseignés sous le mot-clé facteur VERI_MODE n'est pas respecté.

 Conseils :
 Si vous voulez tout de même utiliser les modes calculés (à vos risques et périls !), relancez le calcul en modifiant les mots-clés situés sous le mot-clé facteur VERI_MODE,
   - soit en utilisant des valeurs moins contraignantes sur les critères de qualité,
   - soit en utilisant l'option STOP_ERREUR='NON'.
"""),

    75 : _("""
  le problème traité étant quadratique, on double l'espace de recherche
"""),

    76 : _("""
 3 ou 6 valeurs pour le mot-clé "DIRECTION"
"""),

    77 : _("""
 pour le mot-clé facteur  "PSEUDO_MODE", il faut donner la matrice de masse.
"""),

    78 : _("""
 la direction est nulle.
"""),

    79 : _("""
 Les NUME_DDL associés aux matrices MATR_RIGI et MATR_MASS sont différents.
"""),

    80 : _("""
 bases modales BASE_1 et BASE_2 avec numérotations incompatibles
"""),

    81 : _("""
 bases modales et matrice MATR_ASSE avec numérotations incompatibles
"""),

    82 : _("""
 nombre de modes et d amortissements différents
"""),

    83 : _("""
 nombre de modes et d amortissements de CONNORS différents
"""),

    85 : _("""
 inversion valeur min <=> valeur max
"""),

    86 : _("""
 type de matrice inconnu
"""),

    87 : _("""
  pas de produit car le champ aux noeuds  %(k1)s  existe déjà.
"""),

    88 : _("""
  Problème de programmation :
    La matrice globale %(k1)s n'existe pas.
    Elle est nécessaire pour déterminer les degrés de liberté bloqués par AFFE_CHAR_CINE.

  Solution (pour l'utilisateur) :
    1) Ne pas utiliser de charges cinématiques (AFFE_CHAR_CINE)
    2) Émettre une fiche d'anomalie.

  Solution (pour le programmeur) :
    La matrice globale a été détruite abusivement.
    Instrumenter la routine de destruction pour déterminer la routine coupable.
"""),

    89 : _("""
 le mot-clé MAILLAGE est obligatoire avec le mot-clé CREA_FISS.
"""),

    90 : _("""
 le mot-clé MAILLAGE est obligatoire avec le mot-clé LINE_QUAD.
"""),

    91 : _("""
 CREA_MAILLAGE : l'option LINE_QUAD ne traite pas les macro-commandes mailles
"""),

    92 : _("""
 CREA_MAILLAGE : l'option LINE_QUAD ne traite pas les ABSC_CURV
"""),

    93 : _("""
 le mot-clé MAILLAGE est obligatoire avec le mot-clé QUAD_LINE.
"""),

    94 : _("""
 CREA_MAILLAGE : l'option QUAD_LINE ne traite pas les macro-commandes mailles
"""),

    95 : _("""
 CREA_MAILLAGE : l'option QUAD_LINE ne traite pas les ABSC_CURV
"""),

    96 : _("""
 le mot-clé MAILLAGE est obligatoire avec le mot-clé MODI_MAILLE.
"""),

    97 : _("""
 une seule occurrence de "QUAD_TRIA3"
"""),

    98 : _("""
 le mot-clé MAILLAGE est obligatoire avec le mot-clé COQU_VOLU.
"""),

    99 : _("""
 pas de maille a modifier
"""),

}
