#@ MODIF macr_aspic_mail_ops Macro  DATE 17/08/2004   AUTEUR DURAND C.DURAND 
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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

from math import sqrt,cos,sin,pi,pow,tan

# Ecriture du fichier GIBI principal (dgib) - ASPID0
def write_file_dgib_ASPID0(nomFichierDATG,UNITD, EPT1, DET1, D1, D2, EPT2, DET2, ZMAX, H,
                           ALPHA, JEU, EPC, DEC, XMAX, TYPMAI, THETA, TYPELE,
                           ITYPSO, DPENE, NIVMAG, loc_datg) :

# Ouverture du fichier d'entr�e de commandes
  fdgib=open(nomFichierDATG,'w')
  POIVIR = ' ;                                         \n'
  texte='****************************************************************\n'
  texte=texte+'opti echo 0 ;                                                   \n'
  texte=texte+'epT1   = '+str(EPT1)         +POIVIR
  texte=texte+'DeT1   = '+str(DET1)         +POIVIR
  texte=texte+'d1     = '+str(D1)           +POIVIR
  texte=texte+'d2     = '+str(D2)           +POIVIR
  texte=texte+'epT2   = '+str(EPT2)         +POIVIR
  texte=texte+'DeT2   = '+str(DET2)         +POIVIR
  texte=texte+'Zmax   = '+str(ZMAX)         +POIVIR
  texte=texte+'type_s = '+str(ITYPSO)       +POIVIR
  texte=texte+'d_pene = '+str(DPENE)        +POIVIR
  texte=texte+'h      = '+str(H)            +POIVIR
  texte=texte+'angl_s = '+str(ALPHA)        +POIVIR
  texte=texte+'jeu    = '+str(JEU)          +POIVIR
  texte=texte+'epC    = '+str(EPC)          +POIVIR
  texte=texte+'DeC    = '+str(DEC)          +POIVIR
  texte=texte+'Xmax   = '+str(XMAX)         +POIVIR
  texte=texte+'typmai =  MOT '+TYPMAI       +POIVIR
  texte=texte+'theta  = '+str(THETA)        +POIVIR
  texte=texte+'typele =  MOT '+TYPELE       +POIVIR
  texte=texte+'typ_eque = MOT '+'SAINE'     +POIVIR
  texte=texte+'nivmag = '+str(NIVMAG)       +POIVIR
  texte=texte+'*                                                               \n'
  texte=texte+'opti donn '
  texte=texte+"'"+loc_datg+'aspic.datg'+"';\n"
  print texte
  fdgib.write(texte)
  fdgib.close()

# Ecriture du fichier GIBI principal (dgib) - ASPID1
def write_file_dgib_ASPID1(nomFichierDATG,UNITD, EPT1, DET1, D1, D2, EPT2, DET2, ZMAX, H,
                           ALPHA, JEU, EPC, DEC, XMAX, TYPMAI,THETA,
                           A,C,EPS, RC0, NS,NC,NT,POSI, NDT,FETIRF,FETIRP,
                           TFISS,ZETA,ITYPSO,DPENE, NIVMAG, loc_datg) :

# Ouverture du fichier d'entr�e de commandes
  fdgib=open(nomFichierDATG,'w')
  POIVIR = ' ;                                         \n'
  texte='****************************************************************\n'
  texte=texte+'opti echo 0 ;                                                   \n'
  texte=texte+'epT1   = '+str(EPT1)         +POIVIR
  texte=texte+'DeT1   = '+str(DET1)         +POIVIR
  texte=texte+'d1     = '+str(D1)           +POIVIR
  texte=texte+'d2     = '+str(D2)           +POIVIR
  texte=texte+'epT2   = '+str(EPT2)         +POIVIR
  texte=texte+'DeT2   = '+str(DET2)         +POIVIR
  texte=texte+'Zmax   = '+str(ZMAX)         +POIVIR
  texte=texte+'type_s = '+str(ITYPSO)       +POIVIR
  texte=texte+'d_pene = '+str(DPENE)        +POIVIR
  texte=texte+'h      = '+str(H)            +POIVIR
  texte=texte+'angl_s = '+str(ALPHA)        +POIVIR
  texte=texte+'jeu    = '+str(JEU)          +POIVIR
  texte=texte+'epC    = '+str(EPC)          +POIVIR
  texte=texte+'DeC    = '+str(DEC)          +POIVIR
  texte=texte+'Xmax   = '+str(XMAX)         +POIVIR
  texte=texte+'typmai =  MOT '+TYPMAI       +POIVIR
  texte=texte+'theta  = '+str(THETA)        +POIVIR
  texte=texte+'a      = '+str(A)            +POIVIR
  texte=texte+'c      = '+str(C)            +POIVIR
  texte=texte+'zeta   = '+str(ZETA)         +POIVIR
  texte=texte+'eps    = '+str(EPS)          +POIVIR
  texte=texte+'rc0    = '+str(RC0)          +POIVIR
  texte=texte+'ns     = '+str(NS)           +POIVIR
  texte=texte+'nc     = '+str(NC)           +POIVIR
  texte=texte+'nt     = '+str(NT)           +POIVIR
  texte=texte+'dir_fiss = MOT '+POSI        +POIVIR
  texte=texte+'pos_fiss = MOT '+TFISS       +POIVIR
  texte=texte+'ndt    = '+str(NDT)          +POIVIR
  texte=texte+'f_etir_f = '+str(FETIRF)     +POIVIR
  texte=texte+'f_etir_p = '+str(FETIRP)     +POIVIR
  texte=texte+'typ_eque = MOT '+'FISS_LON'  +POIVIR
  texte=texte+'nivmag = '+str(NIVMAG)       +POIVIR
  texte=texte+'*                                                               \n'
  texte=texte+'opti donn '
  texte=texte+"'"+loc_datg+'aspic_v2.datg'+"';\n"
  print texte
  fdgib.write(texte)
  fdgib.close()

