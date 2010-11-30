      SUBROUTINE DMGMOD(NOMSYM,NOMSD,NOMSD2,NOMMAT,
     &                  NBORDR,JORDR,JCOEF,NBPT,NTCMP,
     &                  NUMCMP,IMPR,VDOMAG)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*8       NOMMAT
      CHARACTER*16      NOMSYM
      CHARACTER*19      NOMSD,NOMSD2
      REAL*8                              VDOMAG(*)
      INTEGER           NBPT,NUMCMP(*)
      INTEGER           NTCMP,IMPR,NBORDR,JORDR,JCOEF
C       ----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 06/07/2009   AUTEUR GALENNE E.GALENNE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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
C       ----------------------------------------------------------------
C       CREATION D UN VECTEUR AUX NOEUDS/PG : AMPLITUDE MAX DE VIBRATION
C       METHODE CALCUL DU DOMMAGE UNITAIRE = /WOHLER
C       ----------------------------------------------------------------
C       IN     NOMSYM    NOM SYMBOLIQUE OPTION EQUI_GD
C              NOMSD     NOM SD RESULTAT STATIQUE
C              NOMSD2     NOM SD RESULTAT MODAL
C              NOMMAT    NOM DU CHAM_MATER
C              NBORDR    NOMBRE DE NUMEROS D'ORDRE 
C              JORD      ADRESSE DE LA LISTE DES NUMEROS D'ORDRE 
C              JCEIF      ADRESSE DE LA LISTE DES COEFFICIENTS
C              NBPT      NOMBRE DE POINTS DE CALCUL DU DOMMAGE
C              NTCMP     NOMBRE TOTAL DE COMPOSANTE OPTION EQUI_GD
C              NUMCMP    NUMERO(S) DE LA(DES) COMPOSANTE(S) DE EQUI_GD
C              IMPR      NIVEAU IMPRESSION
C       OUT    VDOMAG    VECTEUR DOMMAGE AUX POINTS
C       ----------------------------------------------------------------
C       ----- DEBUT COMMUNS NORMALISES  JEVEUX  ------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*6        PGC
      COMMON  / NOMAJE / PGC
      CHARACTER*32       JEXNOM,        JEXNUM
C       ---------------------------------------------------------------
      CHARACTER*8     K8B,KCMP,NOMRM(1),NOMPAR,KCORRE,NOMFON
      CHARACTER*10    NOMPHE
      CHARACTER*16    K16B
      CHARACTER*19    CHEQUI,CHEQU2(NBORDR)
      CHARACTER*24    NOMDMG
      CHARACTER*24    VALK(3)
      CHARACTER*2     CODRET
C
      REAL*8          SU,SALT0,DMAX,SALTM,VAL(1)
      REAL*8          VALR(3),R8B,DMIN,SMAX,COEFF,R8MIN
C
      INTEGER         IPT,IORD,ICMP,NBR,NBK,NBC,NBF
      INTEGER         IVCH,IVORD,IVPT,IBID,IVALK
      INTEGER         NUMSYM,IVCH2,IVORD2(NBORDR),NUMORD
      LOGICAL        CRIT
C
C ---   VECTEURS DE TRAVAIL
C
      CALL JEMARQ()
           
      NOMDMG = '&&OP0151.EQUI_GD'
      CALL WKVECT( NOMDMG , 'V V R', 2       , IVPT  )
      
      CALL GETVTX(' ','CORR_SIGM_MOYE',1,1,1,KCORRE,IBID)
