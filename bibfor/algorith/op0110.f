      SUBROUTINE OP0110 ( IER )
      IMPLICIT NONE
      INTEGER             IER
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/11/2008   AUTEUR PELLET J.PELLET 
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
C  BUT:  OPERATEUR DE CREATION D'UN MAILLAGE SQUELETTE
C-----------------------------------------------------------------------
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
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
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER       IOC1,IOC2, IOC3, IOC4, NBMA, NBMAIL, JNUM, JNOM,
     &              IOC11,LLREF,LLNBS,NBSECT,IOC12,IBID
      REAL*8        TRANS(3),ANGL(3)
      CHARACTER*8   K8B, MODELG, RESCYC, NOMRES, NOMA, NOMSQU
      CHARACTER*16  NOMOPE, NOMCMD
      CHARACTER*24  NOMVEI, NOMVEK
C-----------------------------------------------------------------------
C
      CALL JEMARQ ( )
      CALL INFMAJ()
C
      CALL GETRES ( NOMRES, NOMCMD, NOMOPE )
      CALL GETFAC('CYCLIQUE',IOC1)
      CALL GETVID ( ' ', 'MODELE_GENE', 1,1,1, MODELG, IOC2 )
      CALL GETVID ( ' ', 'MAILLAGE'   , 1,1,1, NOMA  , IOC3 )
      CALL GETVID ( ' ', 'SQUELETTE'  , 1,1,1, NOMSQU, IOC4 )
C
C------------------------CAS CYCLIQUE-----------------------------------
C
C------------------------CAS CYCLIQUE-----------------------------------
C
      IF ( IOC1 .GT. 0 ) THEN
        CALL GETVID ('CYCLIQUE','MODE_CYCL' ,1,1,1,RESCYC,IOC11)
        IF (IOC11.GT.0) THEN
          CALL JEVEUO(RESCYC//'.CYCL_REFE','L',LLREF)
          NOMA = ZK24(LLREF)
          CALL JEVEUO(RESCYC//'.CYCL_NBSC','L',LLNBS)
          NBSECT = ZI(LLNBS)
        ELSE
          CALL GETVID ('CYCLIQUE','MAILLAGE', 1,1,1,NOMA,IOC12)
          CALL GETVIS('CYCLIQUE','NB_SECTEUR',1,1,1,NBSECT,IBID)
        ENDIF
        CALL CYC110( NOMRES , NOMA, NBSECT)
C
C--------------------------CAS CLASSIQUE--------------------------------
C
      ELSEIF ( IOC2 .NE. 0 ) THEN
         IF (IOC4 .EQ. 0) THEN
            CALL CLA110 ( NOMRES , MODELG )
         ELSE
C           --- FUSION DES NOEUDS D'INTERFACE D'UN SQUELETTE EXISTANT --
            CALL REC110 ( NOMRES , NOMSQU , MODELG )
C           -- L'OBJET .INV.SKELETON EST FAUX : ON LE DETRUIT
            CALL JEDETR(NOMRES//'.INV.SKELETON')
         ENDIF
C
C--------------------------UN SQUELETTE---------------------------------
C
      ELSEIF ( IOC3 .NE. 0 ) THEN
         TRANS(1) = 0.D0
         TRANS(2) = 0.D0
         TRANS(3) = 0.D0
         CALL GETVR8 ( ' ', 'TRANS', 1,1,3, TRANS, IOC3 )
         ANGL(1) = 0.D0
         ANGL(2) = 0.D0
         ANGL(3) = 0.D0
         CALL GETVR8 ( ' ', 'ANGL_NAUT', 1,1,3, ANGL, IOC3 )
         CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NBMAIL,K8B,IER)
         NBMA = 1
         NOMVEI = '&&OP0110.MAILLE.NUM'
         NOMVEK = '&&OP0110.MAILLE.NOM'
         CALL WKVECT ( NOMVEI, 'V V I' , NBMAIL, JNUM  )
         CALL WKVECT ( NOMVEK, 'V V K8', NBMAIL, JNOM  )
         CALL PALIM2 ( ' ', 1, NOMA, NOMVEI, NOMVEK, NBMA )
         NBMA = NBMA - 1
         IF ( NBMA .EQ. 0 ) THEN
            CALL U2MESS('F','ALGORITH9_50')
         ENDIF
         CALL SQU110 ( NOMRES,NOMA,NBMA,ZK8(JNOM),TRANS,ANGL)
      ENDIF
C
C
C --- CARACTERISTIQUES GEOMETRIQUES :
C     -----------------------------
      CALL DETRSD('L_TABLE',NOMRES)
      CALL CARGEO(NOMRES)

      CALL TITRE( )

      CALL JEDEMA ( )
      END
