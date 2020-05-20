# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

# person_in_charge: mickael.abbas at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PCOMPOR  = InputParameter(phys=PHY.COMPOR,
comment="""  Informations for non-linear comportment """)

PCAORIE  = InputParameter(phys=PHY.CAORIE, container='CARA!.CARORIEN',
comment="""  PCAORIE : ORIENTATION LOCALE D'UN ELEMENT DE POUTRE OU DE TUYAU  """)


PCACO3D  = InputParameter(phys=PHY.CACO3D)


PCONTMR  = InputParameter(phys=PHY.SIEF_R)


PVARIMR  = InputParameter(phys=PHY.VARI_R)


PVARCPR  = InputParameter(phys=PHY.VARI_R,
comment=""" PVARCPR : VARIABLES DE COMMANDES  POUR T+ """)


PNBSP_I  = InputParameter(phys=PHY.NBSP_I, container='CARA!.CANBSP',
comment="""  PNBSP_I :  NOMBRE DE SOUS_POINTS  """)


PPINTTO  = InputParameter(phys=PHY.N132_R)


PCNSETO  = InputParameter(phys=PHY.N1280I, container='MODL!.TOPOSE.CNS',
comment="""  XFEM - CONNECTIVITE DES SOUS-ELEMENTS  """)


PHEAVTO  = InputParameter(phys=PHY.N512_I)


PLONCHA  = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
comment="""  XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS  """)


PBASLOR  = InputParameter(phys=PHY.NEUT_R)


PLSN     = InputParameter(phys=PHY.NEUT_R)


PLST     = InputParameter(phys=PHY.NEUT_R)


PSTANO   = InputParameter(phys=PHY.N120_I)


PPMILTO  = InputParameter(phys=PHY.N792_R)


PHEA_NO  = InputParameter(phys=PHY.N120_I)


PCONTPR  = OutputParameter(phys=PHY.SIEF_R, type='ELGA')


PVARIPR  = OutputParameter(phys=PHY.VARI_R, type='ELGA')

# For HHO
PCELLMR  = InputParameter(phys=PHY.CELL_R,
comment=""" HHO - degres de liberte de la cellule""")

PCELLIR  = InputParameter(phys=PHY.CELL_R,
comment=""" HHO - degres de liberte de la cellule""")

PCSMTIR  = OutputParameter(phys=PHY.N3240R, type='ELEM',
comment=""" HHO - matrice cellule pour condensation statique""")

PCSRTIR  = OutputParameter(phys=PHY.CELL_R, type='ELEM',
comment=""" HHO - 2nd membre cellule pour condensation statique""")

PCHHOGT  = InputParameter(phys=PHY.N1920R,
comment=""" HHO - matrice du gradient local""")

PCHHOST  = InputParameter(phys=PHY.N2448R,
comment=""" HHO - matrice de la stabilisation locale""")


RAPH_MECA = Option(
    para_in=(
        SP.PACCKM1,
        SP.PACCPLU,
           PBASLOR,
        SP.PCAARPO,
        SP.PCACABL,
           PCACO3D,
        SP.PCACOQU,
        SP.PCADISK,
        SP.PCAGEPO,
        SP.PCAGNBA,
        SP.PCAGNPO,
        SP.PCAMASS,
           PCAORIE,
        SP.PCARCRI,
        SP.PCINFDI,
           PCNSETO,
           PCOMPOR,
        SP.PMULCOM,
           PCONTMR,
        SP.PDDEPLA,
        SP.PDEPENT,
        SP.PDEPKM1,
        SP.PDEPLMR,
        SP.PDEPLPR,
        SP.PFIBRES,
        SP.PGEOMER,
           PHEAVTO,
           PHEA_NO,
        SP.PINSTMR,
        SP.PINSTPR,
        SP.PITERAT,
           PLONCHA,
           PLSN,
           PLST,
        SP.PMATERC,
           PNBSP_I,
           PPINTTO,
           PPMILTO,
        SP.PROMK,
        SP.PROMKM1,
        SP.PSTADYN,
           PSTANO,
        SP.PSTRXMP,
        SP.PSTRXMR,
        SP.PVARCMR,
           PVARCPR,
        SP.PVARCRR,
        SP.PVARIMP,
           PVARIMR,
        SP.PVITENT,
        SP.PVITKM1,
        SP.PVITPLU,
           PCELLMR,
           PCELLIR,
           PCHHOGT,
           PCHHOST,
    ),
    para_out=(
        SP.PCODRET,
           PCONTPR,
        SP.PSTRXPR,
           PVARIPR,
        SP.PVECTUR,
           PCSMTIR,
           PCSRTIR
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
      CondCalcul('-', ((AT.FLUIDE,'OUI'),(AT.ABSO,'OUI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.FSI ,'OUI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.TYPMOD2, 'HHO'),)),
    ),
)
