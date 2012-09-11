      SUBROUTINE NMOBS2(NOMA  ,SDOBSE,NOMTAB,NUMINS,INSTAN,
     &                  TITOBS,TYPCHA,NOMCHA,NOMCHS,NBMA  ,
     &                  NBNO  ,NBPI  ,NBSPI ,NBCMP ,EXTRGA,
     &                  EXTRCH,EXTRCP,LISTNO,LISTMA,LISTPI,
     &                  LISTSP,LISTCP,CHAMP ,CHNOEU,CHELGA,
     &                  NOBSEF)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/09/2012   AUTEUR LADIER A.LADIER 
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
C TOLE CRP_21
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT      NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8   NOMA
      CHARACTER*24  NOMCHA,NOMCHS
      CHARACTER*19  SDOBSE,NOMTAB
      CHARACTER*80  TITOBS
      INTEGER       NBCMP,NBNO,NBMA
      INTEGER       NBPI,NBSPI,NOBSEF
      CHARACTER*4   TYPCHA
      INTEGER       NUMINS
      REAL*8        INSTAN
      CHARACTER*24  LISTNO,LISTMA,LISTPI,LISTCP,LISTSP
      CHARACTER*8   EXTRGA,EXTRCH,EXTRCP
      CHARACTER*19  CHNOEU,CHELGA
      CHARACTER*19  CHAMP
C
C ----------------------------------------------------------------------
C
C ROUTINE *_NON_LINE (OBSERVATION - UTILITAIRE)
C
C EXTRAIRE LES VALEURS - SAUVEGARDE DANS LA TABLE
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  TITOBS : TITRE DE L'OBSERVATION
C IN  TYPCHA : TYPE DU CHAMP
C IN  NOMCHA : NOM DU CHAMP
C IN  NOMCHS : NOM DU CHAMP SIMPLE
C IN  NBCMP  : NOMBRE DE COMPOSANTES DANS LA SD
C IN  NBNO   : NOMBRE DE NOEUDS DANS LA SD
C IN  NBMA   : NOMBRE DE MAILLES DANS LA SD
C IN  NBPI   : NOMBRE DE POINTS D'INTEGRATION
C IN  NBSPI  : NOMBRE DE SOUS-POINTS D'INTEGRATION
C IN  EXTRGA : TYPE D'EXTRACTION SUR UNE MAILLE
C IN  EXTRCH : TYPE D'EXTRACTION SUR LE CHAMP
C IN  EXTRCP : TYPE D'EXTRACTION SUR LES COMPOSANTES
C IN  LISTNO : LISTE CONTENANT LES NOEUDS
C IN  LISTMA : LISTE CONTENANT LES MAILLES
C IN  LISTCP : LISTE DES COMPOSANTES
C IN  LISTPI : LISTE CONTENANT LES POINTS D'EXTRACTION
C IN  LISTSP : LISTE CONTENANT LES SOUS-POINTS D'EXTRACTION
C IN  CHAMP  : CHAMP A EXTRAIRE
C IN  CHNOEU : VECTEUR DE TRAVAIL CHAMPS AUX NOEUDS
C IN  CHELGA : VECTEUR DE TRAVAIL CHAMPS AUX ELEMENTS
C IN  NUMINS : NUMERO DE L'INSTANT COURANT
C I/O NOBSEF : NOMBRE EFFECTIF D'OBSERVATIONS
C
C ----------------------------------------------------------------------
C
      INTEGER      NPARX
      PARAMETER    (NPARX=20)
      CHARACTER*8  NOMPAR(NPARX)
