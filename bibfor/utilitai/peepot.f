      SUBROUTINE PEEPOT(RESU,MODELE,MATE,CARA,NCHAR,LCHAR,NH,NBOCC)
      IMPLICIT   NONE
      INTEGER NCHAR,NH,NBOCC
      CHARACTER*(*) RESU,MODELE,MATE,CARA,LCHAR(*)
C     ------------------------------------------------------------------
C MODIF UTILITAI  DATE 04/12/2001   AUTEUR GNICOLAS G.NICOLAS 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C     OPERATEUR   POST_ELEM
C     TRAITEMENT DU MOT CLE-FACTEUR "ENER_POT"
C     ------------------------------------------------------------------

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
      CHARACTER*32 JEXNOM
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
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      INTEGER ND,NR,NI,IRET,NP,NC,JORD,JINS,JAD,NBORDR,IORD,NUMORD,
     &        IAINST,JNMO,IBID,IE,IRE1,IRE2,NT,NM,NG,NBGRMA,IG,JGR,NBMA,
     &        NUME,IM,NBPARR,NBPARD,NBPAEP,IOCC,JMA,ICHEML,IFM,NIV,IFR,
     &        IUNIFI
      PARAMETER (NBPAEP=2,NBPARR=6,NBPARD=4)
      REAL*8 PREC,VARPEP(NBPAEP),ALPHA,INST,VALER(3)
      CHARACTER*1 BASE
      CHARACTER*8 K8B,NOMA,RESUL,CRIT,NOMLIG,NOMMAI,TYPARR(NBPARR),
     &            TYPARD(NBPARD),VALEK(2)
      CHARACTER*16 TYPRES,OPTION,OPTIO2,NOPARR(NBPARR),NOPARD(NBPARD)
      CHARACTER*19 CHELEM,KNUM,KINS,DEPLA,LIGREL
      CHARACTER*24 CHTIME,CHNUMC,CHAMGD,CHFREQ,CHMASS,CHSIG,CHEPS,
     &             TYPCHA,CHGEOM,CHCARA(15),CHTEMP,CHTREF,CHHARM,MLGGMA,
     &             MLGNMA,K24B
      LOGICAL EXITIM
      COMPLEX*16 C16B,CALPHA

      DATA NOPARR/'NUME_ORDRE','INST','LIEU','ENTITE','TOTALE',
     &     'POUR_CENT'/
      DATA TYPARR/'I','R','K8','K8','R','R'/
      DATA NOPARD/'LIEU','ENTITE','TOTALE','POUR_CENT'/
      DATA TYPARD/'K8','K8','R','R'/

C     ------------------------------------------------------------------
      CALL JEMARQ()

