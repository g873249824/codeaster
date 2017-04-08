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
# person_in_charge: harinaivo.andriambololona at edf.fr


from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


def proj_base_prod(self,MATR_ASSE_GENE,VECT_ASSE_GENE,
                   RESU_GENE, NUME_DDL_GENE,
                   STOCKAGE,**args ):
  if NUME_DDL_GENE is not None and NUME_DDL_GENE.is_typco():
      self.type_sdprod(NUME_DDL_GENE, nume_ddl_gene)
  if MATR_ASSE_GENE != None:
    for m in MATR_ASSE_GENE:
      self.type_sdprod(m['MATRICE'],matr_asse_gene_r)
  if VECT_ASSE_GENE != None:
    for v in VECT_ASSE_GENE:
      self.type_sdprod(v['VECTEUR'],vect_asse_gene)
  if RESU_GENE != None:
    for v in RESU_GENE:
      self.type_sdprod(v['RESULTAT'],tran_gene)
  return None

PROJ_BASE=MACRO(nom="PROJ_BASE",
                op=OPS('Macro.proj_base_ops.proj_base_ops'),
                regles=(AU_MOINS_UN('MATR_ASSE_GENE','VECT_ASSE_GENE','RESU_GENE')),
                sd_prod=proj_base_prod,
         fr=tr("Projection des matrices et/ou vecteurs assembles sur une base (modale ou de RITZ)"),
         BASE            =SIMP(statut='o',typ=(mode_meca,mode_gene) ),
         NB_VECT         =SIMP(statut='f',typ='I'),
         STOCKAGE        =SIMP(statut='f',typ='TXM',defaut="PLEIN",into=("PLEIN","DIAG") ),
         NUME_DDL_GENE   =SIMP(statut='f',typ=(nume_ddl_gene,CO),defaut=None),
         MATR_ASSE_GENE  =FACT(statut='f',max='**',
           MATRICE         =SIMP(statut='o',typ=CO,),
           regles=(UN_PARMI('MATR_ASSE','MATR_ASSE_GENE',),),
           MATR_ASSE       =SIMP(statut='f',typ=matr_asse_depl_r),
           MATR_ASSE_GENE  =SIMP(statut='f',typ=matr_asse_gene_r),
         ),
         VECT_ASSE_GENE  =FACT(statut='f',max='**',
           VECTEUR         =SIMP(statut='o',typ=CO,),
           regles=(UN_PARMI('VECT_ASSE','VECT_ASSE_GENE',),),
           TYPE_VECT       =SIMP(statut='f',typ='TXM',defaut="FORC"),
           VECT_ASSE       =SIMP(statut='f',typ=cham_no_sdaster),
           VECT_ASSE_GENE  =SIMP(statut='f',typ=vect_asse_gene),
         ),
         RESU_GENE  =FACT(statut='f',max='**',
           RESULTAT        =SIMP(statut='o',typ=CO,),
           TYPE_VECT       =SIMP(statut='f',typ='TXM',defaut="FORC"),
           RESU            =SIMP(statut='o',typ=dyna_trans),
         ),
         INFO            =SIMP(statut='f',typ='I',defaut=1,into=(1,2)),
)  ;
