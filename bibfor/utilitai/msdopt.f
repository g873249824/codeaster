      SUBROUTINE MSDOPT ( RESUCO, LESOPT, NBOPT )
      IMPLICIT   NONE
      INTEGER             NBOPT
      CHARACTER*8         RESUCO
      CHARACTER*24        LESOPT
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 03/10/2011   AUTEUR DELMAS J.DELMAS 
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
C
C    CETTE ROUTINE AJOUTE DES OPTIONS DE CALCUL DANS CALC_SENSI
C    POUR ASSURER LA COMPATIBILITE AVEC CALC_CHAMP
C
C    SI SIGM_ELNO ALORS SIEF_ELGA
C
C ----------------------------------------------------------------------
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                       ZK24
      CHARACTER*32                                ZK32
      CHARACTER*80                                         ZK80
      COMMON / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      INTEGER        JOPT, JOPT2,
     &              I, J, NBOPT2, INDK16,
     &               ISIGM
      CHARACTER*16  TYSD
      CHARACTER*24  LESOP2
C DEB ------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL GETTCO ( RESUCO, TYSD )
      CALL JEVEUO(LESOPT,'L',JOPT)
C
      ISIGM = INDK16( ZK16(JOPT), 'SIGM_ELNO', 1, NBOPT )
C
      IF (ISIGM.EQ.0) THEN
        GOTO 9999
      ENDIF
C
      LESOP2 = '&&OP0032.NEW_OPTION'
      CALL JEDUPO ( LESOPT , 'V', LESOP2 , .FALSE. )
      CALL JEDETR ( LESOPT )
      CALL WKVECT ( LESOPT , 'V V K16' , NBOPT+20 , JOPT )
      CALL JEVEUO ( LESOP2 , 'L', JOPT2 )
C
      NBOPT2 = 1
C
      IF( ISIGM .NE. 0 ) THEN
         ZK16(JOPT+NBOPT2-1) = 'SIEF_ELGA'
         NBOPT2 = NBOPT2 + 1
         ZK16(JOPT+NBOPT2-1) = 'SIGM_ELNO'
         NBOPT2 = NBOPT2 + 1
      ENDIF
C
      NBOPT2 = NBOPT2 - 1
C
      DO 10 I = 1 , NBOPT
         DO 12 J = 1 , NBOPT2
            IF ( ZK16(JOPT2+I-1) .EQ. ZK16(JOPT+J-1) ) GOTO 10
 12      CONTINUE
         NBOPT2 = NBOPT2 + 1
         ZK16(JOPT+NBOPT2-1) = ZK16(JOPT2+I-1)
 10   CONTINUE
C
      NBOPT = NBOPT2
      CALL JEDETR ( LESOP2 )
C
 9999 CONTINUE
      CALL JEDEMA()
      END
