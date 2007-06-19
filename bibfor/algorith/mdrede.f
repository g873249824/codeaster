      SUBROUTINE MDREDE (NUMDDL,NBREDE,NBMODE,BMODAL,NEQ,DPLRED,
     &                   PARRED,FONRED,IER)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER       NBREDE,NBMODE,NEQ,IER
      REAL*8        DPLRED(NBREDE,NBMODE,*),PARRED(NBREDE,*),
     &              BMODAL(NEQ,*)
      CHARACTER*8   FONRED(NBREDE,*)
      CHARACTER*14  NUMDDL
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/06/2007   AUTEUR LEBOUVIER F.LEBOUVIER 
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
C
C     STOCKAGE DES INFORMATIONS DE RED DANS DES TABLEAUX
C     ------------------------------------------------------------------
C IN  : NUMDDL       : NOM DU CONCEPT NUMDDL
C IN  : NBREDE       : NOMBRE DE RELATION EFFORT DEPLACEMENT (RED)
C IN  : NBMODE       : NOMBRE DE MODES DE LA BASE DE PROJECTION
C IN  : BMODAL       : VECTEURS MODAUX
C IN  : NEQ          : NOMBRE D'EQUATIONS
C IN  : FONRED( ,4)  : TYPE DU MOT-CLE FACTEUR (TRANSIS OU DEPL)
C OUT : DPLRED       : TABLEAU DES DEPLACEMENTS MODAUX AUX NOEUDS DE RED
C OUT : PARRED       : TABLEAU DES PARAMETRES DE RED
C OUT : FONRED( ,1-3): TABLEAU DES FONCTIONS AUX NOEUDS DE RED
C OUT : IER          : CODE RETOUR
C ----------------------------------------------------------------------
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      REAL*8 VALR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C
      CHARACTER*32  JEXNUM,JEXNOM
C
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER       I, NUNOE, NUDDL, ICOMP
      CHARACTER*1   K1BID
      CHARACTER*8   NOEU, COMP, FONC, SST, NOECHO(3)
      CHARACTER*14  NUME
      CHARACTER*16  TYPNUM
      CHARACTER*24  MDGENE, MDSSNO, NUMERO
      CHARACTER*24 VALK
C
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      IER = 0
      CALL GETTCO(NUMDDL,TYPNUM)
