      SUBROUTINE MMACON(NOMA,DEFICO)
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/10/2004   AUTEUR MABBAS M.ABBAS 
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

      IMPLICIT NONE

      CHARACTER*8 NOMA
      CHARACTER*(*) DEFICO

C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : OP0070
C ----------------------------------------------------------------------

C  CREATION DE MAESCL,TABFIN CONTENANT RESPECTIVEMENT LES MAILLES
C  ESCALVES ET LES POINTS DE CONTACT. CES DEUX TABLEAUX SONT AJOUTES
C  DEFICO(1:16)
C
C  IN  NOMA   : NOM DU MAILLAGE
C  VAR DEFICO : SD POUR LA DEFINITION DE CONTACT
C  IN  RESOCO : SD POUR LA RESOLUTION DE PROBLEME DE CONTACT

C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------

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

C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
      INTEGER      ZMETH
      PARAMETER    (ZMETH=8)
      INTEGER IATYMA,JMACO,JDIM,JMAESC,JTABF,JPONO,JSUNO
      INTEGER NZOCO,NTMA,NUMA,NUTYP,IRET,JNOESC,NBNO,ISUNO
      INTEGER JSUMA,JZONE,IZONE,ISUMA,NBMA,JDECMA,TYCO,PPOSNO
      INTEGER JCMCF,IM,ITYP,NTPC,IMA,NBN,JMETH,MET,IN,JDECNO
      CHARACTER*24 CONTMA,MAESCL,PNOMA,CARACF,NDIMCO
      CHARACTER*24 TABFIN,PSURMA,PZONE,METHCO,NOESCL,PSURNO

C ----------------------------------------------------------------------

C     LE TABLEAU  MAESCL = RESOCO(1:14)//.'MAESCL' CONTIENT LES NUMEROS
C     ABSOLUS DES MAILLES ESCLAVES ( CE NUMERO EST RECUPERE DE CONTAMA)
C     ET  POUR CHAQUE MAILLE ESCLAVE LE NUMERO DE LA SA ZONE ET L'INDICE
C     DE SURFACE

      CALL JEMARQ()

C     RECUPERATION DE CONTAMA CONTNO ET APPARI

      CONTMA = DEFICO(1:16)//'.MAILCO'
      MAESCL = DEFICO(1:16)//'.MAESCL'
      PNOMA = DEFICO(1:16)//'.PNOMACO'
      TABFIN = DEFICO(1:16)//'.TABFIN'
      PSURMA = DEFICO(1:16)//'.PSUMACO'
      PSURNO = DEFICO(1:16)//'.PSUNOCO'
      PZONE = DEFICO(1:16)//'.PZONECO'
      METHCO = DEFICO(1:16)//'.METHCO'
      CARACF = DEFICO(1:16)//'.CARACF'
      NDIMCO = DEFICO(1:16)//'.NDIMCO'
      NOESCL = DEFICO(1:16)//'.NOESCL'

      CALL JEVEUO(CONTMA,'L',JMACO)
      CALL JEVEUO(NDIMCO,'L',JDIM)
      CALL JEVEUO(PNOMA,'L',JPONO)
      CALL JEVEUO(PSURMA,'L',JSUMA)
      CALL JEVEUO(PSURNO,'L',JSUNO)
      CALL JEVEUO(PZONE,'L',JZONE)
      CALL JEVEUO(CARACF,'L',JCMCF)
      CALL JEVEUO(METHCO,'L',JMETH)
      CALL JEVEUO(NOESCL,'E',JNOESC)

      NZOCO = ZI(JDIM+1)

C ======================================================================
C      REMPLISSAGE DU TABLEAU DES MAILLES ESCLAVES
C ======================================================================

