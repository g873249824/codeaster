      SUBROUTINE MAJOU(MODEL,MODMEC,SOLVEU,
     &         NUM,NU,MA,MATE,MOINT,NDBLE,ICOR,TABAD)
      IMPLICIT NONE
C---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C---------------------------------------------------------------------
C     AUTEUR : G.ROUSSEAU
C     ROUTINE REALISANT ,
C     A PARTIR D'UN MODELE GENERALISE, LE CALCUL MASSE AJOUTE.
C     IN: K2 : MODEL : CHARACTER TRADUISANT LA DIMENSION DU FLUIDE
C     IN: K8 : MODMEC : NOM DU CONCEPT MODE_MECA RESTITUE SUR MAILLAGE
C              SQUELETTE
C     IN : K14 : NU :NUMEROTATION ASSOCIEE AU MODELE FLUIDE
C     IN : K14 : NUM :NUMEROTATION ASSOCIEE AU MODELE INTERFACE
C     IN : K8 : MA : MATRICE DE RAIDEUR DU FLUIDE
C     IN : K8 : MOINT: MODELE INTERFACE
C     IN : I : IADX,IADY,IADZ : ADRESSES DES VECTEURS DE NOMS
C              DES CHAMNOS ASSOCIES PAR CMP DE DEPLACEMENT ET
C              PAR MODE D UNE SOUS STRUCTURE DONNEE D INDICE ISST
C     IN : I : IADRP : ADRESSE DU TABLEAU D ADRESSES DES VECTEURS
C              CONTENANT LES NOMS DES CHAMPS DE PRESSION
C     IN : I : ICOR(2) : TABLEAU CONTENANT LES ADRESSES
C                        JEVEUX DE TABLEAUX D'ENTIER
C              INDIQUANT LA CORRESPONDANCE ENTRE NOEUDS DE STRUCTURE
C              ET DE FLUIDE
C     IN: I: NDBLE: INDICATEUR DE RECHERCHE DE NOEUDS DOUBLES
C---------------------------------------------------------------------
      INCLUDE 'jeveux.h'
      INTEGER       NBVALE,NBREFE,NBDESC,IBID,NBID,NBMODE,ILIRES
      INTEGER       I,ICOR(2),NDBLE,TABAD(5),JJ,KK
      REAL*8        CONST(2)
      CHARACTER*1   TYPECH(2),TYPCST(2),KBID
      CHARACTER*2   MODEL
      CHARACTER*6   CHAINE
      CHARACTER*8   NOMCH(2)
      CHARACTER*8   MOINT,MA,K8BID,MAFLUI,MODMEC
      CHARACTER*8   MAILLA
      CHARACTER*14  NU,NUM
      CHARACTER*19  CHCOMB,VESTOC
      CHARACTER*19  VESOLX,VESOLY,VEPR,VESOLZ,TAMPON,CHCMB2
      CHARACTER*19  CHFLU,CHAMNX,CHAMNY,CHAMNZ,SOLVEU
      CHARACTER*24  NOMCHA
      CHARACTER*(*) MATE
      COMPLEX*16    CBID
      INTEGER       NBSEL,IDSEL,N15,N16,SEL,II
      INTEGER VALI
      CHARACTER*20  TEMPOR
      INTEGER      IARG
C
C -----------------------------------------------------------------
C-----------------------------------------------------------------
C ON RECUPERE LE NOMBRE DE MODES DANS LE MODE_MECA
C DEFINI
C-----------------------------------------------------------------------
      INTEGER IADIRG ,IADPR ,IADX ,IADY ,IADZ ,IDESP ,IERD 
      INTEGER IREFP ,IRET ,IVALP ,JCHFLU ,JORDR ,JPARA ,NBNUMO 

      REAL*8 BID ,EBID 
C-----------------------------------------------------------------------
      CALL JEMARQ()
C
C     INITIALISATIONS
      TEMPOR = '&&MAJOU.NUMODE'
      VEPR   = '&&MAJOU.VEPR'
      CHCOMB = '&&CHCOMB'
      CHCMB2 = '&&CHCMB2'
      CHFLU =  '&&MAJOU.CHFLU'
      VESOLX = '&&VEMAJX'
      VESOLY = '&&VEMAJY'
      VESOLZ = '&&VEMAJZ'
      CHAMNX = '&&MAJOU.CHAMNX'
      CHAMNY = '&&MAJOU.CHAMNY'
      CHAMNZ = '&&MAJOU.CHAMNZ'
