      SUBROUTINE JJCPSG ( RPART , ICODE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 16/06/2000   AUTEUR D6BHHJP J.P.LEFEBVRE 
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
C TOLE CRP_18 CRS_508
      IMPLICIT REAL*8 (A-H,O-Z)
C ----------------------------------------------------------------------
C ROUTINE INTERNE JEVEUX DE PARTIONNEMENT DE LA SEGMENTATION MEMOIRE
C
C IN  RPART  : REEL INDIQUANT LA PROPORTION ENTRE LES DEUX PARTITIONS
C IN  ICODE  : CODE VALANT 1 POUR LA CONSTUCTION DE LA PARTITION
C                   VALANT 0 POUR LA DESTRUCTION DE LA PARTITION
C
C ----------------------------------------------------------------------
      CHARACTER*1      K1ZON
      COMMON /KZONJE/  K1ZON(8)
      INTEGER          LK1ZON , JK1ZON , LISZON , JISZON , ISZON(1)
      COMMON /IZONJE/  LK1ZON , JK1ZON , LISZON , JISZON
      EQUIVALENCE    ( ISZON(1) , K1ZON(1) )
C ----------------------------------------------------------------------
      INTEGER          IDINIT   ,IDXAXD   ,ITRECH,ITIAD,ITCOL,LMOTS,IDFR
      COMMON /IXADJE/  IDINIT(2),IDXAXD(2),ITRECH,ITIAD,ITCOL,LMOTS,IDFR
      INTEGER          ISTAT
      COMMON /ISTAJE/  ISTAT(4)
C ----------------------------------------------------------------------
      CHARACTER *75    CMESS
      INTEGER          IADPAR
C DEB ------------------------------------------------------------------
      IF ( ICODE .EQ. 1 ) THEN
        IF ( RPART .LE. 0.D0 .OR. RPART .GT. 1.D0 ) THEN
          CMESS = 'LA VALEUR DU RAPPORT ENTRE PARTITIONS EST INVALIDE'
          CALL JVMESS('F','JJCPSG01',CMESS)
        ENDIF
        IADPAR = LISZON * (1.0D0 - RPART)
        IADP   = ISZON(JISZON + LISZON - 4 )
        IF ( IADPAR+16 .GT. LISZON .OR. IADPAR .LT. IADP+12 ) THEN
          CMESS = 'LA VALEUR DU RAPPORT ENTRE PARTITIONS NE '
     +          //'CONVIENT PAS'
          CALL JVDEBM('S','JJCPSG02',CMESS)
          CMESS=' LA LONGUEUR DE LA PARTITION 1 DOIT ETRE AU MINIMUM DE'
          CALL JVIMPI('L',CMESS,1,IADP)
          CALL JVIMPK('L',' MOTS',0,' ')
          CALL JVIMPI('S',' (ENVIRON ',1,(IADP+12)*100/LISZON)
          CALL JVIMPK('S',' %)',0,' ')
          CALL JVFINM()
        ENDIF
        ISZON(JISZON + LISZON - 4 ) = IADPAR + 3
        ISZON(JISZON + IADPAR + 3 ) = 0
        ISZON(JISZON + IADPAR + 4 ) = LISZON - 3
        ISZON(JISZON + IADP   + 1 ) = IADPAR - 4
        ISZON(JISZON + IADPAR - 4 ) = 0
        ISZON(JISZON + IADPAR - 5 ) = IADP
        ISZON(JISZON + IADPAR + 1 ) = 0
        ISZON(JISZON + IADPAR + 2 ) = 0
        ISZON(JISZON + IADPAR - 2 ) = 0
        ISZON(JISZON + IADPAR - 3 ) = 0
        ISZON(JISZON + IADPAR - 8 ) = ISTAT(1)
        ISZON(JISZON + IADPAR - 1 ) = ISTAT(1)
        ISZON(JISZON + IADPAR     ) = ISTAT(1)
        ISZON(JISZON + IADPAR + 7 ) = ISTAT(1)
        IDINIT(2) = IADPAR + 4
        IDXAXD(2) = IADPAR + 4
        IDFR = IADPAR
      ELSE IF ( ICODE .EQ. 0 ) THEN
        IADPAR = IDFR
        ISZON(JISZON + IADPAR + 3 ) = IADPAR - 5
        ISZON(JISZON + IADPAR - 4 ) = IADPAR + 4
        ISZON(JISZON + IADPAR - 1 ) = ISTAT(1)
        ISZON(JISZON + IADPAR     ) = ISTAT(1)
        IDINIT(2) = ISZON(JISZON + LISZON - 4) + 1
        IDXAXD(2) = IDINIT(2)
        IDFR = 0
        ITCOL = 1
       CALL JVMESS('I','JJCPSG01','SUPPRESSION DE LA PARTITION MEMOIRE')
      ENDIF
C FIN ------------------------------------------------------------------
      END
