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

# person_in_charge: serguei.potapov at edf.fr

"""
Traitement special des poutres
"""
from Utilitai.partition import MAIL_PY
from Utilitai.Utmess import UTMESS
import numpy
import math
from Calc_epx.calc_epx_utils import norme, vecteurs_egaux, tolist

#----------------------------- Precision -------------------------------
tst = 1.0E-10
#------------------------------------------------------------------------
#----------------------------- class POUTRE -----------------------------
#------------------------------------------------------------------------


class POUTRE:

    """
        Classe POUTRE pour gérer les orientation.
    """

    def __init__(self, MAILLAGE, CARA_ELEM):
        """
            Initialisation d'une instance de la classe POUTRE
        """

        # recuperer les infos du maillage sous format python
        self.MApyt = MAIL_PY()
        self.MApyt.FromAster(MAILLAGE)
        self.CARA_ELEM = CARA_ELEM
        # un dictionnaire stockant tous orientations definis dans AFF_CARA_ELEM
        self.dic_gma = self.orientation_cara_elem()

#------------------------------------------------------------------------
    def get_orie_poutre(self, dic_gr_cara_supp):
        """
            Calcul le vecteur d'orientation de section des poutres
            groupe par groupe.
        """

        for gr in list(self.dic_gma.keys()):
            vect = self.get_vecty_group_ma(gr)
            dic_orie = {'VX': vect[0], 'VY': vect[1], 'VZ': vect[2], }
            if gr in dic_gr_cara_supp:
                dic_gr_cara_supp[gr].update(dic_orie)
            else:
                dic_gr_cara_supp[gr] = dic_orie
        return dic_gr_cara_supp

#------------------------------------------------------------------------
    def orientation_cara_elem(self,):
        """
            Récupération des orientations des poutres
        """
        dic_gma = {}
        etapes = self.CARA_ELEM.etape.valeur

        if 'ORIENTATION' not in etapes:
            return dic_gma

        orientation = tolist(etapes['ORIENTATION'])

        for ll in orientation:
            cara = ll['CARA']
            if cara in ['ANGL_VRIL', 'ANGL_NAUT', 'VECT_Y']:
                if 'GROUP_MA' in ll:
                    group_ma = tolist(ll['GROUP_MA'])
                    a = ll['VALE']
                    for gr in group_ma:
                        if gr not in dic_gma:
                            dic_gma[gr] = {}
                        dic_gma[gr][cara] = a

        for gr in list(dic_gma.keys()):
            if 'VECT_Y' not in dic_gma[gr]:
                if 'ANGL_VRIL' not in dic_gma[gr]:
                    dic_gma[gr]['ANGL_VRIL'] = 0.0
                if 'ANGL_NAUT' in dic_gma[gr]:
                    UTMESS('F', 'PLEXUS_10')
        return dic_gma

#------------------------------------------------------------------------
    def get_vecty_group_ma(self, group_ma):
        """
            Renvoie le vecteur d'orientation des poutres pour un groupe
            de maille, en vérifiant que c'est bien le même pour toutes
            les mailles du groupe.
        """
        from Calc_epx.calc_epx_utils import angle2vecty
        # VECT_Y : les données sont déjà sous la bonne forme
        vect_y0 = None
        if 'VECT_Y' in self.dic_gma[group_ma]:
            vect_y = self.dic_gma[group_ma]['VECT_Y']
        else:
            mailles = self.MApyt.gma[group_ma.strip()]

            for imaille in range(len(mailles)):
                maille = mailles[imaille]
                alpha, beta = self.calcul_angles_naut(maille)
                angl = [alpha, beta, self.dic_gma[group_ma]['ANGL_VRIL']]

                vect_y = angle2vecty(angl)
                if imaille > 1:
                    if not vecteurs_egaux(vect_y0, vect_y):
                        UTMESS('F', 'PLEXUS_11', valk=group_ma)
                vect_y0 = vect_y

        return vect_y
#------------------------------------------------------------------------

    def get_coor_nodes_maille(self, maille):
        """
            Renvoie les coordonnées des deux noeuds de la maille 'maille'.
        """
        node1, node2 = self.MApyt.co[maille]
        coor1 = self.MApyt.cn[node1]
        coor2 = self.MApyt.cn[node2]
        return [coor1, coor2]

#------------------------------------------------------------------------
    def calcul_angles_naut(self, maille):
        """
            Calcul des deux angles nautiques définissant la direction de la
            maille 'maille'.
        """

        a, b = self.get_coor_nodes_maille(maille)

        gx = [b[0] - a[0], b[1] - a[1], b[2] - a[2]]

        if abs(gx[1]) < tst and abs(gx[0]) <= tst:
            alpha = 0.0
        else:
            alpha = math.atan2(gx[1], gx[0])

        p = numpy.sqrt(gx[0] * gx[0] + gx[1] * gx[1])
        if abs(gx[2]) < tst and abs(p) <= tst:
            beta = 0.0
        else:
            beta = -math.atan2(gx[2], p)

        [alpha, beta] = numpy.rad2deg([alpha, beta])

        return alpha, beta

#------------------------------------------------------------------------
#----------------------------- FIN class POUTRE -------------------------
#------------------------------------------------------------------------
