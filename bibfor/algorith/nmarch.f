      SUBROUTINE NMARCH(RESULT,NUMINS,PARTPS,FORCE,COMPOR,CRITNL,VALPLU,
     &                  CNSINR,CMD,VITPLU,ACCPLU,NBMODS,DEPENT,VITENT,
     &                  ACCENT,INCR,MODELE,MATE,CARELE,LISCHA)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/10/2004   AUTEUR CIBHHLV L.VIVAN 
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
C RESPONSABLE PBADEL P.BADEL

      IMPLICIT NONE
      LOGICAL FORCE,INCR
      INTEGER NUMINS,NBMODS,IBID
      CHARACTER*8 RESULT
      CHARACTER*16 CMD
      CHARACTER*19 PARTPS,CRITNL,CNSINR
      CHARACTER*24 COMPOR,VALPLU,VITPLU,ACCPLU
      CHARACTER*24 DEPENT,VITENT,ACCENT
      CHARACTER*19 LISCHA,K19B
      CHARACTER*24 MODELE,MATE,CARELE,K24B
C ----------------------------------------------------------------------

C COMMANDE STAT_NON_LINE : ARCHIVAGE

C ----------------------------------------------------------------------

C IN   RESULT : NOM UTILISATEUR DU CONCEPT RESULTAT
C IN   NUMINS : NUMERO DE L'INSTANT
C IN   PARTPS : SD PARA_TEMPS
C IN   FORCE  : VRAI SI ON SOUHAITE FORCER L'ARCHIVAGE
C IN   COMPOR : CARTE DECRIVANT LE TYPE DE COMPORTEMENT
C IN   CRITNL : VALEUR DES CRITERES DE CONVERGENCE
C IN   VALPLU : ETAT EN T+
C IN   INCR   : VRAI S'IL FAUT INCREMENTER LE COMPTEUR D'ARCHIVAGE

C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------

      CHARACTER*32 JEXNUM,JEXNOM,JEXATR
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

C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------

      INTEGER JINST,JCRI,JCRR,JCRK,JPARA,LPARA(7),NBT
      INTEGER IRET,K,NUMARC,JCNSVR,IE,NEQ,JIFL,JFFL,I15,I16,I19,II
      INTEGER JDEPEN,JDEPP,JVITEN,JVITP,JACCEN,JACCP
      REAL*8 INSTAP,R8VIDE
      CHARACTER*8 K8BID
      CHARACTER*24 DEPPLU,SIGPLU,VARPLU,COMPLU,VARDEP,LAGDEP
      CHARACTER*24 CHAMP,K24BID
      INTEGER DIARCH
      REAL*8 DIINST
      LOGICAL DIINCL
      CHARACTER*19 CNOINR

      CALL JEMARQ()

      CALL DESAGG(VALPLU,DEPPLU,SIGPLU,VARPLU,K24BID,VARDEP,LAGDEP,
     &            K24BID,K24BID)

      NUMARC = DIARCH(PARTPS,NUMINS,FORCE,INCR)
      IF (NUMARC.GE.0) THEN

C      ON VERIFIE LA DIMENSION DE RESULT
        CALL RSEXCH(RESULT,'DEPL',NUMARC,CHAMP,IRET)
        IF (IRET.EQ.110) CALL RSAGSD(RESULT,0)


C      ARCHIVAGE DE L'INSTANT
        INSTAP = DIINST(PARTPS,NUMINS)
        CALL RSADPA(RESULT,'E',1,'INST',NUMARC,0,JINST,K8BID)
        ZR(JINST) = INSTAP

C      ARCHIVAGE DU MODELE, MATERIAU, CARA_ELEM ET DE LA SD CHARGE
       CALL RSSEPA(RESULT,NUMARC,MODELE(1:8),MATE(1:8),CARELE(1:8),
     &                LISCHA)

