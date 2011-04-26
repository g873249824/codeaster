      SUBROUTINE XBARVI(CHAR,NOMA,NOMO,NFISS,JFISS)
      IMPLICIT NONE
      CHARACTER*8   CHAR,NOMA,NOMO
      INTEGER      NFISS,JFISS
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR DELMAS J.DELMAS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C ----------------------------------------------------------------------
C
C ROUTINE XFEM
C
C C'EST ICI QUE L'ON REMPLIT LA 5EME COMPOSANTES DE TOPOFAC.AI
C DANS L'ELEMENT DE CONTACT XFEM
C
C CETTE COMPOSANTE VAUT :
C       1 SI L'ARETE INTERSECT�E EST VITALE
C       0 SINON
C
C ON CR�E AUSSI LA SD CHAR(1:8)//'.CONTACT.CNCTE QUI LISTE ET RENSEIGNE
C LES ARETES APARTENANTES A UN GROUPE D'ARETES VITALES CONNECT�ES,
C IL Y A 4 COMPOSANTES PAR ARETES :
C      1 : NUMERO D'ARETE DANS LE GROUPE
C      2 : NUMERO DE GROUPE
C      3 : NUMERO DE MAILLE
C      4 : NUMERO LOCAL DE L'ARETE DANS LA MAILLE
C
C TRAVAIL EFFECTUE EN COLLABORATION AVEC L'I.F.P.
C
C ----------------------------------------------------------------------
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  NOMA   : NOM DU MAILLAGE
C IN  NOMO   : NOM DU MODELE
C IN  NFISS  : NOMBRE DE FISSURES
C IN  JFISS  : POINTEUR SUR LES FISSURES
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER JCSD1,JCSL1,JCSV1,JCSD2,JCSL2,JCSV2,JCONX1,JCONX2
      INTEGER JLIS1,IMA,JMA,NBMA,PINT,IAD,IRET,NDIM,NINTER,IFISS
      INTEGER AR(12,3),I,IA,NBAR,NLOC(2),NGLO(2),NUNO(2),NEQ,IBID
      CHARACTER*32 JEXNUM,JEXATR
      CHARACTER*19 CHS1,CHS2,NLISEQ,LIGREL,AINTER,FACLON
      CHARACTER*8 FISS,TYPMA,K8BID
      INTEGER   ZXAIN,XXMMVD,IN,JN,INC,IAC,IER,NCTA,NCTE
      INTEGER   JCNTAN,JCNTES,JCNTE2,JARCON,NARCON
      INTEGER   JXC
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      CHS1 = '&&XBARVI.CHS1'
      CHS2 = '&&XBARVI.CHS2'
      LIGREL = NOMO//'.MODELE'
      FACLON = NOMO//'.TOPOFAC.LO'
      AINTER = NOMO//'.TOPOFAC.AI'
      ZXAIN = XXMMVD('ZXAIN')
      NARCON = 0
      IAC = 0
      INC = 0
