# coding=utf-8
# person_in_charge: sofiane.hendili at edf.fr


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




PPHASIN  = InputParameter(phys=PHY.VARI_R, container='RESU!META_ELNO!N',
comment="""  PPHASIN : PHASES METALLURGIQUES """)


DURT_ELNO = Option(
    para_in=(
        SP.PMATERC,
           PPHASIN,
    ),
    para_out=(
        SP.PDURT_R,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'TH'),(AT.BORD,'0'),)),
    ),
    comment="""  DURT_ELNO : CALCUL DE DURETE AUX NOEUDS
           A PARTIR DES PHASES METALLURGIQUES """,
)
