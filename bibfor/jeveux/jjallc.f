      SUBROUTINE JJALLC ( ICLASI , IDATCI , CEL , IBACOL )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 27/06/2011   AUTEUR LEFEBVRE J-P.LEFEBVRE 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C TOLE CRP_18  CRS_508 CRS_512
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER             ICLASI , IDATCI ,       IBACOL
      CHARACTER*(*)                         CEL
C ----------------------------------------------------------------------
      CHARACTER*1      K1ZON
      COMMON /KZONJE/  K1ZON(8)
      INTEGER          LK1ZON , JK1ZON , LISZON , JISZON , ISZON(1)
      COMMON /IZONJE/  LK1ZON , JK1ZON , LISZON , JISZON
      EQUIVALENCE    ( ISZON(1) , K1ZON(1) )
C ----------------------------------------------------------------------
      PARAMETER  ( N = 5 )
      INTEGER          LTYP    , LONG    , DATE    , IADD    , IADM    ,
     &                 LONO    , HCOD    , CARA    , LUTI    , IMARQ   
      COMMON /IATRJE/  LTYP(1) , LONG(1) , DATE(1) , IADD(1) , IADM(1) ,
     &                 LONO(1) , HCOD(1) , CARA(1) , LUTI(1) , IMARQ(1)
      COMMON /JIATJE/  JLTYP(N), JLONG(N), JDATE(N), JIADD(N), JIADM(N),
     &                 JLONO(N), JHCOD(N), JCARA(N), JLUTI(N), JMARQ(N)
      CHARACTER*1      GENR    , TYPE
      CHARACTER*4      DOCU
      CHARACTER*8      ORIG
      CHARACTER*32     RNOM
      COMMON /KATRJE/  GENR(8) , TYPE(8) , DOCU(2) , ORIG(1) , RNOM(1)
      COMMON /JKATJE/  JGENR(N), JTYPE(N), JDOCU(N), JORIG(N), JRNOM(N)
C ----------------------------------------------------------------------
      INTEGER          ISTAT
      COMMON /ISTAJE/  ISTAT(4)
      INTEGER          IPGC,KDESMA(2),LGD,LGDUTI,KPOSMA(2),LGP,LGPUTI
      COMMON /IADMJE/  IPGC,KDESMA,   LGD,LGDUTI,KPOSMA,   LGP,LGPUTI
      INTEGER          IDINIT   ,IDXAXD   ,ITRECH,ITIAD,ITCOL,LMOTS,IDFR
      COMMON /IXADJE/  IDINIT(2),IDXAXD(2),ITRECH,ITIAD,ITCOL,LMOTS,IDFR
C ----------------------------------------------------------------------
      INTEGER        IVNMAX     , IDDESO     , IDIADD    , IDIADM     ,
     &               IDMARQ     , IDNOM      ,             IDLONG     ,
     &               IDLONO     , IDLUTI     , IDNUM
      PARAMETER    ( IVNMAX = 0 , IDDESO = 1 , IDIADD = 2 , IDIADM = 3 ,
     &               IDMARQ = 4 , IDNOM  = 5 ,              IDLONG = 7 ,
     &               IDLONO = 8 , IDLUTI = 9 , IDNUM  = 10 )
C     ------------------------------------------------------------------
      CHARACTER*1      GENRI,TYPEI
      INTEGER          COL(1),JCOL,ITAB(1)
      INTEGER          IADMI,IADDI(2),LTYPI,LONOI,ISTA1,ISTA2
C DEB ------------------------------------------------------------------
      IPGCEX = IPGC
C
C --- ON MODIFIE LA FACON DE PARCOURIR LA SEGMENTATION MEMOIRE POUR 
C --- EVITER DE LIBERER DE FACON INTEMPESTIVE DES SEGMENTS DE VALEURS
C --- QUI VIENNENT D'ETRE ALLOUES
C
      ITROLD = ITRECH
      IF (ITCOL .EQ. 2) THEN
        ITRECH = 4
      ENDIF
      IC     = ICLASI
      ID     = IDATCI
      GENRI  = GENR ( JGENR(IC) + ID )
      TYPEI  = TYPE ( JTYPE(IC) + ID )
      LTYPI  = LTYP ( JLTYP(IC) + ID )
      LONOI  = LONO ( JLONO(IC) + ID ) * LTYPI
      IADMI  = IADM ( JIADM(IC) + 2*ID-1 )
      IADYN  = IADM ( JIADM(IC) + 2*ID   )
      IADDI(1) = IADD ( JIADD(IC) + 2*ID-1 )
      IADDI(2) = IADD ( JIADD(IC) + 2*ID   )
