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

# person_in_charge: mathieu.courtois at edf.fr


"""
    Ce module contient la classe mere pour les classes de definition des regles d exclusion.

    La classe REGLE est la classe de base : elle est virtuelle, elle ne doit pas etre instanciee.

    Les classes regles dérivées qui seront instanciées doivent implementer la methode verif
    dont l argument est le dictionnaire des mots cles effectivement presents
    sur lesquels sera operee la verification de la regle

    A la creation de l'objet regle on lui passe la liste des noms de mots cles concernes

    Exemple ::

    # Création de l'objet règle UNPARMI
    r=UNPARMI("INFO","AFFE")
    # Vérification de la règle r sur le dictionnaire passé en argument
    r.verif({"INFO":v1,"AFFE":v2)
"""

import types


class REGLE:

    def __init__(self, *args):
        """
            Les classes dérivées peuvent utiliser cet initialiseur par défaut ou
            le surcharger
        """
        self.mcs = args

    def verif(self, args):
        """
           Les classes dérivées doivent implémenter cette méthode
           qui doit retourner une paire dont le premier élément est une chaine de caractère
           et le deuxième un entier.

           L'entier peut valoir 0 ou 1. -- s'il vaut 1, la règle est vérifiée
            s'il vaut 0, la règle n'est pas vérifiée et le texte joint contient
           un commentaire de la non validité.
        """
        raise NotImplementedError('class REGLE should be derived')

    def liste_to_dico(self, args):
        """
           Cette méthode est utilitaire pour les seuls besoins
           des classes dérivées.

           Elle transforme une liste de noms de mots clés en un
           dictionnaire équivalent dont les clés sont les noms des mts-clés

           Ceci permet d'avoir un traitement identique pour les listes et les dictionnaires
        """
        if type(args) == dict:
            return args
        elif type(args) == list:
            dico = {}
            for arg in args:
                dico[arg] = 0
            return dico
        else:
            raise Exception(
                "Erreur ce n'est ni un dictionnaire ni une liste %s" % args)
