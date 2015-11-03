# coding=utf-8

# ======================================================================
# COPYRIGHT (C) 1991 - 2015  EDF R&D                  WWW.CODE-ASTER.ORG
# THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
# IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
# THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
# (AT YOUR OPTION) ANY LATER VERSION.
#
# THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
# WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
# GENERAL PUBLIC LICENSE FOR MORE DETAILS.
#
# YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
# ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
#    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
# ======================================================================

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


DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO',
    components=('PRES','PHI',))


NGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y',))


EGGEOP_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
    components=('X','Y','W',))


ESOURCR  = LocatedComponents(phys=PHY.SOUR_R, type='ELGA', location='RIGI',
    components=('VNOR',))


MVECTUR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=(DDL_MECA,))

MMATUUR  = ArrayOfComponents(phys=PHY.MDEP_R, locatedComponents=(DDL_MECA,DDL_MECA))


#------------------------------------------------------------
class MEFLSE2(Element):
    """Please document this element"""
    meshType = MT.SEG2
    elrefe =(
            ElrefeLoc(MT.SE2, gauss = ('RIGI=FPG2','FPG1=FPG1',), mater=('FPG1',),),
        )
    calculs = (

        OP.CHAR_MECA_ONDE(te=373,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PMATERC, LC.CMATERC),
                     (SP.PONDECR, LC.EONDEPR), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.CHAR_MECA_VNOR(te=255,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PMATERC, LC.CMATERC),
                     (SP.PSOURCR, ESOURCR), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.CHAR_MECA_VNOR_F(te=256,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PMATERC, LC.CMATERC),
                     (SP.PSOURCF, LC.ESOURCF), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.COOR_ELGA(te=478,
            para_in=((SP.PGEOMER, NGEOMER), ),
            para_out=((OP.COOR_ELGA.PCOORPG, EGGEOP_R), ),
        ),

        OP.IMPE_MECA(te=258,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PIMPEDR, LC.EIMPEDR),
                     (SP.PMATERC, LC.CMATERC), ),
            para_out=((SP.PMATUUR, MMATUUR), ),
        ),

        OP.ONDE_FLUI(te=372,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PMATERC, LC.CMATERC),
                     (SP.PONDECR, LC.EONDEPR), ),
            para_out=((SP.PMATUUR, MMATUUR), ),
        ),

        OP.TOU_INI_ELGA(te=99,
            para_out=((OP.TOU_INI_ELGA.PGEOM_R, EGGEOP_R), ),
        ),

        OP.TOU_INI_ELNO(te=99,
            para_out=((OP.TOU_INI_ELNO.PGEOM_R, NGEOMER), ),
        ),

    )


#------------------------------------------------------------
class MEFLSE3(MEFLSE2):
    """Please document this element"""
    meshType = MT.SEG3
    elrefe =(
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4','FPG1=FPG1',), mater=('FPG1',),),
        )
