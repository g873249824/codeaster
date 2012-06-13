      SUBROUTINE ASSMA2(LMASYM,TT,NU14,NCMP,MATEL,C1,JVALM,JTMP2,LGTMP2)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE PELLET J.PELLET
C TOLE CRP_6
C
      IMPLICIT NONE
C-----------------------------------------------------------------------
C BUT : ASSEMBLER LES MACRO-ELEMENTS DANS UNE MATR_ASSE
C-----------------------------------------------------------------------
      INCLUDE 'jeveux.h'
      CHARACTER*16 OPTIO
C-----------------------------------------------------------------------
      REAL*8 C1
      LOGICAL LMASYM,LMESYM
      CHARACTER*2 TT
      CHARACTER*19 MATEL
      CHARACTER*8 MO,MA,KBID,NOGDCO,NOGDSI,NOMACR
      CHARACTER*14 NU14,NUM2
      INTEGER NBECMX
      PARAMETER(NBECMX=10)
      INTEGER ICODLA(NBECMX),ICODGE(NBECMX)
      INTEGER I1,I2,IACONX,IAD1,IAD11,IAD2,IAD21
      INTEGER JSUPMA,JNMACR,JNUEQ,JNULO1,JPRNO,JPOSD1,IBID
      INTEGER IEC,IERD,IMA,INOLD,NBTERM,JPRN1,JPRN2
      INTEGER JRESL,JSMDI,JSMHC,JSSSA,JVALM(2),K1
      INTEGER K2,N1,KNO,L,NUGD,NBEC,IANCMP,LGNCMP,ICMP,INDIK8
      INTEGER NBSMA,NBSSA,NCMP,NBVEL,NDDL1,NDDL2,JTMP2,LGTMP2
      INTEGER NEC,NM,NMXCMP,NNOE,I,JEC
      INTEGER LSHIFT
C-----------------------------------------------------------------------
C     FONCTIONS FORMULES :
C-----------------------------------------------------------------------
      INTEGER ZZPRNO,POSDD1,NUMLO1,K,NUNOEL,ILI,KDDL

      ZZPRNO(ILI,NUNOEL,L)=ZI(JPRN1-1+ZI(JPRN2+ILI-1)+
     &                     (NUNOEL-1)*(NEC+2)+L-1)
      NUMLO1(KNO,K)=ZI(JNULO1-1+2*(KNO-1)+K)
      POSDD1(KNO,KDDL)=ZI(JPOSD1-1+NMXCMP*(KNO-1)+KDDL)
