      SUBROUTINE CREVGE(LIGREL,BAS1)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 18/09/2012   AUTEUR PELLET J.PELLET 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT NONE
C-----------------------------------------------------------------------
C BUT : CREE UNE SD_VOISINAGE DANS UNE SD_LIGREL
C
C  IN/JXVAR   LIGREL      : LIGREL
C
C  LA STRUCTURE VGE CREE A LES LIMITES SUIVANTES :
C   ON NE TRAITE QUE LES ELEMENTS QUI ONT LA DIMENSION MAXIMALE :
C         3 S'IL Y A DES ELEMENTS 3D
C         2 S'IL Y A DES ELEMENTS 2D ET PAS DE 3D
C   POUR CHAQUE ELEMENT ON NE STOQUE QUE SES VOISINS DE MEME DIMENSION.
C   EN D AUTRES TERMES
C      EN DIMENSION 3 ON TRAITE LES TYPES
C           F3 (3D PAR FACE)  A3 (3D PAR ARRETE)  ET S3 (3D PAR SOMMET)
C      EN DIMENSION 2 ON TRAITE LES TYPES
C           A2  (2D PAR ARRETE)  ET S2 (2D PAR SOMMET)
C-----------------------------------------------------------------------

      INCLUDE 'jeveux.h'
      CHARACTER*19 LIGREL
      CHARACTER*1 BAS1
      CHARACTER*12 VGE
      INTEGER IADDVO,IADVOI

      CHARACTER*24 TYPMAI,CONNEX,CONINV,PTVOIS,ELVOIS
      CHARACTER*8 MA,KBID,TYPEM0,TYPEMR
      CHARACTER*32 NO
      LOGICAL TROISD


      INTEGER NVOIMA,NSCOMA
      PARAMETER(NVOIMA=100,NSCOMA=4)
      INTEGER TOUVOI(1:NVOIMA,1:NSCOMA+2)
      INTEGER IV,IBID,NBMA,IER,DIM,DIMMA,IATYMA,M0,IS,ADCOM0,NBSOM0
      INTEGER NBMR,ADMAR,IR,NUMAR,NVTOT,IAD,DIMVLO,JNVGE
C
      CHARACTER*1 K1BID


C --------- CONSTRUCTION DE LA CONNECTIVITE INVERSE --------------------
C
      CALL JEMARQ()
      CALL DISMOI('F','NOM_MAILLA',LIGREL,'LIGREL',IBID,MA,IER)
      CALL DISMOI('F','NB_MA_MAILLA',MA,'MAILLAGE',NBMA,KBID,IER)
C
      TYPMAI=MA//'.TYPMAIL'
      CONNEX=MA//'.CONNEX'
C
C --------- RECHERCHE DES EVENTUELLES MAILLES 3D DANS LE MODELE --------
C     SI ON EN TROUVE DIM=3 SINON DIM=2 (CE QUI EXCLUE DIM=1 !!!)
C
      TROISD=.FALSE.
      CALL JEVEUO(TYPMAI,'L',IATYMA)
      DO 10 M0=1,NBMA
        IAD=IATYMA-1+M0
        CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ZI(IAD)),TYPEM0)
        CALL DIMMAI(TYPEM0,DIMMA)
        IF (DIMMA.EQ.3) THEN
          TROISD=.TRUE.
          GOTO 20

        ENDIF
   10 CONTINUE
   20 CONTINUE
      IF (TROISD) THEN
        DIM=3
      ELSE
        DIM=2
      ENDIF
      IF (NBMA.LT.1) THEN
        CALL U2MESG('F','VOLUFINI_5',0,' ',1,NBMA,0,0.D0)
      ENDIF
C
C --------- CREATION DU POINTEUR DE LONGUEUR DE CONINV ----------------
C
      CONINV='&&CREVGE.CONINV'
      CALL CNCINV(MA,IBID,0,'G',CONINV)

      TYPMAI=MA//'.TYPMAIL'
      CONNEX=MA//'.CONNEX'

      CALL WKVECT(LIGREL//'.NVGE',BAS1//' V K16',1,JNVGE)
      CALL GCNCON('_',VGE(1:8))
      VGE(9:12)='.VGE'
      ZK16(JNVGE-1+1)=VGE

      PTVOIS=VGE//'.PTVOIS'
      ELVOIS=VGE//'.ELVOIS'


      CALL WKVECT(PTVOIS,BAS1//' V I',NBMA+1,IADDVO)
      ZI(IADDVO)=0

C
      CALL JEVEUO(TYPMAI,'L',IATYMA)
C
C     DIMENSIONNEMENT DE L OBJET CONTENANT LES VOISINS : ELVOIS
C
C
C --------- BOUCLE SUR LES MAILLES  ----------------
C
      DO 70 M0=1,NBMA
        CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ZI(IATYMA-1+M0)),TYPEM0)
        CALL DIMMAI(TYPEM0,DIMMA)
C
C  ON NE TRAITE QUE LES MAILLES DONT LA DIM EST CELLE DE L ESPACE
C
        IF (DIMMA.EQ.DIM) THEN
