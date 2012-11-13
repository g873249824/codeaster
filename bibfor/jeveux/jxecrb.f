      SUBROUTINE JXECRB ( IC , IADDI , IADMO , LSO , IDCO , IDOS )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 13/11/2012   AUTEUR COURTOIS M.COURTOIS 
C RESPONSABLE LEFEBVRE J-P.LEFEBVRE
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
C TOLE CRP_6
      IMPLICIT NONE
      INCLUDE 'jeveux_private.h'
      INTEGER             IC , IADDI , IADMO , LSO , IDCO , IDOS
C ----------------------------------------------------------------------
C ECRITURE DISQUE D'UN OU PLUSIEURS ENREGISTREMENTS SUR LE FICHIER 
C D'ACCES DIRECT ASSOCIE A UNE BASE
C
C IN  IC    : NOM DE LA CLASSE
C IN  IADDI : ADRESSE DISQUE DU SEGMENT DE VALEURS
C IN  IADMO : ADRESSE MEMOIRE DU SEGMENT DE VALEURS EN OCTET
C IN  LSO   : LONGUEUR EN OCTET DU SEGMENT DE VALEURS
C IN  IDCO  : IDENTIFICATEUR DE COLLECTION
C IN  IDOS  : IDENTIFICATEUR D'OBJET SIMPLE OU D'OBJET DE COLLECTION
C                                              >0 GROS OBJET
C                                              =0 PETITS OBJETS
C ----------------------------------------------------------------------
      INTEGER          LK1ZON , JK1ZON , LISZON , JISZON 
      COMMON /IZONJE/  LK1ZON , JK1ZON , LISZON , JISZON
C-----------------------------------------------------------------------
      INTEGER I  ,IADLOC ,IB ,IERR  ,JIACCE 
      INTEGER JIECR ,JUSADI ,N ,NBACCE ,NBLENT ,NUMEXT 
C-----------------------------------------------------------------------
      PARAMETER      ( N = 5 )
C     ------------------------------------------------------------------
      INTEGER          LBIS , LOIS , LOLS , LOR8 , LOC8
      COMMON /IENVJE/  LBIS , LOIS , LOLS , LOR8 , LOC8
C     ------------------------------------------------------------------
      INTEGER          NBLMAX    , NBLUTI    , LONGBL    ,
     +                 KITLEC    , KITECR    ,             KIADM    ,
     +                 IITLEC    , IITECR    , NITECR    , KMARQ
      COMMON /IFICJE/  NBLMAX(N) , NBLUTI(N) , LONGBL(N) ,
     +                 KITLEC(N) , KITECR(N) ,             KIADM(N) ,
     +                 IITLEC(N) , IITECR(N) , NITECR(N) , KMARQ(N)
C
      CHARACTER*2      DN2
      CHARACTER*5      CLASSE
      CHARACTER*8                  NOMFIC    , KSTOUT    , KSTINI
      COMMON /KFICJE/  CLASSE    , NOMFIC(N) , KSTOUT(N) , KSTINI(N) ,
     +                 DN2(N)
      CHARACTER*8      NOMBAS
      COMMON /KBASJE/  NOMBAS(N)
      CHARACTER*128    REPGLO,REPVOL
      COMMON /BANVJE/  REPGLO,REPVOL
      INTEGER          LREPGL,LREPVO
      COMMON /BALVJE/  LREPGL,LREPVO     
      INTEGER          IDN    , IEXT    , NBENRG
      COMMON /IEXTJE/  IDN(N) , IEXT(N) , NBENRG(N)
      COMMON /JIACCE/  JIACCE(N),NBACCE(2*N)
      COMMON /JUSADI/  JUSADI(N)
C     ------------------------------------------------------------------
      CHARACTER*8      NOM
      CHARACTER*128    NOM128
      LOGICAL          LRAB
      INTEGER          LGBL,VALI(3)
      REAL*8           R8BID
C DEB ------------------------------------------------------------------
      IB = 0
      IERR = 0
      LGBL = 1024*LONGBL(IC)*LOIS
      NBLENT = LSO / LGBL
      LRAB   = ( MOD ( LSO , LGBL ) .NE. 0 )
C     ------------------------------------------------------------------
      IF ( KSTINI(IC) .NE. 'DUMMY   ' ) THEN
        NOM = NOMFIC(IC)(1:4)//'.   '
        DO 10 I = 1 , NBLENT
          NUMEXT = (IADDI+I-2)/NBENRG(IC)
          IADLOC = (IADDI+I-1)-(NUMEXT*NBENRG(IC))
          CALL CODENT(NUMEXT+1,'G',NOM(6:7))
          IF ( NOM(1:4) .EQ. 'glob' ) THEN
            NOM128=REPGLO(1:LREPGL)//'/'//NOM
          ELSE IF ( NOM(1:4) .EQ. 'vola' ) THEN
            NOM128=REPVOL(1:LREPVO)//'/'//NOM
          ELSE
            NOM128='./'//NOM
          ENDIF
          JIECR = (JK1ZON+IADMO-1+LGBL*(I-1))/LOIS+1
          CALL WRITDR (NOM128, ISZON(JIECR), LGBL, IADLOC, -1, IB, IERR)
          IF ( IERR .NE. 0 ) THEN
            VALI(1) = IADDI+I-1
            VALI(2) = NUMEXT
            VALI(3) = IERR
            CALL U2MESG('F','JEVEUX_40',1,NOMBAS(IC),3,VALI,0,R8BID)
          ENDIF
          NBACCE(2*IC) = NBACCE(2*IC) + 1
          IUSADI(JUSADI(IC)+3*(IADDI+I-1)-2) = IDCO
          IUSADI(JUSADI(IC)+3*(IADDI+I-1)-1) = IDOS
   10   CONTINUE
        IACCE (JIACCE(IC)+IADDI) = IACCE (JIACCE(IC)+IADDI) + 1
        IF ( LRAB ) THEN
          NUMEXT = (IADDI+NBLENT-1)/NBENRG(IC)
          IADLOC = (IADDI+NBLENT)-(NUMEXT*NBENRG(IC))
          CALL CODENT(NUMEXT+1,'G',NOM(6:7))
          IF ( NOM(1:4) .EQ. 'glob' ) THEN
            NOM128=REPGLO(1:LREPGL)//'/'//NOM
          ELSE IF ( NOM(1:4) .EQ. 'vola' ) THEN
            NOM128=REPVOL(1:LREPVO)//'/'//NOM
          ELSE
            NOM128='./'//NOM
          ENDIF          
          JIECR = (JK1ZON+IADMO-1+LSO-LGBL)/LOIS+1
          IF ( LSO .LT. LGBL ) THEN
            JIECR = (JK1ZON+IADMO-1)/LOIS+1 
          ENDIF       
          CALL WRITDR (NOM128, ISZON(JIECR), LGBL, IADLOC, -1, IB, IERR)
          IF ( IERR .NE. 0 ) THEN
            VALI(1) = IADDI+I-1
            VALI(2) = NUMEXT
            VALI(3) = IERR
            CALL U2MESG('F','JEVEUX_40',1,NOMBAS(IC),3,VALI,0,R8BID)
          ENDIF
          NBACCE(2*IC) = NBACCE(2*IC) + 1
          IUSADI(JUSADI(IC)+3*(IADDI+NBLENT)-2) = IDCO
          IUSADI(JUSADI(IC)+3*(IADDI+NBLENT)-1) = IDOS
        ENDIF
      ENDIF
C FIN ------------------------------------------------------------------
      END