# Ecriture du fichier GIBI principal (dgib) - ASPID2
def write_file_dgib_ASPID2(nomFichierDATG,UNITD, EPT1, DET1, D1, D2, EPT2, DET2, ZMAX,
                           H, ALPHA, JEU, EPC, DEC, XMAX, TYPMAI,
                           THETA, A, C, EPS, RC0, RC1, RC2, RC3,
                           ALP,BETA, NS, NC, NT, POSI ,NDT,NSDT,TFISS,
                           ZETA,ITYPSO,DPENE, NIVMAG, loc_datg) :
# 
  CALPHA = cos(ALPHA*pi/180.)
  SALPHA = sin(ALPHA*pi/180.)
  CTHETA = cos(THETA*pi/180.)
  STHETA = sin(THETA*pi/180.)
#
  AOLD = A
#
  if (ITYPSO == 1) :
# PIQUAGE TYPE 1
     if (POSI == 'DROIT') :
#    PIQUAGE DROIT
        if (TFISS == 'DEB_INT') :
#       POSITION INTERNE
           SGAMMA = STHETA * (DET1/2.0)/( (DEC/2.0) -EPC)
           SGAMME = STHETA * (DET1/2.0)/( (DEC/2.0) )
           RAPPA = sqrt(1.0 - pow(SGAMMA,2))
           RAPPE = sqrt(1.0 - pow(SGAMME,2))
           AP =  A - (1.0 - RAPPA)*A  
           RAPP = (AP/EPC*RAPPE) + (1.0-(AP/EPC))*RAPPA
           XA = (DET1/2.0) * CTHETA 
           YA = (DET1/2.0) * STHETA      
           ZA = ((DEC/2.0) -EPC) * sqrt(1.0 - pow(SGAMMA,2))
           ZA0 = (DEC/2.0) - EPC
           XA0 = DET1/2.0
           XN0 = XA0
           YN0 = 0.0 
           ZN0 = ZA0 + A
           XN = XN0 * CTHETA 
           YN = XN0 * STHETA
           SGAMN = YN / ZN0
           ZN = ZN0 * sqrt(1.0 - (SGAMN*SGAMN))
           D0N0 = sqrt( pow((XA0 - XN0),2) + pow((ZA0 - ZN0),2) )
           DN = sqrt( pow((XA - XN),2) + pow((YA - YN),2) + pow((ZA - ZN),2) )
           RAPP = D0N0 / DN
           ECART = (1.0 - RAPP) * D0N0
           A = A - ECART
        elif (TFISS == 'DEB_EXT') :
#       POSITION EXTERNE
           SGAMME = STHETA * (DET1/2.0)/ (DEC/2.0) 
           RAPPE = sqrt(1.0 - pow(SGAMME,2))
           A =  A  -(1.0 - RAPPE)*A  

     elif (POSI == 'INCLINE') :
#    PIQUAGE INCLINE
        SGAMMA = STHETA * (DET1/2.0)/ ( (DEC/2.0) -EPC)
        XA = (DET1/2.0) * CTHETA 
        YA = (DET1/2.0) * STHETA     
        ZA = ((DEC/2.0) - EPC) * sqrt(1.0 - pow(SGAMMA,2))
        ZA0 = (DEC/2.0) - EPC
        ZD0 = DEC/2.0
        XA0 = DET1/2.0
        XD0 = XA0 + (tan(ALPHA*pi/180.0) * EPC)   
        A0D0 = sqrt( pow((ZD0 - ZA0),2) + pow((XD0 - XA0),2) )
        EPSIL = STHETA * tan(ALPHA*pi/180.0) 
        PHI = (EPSIL * ZA) - YA
        DELTA = pow(PHI,2) - ((1 + pow(EPSIL,2))*(pow(PHI,2) - (pow((DEC/2.0),2)*pow(EPSIL,2))))
        if (THETA > 0) :          
           YD = ( sqrt(DELTA) - PHI) / (1.0 + pow(EPSIL,2))
        else :
          YD = ( -1.0*sqrt(DELTA) - PHI) / (1.0 + pow(EPSIL,2))

        ZD = sqrt(pow((DEC/2.0),2) - pow(YD,2))  

        if ( (abs(THETA - 0.0) < 1.e-3) or ((abs(THETA - 180.0)) < 1.e-3) ) :
           XD = CTHETA * XD0
        else :
           XD = YD / tan(THETA*pi/180.0)

        AD = sqrt( pow((XA - XD),2) + pow((YA - YD),2) + pow((ZA - ZD),2) )       
        RAPP =  A0D0 / AD          

        if (TFISS == 'DEB_EXT') :       
           XN0 = XD0 - A*SALPHA 
           YN0 = 0.0 
           ZN0 = ZD0 - A*CALPHA 
           XN = XN0 * CTHETA 
           YN = XN0 * STHETA
           SGAMN = YN / ZN0
           ZN = ZN0 * sqrt(1.0 - pow(SGAMN,2))
           D0N0 = sqrt( pow((XD0 - XN0),2) + pow((ZD0 - ZN0),2) )
           DN = sqrt( pow((XD - XN),2) + pow((YD - YN),2) + pow((ZD - ZN),2) )       
           RAPP = D0N0 / DN
           ECART = (RAPP - 1.0) * D0N0
           A = A + ECART
           
        if (TFISS == 'DEB_INT') :
           XN0 = XA0 + A*SALPHA 
           YN0 = 0.0
           ZN0 = ZA0 + A*CALPHA 
           XN = XN0 * CTHETA 
           YN = XN0 * STHETA
           SGAMN = YN / ZN0
           ZN = ZN0 * sqrt(1.0 - pow(SGAMN,2))
           D0N0 = sqrt( pow((XA0 - XN0),2) + pow((ZA0 - ZN0),2) )
           DN = sqrt( pow((XA - XN),2) + pow((YA - YN),2) + pow((ZA - ZN),2) )       
           RAPP = D0N0 / DN
           ECART = (RAPP - 1.0) * D0N0
           A = A + ECART

  elif (ITYPSO == 2) :
# PIQUAGE TYPE 2
     if (POSI == 'DROIT') :
#    PIQUAGE DROIT
        SGAMMI = STHETA * ((DET1/2.0) - EPT1)/(DEC/2.0)
        XI = ((DET1/2.0) - EPT1) * CTHETA 
        YI = ((DET1/2.0) - EPT1) * STHETA
        ZI =  (DEC/2.0)  * sqrt(1.0 - pow(SGAMMI,2))
        XI0 = (DET1/2.0) -EPT1
        YI0 = 0.0 
        ZI0 = (DEC/2.0)
        
        SGAMMA = STHETA * (DET1/2.0)/((DEC/2.0) -EPC)
        YA = (DET1/2.0) * STHETA     
        ZA = ((DEC/2.0) - EPC) * sqrt(1.0 - pow(SGAMMA,2))
        TGALP = H / EPC
        EPSIL =  STHETA * TGALP
        PHI = (EPSIL * ZA) - YA
        DELTA = pow(PHI,2) - (1.0 + pow(EPSIL,2))*(pow(PHI,2) - pow((DEC/2.0),2)*pow(EPSIL,2)) 
        if (THETA > 0) :          
           YD = (sqrt(DELTA) - PHI) / (1.0 + pow(EPSIL,2))
        else :
           YD = (-1.0*sqrt(DELTA) - PHI) / (1.0 + pow(EPSIL,2))

        ZD = sqrt( pow((DEC/2.0),2) - pow(YD,2) )
        if ( (abs(THETA - 0.0) < 1.0e-3) or
             (abs(THETA - 180.0) < 1.0e-3) or
             (abs(THETA + 180.0) < 1.0e-3) or
             (abs(THETA + 90.0) < 1.0e-3) or
             (abs(THETA - 90.0) < 1.0e-3) ) :
           XD = CTHETA * ((DET1/2.0) + H)
        else :
           XD = YD / (tan(THETA*pi/180.0))

        XD0 = (DET1/2.0) + H 
        YD0 = 0.0 
        ZD0 = (DEC/2.0) 
        
        if (TFISS == 'DEB_EXT') :
           XN0 = XD0 - A
           YN0 = 0.0 
           ZN0 = ZI0 
           XN = XN0 * CTHETA 
           YN = XN0 * STHETA 
           DZID = abs(ZI - ZD) 
           DXYID = sqrt( pow((XD - XI),2) + pow((YD - YI),2) )
           DXYIN = sqrt( pow((XN - XI),2) + pow((YN - YI),2) )
           DZIN = (DXYIN * DZID) / DXYID
           ZN = ZI - DZIN         
           D0N0 = sqrt( pow((XD0 - XN0),2) + pow((ZD0 - ZN0),2) )
           DN = sqrt( pow((XD - XN),2) + pow((YD - YN),2) + pow((ZD - ZN),2) ) 
           RAPP = D0N0 / DN 
           ECART = DN - D0N0 
           A = A - ECART

        if (TFISS == 'DEB_INT') :
           XN0 = XI0 + A
           YN0 = 0.0 
           ZN0 = ZI0 
           XN = XN0 * CTHETA
           YN = XN0 * STHETA 
           SGAMN = YN / ZN0 
           ZN = ZN0 * sqrt(1.0 - pow(SGAMN,2))
           I0N0 = sqrt( pow((XI0 - XN0),2) + pow((ZI0 - ZN0),2) ) 
           IN = sqrt( pow((XI - XN),2) + pow((YI - YN),2) + pow((ZI - ZN),2) ) 
           RAPP = I0N0 / IN 
           ECART = I0N0 * ( 1.0 - RAPP ) 
           A = A - ECART
        
     elif (POSI == 'INCLINE') :
#    PIQUAGE INCLINE
        TGALPHA = SALPHA/CALPHA
        REPB = (DEC/2.0) + JEU + (EPT1*TGALPHA) 
        SGAMB = (STHETA * DET1/2.0 ) / REPB 
        CGAMB = sqrt(1.0 - pow(SGAMB,2)) 
        XB = (DET1/2.0) * CTHETA
        YB = (DET1/2.0) * STHETA
        ZB = ( (DEC/2.0) + JEU + (EPT1*TGALPHA) ) * CGAMB
        XB0 = (DET1/2.0)
        YB0 = 0.0
        ZB0 = (DEC/2.0) + JEU + (EPT1*TGALPHA)
#
        RIT1 = (DET1/2.0) - EPT1 
        REPG = (DEC/2.0) + JEU 
        SGAMG = ((STHETA ) * RIT1) / REPG
        CGAMG = sqrt(1.0 - pow(SGAMG,2))
        XG = RIT1 * CTHETA
        YG = RIT1 * STHETA
        ZG = ((DEC/2.0) + JEU) * CGAMG
        XG0 = RIT1
        YG0 = 0.0
        ZG0 = (DEC/2.0) + JEU
