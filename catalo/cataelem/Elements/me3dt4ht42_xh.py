# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

# CATALOGUES DES ELEMENTS TARDIF 3D X-FEM GRAND GLISSEMENT (MULTI HEAVISIDE)


from cataelem.Tools.base_objects import LocatedComponents, ArrayOfComponents, SetOfNodes, ElrefeLoc
from cataelem.Tools.base_objects import Calcul, Element
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.located_components as LC
import cataelem.Commons.parameters as SP
import cataelem.Commons.mesh_types as MT
from cataelem.Options.options import OP

#----------------
# Modes locaux :
#----------------


DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO', diff=True,
    components=(
    ('EN1',('DX','DY','DZ','H1X','H1Y',
          'H1Z','LAGS_C','LAGS_F[2]',)),
    ('EN2',('DX','DY','DZ','H1X','H1Y',
          'H1Z','H2X','H2Y','H2Z','LAGS_C',
          'LAGS_F[2]','LAG2_C','LAG2_F[2]',)),
    ('EN3',('DX','DY','DZ','H1X','H1Y',
          'H1Z','H2X','H2Y','H2Z','H3X',
          'H3Y','H3Z','LAGS_C','LAGS_F[2]','LAG2_C',
          'LAG2_F[2]','LAG3_C','LAG3_F[2]',)),
    ('EN4',('DX','DY','DZ','H1X','H1Y',
          'H1Z','H2X','H2Y','H2Z','H3X',
          'H3Y','H3Z','H4X','H4Y','H4Z',
          'LAGS_C','LAGS_F[2]','LAG2_C','LAG2_F[2]','LAG3_C',
          'LAG3_F[2]','LAG4_C','LAG4_F[2]',)),
    ('EN5',('DX','DY','DZ','H1X','H1Y',
          'H1Z',)),
    ('EN6',('DX','DY','DZ','H1X','H1Y',
          'H1Z','H2X','H2Y','H2Z',)),
    ('EN7',('DX','DY','DZ','H1X','H1Y',
          'H1Z','H2X','H2Y','H2Z','H3X',
          'H3Y','H3Z',)),
    ('EN8',('DX','DY','DZ','H1X','H1Y',
          'H1Z','H2X','H2Y','H2Z','H3X',
          'H3Y','H3Z','H4X','H4Y','H4Z',)),))


NGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y','Z',))


CCONCF   = LocatedComponents(phys=PHY.N120_I, type='ELEM',
    components=('X[90]',))


STANO_I  = LocatedComponents(phys=PHY.N120_I, type='ELEM',
    components=('X[64]',))


CCONPI   = LocatedComponents(phys=PHY.N120_R, type='ELEM',
    components=('X[120]',))


CCONHE   = LocatedComponents(phys=PHY.N240_I, type='ELEM',
    components=('X[24]',))


CCONAI   = LocatedComponents(phys=PHY.N480_R, type='ELEM',
    components=('X[200]',))

BASLO_R  = LocatedComponents(phys=PHY.N480_R, type='ELEM',
    components=('X[144]',))

LSN_R  = LocatedComponents(phys=PHY.NEUT_R, type='ELEM',
    components=('X[16]',))

PLALA_I  = LocatedComponents(phys=PHY.NEUT_I, type='ELEM',
    components=('X[8]',))


MVECTUR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

MMATUUR  = ArrayOfComponents(phys=PHY.MDEP_R, locatedComponents=DDL_MECA)

MMATUNS  = ArrayOfComponents(phys=PHY.MDNS_R, locatedComponents=DDL_MECA)


