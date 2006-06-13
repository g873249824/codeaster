      SUBROUTINE RCEVSP ( CCONT, CINST, CSPO, CSPE )
      IMPLICIT     NONE
      CHARACTER*24 CCONT, CINST, CSPO, CSPE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 08/02/2005   AUTEUR CIBHHLV L.VIVAN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY  
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY  
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR     
C (AT YOUR OPTION) ANY LATER VERSION.                                   
C                                                                       
C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT   
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF            
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU      
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.                              
C                                                                       
C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE     
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,         
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C     ------------------------------------------------------------------
C     OPERATEUR POST_RCCM, TYPE_RESU_MECA='EVOLUTION'
C     CALCUL DU SP
C
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32     JEXNOM, JEXNUM
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER      NCMP, JSIOE, JINST, NBINST, NBORDR, JSPO, JSPE,
     +             IND, I1, I2, ICMP, L1, L2
      PARAMETER  ( NCMP = 6 )
      REAL*8       SP1O(NCMP), SP1E(NCMP), SP2O(NCMP), SP2E(NCMP),
     +             SP12O(NCMP), SP12E(NCMP), EQUI(NCMP)
      CHARACTER*8  K8B
C DEB ------------------------------------------------------------------
      CALL JEMARQ()
C
      CALL JEVEUO ( CCONT, 'L', JSIOE )
      CALL JEVEUO ( CINST, 'L', JINST )
      CALL JELIRA ( CINST, 'LONMAX', NBINST, K8B )
C
      NBORDR = (NBINST*(NBINST+1)) / 2
      CALL WKVECT (CSPO, 'V V R', NBORDR, JSPO )
      CALL WKVECT (CSPE, 'V V R', NBORDR, JSPE )
      IND = 0
C
      DO 100 I1 = 1, NBINST
C
         DO 102 ICMP = 1, NCMP
            L1 = NCMP*(I1-1) + ICMP
            L2 = NCMP*NBINST + NCMP*(I1-1) + ICMP
            SP1O(ICMP) = ZR(JSIOE-1+L1)
            SP1E(ICMP) = ZR(JSIOE-1+L2)
 102     CONTINUE
         IND = IND + 1
C ======================================================================
C --- CALCUL DES VALEURS PROPRES DU TENSEUR DE CONTRAINTES 
C     SP1O A L'ORIGINE DU CHEMIN :
C --- CALCUL DE LA DIFFERENCE SUP SPO DES VALEURS PROPRES (LE TRESCA) :
C ======================================================================
         CALL FGEQUI ( SP1O, 'SIGM', 3, EQUI )
         ZR(JSPO+IND-1) = EQUI(2)
C ======================================================================
C --- CALCUL DES VALEURS PROPRES DU TENSEUR DE CONTRAINTES 
C     SP1E A L'AUTRE EXTREMITE DU CHEMIN :
C --- CALCUL DE LA DIFFERENCE SUP SPE DES VALEURS PROPRES (LE TRESCA) :
C ======================================================================
         CALL FGEQUI ( SP1E, 'SIGM', 3, EQUI )
         ZR(JSPE+IND-1) = EQUI(2)
C
         DO 110 I2 = I1+1, NBINST
C
            DO 112 ICMP = 1, NCMP
               L1 = NCMP*(I2-1) + ICMP
               L2 = NCMP*NBINST + NCMP*(I2-1) + ICMP
               SP2O(ICMP) = ZR(JSIOE-1+L1)
               SP2E(ICMP) = ZR(JSIOE-1+L2)
 112        CONTINUE
            IND = IND + 1
C ======================================================================
C ---       COMBINAISON DES CONTRAINTES AUX 2 INSTANTS TEMP1 ET TEMP2 :
C ======================================================================
            DO 114 ICMP = 1 , NCMP
               SP12O(ICMP) = SP1O(ICMP) - SP2O(ICMP)
               SP12E(ICMP) = SP1E(ICMP) - SP2E(ICMP)
 114        CONTINUE
C ======================================================================
C ---       CALCUL DES VALEURS PROPRES DE LA DIFFERENCE DES TENSEURS 
C ---       DE CONTRAINTES LINEARISEES 
C ---       SP12O = SPO(TEMP1)-SPO(TEMP2) A L'ORIGINE DU CHEMIN :
C ---  CALCUL DE LA DIFFERENCE SUP SPO DES VALEURS PROPRES ( LE TRESCA)
C ======================================================================
            CALL FGEQUI ( SP12O, 'SIGM', 3, EQUI )
            ZR(JSPO+IND-1) = EQUI(2)
C ======================================================================
C ---      CALCUL DES VALEURS PROPRES DE LA DIFFERENCE DES TENSEURS 
C ---      DE CONTRAINTES LINEARISEES 
C ---      SP12E = SPE(TEMP1)-SPE(TEMP2) A L'AUTRE EXTREMITE DU CHEMIN :
C ---   CALCUL DE LA DIFFERENCE SUP SPE DES VALEURS PROPRES (LE TRESCA)
C ======================================================================
            CALL FGEQUI ( SP12E, 'SIGM', 3, EQUI )
            ZR(JSPE+IND-1) = EQUI(2)
C
 110     CONTINUE
C
 100  CONTINUE
C
      CALL JEDEMA( )
      END
