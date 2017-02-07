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
# person_in_charge: sylvie.michel-ponnelle at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'JOINT_BA',
    doc            = """Relation de comportement locale en 2D décrivant le phénomène de la liaison acier - béton pour les structures en béton armé.
   Elle permet de rendre compte de l'influence de la liaison dans la redistribution des contraintes dans le corps du béton ainsi que la prédiction des fissures et leur espacement.
   Disponible pour des chargements en monotone et en cyclique, elle prend en compte les effets du frottement des fissures, et du confinement.
   Une seule variable d'endommagement scalaire est utilisée (cf. [R7.01.21] pour plus de détails)."""  ,
    num_lc         = 13,
    nb_vari        = 6,
    nom_vari       = ('ENDONOR','ENDOTAN','ECRISOM1','ECRISOM2','GLIS',
        'ECROCINE',),
    mc_mater       = ('ELAS','JOINT_BA',),
    modelisation   = ('AXIS','PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('NEWTON_1D',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
)
