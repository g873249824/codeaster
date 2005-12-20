      SUBROUTINE MEFGMN ( NOMA , NBGMA , LIGRMA )
      IMPLICIT REAL*8 (A-H,O-Z)
C
      CHARACTER*8         NOMA, LIGRMA(*)
      INTEGER             NBGMA
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 30/01/2002   AUTEUR VABHHTS J.TESELET 
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
C-----------------------------------------------------------------------
C     CREATION DE GROUPES DE NOEUDS A PARTIR DES GROUPES DE MAILLES
C     POUR CHAQUE TUBES DU FAISCEAU. LES GROUPES DE NOEUDS CREES ONT
C     LE MEME NOM QUE LES GROUPES DE MAILLES.
C ----------------------------------------------------------------------
C IN  : NOMA   : NOM DU MAILLAGE.
C IN  : NBGMA  : NOMBRE DE GROUPES DE MAILLES A TRAITER.
C IN  : LIGRMA : LISTE DES NOMS DES GROUPES DE MAILLES.
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
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32     JEXNUM, JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      CHARACTER*1   K1BID
      CHARACTER*8   K8B, NOMGNO, NOMGMA, KOUI
      CHARACTER*24  GRPMA, GRPNO
C DEB-------------------------------------------------------------------
C
      CALL JEMARQ ( )
      GRPMA = NOMA//'.GROUPEMA       '
C
      CALL DISMOI('F','NB_NO_MAILLA',NOMA,'MAILLAGE',NBNOTO,K8B,IERD)
      IF ( NBNOTO.EQ. 0 ) GO TO 9999
      IF ( NBGMA .EQ. 0 ) CALL UTMESS('F','MEFGMN','PAS DE GROUPES '//
     &                          ' DE NOEUDS A CREER ')
C
C
C --- TABLEAUX DE TRAVAIL
C
      CALL WKVECT('&&MEFGMN.LISTE_NO ','V V I',(NBGMA+1)*NBNOTO,IALINO)
      CALL WKVECT('&&MEFGMN.NB_NO    ','V V I', NBGMA          ,IANBNO)
C
C
C --- ON REMPLIT L'OBJET DE TRAVAIL QUI CONTIENT LES GROUP_NO
C --- A AJOUTER:
C
      DO 10 I = 1 , NBGMA
         NOMGMA = LIGRMA(I)
         CALL JEEXIN(JEXNOM(GRPMA,NOMGMA),IRET)
         IF ( IRET .EQ. 0 ) THEN
            CALL UTMESS('F','MEFGMN','GROUP_MA : '//NOMGMA//
     +                              ' INCONNU DANS LE MAILLAGE')
         ENDIF
         CALL JELIRA(JEXNOM(GRPMA,NOMGMA),'LONMAX',NBMA,K1BID)
         CALL JEVEUO(JEXNOM(GRPMA,NOMGMA),'L',IALIMA)
         CALL GMGNRE(NOMA,NBNOTO,ZI(IALINO),ZI(IALIMA),NBMA,
     &               ZI(IALINO+I*NBNOTO),ZI(IANBNO-1+I),'TOUS')
 10   CONTINUE
C
C
C --- CREATION DES GROUPES DE NOEUDS
C
C
      DO 40 I = 1 , NBGMA
         NOMGNO = LIGRMA(I)
         N1 = ZI(IANBNO-1+I)
         GRPNO='&&MEFGMN.'//NOMGNO
         CALL WKVECT(GRPNO,'V V I', N1,IGRNO)
         DO 30 J = 1,N1
            ZI(IGRNO+J-1)=ZI(IALINO+I*NBNOTO+J-1)
  30     CONTINUE
  40  CONTINUE
C
 9999 CONTINUE
C
      CALL JEDETC('V','&&MEFGMN.LISTE_NO ',1)
      CALL JEDETC('V','&&MEFGMN.NB_NO    ',1)
      CALL JEDEMA ( )
      END
