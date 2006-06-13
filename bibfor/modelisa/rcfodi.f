      SUBROUTINE RCFODI(IFON,BETA,F,DF)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 17/12/2002   AUTEUR CIBHHGB G.BERTRAND 
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
      IMPLICIT NONE
      INTEGER           IFON
      REAL*8                 BETA,F,DF
C ......................................................................
C     ROUTINE INVERSE DE RCFODE :
C     UTILISEE UNIQUEMENT POUR LA FONCTION ENTHALPIE DANS
C     L OPERATEUR THER_NON_LINE_MO (REPERE MOBILE)
C     LA FONCTION FOURNIE PAR LE MATERIAU CODE EST BETA=F(TEMPERATURE)
C     ON CALCULE ICI TEMPERATURE=F-1(BETA), DE MEME QUE LA DERIVEE DE
C     CETTE FONCTION.
C IN   IFON   : ADRESSE DANS LE MATERIAU CODE DE LA FONCTION
C IN   BETA   : ENTHALPIE AU POINT DE GAUSS CONSIDERE
C OUT  F      : VALEUR DE LA FONCTION (TEMPERATURE)
C OUT  DF     : VALEUR DE LA DERIVEE DE LA FONCTION
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
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
      INTEGER            JPRO,JVALF,JV,JP,NBVF
      INTEGER            ISAVE,IDEB,IFIN,INCR,INDFCT
      LOGICAL            TESINF,TESSUP,ENTRE,DEJA,AVANT
      CHARACTER*8        K8BID
C ----------------------------------------------------------------------
C PARAMETER ASSOCIE AU MATERIAU CODE
C
      PARAMETER  ( INDFCT = 7 )
C DEB ------------------------------------------------------------------
      NBVF = ZI(IFON)
      JPRO  = ZI(IFON+1)
      JVALF = ZI(IFON+2)
      IF (ZK16(JPRO)(1:1).EQ.'C') THEN
        F  = ZR(JVALF+NBVF+1)
        DF = 0.D0
        GOTO 101
      ENDIF
      ISAVE = ZI(IFON+INDFCT)
      IF (ZK16(JPRO)(1:1).EQ.'N') THEN
C
C---- NAPPE - IMPOSSIBLE
C
        CALL UTMESS ('F','RCFODE_01','NAPPE INTERDITE POUR'
     &              //' LES CARACTERISTIQUES MATERIAU')
      ENDIF
C
      DEJA   = BETA.GE.ZR(JVALF+ISAVE+NBVF-1) .AND.
     &         BETA.LE.ZR(JVALF+ISAVE+NBVF)
      AVANT  = BETA.LT.ZR(JVALF+ISAVE+NBVF-1)
      TESINF = BETA.LT.ZR(JVALF+NBVF)
      TESSUP = BETA.GT.ZR(JVALF+NBVF+NBVF-1)
      ENTRE  = .NOT. TESINF .AND. .NOT. TESSUP
      IF (DEJA) THEN
        JP = JVALF + ISAVE
        JV = JP    + NBVF
        DF = (ZR(JP)-ZR(JP-1))/(ZR(JV)-ZR(JV-1))
        F = DF*(BETA-ZR(JV-1))+ZR(JP-1)
        GOTO 100
      ELSE
        IF ( AVANT ) THEN
          IFIN = JVALF
          IDEB = JVALF+ISAVE-1
          INCR = -1
        ELSE
          IDEB = JVALF+ISAVE
          IFIN = JVALF+NBVF-1
          INCR = 1
        ENDIF
      ENDIF
      IF (ENTRE) THEN
        IF ( INCR .GT. 0 ) THEN
          DO 8 JP=IDEB,IFIN,INCR
            JV = JP + NBVF
            IF (ZR(JV).GE.BETA) THEN
              DF = (ZR(JP)-ZR(JP-1))/(ZR(JV)-ZR(JV-1))
               F = DF*(BETA-ZR(JV-1))+ZR(JP-1)
              ISAVE = JP-JVALF
              GOTO 5
            END IF
 8        CONTINUE
 5        CONTINUE
        ELSE
          DO 9 JP=IDEB,IFIN,INCR
            JV = JP + NBVF
            IF (ZR(JV).LE.BETA) THEN
              DF = (ZR(JP+1)-ZR(JP))/(ZR(JV+1)-ZR(JV))
               F = DF*(BETA-ZR(JV))+ZR(JP)
              ISAVE = JP-JVALF+1
              GOTO 6
            END IF
 9        CONTINUE
 6        CONTINUE
        ENDIF
      ELSE IF (TESINF) THEN
        JV = JVALF+NBVF
        JP = JVALF
        IF (ZK16(JPRO+4)(2:2).EQ.'C') THEN
          DF = 0.0D0
           F = ZR(JP)
        ELSE IF (ZK16(JPRO+4)(1:1).EQ.'L') THEN
          DF = (ZR(JP+1)-ZR(JP))/(ZR(JV+1)-ZR(JV))
           F = DF*(BETA-ZR(JV))+ZR(JP)
        ELSE IF (ZK16(JPRO+4)(1:1).EQ.'E') THEN
          CALL UTMESS ('F','RCFODE_02',' ON DEBORDE A GAUCHE')
        END IF
        ISAVE = 1
      ELSE IF (TESSUP) THEN
        JV = JVALF + 2*NBVF - 1
        JP = JVALF + NBVF - 1
        IF (ZK16(JPRO+4)(2:2).EQ.'C') THEN
          DF = 0.0D0
           F = ZR(JP)
        ELSE IF (ZK16(JPRO+4)(2:2).EQ.'L') THEN
          DF = (ZR(JP)-ZR(JP-1))/(ZR(JV)-ZR(JV-1))
           F = DF*(BETA-ZR(JV-1))+ZR(JP-1)
        ELSE IF (ZK16(JPRO+4)(2:2).EQ.'E') THEN
          CALL UTMESS ('F','RCFODE_03',' ON DEBORDE A DROITE')
        END IF
        ISAVE = NBVF - 1
      END IF
 100  CONTINUE
      ZI(IFON+INDFCT) = ISAVE
 101  CONTINUE
C FIN ------------------------------------------------------------------
      END
