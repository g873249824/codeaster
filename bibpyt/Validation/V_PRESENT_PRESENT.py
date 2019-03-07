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

# person_in_charge: mathieu.courtois at edf.fr


class PRESENT_PRESENT:

    """
       La règle vérifie que si le premier mot-clé de self.mcs est present
           parmi les elements de args les autres doivent l'etre aussi

       Ces arguments sont transmis à la règle pour validation sous la forme
       d'une liste de noms de mots-clés ou d'un dictionnaire dont
       les clés sont des noms de mots-clés.
    """

    def verif(self, args):
        """
            La methode verif effectue la verification specifique à la règle.
            args peut etre un dictionnaire ou une liste. Les éléments de args
            sont soit les éléments de la liste soit les clés du dictionnaire.
        """
        #  on verifie que si le premier de la liste est present,
        #    les autres le sont aussi
        mc0 = self.mcs[0]
        text = ''
        test = 1
        args = self.liste_to_dico(args)
        if mc0 in args:
            for mc in self.mcs[1:len(self.mcs)]:
                if mc not in args:
                    text = text + "- Le mot clé " + repr(mc0)+ \
                        " étant présent, il faut que : " + \
                        mc + " soit présent" + '\n'
                    test = 0
        return text, test
