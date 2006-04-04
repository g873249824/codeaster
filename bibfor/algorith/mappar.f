      SUBROUTINE MAPPAR(PREMIE,NOMA,DEFICO,OLDGEO,NEWGEO,COMGEO,DEPGEO)
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/04/2006   AUTEUR KHAM M.KHAM 
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
      IMPLICIT NONE
      LOGICAL PREMIE
      INTEGER COMGEO
      CHARACTER*8 NOMA
      CHARACTER*24 DEFICO,NEWGEO,OLDGEO,DEPGEO
C
C ---------------------------------------------------------------------
C ROUTINE APPELEE PAR : OP0070
C ---------------------------------------------------------------------
C STOCKAGE DES POINTS  DE CONTACT DES SURFACES  ESCLAVES ET APPARIEMENT.
C
C IN  NOMA   : NOM DU MAILLAGE
C
C VAR DEFICO : SD POUR LA DEFINITION DE CONTACT
C VAR LISTNO : SD POUR LA RESOLUTION DE PROBLEME DE CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8,ALIAS
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER JMACO,JMAESC,JTABF,JNOCO,JSANS,JPSANS,JDIM,JNOMA,JPONO
      INTEGER JTGDEF,POSNO1,POSNO2,INI3,NDIM
      INTEGER N1,N2,INI1,INI2,J,IDTYMA,NUTYMA,TYPEL,JCOOR,JDES,INO
      INTEGER NTMA,POSNO,POSMIN,JDIR,NPEX,POSNOE,NUMNOE,SUPPOK,NSANS
      INTEGER IZONE,TYCO,JECPD,JNORLI,ITYP,NUTYP,NUMSAN,JDEC0,JDEC,K
      INTEGER JCMCF,NTPC,IMA,POSMA,NUMAE,NBN,INI,NUMAM,LISSS,IATYMA
      INTEGER JMETH,JPOUDI,JTOLE,ZMETH,ZTOLE
      REAL*8 XIMIN,YIMIN,T1MIN(3),T2MIN(3),GEOM(3),LAMBDA,XPG,YPG,HPG
      REAL*8 DIR(3),NDIR,NORM(3),COON1(3),COON2(3),NORME1,TOL
      CHARACTER*24 COTAMA,MAESCL,CARACF,ECPDON,NORLIS,DIRCO,CONTNO
      CHARACTER*24 TABFIN,SANSNO,PSANS,NDIMCO,NOMACO,PNOMA,TANDEF,METHCO
      CHARACTER*24 TANPOU,TOLECO
      INTEGER NNEX,INI4
      LOGICAL LDIST,CONDI
      PARAMETER (ZMETH=8,ZTOLE=6)
C
C ----------------------------------------------------------------------
C
C     LE TABLEAU  MAESCL = DEFICO(1:16)//.'MAESCL' CONTIENT LES NUMEROS
C     ABSOLUS DES MAILLES ESCLAVES ( CE NUMERO EST RECUPERE DE CONTAMA)
C     ET POUR CHAQUE MAILLE ESCLAVE LE NUMERO DE LA SA ZONE ET
C     L'INDICE DE SURFACE
C
      CALL JEMARQ
C     REACTUALISATION DE LA GEOMETRIE
      CALL VTGPLD(OLDGEO,1.D0,DEPGEO,'V',NEWGEO)