C
      CALL RSORAC(MODMEC,'LONUTI',IBID,BID,K8BID,CBID,EBID,'ABSOLU',
     +             NBMODE,1,NBID)


C CREATION DE VECTEURS CONTENANT LES NOMS DES VECTEURS DE CHAMP AUX
C NOEUDS DE DEPLACEMENTS SUIVANT OX  OY  OZ AINSI QUE LE CHAMP DE
C PRESSION ASSOCIE A CHAQUE MODE PROPRE

        CALL JECREO('&&MAJOU.TXSTO','V V K24')
        CALL JEECRA('&&MAJOU.TXSTO','LONMAX',NBMODE,K8BID)
        CALL JEECRA('&&MAJOU.TXSTO','LONUTI',NBMODE,K8BID)
        CALL JEVEUT('&&MAJOU.TXSTO','E',IADX)
        CALL JECREO('&&MAJOU.TYSTO','V V K24')
        CALL JEECRA('&&MAJOU.TYSTO','LONMAX',NBMODE,K8BID)
        CALL JEECRA('&&MAJOU.TYSTO','LONUTI',NBMODE,K8BID)
        CALL JEVEUT('&&MAJOU.TYSTO','E',IADY)
         IF(MODEL.EQ.'3D') THEN
          CALL JECREO('&&MAJOU.TZSTO','V V K24')
          CALL JEECRA('&&MAJOU.TZSTO','LONMAX',NBMODE,K8BID)
          CALL JEECRA('&&MAJOU.TZSTO','LONUTI',NBMODE,K8BID)
          CALL JEVEUT('&&MAJOU.TZSTO','E',IADZ)
         ENDIF
        CALL JECREO('&&MAJOU.PRES','V V K24')
        CALL JEECRA('&&MAJOU.PRES','LONMAX',NBMODE,K8BID)
        CALL JEECRA('&&MAJOU.PRES','LONUTI',NBMODE,K8BID)
        CALL JEVEUT('&&MAJOU.PRES','E',IADPR)
C
        CALL JECREO('&&TABIRG','V V I')
        CALL JEECRA('&&TABIRG','LONMAX',NBMODE,K8BID)
        CALL JEECRA('&&TABIRG','LONUTI',NBMODE,K8BID)
        CALL JEVEUT('&&TABIRG','E',IADIRG)
C
        DO 6 I=1,NBMODE
          ZI(IADIRG+I-1)=I
6       CONTINUE

C FORMATION DU TABLEAU DES ADRESSES DES TABLEAUX

        TABAD(1)=IADX
        TABAD(2)=IADY
        TABAD(3)=IADZ
        TABAD(4)=IADPR
        TABAD(5)=IADIRG

C RECUPERATION DES NOMS DE MAILLAGES
        CALL RSEXCH(MODMEC,'DEPL',1,NOMCHA,IRET)
        CALL DISMOI('F','NOM_MAILLA',NOMCHA(1:19),
     +              'CHAM_NO',IBID,MAILLA,IERD)
        CALL DISMOI('F','NOM_MAILLA',MOINT,
     +              'MODELE',IBID,MAFLUI,IERD)

C RECUPERATION DES MODES SELECTIONNES

      CALL GETVIS(' ','NUME_MODE_MECA',0,IARG,0,SEL,N15)
      NBSEL=-1*N15
      IF(NBSEL.GT.0) THEN
        CALL WKVECT(TEMPOR,'V V I',NBSEL,IDSEL)
        CALL GETVIS(' ','NUME_MODE_MECA',0,IARG,NBSEL,ZI(IDSEL),N16)
      ENDIF

