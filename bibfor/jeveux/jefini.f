      SUBROUTINE JEFINI ( COND )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 19/02/2007   AUTEUR LEFEBVRE J-P.LEFEBVRE 
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
C TOLE CRP_12 CRS_505
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)       COND
C     ==================================================================
      PARAMETER  ( N = 5 )
C
      INTEGER          LK1ZON , JK1ZON , LISZON , JISZON , ISZON(1)
      COMMON /IZONJE/  LK1ZON , JK1ZON , LISZON , JISZON
      INTEGER          NBFIC
      COMMON /IPARJE/  NBFIC
C     ------------------------------------------------------------------
      CHARACTER*2      DN2
      CHARACTER*5      CLASSE
      CHARACTER*8                  NOMFIC    , KSTOUT    , KSTINI
      COMMON /KFICJE/  CLASSE    , NOMFIC(N) , KSTOUT(N) , KSTINI(N) ,
     &                 DN2(N)
C
      INTEGER          IPGC,KDESMA(2),LGD,LGDUTI,KPOSMA(2),LGP,LGPUTI
      COMMON /IADMJE/  IPGC,KDESMA,   LGD,LGDUTI,KPOSMA,   LGP,LGPUTI
C     ==================================================================
      CHARACTER*8      KCOND , STAOU
      CHARACTER*24     LADATE
      CHARACTER*75     CMESS
C     ------------------------------------------------------------------
C
      KCOND  = COND ( 1: MIN( LEN(COND) , LEN(KCOND) ) )
      IF ( KCOND .NE. 'NORMAL  ' .AND. KCOND .NE. 'ERREUR  ' .AND.
     &     KCOND .NE. 'TEST    '  ) THEN
         CMESS = 'CONDITION DE CLOTURE '//KCOND//' ERRONEE'
         CALL U2MESK('F','JEVEUX_01',1,CMESS)
      ELSE IF ( KCOND .EQ. 'NORMAL  ' .OR. KCOND .EQ. 'TEST    ' ) THEN
         STAOU = '        '
      ELSE
         STAOU = 'SAUVE   '
      ENDIF
C     -------------  EDITION DES REPERTOIRES ---------------------------
      IF ( KCOND .EQ. 'TEST    '  ) THEN
        DO 5 I = 1 , NBFIC
          IF ( CLASSE(I:I) .NE. ' ' ) THEN
            CALL JEIMPR ( 'MESSAGE' , CLASSE(I:I) ,
     &                    '     JEFINI     ' // KCOND )
          ENDIF
   5    CONTINUE
C     -------------  EDITION SEGMENTATION MEMOIRE ----------------------
        CALL JEIMPM ( 'MESSAGE' , '     JEFINI     ' // KCOND   )
      ENDIF
C     -------------  LIBERATION FICHIER --------------------------------
      IF ( KCOND .NE. 'ERREUR  ' )   THEN
        DO 10 I = 1 , NBFIC
          IF ( CLASSE(I:I) .NE. ' ' ) THEN
            CALL JELIBF ( STAOU , CLASSE(I:I) )
          ENDIF
   10   CONTINUE
C       -----------  DESALLOCATION GESTION DES MARQUES -----------------
        IF ( KDESMA(2) .NE. 0) THEN
          CALL HPDEALLC (KDESMA(2), IBID, IBID)
        ELSE IF (KDESMA(1) .NE. 0) THEN
          CALL JJLIBP (KDESMA(1))
        ENDIF  
        IF ( KPOSMA(2) .NE. 0) THEN
          CALL HPDEALLC (KPOSMA(2), IBID, IBID)
        ELSE IF (KPOSMA(1) .NE. 0) THEN
          CALL JJLIBP (KPOSMA(1))
        ENDIF  
        KDESMA(1) = 0
        KDESMA(2) = 0
        KPOSMA(1) = 0
        KPOSMA(2) = 0
C       -----------  DESALLOCATION MEMOIRE -----------------------------
        CALL JXLIBM ( ISZON , LISZON )
C
      ELSE
        CALL JXABOR()
      ENDIF
C
      IF ( KCOND .NE. 'TEST    ') THEN
        IFM = IUNIFI('ERREUR')
        IF (IFM .GT. 0) THEN
          WRITE(IFM,*) '<I>       FERMETURE DES BASES EFFECTUEE'
        ENDIF
        IFM = IUNIFI('MESSAGE')
        IF (IFM .GT. 0) THEN
          CALL ENLIRD(LADATE)
          WRITE(IFM,*) '<I>       FIN D''EXECUTION LE : '//LADATE
C
C       --- ON FERME TOUT ---
        ENDIF
C
        CALL ULCLOS
C
        CALL XFINI(19)
      ENDIF
      END
