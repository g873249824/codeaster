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

# CATALOGUES DES ELEMENTS DE BORD 2D HM-XFEM MULTI HEAVISIDE


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
                             ('EN1', ('DX', 'DY', 'PRE1', 'H1X', 'H1Y',
                                      'H1PRE1',)),
                             ('EN2', ('DX', 'DY', 'H1X', 'H1Y',)),
                                 ('EN3', ('DX', 'DY', 'PRE1', 'H1X', 'H1Y',
                                          'H1PRE1', 'H2X', 'H2Y', 'H2PRE1',)),
                                 ('EN4', ('DX', 'DY', 'H1X', 'H1Y', 'H2X',
                                          'H2Y',)),
                                 ('EN5', ('DX', 'DY', 'PRE1', 'H1X', 'H1Y',
                                          'H1PRE1', 'H2X', 'H2Y', 'H2PRE1', 'H3X',
                                          'H3Y', 'H3PRE1',)),
                                 ('EN6', ('DX', 'DY', 'H1X', 'H1Y', 'H2X',
                                          'H2Y', 'H3X', 'H3Y',)),))


EFLHN = LocatedComponents(phys=PHY.FLHN_R, type='ELGA', location='RIGI',
                          components=('FH11',))


CFLUXF = LocatedComponents(phys=PHY.FTHM_F, type='ELEM',
                           components=('PFLU1',))


EFLUXE = LocatedComponents(phys=PHY.FTHM_R, type='ELNO',
                           components=('PFLU1',))


NGEOMER = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
                            components=('X', 'Y',))


EGEOMER = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
                            components=('X', 'Y',))


EGGEOP_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='RIGI',
                             components=('X', 'Y', 'W',))


CTEMPSR = LocatedComponents(phys=PHY.INST_R, type='ELEM',
                            components=('INST', 'DELTAT', 'THETA',))


STANO_I = LocatedComponents(phys=PHY.N120_I, type='ELNO',
                            components=('X1',))


E15NEUI = LocatedComponents(phys=PHY.N1280I, type='ELEM',
                            components=('X[15]',))


E8NEUTR = LocatedComponents(phys=PHY.N132_R, type='ELEM',
                            components=('X[8]',))


E5NEUI = LocatedComponents(phys=PHY.N512_I, type='ELEM',
                           components=('X[5]',))


E10NEUTR = LocatedComponents(phys=PHY.N792_R, type='ELEM',
                             components=('X[10]',))


CPRESSF = LocatedComponents(phys=PHY.PRES_F, type='ELEM',
                            components=('PRES', 'CISA',))


EPRESNO = LocatedComponents(phys=PHY.PRES_R, type='ELNO',
                            components=('PRES', 'CISA',))


CPRES_R = LocatedComponents(phys=PHY.PRES_R, type='ELEM',
                            components=('PRES', 'CISA',))


NSIEF_R = LocatedComponents(phys=PHY.SIEF_R, type='ELNO', diff=True,
                            components=(
                            ('EN1', ('FH11X', 'FH11Y',)),
                            ('EN3', ('FH11X', 'FH11Y',)),
                                ('EN5', ('FH11X', 'FH11Y',)),
                                ('EN2', ()),
                                ('EN4', ()),
                                ('EN6', ()),))


MVECTUR = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)


