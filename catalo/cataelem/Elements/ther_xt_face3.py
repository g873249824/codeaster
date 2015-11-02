
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
from cataelem.Tools.base_objects import Calcul, Element, AbstractElement
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.located_components as LC
import cataelem.Commons.parameters as SP
import cataelem.Commons.mesh_types as MT
from cataelem.Options.options import OP

#----------------
# Modes locaux :
#----------------


NGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y','Z',))


STANO_I  = LocatedComponents(phys=PHY.N120_I, type='ELNO',
    components=('X1',))


E6NEUTI  = LocatedComponents(phys=PHY.N512_I, type='ELEM',
    components=('X[6]',))


E33NEUTR = LocatedComponents(phys=PHY.N792_R, type='ELEM',
    components=('X[33]',))


DDL_THER = LocatedComponents(phys=PHY.TEMP_R, type='ELNO',
    components=('TEMP','E1',))



#------------------------------------------------------------
abstractElement = AbstractElement()
ele = abstractElement

ele.addCalcul(OP.INI_XFEM_ELNO, te=99,
    para_out=((OP.INI_XFEM_ELNO.PLSN, LC.N1NEUT_R), (OP.INI_XFEM_ELNO.PLST, LC.N1NEUT_R),
             (OP.INI_XFEM_ELNO.PSTANO, STANO_I), ),
)

ele.addCalcul(OP.TOPONO, te=120,
    para_in=((OP.TOPONO.PCNSETO, LC.E36NEUI), (OP.TOPONO.PHEAVTO, E6NEUTI),
             (SP.PLEVSET, LC.N1NEUT_R), (OP.TOPONO.PLONCHA, LC.E10NEUTI),
             ),
    para_out=((OP.TOPONO.PHEA_NO, LC.N5NEUTI), (OP.TOPONO.PHEA_SE, E6NEUTI),
             ),
)

ele.addCalcul(OP.TOPOSE, te=514,
    para_in=((SP.PGEOMER, NGEOMER), (SP.PLEVSET, LC.N1NEUT_R),
             ),
    para_out=((OP.TOPOSE.PCNSETO, LC.E36NEUI), (OP.TOPOSE.PHEAVTO, E6NEUTI),
             (OP.TOPOSE.PLONCHA, LC.E10NEUTI), (OP.TOPOSE.PPINTTO, LC.E12NEUTR),
             (OP.TOPOSE.PPMILTO, E33NEUTR), ),
)

ele.addCalcul(OP.TOU_INI_ELNO, te=99,
    para_out=((OP.TOU_INI_ELNO.PGEOM_R, NGEOMER), ),
)


#------------------------------------------------------------
THER_XT_FACE3 = Element(modele=abstractElement)
ele = THER_XT_FACE3
ele.meshType = MT.TRIA3
ele.elrefe=(
        ElrefeLoc(MT.TR3, gauss = ('RIGI=COT3','FPG3=FPG3',),),
    )


#------------------------------------------------------------
THER_XT_FACE4 = Element(modele=abstractElement)
ele = THER_XT_FACE4
ele.meshType = MT.QUAD4
ele.elrefe=(
        ElrefeLoc(MT.QU4, gauss = ('RIGI=FPG4',),),
        ElrefeLoc(MT.TR3, gauss = ('RIGI=COT3','FPG3=FPG3',),),
    )
