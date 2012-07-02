      SUBROUTINE ASIMPR(NBSUP,TCOSUP,NOMSUP)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER          NBSUP,TCOSUP(NBSUP,*)
      CHARACTER*8      NOMSUP(NBSUP,*)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C     ------------------------------------------------------------------
C     COMMANDE : COMB_SISM_MODAL
C      IMPRIME LES RESULTATS DES REPONSES PRIMAIRES ET SECONDAIRES
C     ------------------------------------------------------------------

      CHARACTER*4  TYPDIR
      CHARACTER*8  K8B, NOEU, CMP,NOREF
      CHARACTER*8  KNUM,KDIR
      CHARACTER*19 KNOEU,DIDI,LNORE,NBNOR,ORDR
      CHARACTER*80 NOMCAS,CHAINQ,CHAINL,CHAINA
      REAL*8       R8VIDE
      INTEGER      IARG
C
C-----------------------------------------------------------------------
      INTEGER IA ,IBID ,IC ,ICAS ,ID ,IDEP ,IFM 
      INTEGER II ,IL ,INO ,IOCC ,IORDR ,IQ ,IS 
      INTEGER IUNIFI ,JCAS ,JDIR ,JKNO ,JNO ,JNOE ,JNREF 
      INTEGER JORD ,JREF ,JTYP ,LNOD ,NBNO ,NBOC ,NCAS 
      INTEGER NDEP ,NUCAS ,NUME 
      REAL*8 EPSIMA ,VALE 
C-----------------------------------------------------------------------
      EPSIMA = R8VIDE()
      CALL JEMARQ()
      IFM    = IUNIFI('MESSAGE')
      KNOEU  = '&&OP0109.NOM_SUPPOR'
      DIDI   = '&&OP0109.DIRECTION'
      LNORE = '&&ASENAP.NOREF'
      NBNOR = '&&ASENAP.NREF'
      ORDR ='&&ASECON.NORD'
C
      WRITE(IFM,1167)
      WRITE(IFM,1170)
      CALL JEVEUO(KNOEU,'L',JKNO)
      CALL JEVEUO(DIDI,'L',JDIR)
      CALL JEVEUO(LNORE,'L',JNREF)
      CALL JEVEUO(NBNOR,'L',JREF)
      CALL JEVEUO(ORDR,'L',JORD)
C
C  CAS DES IMPRESSIONS POUR LA REPONSE PRIMAIRE
C
      CHAINQ = ' '
      CHAINL = ' '
      CHAINA = ' '

      CHAINQ(1 : 4) ='QUAD'
      CHAINL(1 : 4) ='LINE'
      CHAINA(1 : 4) ='ABS '
      IQ = 1
      IL = 1
      IA = 1
      CALL WKVECT('&&ASIMPR.NOEUDS','V V K8',3*NBSUP,JNOE)
      INO = 1
      DO 40 ID =1,3
        DO 42 IS = 1,NBSUP
          IF (TCOSUP(IS,1).EQ.1) THEN
            DO 44 II=1,INO
            IF (NOMSUP(IS,ID).EQ.ZK8(JNOE+II-1)) THEN
             GOTO 42
            ENDIF
 44         CONTINUE
            ZK8(JNOE+INO-1) = NOMSUP(IS,ID)
            CHAINQ(IQ+5 : IQ+12)= ZK8(JNOE+INO-1)
            INO = INO+1
            IQ = IQ+9
          ELSE IF (TCOSUP(IS,1).EQ.2) THEN
            DO 46 II=1,INO
            IF (NOMSUP(IS,ID).EQ.ZK8(JNOE+INO-1)) GOTO 42
 46         CONTINUE
            ZK8(JNOE+INO-1)= NOMSUP(IS,ID)
            CHAINL(IL+5 : IL+12)= NOMSUP(IS,ID)
            INO = INO+1
            IL = IL+9
          ELSE IF (TCOSUP(IS,1).EQ.3) THEN
            DO 48 II=1,INO
            IF (NOMSUP(IS,ID).EQ.ZK8(JNOE+INO-1)) GOTO 42
 48         CONTINUE
            CHAINA(IA+5 : IA+12)= NOMSUP(IS,ID)
            ZK8(JNOE+INO-1)= NOMSUP(IS,ID)
            INO = INO+1
            IA = IA+9
          ENDIF
 42     CONTINUE
 40   CONTINUE

      IF (IQ.NE.1)
     +   WRITE(IFM,1180) CHAINQ
      IF (IL.NE.1)
     +    WRITE(IFM,1180) CHAINL
      IF (IA.NE.1)
     +   WRITE(IFM,1180) CHAINA