C      ARCHIVAGE DU COMPORTEMENT
        CALL RSEXCH(RESULT,'COMPORTEMENT',NUMARC,CHAMP,IRET)
        IF (IRET.LE.100) THEN
          CALL COPISD('CHAMP_GD','G',COMPOR(1:19),CHAMP(1:19))
          CALL RSNOCH(RESULT,'COMPORTEMENT',NUMARC,' ')
        END IF

C      ARCHIVAGE DU CONTACT
        CALL JEEXIN(CNSINR//'.CNSV',IRET)
        IF (IRET.NE.0) THEN
          CALL JEVEUO(CNSINR//'.CNSV','L',JCNSVR)
          CALL RSEXCH(RESULT,'VALE_CONT',NUMARC,CNOINR,IRET)
          CALL CNSCNO(CNSINR,' ','G',CNOINR)
          CALL RSNOCH(RESULT,'VALE_CONT',NUMARC,' ')
          CALL DETRSD('CHAM_NO_S',CNSINR)
        END IF

C      ARCHIVAGE DES CRITERES DE CONVERGENCE
        CALL JEEXIN(CRITNL//'.CRTR',IRET)
        IF (IRET.NE.0) THEN
          CALL JEVEUO(CRITNL//'.CRTR','L',JCRR)
          CALL JEVEUO(CRITNL//'.CRDE','L',JCRK)
          CALL JELIRA(CRITNL//'.CRDE','LONMAX',NBT,K8BID)
          CALL RSADPA(RESULT,'E',1,ZK16(JCRK),NUMARC,0,JPARA,K8BID)
          ZI(JPARA) = NINT(ZR(JCRR))
          CALL RSADPA(RESULT,'E',1,ZK16(JCRK+1),NUMARC,0,JPARA,K8BID)
          ZI(JPARA) = NINT(ZR(JCRR+1))
          NBT = NBT - 2
          CALL RSADPA(RESULT,'E',NBT,ZK16(JCRK+2),NUMARC,0,LPARA,K8BID)
          DO 10 K = 1,NBT
            ZR(LPARA(K)) = ZR(JCRR+2+K-1)
   10     CONTINUE
        END IF


C      DEPLACEMENTS
        IF (DIINCL(PARTPS,NUMINS,'DEPL')) THEN
          CALL RSEXCH(RESULT,'DEPL',NUMARC,CHAMP,IRET)
          IF (IRET.LE.100) THEN
            CALL COPISD('CHAMP_GD','G',DEPPLU(1:19),CHAMP(1:19))
            CALL RSNOCH(RESULT,'DEPL',NUMARC,' ')
            CALL NMIMPR('IMPR','ARCHIVAGE','DEPL',INSTAP,NUMARC)
          END IF
        END IF


        IF (CMD(1:4).EQ.'DYNA') THEN

C      CAS DES FORCE_FLUIDE
          IF (DIINCL(PARTPS,NUMINS,'DEPL')) THEN
            CALL JEEXIN ( '&&GFLECT.INDICE', IRET )
            IF ( IRET .NE. 0 ) THEN
               CALL JEVEUO ( '&&GFLECT.INDICE', 'L', JIFL ) 
               CALL JEVEUO ( '&&OP0070.GRAPPE_FLUIDE  ', 'L', JFFL ) 
               II = 5 + ZI(JIFL-1+5)
               I15 = ZI(JIFL-1+II+15)
               I16 = ZI(JIFL-1+II+16)
               I19 = ZI(JIFL-1+II+19)
               CALL RSADPA(RESULT,'E',1,'GFUM',NUMARC,0,JPARA,K8BID)
               ZR(JPARA) = ZR(JFFL-1+I15+1)
               CALL RSADPA(RESULT,'E',1,'GFUA',NUMARC,0,JPARA,K8BID)
               ZR(JPARA) = ZR(JFFL-1+I15+2)
               CALL RSADPA(RESULT,'E',1,'GFUML',NUMARC,0,JPARA,K8BID)
               ZR(JPARA) = ZR(JFFL-1+I15+3)
               CALL RSADPA(RESULT,'E',1,'GFUI',NUMARC,0,JPARA,K8BID)
               ZR(JPARA) = ZR(JFFL-1+I15+4)
               CALL RSADPA(RESULT,'E',1,'GFVAG',NUMARC,0,JPARA,K8BID)
               ZR(JPARA) = ZR(JFFL-1+I16+1)
           CALL RSADPA(RESULT,'E',1,'ITER_DASHPOT',NUMARC,0,JPARA,K8BID)
               ZI(JPARA) = ZI(JIFL-1+4)
               CALL RSADPA(RESULT,'E',1,'GFVFD',NUMARC,0,JPARA,K8BID)
               ZR(JPARA) = ZR(JFFL-1+I19+1)
               CALL RSADPA(RESULT,'E',1,'GFVAD',NUMARC,0,JPARA,K8BID)
               ZR(JPARA) = ZR(JFFL-1+I19+2)
            END IF
          END IF

C      VITESSES
          IF (DIINCL(PARTPS,NUMINS,'VITE')) THEN
            CALL RSEXCH(RESULT,'VITE',NUMARC,CHAMP,IRET)
            IF (IRET.LE.100) THEN
              CALL COPISD('CHAMP_GD','G',VITPLU(1:19),CHAMP(1:19))
              CALL RSNOCH(RESULT,'VITE',NUMARC,' ')
              CALL NMIMPR('IMPR','ARCHIVAGE','VITE',INSTAP,NUMARC)
            END IF
          END IF


C      ACCELERATIONS
          IF (DIINCL(PARTPS,NUMINS,'ACCE')) THEN
            CALL RSEXCH(RESULT,'ACCE',NUMARC,CHAMP,IRET)
            IF (IRET.LE.100) THEN
              CALL COPISD('CHAMP_GD','G',ACCPLU(1:19),CHAMP(1:19))
              CALL RSNOCH(RESULT,'ACCE',NUMARC,' ')
              CALL NMIMPR('IMPR','ARCHIVAGE','ACCE',INSTAP,NUMARC)
            END IF
          END IF

          IF (NBMODS.NE.0) THEN
            CALL JEVEUO(DEPENT(1:19)//'.VALE','E',JDEPEN)
            CALL JEVEUO(VITENT(1:19)//'.VALE','E',JVITEN)
            CALL JEVEUO(ACCENT(1:19)//'.VALE','E',JACCEN)
            CALL JEVEUO(DEPPLU(1:19)//'.VALE','L',JDEPP)
            CALL JEVEUO(VITPLU(1:19)//'.VALE','L',JVITP)
            CALL JEVEUO(ACCPLU(1:19)//'.VALE','L',JACCP)
            CALL JELIRA(DEPENT(1:19)//'.VALE','LONMAX',NEQ,K8BID)
            DO 20 IE = 1,NEQ
              ZR(JDEPEN+IE-1) = ZR(JDEPEN+IE-1) + ZR(JDEPP+IE-1)
              ZR(JVITEN+IE-1) = ZR(JVITEN+IE-1) + ZR(JVITP+IE-1)
              ZR(JACCEN+IE-1) = ZR(JACCEN+IE-1) + ZR(JACCP+IE-1)
   20       CONTINUE

C      DEPLACEMENTS ABSOLUS
            IF (DIINCL(PARTPS,NUMINS,'DEPL_ABSOLU')) THEN
              CALL RSEXCH(RESULT,'DEPL_ABSOLU',NUMARC,CHAMP,IRET)
              IF (IRET.LE.100) THEN
                CALL COPISD('CHAMP_GD','G',DEPENT(1:19),CHAMP(1:19))
                CALL RSNOCH(RESULT,'DEPL_ABSOLU',NUMARC,' ')
                CALL NMIMPR('IMPR','ARCHIVAGE','DEPL_ABSOLU',INSTAP,
     &                      NUMARC)
              END IF
            END IF


C      VITESSES ABSOLUES
            IF (DIINCL(PARTPS,NUMINS,'VITE_ABSOLU')) THEN
              CALL RSEXCH(RESULT,'VITE_ABSOLU',NUMARC,CHAMP,IRET)
              IF (IRET.LE.100) THEN
                CALL COPISD('CHAMP_GD','G',VITENT(1:19),CHAMP(1:19))
                CALL RSNOCH(RESULT,'VITE_ABSOLU',NUMARC,' ')
                CALL NMIMPR('IMPR','ARCHIVAGE','VITE_ABSOLU',INSTAP,
     &                      NUMARC)
              END IF
            END IF


C      ACCELERATIONS ABSOLUES
            IF (DIINCL(PARTPS,NUMINS,'ACCE_ABSOLU')) THEN
              CALL RSEXCH(RESULT,'ACCE_ABSOLU',NUMARC,CHAMP,IRET)
              IF (IRET.LE.100) THEN
                CALL COPISD('CHAMP_GD','G',ACCENT(1:19),CHAMP(1:19))
                CALL RSNOCH(RESULT,'ACCE_ABSOLU',NUMARC,' ')
                CALL NMIMPR('IMPR','ARCHIVAGE','ACCE_ABSOLU',INSTAP,
     &                      NUMARC)
              END IF

            END IF
          END IF
        END IF


C      CONTRAINTES
        IF (DIINCL(PARTPS,NUMINS,'SIEF_ELGA')) THEN
          CALL RSEXCH(RESULT,'SIEF_ELGA',NUMARC,CHAMP,IRET)
          IF (IRET.LE.100) THEN
            CALL COPISD('CHAMP_GD','G',SIGPLU(1:19),CHAMP(1:19))
            CALL RSNOCH(RESULT,'SIEF_ELGA',NUMARC,' ')
            CALL NMIMPR('IMPR','ARCHIVAGE','SIEF_ELGA',INSTAP,NUMARC)
          END IF
        END IF


C      VARIABLES INTERNES
        IF (DIINCL(PARTPS,NUMINS,'VARI_ELGA')) THEN
          CALL RSEXCH(RESULT,'VARI_ELGA',NUMARC,CHAMP,IRET)
          IF (IRET.LE.100) THEN
            CALL COPISD('CHAMP_GD','G',VARPLU(1:19),CHAMP(1:19))
            CALL RSNOCH(RESULT,'VARI_ELGA',NUMARC,' ')
            CALL NMIMPR('IMPR','ARCHIVAGE','VARI_ELGA',INSTAP,NUMARC)
          END IF
        END IF


C      VARIABLES NON LOCALES
        CALL EXISD('CHAMP_GD',VARDEP,IRET)
        IF (IRET.NE.0 .AND. DIINCL(PARTPS,NUMINS,'VARI_NON_LOCAL')) THEN
          CALL RSEXCH(RESULT,'VARI_NON_LOCAL',NUMARC,CHAMP,IRET)
          IF (IRET.LE.100) THEN
            CALL COPISD('CHAMP_GD','G',VARDEP,CHAMP)
            CALL RSNOCH(RESULT,'VARI_NON_LOCAL',NUMARC,' ')
            CALL NMIMPR('IMPR','ARCHIVAGE','VARI_NON_LOCAL',INSTAP,
     &                  NUMARC)
          END IF
        END IF


C      MULTIPLICATEURS DE LAGRANGE DES CHAMPS NON LOCAUX
        CALL EXISD('CHAMP_GD',LAGDEP,IRET)
        IF (IRET.NE.0 .AND. DIINCL(PARTPS,NUMINS,'LANL_ELGA')) THEN
          CALL RSEXCH(RESULT,'LANL_ELGA',NUMARC,CHAMP,IRET)
          IF (IRET.LE.100) THEN
            CALL COPISD('CHAMP_GD','G',LAGDEP,CHAMP)
            CALL RSNOCH(RESULT,'LANL_ELGA',NUMARC,' ')
            CALL NMIMPR('IMPR','ARCHIVAGE','LANL_ELGA',INSTAP,NUMARC)
          END IF
        END IF

      END IF


      CALL JEDEMA()
      END