#
        if (TFISS == 'DEB_INT')  :
           XN0 = XG0 + A*CALPHA 
           YN0 = 0.0
           ZN0 = ZG0 + A*SALPHA 
           XN = XN0 * CTHETA 
           YN = XN0 * STHETA
           SGAMN = YN / ZN0
           ZN = ZN0 * sqrt(1.0 - pow(SGAMN,2))
           G0N0 = sqrt( pow((XG0 - XN0),2) + pow((ZG0 - ZN0),2) )
           GN = sqrt( pow((XG - XN),2) + pow((YG - YN),2) + pow((ZG - ZN),2) )
           RAPP = G0N0 / GN
           ECART = (RAPP - 1.0) * G0N0
           A = A + ECART

        if (TFISS == 'DEB_EXT') :
           XN0 = XB0 - A*CALPHA
           YN0 = 0.0
           ZN0 = ZB0 - A*SALPHA
           XN = XN0 * CTHETA
           YN = XN0 * STHETA
           SGAMN = YN / ZN0
           ZN = ZN0 * sqrt(1.0 - pow(SGAMN,2))
           B0N0 = sqrt( pow((XB0 - XN0),2) + pow((ZB0 - ZN0),2) )
           BN = sqrt( pow((XB - XN),2) + pow((YB - YN),2) + pow((ZB - ZN),2) )
           RAPP = B0N0 / BN
           ECART = (RAPP - 1.0) * B0N0
           A = A + ECART

  print ' <MACR_ASPIC_MAIL> CORRECTION PROFONDEUR DEFAUT'
  print ' PROFONDEUR SUR PIQUAGE   : ', AOLD
  print ' PROFONDEUR SUR EQUERRE   : ', A

# Ouverture du fichier d'entr�e de commandes

  fdgib=open(nomFichierDATG,'w')
  POIVIR = ' ;                                         \n'
  texte='****************************************************************\n'
  texte=texte+'opti echo 0 ;                                                   \n'
  texte=texte+'epT1   = '+str(EPT1)         +POIVIR
  texte=texte+'DeT1   = '+str(DET1)         +POIVIR
  texte=texte+'d1     = '+str(D1)           +POIVIR
  texte=texte+'d2     = '+str(D2)           +POIVIR
  texte=texte+'epT2   = '+str(EPT2)         +POIVIR
  texte=texte+'DeT2   = '+str(DET2)         +POIVIR
  texte=texte+'Zmax   = '+str(ZMAX)         +POIVIR
  texte=texte+'type_s = '+str(ITYPSO)       +POIVIR
  texte=texte+'d_pene = '+str(DPENE)        +POIVIR
  texte=texte+'h      = '+str(H)            +POIVIR
  texte=texte+'angl_s = '+str(ALPHA)        +POIVIR
  texte=texte+'jeu    = '+str(JEU)          +POIVIR
  texte=texte+'epC    = '+str(EPC)          +POIVIR
  texte=texte+'DeC    = '+str(DEC)          +POIVIR
  texte=texte+'Xmax   = '+str(XMAX)         +POIVIR
  texte=texte+'typmai =  MOT '+TYPMAI       +POIVIR
  texte=texte+'theta  = '+str(THETA)        +POIVIR
  texte=texte+'a      = '+str(A)            +POIVIR
  texte=texte+'c      = '+str(C)            +POIVIR
  texte=texte+'zeta   = '+str(ZETA)         +POIVIR
  texte=texte+'eps    = '+str(EPS)          +POIVIR
  texte=texte+'rc0    = '+str(RC0)          +POIVIR
  texte=texte+'rc1    = '+str(RC1)          +POIVIR
  texte=texte+'rc2    = '+str(RC2)          +POIVIR
  texte=texte+'rc3    = '+str(RC3)          +POIVIR
  texte=texte+'alpha  = '+str(ALP)          +POIVIR
  texte=texte+'beta   = '+str(BETA)         +POIVIR
  texte=texte+'ns     = '+str(NS)           +POIVIR
  texte=texte+'nc     = '+str(NC)           +POIVIR
  texte=texte+'nt     = '+str(NT)           +POIVIR
  texte=texte+'dir_fiss = MOT '+POSI        +POIVIR
  texte=texte+'pos_fiss = MOT '+TFISS       +POIVIR
  texte=texte+'ndt    = '+str(NDT)          +POIVIR
  texte=texte+'nsdt   = '+str(NSDT)         +POIVIR
  texte=texte+'typ_eque = MOT '+'FISS_COU'  +POIVIR
  texte=texte+'nivmag = '+str(NIVMAG)       +POIVIR
  texte=texte+'*                                                               \n'
  texte=texte+'list epc ;\n'
  texte=texte+'opti donn '
  texte=texte+"'"+loc_datg+'aspic.datg'+"';\n"
  print texte
  fdgib.write(texte)
  fdgib.close()

def macr_aspic_mail_ops(self,EXEC_MAILLAGE,TYPE_ELEM,RAFF_MAIL,TUBULURE,
                             SOUDURE,CORPS,FISS_SOUDURE,IMPRESSION,INFO,
                        **args):
  """
     Ecriture de la macro MACR_ASPIC_MAIL
  """
  from Accas import _F
  import types
  import aster 
  ier=0
  
# On importe les definitions des commandes a utiliser dans la macro
  EXEC_LOGICIEL =self.get_cmd('EXEC_LOGICIEL')
  PRE_GIBI      =self.get_cmd('PRE_GIBI')
  LIRE_MAILLAGE =self.get_cmd('LIRE_MAILLAGE')
  DEFI_GROUP    =self.get_cmd('DEFI_GROUP')
  MODI_MAILLAGE =self.get_cmd('MODI_MAILLAGE')
  AFFE_MODELE   =self.get_cmd('AFFE_MODELE')
  CREA_MAILLAGE =self.get_cmd('CREA_MAILLAGE')
  IMPR_RESU     =self.get_cmd('IMPR_RESU')

