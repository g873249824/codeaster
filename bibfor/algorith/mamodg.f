      SUBROUTINE MAMODG(MODEL,NOMSTO,NOMNUM,NOMRES,ITXSTO,ITYSTO,ITZSTO,
     &                  IPRSTO,IADIRG,NBMO,MAX,MAY,MAZ,NBLOC)
      IMPLICIT NONE
C---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/02/98   AUTEUR CIBHHLV L.VIVAN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C---------------------------------------------------------------------
C ROUTINE NOUVEAU MODELE OPTIMISEE
C ROUTINE CALCULANT LA MASSE AJOUTEE SUR MODELE GENERALISE
C ARGUMENTS :
C IN : NOMNUM,NOMSTO : K19 : NOM CONCERNANT LES SD NUMEDDLGENE
C IN : NOMRES : K8 :NOM UTILISATEUR DU RESULTAT
C IN : MODEL : K2 : CHARACTER DISTINGUANT LE FLUIDE 2D ET 3D
C IN : MAX, MAY,MAZ : K19 : MATRICES AX, AY, AZ CALCULEES SUR
C                          L INTERFACE
C IN : ITXSTO,ITYSTO,ITZSTO,IPRSTO : ADR JEVEUX DES NOMS DES
C      CHAMPS DE DEPL_R STOCKEES PAR CMP ET DE LA PRESSION
C      CALCULEE SUR TOUS LES MODES
C IN : IADIRG : ADRESSE DU PREMIER ELEMENT D UN TABLEAU CONTENANT
C       LES RANGS GENERALISES DU COEFF DE MASSE AJOUTEE
C IN : NBMO : NOMBRE DE MODES TOTAL DANS LA BASE MODALE DES
C            SOUS-STRUCTURES - DEFORMEES STATIQUES + MODES
C             NORMAUX
C---------------------------------------------------------------------
C--------- DEBUT DES COMMUNS JEVEUX ----------------------------------
      CHARACTER*32     JEXNUM, JEXNOM, JEXATR
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16           ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     --- FIN DES COMMUNS JEVEUX ------------------------------------
      INTEGER       NBPRES,IMATX,IMATY,ITXSTO,ITYSTO,ITZSTO,IDELAT
      INTEGER       IVX,IVY,ITPX,ITPY,IPRES,IPRSTO,IADIA,IHCOL,IMATZ
      INTEGER       IABLO,IRANG,JRANG,I,J,IBLO,LDBLO,IVZ,ITPZ,IADIRG
      INTEGER       IBLODI,LDIABL,NBLOC,N1BLOC,N2BLOC,NBMO,N8,NN
      INTEGER       IFM,NIV
      REAL*8        MIJ,RX,RY,RZ,R8DOT
      CHARACTER*2   MODEL
      CHARACTER*8   REPON
      CHARACTER*8   NOMRES
      CHARACTER*19  MAX,MAY,MAZ,NOMNUM,NOMSTO
      CHARACTER*1 K1BID
