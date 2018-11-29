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

from SD import *
from SD.sd_util import *
from SD.sd_titre import sd_titre
from SD.sd_prof_chno import sd_prof_chno


class sd_cham_no(sd_titre):
    nomj = SDNom(fin=19)
    VALE = AsVect(ltyp=Parmi(4, 8, 16, 24), type=Parmi(
        'C', 'I', 'K', 'R'), docu=Parmi('', '2', '3'), )
    REFE = AsVK24(lonmax=4)
    DESC = AsVI(docu='CHNO', )

    def exists(self):
        # retourne "vrai" si la SD semble exister (et donc qu'elle peut etre
        # vérifiée)
        return self.REFE.exists

    def u_desc(self):
        desc = self.DESC.get()
        gd = desc[0]
        num = desc[1]
        return gd, num

    def u_refe(self):
        refe = self.REFE.get_stripped()
        mail = refe[0]
        prof_chno = refe[1]
        assert refe[2] == '', refe
        assert refe[3] == '', refe
        return mail, prof_chno

    def check_cham_no_i_REFE(self, checker):
        if not self.exists():
            return
        if self.REFE in checker.names:
            return

        mail, prof_chno = self.u_refe()

        # faut-il vérifier le sd_maillage de chaque sd_cham_no ?   AJACOT_PB
        #  - cela risque de couter cher
        #  - cela pose un problème "import circulaire" avec sd_maillage -> sd_cham_no => import ici
        from SD.sd_maillage import sd_maillage
        sd2 = sd_maillage(mail)
        sd2.check(checker)

        if prof_chno:
            if prof_chno[:14] + '.NUME.PRNO' in checker.names:
                return
            sd2 = sd_prof_chno(prof_chno)
            sd2.check(checker)

    def check_cham_no_DESC(self, checker):
        if not self.exists():
            return
        if self.DESC in checker.names:
            return

        gd, num = self.u_desc()
        if (num < 0):
            nb_ec = sdu_nb_ec(gd)
            assert self.DESC.lonmax == 2 + nb_ec
        else:
            assert self.DESC.lonmax == 2
