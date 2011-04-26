      SUBROUTINE UTIMSD(UNIT,NIVEAU,LATTR,LCONT,SCH1,IPOS,BASE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
C     --
C     ARGUMENTS:
C     ----------
      CHARACTER*(*) SCH1,BASE
      INTEGER       IPOS,NIVEAU,UNIT
      LOGICAL LATTR,LCONT
C ----------------------------------------------------------------------
C BUT:
C   IMPRIMER LE CONTENU DES OBJETS JEVEUX (K24) AYANT
C   LA CHAINE SCH1 EN POSITION IPOS DANS LEURS NOMS.
C
C
C IN:
C  UNIT     : UNITE LOGIQUE D'IMPRESSION
C  NIVEAU   : NIVEAU D'IMPRESSION
C    NIVEAU 0 --> IMPRESSION DES NOMS DES OBJETS.
C    NIVEAU 1 --> IMPRESSION DU CONTENU DES 10 1ER OBJETS DE COLLEC.
C    NIVEAU 2 --> IMPRESSION DU CONTENU DE TOUS LES OBJETS DE COLLEC.
C    NIVEAU -1--> IMPRESSION DU RESUME DES OBJETS (1 LIGNE PAR OBJET)
C  LATTR   : VRAI : ON IMPRIME LES ATTRIBUTS
C          : FAUX : ON N'IMPRIME PAS LES ATTRIBUTS
C  LCONT   : VRAI : ON IMPRIME LE CONTENU DES OBJETS
C          : FAUX : ON N'IMPRIME PAS LE CONTENU DES OBJETS
C   SCH1   : CHAINE DE CARACTERES CHERCHEE
C   IPOS   : / DEBUT DE LA CHAINE DE CARACTERES A CHERCHER (1,...,24)
C            / 0 : ON NE REGARDE PAS SCH1, ON IMPRIME TOUS LES OBJETS
C   BASE   : 'G','V','L',OU ' '(TOUTES)
C
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*24 OB1,CHAIN2
      CHARACTER*40 LB
      CHARACTER*1 XOUS,BAS2
      INTEGER LONG,NBVAL,NBOBJ,IALIOB,I,IBID
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL ,TOUT
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      CHARACTER*8  KBID
C --------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
C
C
      CALL JEMARQ()
      BAS2= BASE
C
C     --QUELQUES VERIFICATIONS:
C     -------------------------
      IF (IPOS.EQ.0) THEN
         TOUT=.TRUE.
      ELSE
         TOUT=.FALSE.

         LONG=LEN(SCH1)
         IF (LEN(SCH1).GT.24) THEN
            CALL U2MESS('F','UTILITAI5_42')
         END IF
         IF ((IPOS.LT.0).OR.(IPOS.GT.24)) THEN
            CALL U2MESS('F','UTILITAI5_43')
         END IF
         IF (IPOS+LEN(SCH1).GT.25) THEN
            CALL U2MESS('F','UTILITAI5_44')
         END IF
      ENDIF
C
C     -- ECRITURE DE L'ENTETE :
C    --------------------------
      CHAIN2='????????????????????????'
      IF (.NOT.TOUT) CHAIN2(IPOS:IPOS-1+LONG)=SCH1
      WRITE(UNIT,*) ' '
      WRITE(UNIT,*) '====> IMPR_CO DE LA STRUCTURE DE DONNEE : ',
     &                CHAIN2
      WRITE(UNIT,*) 'ATTRIBUT : ',LATTR
     &                   ,' CONTENU : ',LCONT,' BASE : >',BAS2,'<'
      CALL JELSTC(BAS2 ,SCH1,IPOS,0,KBID,NBVAL)
      NBOBJ= -NBVAL
      WRITE(UNIT,*) 'NOMBRE D''OBJETS (OU COLLECTIONS) TROUVES :',NBOBJ
      WRITE(UNIT,*) ' '
      IF (NBVAL.EQ.0) GO TO 9999
C
C     -- RECHERCHE DES NOMS DES OBJETS VERIFIANT LE CRITERE:
C    -------------------------------------------------------
      CALL WKVECT('&&UTIMSD.LISTE','V V K24',NBOBJ,IALIOB)
      CALL JELSTC(BAS2 ,SCH1,IPOS,NBOBJ,ZK24(IALIOB),NBVAL)
C
C     -- ON TRIE PAR ORDRE ALPHABETIQUE:
      CALL UTTR24(ZK24(IALIOB),NBOBJ)


C     -- SI NIVEAU = 0 ON IMPRIME LES NOMS DES OBJETS :
C     -----------------------------------------------
      IF (NIVEAU.EQ.0) THEN
        DO 1   I=1,NBOBJ
           OB1 = ZK24(IALIOB-1+I)
           WRITE(UNIT,*) '      >',OB1,'<'
 1      CONTINUE


      ELSE IF (NIVEAU.EQ.-1) THEN
        DO 4   I=1,NBOBJ
           OB1 = ZK24(IALIOB-1+I)
           CALL DBGOBJ(OB1,'OUI',UNIT,'&&UTIMSD')
 4      CONTINUE


      ELSE IF (NIVEAU.GT.0) THEN
        LB='========================================'
C
C       -- IMPRESSION DES ATTRIBUTS :
C       -----------------------------
        IF (LATTR) THEN
          WRITE(UNIT,'(A40,A40)') LB,LB
          WRITE(UNIT,*) ' IMPRESSION DES ATTRIBUTS DES OBJETS TROUVES :'
          DO 2   I=1,NBOBJ
            OB1 = ZK24(IALIOB-1+I)
            CALL JELIRA(OB1,'XOUS',IBID,XOUS)
            CALL UTIMOB(UNIT,OB1,NIVEAU,.TRUE.,.FALSE.,XOUS)
 2        CONTINUE
        END IF
C
C       -- IMPRESSION DES VALEURS :
C       ---------------------------
        IF (LCONT) THEN
          WRITE(UNIT,'(A40,A40)') LB,LB
          WRITE(UNIT,*) ' IMPRESSION DU CONTENU DES OBJETS TROUVES :'
          DO 3   I=1,NBOBJ
            OB1 = ZK24(IALIOB-1+I)
            CALL JELIRA(OB1,'XOUS',IBID,XOUS)
            CALL UTIMOB(UNIT,OB1,NIVEAU,.FALSE.,.TRUE.,XOUS)
 3        CONTINUE
        END IF
C
      END IF
C
C
      WRITE(UNIT,*) '====> FIN IMPR_CO DE DE STRUCTURE DE DONNEE : ',
     &                CHAIN2
C
C
      CALL JEDETR('&&UTIMSD.LISTE')
 9999 CONTINUE
      CALL JEDEMA()
      END
