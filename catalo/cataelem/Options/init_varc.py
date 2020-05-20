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

from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PVARCPR  = OutputParameter(phys=PHY.VARI_R, type='ELGA',
comment="""  PVARCPR : VARIABLES DE COMMANDE POUR LE MATERIAU """)

PVARCNO  = OutputParameter(phys=PHY.VARI_R, type='ELNO',
comment="""  PVARCNO : VARIABLES DE COMMANDE POUR LE MATERIAU """)

INIT_VARC = Option(
    para_in=(
    ),
    para_out=(
           PVARCPR,
           PVARCNO,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
      CondCalcul('+', ((AT.PHENO,'TH'),(AT.BORD,'0'),)),
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD_ISO,'OUI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.FLUIDE,'OUI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.ABSO  ,'OUI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.TYPMOD2, 'HHO'),)),
    ),
    comment=""" OPTION NE CALCULANT RIEN.
   ELLE SERT A ALLOUER LES CHAMPS DE VARIABLES DE COMMANDE POUR LE MATERIAU.

   ATTENTION :
      UN ELEMENT QUI CALCULE INIT_VARC DOIT AUSSI CALCULER L'OPTION NSPG_NBVA.
""",
)
