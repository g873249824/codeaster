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


cata_msg = {

    2 : _("""
 interface inexistante
 numéro liaison            : %(i1)d
 nom sous-structure        : %(k1)s
 nom MACR_ELEM             : %(k2)s
 nom interface inexistante : %(k3)s
"""),

    3 : _("""
 On ne trouve pas le nom de l'interface associée à la sous-structure
 %(k1)s. La base modale utilisée pour définir le macro-élément associé
 à la sous-structure doit avoir été définie avec DEFI_BASE_MODALE, en
 mentionnant obligatoirement l'interface sous le mot-clé INTERF_DYNA.
"""),


    7 : _("""
 données incompatibles :
 pour les modes mécaniques :  %(k1)s
 il manque l'option        :  %(k2)s
"""),

    12 : _("""
 données incompatibles :
 pour les MODE_CORR :  %(k1)s
 il manque le champ :  %(k2)s
"""),

    13 : _("""
 données incompatibles :
 pour les MODE_CORR :  %(k1)s
 pour le champ      :  %(k2)s
 le type n'est pas  %(k3)s
"""),

    14 : _("""
 données incompatibles :
 pour les statiques :  %(k1)s
 il manque le champ :  %(k2)s
"""),

    15 : _("""
 données incompatibles :
 pour les statiques :  %(k1)s
 pour le champ      :  %(k2)s
 le type n'est pas  %(k3)s
"""),

    16 : _("""
 La base modale %(k1)s contient des modes complexes.
 On ne peut pas projeter de matrice sur cette base.
 Conseil : calculez si possible une base modale avec vecteurs propres réels.
"""),

    18 : _("""
 on ne sait pas bien traiter l'option de calcul demandée :  %(k1)s
"""),

    20 : _("""
 données incompatibles :
 pour les modes mécaniques :  %(k1)s
 pour l'option             :  %(k2)s
 il manque le champ d'ordre  %(i1)d
"""),

    21 : _("""
 données incompatibles :
 pour les MODE_CORR :  %(k1)s
 il manque l'option :  %(k2)s
"""),

    22 : _("""
 données incompatibles :
 pour les modes statiques :  %(k1)s
 il manque l'option       :  %(k2)s
"""),


    26 : _("""
 arrêt sur manque argument
 base modale donnée -->  %(k1)s
 INTERF_DYNA donnée -->  %(k2)s
"""),

    27 : _("""
 arrêt sur type de base incorrecte
 base modale donnée -->  %(k1)s
 type  base modale  -->  %(k2)s
 type attendu       -->  %(k3)s
"""),

    28 : _("""
 arrêt sur incohérence données
 base modale donnée         -->  %(k1)s
 INTERF_DYNA correspondante -->  %(k2)s
 INTERF_DYNA donnée         -->  %(k3)s
"""),

    29 : _("""
 problème arguments de définition interface
 nom interface donné    %(k1)s
 numéro interface donné %(i1)d
"""),

    30 : _("""
 arrêt sur base modale sans INTERF_DYNA
 base modale donnée -->  %(k1)s
"""),

    31 : _("""
 arrêt sur manque arguments
 base modale donnée -->  %(k1)s
 INTERF_DYNA donnée -->  %(k2)s
"""),

    35 : _("""
 un ddl non prévu est présent sur l'interface de liaison
 type du DDL  -->  %(k1)s
 nom du noeud -->  %(k2)s

 Il ne sera pas pris en compte dans le calcul des matrices réduites de liaison
 Seules les composantes DX, DY, DZ, DRX, DRY, DRZ sont prévues

"""),

    36 : _("""
Le profil de numérotation pour le mode numéro %(i1)d de la base %(k1)s n'est pas
 cohérent avec le NUME_DDL de la base
 La trace de l'interface, déterminé par le NUME_DDL, ne correspond pas
 Il est donc impossible d'extraire la trace de ce mode sur l'interface
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    37 : _("""
 arrêt sur problème cohérence
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    38 : _("""
 arrêt sur problème cohérence interface
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    39 : _("""
 arrêt sur matrice inexistante
 matrice %(k1)s
"""),

    40 : _("""
  arrêt problème de factorisation:
  présence probable de modes de corps rigide
  la méthode de Mac-Neal ne fonctionne pas en présence de modes de corps rigide
"""),

    42 : _("""
 le mot-clé  %(k1)s est incompatible avec le champ %(k2)s
 utilisez 'GROUP_MA' ou 'MAILLE'  pour restreindre le changement de repère
 à certaines mailles. %(k3)s
"""),

    43 : _("""
 La modélisation est de dimension 2 (2D)
 Seule la première valeur de l'angle nautique est retenue :  %(r1)f
"""),


    49 : _("""
 problème: sous-structure inconnue
 sous-structure -->  %(k1)s
"""),

    50 : _("""
 pas de sous-structure dans le squelette
"""),

    51 : _("""
 nom de sous-structure non trouvé
 la sous-structure :  %(k1)s n existe pas  %(k2)s
"""),

    53 : _("""
 arrêt sur pivot nul
 ligne -->  %(i1)d
"""),

    55 : _("""
 le MAILLAGE : %(k1)s ne contient pas de GROUP_MA
"""),

    56 : _("""
 le GROUP_MA : %(k2)s n'existe pas dans le MAILLAGE : %(k1)s
"""),

    57 : _("""
 le MAILLAGE : %(k1)s ne contient pas de GROUP_NO
"""),

    58 : _("""
 le GROUP_NO : %(k2)s n'existe pas dans le MAILLAGE : %(k1)s
"""),

    59 : _("""
 nombre de noeuds communs =  %(i1)d
"""),

    62 : _("""
 les deux numérotations n'ont pas même maillage d'origine
  numérotation 1: %(k1)s
  maillage     1: %(k2)s
  numérotation 2: %(k3)s
  maillage     2: %(k4)s
"""),

    63 : _("""
 perte d'information sur DDL physique à la conversion de numérotation
 noeud numéro    :  %(i1)d
 type DDL numéro :  %(i2)d
"""),

    64 : _("""
 arrêt sur perte d'information DDL physique
"""),








    67 : _("""
 arrêt sur problème de conditions d'interface
"""),

    68 : _("""
 le maillage final n'est pas 3D
 maillage : %(k1)s
"""),

    69 : _("""
 l'origine du maillage 1D n'est pas 0
"""),

    70 : _("""
 les noeuds du maillage sont confondus
"""),

    71 : _("""

 le noeud se trouve en dehors du domaine de définition avec un profil gauche de type EXCLU
 noeud :  %(k1)s
"""),

    72 : _("""

 le noeud se trouve en dehors du domaine de définition avec un profil droit de type EXCLU
 noeud :  %(k1)s
"""),

    73 : _("""
 problème pour stocker le champ dans le résultat :  %(k1)s
 pour le NUME_ORDRE :  %(i1)d
"""),

    74 : _("""
 Le champ est déjà existant
 il sera remplacé par le champ %(k1)s
 pour le NUME_ORDRE  %(i1)d
"""),







    77 : _("""
 pas d'interface définie
"""),

    78 : _("""
 arrêt sur interface déjà définie
 mot-clé interface numéro  -->  %(i1)d
 interface                 -->  %(k1)s
"""),

    79 : _("""
 les deux interfaces n'ont pas le même nombre de noeuds
 nombre noeuds interface droite -->  %(i1)d
 nombre noeuds interface gauche -->  %(i2)d
"""),

    80 : _("""
 les deux interfaces n'ont pas le même nombre de degrés de liberté
 nombre ddl interface droite -->  %(i1)d
 nombre ddl interface gauche -->  %(i2)d
"""),

    81 : _("""
 arrêt sur base modale ne comportant pas de modes propres
"""),

    82 : _("""

 le nombre de modes propres demandé est supérieur au nombre de modes dynamiques de la base
 nombre de modes demandés       --> %(i1)d
 nombre de modes de la base     --> %(i2)d
 nombre de fréquences douteuses --> %(i3)d
"""),

    83 : _("""
 plusieurs champs correspondant à l'accès demandé
 résultat     : %(k1)s
 accès "INST" : %(r1)f
 nombre       : %(i1)d
"""),

    84 : _("""
 pas de champ correspondant à un accès demandé
 résultat     :  %(k1)s
 accès "INST" :  %(r1)f
"""),











}
