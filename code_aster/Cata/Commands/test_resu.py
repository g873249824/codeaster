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
#
#
# ======================================================================
# person_in_charge: mathieu.courtois at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


TEST_RESU=PROC(nom="TEST_RESU",op=23,
         fr=tr("Extraction d'une valeur d'une structure de donnée et comparaison à une valeur de référence"),
         regles=(AU_MOINS_UN('CHAM_NO','CHAM_ELEM','CARTE','RESU','GENE','OBJET','TEST_NAN','MAILLAGE')),

         CHAM_NO         =FACT(statut='f',max='**',
           regles=(EXCLUS('NOEUD','GROUP_NO'),  # EXCLUS avec 'TYPE_TEST' dans trchno.f
                   PRESENT_PRESENT('NOEUD','NOM_CMP'),
                   PRESENT_PRESENT( 'GROUP_NO','NOM_CMP'),),
           CHAM_GD         =SIMP(statut='o',typ=cham_no_sdaster),
           NOEUD           =SIMP(statut='c',typ=no   ),
           GROUP_NO        =SIMP(statut='f',typ=grno ),
           NOM_CMP         =SIMP(statut='f',typ='TXM',max=1),
           **C_TEST_REFERENCE('CHAM_NO', max='**')
         ),

         CARTE      =FACT(statut='f',max='**',
           regles=(UN_PARMI('MAILLE','GROUP_MA'),),
           CHAM_GD         =SIMP(statut='o',typ=carte_sdaster),
           GROUP_MA        =SIMP(statut='f',typ=grma),
           MAILLE          =SIMP(statut='c',typ=ma),
           NOM_CMP         =SIMP(statut='o',typ='TXM',max=1),
           **C_TEST_REFERENCE('CARTE', max=1)
         ),

         CHAM_ELEM       =FACT(statut='f',max='**',
           regles=(#UN_PARMI('MAILLE' ou 'GROUP_MA','TYPE_TEST',) dans trchel.f
                   EXCLUS('MAILLE','GROUP_MA'),
                   EXCLUS('NOEUD','GROUP_NO','POINT'),
                   PRESENT_PRESENT('NOEUD','NOM_CMP'),
                   PRESENT_PRESENT('GROUP_NO','NOM_CMP'),
                   PRESENT_PRESENT('POINT','NOM_CMP'),),
           CHAM_GD         =SIMP(statut='o',typ=cham_elem),
           GROUP_MA        =SIMP(statut='f',typ=grma),
           MAILLE          =SIMP(statut='c',typ=ma),
           POINT           =SIMP(statut='f',typ='I' ),
           SOUS_POINT      =SIMP(statut='f',typ='I'),
           NOEUD           =SIMP(statut='c',typ=no),
           GROUP_NO        =SIMP(statut='f',typ=grno),
           NOM_CMP         =SIMP(statut='f',typ='TXM',max=1),
           **C_TEST_REFERENCE('CHAM_ELEM', max='**')
         ),

         RESU            =FACT(statut='f',max='**',
           regles=(UN_PARMI('NUME_ORDRE','INST','FREQ','NUME_MODE','NOEUD_CMP','NOM_CAS','ANGLE'),
                   UN_PARMI('NOM_CHAM','PARA'),
                   PRESENT_ABSENT('PARA','MAILLE','GROUP_MA','NOEUD','GROUP_NO','POINT','NOM_CMP','NOM_VARI'),
                   EXCLUS('NOEUD','GROUP_NO','POINT'),  # EXCLUS avec 'TYPE_TEST' dans trresu.f
                   EXCLUS('MAILLE','GROUP_MA'),
                   EXCLUS('NOM_CMP','NOM_VARI'),
                   ),
           RESULTAT        =SIMP(statut='o',typ=resultat_sdaster),
           NUME_ORDRE      =SIMP(statut='f',typ='I'),
           INST            =SIMP(statut='f',typ='R'),
           FREQ            =SIMP(statut='f',typ='R'),
           NUME_MODE       =SIMP(statut='f',typ='I'),
           NOEUD_CMP       =SIMP(statut='f',typ='TXM',min=2,max=2),
           NOM_CAS         =SIMP(statut='f',typ='TXM'),
           ANGLE           =SIMP(statut='f',typ='R'),
           PARA            =SIMP(statut='f',typ='TXM'),
           NOM_CHAM        =SIMP(statut='f',typ='TXM',validators=NoRepeat(),into=C_NOM_CHAM_INTO()),
           NOM_CMP         =SIMP(statut='f',typ='TXM',max=1),
           NOM_VARI        =SIMP(statut='f',typ='TXM',max=1),
           GROUP_MA        =SIMP(statut='f',typ=grma),
           MAILLE          =SIMP(statut='c',typ=ma),
           NOEUD           =SIMP(statut='c',typ=no   ,max='**'),
           GROUP_NO        =SIMP(statut='f',typ=grno ,max='**'),
           POINT           =SIMP(statut='f',typ='I'),
           SOUS_POINT      =SIMP(statut='f',typ='I'),
           **C_TEST_REFERENCE('RESU', max='**')
         ),

         GENE            =FACT(statut='f',max='**',
           RESU_GENE       =SIMP(statut='o',typ=(vect_asse_gene, tran_gene, mode_gene, harm_gene)),
           b_vect_asse     =BLOC(condition = """is_type("RESU_GENE") == vect_asse_gene""",
             NUME_CMP_GENE   =SIMP(statut='o',typ='I'),
           ),
           b_mode          =BLOC(condition = """is_type("RESU_GENE") == mode_gene""",
                            regles=(UN_PARMI('NUME_ORDRE','FREQ','NUME_MODE'),
                                    UN_PARMI('NOM_CHAM','PARA'),
                                    PRESENT_PRESENT('NOM_CHAM','NUME_CMP_GENE'),),
             NOM_CHAM        =SIMP(statut='f',typ='TXM',validators=NoRepeat(),into=C_NOM_CHAM_INTO()),
             NUME_CMP_GENE   =SIMP(statut='f',typ='I'),
             PARA            =SIMP(statut='f',typ='TXM'),
             NUME_ORDRE      =SIMP(statut='f',typ='I'),
             NUME_MODE       =SIMP(statut='f',typ='I'),
             FREQ            =SIMP(statut='f',typ='R'),
           ),
           b_harm          =BLOC(condition = """is_type("RESU_GENE") == harm_gene""",
                            regles=(UN_PARMI('NUME_ORDRE','FREQ') ,),
             NOM_CHAM        =SIMP(statut='o',typ='TXM',validators=NoRepeat(),into=C_NOM_CHAM_INTO()),
             NUME_CMP_GENE   =SIMP(statut='o',typ='I'),
             NUME_ORDRE      =SIMP(statut='f',typ='I'),
             FREQ            =SIMP(statut='f',typ='R'),
           ),
           b_tran          =BLOC(condition = """is_type("RESU_GENE") == tran_gene""",
                            regles=(UN_PARMI('NUME_ORDRE','INST') ,),
             NOM_CHAM        =SIMP(statut='o',typ='TXM',validators=NoRepeat(),into=C_NOM_CHAM_INTO()),
             NUME_CMP_GENE   =SIMP(statut='o',typ='I'),
             NUME_ORDRE      =SIMP(statut='f',typ='I'),
             INST            =SIMP(statut='f',typ='R'),
           ),
           **C_TEST_REFERENCE('GENE', max='**')
         ),

         OBJET           =FACT(statut='f',max='**',
           NOM             =SIMP(statut='o',typ='TXM'),
           **C_TEST_REFERENCE('OBJET', max=1)
         ),

         MAILLAGE        =FACT(statut='f',max='**',
           MAILLAGE        =SIMP(statut='o',typ=maillage_sdaster),
           CARA            =SIMP(statut='o',typ='TXM',max=1,
                                 into=('NB_MAILLE','NB_NOEUD','NB_GROUP_MA','NB_GROUP_NO','NB_MA_GROUP_MA','NB_NO_GROUP_NO',)),
           NOM_GROUP_MA    =SIMP(statut='f',typ=grma,max=1),
           NOM_GROUP_NO    =SIMP(statut='f',typ=grno,max=1),

           **C_TEST_REFERENCE('MAILLAGE', max=1)
         ),

         TEST_NAN        =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON") ),
)
