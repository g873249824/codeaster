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
# person_in_charge: mickael.abbas at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


def C_INCREMENT(TYPE_CMD) :   #COMMUN#
#
    assert TYPE_CMD in ('THERMIQUE','MECANIQUE',)
    kwargs = {}
    statut_liste_inst = ' '

# La liste d'instants est facultative en thermique et obligatoire en mecanique

    if TYPE_CMD in ('THERMIQUE'):
      statut_liste_inst = 'f'
    elif TYPE_CMD in ('MECANIQUE'):
      statut_liste_inst = 'o'

    kwargs['LIST_INST']         =SIMP(statut=statut_liste_inst,typ=(listr8_sdaster,list_inst))
    kwargs['NUME_INST_INIT']    =SIMP(statut='f',typ='I')
    kwargs['INST_INIT']         =SIMP(statut='f',typ='R')
    kwargs['NUME_INST_FIN']     =SIMP(statut='f',typ='I')
    kwargs['INST_FIN']          =SIMP(statut='f',typ='R')
    kwargs['PRECISION']         =SIMP(statut='f',typ='R',defaut=1.0E-6 )

    mcfact = FACT(statut=statut_liste_inst,
                  regles=(EXCLUS('NUME_INST_INIT','INST_INIT'),
                            EXCLUS('NUME_INST_FIN','INST_FIN'),),
                  **kwargs)

    return mcfact
