       SUBROUTINE CMQLMA(MAIN,MAOUT,NBMA,MAILQ)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 14/09/2010   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
       IMPLICIT NONE
       INTEGER NBMA,MAILQ(NBMA)
       CHARACTER*8 MAIN,MAOUT
C
C-----------------------------------------------------------------------
C    - COMMANDE :  CREA_MAILLAGE / QUAD_LINE
C    - BUT DE LA COMMANDE: 
C      TRANSFORMATION DES MAILLES QUADRATIQUES -> LINEAIRES
C    - BUT DE LA ROUTINE:
C      CREATION DES OBJETS .TYPMAIL .CONNEX DE LA NOUVELLE SD MAILLAGE
C    - ROUTINE APPELEE PAR : CMQLQL
C ----------------------------------------------------------------------
C IN        MAIN    K8   NOM DU MAILLAGE INITIAL
C IN        MAOUT   K8   NOM DU MAILLAGE FINAL
C IN        NBMA     I   NOMBRE DE MAILLES REFERENCEES
C IN        MAILS    I   NUMERO DES MAILLES REFERENCEES
C ----------------------------------------------------------------------
C
C  ======           ==============         ======================== 
C  MAILLE           TYPE APRES LIN         NBRE DE NOEUDS APRES LIN
C  ======           ==============         ========================
C                         
C
C  SEG3                      2                       2
C  TRIA6                     7                       3
C  QUAD8                    12                       4
C  QUAD9                    12                       4
C  TETRA10                  18                       4
C  PENTA15                  20                       6
C  PENTA18                  20                       6
C  PYRAM13                  23                       5
C  HEXA20                   25                       8
C  HEXA27                   25                       8
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNUM,JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER NBTYMA
      PARAMETER(NBTYMA=27)
      INTEGER JDIM,I,NBTMA,JMA,JTYPM1,JTYPM2,JCONN1,JCONN2,
     &     TYMAL(NBTYMA),JNOMM,NUM1,NUM2,NBNOL(NBTYMA),JNOMTM,
     &     ITYP,J,INOM,JJ,NBNOMX,IRET,NDIM,IJ,K
      CHARACTER*1 KBID
      CHARACTER*8 NOM,NOMMA,NOMNOI
      CHARACTER*24 CONNEX,TYPMA
C     
C     TYMAL: TYPE DES MAILLES APRES LINEARISATION (CF. CI-DESSUS)
C     NBNOL: NOMBRE DE NOEUDS APRES LINEARISATION (CF. CI-DESSUS)
      DATA TYMAL   /3*0,2,4*0,7,4*0,12,0,12,2*0,18,0,20,20,0,23,0,25,25/
      DATA NBNOL   /3*0,2,4*0,3,4*0,4 ,0,4 ,2*0,4 ,0,6 ,6, 0,5 ,0,8, 8/
      
      CALL JEMARQ()
C
      CONNEX = MAOUT // '.CONNEX'
      TYPMA= MAOUT // '.TYPMAIL'
C
C     CREATION D'UN TABLEAU DIMENSIONNE AU NOMBRE DE MAILLES DU
C     MAILLAGE INITIAL PERMETTANT DE SAVOIR SI LA MAILLE EN COURS
C     SERA LINEAIRE OU NON.
C     -----------------------------------------------------------
      CALL JEVEUO(MAIN//'.DIME','L',JDIM)
      NBTMA=ZI(JDIM+2)
      CALL WKVECT('&&CMQLMA.MAILLE','V V I',NBTMA,JMA)
      DO 10 I=1,NBTMA
         ZI(JMA+I-1)=0
 10   CONTINUE
      DO 20 I=1,NBMA
         ZI(JMA+MAILQ(I)-1)=1
 20   CONTINUE
C
C     CREATION DES OBJETS  '.TYPMAIL', '.CONNEX':
C     -------------------------------------------

      CALL DISMOI('F','NB_NO_MAX','&CATA','CATALOGUE',NBNOMX,KBID,IRET)
      CALL JECREC(MAOUT//'.CONNEX','G V I','NU','CONTIG','VARIABLE',
     &     ZI(JDIM+2))
      NDIM=NBNOMX*ZI(JDIM+2)
      CALL JEECRA(MAOUT//'.CONNEX','LONT',NDIM,KBID)
      CALL JEVEUO(MAIN//'.TYPMAIL','L',JTYPM1)
      CALL JEVEUO(TYPMA,'E',JTYPM2)
      CALL JEVEUO('&CATA.TM.NBNO','L',INOM)
C
C     NUM1:NOMBRE DE NOEUDS DE LA MAILLE INITIALE
C     NUM2:NOMBRE DE NOEUDS DE LA MAILLE LINEARISEE    
C
C     ON PARCOURT LES MAILLES DU MAILLAGE
      DO 30 I=1,NBTMA
         NUM1=ZI(INOM+ZI(JTYPM1+I-1)-1)
C
C        '.TYPMAIL':
C        ----------
C        SI LA MAILLE N'EST PAS A LINEARISER
         IF(ZI(JMA+I-1).EQ.0)THEN
            ZI(JTYPM2+I-1)=ZI(JTYPM1+I-1)
            NUM2=NUM1
C        SI LA MAILLE EST A LINEARISER  
         ELSE
            ITYP=ZI(JTYPM1+I-1)
            ZI(JTYPM2+I-1)=TYMAL(ITYP)
            NUM2=NBNOL(ITYP)
         ENDIF
C
C        '.CONNEX':
C        ----------
         CALL JECROC(JEXNUM(CONNEX,I))
         CALL JEECRA(JEXNUM(CONNEX,I),'LONMAX',NUM2,KBID)
         CALL JEVEUO(JEXNUM(CONNEX,I),'E',JCONN2)
         CALL JEVEUO(JEXNUM(MAIN//'.CONNEX',I),'L',JCONN1)
         DO 40 J=1,NUM2
            IJ=ZI(JCONN1+J-1)
            CALL JENUNO(JEXNUM(MAIN//'.NOMNOE',IJ),NOMNOI)
            CALL JENONU(JEXNOM(MAOUT//'.NOMNOE',NOMNOI),ZI(JCONN2+J-1))
 40      CONTINUE
 30   CONTINUE
C     
      CALL JEDETR('&&CMQLMA.MAILLE')
C     
      CALL JEDEMA()
C     
      END
