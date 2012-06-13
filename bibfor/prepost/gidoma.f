      SUBROUTINE GIDOMA(NBNOTO)
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'jeveux.h'
      INTEGER NBNOTO
C
C ----------------------------------------------------------------------
C     BUT : CREER  L'OBJET &&GILIRE.NUMANEW
C           QUI DONNE LE NOUVEAU NUMERO DE MAILLE DE TOUTES LES
C           MAILLES LUES POUR TENIR COMPTE DES MAILLES IDENTIQUES.
C           (MAILLES EN "DOUBLE" GENEREES PAR LE "ET" GIBI)
C
C     IN  : NBNOTO : NOMBRE TOTAL DE NOEUDS DU MAILLAGE.
C
C ----------------------------------------------------------------------
C
C     FONCTIONS EXTERNES:
C     -------------------
C
C     VARIABLES LOCALES:
C     ------------------
C
      CHARACTER*8  KBI
      LOGICAL IDEN
C
C
C     -- RECUPERATION DU NOMBRE DE MAILLES TOTAL (AVANT COMPACTAGE):
      CALL JEMARQ()
      CALL JELIRA('&&GILIRE.CONNEX2','NMAXOC',NBMATO,KBI)
      CALL JEVEUO('&&GILIRE.CONNEX2','L',IACNX2)
      CALL JEVEUO(JEXATR('&&GILIRE.CONNEX2','LONCUM'),'L',ILCNX2)
C
C     -- CREATION DE L'OBJET .NUMANEW QUI CONTIENDRA POUR CHAQ. MAILLE:
C     -- SON NOUVEAU NUMERO (INFERIEUR OU EGAL A L'ANCIEN)
      CALL WKVECT('&&GILIRE.NUMANEW','V V I',NBMATO,IANEMA)
C
C     -- CREATION ET REMPLISSAGE DE L'OBJET &&GILIRE.OBJET_WK1
C        CET OBJET INDIQUE POUR CHAQUE NOEUD COMBIEN DE MAILLES
C        ONT UNE CONNECTIVITE QUI COMMENCE PAR CE NOEUD:
      CALL WKVECT('&&GILIRE.OBJET_WK1','V V I',NBNOTO,IAWK1)
      DO 20 IMA=1,NBMATO
         NUNO1= ZI(IACNX2-1+ZI(ILCNX2-1+IMA)-1+1 )
         ZI(IAWK1-1+NUNO1) =ZI(IAWK1-1+NUNO1) +1
 20   CONTINUE
C
C     -- CREATION ET REMPLISSAGE DE L'OBJET &&GILIRE.OBJET_WK2
C        CET OBJET CONTIENT LA LISTE DES MAILLES QUI COMMENCENT
C        PAR LE MEME NOEUD.
C     -- COMME JEVEUX N'ADMET TOUJOURS PAS D'OBJETS DE LONGUEURS NULLES
C        DANS LES COLLECTIONS, ON CREE AUSSI .OBJET_WK3 QUI SERT DE
C        POINTEUR DE LONGUEURS CUMULEES.
C        WK3(INO) = ADRESSE DANS WK2 DE LA PREMIERE MAILLE QUI COMMENCE
C        PAR LE NOEUD INO. (0 SI AUCUNE MAILLE).
      CALL WKVECT('&&GILIRE.OBJET_WK2','V V I',NBMATO,IAWK2)
      CALL WKVECT('&&GILIRE.OBJET_WK3','V V I',NBNOTO,IAWK3)
C
C     -- CALCUL DE OBJET_WK3:
      ICO=1
      DO 21 INO=1,NBNOTO
         NBMA = ZI(IAWK1-1+INO)
         IF (NBMA.EQ.0) GO TO 21
         ZI(IAWK3-1+INO) = ICO
         ICO = ICO + NBMA
 21   CONTINUE
C
C     -- CALCUL DE OBJET_WK2: (ON MODIFIE _WK3 A CHAQUE MAILLE TRAITEE)
      DO 22 IMA=1,NBMATO
         NUNO1= ZI(IACNX2-1+ZI(ILCNX2-1+IMA)-1+1 )
         IPOS = ZI(IAWK3-1+NUNO1)
         CALL ASSERT(IPOS.NE.0)
         CALL ASSERT(ZI(IAWK2-1+IPOS).EQ.0)
         ZI(IAWK2-1+IPOS) = IMA
         ZI(IAWK3-1+NUNO1) = IPOS + 1
 22   CONTINUE
C
C     -- ON DECLARE IDENTIQUES 2 MAILLES AYANT MEME CONNECTIVITE:
      ICO=0
      DO 1 INO=1,NBNOTO
         NBMA= ZI(IAWK1-1+INO)
         IF (NBMA.EQ.0) GO TO 1
         DO 2 J=1,NBMA
            IDEN=.FALSE.
            IMAJ= ZI(IAWK2-1+ICO+J)
            NBNOJ=ZI(ILCNX2-1+IMAJ+1)-ZI(ILCNX2-1+IMAJ)
            DO 3 K=1,J-1
               IMAK= ZI(IAWK2-1+ICO+K)
               NBNOK=ZI(ILCNX2-1+IMAK+1)-ZI(ILCNX2-1+IMAK)
               IF (NBNOJ.NE.NBNOK) GO TO 3
               DO 4 L=1,NBNOJ
                  NUNOJ= ZI(IACNX2-1+ZI(ILCNX2-1+IMAJ)-1+L )
                  NUNOK= ZI(IACNX2-1+ZI(ILCNX2-1+IMAK)-1+L )
                  IF (NUNOJ.NE.NUNOK) GO TO 3
                  IF (L.EQ.NBNOJ) THEN
                     IDEN=.TRUE.
                     GO TO 5
                  END IF
 4             CONTINUE
 3          CONTINUE
 5          CONTINUE
            IF (IDEN) THEN
               ZI(IANEMA-1+IMAJ) =ZI(IANEMA-1+IMAK)
               GO TO 2
            ELSE
               ZI(IANEMA-1+IMAJ) =IMAJ
            END IF
 2       CONTINUE
      ICO = ICO + NBMA
 1    CONTINUE
C
      CALL JEDEMA()
      END
