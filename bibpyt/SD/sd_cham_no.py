#@ MODIF sd_cham_no SD  DATE 09/05/2007   AUTEUR PELLET J.PELLET 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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

from SD import *
from SD.sd_titre import sd_titre

from SD.sd_nume_equa import sd_nume_equa


class sd_cham_no(sd_titre):
#------------------------------------
    nomj = SDNom(fin=19)
    VALE = AsObject(genr='V', ltyp=Parmi(4,8,16,24), type=Parmi('C', 'I', 'K', 'R'), xous='S', docu=Parmi('', '2', '3'), )
    REFE = AsVK24()
    DESC = AsVI(docu='CHNO', )


    def exists(self):
        # retourne "vrai" si la SD semble exister (et donc qu'elle peut etre v�rifi�e)
        return self.REFE.exists

    # indirection vers PROF_CHNO/NUME_EQUA :
    def check_cham_no_i_REFE(self, checker):
        if not self.exists() : return
        lnom = self.REFE.get()

        # faut-il v�rifier le sd_maillage de chaque sd_cham_no ?   AJACOT_PB
        #  - cela risque de couter cher
        #  - cela pose un probl�me "import circulaire" avec sd_maillage -> sd_cham_no => import ici
        #  - cela pose un probl�me de boucle infinie : sd_maillage -> sd_cham_no -> sd_maillage -> ...
        #from SD.sd_maillage import sd_maillage
        #sd2 = sd_maillage(lnom[0]) ; sd2.check(checker)

        # j'aurai pr�f�r� : sd_prof_chno que sd_nume_equa (mais sslv111b !) AJACOT_PB :
        if lnom[1].strip() :
            sd2 = sd_nume_equa(lnom[1]) ; sd2.check(checker)


