      SUBROUTINE PJMA2P(MOA2,MA2P,CORRES)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 08/11/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C RESPONSABLE BERARD A.BERARD
C
C
C
      IMPLICIT   NONE

C ----------------------------------------------------------------------
C
C COMMANDE PROJ_CHAMP
C
C ----------------------------------------------------------------------
C 0.1. ==> ARGUMENTS
C

C MOA2 : MODELE2 DONT ON VEUT EXTRAIRE LES POINTS DE GAUSS
C CORRES : TABLEAU DE CORRESPONDANCE REMPLI DANS LE .PJEL
C MA2P : MAILLAGE 2 PRIME (OBTENU A PARTIR DES PG DU MAILLAGE 2)


       CHARACTER*16 CORRES
       CHARACTER*8 MA2P, MOA2



C
C 0.2. ==> COMMUNS
C ----------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*32       JEXNUM
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)

      CHARACTER*32 JEXNOM


C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
C 0.3. ==> VARIABLES LOCALES
C


      INTEGER NDIM,NTGEO,IPO,IPG,NUNO2
      INTEGER IBID,IRET,NBNO2P,NNO2
      INTEGER K,J1,J2,J4
      INTEGER NBMA, NBPT, NBSP, NBCMP
      INTEGER IMA,IPT,ISP,ICMP,IAD,IADIME
      INTEGER JTYPMA,JDIMT,JDIME,JPO2
      INTEGER JCESD, JCESL, JCESV,I
      CHARACTER*8 NOM,NOMA,MAIL2,KBID
      CHARACTER*19 CHAMG,CES,CHGEOM,LIGREL
      CHARACTER*24 COODSC



      CALL JEMARQ()


C RECUPERATION DU NOM DU MAILLAGE 2
      CALL DISMOI('F','NOM_MAILLA',MOA2,'MODELE',IBID,MAIL2,IRET)


