      SUBROUTINE CFALGO(NOMA,ITERAT,CONV,
     &                  DEFICO,RESOCO,
     &                  DEPPLU,DDEPLA,DEPDEL,CNCINE,
     &                  LICCVG,LREAC)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/11/2004   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      IMPLICIT     NONE
      CHARACTER*8  NOMA
      INTEGER      ITERAT
      REAL*8       CONV(*)
      CHARACTER*24 DEFICO
      CHARACTER*24 RESOCO
      CHARACTER*24 DEPPLU
      CHARACTER*24 DDEPLA
      CHARACTER*24 DEPDEL
      CHARACTER*24 CNCINE
      INTEGER      LICCVG(*)
      LOGICAL      LREAC(4)
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : NMCOFR
C ----------------------------------------------------------------------
C
C ROUTINE D'AIGUILLAGE POUR LA RESOLUTION DU CONTACT
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  ITERAT : ITERATION DE NEWTON
C IN  CONV   : INFORMATIONS SUR LA CONVERGENCE DU CALCUL
C                     1 - RESI_DUAL_ABSO      (LAGRANGIEN AUGMENTE)
C                     2 - RESI_PRIM_ABSO      (LAGRANGIEN AUGMENTE)
C                     3 - NOMBRE D'ITERATIONS DUAL (LAGRANGIEN AUGMENTE)
C                     4 - NUMERO ITERATION BFGS (LAGRANGIEN AUGMENTE)
C                    10 - NOMBRE D'ITERATIONS (RECHERCHE LINEAIRE)
C                    11 - RHO                 (RECHERCHE LINEAIRE)
C                    20 - RESI_GLOB_RELA
C                    21 - RESI_GLOB_MAXI
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  DEPPLU : CHAMP DE DEPLACEMENTS A L'ITERATION DE NEWTON PRECEDENTE
C IN  DDEPLA : INCREMENT DE DEPLACEMENTS CALCULE EN IGNORANT LE CONTACT
C IN  DEPDEL : INCREMENT DE DEPLACEMENT CUMULE
C IN  CNCINE : CHAM_NO CINEMATIQUE
C OUT LICCVG : CODES RETOURS D'ERREUR
C                       (1) PILOTAGE
C                       (2) LOI DE COMPORTEMENT
C                       (3) CONTACT/FROTTEMENT: NOMBRE MAXI D'ITERATIONS
C                       (4) CONTACT/FROTTEMENT: MATRICE SINGULIERE
C OUT LREAC  : ETAT DU CONTACT 
C              (1) = TRUE  SI REACTUALISATION A FAIRE  
C              (2) = TRUE  SI ATTENTE POINT FIXE CONTACT
C              (3) = TRUE  SI METHODE CONTINUE
C              (4) = TRUE  SI MODELISATION DU CONTACT
C
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
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
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      ZMETH
      PARAMETER    (ZMETH=8)
      CHARACTER*19 MATR,MATASS
      INTEGER      LDSCON,LMAT
      CHARACTER*24 METHCO,APPARI
      INTEGER      JMETH,NEQ
      INTEGER      IFM,NIV,ICONTA,IZONE,IMETH
C
C ----------------------------------------------------------------------
C
      CALL INFNIV (IFM,NIV)
      CALL JEMARQ ()
C
C --- METHODE DE CONTACT 
C
      METHCO = DEFICO(1:16)//'.METHCO'
      CALL JEVEUO (METHCO,'L',JMETH)
C
C --- INITIALISATION DES VARIABLES DE CONVERGENCE DU CONTACT
C
      LICCVG(3) = 0
      LICCVG(4) = 0
C
C --- RECUPERATION DU DESCRIPTEUR DE LA MATRICE DE CONTACT
C
      MATR = RESOCO(1:14)//'.MATR'
      CALL MTDSCR ( MATR )
      CALL JEVEUO ( MATR(1:19)//'.&INT', 'E', LDSCON )
C
C --- RECUPERATION DU DESCRIPTEUR DE LA MATRICE MECANIQUE
C     
      CALL NMMAFR(ITERAT,RESOCO(1:14),DEFICO,MATASS)
      CALL JEVEUO ( MATASS//'.&INT', 'E', LMAT )
C 
C --- INITIALISATION POUR LA DETERMINATION DE POINTS FIXE
C 
      LREAC(2) = .FALSE.
C 
C --- ARRET OU NON SI MATRICE DE CONTACT SINGULIERE
C   
      IF (NIV.GE.2) THEN
         WRITE (IFM,*) '<CONTACT> ALGORITHME DE RECHERCHE DE CONTACT' 
      ENDIF
C
C --- LE CONTACT DOIT-IL ETRE MODELISE ?
C 
      APPARI = RESOCO(1:14)//'.APPARI'
      CALL JEEXIN(APPARI,ICONTA)
      IF (ICONTA.EQ.0) THEN 
        GO TO 999
      ENDIF
C
C --- PRE-TRAITEMENT DES CONDITIONS UNILATERALES AUTRES QUE DEPLACEMENT
C
      IF (LREAC(1).OR.ITERAT.EQ.0)  THEN
        NEQ = ZI(LMAT+2)
        CALL CFTHMP(NEQ,RESOCO,DEPPLU)
      ENDIF
C
C --- CHOIX DE L'ALGO DE CONTACT/FROTTEMENT
C 
      IZONE = 1
      IMETH = ZI(JMETH+ZMETH*(IZONE-1)+6)

      IF (IMETH.EQ.-1) THEN
         CALL ALGOCP(DEFICO,RESOCO,LMAT,LDSCON,NOMA,DDEPLA,
     &               DEPPLU,LREAC,DEPDEL)    
      ELSE IF (IMETH.EQ.0) THEN
         CALL ALGOCO(DEFICO,RESOCO,LMAT,LDSCON,NOMA,CNCINE,DDEPLA,
     &               DEPPLU,LICCVG)
      ELSE IF (IMETH.EQ.1) THEN
         CALL ALGOCL(DEFICO,RESOCO,LMAT,LDSCON,NOMA,CNCINE,
     &        DEPPLU,ITERAT,LREAC,DDEPLA,LICCVG)
      ELSE IF (IMETH.EQ.2) THEN
         CALL FRO2GD(DEFICO,RESOCO,LMAT,LDSCON,NOMA,CNCINE,
     &               DEPPLU,ITERAT,LREAC,DEPDEL,DDEPLA,LICCVG)
      ELSE IF (IMETH.EQ.3) THEN
         CALL FROPGD(DEFICO,RESOCO,LMAT,LDSCON,NOMA,CNCINE,DDEPLA,
     &               DEPPLU,ITERAT,LREAC,CONV,DEPDEL,LICCVG)
      ELSE IF (IMETH.EQ.4) THEN
         CALL FROLGD(DEFICO,RESOCO,LMAT,LDSCON,NOMA,CNCINE,DDEPLA,
     &               DEPPLU,ITERAT,LREAC,CONV,DEPDEL,LICCVG)
      ELSE IF (IMETH.EQ.5) THEN
         CALL FROGDP(DEFICO,RESOCO,LMAT,LDSCON,NOMA,DDEPLA,
     &               DEPPLU,ITERAT,LREAC,CONV,DEPDEL)
      ENDIF

      CALL JEDEMA()

  999 CONTINUE
      END
