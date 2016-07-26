# coding=utf-8
# person_in_charge: samuel.geniaut at edf.fr


# ======================================================================
# COPYRIGHT (C) 1991 - 2016  EDF R&D                  WWW.CODE-ASTER.ORG
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

from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PVARCPR  = InputParameter(phys=PHY.VARI_R)


PCOMPOR  = InputParameter(phys=PHY.COMPOR)


PCONTRR  = InputParameter(phys=PHY.SIEF_R)


PVARIPR  = InputParameter(phys=PHY.VARI_R)


PBASLOR  = InputParameter(phys=PHY.NEUT_R)


PPINTTO  = InputParameter(phys=PHY.N132_R)


PCNSETO  = InputParameter(phys=PHY.N1280I, container='MODL!.TOPOSE.CNS',
comment="""  XFEM - CONNECTIVITE DES SOUS-ELEMENTS  """)


PHEAVTO  = InputParameter(phys=PHY.N512_I)


PHEA_NO  = InputParameter(phys=PHY.N120_I)


PLONCHA  = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
comment="""  XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS  """)


PLSN     = InputParameter(phys=PHY.NEUT_R)


PLST     = InputParameter(phys=PHY.NEUT_R)


PPINTER  = InputParameter(phys=PHY.N816_R)


PAINTER  = InputParameter(phys=PHY.N1360R)


PCFACE   = InputParameter(phys=PHY.N720_I)


PLONGCO  = InputParameter(phys=PHY.N120_I)


PPMILTO  = InputParameter(phys=PHY.N792_R)


PBASECO  = InputParameter(phys=PHY.N2448R)

PSTANO   = InputParameter(phys=PHY.N120_I)

CALC_G_F = Option(
    para_in=(
        SP.PACCELE,
           PAINTER,
           PBASECO,
           PBASLOR,
           PCFACE,
           PCNSETO,
           PCOMPOR,
        SP.PCONTGR,
           PCONTRR,
        SP.PCOURB,
        SP.PDEFOPL,
        SP.PDEPINR,
        SP.PDEPLAR,
        SP.PEPSINF,
        SP.PFF1D2D,
        SP.PFF2D3D,
        SP.PFFVOLU,
        SP.PGEOMER,
           PHEAVTO,
           PHEA_NO,
           PLONCHA,
           PLONGCO,
           PLSN,
           PLST,
        SP.PMATERC,
        SP.PPESANR,
           PPINTER,
           PPINTTO,
           PPMILTO,
        SP.PPRESSF,
        SP.PROTATR,
        SP.PSIGINR,
        SP.PSIGISE,
        SP.PTEMPSR,
        SP.PTHETAR,
           PVARCPR,
        SP.PVARCRR,
           PVARIPR,
        SP.PVITESS,
           PSTANO,
    ),
    para_out=(
        SP.PGTHETA,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'-1'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.ABSO,'OUI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.DISCRET,'OUI'),)),
    ),
)
