      SUBROUTINE CFELSN(IZONE,NOMA,NUMNOE,POSNOE,
     &                  JAPMEM,JNOCO,JPSANS,JSANS,
     &                  SUPPOK)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/05/2005   AUTEUR MABBAS M.ABBAS 
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
      INTEGER      IZONE
      CHARACTER*8  NOMA
      INTEGER      NUMNOE
      INTEGER      POSNOE
      INTEGER      JAPMEM
      INTEGER      JNOCO
      INTEGER      JPSANS
      INTEGER      JSANS
      INTEGER      SUPPOK
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : RECHMN
C ----------------------------------------------------------------------
C
C VERIFIE ET EXCLU DE LA LISTE DES NOEUDS ESCLAVES LES NOEUDS DECLARES
C AVEC LE MOT-CLEF 'SANS_NOEUD' OU 'SANS_GROUP_NO'
C EXCLUE EGALEMENT LE NOEUD MAITRE D'UN APPARIEMENT EVENTUEL DANS LE CAS
C SYMETRIQUE
C
C IN  IZONE  : NUMERO DE LA ZONE COURANTE
C IN  NOMA   : NOM DU MAILLAGE
C IN  NUMNOE : NUMERO ABSOLU DU NOEUD ESCLAVE
C IN  POSNOE : POSITION DU NOEUD ESCLAVE DANS CONTNO
C IN  JAPMEM : POINTEUR VERS RESOCO(1:14)//'.APMEMO' 
C IN  JNOCO  : POINTEUR VERS DEFICO(1:16)//'.NOEUCO'
C IN  JPSANS : POINTEUR VERS DEFICO(1:16)//'.PSANS'
C IN  JSANS  : POINTEUR VERS DEFICO(1:16)//'.SANSNO'
C OUT SUPPOK : ON A SUPPRIME LE NOEUD ESCLAVE ( =1)
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

C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
      INTEGER      K
      INTEGER      TYPSUP,POSSUP
      INTEGER      NSANS,NUMSAN,JDEC
C ----------------------------------------------------------------------
      CALL JEMARQ()
C

      SUPPOK = 0


      NSANS = ZI(JPSANS+IZONE) - ZI(JPSANS+IZONE-1)
      JDEC  = ZI(JPSANS+IZONE-1)
      DO 10 K = 1,NSANS
C
C --- NUMERO ABSOLU DU NOEUD SANS_GROUP_NO
C
        NUMSAN = ZI(JSANS+JDEC+K-1)
        IF (NUMNOE.EQ.NUMSAN) THEN
          TYPSUP = -1
          POSSUP = POSNOE
          CALL CFSUPM(NOMA,JNOCO,JAPMEM,POSSUP,TYPSUP)
          SUPPOK = 1
          GO TO 999
        END IF
  10  CONTINUE
 
 999  CONTINUE

C
C ----------------------------------------------------------------------
C
      CALL JEDEMA()

      END