# La macro compte pour 1 dans la numerotation des commandes
  self.set_icmd(1)

  TYPELE = TYPE_ELEM
  NIVMAG = EXEC_MAILLAGE['NIVE_GIBI']
#
#     --- raffinement maillage ---
#
  TYPMAI = RAFF_MAIL
  GROS   = (TYPMAI=='GROS')
  if GROS : NBAZIT = 40
  else    : NBAZIT = 48
#
#     --- caracteristiques de la tubulure ---
#
  EPT1  = TUBULURE['E_BASE'   ]
  DET1  = TUBULURE['DEXT_BASE']
  D1    = TUBULURE['L_BASE'   ]
  D2    = TUBULURE['L_CHANF'  ]
  EPT2  = TUBULURE['E_TUBU'   ]
  DET2  = TUBULURE['DEXT_TUBU']
  ZMAX  = TUBULURE['Z_MAX'    ]
  TYPSOU= TUBULURE['TYPE'     ]
  DPENE = TUBULURE['L_PENETR' ]
  if TYPSOU=='TYPE_2' and DPENE>0.0 : 
    self.cr.fatal("<F> <MACR_ASPIC_MAIL> les piquages penetrants sont autorises uniquement avec les soudures de type 1")
    ier = ier+1
    return ier
  if TYPSOU=='TYPE_2' :
     ITYPSO = 2
  else :
     ITYPSO = 1
#
#     --- caracteristiques de la soudure ---
#
  H     = SOUDURE['H_SOUD'   ]
  ALPHA = SOUDURE['ANGL_SOUD']
  JEU   = SOUDURE['JEU_SOUD' ]
#
#     --- caracteristiques du corps ---
#
  EPC   = CORPS  ['E_CORP'   ]
  DEC   = CORPS  ['DEXT_CORP']
  XMAX  = CORPS  ['X_MAX'    ]
  EPSI  = 1.E-03
  RMB   = ( DET1 - EPT1 ) / 2.0
  VAL1  = 1.5 * sqrt( RMB**3 / EPT1 )
  VAL3  = 3.0 * sqrt( RMB    * EPT1 )
  RMT   = ( DET2 - EPT2 ) / 2.0
  VAL2  = 1.5 * sqrt( RMT**3 / EPT2 )
  VAL4  = 3.0 * sqrt( RMT    * EPT2 )
  LZMAX = max ( VAL1 , VAL2, VAL3, VAL4 )
  ZMAXC = LZMAX + ( DEC/2.0 ) + D1 + D2
  LOK = ( abs(ZMAX-ZMAXC) <= EPSI * abs(ZMAXC) )
  if not LOK :
    print ' <MACR_ASPIC_MAIL> erreur donnees'
    print ' <MACR_ASPIC_MAIL> Z_MAX FOURNIE   : ', ZMAX
    print ' <MACR_ASPIC_MAIL> Z_MAX CALCULEE  : ', ZMAXC
    self.cr.fatal("<F> <MACR_ASPIC_MAIL> erreur donnees ")
    ier = ier+1
    return ier
  RMC   = ( DEC - EPC ) / 2.0
  VAL1  = 1.5 * sqrt( RMC**3 / EPC )
  VAL2  = 3.0 * sqrt( RMC    * EPC )
  LXMAX = max( VAL1 , VAL2 )
  XMAXC = LXMAX + ( DET1 / 2.0 )
  LOK = ( abs(XMAX-XMAXC) <= EPSI * abs(XMAXC) )
  if not LOK :
    print ' <MACR_ASPIC_MAIL> erreur donnees'
    print ' <MACR_ASPIC_MAIL> Z_MAX FOURNIE   : ', ZMAX
    print ' <MACR_ASPIC_MAIL> Z_MAX CALCULEE  : ', ZMAXC
    self.cr.fatal("<F> <MACR_ASPIC_MAIL> erreur donnees ")
    ier = ier+1
    return ier
  print ' MACR_ASPIC_MAIL / X_MAX CALCULEE : ',XMAX
  print ' MACR_ASPIC_MAIL / Z_MAX CALCULEE : ',XMAXC
