      SUBROUTINE VPCREA( ICOND, MODES, MASSE, AMOR, RAIDE , IER )
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER            ICOND,                             IER
      CHARACTER*(*)             MODES, MASSE, AMOR, RAIDE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 10/03/98   AUTEUR VABHHTS J.PELLET 
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
C     CREATION OU VERIFICATION DE COHERENCE DES MODES
C     ------------------------------------------------------------------
C
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
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*6      PGC, PGCANC
      COMMON  /NOMAJE/ PGC
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C     ------------------------------------------------------------------
C
      INTEGER       NBVAL,IVAL, LMODE
      CHARACTER*1   TYPE
      CHARACTER*8   CBID
      CHARACTER*16  NOMCMD
      CHARACTER*24  VALE, REFE
C     ------------------------------------------------------------------
      DATA  REFE  /'                   .REFE'/
C     ------------------------------------------------------------------
      CALL JEMARQ()
      IER    = 0
      PGC    = 'VPCREA'
C
C     --------------------------- REFE --------------------------------
C     --- AFFECTATION DES INFORMATIONS DE REFERENCE A CHAMP ---
      REFE(1:8) = MODES
      CALL JEEXIN(REFE,IER1)
      IF ( IER1 .EQ. 0 ) THEN
         IF ( ICOND .EQ. 0 ) THEN
            NBVAL = 3
            CALL WKVECT(REFE,'G V K24',NBVAL,LMODE)
            ZK24(LMODE    ) = MASSE
            ZK24(LMODE+1) = AMOR
            ZK24(LMODE+2) = RAIDE
         ENDIF
      ELSE
         CALL JEVEUO(REFE,'L',LMODE)
         IF ( ZK24(LMODE    ) .NE. MASSE  ) IER = IER + 1
         IF ( ZK24(LMODE+1) .NE. AMOR     ) IER = IER + 1
         IF ( ZK24(LMODE+2) .NE. RAIDE    ) IER = IER + 1
         IF ( IER.NE.0 ) THEN
           CALL GETRES(CBID,CBID,NOMCMD)
           IF ( ZK24(LMODE+1)(1:8) .NE. ' ' ) THEN
              CALL UTMESS('F',NOMCMD//'.VPCREA',
     +        'LE CONCEPT MODE "'//REFE(1:8)//'" A ETE CREE AVEC '//
     +        'LES MATRICES    MATR_A: '//ZK24(LMODE)(1:8)//
     +                      ', MATR_B: '//ZK24(LMODE+2)(1:8)//
     +                      ', MATR_C: '//ZK24(LMODE+1)(1:8)//
     +        ' ET NON AVEC CELLES  PASSEES EN ARGUMENTS.')
           ELSE
              CALL UTMESS('F',NOMCMD//'.VPCREA',
     +        'LE CONCEPT MODE "'//REFE(1:8)//'" A ETE CREE AVEC '//
     +        'LES MATRICES    MATR_A: '//ZK24(LMODE)(1:8)//
     +                      ', MATR_B: '//ZK24(LMODE+2)(1:8)//
     +        ' ET NON AVEC CELLES  PASSEES EN ARGUMENTS.')
           ENDIF
         ENDIF
      ENDIF
      CALL JEDEMA()
      END
