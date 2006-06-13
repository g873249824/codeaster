      SUBROUTINE ACYELT(NMCOLZ,NOMOBZ,NOB,CMAT,NDIM,IDEB,JDEB,X)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/11/1999   AUTEUR SABJLMA P.LATRUBESSE 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
C***********************************************************************
C    P. RICHARD     DATE 10/04/91
C-----------------------------------------------------------------------
C  BUT:  ASSEMBLER SI ELLE EXISTE LA SOUS-MATRICE  CORRESPONDANT
C  A UN NOM OBJET DE COLLECTION DANS UNE MATRICE COMPLEXE AVEC
C   UN ASSEMBLAGE EN UN TEMPS (ADAPTE AU CYCLIQUE)
C   LA SOUS-MATRICE EST SYMETRIQUE ET SE SITUE A CHEVAL SUR LA DIAGONALE
C   ELLE EST ELLE-MEME STOCKEE TRIANGULAIRE SUPERIEURE
C
C-----------------------------------------------------------------------
C
C NMCOLZ   /I/: NOM K24 DE LA COLLECTION
C NOMOBZ   /I/: NOM K8 DE L'OBJET DE COLLECTION
C NOB     /I/: NOMBRE DE LIGNE ET COLONNES DE LA MATRICE ELEMENTAIRE
C CMAT     /M/: MATRICE RECEPTRICE COMPLEXE
C NDIM     /I/: DIMENSION DE LA MATRICE RECEPTRICE CARREE
C IDEB     /I/: INDICE DE PREMIERE LIGNE RECEPTRICE
C JDEB     /I/: INDICE DE PREMIERE COLONNE RECEPTRICE
C X        /I/: COEFFICIENT ASSEMBLAGE
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
      CHARACTER*32 JEXNOM ,JEXNUM
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      CHARACTER*8 NOMOB
      CHARACTER*24 NOMCOL
      COMPLEX*16   CMAT(*)
      CHARACTER*(*) NMCOLZ, NOMOBZ
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      NOMOB = NOMOBZ
      NOMCOL = NMCOLZ
C
      CALL JENONU(JEXNOM(NOMCOL(1:15)//'.REPE.MAT',NOMOB),IRET)
      IF (IRET.EQ.0) GOTO 9999
C
        CALL JENONU(JEXNOM(NOMCOL(1:15)//'.REPE.MAT',NOMOB),IBID)
        CALL JEVEUO(JEXNUM(NOMCOL,IBID),'L',LLOB)
C
      IAD = LLOB - 1
      DO 30 J = 1,NOB
      DO 30 I = J,1,-1
         IAD = IAD + 1
         CALL AMPCPR(CMAT,NDIM,NDIM,ZR(IAD),1,1,IDEB-1+I,JDEB-1+J,X,1,1)
 30   CONTINUE
C
C
 9999 CONTINUE
      CALL JEDEMA()
      END