#------------------------------------------------------------
class HM_DPSE3_XH1(Element):

    """Please document this element"""
    meshType = MT.SEG3
    nodes = (
        SetOfNodes('EN2', (3,)),
        SetOfNodes('EN1', (1, 2,)),
    )
    elrefe = (
        ElrefeLoc(MT.SE3, gauss=('RIGI=FPG4',),),
        ElrefeLoc(MT.SE2, gauss=('RIGI=FPG2',),),
    )
    calculs = (

        OP.CHAR_MECA_FLUX_F(te=579,
                            para_in=(
                            (OP.CHAR_MECA_FLUX_F.PCNSETO, E15NEUI), (
                            OP.CHAR_MECA_FLUX_F.PFISNO, LC.FISNO_I),
                            (SP.PFLUXF, CFLUXF), (SP.PGEOMER, NGEOMER),
                            (OP.CHAR_MECA_FLUX_F.PHEAVTO, E5NEUI), (
                            OP.CHAR_MECA_FLUX_F.PHEA_NO, LC.N5NEUTI),
                            (OP.CHAR_MECA_FLUX_F.PHEA_SE, E5NEUI), (
                            OP.CHAR_MECA_FLUX_F.PLONCHA, LC.E10NEUTI),
                            (OP.CHAR_MECA_FLUX_F.PLSN, LC.N1NEUT_R), (
                            OP.CHAR_MECA_FLUX_F.PPINTTO, E8NEUTR),
                            (OP.CHAR_MECA_FLUX_F.PPMILTO, E10NEUTR), (
                            OP.CHAR_MECA_FLUX_F.PSTANO, STANO_I),
                            (SP.PTEMPSR, CTEMPSR), ),
                            para_out=((SP.PVECTUR, MVECTUR), ),
                            ),

        OP.CHAR_MECA_FLUX_R(te=579,
                            para_in=(
                            (OP.CHAR_MECA_FLUX_R.PCNSETO, E15NEUI), (
                            OP.CHAR_MECA_FLUX_R.PFISNO, LC.FISNO_I),
                            (SP.PFLUXR, EFLUXE), (SP.PGEOMER, NGEOMER),
                            (OP.CHAR_MECA_FLUX_R.PHEAVTO, E5NEUI), (
                            OP.CHAR_MECA_FLUX_R.PHEA_NO, LC.N5NEUTI),
                            (OP.CHAR_MECA_FLUX_R.PHEA_SE, E5NEUI), (
                            OP.CHAR_MECA_FLUX_R.PLONCHA, LC.E10NEUTI),
                            (OP.CHAR_MECA_FLUX_R.PLSN, LC.N1NEUT_R), (
                            OP.CHAR_MECA_FLUX_R.PPINTTO, E8NEUTR),
                            (OP.CHAR_MECA_FLUX_R.PPMILTO, E10NEUTR), (
                            OP.CHAR_MECA_FLUX_R.PSTANO, STANO_I),
                            (SP.PTEMPSR, CTEMPSR), ),
                            para_out=((SP.PVECTUR, MVECTUR), ),
                            ),

        OP.CHAR_MECA_PRES_F(te=36,
                            para_in=(
                            (OP.CHAR_MECA_PRES_F.PCNSETO, E15NEUI), (
                            OP.CHAR_MECA_PRES_F.PFISNO, LC.FISNO_I),
                            (SP.PGEOMER, NGEOMER), (
                            OP.CHAR_MECA_PRES_F.PHEAVTO, E5NEUI),
                            (OP.CHAR_MECA_PRES_F.PHEA_NO, LC.N5NEUTI), (
                            OP.CHAR_MECA_PRES_F.PHEA_SE, E5NEUI),
                            (OP.CHAR_MECA_PRES_F.PLONCHA, LC.E10NEUTI), (
                            OP.CHAR_MECA_PRES_F.PLSN, LC.N1NEUT_R),
                            (OP.CHAR_MECA_PRES_F.PLST, LC.N1NEUT_R), (
                            OP.CHAR_MECA_PRES_F.PPINTTO, E8NEUTR),
                            (OP.CHAR_MECA_PRES_F.PPMILTO, E10NEUTR), (
                            SP.PPRESSF, CPRESSF),
                            (OP.CHAR_MECA_PRES_F.PSTANO, STANO_I), (
                            SP.PTEMPSR, CTEMPSR),
                            ),
                            para_out=((SP.PVECTUR, MVECTUR), ),
                            ),

        OP.CHAR_MECA_PRES_R(te=36,
                            para_in=(
                            (OP.CHAR_MECA_PRES_R.PCNSETO, E15NEUI), (
                            OP.CHAR_MECA_PRES_R.PFISNO, LC.FISNO_I),
                            (SP.PGEOMER, NGEOMER), (
                            OP.CHAR_MECA_PRES_R.PHEAVTO, E5NEUI),
                            (OP.CHAR_MECA_PRES_R.PHEA_NO, LC.N5NEUTI), (
                            OP.CHAR_MECA_PRES_R.PHEA_SE, E5NEUI),
                            (OP.CHAR_MECA_PRES_R.PLONCHA, LC.E10NEUTI), (
                            OP.CHAR_MECA_PRES_R.PLSN, LC.N1NEUT_R),
                            (OP.CHAR_MECA_PRES_R.PLST, LC.N1NEUT_R), (
                            OP.CHAR_MECA_PRES_R.PPINTTO, E8NEUTR),
                            (OP.CHAR_MECA_PRES_R.PPMILTO, E10NEUTR), (
                            SP.PPRESSR, EPRESNO),
                            (OP.CHAR_MECA_PRES_R.PSTANO, STANO_I), (
                            SP.PTEMPSR, CTEMPSR),
                            ),
                            para_out=((SP.PVECTUR, MVECTUR), ),
                            ),

        OP.COOR_ELGA(te=467,
                     para_in=((SP.PGEOMER, NGEOMER), ),
                     para_out=((OP.COOR_ELGA.PCOORPG, EGGEOP_R), ),
                     ),

        OP.FLHN_ELGA(te=468,
                     para_in=((SP.PCONTR, NSIEF_R), (SP.PGEOMER, NGEOMER),
                              ),
                     para_out=((SP.PFLHN, EFLHN), ),
                     ),

        OP.INI_XFEM_ELNO(te=99,
                         para_out=(
                         (OP.INI_XFEM_ELNO.PFISNO, LC.FISNO_I), (
                         OP.INI_XFEM_ELNO.PLSN, LC.N1NEUT_R),
                         (OP.INI_XFEM_ELNO.PLST, LC.N1NEUT_R), (
                         OP.INI_XFEM_ELNO.PSTANO, STANO_I),
                         ),
                         ),

        OP.TOPONO(te=120,
                  para_in=(
                      (OP.TOPONO.PCNSETO, E15NEUI), (SP.PFISCO, LC.FISCO_I),
                  (OP.TOPONO.PFISNO, LC.FISNO_I), (
                  OP.TOPONO.PHEAVTO, E5NEUI),
                  (SP.PLEVSET, LC.N1NEUT_R), (
                  OP.TOPONO.PLONCHA, LC.E10NEUTI),
                  ),
                  para_out=(
                  (OP.TOPONO.PHEA_NO, LC.N5NEUTI), (OP.TOPONO.PHEA_SE, E5NEUI),
                  ),
                  ),

        OP.TOPOSE(te=514,
                  para_in=((SP.PFISCO, LC.FISCO_I), (SP.PGEOMER, NGEOMER),
                           (SP.PLEVSET, LC.N1NEUT_R), ),
                  para_out=(
                  (OP.TOPOSE.PCNSETO, E15NEUI), (OP.TOPOSE.PHEAVTO, E5NEUI),
                  (OP.TOPOSE.PLONCHA, LC.E10NEUTI), (
                  OP.TOPOSE.PPINTTO, E8NEUTR),
                  (OP.TOPOSE.PPMILTO, E10NEUTR), ),
                  ),

        OP.TOU_INI_ELEM(te=99,
                        para_out=((OP.TOU_INI_ELEM.PPRES_R, CPRES_R), ),
                        ),

        OP.TOU_INI_ELGA(te=99,
                        para_out=((OP.TOU_INI_ELGA.PGEOM_R, EGEOMER), ),
                        ),

        OP.TOU_INI_ELNO(te=99,
                        para_out=(
                        (OP.TOU_INI_ELNO.PGEOM_R, NGEOMER), (
                        OP.TOU_INI_ELNO.PNEUT_F, LC.ENNEUT_F),
                        (OP.TOU_INI_ELNO.PNEUT_R, LC.ENNEUT_R), (
                        OP.TOU_INI_ELNO.PPRES_R, EPRESNO),
                        ),
                        ),

    )


#------------------------------------------------------------
class HM_DPSE3_XH2(HM_DPSE3_XH1):

    """Please document this element"""
    meshType = MT.SEG3
    nodes = (
        SetOfNodes('EN4', (3,)),
        SetOfNodes('EN3', (1, 2,)),
    )
    elrefe = (
        ElrefeLoc(MT.SE3, gauss=('RIGI=FPG4',),),
        ElrefeLoc(MT.SE2, gauss=('RIGI=FPG4',),),
    )


#------------------------------------------------------------
class HM_DPSE3_XH3(HM_DPSE3_XH1):

    """Please document this element"""
    meshType = MT.SEG3
    nodes = (
        SetOfNodes('EN6', (3,)),
        SetOfNodes('EN5', (1, 2,)),
    )
    elrefe = (
        ElrefeLoc(MT.SE3, gauss=('RIGI=FPG4',),),
        ElrefeLoc(MT.SE2, gauss=('RIGI=FPG4',),),
    )
