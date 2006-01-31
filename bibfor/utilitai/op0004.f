      SUBROUTINE OP0004 ( IER )
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER IER
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 30/01/2006   AUTEUR LEBOUVIE F.LEBOUVIER 
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
C     OPERATEUR DEFI_NAPPE
C     STOCKAGE DANS UN OBJET DE TYPE FONCTION
C     -----------------------------------------------------------------
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER       ZI
      COMMON/IVARJE/ZI(1)
      REAL*8        ZR
      COMMON/RVARJE/ZR(1)
      COMPLEX*16    ZC
      COMMON/CVARJE/ZC(1)
      LOGICAL       ZL
      COMMON/LVARJE/ZL(1)
      CHARACTER*8   ZK8
      CHARACTER*16         ZK16
      CHARACTER*24                ZK24
      CHARACTER*32                         ZK32
      CHARACTER*80                                 ZK80
      COMMON/KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ----------- FIN COMMUNS NORMALISES JEVEUX ------------------------
      CHARACTER*4  INTERP(2)
      CHARACTER*8  K8B, NOMPF
      CHARACTER*16 NOMCMD,TYPFON,VERIF
      CHARACTER*19 NOMFON
      LOGICAL      DEFONC
      INTEGER      IRET,IRET2
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
      VERIF = ' '
      DEFONC = .FALSE.
      CALL GETRES(NOMFON,TYPFON,NOMCMD)
      CALL GETVTX(' ','VERIF'   ,0,1,1,VERIF,N1)
      CALL GETVR8(' ','PARA'    ,0,1,0,TOTO ,N2)
      CALL GETVID(' ','FONCTION',0,1,0,K8B  ,N3)
      NBPARA = ABS(N2)
      IF (N3.NE.0) THEN
         NBFONC = -N3
      ELSE
         DEFONC = .TRUE.
         CALL GETFAC('DEFI_FONCTION',NBFONC)
      ENDIF
