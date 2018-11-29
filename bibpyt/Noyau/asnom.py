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
Description des types de base aster

version 2 - réécrite pour essayer de simplifier
le problème des instances/types et instances/instances

le type de base ASBase permet de représenter une structure
de donnée. Une instance de ASBase comme attribut d'une classe
dérivée de ASBase représente une sous-structure nommée.

une instance de ASBase 'libre' représente une instance de la
structure de donnée complète.

c'est ce comportement qui est capturé dans la classe StructType
"""

from .basetype import Type


class SDNom(Type):

    """Objet représentant une sous-partie de nom
    d'objet jeveux"""
    nomj = None
    debut = None
    fin = None
    just = None
    justtype = None

    def __init__(self, nomj=None, debut=None, fin=None, just='l', **kwargs):
        """
        Configure un objet nom
        nomj : la partie du nom fixée (par ex .TITR) ou '' si non précisée
        debut, fin : la partie du K24 concernée
        just : la justification a droite ou a gauche ('l' ou 'r')
        kwargs : inutilisé, juste par simplicité

        Note:
        On utilise cet objet comme attribut d'instance ou de classe.
        En attribut de classe pour les noms de structure, cela permet
        de définir la position du nom d'objet dans le nom jeveux, l'attribut
        nom est alors la valeur du suffixe pour une sous-structure ou None pour
        une structure principale.
        """
        super(SDNom, self).__init__(
            nomj=nomj, debut=debut, fin=fin, just=just, **kwargs)
        self.update((nomj, debut, fin, just))

    def __call__(self):
        if self._parent is None or self._parent._parent is None:
            debut = self.debut or 0
            prefix = ' ' * debut
        else:
            # normalement
            # assert self._parent.nomj is self
            nomparent = self._parent._parent.nomj
            prefix = nomparent()
            debut = self.debut or nomparent.fin or len(prefix)
        fin = self.fin or 24
        nomj = self.nomj or ''
        nomj = self.just(nomj, fin - debut)
        prefix = prefix.ljust(24)
        res = prefix[:debut] + nomj + prefix[fin:]
        return res[:24]

    def fcata(self):
        return self.just(self.nomj, self.fin - self.debut).replace(' ', '?')

    def __repr__(self):
        return "<SDNom(%r,%s,%s)>" % (self.nomj, self.debut, self.fin)

    # On utilise pickle pour les copies, et pickle ne sait pas gérer la
    # sauvegarde de str.ljust ou str.rjust (c'est une méthode non liée)

    def __getstate__(self):
        return (self.nomj, self.debut, self.fin, self.justtype)

    def __setstate__(self, xxx_todo_changeme):
        (nomj, debut, fin, just) = xxx_todo_changeme
        self.nomj = nomj
        self.debut = debut
        self.fin = fin
        if just == 'l' or just is None:
            self.just = str.ljust
        elif just == 'r':
            self.just = str.rjust
        else:
            raise ValueError("Justification '%s' invalide" % just)
        self.justtype = just

    def update(self, xxx_todo_changeme1):
        (nomj, debut, fin, just) = xxx_todo_changeme1
        if nomj is not None:
            self.nomj = nomj
        if self.debut is None:
            self.debut = debut
        if self.fin is None:
            self.fin = fin
        if self.justtype is None and just is not None:
            if just == 'l':
                self.just = str.ljust
            elif just == 'r':
                self.just = str.rjust
            else:
                raise ValueError("Justification '%s' invalide" % just)
            self.justtype = just

    def reparent(self, parent, new_name):
        self._parent = parent
        self._name = new_name
        for nam in self._subtypes:
            obj = getattr(self, nam)
            obj.reparent(self, nam)
        if self.nomj is None and self._parent._name is not None:
            self.nomj = "." + self._parent._name
