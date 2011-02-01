      SUBROUTINE NMPIAC(SDPILO,ETA   )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 01/02/2011   AUTEUR MASSIN P.MASSIN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C      
      IMPLICIT NONE
      CHARACTER*19 SDPILO
      REAL*8       ETA
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - PILOTAGE)
C
C REACTUALISATION DES BORNES DE PILOTAGE SI DEMANDE
C
C ----------------------------------------------------------------------
C
C
C IN  SDPILO : SD PILOTAGE      
C IN  ETA    : PARAMETRE DE PILOTAGE
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      CHARACTER*24 EVOLPA,TYPSEL,TYPPIL
      INTEGER      JPLTK, JPLIR
C
C ----------------------------------------------------------------------
C      
      CALL JEVEUO(SDPILO(1:19)// '.PLTK','L',JPLTK)
      TYPPIL = ZK24(JPLTK)
      TYPSEL = ZK24(JPLTK+5)
      EVOLPA = ZK24(JPLTK+6)
      CALL JEVEUO(SDPILO(1:19)// '.PLIR','E',JPLIR)
      IF(TYPSEL.EQ.'ANGL_INCR_DEPL'.AND.(TYPPIL.EQ.'LONG_ARC'
     &   .OR.TYPPIL.EQ.'SAUT_LONG_ARC')) THEN
         ZR(JPLIR-1+6)=ZR(JPLIR)
      ENDIF

            
      IF (EVOLPA .EQ. 'SANS') GOTO 9999        
      IF (EVOLPA .EQ. 'CROISSANT') THEN
        ZR(JPLIR+4) = ETA
      ELSE
        ZR(JPLIR+3) = ETA
      END IF
      
 9999 CONTINUE
      END
