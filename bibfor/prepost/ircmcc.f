      SUBROUTINE IRCMCC ( IDFIMD,
     >                    NOCHMD, EXISTC,
     >                    NCMPVE, NTNCMP, NTUCMP,
     >                    CODRET )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 08/10/2002   AUTEUR GNICOLAS G.NICOLAS 
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
C        NTNCMP : SD DES NOMS DES COMPOSANTES A ECRIRE (K8)
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
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'IRCMCC' )
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
C 1.1. ==> RECUPERATION DU NIVEAU D'IMPRESSION
C
      CALL INFMAJ
      CALL INFNIV ( IFM, NIVINF )
C
C====
C 2. CREATION DU CHAMP
C====
C
      IF ( EXISTC.EQ.1 ) THEN
        CALL UTMESS ('F',NOMPRO,'ON NE SAIT PAS FAIRE AVEC EXISTC = 1')
      ENDIF
C
      IF ( EXISTC.EQ.0 ) THEN
C
        CALL JEVEUO ( NTNCMP, 'L', ADNCMP )
        CALL JEVEUO ( NTUCMP, 'L', ADUCMP )
C
        IF ( NCMPVE.EQ.1 ) THEN
          WRITE (IFM,20001) ZK8(ADNCMP)
        ELSE
          WRITE (IFM,20002) NCMPVE
          WRITE (IFM,20003) (ZK8(ADNCMP-1+IAUX),IAUX=1,NCMPVE)
        ENDIF
20001   FORMAT(2X,'LE CHAMP MED EST CREE AVEC LA COMPOSANTE : ',A8)
20002   FORMAT(2X,'LE CHAMP MED EST CREE AVEC ',I3,' COMPOSANTES :')
20003   FORMAT(2X,A8,4(', ',A8:))
C
        CALL EFCHAC ( IDFIMD, NOCHMD, EDFL64,
     >                ZK8(ADNCMP), ZK8(ADUCMP), NCMPVE, CODRET )
        IF ( CODRET.NE.0 ) THEN
          CALL CODENT ( CODRET,'G',SAUX08 )
          CALL UTMESS ('F',NOMPRO,'MED: ERREUR EFCHAC NUMERO '//SAUX08)
        ENDIF
C
      ENDIF
C
      END
