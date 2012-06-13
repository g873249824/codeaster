      SUBROUTINE OP0187()
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     =================================================================
C                      OPERATEUR POST_MAIL_XFEM
C                      ------------------------
C     BUT : GENERER UN MAILLAGE DESTINE UNIQUEMENT AU POST-TRAITEMENT
C           DES ELEMENTS XFEM, ET METTANT EN EVIDENCE LES SOUS-ELEMENTS
C           DES MAILLES FISSUREES
C     =================================================================
C     ------------------------------------------------------------------
      INCLUDE 'jeveux.h'
      INTEGER      IBID,IRET,NSETOT,NNNTOT,NCOTOT,NBNOC,NBMAC,IFM,NIV
      INTEGER      NBGMA2,JNIVGR,NFTOT,MFTOT,NFCOMF,NGFON
      CHARACTER*2  PREFNO(4)
      CHARACTER*8  MAXFEM,MO,MALINI,K8B,NOMRES,NOGRFI
      CHARACTER*16 K16B
      CHARACTER*19 K19B
      CHARACTER*24 MAILX,MAILC,LISTNO,K24B,LOGRMA,DIRGRM,LISTGR,NIVGRM
C
      CALL JEMARQ()
      CALL INFMAJ()
      CALL INFNIV(IFM,NIV)
C
C     ------------------------------------------------------------------
C     1. RECUPERATION DES CONCEPTS UTILISATEURS
C        ET DEFINITION DES NOMBRES DE MAILLES ET DE NOEUDS EN FOND DE
C        FISSURE
C     ------------------------------------------------------------------
C
      IF (NIV.GT.1) WRITE(IFM,*)' '
      IF (NIV.GT.1) WRITE(IFM,*)'1. XPOINI'
      CALL XPOINI(MAXFEM,MO,MALINI,K8B,K24B,K8B,K8B,PREFNO,NOGRFI)
      CALL XPOFON(MO,MFTOT,NFTOT,NFCOMF,NGFON)
C
C     ------------------------------------------------------------------
C     2. SEPARATION DES MAILLES DE MALINI EN 2 GROUPES
C              - MAILC : MAILLES NON AFFECTEES D'UN MODELE
C                        OU NON SOUS-DECOUPEES (CLASSIQUE)
C              - MAILX : MAILLES SOUS-DECOUPEES (X-FEM)
C     ------------------------------------------------------------------
C
      IF (NIV.GT.1) WRITE(IFM,*)' '
      IF (NIV.GT.1) WRITE(IFM,*)'2. XPOSEP'
      MAILC = '&&OP0187.MAILC'
      MAILX = '&&OP0187.MAILX'
      LOGRMA = '&&OP0187.LOGRMA'
      LISTGR = '&&OP0187.LISTGR'
      CALL XPOSEP(MO,MALINI,MAILC,MAILX,NSETOT,NNNTOT,NCOTOT,
     &                                                 LOGRMA,LISTGR)

      IF (NIV.GT.1) THEN
        WRITE(IFM,*)'NOMBRE DE NOUVELLES MAILLES A CREER',NSETOT+MFTOT
        WRITE(IFM,*)'NOMBRE DE NOUVEAUX NOEUDS A CREER',NNNTOT+NFTOT
      ENDIF

C     ------------------------------------------------------------------
C     3. DIMENSIONNEMENT DES OBJETS DE MAXFEM
C     ------------------------------------------------------------------

      IF (NIV.GT.1) WRITE(IFM,*)' '
      IF (NIV.GT.1) WRITE(IFM,*)'3. XPODIM'
      LISTNO = '&&OP0187.LISTNO'
      DIRGRM = '&&OP0187.DIRGRM'
      CALL XPODIM(MALINI,MAILC,K8B,K24B,NSETOT+MFTOT,NNNTOT+NFTOT,
     &            NCOTOT+NFCOMF,LISTNO,K19B,K19B,K19B,K19B,K19B,K19B,
     &            K19B,IBID,K8B,NBNOC,NBMAC,LOGRMA,DIRGRM,MAXFEM,NGFON,
     &            K19B,K19B)

C     ------------------------------------------------------------------
C     4. TRAITEMENT DES MAILLES DE MAILC
C            LES MAILLES DE MAILC ET LES NOEUDS ASSOCI�S SONT COPIES
C            DANS MAXFEM A L'IDENTIQUE
C     ------------------------------------------------------------------

      IF (NIV.GT.1) WRITE(IFM,*)' '
      IF (NIV.GT.1) WRITE(IFM,*)'4. XPOMAC'

C     CREATION DU VECTEUR DE REMPLISSAGE DES GROUP_MA
      NIVGRM = '&&OP0187.NIVGRM'
      CALL JELIRA(MAXFEM//'.GROUPEMA','NUTIOC',NBGMA2,K8B)
      IF (NBGMA2.GT.0) CALL WKVECT(NIVGRM,'V V I',NBGMA2,JNIVGR)

      CALL XPOMAC(MALINI,MAILC,LISTNO,NBNOC,NBMAC,MAXFEM,NIVGRM,
     &            K19B,K19B,K19B,K19B,K19B,K19B,K8B,K19B,K19B)

C     ------------------------------------------------------------------
C     5. TRAITEMENT DES MAILLES DE MAILX
C     ------------------------------------------------------------------

      IF (NIV.GT.1) WRITE(IFM,*)' '
      IF (NIV.GT.1) WRITE(IFM,*)'5. XPOMAX'
      CALL XPOMAX(MO,MALINI,MAILX,NBNOC,NBMAC,PREFNO,NOGRFI,MAXFEM,
     &            K19B,K19B,K19B,K19B,K19B,K19B,LISTGR,DIRGRM,NIVGRM,
     &            K8B,NGFON,K19B,K19B)

C     ------------------------------------------------------------------
C     6. TRAITEMENT DES FONDS DE FISSURE
C     ------------------------------------------------------------------

      IF (NIV.GT.1) WRITE(IFM,*)' '
      IF (NIV.GT.1) WRITE(IFM,*)'6. XPOCRF'
      CALL XPOCRF(MO,MAXFEM,MFTOT,NFTOT)

      IF (NIV.GT.1) WRITE(IFM,*)'FIN DE POST_MAIL_XFEM'

      CALL TITRE()
C
C --- CARACTERISTIQUES GEOMETRIQUES :
C     -----------------------------
      CALL GETRES ( NOMRES, K16B, K16B )
      CALL CARGEO ( NOMRES )

      CALL JEEXIN(DIRGRM,IRET)
      IF (IRET.NE.0) CALL JEDETR(DIRGRM)

      CALL JEEXIN(LISTGR,IRET)
      IF (IRET.NE.0) CALL JEDETR(LISTGR)

      CALL JEEXIN(NIVGRM,IRET)
      IF (IRET.NE.0) CALL JEDETR(NIVGRM)

      CALL JEDEMA()
      END
