      SUBROUTINE OP0015(IER)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER IER
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 05/10/2004   AUTEUR REZETTE C.REZETTE 
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
C     ------------------------------------------------------------------
C     OPERA 15 :     RESOLUTION LDLT  (A DONNEES ALTEREES)
C     ------------------------------------------------------------------
C     RESOLUTION D'UN SYSTEME DE LA FORME TLDL * X = F
C     ------------------------------------------------------------------
C     LA MATRICE DOIT ETRE SYMETRIQUE ET STOCKEE "LIGN_CIEL" PAR BLOCS
C     ------------------------------------------------------------------
C
C     ----------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL ,IDENSD
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*1 FTYPE(2)
      CHARACTER*4 ETAMAT
      CHARACTER*8 XSOL,SECMBR,MATFAC,TYPE,VCINE,TYPV
      CHARACTER*16 CONCEP,NOMCMD
      CHARACTER*19 XSOL19,VCIN19,MAT19,PCHN1,PCHN2
      CHARACTER*24 VXSOL,VXCIN
      COMPLEX*16   CBID
      REAL*8       RSOL(2), RCINE(2)
C     ------------------------------------------------------------------
      DATA FTYPE/'R','C'/
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
C-----RECUPERATION DU NIVEAU D'IMPRESSION
C
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)
C----------------------------------------------------------------------
C
C     --- RECUPERATION SUR LA COMMANDE ET SON RESULAT ---
      CALL GETRES(XSOL,CONCEP,NOMCMD)
      XSOL19 = XSOL
C
C     --- RECUPERATION DES NOMS DE LA MATRICE ET DU SECOND MEMBRE ---
C     --- ET EVANTUELLEMENT D'UN CHAM_CINE                        ---
      CALL GETVID('  ','MATR_FACT',0,1,1,MATFAC,NB)
      CALL GETVID('  ','CHAM_NO',0,1,1,SECMBR,NB)


C     -- ON VERIFIE QUE LE PROF_CHNO DE LA MATR_ASSE
C        EST IDENTIQUE A CELUI DU  SECOND_MEMBRE :
C     -----------------------------------------------
       CALL DISMOI('F','PROF_CHNO',MATFAC,'MATR_ASSE',IBID,PCHN1,IBID)
       CALL DISMOI('F','PROF_CHNO',SECMBR,'CHAM_NO',IBID,PCHN2,IBID)
       IF (.NOT.IDENSD('PROF_CHNO',PCHN1,PCHN2))
     & CALL UTMESS('F','OP0015','LA NUMEROTATION '
     & //'DES INCONNUES EST INCOHERENTE ENTRE LA MATRICE ET LE SECOND'
     & //' MEMBRE.')


      CALL GETVID('  ','CHAM_CINE',0,1,1,VCINE,NBCINE)
      IF (NBCINE.NE.0) THEN
        VCIN19 = VCINE
      ELSE
        VCIN19 = ' '
      ENDIF
C
      CALL EXISD('CHAMP_GD',XSOL,IRET)
      IF (IRET.NE.0) THEN
C        --- VERIFICATION DES COMPATIBILITES --
         CALL VRREFE(SECMBR,XSOL,IRET)
         IF (IRET.NE.0) THEN
            CALL UTMESS('F','RESO_LDLT',
     +                      SECMBR//' ET '//XSOL//' N''ONT PAS LE '//
     +                  'MEME DOMAINE DE DEFINITION.')
         ENDIF
      ELSE
C        --- CREATION DU VECTEUR SOLUTION ---
         TYPE = ' '
         CALL VTDEFS(XSOL,SECMBR,'GLOBALE',TYPE)
      ENDIF
C
      IF (XSOL.NE.SECMBR) THEN
C        --- TRANSFERT DU SECOND MEMBRE DANS LE VECTEUR SOLUTION ---
         CALL VTCOPY(SECMBR,XSOL,IRET)
         IF (IRET.NE.0) CALL UTMESS('F','RESO_LDLT','STOP')
      ENDIF
C
C     --- CHARGEMENT DES DESCRIPTEURS DE LA MATRICE A FACTORISER ---
       CALL MTDSCR(MATFAC)
       CALL JEVEUO(MATFAC//'           .&INT','E', LMAT )
      IF (LMAT.EQ.0) THEN
         CALL UTMESS('F','RESO_LDLT',
     +                   'PROBLEMES A L''ALLOCATION DES DESCRIPTEURS '//
     +               'DE LA MATRICE "'//MATFAC//'" ')
      ENDIF
      MAT19 = MATFAC
      CALL JELIRA(MAT19//'.REFA','DOCU',IBID,ETAMAT)
      IF (ETAMAT.NE.'DECP'.AND.ETAMAT.NE.'DECT') THEN
C
            CALL UTMESS('F','OP0015','  PAS DE RESOLUTION '//
     +       'CAR LA MATRICE '//MAT19//' N"EST PAS DECOMPOSEE.' )
      ENDIF
C
C     --------------------- RESOLUTION EFFECTIVE ----------------------
      NBSOL = 1
C
C     ---RECUPERATION DU TABLEAU DEVANT CONTENIR LA SOLUTION ---
      VXSOL = XSOL19//'.VALE'
      VXCIN = VCIN19//'.VALE'
      CALL JEVEUO(VXSOL,'E',LXSOL)
      CALL JELIRA(VXSOL,'TYPE',IBID,TYPE)
      IF (VCIN19.NE.' ') THEN
        CALL JEVEUO(VXCIN,'L',LCINE)
        CALL JELIRA(VXCIN,'TYPE',IBID,TYPV)
      ELSE
        TYPV = TYPE
      ENDIF
C
C     --- CONTROLE DES TYPES ---
      IF (FTYPE(ZI(LMAT+3)).NE.TYPE(1:1)) THEN
         CALL UTMESS('F','RESO_LDLT',
     +                   'LA MATRICE ET LE SECOND MEMBRE SONT DE '//
     +                   'TYPE DIFFERENT.')
      ELSE IF (TYPV(1:1).NE.TYPE(1:1)) THEN
         CALL UTMESS('F','RESO_LDLT',
     +                   'LE SECOND MEMBRE ET LE CHAMP CINEMATIQUE'//
     +                   'SONT DE TYPE DIFFERENT.')
      ELSE IF (TYPE(1:1).EQ.'R') THEN
         CALL CSMBGG(LMAT,ZR(LXSOL),ZR(LCINE),CBID,CBID,'R')
         CALL MRCONL(LMAT,0,' ',ZR(LXSOL),NBSOL)
         CALL MRCOND(LMAT,0,ZR(LXSOL),NBSOL)
         CALL RLDLGG(LMAT,ZR(LXSOL),CBID,NBSOL)
         CALL MRCOND(LMAT,0,ZR(LXSOL),NBSOL)
      ELSE IF (TYPE(1:1).EQ.'C') THEN
         CALL CSMBGG(LMAT,RBID,RBID,ZC(LXSOL),ZC(LCINE),'C')
         CALL MCCONL(LMAT,0,' ',ZC(LXSOL),NBSOL)
         CALL MCCOND(LMAT,0,ZC(LXSOL),NBSOL)
         CALL RLDLGG(LMAT,RBID,ZC(LXSOL),NBSOL)
         CALL MCCOND(LMAT,0,ZC(LXSOL),NBSOL)
      ELSE
         CALL UTMESS('F','RESO_LDLT',
     +                   'LA MATRICE EST D''UN TYPE INCONNU '//
     +               'DE L''OPERATEUR.')
      ENDIF
C     --------------------------------------------------------------
C
      CALL TITRE
      CALL JEDEMA()
      END