#------------------------------------------------------------
class ME3DT4HT42_XH(Element):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN1', (1,2,3,4,)),
            SetOfNodes('EN6', (5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )
    calculs = (

        OP.CHAR_MECA_CONT(te=367,
            para_in=((SP.PCAR_AI, CCONAI), (SP.PCAR_CF, CCONCF),
                     (SP.PCAR_PI, CCONPI), (SP.PCAR_PT, LC.CCONPT),
                     (SP.PDEPL_M, DDL_MECA), (SP.PDEPL_P, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (SP.PHEAVNO, PLALA_I),
                     (OP.CHAR_MECA_CONT.PHEA_FA, CCONHE), (OP.CHAR_MECA_CONT.PHEA_NO, LC.N80NEUI),
                     (OP.CHAR_MECA_CONT.PSTANO, STANO_I),
                     (SP.PMATERC, LC.CMATERC), (OP.CHAR_MECA_CONT.PLSN, LSN_R),
                     (OP.CHAR_MECA_CONT.PBASLOC, BASLO_R),),
            para_out=((SP.PVECTCR, MVECTUR), (SP.PVECTFR, MVECTUR),),
        ),

        OP.RIGI_CONT(te=366,
            para_in=((SP.PCAR_AI, CCONAI), (SP.PCAR_CF, CCONCF),
                     (SP.PCAR_PI, CCONPI), (SP.PCAR_PT, LC.CCONPT),
                     (SP.PDEPL_M, DDL_MECA), (SP.PDEPL_P, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (SP.PHEAVNO, PLALA_I),
                     (OP.RIGI_CONT.PHEA_FA, CCONHE), (OP.RIGI_CONT.PHEA_NO, LC.N80NEUI),
                     (OP.RIGI_CONT.PSTANO, STANO_I), (OP.RIGI_CONT.PLSN, LSN_R),
                     (SP.PMATERC, LC.CMATERC), (OP.RIGI_CONT.PBASLOC, BASLO_R),
                     ),
            para_out=((SP.PMATUNS, MMATUNS), (SP.PMATUUR, MMATUUR),
                     ),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out=((OP.TOU_INI_ELEM.PGEOM_R, LC.CGEOM3D), ),
        ),


        OP.TOU_INI_ELNO(te=99,
            para_out=((OP.TOU_INI_ELNO.PGEOM_R, NGEOMER), ),
        ),

        OP.XCVBCA(te=363,
            para_in=((SP.PCAR_AI, CCONAI), (SP.PCAR_PT, LC.CCONPT),
                     (SP.PDEPL_P, DDL_MECA), (SP.PGEOMER, NGEOMER),
                     (SP.PHEAVNO, PLALA_I), (OP.XCVBCA.PHEA_FA, CCONHE),
                     (OP.XCVBCA.PHEA_NO, LC.N80NEUI), 
                     (OP.XCVBCA.PSTANO, STANO_I),),
            para_out=((SP.PINDCOO, LC.I3NEUT_I), ),
        ),

    )


#------------------------------------------------------------
class ME3DT4HT43_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN1', (1,2,3,4,)),
            SetOfNodes('EN7', (5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT4HT44_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN1', (1,2,3,4,)),
            SetOfNodes('EN8', (5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT42T4H_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN2', (1,2,3,4,)),
            SetOfNodes('EN5', (5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT42T42_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN2', (1,2,3,4,)),
            SetOfNodes('EN6', (5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT42T43_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN2', (1,2,3,4,)),
            SetOfNodes('EN7', (5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT42T44_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN2', (1,2,3,4,)),
            SetOfNodes('EN8', (5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT43T4H_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN3', (1,2,3,4,)),
            SetOfNodes('EN5', (5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT43T42_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN3', (1,2,3,4,)),
            SetOfNodes('EN6', (5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT43T43_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN3', (1,2,3,4,)),
            SetOfNodes('EN7', (5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT43T44_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN3', (1,2,3,4,)),
            SetOfNodes('EN8', (5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT44T4H_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN4', (1,2,3,4,)),
            SetOfNodes('EN5', (5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT44T42_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN4', (1,2,3,4,)),
            SetOfNodes('EN6', (5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT44T43_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN4', (1,2,3,4,)),
            SetOfNodes('EN7', (5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT44T44_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN4', (1,2,3,4,)),
            SetOfNodes('EN8', (5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP6HP62_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN1', (1,2,3,4,5,6,)),
            SetOfNodes('EN6', (7,8,9,10,11,12,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP6HP63_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN1', (1,2,3,4,5,6,)),
            SetOfNodes('EN7', (7,8,9,10,11,12,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP6HP64_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN1', (1,2,3,4,5,6,)),
            SetOfNodes('EN8', (7,8,9,10,11,12,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP62P6H_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN2', (1,2,3,4,5,6,)),
            SetOfNodes('EN5', (7,8,9,10,11,12,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP62P62_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN2', (1,2,3,4,5,6,)),
            SetOfNodes('EN6', (7,8,9,10,11,12,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP62P63_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN2', (1,2,3,4,5,6,)),
            SetOfNodes('EN7', (7,8,9,10,11,12,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP62P64_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN2', (1,2,3,4,5,6,)),
            SetOfNodes('EN8', (7,8,9,10,11,12,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP63P6H_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN3', (1,2,3,4,5,6,)),
            SetOfNodes('EN5', (7,8,9,10,11,12,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP63P62_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN3', (1,2,3,4,5,6,)),
            SetOfNodes('EN6', (7,8,9,10,11,12,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP63P63_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN3', (1,2,3,4,5,6,)),
            SetOfNodes('EN7', (7,8,9,10,11,12,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP63P64_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN3', (1,2,3,4,5,6,)),
            SetOfNodes('EN8', (7,8,9,10,11,12,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP64P6H_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN4', (1,2,3,4,5,6,)),
            SetOfNodes('EN5', (7,8,9,10,11,12,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP64P62_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN4', (1,2,3,4,5,6,)),
            SetOfNodes('EN6', (7,8,9,10,11,12,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP64P63_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN4', (1,2,3,4,5,6,)),
            SetOfNodes('EN7', (7,8,9,10,11,12,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP64P64_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN4', (1,2,3,4,5,6,)),
            SetOfNodes('EN8', (7,8,9,10,11,12,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH8HH82_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN1', (1,2,3,4,5,6,7,8,)),
            SetOfNodes('EN6', (9,10,11,12,13,14,15,16,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH8HH83_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN1', (1,2,3,4,5,6,7,8,)),
            SetOfNodes('EN7', (9,10,11,12,13,14,15,16,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH8HH84_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN1', (1,2,3,4,5,6,7,8,)),
            SetOfNodes('EN8', (9,10,11,12,13,14,15,16,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH82H8H_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN2', (1,2,3,4,5,6,7,8,)),
            SetOfNodes('EN5', (9,10,11,12,13,14,15,16,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH82H82_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN2', (1,2,3,4,5,6,7,8,)),
            SetOfNodes('EN6', (9,10,11,12,13,14,15,16,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH82H83_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN2', (1,2,3,4,5,6,7,8,)),
            SetOfNodes('EN7', (9,10,11,12,13,14,15,16,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH82H84_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN2', (1,2,3,4,5,6,7,8,)),
            SetOfNodes('EN8', (9,10,11,12,13,14,15,16,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH83H8H_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN3', (1,2,3,4,5,6,7,8,)),
            SetOfNodes('EN5', (9,10,11,12,13,14,15,16,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH83H82_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN3', (1,2,3,4,5,6,7,8,)),
            SetOfNodes('EN6', (9,10,11,12,13,14,15,16,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH83H83_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN3', (1,2,3,4,5,6,7,8,)),
            SetOfNodes('EN7', (9,10,11,12,13,14,15,16,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH83H84_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN3', (1,2,3,4,5,6,7,8,)),
            SetOfNodes('EN8', (9,10,11,12,13,14,15,16,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH84H8H_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN4', (1,2,3,4,5,6,7,8,)),
            SetOfNodes('EN5', (9,10,11,12,13,14,15,16,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH84H82_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN4', (1,2,3,4,5,6,7,8,)),
            SetOfNodes('EN6', (9,10,11,12,13,14,15,16,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH84H83_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN4', (1,2,3,4,5,6,7,8,)),
            SetOfNodes('EN7', (9,10,11,12,13,14,15,16,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH84H84_XH(ME3DT4HT42_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN4', (1,2,3,4,5,6,7,8,)),
            SetOfNodes('EN8', (9,10,11,12,13,14,15,16,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )
