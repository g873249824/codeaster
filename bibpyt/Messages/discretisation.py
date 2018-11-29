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

    1 : _("""
Certains pas de temps de la liste (LISTE_INST) sont plus petits
 que le pas de temps minimal renseigné (SUBD_PAS_MINI)
"""),

    2 : _("""
 L'instant initial de la liste est plus grand que le deuxième instant.
 Si vous faites une reprise de calcul (REUSE), vous pouvez utiliser le mot-clef ETAT_INIT/INST_ETAT_INIT pour corriger cela.
"""),

    3 : _("""
 Problème lors de la récupération de la table contenant les paramètres calculés du résultat <%(k1)s>.
Conseils :
   Vérifiez que le résultat <%(k1)s> provient bien de la commande STAT_NON_LINE ou DYNA_NON_LINE.
"""),

    4 : _("""
 Problème lors de la récupération de la table contenant les paramètres calculés du résultat <%(k1)s>.
 Ce résultat a été construit en reprise (REUSE). On ne sait pas extraire une liste d'instants correcte.
Conseils :
   Faites votre calcul initial sans reprise.
"""),


    5 : _("""
 L'adaptation du pas de temps a été désactivée. Seuls les instants définis par LIST_INST seront calculés
 (hormis les sous découpages éventuels).
"""),

    6 : _("""
Le paramètre SUBD_PAS_MINI est plus grand que le plus petit intervalle de temps donné %(r1)f.
"""),

    8 : _("""
 Vous faites un calcul de thermique sans résolution stationnaire et sans
 non plus de résolution transitoire.

 Conseils :
   Renseignez la discrétisation temporelle par le mot clé INCREMENT
"""),

    9 : _("""
 Attention, en cas d'erreur (contact, loi de comportement, pilotage, ...), le pas de temps
 ne sera pas redécoupé.
"""),


    10 : _("""
 Il y a trop d'occurrences de ECHEC/EVENEMENT=<%(k1)s>.
"""),

    14 : _("""
 Attention : avec MODE_CALCUL_TPLUS = 'IMPLEX', on doit demander le calcul à tous les instants
 (EVENEMENT='TOUT_INST')
"""),

    15 : _("""
 Attention : MODE_CALCUL_TPLUS = 'IMPLEX' ne permet qu'un mot clé ADAPTATION
"""),

    43 : _("""
  Vous n'avez pas activé la détection de singularité (NPREC est négatif).
  La découpe du pas de temps en cas d'erreur sur matrice singulière (pivot nul) ne sera
donc pas possible.
"""),

    87 : _("""
La liste d'instants n'est pas strictement croissante.
"""),

    89 : _("""
L'instant initial est introuvable dans la liste d'instants (LIST_INST).
Risque & Conseil :
   Vérifiez le mot-clé INST_INIT (ou NUME_INST_INIT), en tenant compte de la précision (mot-clé PRECISION).
"""),

    92 : _("""
On ne peut faire le calcul car l'instant final donné est égal au dernier instant stocké dans la structure de données RESULTAT. Il n'y a qu'un incrément disponible alors qu'il faut au moins deux pas de temps dans les opérateurs non-linéaires.
"""),

    94 : _("""
L'instant final est introuvable dans la liste d'instants (LIST_INST).
Risque & Conseil :
   Vérifiez le mot-clé INST_FIN (ou NUME_INST_FIN), en tenant compte de la précision (mot-clé PRECISION).
"""),

    95 : _("""
La liste des instants ne contient qu'un instant.
Pour un calcul en mécanique non-linéaire, il faut plusieurs instants de calcul.
"""),

    96 : _("""
La liste des instants ne contient qu'un instant et ce n'est pas un calcul stationnaire.
Pour un calcul en thermique non-linéaire, il faut plusieurs instants de calcul.
"""),


}
