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

# Ce catalogue correspondant aux elements fluides lineaires massifs en axisymetrique
# pour le couplage fluide-structure n'ont que des DDL de :
#  pression PRES et potentiel de deplacement PHI.
# La contrainte n'existe pas, ni la deformation.
# Les options FULL_MECA et RAPH_MECA sont disponibles mais correspondent
# a un probleme lineaire : le CODRET sera toujours OK sur ces elements.
# On le garde neanmoins pour des raisons de compatibilite.


from cataelem.Tools.base_objects import LocatedComponents, ArrayOfComponents, SetOfNodes, ElrefeLoc
from cataelem.Tools.base_objects import Calcul, Element
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.located_components as LC
import cataelem.Commons.parameters as SP
import cataelem.Commons.mesh_types as MT
from cataelem.Options.options import OP

#----------------------------------------------------------------------------------------------
# Located components
#----------------------------------------------------------------------------------------------

DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO',
                             components=('PRES','PHI',))

NDEPLAC  = LocatedComponents(phys=PHY.DEPL_C, type='ELNO',
                             components=('PRES','PHI',))

MMATUUC  = ArrayOfComponents(phys=PHY.MDEP_C, locatedComponents=NDEPLAC)

MMATUUR  = ArrayOfComponents(phys=PHY.MDEP_R, locatedComponents=DDL_MECA)

MVECTUR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

#----------------------------------------------------------------------------------------------
class MEAXFLQ4(Element):
    """Element for fluid (U,P,PHI) - Axisymmetric - On QU4"""
    meshType = MT.QUAD4
    elrefe =(
            ElrefeLoc(MT.QU4, gauss = ('RIGI=FPG4','FPG1=FPG1',), mater=('FPG1',),),
    )
    calculs = (
        OP.COOR_ELGA(te=479,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D),),
            para_out = ((OP.COOR_ELGA.PCOORPG, LC.EGGAU2D),),
        ),

        OP.MASS_INER(te=157,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D), (SP.PMATERC, LC.CMATERC),),
            para_out = ((SP.PMASSINE, LC.EMASSINE),),
        ),

        OP.MASS_MECA(te=254,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D), (SP.PMATERC, LC.CMATERC),),
            para_out = ((SP.PMATUUR, MMATUUR),),
        ),

        OP.PRME_ELNO(te=420,
            para_in  = ((SP.PDEPLAC, NDEPLAC),),
            para_out = ((SP.PPRME_R, LC.EPRMENO),),
        ),

        OP.RIGI_MECA(te=253,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D), (SP.PMATERC, LC.CMATERC),),
            para_out = ((SP.PMATUUR, MMATUUR),),
        ),

        OP.RIGI_MECA_HYST(te=253,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D), (SP.PMATERC, LC.CMATERC),),
            para_out = ((SP.PMATUUC, MMATUUC),),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out = ((SP.PGEOM_R, LC.CGEOM2D),),
        ),

        OP.TOU_INI_ELGA(te=99,
            para_out = ((SP.PGEOM_R, LC.EGGEO2D),),
        ),

        OP.TOU_INI_ELNO(te=99,
            para_out = ((SP.PGEOM_R, LC.EGEOM2D),),
        ),

        OP.VERI_JACOBIEN(te=328,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D),),
            para_out = ((SP.PCODRET, LC.ECODRET),),
        ),
    )

#----------------------------------------------------------------------------------------------
class MEAXFLQ8(MEAXFLQ4):
    """Element for fluid (U,P,PHI) - Axisymmetric - On QU8"""
    meshType = MT.QUAD8
    elrefe =(
            ElrefeLoc(MT.QU8, gauss = ('RIGI=FPG9','FPG1=FPG1',), mater=('FPG1',),),
    )

#----------------------------------------------------------------------------------------------
class MEAXFLQ9(MEAXFLQ4):
    """Element for fluid (U,P,PHI) - Axisymmetric - On QU9"""
    meshType = MT.QUAD9
    elrefe =(
            ElrefeLoc(MT.QU9, gauss = ('RIGI=FPG9','FPG1=FPG1',), mater=('FPG1',),),
    )

#----------------------------------------------------------------------------------------------
class MEAXFLT3(MEAXFLQ4):
    """Element for fluid (U,P,PHI) - Axisymmetric - On TR3"""
    meshType = MT.TRIA3
    elrefe =(
            ElrefeLoc(MT.TR3, gauss = ('RIGI=FPG3','FPG1=FPG1',), mater=('FPG1',),),
    )

#----------------------------------------------------------------------------------------------
class MEAXFLT6(MEAXFLQ4):
    """Element for fluid (U,P,PHI) - Axisymmetric - On TR6"""
    meshType = MT.TRIA6
    elrefe =(
            ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG6','FPG1=FPG1',), mater=('FPG1',),),
    )

#----------------------------------------------------------------------------------------------
class MEAXFLS2(Element):
    """Element for fluid (U,P,PHI) - Axisymmetric/Boundary - On SE2"""
    meshType = MT.SEG2
    elrefe =(
            ElrefeLoc(MT.SE2, gauss = ('RIGI=FPG2','FPG1=FPG1',), mater=('FPG1',),),
    )
    calculs = (
        OP.CHAR_MECA_ONDE(te=373,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D), (SP.PMATERC, LC.CMATERC),
                        (SP.PONDECR, LC.EONDEPR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_PRES_F(te=99,
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),
        
        OP.CHAR_MECA_PRES_R(te=99,
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_VNOR(te=255,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D), (SP.PMATERC, LC.CMATERC),
                        (SP.PVITENR, LC.EVITENR),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.CHAR_MECA_VNOR_F(te=255,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D), (SP.PMATERC, LC.CMATERC),
                        (SP.PVITENF, LC.EVITENF),),
            para_out = ((SP.PVECTUR, MVECTUR),),
        ),

        OP.COOR_ELGA(te=478,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D),),
            para_out = ((OP.COOR_ELGA.PCOORPG, LC.EGGAU2D),),
        ),

        OP.IMPE_MECA(te=258,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D), (SP.PIMPEDR, LC.EIMPEDR),
                        (SP.PMATERC, LC.CMATERC),),
            para_out = ((SP.PMATUUR, MMATUUR),),
        ),

        OP.ONDE_FLUI(te=372,
            para_in  = ((SP.PGEOMER, LC.EGEOM2D), (SP.PMATERC, LC.CMATERC),
                        (SP.PONDECR, LC.EONDEPR),),
            para_out = ((SP.PMATUUR, MMATUUR),),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out = ((SP.PGEOM_R, LC.CGEOM2D),),
        ),

        OP.TOU_INI_ELGA(te=99,
            para_out = ((SP.PGEOM_R, LC.EGGEO2D),),
        ),

        OP.TOU_INI_ELNO(te=99,
            para_out = ((SP.PGEOM_R, LC.EGEOM2D),),
        ),
    )

#----------------------------------------------------------------------------------------------
class MEAXFLS3(MEAXFLS2):
    """Element for fluid (U,P,PHI) - Axisymmetric/Boundary - On SE3"""
    meshType = MT.SEG3
    elrefe =(
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4','FPG1=FPG1',), mater=('FPG1',),),
    )