C
      IF (NBPARA.NE.NBFONC) THEN
         CALL UTDEBM('F','OP0004'//'(ERREUR.01)',' ')
         CALL UTIMPI('L','LE NOMBRE DE PARAMETRES ',1,NBPARA)
         CALL UTIMPI('S',' EST DIFFERENT DU NOMBRE DE FONCTIONS ',
     +                                                     1,NBFONC)
         CALL UTFINM()
      ENDIF
C
C     --- VERIFICATION DE LA CROISSANCE DES PARAMETRES ---
      IF ( VERIF .EQ. 'CROISSANT' ) THEN
         CALL WKVECT('&&OP0004.TEMP.PARA','V V R',NBPARA,LPAR)
         CALL GETVR8(' ','PARA',0,1,NBPARA,ZR(LPAR),N)
C        VERIF QUE LES PARA SONT STRICT CROISSANTS
         IRET=2
         CALL FOVERF(ZR(LPAR),NBPARA,IRET)
         IF(IRET.NE.2)THEN
            CALL UTMESS('F','OP0004','PARAMETRES NON CROISSANTS')
         ENDIF
         CALL JEDETR('&&OP0004.TEMP.PARA')
      ENDIF
C
      IF ( DEFONC ) THEN
         DO 10 IOCC=1, NBFONC
            CALL GETVR8('DEFI_FONCTION','VALE',IOCC,1,0,RBID,NV)
            NV = -NV
            IF (MOD(NV,2) .NE. 0 ) THEN
               CALL UTDEBM('F','OP0004'//'(ERREUR.04)',
     +                  'IL N''Y A PAS UN NOMBRE PAIR DE VALEURS')
               CALL UTIMPI('S',', "DEFI_FONCTION" OCCURENCE ',1,IOCC)
               CALL UTFINM()
            ENDIF
            IF ( VERIF .EQ. 'CROISSANT' ) THEN
               NBCOUP = NV / 2
               CALL WKVECT('&&OP0004.TEMP.PARA','V V R',NV,LPARA)
               CALL WKVECT('&&OP0004.TEMP.PAR2','V V R',NBCOUP,LPAR2)
               CALL GETVR8('DEFI_FONCTION','VALE',IOCC,1,NV,
     +                                                ZR(LPARA),NBVAL)
               DO 12 I = 0,NBCOUP-1
                  ZR(LPAR2+I) = ZR(LPARA+2*I)
 12            CONTINUE
C              VERIF QUE LES PARA SONT STRICT CROISSANTS
               IRET=2
               CALL FOVERF(ZR(LPAR2),NBCOUP,IRET)
               IF(IRET.NE.2) THEN
                  CALL UTMESS('F','OP0004','PARAMETRES NON CROISSANTS')
               ENDIF
               CALL JEDETR('&&OP0004.TEMP.PARA')
               CALL JEDETR('&&OP0004.TEMP.PAR2')
            ENDIF
  10     CONTINUE
      ENDIF

C
C --- RECUPERATION DU NIVEAU D'IMPRESSION
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)
C
C     --- CREATION ET REMPLISSAGE DE L'OBJET NOMFON.PROL ---
      NPROL = 6 + 2*NBFONC
      CALL WKVECT(NOMFON//'.PROL','G V K16',NPROL,LPRO)
      ZK16(LPRO  ) = 'NAPPE   '
      CALL GETVTX(' ','INTERPOL'   ,0,1,2,INTERP,L1)
      IF ( L1 .EQ. 1 ) INTERP(2) = INTERP(1)
      ZK16(LPRO+1) = INTERP(1)//INTERP(2)
      CALL GETVTX(' ','NOM_PARA'   ,0,1,1,ZK16(LPRO+2),L)
      CALL GETVTX(' ','NOM_RESU'   ,0,1,1,ZK16(LPRO+3),L)
      CALL GETVTX(' ','PROL_GAUCHE',0,1,1,ZK16(LPRO+4)(1:1),L)
      CALL GETVTX(' ','PROL_DROITE',0,1,1,ZK16(LPRO+4)(2:2),L)
C
C     --- CREATION ET REMPLISSAGE DE L'OBJET NOMFON.PARA ---
      CALL WKVECT(NOMFON//'.PARA','G V R',NBPARA,LPAR)
      CALL GETVR8(' ','PARA',0,1,NBPARA,ZR(LPAR),N)
C
      CALL WKVECT('&&OP0004.NOM.FONCTIONS','V V K24',NBFONC,LNOMF)
      IF ( DEFONC ) THEN
         CALL GETVTX(' ','NOM_PARA_FONC',0,1,1,ZK16(LPRO+5),L)
         MXVA = 0
         DO  20 IFONC = 1, NBFONC
            CALL GETVR8('DEFI_FONCTION','VALE',IFONC,1,0,RBID,NBVAL)
            MXVA = MAX(MXVA,-NBVAL)
 20      CONTINUE
         CALL WKVECT('&&OP0004.VALEURS.LUES','V V R',MXVA,JVAL)
         CALL WKVECT('&&OP0004.POINTEURS.F','V V I',NBFONC,LADRF)
         DO 30 IFONC = 1, NBFONC
            ZK24(LNOMF+IFONC-1) = '&&OP0004.F'
            CALL CODENT(IFONC,'G',ZK24(LNOMF+IFONC-1)(11:19))
            ZK24(LNOMF+IFONC-1)(20:24) = '.VALE'
            CALL GETVR8('DEFI_FONCTION','VALE',IFONC,1,MXVA,
     +                                                ZR(JVAL),NBVAL)
            CALL WKVECT(ZK24(LNOMF+IFONC-1),'V V R',NBVAL,LVAL)
            ZI(LADRF+IFONC-1) = LVAL
            NBCOUP = NBVAL / 2
            DO 32 IVAL = 1, NBCOUP
               ZR(LVAL-1+IVAL)        = ZR(JVAL-1+2*IVAL-1)
               ZR(LVAL-1+NBCOUP+IVAL) = ZR(JVAL-1+2*IVAL)
 32         CONTINUE
C
C           --- VERIFICATION QU'ON A BIEN CREER UNE FONCTION ---
C               ET REMISE DES ABSCISSES EN ORDRE CROISSANT
C           CE N'EST PAS LA PEINE SI LA CROISSANTE STRICTE A ETE IMPOSEE
            IF(VERIF.NE.'CROISSANT')THEN
               IRET2=0
               CALL FOVERF(ZR(LVAL),NBCOUP,IRET2)
               IF(IRET2.EQ.0)THEN
                  TYPFON='FONCTION'
                  CALL UTTRIF(ZR(LVAL),NBCOUP,TYPFON)
                CALL UTDEBM('A','OP0004','LES ABSCISSES DE LA FONCTION')
                  CALL UTIMPK('S',' ',1,NOMFON)
                  CALL UTIMPK('L','ONT ETE REORDONNEES.',0,K8B)
                  CALL UTFINM()
               ELSEIF(IRET2.LT.0)THEN
                  CALL ORDON1(ZR(LVAL),NBCOUP)
        CALL UTDEBM('A','OP0004','L ORDRE DES ABSCISSES DE LA FONCTION')
                  CALL UTIMPI('S',' NUMERO ',1,IFONC)
                  CALL UTIMPK('L','A ETE INVERSE .',0,K8B)
                  CALL UTFINM()
               ENDIF
            ENDIF
C
            CALL GETVTX('DEFI_FONCTION','INTERPOL'   ,IFONC,1,2,
     +                                                INTERP,L1)
            IF ( L1 .EQ. 1 ) INTERP(2) = INTERP(1)
            ZK16(LPRO+5+2*IFONC-1) = INTERP(1)//INTERP(2)
            CALL GETVTX('DEFI_FONCTION','PROL_GAUCHE',IFONC,1,1,
     +                                   ZK16(LPRO+5+2*IFONC)(1:1),L)
            CALL GETVTX('DEFI_FONCTION','PROL_DROITE',IFONC,1,1,
     +                                   ZK16(LPRO+5+2*IFONC)(2:2),L)
 30      CONTINUE
      ELSE
         CALL GETVID(' ','FONCTION',0,1,NBFONC,ZK24(LNOMF),N)
         CALL FOVERN(ZK24(LNOMF),NBFONC,ZK16(LPRO),IRET)
      ENDIF
C
C     --- ON ORDONNE LA NAPPE SUIVANT LES PARAMETRES CROISSANTS ---
      IF (VERIF.NE.'CROISSANT') THEN
          IRET=0
          CALL FOORDN(ZR(LPAR),ZK24(LNOMF),NBPARA,NBFONC,IRET)
          IF (IRET.NE.0 .AND. .NOT. DEFONC) THEN
             CALL UTMESS('F','OP0004'//'(ERREUR.05)',
     +                       'DEUX FONCTIONS DIFFERENTES '//
     +                       'AFFECTEE A LA MEME VALEUR DE PARAMETRE.')
          ELSEIF (IRET.NE.0 ) THEN
             CALL UTMESS('F','OP0004'//'(ERREUR.06)',
     +                       'DEUX LISTES DE VALEURS DIFFERENTES '//
     +                       'AFFECTEE A LA MEME VALEUR DE PARAMETRE.')
          ENDIF
      ENDIF
C
C     --- CREATION ET REMPLISSAGE DE LA COLLECTION NOMFON.VALE ---
      CALL JECREC(NOMFON//'.VALE','G V R',
     +                            'NU','CONTIG','VARIABLE',NBFONC)
      CALL FOSTON(NOMFON//'.VALE',ZK24(LNOMF),NBFONC)
C
C     --- CREATION D'UN TITRE ---
      CALL TITRE
C
C     --- IMPRESSIONS ---
      IF (NIV.GT.1) CALL FOIMPR(NOMFON,NIV,IFM,0,K8B)
C
      CALL JEDEMA()
      END
