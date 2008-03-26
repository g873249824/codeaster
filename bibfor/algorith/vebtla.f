      SUBROUTINE VEBTLA(MODELZ,MATE  ,CARELE,DEPLAZ,LISCHA,
     &                  VECELZ)
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
      CHARACTER*(*) MODELZ,DEPLAZ,VECELZ
      CHARACTER*19  LISCHA
      CHARACTER*24  MATE,CARELE
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (CALCUL)
C
C CALCUL DES VECTEURS ELEMENTAIRES BT.LAMBDA
C      
C ----------------------------------------------------------------------
C
C
C IN  MATE   : CHAMP DE MATERIAU
C IN  CARELE : CARACTERISTIQUES ELEMENTAIRES      
C IN  MODELE : NOM DU MODELE
C IN  DEPLA  : CHAMP DE DEPLACEMENTS
C IN  LISCHA : SD L_CHARGES
C OUT VECELE : VECTEURS ELEMENTAIRES     
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
      CHARACTER*6  MASQUE
      CHARACTER*8  NOMCHA,K8BID
      CHARACTER*16 OPTION
      CHARACTER*24 LIGRCH
      INTEGER      IRET,NCHAR,NDIR,ICHA
      INTEGER      JCHAR,JINF
      CHARACTER*8  MODELE
      CHARACTER*19 DEPLA,VECELE   
      INTEGER      IFMDBG,NIVDBG
      LOGICAL      DEBUG
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()  
      CALL INFDBG('PRE_CALCUL',IFMDBG,NIVDBG)        
C
C --- INITIALISATIONS
C
      MODELE = MODELZ
      DEPLA  = DEPLAZ
      VECELE = VECELZ
      OPTION = 'MECA_BTLA_R'
      MASQUE = '.REXXX'
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
C --- ACCES AUX CHARGES
C      
      CALL JEEXIN(LISCHA(1:19)//'.LCHA',IRET)
      IF ( IRET .EQ. 0 ) GOTO 9999
      CALL JELIRA(LISCHA(1:19)//'.LCHA','LONMAX',NCHAR,K8BID)
      CALL JEVEUO(LISCHA(1:19)//'.LCHA','L',JCHAR)
      CALL JEVEUO(LISCHA(1:19)//'.INFC','L',JINF)
C
C --- ALLOCATION DU VECT_ELEM RESULTAT :
C     
      CALL JEEXIN(VECELE//'.RELR' ,IRET)
      IF ( IRET .EQ. 0 ) THEN
        CALL MEMARE('V',VECELE,MODELE,MATE  ,CARELE,'CHAR_MECA')
      ELSE
         CALL JEDETR(VECELE//'.RELR')
      ENDIF
      CALL REAJRE(VECELE,' ','V')
C
C --- CALCUL DE L'OPTION BT.LAMBDA
C      
      NDIR  = 0
      DO 10 ICHA = 1,NCHAR
        IF ( ZI(JINF+ICHA) .GT. 0 ) THEN
          NOMCHA = ZK24(JCHAR+ICHA-1)(1:8)
          LIGRCH = NOMCHA // '.CHME.LIGRE'
          NDIR   = NDIR + 1
          CALL CODENT(NDIR,'D0',MASQUE(4:6))
          LPAIN(1)  = 'PDDLMUR'
          LCHIN(1)  =  NOMCHA(1:8)//'.CHME.CMULT'
          LPAIN(2)  = 'PLAGRAR'
          LCHIN(2)  =  DEPLA
          LPAOUT(1) = 'PVECTUR'
          LCHOUT(1) =  VECELE(1:8)//MASQUE        
C          
          CALL CALCUL('S',OPTION,LIGRCH,NBIN ,LCHIN ,LPAIN ,
     &                                  NBOUT,LCHOUT,LPAOUT,'V')
C
          IF (DEBUG) THEN
            CALL DBGCAL(OPTION,IFMDBG,
     &                  NBIN  ,LPAIN ,LCHIN ,
     &                  NBOUT ,LPAOUT,LCHOUT)
          ENDIF   
C     
          CALL REAJRE(VECELE,LCHOUT(1),'V')
        ENDIF
 10   CONTINUE
C
 9999 CONTINUE
      CALL JEDEMA()
      END
