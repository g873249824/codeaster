      SUBROUTINE RSINCH(NOMSD,NOMCH,ACCES,RVAL,CHEXTR,PROLDR,PROLGA,
     +                  ISTOP,BASE,IER)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER           ISTOP,IER
      REAL*8                              RVAL
      CHARACTER*(*)     NOMSD,NOMCH,ACCES,     CHEXTR,PROLDR,PROLGA
      CHARACTER*(*)           BASE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 02/04/2001   AUTEUR VABHHTS J.PELLET 
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
C      INTERPOLATION D'UN CHAMP_19 A PARTIR D'1 SD RESULTAT-COMPOSE
C ----------------------------------------------------------------------
C IN  : NOMSD  : NOM DE LA STRUCTURE "RESULTAT"
C IN  : NOMCH  : NOM SYMBOLIQUE DU CHAMP CHERCHE.
C IN  : ACCES  : NOM SYMBOLIQUE DE LA VARIABLE D'ACCES.
C IN  : RVAL   : VALEUR REEL DE LA VARIABLE D'ACCES.
C IN  : CHEXTR : NOM DU CHAMP A CREER. (S'IL EXISTE, ON LE DETRUIT).
C IN  : PROLDR : 'CONSTANT', 'LINEAIRE', OU 'EXCLU'
C                          (PROLONGEMENT VOULU A DROITE)
C IN  : PROLGA : 'CONSTANT', 'LINEAIRE', OU 'EXCLU'
C                          (PROLONGEMENT VOULU A GAUCHE)
C IN  : ISTOP  :  EN CAS D'ERREUR D'INTERPOLATION:
C                 0  --> N'ECRIT PAS DE MESSAGE , NE FAIT PAS STOP.
C                 1  --> ECRIT MESSAGES , NE FAIT PAS STOP.
C                 2  --> ECRIT MESSAGES , FAIT STOP.
C IN  : BASE   : BASE DU CHAMP CREE
C
C OUT : IER    : CODE_RETOUR :
C                LE CHAMP EST CALCULE:
C                00 --> LE CHAMP EST INTERPOLE ENTRE 2 VALEURS.
C                01 --> LE CHAMP EST PROLONGE A GAUCHE.
C                02 --> LE CHAMP EST PROLONGE A DROITE.
C
C                LE CHAMP N'EST PAS CALCULE:
C                10 --> IL N'EXISTE AUCUN CHAMP POUR L'INTERPOLATION.
C                11 --> LE PROLONGEMENT A GAUCHE INTERDIT.
C                12 --> SI PROLONGEMENT A DROITE INTERDIT.
C                20 --> LA VARIABLE D'ACCES EST ILLICITE.
C ----------------------------------------------------------------------
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR,JEXR8
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR,R1,R2,RBASE
      COMPLEX*16 ZC,CBID
      LOGICAL ZL,COMPO
      INTEGER L1,L2
      CHARACTER*1 STP,BASE2
      CHARACTER*4 TYSD,TYPE,TYSCA
      CHARACTER*8 ZK8,NOMOBJ,K8BID,K8DEBU,K8MAXI,K8ENT
      CHARACTER*19 CH1,CH2
      CHARACTER*8  PROLD2,PROLG2
      CHARACTER*19 NOMS2
      CHARACTER*16 ZK16,ACCE2,NOMC2
      CHARACTER*19 CHEXT2
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
      CHARACTER*24 TITI
C
C
      CALL JEMARQ()
      ACCE2 = ACCES
      NOMS2 = NOMSD
      NOMC2 = NOMCH
      PROLD2 = PROLDR
      PROLG2 = PROLGA
      CHEXT2 = CHEXTR
      BASE2  = BASE
C
C     -- VERIFICATION DE LA VARIABLE D'ACCES:
C     ---------------------------------------
C
      CALL JENONU(JEXNOM(NOMS2//'.NOVA',ACCE2),IACCES)
      IF (IACCES.EQ.0) THEN
         IER = 20
         GO TO 9998
      END IF
C
      CALL JEVEUO(JEXNUM(NOMS2//'.TAVA',IACCES),'L',IATAVA)
      NOMOBJ = ZK8(IATAVA-1+1)
      K8DEBU = ZK8(IATAVA-1+2)
      CALL LXLIIS(K8DEBU,IDEBU,IER1)
      K8MAXI = ZK8(IATAVA-1+3)
      CALL LXLIIS(K8MAXI,IMAXI,IER2)
      IF ((ABS(IER1)+ABS(IER2)).NE.0) THEN
         CALL UTMESS('F','RSINCH','1')
      END IF
      IF (IER2.NE.0) THEN
         IER = 20
         GO TO 9998
      END IF
C
      CALL JEVEUO(NOMS2//NOMOBJ,'L',IAOBJ)
      CALL JELIRA(NOMS2//NOMOBJ,'TYPE',IBID,TYPE)
      CALL JELIRA(NOMS2//NOMOBJ,'LTYP',ILOTY,K8BID)
C
      CALL DISMOI('F','NB_CHAMP_MAX',NOMSD,'RESULTAT',NBORDR,K8BID,
     +             IERD)
C
      CALL CODENT(ILOTY,'G',K8ENT)
      TYSCA = TYPE(1:1)//K8ENT(1:3)
C
      IF (TYSCA.NE.'R8  ') THEN
         IER = 20
         GO TO 9998
      END IF
C
C     -- VERIFICATION DU NOM DE CHAMP:
C     --------------------------------
C
      CALL JENONU(JEXNOM(NOMS2//'.DESC',NOMC2),INOMCH)
      IF (INOMCH.EQ.0) THEN
         IER = 21
         GO TO 9998
      END IF
C
C     -- ON INTERPOLE :
C     -----------------
C
C     -- ON REPERE QUELS SONT LES CHAMPS EXISTANT REELLEMENT:
      CALL JECREO('&&RSINCH.LEXI','V V L')
      CALL JEECRA('&&RSINCH.LEXI','LONMAX',NBORDR,K8BID)
      CALL JEVEUO('&&RSINCH.LEXI','E',IALEXI)
      CALL JENONU ( JEXNOM(NOMS2//'.DESC',NOMC2),IBID)
      CALL JEVEUO(JEXNUM(NOMS2//'.TACH',IBID),'L',IATACH)
      DO 1,I = 1,NBORDR
         IF (ZK24(IATACH-1+I) (1:1).EQ.' ') THEN
            ZL(IALEXI-1+I) = .FALSE.
         ELSE
            ZL(IALEXI-1+I) = .TRUE.
         END IF
    1 CONTINUE
C
      CALL RSBARY(ZR(IAOBJ),NBORDR,.FALSE.,ZL(IALEXI),RVAL,I1,I2,IPOSIT)
      CALL JEDETR('&&RSINCH.LEXI')
      IF (IPOSIT.EQ.-2) THEN
         IER = 10
         GO TO 9998
      END IF
      CALL RSUTRO(NOMSD,I1,IP1,IERR1)
      CALL RSUTRO(NOMSD,I2,IP2,IERR2)
      IF (IERR1+IERR2.GT.0) THEN
         CALL UTMESS('F','RSINCH','1BIS')
      END IF
      RBASE = ZR(IAOBJ-1+I2) - ZR(IAOBJ-1+I1)
C
      CALL RSEXCH(NOMSD,NOMC2,IP1,CH1,L1)
      CALL RSEXCH(NOMSD,NOMC2,IP2,CH2,L2)
      IF (L1+L2.GT.0) THEN
         CALL UTMESS('F','RSINCH','2')
      END IF
C
C     -- SI LES 2 POINTS IP1 ET IP2 ONT MEME ABSCISSE, ON RECOPIE
C     -- SIMPLEMENT LE CHAMP(IP1) DANS CHEXT2.
      IF (RBASE.EQ.0.0D0) THEN
            CALL COPISD('CHAMP_GD',BASE2,CH1(1:19),CHEXT2(1:19))
         IER = 0
         GO TO 9998
      END IF
C
      R1 = (ZR(IAOBJ-1+I2)-RVAL)/RBASE
      R2 = (RVAL-ZR(IAOBJ-1+I1))/RBASE
C
C     -- INTERPOLATION VRAIE:
C     -----------------------
      IF (IPOSIT.EQ.0) THEN
         CALL BARYCH(CH1,CH2,R1,R2,CHEXT2,BASE2)
         IER = 0
         GO TO 9998
C
C        -- PROLONGEMENT A GAUCHE:
C        -------------------------
      ELSE IF (IPOSIT.EQ.-1) THEN
         IER = 1
         IF (PROLG2(1:8).EQ.'LINEAIRE') THEN
            CALL BARYCH(CH1,CH2,R1,R2,CHEXT2,BASE2)
         ELSE IF (PROLG2(1:8).EQ.'CONSTANT') THEN
            CALL COPISD('CHAMP_GD',BASE2,CH1(1:19),CHEXT2(1:19))
         ELSE
            IER = 11
         END IF
         GO TO 9998
C
C        -- PROLONGEMENT A DROITE:
C        -------------------------
      ELSE IF (IPOSIT.EQ.1) THEN
         IER = 2
         IF (PROLD2(1:8).EQ.'LINEAIRE') THEN
            CALL BARYCH(CH1,CH2,R1,R2,CHEXT2,BASE2)
         ELSE IF (PROLD2(1:8).EQ.'CONSTANT') THEN
            CALL COPISD('CHAMP_GD',BASE2,CH2(1:19),CHEXT2(1:19))
         ELSE
            IER = 12
         END IF
         GO TO 9998
C
      END IF
 9998 CONTINUE
C
C     -- MESSAGES, ARRET?
C     -------------------
      IF (ISTOP.EQ.0) THEN
         GO TO 9999
      ELSE IF (ISTOP.EQ.1) THEN
         STP = 'A'
      ELSE IF (ISTOP.EQ.2) THEN
         STP = 'F'
      END IF


      IF (IER.EQ.11) THEN
         CALL UTDEBM(STP,'RSINCH','L''EXTRAPOLATION NE PEUT ETRE FAITE'
     +               //' A GAUCHE (INTERDIT).')
      ELSE IF (IER.EQ.12) THEN
         CALL UTDEBM(STP,'RSINCH','L''EXTRAPOLATION NE PEUT ETRE FAITE'
     +               //' A DROITE (INTERDIT).')
      ELSE IF (IER.EQ.10) THEN
         CALL UTDEBM(STP,'RSINCH','L''INTERPOLATION NE PEUT ETRE FAITE'
     +               //' CAR AUCUN CHAMP DE : '//NOMC2//
     +               ' N''EST CALCULE.')
      ELSE IF (IER.EQ.20) THEN
         CALL UTDEBM(STP,'RSINCH','LA VARIABLE D''ACCES '//ACCE2//
     +               ' EST INVALIDE POUR UNE INTERPOLATION.')
      ELSE IF (IER.EQ.21) THEN
         CALL UTDEBM(STP,'RSINCH','CE NOM DE CHAMP EST INTERDIT : '//
     +               NOMC2//' POUR UNE INTERPOLATION.')
      END IF
C
      IF (IER.GE.10) THEN
         CALL UTIMPK('L','RESULTAT:',1,NOMSD)
         CALL UTIMPK('S','NOM_CHAM:',1,NOMCH)
         CALL UTIMPK('S',' VARIABLE D''ACCES:',1,ACCES)
         CALL UTIMPR('L',' VALEUR:',1,RVAL)
         CALL UTFINM()
      END IF
C
C
 9999 CONTINUE
C
      CALL JEDEMA()
      END