C ------------------------------------------------------------------
C----- ICI ON CALCULE LA MASSE AJOUTEE SUR UN MODELE GENERALISE ---

      CALL JEMARQ()

        CALL INFNIV(IFM,NIV)
        CALL GETVTX(' ','AVEC_MODE_STAT',0,1,1,REPON,NN)
        IF (REPON(1:3).EQ.'NON') CALL JEVEUO('&&DELAT.INDIC','L',IDELAT)
        CALL JEVEUO(NOMSTO//'.ADIA','L',IADIA)
        CALL JEVEUO(NOMSTO//'.ABLO','L',IABLO)
        CALL JEVEUO(NOMSTO//'.HCOL','L',IHCOL)
        CALL JEVEUO(NOMSTO//'.IABL','L',LDIABL)
C
           CALL JELIRA(ZK24(IPRSTO)(1:19)//'.VALE','LONMAX'
     &                 ,NBPRES,K1BID)
           CALL WKVECT('&&MAMODG.VECTX','V V R',NBPRES,IVX)
           CALL WKVECT('&&MAMODG.VECTY','V V R',NBPRES,IVY)

C --- RECUPERATION DES DESCRIPTEURS DE MATRICES ASSEMBLEES MAX ET MAY
C --- EVENTUELLEMENT MAZ

           CALL MTDSCR(MAX)
           CALL JEVEUO(MAX(1:19)//'.&INT','E',IMATX)
           CALL MTDSCR(MAY)
           CALL JEVEUO(MAY(1:19)//'.&INT','E',IMATY)
           IF(MODEL.EQ.'3D') THEN
              CALL MTDSCR(MAZ)
              CALL JEVEUO(MAZ(1:19)//'.&INT','E',IMATZ)
              CALL WKVECT('&&MAMODG.VECTZ','V V R',NBPRES,IVZ)
           ENDIF
C
C     BOUCLE SUR LES BLOCS DE LA MATRICE ASSEMBLEE GENE
C
      DO 40 IBLO=1,NBLOC

         CALL JECROC(JEXNUM(NOMRES//'           .VALE',IBLO))
         CALL JEVEUO(JEXNUM(NOMRES//'           .VALE',IBLO),'E',
     &              LDBLO)
C-------------------------------------------------------------
C
C         BOUCLE SUR LES COLONNES DE LA MATRICE ASSEMBLEE
C
          N1BLOC=ZI(IABLO+IBLO-1)+1
          N2BLOC=ZI(IABLO+IBLO)
C
C
        DO 10 I = N1BLOC,N2BLOC
            IF(I.GT.NBMO) GOTO 10
            IF(REPON(1:3).EQ.'NON') THEN
              IF(ZI(IDELAT+I-1).NE.1) GOTO 10
            ENDIF
            CALL JEVEUO(ZK24(ITXSTO+I-1)(1:19)//'.VALE','L',ITPX)
            CALL JEVEUO(ZK24(ITYSTO+I-1)(1:19)//'.VALE','L',ITPY)
            IF(MODEL.EQ.'3D') THEN
              CALL JEVEUO(ZK24(ITZSTO+I-1)(1:19)//'.VALE','L',ITPZ)
              CALL MRMULT('ZERO',IMATZ,ZR(ITPZ),'R',ZR(IVZ),1)
            ENDIF

C------MULTIPLICATIONS MATRICE MAX * CHAMNO MODX---------------------
C----------ET MATRICE MAY * CHAMNO MODY------------------------------

           CALL MRMULT('ZERO',IMATX,ZR(ITPX),'R',ZR(IVX),1)
           CALL MRMULT('ZERO',IMATY,ZR(ITPY),'R',ZR(IVY),1)

C RANG GENERALISE DU TERME DE MASSE CALCULEE : LIGNE

           IRANG=ZI(IADIRG+I-1)

          DO 30 J = (I-ZI(IHCOL+I-1)+1),I

C----------------------------------------------------------------
C ICI ON CALCULE LA MASSE AJOUTEE SUR UN MODELE GENERALISE
C--------------------------------------------------------------
C-----------STOCKAGE DANS LA MATR_ASSE_GENE  ------

            IF(REPON(1:3).EQ.'NON') THEN
              IF(ZI(IDELAT+J-1).NE.1) GOTO 50
            ENDIF

           CALL JEVEUO(ZK24(IPRSTO+J-1)(1:19)//'.VALE','L',IPRES)

           RX= R8DOT(NBPRES,ZR(IPRES), 1,ZR(IVX),1)
           RY= R8DOT(NBPRES,ZR(IPRES), 1,ZR(IVY),1)

           IF (MODEL.EQ.'3D') THEN
             RZ= R8DOT(NBPRES,ZR(IPRES), 1,ZR(IVZ),1)
             MIJ = RX+RY+RZ
           ELSE
             MIJ = RX+RY
           ENDIF
50         CONTINUE
          IF(REPON(1:3).EQ.'NON') THEN
            IF(ZI(IDELAT+J-1).NE.1) MIJ=0.D0
          ENDIF
C
C RANG GENERALISE DU TERME DE MASSE: COLONNE
C
                  JRANG=ZI(IADIRG+J-1)
                  IBLODI = ZI(LDIABL+IRANG-1)

                  IF (IBLODI.NE.IBLO) THEN
C
C                 CAS OU LE BLOC COURANT N EST PAS LE BON
C
                    CALL JELIBE(JEXNUM(NOMRES//'           .VALE',
     +                          IBLO))
                    CALL JEVEUO(JEXNUM(NOMRES//'           .VALE',
     +              IBLODI),'E',LDBLO)
                    ZR(LDBLO+ZI(IADIA+IRANG-1)+JRANG-IRANG-1) = MIJ
                    IF (NIV .EQ. 2) THEN
                      WRITE(IFM,350) IRANG,JRANG,MIJ
                    ENDIF
                    CALL JELIBE(JEXNUM(NOMRES//'           .VALE',
     +                          IBLODI))
                    CALL JEVEUO(JEXNUM(NOMRES//'           .VALE',
     +              IBLO),'E',LDBLO)

                  ELSE
                    ZR(LDBLO+ZI(IADIA+IRANG-1)+JRANG-IRANG-1) = MIJ
                    IF (NIV .EQ. 2) THEN
                      WRITE(IFM,350) IRANG,JRANG,MIJ
                    ENDIF
                  ENDIF
30      CONTINUE
10     CONTINUE
40    CONTINUE

350   FORMAT(18X,'M',2 I 4,1X,'=',1X, D 12.5)


C--MENAGE FINAL DES OBJETS DE TRAVAIL

             CALL JEDETR('&&MAMODG.VECTZ')
             CALL JEDETR('&&MAMODG.VECTX')
             CALL JEDETR('&&MAMODG.VECTY')

      CALL JEDEMA()
           END
