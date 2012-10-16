       SUBROUTINE MDITM3 ( CHAIN1,CHAIN2,CHAIN3,CHAIN4,CHAIN5,CHAIN6,
     &                     CHAIN7,CHAIN8,CHAIN9,ILONG,NP1,NBNL)
C ---------------------------------------------------------------------
C DESCRIPTION
C -----------
C     CALCUL DE LA REPONSE DYNAMIQUE NON-LINEAIRE D'UNE STRUCTURE
C                    PAR UNE METHODE INTEGRALE
C                      (VERSION MULTIMODAL)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/10/2012   AUTEUR BERRO H.BERRO 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      IMPLICIT NONE
C
C
C
C
      INCLUDE 'jeveux.h'
      INTEGER      ILONG,NP1,NBNL,I,ILONGG
      INTEGER      KORDRE,KTEMPS,KDEPG,KVITG,KACCG,KDEP,KFOR,KVIT,KPTEM
      INTEGER      JORDRE,JTEMPS,JDEPG,JVITG,JACCG,JDEP,JFOR,JVIT,JPTEM
      CHARACTER*16 CHAIN1,CHAIN2,CHAIN3,CHAIN4,CHAIN5,CHAIN6
      CHARACTER*16 CHAIN7,CHAIN8,CHAIN9
C
      CALL JEMARQ( )
C
      ILONGG = ILONG
      ILONG  = ILONG + 10000
C
      IF ( ILONGG .NE. 0 ) THEN
        CALL JEVEUO ( CHAIN1, 'L', JORDRE )
        CALL JEVEUO ( CHAIN2, 'L', JTEMPS )
        CALL JEVEUO ( CHAIN3, 'L', JDEPG  )
        CALL JEVEUO ( CHAIN4, 'L', JVITG  )
        CALL JEVEUO ( CHAIN5, 'L', JACCG  )
        CALL JEVEUO ( CHAIN9, 'L', JPTEM  )
        IF ( NBNL .NE. 0 ) THEN
          CALL JEVEUO ( CHAIN6, 'L', JDEP   )
          CALL JEVEUO ( CHAIN7, 'L', JFOR   )
          CALL JEVEUO ( CHAIN8, 'L', JVIT   )
          CALL WKVECT ( '&&MDITM3_6', 'V V R8', NBNL*3*ILONGG, KDEP )
          CALL WKVECT ( '&&MDITM3_7', 'V V R8', NBNL*3*ILONGG, KFOR )
          CALL WKVECT ( '&&MDITM3_8', 'V V R8', NBNL*3*ILONGG, KVIT )
        ENDIF
        CALL WKVECT ( '&&MDITM3_1', 'V V I' , ILONGG       , KORDRE )
        CALL WKVECT ( '&&MDITM3_2', 'V V R8', ILONGG       , KTEMPS )
        CALL WKVECT ( '&&MDITM3_3', 'V V R8', NP1*ILONGG   , KDEPG  )
        CALL WKVECT ( '&&MDITM3_4', 'V V R8', NP1*ILONGG   , KVITG  )
        CALL WKVECT ( '&&MDITM3_5', 'V V R8', NP1*ILONGG   , KACCG  )
        CALL WKVECT ( '&&MDITM3_9', 'V V R8', NP1*ILONGG   , KPTEM  )
        DO 110 I = 0 , ILONGG-1
           ZI(KORDRE+I) = ZI(JORDRE + I)
           ZR(KTEMPS+I) = ZR(JTEMPS + I)
           ZR(KPTEM+I)  = ZR(JPTEM  + I)
 110    CONTINUE
        DO 120 I = 0 , NP1*ILONGG-1
           ZR(KDEPG+I) = ZR(JDEPG + I)
           ZR(KVITG+I) = ZR(JVITG + I)
           ZR(KACCG+I) = ZR(JACCG + I)
 120    CONTINUE
        DO 130 I = 0 , NBNL*3*ILONGG-1
           ZR(KDEP+I) = ZR(JDEP + I)
           ZR(KVIT+I) = ZR(JVIT + I)
           ZR(KFOR+I) = ZR(JFOR + I)
 130    CONTINUE
        CALL JEDETR ( CHAIN1 )
        CALL JEDETR ( CHAIN2 )
        CALL JEDETR ( CHAIN3 )
        CALL JEDETR ( CHAIN4 )
        CALL JEDETR ( CHAIN5 )
        CALL JEDETR ( CHAIN9 )
        IF ( NBNL .NE. 0 ) THEN
          CALL JEDETR ( CHAIN6 )
          CALL JEDETR ( CHAIN7 )
          CALL JEDETR ( CHAIN8 )
        ENDIF
      ENDIF
C
      CALL WKVECT ( CHAIN1, 'V V I' , ILONG       , JORDRE )
      CALL WKVECT ( CHAIN2, 'V V R8', ILONG       , JTEMPS )
      CALL WKVECT ( CHAIN3, 'V V R8', NP1*ILONG   , JDEPG  )
      CALL WKVECT ( CHAIN4, 'V V R8', NP1*ILONG   , JVITG  )
      CALL WKVECT ( CHAIN5, 'V V R8', NP1*ILONG   , JACCG  )
      CALL WKVECT ( CHAIN9, 'V V R8', NP1*ILONG   , JPTEM  )
      IF ( NBNL .NE. 0 ) THEN
        CALL WKVECT ( CHAIN6, 'V V R8', NBNL*3*ILONG, JDEP )
        CALL WKVECT ( CHAIN7, 'V V R8', NBNL*3*ILONG, JFOR )
        CALL WKVECT ( CHAIN8, 'V V R8', NBNL*3*ILONG, JVIT )
      ELSE
        CALL WKVECT ( CHAIN6, 'V V R8', 1, JDEP )
        CALL WKVECT ( CHAIN7, 'V V R8', 1, JFOR )
        CALL WKVECT ( CHAIN8, 'V V R8', 1, JVIT )
      ENDIF
C
      IF ( ILONGG .NE. 0 ) THEN
        DO 10 I = 0 , ILONGG-1
           ZI(JORDRE+I) = ZI(KORDRE + I)
           ZR(JTEMPS+I) = ZR(KTEMPS + I)
           ZR(JPTEM+I)  = ZR(KPTEM  + I)
 10     CONTINUE
        DO 20 I = 0 , NP1*ILONGG-1
           ZR(JDEPG+I) = ZR(KDEPG + I)
           ZR(JVITG+I) = ZR(KVITG + I)
           ZR(JACCG+I) = ZR(KACCG + I)
 20     CONTINUE
        DO 30 I = 0 , NBNL*3*ILONGG-1
           ZR(JDEP+I) = ZR(KDEP + I)
           ZR(JVIT+I) = ZR(KVIT + I)
           ZR(JFOR+I) = ZR(KFOR + I)
 30     CONTINUE
        CALL JEDETR ( '&&MDITM3_1' )
        CALL JEDETR ( '&&MDITM3_2' )
        CALL JEDETR ( '&&MDITM3_3' )
        CALL JEDETR ( '&&MDITM3_4' )
        CALL JEDETR ( '&&MDITM3_5' )
        CALL JEDETR ( '&&MDITM3_9' )
        IF ( NBNL .NE. 0 ) THEN
          CALL JEDETR ( '&&MDITM3_6' )
          CALL JEDETR ( '&&MDITM3_7' )
          CALL JEDETR ( '&&MDITM3_8' )
        ENDIF
      ENDIF
C
      CALL JEDEMA( )
      END
