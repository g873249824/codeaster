      SUBROUTINE DIMECO(CHAR,NOMA,NDIM,NZOCO,NSUCO,NMACO,NNOCO,
     &                  NMANO,NNOMA,NMAMA)     
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 07/10/2004   AUTEUR MABBAS M.ABBAS 
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
      CHARACTER*8  CHAR
      CHARACTER*8  NOMA
      INTEGER      NDIM
      INTEGER      NZOCO
      INTEGER      NSUCO
      INTEGER      NMACO
      INTEGER      NNOCO
      INTEGER      NMANO
      INTEGER      NNOMA
      INTEGER      NMAMA
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : CALICO
C ----------------------------------------------------------------------
C
C CONSTRUCTION DU TABLEAU CONTENANT LES LONGUEURS DES DIFFERENTS 
C VECTEURS 
C ET LE NOMBRE DE NOEUDS ESCLAVES MAXIMUM POUR CHAQUE ZONE.
C CALCUL DU NOMBRE MAXIMAL DE NOEUDS ESCLAVES DANS CHAQUE ZONE.
C DIMENSIONNEMENT DES TABLEAUX CONTENANT LES INFORMATIONS 
C POUR METHODES "PENALISATION" ET "LAGRANGIEN" 
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  NOMA   : NOM DU MAILLAGE
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NZOCO  : NOMBRE DE ZONES DE CONTACT
C IN  NSUCO  : NOMBRE TOTAL DE SURFACES DE CONTACT
C IN  NMACO  : NOMBRE TOTAL DE MAILLES DES SURFACES
C IN  NNOCO  : NOMBRE TOTAL DE NOEUDS DES SURFACES
C IN  NMANO  : DIMENSION DU TABLEAU INVERSE NOEUDS->MAILLES
C IN  NNOMA  : DIMENSION DU TABLEAU DIRECT MAILLES->NOEUDS
C IN  NMAMA  : DIMENSION DU TABLEAU DONNANT POUR CHAQUE MAILLE DE 
C              CONTACT LA LISTE
C              DES MAILLES DE CONTACT DE LA MEME SURFACE ADJACENTES
C              (ON STOCKE LA POSITION DANS CONTMA, PAS LE NUMERO ABSOLU)
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX ----------------
C
      CHARACTER*24 NDIMCO,PSURNO,PZONE,FROTE,PENAL,COMAFO
      INTEGER      JDIM,JSUNO,JZONE,IFRO,IPENA,ICOMA
      CHARACTER*24 ECPDON,DEFICO,NOESCL
      INTEGER      JECPD,JNOESC
      INTEGER      NESMAX,NESM,NSURF
      INTEGER      IOC,I1,I2
      INTEGER      NBNO1,NBNO2

C ======================================================================
C --- INITIALISATION ---------------------------------------------------
C ======================================================================
      CALL JEMARQ()

C ----------------------------------------------------------------------

      NDIMCO = CHAR(1:8)//'.CONTACT.NDIMCO'
      PSURNO = CHAR(1:8)//'.CONTACT.PSUNOCO'
      PZONE  = CHAR(1:8)//'.CONTACT.PZONECO'
      ECPDON = CHAR(1:8)//'.CONTACT.ECPDON'     
      DEFICO = CHAR(1:8)//'.CONTACT' 
      NOESCL = CHAR(1:8)//'.CONTACT.NOESCL'

      CALL WKVECT(NDIMCO,'G V I',9+NZOCO,JDIM)
      CALL JEVEUO(PZONE,'L',JZONE)
      CALL JEVEUO(PSURNO,'L',JSUNO)
      CALL JEVEUO(ECPDON,'L',JECPD)
      
C ======================================================================
C --- TABLEAU CONTENANT LES LONGUEURS DES DIFFERENTS VECTEURS ----------
C --- ET LE NOMBRE DE NOEUDS ESCLAVES MAXIMUM POUR CHAQUE ZONE ---------
C ======================================================================

      ZI(JDIM)   = NDIM
      ZI(JDIM+1) = NZOCO
      ZI(JDIM+2) = NSUCO
      ZI(JDIM+3) = NMACO
      ZI(JDIM+4) = NNOCO
      ZI(JDIM+5) = NMANO
      ZI(JDIM+6) = NNOMA
      ZI(JDIM+7) = NMAMA

C ======================================================================
C --- CALCUL DU NOMBRE MAXIMAL DE NOEUDS ESCLAVES DANS CHAQUE ZONE -----
C --- ON COMPTE LES NOEUDS DE LA 2E SURFACE POUR APPARIEMENT 'NON', ----
C --- 'NODAL' ET 'MAIT_ESCL' -------------------------------------------
C --- LE MAX DES NOEUDS DES 1ERE ET 2EME SURFACE POUR 'MAIT_ESCL_SYME'--
C --- TOUS LES NOEUDS DES DIFFERENTES SURFACES POUR 'TERRITOIRE'--------
C --- ET 'HIERARCHIQUE'-------------------------------------------------
C ======================================================================
      NESMAX = 0
      DO 20 IOC = 1,NZOCO
        NESM = 0
        I1 = ZI(JZONE+IOC-1) + 1
        I2 = ZI(JZONE+IOC)
        NSURF = I2 - I1 + 1
        IF (NSURF.EQ.2) THEN
          NBNO1  = ZI(JSUNO+I1) - ZI(JSUNO+I1-1)
          NBNO2  = ZI(JSUNO+I2) - ZI(JSUNO+I2-1)
          NESM   = NESM + NBNO2
          NESMAX = NESMAX + NBNO2
        ELSE
          NBNO1  = ZI(JSUNO+I2) - ZI(JSUNO+I1-1)
          NESM   = NESM + NBNO1
          NESMAX = NESMAX + NBNO1
        END IF
        ZI(JDIM+8+IOC) = NESM
   20 CONTINUE
C ======================================================================
      ZI(JDIM+8) = NESMAX
C ======================================================================
C --- DIMENSIONNEMENT DES TABLEAUX CONTENANT LES INFORMATIONS 
C --- POUR METHODES "PENALISATION" ET "LAGRANGIEN" 
C ======================================================================

      FROTE  = CHAR(1:8)//'.CONTACT.FROTE'
      PENAL  = CHAR(1:8)//'.CONTACT.PENAL'
      COMAFO = CHAR(1:8)//'.CONTACT.COMAFO'
      CALL WKVECT(FROTE,'G V R',NESMAX,IFRO)
      CALL WKVECT(PENAL,'G V R',2*NESMAX,IPENA)
      CALL WKVECT(COMAFO,'G V R',NESMAX,ICOMA)
C ======================================================================
C --- DIMENSIONNEMENT DES TABLEAUX CONTENANT LES INFORMATIONS 
C --- POUR METHODE "CONTINUE" 
C ======================================================================
      IF (ZI(JECPD).EQ.1) THEN     
        CALL WKVECT(NOESCL,'G V R',10*NNOCO+1,JNOESC)
        ZR(JNOESC) = NNOCO

        DO 30 IOC = 1,NNOCO
          ZR(JNOESC+10* (IOC-1)+1) = 0.D0
   30   CONTINUE
        CALL MMACON(NOMA,DEFICO)
      END IF

C ======================================================================
      CALL JEDEMA()
      END
