      SUBROUTINE ACEVTR(NOMA,NOMO,ITYP,NOMS,ITAB,NN,IDIM)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 04/05/99   AUTEUR CIBHHPD P.DAVID 
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
C.======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)
C
      CHARACTER*8 NOMS(*)
      CHARACTER*8  NOMO,NOMA
      INTEGER ITYP,NN,IDIM,ITAB(*)
C
C   ARGUMENT        E/S  TYPE         ROLE
C.========================= DEBUT DES DECLARATIONS ====================
C ----- COMMUNS NORMALISES  JEVEUX
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
      CHARACTER*32     JEXNUM, JEXNOM
C -----  VARIABLES LOCALES
      INTEGER       REPI
      CHARACTER*1   K1BID
      CHARACTER*16  NOMTE, NOMODL,CHAINE
      CHARACTER*19  NOLIG
      CHARACTER*24  REPK
C.========================= DEBUT DU CODE EXECUTABLE ==================
C
      CALL JEMARQ ( )
C
C --- INITIALISATIONS :
C     ---------------
      REPI    = 0
      IF (IDIM.EQ.2) THEN
        CHAINE='2D_DIS_TR'
      ELSE
        CHAINE='DIS_TR'
      ENDIF
C
      NOLIG = NOMO//'.MODELE'
      CALL JEEXIN(NOLIG//'.LIEL',IRET)
      IF (IRET.NE.0) THEN
        CALL JELIRA(NOLIG//'.LIEL','NUTIOC',NBGREL,K1BID)
        IF (NBGREL.LE.0) THEN
          CALL UTMESS('F','MODEXI','LE NOMBRE DE GRELS DU LIGREL '//
     +                'DU MODELE EST NUL.')
        ENDIF
        NOMODL=' '
        IERR=0
        DO 10 IGREL=1,NBGREL
          CALL JEVEUO(JEXNUM(NOLIG//'.LIEL',IGREL),'L',IALIEL)
          CALL JELIRA(JEXNUM(NOLIG//'.LIEL',IGREL),'LONMAX',NEL,K1BID)
          ITYPEL= ZI(IALIEL -1 +NEL)
          CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITYPEL),NOMTE)
          CALL DISMTE('F','MODELISATION',NOMTE,REPI,REPK,IERD)
          NOMODL=REPK(1:16)
          IF (NOMODL.NE.CHAINE) THEN
            IF (ITYP.EQ.0) THEN
               IERR=1
               KMAI=ZI(IALIEL)
               GOTO 20
            ELSE
               DO 1 KMA=1,NN
               IF (ITYP.EQ.1) THEN
                  CALL JENONU(JEXNOM(NOMA//'.NOMMAI',NOMS(KMA)),IMA)
               ELSE
                  IMA=ITAB(KMA)
               ENDIF
               CALL TESTLI(IMA,ZI(IALIEL),NEL-1,KMAI,IERR)
               IF (IERR.EQ.1) GOTO 20
    1          CONTINUE
            ENDIF
          ENDIF
   10   CONTINUE
      ENDIF
   20 CONTINUE
C     IF (IERR.EQ.1)  WRITE(*,*) 'KMAI',KMAI,'IGREL',IGREL,
C    .       'NOMODL',NOMODL,'CHAINE',CHAINE
      IF (IERR.EQ.1)  CALL UTMESS('F','AFFE_CARA_ELEM',
     .     'IL NE FAUT PAS DEMANDER ''TR'' DERRIERE CARA SI LE TYPE '
     .   //'D''ELEMENT DISCRET NE PREND PAS EN COMPTE LA ROTATION')
      CALL JEDEMA()
      END
