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
 AFFE_CARA_ELEM : mot clé GENE_TUYAU
 Les deux angles sont différents
 %(r1)f
 %(r2)f
"""),

    3 : _("""
Vous utilisez des éléments de type GRILLE_MEMBRANE. Le mot-clé ANGL_REP de la commande AFFE_CARA_ELEM
permet d'indiquer la direction des armatures.
La projection de ce vecteur directeur dans le plan de certains des éléments de GRILLE_MEMBRANE est nulle.

Conseil :
  Vérifiez les données sous le mot clef ANGL_REP de la commande AFFE_CARA_ELEM.
"""),

    4 : _("""
Problème dans le calcul de l'option FORC_NODA / REAC_NODA :

Le nombre de sous-point du champ de contrainte contenu dans la SD n'est
pas cohérent avec ce qui a été défini dans AFFE_CARA_ELEM.

Il est probable que le champ de contrainte a été extrait sur un seul sous-point.

Il est impératif d'utiliser un champ de contrainte complet pour le calcul de FORC_NODA.
"""),

    5 : _("""
 problème de maillage TUYAU :
 pour une maille définie par les noeuds N1 N2 N3,
 le noeud N3 doit être le noeud milieu
"""),

    6 : _("""
  GENE_TUYAU
  il faut donner un vecteur non colinéaire au tuyau
"""),

    7 : _("""
  -> L'angle du coude est trop grand
     ANGLE     = %(r1)f
     ANGLE MAX = %(r2)f
  -> Risque & Conseil : mailler plus fin
"""),

    8 : _("""
La raideur tangente de la section est nulle.
Vérifier votre matériau, vous avez peut être défini un matériau élastoplastique parfait.

Risque & Conseil : mettre un léger écrouissage peut permettre de passer cette difficulté.
"""),

    10 : _("""
 le champ  %(k1)s n'a pas le bon type :
   type autorisé  :%(k2)s
   type du champ  :%(k3)s
"""),

    11 : _("""
 La modélisation utilisée n'est pas traitée.
"""),

    12 : _("""
 Le nombre de couche doit être obligatoirement supérieur à zéro.
"""),



    14 : _("""
 Le type d'élément %(k1)s n'est pas prévu.
"""),

    15 : _("""
 La nature du matériau %(k1)s n'est pas traitée.
 Seules sont considérées les natures : ELAS, ELAS_ISTR, ELAS_ORTH.
"""),

    18 : _("""
 le nombre de noeuds d'un tuyau est différent de 3 ou 4
"""),

    19 : _("""
Erreur :
   Le calcul du chargement dû à la température n'est pas programmé pour le type d'élément %(k1)s.

Conseil :
  Pour pouvoir continuer le calcul, ALPHA doit être nul. Le chargement sera nul.
  Il faut émettre une demande d'évolution pour que ce chargement soit pris en compte.
"""),

    20 : _("""
 Aucun type d'éléments ne correspond au type demandé.
"""),

    21 : _("""
 prédicteur ELAS hors champs
"""),

    22 : _("""
Erreur :
   Le calcul du chargement dû à l'hydratation n'est pas programmé pour le type d'élément %(k1)s.

Conseil :
  Pour pouvoir continuer le calcul, B_ENDOGE doit être nul. Le chargement sera nul.
  Il faut émettre une demande d'évolution pour que ce chargement soit pris en compte.
"""),

    23 : _("""
Erreur :
   Le calcul du chargement dû au séchage n'est pas programmé pour le type d'élément %(k1)s.

Conseil :
  Pour pouvoir continuer le calcul, K_DESSIC doit être nul. Le chargement sera nul.
  Il faut émettre une demande d'évolution pour que ce chargement soit pris en compte.
"""),

    24 : _("""
 dérivées de "MP" non définies
"""),

    25 : _("""
 On passe en mécanisme 2.
"""),

    26 : _("""
 Chargement en mécanisme 2 trop important.
 À vérifier.
"""),

    27 : _("""
 On poursuit en mécanisme 2.
