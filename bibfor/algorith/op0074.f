      SUBROUTINE OP0074 (IER)
      IMPLICIT REAL*8 (A-H,O-Z)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 31/10/2006   AUTEUR A3BHHAE H.ANDRIAMBOLOLONA 
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
C     OPERATEUR: DYNA_TRAN_MODAL
C
C ----------------------------------------------------------------------
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
C
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
C
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      CHARACTER*8  MATGEN, NOMRES, TRAN, RIGGEN, K8B
      CHARACTER*8  MODELE, CHMAT, CARAEL, NOBJS
      CHARACTER*14 NUMGEN
      CHARACTER*16 TYPREP, NOMCMD, TYPRES
      CHARACTER*32 JEXNUM
C
C     --- ETAPE DE VERIFICATIONS
C
      CALL JEMARQ()
      CALL INFMAJ()
C
      CALL MDVERI( )
C
C     --- RECUPERATION NOM DE LA COMMANDE ---
C
      CALL GETRES(NOMRES,TYPRES,NOMCMD)
      CALL GETVID('ETAT_INIT','RESU_GENE',1,1,1,TRAN,NDT)
      IF (NDT.NE.0) THEN
C        --- TEST SI REPRISE AVEC NOM DE CONCEPT IDENTIQUE ---
         IF (TRAN.EQ.NOMRES) NOMRES='&&OP0074'
      ENDIF
C
C     --- DETERMINATION DU TYPE DE CALCUL ---
C
      CALL GETVID(' ','MASS_GENE',0,1,1,MATGEN,NM)
      CALL JEVEUO(MATGEN//'           .REFA','L',JREFE)
      NUMGEN = ZK24(JREFE+1)(1:14)
      CALL JEVEUO(NUMGEN//'.NUME.REFN','L',JREFE)
      CALL GETTCO(ZK24(JREFE),TYPREP)

C
C       --- CALCUL PAR SUPERPOSITION SUR BASE MODALE ---
C
      IF (TYPREP.EQ.'MODE_MECA       '.OR.
     &    TYPREP.EQ.'MODE_STAT       '.OR.
     &    TYPREP.EQ.'MODE_GENE       '.OR.
     &    TYPREP.EQ.'BASE_MODALE     ') THEN
          CALL MDTR74(NOMRES,NOMCMD)
      ENDIF
C
C       --- CALCUL PAR SOUS-STRUCTURATION DIRECTE ---
C
      IF (TYPREP.EQ.'MODELE_GENE     ') THEN
         CALL SSDT74(NOMRES,NOMCMD)
      ENDIF
C
C
C     --- CAS DE REPRISE AVEC LE MEME NOM DE CONCEPT ---
C
      IF (NOMRES.EQ.'&&OP0074') CALL RESU74(TRAN,NOMRES)
C
      CALL JEDEMA()
      END
