      SUBROUTINE NMDIDI(MODELE,NUMEDD,LISCHA,VALMOI,VEELEM,
     &                  SECMBR)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/03/2008   AUTEUR REZETTE C.REZETTE 
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
C RESPONSABLE MABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*19  LISCHA
      CHARACTER*24  MODELE, NUMEDD
      CHARACTER*24  VALMOI(8),SECMBR(8)
      CHARACTER*19  VEELEM(30)
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (CALCUL)
C
C CALCUL ET ASSEMBLAGE POUR DIRICHLET DIFFERENTIEL
C      
C ----------------------------------------------------------------------
C
C
C IN       MODELE : MODELE
C IN       NUMEDD : NUME_DDL
C IN       LISCHA : SD L_CHARGES
C IN       DEPMOI : DEPLACEMENTS A L'INSTANT INITIAL
C IN/JXOUT CNDIDI : SECOND MEMBRE DIDI : BDIDI.UREF (OU INEXISTANT)
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      NBOUT,NBIN
      PARAMETER    (NBOUT=1, NBIN=2)
      CHARACTER*8  LPAOUT(NBOUT),LPAIN(NBIN)
      CHARACTER*19 LCHOUT(NBOUT),LCHIN(NBIN)
C
      INTEGER      NUMREF, N1, NEVO, IRET
      INTEGER      NCHAR, NBRES, JCHAR, JINF, ICHA
      CHARACTER*8  NOMCHA, K8BID
      CHARACTER*16 OPTION
      CHARACTER*19 DEPDID, VEDIDI
      CHARACTER*1  BASE
      CHARACTER*24 EVOL, MASQUE
      CHARACTER*24 LIGRCH
      CHARACTER*24 K24BID,DEPMOI,CNDIDI
      LOGICAL      DEBUG
      INTEGER      IFMDBG,NIVDBG
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()  
      CALL INFDBG('PRE_CALCUL',IFMDBG,NIVDBG) 
C
C --- INITIALISATIONS
C   
      VEDIDI = VEELEM(18)
      BASE   = 'V'
      CALL JEEXIN(LISCHA(1:19)// '.LCHA',IRET)
      IF ( IRET .EQ. 0 ) GOTO 9999 
      OPTION = 'MECA_BU_R'
      IF (NIVDBG.GE.2) THEN
        DEBUG  = .TRUE.
      ELSE
        DEBUG  = .FALSE.
      ENDIF 
C
C --- INITIALISATION DES CHAMPS POUR CALCUL
C
      CALL INICAL(NBIN  ,LPAIN ,LCHIN ,
     &            NBOUT ,LPAOUT,LCHOUT)                  
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C
      CALL DESAGG(VALMOI,DEPMOI,K24BID,K24BID,K24BID,
     &            K24BID,K24BID,K24BID,K24BID)    
      CALL DESAGG(SECMBR,K24BID,K24BID,K24BID,K24BID,
     &            K24BID,K24BID,CNDIDI,K24BID)
C
C --- MENAGE
C
      CALL DETRSD('CHAMP_GD',CNDIDI)            
C
C --- CONSTRUCTION DE LA CONFIGURATION DE REFERENCE
C 
      DEPDID = DEPMOI
      CALL GETVIS ('ETAT_INIT','NUME_DIDI',1,1,1,NUMREF,N1)
      CALL GETVID ('ETAT_INIT','EVOL_NOLI',1,1,1,EVOL,NEVO)
      IF ((N1.GT.0) .AND. (NEVO.GT.0)) THEN
        CALL RSEXCH (EVOL,'DEPL',NUMREF,DEPDID,IRET)
        IF (IRET.NE.0) CALL U2MESK('F','ALGORITH7_20',1,EVOL)
      END IF
C
C --- CONSTRUCTION DU VECTEUR BDIDI.UREF
C 
C REM : LE TERME BT.LAMBDA EST EGALEMENT CALCULE. IL EST NUL CAR A CE
C       STADE, LES LAMBDAS SONT NULS.

C
C --- LISTE DES CHARGES
C
      CALL JELIRA(LISCHA(1:19)//'.LCHA','LONMAX',NCHAR,K8BID)
      CALL JEVEUO(LISCHA(1:19)//'.LCHA','L',JCHAR)
      CALL JEVEUO(LISCHA(1:19)//'.INFC','L',JINF)
C
C --- PREPARATION DES VECT_ELEM
C
      CALL JEEXIN(VEDIDI// '.RELR',IRET)
      IF ( IRET .EQ. 0 ) THEN
        CALL MEMARE('V',VEDIDI,MODELE(1:8),' ',' ','CHAR_MECA')
      ENDIF
      CALL JEDETR(VEDIDI//'.RELR')
      CALL REAJRE(VEDIDI,' ','V')
      MASQUE = VEDIDI(1:8)// '.VEXXX'
C
C --- BOUCLE SUR LES CHARGES DE TYPE DIRICHLET DIFFERENTIEL
C
      NBRES = 0
      DO 10 ICHA = 1,NCHAR
C
C --- VERIF SI CHARGE DE TYPE DIRICHLET DIFFERENTIEL
C
        IF (ZI(JINF+ICHA).LE.0.OR.ZI(JINF+3*NCHAR+2+ICHA).EQ.0) THEN
          GOTO 10
        ENDIF
        NOMCHA = ZK24(JCHAR+ICHA-1)(1:8)
        CALL JEEXIN(NOMCHA(1:8)//'.CHME.LIGRE.LIEL',IRET)
        IF (IRET.LE.0) GOTO 10
        CALL EXISD('CHAMP_GD',NOMCHA(1:8)//'.CHME.CMULT',IRET)
        IF (IRET.LE.0) GOTO 10

        CALL CODENT(NBRES+1,'D0',MASQUE(12:14))

        LIGRCH    =  NOMCHA// '.CHME.LIGRE'
        LPAIN(1)  = 'PDDLMUR'
        LCHIN(1)  =  NOMCHA// '.CHME.CMULT'
        LPAIN(2)  = 'PDDLIMR'
        LCHIN(2)  =  DEPDID
        LPAOUT(1) = 'PVECTUR'
        LCHOUT(1) =  MASQUE
        CALL CALCUL('S',OPTION,LIGRCH,NBIN  ,LCHIN ,LPAIN ,
     &                                NBOUT ,LCHOUT,LPAOUT,BASE)
C
        IF (DEBUG) THEN
          CALL DBGCAL(OPTION,IFMDBG,
     &                NBIN  ,LPAIN ,LCHIN ,
     &                NBOUT ,LPAOUT,LCHOUT)
        ENDIF   
C	    
        NBRES = NBRES + 1
        CALL REAJRE(VEDIDI,LCHOUT(1),'V')
 10   CONTINUE
C
C --- ASSEMBLAGE DES VECT_ELEM
C
      IF (NBRES.NE.0) THEN
        CALL ASSVEC(BASE,CNDIDI,1,VEDIDI,1.D0,NUMEDD,' ','ZERO',1)
      ENDIF 


 9999 CONTINUE
      CALL JEDEMA()
      END