"""),

    28 : _("""
 décharge négative sans passer par le mécanisme 1
 diminuer le pas de temps
"""),

    29 : _("""
 on revient en mécanisme 1
"""),

    30 : _("""
 pas de retour dans le mécanisme 1 trop important
 diminuer le pas de temps
"""),

    31 : _("""
 type d'élément  %(k1)s  incompatible avec  %(k2)s
"""),

    32 : _("""
 le comportement %(k1)s est inattendu
"""),

    34 : _("""
 élément non traité  %(k1)s
"""),





    36 : _("""
 nombre de couches négatif ou nul :  %(k1)s
"""),

    37 : _("""
 le champ  %(k1)s n'a pas la bonne grandeur :
   grandeur autorisée  :%(k2)s
   grandeur du champ   :%(k3)s
"""),


    38 : _("""
 Élément de poutre %(k1)s :
 Vous faites des calculs avec l'option GROT_GDEP. Lors de la réactualisation de la géométrie,
 une rotation pour la poutre %(k1)s varie de plus de PI/8.
 Variation d'angle %(k2)s de %(r1)f degrés.

 * Cela peut arriver lorsque l'axe de la poutre correspond à l'axe global Z. Dans ce cas le
 calcul des angles définissant l'orientation de la poutre peut présenter une indétermination.
 -> Risque & Conseils :
    Des problèmes de convergence peuvent survenir.
    a) Essayez de définir une poutre qui n'est pas exactement verticale en déplaçant légèrement
       un des noeuds.
    b) Essayez de modifiez votre maillage, pour qu'au cours du calcul, l'axe de la poutre ne soit
       jamais l'axe Z global.

 * Cela peut être due à une instabilité de type flambement, déversement, ...
 -> Risque & Conseils :
    Des problèmes de convergence peuvent survenir.
    L'utilisation du pilotage peut permettre de passer cette instabilité.
"""),


    40 : _("""
  -> L'axe de référence pour le calcul du repère local est normal à un
     au moins un élément de plaque.
  -> Risque & Conseil :
     Il faut modifier l'axe de référence (axe X par défaut) en utilisant
     ANGL_REP ou VECTEUR.

"""),

    41 : _("""
 impossibilité :
 vous avez un matériau de type "ELAS_COQUE" et vous n'avez pas défini la raideur de membrane,
 ni sous la forme "MEMB_L", ni sous la forme "M_LLLL".
"""),

    42 : _("""
  Le comportement matériau %(k1)s n'est pas disponible pour ce type de modélisation

   Conseils :
   * S'il s'agit de ELAS_HYPER changez votre modélisation massif 2D,3D.
   * S'il s'agit de ELAS_GLRC utilisez la modélisation DKTG
   * S'il s'agit de ELAS_MEMBRANE utilisez la modélisation MEMBRANE&GRILLE_MEMBRANE
   * Si vous modélisez un comportement anisotrope de plaque/coque, utilisez soit
      ELAS_COQUE ou ELAS_ORTH.
   * Dans le cas ELAS_ORTH n'oubliez pas de définir DEFI_COMPOSITE
      Vous pouvez aussi utiliser ELAS_ORTH isotropie transverse définissant correctement les paramètres matériaux
   * Dans le cas ELAS_COQUE vous n'avez pas besoin de définir DEFI_COMPOSITE. Mais attention :
      ELAS_COQUE donne les propriétés matériaux (membrane, flexion) dans le repère
      intrinsèque de la coque.
"""),

    43 : _("""
 impossibilité :
 vous avez un matériau de type "ELAS_COQUE" et le déterminant de la sous matrice de Hooke relative au cisaillement est nul.
"""),

    44 : _("""
 Le comportement matériau %(k1)s n'est pas traité.
"""),

    45 : _("""
 Le comportement matériau %(k1)s n'est pas traité.

Conseil :
 Pour définir une COQUE_3D orthotrope, il ne faut pas utiliser
 la commande DEFI_COMPOSITE.
 Seule la définition du comportement ELAS_ORTH est nécessaire.
"""),


    46 : _("""
 nombre de couches négatif ou nul
