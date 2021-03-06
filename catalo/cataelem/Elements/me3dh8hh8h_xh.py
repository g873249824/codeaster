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

# CATALOGUES DES ELEMENTS X-FEM HEAVISIDE AVEC CONTACT GRANDS GLISSEMENTS


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
          'H1Z',)),
    ('EN3',('DX','DY','DZ','H1X','H1Y',
          'H1Z','K1','K2','K3','LAGS_C',
          'LAGS_F[2]',)),
    ('EN4',('DX','DY','DZ','H1X','H1Y',
          'H1Z','K1','K2','K3',)),
    ('EN5',('K1','K2','K3','LAGS_C','LAGS_F[2]',)),))


NGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y','Z',))


CCONCF   = LocatedComponents(phys=PHY.N120_I, type='ELEM',
    components=('X[90]',))


STANO_I  = LocatedComponents(phys=PHY.N120_I, type='ELEM',
    components=('X[40]',))


CCONPI   = LocatedComponents(phys=PHY.N120_R, type='ELEM',
    components=('X[120]',))


CCONAI   = LocatedComponents(phys=PHY.N480_R, type='ELEM',
    components=('X[200]',))

BASLO_R  = LocatedComponents(phys=PHY.N480_R, type='ELEM',
    components=('X[144]',))

LSN_R  = LocatedComponents(phys=PHY.NEUT_R, type='ELEM',
    components=('X[16]',))

MVECTUR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

MMATUUR  = ArrayOfComponents(phys=PHY.MDEP_R, locatedComponents=DDL_MECA)

MMATUNS  = ArrayOfComponents(phys=PHY.MDNS_R, locatedComponents=DDL_MECA)


#------------------------------------------------------------
class ME3DH8HH8H_XH(Element):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN2', (9,10,11,12,13,14,15,16,)),
            SetOfNodes('EN1', (1,2,3,4,5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )
    calculs = (

        OP.CHAR_MECA_CONT(te=367,
            para_in=((SP.PCAR_AI, CCONAI), (SP.PCAR_CF, CCONCF),
                     (SP.PCAR_PI, CCONPI), (SP.PCAR_PT, LC.CCONPT),
                     (SP.PDEPL_M, DDL_MECA), (SP.PDEPL_P, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (OP.CHAR_MECA_CONT.PHEA_NO, LC.N80NEUI),
                     (OP.CHAR_MECA_CONT.PSTANO, STANO_I),
                     (SP.PMATERC, LC.CMATERC), (OP.CHAR_MECA_CONT.PLSNGG, LSN_R),
                     (OP.CHAR_MECA_CONT.PBASLOC, BASLO_R),),
            para_out=((SP.PVECTCR, MVECTUR), (SP.PVECTFR, MVECTUR),),
        ),

        OP.RIGI_CONT(te=366,
            para_in=((SP.PCAR_AI, CCONAI), (SP.PCAR_CF, CCONCF),
                     (SP.PCAR_PI, CCONPI), (SP.PCAR_PT, LC.CCONPT),
                     (SP.PDEPL_M, DDL_MECA), (SP.PDEPL_P, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (OP.RIGI_CONT.PHEA_NO, LC.N80NEUI),
                     (OP.RIGI_CONT.PSTANO, STANO_I), (OP.RIGI_CONT.PLSNGG, LSN_R),
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
                     (OP.XCVBCA.PHEA_NO, LC.N80NEUI),
                     (OP.XCVBCA.PSTANO, STANO_I),
                     (SP.PMATERC, LC.CMATERC), (OP.XCVBCA.PLSNGG, LSN_R),
                     (OP.XCVBCA.PBASLOC, BASLO_R),),
            para_out=((SP.PINDCOO, LC.I3NEUT_I), ),
        ),

    )


#------------------------------------------------------------
class ME3DH8HH8C_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN4', (9,10,11,12,13,14,15,16,)),
            SetOfNodes('EN1', (1,2,3,4,5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH8CH8H_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN2', (9,10,11,12,13,14,15,16,)),
            SetOfNodes('EN3', (1,2,3,4,5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH8CH8C_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.HE8HE8
    nodes = (
            SetOfNodes('EN4', (9,10,11,12,13,14,15,16,)),
            SetOfNodes('EN3', (1,2,3,4,5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DH8T_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.HEXA8
    nodes = (
            SetOfNodes('EN5', (1,2,3,4,5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP6HP6H_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN2', (7,8,9,10,11,12,)),
            SetOfNodes('EN1', (1,2,3,4,5,6,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP6HP6C_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN4', (7,8,9,10,11,12,)),
            SetOfNodes('EN1', (1,2,3,4,5,6,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP6CP6H_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN2', (7,8,9,10,11,12,)),
            SetOfNodes('EN3', (1,2,3,4,5,6,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP6CP6C_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.PE6PE6
    nodes = (
            SetOfNodes('EN4', (7,8,9,10,11,12,)),
            SetOfNodes('EN3', (1,2,3,4,5,6,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DP6T_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.PENTA6
    nodes = (
            SetOfNodes('EN5', (1,2,3,4,5,6,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT4HT4H_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN2', (5,6,7,8,)),
            SetOfNodes('EN1', (1,2,3,4,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT4HT4C_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN4', (5,6,7,8,)),
            SetOfNodes('EN1', (1,2,3,4,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT4CT4H_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN2', (5,6,7,8,)),
            SetOfNodes('EN3', (1,2,3,4,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT4CT4C_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.TE4TE4
    nodes = (
            SetOfNodes('EN4', (5,6,7,8,)),
            SetOfNodes('EN3', (1,2,3,4,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DT4T_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.TETRA4
    nodes = (
            SetOfNodes('EN5', (1,2,3,4,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
# debut des modifs ajout des elements quadratiques
# on ne garde que H-H C:heav+ctip T:ctip (el du fond)

class ME3DHVHHVH_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.H20H20
    nodes = (
            SetOfNodes('EN2', (9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,)),
            SetOfNodes('EN1', (1,2,3,4,5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.H20, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DPQHPQH_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.P15P15
    nodes = (
            SetOfNodes('EN2', (7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,)),
            SetOfNodes('EN1', (1,2,3,4,5,6,)),
        )
    elrefe =(
            ElrefeLoc(MT.P15, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )


#------------------------------------------------------------
class ME3DTDHTDH_XH(ME3DH8HH8H_XH):
    """Please document this element"""
    meshType = MT.T10T10
    nodes = (
            SetOfNodes('EN2', (5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,)),
            SetOfNodes('EN1', (1,2,3,4,)),
        )
    elrefe =(
            ElrefeLoc(MT.T10, gauss = ('NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('NOEU=NOEU',),),
        )
