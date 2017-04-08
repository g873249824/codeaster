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


class melasflu_sdaster(ASSD):
    cata_sdj = "SD.sd_melasflu.sd_melasflu"


    def VITE_FLUI (self):
        """
        Returns a python list of fluid velocities under which modal paramteres have been
        successfully calculated under the defined fluid-elastic conditions"""

        if not self.accessible():
            # Method is not allowed for For PAR_LOT = 'OUI' calculations
            raise Accas.AsException("Erreur dans melas_flu.VITE_FLUIDE() en PAR_LOT='OUI'")

        vite = self.sdj.VITE.get()
        freq_obj = self.sdj.FREQ.get()

        nbv = len(vite)
        nbm = len(freq_obj)/(2*nbv)
        vite_ok = []
        for iv in range(nbv):
            freqs   = [freq_obj[2*nbm*(iv)+2*(im)] for im in range(nbm)] # Extract a list of all modes for a given fluid velocity no. iv
            calc_ok = ([freq>0 for freq in freqs].count(False)==0)       # Check that all frequencies are positive for this velocity
            if calc_ok : vite_ok.append(vite[iv])

        return vite_ok
