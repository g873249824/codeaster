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


"""

"""
# Modules Python

# Modules Eficas
from . import B_utils


class ENTITE:

    """

    """

    def get_entite(self, nom, typ=None):
        """
            Cette méthode retourne la sous entite de nom nom et de type typ
            Les blocs sont explorés recursivement mais pas les mots cles facteurs
            Si typ is None on ne vérifie pas le type. Sinon, on ne retourne la sous entité
            que si elle est du bon type.
            Si aucune sous entite ne satisfait les criteres la methode retourne None
        """
        for k, v in list(self.entites.items()):
            if k == nom:
                if typ is None:
                    return v
                elif isinstance(v, typ):
                    return v
            if v.label == 'BLOC':
                o = v.get_entite(nom, typ)
                if o:
                    return o
        return None

    def get_nb_mcs(self):
        """
            Cette methode retourne le nombre total de mots cles simples
            sous l'objet self
        """
        nb = 0
        for k, v in list(self.entites.items()):
            if v.label in ("BLOC", "FACT"):
                nb = nb + v.get_nb_mcs()
            elif v.label in ("SIMP",):
                nb = nb + 1
            else:
                pass
        return nb

    def get_mc_simp(self, niv=1):
        """
            Cette methode retourne la liste des mots cles simple sous self
            On descend sous les BLOC & MCFACT.
        """
        motcles = []
        for k, v in list(self.entites.items()):
            if v.label == 'BLOC':
                motcles.extend(v.get_mc_simp(niv))
            elif v.label == 'SIMP':
                motcles.append(k)
            elif v.label == 'FACT':
                # on ne veut conserver que les mcsimp de haut niveau
                if niv == 1:
                    pass
                    # on veut "eliminer" les mcfacts pour avoir tous les mcsimp
                elif niv == 2:
                    motcles.extend(v.get_mc_simp(niv))
        return motcles

    def get_mc_fact(self):
        """
            Cette methode retourne la liste des noms de mots cles facteurs
            sous self
        """
        motcles = []
        for k, v in list(self.entites.items()):
            if v.label == 'BLOC':
                motcles.extend(v.get_mc_fact())
            elif v.label == 'SIMP':
                pass
            elif v.label == 'FACT':
                motcles.append(k)
        return motcles

    def get_li_mc_fact(self):
        """
            Cette methode retourne la liste des mots cles facteurs sous self
        """
        motcles = []
        for k, v in list(self.entites.items()):
            if v.label == 'BLOC':
                motcles.extend(v.get_li_mc_fact())
            elif v.label == 'SIMP':
                pass
            elif v.label == 'FACT':
                motcles.append(v)
        return motcles

    def getmcfs(self, nom_motfac):
        """
            Retourne la liste des mots cles facteurs de nom nom_motfac
            contenus dans la definition self
            Tous les mots cles facteurs contenus dans tous les blocs
            sont mis dans cette liste

            Si la definition ne comporte aucun mot cle facteur de nom
            nom_motfac, on retourne une liste vide []
        """
        l = []
        for k, v in list(self.entites.items()):
            # Si l'entite a pour nom nom_motfac et est de type FACT, on
            # l'ajoute a la liste
            if k == nom_motfac and v.label == 'FACT':
                l.append(v)
            if v.label == 'BLOC':
                # S'il s'agit d'un bloc, on lui demande de retourner la liste des mots cles facteurs
                # qu'il contient. (On peut avoir plusieurs sous blocs) et on
                # l'ajoute a la liste globale
                o = v.getmcfs(nom_motfac)
                if o:
                    l = l + o
        return l
