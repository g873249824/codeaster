      SUBROUTINE OP0110()
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C
C  BUT:  OPERATEUR DE CREATION D'UN MAILLAGE SQUELETTE
C-----------------------------------------------------------------------
C
C
C
C
      INCLUDE 'jeveux.h'

      INTEGER       IOC1,IOC2, IOC3,
     &              IOC11,LLREF,LLNBS,NBSECT,IOC12,IBID
      CHARACTER*8    MODELG, RESCYC, NOMRES, NOMA, NOMSQU
      CHARACTER*16  NOMOPE, NOMCMD
      INTEGER      IARG
C-----------------------------------------------------------------------
C
      CALL JEMARQ ( )
      CALL INFMAJ()
C
      CALL GETRES ( NOMRES, NOMCMD, NOMOPE )
      CALL GETFAC('CYCLIQUE',IOC1)
      CALL GETVID ( ' ', 'MODELE_GENE', 1,IARG,1, MODELG, IOC2 )
      CALL GETVID ( ' ', 'SQUELETTE'  , 1,IARG,1, NOMSQU, IOC3 )

C
C------------------------CAS CYCLIQUE-----------------------------------
C
      IF ( IOC1 .GT. 0 ) THEN
        CALL GETVID ('CYCLIQUE','MODE_CYCL' ,1,IARG,1,RESCYC,IOC11)
        IF (IOC11.GT.0) THEN
          CALL JEVEUO(RESCYC//'.CYCL_REFE','L',LLREF)
          NOMA = ZK24(LLREF)
          CALL JEVEUO(RESCYC//'.CYCL_NBSC','L',LLNBS)
          NBSECT = ZI(LLNBS)
        ELSE
          CALL GETVID ('CYCLIQUE','MAILLAGE', 1,IARG,1,NOMA,IOC12)
          CALL GETVIS('CYCLIQUE','NB_SECTEUR',1,IARG,1,NBSECT,IBID)
        ENDIF
        CALL CYC110( NOMRES , NOMA, NBSECT)
C
C--------------------------CAS CLASSIQUE--------------------------------
C
      ELSEIF ( IOC2 .NE. 0 ) THEN
         IF (IOC3 .EQ. 0) THEN
            CALL CLA110 ( NOMRES , MODELG )
         ELSE
C           --- FUSION DES NOEUDS D'INTERFACE D'UN SQUELETTE EXISTANT --
            CALL REC110 ( NOMRES , NOMSQU , MODELG )
C           -- L'OBJET .INV.SKELETON EST FAUX : ON LE DETRUIT
            CALL JEDETR(NOMRES//'.INV.SKELETON')
         ENDIF
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