#
#     --- caracteristiques de la fissure ---
#
  SAIN   = 0
  FISLON = 0
  FISCOU = 0
  THETA  = 0.0
  TFISS  = None
  if FISS_SOUDURE==None :
     SAIN = 1
  else :
     if   FISS_SOUDURE['TYPE']=='LONGUE' : FISLON = 1
     elif FISS_SOUDURE['TYPE']=='COURTE' : FISCOU = 1
     THETA = FISS_SOUDURE['AZIMUT'        ]
     EPS   = FISS_SOUDURE['ANGL_OUVERTURE']
     AXIS  = FISS_SOUDURE['AXIS'          ]
     POSI  = FISS_SOUDURE['POSITION'      ]
     TFISS = FISS_SOUDURE['FISSURE'       ]
     A     = FISS_SOUDURE['PROFONDEUR'    ]
     if      FISS_SOUDURE['LONGUEUR'      ]!=None :
        C  = FISS_SOUDURE['LONGUEUR'      ]
        N1 = 1
     else : N1 = 0
     if (TFISS=='DEB_INT') and (POSI=='INCLINE') and (DPENE>0.0) and (JEU>0.0) : 
       print ' <MACR_ASPIC_MAIL> erreur donnees'
       print ' <MACR_ASPIC_MAIL> dans le cas de fissures'
       print ' <MACR_ASPIC_MAIL> inclinees debouchant en peau interne avec'
       print ' <MACR_ASPIC_MAIL> piquage penetrant le jeu doit etre nul'
       self.cr.fatal("<F> <MACR_ASPIC_MAIL> erreur donnees ")
       ier = ier+1
       return ier
     ZETA = 0.5
     if TFISS not in ('DEB_INT','DEB_EXT') :
        if FISS_SOUDURE['LIGA_INT']==None : 
           print ' <MACR_ASPIC_MAIL> erreur donnees'
           print ' <MACR_ASPIC_MAIL> dans le cas de fissures internes'
           print ' <MACR_ASPIC_MAIL> (NON_DEB) le ligament inferieur est obligatoire'
           self.cr.fatal("<F> <MACR_ASPIC_MAIL> erreur donnees ")
           ier = ier+1
           return ier
        LIGA  = FISS_SOUDURE['LIGA_INT']
        if POSI=='DROIT' :
           if ITYPSO==1 : ZETA = (A+LIGA)/(EPC+H)
           else         : ZETA = (A+LIGA)/(EPT1+H)
        else :
           if ITYPSO==1 : ZETA = (A+LIGA)*cos(ALPHA*pi/180.0)/EPC
           else         : ZETA = (A+LIGA)*cos(ALPHA*pi/180.0)/EPT1
        if ZETA < 0.1   :
           self.cr.fatal("<F> <MACR_ASPIC_MAIL> dans le cas de fissures internes (NON_DEB) le ligament est trop petit ")
           ier = ier+1
           return ier
        if ZETA > 0.9   :
           self.cr.fatal("<F> <MACR_ASPIC_MAIL> dans le cas de fissures internes (NON_DEB) le ligament est trop grand ")
           ier = ier+1
           return ier
        if LIGA < 0.1*EPC :
           self.cr.fatal("<F> <MACR_ASPIC_MAIL> dans le cas de fissures internes (NON_DEB) le ligament est trop petit ")
           ier = ier+1
           return ier
        if (LIGA + 2.0*A) > 0.9*EPC :
           self.cr.fatal("<F> <MACR_ASPIC_MAIL> dans le cas de fissures internes (NON_DEB) le ligament est trop grand ")
           ier = ier+1
           return ier
     if N1==0 :
        if FISCOU      :
           self.cr.fatal("<F> <MACR_ASPIC_MAIL> dans le cas de fissures courte il faut preciser la longueur ")
           ier = ier+1
           return ier
        if AXIS=='NON' :
           self.cr.fatal("<F> <MACR_ASPIC_MAIL> dans le cas de la fissure longue il faut preciser la longueur ou axis=oui ")
           ier = ier+1
           return ier
        C = 0.0
     else :
        if AXIS=='OUI' : print '<A> <MACR_ASPIC_MAIL> fissure axisymetrique : le mot clef <LONGUEUR> ne doit pas etre renseigne'
     C = 0.5 * C
     LEQU=2.*(pi*(DEC-EPC)-DET1+2.*EPT1)
#
# LPIQ est une valeur qui depend theoriquement de la fissure. la valeur
# ci-dessous est approchee car elle ne sert qu'a calculer les facteurs d'etirement
#
     LPIQ=pi*(DET1)
     if AXIS=='OUI' : C=100.0*LPIQ
     RAPL=LEQU/LPIQ
     if FISCOU :
        RAP=A/C
        CAS1=RAP<0.3499
        CAS3=RAP>0.4999
        CAS2= not (CAS1 or CAS3)
        if CAS1 : ALP=0.8
        if CAS2 : ALP=0.4
        if CAS3 : ALP=0.0
        BETA=1.0
        if GROS and not CAS1 :
          NDT=1
          NSDT=2
        else :
          NDT=2
          NSDT=4
#
     if FISLON :
       if GROS :
         NDT=2
         FETIRF=30.*RAPL
         FETIRP=60.*RAPL
       else :
         NDT=3
         FETIRF=15.*RAPL
         FETIRP=30.*RAPL
#
     RC0 = FISS_SOUDURE['RAYON_TORE']
     if (FISCOU and RC0==None) :
       if GROS : RC0=0.12
       else    : RC0=0.10
       if CAS1 : RC0=0.08
       RC0=RC0*A
     if (FISLON and RC0==None) : RC0=A/(NDT+1)
#
     RC1 = FISS_SOUDURE['COEF_MULT_RC1']
     if (FISCOU and RC1==None) :
       if GROS : RC1=1.2
       else    : RC1=1.0
#
     RC2 = FISS_SOUDURE['COEF_MULT_RC2']
     if (FISCOU and RC2==None) :
       if GROS : RC2=1.4
       else    : RC2=1.2
#
     RC3 = FISS_SOUDURE['COEF_MULT_RC3']
     if (FISCOU and RC3==None) :
       if GROS :
          if CAS1 : RC3=2.5
          else    : RC3=1.0  # valeur non utilisee
       else : 
          if CAS3 : RC3=2.2
          else    : RC3=2.0
#
     NT = FISS_SOUDURE['NB_TRANCHE']
     if (FISCOU and NT==None) :
       if GROS : NT = 8
       else    : NT = 16
       if CAS1 : NT = NT*2
     if (FISLON and NT==None) : NT=0
#
     NS = FISS_SOUDURE['NB_SECTEUR']
     if (FISCOU and NS==None) :
       if GROS : NS = 2
       else    : NS = 4
     if (FISLON and NS==None) :
       if GROS : NS = 2
       else    : NS = 4
#
     NC = FISS_SOUDURE['NB_COURONNE']
     if (FISCOU and NC==None) :
       if GROS : NC = 3
       else    : NC = 4
     if (FISLON and NC==None) :
       if GROS : NC = 3
       else    : NC = 4
