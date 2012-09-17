      SUBROUTINE CALMDG(MODEL,MODGEN,NUGENE,NUM,NU,MA,MATE,MOINT,
     &                  MOFLUI,NDBLE,
     &                  ITXSTO,ITYSTO,ITZSTO,IPRSTO,NBMO,IADIRG)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*(*)  MATE

C---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/09/2012   AUTEUR LADIER A.LADIER 
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
C TOLE CRP_6
C---------------------------------------------------------------------
C AUTEUR : G. ROUSSEAU
C ROUTINE CALCULANT :
C     A PARTIR D UN MODELE GENERALISE : CHAMPS DE
C     TEMPERATURE CORRESPONDANT A TOUS LES MODES
C     DE CHACUNE DES SOUS-STRUCTURES, ET LES CHAMPS DE PRESSION
C     ASSOCIES
C     IN: K2 : MODEL : CHARACTER TRADUISANT LA DIMENSION DU FLUIDE
C     IN: K8 : MODGEN : MODELE GENERALISE
C     IN : K14 : NUMEGE : NUMEROTATION DES DDLS GENERALISEES
C     IN : K14 : NUM :NUMEROTATION ASSOCIEE AU MODELE D INTERFACE
C     IN : K14 : NU :NUMEROTATION ASSOCIEE AU MODELE FLUIDE
C     IN : K8 : MA : MATRICE DE RAIDEUR DU FLUIDE
C     IN : K8 : MOINT,MOFLUI : MODELE INTERFACE, MODELE FLUIDE
C     IN : I : NDBLE :INDICATEUR DE RECHERCHE DE NOEUDS DOUBLES
C     OUT : INTEGER : ITXSTO,ITYSTO,ITZSTO,IPRSTO :
C           ADRESSE DU CHAMP DE TEMP
C     CORRESPONDANT A TOUS LES MODES
C     DE CHAQUE SSTRUCTURE,RESP. DECOMPOSE
C     SUIVANT DX PUIS DY PUIS DZ - CHAMP DE PRESSION ASSOCIE A UN MODE
C     OUT : NOMBRE DE MODES TOTAL (SOMME DES MODES CONTRAINTS ET
C     DYNAMIQUES DE CHACUNE DES SOUS-STRUCTURES )
C     OUT : INTEGER : IADIRG : ADRESSE DU TABLEAU CONTENANT
C           LE RANG DES DDLS GENERALISES HORS LAGRANGES
C
C---------------------------------------------------------------------
      INTEGER       IBID,NBID,ISST,IADRP
      INTEGER       I,J,ITXSTO,ITYSTO,IPRSTO
      INTEGER       ICOR(2),NDBLE
      REAL*8        TGEOM(6)
      REAL*8        NORM1,NORM2,RESTE(3),DEUXPI
      CHARACTER*2   MODEL
      CHARACTER*6   CHAINE
      CHARACTER*8   REPON,MOFLUI,MOINT,MA,K8BID
      CHARACTER*8   MODGEN,BAMO,MACEL,MAILLA,MAFLUI
      CHARACTER*14  NU,NUM
      CHARACTER*14  NUGENE
      CHARACTER*24  NOMCHA
      COMPLEX*16    CBID
      INTEGER      IARG
C -----------------------------------------------------------------
C---------------------------------------------------------------------

C-----------------------------------------------------------------------
      INTEGER IADIRG ,IADRX ,IADRY ,IADRZ ,IADX ,IADY ,IADZ
      INTEGER IBAMO ,ICOMPT ,IDELAT ,IERD ,IGEO ,ILIRES ,ILMAX
      INTEGER IMACL ,IMODG ,IND ,IOR ,IPRS ,IRANG ,IRET
      INTEGER IROT ,ITABL ,ITZSTO ,K ,NBMO ,NBMOD ,NBMODG
      INTEGER NBSST ,NN
      REAL*8 BID ,EBID
C-----------------------------------------------------------------------
      CALL JEMARQ()

