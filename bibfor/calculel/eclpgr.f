      SUBROUTINE ECLPGR
      IMPLICIT   NONE
C MODIF CALCULEL  DATE 11/10/2010   AUTEUR PELLET J.PELLET 
C RESPONSABLE PELLET J.PELLET
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
C   - TRAITEMENT DU MOT CLE CREA_RESU/ECLA_PG

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ---------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24,NOOJB
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --- FIN DECLARATIONS NORMALISEES JEVEUX -----------------------------

C ---------------------------------------------------------------------
      REAL*8 PREC
      INTEGER IBID,IRET,I,IAINS1,IAINS2
      INTEGER NBSY,NP,NC,ISY
      INTEGER NBORDR,IORDR,JORDR
      INTEGER MXSY,IRET2
      PARAMETER(MXSY=15)
      CHARACTER*8 MO1,MA1,MA2,KBID,RESU,EVO1,CRIT
      CHARACTER*16 TYPRES,NOMCMD,NOMSY1,NOMSY2,LICHAM(MXSY)
      CHARACTER*16 TYPRE2
      CHARACTER*19 LIGREL,CH1,CH2,PRCHNO
      CHARACTER*24 NOMFPG,VALK(2)
C DEB -----------------------------------------------------------------

      CALL JEMARQ


      CALL GETRES(RESU,TYPRE2,NOMCMD)
      CALL GETVID('ECLA_PG','RESU_INIT',1,1,1,EVO1,IBID)
      CALL GETTCO(EVO1,TYPRES)
      IF (TYPRES.NE.TYPRE2) CALL U2MESS('F','CALCULEL2_37')

      CALL GETVID('ECLA_PG','MAILLAGE',1,1,1,MA2,IBID)
      CALL GETVID('ECLA_PG','MODELE_INIT',1,1,1,MO1,IBID)
      CALL GETVTX('ECLA_PG','NOM_CHAM',1,1,MXSY,LICHAM,NBSY)

      CALL DISMOI('F','NOM_MAILLA',MO1,'MODELE',IBID,MA1,IBID)

      CALL EXLIMA('ECLA_PG',1,'V',MO1,LIGREL)

      NOMFPG='&&ECLPGR.NOMFPG'

C     -- CREATION DE LA SD RESULTAT : RESU
C     ------------------------------------
      CALL GETVR8('ECLA_PG','PRECISION',1,1,1,PREC,NP)
      CALL GETVTX('ECLA_PG','CRITERE',1,1,1,CRIT,NC)
      CALL RSUTNU(EVO1,'ECLA_PG',1,'&&ECLPGR.NUME_ORDRE',NBORDR,PREC,
     &            CRIT,IRET)
      IF (NBORDR.EQ.0) CALL U2MESS('F','CALCULEL2_38')
      CALL JEVEUO('&&ECLPGR.NUME_ORDRE','L',JORDR)

      IF (RESU.NE.EVO1) CALL RSCRSD('G',RESU,TYPRES,NBORDR)


C     -- ON CALCULE LES CHAM_NO RESULTATS :
C     --------------------------------------
      DO 20 ISY=1,NBSY

C       -- ON SUPPOSE QUE TOUS LES INSTANTS ONT LE MEME PROFIL :
C          PRCHNO
        NOOJB='12345678.00000.NUME.PRNO'
        CALL GNOMSD(NOOJB,10,14)
        PRCHNO=NOOJB(1:19)

        NOMSY1=LICHAM(ISY)
        IF (NOMSY1(6:9).NE.'ELGA') CALL U2MESS('F','CALCULEL2_41')
        NOMSY2 = NOMSY1

        DO 10 I=1,NBORDR
          IORDR=ZI(JORDR+I-1)
          CALL RSEXCH(EVO1,NOMSY1,IORDR,CH1,IRET)
          IF (IRET.GT.0)GOTO 10

          CALL RSEXCH(RESU,NOMSY2,IORDR,CH2,IRET)

C         -- ON NE CALCULE NOMFPG QUE POUR LE 1ER NUME_ORDRE :
C         -- ON VERIFIE QUE LES CHAMPS ONT TOUS LA MEME FAMILLE DE
C            DE POINTS DE GAUSS
          IF (I.EQ.1) THEN
            CALL CELFPG(CH1,NOMFPG,IRET2)
            IF (IRET2.EQ.1) THEN
              VALK(1)=MO1
              VALK(2)=LICHAM(1)
              CALL U2MESK('I','CALCULEL2_33',2,VALK)
            ENDIF
          ENDIF

          CALL ECLPGC(CH1,CH2,LIGREL,MA2,PRCHNO,NOMFPG)
          CALL RSNOCH(RESU,NOMSY2,IORDR,' ')
   10   CONTINUE
        CALL JEDETR(NOMFPG)
   20 CONTINUE


C       -- ON RECOPIE LE PARAMETRE "INST" :
C       -----------------------------------
      DO 30 I=1,NBORDR
        IORDR=ZI(JORDR+I-1)
        CALL RSADPA(EVO1,'L',1,'INST',IORDR,0,IAINS1,KBID)
        CALL RSADPA(RESU,'E',1,'INST',IORDR,0,IAINS2,KBID)
        ZR(IAINS2)=ZR(IAINS1)
   30 CONTINUE

      CALL JEDETC('V','&&ECLPGR',1)

   40 CONTINUE
      CALL JEDEMA
      END
