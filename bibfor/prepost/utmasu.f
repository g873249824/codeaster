      SUBROUTINE UTMASU ( MODL, MAIL, KDIM, NLIMA, LIMA, NOMOB1, PREC,
     +                    COOR )
      IMPLICIT NONE
      INTEGER             LIMA(*), NLIMA
      REAL*8              PREC, COOR(*)
      CHARACTER*2         KDIM
      CHARACTER*8         MODL, MAIL
      CHARACTER*(*)       NOMOB1
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 13/03/2006   AUTEUR CIBHHLV L.VIVAN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     DETERMINE LES MAILLES SUPPORT D'UNE LISTE DE MAILLES DE PEAU
C     MAILLE PEAU 2D => MAILLE SUPPORT 3D
C     MAILLE PEAU 1D => MAILLE SUPPORT 2D
C
C   ARGUMENT EN ENTREE
C   ------------------
C     MODL   : NOM DE L'OJB REPRESENTANT LE MODELE
C     MAIL   : NOM DE L'OJB REPRESENTANT LE MAILLAGE
C     KDIM   : '3D' RECHERCHE LES MAILLES 3D VOISINES
C              '2D' RECHERCHE LES MAILLES 2D VOISINES
C              '  ' RECHERCHE TOUTES LES MAILLES VOISINES
C     LIMA   : LISTE DES NUMEROS DE MAILLES
C     NLIMA  : NOMBRE DE MAILLES
C     BASE   : BASE DE CREATION
C     NOMOB1 : NOM DE L' OJB A CREER
C-----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32     JEXNOM, JEXNUM, JEXATR
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER       P1,P2,P3,P4, JM3D, INDIIS, NBMAT, IRET, IM1, IM2
      INTEGER       IMA, NUMA, NNOE, INO, NBM, I, K, INDI, NNOEM, NNOE1
      INTEGER       LISNOE(27), LISMA(1000), JMODL
      CHARACTER*1   TYPERR
      CHARACTER*8   K8B, NOMAIL, NOMA1, NOMA2
      CHARACTER*24  NOMAVO
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
C --- APPEL A LA CONNECTIVITE :
C     -----------------------
      CALL JEVEUO ( JEXATR(MAIL//'.CONNEX','LONCUM'), 'L', P2 )
      CALL JEVEUO ( MAIL//'.CONNEX', 'L', P1 )
      CALL JEVEUO ( MODL//'.MAILLE', 'L', JMODL )
C
C --- RECUPERATION DES MAILLES VOISINES DU GROUP_MA :
C     ---------------------------------------------
      NOMAVO = '&&UTMASU.MAILLE_VOISINE '
      CALL UTMAVO ( MAIL, KDIM, LIMA, NLIMA, 'V', NOMAVO )
      CALL JEVEUO ( JEXATR(NOMAVO,'LONCUM'), 'L', P4 )
      CALL JEVEUO ( NOMAVO, 'L', P3 )
C
C --- CREATION DE LA SD :
C     -----------------
      CALL WKVECT ( NOMOB1, 'V V I' , NLIMA, JM3D )
C
C --- ON REMPLIT LA SD :
C     -----------------
      DO 100 IMA = 1, NLIMA
         NUMA = LIMA(IMA)
         NNOE = ZI(P2+NUMA)-ZI(P2-1+NUMA)
         DO 80 INO = 1,NNOE
            LISNOE(INO) = ZI(P1-1+ZI(P2+NUMA-1)+INO-1)
  80     CONTINUE

         NBMAT = ZI(P4+IMA+1-1) - ZI(P4+IMA-1)

         NBM = 0
         DO 10 I = 1, NBMAT
            IM2 = ZI(P3+ZI(P4+IMA-1)-1+I-1)
            NNOEM = ZI(P2+IM2) - ZI(P2-1+IM2)
            IF ( ZI(JMODL-1+IM2) .EQ. 0 ) GOTO 10
            IF ( ZI(P1+ZI(P2+IM2-1)-1) .EQ. 0 ) GOTO 10

            DO 12 K =  1 , NNOE
               INDI = INDIIS(ZI(P1+ZI(P2+IM2-1)-1),LISNOE(K),1,NNOEM)
               IF ( INDI .EQ. 0 )   GOTO 10
 12         CONTINUE
            NBM = NBM + 1
            IF ( NBM .EQ. 1 ) THEN
               ZI(JM3D+IMA-1) = IM2
            ELSE
               IM1 = ZI(JM3D+IMA-1)
               NNOE1 = ZI(P2+IM1) - ZI(P2-1+IM1)
               CALL ORIEM0 ( MAIL, COOR, ZI(P1+ZI(P2+IM1-1)-1), NNOE1,
     +                       ZI(P1+ZI(P2+IM2-1)-1), NNOEM, PREC, IRET )
               IF ( IRET .EQ. 0 ) THEN
                  TYPERR = 'A'
               ELSE
                  TYPERR = 'F'
               ENDIF
               CALL JENUNO(JEXNUM(MAIL//'.NOMMAI',NUMA),NOMAIL)
               CALL UTDEBM(TYPERR,'UTMASU','LA MAILLE DE PEAU '//
     +              NOMAIL//' S''APPUIE SUR PLUS D''UNE MAILLE '//
     +              'SUPPORT')
               CALL JENUNO(JEXNUM(MAIL//'.NOMMAI',IM1),NOMA1)
               CALL JENUNO(JEXNUM(MAIL//'.NOMMAI',IM2),NOMA2)
               CALL UTIMPK('L',' MAILLE SUPPORT 1 : ',1,NOMA1)
               CALL UTIMPK('L',' MAILLE SUPPORT 2 : ',1,NOMA2)
               CALL UTFINM
            ENDIF
C
 10      CONTINUE
C
         IF ( NBM .EQ. 0 ) THEN
            CALL JENUNO(JEXNUM(MAIL//'.NOMMAI',NUMA),NOMAIL)
            CALL UTMESS('A','UTMASU','LA MAILLE DE PEAU '//
     +              NOMAIL//' NE S''APPUIE SUR AUCUNE MAILLE SUPPORT')
         ENDIF
C
 100  CONTINUE
C
      CALL JEDETR ( NOMAVO )
C
      CALL JEDEMA()
C
      END
