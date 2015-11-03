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

from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PVARCPR  = InputParameter(phys=PHY.VARI_R,
comment="""  PVARCPR : VARIABLES DE COMMANDE  """)


PCAORIE  = InputParameter(phys=PHY.CAORIE, container='CARA!.CARORIEN',
comment="""  PCAORIE : ORIENTATION LOCALE D'UN ELEMENT DE POUTRE OU DE TUYAU  """)


PCOMPOR  = InputParameter(phys=PHY.COMPOR)


CHAR_MECA_SECH_R = Option(
    para_in=(
        SP.PCAGNBA,
        SP.PCAGNPO,
        SP.PCAMASS,
           PCAORIE,
           PCOMPOR,
        SP.PGEOMER,
        SP.PMATERC,
        SP.PTEMPSR,
           PVARCPR,
        SP.PVARCRR,
    ),
    para_out=(
        SP.PVECTUR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.INTERFACE,'OUI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'3FL'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'2FL'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'AXF'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'3FI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'AFI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'PFI'),)),
    ),
    comment=""" CHAR_MECA_SECH_R: (MOT-CLE : SECH_CALCULEE): CALCUL DU SECOND
           MEMBRE ELEMENTAIRE CORRESPONDANT AU CHAMP DE SECHAGE """,
)
