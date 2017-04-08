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


IMPR_JEVEUX=PROC(nom="IMPR_JEVEUX",op=16,
                 fr=tr("Imprimer le contenu des objets créés par JEVEUX (pour développeur)"),
         ENTITE          =SIMP(fr=tr("choix de l'observation"),statut='o',typ='TXM',
                               into=("DISQUE","MEMOIRE","REPERTOIRE",    
                                     "OBJET","ATTRIBUT","SYSTEME","ENREGISTREMENT") ),
         b_objet      =BLOC(condition = """(equal_to("ENTITE", 'OBJET'))""",
            NOMOBJ          =SIMP(fr=tr("nom d'objet"),statut='f',typ='TXM' ),  
            NUMOC           =SIMP(fr=tr("numéro d objet de collection"),statut='f',typ='I' ),  
            NOMOC           =SIMP(fr=tr("nom d'objet de collection"),statut='f',typ='TXM' ),  
         ),
         b_attribut   =BLOC(condition = """(equal_to("ENTITE", 'ATTRIBUT'))""",
            NOMOBJ          =SIMP(fr=tr("nom de collection"),statut='f',typ='TXM' ),  
            NOMATR          =SIMP(fr=tr("nom d attribut de collection"),statut='f',typ='TXM',
                                  into=('$$DESO','$$IADD','$$IADM','$$NOM','$$LONG',
                                      '$$LONO','$$LUTI','$$NUM') ),
         ),
         b_systeme    =BLOC(condition = """(equal_to("ENTITE", 'SYSTEME'))""",
            CLASSE          =SIMP(statut='o',typ='TXM',into=('G','V') ),  
            NOMATR          =SIMP(fr=tr("nom d attribut systeme"),statut='f',typ='TXM',   
                                  into=('$$CARA','$$IADD','$$GENR','$$TYPE','$$MARQ',
                                      '$$DOCU','$$ORIG','$$RNOM','$$LTYP','$$LONG',
                                      '$$LONO','$$DATE','$$LUTI','$$HCOD','$$INDX',
                                      '$$TLEC','$$TECR','$$IADM','$$ACCE','$$USADI') ),
         ),
         b_repertoire =BLOC(condition = """(equal_to("ENTITE", 'REPERTOIRE'))""",
            CLASSE          =SIMP(statut='f',typ='TXM',into=('G','V',' '),defaut=' '),  
         ),
         b_disque     =BLOC(condition = """(equal_to("ENTITE", 'DISQUE'))""",
            CLASSE          =SIMP(statut='f',typ='TXM' ,into=('G','V',' '),defaut=' '),  
         ),
         b_enregist   =BLOC(condition = """(equal_to("ENTITE", 'ENREGISTREMENT'))""",
            CLASSE          =SIMP(statut='f',typ='TXM' ,into=('G','V'),defaut='G'),  
            NUMERO          =SIMP(statut='o',typ='I',val_min=1),  
            INFO            =SIMP(statut='f',typ='I',into=(1,2),defaut=1),  
         ),
         IMPRESSION      =FACT(statut='f',
           NOM             =SIMP(statut='f',typ='TXM' ),  
           UNITE           =SIMP(statut='f',typ=UnitType(), inout='out'),  
         ),
         COMMENTAIRE     =SIMP(statut='f',typ='TXM' ),  
)  ;