C --------- REMISE ZERO TOUVOI
          NVTOT=0
          DO 40 IV=1,NVOIMA
            DO 30 IS=1,NSCOMA+2
              TOUVOI(IV,IS)=0
   30       CONTINUE
   40     CONTINUE
          CALL JEVEUO(JEXNUM(CONNEX,M0),'L',ADCOM0)
          CALL NBSOMM(TYPEM0,NBSOM0)
C
C      REMPLISSAGE DU TABLEAU DE POINTEURS
C
C --------- BOUCLE SUR LES SOMMETS  ----------------
C
          DO 60 IS=1,NBSOM0
            NO=JEXNUM(CONINV,ZI(ADCOM0-1+IS))
C  NBMR NOMBRE DE MAILLES RELIEES AU SOMMET
            CALL JELIRA(NO,'LONMAX',NBMR,K1BID)
            CALL JEVEUO(NO,'L',ADMAR)
            IF (NBMR.GT.1) THEN
              DO 50 IR=1,NBMR
C  NUMAR NUMERO DE LA MAILLE RELIEE AU SOMMET
                NUMAR=ZI(ADMAR-1+IR)
                CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ZI(IATYMA-1+NUMAR)),
     &                      TYPEMR)
                CALL DIMMAI(TYPEMR,DIMMA)
C
C  ON NE STOQUE QUE LES VOISINS DE MEME DIMENTION

C
                IF (NUMAR.NE.M0 .AND. (DIMMA.EQ.DIM)) THEN
C  -- AJOUT DE NUMAR A TOUVOI POUR M0
                  CALL ADLIVO(M0,NUMAR,IS,NVTOT,NVOIMA,NSCOMA,TOUVOI)
                ENDIF
   50         CONTINUE
            ENDIF
   60     CONTINUE
          CALL DIMVOI(NVTOT,NVOIMA,NSCOMA,TOUVOI,DIMVLO)
        ELSE
C
C      POUR LES ELEMENTS NON TARITES ON ECRIT QUAND MEME
C      QUE LE NOMBRE DE VOISINS EST NUL
C
          DIMVLO=1
        ENDIF
        ZI(IADDVO+M0)=ZI(IADDVO+M0-1)+DIMVLO
   70 CONTINUE
C
C  ON PEUT MAINTENANT ALLOUER ET REMPLIR CET OBJET
C
      CALL WKVECT(ELVOIS,BAS1//' V I',ZI(IADDVO+NBMA),IADVOI)
C --------- BOUCLE SUR LES MAILLES  ----------------
C
      DO 120 M0=1,NBMA
        CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ZI(IATYMA-1+M0)),TYPEM0)
        CALL DIMMAI(TYPEM0,DIMMA)
C
C  ON NE TRAITE QUE LES MAILLES DONT LA DIM EST CELLE DE L ESPACE
C
        IF (DIMMA.EQ.DIM) THEN
C --------- REMISE ZERO TOUVOI
          NVTOT=0
          DO 90 IV=1,NVOIMA
            DO 80 IS=1,NSCOMA+2
              TOUVOI(IV,IS)=0
   80       CONTINUE
   90     CONTINUE
          CALL JEVEUO(JEXNUM(CONNEX,M0),'L',ADCOM0)
          CALL NBSOMM(TYPEM0,NBSOM0)
C
C --------- BOUCLE SUR LES SOMMETS  ----------------
C
          DO 110 IS=1,NBSOM0
            NO=JEXNUM(CONINV,ZI(ADCOM0-1+IS))
C  NBMR NOMBRE DE MAILLES RELIEES AU SOMMET
            CALL JELIRA(NO,'LONMAX',NBMR,K1BID)
            CALL JEVEUO(NO,'L',ADMAR)
            IF (NBMR.GT.1) THEN
              DO 100 IR=1,NBMR
C  NUMAR NUMERO DE LA MAILLE RELIEE AU SOMMET
                NUMAR=ZI(ADMAR-1+IR)
                CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ZI(IATYMA-1+NUMAR)),
     &                      TYPEMR)
                CALL DIMMAI(TYPEMR,DIMMA)
                IF (NUMAR.NE.M0 .AND. (DIMMA.EQ.DIM)) THEN
C  -- AJOUT DE NUMAR A TOUVOI POUR M0
                  CALL ADLIVO(M0,NUMAR,IS,NVTOT,NVOIMA,NSCOMA,TOUVOI)
                ENDIF
  100         CONTINUE
            ENDIF
  110     CONTINUE
          IAD=IADVOI+ZI(IADDVO+M0-1)
          CALL CRVLOC(DIM,M0,ADCOM0,IATYMA,CONNEX,ZI(IAD),NVTOT,NVOIMA,
     &                NSCOMA,TOUVOI)
        ELSE
C
C      POUR LES ELEMENTS NON TARITES ON ECRIT QUAND MEME
C      QUE LE NOMBRE DE VOISINS EST NUL
C
          ZI(IADVOI+ZI(IADDVO+M0-1))=0
        ENDIF
  120 CONTINUE


C      CALL IMPVOI(' VGE EN FIN DE CREVGE ',NBMA,IADDVO,IADVOI)
      CALL JEDETR(CONINV)
      CALL JEDEMA()

      END
