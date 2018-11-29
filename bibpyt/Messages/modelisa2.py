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



    3: _("""
 calcul de la tension le long du câble numéro %(k1)s  :
 la longueur sur laquelle on devrait prendre en compte les pertes de tension par recul de l ancrage
 est supérieure à la longueur du câble"""),

    4: _("""
  calcul de la tension le long du câble numéro %(k1)s  :
  la longueur sur laquelle on doit prendre en compte les pertes de tension par recul de l ancrage
  est égale à la longueur du câble"""),

    5: _("""
 Formule interdite pour le calcul d'intégrale : la fonction soit être tabulée.
 Utilisez CALC_FONC_INTERP pour tabuler la formule %(k1)s
"""),

    6: _("""
Erreur d'utilisation :
 Le modèle contient un mélange d'éléments 2D (vivant dans le plan Oxy) et 3D.
 Le code n'a pas prévu ce cas de figure ici.

Risques et conseils :
 Il faut peut être émettre une demande d'évolution pour pouvoir traiter ce problème.
"""),

    7: _("""
Occurrence de %(k1)s.
La maille %(k2)s a déjà été affectée par l'angle %(k3)s.
   Orientation précédente : %(r1)f [°]
   Orientation nouvelle   : %(r2)f [°]
La règle de surcharge est appliquée.
"""),

    8: _("""
  Il n'y a pas d'élément discret fixé au noeud %(k1)s du radier.
"""),

    9: _("""
  Erreur utilisateur :
    l'objet %(k1)s n'existe pas. On ne peut pas continuer.
  Risques & conseils :
    Dans ce contexte, les seuls solveurs autorisés sont MULT_FRONT et LDLT
"""),

    10: _("""
  Le nombre de noeuds du radier et le nombre d'éléments discrets du groupe %(k1)s sont différents :
  Nombre de noeuds du radier : %(i1)d
  Nombre d'éléments discrets         : %(i2)d
"""),

    11: _("""
Erreur utilisateur :
  Le modèle fourni %(k1)s est associé au maillage %(k2)s.
  Ce maillage est différent du maillage fourni %(k3)s.
"""),

    13: _("""
 problème pour récupérer une grandeur dans la table CARA_GEOM
"""),

    14: _("""
 plus petite taille de maille négative ou nulle
"""),

    15: _("""
 groupe de maille GROUP_MA_1= %(k1)s  inexistant dans le maillage  %(k2)s
"""),

    16: _("""
 groupe de maille GROUP_MA_2= %(k1)s  inexistant dans le maillage  %(k2)s
"""),

    17: _("""
 les groupes de mailles GROUP_MA_1= %(k1)s  et GROUP_MA_2= %(k2)s  ont des cardinaux différents
"""),

    18: _("""
 nombre de noeuds incohérent sous les 2 GROUP_MA a coller
"""),

    19: _("""
 un noeud de GROUP_MA_2 n'est géométriquement appariable avec aucun de GROUP_MA_1
"""),



    21: _("""
  -> Le GROUP_MA %(k1)s est présent dans les 2 maillages que l'on assemble.
     Il y a conflit de noms. Le GROUP_MA du 2ème maillage est renommé.
  -> Risque & Conseil :
     Vérifiez que le nom du GROUP_MA retenu est bien celui souhaité.
"""),

    22: _("""
  -> Le GROUP_NO %(k1)s est présent dans les 2 maillages que l'on assemble.
     Il y a conflit de noms. Le GROUP_NO du 2ème maillage est renommé.
  -> Risque & Conseil :
     Vérifiez que le nom du GROUP_NO retenu est bien celui souhaité.
"""),

    23: _("""
 traitement non prévu pour un modèle avec mailles tardives.
"""),

    24: _("""
 absence de carte d'orientation des éléments. la structure étudiée n'est pas une poutre.
"""),

    25: _("""
 problème pour déterminer les rangs des composantes <ALPHA> , <BETA> , <GAMMA> de la grandeur <CAORIE>
 """),

    26: _("""
 erreur a l'appel de la routine pour extension de la carte  %(k1)s .
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    27: _("""
 Détection d'un élément d'un type non admissible. La structure étudiée n'est pas une poutre droite.
"""),

    28: _("""
 l'élément supporté par la maille numéro %(i1)d n'a pas été orienté.
"""),

    29: _("""
 carte d'orientation incomplète pour l'élément supporté par la maille numéro %(i1)d.
"""),

    30: _("""
 les éléments de la structure ne sont pas d'un type attendu. la structure étudiée n'est pas une poutre droite.
"""),

    31: _("""
 l'axe directeur de la poutre doit être parallèle avec l'un des axes du repère global.
"""),

    32: _("""
 la structure étudiée n'est pas une poutre droite.
"""),


    37: _("""
 valeur inattendue:  %(k1)s
"""),




    43: _("""
 deux mailles POI1 interdit
"""),

    45: _("""
Loi de comportement RELAX_ACIER :
Vous avez un matériau avec le comportement %(k1)s et RELAX_1000=%(r1)f
Si vous avez utilisé la commande DEFI_CABLE_BP, il faut que TYPE_RELAX='SANS' ou RELAX_1000=0.0
pour ne pas prendre en compte 2 fois la relaxation.
"""),

    46: _("""
Loi de comportement RELAX_ACIER :
Pour prendre en compte la relaxation, F_PRG est obligatoire. Ce paramètre peut-être donné à l'aide de la
commande DEFI_MATERIAU soit par :
  - RELAX_ACIER / F_PRG : réel ou fonction pouvant dépendre de la température
  - BPEL_ACIER  / F_PRG : réel
  - ETCC_ACIER  / F_PRG : réel
"""),

    47: _("""
Opérateur DEFI_CABLE_BP:
  Vous avez indiqué TYPE_RELAX='SANS' et donné RELAX_1000 = %(r1)f.
  Aucun calcul de relaxation des câbles ne sera fait par DEFI_CABLE_BP.
  La valeur ne sera donc pas prise en compte.
"""),

    48: _("""
 récupération des caractéristiques élémentaires du câble no %(k1)s  : détection d un élément différent du type <MECA_barre>
"""),

    49: _("""
 les caractéristiques matérielles n'ont pas été affectées à la maille no %(k1)s  appartenant au câble no %(k2)s
 """),

    50: _("""
 des matériaux différents ont été affectés aux mailles appartenant au câble no %(k1)s
"""),

    51: _("""
 récupération des caractéristiques du matériau ACIER associé au câble no %(k1)s  : absence de relation de comportement de type <ELAS>
"""),

    52: _("""
 récupération des caractéristiques du matériau ACIER associé au câble no %(k1)s , relation de comportement <ELAS> : module de Young indéfini
"""),

    53: _("""
 récupération des caractéristiques du matériau ACIER associé au câble no %(k1)s , relation de comportement <ELAS> : valeur invalide pour le module de Young
"""),

    54: _("""
 récupération des caractéristiques du matériau ACIER associé au câble no %(k1)s  : absence de relation de comportement de type <BPEL_ACIER> ou <ETCC_ACIER>
"""),

    55: _("""
 récupération des caractéristiques du matériau ACIER associé au câble no %(k1)s , relation de comportement <BPEL_ACIER> : Le paramètre F_PRG doit être positif et non nul
 """),
    56 : _("""
 Pour faire un calcul de relaxation type ETCC_REPRISE, vous devez  renseigner le mot-clé TENSION_CT de DEFI_CABLE pour chaque câble de précontrainte,
"""),

    57: _("""
 les caractéristiques géométriques n'ont pas été affectées à la maille no %(k1)s  appartenant au câble no %(k2)s
 """),

    58: _("""
 l'aire de la section droite n a pas été affectée à la maille no %(k1)s  appartenant au câble no %(k2)s
"""),

    59: _("""
 valeur invalide pour l'aire de la section droite affectée à la maille numéro %(k1)s  appartenant au câble numéro %(k2)s
"""),

    60: _("""
 des aires de section droite différentes ont été affectées aux mailles appartenant au câble no %(k1)s
"""),

    62: _("""
  numéro d'occurrence négatif
"""),



    64: _("""
 il faut choisir entre : FLUX_X ,  FLUX_Y , FLUX_Z et FLUN , FLUN_INF , FLUN_SUP.
"""),

    65: _("""
 le descripteur_grandeur des forces ne tient pas sur dix entiers codés
"""),

    66: _("""
 trop de valeurs d'angles, on ne garde que les 3 premiers.
"""),

    67 : _("""
La table fournie dans DEFI_CABLE doit contenir l'abscisse curviligne et la tension du câble.
"""),

    68 : _("""
La table fournie n'a pas la bonne dimension : vérifiez qu'il s'agit du bon câble ou que plusieurs
instants ne sont pas contenus dans la table.
"""),

    69 : _("""
Les abscisses curvilignes de la table fournie ne correspondent pas à celles du câble étudié
"""),

    70 : _(""" Attention, vous voulez calculer les pertes par relaxation de l'acier, mais
      le coefficient RELAX_1000 est nul. Les pertes associées sont donc nulles.
 """),


71: _("""
 LIAISON_PROJ : Le noeud %(k1)s ne porte pas le DDL %(k2)s.
"""),

72 : _("""
 LIAISON_PROJ : La relation linéaire pour le noeud %(k1)s est une tautologie.
 On ne l'écrit pas.
"""),

73 : _("""
 LIAISON_PROJ : avec l'option TYPE='EXCENTREMENT' les seules mailles disponibles sont :
 %(k1)s
"""),

74 : _("""
 LIAISON_PROJ : Tous les maillages doivent être identiques.
   Maillage sur lequel s'appui la charge %(k1)8s        : %(k2)s
   Maillage des mailles maîtres, utilisé dans PROJ_CHAMP : %(k3)s
   Maillage des noeuds esclaves, utilisé dans PROJ_CHAMP : %(k4)s
"""),

75: _("""
 LIAISON_PROJ : ne fonctionne qu'avec des modélisations 3D.
"""),

76: _("""
 Incohérence détectée entre le nombre de modes de la base "mouillée", calculée par CALC_FLUI_STRU, et ceux de la
 base modale de la structure "en air", utilisée pour la projection du spectre de turbulence (PROJ_SPEC_BASE).

 - Nombre de modes de la base mouillée : %(i1)d
 - Nombre de modes de la base en air   : %(i2)d

 Conseil : si vous avez filtré des modes lors du calcul des coefficients de couplage (CALC_FLUI_STRU), il faut
 obligatoirement les omettre de la base de projection du spectre (PROJ_SPEC_BASE).

 En pratique, si un filtrage de modes est nécessaire pour l'étape de calcul IFS, un simple appel à EXTR_MODE sur
 la base initiale permet d'extraire ces modes. Cette étape réalisée en amont des calculs couplés Fluide-Structure
 permet d'assurer la cohérence de l'enchaînement.
"""),

    83: _("""
 on doit utiliser le mot clé CHAM_NO pour donner le CHAM_NO dont les composantes seront les seconds membres de la relation linéaire.

 """),

    84: _("""
 il faut que le CHAM_NO dont les termes servent de seconds membres à la relation linéaire à écrire ait été défini.
 """),

    85: _("""
 on doit donner un CHAM_NO après le mot clé CHAM_NO derrière le mot facteur CHAMNO_IMPO .
"""),

    86: _("""
 il faut définir la valeur du coefficient de la relation linéaire après le mot clé COEF_IMPO derrière le mot facteur CHAMNO_IMPO
"""),

    87: _("""
 le descripteur_grandeur de la grandeur de nom  %(k1)s  ne tient pas sur dix entiers codés
"""),

    89: _("""
 Le contenu de la table n'est pas celui attendu !
"""),

    90: _("""
 Le calcul par l'opérateur <CALC_FLUI_STRU> des paramètres du mode no %(i1)d
 n'a pas convergé pour la vitesse no %(i2)d. On ne calcule donc pas
 d'interspectre de réponse modale pour cette vitesse.
"""),

    91: _("""
La fonction n'a pas été trouvée dans la colonne %(k1)s de la table %(k2)s
(ou bien le paramètre %(k1)s n'existe pas dans la table).
"""),

    92: _("""
Les mots-clés admissibles pour définir la première liste de noeuds sous le mot-clé facteur  %(k1)s sont :
"GROUP_NO_1" ou "NOEUD_1" ou "GROUP_MA_1" ou "MAILLE_1".
"""),

    93: _("""
Les mots-clés admissibles pour définir la seconde liste de noeuds sous le mot-clé facteur  %(k1)s  sont :
"GROUP_NO_2" ou "NOEUD_2" ou "GROUP_MA_2" ou "MAILLE_2".
"""),

    94: _("""
  LIAISON_GROUP : on ne sait pas calculer la normale à un noeud. Il faut passer par les mailles
"""),

    95: _("""
 le groupe  %(k1)s ne fait pas partie du maillage :  %(k2)s
"""),

    96: _("""
  %(k1)s   %(k2)s ne fait pas partie du maillage :  %(k3)s
"""),


    97: _("""
  Assemblage de maillages : Présence de noeuds confondus dans la zone à coller GROUP_MA_1.
"""),


}
