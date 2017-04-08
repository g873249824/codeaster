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
# person_in_charge: hassan.berro at edf.fr

from .Syntax import ASSD
from .co_resultat_sdaster import resultat_sdaster


class dyna_gene(ASSD):
    cata_sdj = "SD.sd_dyna_gene.sd_dyna_gene"

class dyna_phys(resultat_sdaster):
    cata_sdj="SD.sd_dyna_phys.sd_dyna_phys"

# Concepts generalises
class harm_gene  (dyna_gene) :
    def LIST_ARCH (self):
        """
        Returns a python list of all archived frequencies
        """
        if not self.accessible():
            raise Accas.AsException("Erreur dans harm_gene.LIST_ARCH() en PAR_LOT='OUI'")

        disc = self.sdj.DISC.get()
        return list(disc)

class tran_gene  (dyna_gene) :
    # Private methods
    def __nb_nonl (self):
        desc = self.sdj.DESC.get()
        nbnoli = desc[2]
        return nbnoli
    def __nb_modes (self):
        desc = self.sdj.DESC.get()
        nbmodes = desc[1]
        return nbmodes
    def __check_input_inoli(self, inoli):
        if (inoli==-1) :
            print "Nonlinearity index not specified, by default the first nonlinearity will be considered."
            inoli = 1
        nbnoli = self.__nb_nonl()
        if nbnoli == 0 :
            raise Accas.AsException("Linear calculation, no information can be retrieved.")
        if( inoli <= 0) or (inoli > nbnoli):
            raise Accas.AsException("The nonlinearity index should be a comprised between 1 and %d, the total number of nonlinearities."%(nbnoli))
        return inoli
    def __type_nonl (self):
        Int2StrTypes = {1 : 'DIS_CHOC',
                        2 : 'FLAMBAGE',
                        3 : 'ANTI_SISM',
                        4 : 'DIS_VISC',
                        5 : 'DIS_ECRO_TRAC',
                        6 : 'ROTOR_FISS',
                        7 : 'COUPLAGE_EDYOS',
                        8 : 'RELA_EFFO_DEPL',
                        9 : 'RELA_EFFO_VITE'}

        nltypes = self.sdj.sd_nl.TYPE.get()
        return [Int2StrTypes[nltypes[i]] for i in range(len(nltypes))]
    def __print_vint_description(self, inoli):
        nltype = self.__type_nonl()[inoli-1].strip()
        vintDescription = {'DIS_CHOC'      : ['F_NORMAL', 'F_TANGE1', 'F_TANGE1',
                                              'DXLOC_N1', 'DYLOC_N1', 'DZLOC_N1',
                                              'DXLOC_N2', 'DYLOC_N2', 'DZLOC_N2',
                                              'V_NORMAL', 'V_TANGE1', 'V_TANGE1',
                                              'IND_ADHE', 'VINT_FR1', 'VINT_FR2',
                                              'VINT_FR3', 'VINT_FR4', 'VINT_FR5',
                                              'VINT_FR6', 'VINT_FR7'],
                           'FLAMBAGE'      : ['F_NORMAL',
                                              'DXLOC_N1', 'DYLOC_N1', 'DZLOC_N1',
                                              'DXLOC_N2', 'DYLOC_N2', 'DZLOC_N2',
                                              'V_NORMAL', 'DEF_PLAS'],
                           'ANTI_SISM'     : ['F_AXIAL',
                                              'DXLOC_N1', 'DYLOC_N1', 'DZLOC_N1',
                                              'DXLOC_N2', 'DYLOC_N2', 'DZLOC_N2',
                                              'V_NORMAL'],
                           'DIS_VISC'      : ['DXLOC_N1', 'DYLOC_N1', 'DZLOC_N1',
                                              'DXLOC_N2', 'DYLOC_N2', 'DZLOC_N2',
                                              'V_AXIALE', 'F_AXIALE', 'V_AXIALE',
                                              'D_AXIALE', 'PUISSANC'],
                           'DIS_ECRO_TRAC' : ['DXLOC_N1', 'DYLOC_N1', 'DZLOC_N1',
                                              'DXLOC_N2', 'DYLOC_N2', 'DZLOC_N2',
                                              'V_AXIALE', 'F_AXIALE', 'V_AXIALE',
                                              'D_AXIALE', 'PUISSANC', 'IP      '],
                           'ROTOR_FISS'    : ['PHI_DEGR', 'F_TANGE1', 'F_TANGE2'],
                           'COUPLAGE_EDYOS': [],
                           'RELA_EFFO_DEPL': ['DCMP_N1 ', 'FCMP_LOC', 'IND_NONZ'] ,
                           'RELA_EFFO_VITE': ['VCMP_N1 ', 'FCMP_LOC', 'IND_NONZ']  }
        print "\n" + "-"*104
        print "Information regarding the saved internal variables for %s non linearity (index=%d)"%(nltype, inoli)
        print "-"*104
        vintDesc = [v.center(10) for v in vintDescription[nltype]]
        indices  = [str(i+1).center(10) for i in range(len(vintDesc))]
        sep = " | "

        nblines = len(indices)/8
        if 8*nblines<len(indices) : nblines = nblines + 1
        for i in range(nblines-1):
            print sep.join(indices [i*8:(i+1)*8])
            print sep.join(vintDesc[i*8:(i+1)*8])
            print "-"*104
        print sep.join(indices [8*(nblines-1):])
        print sep.join(vintDesc[8*(nblines-1):])
        print "-"*104
        return vintDesc

    # Public Methods
    def LIST_ARCH (self):
        """
        Returns a python list of all archived instants
        """
        if not self.accessible():
            raise Accas.AsException("Erreur dans tran_gene.LIST_ARCH() en PAR_LOT='OUI'")

        disc = self.sdj.DISC.get()
        return list(disc)

    def LIST_PAS_TEMPS (self):
        """
        Returns a python list of the integration steps
        """
        if not self.accessible():
            raise Accas.AsException("Erreur dans tran_gene.PTEM() en PAR_LOT='OUI'")

        step = self.sdj.PTEM.get()
        return list(step)

    def DEPL (self):
        """
        Returns a 2D numpy array of the calculated modal displacements
        """
        if not self.accessible():
            raise Accas.AsException("Erreur dans tran_gene.DEPL() en PAR_LOT='OUI'")

        depl = self.sdj.DEPL.get()
        nbmodes = self.__nb_modes()
        nbsaves = len(depl)/nbmodes
        import numpy as np
        output = np.reshape(depl,(nbsaves,nbmodes))
        return output

    def VITE (self):
        """
        Returns a 2D numpy array of the calculated modal velocities
        """
        if not self.accessible():
            raise Accas.AsException("Erreur dans tran_gene.VITE() en PAR_LOT='OUI'")

        vite = self.sdj.VITE.get()
        nbmodes = self.__nb_modes()
        nbsaves = len(vite)/nbmodes
        import numpy as np
        output = np.reshape(vite,(nbsaves,nbmodes))
        return output

    def ACCE (self):
        """
        Returns a 2D numpy array of the calculated modal accelerations
        """
        if not self.accessible():
            raise Accas.AsException("Erreur dans tran_gene.ACCE() en PAR_LOT='OUI'")

        acce = self.sdj.ACCE.get()
        nbmodes = self.__nb_modes()
        nbsaves = len(acce)/nbmodes
        import numpy as np
        output = np.reshape(acce,(nbsaves,nbmodes))
        return output

    def INFO_NONL(self):
        """
        Prints out information about the considered non linearities, returns a 2D python list (list in list) with
        the retrieved information"""

        if not self.accessible():
            raise Accas.AsException("Erreur dans tran_gene.INFO_NONL() en PAR_LOT='OUI'")

        nbnoli  = self.__nb_nonl()
        if nbnoli == 0 :
            print "Linear calculation, no nonlinearities used or can be printed."
            return None

        nltypes = self.__type_nonl()
        inti    = self.sdj.sd_nl.INTI.get()

        print "-"*104
        print "%sInformation regarding the considered non linearities"%(' '*15)
        print "-"*104
        #      12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
        #      ooo-----ooo+++++++++++++++++ooo---------ooo+++++++++ooo---------ooo+++++++++ooo-------------------------
        print " |  IND  |       TYPE        |    NO1    |    NO2    |   SST1    |    SST2   |           TITLE          |"
        print "-"*104
        Output =[None]*nbnoli
        for i in range(nbnoli):
            title, no1, no2, sst1, sst2 = inti[i*5:i*5+5]
            if len( no2.strip()) == 0 : no2  = '-'
            if len(sst1.strip()) == 0 : sst1 = '-'
            if len(sst2.strip()) == 0 : sst2 = '-'
            title = title.strip().center(25)
            no1   = no1.strip().center(9)
            no2   = no2.strip().center(9)
            sst1  = sst1.strip().center(9)
            sst2  = sst2.strip().center(9)
            sep = ' | '
            print "%s%s%s%s%s%s%s%s%s%s%s%s%s%s"%(sep,str(i+1).center(5),sep,nltypes[i].center(17),sep,no1,sep,no2,sep,sst1,sep,sst2,sep,title)
            add = [nltypes[i]]+list(inti[(i-1)*5:(i-1)*5+5])
            Output[i] = add
        print "-"*104
        return Output

    def VARI_INTERNE (self, inoli=-1, describe=True):
        """
        Returns a 2D numpy array of all internal variables for a given non linearity of index <inoli>

        Output ARRAY : -----------------------------------------
                      | VINT1    VINT2    VINT3    ...  VINTn
               -------------------------------------------------
              | INST1 |
              | INST2 |
              | INST3 |
                ...
              | INSTn |
               -------------------------------------------------

        ARRAY[I,J] => Instant I, Internal Variable J
                      Use python's convention for indices, they range from 0 -> n-1



        ex. Print the internal variables for the first nonlinearity (index 1) calculated at
            the final (last archived) instant
         ----------------------------------------
        | ARRAY = RESUGENE.VARI_INTERNE(1)
        | print ARRAY[-1,:]
         ----------------------------------------

        ex. Print the time evolution of the third internal variable for the first nonlinearity
         ----------------------------------------
        | ARRAY = RESUGENE.VARI_INTERNE(1)
        | print ARRAY[:,(3-1)]
         ----------------------------------------
        """
        if not self.accessible():
            raise Accas.AsException("Erreur dans tran_gene.VARI_INTERNE() en PAR_LOT='OUI'")

        inoli = self.__check_input_inoli(inoli)
        i = inoli-1

        vindx  = self.sdj.sd_nl.VIND.get()
        nbvint = vindx[-1]-1    # number of internal variables saved for all nonlinearities : record length of VINT

        vint    = self.sdj.sd_nl.VINT.get()
        nbsaves = len(vint)/nbvint

        start  = vindx[i  ]-1
        finish = vindx[i+1]-1
        outputLength = (finish-start)*nbsaves

        cntr = 0
        output = [0.]*outputLength
        for iord in range(nbsaves):
            for i in range(start, finish):
                output[cntr] = vint[iord*(nbvint)+i]
                cntr += 1

        import numpy as np
        output = np.reshape(output,(nbsaves, finish-start))

        if describe : dummy = self.__print_vint_description(inoli)

        return output

    def FORCE_NORMALE (self, inoli=-1):
        """
        Returns a 1D numpy array giving the evolution of the normal force at the archived instants"""

        if not self.accessible():
            raise Accas.AsException("Erreur dans tran_gene.FORCE_NORMALE() en PAR_LOT='OUI'")

        inoli = self.__check_input_inoli(inoli)

        nltypes = self.__type_nonl()
        if not(nltypes[inoli-1] in ('DIS_CHOC', 'FLAMBAGE')) :
            dummy = self.INFO_NONL()
            raise Accas.AsException("The chosen nonlinearity index (%d) does not correspond to a DIS_CHOC or FLAMBAGE nonlinearity\nThese are the only nonlinearities that save the local normal force."%(inoli))


        vint = self.VARI_INTERNE(inoli, describe=False)
        #The normal force is saved in the first position (ind=0) of the internal variables for DIS_CHOC and FLAMBAGE nonlinearities
        return vint[:,0]

    def FORCE_TANGENTIELLE (self, inoli=-1):
        """
        Returns a 2D numpy array (2 x nbsaves - 2 : for tangential axes 1 and 2)
        The evolution of the tangential forces at the archived instants"""

        if not self.accessible():
            raise Accas.AsException("Erreur dans tran_gene.FORCE_TANGENTIELLE() en PAR_LOT='OUI'")

        inoli = self.__check_input_inoli(inoli)

        nltypes = self.__type_nonl()
        if not(nltypes[inoli-1] in ('DIS_CHOC', 'ROTOR_FISS')) :
            dummy = self.INFO_NONL()
            raise Accas.AsException("The chosen nonlinearity index (%d) does not correspond to a DIS_CHOC or ROTOR_FISS nonlinearity\nThese are the only nonlinearities that calculate and save a local tangential force."%(inoli))


        vint = self.VARI_INTERNE(inoli, describe=False)

        #The tangential forces are saved in positions 2 and 3 of the internal variables for DIS_CHOC nonlinearities
        if nltypes[inoli-1] == 'DIS_CHOC': return vint[:,1:3]

        #The tangential forces are saved in positions 2 and 3 of the internal variables for ROTOR_FISS nonlinearities
        if nltypes[inoli-1] == 'ROTOR_FISS': return vint[:,1:3]

    def FORCE_AXIALE (self, inoli=-1):
        """
        Returns a 1D numpy array giving the evolution of the axial force at the archived instants"""

        if not self.accessible():
            raise Accas.AsException("Erreur dans tran_gene.FORCE_AXIALE() en PAR_LOT='OUI'")

        inoli = self.__check_input_inoli(inoli)

        nltypes = self.__type_nonl()
        if not(nltypes[inoli-1] in ('ANTI_SISM', 'DIS_VISC', 'DIS_ECRO_TRAC' )) :
            dummy = self.INFO_NONL()
            raise Accas.AsException("The chosen nonlinearity index (%d) does not correspond to a ANTI_SISM, DIS_VISC, or DIS_ECRO_TRAC' nonlinearity\nThese are the only nonlinearities that calculate and save an axial force."%(inoli))


        vint = self.VARI_INTERNE(inoli, describe=False)

        #The axial forces are saved in position 1  for ANTI_SISM nonlinearities
        if nltypes[inoli-1] == 'ANTI_SISM' : return vint[:,0]

        #The axial forces are saved in position 8 for DIS_VISC and DIS_ECRO_TRAC nonlinearities
        return vint[:,7]

    def FORCE_RELATION (self, inoli=-1):
        """
        Returns a 1D numpy array giving the evolution of the forces defined as displacement or velocity relationships"""

        if not self.accessible():
            raise Accas.AsException("Erreur dans tran_gene.FORCE_RELATION() en PAR_LOT='OUI'")

        inoli = self.__check_input_inoli(inoli)

        nltypes = self.__type_nonl()
        if not(nltypes[inoli-1] in ('RELA_EFFO_DEPL', 'RELA_EFFO_VITE')) :
            dummy = self.INFO_NONL()
            raise Accas.AsException("The chosen nonlinearity index (%d) does not correspond to a RELA_EFFO_DEPL or RELA_EFFO_VITE' nonlinearity\nThese are the only nonlinearities that calculate and save a relationship defined force."%(inoli))


        vint = self.VARI_INTERNE(inoli, describe=False)

        #The relationship defined forces are saved in position 2  for RELA_EFFO_DEPL and RELA_EFFO_VITE nonlinearities
        return vint[:,1]

# Concepts physiques
class acou_harmo (dyna_phys) : pass
class dyna_harmo (dyna_phys) : pass
class dyna_trans (dyna_phys) : pass
class mode_acou  (dyna_phys) : pass
class mode_flamb (dyna_phys) : pass
class mode_meca  (dyna_phys) : pass
class mode_meca_c(mode_meca) : pass

# TODO : convertir mode_gene en format generalise
class mode_gene  (dyna_phys) : pass