C-----------------------------------------------------------------------


      CALL JEMARQ()

      CALL DISMOI('F','NB_SS_ACTI',MATEL,'MATR_ELEM',NBSSA,KBID,IERD)
      IF (NBSSA.EQ.0)GOTO 100

      CALL ASSERT(LMASYM)
      LMESYM=.TRUE.
      DO 10 I=1,NBECMX
        ICODLA(I)=0
        ICODGE(I)=0
   10 CONTINUE

      CALL DISMOI('F','NOM_MODELE',NU14,'NUME_DDL',IBID,MO,IERD)
      CALL DISMOI('F','NOM_MAILLA',MO,'MODELE',IBID,MA,IERD)
      CALL DISMOI('F','NB_NO_MAILLA',MO,'MODELE',NM,KBID,IERD)
      CALL DISMOI('F','NB_SM_MAILLA',MO,'MODELE',NBSMA,KBID,IERD)
      CALL JEVEUO(MA//'.NOMACR','L',JNMACR)
      CALL JEVEUO(MO//'.MODELE    .SSSA','L',JSSSA)

      CALL JEVEUO(NU14//'.SMOS.SMDI','L',JSMDI)
      CALL JEVEUO(NU14//'.SMOS.SMHC','L',JSMHC)
      CALL JEVEUO(NU14//'.NUME.NUEQ','L',JNUEQ)
      CALL JEVEUO(NU14//'.NUME.PRNO','L',JPRN1)
      CALL JEVEUO(JEXATR(NU14//'.NUME.PRNO','LONCUM'),'L',JPRN2)

      CALL DISMOI('F','SUR_OPTION',MATEL,'MATR_ELEM',IBID,OPTIO,IERD)
      CALL DISMOI('F','NOM_GD',NU14,'NUME_DDL',IBID,NOGDCO,IERD)
      CALL DISMOI('F','NOM_GD_SI',NOGDCO,'GRANDEUR',IBID,NOGDSI,IERD)
      CALL DISMOI('F','NB_CMP_MAX',NOGDSI,'GRANDEUR',NMXCMP,KBID,IERD)
      CALL DISMOI('F','NUM_GD_SI',NOGDSI,'GRANDEUR',NUGD,KBID,IERD)
      NEC=NBEC(NUGD)
      CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP',NOGDSI),'L',IANCMP)
      CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP',NOGDSI),'LONMAX',LGNCMP,KBID)
      ICMP=INDIK8(ZK8(IANCMP),'LAGR',1,LGNCMP)
      IF (ICMP.GT.0) THEN
        JEC=(ICMP-1)/30+1
        ICODLA(JEC)=LSHIFT(1,ICMP-(JEC-1)*30)
      ENDIF

      CALL JEVEUO('&&ASSMAM.NUMLO1','E',JNULO1)
      CALL JEVEUO('&&ASSMAM.POSDD1','E',JPOSD1)



      CALL SSVALM('DEBUT',OPTIO,MO,MA,0,JRESL,NBVEL)

      DO 90,IMA=1,NBSMA
C         -- BOUCLE SUR LES MACRO-ELEMENTS :
C         ----------------------------------
        IF (ZI(JSSSA-1+IMA).EQ.0)GOTO 90

        CALL JEVEUO(JEXNUM(MA//'.SUPMAIL',IMA),'L',JSUPMA)
        CALL JELIRA(JEXNUM(MA//'.SUPMAIL',IMA),'LONMAX',NNOE,KBID)

        NBTERM=0

        CALL SSVALM(' ',OPTIO,MO,MA,IMA,JRESL,NBVEL)

        NOMACR=ZK8(JNMACR-1+IMA)
        CALL DISMOI('F','NOM_NUME_DDL',NOMACR,'MACR_ELEM_STAT',IBID,
     &              NUM2,IERD)
        CALL JEVEUO(NOMACR//'.CONX','L',IACONX)
        CALL JEVEUO(JEXNUM(NUM2//'.NUME.PRNO',1),'L',JPRNO)

        DO 80 K1=1,NNOE
          N1=ZI(JSUPMA-1+K1)
          IF (N1.GT.NM) THEN
            DO 20 IEC=1,NBECMX
              ICODGE(IEC)=ICODLA(IEC)
   20       CONTINUE

          ELSE
            INOLD=ZI(IACONX-1+3*(K1-1)+2)
            DO 30 IEC=1,NEC
              ICODGE(IEC)=ZI(JPRNO-1+(NEC+2)*(INOLD-1)+2+IEC)
   30       CONTINUE
          ENDIF

          IAD1=ZZPRNO(1,N1,1)
          CALL CORDD2(JPRN1,JPRN2,1,ICODGE,NEC,NCMP,N1,NDDL1,
     &                ZI(JPOSD1-1+NMXCMP*(K1-1)+1))
          ZI(JNULO1-1+2*(K1-1)+1)=IAD1
          ZI(JNULO1-1+2*(K1-1)+2)=NDDL1
          DO 70 I1=1,NDDL1
            DO 50 K2=1,K1-1
              IAD2=NUMLO1(K2,1)
              NDDL2=NUMLO1(K2,2)
              DO 40 I2=1,NDDL2
                IAD11=ZI(JNUEQ-1+IAD1+POSDD1(K1,I1)-1)
                IAD21=ZI(JNUEQ-1+IAD2+POSDD1(K2,I2)-1)
                CALL ASRETM(LMASYM,JTMP2,LGTMP2,NBTERM,JSMHC,JSMDI,
     &                      IAD11,IAD21)
   40         CONTINUE
   50       CONTINUE
            K2=K1
            IAD2=NUMLO1(K2,1)
            NDDL2=NUMLO1(K2,2)
            DO 60 I2=1,I1
              IAD11=ZI(JNUEQ-1+IAD1+POSDD1(K1,I1)-1)
              IAD21=ZI(JNUEQ-1+IAD2+POSDD1(K2,I2)-1)
              CALL ASRETM(LMASYM,JTMP2,LGTMP2,NBTERM,JSMHC,JSMDI,IAD11,
     &                    IAD21)
   60       CONTINUE
   70     CONTINUE
   80   CONTINUE


C         ---- POUR FINIR, ON RECOPIE EFFECTIVEMENT LES TERMES:
        CALL ASCOPR(LMASYM,LMESYM,'R'//TT(2:2),JTMP2,NBTERM,JRESL,C1,
     &              JVALM)
   90 CONTINUE
      CALL SSVALM('FIN',OPTIO,MO,MA,IMA,JRESL,NBVEL)


  100 CONTINUE
      CALL JEDEMA()
      END