C     RECUPERATION DE QUELQUES DONNEES      
      COTAMA = DEFICO(1:16) // '.MAILCO'
      MAESCL = DEFICO(1:16) // '.MAESCL'
      TABFIN = DEFICO(1:16) // '.TABFIN'
      CARACF = DEFICO(1:16) // '.CARACF'
      ECPDON = DEFICO(1:16) // '.ECPDON'
      NORLIS = DEFICO(1:16) // '.NORLIS'
      DIRCO  = DEFICO(1:16) // '.DIRCO'
      CONTNO = DEFICO(1:16) // '.NOEUCO'
      SANSNO = DEFICO(1:16) // '.SSNOCO'
      PSANS  = DEFICO(1:16) // '.PSSNOCO'
      NDIMCO = DEFICO(1:16) // '.NDIMCO'
      NOMACO = DEFICO(1:16) // '.NOMACO'
      PNOMA  = DEFICO(1:16) // '.PNOMACO'
      TANDEF = DEFICO(1:16) // '.TANDEF'
      METHCO = DEFICO(1:16) // '.METHCO'
      TANPOU = DEFICO(1:16) // '.TANPOU'
      TOLECO = DEFICO(1:16) // '.TOLECO'
      
      CALL JEVEUO(COTAMA,'L',JMACO)
      CALL JEVEUO(MAESCL,'L',JMAESC)
      CALL JEVEUO(TABFIN,'E',JTABF)
      CALL JEVEUO(CARACF,'L',JCMCF)
      CALL JEVEUO(ECPDON,'L',JECPD)
      CALL JEVEUO(NORLIS,'L',JNORLI)
      CALL JEVEUO(DIRCO,'L',JDIR)
      CALL JEVEUO(NOMA//'.TYPMAIL','L',IATYMA)
      CALL JEVEUO(CONTNO,'L',JNOCO)
      CALL JEVEUO(SANSNO,'L',JSANS)
      CALL JEVEUO(PSANS,'L',JPSANS)
      CALL JEVEUO(NDIMCO,'E',JDIM)
      CALL JEVEUO(NOMACO,'L',JNOMA)
      CALL JEVEUO(PNOMA,'L',JPONO)
      CALL JEVEUO(TANDEF,'L',JTGDEF)
      CALL JEVEUO(METHCO,'L',JMETH)
      CALL JEVEUO(TOLECO,'L',JTOLE)

C=======================================================================
C APPARIEMENT
C  METHODE : RECHERCHE DU NOEUD LE PLUS PROCHE ENSUITE PROJECTION
C     SUR  LES MAILLES QUI L'ENTOURANT
C=======================================================================

C   CALCUL DES NORMALES 
      CALL LISSAG(NOMA,DEFICO,NEWGEO)

C   BOUCLE SUR LES POINTS DE CONTACT

      LAMBDA = -1.0D+6
      NTMA = ZI(JMAESC)
      NTPC = 0
      NDIM = ZI(JDIM)
      DO 20 IMA = 1,NTMA
        POSMA = ZI(JMAESC+3*(IMA-1)+1)
        NUMAE = ZI(JMACO+POSMA-1)
        IZONE = ZI(JMAESC+3*(IMA-1)+2)
        NBN = ZI(JMAESC+3*(IMA-1)+3)
        TYCO = NINT(ZR(JCMCF+10*(IZONE-1)+1))
        LISSS = ZI(JNORLI+IZONE-1+1)
        LAMBDA = -ABS(ZR(JCMCF+10*(IZONE-1)+6))
        DIR(1) = ZR(JDIR+3*(IZONE-1))
        DIR(2) = ZR(JDIR+3*(IZONE-1)+1)
        DIR(3) = ZR(JDIR+3*(IZONE-1)+2)
        NDIR = SQRT(DIR(1)*DIR(1)+DIR(2)*DIR(2)+DIR(3)*DIR(3))
        ITYP = IATYMA - 1 + NUMAE
        NUTYP = ZI(ITYP)
        IF (NUTYP .EQ. 2) THEN
          ALIAS(1:3) = 'SG2'
        ELSEIF (NUTYP .EQ. 4) THEN
          ALIAS(1:3) = 'SG3'
        ELSEIF (NUTYP .EQ. 7) THEN
          ALIAS(1:3) = 'TR3'
        ELSEIF (NUTYP .EQ. 9) THEN
          ALIAS(1:3) = 'TR6'
        ELSEIF (NUTYP .EQ. 12) THEN
          ALIAS(1:3) = 'QU4'
        ELSEIF (NUTYP .EQ. 14) THEN
          ALIAS(1:3) = 'QU8'
        ELSEIF (NUTYP .EQ. 16) THEN
          ALIAS(1:3) = 'QU9'
        ELSE
          CALL UTMESS('F','COPCO','STOP_1')
        END IF
C ---- ON TESTE SI LA MAILLE CONTIENT UN NOEUD INTERDIT
        NPEX = 0
        INI1 = 0
        INI2 = 0
        INI3 = 0
        DO 50 INI = 1,NBN
          SUPPOK = 0
          JDEC0 = ZI(JPONO+POSMA-1)
          POSNOE = ZI(JNOMA+JDEC0+INI-1)
          NUMNOE = ZI(JNOCO+POSNOE-1)
          NSANS = ZI(JPSANS+IZONE) - ZI(JPSANS+IZONE-1)
          JDEC = ZI(JPSANS+IZONE-1)
          DO 30 K = 1,NSANS
C ---- NUMERO ABSOLU DU NOEUD DANS SANS_GROUP_NO OU SANS_NOEUD
          NUMSAN = ZI(JSANS+JDEC+K-1)
          IF (NUMNOE .EQ. NUMSAN) THEN
           SUPPOK = 1
           GOTO 40
          END IF
 30       CONTINUE 
 40       CONTINUE 
          IF (SUPPOK .EQ. 1) THEN
            NPEX = NPEX + 1
            IF (NPEX .EQ. 1) THEN
             INI1 = INI
            ELSEIF (NPEX .EQ. 2) THEN
             INI2 = INI
            ELSE
             INI3 = INI
            END IF
          END IF
 50     CONTINUE
        
        NNEX=0
        DO 10 INI = 1,NBN

          CALL GAUSS2(ALIAS,TYCO,XPG,YPG,INI,HPG)
          CALL COPCOG(NOMA,POSMA,XPG,YPG,NEWGEO,GEOM,DEFICO)

          IF (NDIR .GT. 0.D0) THEN
            CALL MRECHD(IZONE,GEOM,NEWGEO,DEFICO,POSNO,DIR)
            CALL MCHMPD(NOMA,GEOM,POSNO,NEWGEO,DEFICO,POSMIN,T1MIN,
     &                  T2MIN,XIMIN,YIMIN,DIR)
          ELSE
            CALL MRECHN(IZONE,GEOM,NEWGEO,DEFICO,POSNO)
            CONDI=.TRUE.
            TOL=ZR(JTOLE+ZTOLE*(IZONE-1))
            CALL MCHMPS(NOMA,GEOM,POSNO,NEWGEO,DEFICO,POSMIN,T1MIN,
     &                  T2MIN,XIMIN,YIMIN,CONDI,TOL)
     
            IF(.NOT. CONDI) THEN
              NNEX=NNEX+1
            ENDIF
            
          END IF
          NUMAM = ZI(JMACO+POSMIN-1)
          IF (LISSS .EQ. 1) THEN
            CALL COPNOR(NOMA,POSMIN,XIMIN,YIMIN,NEWGEO,DEFICO,T1MIN,
     &                  T2MIN)
          END IF
          ZR(JTABF+22*NTPC+22*(INI-1)+1) = NUMAE
          ZR(JTABF+22*NTPC+22*(INI-1)+2) = NUMAM
          ZR(JTABF+22*NTPC+22*(INI-1)+3) = XPG
          ZR(JTABF+22*NTPC+22*(INI-1)+4) = XIMIN
          ZR(JTABF+22*NTPC+22*(INI-1)+5) = YIMIN
C
C ---- DEFINITION BASE TANGENTE LOCALE DANS LE CAS DES POUTRES
C
          IF(ZI(JMETH+ZMETH*(IZONE-1)+2).EQ.2) THEN
            CALL JEVEUO(TANPOU,'L',JPOUDI)
            T2MIN(1) = ZR(JPOUDI+3* (IZONE-1))
            T2MIN(2) = ZR(JPOUDI+3* (IZONE-1)+1)
            T2MIN(3) = ZR(JPOUDI+3* (IZONE-1)+2)
            CALL NORMEV(T2MIN,NORME1)
          END IF
          
C
C ---- DEFINITION BASE TANGENTE LOCALE AU NOEUD A EXCLURE
C
          SUPPOK = 0
          JDEC0 = ZI(JPONO+POSMA-1)
          POSNOE = ZI(JNOMA+JDEC0+INI-1)
          NUMNOE = ZI(JNOCO+POSNOE-1)
          NSANS = ZI(JPSANS+IZONE) - ZI(JPSANS+IZONE-1)
          JDEC = ZI(JPSANS+IZONE-1)
          DO 31 K = 1,NSANS
C ---- NUMERO ABSOLU DU NOEUD DANS SANS_GROUP_NO OU SANS_NOEUD
          NUMSAN = ZI(JSANS+JDEC+K-1)
          IF (NUMNOE .EQ. NUMSAN) THEN
           SUPPOK = 1
           GOTO 41
          END IF
 31       CONTINUE 
 41       CONTINUE 

          IF (SUPPOK .EQ. 1) THEN
            IF (NPEX .EQ. 1) THEN
              IF (NDIM .EQ. 2) THEN
                T1MIN(1) = ZR(JTGDEF+6*(IZONE-1))
                T1MIN(2) = ZR(JTGDEF+6*(IZONE-1)+1)
                T1MIN(3) = ZR(JTGDEF+6*(IZONE-1)+2)
              ELSE IF (NDIM .EQ. 3) THEN
                T1MIN(1) = ZR(JTGDEF+6*(IZONE-1)+3)
                T1MIN(2) = ZR(JTGDEF+6*(IZONE-1)+4)
                T1MIN(3) = ZR(JTGDEF+6*(IZONE-1)+5)
                T2MIN(1) = ZR(JTGDEF+6*(IZONE-1))
                T2MIN(2) = ZR(JTGDEF+6*(IZONE-1)+1)
                T2MIN(3) = ZR(JTGDEF+6*(IZONE-1)+2)
              END IF
            ELSE
              CALL JEVEUO(NOMA//'.COORDO    .VALE','L',JCOOR)
              CALL PROVEC(T2MIN,T1MIN,NORM)

               IF (INI .EQ. INI1) THEN
                 N1 = NUMNOE
                 POSNO2 = ZI(JNOMA+JDEC0+INI2-1)
                 N2 = ZI(JNOCO+POSNO2-1)
                 DO 56 J = 1,3
                   COON1(J) = ZR(JCOOR+3*(N1-1)+J-1)
                   COON2(J) = ZR(JCOOR+3*(N2-1)+J-1)
 56              CONTINUE
                 CALL VDIFF(3,COON1,COON2,T2MIN)
                 CALL NORMEV(T2MIN,NORME1)
                 CALL PROVEC(T2MIN,NORM,T1MIN)
               ELSE
                 N2 = NUMNOE
                 POSNO1 = ZI(JNOMA+JDEC0+INI1-1)
                 N1 = ZI(JNOCO+POSNO1-1)
                 DO 57 J = 1,3
                   COON2(J) = ZR(JCOOR+3*(N2-1)+J-1)
                   COON1(J) = ZR(JCOOR+3*(N1-1)+J-1)
 57              CONTINUE
                 CALL VDIFF(3,COON1,COON2,T2MIN)
                 CALL NORMEV(T2MIN,NORME1)
                 CALL PROVEC(T2MIN,NORM,T1MIN)
               END IF
            END IF
          END IF

          ZR(JTABF+22*NTPC+22*(INI-1)+6) = T1MIN(1)
          ZR(JTABF+22*NTPC+22*(INI-1)+7) = T1MIN(2)
          ZR(JTABF+22*NTPC+22*(INI-1)+8) = T1MIN(3)
          ZR(JTABF+22*NTPC+22*(INI-1)+9) = T2MIN(1)
          ZR(JTABF+22*NTPC+22*(INI-1)+10) = T2MIN(2)
          ZR(JTABF+22*NTPC+22*(INI-1)+11) = T2MIN(3)
          ZR(JTABF+22*NTPC+22*(INI-1)+12) = YPG
          
          IF (PREMIE) THEN
            IF (ZI(JECPD+6*(IZONE-1)+5) .EQ. 1.D0) THEN
              ZR(JTABF+22*NTPC+22*(INI-1)+13) = 1.D0
            ELSE
              ZR(JTABF+22*NTPC+22*(INI-1)+13) = 0.D0
            END IF
          END IF
          
          IF (PREMIE) ZR(JTABF+22*NTPC+22*(INI-1)+14) = LAMBDA
          ZR(JTABF+22*NTPC+22*(INI-1)+15) = IZONE
          ZR(JTABF+22*NTPC+22*(INI-1)+16) = HPG
          IF (PREMIE) ZR(JTABF+22*NTPC+22*(INI-1)+21) = 0.D0
          IF (NINT(ZR(JCMCF+10*(IZONE-1)+7)) .EQ. 0.D0) THEN 
            ZR(JTABF+22*NTPC+22* (INI-1)+21) = 1.D0
          END IF
          
          IF (INI .EQ. NBN .AND. NNEX .EQ. NBN) THEN
            DO 11 INI4 = 1,NBN
            ZR(JTABF+22*NTPC+22*(INI4-1)+22) = 1.D0
 11         CONTINUE
          ELSE
            DO 12 INI4 = 1,NBN
            ZR(JTABF+22*NTPC+22*(INI4-1)+22) = 0.D0
 12         CONTINUE
          END IF
          
          IF (SUPPOK.EQ.1 .AND. NPEX.EQ.1) THEN
              ZR(JTABF+22*NTPC+22*(INI-1)+17) = 1.D0
              ZR(JTABF+22*NTPC+22*(INI-1)+18) = INI1
              ZR(JTABF+22*NTPC+22*(INI-1)+19) = 0.D0
              ZR(JTABF+22*NTPC+22*(INI-1)+20) = 0.D0
          ELSEIF (SUPPOK.EQ.1 .AND. NPEX.EQ.2) THEN
              ZR(JTABF+22*NTPC+22*(INI-1)+17) = 2.D0
              ZR(JTABF+22*NTPC+22*(INI-1)+18) = INI1
              ZR(JTABF+22*NTPC+22*(INI-1)+19) = INI2
              ZR(JTABF+22*NTPC+22*(INI-1)+20) = 0.D0
          ELSEIF (SUPPOK.EQ.1 .AND. NPEX.EQ.3) THEN
              ZR(JTABF+22*NTPC+22*(INI-1)+17) = 3.D0
              ZR(JTABF+22*NTPC+22*(INI-1)+18) = INI1
              ZR(JTABF+22*NTPC+22*(INI-1)+19) = INI2
              ZR(JTABF+22*NTPC+22*(INI-1)+20) = INI3
          ELSE
             ZR(JTABF+22*NTPC+22*(INI-1)+17) = 0.D0
             ZR(JTABF+22*NTPC+22*(INI-1)+18) = 0.D0
             ZR(JTABF+22*NTPC+22*(INI-1)+19) = 0.D0
             ZR(JTABF+22*NTPC+22*(INI-1)+20) = 0.D0
          END IF

 10     CONTINUE
        NTPC = NTPC + NBN

 20   CONTINUE
      ZR(JTABF-1+1) = NTPC
      CALL JEDEMA
      END
