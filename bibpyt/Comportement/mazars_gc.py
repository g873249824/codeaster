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
    nom            = 'MAZARS_GC',
    doc            =  """
   Loi d'endommagement isotrope élastique-fragile du béton, suivant le modèle de Mazars.
   Permet de rendre compte de l'adoucissement en compression et la fragilité en traction.
   Dans le cas des poutres multifibres :
      Distingue l'endommagement en traction et en compression. Deux variables d'endommagement scalaire
      sont utilisées pour faire la distinction entre l'endommagement de traction et de compression.
   En contrainte plane :
      Pas de couplage possible avec d'autres phénomènes tels que le fluage.
      Cette version permet de rendre mieux compte du cisaillement.
   """    ,
    num_lc         = 8,
    nb_vari        = 8,
    nom_vari       = ('CRITSIG','CRITEPS','ENDO','EPSEQT','EPSEQC',
        'RSIGMA','TEMP_MAX','DISSIP',),
    mc_mater       = ('ELAS','MAZARS',),
    modelisation   = ('1D','C_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = None,
    proprietes     = None,
    symmetry       = ('No',),
)