C=====================================================================
C---------------------------------------------------------------------
C                 CALCUL SUR MODELE GENERALISE
C---------------------------------------------------------------------
C=====================================================================

        CALL JELIRA(MODGEN//'      .MODG.SSNO        '
     &           ,'NOMMAX',NBSST,K8BID)
        CALL GETVTX(' ','AVEC_MODE_STAT',0,IARG,1,REPON,NN)
        IF(REPON(1:3).EQ.'NON') THEN
           CALL DELAT(MODGEN,NBSST,NBMO)
           CALL JEVEUO('&&DELAT.INDIC','L',IDELAT)
        ENDIF

C CREATION DE TABLEAUX D ADRESSES PAR SOUS-STRUCTURES POUR LES
C NOMS DES CHAMNO DE DEPL_R PAR COMPOSANTES ET LA PRESSION

        CALL WKVECT('&&CALMDG.TABL_MODE','V V I',NBSST,ITABL)
        CALL WKVECT('&&CALMDG.TABL_ADRX','V V I',NBSST,IADRX)
        CALL WKVECT('&&CALMDG.TABL_ADRY','V V I',NBSST,IADRY)
        IF(MODEL.EQ.'3D') CALL WKVECT('&&CALMDG.TABL_ADRZ','V V I',
     &                                NBSST,IADRZ)
        CALL WKVECT('&&CALMDG.TABL_ADRP','V V I',NBSST,IADRP)
        CALL WKVECT('&&CALMDG.TABL_LONMAX','V V I',NBSST,ILMAX)


       ILIRES=0
       ICOMPT=0
       DO 1 ISST=1,NBSST
        K=0
        CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.SSME',ISST),
     &            'L',IMACL)
        MACEL=ZK8(IMACL)

        CALL JEVEUO(MACEL//'.MAEL_REFE','L',IBAMO)
        BAMO = ZK24(IBAMO)(1:8)

C TEST POUR DETERMINER SI FLUIDE ET STRUCTURE S APPUIENT SUR
C DES MAILLAGES COMMUNS

        CALL RSEXCH('F',BAMO,'DEPL',1,NOMCHA,IRET)
        CALL DISMOI('F','NOM_MAILLA',NOMCHA(1:19),
     &              'CHAM_NO',IBID,MAILLA,IERD)
        CALL DISMOI('F','NOM_MAILLA',MOINT,
     &              'MODELE',IBID,MAFLUI,IERD)
        IF (MAFLUI.NE.MAILLA) THEN
         CALL TABCOR(MODEL,MATE,MAILLA,MAFLUI,MOINT,NUM,NDBLE,ICOR)
        ENDIF

C RECUPERATION DES CMPS DE TRANSLATION

        CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.SSTR',ISST),
     &            'L',IGEO)

       TGEOM(1)=ZR(IGEO)
       TGEOM(2)=ZR(IGEO+1)
       TGEOM(3)=ZR(IGEO+2)

C RECUPERATION DES CMPS DE ROTATION

        CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.SSOR',ISST),
     &            'L',IROT)

       TGEOM(4)=ZR(IROT)
       TGEOM(5)=ZR(IROT+1)
       TGEOM(6)=ZR(IROT+2)

       NORM1 = SQRT(TGEOM(1)**2+TGEOM(2)**2+TGEOM(3)**2)

       DEUXPI = 4.0D0 * ACOS ( 0.0D0 )

       DO 3 IOR=1,3

            RESTE(IOR)=MOD(TGEOM(IOR+3),DEUXPI)

3      CONTINUE

       IF ((RESTE(1).EQ.0.0D0).AND.(RESTE(2).EQ.0.0D0).AND.
     &  (RESTE(3).EQ.0.0D0)) THEN
         NORM2 = 0.0D0
       ELSE
         NORM2 = 1.0D0
       ENDIF



C ON RECUPERE LE NOMBRE DE MODES DANS LA BASE MODALE DU MACRO-ELEMENT
C DEFINI

      CALL RSORAC(BAMO,'LONUTI',IBID,BID,K8BID,CBID,EBID,'ABSOLU',
     &             NBMODG,1,NBID)

      ZI(ITABL+ISST-1)=NBMODG

