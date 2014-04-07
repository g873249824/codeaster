# coding=utf-8
# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

from SD import *

from SD.sd_ligrel import sd_ligrel
from SD.sd_carte import sd_carte
from SD.sd_char_cine import sd_char_cine


class sd_char_gf_xx(AsBase):
    nomj = SDNom(fin=19)
    VALE = AsVR()
    NCMP = AsVK8()


class sd_char_grflu(AsBase):
    nomj = SDNom(fin=19)

    ABSC = AsVR()
    APPL = AsVI()
    GEOM = AsVR()
    LIMA = AsVI()
    LINO = AsVI()
    NOMA = AsVK8()
    VDIR = AsVR()


class sd_char_chme(AsBase):
    nomj = SDNom(fin=13)

    MODEL_NOMO = AsVK8(SDNom(nomj='.MODEL.NOMO'), lonmax=1, )

    LIGRE = Facultatif(sd_ligrel())

    CIMPO = Facultatif(sd_carte())
    CMULT = Facultatif(sd_carte())
    EPSIN = Facultatif(sd_carte())
    F1D1D = Facultatif(sd_carte())
    F1D2D = Facultatif(sd_carte())
    F1D3D = Facultatif(sd_carte())
    F2D2D = Facultatif(sd_carte())
    F2D3D = Facultatif(sd_carte())
    F3D3D = Facultatif(sd_carte())
    FCO2D = Facultatif(sd_carte())
    FCO3D = Facultatif(sd_carte())
    FELEC = Facultatif(sd_carte())
    FL101 = Facultatif(sd_carte())
    FL102 = Facultatif(sd_carte())
    FLUX  = Facultatif(sd_carte())
    FORNO = Facultatif(sd_carte())
    IMPE  = Facultatif(sd_carte())
    ONDE  = Facultatif(sd_carte())
    PESAN = Facultatif(sd_carte())
    PRESS = Facultatif(sd_carte())
    PREFF = Facultatif(sd_carte())
    ROTAT = Facultatif(sd_carte())
    SIGIN = Facultatif(sd_carte())
    SIINT = Facultatif(sd_carte())
    VNOR  = Facultatif(sd_carte())
    ONDPL = Facultatif(sd_carte())
    ONDPR = Facultatif(sd_carte())
    EFOND = Facultatif(sd_carte())

    VEASS = Facultatif(AsVK8(lonmax=1, ))
    VEISS = Facultatif(AsVK8(lonmax=6, ))
    EVOL_CHAR  = Facultatif(AsVK8(SDNom(nomj='.EVOL.CHAR'), lonmax=1, ))
    TEMPE_TEMP = Facultatif(AsVK8(SDNom(nomj='.TEMPE.TEMP'), lonmax=1, ))

    RCLIN = Facultatif(AsColl(stockage='DISPERSE',modelong='VARIABLE', type='I', ))
    RCNOM = Facultatif(AsColl(stockage='CONTIG',modelong='CONSTANT', type='K', ))
    RCTYR = Facultatif(AsVK8(SDNom(nomj='.RCTYR'),))
    NMATA = Facultatif(AsVI(SDNom(nomj='.NMATA'),))

class sd_char_meca(AsBase):
    nomj = SDNom(fin=8)

    TYPE            = AsVK8(lonmax=1)

    CHME = Facultatif(sd_char_chme())
    ELIM = Facultatif(sd_char_cine())

    TRANS01 = Facultatif(AsVR(lonmax=6, ))
    TRANS02 = Facultatif(AsVR(lonmax=6, ))
    LISMA01 = Facultatif(AsVI(lonmax=12, ))
    LISMA02 = Facultatif(AsVI(lonmax=12, ))
    POIDS_MAILLE = Facultatif(AsVR())
