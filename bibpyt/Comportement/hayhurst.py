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
    nom            = 'HAYHURST',
    doc            = """Modele viscoplastique couple a l'endommagement isotrope de Kachanov."""  ,
    num_lc         = 32,
    nb_vari        = 12,
    nom_vari       = ('EPSPXX','EPSPYY','EPSPZZ','EPSPXY','EPSPXZ',
        'EPSPYZ','EPSPEQ','H1','H2','PHI',
        'ENDO','VIDE',),
    mc_mater       = ('ELAS','HAYHURST',),
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GDEF_LOG',),
    algo_inte      = ('NEWTON','RUNGE_KUTTA','NEWTON_PERT',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
)