C RECUPERATION DE LA DIMENSION TOPOLOGIQUE DU MAILLAGE
      CALL JEVEUO(MAIL2(1:8)//'.DIME','L',JDIME)
      NDIM = ZI(JDIME - 1 + 6)

C RECUPERATION DU CHAMP DE COORDONNEES DU MAILLAGE 2
      CHGEOM=MAIL2//'.COORDO'


C LIGREL DU MODELE 2

      MOA2='&&MODEL2'
      LIGREL=MOA2//'.MODELE    .LGRF'

      CALL PJLIGR(MAIL2,MOA2,NDIM,LIGREL)

      CHAMG='&&PJMA2P.PGCOOR'

C APPEL A CALCUL POUR CREER UN CHAMP DE COORDONNEES DES ELGA
      CALL CALCUL('S','COOR_ELGA',LIGREL,1,
     &   CHGEOM,'PGEOMER',1,CHAMG,'PCOORPG ','G','OUI')

C TRANSFORMATION DE CE CHAMP EN CHAM_ELEM_S
      CES='&&PJMA2P.PGCORS'
      CALL CELCES(CHAMG,'G',CES)

      CALL JEVEUO(CES//'.CESD','L',JCESD)
      CALL JEVEUO(CES//'.CESL','L',JCESL)
      CALL JEVEUO(CES//'.CESV','L',JCESV)

      NBMA=ZI(JCESD-1+1)


C
C LE NB D'ELGA PAR MAILLE UTILE (I.E. DE DIMENSION TOPOLOGIQUE
C EGALE A LA DIMENSION DE L'ESPACE) DEVIENT LE NB DE NOEUDS DE MA2P
C

      NBNO2P=0

C NBMA*9*2 = NB MAX DE MAILLES * NB DE PG MAX PAR MAILLE * 2
C ON CREE UN TABLEAU, POUR CHAQUE JPO2, ON A DEUX VALEURS
C LA PREMIERE VALEUR EST LE NUMERO DE LA MAILLE
C LA DEUXIEME VALEUR EST LE NUMERO DU POINT DE GAUSS DANS CETTE MAILLE

      CALL WKVECT(CORRES//'.PJEF_EL', 'G V I', NBMA*9*2, JPO2)
      CALL JEVEUO(MAIL2(1:8)//'.TYPMAIL','L',JTYPMA)

C NB DE SOUS-POINTS TOUJOURS EGAL A 1

      IPO=1

      DO 50,IMA = 1,NBMA
        CALL JEVEUO(JEXNUM('&CATA.TM.TMDIM',ZI(JTYPMA-1+IMA)),'L',JDIMT)
        IF (ZI(JDIMT).EQ.NDIM) THEN
          NBPT = ZI(JCESD-1+5+4* (IMA-1)+1)
          DO 60,IPG = 1,NBPT
            ZI(JPO2-1+IPO)=IMA
            ZI(JPO2-1+IPO+1)=IPG
            IPO=IPO+2
 60       CONTINUE
          NBNO2P=NBNO2P+NBPT

C FIN BOUCLE SUR LES MAILLES UTILES

        ENDIF

 50   CONTINUE


C CREATION DU .DIME DU NOUVEAU MAILLAGE
C IL Y A AUTANT DE MAILLES QUE DE NOEUDS
C TOUTES LES MAILLES SONT DES POI1

      CALL WKVECT(MA2P//'.DIME', 'G V I', 6, IADIME)
      ZI(IADIME-1+1)=NBNO2P
      ZI(IADIME-1+3)=NBNO2P
      ZI(IADIME-1+6)=3


C CREATION DU .NOMNOE ET DU .NOMMAI DU NOUVEAU MAILLAGE
      CALL JECREO(MA2P//'.NOMNOE', 'G N K8')
      CALL JEECRA(MA2P//'.NOMNOE', 'NOMMAX', NBNO2P, ' ')
      CALL JECREO(MA2P//'.NOMMAI', 'G N K8')
      CALL JEECRA(MA2P//'.NOMMAI', 'NOMMAX', NBNO2P, ' ')


      NOM(1:1)='N'
      DO 51,K=1,NBNO2P
          CALL CODENT(K,'G',NOM(2:8))
          CALL JECROC(JEXNOM(MA2P//'.NOMNOE',NOM))
51    CONTINUE
      NOM(1:1)='M'
      DO 52,K=1,NBNO2P
          CALL CODENT(K,'G',NOM(2:8))
          CALL JECROC(JEXNOM(MA2P//'.NOMMAI',NOM))
52    CONTINUE



C CREATION DU .CONNEX ET DU .TYPMAIL DU NOUVEAU MAILLAGE
C

      CALL JECREC(MA2P//'.CONNEX','G V I','NU','CONTIG',
     &            'VARIABLE',NBNO2P)
      CALL JEECRA(MA2P//'.CONNEX','LONT',NBNO2P,' ')
      CALL JEVEUO(MA2P//'.CONNEX','E',IBID)

      NUNO2=0

      DO 53,IMA=1,NBNO2P
        NNO2=1
        CALL JECROC(JEXNUM(MA2P//'.CONNEX',IMA))
        CALL JEECRA(JEXNUM(MA2P//'.CONNEX',IMA),'LONMAX',NNO2,KBID)
          NUNO2=NUNO2+1
          ZI(IBID-1+NUNO2)=NUNO2
53    CONTINUE



C CREATION DU .REFE DU NOUVEAU MAILLAGE
      CALL WKVECT(MA2P//'.COORDO    .REFE', 'V V K24', 4, J4)
      ZK24(J4)='MA2P'


C CREATION DU .VALE DU NOUVEAU MAILLAGE
      CALL WKVECT(MA2P//'.COORDO    .VALE', 'V V R', 4*NBNO2P, J1)


C REMPLISSAGE
C ON VA JUSQU'A NBCMP-1 CAR ON NE PREND PAS LE POIDS DU PG

      J2=J1
      DO 41,IMA = 1,NBMA
        NBPT = ZI(JCESD-1+5+4* (IMA-1)+1)
        NBSP = ZI(JCESD-1+5+4* (IMA-1)+2)
        NBCMP = ZI(JCESD-1+5+4* (IMA-1)+3)
        CALL JEVEUO(JEXNUM('&CATA.TM.TMDIM',ZI(JTYPMA-1+IMA)),'L',JDIMT)

        IF (ZI(JDIMT).EQ.NDIM) THEN
        DO 31,IPT = 1,NBPT
          DO 21,ISP = 1,NBSP
            DO 11,ICMP = 1,NBCMP-1
              CALL CESEXI('C',JCESD,JCESL,IMA,IPT,ISP,ICMP,IAD)
              IF (IAD.GT.0)  THEN
                ZR(J2)=ZR(JCESV-1+IAD)
                J2=J2+1
              ENDIF
 11         CONTINUE
            J2=J2+1
 21       CONTINUE
 31     CONTINUE

        ENDIF

 41   CONTINUE


C CREATION DU .DESC DU NOUVEAU MAILLAGE

      COODSC=MA2P//'.COORDO    .DESC'

      CALL JENONU(JEXNOM('&CATA.GD.NOMGD','GEOM_R'),NTGEO)
      CALL JECREO(COODSC,'G V I')
      CALL JEECRA(COODSC,'LONMAX',3,' ')
      CALL JEECRA(COODSC,'DOCU',0,'CHNO')
      CALL JEVEUO(COODSC,'E',IAD)
      ZI(IAD)   =  NTGEO
      ZI(IAD+1) = -3
      ZI(IAD+2) = 14

      CALL DETRSD('CHAM_ELEM',CHAMG)
      CALL DETRSD('CHAM_ELEM_S',CES)


      CALL JEDEMA()

      END
