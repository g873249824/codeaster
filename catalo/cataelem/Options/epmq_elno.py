

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




PDEFORR  = InputParameter(phys=PHY.EPSI_R, container='RESU!EPME_ELNO!N',
comment="""  PDEFORR : DEFORMATIONS MECANIQUES PAR ELEMENT AUX NOEUDS """)


PDEFOEQ  = OutputParameter(phys=PHY.EPSI_R, type='ELNO',
comment="""  PDEFOEQ : DEFORMATIONS MECANIQUES EQUIVALENTES PAR ELEMENT AUX NOEUDS """)


EPMQ_ELNO = Option(
    para_in=(
           PDEFORR,
    ),
    para_out=(
           PDEFOEQ,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
    ),
    comment="""  EPMQ_ELNO : DEFORMATIONS MECANIQUES EQUIVALENTES PAR ELEMENT AUX NOEUDS """,
)
