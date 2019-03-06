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

from SD import *
from SD.sd_maillage import sd_maillage
from SD.sd_nume_ddl import sd_nume_ddl
from SD.sd_util import *


class sd_interf_dyna_clas(AsBase):
#---------------------------------------
    nomj = SDNom(fin=8)
    IDC_NOMS = AsObject(genr='N', xous='S', type='K', ltyp=8, )
    IDC_DDAC = AsColl(
        acces='NU', stockage='DISPERSE', modelong='VARIABLE', type='I', )
    IDC_DY_FREQ = AsVR(lonmax=1, )
    IDC_LINO = AsColl(
        acces='NU', stockage='DISPERSE', modelong='VARIABLE', type='I', )
    IDC_TYPE = AsVK8()
    IDC_DESC = AsVI(lonmax=5, )
    IDC_DEFO = AsVI()
    IDC_REFE = AsVK24(lonmax=3, )

    def check_coherence_longueurs(self, checker):
        noms = self.IDC_NOMS.get()
        type = self.IDC_TYPE.get()
        lino = self.IDC_LINO.get()
        ddac = self.IDC_DDAC.get()
        nb_intf = len(noms)
        assert nb_intf > 0, noms
        assert len(type) == nb_intf, (nb_intf, type)
        assert len(list(lino.keys())) == nb_intf, (nb_intf, lino)
        assert len(list(ddac.keys())) == nb_intf, (nb_intf, ddac)

    def check_REFE(self, checker):
        refe = self.IDC_REFE.get()
        sd2 = sd_maillage(refe[0])
        sd2.check(checker)
        sd2 = sd_nume_ddl(refe[1])
        sd2.check(checker)
        assert refe[2].strip() == '', refe

    def check_DESC(self, checker):
        desc = self.IDC_DESC.get()
        assert desc[0] == 1, desc
        assert desc[1] > 2 and desc[1] < 10, desc
        assert desc[2] > 60 and desc[2] < 300, desc
        assert desc[3] > 0 and desc[3] < 500, desc
        assert desc[4] > 0, desc
        nomgd = sdu_nom_gd(desc[3]).strip()
        assert nomgd == 'DEPL_R', (nomgd, desc)

    def check_NOMS(self, checker):
        # il n'y a rien à vérifier : un pointeur de noms contient
        # toujours des noms "non blancs" et "tous différents"
        pass

    def check_TYPE(self, checker):
        type = self.IDC_TYPE.get()
        for t1 in type:
            assert t1.strip() in ('CRAIGB', 'MNEAL', 'CB_HARMO', 'AUCUN'), type

    def check_LINO_DDAC(self, checker):
        lino = self.IDC_LINO.get()
        ddac = self.IDC_DDAC.get()
        desc = self.IDC_DESC.get()
        nbec = desc[1]
        nb_intf = len(list(lino.keys()))

        for kintf in range(nb_intf):
            llino = list(lino.values())[kintf]
            lddac = list(ddac.values())[kintf]
            nbno = len(llino)
            assert len(lddac) == nbno * nbec, (lino, ddac)
            for nuno in llino:
                assert nuno > 0, lino

    def check_FREQ(self, checker):
        freq = self.IDC_DY_FREQ.get()
        assert freq[0] >= 0, freq

    def check_DEFO(self, checker):
        defo = self.IDC_DEFO.get()
        desc = self.IDC_DESC.get()
        nbec = desc[1]
        nbnot = len(defo) // (nbec + 2)
        assert len(defo) == nbnot * (nbec + 2), defo
        for k in range(nbnot):
            assert defo[k] > 0, defo

        assert sdu_monotone(defo[nbnot:2 * nbnot]) in (
            1, 0), (nbnot, nbec, defo)
