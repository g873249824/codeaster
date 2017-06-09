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


class MissDomains(object):

    """A MissDomain instance assigns the identifiers of the domains and
    the different groups they contains"""

    def __init__(self, use_pc, use_issf):
        """Initialization"""
        self.use_pc = use_pc
        self.use_issf = use_issf
        # XXX by defining all the domains, even for issf, fdlv112b fails
        self.def_all_domains = (not use_issf) or use_pc
        self.domain = {}
        self.group = {}
        self._define_domain()

    def __getitem__(self, key):
        """Return a domain definition"""
        return self.domain[key]

    def get(self, key, default=None):
        """Return a domain definition"""
        return self.domain.get(key, default)

    def _define_domain(self):
        """Define the group and domain numbers.
        'group' and 'domain' are dictionnaries.
        - Keys of 'group' are strings: 'sol-struct', 'fluide-struct',
          'sol-fluide', 'sol libre', 'pc', 'struct'
        - Keys of 'domain' are strings: 'struct', 'sol', 'fluide'.
          A domain is defined by its number and the groups that belong to it.

             groupes                   ISS    ISS+PC  ISFS    ISFS+PC
        . interface sol-structure       1       1       1       1
        . interface fluide-structure                    2       2
        . interface sol-fluide                          3       3
        . sol libre                                     4       4
        . points de contrôle                    2               5
        . volume de la structure        2       3       5       6
        """
        self.domain['struct'] = (1, [1])
        self.domain['sol'] = (2, [-1])
        self.group['sol-struct'] = i = 1
        if self.use_issf:
            if self.def_all_domains:
                self.domain['fluide'] = (3, [-2, -3])
            else:
                self.domain['sol'] = (1, [-1])
                self.domain['fluide'] = (2, [-2, -3])
            self.group['fluide-struct'] = i = i + 1
            self.group['sol-fluide'] = i = i + 1
            self.group['sol libre'] = i = i + 1
            self.domain['struct'][1].append(self.group['fluide-struct'])
            self.domain['sol'][1].extend([self.group['sol-fluide'],
                                          self.group['sol libre']])
        if self.use_pc:
            self.group['pc'] = i = i + 1
            self.domain['sol'][1].append(self.group['pc'])
        self.group['struct'] = i = i + 1
        self.domain['struct'][1].append(self.group['struct'])
        # checkings
        if not self.use_pc and not self.use_issf:
            assert self.group['struct'] == 2
        elif self.use_pc and not self.use_issf:
            assert self.group['struct'] == 3
        elif not self.use_pc and self.use_issf:
            assert self.group['struct'] == 5
        elif self.use_pc and self.use_issf:
            assert self.group['struct'] == 6
