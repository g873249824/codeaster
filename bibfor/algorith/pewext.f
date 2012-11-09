      SUBROUTINE PEWEXT(RESU)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'

      CHARACTER*(*) RESU
C ----------------------------------------------------------------------

      INTEGER I,IRET,JINST
      INTEGER NBORD,JORD,NUMORD
      REAL*8 INST,PREC,F0U0,F1U0,F0U1,F1U1,W,VALER(3)
      COMPLEX*16 C16B
      CHARACTER*8 CRIT,RESULT
      CHARACTER*8 K8B,TYPARR(4)
      CHARACTER*16 NOPARR(4)
      CHARACTER*19 DEPLA1,FORCE1
      CHARACTER*19 DEPLS0,DEPLS1,FORCS0,FORCS1
      CHARACTER*24 LISORD
      INTEGER IARG,IER
C
C-----------------------------------------------------------------------
C

      CALL JEMARQ()
      LISORD='&&PEWEXT.VECTORDR'
      CALL GETVID(' ','RESULTAT',0,IARG,1,RESULT,IRET)


C -- INITIALISATION DE LA TABLE RESULTAT

      TYPARR(1)='I'
      TYPARR(2)='R'
      TYPARR(3)='R'
      TYPARR(4)='R'

      NOPARR(1)='NUME_ORDRE'
      NOPARR(2)='INST'
      NOPARR(3)='TRAV_ELAS'
      NOPARR(4)='TRAV_REEL'

      CALL TBCRSD(RESU,'G')
      CALL TBAJPA(RESU,4,NOPARR,TYPARR)



C -- EXTRACTION DES NUMEROS D'ORDRE DU CALCUL

      CALL GETVR8(' ','PRECISION',1,IARG,1,PREC,IRET)
      CALL GETVTX(' ','CRITERE',1,IARG,1,CRIT,IRET)
      CALL RSUTNU(RESULT,' ',0,LISORD,NBORD,PREC,CRIT,IRET)
      IF (IRET.NE.0) CALL U2MESK('F','POSTELEM_11',1,RESULT)
      CALL JEVEUO(LISORD,'L',JORD)


C -- CALCUL DU TRAVAIL DES FORCES EXTERIEURES AUX DIFFERENTS INSTANTS

      DEPLS0='&&PEWEXT.DEPLS0'
      DEPLS1='&&PEWEXT.DEPLS1'
      FORCS0='&&PEWEXT.FORCS0'
      FORCS1='&&PEWEXT.FORCS1'

      DO 10 I=1,NBORD
        CALL JEMARQ()
        CALL JERECU('V')
        NUMORD=ZI(JORD-1+I)

C       EXTRACTION DE L'INSTANT DE CALCUL
        CALL RSADPA(RESULT,'L',1,'INST',NUMORD,0,JINST,K8B)
        INST=ZR(JINST)

C       EXTRACTION DU CHAMP DE DEPLCAMENT
        CALL RSEXCH('F',RESULT,'DEPL',NUMORD,DEPLA1,IRET)

C       -- TOUS LES CHAMPS DE LA SD_RESULTAT N'ONT PAS FORCEMENT
C          LA MEME NUMEROTATION, C'EST POURQUOI ON PASSE PAR DES
C          CHAMPS SIMPLES :
        CALL CNOCNS(DEPLA1,'V',DEPLS1)

C       EXTRACTION DU CHAMP DE FORCE NODALE
        CALL RSEXCH('F',RESULT,'FORC_NODA',NUMORD,FORCE1,IRET)
        CALL CNOCNS(FORCE1,'V',FORCS1)

C       CALCUL DU PRODUIT SCALAIRE F.U
        CALL CNSDOT(DEPLS1,FORCS1,F1U1,IER)
        CALL ASSERT(IER.EQ.0)

C       CALCUL DE L'INTEGRALE I(F.DU)
        IF (I.GE.2) THEN
          CALL CNSDOT(DEPLS0,FORCS1,F1U0,IER)
          CALL ASSERT(IER.EQ.0)
          CALL CNSDOT(DEPLS1,FORCS0,F0U1,IER)
          CALL ASSERT(IER.EQ.0)
          W=W+0.5D0*(F0U1-F1U0+F1U1-F0U0)
        ELSE
          W=0
        ENDIF

        VALER(1)=INST
        VALER(2)=F1U1/2
        VALER(3)=W
        CALL TBAJLI(RESU,4,NOPARR,NUMORD,VALER,C16B,K8B,0)

        CALL COPISD('CHAM_NO_S','V',DEPLS1,DEPLS0)
        CALL COPISD('CHAM_NO_S','V',FORCS1,FORCS0)
        F0U0=F1U1

        CALL JEDEMA()
   10 CONTINUE

      CALL DETRSD('CHAM_NO_S',DEPLS1)
      CALL DETRSD('CHAM_NO_S',DEPLS0)
      CALL DETRSD('CHAM_NO_S',FORCS1)
      CALL DETRSD('CHAM_NO_S',FORCS0)

      CALL JEDEMA()
      END