C ------- OBJET CONTENANT LES IDENTIFICATEURS DE LA COLLECTION
      IF ( IADMI .EQ. 0 ) THEN
        IADML = 0
        IF ( IADDI(1) .EQ. 0 ) THEN
          IF ( CEL .EQ. 'E' ) THEN
            CALL JJALLS (LONOI, IC, GENRI, TYPEI, LTYPI, 'INIT',
     &                   COL, JCOL, IADML, IADYN)
          ELSE
            CALL U2MESK('F','JEVEUX_18',1,RNOM(JRNOM(IC)+ID))
          ENDIF
        ELSE
          CALL JJALLS (LONOI, IC, GENRI, TYPEI, LTYPI, 'NOINIT',
     &                 COL, JCOL, IADML, IADYN )
          CALL JXLIRO ( IC , IADML , IADDI , LONOI )
        ENDIF
        IADMI = IADML
        IADM (JIADM(IC)+2*ID-1) = IADML
        IADM (JIADM(IC)+2*ID  ) = IADYN
      ELSE
        ISTA1 = ISZON (JISZON+IADMI - 1)
        IS    = JISZON+ISZON(JISZON+IADMI-4)
        ISTA2 = ISZON (IS - 4)
        ICEL = ISTAT(3)
        IF ( CEL .EQ. 'E' ) ICEL = ISTAT(4)
        IF ( ISTA1 .EQ. ISTAT(2) .AND. ISTA2 .EQ. ICEL ) THEN
          IF ( IMARQ(JMARQ(IC)+2*ID-1) .NE. 0 ) THEN
            IBACOL = IADMI
            GOTO 100
          ENDIF
        ENDIF
      ENDIF
      IBACOL = IADMI
      CALL JJECRS (IADMI, IADYN,IC, ID, 0, CEL, IMARQ(JMARQ(IC)+2*ID-1))
 100  CONTINUE
C
      DO 20 K = 2,IDNUM
C     ----------- OBJETS ATTRIBUTS DE COLLECTION
        IX  = ISZON( JISZON + IBACOL + K )
        IF ( IX .GT. 0 ) THEN
          GENRI  = GENR ( JGENR(IC) + IX )
          TYPEI  = TYPE ( JTYPE(IC) + IX )
          LTYPI  = LTYP ( JLTYP(IC) + IX )
          LONOI  = LONO ( JLONO(IC) + IX ) * LTYPI
          IF ( LONOI .EQ. 0 ) THEN
            CALL U2MESK('F','JEVEUX_26',1,RNOM(JRNOM(IC)+IX))
          ENDIF
          IADMI  = IADM ( JIADM(IC) + 2*IX-1 )
          IADYN  = IADM ( JIADM(IC) + 2*IX  )
          IADDI(1) = IADD ( JIADD(IC) + 2*IX-1 )
          IADDI(2) = IADD ( JIADD(IC) + 2*IX   )
          IF ( IADMI .NE. 0 ) THEN
C --------- IL N'Y A RIEN A FAIRE
C
          ELSE IF ( K .NE. IDIADM .AND. K .NE. IDMARQ ) THEN
C --------- MISE EN MEMOIRE AVEC LECTURE DISQUE
            IADML = 0
            IF ( IADDI(1) .EQ. 0 ) THEN
              IF ( CEL .EQ. 'E' ) THEN
                CALL JJALLS (LONOI, IC, GENRI, TYPEI, LTYPI, 'INIT',
     &                       COL, JCOL, IADML, IADYN)
              ELSE
                CALL U2MESK('F','JEVEUX_18',1,RNOM(JRNOM(IC)+IX))
              ENDIF
            ELSE
              CALL JJALLS (LONOI, IC, GENRI, TYPEI, LTYPI, 'NOINIT',
     &                     COL, JCOL, IADML, IADYN)
              CALL JXLIRO ( IC , IADML , IADDI , LONOI )
            ENDIF
            IADMI = IADML
            IADM(JIADM(IC)+2*IX-1) = IADML
            IADM(JIADM(IC)+2*IX  ) = IADYN
          ELSE
C --------- MISE EN MEMOIRE SANS LECTURE DISQUE
            CALL JJALLS (LONOI, IC, GENRI, TYPEI, LTYPI, 'INIT',
     &                   ITAB, JCTAB, IADMI, IADYN)
            IADM(JIADM(IC)+2*IX-1) = IADMI
            IADM(JIADM(IC)+2*IX  ) = IADYN
          ENDIF
          IF ( (K.EQ.IDNOM  .OR. K.EQ.IDLONG  .OR.
     &          K.EQ.IDLONO .OR. K.EQ.IDLUTI)
     &         .AND.  RNOM(JRNOM(IC)+IX)(25:26) .NE. '$$'    ) THEN
            IPGC   = -1
          ENDIF
          CALL JJECRS (IADMI,IADYN,IC,IX,0,CEL,IMARQ(JMARQ(IC)+2*IX-1))
          IPGC = IPGCEX
        ENDIF
 20   CONTINUE
C
      ITRECH = ITROLD
      IX  = ISZON( JISZON + IBACOL + IDDESO )
      LTYPI  = LTYP ( JLTYP(IC) + IX )
      LONOI  = LONO ( JLONO(IC) + IX ) * LTYPI
      IF ( LONOI .GT. 0 ) THEN
        IADMI  = IADM ( JIADM(IC) + 2*IX-1 )
        IADYN  = IADM ( JIADM(IC) + 2*IX  )
        IF ( IADMI .NE. 0 ) THEN
          CALL JJECRS (IADMI,IADYN,IC,IX,0,CEL,IMARQ(JMARQ(IC)+2*IX-1))
        ENDIF
      ENDIF
C FIN ------------------------------------------------------------------
      END