C VERIFICATION QUE LES NUMEROS DES MODES DONNES PAR L'USER
C CORRESPONDENT A DES NUMEROS EXISTANTS DANS LES LES MODES
C UTILISES
C      CALL JEVEUO(MODMEC//'           .NUMO','L',INUMO)
       CALL JELIRA(MODMEC//'           .ORDR','LONMAX',NBNUMO,KBID)
       CALL JEVEUO(MODMEC//'           .ORDR','L',JORDR)
       DO 100 JJ=1,NBSEL
         DO 200 KK=1,NBNUMO
           CALL RSADPA(MODMEC,'L',1,'NUME_MODE',ZI(JORDR-1+KK),0,
     &                 JPARA,K8BID)
           IF(ZI(IDSEL+JJ-1).EQ.ZI(JPARA)) GOTO 100
200      CONTINUE
         VALI = ZI(IDSEL+JJ-1)
         CALL U2MESG('F', 'ALGORITH13_35',0,' ',1,VALI,0,0.D0)
100    CONTINUE



C
C BOUCLE SUR LE NOMBRES DE MODES
C
        DO 1  ILIRES=1 ,NBMODE


C SORTIE DE BOUCLE POUR LES MODES NON-SELECTIONNES
          IF(NBSEL.GT.0) THEN
             DO 2 II=0,NBSEL-1
               IF(ILIRES.EQ.ZI(IDSEL+II)) GOTO 22
    2        CONTINUE
            GOTO 1
   22     CONTINUE
          ENDIF


          CALL RSEXCH(MODMEC,'DEPL',ILIRES,NOMCHA,IRET)
          CALL ALIMRS(MATE,MAILLA,MAFLUI,MOINT,NDBLE,NUM,NOMCHA(1:19),
     &              CHAMNX, 'DX',ICOR)
          CALL ALIMRS(MATE,MAILLA,MAFLUI,MOINT,NDBLE,NUM,NOMCHA(1:19),
     &               CHAMNY, 'DY',ICOR)
          IF(MODEL.EQ.'3D') THEN
            CALL ALIMRS(MATE,MAILLA,MAFLUI,MOINT,NDBLE,NUM,NOMCHA(1:19),
     &                 CHAMNZ, 'DZ',ICOR)
          ENDIF



C---------ON TRANSPORTE CE MODE TRANSFORME EN TEMPERATURE
C-----SUR LES CONTOURS DE LA INTERFACE FLUIDE

           TYPCST(1) ='R'
           TYPCST(2) ='R'

           CONST(1) =1.0D0
           CONST(2) =1.0D0

           TYPECH(1) ='R'
           TYPECH(2) ='R'

           NOMCH(1) = VESOLX(1:8)
           NOMCH(2) = VESOLY(1:8)


          CALL CALFLU(CHAMNX,MOINT,MATE,NUM,VESOLX,NBDESC,NBREFE,
     +                 NBVALE,'X')
        CALL CALFLU(CHAMNY,MOINT,MATE,NUM,VESOLY,NBDESC,NBREFE,
     +                 NBVALE,'Y')

        VESTOC='&&MAJOU.TPXSTO'
        CALL PRSTOC(CHAMNX,VESTOC,ILIRES,ILIRES,IADX,
     +                  NBVALE,NBREFE,NBDESC)

        VESTOC='&&MAJOU.TPYSTO'
        CALL PRSTOC(CHAMNY,VESTOC,ILIRES,ILIRES,IADY,
     +                NBVALE,NBREFE,NBDESC)

          IF (MODEL.EQ.'3D') THEN
            CALL CALFLU(CHAMNZ,MOINT,MATE,NUM,VESOLZ,NBDESC,NBREFE,
     +                 NBVALE,'Z')
            VESTOC='&&MAJOU.TPZSTO'
            CALL PRSTOC(CHAMNZ,VESTOC,ILIRES,ILIRES,IADZ,
     &                                    NBVALE,NBREFE,NBDESC)
          ENDIF

C---ON RECOMBINE LES DEUX (TROIS)CHAMPS AUX NOEUDS DE TEMP ET ON CALCULE
C-----LE FLUX FLUIDE TOTAL.....


           CALL VTCMBL(2,TYPCST,CONST,TYPECH,NOMCH,'R',CHCOMB)

           IF(MODEL.EQ.'3D') THEN

             TYPCST(1) ='R'
             TYPCST(2) ='R'

             CONST(1) =1.0D0
             CONST(2) =1.0D0

             TYPECH(1) ='R'
             TYPECH(2) ='R'

             NOMCH(1) = CHCOMB
             NOMCH(2) = VESOLZ(1:8)

             CALL VTCMBL(2,TYPCST,CONST,TYPECH,NOMCH,'R',CHCMB2)

           ENDIF

           IF(MODEL.EQ.'3D')THEN
            TAMPON=CHCMB2
           ELSE
            TAMPON=CHCOMB
           ENDIF

           CALL CHNUCN(TAMPON,NU,0,K8BID,'V',CHFLU)

C----ON RESOUT L EQUATION DE LAPLACE

           CALL JEVEUO(CHFLU//'.VALE','E',JCHFLU)
           CALL RESOUD(MA,' ',' ',SOLVEU,' ',' ',' ',
     &                  ' ',1,ZR(JCHFLU),CBID,.TRUE.)


C--------ON REPLONGE LA PRESSION SUR L INTERFACE
C-----------------QU 'ON STOCKE

           CALL CHNUCN(CHFLU,NUM,0,K8BID,'V',VEPR)

           VESTOC= '&&MAJOU.VESTOC'
           CALL PRSTOC(VEPR,VESTOC,ILIRES,ILIRES,IADPR,
     &                NBVALE,NBREFE,NBDESC)
1          CONTINUE
C
C CREATION DE TABLEAUX NULS POUR LA PRESSION ET LES
C DEPLACEMENTS DES MODES NON-SELECTIONNES
C
      IF(NBSEL.GT.0) THEN
        DO 3 ILIRES=1,NBMODE
          DO 33 II=0,NBSEL
             IF(ILIRES.EQ.ZI(IDSEL+II)) GOTO 3
   33     CONTINUE

          CHAINE = 'CBIDON'
          CALL CODENT(ILIRES,'D0',CHAINE(1:5))

C TABLEAUX POUR LA PRESSION

          VESTOC= '&&MAJOU.VESTOC'
          ZK24(IADPR+ILIRES-1) = VESTOC(1:14)//CHAINE(1:5)
          CALL WKVECT(ZK24(IADPR+ILIRES-1)(1:19)//'.VALE',
     +                'V V R',NBVALE,IVALP)
          CALL WKVECT(ZK24(IADPR+ILIRES-1)(1:19)//'.REFE',
     +                'V V K24',NBREFE,IREFP)
          CALL WKVECT(ZK24(IADPR+ILIRES-1)(1:19)//'.DESC',
     +                'V V I',NBDESC,IDESP)

C TABLEAUX POUR LES DEPLACEMENTS EN X

          VESTOC= '&&MAJOU.TPXSTO'
          ZK24(IADX+ILIRES-1) = VESTOC(1:14)//CHAINE(1:5)
          CALL WKVECT(ZK24(IADX+ILIRES-1)(1:19)//'.VALE',
     +                'V V R',NBVALE,IVALP)
          CALL WKVECT(ZK24(IADX+ILIRES-1)(1:19)//'.REFE',
     +                'V V K24',NBREFE,IREFP)
          CALL WKVECT(ZK24(IADX+ILIRES-1)(1:19)//'.DESC',
     +                'V V I',NBDESC,IDESP)

C TABLEAUX POUR LES DEPLACEMENTS EN Y

          VESTOC= '&&MAJOU.TPYSTO'
          ZK24(IADY+ILIRES-1) = VESTOC(1:14)//CHAINE(1:5)
          CALL WKVECT(ZK24(IADY+ILIRES-1)(1:19)//'.VALE',
     +                'V V R',NBVALE,IVALP)
          CALL WKVECT(ZK24(IADY+ILIRES-1)(1:19)//'.REFE',
     +                'V V K24',NBREFE,IREFP)
          CALL WKVECT(ZK24(IADY+ILIRES-1)(1:19)//'.DESC',
     +                'V V I',NBDESC,IDESP)

C TABLEAUX POUR LES DEPLACEMENTS EN Z

          IF(MODEL.EQ.'3D') THEN
            VESTOC= '&&MAJOU.TPZSTO'
            ZK24(IADZ+ILIRES-1) = VESTOC(1:14)//CHAINE(1:5)
            CALL WKVECT(ZK24(IADZ+ILIRES-1)(1:19)//'.VALE',
     +                  'V V R',NBVALE,IVALP)
            CALL WKVECT(ZK24(IADZ+ILIRES-1)(1:19)//'.REFE',
     +                  'V V K24',NBREFE,IREFP)
            CALL WKVECT(ZK24(IADZ+ILIRES-1)(1:19)//'.DESC',
     +                  'V V I',NBDESC,IDESP)
          ENDIF

    3   CONTINUE
      ENDIF

      CALL JEDETC('V',TEMPOR,1)
      CALL JEDETC('V',VEPR,1)
      CALL JEDETC('V',CHCOMB,1)
      CALL JEDETC('V',CHCMB2,1)
      CALL JEDETC('V',CHFLU,1)
      CALL JEDETC('V',VESOLX,1)
      CALL JEDETC('V',VESOLY,1)
      CALL JEDETC('V',VESOLZ,1)
      CALL JEDETC('V',CHAMNX,1)
      CALL JEDETC('V',CHAMNY,1)
      CALL JEDETC('V',CHAMNZ,1)

      CALL JEDEMA()
      END
