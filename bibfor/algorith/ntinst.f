      SUBROUTINE NTINST ( LNUAR, LOSTAT, LIEVOL, LISARC, EXCARC,
     &                    NUMIMP, NBGRPA, IDEB, JDEB, NUMORD, TPSNP1 )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/09/2002   AUTEUR VABHHTS J.PELLET 
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
C
      IMPLICIT NONE
      LOGICAL      LNUAR,LOSTAT
      INTEGER      NUMIMP(2),NBGRPA,IDEB,JDEB,NUMORD
      REAL*8       TPSNP1
      CHARACTER*24 LIEVOL,LISARC
      CHARACTER*24 EXCARC
C
C ----------------------------------------------------------------------
C
C COMMANDE THER_NON_LINE :
C LISTE DES INSTANTS DE CALCUL ET DIVERS COMPTEURS.
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      ITOT,JNBP,JVAL,K,IRET,N1,NBEXCL,JEXCL,NBARCH,NBINST
      CHARACTER*8  K8B
C DEB ------------------------------------------------------------------
C
C --- DONNEES D'INCREMENTATION (LISTE DES INSTANTS DE CALCUL)
C
      CALL JEMARQ()
C
      NUMIMP(2) = 0
      CALL GETFAC('INCREMENT',N1)
      IF ( N1 .GT. 0 ) THEN
         CALL GETVID( 'INCREMENT', 'LIST_INST', 1,1,1, LIEVOL   , N1)
         CALL GETVIS( 'INCREMENT', 'NUME_INIT', 1,1,1, NUMIMP(1), N1)
         CALL GETVIS( 'INCREMENT', 'NUME_FIN' , 1,1,1, NUMIMP(2), N1)
         CALL JEVEUO (LIEVOL(1:19)//'.NBPA','L',JNBP)
         CALL JELIRA (LIEVOL(1:19)//'.NBPA','LONMAX',NBGRPA,K8B)
         CALL JEVEUO (LIEVOL(1:19)//'.VALE','L',JVAL)
         CALL JELIRA (LIEVOL(1:19)//'.VALE','LONMAX',NBINST,K8B)
         IF ( NUMIMP(2) .EQ. 0 ) NUMIMP(2) = NBINST - 1
      ELSE
C
         LIEVOL = '&&NTINST.LIST_REEL'
         CALL WKVECT (LIEVOL(1:19)//'.VALE','V V R',1,JVAL)
         NBGRPA = 0
         NBINST = 1
      ENDIF
C
C     --- ARCHIVAGE ---
      LISARC = '&&NTINST.LISTE.ARCH'
      EXCARC = '&&NTINST.LISTE.EXCL'
C
      CALL GETVTX ( 'ARCHIVAGE', 'CHAM_EXCLU' , 1,1,0, K8B, NBEXCL )
      NBEXCL = -NBEXCL
      IF ( NBEXCL .NE. 0 ) THEN
        CALL WKVECT ( EXCARC, 'V V K8', NBEXCL, JEXCL )
        CALL  DYARCH ( NBINST,LIEVOL,LISARC,NBARCH,1,NBEXCL,ZK8(JEXCL))
      ELSE
        K8B = ' '
        CALL  DYARCH ( NBINST, LIEVOL, LISARC, NBARCH, 1, NBEXCL, K8B )
      ENDIF
      LNUAR=.FALSE.
      CALL GETVID ( 'ARCHIVAGE', 'LIST_ARCH', 1,1,1, K8B, N1 )
      IF ( N1 .NE. 0 ) THEN
           LNUAR=.TRUE.
      ENDIF
      CALL GETVIS ( 'ARCHIVAGE', 'PAS_ARCH', 1,1,1, K, N1 )
      IF ( N1 .NE. 0 ) THEN
           LNUAR=.TRUE.
      ENDIF
C
      NUMORD = NUMIMP(1)
      IDEB = 0
      JDEB = 1
      CALL JEEXIN (LIEVOL(1:19)//'.NBPA',IRET)
      IF ( IRET .NE. 0 ) THEN
         ITOT = 0
         DO 57 K=1,NBGRPA
            JDEB = NUMORD - ITOT + 1
            ITOT = ITOT + ZI(JNBP+K-1)
            IF ( ITOT .GE. NUMORD ) THEN
               IDEB = K
               GOTO 58
            ENDIF
 57      CONTINUE
 58      CONTINUE
      ENDIF
C
      IF ( LOSTAT ) THEN
         TPSNP1 = ZR(JVAL)-1.D0
         NUMORD = NUMORD - 1 
         IDEB = 0
      ELSE
         TPSNP1 = ZR(JVAL+NUMORD)
      ENDIF
C
      CALL JEDEMA()
C FIN ------------------------------------------------------------------
      END
