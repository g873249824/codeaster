#@ MODIF sd_modele SD  DATE 28/06/2011   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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

from SD.sd_ligrel    import sd_ligrel
from SD.sd_maillage  import sd_maillage
from SD.sd_prof_chno import sd_prof_chno
from SD.sd_carte     import sd_carte
from SD.sd_xfem      import sd_modele_xfem
from SD.sd_l_table   import sd_l_table



class sd_modele(AsBase):
#-----------------------------
    nomj = SDNom(fin=8)

    MODELE = sd_ligrel()
    NOEUD = Facultatif(AsVI())
    MAILLE = Facultatif(AsVI())

    # une sd_modele peut avoir une "sd_l_table" contenant des grandeurs caract�ristiques de l'�tude :
    lt = Facultatif(sd_l_table(SDNom(nomj='')))

    # Si le mod�le vient de MODI_MODELE_XFEM :
    xfem = Facultatif(sd_modele_xfem(SDNom(nomj='')))


    def check_existence(self,checker) :
        exi_liel=self.MODELE.LIEL.exists
        exi_maille=self.MAILLE.exists
        exi_noeud=self.NOEUD.exists

        # si .LIEL => .MAILLE et .NOEUD
        if exi_liel :
            assert exi_maille
            assert exi_noeud


    def check_maillage(self,checker) :
        # on est oblig� de checker le maillage pour permettre la creation de la sd_voisinage
        lgrf=self.MODELE.LGRF.get_stripped()
        sd2 = sd_maillage(lgrf[0]); sd2.check(checker)

