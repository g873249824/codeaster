      SUBROUTINE DISTNO(XLOCAL,SIGNE,TYPEOB,XJEU,DIST1,DIST2,NBSEG,
     &                  DNORM,COST,SINT )
      IMPLICIT  REAL*8 (A-H,O-Z)
      REAL*8            XLOCAL(6),SIGNE(*)
      CHARACTER*8       TYPEOB
C---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/03/2004   AUTEUR REZETTE C.REZETTE 
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
C
C     CALCULE LA DISTANCE NORMALE A L'OBSTACLE (<0 SI CHOC)
C---------------------------------------------------------------------
C IN  : XLOCAL : COORDONNES DANS LE REPERE LOCAL
C IN  : SIGNE  : POUR UN BI_PLAN_Y  SIGNE= SIGNE DE Y20LOC-Y10LOC
C                POUR UN BI_PLAN_Z  SIGNE= SIGNE DE Z20LOC-Z10LOC
C IN  : TYPEOB : NOM DECRIVANT LE TYPE D'OBSTACLE CERCLE,PLAN.
C IN  : XJEU   : VALEUR DU JEU POUR OBSTACLE CERCLE OU PLAN
C IN  : DIST1  : VALEUR DE EPAISSEUR DE DIST1 POUR BIPLAN
C IN  : DIST2  : VALEUR DE EPAISSEUR DE DIST2 POUR BIPLAN
C IN  : NBSEG  : NB DE SEGMENTS DE DISCRETISATION SI DISCRET
C OUT : DNORM  : DISTANCE NORMALE A L'OBSTACLE
C OUT : COST   : DIRECTION NORMALE A L'OBSTACLE
C OUT : SINT   : DIRECTION NORMALE A L'OBSTACLE
C---------------------------------------------------------------------
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
      CHARACTER*8 K8BID
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      CALL JEMARQ()
      ZERO = 0.D0
      UN   = 1.D0
      DEPI = R8DEPI()
C
C     --- OBSTACLE CIRCULAIRE ---
      IF ( TYPEOB .EQ. 'CERCLE  ' ) THEN
         XLG = SQRT( XLOCAL(2)**2 + XLOCAL(3)**2 )
         DNORM = XJEU - XLG
         IF (XLG.NE.0.D0) THEN
            SINT = -XLOCAL(3) / XLG
            COST = -XLOCAL(2) / XLG
         ELSE
           SINT =  ZERO
           COST = -UN
        ENDIF
C
C     --- OBSTACLES CIRCULAIRES ---
      ELSEIF (TYPEOB.EQ.'BI_CERCL') THEN
        XLG = SQRT( (XLOCAL(2)-XLOCAL(5))**2+(XLOCAL(3)-XLOCAL(6))**2 )
        DNORM = XLG - DIST1 - DIST2
        COST  = ( XLOCAL(2) - XLOCAL(5) ) / XLG
        SINT  = ( XLOCAL(3) - XLOCAL(6) ) / XLG
C     --- OBSTACLES CIRCULAIRES CONCENTRIQUES ---
      ELSEIF (TYPEOB.EQ.'BI_CERCI') THEN
        XLG = SQRT( (XLOCAL(2)-XLOCAL(5))**2+(XLOCAL(3)-XLOCAL(6))**2 )
        DNORM = DIST2 - DIST1 -XLG
        IF (XLG .GT. 0.D0) THEN
           COST = ( XLOCAL(5) - XLOCAL(2) ) / XLG
           SINT = ( XLOCAL(6) - XLOCAL(3) ) / XLG
        ELSE
           COST = -UN
           SINT = ZERO
        ENDIF
C
C     --- OBSTACLE PLAN PARALLELE A YLOCAL ---
      ELSEIF ( TYPEOB .EQ. 'PLAN_Y  ' ) THEN
         DNORM = XJEU - ABS(XLOCAL(2))
         SINT  = ZERO
         COST  = -SIGN( UN,XLOCAL(2) )
C
C     --- OBSTACLE PLANS PARALLELES A YLOCAL ---
      ELSEIF (TYPEOB.EQ.'BI_PLANY') THEN
        DNORM = ( XLOCAL(5)-XLOCAL(2) ) * SIGNE(1)- DIST1 - DIST2
        SINT  = ZERO
C        COST  = -SIGN(UN,(XLOCAL(5)-XLOCAL(2)))
        COS2  = -SIGN(UN,(XLOCAL(5)-XLOCAL(2)))
        COST = -SIGNE(1)
        IF (COS2.NE.COST) CALL UTMESS('A','DISTNO',
     +   ' INTERPENETRATION SUPERIEURE A DIST1 PLUS DIST2')
C
C     --- OBSTACLE PLAN PARALLELE A ZLOCAL ---
      ELSEIF ( TYPEOB .EQ. 'PLAN_Z  ' ) THEN
         DNORM = XJEU - ABS(XLOCAL(3))
         COST  = ZERO
         SINT  = -SIGN( UN,XLOCAL(3) )
C
C     --- OBSTACLE PLANS PARALLELES A ZLOCAL ---
      ELSEIF ( TYPEOB .EQ. 'BI_PLANZ' ) THEN
        DNORM = ( XLOCAL(6) - XLOCAL(3) ) * SIGNE(2) - DIST1 - DIST2
        COST  = ZERO
C        SINT  = -SIGN(UN,(XLOCAL(6)-XLOCAL(3)))
        SIN2  = -SIGN(UN,(XLOCAL(6)-XLOCAL(3)))
        SINT = -SIGNE(2)
        IF (SIN2.NE.SINT) CALL UTMESS('A','DISTNO',
     +   ' INTERPENETRATION SUPERIEURE A DIST1 PLUS DIST2')
C
C     --- OBSTACLE DISCRETISE ---
      ELSE
        CALL JEVEUO(TYPEOB//'           .VALR','L',IDRAYO)
        CALL JEVEUO(TYPEOB//'           .VALT','L',IDTHET)
        CALL JELIRA(TYPEOB//'           .VALT','LONMAX',NBSEG,K8BID)
        XLG = SQRT(XLOCAL(2)**2+XLOCAL(3)**2)
        IF ( XLG.NE.0.D0) THEN
           SINTNO = XLOCAL(3) / XLG
           COSTNO = XLOCAL(2) / XLG
        ELSE
           SINTNO = ZERO
           COSTNO = UN
        ENDIF
        TETANO = ATAN2(SINTNO,COSTNO)
        IF ( TETANO.LT.ZERO) TETANO = TETANO + DEPI
        DO 10 I = 1,NBSEG-1
           R1 = ZR(IDRAYO+I-1)
           R2 = ZR(IDRAYO+I)
           T1 = ZR(IDTHET+I-1)
           T2 = ZR(IDTHET+I)
           IF (TETANO.GE.T1.AND.TETANO.LE.T2) THEN
              Y1 = R1*COS(T1)
              Y2 = R2*COS(T2)
              Z1 = R1*SIN(T1)
              Z2 = R2*SIN(T2)
              DY = Y2-Y1
              DZ = Z2-Z1
              XLS = SQRT(DY*DY+DZ*DZ)
              IF (XLS.NE.0.D0) THEN
                 COST = -DZ / XLS
                 SINT = DY / XLS
              ELSE
                 SINT = ZERO
                 COST = -UN
              ENDIF
              DNORM = (XLOCAL(2)-Y1)*COST+(XLOCAL(3)-Z1)*SINT
              GOTO 9999
            ENDIF
 10      CONTINUE
      ENDIF
C
 9999 CONTINUE
      CALL JEDEMA()
      END