C CREATION DE VECTEURS CONTENANT LES NOMS DES VECTEURS DE CHAMP AUX
C NOEUDS DE DEPLACEMENTS SUIVANT OX  OY  OZ AINSI QUE LE CHAMP DE
C PRESSION ASSOCIE A CHAQUE MODE PROPRE OU CONTRAINT DE CHAQUE SST
C ON STOCKE LES ADRESSES DES VECTEURS DANS LES TABLEAUX D ADRESSES
C PRECEDEMMENT CREES

        CHAINE = 'CBIDON'

        CALL CODENT(ISST,'D0',CHAINE(1:6))
        CALL JECREO('&&CALMDG.TXSTO'//CHAINE,'V V K24')
        CALL JEECRA('&&CALMDG.TXSTO'//CHAINE,'LONMAX',NBMODG,K8BID)
        CALL JEECRA('&&CALMDG.TXSTO'//CHAINE,'LONUTI',NBMODG,K8BID)
        CALL JEVEUT('&&CALMDG.TXSTO'//CHAINE,'E',IADX)
        ZI(IADRX+ISST-1)=IADX
        CALL JECREO('&&CALMDG.TYSTO'//CHAINE,'V V K24')
        CALL JEECRA('&&CALMDG.TYSTO'//CHAINE,'LONMAX',NBMODG,K8BID)
        CALL JEECRA('&&CALMDG.TYSTO'//CHAINE,'LONUTI',NBMODG,K8BID)
        CALL JEVEUT('&&CALMDG.TYSTO'//CHAINE,'E',IADY)
        ZI(IADRY+ISST-1)=IADY
        IF(MODEL.EQ.'3D') THEN
          CALL JECREO('&&CALMDG.TZSTO'//CHAINE,'V V K24')
          CALL JEECRA('&&CALMDG.TZSTO'//CHAINE,'LONMAX',NBMODG,K8BID)
          CALL JEECRA('&&CALMDG.TZSTO'//CHAINE,'LONUTI',NBMODG,K8BID)
          CALL JEVEUT('&&CALMDG.TZSTO'//CHAINE,'E',IADZ)
        ZI(IADRZ+ISST-1)=IADZ
        ENDIF
        CALL JECREO('&&CALMDG.PRES'//CHAINE,'V V K24')
        CALL JEECRA('&&CALMDG.PRES'//CHAINE,'LONMAX',NBMODG,K8BID)
        CALL JEECRA('&&CALMDG.PRES'//CHAINE,'LONUTI',NBMODG,K8BID)
        CALL JEVEUT('&&CALMDG.PRES'//CHAINE,'E',IPRS)
        ZI(IADRP+ISST-1)=IPRS

C RECUPERATION DES MODES PROPRES ET CONTRAINTS AUQUELS ON
C FAIT SUBIR ROTATION ET TRANSLATION DEFINIES DANS LE MODELE
C GENERALISE. CETTE ROUTINE PERMET AUSSI LE TRANSPORT
C D UNE SOUS STRUCTURE A UNE AUTRE DES CHAMPS AUX NOEUDS
C CALCULES SUR UNE SEULE SOUS STRUCTURE

         DO 2, IMODG=1,NBMODG
      ICOMPT=ICOMPT+1

      IF (REPON(1:3).EQ.'NON') THEN
       IF(ZI(IDELAT+ICOMPT-1).NE.1) GOTO 2
      ENDIF

      CALL TRPROT(MODEL,BAMO,TGEOM,IMODG,IADX,IADY,IADZ,ISST,IADRP,
     &            NORM1,NORM2,NDBLE,NUM,NU,MA,MATE,MOINT,
     &            ILIRES,K,ICOR)


2       CONTINUE

C DESTRUCTION DU TABLEAU DES CORRESPONDANCES

        CALL JEDETR('&&TABCOR.CORRE1')

        IF (NDBLE.EQ.1) CALL JEDETR('&&TABCOR.CORRE2')

1      CONTINUE

C----------------------------------------------------------------
C CALCUL DU NOMBRE DE MODES TOTAL

       NBMO=0
       DO 4 ISST=1,NBSST
         NBMO=NBMO+ZI(ITABL+ISST-1)
4      CONTINUE

C CREATION D UN TABLEAU DE VECTEURS CONTENANT LES NOMS DE TOUS
C LES VECTEURS DE DEPLACEMENTS ET DE PRESSION DE L ENSEMBLE
C DES SOUS STRUCTURES

        CALL JECREO('&&TPXSTO','V V K24')
        CALL JEECRA('&&TPXSTO','LONMAX',NBMO,K8BID)
        CALL JEECRA('&&TPXSTO','LONUTI',NBMO,K8BID)
        CALL JEVEUT('&&TPXSTO','E',ITXSTO)
        CALL JECREO('&&TPYSTO','V V K24')
        CALL JEECRA('&&TPYSTO','LONMAX',NBMO,K8BID)
        CALL JEECRA('&&TPYSTO','LONUTI',NBMO,K8BID)
        CALL JEVEUT('&&TPYSTO','E',ITYSTO)
        IF(MODEL.EQ.'3D') THEN
           CALL JECREO('&&TPZSTO','V V K24')
           CALL JEECRA('&&TPZSTO','LONMAX',NBMO,K8BID)
           CALL JEECRA('&&TPZSTO','LONUTI',NBMO,K8BID)
           CALL JEVEUT('&&TPZSTO','E',ITZSTO)
        END IF
        CALL JECREO('&&VESTOC','V V K24')
        CALL JEECRA('&&VESTOC','LONMAX',NBMO,K8BID)
        CALL JEECRA('&&VESTOC','LONUTI',NBMO,K8BID)
        CALL JEVEUT('&&VESTOC','E',IPRSTO)
        CALL JECREO('&&TABIRG','V V I')
        CALL JEECRA('&&TABIRG','LONMAX',NBMO,K8BID)
        CALL JEECRA('&&TABIRG','LONUTI',NBMO,K8BID)
        CALL JEVEUT('&&TABIRG','E',IADIRG)

       IND=0
       DO 5 I=1,NBSST

C NB DE MODES PAR SST

          NBMOD=ZI(ITABL+I-1)

        DO 6 J=1,NBMOD

          IND=IND+1
          ZK24(ITXSTO+IND-1)=ZK24(ZI(IADRX+I-1)+J-1)
          ZK24(ITYSTO+IND-1)=ZK24(ZI(IADRY+I-1)+J-1)
          IF(MODEL.EQ.'3D') ZK24(ITZSTO+IND-1)=ZK24(ZI(IADRZ+I-1)+J-1)
          ZK24(IPRSTO+IND-1)=ZK24(ZI(IADRP+I-1)+J-1)
          CALL RANGEN(NUGENE//'.NUME',I,J,IRANG)
          ZI(IADIRG+IND-1)=IRANG

6       CONTINUE
5      CONTINUE

C
C --- MENAGE
C
       CHAINE = 'CBIDON'
       DO 7 ISST=1,NBSST

        CALL CODENT(ISST,'D0',CHAINE(1:6))
        CALL JEDETR('&&CALMDG.TXSTO'//CHAINE)
        CALL JEDETR('&&CALMDG.TYSTO'//CHAINE)
        CALL JEDETR('&&CALMDG.TZSTO'//CHAINE)
        CALL JEDETR('&&CALMDG.PRES'//CHAINE)

7      CONTINUE


       CALL JEDETR('&&CALMDG.TABL_MODE')
       CALL JEDETR('&&CALMDG.TABL_ADRX')
       CALL JEDETR('&&CALMDG.TABL_ADRY')
       CALL JEDETR('&&CALMDG.TABL_ADRZ')
       CALL JEDETR('&&CALMDG.TABL_ADRP')
       CALL JEDETR('&&CALMDG.TABL_LONMAX')

      CALL JEDEMA()
       END
