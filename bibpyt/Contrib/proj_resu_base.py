# -*- coding: utf-8 -*-
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
# person_in_charge: albert.alarcon at edf.fr

from Cata import cata
from Cata.cata import *


PROJ_RESU_BASE=OPER(nom="PROJ_RESU_BASE",op=  79,sd_prod=tran_gene,
                    fr=tr("Projection d'une sd resultat assemblee sur une base (modale ou de RITZ)"),
                    reentrant='n',
         BASE            =SIMP(statut='o',typ=(mode_meca,mode_gene) ),
         NUME_DDL_GENE   =SIMP(statut='o',typ=nume_ddl_gene ),
         TYPE_VECT       =SIMP(statut='f',typ='TXM',defaut="FORC"),
         RESU            =SIMP(statut='o',typ=dyna_trans),
)  ;
