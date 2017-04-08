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
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


CALC_STABILITE=MACRO(nom="CALC_STABILITE",sd_prod=table_container,
               op=OPS('Macro.calc_stabilite_ops.calc_stabilite_ops'),
               fr=tr("post-traitement modes non-linéaires : filtre resultats et calcul de stabilité"),
               reentrant='f',

               reuse =SIMP(statut='c',typ=CO),

               MODE_NON_LINE = SIMP(statut='o',typ=table_container,max=1),
               SCHEMA_TEMPS = FACT(statut='d',max=1,
                                   SCHEMA = SIMP(statut='f',typ='TXM',into=('NEWMARK',),defaut='NEWMARK'),
                                   b_newmark= BLOC(condition="""equal_to("SCHEMA", 'NEWMARK')""",
                                                NB_INST = SIMP(statut='f',typ='I',defaut= 1000 ),
                                                ),
                                  ),
               TOLERANCE  = SIMP(statut='f',typ='R',defaut= 1.E-2 ),

               FILTRE = FACT(statut='f',max=1,regles=(UN_PARMI('NUME_ORDRE','FREQ_MIN',),),
                             NUME_ORDRE = SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
                             FREQ_MIN = SIMP(statut='f',typ='R' ),
                             b_freq_min = BLOC(condition = """exists("FREQ_MIN")""",
                                               FREQ_MAX = SIMP(statut='o',typ='R' ),
                                               PRECISION = SIMP(statut='f',typ='R',defaut= 1.E-3 ),
                                               ),
                             ),

               INFO = SIMP(statut='f',typ='I',defaut= 1,into=(1,2) ),

)  ;