"""),

    48 : _("""
 impossibilité, la surface de l'élément est nulle.
"""),

    49 : _("""
 Le comportement matériau %(k1)s n'est pas traité pour l'option %(k2)s.
"""),

    50 : _("""
 comportement élastique inexistant
"""),

    52 : _("""
  -> Le type de comportement %(k1)s n'est pas prévu pour le calcul de
     SIEF_ELGA avec chargement thermique.
"""),

    53 : _("""
Erreur utilisateur :
  Température sur la maille: %(k1)s : il manque la composante "TEMP_MIL"
"""),

    55 : _("""
Inconnu:  %(k1)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),



    62 : _("""
 GROUP_MA :  %(k1)s  inconnu dans le maillage
"""),

    63 : _("""
 Le groupe de mailles %(k1)s n'existe pas.
"""),







    66 : _("""
 Si vous avez renseigné le mot-clé NOEUD_ORIG, donnez un groupe de mailles sous GROUP_MA ou une liste de mailles
 sous MAILLE. On ne réordonne pas les groupes de noeuds et les listes de noeuds.
"""),

    67 : _("""
 Le groupe de noeuds %(k1)s n'existe pas.
"""),


    68 : _("""
 Le noeud origine ou extrémité %(k1)s ne fait pas partie des mailles de la ligne.
"""),

    69 : _("""
 Le noeud origine ou extrémité  %(k1)s  n'est pas une extrémité de la ligne.
"""),

    70 : _("""
 Alarme DEFI_GROUP / CREA_GROUP_NO / OPTION='NOEUD_ORDO' :
   Le groupe de mailles spécifié forme une ligne fermée (NOEUD_ORIG et NOEUD_EXTR identiques).
   Vous n'avez pas renseigné le mot clé VECT_ORIE. La ligne est donc orientée arbitrairement.
"""),

    71 : _("""
 Erreur utilisateur :
   On cherche à orienter une ligne (un ensemble de segments).
   La recherche du noeud "origine" de la ligne échoue.

 Conseil :
   La ligne est peut-être une ligne fermée (sans extrémités).
   On peut alors utiliser les mots clés GROUP_NO_ORIG et GROUP_NO_EXTR
   (ou NOEUD_ORIG et NOEUD_EXTR).

"""),

    72 : _("""
 GROUP_NO orienté : noeud origine =  %(k1)s
"""),

    73 : _("""
 Le GROUP_MA :  %(k1)s n'existe pas.
"""),




    77 : _("""
 le noeud extrémité  %(k1)s  n'est pas le dernier noeud
"""),

    87 : _("""
 Mauvaise définition de MP1 et MP2
"""),

    88 : _("""
 Option %(k1)s n'est pas disponible pour l'élément %(k2)s et la loi de comportement %(k3)s
"""),

    90 : _("""
Erreur de programmation :
   Un attribut n'est pas défini pour cette modélisation.
Solution :
   Il faut modifier le catalogue pour ajouter cet attribut pour cette modélisation.

Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    91 : _("""
   Le comportement est %(k1)s mais l'option DEFI_COMPOSITE est manquant.

   Conseils :
   1. Il faut utiliser ELAS_COQUE si vous ne voulez pas utiliser DEFI_COMPOSITE. Mais
attention : ELAS_COQUE donne les propriétés matériaux (membrane, flexion) dans le repère
intrinsèque de la coque.
   2. Sinon ELAS_ORTH pour les plaques/coques demandent d'activer DEFI_COMPOSITE
pour préciser les orientations des couches
"""),

    92 : _("""
   Le comportement  %(k1)s n'est pas pris charge actuellement par la modélisation.

   Conseils :
      Vous pouvez aussi utiliser ELAS_ORTH ou ELAS_COQUE  isotropie transverse définissant correctement les paramètres matériaux.
      Attention avec ELAS_ORTH vous devez absolument définir DEFI_COMPOSITE pour préciser l'orientation des couches.
      Attention ELAS_COQUE donne les propriétés matériaux (membrane, flexion) dans le repère
      intrinsèque de la coque.
"""),


}
