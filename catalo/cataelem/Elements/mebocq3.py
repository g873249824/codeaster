
# ======================================================================
# COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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


CCACOQU  = LocatedComponents(phys=PHY.CACOQU, type='ELEM',
    components=('EP','ALPHA','BETA','CTOR',))


DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO',
    components=('DX','DY','DZ','DRX','DRY',
          'DRZ',))


MFORCEF  = LocatedComponents(phys=PHY.FORC_F, type='ELEM',
    components=('FX','FY','FZ','MX','MY',
          'MZ',))


MFORCER  = LocatedComponents(phys=PHY.FORC_R, type='ELEM',
    components=('FX','FY','FZ','MX','MY',
          'MZ',))


CGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELEM',
    components=('X','Y','Z',))


MGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y','Z',))


EGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
    components=('X','Y','Z',))


ECASECT  = LocatedComponents(phys=PHY.NEUT_R, type='ELEM',
    components=('X[10]',))


MVECTUR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=(DDL_MECA,))


#------------------------------------------------------------
class MEBOCQ3(Element):
    """Please document this element"""
    meshType = MT.SEG3
    elrefe =(
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4',),),
        )
    calculs = (

        OP.CARA_SECT_POUT3(te=570,
            para_in=((SP.PCACOQU, CCACOQU), (OP.CARA_SECT_POUT3.PCAORIE, CGEOMER),
                     (SP.PGEOMER, MGEOMER), ),
            para_out=((SP.PCASECT, ECASECT), ),
        ),

        OP.CARA_SECT_POUT4(te=570,
            para_in=((SP.PCACOQU, CCACOQU), (OP.CARA_SECT_POUT4.PCAORIE, CGEOMER),
                     (SP.PGEOMER, MGEOMER), (SP.PORIGIN, CGEOMER),
                     ),
            para_out=((SP.PVECTU1, MVECTUR), (SP.PVECTU2, MVECTUR),
                     ),
        ),

        OP.CARA_SECT_POUT5(te=570,
            para_in=((SP.PCACOQU, CCACOQU), (OP.CARA_SECT_POUT5.PCAORIE, CGEOMER),
                     (SP.PGEOMER, MGEOMER), (SP.PNUMMOD, LC.CNUMMOD),
                     (SP.PORIGFI, CGEOMER), (SP.PORIGIN, CGEOMER),
                     ),
            para_out=((SP.PVECTU1, MVECTUR), (SP.PVECTU2, MVECTUR),
                     (SP.PVECTU3, MVECTUR), ),
        ),

        OP.CHAR_MECA_FF1D3D(te=418,
            para_in=((SP.PFF1D3D, MFORCEF), (SP.PGEOMER, MGEOMER),
                     (SP.PTEMPSR, LC.MTEMPSR), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.CHAR_MECA_FR1D3D(te=418,
            para_in=((SP.PFR1D3D, MFORCER), (SP.PGEOMER, MGEOMER),
                     ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out=((OP.TOU_INI_ELEM.PGEOM_R, CGEOMER), ),
        ),

        OP.TOU_INI_ELGA(te=99,
            para_out=((OP.TOU_INI_ELGA.PGEOM_R, EGEOMER), ),
        ),

        OP.TOU_INI_ELNO(te=99,
            para_out=((OP.TOU_INI_ELNO.PGEOM_R, MGEOMER), ),
        ),

    )
