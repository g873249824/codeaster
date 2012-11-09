      SUBROUTINE CCPOUX(RESUIN,TYPESD,NORDRE,NBCHRE,IOCCUR,
     &                  KCHARG,MODELE,NBPAIN,LIPAIN,LICHIN,
     &                  SUROPT,IRET)
      IMPLICIT NONE
C     --- ARGUMENTS ---
      INCLUDE 'jeveux.h'

      INTEGER      NBPAIN,NORDRE,NBCHRE,IOCCUR,IRET
      CHARACTER*8  RESUIN,LIPAIN(*)
      CHARACTER*16 TYPESD
      CHARACTER*19 KCHARG
      CHARACTER*24 LICHIN(*),SUROPT
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C ----------------------------------------------------------------------
C  CALC_CHAMP - POUTRES POUX
C  -    -               ----
C ----------------------------------------------------------------------
C
C  CALC_CHAMP ET POUTRE POUX
C
C IN  :
C   RESUIN  K8   NOM DE LA STRUCUTRE DE DONNEES RESULTAT IN
C   TYPESD  K16  TYPE DE LA STRUCTURE DE DONNEES RESULTAT
C   NORDRE  I    NUMERO D'ORDRE COURANT
C   NBCHRE  I    NOMBRE DE CHARGES REPARTIES (POUTRES)
C   IOCCUR  I    NUMERO D'OCCURENCE OU SE TROUVE LE CHARGE REPARTIE
C   KCHARG  K19  NOM DE L'OBJET JEVEUX CONTENANT LES CHARGES
C   MODELE  K8   NOM DU MODELE
C   NBPAIN  I    NOMBRE DE PARAMETRES IN
C   LIPAIN  K8*  LISTE DES PARAMETRES IN
C   LICHIN  K8*  LISTE DES CHAMPS IN
C   SUROPT  K24
C
C OUT :
C   IRET    I    CODE RETOUR (0 SI OK, 1 SINON)
C ----------------------------------------------------------------------
C RESPONSABLE SELLENET N.SELLENET
      LOGICAL      EXIF1D

      INTEGER      LTYMO,LDEPL,LFREQ,NEQ,LVALE,LACCE,II,I
      INTEGER      L1,L3,JCHA,N1,IPARA,IBID,IER,LINST

      REAL*8       ZERO,UN,COEF,VALRES
      REAL*8       ALPHA,TPS(11),RBID,FREQ,INST
      PARAMETER    (ZERO=0.D0,UN=1.D0)

      COMPLEX*16   CZERO,CBID,CALPHA,TPC(11)
      PARAMETER    (CZERO= (0.D0,0.D0))

      CHARACTER*1  TYPCOE
      CHARACTER*5  CH5
      CHARACTER*8  CHAREP,K8B,CURPAR,NCMPPE(4),TPF(11),CHARGE,TYPCHA
      CHARACTER*8  NCMPFO(11),MODELE
      CHARACTER*16 TYPEMO
      CHARACTER*19 CHDYNR,CHACCE
      CHARACTER*24 CHAMGD,NOCHIN,NOCHI1,CHDEPL,LIGRMO
      INTEGER      IARG

      DATA         NCMPPE/ 'G' , 'AG' , 'BG' , 'CG' /
      DATA         NCMPFO/ 'FX' , 'FY' , 'FZ' , 'MX' , 'MY' , 'MZ' ,
     &                     'BX' , 'REP' , 'ALPHA' , 'BETA' , 'GAMMA' /

      CALL JEMARQ()

      IRET = 0

      TYPEMO = ' '
      IF (TYPESD.EQ.'MODE_MECA') THEN
        CALL RSADPA(RESUIN,'L',1,'TYPE_MODE',1,0,LTYMO,K8B)
        TYPEMO=ZK16(LTYMO)
      ENDIF
      CALL RSEXCH('F',RESUIN,'DEPL',NORDRE,CHDEPL,IER)

      CALL JEVEUO(KCHARG,'L',JCHA)

      LIGRMO = MODELE//'.MODELE'

      CHAREP = ' '
      TYPCOE = ' '
      ALPHA = ZERO
      CALPHA = CZERO
      CHDYNR = '&&MECALM.M.GAMMA'
      IF ((TYPESD.EQ.'MODE_MECA'.AND.TYPEMO(1:8).EQ.'MODE_DYN' )
     &     .OR. TYPESD.EQ.'MODE_ACOU') THEN
        CALL JEVEUO(CHDYNR//'.VALE','E',LVALE)
        CALL JELIRA(CHDEPL(1:19)//'.VALE','LONMAX',NEQ,K8B)
        CALL RSEXCH('F',RESUIN,'DEPL',NORDRE,CHAMGD,IER)
        CALL JEVEUO(CHAMGD(1:19)//'.VALE','L',LDEPL)
        CALL RSADPA(RESUIN,'L',1,'OMEGA2',NORDRE,0,LFREQ,K8B)
        DO 20 II = 0,NEQ - 1
          ZR(LVALE+II) = -ZR(LFREQ)*ZR(LDEPL+II)
   20   CONTINUE
        CALL JELIBE(CHAMGD(1:19)//'.VALE')
      ELSE IF (TYPESD.EQ.'DYNA_TRANS') THEN
        CALL JEVEUO(CHDYNR//'.VALE','E',LVALE)
        CALL JELIRA(CHDEPL(1:19)//'.VALE','LONMAX',NEQ,K8B)
        CALL RSEXCH(' ',RESUIN,'ACCE',NORDRE,CHACCE,IER)
        IF (IER.EQ.0) THEN
          CALL JEVEUO(CHACCE//'.VALE','L',LACCE)
          DO 30 II = 0,NEQ - 1
            ZR(LVALE+II) = ZR(LACCE+II)
   30     CONTINUE
          CALL JELIBE(CHACCE//'.VALE')
        ELSE
          CALL U2MESS('A','CALCULEL3_1')
          DO 40 II = 0,NEQ - 1
            ZR(LVALE+II) = ZERO
   40     CONTINUE
        END IF
      ELSE IF (TYPESD.EQ.'DYNA_HARMO') THEN
        CALL JEVEUO(CHDYNR//'.VALE','E',LVALE)
        CALL JELIRA(CHDEPL(1:19)//'.VALE','LONMAX',NEQ,K8B)
        CALL RSEXCH(' ',RESUIN,'ACCE',NORDRE,CHACCE,IER)
        IF (IER.EQ.0) THEN
          CALL JEVEUO(CHACCE//'.VALE','L',LACCE)
          DO 50 II = 0,NEQ - 1
            ZC(LVALE+II) = ZC(LACCE+II)
   50     CONTINUE
          CALL JELIBE(CHACCE//'.VALE')
        ELSE
          CALL U2MESS('A','CALCULEL3_1')
          DO 60 II = 0,NEQ - 1
            ZC(LVALE+II) = CZERO
   60     CONTINUE
        END IF
      END IF
C --- CALCUL DU COEFFICIENT MULTIPLICATIF DE LA CHARGE
C     CE CALCUL N'EST EFFECTIF QUE POUR LES CONDITIONS SUIVANTES
C          * MODELISATION POUTRE
C          * PRESENCE D'UNE (ET D'UNE SEULE) CHARGE REPARTIE
C          * UTILISATION DU MOT-CLE FACTEUR EXCIT
      IF (NBCHRE.NE.0) THEN
        CALL GETVID('EXCIT','FONC_MULT',IOCCUR,IARG,1,K8B,L1)
        CALL GETVR8('EXCIT','COEF_MULT',IOCCUR,IARG,1,COEF,L3)
        IF (L1.NE.0 .OR. L3.NE.0) THEN
          IF (TYPESD.EQ.'DYNA_HARMO') THEN
            TYPCOE = 'C'
            CALL RSADPA(RESUIN,'L',1,'FREQ',NORDRE,0,LFREQ,K8B)
            FREQ = ZR(LFREQ)
            IF (L1.NE.0) THEN
              CALL FOINTE('F ',K8B,1,'FREQ',FREQ,VALRES,IER)
              CALPHA = DCMPLX(VALRES,ZERO)
            ELSE IF (L3.NE.0) THEN
              CALPHA = DCMPLX(COEF,UN)
            END IF
          ELSE IF (TYPESD.EQ.'DYNA_TRANS') THEN
            TYPCOE = 'R'
            CALL RSADPA(RESUIN,'L',1,'INST',NORDRE,0,LINST,K8B)
            INST = ZR(LINST)
            IF (L1.NE.0) THEN
              CALL FOINTE('F ',K8B,1,'INST',INST,ALPHA,IER)
            ELSE IF (L3.NE.0) THEN
              ALPHA = COEF
            ELSE
              CALL U2MESS('A','CALCULEL3_2')
              IRET = 1
              GO TO 9999
            END IF
          ELSE IF (TYPESD.EQ.'EVOL_ELAS') THEN
            TYPCOE = 'R'
            IF (L1.NE.0) THEN
              CALL FOINTE('F ',K8B,1,'INST',INST,ALPHA,IER)
            ELSE
              CALL U2MESS('A','CALCULEL3_3')
              IRET = 1
              GO TO 9999
            END IF
          ELSE
            CALL U2MESS('A','CALCULEL3_4')
            IRET = 1
            GO TO 9999
          END IF
        END IF
      END IF
      IF (IOCCUR.GT.0) THEN
        CALL GETVID('EXCIT','CHARGE',IOCCUR,IARG,1,CHAREP,N1)
        IF(N1.EQ.0) CHAREP=ZK8(JCHA-1+IOCCUR)
      END IF

      IF ( CHAREP.EQ.' ' ) THEN
        CHARGE = ZK8(JCHA)
      ELSE
        CHARGE = CHAREP
      ENDIF

      CH5 = '.    '
      DO 10 I = 1,11
         TPS(I) = ZERO
         TPF(I) = '&FOZERO'
         TPC(I) = CZERO
  10  CONTINUE

      NOCHI1 = CHARGE//'.CHME.F1D1D.DESC'
      EXIF1D = .FALSE.
      CALL JEEXIN(NOCHI1,IER)
      IF ( IER.EQ.0 ) THEN
        EXIF1D = .TRUE.
      ELSE
        CALL DISMOI('F','TYPE_CHARGE',CHARGE,'CHARGE',IBID,TYPCHA,IER)
      ENDIF

      DO 70 IPARA = 1,NBPAIN
        CURPAR = LIPAIN(IPARA)
        CH5 = '.    '
        IF ( (CURPAR.EQ.'PCOEFFR').AND.(TYPCOE.EQ.'R') ) THEN
          NOCHIN = '&&MECHPO'//CH5//'.COEFF'
          CALL MECACT('V',NOCHIN,'MODELE',LIGRMO,'IMPE_R',
     &                1,'IMPE',IBID,ALPHA,CBID,K8B)
          LICHIN(IPARA) = NOCHIN
        ENDIF
        IF ( (CURPAR.EQ.'PCOEFFC').AND.(TYPCOE.EQ.'C') ) THEN
          NOCHIN = '&&MECHPO'//CH5//'.COEFF'
          CALL MECACT('V',NOCHIN,'MODELE',LIGRMO,'IMPE_C',
     &                1,'IMPE',IBID,RBID,CALPHA,K8B)
          LICHIN(IPARA) = NOCHIN
        ENDIF

        IF ( CURPAR.EQ.'PPESANR' ) THEN
          NOCHIN = CHARGE//'.CHME.PESAN.DESC'
          CALL JEEXIN(NOCHIN,IER)
          IF (IER.EQ.0) THEN
            CALL CODENT(IPARA,'D0',CH5(2:5))
            NOCHIN = '&&MECHPO'//CH5//'.PESAN.DESC'
            LICHIN(IPARA) = NOCHIN
            CALL MECACT('V',NOCHIN,'MODELE',LIGRMO,'PESA_R  ',4,
     &                  NCMPPE,IBID,TPS,CBID,K8B)
          ELSE
            LICHIN(IPARA) = NOCHIN
          ENDIF
        ELSEIF ( CURPAR.EQ.'PFF1D1D' ) THEN
          IF ( EXIF1D ) THEN
            CALL CODENT(IPARA,'D0',CH5(2:5))
            NOCHIN = '&&MECHPO'//CH5//'.P1D1D.DESC'
            LICHIN(IPARA) = NOCHIN
            CALL FOZERO(TPF(1))
            CALL MECACT('V',NOCHIN,'MODELE',LIGRMO,'FORC_F  ',
     &                  11,NCMPFO,IBID,RBID,CBID,TPF)
          ELSE
            IF ( TYPCHA(5:7).EQ.'_FO' ) THEN
              LICHIN(IPARA) = NOCHI1
            ELSE
              CALL CODENT(IPARA,'D0',CH5(2:5))
              NOCHIN = '&&MECHPO'//CH5//'.P1D1D.DESC'
              LICHIN(IPARA) = NOCHIN
              CALL FOZERO(TPF(1))
              CALL MECACT('V',NOCHIN,'MODELE',LIGRMO,
     &                    'FORC_F  ',11,NCMPFO,IBID,RBID,CBID,TPF)
            ENDIF
          ENDIF
        ELSEIF ( CURPAR.EQ.'PFR1D1D' ) THEN
          IF ( EXIF1D ) THEN
            CALL CODENT(IPARA,'D0',CH5(2:5))
            NOCHIN = '&&MECHPO'//CH5//'.P1D1D.DESC'
            LICHIN(IPARA) = NOCHIN
            CALL MECACT('V',NOCHIN,'MODELE',LIGRMO,'FORC_R  ',11,
     &                  NCMPFO,IBID,TPS,CBID,K8B)
          ELSE
            IF ( (TYPCHA(5:7).EQ.'_FO').OR.
     &           (TYPCHA(5:7).EQ.'_RI') ) THEN
              CALL CODENT(IPARA,'D0',CH5(2:5))
              NOCHIN = '&&MECHPO'//CH5//'.P1D1D.DESC'
              LICHIN(IPARA) = NOCHIN
              CALL MECACT('V',NOCHIN,'MODELE',LIGRMO,'FORC_R  ',
     &                    11,NCMPFO,IBID,TPS,CBID,K8B)
            ELSE
              LICHIN(IPARA) = NOCHI1
            ENDIF
          ENDIF
        ELSEIF ( CURPAR.EQ.'PFC1D1D' ) THEN
          IF ( EXIF1D ) THEN
            CALL CODENT(IPARA,'D0',CH5(2:5))
            NOCHIN = '&&MECHPO'//CH5//'.P1D1D.DESC'
            LICHIN(IPARA) = NOCHIN
            CALL MECACT('V',NOCHIN,'MODELE',LIGRMO,'FORC_C  ',11,
     &                  NCMPFO,IBID,RBID,TPC,K8B)
          ELSE
            IF ( TYPCHA(5:7).EQ.'_RI' ) THEN
              LICHIN(IPARA) = NOCHI1
            ELSE
              CALL CODENT(IPARA,'D0',CH5(2:5))
              NOCHIN = '&&MECHPO'//CH5//'.P1D1D.DESC'
              LICHIN(IPARA) = NOCHIN
              CALL MECACT('V',NOCHIN,'MODELE',LIGRMO,'FORC_C  ',
     &                    11,NCMPFO,IBID,RBID,TPC,K8B)
            ENDIF
          ENDIF
        ELSEIF ( CURPAR.EQ.'PCHDYNR' ) THEN
          NOCHIN = CHDYNR//'.VALE'
          CALL JEEXIN(NOCHIN,IER)
          IF (IER.EQ.0) THEN
            CALL CODENT(IPARA,'D0',CH5(2:5))
            NOCHIN = '&&MECHPO'//CH5//'.PCHDY'
            CALL COPISD('CHAMP_GD','V',CHDEPL,NOCHIN)
          ENDIF
          LICHIN(IPARA) = NOCHIN
        ELSEIF ( CURPAR.EQ.'PSUROPT' ) THEN
          CALL CODENT(IPARA,'D0',CH5(2:5))
          NOCHIN = '&&MECHPO'//CH5//'.SUR_OPTION'
          LICHIN(IPARA) = NOCHIN
          CALL MECACT('V',NOCHIN,'MODELE',LIGRMO,'NEUT_K24',
     &                1,'Z1',IBID,RBID,CBID,SUROPT)
        ENDIF
   70 CONTINUE

 9999 CONTINUE

      CALL JEDEMA()

      END
