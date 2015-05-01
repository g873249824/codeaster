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
# person_in_charge: sam.cuvilliez at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom='DRUCK_PRAGER',
    doc="""Loi de Drucker_Prager, associée, pour la mécanique des sols (cf. [R7.01.16] pour plus de détails).
   On suppose toutefois que le coefficient de dilatation thermique est constant. L'écrouissage peut être linéaire ou parabolique.""",
    num_lc=16,
    nb_vari=3,
    nom_vari=('EPSPEQ', 'EPSPVOL', 'INDIPLAS'),
    mc_mater = ('ELAS', 'DRUCKER_PRAGER'),
    modelisation = ('3D', 'AXIS', 'D_PLAN', 'GRADEPSI'),
    deformation = ('PETIT', 'PETIT_REAC', 'GROT_GDEP'),
    nom_varc = ('TEMP',),
    algo_inte = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
    proprietes = None,
)