C
C  CAS DES IMPRESSIONS POUR LA REPONSE SECONDAIRE
C
      CALL GETFAC('COMB_DEPL_APPUI',NBOC)
      CALL GETFAC('DEPL_MULT_APPUI',NDEP)
      CALL JEVEUO('&&ASENAP.TYPE','L',JTYP)
      NOREF = '-'
      WRITE(IFM,1190)
      WRITE(IFM,1200)
      DO 10 IOCC =1,NBOC
        CALL JELIRA(JEXNUM('&&ASENAP.LISTCAS',IOCC),'LONMAX',
     +                                                   NCAS,K8B)
        CALL JEVEUO(JEXNUM('&&ASENAP.LISTCAS',IOCC),'L',JCAS)
        DO 20 ICAS = 1,NCAS
          NUCAS = ZI(JCAS+ICAS-1)
          DO 30 IDEP = 1,NDEP
           CALL GETVIS('DEPL_MULT_APPUI','NUME_CAS',IDEP,IARG,1,
     &                 NUME,IBID)
            IF (NUME.EQ.NUCAS) THEN
               CALL GETVTX('DEPL_MULT_APPUI','NOM_CAS',
     +                IDEP,IARG,1,NOMCAS,IBID)
               KNUM = 'N       '
               CALL CODENT(NUCAS, 'D0' , KNUM(2:8) )
               KDIR = 'D       '
               CALL CODENT(NUCAS, 'D0' , KDIR(2:8) )
               CALL JELIRA (JEXNOM('&&ASENAP.LINOEU',KNUM),
     &              'LONMAX',NBNO,K8B)
               CALL JEVEUO (JEXNOM('&&ASENAP.LINOEU',KNUM),
     &              'L', JNO )
               LNOD =3*NBNO
               CALL JELIRA (JEXNOM('&&ASENAP.LIDIR',KDIR),'LONMAX',
     &             LNOD,K8B)
               CALL JEVEUO (JEXNOM('&&ASENAP.LIDIR',KDIR), 'L', JDIR )
               IF (ZI(JREF+ICAS-1).EQ.1)  NOREF = ZK8(JNREF+ICAS-1)
               DO 12 INO = 1,NBNO
                 NOEU =ZK8(JNO+INO-1)
                 IF (ZR(JDIR+3*(INO-1)).NE.EPSIMA) THEN
                     CMP = 'DX'
                     VALE = ZR(JDIR+3*(INO-1))
                     WRITE(IFM,1210)NUCAS,NOEU,
     +           CMP,VALE,NOREF,NOMCAS
                 ENDIF
                 IF (ZR(JDIR+3*(INO-1)+1).NE.EPSIMA) THEN
                     CMP = 'DY'
                     VALE = ZR(JDIR+3*(INO-1)+1)
                     WRITE(IFM,1210)NUCAS,NOEU,
     +           CMP,VALE,NOREF,NOMCAS
                 ENDIF
                 IF (ZR(JDIR+3*(INO-1)+2).NE.EPSIMA) THEN
                     CMP = 'DZ'
                     VALE = ZR(JDIR+3*(INO-1)+2)
                      WRITE(IFM,1210)NUCAS,NOEU,
     +           CMP,VALE,NOREF,NOMCAS
                 ENDIF
 12          CONTINUE
            ENDIF
 30       CONTINUE
 20     CONTINUE
 10   CONTINUE
      DO 50 IOCC = 1,NBOC
        CALL JELIRA(JEXNUM('&&ASENAP.LISTCAS',IOCC),'LONMAX',
     +                                                   NCAS,K8B)
        CALL JEVEUO(JEXNUM('&&ASENAP.LISTCAS',IOCC),'L',JCAS)
        WRITE(IFM,1220)
        IF (ZI(JTYP+IOCC-1).EQ.1) TYPDIR = 'QUAD'
        IF (ZI(JTYP+IOCC-1).EQ.2) TYPDIR = 'LINE'
        IF (ZI(JTYP+IOCC-1).EQ.3) TYPDIR = 'ABS'
        IORDR = ZI(JORD+IOCC-1)
        WRITE(IFM,1230)
        WRITE(IFM,1240)IORDR,TYPDIR,( ZI(JCAS+IC-1),IC=1,NCAS)
 50   CONTINUE
      IORDR = ZI(JORD+NBOC)
      TYPDIR ='QUAD'
      WRITE(IFM,1250)
      WRITE(IFM,1260)
      WRITE(IFM,1270)IORDR,TYPDIR
C
C ----LISTE DES FORMATS D IMPRESSIONS
C

 1167 FORMAT(/,1X,'--- COMPOSANTE PRIMAIRE ---')
 1170 FORMAT(1X,
     +      'COMBI SUPPORT')
 1180 FORMAT(2X,A80)
 1190 FORMAT(/,1X,' --- COMPOSANTE SECONDAIRE ---')
 1200 FORMAT(1X,
     + '  CAS      SUPPORT     CMP        VALEUR       '//
     +  ' NOEUD_REFE  NOM_CAS')
 1210 FORMAT(1P,1X,I5,5X,A8,3X,A8,5X,D12.5,3X,A8,3X,A80)
 1220 FORMAT(1X,
     +      'GROUPE DE CAS')
 1230 FORMAT(1X,'NUME_ORDRE     COMBI     LIST_CAS')
 1240 FORMAT(1P,1X,I5,8X,A8,5X,100(I3,1X))
 1250 FORMAT(/,1X,' SOMME QUADRATIQUE DES OCCURENCES '//
     +   ' DE COMB_DEPL_APPUI    ')
 1260 FORMAT(/,1X,'NUME_ORDRE     CUMUL     ')
 1270 FORMAT(1P,1X,I5,8X,A8)
C
      CALL JEDETC('V','&&ASECON',1)
      CALL JEDETC('V','&&ASIMPR',1)
      CALL JEDEMA()
      END
