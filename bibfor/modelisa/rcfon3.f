      SUBROUTINE RCFON3(QUEST,VALE,E,NU,P, RP,RPRIM,C,SIELEQ,DP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 02/06/2003   AUTEUR G8BHHXD X.DESROCHES 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*1      QUEST
      REAL*8           E,NU,P,SIELEQ,RP,RPRIM,C,DP,VALE(10)
C ----------------------------------------------------------------------
C     INTERPOLATION SUR UNE FONCTION DE TYPE R(P)
C
C IN  QUEST   : 'V' -> CALCUL DE RP, RPRIM ET AIRERP
C                 IN: P  OUT: RP,RPRIM,AIRERP
C               'E' -> CALCUL DE L'INCREMENT DP, RACINE DE L'EQUATION
C                 IN : E(T+),NU(T+),P-,SIELEQ+
C                 OUT: RP(P+),RPRIM(P+),AIRERP(P+),DP

C IN  VALE    : VALEUR DE LA  FONCTION R(P)
C IN  E       : MODULE D'YOUNG
C IN  NU      : COEFFICIENT DE POISSON
C IN  P       : VARIABLE INTERNE
C OUT RP      : VALEUR DE R(P).
C OUT RPRIM   : VALEUR DE LA DERIVEE DE R(P) EN P
C IN  C       : CONSTANTE DE PRAGER
C IN  SIELEQ  : CONTRAINTE ELASTIQUE EQUIVALENTE
C OUT DP      : INCREMENT DE DEFORMATION PLASTIQUE CUMULEE.
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
      LOGICAL       TESSUP
      INTEGER       I,I0,NBVALE
      REAL *8       P0,RP0,PP,EQU,DEUXMU,RPM


C - INITIALISATION
      NBVALE = 4
      IF (P.LT.0) CALL UTMESS ('F','RCFON3',
     &            'DEFORMATION PLASTIQUE CUMULEE P < 0')
      TESSUP = .FALSE.

C - PARCOURS JUSQU'A P
      DO 10 I=1,NBVALE-1
        IF (P.LT.VALE(I+1)) THEN
          I0 = I-1
          GOTO 20
        ENDIF
10    CONTINUE
      TESSUP = .TRUE.
      I0=NBVALE-1
20    CONTINUE
  
C - CALCUL DES VALEURS DE R(P), R'(P) ET AIRE(P)

      IF (QUEST.EQ.'V') THEN
        IF (TESSUP) THEN
         CALL UTMESS('F','RCFON3','ON DEBORDE A DROITE '//
     &      'REDEFINISSEZ VOS NAPPES ALPHA - MOMENT')
        ELSE

          RPRIM = (VALE(NBVALE+I0+2)-VALE(NBVALE+I0+1))/
     &            (VALE(I0+2)-VALE(I0+1))
        ENDIF

        P0  = VALE(I0+1)
        RP0 = VALE(NBVALE+I0+1)
        RP     = RP0 + RPRIM*(P-P0) - 1.5D0*C*P
        RPRIM = RPRIM - 1.5D0*C
        GOTO 9999
      ENDIF

C - RESOLUTION DE L'EQUATION R(P+DP) + 3/2*(2MU+C) DP = SIELEQ

      DEUXMU = E/(1+NU)
      DO 30 I=I0+1,NBVALE-1
        EQU = VALE(NBVALE+I+1) + 1.5D0*(DEUXMU+C)*(VALE(I+1)-P) - SIELEQ
        IF (EQU.GT.0) THEN
          I0 = I-1
          GOTO 40
        ENDIF
30    CONTINUE
      TESSUP = .TRUE.
      I0 = NBVALE-1
40    CONTINUE



C - CALCUL DES VALEURS DE DP, R(P+DP), R'(P+DP)

      IF (TESSUP) THEN
         CALL UTMESS('F','RCFON3','ON DEBORDE A DROITE'//
     &     ' REDEFINISSEZ VOS NAPPES ALPHA - MOMENT')
      ELSE
        RPRIM = (VALE(NBVALE+I0+2)-VALE(NBVALE+I0+1))/
     &          (VALE(I0+2)-VALE(I0+1))
      ENDIF
      P0  = VALE(I0+1)
      RP0 = VALE(NBVALE+I0+1)
      RPM = RP0+RPRIM*(P-P0) -1.5D0*C*P
      DP  = (SIELEQ-RPM)/(1.5D0*DEUXMU+RPRIM)
      PP     = P+DP
      RP     = RP0 + RPRIM*(PP-P0)-1.5D0*C*PP
      RPRIM = RPRIM - 1.5D0*C
9999  CONTINUE
      END
