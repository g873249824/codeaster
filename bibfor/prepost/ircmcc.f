      SUBROUTINE IRCMCC ( IDFIMD,
     &                    NOCHMD, EXISTC,
     &                    NCMPVE, NTNCMP, NTUCMP,
     &                    CODRET )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 30/05/2007   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GNICOLAS G.NICOLAS
C_______________________________________________________________________
C     ECRITURE D'UN CHAMP -  FORMAT MED - CREATION DU CHAMP
C        -  -       -               -     -           -
C_______________________________________________________________________
C     ENTREES :
C        IDFIMD : IDENTIFIANT DU FICHIER MED
C        NOCHMD : NOM MED DU CHAMP A ECRIRE
C        EXISTC : 0 : LE CHAMP EST INCONNU DANS LE FICHIER
C                >0 : LE CHAMP EST CREE AVEC :
C                 1 : LES COMPOSANTES VOULUES NE SONT PAS TOUTES
C                     ENREGISTREES
C                 2 : AUCUNE VALEUR POUR CE TYPE ET CE NUMERO D'ORDRE
C        NCMPVE : NOMBRE DE COMPOSANTES VALIDES EN ECRITURE
C        NTNCMP : SD DES NOMS DES COMPOSANTES A ECRIRE (K16)
C        NTUCMP : SD DES UNITES DES COMPOSANTES A ECRIRE (K16)
C     SORTIES:
C        CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
C_______________________________________________________________________
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      CHARACTER*32 NOCHMD
      CHARACTER*(*) NTNCMP, NTUCMP
C
      INTEGER IDFIMD
      INTEGER EXISTC
      INTEGER NCMPVE
C
      INTEGER CODRET
C
C 0.2. ==> COMMUNS
C
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
C
      INTEGER EDFL64
      PARAMETER (EDFL64=6)
C
      INTEGER ADNCMP, ADUCMP
      INTEGER IFM, NIVINF
      INTEGER IAUX
C
      CHARACTER*8 SAUX08
C
C====
C 1. PREALABLES
C====
C
      CALL INFNIV ( IFM, NIVINF )
C
      IF ( EXISTC.EQ.1 ) THEN
        CALL U2MESK('S', 'PREPOST2_5', 1, NOCHMD)
      ENDIF
C
C====
C 2. CREATION DU CHAMP
C====
C
      IF ( EXISTC.EQ.0 ) THEN
C
        IF ( NIVINF.GT.1 ) THEN
          WRITE (IFM,2100) NOCHMD
        ENDIF
 2100   FORMAT(2X,'DEMANDE DE CREATION DU CHAMP MED : ',A)
C
C 2.1. ==> ADRESSES DE LA DESCRIPTION DES COMPOSANTES
C
        CALL JEVEUO ( NTNCMP, 'L', ADNCMP )
        CALL JEVEUO ( NTUCMP, 'L', ADUCMP )
C
C 2.2. ==> APPEL DE LA ROUTINE MED
C
        CALL EFCHAC ( IDFIMD, NOCHMD, EDFL64,
     &                ZK16(ADNCMP), ZK16(ADUCMP), NCMPVE, CODRET )
C
        IF ( CODRET.NE.0 ) THEN
          CALL CODENT ( CODRET,'G',SAUX08 )
          CALL U2MESK('F','PREPOST2_6',1,SAUX08)
        ENDIF
C
C 2.3. ==> IMPRESSION D'INFORMATION
C
        IF ( NIVINF.GT.1 ) THEN
          IF ( NCMPVE.EQ.1 ) THEN
            WRITE (IFM,2301) ZK16(ADNCMP)(1:8)
          ELSE
            WRITE (IFM,2302) NCMPVE
            WRITE (IFM,2303) (ZK16(ADNCMP-1+IAUX)(1:8),IAUX=1,NCMPVE)
          ENDIF
        ENDIF
 2301   FORMAT(2X,'LE CHAMP MED EST CREE AVEC LA COMPOSANTE : ',A8)
 2302   FORMAT(2X,'LE CHAMP MED EST CREE AVEC ',I3,' COMPOSANTES :')
 2303   FORMAT(5(A8:,', '),:)
C
      ENDIF
C
      END
