      LOGICAL FUNCTION IDENSD(TYPESD,SD1,SD2)
      IMPLICIT NONE
      CHARACTER*(*) SD1,SD2,TYPESD
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 22/07/99   AUTEUR D6BHHHH M.ASA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C RESPONSABLE                            VABHHTS J.PELLET 
C ----------------------------------------------------------------------
C  BUT : DETERMINER L'IDENTITE DE 2 SD D'ASTER.
C  IN   TYPESD : TYPE DE  SD1 ET SD2
C               'PROF_CHNO'
C       SD1   : NOM DE LA 1ERE SD
C       SD2   : NOM DE LA 2EME SD
C
C     RESULTAT:
C       IDENSD : .TRUE.    SI SD1 == SD2
C                .FALSE.   SINON
C ----------------------------------------------------------------------
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR,JEXR8
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C ----------------------------------------------------------------------
      LOGICAL IDEN(10),IDENOB
      CHARACTER*16 TYP2SD
      CHARACTER*19 PCHN1,PCHN2
C
C -DEB------------------------------------------------------------------
C
      CALL JEMARQ()
      TYP2SD = TYPESD
      IDENSD=.TRUE.

      IF (SD1.EQ.SD2) GOTO 9999


      IF (TYP2SD.EQ.'PROF_CHNO') THEN
C     --------------------------------
        PCHN1=SD1
        PCHN2=SD2
        IDEN(1)=IDENOB(PCHN1//'.LILI',PCHN2//'.LILI')
        IDEN(2)=IDENOB(PCHN1//'.DEEQ',PCHN2//'.DEEQ')
        IDEN(3)=IDENOB(PCHN1//'.NUEQ',PCHN2//'.NUEQ')
        IF (.NOT.(IDEN(1).AND.IDEN(2).AND.IDEN(3))) GOTO 9998


      ELSE
        CALL UTMESS('F','IDENSD',' LE MOT CLE :'//TYP2SD//
     +              'N EST PAS AUTORISE.')
      END IF

      GOTO 9999
 9998 CONTINUE
      IDENSD=.FALSE.


 9999 CONTINUE
      CALL JEDEMA()
      END
