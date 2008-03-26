      SUBROUTINE ASSMA2(LMASYM,TT,MAT19,NU14,NCMP,MATEL,C2,JVALM)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 25/03/2008   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
C-----------------------------------------------------------------------
C BUT : ASSEMBLER LES MACRO-ELEMENTS DANS UNE MATR_ASSE
C-----------------------------------------------------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16,OPTIO
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNOM,JEXNUM,JEXATR
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C-----------------------------------------------------------------------
      REAL*8 C2
      LOGICAL LMASYM,LMESYM
      CHARACTER*2 TT
      CHARACTER*19 MAT19,MATEL
      CHARACTER*8 MO,MA,KBID,NOGDCO,NOGDSI,NOMACR
      CHARACTER*14 NU14,NUM2
      INTEGER NBECMX
      PARAMETER(NBECMX=10)
      INTEGER ICODLA(NBECMX),ICODGE(NBECMX)
      INTEGER I1,I2,IACONX,IAD1,IAD11,IAD2,IAD21
      INTEGER JSUPMA,JNMACR,JNUEQ,JNULOC,JPRNO,JPOSDL,IBID
      INTEGER IEC,IERD,ILONG,IMA,INOLD,ITERM,JPRN1,JPRN2
      INTEGER JRESL,JSMDI,JSMHC,JSSSA,JTMP2,JVALM(2),K1
      INTEGER K2,N1,KNO,L,NUGD,NBEC,IANCMP,LGNCMP,ICMP,INDIK8
      INTEGER NBSMA,NBSSA,NCMP,NBVEL,NDDL1,NDDL2
      INTEGER NEC,NM,NMXCMP,NNOE,I,JEC
C-----------------------------------------------------------------------
C     FONCTIONS FORMULES :
C-----------------------------------------------------------------------
      INTEGER ZZPRNO,POSDD2,NUMLOC,K,NUNOEL,ILI,KDDL

      ZZPRNO(ILI,NUNOEL,L)=ZI(JPRN1-1+ZI(JPRN2+ILI-1)+
     &                     (NUNOEL-1)*(NEC+2)+L-1)
      NUMLOC(KNO,K)=ZI(JNULOC-1+2*(KNO-1)+K)
      POSDD2(KNO,KDDL)=ZI(JPOSDL-1+NMXCMP*(KNO-1)+KDDL)
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
        ICODLA(JEC)=2**(ICMP-(JEC-1)*30)
      ENDIF

      CALL JEVEUO('&&ASSMAM.NUMLOC','E',JNULOC)
      CALL JEVEUO('&&ASSMAM.POSDDL','E',JPOSDL)



      CALL SSVALM('DEBUT',OPTIO,MO,MA,0,JRESL,NBVEL)

      ILONG=0
      DO 90,IMA=1,NBSMA
C         -- BOUCLE SUR LES MACRO-ELEMENTS :
C         ----------------------------------
        IF (ZI(JSSSA-1+IMA).EQ.0)GOTO 90

        CALL JEVEUO(JEXNUM(MA//'.SUPMAIL',IMA),'L',JSUPMA)
        CALL JELIRA(JEXNUM(MA//'.SUPMAIL',IMA),'LONMAX',NNOE,KBID)

        ITERM=0

        CALL SSVALM(' ',OPTIO,MO,MA,IMA,JRESL,NBVEL)
        IF (NBVEL.GT.ILONG) THEN
          ILONG=NBVEL
          CALL JEDETR(MAT19//'.TMP2')
          CALL WKVECT(MAT19//'.TMP2',' V V I',2*ILONG,JTMP2)
        ENDIF

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
     &                ZI(JPOSDL-1+NMXCMP*(K1-1)+1))
          ZI(JNULOC-1+2*(K1-1)+1)=IAD1
          ZI(JNULOC-1+2*(K1-1)+2)=NDDL1
          DO 70 I1=1,NDDL1
            DO 50 K2=1,K1-1
              IAD2=NUMLOC(K2,1)
              NDDL2=NUMLOC(K2,2)
              DO 40 I2=1,NDDL2
                IAD11=ZI(JNUEQ-1+IAD1+POSDD2(K1,I1)-1)
                IAD21=ZI(JNUEQ-1+IAD2+POSDD2(K2,I2)-1)
                CALL ASRETM(LMASYM,JTMP2,ITERM,JSMHC,JSMDI,IAD11,IAD21)
   40         CONTINUE
   50       CONTINUE
            K2=K1
            IAD2=NUMLOC(K2,1)
            NDDL2=NUMLOC(K2,2)
            DO 60 I2=1,I1
              IAD11=ZI(JNUEQ-1+IAD1+POSDD2(K1,I1)-1)
              IAD21=ZI(JNUEQ-1+IAD2+POSDD2(K2,I2)-1)
              CALL ASRETM(LMASYM,JTMP2,ITERM,JSMHC,JSMDI,IAD11,IAD21)
   60       CONTINUE
   70     CONTINUE
   80   CONTINUE


C         ---- POUR FINIR, ON RECOPIE EFFECTIVEMENT LES TERMES:
        CALL ASCOPR(LMASYM,LMESYM,'R'//TT(2:2),JTMP2,ITERM,JRESL,
     &              C2,JVALM)
   90 CONTINUE
      CALL SSVALM('FIN',OPTIO,MO,MA,IMA,JRESL,NBVEL)


  100 CONTINUE
      CALL JEDEMA()
      END
