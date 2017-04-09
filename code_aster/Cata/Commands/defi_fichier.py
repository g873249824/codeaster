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
# person_in_charge: j-pierre.lefebvre at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


def DEFIC_prod(self,ACTION,UNITE,**args):
  if ACTION == "ASSOCIER" or ACTION == "RESERVER":
    if UNITE != None :
      return
    else :
      return entier
  elif ACTION == "LIBERER"  :
    return
  else :
    raise AsException("ACTION non prevue : %s" % ACTION)

DEFI_FICHIER=MACRO(nom="DEFI_FICHIER",
                   op=OPS("code_aster.Cata.ops.build_DEFI_FICHIER"),
                   sd_prod=DEFIC_prod,
                   reentrant='n',
                   fr=tr("Ouvre ou ferme un fichier associé à un numéro d'unité logique"),

            ACTION        =SIMP(statut='f',typ='TXM',into=("ASSOCIER","LIBERER","RESERVER"),defaut="ASSOCIER"),

            b_associer    =BLOC(condition = """equal_to("ACTION", 'ASSOCIER')""",
                                fr=tr("Paramètres pour l'ouverture du fichier"),
                                regles=(AU_MOINS_UN('FICHIER','UNITE'),),
               UNITE      =SIMP(statut='f',typ=UnitType() ,val_min=1, inout='out'),
               FICHIER    =SIMP(statut='f',typ='TXM',validators=LongStr(1,255)),
               TYPE       =SIMP(statut='f',typ='TXM',into=("ASCII","BINARY","LIBRE"),defaut="ASCII"),

               b_type_ascii  =BLOC(condition = """equal_to("TYPE", 'ASCII')""",fr=tr("Paramètres pour le type ASCII"),
                  ACCES      =SIMP(statut='f',typ='TXM',into=("NEW","APPEND","OLD"),defaut="NEW"),
               ),
               b_type_autre  =BLOC(condition = """not equal_to("TYPE", 'ASCII')""",fr=tr("Paramètres pour les types BINARY et LIBRE"),
                  ACCES      =SIMP(statut='f',typ='TXM',into=("NEW","OLD"),defaut="NEW"),
               ),
            ),

            b_reserver    =BLOC(condition = """equal_to("ACTION", 'RESERVER')""",
                                fr=tr("Paramètres pour la réservation de l'unité du fichier"),
                                regles=(AU_MOINS_UN('FICHIER','UNITE'),),
               UNITE      =SIMP(statut='f',typ=UnitType() ,val_min=1, inout='out'),
               FICHIER    =SIMP(statut='f',typ='TXM',validators=LongStr(1,255)),
               TYPE       =SIMP(statut='f',typ='TXM',into=("ASCII",),defaut="ASCII"),
               ACCES      =SIMP(statut='f',typ='TXM',into=("APPEND",),defaut="APPEND"),
            ),

            b_liberer    =BLOC(condition = """equal_to("ACTION", 'LIBERER')""",
                               fr=tr("Paramètres pour la fermeture du fichier"),
                               regles=(UN_PARMI('FICHIER','UNITE'),),
                  UNITE     =SIMP(statut='f',typ=UnitType() ,val_min=1, inout='out'),
                  FICHIER   =SIMP(statut='f',typ='TXM',validators=LongStr(1,255)),
           ),

           INFO          =SIMP(statut='f',typ='I',into=(1,2) ),
           )