#
  loc_gibi=aster.repout()
  logiel = EXEC_MAILLAGE['LOGICIEL'  ]
  UNITD  = EXEC_MAILLAGE['UNITE_DATG']
  UNITS  = EXEC_MAILLAGE['UNITE_MGIB']
  if   logiel=='GIBI98'  : logiel = loc_gibi+'gibi98'
  elif logiel=='GIBI2000': logiel = loc_gibi+'gibi2000'
  else                   :
       self.cr.fatal("<F> <MACR_ASPIC_MAIL> seuls gibi98 et gibi2000 sont appelableS")
       ier = ier+1
       return ier
#
#     --- ecriture sur le fichier .datg  de la procedure ---
#
# Nom du fichier de commandes pour GIBI
  nomFichierDATG = 'fort.'+str(UNITD)
# Nom du fichier de maillage GIBI
  nomFichierGIBI = 'fort.'+str(UNITS)
  loc_datg = aster.repdex()
  if SAIN   : write_file_dgib_ASPID0(nomFichierDATG,UNITD, EPT1, DET1, D1, D2, EPT2, DET2, ZMAX, H,
                                     ALPHA, JEU, EPC, DEC, XMAX, TYPMAI, THETA, TYPELE,
                                     ITYPSO, DPENE, NIVMAG,loc_datg)
  if FISLON : write_file_dgib_ASPID1(nomFichierDATG,UNITD, EPT1, DET1, D1, D2, EPT2, DET2, ZMAX, H,
                                     ALPHA, JEU, EPC, DEC, XMAX, TYPMAI,THETA,
                                     A,C,EPS, RC0,NS,NC,NT,POSI, NDT,FETIRF,FETIRP,
                                     TFISS,ZETA,ITYPSO,DPENE, NIVMAG,loc_datg)
  if FISCOU : write_file_dgib_ASPID2(nomFichierDATG,UNITD, EPT1, DET1, D1, D2, EPT2, DET2, ZMAX,
                                     H, ALPHA, JEU, EPC, DEC, XMAX, TYPMAI,
                                     THETA, A, C, EPS, RC0, RC1, RC2, RC3,
                                     ALP,BETA, NS, NC, NT, POSI ,NDT,NSDT,TFISS,
                                     ZETA,ITYPSO,DPENE, NIVMAG,loc_datg)
#
  EXEC_LOGICIEL( LOGICIEL = logiel ,
                 ARGUMENT = ( _F(NOM_PARA=nomFichierDATG),
                              _F(NOM_PARA=nomFichierGIBI), ), )
#
  PRE_GIBI()
#
  __MAPROV=LIRE_MAILLAGE(INFO=INFO)
#
  motscles={}
  motscles['CREA_GROUP_MA']=[]
  l_CREA_GROUP_NO=[]
  if SAIN :
     l_CREA_GROUP_NO.append('S_LAT1')
     l_CREA_GROUP_NO.append('S_LAT2')
  else :
     l_CREA_GROUP_NO.append('S_LAT1_C')
     l_CREA_GROUP_NO.append('S_LAT2_C')
     l_CREA_GROUP_NO.append('S_LAT1_T')
     l_CREA_GROUP_NO.append('S_LAT2_T')
     if (TFISS=='NON_DEB') and (FISS_SOUDURE['TYPE']=='LONGUE') :
        l_CREA_GROUP_NO.append('PFONDINF')
        l_CREA_GROUP_NO.append('PFONDSUP')
     else :
        l_CREA_GROUP_NO.append('PFONDFIS')
     if (TFISS=='NON_DEB') and (FISS_SOUDURE['TYPE']=='COURTE') :
        motscles['CREA_GROUP_MA'].append(_F(GROUP_MA = 'FONDFISS',
                                            NOM      = 'MAIL_ORI',
                                            POSITION = 'INIT'     ))
     if (TFISS[:4]=='DEB_') and (AXIS=='OUI') :
        motscles['CREA_GROUP_MA'].append(_F(GROUP_MA = 'FONDFISS',
                                            NOM      = 'MAIL_ORI',
                                            POSITION = 'INIT'     ))
     if (TFISS=='NON_DEB') and (FISS_SOUDURE['TYPE']=='LONGUE') :
        motscles['CREA_GROUP_MA'].append(_F(GROUP_MA = 'FOND_SUP',
                                            NOM      = 'MA_ORI_S',
                                            POSITION = 'INIT'     ))
        motscles['CREA_GROUP_MA'].append(_F(GROUP_MA = 'FOND_INF',
                                            NOM      = 'MA_ORI_I',
                                            POSITION = 'INIT'     ))
  l_CREA_GROUP_NO.append('S_FOND1')
  l_CREA_GROUP_NO.append('S_FOND2')
  l_CREA_GROUP_NO.append('EQUERRE')
  motscles['CREA_GROUP_NO']=_F(GROUP_MA=l_CREA_GROUP_NO)
#
  __MAPROV=DEFI_GROUP(reuse   =__MAPROV,
                      MAILLAGE=__MAPROV,
                      **motscles )
#
  if not SAIN :
     motscles={}
     motscles['CREA_GROUP_NO']=[]
     if not (TFISS=='NON_DEB')  :
        motscles['CREA_GROUP_NO'].append(_F(GROUP_MA = 'FONDFISS',))
     if (TFISS=='NON_DEB') and (FISS_SOUDURE['TYPE']=='LONGUE') :
        motscles['CREA_GROUP_NO'].append(_F(GROUP_MA = ('FOND_SUP','FOND_INF',),))
     __MAPROV=DEFI_GROUP(reuse   =__MAPROV,
                         MAILLAGE=__MAPROV,
                         **motscles )
