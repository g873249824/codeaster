# coding=utf-8
# ======================================================================
# COPYRIGHT (C) 1991 - 2017  EDF R&D                  WWW.CODE-ASTER.ORG
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

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'VMIS_ASYM_LINE',
    doc            =   """Relation de comportement des barres, à écrouissage isotrope, et seuils non symétrique en traction et compression"""      ,
    num_lc         = 0,
    nb_vari        = 4,
    nom_vari       = ('EPSPEQT','INDIPLAT','EPSPEQC','INDIPLAC',),
    mc_mater       = None,
    modelisation   = ('BARRE','1D',),
    deformation    = ('PETIT','PETIT_REAC',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = None,
    proprietes     = None,
    syme_matr_tang = ('Yes',),
)
