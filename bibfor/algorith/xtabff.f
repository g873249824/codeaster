      SUBROUTINE XTABFF(NBFOND,NFON,NDIM,FISS)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 01/03/2011   AUTEUR GENIAUT S.GENIAUT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT S.GENIAUT
C
      IMPLICIT NONE
      INTEGER       NDIM,NBFOND,NFON
      CHARACTER*8   FISS

C
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (PREPARATION)
C
C     CONSTRUCTION DES 2 TABLES SUR LES FONDS DE FISSURE :
C             - TABLE DES COORDONNEES DES FONDS DE FISSURE
C             - TABLE DU NOMBRE DE FONDS DE FISSURE
C
C ----------------------------------------------------------------------
C
C
C I/O FISS   : NOM DE LA FISSURE
C IN  NBFOND : NOMBRE DE FONDS DE FISSURES DETECTES
C IN  NFON   : NOMBRE DE POINTS DE FOND DE FISSURE
C IN  NDIM   : DIMENSION DE L'ESPACE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32  JEXATR,JEXNUM
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER       IFM,NIV,IRET,I
      INTEGER       NPARA,NFONL,NFONDL,VALI(2)
      INTEGER       JMULT,JFON
      REAL*8        VALE(4),R8BID
      CHARACTER*1   TYPAR2(3),TYPAR3(6)
      CHARACTER*8   K8BID
      CHARACTER*12  K12, NOPAR2(3),NOPAR3(6)
      CHARACTER*19  TABCOO,TABNB
      COMPLEX*16    C16B
      DATA NOPAR2 /'NUME_FOND','COOR_X','COOR_Y'/
      DATA TYPAR2 /'I'        ,'R'     ,'R'/
      DATA NOPAR3 /'NUME_FOND','NUM_PT','ABSC_CURV',
     &                                       'COOR_X','COOR_Y','COOR_Z'/
      DATA TYPAR3 /'I'        ,'I'    ,'R'     ,'R',       'R'     ,'R'/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('XFEM',IFM,NIV)

C     S'IL N'Y A PAS DE FOND DE FISSURE ON SORT
      IF (NBFOND.EQ.0) GOTO 999

      CALL JEVEUO( FISS//'.FONDMULT', 'L', JMULT)
      CALL JEVEUO( FISS//'.FONDFISS', 'L', JFON)

      CALL LTCRSD ( FISS , 'G' )

C     ------------------------------------------------------------------
C     CONSTRUCTION DE LA TABLE DES COORDONNEES DES FONDS DE FISSURE
C     ------------------------------------------------------------------

      CALL LTNOTB ( FISS , 'FOND_FISS' , TABCOO )
      CALL TBCRSD ( TABCOO,'G')

      IF (NDIM.EQ.2) THEN
        NPARA = 3
        CALL TBAJPA ( TABCOO, NPARA, NOPAR2, TYPAR2 )
        DO 100 I = 1,NBFOND
          VALI(1)=I
          VALE(1)=ZR(JFON-1+4*(I-1)+1)
          VALE(2)=ZR(JFON-1+4*(I-1)+2)
          CALL TBAJLI(TABCOO,NPARA,NOPAR2,VALI,VALE,C16B,K8BID,0)
 100    CONTINUE
      ELSEIF (NDIM.EQ.3) THEN
        NPARA = 6
        CALL TBAJPA ( TABCOO, NPARA, NOPAR3, TYPAR3 )
        NFONL = 1
        NFONDL = 0
        DO 200 I = 1,NFON
          IF (ZI(JMULT-1+2*NFONDL+1).EQ.I) THEN
            NFONDL = NFONDL + 1
           NFONL = 1
          ELSE
            NFONL = NFONL + 1
          ENDIF            
          VALI(1)=NFONDL
          VALI(2)=NFONL
          VALE(1)=ZR(JFON-1+4*(I-1)+4)
          VALE(2)=ZR(JFON-1+4*(I-1)+1)
          VALE(3)=ZR(JFON-1+4*(I-1)+2)
          VALE(4)=ZR(JFON-1+4*(I-1)+3)
          CALL TBAJLI (TABCOO,NPARA,NOPAR3,VALI,VALE,C16B,K8BID,0)
 200    CONTINUE
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C     ------------------------------------------------------------------
C     CONSTRUCTION DE LA TABLE DU NOMBRE DE FONDS DE FISSURE
C     ------------------------------------------------------------------
C
      CALL LTNOTB ( FISS , 'NB_FOND_FISS' , TABNB )
      CALL TBCRSD ( TABNB,'G')
      CALL TBAJPA ( TABNB, 1, 'NOMBRE', 'I' )
      CALL TBAJLI ( TABNB, 1, 'NOMBRE',NBFOND, R8BID, C16B, K8BID, 0 )

 999  CONTINUE
      CALL JEDEMA()
      END
