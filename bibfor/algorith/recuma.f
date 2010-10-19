      SUBROUTINE RECUMA (MAILLA,NBMA,NBGR,NOMMA,NOMGR,NBTO,NUMNOT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/10/2010   AUTEUR DELMAS J.DELMAS 
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
C***********************************************************************
C    P. RICHARD     DATE 13/07/90
C-----------------------------------------------------------------------
C  BUT: RASSEMBLER LES MAILLES DE NOMMA ET DES GROUPNO DE NOMGR
      IMPLICIT REAL*8 (A-H,O-Z)
C          ET TRANSCODER DANS NUMNOT
C
C-----------------------------------------------------------------------
C
C MAILLA   /I/: NOM UTILISATEUR DU MAILLAGE
C NBMA     /I/: NOMBRE DE MAILLE EN ARGUMENT DE LA COMMANDE
C NBGR     /I/: NOMBRE DE GROUPES DE MAILLES EN ARGUMENTS
C NOMMA    /I/: NOMS DES MAILLES DONNES EN ARGUMENTS
C NOMGR    /I/: NOMS DES GROUPES DE MAILLES EN ARGUMENTS
C NBTO     /O/: NOMBRE TOTAL DE MAILLES ASSOCIES A L'INTERFACE
C NUMNOT   /O/: VECTEUR DES NUMERO DES MAILLES D'INTERFACE
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER         ZI
      COMMON  /IVARJE/ZI(1)
      REAL*8          ZR
      COMMON  /RVARJE/ZR(1)
      COMPLEX*16      ZC
      COMMON  /CVARJE/ZC(1)
      LOGICAL         ZL
      COMMON  /LVARJE/ZL(1)
      CHARACTER*8     ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                       ZK24
      CHARACTER*32                                 ZK32
      CHARACTER*80                                           ZK80
      COMMON  /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      CHARACTER*8 MAILLA,NOMMA(NBMA),NOMGR(NBGR),NOMCOU
      CHARACTER*24 VALK(2)
      CHARACTER*32 JEXNOM
      INTEGER NUMNOT(NBTO)
      CHARACTER*1 K1BID
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      ICOMP=0
C
C-------RECUPERATION ET TRANSCODAGE DES MAILLES DES GROUPES-------------
C
      IF(NBGR.GT.0) THEN
        DO 10 I=1,NBGR
          NOMCOU=NOMGR(I)
          CALL JELIRA(JEXNOM(MAILLA//'.GROUPEMA',NOMCOU),'LONUTI',
     &                                 NB,K1BID)
          CALL JEVEUO(JEXNOM(MAILLA//'.GROUPEMA',NOMCOU),'L',IADG)
          DO 20 J=1,NB
            ICOMP=ICOMP+1
            NUMNOT(ICOMP)=ZI(IADG+J-1)
 20       CONTINUE
 10     CONTINUE
      ENDIF
C
C
C-------RECUPERATION ET TRANSCODAGE DES MAILLES-------------------------
C
C
C
      IF(NBMA.GT.0) THEN
        DO 30 I=1,NBMA
          NOMCOU=NOMMA(I)
          CALL JENONU (JEXNOM(MAILLA//'.NOMMAI',NOMCOU),NUMA)
C
          IF(NUMA.EQ.0) THEN
            VALK (1) = MAILLA
            VALK (2) = NOMCOU
            CALL U2MESG('E', 'ALGORITH14_10',2,VALK,0,0,0,0.D0)
          ENDIF
C
          ICOMP=ICOMP+1
          NUMNOT(ICOMP)=NUMA
C
 30     CONTINUE
      ENDIF
      NBTO=ICOMP
C
 9999 CONTINUE
      CALL JEDEMA()
      END