C --- RECUPERATION DU NIVEAU D'IMPRESSION
      CALL INFNIV(IFM,NIV)
      IFR = IUNIFI('RESULTAT')

      BASE = 'V'
      K24B = ' '
      EXITIM = .FALSE.
      INST = 0.D0
      ALPHA = 1.D0
      CALPHA = (1.D0,1.D0)
      CALL GETVID(' ','CHAM_GD',1,1,1,DEPLA,ND)
      CALL GETVID(' ','RESULTAT',1,1,1,RESUL,NR)
      CALL GETVR8(' ','INST',1,1,1,INST,NI)
      IF (NI.NE.0) EXITIM = .TRUE.
      IF (NR.NE.0) THEN
        CALL GETTCO(RESUL,TYPRES)
        IF (TYPRES(1:9).EQ.'MODE_MECA') THEN
          NOPARR(2) = 'FREQ'
        ELSE IF (TYPRES(1:9).EQ.'EVOL_THER' .OR.
     &           TYPRES(1:9).EQ.'EVOL_ELAS' .OR.
     &           TYPRES(1:9).EQ.'EVOL_NOLI' .OR.
     &           TYPRES(1:10).EQ.'DYNA_TRANS') THEN
          NOPARR(2) = 'INST'
        ELSE
          CALL UTMESS('F','PEEPOT','ON ATTEND UN CONCEPT '//
     &                '"MODE_MECA" OU "EVOL_ELAS"'//
     &                ' OU "EVOL_THER" OU "DYNA_TRANS" OU "EVOL_NOLI"')
        END IF
      END IF

      OPTION = 'ENER_POT'
      CALL MECHAM(OPTION,MODELE,NCHAR,LCHAR,CARA,NH,CHGEOM,CHCARA,
     &            CHHARM,IRET)
      IF (IRET.NE.0) GO TO 90
      NOMA = CHGEOM(1:8)
      MLGNMA = NOMA//'.NOMMAI'
      MLGGMA = NOMA//'.GROUPEMA'
      CHFREQ = ' '
      CHMASS = ' '
      CALL MECHNC(NOMA,' ',0,CHNUMC)

      NOMLIG = '&&PEEPOT'
      CALL EXLIMA('ENER_POT','V',MODELE,NOMLIG,LIGREL)

      KNUM = '&&PEEPOT.NUME_ORDRE'
      KINS = '&&PEEPOT.INSTANT'
      TYPRES = ' '
      IF (ND.NE.0) THEN
        NBORDR = 1
        CALL WKVECT(KNUM,'V V I',NBORDR,JORD)
        ZI(JORD) = 1
        CALL WKVECT(KINS,'V V R',NBORDR,JINS)
        ZR(JINS) = INST
        CALL TBCRSD(RESU,'G')
        CALL TBAJPA(RESU,NBPARD,NOPARD,TYPARD)
      ELSE
        CALL GETVR8(' ','PRECISION',1,1,1,PREC,NP)
        CALL GETVTX(' ','CRITERE',1,1,1,CRIT,NC)
        CALL RSUTNU(RESUL,' ',0,KNUM,NBORDR,PREC,CRIT,IRET)
        IF (IRET.NE.0) GO TO 80
        CALL JEVEUO(KNUM,'L',JORD)
