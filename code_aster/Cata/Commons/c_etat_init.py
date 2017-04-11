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


def C_ETAT_INIT( COMMAND, statut ) :  #COMMUN#

    kwargs = {}

    kwargs['DEPL']           = SIMP(statut='f',typ=cham_no_sdaster)
    kwargs['SIGM']           = SIMP(statut='f',typ=(cham_elem,carte_sdaster))
    kwargs['VARI']           = SIMP(statut='f',typ=cham_elem)
    kwargs['STRX']           = SIMP(statut='f',typ=cham_elem)

    if COMMAND == 'STAT_NON_LINE':
        kwargs['COHE']      = SIMP(statut='f',typ=cham_elem)

    if COMMAND == 'DYNA_NON_LINE':
        kwargs['VITE']       = SIMP(statut='f',typ=cham_no_sdaster)
        kwargs['ACCE']       = SIMP(statut='f',typ=cham_no_sdaster)

    kwargs['EVOL_NOLI']      = SIMP(statut='f',typ=evol_noli)
    kwargs['NUME_ORDRE']     = SIMP(statut='f',typ='I')
    kwargs['INST']           = SIMP(statut='f',typ='R')
    kwargs['NUME_DIDI']      = SIMP(statut='f',typ='I')
    kwargs['INST_ETAT_INIT'] = SIMP(statut='f',typ='R')
    kwargs['CRITERE']        = SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU"))

    if COMMAND == 'DYNA_NON_LINE':
        mcfact = FACT(statut=statut,max='**',
                  regles=(AU_MOINS_UN('EVOL_NOLI','ACCE','VITE','DEPL','SIGM','VARI',),
                          EXCLUS('NUME_ORDRE','INST'), ),
                  b_prec_rela=BLOC(condition="""(equal_to("CRITERE", 'RELATIF'))""",
                                   PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
                  b_prec_abso=BLOC(condition="""(equal_to("CRITERE", 'ABSOLU'))""",
                                   PRECISION       =SIMP(statut='o',typ='R',),),
                    **kwargs
                 )
    else:
        mcfact = FACT(statut=statut,max='**',
                  regles=(AU_MOINS_UN('EVOL_NOLI','DEPL','SIGM','VARI','COHE',),
                          EXCLUS('NUME_ORDRE','INST'), ),
                  b_prec_rela=BLOC(condition="""(equal_to("CRITERE", 'RELATIF'))""",
                                   PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
                  b_prec_abso=BLOC(condition="""(equal_to("CRITERE", 'ABSOLU'))""",
                                   PRECISION       =SIMP(statut='o',typ='R',),),
                    **kwargs
                 )

    return mcfact
