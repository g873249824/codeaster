      SUBROUTINE XAPPAR(PREMIE,NOMA,MODELE,DEFICO,RESOCO)
C
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C
      IMPLICIT NONE
      LOGICAL      PREMIE
      CHARACTER*8  NOMA,MODELE
      CHARACTER*24 DEFICO,RESOCO
C
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (CONTACT - GRANDS GLISSEMENTS)
C
C REALISE L'APPARIEMENT ENTRE SURFACE ESCLAVE ET SURFACE MAITRE POUR
C LE CONTACT METHODE CONTINUE.
C
C TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C
C ----------------------------------------------------------------------
C
C
C METHODE : POUR CHAQUE POINT DE CONTACT (SUR UNE MAILLE ESCLAVE ET
C AVEC UN SCHEMA D'INTEGRATION DONNE), ON RECHERCHE LE NOEUD MAITRE LE
C PLUS PROCHE ET ON PROJETTE SUR LES MAILLES QUI L'ENTOURE
C
C STOCKAGE DES POINTS  DE CONTACT DES SURFACES  ESCLAVES ET APPARIEMENT
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  MODELE : NOM DU MODELE
C IN  PREMIE : VAUT .TRUE. SI PREMIER INSTANT DE STAT/DYNA_NON_LINE
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
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
      INTEGER      CFMMVD,ZMESX,ZTABF
      INTEGER      IFM,NIV
      INTEGER      I,IPC,TYCO
      INTEGER      NDIM,NTMAE,NTPC,NBPC
      INTEGER      CFDISI,MMINFI
      INTEGER      IFACE,IMAE,IZONE,IFAMIN
      INTEGER      JCESD,JCESV,JCESL,IAD
      INTEGER      MMAIT,AMAIT,NMAIT,GROUP,STATUE,STAMIN
      INTEGER      NUMMAE,NUMMIN
      INTEGER      NPTE,NFACE,NVIT,NARET
      REAL*8       GEOM(3),KSIPC1,KSIPC2,WPC
      REAL*8       T1MIN(3),T2MIN(3),XIMIN,YIMIN
      REAL*8       JEUMIN,COOR(3),NORM(3),NOOR
      REAL*8       RRE,RRM
      CHARACTER*8  ALIAS
      CHARACTER*19 CHSGE,CHSGM,CHSLO,CHSCF,CHSAI,CHSPI,CHSLT
      CHARACTER*24 CNCTE
      CHARACTER*24 TABFIN,MAESCX
      INTEGER      JTABF,JMAESX,NINTER
      LOGICAL      MMINFL,PROJIN,LCINIT,LGLISS
      INTEGER      JXC
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('XFEM',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<XFEM> ... APPARIEMENT'
      ENDIF
C
C --- RECUPERATION DE QUELQUES DONNEES
C
      TABFIN = RESOCO(1:14)//'.TABFIN'
      MAESCX = DEFICO(1:16)//'.MAESCX'
      CNCTE  = DEFICO(1:16)//'.CNCTE'
      CALL JEVEUO(TABFIN,'E',JTABF)
      CALL JEVEUO(MAESCX,'L',JMAESX)
C
      ZTABF  = CFMMVD('ZTABF')
      ZMESX  = CFMMVD('ZMESX')
C
C --- INITIALISATIONS
C
      CHSGE  = '&&XAPPAR.CHSGE'
      CHSGM  = '&&XAPPAR.CHSGM'
      CHSLO  = '&&XAPPAR.CHSLO'
      CHSCF  = '&&XAPPAR.CHSCF'
      CHSAI  = '&&XAPPAR.CHSAI'
      CHSPI  = '&&XAPPAR.CHSPI'
      CHSLT  = '&&XAPPAR.CHSLT'
      NTPC   = 0
      DO 9 I=1,3
        GEOM(I)  = 0.D0
        T1MIN(I) = 0.D0
        T2MIN(I) = 0.D0
  9   CONTINUE
      NDIM   = CFDISI(DEFICO,'NDIM' )
      NTMAE  = CFDISI(DEFICO,'NTMAE')
C
C --- ON RECUPERE RESPECTIVEMENT :
C --- LES CHAMPS DES GEOMETRIE ESCLAVE ET MAITRE
C --- LES INFOS SUR LE NOMBRES DE PT D'INTER ET LE NBRE DE FACETTE
C --- LES INFOS SUR LES ARETES COUPEES
C --- LES NUMERO LOCAUX DES NOEUDS DES FACETTES DE CONTACT
C --- LE CHAMP NOEUD DE LA LST
C
      CALL CELCES(MODELE//'.TOPOFAC.GE','V',CHSGE)
      CALL CELCES(MODELE//'.TOPOFAC.GM','V',CHSGM)
      CALL CELCES(MODELE//'.TOPOFAC.LO','V',CHSLO)
      CALL CELCES(MODELE//'.TOPOFAC.AI','V',CHSAI)
      CALL CELCES(MODELE//'.TOPOFAC.CF','V',CHSCF)
      CALL CELCES(MODELE//'.TOPOFAC.PI','V',CHSPI)
      CALL CELCES(MODELE//'.LTNO','V',CHSLT)
C
      CALL JEVEUO(CHSLO//'.CESD','L',JCESD)
      CALL JEVEUO(CHSLO//'.CESV','L',JCESV)
      CALL JEVEUO(CHSLO//'.CESL','L',JCESL)
C
C --- BOUCLE SUR LES MAILLES ESCLAVES
C
      DO 100 IMAE=1,NTMAE
C
C --- ZONE DE CONTACT
C
        IZONE  = ZI(JMAESX+ZMESX*(IMAE-1)+2-1)
C
C --- OPTIONS SUR LA ZONE DE CONTACT
C
        TYCO   =  MMINFI(DEFICO,'INTEGRATION'   ,IZONE )
        LGLISS =  MMINFL(DEFICO,'GLISSIERE_ZONE',IZONE )
        LCINIT = (MMINFI(DEFICO,'CONTACT_INIT'  ,IZONE ).EQ.1)
C
C --- INFOS SUR LA MAILLE ESCLAVE COURANTE
C
        NUMMAE = ZI(JMAESX+ZMESX*(IMAE-1)+1-1)
        NBPC   = ZI(JMAESX+ZMESX*(IMAE-1)+3-1)
        STATUE = ZI(JMAESX+ZMESX*(IMAE-1)+4-1)
C
        CALL JEVEUO(MODELE//'.XFEM_CONT'  ,'L',JXC)
        IF(NDIM.EQ.2) THEN
          IF(ZI(JXC).LE.2) ALIAS='SE2'
          IF(ZI(JXC).EQ.3) ALIAS='SE3'
        ELSEIF(NDIM.EQ.3) THEN
           ALIAS='TR3'
        ENDIF
C
C --- ON RECUPERE LE NOMBRE DE POINTS D'INTERSECTION
C --- DE LA MAILLE ESCLAVE
C
        CALL CESEXI('C',JCESD,JCESL,NUMMAE,1,1,1,IAD)
        CALL ASSERT(IAD.GT.0)
        NINTER   = ZI(JCESV-1+IAD)
C
C --- ON RECUPERE LE NOMBRE DE POINTS PAR FACETTE
C --- DE LA MAILLE ESCLAVE
        CALL CESEXI('C',JCESD,JCESL,NUMMAE,1,1,3,IAD)
        CALL ASSERT(IAD.GT.0)
        NPTE   = ZI(JCESV-1+IAD)
C
C --- ON RECUPERE LE NOMBRE DE FACETTES DE CONTACT DE LA MAILLE ESCLAVE
C
        CALL CESEXI('C',JCESD,JCESL,NUMMAE,1,1,2,IAD)
        CALL ASSERT(IAD.GT.0)
        NFACE  = ZI(JCESV-1+IAD)

        IF (NBPC.EQ.0) GO TO 100
C
C --- BOUCLE SUR LES FACETTES DE CONTACT
C
        DO 105 IFACE  = 1,NFACE
C
C --- APPARIEMENT - BOUCLE SUR LES POINTS DE CONTACT
C
          DO 110 IPC = 1,NBPC
C
C --- COORDONNEES DANS ELEMENT DE REFERENCE ET POIDS DU POINT DE CONTACT
C
            CALL MMGAUS(ALIAS ,TYCO  ,IPC   ,KSIPC1,KSIPC2,
     &                  WPC   )
C
C --- CALCUL DES COORDONNEES REELLES DU POINT DE CONTACT
C
            CALL XCOPCO(CHSGE ,CHSCF ,ALIAS ,NDIM  ,NUMMAE,
     &                  IFACE ,KSIPC1,KSIPC2,NPTE,GEOM  )
C
C --- RECHERCHE DU PT D'INTERSECTION SUR LE COTE MA�TRE LE PLUS PROCHE
C --- DU POINT DE CONTACT
C
            CALL XMREPT(NDIM  ,DEFICO,CHSGM ,CHSLO ,CHSAI ,
     &                  GEOM  ,STATUE,MMAIT ,AMAIT ,NMAIT )
C
C --- PROJECTION DU PT DE CONTACT SUR LA FACETTE DE CONTACT
C --- LA PLUS PROCHE
C
            CALL XMREMA(NOMA  ,NDIM  ,DEFICO,IZONE ,ALIAS ,
     &                  MMAIT ,AMAIT ,NMAIT ,STATUE,GEOM  ,
     &                  CHSGM ,CHSLO ,CHSCF ,NUMMIN,NUMMAE,
     &                  IFAMIN,IFACE ,JEUMIN,T1MIN ,T2MIN ,
     &                  XIMIN ,YIMIN ,PROJIN,STAMIN)
C
C --- NUMEROS DES MAILLE ESCLAVE ET MAITRE
C
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+1)  = NUMMAE
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+2)  = NUMMIN
C
C --- COORDONNEES GEOMETRIQUES DU POINT DE CONTACT
C
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+3)  = KSIPC1
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+12) = KSIPC2
C
C --- VECTEURS TANGENTS DANS LE POINT DE CONTACT
C
C --- EN 3D, ON ORIENTE LES TANGENTES
C
            IF (NDIM.EQ.3) THEN
C --- ON CALCULE LA NORMALE
              CALL PROVEC(T1MIN ,T2MIN ,NORM  )
              CALL NORMEV(NORM  ,NOOR  )
C --- ON PROJETE LA DIRECTION X SUR SUR LE PLAN TANGENT,
C --- POUR OBTENIR LA PREMIERE DIRECTION TANGENTE
              T1MIN(1) = 1-NORM(1)**2
              T1MIN(2) = -NORM(1)*NORM(2)
              T1MIN(3) = -NORM(1)*NORM(3)
C --- DEUXI�ME DIRECTION TANGENTE
              CALL PROVEC(NORM  ,T1MIN ,T2MIN )
C
C --- NORMALISATION DES VECTEURS TANGENTS
C
              CALL NORMEV(T1MIN  ,NOOR  )
              CALL NORMEV(T2MIN  ,NOOR  )
C
            ENDIF
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+6)  = T1MIN(1)
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+7)  = T1MIN(2)
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+8)  = T1MIN(3)
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+9)  = T2MIN(1)
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+10) = T2MIN(2)
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+11) = T2MIN(3)
C
C --- NUMERO DE LA ZONE DE FISSURE
C
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+15) = IZONE
C
C --- POIDS DU POINT DU CONTACT
C
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+16) = WPC
C
C --- NOMBRE DE POINTS D'INTERSECTIONS ESCLAVE
C
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+24) = NPTE
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+14) = NINTER
C
C --- NUMERO DE LA FACETTE ESCLAVE
C
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+25) = IFACE
C
C --- NOMBRE DE FACETTES ESCLAVES
C
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+26) = NFACE
C
C --- COORDONNEES DANS L'ELEMENT PARENT MAITRE
C
            CALL XMCOOR(CHSCF ,CHSPI ,NDIM ,NPTE ,NUMMIN,IFAMIN,
     &                  XIMIN ,YIMIN ,COOR  )
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+20) = COOR(1)
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+21) = COOR(2)
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+23) = COOR(3)
C
C --- STATUT DE LA MAILLE MAITRE
C
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+32) = STAMIN
C
C --- CALCUL DE SQRT LST DU PT DE CONTACT MAITRE
C
            CALL XMRLST(NOMA  ,CHSLT ,NUMMIN,COOR  ,RRM  )
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+31) = RRM
C
            IF (PREMIE) THEN