C
C --    VECTEUR DES NUMORD NOMS DE CHAMPS POUR L OPTION NOMSYM
C
      CALL JENONU(JEXNOM(NOMSD//'.DESC',NOMSYM),NUMSYM)
      IF(NUMSYM.EQ.0) THEN
         VALK(1) = NOMSYM
         VALK(2) = NOMSD
         CALL U2MESK('F','PREPOST_51', 2 ,VALK)
      ENDIF
      CALL JEVEUO(JEXNUM(NOMSD//'.TACH',NUMSYM),'L',IVCH)
C
      CALL JENONU(JEXNOM(NOMSD2//'.DESC',NOMSYM),NUMSYM)
      IF(NUMSYM.EQ.0) THEN
         VALK(1) = NOMSYM
         VALK(2) = NOMSD2
         CALL U2MESK('F','PREPOST_51', 2 ,VALK)
      ENDIF
      CALL JEVEUO(JEXNUM(NOMSD2//'.TACH',NUMSYM),'L',IVCH2)
C
C RECUPERATION PROPRIETES MATERIAUX
C
      NOMRM(1) = 'SU'
      NOMPAR = ' '
      CALL RCVALE(NOMMAT,'RCCM',0,NOMPAR,R8B,1,NOMRM,VAL,
     &                CODRET,'F ')
      IF (CODRET.NE.'OK') THEN
         VALK(1) = 'SU'
         CALL U2MESK('F','FATIGUE1_88', 1 ,VALK)
      ENDIF
      SU = VAL(1)
C   
      NOMPHE = 'FATIGUE   '
      CALL JELIRA (NOMMAT//'.'//NOMPHE//'.VALR','LONUTI',NBR,K8B)
      CALL JELIRA (NOMMAT//'.'//NOMPHE//'.VALC','LONUTI',NBC,K8B)
      CALL JEVEUO (NOMMAT//'.'//NOMPHE//'.VALK', 'L',IVALK)
      CALL JELIRA (NOMMAT//'.'//NOMPHE//'.VALK','LONUTI',NBK,K8B)
      NBF = (NBK-NBR-NBC)/2
      DO 50 IK = 1, NBF
        IF (ZK8(IVALK-1+NBR+NBC+IK) .EQ. 'WOHLER') THEN
          NOMFON = ZK8(IVALK-1+NBR+NBC+NBF+IK)
          CALL JEVEUO(NOMFON//'           .VALE','L',IVALF)
          SALT0=ZR(IVALF)
        ENDIF
  50  CONTINUE
C      
      VALR(1) = SU
      VALR(2) = SALT0
      CALL U2MESG('I','FATIGUE1_87',0,' ',0,0,2,VALR)
C
      ICMP = 1
      DMIN = 1.D10
      SMAX= 0.D0
      CRIT = .FALSE.
      R8MIN = R8MIEM()
C
C ---       CALCUL DU VECTEUR HISTOIRE DE LA EQUI_GD EN CE POINT
C
       CHEQUI  = ZK24(IVCH)(1:19)
       IF(CHEQUI.EQ.' ') THEN
          VALK(1) = CHEQUI
          VALK(2) = NOMSYM
          VALK(3) = NOMSD
          CALL U2MESK('F','PREPOST_52', 3 ,VALK)
       ENDIF
       CALL JEVEUO(CHEQUI//'.CELV','L',IVORD)
       
       DO 11 IORD = 1, NBORDR
         NUMORD = ZI(JORDR+IORD-1)
         CHEQU2(IORD)  = ZK24(IVCH2+NUMORD-1)(1:19)
         IF(CHEQU2(IORD).EQ.' ') THEN
            VALK(1) = CHEQU2(IORD)
            VALK(2) = NOMSYM
            VALK(3) = NOMSD2
            CALL U2MESK('F','PREPOST_52', 3 ,VALK)
         ENDIF
         CALL JEVEUO(CHEQU2(IORD)//'.CELV','L',IVORD2(IORD))
 11    CONTINUE
C
C ---     BOUCLE SUR LES POINTS
C
      DO 10 IPT = 1 , NBPT
C -    STOCKAGE CONTRAINTES
        ZR(IVPT) = ZR(IVORD+(IPT-1)*NTCMP+NUMCMP(ICMP)-1)
        ZR(IVPT+1) = 0.D0
        DO 12 IORD = 1, NBORDR
          COEFF = ZR(JCOEF+IORD-1)
          ZR(IVPT+1) = ZR(IVPT+1) + COEFF*
     &              ABS(ZR(IVORD2(IORD)+(IPT-1)*NTCMP+NUMCMP(ICMP)-1))
 12     CONTINUE

       IF (ZR(IVPT) .GT. SU) THEN
         IF(IMPR.GE.2) CALL U2MESG('I','FATIGUE1_80',0,' ',0,0,0,VALR)
         SALTM = 0.D0
         CRIT = .TRUE.
         SMAX = MAX(ZR(IVPT) , SMAX)
       ELSEIF (ZR(IVPT) .GT. 0.D0) THEN
         IF (KCORRE.EQ.'GOODMAN') THEN
           SALTM = SALT0 *(1 - ZR(IVPT)/SU )
         ELSE IF (KCORRE.EQ.'GERBER') THEN
           SALTM = SALT0 *(1 - (ZR(IVPT)/SU)**2 )
         ENDIF
       ELSE
         SALTM = SALT0
       ENDIF
C       
       IF (ABS(ZR(IVPT+1)) .GT. R8MIN) THEN
         DMAX = SALTM / ABS(ZR(IVPT+1)) 
       ELSE 
         DMAX = 1.D10
       ENDIF
       IF (DMAX .LT. DMIN)  DMIN = DMAX
       
       VDOMAG(IPT) = DMAX
       IF(IMPR.GE.2) THEN
         VALR (1) = ZR(IVPT)
         VALR (2) = ZR(IVPT+1)
         VALR (3) = DMAX
         CALL U2MESG('I','FATIGUE1_79',0,' ',1,IPT,3,VALR)
       ENDIF
C
 10     CONTINUE
C
      IF (CRIT) THEN
         VALR (1) = SMAX
         VALR (2) = SU
        CALL U2MESG('A','FATIGUE1_83',0,' ',0,0,2,VALR)
      ENDIF
      CALL U2MESG('I','FATIGUE1_82',0,' ',0,0,1,DMIN)
C
C
      CALL JEDEMA()
      END