C        --- ON RECUPERE LES INSTANTS ---
        CALL WKVECT(KINS,'V V R',NBORDR,JINS)
        CALL JEEXIN(RESUL//'           .INST',IRET)
        IF (IRET.NE.0) THEN
          EXITIM = .TRUE.
          DO 10 IORD = 1,NBORDR
            NUMORD = ZI(JORD+IORD-1)
            CALL RSADPA(RESUL,'L',1,'INST',NUMORD,0,IAINST,K8B)
            ZR(JINS+IORD-1) = ZR(IAINST)
   10     CONTINUE
        ELSE
          CALL JEEXIN(RESUL//'           .FREQ',IRET)
          IF (IRET.NE.0) THEN
            DO 20 IORD = 1,NBORDR
              NUMORD = ZI(JORD+IORD-1)
              CALL RSADPA(RESUL,'L',1,'FREQ',NUMORD,0,IAINST,K8B)
              ZR(JINS+IORD-1) = ZR(IAINST)
   20       CONTINUE
          END IF
        END IF
        CALL TBCRSD(RESU,'G')
        CALL TBAJPA(RESU,NBPARR,NOPARR,TYPARR)
      END IF

      DO 70 IORD = 1,NBORDR
        ICHEML = 0
        NUMORD = ZI(JORD+IORD-1)
        INST = ZR(JINS+IORD-1)
        VALER(1) = INST
        IF (TYPRES.EQ.'FOURIER_ELAS') THEN
          CALL RSADPA(RESUL,'L',1,'NUME_MODE',NUMORD,0,JNMO,K8B)
          CALL MEHARM(MODELE,ZI(JNMO),CHHARM)
        END IF
        CHTIME = ' '
        IF (EXITIM) CALL MECHTI(NOMA,INST,CHTIME)

        IF (NR.NE.0) THEN
          CALL RSEXCH(RESUL,'EPOT_ELEM_DEPL',NUMORD,DEPLA,IRET)
          IF (IRET.GT.0) THEN
            CALL RSEXCH(RESUL,'DEPL',NUMORD,DEPLA,IRE1)
            IF (IRE1.GT.0) THEN
              CALL RSEXCH(RESUL,'TEMP',NUMORD,DEPLA,IRE2)
              IF (IRE2.GT.0) GO TO 70
            END IF
          END IF
        END IF

        CALL DISMOI('F','TYPE_SUPERVIS',DEPLA,'CHAMP',IBID,TYPCHA,IE)
        IF (TYPCHA(1:12).EQ.'CHAM_NO_DEPL') THEN
          OPTIO2 = 'EPOT_ELEM_DEPL'
          CHAMGD = DEPLA
          CALL MECHTE(MODELE,NCHAR,LCHAR,MATE,EXITIM,INST,CHTREF,CHTEMP)
        ELSE IF (TYPCHA(1:12).EQ.'CHAM_NO_TEMP') THEN
          OPTIO2 = 'EPOT_ELEM_TEMP'
          CHAMGD = ' '
          CHTREF = ' '
          CHTEMP = DEPLA
        ELSE IF (TYPCHA(1:14).EQ.'CHAM_ELEM_ENER') THEN
          CHELEM = DEPLA
          GO TO 30
        ELSE
          CALL UTMESS('F','PEEPOT','TYPE DE CHAMP INCONNU.')
        END IF
        ICHEML = 1
        CHELEM = '&&PEEPOT.CHAM_ELEM'
        IBID = 0
        CALL MECALC(OPTIO2,MODELE,CHAMGD,CHGEOM,MATE,CHCARA,CHTEMP,
     &              CHTREF,CHTIME,CHNUMC,CHHARM,CHSIG,CHEPS,CHFREQ,
     &              CHMASS,K24B,K24B,K24B,ALPHA,CALPHA,K24B,K24B,CHELEM,
     &              LIGREL,BASE,K24B,K24B,K24B,K24B,
     &                  K24B, K24B, K8B, IBID, IRET)
   30   CONTINUE

C        --- IMPRESSION DU CHAMELEM ---
        IF (NIV.GT.1) THEN
          IF (NR.NE.0) WRITE (IFR,1000) OPTIO2,NUMORD,INST
          CALL IRCHAM(CHELEM)
        END IF

C        --- ON CALCULE L'ENERGIE TOTALE ---
        CALL PEENCA(CHELEM,NBPAEP,VARPEP,0,IBID)

        DO 60 IOCC = 1,NBOCC
          CALL GETVTX(OPTION(1:9),'TOUT',IOCC,1,0,K8B,NT)
          CALL GETVEM(NOMA,'MAILLE',OPTION(1:9),'MAILLE',IOCC,1,0,K8B,
     &                NM)
          CALL GETVEM(NOMA,'GROUP_MA',OPTION(1:9),'GROUP_MA',IOCC,1,0,
     &                K8B,NG)
          IF (NT.NE.0) THEN
            CALL PEENCA(CHELEM,NBPAEP,VARPEP,0,IBID)
            VALEK(1) = NOMA
            VALEK(2) = 'TOUT'
            IF (NR.NE.0) THEN
              VALER(2) = VARPEP(1)
              VALER(3) = VARPEP(2)
              CALL TBAJLI(RESU,NBPARR,NOPARR,NUMORD,VALER,C16B,VALEK,0)
            ELSE
              CALL TBAJLI(RESU,NBPARD,NOPARD,NUMORD,VARPEP,C16B,VALEK,0)
            END IF
          END IF
          IF (NG.NE.0) THEN
            NBGRMA = -NG
            CALL WKVECT('&&PEEPOT_GROUPM','V V K8',NBGRMA,JGR)
            CALL GETVEM(NOMA,'GROUP_MA',OPTION(1:9),'GROUP_MA',IOCC,1,
     &                  NBGRMA,ZK8(JGR),NG)
            VALEK(2) = 'GROUP_MA'
            DO 40 IG = 1,NBGRMA
              NOMMAI = ZK8(JGR+IG-1)
              CALL JEEXIN(JEXNOM(MLGGMA,NOMMAI),IRET)
              IF (IRET.EQ.0) THEN
                CALL UTMESS('A','PEEPOT','LE GROUPE DE MAILLE "'//
     &                      NOMMAI//'" N''EXISTE PAS.')
                GO TO 40
              END IF
              CALL JELIRA(JEXNOM(MLGGMA,NOMMAI),'LONMAX',NBMA,K8B)
              IF (NBMA.EQ.0) THEN
                CALL UTMESS('A','PEEPOT','LE GROUPE "'//NOMMAI//
     &                      '" NE CONTIENT AUCUNE MAILLE.')
                GO TO 40
              END IF
              CALL JEVEUO(JEXNOM(MLGGMA,NOMMAI),'L',JAD)
              CALL PEENCA(CHELEM,NBPAEP,VARPEP,NBMA,ZI(JAD))
              VALEK(1) = NOMMAI
              IF (NR.NE.0) THEN
                VALER(2) = VARPEP(1)
                VALER(3) = VARPEP(2)
                CALL TBAJLI(RESU,NBPARR,NOPARR,NUMORD,VALER,C16B,VALEK,
     &                      0)
              ELSE
                CALL TBAJLI(RESU,NBPARD,NOPARD,NUMORD,VARPEP,C16B,VALEK,
     &                      0)
              END IF
   40       CONTINUE
            CALL JEDETR('&&PEEPOT_GROUPM')
          END IF
          IF (NM.NE.0) THEN
            NBMA = -NM
            CALL WKVECT('&&PEEPOT_MAILLE','V V K8',NBMA,JMA)
            CALL GETVEM(NOMA,'MAILLE',OPTION(1:9),'MAILLE',IOCC,1,NBMA,
     &                  ZK8(JMA),NM)
            VALEK(2) = 'MAILLE'
            DO 50 IM = 1,NBMA
              NOMMAI = ZK8(JMA+IM-1)
              CALL JEEXIN(JEXNOM(MLGNMA,NOMMAI),IRET)
              IF (IRET.EQ.0) THEN
                CALL UTMESS('A','PEEPOT','LA MAILLE "'//NOMMAI//
     &                      '" N''EXISTE PAS.')
                GO TO 50
              END IF
              CALL JENONU(JEXNOM(MLGNMA,NOMMAI),NUME)
              CALL PEENCA(CHELEM,NBPAEP,VARPEP,1,NUME)
              VALEK(1) = NOMMAI
              IF (NR.NE.0) THEN
                VALER(2) = VARPEP(1)
                VALER(3) = VARPEP(2)
                CALL TBAJLI(RESU,NBPARR,NOPARR,NUMORD,VALER,C16B,VALEK,
     &                      0)
              ELSE
                CALL TBAJLI(RESU,NBPARD,NOPARD,NUMORD,VARPEP,C16B,VALEK,
     &                      0)
              END IF
   50       CONTINUE
            CALL JEDETR('&&PEEPOT_MAILLE')
          END IF
   60   CONTINUE
        CALL JEDETR('&&PEEPOT.PAR')
        IF (ICHEML.NE.0) CALL JEDETR(CHELEM)
   70 CONTINUE

   80 CONTINUE
      CALL JEDETR(KNUM)
      CALL JEDETR(KINS)

 1000 FORMAT (1P,' ------>',/,
     &       ' CHAMP PAR ELEMENT AUX NOEUDS DE NOM SYMBOLIQUE ',A16,/,
     &       ' NUMERO D''ORDRE: ',I7,'  INST: ',E12.5)

   90 CONTINUE
      CALL JEDEMA()
      END