C
C --- STATUT DE LA MAILLE ESCLAVE
C
C              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+14) = STATUE
C
C --- COORDONNEES DANS L'ELEMENT PARENT ESCLAVE
C
              CALL XMCOOR(CHSCF ,CHSPI ,NDIM,NPTE  ,NUMMAE,IFACE ,
     &                    KSIPC1,KSIPC2,COOR  )
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+17) = COOR(1)
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+18) = COOR(2)
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+19) = COOR(3)
C
C --- CALCUL DE SQRT LST DU PT DE CONTACT ESCLAVE
C
              CALL XMRLST(NOMA  ,CHSLT,NUMMAE,COOR  ,RRE   )
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+30) = RRE
C
C --- POINT D'INTEGRATION VITAL OU PAS
C --- NUMERO DE GROUPE ET D'ARETE (SI LE PT EST SUR UNE ARETE CONNECT�E)
C
              IF (TYCO.EQ.12 .OR. TYCO.EQ.13 .OR. TYCO.EQ.14) THEN
                NVIT  = 1
                GROUP = 0
                NARET = 0
              ELSE
                CALL XPIVIT(CHSCF ,CHSAI ,CNCTE ,NDIM  ,NUMMAE,
     &                    IFACE ,KSIPC1,KSIPC2,NVIT  ,GROUP  ,
     &                    NARET )
              ENDIF
