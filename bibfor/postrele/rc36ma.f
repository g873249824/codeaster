      SUBROUTINE RC36MA(NOMMAT,NOMA)
      IMPLICIT   NONE
      CHARACTER*8 NOMMAT,NOMA
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 16/02/2009   AUTEUR GALENNE E.GALENNE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     ------------------------------------------------------------------

C     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3600

C     TRAITEMENT DU CHAM_MATER
C     RECUPERATION POUR CHAQUE MAILLE
C          DE  E, NU, ALPHA    SOUS ELAS
C          DE  E_REFE          SOUS FATIGUE
C          DE  M_KE, N_KE, SM  SOUS RCCM

C IN  : NOMMAT : CHAM_MATER UTILISATEUR
C IN  : NOMA   : MAILLAGE

C     CREATION DES OBJETS :

C     &&RC3600.MATERIAU' : VECTEUR DE DIMENSION 2*NOMBRE DE SITUATIONS
C         CONTENANT LES NOMS DES CHAM_ELEM  CHMATA ET CHMATB :

C         CHMATA = '&&RC36MA_A.'//NUMSITU : CHAMP SIMPLE ELNO CONTENANT
C              POUR CHAQUE MAILLE LES 8 PARAMETRES
C                    E_AMBI, NU, ALPHA : A LA TEMPERATURE DE REFERENCE
C                    E, SM, M_KE, N_KE : A LA TEMPERATURE DE CALCUL

C         CHMATB = '&&RC36MA_B.'//NUMSITU : CHAMP SIMPLE ELNO CONTENANT
C              POUR CHAQUE MAILLE LES 8 PARAMETRES
C                    E_AMBI, NU, ALPHA : A LA TEMPERATURE DE REFERENCE
C                    E, SM, M_KE, N_KE : A LA TEMPERATURE DE CALCUL

C      &&RC3600.NOM_MATERIAU : VECTEUR DIMENSIONNE A NBMAIL CONTENANT
C      POUR CHAQUE MAILLE LE NOM DU MATERIAU ASSOCIE (POUR RECUPER LA
C      COURBE DE FATIGUE)
C-----------------------------------------------------------------------
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------

      INTEGER NBCMP
      PARAMETER (NBCMP=9)
      INTEGER NBPA,NBPB,NBPT,IPT,NBSEIS,NDIM,JCESVM,JCESDM,JCESLM,ISP,
     &        ICMP,IAD,IM,IERD,NBMAIL,JCESLA,JCESVA,JCESDA,
     &        JCESLB,JCESVB,JCESDB,IER,IOCC,NBSITU,JCHMAT,NA,NB,JMATER
      REAL*8 PARA(NBCMP),TEMPA,TEMPRA,TEMPB,TEMPRB,R8VIDE,TKE
      CHARACTER*2 CODRET(NBCMP)
      CHARACTER*8 K8B,NOMGD,MATER,NOPA,NOPB,TYPEKE,NOCMP(NBCMP)
      CHARACTER*8 LICMP(2),KTREF
      CHARACTER*16 PHENOM,MOTCL1,MOTCL2
      CHARACTER*19 CHNMAT,CHSMAT,CHSMA2
      CHARACTER*24 CHMATA,CHMATB
C DEB ------------------------------------------------------------------
      CALL JEMARQ()

      MOTCL1 = 'SITUATION'
      MOTCL2 = 'SEISME'
      CALL GETFAC(MOTCL1,NBSITU)
      CALL GETFAC(MOTCL2,NBSEIS)
      NDIM = NBSITU + NBSEIS

C    RECUP TYPE KE
      CALL GETVTX ( ' ', 'TYPE_KE', 0,1,1, TYPEKE, NB )
      IF (TYPEKE.EQ.'KE_MECA')THEN
         TKE=-1.D0
      ELSE
         TKE=1.D0
      ENDIF
      PARA(9)=TKE

      CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NBMAIL,K8B,IERD)

      CALL WKVECT('&&RC3600.MATERIAU','V V K24',2*NDIM,JCHMAT)
      CALL WKVECT('&&RC3600.NOM_MATERIAU', 'V V K8', NBMAIL, JMATER )

      CHNMAT = NOMMAT//'.CHAMP_MAT '
      CHSMAT = '&&RC36MA.CHSMAT'
      CHSMA2 = '&&RC36MA.CHSMA2'
      K8B  = ' '
      CALL CARCES(CHNMAT,'ELEM',K8B,'V',CHSMAT,IER)
      IF (IER.NE.0) CALL U2MESS('F','POSTRCCM_13')
