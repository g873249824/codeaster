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

# CATALOGUES DES ELEMENTS 3D X-FEM MULTI HEAVISIDE AVEC CONTACT


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


CCAMASS  = LocatedComponents(phys=PHY.CAMASS, type='ELEM',
    components=('C','ALPHA','BETA','KAPPA','X',
          'Y','Z',))



DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO', diff=True,
    components=(
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
          'LAG3_F[2]','LAG4_C','LAG4_F[2]',)),))


EDEPLPG  = LocatedComponents(phys=PHY.DEPL_R, type='ELGA', location='XFEM',
    components=('DX','DY','DZ','H1X','H1Y',
          'H1Z','H2X','H2Y','H2Z','H3X',
          'H3Y','H3Z','H4X','H4Y','H4Z',
          'LAGS_C','LAGS_F[2]','LAG2_C','LAG2_F[2]','LAG3_C',
          'LAG3_F[2]','LAG4_C','LAG4_F[2]',))


DDL_MECC = LocatedComponents(phys=PHY.DEPL_R, type='ELNO',
    components=('DX','DY','DZ',))


EENERR   = LocatedComponents(phys=PHY.ENER_R, type='ELEM',
    components=('TOTALE',))


EFACY_R  = LocatedComponents(phys=PHY.FACY_R, type='ELGA', location='RIGI',
    components=('DTAUM1','VNM1X','VNM1Y','VNM1Z','SINMAX1',
          'SINMOY1','EPNMAX1','EPNMOY1','SIGEQ1','NBRUP1',
          'ENDO1','DTAUM2','VNM2X','VNM2Y','VNM2Z',
          'SINMAX2','SINMOY2','EPNMAX2','EPNMOY2','SIGEQ2',
          'NBRUP2','ENDO2',))


CFORCEF  = LocatedComponents(phys=PHY.FORC_F, type='ELEM',
    components=('FX','FY','FZ',))


NFORCER  = LocatedComponents(phys=PHY.FORC_R, type='ELNO',
    components=('FX','FY','FZ',))


EKTHETA  = LocatedComponents(phys=PHY.G, type='ELEM',
    components=('GTHETA','FIC[3]','K[3]','BETA',))


EGGEOP_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='XFEM',
    components=('X','Y','Z','W',))


EGGEOM_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='XFEM',
    components=('X','Y','Z',))


NGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y','Z',))




XFGEOM_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='XFEM',
    components=('X','Y','Z',))


CTEMPSR  = LocatedComponents(phys=PHY.INST_R, type='ELEM',
    components=('INST',))


STANO_I  = LocatedComponents(phys=PHY.N120_I, type='ELNO',
    components=('X1',))


E90NEUTR = LocatedComponents(phys=PHY.N1360R, type='ELEM',
    components=('X[90]',))


E24NEUTI = LocatedComponents(phys=PHY.N240_I, type='ELEM',
    components=('X[24]',))


E24NEUI  = LocatedComponents(phys=PHY.N960_I, type='ELEM',
    components=('X[24]',))


EGNEUT_F = LocatedComponents(phys=PHY.NEUT_F, type='ELGA', location='XFEM',
    components=('X[30]',))


E1NEUTK  = LocatedComponents(phys=PHY.NEUT_K8, type='ELEM',
    components=('Z1',))


EGNEUT_R = LocatedComponents(phys=PHY.NEUT_R, type='ELGA', location='XFEM',
    components=('X[30]',))


EMNEUT_R = LocatedComponents(phys=PHY.NEUT_R, type='ELEM',
    components=('X[30]',))


CPRESSF  = LocatedComponents(phys=PHY.PRES_F, type='ELEM',
    components=('PRES',))


EPRESNO  = LocatedComponents(phys=PHY.PRES_R, type='ELNO',
    components=('PRES',))


ECONTPC  = LocatedComponents(phys=PHY.SIEF_C, type='ELGA', location='XFEM',
    components=('SIXX','SIYY','SIZZ','SIXY','SIXZ',
          'SIYZ',))


ECONTPG  = LocatedComponents(phys=PHY.SIEF_R, type='ELGA', location='XFEM',
    components=('SIXX','SIYY','SIZZ','SIXY','SIXZ',
          'SIYZ',))


ZVARIPG  = LocatedComponents(phys=PHY.VARI_R, type='ELGA', location='XFEM',
    components=('VARI',))


CONTX_R  = LocatedComponents(phys=PHY.XCONTAC, type='ELEM',
    components=('RHON','MU','RHOTK','INTEG','COECH',
          'COSTCO','COSTFR','COPECO','COPEFR',))


MVECTUR  = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

MMATUUR  = ArrayOfComponents(phys=PHY.MDEP_R, locatedComponents=DDL_MECA)

MMATUNS  = ArrayOfComponents(phys=PHY.MDNS_R, locatedComponents=DDL_MECA)


