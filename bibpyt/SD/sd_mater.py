#@ MODIF sd_mater SD  DATE 19/06/2007   AUTEUR PELLET J.PELLET 
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

from SD.sd_fonction import sd_fonction



class sd_mater_RDEP(AsBase):
#---------------------------
    # on dirait une fonction, mais c'est plutot la concat�nation de plusieurs fonctions
    nomj = SDNom(fin=8)
    PROL = AsVK16()
    VALE = AsVR()


class sd_compor1(AsBase):
#-----------------------
    nomj = SDNom(fin=19)
    VALC = AsVC(SDNom(debut=19), )
    VALK = AsVK8(SDNom(debut=19), )
    VALR = AsVR(SDNom(debut=19), )


    # parfois, THER_NL cr�e une sd_fonction pour BETA
    def check_compor1_i_VALK(self, checker):
        nom= self.nomj().strip()
        valk=list(self.VALK.get())
        if not valk : return
        if nom[8:16]=='.THER_NL' :
           k=valk.index('BETA    ')
           nomfon=valk[2*k+1]
           sd2=sd_fonction(nomfon) ; sd2.check(checker)


class sd_mater(AsBase):
#----------------------
    nomj = SDNom(fin=8)
    NOMRC = AsVK16(SDNom(nomj='.MATERIAU.NOMRC'), )
    rdep = Facultatif(sd_mater_RDEP(SDNom(nomj='.&&RDEP')))

    # existence possible de la SD :
    def exists(self):
        return self.NOMRC.exists

    # indirection vers les sd_compor1 de NOMRC :
    def check_mater_i_NOMRC(self, checker):
        lnom = self.NOMRC.get()
        if not lnom: return
        for nom in lnom:
            if not nom.strip(): continue
            nomc1=self.nomj()[:8]+'.'+nom
            comp1 = sd_compor1(nomc1)

            # parfois, comp1 est vide. AJACOT_PB : ssls115g/DEFI_COQU_MULT
            if comp1.VALK.get() : comp1.check(checker)