#
  __MAPROV=MODI_MAILLAGE(reuse   =__MAPROV,
                         MAILLAGE=__MAPROV,
                         EQUE_PIQUA=_F( GROUP_NO  = 'EQUERRE' ,
                                        E_BASE    = EPT1  ,
                                        DEXT_BASE = DET1  ,
                                        L_BASE    = D1    ,
                                        L_CHANF   = D2    ,
                                        TYPE      = TYPSOU,
                                        H_SOUD    = H     , 
                                        ANGL_SOUD = ALPHA ,
                                        JEU_SOUD  = JEU   ,
                                        E_CORP    = EPC   , 
                                        DEXT_CORP = DEC   ,
                                        AZIMUT    = THETA ,
                                        RAFF_MAIL = TYPMAI,
                                        X_MAX     = XMAX  , )
                         )
#
  __MODELE=AFFE_MODELE( MAILLAGE=__MAPROV,
                        AFFE=_F( GROUP_MA     = ('EQUERRE','PEAUINT','EXCORP1','EXCORP2','EXTUBU'),
                                 PHENOMENE    = 'MECANIQUE'  ,
                                 MODELISATION = '3D'         , )
                         )
#
  motscles={}
  if TFISS=='DEB_INT' :
     motscles['ORIE_PEAU_3D']=_F(GROUP_MA=('PEAUINT','EXCORP1','EXCORP2','EXTUBU','LEVRTUBU','LEVRCORP'),)
  else :
     motscles['ORIE_PEAU_3D']=_F(GROUP_MA=('PEAUINT','EXCORP1','EXCORP2','EXTUBU',),)
  __MAPROV=MODI_MAILLAGE(reuse   =__MAPROV,
                         MAILLAGE=__MAPROV,
                         MODELE  =__MODELE,
                         **motscles
                         )
#
  if SAIN :
     __MAPROV=DEFI_GROUP(reuse         = __MAPROV,
                         MAILLAGE      = __MAPROV,
                         CREA_GROUP_NO = _F(GROUP_MA=('NIDXT','NEDXT','NIIXT','NEIXT')) )
#
     for i in range(1,NBAZIT+1):
       prec = EPC / 5.0
       __MAPROV=DEFI_GROUP(reuse         = __MAPROV,
                           MAILLAGE      = __MAPROV,
                         CREA_GROUP_NO = ( _F( NOM       = 'NID'+str(i) ,
                                               GROUP_NO  = 'NIDXT'      ,
                                               NUME_INIT = i            ,
                                               NUME_FIN  = i            ,),
                                           _F( NOM       = 'NED'+str(i) ,
                                               GROUP_NO  = 'NEDXT'      ,
                                               NUME_INIT = i            ,
                                               NUME_FIN  = i            ,),
                                           _F( NOM       = 'NII'+str(i) ,
                                               GROUP_NO  = 'NIIXT'      ,
                                               NUME_INIT = i            ,
                                               NUME_FIN  = i            ,),
                                           _F( NOM       = 'NEI'+str(i) ,
                                               GROUP_NO  = 'NEIXT'      ,
                                               NUME_INIT = i            ,
                                               NUME_FIN  = i            ,),
                                           _F( NOM       = 'LDN'+str(i) ,
                                               GROUP_MA  = 'LD' +str(i) ,),
                                           _F( NOM       = 'LD' +str(i) ,
                                               GROUP_NO  = 'LDN'+str(i) ,
                                               OPTION    = 'SEGM_DROI_ORDO',
                                               PRECISION =  prec        ,
                                               CRITERE   = 'ABSOLU'     ,
                                               GROUP_NO_ORIG   = 'NID'+str(i),
                                               GROUP_NO_EXTR   = 'NED'+str(i),),
                                           _F( NOM       = 'LIN'+str(i) ,
                                               GROUP_MA  = 'LI' +str(i) ,),
                                           _F( NOM       = 'LI' +str(i) ,
                                               GROUP_NO  = 'LIN'+str(i) ,
                                               OPTION    = 'SEGM_DROI_ORDO',
                                               PRECISION =  prec        ,
                                               CRITERE   = 'ABSOLU'     ,
                                               GROUP_NO_ORIG   = 'NII'+str(i),
                                               GROUP_NO_EXTR   = 'NEI'+str(i),),))
#
#
#     --- commande CREA_MAILLAGE ---
#
  self.DeclareOut('nomres',self.sd)
  nomres=CREA_MAILLAGE( MAILLAGE=__MAPROV,
                        CREA_POI1 = ( _F( NOM_GROUP_MA = 'P1_CORP ' ,
                                          GROUP_NO     = 'P1_CORP ' , ),
                                      _F( NOM_GROUP_MA = 'P2_CORP ' ,
                                          GROUP_NO     = 'P2_CORP ' , ),
                                      _F( NOM_GROUP_MA = 'P_TUBU ' ,
                                          GROUP_NO     = 'P_TUBU ' ,  ),)
                         )
#
  if IMPRESSION!=None:
     for impr in IMPRESSION :
#
         motscles={}
         if impr['FORMAT']=='IDEAS'  : motscles['VERSION']  =impr['VERSION']
         if impr['FORMAT']=='CASTEM' : motscles['NIVE_GIBI']=impr['NIVE_GIBI']
         if impr['UNITE']!=None      : motscles['UNITE']    =impr['UNITE']
         impr_resu = _F( MAILLAGE = nomres,)
#
         IMPR_RESU( RESU = impr_resu, 
                    FORMAT = impr['FORMAT'],**motscles )
#
  return ier

