      SUBROUTINE PACOOR(NOMMA,IMA,NBNO,COOR)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*8       NOMMA
      INTEGER                 IMA,NBNO
      REAL*8                           COOR(*)
C---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 14/01/98   AUTEUR VABHHTS J.PELLET 
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
C---------------------------------------------------------------------
C     BUT: DONNER LA LISTE DES COORDONNEES DES NBNO 1ERS NOEUDS DE LA
C          MAILLE IMA DU MAILLAGE NOMMA OU D'UN NOEUD SI NBNO = 0
C     VERIFICTION : NBNO < OU = NBRE DE NOUDS DE LA MAILLE
C ATTENTION IL FAUT QUE DIM DE COOR >= 3 MEME POUR UN NOEUD EN 2D
C---------------------------------------------------------------------
C ARGUMENTS D'ENTREE:
C IN   NOMMA  K8  : NOM DU MAILLAGE
C IN   IMA    I   : NUMERO DE LA MAILLE OU DU NOEUD SI NBNO = 0
C IN   NBNO   I   : NOMBRE DE NOEUDS DE LA MAILLE A EXTRAIRE, OU 0 POUR
C                   UN NOEUD
C OUT  COOR   R(*): COORDONNEES DES NBNO 1ERS NOEUDS DE LA MAILLE
C                   OU COORDONNEES DU NOEUD IMA
C                   POUR INO = 1,NBNO  OU INO = IMA SI NBNO = 0
C                   COOR(3*(INO-1)+1)= X1(INO)
C                   COOR(3*(INO-1)+2)= X2(INO)
C                   COOR(3*(INO-1)+3)= X3(INO) ( EN 2D 0)
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                       ZK24
      CHARACTER*32                                ZK32
      CHARACTER*80                                         ZK80
      COMMON / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32      JEXNOM, JEXNUM
C     ------- FIN COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*24 DESC,VALE ,CONNEX
      REAL*8       X(3)
      CHARACTER*8  K24BID
C --- DEBUT
      CALL JEMARQ()
      DESC = NOMMA(1:8)//'.COORDO    .DESC'
      VALE = NOMMA(1:8)//'.COORDO    .VALE'
      CONNEX = NOMMA(1:8)//'.CONNEX'
      CALL JEVEUO(DESC,'L',IDDESC)
      NBCMP = -ZI(IDDESC+1)
      IF (NBCMP.EQ.2) THEN
        IF (NBNO.GT.0) X(3) = 0.D0
        IF (NBNO.EQ.0) COOR(3) = 0.D0
      ENDIF
      CALL JEVEUO(VALE,'L',IDVALE)
      IF (NBNO.GT.0) THEN
        CALL JEVEUO(JEXNUM(CONNEX,IMA),'L',IDCONN)
        CALL JELIRA(JEXNUM(CONNEX,IMA),'LONMAX',NBNOMX,K24BID)
        IF (NBNO.GT.NBNOMX) CALL UTMESS('F','PACOOR_1','EXTRACTION DE'
     +    //' PLUS DE NOEUDS QUE N"EN CONTIENT LA MAILLE')
        DO 1 INOMA = 1,NBNO
          INO = ZI(IDCONN-1+INOMA)
          IDINO = IDVALE+ NBCMP*(INO-1)-1
          DO 2 ICMP = 1,NBCMP
            X(ICMP) = ZR(IDINO+ICMP)
2         CONTINUE
          ICOOR = 3*(INOMA-1)
          DO 3 I=1,3
            COOR(ICOOR+I) = X(I)
3         CONTINUE
1       CONTINUE
      ELSE IF (NBNO.EQ.0) THEN
        IDINO = IDVALE+ NBCMP*(IMA-1)-1
        DO 4 ICMP = 1,NBCMP
          COOR(ICMP) = ZR(IDINO+ICMP)
4       CONTINUE
      ELSE
        CALL UTMESS('F','PACOOR_01',' NOMBRE DE NOEUDS NEGATIF')
      ENDIF
      CALL JEDEMA()
      END
