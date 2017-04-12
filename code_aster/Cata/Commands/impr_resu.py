# coding=utf-8
# ======================================================================
# COPYRIGHT (C) 1991 - 2017 EDF R&D                  WWW.CODE-ASTER.ORG
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
# person_in_charge: nicolas.sellenet at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


IMPR_RESU=PROC(nom="IMPR_RESU",op=39,
               fr=tr("Imprimer un maillage et/ou les résultats d'un calcul (différents formats)"),

         FORMAT          =SIMP(statut='f',typ='TXM',defaut="MED",
                                 into=("RESULTAT","IDEAS","ASTER","MED","GMSH") ),

         PROC0           =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON") ),

         b_modele =BLOC(condition="""not equal_to("FORMAT", 'MED')""",fr=tr("Modèle"),
           MODELE          =SIMP(statut='f',typ=modele_sdaster),
         ),

         b_format_resultat  =BLOC(condition="""equal_to("FORMAT", 'RESULTAT')""",fr=tr("unité logique d'impression au format RESULTAT"),
           UNITE           =SIMP(statut='f',typ=UnitType(),defaut=8, inout='out'),
         ),

         b_format_ideas  =BLOC(condition="""equal_to("FORMAT", 'IDEAS')""",fr=tr("unité logique d'impression et version IDEAS"),
           UNITE           =SIMP(statut='f',typ=UnitType(),defaut=30, inout='out'),
           VERSION         =SIMP(statut='f',typ='I',defaut=5,into=(4,5)),
         ),

         b_format_aster  =BLOC(condition="""equal_to("FORMAT", 'ASTER')""",fr=tr("unité logique d'impression au format ASTER"),
           UNITE           =SIMP(statut='f',typ=UnitType(),defaut=26, inout='out'),
         ),

         b_format_med  =BLOC(condition="""equal_to("FORMAT", 'MED')""",fr=tr("unité logique d'impression au format MED"),
           UNITE           =SIMP(statut='f',typ=UnitType(),defaut=80, inout='out'),
         ),

         b_format_gmsh  =BLOC(condition="""equal_to("FORMAT", 'GMSH')""",fr=tr("unité logique d'impression et version GMSH"),
           UNITE           =SIMP(statut='f',typ=UnitType(),defaut=37, inout='out'),
           VERSION         =SIMP(statut='f',typ='R',defaut=1.2,into=(1.0,1.2)),
         ),

         CONCEPT          =FACT(statut='f',max='**',
           fr=tr('Pour imprimer les champs de "données" à des fins de visualisation (controle des affectations).'),
           # (valide pour les format RESULTAT et MED)
           regles=(UN_PARMI('CHAM_MATER','CARA_ELEM','CHARGE'),),
           CHAM_MATER      =SIMP(statut='f',typ=cham_mater),
           CARA_ELEM       =SIMP(statut='f',typ=cara_elem),
           CHARGE          =SIMP(statut='f',typ=char_meca),

           b_cara_elem        =BLOC(condition="""exists("CARA_ELEM")""", fr=tr("impression des repères locaux."),
              REPERE_LOCAL    =SIMP(statut='f',typ='TXM',defaut="NON",into=("NON","ELEM", "ELNO")),
              b_reploc        =BLOC(condition="""not equal_to("REPERE_LOCAL", 'NON')""", fr=tr("impression des repères locaux."),
                 MODELE          =SIMP(statut='o',typ=modele_sdaster),
              ),
           ),
         ), # end fkw_concept

         b_fmt_med = BLOC(condition="""equal_to("FORMAT", 'MED')""",
            RESU            =FACT(statut='f',max='**',

              regles=(AU_MOINS_UN('CHAM_GD','RESULTAT','MAILLAGE',),
                      EXCLUS('CHAM_GD','RESULTAT'),
                      EXCLUS('TOUT_CMP','NOM_CMP'),),
              MAILLAGE        =SIMP(statut='f',typ=(maillage_sdaster,squelette)),
              CARA_ELEM       =SIMP(statut='f',typ=cara_elem),
              CHAM_GD         =SIMP(statut='f',typ=cham_gd_sdaster),
              RESULTAT        =SIMP(statut='f',typ=resultat_sdaster),
              INFO_MAILLAGE   =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON") ),

              b_partie        =BLOC(condition="""(is_type("RESULTAT") in (dyna_harmo, acou_harmo) or is_type("CHAM_GD") != carte_sdaster)""",
                PARTIE          =SIMP(statut='f',typ='TXM',into=("REEL","IMAG") ),
              ),
              IMPR_NOM_VARI=SIMP(statut='f',typ='TXM',into=("OUI","NON"),defaut="OUI",),

              b_extrac        =BLOC(condition="""exists("RESULTAT")""",
                                    fr=tr("extraction d un champ de grandeur"),
                regles=(EXCLUS('TOUT_CHAM','NOM_CHAM'),
                        EXCLUS('TOUT_ORDRE','NUME_ORDRE','INST','FREQ','NUME_MODE','NOEUD_CMP',
                               'LIST_INST','LIST_FREQ','LIST_ORDRE','NOM_CAS','ANGLE'),),
                TOUT_CHAM       =SIMP(statut='f',typ='TXM',into=("OUI","NON") ),
                NOM_CHAM        =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**',into=C_NOM_CHAM_INTO()),

                TOUT_ORDRE      =SIMP(statut='f',typ='TXM',into=("OUI",) ),
                NUME_ORDRE      =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
                NUME_MODE       =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
                LIST_ORDRE      =SIMP(statut='f',typ=listis_sdaster),
                NOEUD_CMP       =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**'),
                NOM_CAS         =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**'),
                ANGLE           =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
                FREQ            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
                LIST_FREQ       =SIMP(statut='f',typ=listr8_sdaster),
                INST            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
                LIST_INST       =SIMP(statut='f',typ=listr8_sdaster),

                b_acce_reel     =BLOC(condition="""(exists("ANGLE"))or(exists("FREQ"))or(exists("LIST_FREQ"))or(exists("INST"))or(exists("LIST_INST"))""",
                   CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU",),),
                   b_prec_rela=BLOC(condition="""(equal_to("CRITERE", 'RELATIF'))""",
                        PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
                   b_prec_abso=BLOC(condition="""(equal_to("CRITERE", 'ABSOLU'))""",
                        PRECISION       =SIMP(statut='o',typ='R',),),
                ),
              ),
   ###
              b_param         =BLOC(condition="""(exists("RESULTAT"))""",
                NOM_PARA        =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**'),
              ),
   ###
              TOUT_CMP        =SIMP(statut='f',typ='TXM',into=("OUI",) ),
              NOM_CMP         =SIMP(statut='f',typ='TXM',max='**'),
   ###
              b_med=BLOC(condition="""(exists("CHAM_GD") or exists("RESULTAT"))""",
                                   fr=tr("renommage du champ"),
                regles=(EXCLUS('NOM_CHAM_MED','NOM_RESU_MED'),),
                NOM_CHAM_MED    =SIMP(statut='f',typ='TXM',
                                      validators=AndVal((LongStr(1,64), NoRepeat())), max='**'),
                NOM_RESU_MED    =SIMP(statut='f',typ='TXM'),
              ),
   ###
              TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
              NOEUD           =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
              GROUP_NO        =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
              MAILLE          =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
              GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),

              SOUS_TITRE      =SIMP(statut='f',typ='TXM'),
            ), # end fkw_resu
         ), # end b_fmt_med

         b_fmt_resultat = BLOC(condition="""equal_to("FORMAT", 'RESULTAT')""",
            RESU            =FACT(statut='f',max='**',

              regles=(AU_MOINS_UN('CHAM_GD','RESULTAT','MAILLAGE',),
                      EXCLUS('CHAM_GD','RESULTAT'),
                      EXCLUS('TOUT_PARA','NOM_PARA'),
                      EXCLUS('TOUT_CMP','NOM_CMP'),),
              MAILLAGE        =SIMP(statut='f',typ=(maillage_sdaster,squelette)),
              CARA_ELEM       =SIMP(statut='f',typ=cara_elem),
              CHAM_GD         =SIMP(statut='f',typ=cham_gd_sdaster),
              RESULTAT        =SIMP(statut='f',typ=resultat_sdaster),
              b_extrac        =BLOC(condition="""exists("RESULTAT")""",
                                    fr=tr("extraction d un champ de grandeur"),
                regles=(EXCLUS('TOUT_CHAM','NOM_CHAM'),
                        EXCLUS('TOUT_ORDRE','NUME_ORDRE','INST','FREQ','NUME_MODE','NOEUD_CMP',
                               'LIST_INST','LIST_FREQ','LIST_ORDRE','NOM_CAS','ANGLE'),),
                TOUT_CHAM       =SIMP(statut='f',typ='TXM',into=("OUI","NON") ),
                NOM_CHAM        =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**',into=C_NOM_CHAM_INTO()),

                TOUT_ORDRE      =SIMP(statut='f',typ='TXM',into=("OUI",) ),
                NUME_ORDRE      =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
                NUME_MODE       =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
                LIST_ORDRE      =SIMP(statut='f',typ=listis_sdaster),
                NOEUD_CMP       =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**'),
                NOM_CAS         =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**'),
                ANGLE           =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
                FREQ            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
                LIST_FREQ       =SIMP(statut='f',typ=listr8_sdaster),
                INST            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
                LIST_INST       =SIMP(statut='f',typ=listr8_sdaster),

                b_acce_reel     =BLOC(condition="""(exists("ANGLE"))or(exists("FREQ"))or(exists("LIST_FREQ"))or(exists("INST"))or(exists("LIST_INST"))""",
                   CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU",),),
                   b_prec_rela=BLOC(condition="""(equal_to("CRITERE", 'RELATIF'))""",
                        PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
                   b_prec_abso=BLOC(condition="""(equal_to("CRITERE", 'ABSOLU'))""",
                        PRECISION       =SIMP(statut='o',typ='R',),),
                ),
              ),
              TOUT_PARA       =SIMP(statut='f',typ='TXM',into=("OUI","NON",) ),
              NOM_PARA        =SIMP(statut='f',typ='TXM',max='**'),
              FORM_TABL       =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON","EXCEL") ),
              TOUT_CMP        =SIMP(statut='f',typ='TXM',into=("OUI",) ),
              NOM_CMP         =SIMP(statut='f',typ='TXM',max='**'),

              b_topologie=BLOC(condition="""(exists("CHAM_GD") or exists("RESULTAT"))""",
                                   fr=tr("sélection des entités topologiques"),
                TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
                NOEUD           =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
                GROUP_NO        =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
                MAILLE          =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
                GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
              ),
              VALE_MAX        =SIMP(statut='f',typ='TXM',into=("OUI",) ),
              VALE_MIN        =SIMP(statut='f',typ='TXM',into=("OUI",) ),
              BORNE_SUP       =SIMP(statut='f',typ='R'),
              BORNE_INF       =SIMP(statut='f',typ='R'),
              IMPR_COOR       =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON") ),
              FORMAT_R        =SIMP(statut='f',typ='TXM',defaut="1PE21.14"),
              SOUS_TITRE      =SIMP(statut='f',typ='TXM'),
            ), # end fkw_resu
         ), # end b_fmt_resultat

         b_fmt_gmsh = BLOC(condition="""equal_to("FORMAT", 'GMSH')""",
            RESU            =FACT(statut='f',max='**',

              regles=(AU_MOINS_UN('CHAM_GD','RESULTAT','MAILLAGE',),
                      EXCLUS('CHAM_GD','RESULTAT'),),
              MAILLAGE        =SIMP(statut='f',typ=(maillage_sdaster,squelette)),
              CARA_ELEM       =SIMP(statut='f',typ=cara_elem),
              CHAM_GD         =SIMP(statut='f',typ=cham_gd_sdaster),
              RESULTAT        =SIMP(statut='f',typ=resultat_sdaster),
              PARTIE          =SIMP(statut='f',typ='TXM',into=("REEL","IMAG") ),
              b_extrac        =BLOC(condition="""exists("RESULTAT")""",
                                    fr=tr("extraction d un champ de grandeur"),
                regles=(EXCLUS('TOUT_CHAM','NOM_CHAM'),
                        EXCLUS('TOUT_ORDRE','NUME_ORDRE','INST','FREQ','NUME_MODE','NOEUD_CMP',
                               'LIST_INST','LIST_FREQ','LIST_ORDRE','NOM_CAS','ANGLE'),),
                TOUT_CHAM       =SIMP(statut='f',typ='TXM',into=("OUI","NON") ),
                NOM_CHAM        =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**',into=C_NOM_CHAM_INTO()),

                TOUT_ORDRE      =SIMP(statut='f',typ='TXM',into=("OUI",) ),
                NUME_ORDRE      =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
                NUME_MODE       =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
                LIST_ORDRE      =SIMP(statut='f',typ=listis_sdaster),
                NOEUD_CMP       =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**'),
                NOM_CAS         =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**'),
                ANGLE           =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
                FREQ            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
                LIST_FREQ       =SIMP(statut='f',typ=listr8_sdaster),
                INST            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
                LIST_INST       =SIMP(statut='f',typ=listr8_sdaster),

                b_acce_reel     =BLOC(condition="""(exists("ANGLE"))or(exists("FREQ"))or(exists("LIST_FREQ"))or(exists("INST"))or(exists("LIST_INST"))""",
                   CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU",),),
                   b_prec_rela=BLOC(condition="""(equal_to("CRITERE", 'RELATIF'))""",
                        PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
                   b_prec_abso=BLOC(condition="""(equal_to("CRITERE", 'ABSOLU'))""",
                        PRECISION       =SIMP(statut='o',typ='R',),),
                ),
              ),
              MAILLE          =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
              GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
              TYPE_CHAM       =SIMP(statut='f',typ='TXM',defaut="SCALAIRE",
                                    into=("VECT_2D","VECT_3D","SCALAIRE","TENS_2D","TENS_3D"),),
              b_scal          =BLOC(condition = """equal_to("TYPE_CHAM", 'SCALAIRE')""",
               NOM_CMP         =SIMP(statut='f',typ='TXM',max='**' ),),
              b_vect_2d       =BLOC(condition = """equal_to("TYPE_CHAM", 'VECT_2D')""",
               NOM_CMP         =SIMP(statut='o',typ='TXM',min=2,max=2 ),),
              b_vect_3d       =BLOC(condition = """equal_to("TYPE_CHAM", 'VECT_3D')""",
               NOM_CMP         =SIMP(statut='o',typ='TXM',min=3,max=3 ),),
              b_tens_2d       =BLOC(condition = """equal_to("TYPE_CHAM", 'TENS_2D')""",
               NOM_CMP         =SIMP(statut='o',typ='TXM',min=4,max=4 ),),
              b_tens_3d       =BLOC(condition = """equal_to("TYPE_CHAM", 'TENS_3D')""",
               NOM_CMP         =SIMP(statut='o',typ='TXM',min=6,max=6 ),),

              SOUS_TITRE      =SIMP(statut='f',typ='TXM'),
            ), # end fkw_resu
         ), # end b_fmt_gmsh

         b_fmt_ideas = BLOC(condition="""equal_to("FORMAT", 'IDEAS')""",
            RESU            =FACT(statut='f',max='**',

              regles=(AU_MOINS_UN('CHAM_GD','RESULTAT','MAILLAGE',),
                      EXCLUS('CHAM_GD','RESULTAT'),
                      EXCLUS('TOUT_CMP','NOM_CMP'),),
              MAILLAGE        =SIMP(statut='f',typ=(maillage_sdaster,squelette)),
              CARA_ELEM       =SIMP(statut='f',typ=cara_elem),
              CHAM_GD         =SIMP(statut='f',typ=cham_gd_sdaster),
              RESULTAT        =SIMP(statut='f',typ=resultat_sdaster),
              TOUT_CMP        =SIMP(statut='f',typ='TXM',into=("OUI",) ),
              NOM_CMP         =SIMP(statut='f',typ='TXM',max='**'),

              b_extrac        =BLOC(condition="""exists("RESULTAT")""",
                                    fr=tr("extraction d un champ de grandeur"),
                regles=(EXCLUS('TOUT_CHAM','NOM_CHAM'),
                        EXCLUS('TOUT_ORDRE','NUME_ORDRE','INST','FREQ','NUME_MODE','NOEUD_CMP',
                               'LIST_INST','LIST_FREQ','LIST_ORDRE','NOM_CAS','ANGLE'),),
                TOUT_CHAM       =SIMP(statut='f',typ='TXM',into=("OUI","NON") ),
                NOM_CHAM        =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**',into=C_NOM_CHAM_INTO()),

                TOUT_ORDRE      =SIMP(statut='f',typ='TXM',into=("OUI",) ),
                NUME_ORDRE      =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
                NUME_MODE       =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
                LIST_ORDRE      =SIMP(statut='f',typ=listis_sdaster),
                NOEUD_CMP       =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**'),
                NOM_CAS         =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**'),
                ANGLE           =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
                FREQ            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
                LIST_FREQ       =SIMP(statut='f',typ=listr8_sdaster),
                INST            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
                LIST_INST       =SIMP(statut='f',typ=listr8_sdaster),

                b_acce_reel     =BLOC(condition="""(exists("ANGLE"))or(exists("FREQ"))or(exists("LIST_FREQ"))or(exists("INST"))or(exists("LIST_INST"))""",
                   CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU",),),
                   b_prec_rela=BLOC(condition="""(equal_to("CRITERE", 'RELATIF'))""",
                        PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
                   b_prec_abso=BLOC(condition="""(equal_to("CRITERE", 'ABSOLU'))""",
                        PRECISION       =SIMP(statut='o',typ='R',),),
                ),
              ),
              b_topologie=BLOC(condition="""(exists("CHAM_GD") or exists("RESULTAT"))""",
                                   fr=tr("sélection des entités topologiques"),
                TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
                NOEUD           =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
                GROUP_NO        =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
                MAILLE          =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
                GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
              ),

              SOUS_TITRE      =SIMP(statut='f',typ='TXM'),
            ), # end fkw_resu
         ), # end b_fmt_ideas

         b_fmt_aster = BLOC(condition="""equal_to("FORMAT", 'ASTER')""",
            RESU            =FACT(statut='f',max='**',

              regles=(AU_MOINS_UN('CHAM_GD','RESULTAT','MAILLAGE',),
                      EXCLUS('CHAM_GD','RESULTAT'),),
              MAILLAGE        =SIMP(statut='f',typ=(maillage_sdaster,squelette)),
              CARA_ELEM       =SIMP(statut='f',typ=cara_elem),
              CHAM_GD         =SIMP(statut='f',typ=cham_gd_sdaster),
              RESULTAT        =SIMP(statut='f',typ=resultat_sdaster),

              b_extrac        =BLOC(condition="""exists("RESULTAT")""",
                                    fr=tr("extraction d un champ de grandeur"),
                regles=(EXCLUS('TOUT_CHAM','NOM_CHAM'),
                        EXCLUS('TOUT_ORDRE','NUME_ORDRE','INST','FREQ','NUME_MODE','NOEUD_CMP',
                               'LIST_INST','LIST_FREQ','LIST_ORDRE','NOM_CAS','ANGLE'),),
                TOUT_CHAM       =SIMP(statut='f',typ='TXM',into=("OUI","NON") ),
                NOM_CHAM        =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**',into=C_NOM_CHAM_INTO()),

                TOUT_ORDRE      =SIMP(statut='f',typ='TXM',into=("OUI",) ),
                NUME_ORDRE      =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
                NUME_MODE       =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
                LIST_ORDRE      =SIMP(statut='f',typ=listis_sdaster),
                NOEUD_CMP       =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**'),
                NOM_CAS         =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**'),
                ANGLE           =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
                FREQ            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
                LIST_FREQ       =SIMP(statut='f',typ=listr8_sdaster),
                INST            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
                LIST_INST       =SIMP(statut='f',typ=listr8_sdaster),

                b_acce_reel     =BLOC(condition="""(exists("ANGLE"))or(exists("FREQ"))or(exists("LIST_FREQ"))or(exists("INST"))or(exists("LIST_INST"))""",
                   CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU",),),
                   b_prec_rela=BLOC(condition="""(equal_to("CRITERE", 'RELATIF'))""",
                        PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
                   b_prec_abso=BLOC(condition="""(equal_to("CRITERE", 'ABSOLU'))""",
                        PRECISION       =SIMP(statut='o',typ='R',),),
                ),
              ),

              FORMAT_R        =SIMP(statut='f',typ='TXM',defaut="1PE21.14"),

              SOUS_TITRE      =SIMP(statut='f',typ='TXM'),
            ), # end fkw_resu
         ), # end b_fmt_aster

         INFO            =SIMP(statut='f',typ='I',defaut=1,into=(1,2) ),
         translation={
            "IMPR_RESU": "Set output results",
            "UNITE": "Result file location",
        
         }
) ;
