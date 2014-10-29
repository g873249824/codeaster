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
# person_in_charge: sylvie.granet at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom='LIQU_GAZ',
    doc="""Loi de comportement pour un milieu poreux non saturé liquide/gaz sans changement de phase
   (Cf. [R7.01.11] pour plus de détails).""",
    num_lc=9999,
    nb_vari=2,
    nom_vari=('LIQGAZ1', 'LIQGAZ2'),
    mc_mater = ('THM_LIQ', 'THM_GAZ'),
    modelisation = ('KIT_HH', 'KIT_HHM', 'KIT_HM',
                    'KIT_THHM', 'KIT_THH', 'KIT_THM', 'KIT_THV'),
    deformation = ('PETIT', 'PETIT_REAC', 'GROT_GDEP'),
    nom_varc = ('TEMP'),
    algo_inte = 'SANS_OBJET',
    type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
    proprietes = ' ',
)
