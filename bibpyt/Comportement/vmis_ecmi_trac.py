# coding=utf-8
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
# person_in_charge: jean-michel.proix at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom='VMIS_ECMI_TRAC',
    doc="""Relation de comportement d'élasto-plasticité de VON MISES à écrouissage combiné,
   cinématique linéaire et isotrope non linéaire (Cf. [R5.03.16] pour plus de détails).
   L'écrouissage isotrope est donné par une courbe de traction ou éventuellement par plusieurs courbes
   si celles ci dépendent de la température.""",
    num_lc=3,
    nb_vari=8,
    nom_vari=('EPSPEQ', 'INDIPLAS', 'XCINXX',
              'XCINYY', 'XCINZZ', 'XCINXY', 'XCINXZ', 'XCINYZ'),
    mc_mater = ('ELAS', 'TRACTION', 'PRAGER'),
    modelisation = ('3D', 'AXIS', 'C_PLAN', 'D_PLAN'),
    deformation = ('PETIT', 'PETIT_REAC',
                   'GROT_GDEP', 'GDEF_LOG'),
    nom_varc = ('TEMP',),
    algo_inte = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
    proprietes = None,
)
