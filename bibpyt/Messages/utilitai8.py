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

    1 : _("""
 Rien que des constantes pour une nappe.
 Nombre de fonctions constantes %(i1)d
"""),

    2 : _("""
 Paramètres différents.
 fonction %(k1)s de paramètre %(k2)s au lieu de %(k3)s
"""),

    3 : _("""
 Le nombre de paramètres  %(i1)d  est différent du nombre de fonctions  %(i2)d
"""),

    4 : _("""
 Il n'y a pas un nombre pair de valeurs, "DEFI_FONCTION" occurrence  %(i1)d
"""),

    5 : _("""
 Les abscisses de la fonction  %(k1)s ont été réordonnées.
"""),

    6 : _("""
 L'ordre des abscisses de la fonction numéro  %(i1)d a été inversé .
"""),

    7 : _("""
 Appel erroné
  archivage numéro :  %(i1)d
  code retour :  %(i2)d
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    8 : _("""
 Lecture des champs:
"""),

    9 : _("""
   Numéro d'ordre :  %(i1)d             instant :  %(r1)g
"""),

    10 : _("""
 Le modèle est manquant.

 Conseil :
  Il faut remplir le mot-clé MODELE si la commande utilisée le permet.
"""),






    13 : _("""
  Dans la structure de données résultat %(k1)s,
  le champ %(k2)s
"""),

    14 : _("""
  ou le champ %(k1)s
"""),

    15 : _("""
  n'existe pas.
"""),

    16 : _("""
  Pour le numéro d'ordre NUME_ORDRE %(i1)d,
  l'option %(k1)s n'est pas calculée.

  Conseil :
    Vérifiez le nom de la structure de donnée et vérifiez que les champs existent.
    Si le concept n'est pas réentrant les champs ne sont pas cherchés dans %(k2)s.
"""),

    17 : _("""
 pas de NUME_ORDRE trouvé pour le numéro  %(i1)d
"""),

    18 : _("""
 pas de champs trouvé pour l'instant  %(r1)g
"""),

    19 : _("""
 Plusieurs pas de temps trouvés  dans l'intervalle de précision
 autour de l'instant  %(r1)g
 nombre de pas de temps trouvés  %(i1)d
 Conseil : modifier le paramètre PRECISION
"""),

    20 : _("""
 Erreur dans les données :
 Le paramètre existe déjà:  %(k1)s  dans la table:  %(k2)s
"""),

    21 : _("""
 Erreur dans les données
 Le type du paramètre:  %(k1)s
  est différent pour le paramètre:  %(k2)s
  et le paramètre:  %(k3)s
"""),

    22 : _("""
  Valeur de M maximale atteinte pour résoudre F(M)=0,
  Conseil : Vérifiez vos listes d'instants de rupture, M maximal admissible =  %(r1)f
"""),

    23 : _("""
  Valeur de M minimale atteinte pour résoudre F(M)=0,
  Conseil : Vérifiez vos listes d'instants de rupture, valeur de M =  %(r1)f
"""),

    24 : _("""
 Le champ demandé est incompatible avec le type de résultat
  type de résultat : %(k1)s
      nom du champ : %(k2)s
"""),

    27 : _("""
 Appel erroné  résultat :  %(k1)s   archivage numéro :  %(i1)d
   code retour  :  %(i2)d
   problème champ :  %(k2)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    31 : _("""
  Option déjà calculée:  option  %(k1)s  NUME_ORDRE  %(i1)d
  On la recalcule car les données peuvent être différentes

"""),

    32 : _("""
 L'extrapolation ne peut être faite à gauche (interdit).
"""),

    33 : _("""
 L'extrapolation ne peut être faite à droite (interdit).
"""),

    34 : _("""
 L'interpolation ne peut être faite car aucun champ de : %(k1)s n'est calcule.
"""),

    35 : _("""
 La variable d'accès %(k1)s est invalide pour une interpolation.
"""),

    36 : _("""
 Ce nom de champ est interdit : %(k1)s pour une interpolation.
"""),

    37 : _("""
 Résultat: %(k1)s NOM_CHAM: %(k2)s  variable d'accès: %(k3)s valeur: %(r1)g

"""),

    38 : _("""
 Plusieurs champs correspondant à l'accès demandé pour la SD_RESULTAT  %(k1)s
"""),

    39 : _("""
 accès %(k1)s : %(i1)d
"""),

    40 : _("""
 accès %(k1)s : %(r1)g
"""),

    41 : _("""
 accès %(k1)s  : %(k1)s
"""),

    46 : _("""
  nombre : %(i1)d NUME_ORDRE retenus : %(i2)d, %(i3)d
"""),

    47 : _("""
 Pas de champ correspondant à un accès demandé pour la SD_RESULTAT  %(k1)s
"""),

    48 : _("""
  nombre : %(i1)d NUME_ORDRE retenus (les trois premiers) : %(i2)d, %(i3)d, %(i4)d
"""),

    56 : _("""
 pas de champs pour l'accès  %(k1)s de valeur  %(r1)g
"""),

    57 : _("""
Erreur utilisateur :
  Plusieurs champs correspondent à l'accès demandé pour la structure de données résultat  %(k1)s
  - accès "INST"             : %(r1)19.12e
  - nombre de champs trouvés : %(i1)d
Conseil:
  Resserrer la précision avec le mot clé PRECISION
"""),

    58 : _("""
 Pas de champs pour l'accès  %(k1)s de valeur  %(r1)g
"""),

    59 : _("""
Erreur utilisateur :
  Plusieurs champs correspondent à l'accès demandé pour la structure de données résultat  %(k1)s
  - accès "FREQ"             : %(r1)19.12e
  - nombre de champs trouvés : %(i1)d
Conseil:
  Resserrer la précision avec le mot clé PRECISION
"""),

    60 : _("""
 L'intégrale d'un champ sur des éléments de structure
(poutre, plaque, coque, tuyau, poutre multifibre) n'est pas programmée.
 Réduisez la zone de calcul par le mot-clé GROUP_MA/MAILLE.
"""),

    61 : _("""
 Erreur dans les données pour le champ  %(k1)s
 Aucun noeud ne supporte les composantes
 %(k2)s, %(k3)s, %(k4)s, %(k5)s, ...
"""),

    62 : _("""
 Erreur dans les données pour le champ  %(k1)s
 Aucune maille ne supporte les composantes
 %(k2)s, %(k3)s, %(k4)s, %(k5)s, ...
"""),





    66 : _("""
  Le MACR_ELEM_DYNA a été créé avec une base modale qui entre-temps a été
  modifiée/enrichie. Le nombre d'équations dans le MACR_ELEM_DYNA ne
  correspond plus au nombre de vecteurs de projection modale.

  -> Conseil: Pour mettre à jour le MACR_ELEM_DYNA, il faut d'abord détruire
              le concept associé et le récréer ensuite avec la nouvelle base modale.

  Nombre d'équations dans le MACR_ELEM_DYNA      = %(i1)d
  Nombre de vecteurs de projection modale        = %(i2)d
"""),



    72 : _("""
 On attend des données fréquentielles.
"""),

}