C
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+27) = NVIT
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+4)  = GROUP
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+5)  = NARET
C
C --- CONTACT_INIT (13) ET MEMOIRE DE CONTACT (28) LA MEMO DE CONTACT
C --- EST INITIALISEE AVEC CONTACT_INI ET SERT POUR LE CONTACT GLISSIERE
C
              IF (LCINIT) THEN
                ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+13) = 1.D0
                ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+28) = 1.D0
              ELSE
                ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+13) = 0.D0
                ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+28) = 0.D0
              ENDIF
C
C --- ON RENSEIGNE LE CONTACT GLISSIERE SI DECLARE
C
              IF (LGLISS) THEN
                ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+29) = 1.D0
              ELSE
                ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+29) = 0.D0
              ENDIF
            ENDIF
C
C --- NOEUDS EXCLUS PAR PROJECTION HORS ZONE
C
            IF (.NOT. PROJIN) THEN
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+22) = 1.D0
            ELSE
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+22) = 0.D0
            ENDIF
 110      CONTINUE
        NTPC = NTPC + NBPC
 105    CONTINUE
 100  CONTINUE
      ZR(JTABF-1+1) = NTPC
      CALL ASSERT(NTPC.EQ.CFDISI(DEFICO,'NTPC'))
C
C --- MENAGE
C
      CALL DETRSD('CHAM_ELEM_S',CHSGE)
      CALL DETRSD('CHAM_ELEM_S',CHSGM)
      CALL DETRSD('CHAM_ELEM_S',CHSLO)
      CALL DETRSD('CHAM_ELEM_S',CHSAI)
      CALL DETRSD('CHAM_ELEM_S',CHSCF)
      CALL DETRSD('CHAM_ELEM_S',CHSPI)
      CALL DETRSD('CHAM_ELEM_S',CHSLT)
C
      CALL JEDEMA()
      END