C     -- ON NE GARDE DANS LE CHAMP DE MATERIAU QUE LES CMPS
C      X1 : NOM DU MATERIAU
C      X30: TEMP_REF
      LICMP(1)='X1'
      LICMP(2)='X30'
      CALL CESRED(CHSMAT,0,0,2,LICMP,'V',CHSMA2)
      CALL DETRSD ( 'CHAM_ELEM_S', CHSMAT )

      CALL JEVEUO(CHSMA2//'.CESV','L',JCESVM)
      CALL JEVEUO(CHSMA2//'.CESD','L',JCESDM)
      CALL JEVEUO(CHSMA2//'.CESL','L',JCESLM)

      IF (IER.NE.0) CALL U2MESS('F','POSTRCCM_14')


C --- E_AMBI, NU, ALPHA : A LA TEMPERATURE DE REFERENCE
C --- E, SM, M_KE, N_KE : A LA TEMPERATURE DE CALCUL

      NOMGD = 'RCCM_R'
      NOCMP(1) = 'E'
      NOCMP(2) = 'E_AMBI'
      NOCMP(3) = 'NU'
      NOCMP(4) = 'ALPHA'
      NOCMP(5) = 'E_REFE'
      NOCMP(6) = 'SM'
      NOCMP(7) = 'M_KE'
      NOCMP(8) = 'N_KE'
      NOCMP(9) = 'TYPEKE'
C
      DO 60,IOCC = 1,NBSITU,1

        CALL CODENT(IOCC,'D0',K8B)

C ------ ETAT STABILISE "A"
C        ------------------

        CHMATA = '&&RC36MA_A.'//K8B
        NOCMP(2) = 'E_AMBI'
        CALL CESCRE('V',CHMATA,'ELNO',NOMA,NOMGD,NBCMP,NOCMP,-1,-1,
     &              -NBCMP)
        NOCMP(2) = 'E'

        CALL JEVEUO(CHMATA(1:19)//'.CESD','L',JCESDA)
        CALL JEVEUO(CHMATA(1:19)//'.CESL','E',JCESLA)
        CALL JEVEUO(CHMATA(1:19)//'.CESV','E',JCESVA)

        NBPA = 1
        NOPA = 'TEMP'
        CALL GETVR8(MOTCL1,'TEMP_REF_A',IOCC,1,1,TEMPA,NA)

C ------ ETAT STABILISE "B"
C        ------------------

        CHMATB = '&&RC36MA_B.'//K8B
        NOCMP(2) = 'E_AMBI'
        CALL CESCRE('V',CHMATB,'ELNO',NOMA,NOMGD,NBCMP,NOCMP,-1,-1,
     &              -NBCMP)
        NOCMP(2) = 'E'

        CALL JEVEUO(CHMATB(1:19)//'.CESD','L',JCESDB)
        CALL JEVEUO(CHMATB(1:19)//'.CESL','E',JCESLB)
        CALL JEVEUO(CHMATB(1:19)//'.CESV','E',JCESVB)

        NBPB = 1
        NOPB = 'TEMP'
        CALL GETVR8(MOTCL1,'TEMP_REF_B',IOCC,1,1,TEMPB,NB)

        DO 50 IM = 1,NBMAIL

          ICMP = 1

C --------- LE MATERIAU
          CALL CESEXI('C',JCESDM,JCESLM,IM,1,1,1,IAD)
          IF (IAD.GT.0) THEN
            MATER = ZK8(JCESVM-1+IAD)
          ELSE
            CALL CODENT(IM,'D',K8B)
            CALL U2MESK('F','POSTRCCM_10',1,K8B)
          END IF

C --------- LA TEPERATURE DE REFERENCE :
          CALL CESEXI('C',JCESDM,JCESLM,IM,1,1,2,IAD)
          IF (IAD.GT.0) THEN
            KTREF = ZK8(JCESVM-1+IAD)
            IF (KTREF.EQ.'NAN') THEN
              TEMPRA=R8VIDE()
            ELSE
              READ (KTREF,'(F8.2)') TEMPRA
            ENDIF
          ELSE
            TEMPRA=R8VIDE()
          END IF

          IF (NA.EQ.0)  TEMPA = TEMPRA
          TEMPRB = TEMPRA
          IF (NB.EQ.0)  TEMPB = TEMPRB

          ZK8(JMATER+IM-1) = MATER
          CALL RCCOME(MATER,'ELAS',PHENOM,CODRET)
          IF (CODRET(1).EQ.'NO') CALL U2MESK('F','POSTRCCM_7',1,'ELAS')

          CALL RCCOME(MATER,'FATIGUE',PHENOM,CODRET)
        IF (CODRET(1).EQ.'NO') CALL U2MESK('F','POSTRCCM_7',1,'FATIGUE')

          CALL RCCOME(MATER,'RCCM',PHENOM,CODRET)
          IF (CODRET(1).EQ.'NO') CALL U2MESK('F','POSTRCCM_7',1,'RCCM')

C   INTERPOLATION POUR TEMP_A
          CALL RCVALE(MATER,'ELAS',NBPA,NOPA,TEMPA,1,NOCMP(1),PARA(1),
     &                CODRET,'F ')

          CALL RCVALE(MATER,'ELAS',NBPA,NOPA,TEMPRA,3,NOCMP(2),PARA(2),
     &                CODRET,'F ')

          CALL RCVALE(MATER,'FATIGUE',NBPA,NOPA,TEMPA,1,NOCMP(5),
     &                PARA(5),CODRET,'F ')

          CALL RCVALE(MATER,'RCCM',NBPA,NOPA,TEMPA,3,NOCMP(6),PARA(6),
     &                CODRET,'F ')

C --------- LES MAILLES AFFECTEES

          NBPT = ZI(JCESDA-1+5+4* (IM-1)+1)
          ISP = 1
          DO 20 IPT = 1,NBPT
            DO 10 ICMP = 1,NBCMP
              CALL CESEXI('S',JCESDA,JCESLA,IM,IPT,ISP,ICMP,IAD)
              IF (IAD.LT.0) THEN
                 IAD=-IAD
                 ZL(JCESLA-1+IAD) = .TRUE.
              ENDIF
              ZR(JCESVA-1+IAD) = PARA(ICMP)
   10       CONTINUE
   20     CONTINUE

C   INTERPOLATION POUR TEMP_B
          CALL RCVALE(MATER,'ELAS',NBPB,NOPB,TEMPB,1,NOCMP(1),PARA(1),
     &                CODRET,'F ')

          CALL RCVALE(MATER,'ELAS',NBPB,NOPB,TEMPRB,3,NOCMP(2),PARA(2),
     &                CODRET,'F ')

          CALL RCVALE(MATER,'FATIGUE',NBPB,NOPB,TEMPB,1,NOCMP(5),
     &                PARA(5),CODRET,'F ')

          CALL RCVALE(MATER,'RCCM',NBPB,NOPB,TEMPB,3,NOCMP(6),PARA(6),
     &                CODRET,'F ')

C --------- LES MAILLES AFFECTEES

          NBPT = ZI(JCESDB-1+5+4* (IM-1)+1)
          ISP = 1
          DO 40 IPT = 1,NBPT
            DO 30 ICMP = 1,NBCMP
              CALL CESEXI('S',JCESDB,JCESLB,IM,IPT,ISP,ICMP,IAD)
              IF (IAD.LT.0) THEN
                 IAD=-IAD
                 ZL(JCESLB-1+IAD) = .TRUE.
              ENDIF
              ZR(JCESVB-1+IAD) = PARA(ICMP)
   30       CONTINUE
   40     CONTINUE

   50   CONTINUE

        ZK24(JCHMAT+2*IOCC-1) = CHMATA

        ZK24(JCHMAT+2*IOCC-2) = CHMATB

   60 CONTINUE
C
      DO 160,IOCC = 1,NBSEIS,1

        CALL CODENT ( NBSITU+IOCC, 'D0', K8B )

C ------ ETAT STABILISE "A"
C        ------------------

        CHMATA = '&&RC36MA_A.'//K8B
        NOCMP(2) = 'E_AMBI'
        CALL CESCRE('V',CHMATA,'ELNO',NOMA,NOMGD,NBCMP,NOCMP,-1,-1,
     &              -NBCMP)
        NOCMP(2) = 'E'

        CALL JEVEUO(CHMATA(1:19)//'.CESD','L',JCESDA)
        CALL JEVEUO(CHMATA(1:19)//'.CESL','E',JCESLA)
        CALL JEVEUO(CHMATA(1:19)//'.CESV','E',JCESVA)

        NBPA = 1
        NOPA = 'TEMP'
        CALL GETVR8(MOTCL2,'TEMP_REF',IOCC,1,1,TEMPA,NA)

C ------ ETAT STABILISE "B"
C        ------------------

        CHMATB = '&&RC36MA_B.'//K8B
        NOCMP(2) = 'E_AMBI'
        CALL CESCRE('V',CHMATB,'ELNO',NOMA,NOMGD,NBCMP,NOCMP,-1,-1,
     &              -NBCMP)
        NOCMP(2) = 'E'

        CALL JEVEUO(CHMATB(1:19)//'.CESD','L',JCESDB)
        CALL JEVEUO(CHMATB(1:19)//'.CESL','E',JCESLB)
        CALL JEVEUO(CHMATB(1:19)//'.CESV','E',JCESVB)

        NBPB = 1
        NOPB = 'TEMP'
        CALL GETVR8(MOTCL2,'TEMP_REF',IOCC,1,1,TEMPB,NB)

        DO 150 IM = 1,NBMAIL

          ICMP = 1

C --------- LE MATERIAU
          CALL CESEXI('C',JCESDM,JCESLM,IM,1,1,1,IAD)
          IF (IAD.GT.0) THEN
            MATER = ZK8(JCESVM-1+IAD)
          ELSE
            CALL CODENT(IM,'D',K8B)
            CALL U2MESK('F','POSTRCCM_10',1,K8B)
          END IF

C --------- LA TEPERATURE DE REFERENCE :
          CALL CESEXI('C',JCESDM,JCESLM,IM,1,1,2,IAD)
          IF (IAD.GT.0) THEN
            KTREF = ZK8(JCESVM-1+IAD)
            IF (KTREF.EQ.'NAN') THEN
              TEMPRA=R8VIDE()
            ELSE
              READ (KTREF,'(F8.2)') TEMPRA
            ENDIF
          ELSE
            TEMPRA=R8VIDE()
          END IF

          IF (NA.EQ.0) TEMPA = TEMPRA
          TEMPRB = TEMPRA
          IF (NB.EQ.0) TEMPB = TEMPRB

          ZK8(JMATER+IM-1) = MATER
          CALL RCCOME(MATER,'ELAS',PHENOM,CODRET)
          IF (CODRET(1).EQ.'NO') CALL U2MESK('F','POSTRCCM_7',1,'ELAS')

          CALL RCCOME(MATER,'FATIGUE',PHENOM,CODRET)
        IF (CODRET(1).EQ.'NO') CALL U2MESK('F','POSTRCCM_7',1,'FATIGUE')

          CALL RCCOME(MATER,'RCCM',PHENOM,CODRET)
          IF (CODRET(1).EQ.'NO') CALL U2MESK('F','POSTRCCM_7',1,'RCCM')

C   INTERPOLATION POUR TEMP_A
          CALL RCVALE(MATER,'ELAS',NBPA,NOPA,TEMPA,1,NOCMP(1),PARA(1),
     &                CODRET,'F ')

          CALL RCVALE(MATER,'ELAS',NBPA,NOPA,TEMPRA,3,NOCMP(2),PARA(2),
     &                CODRET,'F ')

          CALL RCVALE(MATER,'FATIGUE',NBPA,NOPA,TEMPA,1,NOCMP(5),
     &                PARA(5),CODRET,'F ')

          CALL RCVALE(MATER,'RCCM',NBPA,NOPA,TEMPA,3,NOCMP(6),PARA(6),
     &                CODRET,'F ')

C --------- LES MAILLES AFFECTEES

          NBPT = ZI(JCESDA-1+5+4* (IM-1)+1)
          ISP = 1
          DO 120 IPT = 1,NBPT
            DO 110 ICMP = 1,NBCMP
              CALL CESEXI('S',JCESDA,JCESLA,IM,IPT,ISP,ICMP,IAD)
              IF (IAD.LT.0) THEN
                 IAD=-IAD
                 ZL(JCESLA-1+IAD) = .TRUE.
              ENDIF
              ZR(JCESVA-1+IAD) = PARA(ICMP)
  110       CONTINUE
  120     CONTINUE

C   INTERPOLATION POUR TEMP_B
          CALL RCVALE(MATER,'ELAS',NBPB,NOPB,TEMPB,1,NOCMP(1),PARA(1),
     &                CODRET,'F ')

          CALL RCVALE(MATER,'ELAS',NBPB,NOPB,TEMPRB,3,NOCMP(2),PARA(2),
     &                CODRET,'F ')

          CALL RCVALE(MATER,'FATIGUE',NBPB,NOPB,TEMPB,1,NOCMP(5),
     &                PARA(5),CODRET,'F ')

          CALL RCVALE(MATER,'RCCM',NBPB,NOPB,TEMPB,3,NOCMP(6),PARA(6),
     &                CODRET,'F ')

C --------- LES MAILLES AFFECTEES

          NBPT = ZI(JCESDB-1+5+4* (IM-1)+1)
          ISP = 1
          DO 140 IPT = 1,NBPT
            DO 130 ICMP = 1,NBCMP
              CALL CESEXI('S',JCESDB,JCESLB,IM,IPT,ISP,ICMP,IAD)
              IF (IAD.LT.0) THEN
                 IAD=-IAD
                 ZL(JCESLB-1+IAD) = .TRUE.
              ENDIF
              ZR(JCESVB-1+IAD) = PARA(ICMP)
  130       CONTINUE
  140     CONTINUE

  150   CONTINUE

        ZK24(JCHMAT+2*(NBSITU+IOCC)-1) = CHMATA

        ZK24(JCHMAT+2*(NBSITU+IOCC)-2) = CHMATB

  160 CONTINUE
      CALL DETRSD ( 'CHAM_ELEM_S', CHSMA2 )

      CALL JEDEMA()
      END
