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
# person_in_charge: mathieu.courtois at edf.fr


from .Syntax import ASSD


class resultat_sdaster(ASSD):
   cata_sdj = "SD.sd_resultat.sd_resultat"

   def LIST_CHAMPS (self) :
      if not self.accessible():
         raise Accas.AsException("Erreur dans resultat.LIST_CHAMPS en PAR_LOT='OUI'")
      return aster.GetResu(self.get_name(), "CHAMPS")

   def LIST_NOM_CMP (self) :
      if not self.accessible():
         raise Accas.AsException("Erreur dans resultat.LIST_NOM_CMP en PAR_LOT='OUI'")
      return aster.GetResu(self.get_name(), "COMPOSANTES")

   def LIST_VARI_ACCES (self) :
      if not self.accessible():
         raise Accas.AsException("Erreur dans resultat.LIST_VARI_ACCES en PAR_LOT='OUI'")
      return aster.GetResu(self.get_name(), "VARI_ACCES")

   def LIST_PARA (self) :
      if not self.accessible():
         raise Accas.AsException("Erreur dans resultat.LIST_PARA en PAR_LOT='OUI'")
      return aster.GetResu(self.get_name(), "PARAMETRES")


class comb_fourier(resultat_sdaster): pass
class fourier_elas(resultat_sdaster): pass
class fourier_ther(resultat_sdaster): pass
class mult_elas(resultat_sdaster): pass
class mode_empi(resultat_sdaster): pass

# resultat_sdaster/evol_sdaster :
class evol_sdaster(resultat_sdaster): pass
class evol_char(evol_sdaster): pass
class evol_elas(evol_sdaster): pass
class evol_noli(evol_sdaster): pass
class evol_ther(evol_sdaster): pass
class evol_varc(evol_sdaster): pass