C
C --- ON RECUPERE DES INFOS GLOBALES SUR LE MAILLAGE
C
      CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NBMA,K8BID,IRET)
      CALL DISMOI('F','DIM_GEOM',NOMA,'MAILLAGE',NDIM,K8BID,IRET)
      CALL JEVEUO(NOMA(1:8)//'.TYPMAIL','L',JMA)
      CALL JEVEUO(NOMA(1:8)//'.CONNEX','L',JCONX1)
      CALL JEVEUO(JEXATR(NOMA(1:8)//'.CONNEX','LONCUM'),'L',JCONX2)
C
C --- TRANSFO CHAM_ELEM -> CHAM_ELEM_S
C
      CALL CELCES(FACLON,'V',CHS1)
      CALL CELCES(AINTER,'V',CHS2)
C
C --- ACCES AU CHAM_ELEM_S
C
      CALL JEVEUO(CHS1//'.CESD','L',JCSD1)
      CALL JEVEUO(CHS1//'.CESV','L',JCSV1)
      CALL JEVEUO(CHS1//'.CESL','L',JCSL1)
      CALL JEVEUO(CHS2//'.CESD','L',JCSD2)
      CALL JEVEUO(CHS2//'.CESL','L',JCSL2)
      CALL JEVEUO(CHS2//'.CESV','E',JCSV2)
C
C --- PREMI�RE PASSE POUR DIMENSIONER LE VECTEUR DES ARETES VITALES
C --- CONNECT�ES
C --- BOUCLE SUR LES MAILLES
C
      DO 11 IMA=1,NBMA
       CALL CESEXI('C',JCSD1,JCSL1,IMA,1,1,1,IAD)
       IF (IAD.GT.0) THEN
        CALL JEVEUO(NOMO//'.XFEM_CONT'  ,'L',JXC)
        NINTER = ZI(JCSV1-1+IAD)
        IF (NINTER.GE.1) THEN
          CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ZI(JMA-1+IMA)),TYPMA)
         IF (ZI(JXC).EQ.2) GOTO 11
         DO 21 PINT = 1,NINTER
C
C --- NUMERO DE L'ARETE INTERSECT�
C
           CALL CESEXI('S',JCSD2,JCSL2,IMA,1,1,ZXAIN*(PINT-1)+1,IAD)
           CALL ASSERT(IAD.GT.0)
           IA=NINT(ZR(JCSV2-1+IAD))
           IF (IA.GT.0) THEN
            CALL CONARE(TYPMA,AR,NBAR)
C
C --- SI IL S'AGIT D'UNE ARRETE, RECUPERATION DES NUM GLOBAUX DE
C --- SES NOEUDS
C
            DO 31 I=1,2
             NLOC(I) = AR(IA,I)
             NGLO(I) = ZI(JCONX1-1+ZI(JCONX2+IMA-1)+NLOC(I)-1)
 31         CONTINUE
C
C --- COMPARAISON AVEC LES NOEUDS DES LISTES DE NOEUDS CONNECTANTS
C
            DO 41 IFISS = 1,NFISS
              FISS=ZK8(JFISS+IFISS-1)
              CALL JEEXIN(FISS(1:8)//'.CONNECTANT',IER)
              IF (IER.EQ.0) THEN
                GOTO 41
              ELSE
                CALL JEVEUO(FISS(1:8)//'.CONNECTANT','L',JCNTAN)
                CALL JELIRA(FISS(1:8)//'.CONNECTANT','LONMAX',
     &                   NCTA,K8BID)
                DO 51 IN=1,NCTA/3
                 NUNO(1) = ZI(JCNTAN-1+3*(IN-1)+1)
                 IF ((NUNO(1).EQ.NGLO(1)).OR.(NUNO(1).EQ.NGLO(2))) THEN
                   CALL JEVEUO(FISS(1:8)//'.CONNECTES ','L',JCNTES)
                   NCTE   = ZI(JCNTAN-1+3*(IN-1)+2)
                   JCNTE2 = ZI(JCNTAN-1+3*(IN-1)+3)
                   DO 61 JN=1,NCTE
                    NUNO(2)  = ZI(JCNTES-1 + JCNTE2 + JN)
                    IF ((NUNO(2).EQ.NGLO(1))
     &                       .OR.(NUNO(2).EQ.NGLO(2)))THEN
                      NARCON = NARCON + 1
                      GOTO 21
                    ENDIF
 61                CONTINUE
                   GOTO 21
                 ENDIF
 51             CONTINUE
              ENDIF
 41         CONTINUE
           ENDIF
 21      CONTINUE
        ENDIF
       ENDIF
 11   CONTINUE
      IF (NARCON.GT.0) THEN
        CALL WKVECT('&&XBARVI.ARCON','G V I',5*NARCON,JARCON)
      ENDIF
C
C --- BOUCLE SUR LES MAILLES
C
      DO 10 IMA=1,NBMA
       CALL CESEXI('C',JCSD1,JCSL1,IMA,1,1,1,IAD)
       IF (IAD.GT.0) THEN
        CALL JEVEUO(NOMO//'.XFEM_CONT'  ,'L',JXC)
        NINTER = ZI(JCSV1-1+IAD)
        IF (NINTER.GE.1) THEN
         CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ZI(JMA-1+IMA)),TYPMA)

         IF (ZI(JXC).EQ.2) THEN
C
C --- SI C L'ANCIENNE FORMULATION, ON IMPOSE QUE TOUTES LES
C     ARETES SONT VITALES
C
           DO 5 PINT = 1,NINTER
             CALL CESEXI('S',JCSD2,JCSL2,IMA,1,1,ZXAIN*(PINT-1)+5,IAD)
             ZR(JCSV2-1+IAD)=1
 5         CONTINUE
           GOTO 10
         ENDIF
         DO 20 PINT = 1,NINTER
C
C --- NUMERO DE L'ARETE INTERSECT�E
C
          CALL CESEXI('S',JCSD2,JCSL2,IMA,1,1,ZXAIN*(PINT-1)+1,IAD)
          CALL ASSERT(IAD.GT.0)
          IA=NINT(ZR(JCSV2-1+IAD))
C
C --- SI IL S'AGIT D'UN NOEUD, ALORS IL EST VITAL
C
          IF (IA.EQ.0) THEN
            CALL CESEXI('S',JCSD2,JCSL2,IMA,1,1,ZXAIN*(PINT-1)+5,IAD)
            ZR(JCSV2-1+IAD)=1
          ELSEIF (IA.GT.0) THEN
C
C --- SI IL S'AGIT D'UNE ARRETE, RECUPERATION DES NUM GLOBAUX
C     DE SES NOEUDS
C
            CALL CONARE(TYPMA,AR,NBAR)
            DO 30 I=1,2
             NLOC(I) = AR(IA,I)
             NGLO(I) = ZI(JCONX1-1+ZI(JCONX2+IMA-1)+NLOC(I)-1)
 30         CONTINUE
C
C --- COMPARAISON AVEC LES COUPLES DE NOEUDS DES LISTES
C     DES RELATIONS D'EGALIT�S
C
            DO 40 IFISS = 1,NFISS
             FISS=ZK8(JFISS+IFISS-1)
             NLISEQ = FISS(1:8)//'.LISEQ'
C
C --- ON RECUPERE LA LISTE DES RELATIONS D'EGALIT�S
C
             CALL JEEXIN(NLISEQ,IER)
             IF (IER.EQ.0) THEN
              NEQ = 0
             ELSE
              CALL JEVEUO(NLISEQ,'L',JLIS1)
              CALL JELIRA(NLISEQ,'LONMAX',NEQ,K8BID)
             ENDIF
             DO 50 I=1,NEQ/2
              NUNO(1)  = ZI(JLIS1-1+2*(I-1)+1)
              NUNO(2)  = ZI(JLIS1-1+2*(I-1)+2)
              IF (((NUNO(1).EQ.NGLO(1)).AND.(NUNO(2).EQ.NGLO(2)))
     &        .OR.((NUNO(1).EQ.NGLO(2)).AND.(NUNO(2).EQ.NGLO(1)))) THEN
C
C --- SI C EGAL, ON EST SUR UNE ARETE VITALE,
C     ON MET LE STATUT � 1 ET ON SORT
C
               CALL CESEXI('S',JCSD2,JCSL2,IMA,1,1,ZXAIN*(PINT-1)+5,IAD)
               ZR(JCSV2-1+IAD)=1
C
C --- AVANT DE SORTIR, ON REGARDE SI L'ARETE EN QUESTION EST
C --- RELI� � UNE AUTRE ARETE VITALE
C
C --- ON RECUPERE LA LISTE DES NOEUDS CONNECTANTS
C
               CALL JEEXIN(FISS(1:8)//'.CONNECTANT',IER)
               IF (IER.EQ.0) THEN
                GO TO 20
               ELSE
                CALL JEVEUO(FISS(1:8)//'.CONNECTANT','L',JCNTAN)
                CALL JELIRA(FISS(1:8)//'.CONNECTANT','LONMAX',
     &                   NCTA,K8BID)
                DO 60 IN=1,NCTA/3
C
C --- ON COMPARE LES NUMEROS DE CETTE LISTE � CELLE DE L'ARETE
C
                 NUNO(1) = ZI(JCNTAN-1+3*(IN-1)+1)
                 IF ((NUNO(1).EQ.NGLO(1)).OR.(NUNO(1).EQ.NGLO(2))) THEN
C
C --- SI C EGALE, ON RECUPERE LA LISTE DES NOEUDS CONNECTES
C
                   CALL JEVEUO(FISS(1:8)//'.CONNECTES ','L',JCNTES)
                   NCTE   = ZI(JCNTAN-1+3*(IN-1)+2)
                   JCNTE2 = ZI(JCNTAN-1+3*(IN-1)+3)
                   DO 70 JN=1,NCTE
C
C --- ON COMPARE LES NUMEROS DE CETTE LISTE � CELLE DE L'ARETE
C
                    NUNO(2)  = ZI(JCNTES-1 + JCNTE2 + JN)
                    IF ((NUNO(2).EQ.NGLO(1))
     &                       .OR.(NUNO(2).EQ.NGLO(2)))THEN
C
C --- SI C EGALE, ON NOTE LE NUMERO DE MAILLE, LE NUMERO LOCAL DE
C --- L'ARETE ET ON SORT
C
                      IAC = IAC + 1
                      ZI(JARCON-1+5*(IAC-1)+1) = IFISS
                      ZI(JARCON-1+5*(IAC-1)+2) = IN
                      ZI(JARCON-1+5*(IAC-1)+3) = IMA
                      ZI(JARCON-1+5*(IAC-1)+4) = IA
                      ZI(JARCON-1+5*(IAC-1)+5) = JN
                      GOTO 20
                     ENDIF
 70                CONTINUE
                 ENDIF
 60             CONTINUE
               ENDIF
C
               GOTO 20
              ENDIF
 50          CONTINUE
 40         CONTINUE
          ENDIF
 20      CONTINUE
        ENDIF
       ENDIF
 10   CONTINUE
C
C --- CONVERSION CHAM_ELEM_S -> CHAM_ELEM
C
      CALL CESCEL(CHS2,LIGREL,'TOPOFA','PAINTER','OUI',IBID,'G',
     &                                           AINTER,'F',IBID)
C
      IF (NARCON.GT.0) THEN
C
C --- ON ECRIT LE VECTEUR DES ARETES CONECT�ES
C
        CALL WKVECT(CHAR(1:8)//'.CONTACT.CNCTE','G V I',4*NARCON,JCNTES)
        NCTE = 0
C
C --- ON BOUCLE SUR TOUT LES NOEUDS CONNECTANT, CHAQUE NOEUD
C --- CONNECTANT DEFINI UN GROUPE
C
        DO 80 IFISS = 1,NFISS
          FISS=ZK8(JFISS+IFISS-1)
          CALL JEEXIN(FISS(1:8)//'.CONNECTANT',IER)
          IF (IER.EQ.0) THEN
            GOTO 80
          ELSE
            CALL JELIRA(FISS(1:8)//'.CONNECTANT','LONMAX',NCTA,K8BID)
            DO 90 IN=1,NCTA/3
C
C --- ON BOUCLE SUR TOUTES LES ARETES CONNECTEES
C
              DO 100 IAC=1,NARCON
                IF ((ZI(JARCON-1+5*(IAC-1)+1).EQ.IFISS).AND.
     &              (ZI(JARCON-1+5*(IAC-1)+2).EQ.IN))        THEN
                  NCTE = NCTE+1
C
C --- DES QU'IL Y EN A UNE QUI CORRESPOND AU GROUPE EN COURS,
C --- ON LE STOQUE DANS CE GROUPE
C
                  ZI(JCNTES-1+4*(NCTE-1)+1) = ZI(JARCON-1+5*(IAC-1)+5)
                  ZI(JCNTES-1+4*(NCTE-1)+2) = INC + IN
                  ZI(JCNTES-1+4*(NCTE-1)+3) = ZI(JARCON-1+5*(IAC-1)+3)
                  ZI(JCNTES-1+4*(NCTE-1)+4) = ZI(JARCON-1+5*(IAC-1)+4)
                ENDIF
100           CONTINUE
 90         CONTINUE
            INC = INC + NCTA/3
          ENDIF
 80     CONTINUE
      ENDIF
C
C --- MENAGE
C
       DO 200 IFISS = 1,NFISS
         FISS=ZK8(JFISS+IFISS-1)
         CALL JEEXIN(FISS(1:8)//'.CONNECTANT',IER)
         IF (IER.NE.0) THEN
           CALL JEDETR(FISS(1:8)//'.CONNECTANT')
           CALL JEDETR(FISS(1:8)//'.CONNECTES ')
         ENDIF
200     CONTINUE
      IF (NARCON.GT.0) THEN
        CALL JEDETR('&&XBARVI.ARCON')
      ENDIF
      CALL DETRSD('CHAM_ELEM_S',CHS1)
      CALL DETRSD('CHAM_ELEM_S',CHS2)
C
      CALL JEDEMA()
      END
