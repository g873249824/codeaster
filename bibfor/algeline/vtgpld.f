      SUBROUTINE VTGPLD(CUMUL ,GEOMIZ,ALPHA ,DEPLAZ,BASE  ,
     &                  GEOMFZ)
C
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 21/02/2012   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT      NONE
      CHARACTER*(*) GEOMIZ,DEPLAZ,GEOMFZ
      CHARACTER*1   BASE
      REAL*8        ALPHA
      CHARACTER*4   CUMUL
C
C ----------------------------------------------------------------------
C
C REACTUALISATION D'UN CHAMP GEOMETRIQUE (GEOM_R) AVEC UN CHAMP SUR
C LA GRANDEUR DEPL_R
C
C ----------------------------------------------------------------------
C
C ON FAIT:
C   GEOMF = GEOMI + ALPHA * DEPLA SI CUMUL = 'CUMU'
C   GEOMF = ALPHA * DEPLA         SI CUMUL = 'ZERO'
C
C ON SE SERT UNIQIUEMENT DES COMPOSANTES DX, DY, DZ SUR LE CHAMP
C DE DEPLACEMENT
C SI SUR CERTAINS NOEUDS, ON NE TROUVE PAS DE DEPLACEMENT,
C ON LES LAISSE INCHANGES
C
C IN  CUMUL : 'ZERO' OU 'CUMU'
C IN  GEOMI : CHAM_NO(GEOM_R) - CHAMP DE GEOMETRIE A ACTUALISER.
C IN  ALPHA : COEFFICIENT MULTIPLICATEUR DE DEPLA
C IN  DEPLA : CHAM_NO(DEPL_R) - CHAMP DE DEPLACEMENT A AJOUTER.
C IN  BASE  : BASE SUR LAQUELLE DOIT ETRE CREE GEOMF
C OUT GEOMF : CHAM_NO(GEOM_R) : CHAMP DE GEOMETRIE ACTUALISE.
C                 (CE CHAMP EST DETRUIT S'IL EXISTE DEJA)
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER       IAD,IBID,ICOMPT,IGD,IVAL,LDIM,IRET
      INTEGER       NBEC,NBNO,NCMP,NCMPMX,NEC,NUM
      INTEGER       IADESC,IAPRNO,IAREFE,IAVALD,IAVALF,IAVALI
      INTEGER       ICMP,INO
      REAL*8        RDEPLA
      LOGICAL       EXISDG
      CHARACTER*8   NOMA,NOMGD,K8BID,KTYPE
      CHARACTER*19  GEOMI,DEPLA,GEOMF
      CHARACTER*24  NOMNU
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATION
C
      GEOMI  = GEOMIZ
      GEOMF  = GEOMFZ
      DEPLA  = DEPLAZ
C
C --- CONFORMITE DES GRANDEURS
C
      CALL DISMOI('F','NOM_GD',GEOMI,'CHAM_NO',IBID,NOMGD,IRET)
      CALL ASSERT(NOMGD(1:6).EQ.'GEOM_R')
      CALL DISMOI('F','NOM_GD',DEPLA,'CHAM_NO',IBID,NOMGD,IRET)
      CALL ASSERT(NOMGD(1:6).EQ.'DEPL_R')
      CALL JELIRA(DEPLA//'.VALE','TYPE',IBID,KTYPE)
      CALL ASSERT(KTYPE(1:1).EQ.'R')
C
C --- ON RECOPIE BESTIALEMENT LE CHAMP POUR CREER LE NOUVEAU
C
      CALL COPISD('CHAMP_GD',BASE,GEOMI,GEOMF)
C
C --- INFORMATIONS SUR LE MAILLAGE
C
      CALL DISMOI('F','NOM_MAILLA'  ,GEOMI,'CHAM_NO' ,IBID,NOMA ,IRET)
      CALL DISMOI('F','NB_NO_MAILLA',NOMA ,'MAILLAGE',NBNO,K8BID,IRET)
C
      CALL JELIRA(GEOMI//'.VALE','LONMAX',LDIM,K8BID)
      CALL ASSERT(LDIM/3.EQ.NBNO)
C
C --- ACCES AUX CHAMPS
C
      CALL JEVEUO(GEOMI//'.VALE','L',IAVALI)
      CALL JEVEUO(GEOMF//'.VALE','E',IAVALF)
      CALL JEVEUO(DEPLA//'.REFE','L',IAREFE)
      CALL JEVEUO(DEPLA//'.VALE','L',IAVALD)
      CALL JEVEUO(DEPLA//'.DESC','L',IADESC)
C
C --- INFORMATIONS SUR LE CHAMP DE DEPLACEMENT
C
      NOMNU  = ZK24(IAREFE-1+2)
      IGD    = ZI(IADESC-1+1)
      NUM    = ZI(IADESC-1+2)
      NEC    = NBEC(IGD)
      CALL ASSERT(NEC.LE.10)
      CALL JELIRA(JEXNUM('&CATA.GD.NOMCMP',IGD),'LONMAX',NCMPMX,K8BID)
      CALL JEVEUO(JEXNUM('&CATA.GD.NOMCMP',IGD),'L',IAD)
      CALL ASSERT(ZK8(IAD-1+1).EQ.'DX')
      CALL ASSERT(ZK8(IAD-1+2).EQ.'DY')
      CALL ASSERT(ZK8(IAD-1+3).EQ.'DZ')
C
C --- SI LE CHAMP EST A REPRESENTATION CONSTANTE
C
      IF ( NUM .LT. 0 )  THEN
        DO 13 INO = 1,NBNO
          DO 14 ICMP = 1,3
            RDEPLA = ZR(IAVALD-1+3*(INO-1)+ICMP)
            IF (CUMUL.EQ.'CUMU') THEN
              ZR(IAVALF-1+3*(INO-1)+ICMP) =
     &                 ZR(IAVALI-1+3*(INO-1)+ICMP)+ALPHA*RDEPLA
            ELSEIF (CUMUL.EQ.'ZERO') THEN
              ZR(IAVALF-1+3*(INO-1)+ICMP) =
     &                 ALPHA*RDEPLA
            ELSE
              CALL ASSERT(.FALSE.)
            ENDIF
   14     CONTINUE
   13   CONTINUE
      ELSE
C
C --- ON RECUPERE CE QUI CONCERNE LES NOEUDS DU MAILLAGE
C
        CALL JELIRA(JEXNUM(NOMNU(1:19)//'.PRNO',1),'LONMAX',IBID,K8BID)
        CALL ASSERT(IBID.NE.0)
        CALL JEVEUO(JEXNUM(NOMNU(1:19)//'.PRNO',1),'L',IAPRNO)
        DO 11 INO = 1,NBNO
          IVAL = ZI(IAPRNO-1+(INO-1)*(NEC+2)+1)
          NCMP = ZI(IAPRNO-1+(INO-1)*(NEC+2)+2)
          IF (NCMP.NE.0) THEN
            ICOMPT = 0
            DO 12 ICMP = 1,3
              IF (EXISDG(ZI(IAPRNO-1+(INO-1)*(NEC+2)+3),ICMP)) THEN
                ICOMPT = ICOMPT + 1
                RDEPLA = ZR(IAVALD-1+IVAL-1+ICOMPT)
                IF (CUMUL.EQ.'CUMU') THEN
                   ZR(IAVALF-1+3*(INO-1)+ICMP)=
     &                     ZR(IAVALI-1+3*(INO-1)+ICMP)+ALPHA*RDEPLA
                ELSEIF (CUMUL.EQ.'ZERO') THEN
                   ZR(IAVALF-1+3*(INO-1)+ICMP)=
     &                     ALPHA*RDEPLA
                ELSE
                  CALL ASSERT(.FALSE.)
                ENDIF
              ENDIF
   12       CONTINUE
          ENDIF
   11   CONTINUE
      ENDIF
C
      CALL JEDEMA()
      END
