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

"""
   Messages à l'attention des développeurs, type "ASSERT"
   Lorsque l'utilisateur tombe sur un tel message, tout ce qu'il a à faire,
   c'est de rapporter le bug, le texte du message devant aider le
   développeur à faire le diagnostic.

   "UTPRIN" ajoute automatiquement ces deux lignes :
      Il y a probablement une erreur dans la programmation.
      Veuillez contacter votre assistance technique.
"""

cata_msg = {

    1 : _("""
Erreur de programmation.

Condition non respectée:
    %(k1)s
Fichier %(k2)s, ligne %(i1)d
"""),

    2 : _("""
Erreur numérique (floating point exception).
"""),

    3 : _("""
Erreur de programmation : Nom de grandeur inattendu : %(k1)s
Routine : %(k2)s
"""),

    4 : _("""
On ne sait pas traiter ce type d'élément : %(k1)s
"""),



    6 : _("""
Erreur de programmation :
  La mémoire allouée avec la routine AS_ALLOCATE n'a pas été totalement libérée
  (fuite mémoire).

  Le volume de mémoire perdu est : %(r1).6f Mo

Risques et conseils :
  Il faut émettre une fiche d'anomalie.
"""),

    7 : _("""
Erreur de programmation :
  Le nombre d'objet de travail créés par le mécanisme AS_ALLOCATE
  est supérieur au maximum autorisé.

Risques et conseils :
  Il faut émettre une fiche d'anomalie.
"""),



    9 : _("""
Erreur de programmation dans un module Python.
Condition non respectée : %(k2)s

      %(k1)s
"""),

    97 : _("""
Erreur signalée dans la bibliothèque MED
     nom de l'utilitaire : %(k1)s
             code retour : %(i1)d
"""),

}