C RECUPERONS D'ABORD LE NOMBRE TOTALE DES MAILLES DE CONTACT.
      MET =1
      NTMA = 0
      DO 10 IZONE = 1,NZOCO
         MET=ZI(JMETH +ZMETH*(IZONE-1)+6)
         ISUMA = ZI(JZONE+IZONE-1) + 1
         IF (MET.NE.6) GOTO 10
          NBMA = ZI(JSUMA+ISUMA) - ZI(JSUMA+ISUMA-1)
          NTMA = NTMA + NBMA

   10 CONTINUE

C  CREATION DU TABLEAU ET DESTRUCTION S'IL EXISTE

      CALL JEDETR (DEFICO(1:16)//'.MAESCL')
      CALL JEDETR (DEFICO(1:16)//'.TABFIN')
      CALL JEEXIN(DEFICO(1:16)//'.MAESCL',IRET)
      IF (IRET.GT.0) THEN
      CALL JEDETR (DEFICO(1:16)//'.MAESCL')
      END IF
      CALL WKVECT(MAESCL,'G V I',3*NTMA+1,JMAESC)
      CALL JEVEUO(MAESCL,'E',JMAESC)
      CALL JEVEUO(NOMA//'.TYPMAIL','L',IATYMA)
      NTMA = 0
      ZI(JMAESC) = 0
      DO 30 IZONE = 1,NZOCO
C  
        ISUMA = ZI(JZONE+IZONE-1) + 1
        NBMA = ZI(JSUMA+ISUMA) - ZI(JSUMA+ISUMA-1)
        JDECMA = ZI(JSUMA+ISUMA-1)
        TYCO = NINT(ZR(JCMCF+6* (IZONE-1)+1))
        DO 20 IM = 1,NBMA
          ZI(JMAESC+3*NTMA+3*IM-2) = JDECMA + IM
          ZI(JMAESC+3*NTMA+3*IM-1) = IZONE
          NUMA=ZI(JMACO-1+JDECMA + IM)
          ITYP = IATYMA - 1 + NUMA
          NUTYP = ZI(ITYP)
          IF  (TYCO.EQ.1) THEN
C NOEUDS
            IF (NUTYP.EQ.2) ZI(JMAESC+3*NTMA+3*IM) = 2
            IF (NUTYP.EQ.4) ZI(JMAESC+3*NTMA+3*IM) = 3
            IF (NUTYP.EQ.7) ZI(JMAESC+3*NTMA+3*IM) = 3
            IF (NUTYP.EQ.9) ZI(JMAESC+3*NTMA+3*IM) = 6
            IF (NUTYP.EQ.12) ZI(JMAESC+3*NTMA+3*IM) = 4
            IF (NUTYP.EQ.14) ZI(JMAESC+3*NTMA+3*IM) = 9
            IF (NUTYP.EQ.16) ZI(JMAESC+3*NTMA+3*IM) = 9
          ELSE IF (TYCO.EQ.2) THEN
C PGAUSS
            IF (NUTYP.EQ.2) ZI(JMAESC+3*NTMA+3*IM) = 2
            IF (NUTYP.EQ.4) ZI(JMAESC+3*NTMA+3*IM) = 2
            IF (NUTYP.EQ.7) ZI(JMAESC+3*NTMA+3*IM) = 3
            IF (NUTYP.EQ.9) ZI(JMAESC+3*NTMA+3*IM) = 6
            IF (NUTYP.EQ.12) ZI(JMAESC+3*NTMA+3*IM) = 4
            IF (NUTYP.EQ.14) ZI(JMAESC+3*NTMA+3*IM) = 9
            IF (NUTYP.EQ.16) ZI(JMAESC+3*NTMA+3*IM) = 9
          ELSE IF (TYCO.EQ.3) THEN
C SIMPSON
            IF (NUTYP.EQ.2) ZI(JMAESC+3*NTMA+3*IM) = 3
            IF (NUTYP.EQ.4) ZI(JMAESC+3*NTMA+3*IM) = 3
            IF (NUTYP.EQ.7) ZI(JMAESC+3*NTMA+3*IM) = 6
            IF (NUTYP.EQ.9) ZI(JMAESC+3*NTMA+3*IM) = 6
            IF (NUTYP.EQ.12) ZI(JMAESC+3*NTMA+3*IM) = 9
            IF (NUTYP.EQ.14) ZI(JMAESC+3*NTMA+3*IM) = 9
            IF (NUTYP.EQ.16) ZI(JMAESC+3*NTMA+3*IM) = 9
          ELSE IF (TYCO.EQ.4) THEN
C SIMPSON1
            IF (NUTYP.EQ.2) ZI(JMAESC+3*NTMA+3*IM) = 5
            IF (NUTYP.EQ.4) ZI(JMAESC+3*NTMA+3*IM) = 5
            IF (NUTYP.EQ.7) ZI(JMAESC+3*NTMA+3*IM) = 15
            IF (NUTYP.EQ.9) ZI(JMAESC+3*NTMA+3*IM) = 15
            IF (NUTYP.EQ.12) ZI(JMAESC+3*NTMA+3*IM) = 21
            IF (NUTYP.EQ.14) ZI(JMAESC+3*NTMA+3*IM) = 21
            IF (NUTYP.EQ.16) ZI(JMAESC+3*NTMA+3*IM) = 21
          ELSE IF (TYCO.EQ.5) THEN
C SIMPSON2
            IF (NUTYP.EQ.2) ZI(JMAESC+3*NTMA+3*IM) = 9
            IF (NUTYP.EQ.4) ZI(JMAESC+3*NTMA+3*IM) = 9
            IF (NUTYP.EQ.7) ZI(JMAESC+3*NTMA+3*IM) = 42
            IF (NUTYP.EQ.9) ZI(JMAESC+3*NTMA+3*IM) = 42
            IF (NUTYP.EQ.12) ZI(JMAESC+3*NTMA+3*IM) =65 
            IF (NUTYP.EQ.14) ZI(JMAESC+3*NTMA+3*IM) = 65
            IF (NUTYP.EQ.16) ZI(JMAESC+3*NTMA+3*IM) = 65
          ELSE
            CALL JXABOR()
          END IF
   20   CONTINUE
        NTMA = NTMA + NBMA
   30 CONTINUE
      ZI(JMAESC) = NTMA

C  ON COMPTE LE NOMBRE DES POINTS ESCLAVES POUR CREER TABFIN

      NTPC = 0
      DO 40 IMA = 1,NTMA
        NBN = ZI(JMAESC+3* (IMA-1)+3)
        NTPC = NTPC + NBN
   40 CONTINUE

C  ON MET AUX POINTS MAITRES 1 POUR FAIRE LE CALCUL DE LA NORL
       
       DO 50 IZONE = 1,NZOCO   
        ISUNO = ZI(JZONE+IZONE)
        NBNO = ZI(JSUNO+ISUNO) - ZI(JSUNO+ISUNO-1)
        JDECNO = ZI(JSUNO+ISUNO-1)
        DO  60 IN = 1,NBNO
            PPOSNO = JDECNO+IN
            ZR(JNOESC+10*(PPOSNO-1)+1)=1.D0 
60      CONTINUE  
50     CONTINUE     
       DO 70 IZONE = 1,NZOCO   
        ISUNO = ZI(JZONE+IZONE-1)+1
        NBNO = ZI(JSUNO+ISUNO) - ZI(JSUNO+ISUNO-1)
        JDECNO = ZI(JSUNO+ISUNO-1)
        DO 80 IN = 1,NBNO
            PPOSNO = JDECNO+IN
            ZR(JNOESC+10*(PPOSNO-1)+1)=-1.D0
80      CONTINUE
70     CONTINUE

C CREATION DU TABLEAU TABFIN
      CALL JEEXIN(DEFICO(1:16)//'.TABFIN',IRET)
      IF (IRET.GT.0) THEN
      CALL JEDETR (DEFICO(1:16)//'.TABFIN')
      END IF
      CALL WKVECT(TABFIN,'G V R',16*NTPC+1,JTABF)
      CALL JEDEMA()
      END