C
      INTEGER      INO,IMA,IPI,ISPI,ICMP
      INTEGER      NBNOR,NBMAR,IRET
      INTEGER      IVALCP,JCESD
      REAL*8       VALR
      INTEGER      NVALCP
      INTEGER      NUM,SNUM,NPI,NSPI,NMAPT,NMASPT,NBPIR,NBSPIR
      INTEGER      NUMNOE,NUMMAI
      CHARACTER*8  NOMNOE,NOMMAI,NOMCMP
      INTEGER      JNO,JMA,JPI,JSPI,JNOEU,JELGA,JCMP
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- PASSAGE EN CHAM_ELEM_S
C
      IF (TYPCHA.EQ.'ELGA') THEN
        CALL JEEXIN(NOMCHS,IRET)
        IF (IRET.EQ.0) THEN
          CALL SDMPIC('CHAM_ELEM',CHAMP )
          CALL CELCES(CHAMP ,'V',NOMCHS)
        ENDIF
        CALL JEVEUO(NOMCHS(1:19)//'.CESD','L',JCESD)
      ENDIF
C
C --- NOMBRE DE NOEUDS POUR LA BOUCLE
C
      IF (TYPCHA.EQ.'NOEU') THEN
        IF (EXTRCH.EQ.'VALE') THEN
          NBNOR  = NBNO
        ELSEIF ((EXTRCH.EQ.'MIN').OR.
     &          (EXTRCH.EQ.'MAX').OR.
     &          (EXTRCH.EQ.'MAXI_ABS').OR.
     &          (EXTRCH.EQ.'MINI_ABS').OR.
     &          (EXTRCH.EQ.'MOY')) THEN
          NBNOR = 1
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ENDIF
C
C --- NOMBRE DE MAILLES POUR LA BOUCLE
C
      IF (TYPCHA.EQ.'ELGA') THEN
        IF (EXTRCH.EQ.'VALE') THEN
          NBMAR  = NBMA
        ELSEIF ((EXTRCH.EQ.'MIN').OR.
     &          (EXTRCH.EQ.'MAX').OR.
     &          (EXTRCH.EQ.'MAXI_ABS').OR.
     &          (EXTRCH.EQ.'MINI_ABS').OR.
     &          (EXTRCH.EQ.'MOY')) THEN
          NBMAR = 1
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ENDIF
C
C --- NOMBRE DE COMPOSANTES POUR LA BOUCLE
C
      IF (EXTRCP.EQ.' ') THEN
        NVALCP    = NBCMP
      ELSE
        NVALCP    = 1
      ENDIF
C
C --- RECOPIE DU NOM DES COMPOSANTES
C
      CALL JEVEUO(LISTCP,'L',JCMP  )
      DO 280 ICMP = 1,NBCMP
        NOMPAR(ICMP) = ZK8(JCMP-1+ICMP)
 280  CONTINUE
C
C --- VALEUR NODALES
C
      IF (TYPCHA.EQ.'NOEU') THEN
        CALL JEVEUO(CHNOEU,'L',JNOEU)
        CALL JEVEUO(LISTNO,'L',JNO  )
C
        DO 20 INO = 1,NBNOR
C
C ------- NOEUD COURANT
C
          NUMNOE  = ZI(JNO-1+INO)
          CALL JENUNO(JEXNUM(NOMA(1:8)//'.NOMNOE',NUMNOE),NOMNOE)
C
C ------- ECRITURE DES VALEURS
C
          DO 21 IVALCP = 1,NVALCP
            VALR = ZR(JNOEU+IVALCP-1
     &                     +NBCMP*(INO-1))
            NOMCMP = NOMPAR(IVALCP)
            CALL NMOBSZ(SDOBSE,NOMTAB,TITOBS,NOMCHA,TYPCHA,
     &                  EXTRCH,EXTRCP,EXTRGA,NOMCMP,NOMNOE,
     &                  NOMMAI,NUM   ,SNUM  ,NUMINS,INSTAN,
     &                  VALR  )
            NOBSEF = NOBSEF + 1
  21      CONTINUE
  20    CONTINUE
      ENDIF
C
C --- VALEURS AUX POINTS DE GAUSS
C
      IF (TYPCHA.EQ.'ELGA') THEN
        CALL JEVEUO(CHELGA,'L',JELGA)
        CALL JEVEUO(LISTMA,'L',JMA)
        CALL JEVEUO(LISTPI,'L',JPI)
        CALL JEVEUO(LISTSP,'L',JSPI)
C
C ----- BOUCLE SUR LES MAILLES
C
        DO 30 IMA = 1,NBMAR
C
C ------- MAILLE COURANTE
C
          NUMMAI  = ZI(JMA-1+IMA)
          CALL JENUNO(JEXNUM(NOMA(1:8)//'.NOMMAI',NUMMAI),NOMMAI)
C
C ------- NOMBRE EFFECTIF DE POINTS/SOUS-POINTS SUR LA MAILLE
C
          NMAPT  = ZI(JCESD+5+4*(NUMMAI-1))
          NMASPT = ZI(JCESD+5+4*(NUMMAI-1)+1)
C
C ------- PLAFONNEMENT
C
          NPI    = NBPI
          NSPI   = NBSPI
          IF (NPI.GT.NMAPT)   NPI  = NMAPT
          IF (NSPI.GT.NMASPT) NSPI = NMASPT
C
C ------- NOMBRE DE POINTS/SOUS-POINTS POUR LA BOUCLE
C
          IF (EXTRGA.EQ.'VALE') THEN
            NBPIR  = NPI
            NBSPIR = NSPI
          ELSE
            NBPIR  = 1
            NBSPIR = 1
          ENDIF
C
C ------- BOUCLE SUR LES POINTS/SOUS_POINTS
C
          DO 45 IPI = 1,NBPIR
            DO 46 ISPI = 1,NBSPIR
C
C ----------- NUMERO DES POINTS/SOUS-POINTS
C
              IF (EXTRGA.EQ.'VALE') THEN
                NUM    = ZI(JPI-1+IPI  )
                SNUM   = ZI(JSPI-1+ISPI )
              ELSE
                NUM    = IPI
                SNUM   = ISPI
              ENDIF
C
C ----------- LECTURE DES VALEURS
C
              DO 47 IVALCP = 1,NVALCP
                VALR = ZR(JELGA+NBCMP*NBPI*NBSPI*(IMA-1)
     &                   +NBPI*NBSPI*(IVALCP-1)
     &                   +NBSPI*(IPI-1)
     &                   +(ISPI-1))
                NOMCMP = NOMPAR(IVALCP)
                CALL NMOBSZ(SDOBSE,NOMTAB,TITOBS,NOMCHA,TYPCHA,
     &                      EXTRCH,EXTRCP,EXTRGA,NOMCMP,NOMNOE,
     &                      NOMMAI,NUM   ,SNUM  ,NUMINS,INSTAN,
     &                      VALR  )
                NOBSEF = NOBSEF + 1
  47          CONTINUE
  46        CONTINUE
  45      CONTINUE
  30    CONTINUE
      ENDIF
C
      CALL JEDEMA()
C
      END