C
      IF (TYPNUM(1:13).EQ.'NUME_DDL_GENE') THEN
        CALL JEVEUO(NUMDDL//'.NUME.REFE','L',LLREFE)
        MDGENE = ZK24(LLREFE)
        MDSSNO = MDGENE(1:14)//'.MODG.SSNO'
        NUMERO(1:14) = NUMDDL
      ENDIF
C
      DO 10 I = 1,NBREDE
C
        IF (FONRED(I,4) .EQ. 'DEPL    ') THEN
           CALL GETVID('RELA_EFFO_DEPL','NOEUD'   ,I,1,1,NOEU,NN)
           CALL GETVTX('RELA_EFFO_DEPL','NOM_CMP' ,I,1,1,COMP,NC)
           CALL GETVID('RELA_EFFO_DEPL','RELATION',I,1,1,FONC,NF)
           CALL GETVTX('RELA_EFFO_DEPL','SOUS_STRUC',I,1,1,SST,NS)
        ELSEIF (FONRED(I,4) .EQ. 'TRANSIS ') THEN
           CALL GETVID('RELA_TRANSIS','NOEUD'   ,I,1,1,NOEU,NN)
           CALL GETVTX('RELA_TRANSIS','NOM_CMP' ,I,1,1,COMP,NC)
           CALL GETVID('RELA_TRANSIS','RELATION',I,1,1,FONC,NF)
           CALL GETVTX('RELA_TRANSIS','SOUS_STRUC',I,1,1,SST,NS)
        ENDIF
C
        IF (COMP(1:2).EQ.'DX')  ICOMP = 1
        IF (COMP(1:2).EQ.'DY')  ICOMP = 2
        IF (COMP(1:2).EQ.'DZ')  ICOMP = 3
        IF (COMP(1:3).EQ.'DRX') ICOMP = 4
        IF (COMP(1:3).EQ.'DRY') ICOMP = 5
        IF (COMP(1:3).EQ.'DRZ') ICOMP = 6
C
C ----- CALCUL DIRECT
        IF (TYPNUM.EQ.'NUME_DDL_SDASTER') THEN
          CALL POSDDL('NUME_DDL',NUMDDL,NOEU,COMP,NUNOE,NUDDL)
C
C ----- CALCUL PAR SOUS-STRUCTURATION
        ELSEIF (TYPNUM(1:13).EQ.'NUME_DDL_GENE') THEN
          IF (NS.EQ.0) THEN
            CALL U2MESS('F','ALGORITH5_63')
          ENDIF
          CALL JENONU(JEXNOM(MDSSNO,SST),IRET)
          IF (IRET.EQ.0) THEN
            CALL U2MESS('F','ALGORITH5_64')
          ENDIF
          CALL MGUTDM(MDGENE,SST,IBID,'NOM_NUME_DDL',IBID,NUME)
          CALL POSDDL('NUME_DDL',NUME(1:8),NOEU,COMP,NUNOE,NUDDL)
        ENDIF
C
        IF (NUDDL.EQ.0) THEN
          VALK = NOEU
          CALL U2MESG('E+','ALGORITH15_16',1,VALK,0,0,0,0.D0)
          IF (TYPNUM(1:13).EQ.'NUME_DDL_GENE') THEN
            VALK = SST
            CALL U2MESG('E+','ALGORITH15_17',1,VALK,0,0,0,0.D0)
          ENDIF
          VALK = COMP
          CALL U2MESG('E','ALGORITH15_18',1,VALK,0,0,0,0.D0)
          IER = IER + 1
          GOTO 10
        ENDIF
C
         PARRED(I,1) = 0.D0
         PARRED(I,2) = 0.D0
         CALL JEEXIN(FONC//'           .VALE',IRET)
         IF (IRET .EQ. 0 ) THEN
           IF (FONRED(I,4) .EQ. 'TRANSIS ') THEN
             VALK = FONC
             CALL U2MESG('E','ALGORITH15_19',1,VALK,0,0,0,0.D0)
             IER = IER + 1
             GOTO 10
           ENDIF
         ELSE
           CALL JEVEUO(FONC//'           .VALE','L',LVAL)
           PARRED(I,1) = ZR(LVAL)
           IF (FONRED(I,4) .EQ. 'TRANSIS ') THEN
             CALL JELIRA(FONC//'           .VALE','LONUTI',NBPT,K1BID)
             LFON = LVAL + ( NBPT / 2 )
             IF (ABS(ZR(LVAL)).LT.1.D-08) THEN
              VALK = FONC
              VALR = ZR(LVAL)
              CALL U2MESG('E','ALGORITH15_20',1,VALK,0,0,1,VALR)
              IER = IER + 1
              GOTO 10
             ENDIF
             PARRED(I,2) = ZR(LFON) / ZR(LVAL)
           ENDIF
         ENDIF
C
        DO 11 J=1,NBMODE
          DPLRED(I,J,1) = 0.D0
          DPLRED(I,J,2) = 0.D0
          DPLRED(I,J,3) = 0.D0
          DPLRED(I,J,4) = 0.D0
          DPLRED(I,J,5) = 0.D0
          DPLRED(I,J,6) = 0.D0
11      CONTINUE
C
C ----- CALCUL DIRECT
        IF (TYPNUM.EQ.'NUME_DDL_SDASTER') THEN
          DO 13 J=1,NBMODE
            DPLRED(I,J,ICOMP) = BMODAL(NUDDL,J)
13        CONTINUE
C
C ----- CALCUL PAR SOUS-STRUCTURATION
        ELSEIF (TYPNUM(1:13).EQ.'NUME_DDL_GENE') THEN
          CALL WKVECT('&&MDREDE.DPLCHO','V V R8',NBMODE*6,JDPL)
          NOECHO(1) = NOEU
          NOECHO(2) = SST
          NOECHO(3) = NUME
          CALL RESMOD(BMODAL,NBMODE,NEQ,NUMERO,MDGENE,NOECHO,ZR(JDPL))
          DO 12 J=1,NBMODE
            DPLRED(I,J,ICOMP) = ZR(JDPL-1+J+(ICOMP-1)*NBMODE)
12        CONTINUE
          CALL JEDETR('&&MDREDE.DPLCHO')
        ENDIF
C
        FONRED(I,1) = NOEU
        FONRED(I,2) = COMP
        FONRED(I,3) = FONC
C
10    CONTINUE
C
      CALL JEDEMA()
      END