#------------------------------------------------------------
class MECA_XH2C_HEXA8(Element):
    """Please document this element"""
    meshType = MT.HEXA8
    nodes = (
            SetOfNodes('EN2', (1,2,3,4,5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('RIGI=FPG8','FPG1=FPG1','NOEU=NOEU','XFEM=XFEM960',), mater=('RIGI','XFEM',),),
            ElrefeLoc(MT.TE4, gauss = ('XINT=FPG5','NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('FPG4=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12','SIMP=SIMP','GAUSS=FPG12',),),
        )
    calculs = (

        OP.CALC_G(te=288,
            para_in=((OP.CALC_G.PAINTER, E90NEUTR), (OP.CALC_G.PBASECO, LC.E162NEUR),
                     (OP.CALC_G.PBASLOR, LC.N9NEUT_R), (OP.CALC_G.PCFACE, LC.E54NEUTI),
                     (OP.CALC_G.PCNSETO, LC.E512NEUI), (OP.CALC_G.PCOMPOR, LC.CCOMPOR),
                     (SP.PDEPLAR, DDL_MECA), (SP.PFRVOLU, NFORCER),
                     (SP.PGEOMER, NGEOMER), (OP.CALC_G.PHEAVTO, LC.E128NEUI),
                     (OP.CALC_G.PHEA_NO, LC.N5NEUTI), (OP.CALC_G.PLONCHA, LC.E10NEUTI),
                     (OP.CALC_G.PLONGCO, LC.E3NEUTI), (OP.CALC_G.PLSN, LC.N1NEUT_R),
                     (OP.CALC_G.PLST, LC.N1NEUT_R), (SP.PMATERC, LC.CMATERC),
                     (SP.PPESANR, LC.CPESANR), (OP.CALC_G.PPINTER, LC.E54NEUTR),
                     (OP.CALC_G.PPINTTO, LC.E132NEUR), (SP.PPRESSR, EPRESNO),
                     (SP.PROTATR, LC.CROTATR), (SP.PTHETAR, DDL_MECC),
                     (OP.CALC_G.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     ),
            para_out=((SP.PGTHETA, LC.EGTHETA), ),
        ),

        OP.CALC_GTP(te=288,
            para_in=((OP.CALC_GTP.PAINTER, E90NEUTR), (OP.CALC_GTP.PBASECO, LC.E162NEUR),
                     (OP.CALC_GTP.PBASLOR, LC.N9NEUT_R), (OP.CALC_GTP.PCFACE, LC.E54NEUTI),
                     (OP.CALC_GTP.PCNSETO, LC.E512NEUI), (OP.CALC_GTP.PCOMPOR, LC.CCOMPOR),
                     (SP.PDEPLAR, DDL_MECA), (SP.PFRVOLU, NFORCER),
                     (SP.PGEOMER, NGEOMER), (OP.CALC_GTP.PHEAVTO, LC.E128NEUI),
                     (OP.CALC_GTP.PHEA_NO, LC.N5NEUTI), (OP.CALC_GTP.PLONCHA, LC.E10NEUTI),
                     (OP.CALC_GTP.PLONGCO, LC.E3NEUTI), (OP.CALC_GTP.PLSN, LC.N1NEUT_R),
                     (OP.CALC_GTP.PLST, LC.N1NEUT_R), (SP.PMATERC, LC.CMATERC),
                     (SP.PPESANR, LC.CPESANR), (OP.CALC_GTP.PPINTER, LC.E54NEUTR),
                     (OP.CALC_GTP.PPINTTO, LC.E132NEUR), (SP.PPRESSR, EPRESNO),
                     (SP.PROTATR, LC.CROTATR), (SP.PTHETAR, DDL_MECC),
                     (OP.CALC_GTP.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     ),
            para_out=((SP.PGTHETA, LC.EGTHETA), ),
        ),

        OP.CALC_GTP_F(te=288,
            para_in=((OP.CALC_GTP_F.PAINTER, E90NEUTR), (OP.CALC_GTP_F.PBASECO, LC.E162NEUR),
                     (OP.CALC_GTP_F.PBASLOR, LC.N9NEUT_R), (OP.CALC_GTP_F.PCFACE, LC.E54NEUTI),
                     (OP.CALC_GTP_F.PCNSETO, LC.E512NEUI), (OP.CALC_GTP_F.PCOMPOR, LC.CCOMPOR),
                     (SP.PCOURB, LC.G27NEUTR), (SP.PDEPLAR, DDL_MECA),
                     (SP.PFFVOLU, CFORCEF), (SP.PGEOMER, NGEOMER),
                     (OP.CALC_GTP_F.PHEAVTO, LC.E128NEUI), (OP.CALC_GTP_F.PHEA_NO, LC.N5NEUTI),
                     (OP.CALC_GTP_F.PLONCHA, LC.E10NEUTI), (OP.CALC_GTP_F.PLONGCO, LC.E3NEUTI),
                     (OP.CALC_GTP_F.PLSN, LC.N1NEUT_R), (OP.CALC_GTP_F.PLST, LC.N1NEUT_R),
                     (SP.PMATERC, LC.CMATERC), (SP.PPESANR, LC.CPESANR),
                     (OP.CALC_GTP_F.PPINTER, LC.E54NEUTR), (OP.CALC_GTP_F.PPINTTO, LC.E132NEUR),
                     (SP.PPRESSF, CPRESSF), (SP.PROTATR, LC.CROTATR),
                     (SP.PTEMPSR, CTEMPSR), (SP.PTHETAR, DDL_MECC),
                     (OP.CALC_GTP_F.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     ),
            para_out=((SP.PGTHETA, LC.EGTHETA), ),
        ),

        OP.CALC_G_F(te=288,
            para_in=((OP.CALC_G_F.PAINTER, E90NEUTR), (OP.CALC_G_F.PBASECO, LC.E162NEUR),
                     (OP.CALC_G_F.PBASLOR, LC.N9NEUT_R), (OP.CALC_G_F.PCFACE, LC.E54NEUTI),
                     (OP.CALC_G_F.PCNSETO, LC.E512NEUI), (OP.CALC_G_F.PCOMPOR, LC.CCOMPOR),
                     (SP.PCOURB, LC.G27NEUTR), (SP.PDEPLAR, DDL_MECA),
                     (SP.PFFVOLU, CFORCEF), (SP.PGEOMER, NGEOMER),
                     (OP.CALC_G_F.PHEAVTO, LC.E128NEUI), (OP.CALC_G_F.PHEA_NO, LC.N5NEUTI),
                     (OP.CALC_G_F.PLONCHA, LC.E10NEUTI), (OP.CALC_G_F.PLONGCO, LC.E3NEUTI),
                     (OP.CALC_G_F.PLSN, LC.N1NEUT_R), (OP.CALC_G_F.PLST, LC.N1NEUT_R),
                     (SP.PMATERC, LC.CMATERC), (SP.PPESANR, LC.CPESANR),
                     (OP.CALC_G_F.PPINTER, LC.E54NEUTR), (OP.CALC_G_F.PPINTTO, LC.E132NEUR),
                     (SP.PPRESSF, CPRESSF), (SP.PROTATR, LC.CROTATR),
                     (SP.PTEMPSR, CTEMPSR), (SP.PTHETAR, DDL_MECC),
                     (OP.CALC_G_F.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     ),
            para_out=((SP.PGTHETA, LC.EGTHETA), ),
        ),

        OP.CALC_K_G(te=297,
            para_in=((OP.CALC_K_G.PAINTER, E90NEUTR), (OP.CALC_K_G.PBASECO, LC.E162NEUR),
                     (OP.CALC_K_G.PBASLOR, LC.N9NEUT_R), (OP.CALC_K_G.PCFACE, LC.E54NEUTI),
                     (OP.CALC_K_G.PCNSETO, LC.E512NEUI), (OP.CALC_K_G.PCOMPOR, LC.CCOMPOR),
                     (SP.PCOURB, LC.G27NEUTR), (SP.PDEPLAR, DDL_MECA),
                     (SP.PFRVOLU, NFORCER), (SP.PGEOMER, NGEOMER),
                     (OP.CALC_K_G.PHEAVTO, LC.E128NEUI), (OP.CALC_K_G.PHEA_NO, LC.N5NEUTI),
                     (OP.CALC_K_G.PLONCHA, LC.E10NEUTI), (OP.CALC_K_G.PLONGCO, LC.E3NEUTI),
                     (OP.CALC_K_G.PLSN, LC.N1NEUT_R), (OP.CALC_K_G.PLST, LC.N1NEUT_R),
                     (SP.PMATERC, LC.CMATERC), (SP.PPESANR, LC.CPESANR),
                     (OP.CALC_K_G.PPINTER, LC.E54NEUTR), (OP.CALC_K_G.PPINTTO, LC.E132NEUR),
                     (SP.PPRESSR, EPRESNO), (SP.PPULPRO, LC.CFREQR),
                     (SP.PROTATR, LC.CROTATR), (SP.PTHETAR, DDL_MECC),
                     (OP.CALC_K_G.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     ),
            para_out=((SP.PGTHETA, EKTHETA), ),
        ),

        OP.CALC_K_G_F(te=297,
            para_in=((OP.CALC_K_G_F.PAINTER, E90NEUTR), (OP.CALC_K_G_F.PBASECO, LC.E162NEUR),
                     (OP.CALC_K_G_F.PBASLOR, LC.N9NEUT_R), (OP.CALC_K_G_F.PCFACE, LC.E54NEUTI),
                     (OP.CALC_K_G_F.PCNSETO, LC.E512NEUI), (OP.CALC_K_G_F.PCOMPOR, LC.CCOMPOR),
                     (SP.PCOURB, LC.G27NEUTR), (SP.PDEPLAR, DDL_MECA),
                     (SP.PFFVOLU, CFORCEF), (SP.PGEOMER, NGEOMER),
                     (OP.CALC_K_G_F.PHEAVTO, LC.E128NEUI), (OP.CALC_K_G_F.PHEA_NO, LC.N5NEUTI),
                     (OP.CALC_K_G_F.PLONCHA, LC.E10NEUTI), (OP.CALC_K_G_F.PLONGCO, LC.E3NEUTI),
                     (OP.CALC_K_G_F.PLSN, LC.N1NEUT_R), (OP.CALC_K_G_F.PLST, LC.N1NEUT_R),
                     (SP.PMATERC, LC.CMATERC), (SP.PPESANR, LC.CPESANR),
                     (OP.CALC_K_G_F.PPINTER, LC.E54NEUTR), (OP.CALC_K_G_F.PPINTTO, LC.E132NEUR),
                     (SP.PPRESSF, CPRESSF), (SP.PPULPRO, LC.CFREQR),
                     (SP.PROTATR, LC.CROTATR), (SP.PTEMPSR, CTEMPSR),
                     (SP.PTHETAR, DDL_MECC), (OP.CALC_K_G_F.PVARCPR, LC.ZVARCPG),
                     (SP.PVARCRR, LC.ZVARCPG), ),
            para_out=((SP.PGTHETA, EKTHETA), ),
        ),

        OP.CHAR_MECA_CONT(te=534,
            para_in=((OP.CHAR_MECA_CONT.PAINTER, E90NEUTR), (OP.CHAR_MECA_CONT.PBASECO, LC.E162NEUR),
                     (OP.CHAR_MECA_CONT.PCFACE, LC.E54NEUTI), (SP.PCOHES, LC.E1NEUTR),
                     (SP.PDEPL_M, DDL_MECA), (SP.PDEPL_P, DDL_MECA),
                     (SP.PDONCO, CONTX_R), (OP.CHAR_MECA_CONT.PFISNO, LC.FISNO_I),
                     (SP.PGEOMER, NGEOMER), (SP.PHEAVNO, LC.FISNO_I),
                     (OP.CHAR_MECA_CONT.PHEA_FA, E24NEUTI), (OP.CHAR_MECA_CONT.PHEA_NO, LC.N5NEUTI),
                     (SP.PINDCOI, LC.E1NEUTI), (OP.CHAR_MECA_CONT.PLONGCO, LC.E3NEUTI),
                     (OP.CHAR_MECA_CONT.PLST, LC.N1NEUT_R), (SP.PMATERC, LC.CMATERC),
                     (OP.CHAR_MECA_CONT.PPINTER, LC.E54NEUTR), (OP.CHAR_MECA_CONT.PSEUIL, LC.E1NEUTR),
                     (OP.CHAR_MECA_CONT.PSTANO, STANO_I), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.CHAR_MECA_FROT(te=534,
            para_in=((OP.CHAR_MECA_FROT.PAINTER, E90NEUTR), (OP.CHAR_MECA_FROT.PBASECO, LC.E162NEUR),
                     (OP.CHAR_MECA_FROT.PCFACE, LC.E54NEUTI), (SP.PCOHES, LC.E1NEUTR),
                     (SP.PDEPL_M, DDL_MECA), (SP.PDEPL_P, DDL_MECA),
                     (SP.PDONCO, CONTX_R), (OP.CHAR_MECA_FROT.PFISNO, LC.FISNO_I),
                     (SP.PGEOMER, NGEOMER), (SP.PHEAVNO, LC.FISNO_I),
                     (OP.CHAR_MECA_FROT.PHEA_FA, E24NEUTI), (OP.CHAR_MECA_FROT.PHEA_NO, LC.N5NEUTI),
                     (SP.PINDCOI, LC.E1NEUTI), (OP.CHAR_MECA_FROT.PLONGCO, LC.E3NEUTI),
                     (OP.CHAR_MECA_FROT.PLST, LC.N1NEUT_R), (SP.PMATERC, LC.CMATERC),
                     (OP.CHAR_MECA_FROT.PPINTER, LC.E54NEUTR), (OP.CHAR_MECA_FROT.PSEUIL, LC.E1NEUTR),
                     (OP.CHAR_MECA_FROT.PSTANO, STANO_I), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

#       -- te0580 : ne resout que les cas triviaux : 0.
        OP.CHAR_MECA_PRES_F(te=580,
            para_in=((SP.PPRESSF, CPRESSF), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.CHAR_MECA_PRES_R(te=580,
            para_in=((SP.PPRESSR, EPRESNO), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.CHAR_MECA_ROTA_R(te=441,
            para_in=((OP.CHAR_MECA_ROTA_R.PCNSETO, LC.E512NEUI), (SP.PDEPLMR, DDL_MECA),
                     (SP.PDEPLPR, DDL_MECA), (SP.PGEOMER, NGEOMER),
                     (OP.CHAR_MECA_ROTA_R.PHEAVTO, LC.E128NEUI), (OP.CHAR_MECA_ROTA_R.PLONCHA, LC.E10NEUTI),
                     (OP.CHAR_MECA_ROTA_R.PLSN, LC.N1NEUT_R), (OP.CHAR_MECA_ROTA_R.PLST, LC.N1NEUT_R),
                     (SP.PMATERC, LC.CMATERC), (OP.CHAR_MECA_ROTA_R.PPINTTO, LC.E132NEUR),
                     (SP.PROTATR, LC.CROTATR), (OP.CHAR_MECA_ROTA_R.PSTANO, STANO_I),
                     ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.COOR_ELGA(te=481,
            para_in=((OP.COOR_ELGA.PCNSETO, LC.E512NEUI), (SP.PGEOMER, NGEOMER),
                     (OP.COOR_ELGA.PLONCHA, LC.E10NEUTI), (OP.COOR_ELGA.PPINTTO, LC.E132NEUR),
                     ),
            para_out=((OP.COOR_ELGA.PCOORPG, EGGEOP_R), ),
        ),

        OP.DEPL_XPG(te=566,
            para_in=((OP.DEPL_XPG.PBASLOR, LC.N9NEUT_R), (SP.PDEPLNO, DDL_MECA),
                     (OP.DEPL_XPG.PHEAVTO, LC.E128NEUI), (OP.DEPL_XPG.PHEA_NO, LC.N5NEUTI),
                     (OP.DEPL_XPG.PLONCHA, LC.E10NEUTI), (OP.DEPL_XPG.PLSN, LC.N1NEUT_R),
                     (OP.DEPL_XPG.PLST, LC.N1NEUT_R), (OP.DEPL_XPG.PXFGEOM, XFGEOM_R),
                     ),
            para_out=((SP.PDEPLPG, EDEPLPG), ),
        ),

        OP.ENEL_ELEM(te=565,
            para_in=((OP.ENEL_ELEM.PCNSETO, LC.E512NEUI), (OP.ENEL_ELEM.PCOMPOR, LC.CCOMPOR),
                     (OP.ENEL_ELEM.PCONTPR, ECONTPG), (SP.PDEPLR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (OP.ENEL_ELEM.PLONCHA, LC.E10NEUTI),
                     (SP.PMATERC, LC.CMATERC), (OP.ENEL_ELEM.PPINTTO, LC.E132NEUR),
                     (OP.ENEL_ELEM.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     (OP.ENEL_ELEM.PVARIPR, ZVARIPG), ),
            para_out=((SP.PENERD1, EENERR), ),
        ),

        OP.FORC_NODA(te=542,
            para_in=((OP.FORC_NODA.PBASLOR, LC.N9NEUT_R), (OP.FORC_NODA.PCNSETO, LC.E512NEUI),
                     (OP.FORC_NODA.PCOMPOR, LC.CCOMPOR), (OP.FORC_NODA.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (OP.FORC_NODA.PFISNO, LC.FISNO_I),
                     (SP.PGEOMER, NGEOMER), (OP.FORC_NODA.PHEAVTO, LC.E128NEUI),
                     (OP.FORC_NODA.PHEA_NO, LC.N5NEUTI), (OP.FORC_NODA.PLONCHA, LC.E10NEUTI),
                     (OP.FORC_NODA.PLSN, LC.N1NEUT_R), (OP.FORC_NODA.PLST, LC.N1NEUT_R),
                     (OP.FORC_NODA.PPINTTO, LC.E132NEUR), (OP.FORC_NODA.PSTANO, STANO_I),
                     (OP.FORC_NODA.PVARCPR, LC.ZVARCPG), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.FULL_MECA(te=539,
            para_in=((OP.FULL_MECA.PBASLOR, LC.N9NEUT_R), (SP.PCAMASS, CCAMASS),
                     (SP.PCARCRI, LC.CCARCRI), (OP.FULL_MECA.PCNSETO, LC.E512NEUI),
                     (OP.FULL_MECA.PCOMPOR, LC.CCOMPOR), (OP.FULL_MECA.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (OP.FULL_MECA.PFISNO, LC.FISNO_I), (SP.PGEOMER, NGEOMER),
                     (SP.PHEAVNO, LC.FISNO_I), (OP.FULL_MECA.PHEAVTO, LC.E128NEUI),
                     (OP.FULL_MECA.PHEA_NO, LC.N5NEUTI), (SP.PINSTMR, CTEMPSR),
                     (SP.PINSTPR, CTEMPSR), (OP.FULL_MECA.PLONCHA, LC.E10NEUTI),
                     (OP.FULL_MECA.PLSN, LC.N1NEUT_R), (OP.FULL_MECA.PLST, LC.N1NEUT_R),
                     (SP.PMATERC, LC.CMATERC), (OP.FULL_MECA.PPINTTO, LC.E132NEUR),
                     (OP.FULL_MECA.PSTANO, STANO_I), (SP.PVARCMR, LC.ZVARCPG),
                     (OP.FULL_MECA.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     (SP.PVARIMP, ZVARIPG), (OP.FULL_MECA.PVARIMR, ZVARIPG),
                     ),
            para_out=((SP.PCODRET, LC.ECODRET), (OP.FULL_MECA.PCONTPR, ECONTPG),
                     (SP.PMATUUR, MMATUUR), (OP.FULL_MECA.PVARIPR, ZVARIPG),
                     (SP.PVECTUR, MVECTUR), ),
        ),

        OP.GEOM_FAC(te=519,
            para_in=((SP.NOMFIS, E1NEUTK), (SP.PDEPLA, DDL_MECA),
                     (OP.GEOM_FAC.PFISNO, LC.FISNO_I), (OP.GEOM_FAC.PGESCLO, LC.E54NEUTR),
                     (OP.GEOM_FAC.PHEA_FA, E24NEUTI), (OP.GEOM_FAC.PHEA_NO, LC.N5NEUTI),
                     (OP.GEOM_FAC.PLONGCO, LC.E3NEUTI), (OP.GEOM_FAC.PLST, LC.N1NEUT_R),
                     (OP.GEOM_FAC.PPINTER, LC.E54NEUTR), ),
            para_out=((SP.PNEWGEM, LC.E54NEUTR), (SP.PNEWGES, LC.E54NEUTR),
                     ),
        ),

        OP.GRAD_NEUT9_R(te=398,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PNEUTER, LC.N9NEUT_R),
                     ),
            para_out=((OP.GRAD_NEUT9_R.PGNEUTR, LC.G27NEUTR), ),
        ),

        OP.INIT_VARC(te=99,
            para_out=((OP.INIT_VARC.PVARCPR, LC.ZVARCPG), ),
        ),

        OP.INI_XFEM_ELNO(te=99,
            para_out=((OP.INI_XFEM_ELNO.PBASLOR, LC.N9NEUT_R), (OP.INI_XFEM_ELNO.PFISNO, LC.FISNO_I),
                     (OP.INI_XFEM_ELNO.PLSN, LC.N1NEUT_R), (OP.INI_XFEM_ELNO.PLST, LC.N1NEUT_R),
                     (OP.INI_XFEM_ELNO.PSTANO, STANO_I), ),
        ),

        OP.NORME_L2(te=563,
            para_in=((SP.PCALCI, LC.EMNEUT_I), (SP.PCHAMPG, EGNEUT_R),
                     (SP.PCOEFR, EMNEUT_R), (OP.NORME_L2.PCOORPG, EGGEOP_R),
                     ),
            para_out=((SP.PNORME, LC.ENORME), ),
        ),

        OP.NSPG_NBVA(te=496,
            para_in=((OP.NSPG_NBVA.PCOMPOR, LC.CCOMPO2), ),
            para_out=((SP.PDCEL_I, LC.EDCEL_I), ),
        ),

        OP.RAPH_MECA(te=539,
            para_in=((OP.RAPH_MECA.PBASLOR, LC.N9NEUT_R), (SP.PCAMASS, CCAMASS),
                     (SP.PCARCRI, LC.CCARCRI), (OP.RAPH_MECA.PCNSETO, LC.E512NEUI),
                     (OP.RAPH_MECA.PCOMPOR, LC.CCOMPOR), (OP.RAPH_MECA.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (OP.RAPH_MECA.PHEAVTO, LC.E128NEUI),
                     (OP.RAPH_MECA.PHEA_NO, LC.N5NEUTI), (SP.PINSTMR, CTEMPSR),
                     (SP.PINSTPR, CTEMPSR), (OP.RAPH_MECA.PLONCHA, LC.E10NEUTI),
                     (OP.RAPH_MECA.PLSN, LC.N1NEUT_R), (OP.RAPH_MECA.PLST, LC.N1NEUT_R),
                     (SP.PMATERC, LC.CMATERC), (OP.RAPH_MECA.PPINTTO, LC.E132NEUR),
                     (OP.RAPH_MECA.PSTANO, STANO_I), (SP.PVARCMR, LC.ZVARCPG),
                     (OP.RAPH_MECA.PVARCPR, LC.ZVARCPG), (SP.PVARCRR, LC.ZVARCPG),
                     (SP.PVARIMP, ZVARIPG), (OP.RAPH_MECA.PVARIMR, ZVARIPG),
                     ),
            para_out=((SP.PCODRET, LC.ECODRET), (OP.RAPH_MECA.PCONTPR, ECONTPG),
                     (OP.RAPH_MECA.PVARIPR, ZVARIPG), (SP.PVECTUR, MVECTUR),
                     ),
        ),

        OP.RIGI_CONT(te=533,
            para_in=((OP.RIGI_CONT.PAINTER, E90NEUTR), (OP.RIGI_CONT.PBASECO, LC.E162NEUR),
                     (OP.RIGI_CONT.PCFACE, LC.E54NEUTI), (SP.PCOHES, LC.E1NEUTR),
                     (SP.PDEPL_M, DDL_MECA), (SP.PDEPL_P, DDL_MECA),
                     (SP.PDONCO, CONTX_R), (OP.RIGI_CONT.PFISNO, LC.FISNO_I),
                     (SP.PGEOMER, NGEOMER), (SP.PHEAVNO, LC.FISNO_I),
                     (OP.RIGI_CONT.PHEA_FA, E24NEUTI), (OP.RIGI_CONT.PHEA_NO, LC.N5NEUTI),
                     (SP.PINDCOI, LC.E1NEUTI), (OP.RIGI_CONT.PLONGCO, LC.E3NEUTI),
                     (OP.RIGI_CONT.PLSN, LC.N1NEUT_R), (OP.RIGI_CONT.PLST, LC.N1NEUT_R),
                     (SP.PMATERC, LC.CMATERC), (OP.RIGI_CONT.PPINTER, LC.E54NEUTR),
                     (OP.RIGI_CONT.PSEUIL, LC.E1NEUTR), (OP.RIGI_CONT.PSTANO, STANO_I),
                     ),
            para_out=((SP.PMATUNS, MMATUNS), (SP.PMATUUR, MMATUUR),
                     ),
        ),

        OP.RIGI_FROT(te=533,
            para_in=((OP.RIGI_FROT.PAINTER, E90NEUTR), (OP.RIGI_FROT.PBASECO, LC.E162NEUR),
                     (OP.RIGI_FROT.PCFACE, LC.E54NEUTI), (SP.PCOHES, LC.E1NEUTR),
                     (SP.PDEPL_M, DDL_MECA), (SP.PDEPL_P, DDL_MECA),
                     (SP.PDONCO, CONTX_R), (OP.RIGI_FROT.PFISNO, LC.FISNO_I),
                     (SP.PGEOMER, NGEOMER), (SP.PHEAVNO, LC.FISNO_I),
                     (OP.RIGI_FROT.PHEA_FA, E24NEUTI), (OP.RIGI_FROT.PHEA_NO, LC.N5NEUTI),
                     (SP.PINDCOI, LC.E1NEUTI), (OP.RIGI_FROT.PLONGCO, LC.E3NEUTI),
                     (OP.RIGI_FROT.PLSN, LC.N1NEUT_R), (OP.RIGI_FROT.PLST, LC.N1NEUT_R),
                     (SP.PMATERC, LC.CMATERC), (OP.RIGI_FROT.PPINTER, LC.E54NEUTR),
                     (OP.RIGI_FROT.PSEUIL, LC.E1NEUTR), (OP.RIGI_FROT.PSTANO, STANO_I),
                     ),
            para_out=((SP.PMATUNS, MMATUNS), (SP.PMATUUR, MMATUUR),
                     ),
        ),

        OP.RIGI_MECA_TANG(te=539,
            para_in=((OP.RIGI_MECA_TANG.PBASLOR, LC.N9NEUT_R), (SP.PCAMASS, CCAMASS),
                     (SP.PCARCRI, LC.CCARCRI), (OP.RIGI_MECA_TANG.PCNSETO, LC.E512NEUI),
                     (OP.RIGI_MECA_TANG.PCOMPOR, LC.CCOMPOR), (OP.RIGI_MECA_TANG.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (OP.RIGI_MECA_TANG.PFISNO, LC.FISNO_I), (SP.PGEOMER, NGEOMER),
                     (OP.RIGI_MECA_TANG.PHEAVTO, LC.E128NEUI), (OP.RIGI_MECA_TANG.PHEA_NO, LC.N5NEUTI),
                     (SP.PINSTMR, CTEMPSR), (SP.PINSTPR, CTEMPSR),
                     (OP.RIGI_MECA_TANG.PLONCHA, LC.E10NEUTI), (OP.RIGI_MECA_TANG.PLSN, LC.N1NEUT_R),
                     (OP.RIGI_MECA_TANG.PLST, LC.N1NEUT_R), (SP.PMATERC, LC.CMATERC),
                     (OP.RIGI_MECA_TANG.PPINTTO, LC.E132NEUR), (OP.RIGI_MECA_TANG.PSTANO, STANO_I),
                     (SP.PVARCMR, LC.ZVARCPG), (OP.RIGI_MECA_TANG.PVARCPR, LC.ZVARCPG),
                     (SP.PVARCRR, LC.ZVARCPG), (OP.RIGI_MECA_TANG.PVARIMR, ZVARIPG),
                     ),
            para_out=((SP.PMATUUR, MMATUUR), ),
        ),

        OP.SIGM_ELGA(te=546,
            para_in=((SP.PSIEFR, ECONTPG), ),
            para_out=((SP.PSIGMC, ECONTPC), (SP.PSIGMR, ECONTPG),
                     ),
        ),

        OP.TOPOFA(te=510,
            para_in=((OP.TOPOFA.PAINTTO, LC.E220NEUR), (OP.TOPOFA.PCNSETO, LC.E512NEUI),
                     (SP.PDECOU, E1NEUTK), (SP.PFISCO, LC.FISCO_I),
                     (SP.PGEOMER, NGEOMER), (SP.PGRADLN, LC.N3NEUT_R),
                     (SP.PGRADLT, LC.N3NEUT_R), (OP.TOPOFA.PHEAVTO, LC.E128NEUI),
                     (OP.TOPOFA.PLONCHA, LC.E10NEUTI), (OP.TOPOFA.PLSN, LC.N1NEUT_R),
                     (OP.TOPOFA.PLST, LC.N1NEUT_R), (OP.TOPOFA.PPINTTO, LC.E132NEUR),
                     ),
            para_out=((OP.TOPOFA.PAINTER, E90NEUTR), (OP.TOPOFA.PBASECO, LC.E162NEUR),
                     (OP.TOPOFA.PCFACE, LC.E54NEUTI), (SP.PGESCLA, LC.E54NEUTR),
                     (OP.TOPOFA.PHEAVFA, E24NEUI), (OP.TOPOFA.PLONGCO, LC.E3NEUTI),
                     (OP.TOPOFA.PPINTER, LC.E54NEUTR), ),
        ),

        OP.TOPONO(te=120,
            para_in=((OP.TOPONO.PCNSETO, LC.E512NEUI), (SP.PFISCO, LC.FISCO_I),
                     (OP.TOPONO.PFISNO, LC.FISNO_I), (OP.TOPONO.PHEAVFA, E24NEUI),
                     (OP.TOPONO.PHEAVTO, LC.E128NEUI), (SP.PLEVSET, LC.N1NEUT_R),
                     (OP.TOPONO.PLONCHA, LC.E10NEUTI), (OP.TOPONO.PLONGCO, LC.E3NEUTI),
                     ),
            para_out=((OP.TOPONO.PHEA_FA, E24NEUTI), (OP.TOPONO.PHEA_NO, LC.N5NEUTI),
                     (OP.TOPONO.PHEA_SE, LC.E128NEUI), ),
        ),

        OP.TOPOSE(te=514,
            para_in=((SP.PFISCO, LC.FISCO_I), (SP.PGEOMER, NGEOMER),
                     (SP.PLEVSET, LC.N1NEUT_R), ),
            para_out=((OP.TOPOSE.PAINTTO, LC.E220NEUR), (OP.TOPOSE.PCNSETO, LC.E512NEUI),
                     (OP.TOPOSE.PHEAVTO, LC.E128NEUI), (OP.TOPOSE.PLONCHA, LC.E10NEUTI),
                     (OP.TOPOSE.PPINTTO, LC.E132NEUR), ),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out=((OP.TOU_INI_ELEM.PGEOM_R, LC.CGEOM3D), ),
        ),

        OP.TOU_INI_ELGA(te=99,
            para_out=((OP.TOU_INI_ELGA.PDEPL_R, EDEPLPG), (OP.TOU_INI_ELGA.PDOMMAG, LC.EDOMGGA),
                     (SP.PFACY_R, EFACY_R), (OP.TOU_INI_ELGA.PGEOM_R, EGGEOM_R),
                     (OP.TOU_INI_ELGA.PINST_R, LC.EGINST_R), (OP.TOU_INI_ELGA.PNEUT_F, EGNEUT_F),
                     (OP.TOU_INI_ELGA.PNEUT_R, EGNEUT_R), (OP.TOU_INI_ELGA.PSIEF_R, ECONTPG),
                     (OP.TOU_INI_ELGA.PVARI_R, ZVARIPG), ),
        ),

        OP.TOU_INI_ELNO(te=99,
            para_out=((OP.TOU_INI_ELNO.PGEOM_R, NGEOMER), ),
        ),

        OP.XCVBCA(te=532,
            para_in=((OP.XCVBCA.PAINTER, E90NEUTR), (OP.XCVBCA.PBASECO, LC.E162NEUR),
                     (OP.XCVBCA.PCFACE, LC.E54NEUTI), (SP.PCOHES, LC.E1NEUTR),
                     (SP.PDEPL_P, DDL_MECA), (SP.PDONCO, CONTX_R),
                     (OP.XCVBCA.PFISNO, LC.FISNO_I), (SP.PGEOMER, NGEOMER),
                     (SP.PGLISS, LC.E1NEUTI), (SP.PHEAVNO, LC.FISNO_I),
                     (OP.XCVBCA.PHEA_FA, E24NEUTI), (OP.XCVBCA.PHEA_NO, LC.N5NEUTI),
                     (SP.PINDCOI, LC.E1NEUTI), (OP.XCVBCA.PLONGCO, LC.E3NEUTI),
                     (OP.XCVBCA.PLST, LC.N1NEUT_R), (SP.PMATERC, LC.CMATERC),
                     (SP.PMEMCON, LC.E1NEUTI), (OP.XCVBCA.PPINTER, LC.E54NEUTR),
                     ),
            para_out=((OP.XCVBCA.PCOHESO, LC.E1NEUTR), (SP.PINCOCA, LC.E1NEUTI),
                     (SP.PINDCOO, LC.E1NEUTI), (SP.PINDMEM, LC.E1NEUTI),
                     ),
        ),

        OP.XFEM_XPG(te=46,
            para_in=((OP.XFEM_XPG.PCNSETO, LC.E512NEUI), (SP.PGEOMER, NGEOMER),
                     (OP.XFEM_XPG.PHEAVTO, LC.E128NEUI), (OP.XFEM_XPG.PLONCHA, LC.E10NEUTI),
                     (OP.XFEM_XPG.PPINTTO, LC.E132NEUR), ),
            para_out=((OP.XFEM_XPG.PXFGEOM, XFGEOM_R), ),
        ),

        OP.XREACL(te=548,
            para_in=((OP.XREACL.PAINTER, E90NEUTR), (OP.XREACL.PBASECO, LC.E162NEUR),
                     (OP.XREACL.PCFACE, LC.E54NEUTI), (SP.PDEPL_P, DDL_MECA),
                     (SP.PDONCO, CONTX_R), (SP.PGEOMER, NGEOMER),
                     (OP.XREACL.PLONGCO, LC.E3NEUTI), (OP.XREACL.PLST, LC.N1NEUT_R),
                     (OP.XREACL.PPINTER, LC.E54NEUTR), ),
            para_out=((OP.XREACL.PSEUIL, LC.E1NEUTR), ),
        ),

    )


#------------------------------------------------------------
class MECA_XH3C_HEXA8(MECA_XH2C_HEXA8):
    """Please document this element"""
    meshType = MT.HEXA8
    nodes = (
            SetOfNodes('EN3', (1,2,3,4,5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('RIGI=FPG8','FPG1=FPG1','NOEU=NOEU','XFEM=XFEM1440',), mater=('RIGI','XFEM',),),
            ElrefeLoc(MT.TE4, gauss = ('XINT=FPG5','NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('FPG4=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12','SIMP=SIMP','GAUSS=FPG12',),),
        )


#------------------------------------------------------------
class MECA_XH4C_HEXA8(MECA_XH2C_HEXA8):
    """Please document this element"""
    meshType = MT.HEXA8
    nodes = (
            SetOfNodes('EN4', (1,2,3,4,5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.HE8, gauss = ('RIGI=FPG8','FPG1=FPG1','NOEU=NOEU','XFEM=XFEM1920',), mater=('RIGI','XFEM',),),
            ElrefeLoc(MT.TE4, gauss = ('XINT=FPG5','NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('FPG4=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12','SIMP=SIMP','GAUSS=FPG12',),),
        )


#------------------------------------------------------------
class MECA_XH2C_PENTA6(MECA_XH2C_HEXA8):
    """Please document this element"""
    meshType = MT.PENTA6
    nodes = (
            SetOfNodes('EN2', (1,2,3,4,5,6,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('RIGI=FPG6','FPG1=FPG1','NOEU=NOEU','XFEM=XFEM480',), mater=('RIGI','XFEM',),),
            ElrefeLoc(MT.TE4, gauss = ('XINT=FPG5','NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('FPG4=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12','SIMP=SIMP','GAUSS=FPG12',),),
        )


#------------------------------------------------------------
class MECA_XH3C_PENTA6(MECA_XH2C_HEXA8):
    """Please document this element"""
    meshType = MT.PENTA6
    nodes = (
            SetOfNodes('EN3', (1,2,3,4,5,6,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('RIGI=FPG6','FPG1=FPG1','NOEU=NOEU','XFEM=XFEM720',), mater=('RIGI','XFEM',),),
            ElrefeLoc(MT.TE4, gauss = ('XINT=FPG5','NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('FPG4=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12','SIMP=SIMP','GAUSS=FPG12',),),
        )


#------------------------------------------------------------
class MECA_XH4C_PENTA6(MECA_XH2C_HEXA8):
    """Please document this element"""
    meshType = MT.PENTA6
    nodes = (
            SetOfNodes('EN4', (1,2,3,4,5,6,)),
        )
    elrefe =(
            ElrefeLoc(MT.PE6, gauss = ('RIGI=FPG6','FPG1=FPG1','NOEU=NOEU','XFEM=XFEM960',), mater=('RIGI','XFEM',),),
            ElrefeLoc(MT.TE4, gauss = ('XINT=FPG5','NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('FPG4=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12','SIMP=SIMP','GAUSS=FPG12',),),
        )


#------------------------------------------------------------
class MECA_XH2C_PYRAM5(MECA_XH2C_HEXA8):
    """Please document this element"""
    meshType = MT.PYRAM5
    nodes = (
            SetOfNodes('EN2', (1,2,3,4,5,)),
        )
    elrefe =(
            ElrefeLoc(MT.PY5, gauss = ('RIGI=FPG5','FPG1=FPG1','NOEU=NOEU','XFEM=XFEM360',), mater=('RIGI','XFEM',),),
            ElrefeLoc(MT.TE4, gauss = ('XINT=FPG5','NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('FPG4=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12','SIMP=SIMP','GAUSS=FPG12',),),
        )


#------------------------------------------------------------
class MECA_XH3C_PYRAM5(MECA_XH2C_HEXA8):
    """Please document this element"""
    meshType = MT.PYRAM5
    nodes = (
            SetOfNodes('EN3', (1,2,3,4,5,)),
        )
    elrefe =(
            ElrefeLoc(MT.PY5, gauss = ('RIGI=FPG5','FPG1=FPG1','NOEU=NOEU','XFEM=XFEM540',), mater=('RIGI','XFEM',),),
            ElrefeLoc(MT.TE4, gauss = ('XINT=FPG5','NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('FPG4=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12','SIMP=SIMP','GAUSS=FPG12',),),
        )


#------------------------------------------------------------
class MECA_XH4C_PYRAM5(MECA_XH2C_HEXA8):
    """Please document this element"""
    meshType = MT.PYRAM5
    nodes = (
            SetOfNodes('EN4', (1,2,3,4,5,)),
        )
    elrefe =(
            ElrefeLoc(MT.PY5, gauss = ('RIGI=FPG5','FPG1=FPG1','NOEU=NOEU','XFEM=XFEM720',), mater=('RIGI','XFEM',),),
            ElrefeLoc(MT.TE4, gauss = ('XINT=FPG5','NOEU=NOEU',),),
            ElrefeLoc(MT.TR3, gauss = ('FPG4=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12','SIMP=SIMP','GAUSS=FPG12',),),
        )


#------------------------------------------------------------
class MECA_XH2C_TETRA4(MECA_XH2C_HEXA8):
    """Please document this element"""
    meshType = MT.TETRA4
    nodes = (
            SetOfNodes('EN2', (1,2,3,4,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('RIGI=FPG1','FPG1=FPG1','NOEU=NOEU','XINT=FPG5','XFEM=XFEM180',), mater=('RIGI','XFEM',),),
            ElrefeLoc(MT.TR3, gauss = ('FPG4=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12','SIMP=SIMP','GAUSS=FPG12',),),
        )


#------------------------------------------------------------
class MECA_XH3C_TETRA4(MECA_XH2C_HEXA8):
    """Please document this element"""
    meshType = MT.TETRA4
    nodes = (
            SetOfNodes('EN3', (1,2,3,4,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('RIGI=FPG1','FPG1=FPG1','NOEU=NOEU','XINT=FPG5','XFEM=XFEM270',), mater=('RIGI','XFEM',),),
            ElrefeLoc(MT.TR3, gauss = ('FPG4=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12','SIMP=SIMP','GAUSS=FPG12',),),
        )


#------------------------------------------------------------
class MECA_XH4C_TETRA4(MECA_XH2C_HEXA8):
    """Please document this element"""
    meshType = MT.TETRA4
    nodes = (
            SetOfNodes('EN4', (1,2,3,4,)),
        )
    elrefe =(
            ElrefeLoc(MT.TE4, gauss = ('RIGI=FPG1','FPG1=FPG1','NOEU=NOEU','XINT=FPG5','XFEM=XFEM360',), mater=('RIGI','XFEM',),),
            ElrefeLoc(MT.TR3, gauss = ('FPG4=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12','SIMP=SIMP','GAUSS=FPG12',),),
        )
