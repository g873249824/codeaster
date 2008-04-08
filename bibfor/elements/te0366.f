       SUBROUTINE TE0366(OPTION,NOMTE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 08/04/2008   AUTEUR MEUNIER S.MEUNIER 
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
C
      IMPLICIT   NONE
      CHARACTER*16 OPTION,NOMTE
C
C ----------------------------------------------------------------------
C  CALCUL CALCUL DES MATRICES DE CONTACT ET DE FROTTEMENT
C  DE COULOMB STANDARD  AVEC LA METHODE CONTINUE (ECP)
C
C  OPTION : 'RIGI_CONT' (CALCUL DES MATRICES DE CONTACT )
C           'RIGI_FROT' (CALCUL DES MATRICES DE FROTTEMENT STANDARD)
C
C  ENTREES  ---> OPTION : OPTION DE CALCUL
C           ---> NOMTE  : NOM DU TYPE ELEMENT
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
C
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
C
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------
C
      INTEGER I,J,IJ,NFAES,NFAMA
      INTEGER NNE,NNES,NNM,NNC,NDDL,NDDLC,NDIM,INDCO
      INTEGER IGEOM,IDEPL,IMATT,JPCPO,IGEOMT,IGEOES,IGEOMA
      INTEGER IDEPM,JPCPI,JPCAI,JPCCF,IAINES,IAINMA
      INTEGER INDNOR,IAXIS,IFROTT,IFACES,IFACMA
      INTEGER IPINES,IPINMA
      INTEGER IRET,IBID,CFACE(5,3)
      REAL*8 COEFCA,NOOR,R8PREM
      REAL*8 XPR,YPR,XPC,YPC,HPG,XES(3),XMA(3)
      REAL*8 MMAT(81,81),TAU1(3),TAU2(3),NORM(3)
      REAL*8 GEOMM(3),GEOME(3),RBID,GRAD,EPS
      REAL*8 FFPC(9),DFFPC(2,9),DDFFPC(3,9),JACOBI
      REAL*8 FFPR(9),DFFPR(2,9),DDFFPR(3,9),DFDI,F
      REAL*8 FFES(9)
      REAL*8 FFMA(9)
      CHARACTER*8 ESC,MAIT,ELC,ESQ
      CHARACTER*19 GEOM2,PINTES,PINTMA,COORDE,COORDM
      CHARACTER*19 AINTES,AINTMA,CFACES,CFACMA
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INFOS SUR LA MAILLE DE CONTACT
C
      CALL XMELET(NOMTE,
     &            NDIM,NDDL,NDDLC,ESC,ESQ,NNE,MAIT,NNM,ELC,NNC)
      IF (NDDL.GT.81) THEN
        CALL U2MESS('F','ELEMENTS3_79')
      ENDIF
C
C --- INITIALISATIONS
C
      DO 7 I=1,5
        DO 8 J=1,3
          CFACE(I,J)=0
  8     CONTINUE
  7   CONTINUE
C
      DO 9 I = 1,NDIM
        GEOME(I)  = 0.D0
        GEOMM(I)  = 0.D0
        XES(I)    = 0.D0
        XMA(I)    = 0.D0
 9    CONTINUE
C
      DO 10 I = 1,NDDL
        DO 20 J = 1,NDDL
          MMAT(I,J) = 0.D0
   20   CONTINUE
   10 CONTINUE
C
      GEOM2 ='&&TE0366.GEOM2'
      PINTES='&&TE0366.PINES'
      PINTMA='&&TE0366.PINMA'
      COORDE='&&TE0366.GEOME'
      COORDM='&&TE0366.GEOMM'
      AINTES='&&TE0366.AINTE'
      AINTMA='&&TE0366.AINTM'
      CFACES='&&TE0366.CFACE'
      CFACMA='&&TE0366.CFACM'
C
C --RECUPERATION DES DONNEES DE LA CARTE CONTACT 'POINT' (VOIR MMCART)
      CALL JEVECH('PCAR_PT','L',JPCPO)
      XPC      = ZR(JPCPO-1+1)
      YPC      = ZR(JPCPO-1+10)
      XPR      = ZR(JPCPO-1+2)
      YPR      = ZR(JPCPO-1+3)
      TAU1(1)  = ZR(JPCPO-1+4)
      TAU1(2)  = ZR(JPCPO-1+5)
      TAU1(3)  = ZR(JPCPO-1+6)
      TAU2(1)  = ZR(JPCPO-1+7)
      TAU2(2)  = ZR(JPCPO-1+8)
      TAU2(3)  = ZR(JPCPO-1+9)
      INDCO    = NINT(ZR(JPCPO-1+11))
C      LAMBDA   = ZR(JPCPO-1+12)
      COEFCA   = ZR(JPCPO-1+13)
C      COEFFA   = ZR(JPCPO-1+14)
C      COEFFF   = ZR(JPCPO-1+15)
      IFROTT   = NINT(ZR(JPCPO-1+16))
      INDNOR   = NINT(ZR(JPCPO-1+17))
      IAXIS    = NINT(ZR(JPCPO-1+18))
      HPG      = ZR(JPCPO-1+19)
C
C---LES NUMEROS DES FACETTES DE CONTACT (ESCLAVE ET MAITRE) DONT LE
C---PTC ET SON PROJETE APPARTIENT
      NFAES    = NINT(ZR(JPCPO-1+31))
      NFAMA    = NINT(ZR(JPCPO-1+32))
C--------------------------------------------------------------------
C      IMA      = NINT(ZR(JPCPO-1+34))
C
C --RECUPERATION DES DONNEES DE LA CARTE CONTACT 'PINTER' (VOIR MMCART)
      CALL JEVECH('PCAR_PI','L',JPCPI)
C
C --RECUPERATION DES DONNEES DE LA CARTE CONTACT 'AINTER' (VOIR MMCART)
      CALL JEVECH('PCAR_AI','L',JPCAI)
C
C --RECUPERATION DES DONNEES DE LA CARTE CONTACT 'CFACE' (VOIR MMCART)
      CALL JEVECH('PCAR_CF','L',JPCCF)
C
C --- RECUPERATION DE LA GEOMETRIE ET DES CHAMPS DE DEPLACEMENT
C
      CALL JEVECH('PGEOMER','E',IGEOM)
      CALL JEVECH('PDEPL_P','E',IDEPL)
      CALL JEVECH('PDEPL_M','L',IDEPM)
C----ON CREE UN CHAMP 'LOCAL' DE LA G�OMETRIE (POUR MANIPULER PAR LA
C----SUITE LES NOEUDS FICTIFS
C
      CALL WKVECT(GEOM2,'V V R',NDIM*(NNE+NNM),IGEOMT)
      DO 50 I=1,NDIM*(NNE+NNM)
        ZR(IGEOMT+I-1)=ZR(IGEOM+I-1)
  50  CONTINUE
C
C-----NOMBRE DE NOEUDS ESCLAVES SOMMETES(EN 3D IL FAUDRA MODIFIER ICI)
      NNES=NNE/2
C
C --- REACTUALISATION DE LA GEOMETRIE
C
      CALL XMREAC(NDIM,NNES,NNM,
     &            IGEOMT,IDEPM)
C
C --- FONCTIONS DE FORMES ET DERIVEES POUR LE
C --- POINT DE CONTACT
C
      CALL XMMFFD(ELC,XPC,YPC,
     &            FFPC,DFFPC,DDFFPC,IRET)
C
C --- FONCTIONS DE FORMES ET DERIVEES POUR LA
C --- PROJECTION DU POINT DE CONTACT DANS 'ELC'
C
      CALL XMMFFD(ELC,XPR,YPR,
     &            FFPR,DFFPR,DDFFPR,IRET)
C
C----CONSTRUCTION DU CHAMP DES COORDONN�ES G�OMETRIQUE POUR LA
C----MAILLE ESCLAVE (SEULEMENT POUR LES NOEUDS SOMMETS)
C
      CALL WKVECT(COORDE,'V V R',NDIM*NNES,IGEOES)
      DO 60 I=1,NNES
        DO 70 J=1,NDIM
          ZR(IGEOES-1+(I-1)*NDIM+J)=ZR(IGEOMT-1+(I-1)*NDIM+J)
  70   CONTINUE
 60   CONTINUE
C
C----CONSTRUCTION DU CHAMP DES COORDONN�ES G�OMETRIQUE POUR LA
C----MAILLE MAITRE
C
      CALL WKVECT(COORDM,'V V R',NDIM*NNM,IGEOMA)
      DO 80 I=1,NNM
        DO 90 J=1,NDIM
          ZR(IGEOMA-1+(I-1)*NDIM+J)=
     &              ZR(IGEOMT-1+NDIM*NNE+(I-1)*NDIM+J)
 90     CONTINUE
 80   CONTINUE
C
C----CONSTRUCTION DES CHAMPS AINTES ET AINTMA (INFO SUR LES ARRETES
C----COUP�S DANS LA MAILLE ESCLAVE, RESPECTIVEMENT MAITRE )
C
      CALL WKVECT(AINTES,'V V R',24,IAINES)
      CALL WKVECT(AINTMA,'V V R',24,IAINMA)
      DO 81 I=1,24
        ZR(IAINES-1+I)= ZR(JPCAI-1+I)
        ZR(IAINMA-1+I)= ZR(JPCAI-1+24+I)
 81   CONTINUE
C
C----CONSTRUCTION DES CHAMPS CFACES ET CFACMA (INFO SUR LA
C----CONNECTIVIT� DES FACETTES DANS LA MAILLE ESCLAVE,
C----RESPECTIVEMENT MAITRE )
C
      CALL WKVECT(CFACES,'V V R',24,IFACES)
      CALL WKVECT(CFACMA,'V V R',24,IFACMA)
      DO 82 I=1,15
        ZR(IFACES-1+I)= ZR(JPCCF-1+I)
        ZR(IFACMA-1+I)= ZR(JPCCF-1+15+I)
 82   CONTINUE
C
C----ON CONSTRUIT LA MATRICE DE CONNECTIVIT� CFACE (MAILLE ESCLAVE)
C--!!!ATTENTION, POUR L'INSTANT CE QUI SUIT EST VALABLE QUE EN 2D!!
C      NFACE=1
      CFACE(1,1)=1
      CFACE(1,2)=2
C
C      DO 83 I=1,NFACE
C        DO 84 J=1,NDIM
C          CFACE(I,J)=NINT(ZR(IFACES-1+NDIM*(I-1)+J))
C 84     CONTINUE
C 83   CONTINUE
C
C ---CALCUL DES COORDONN�ES R�ELES DES POINTS D'INTERSECTION ESCLAVES
      CALL WKVECT(PINTES,'V V R',NDIM*NDIM,IPINES)
      DO 100 I=1,NDIM*NDIM
        ZR(IPINES-1+I)=0.D0
 100  CONTINUE
      CALL XMPINT(ESC,NDIM,IGEOES,JPCPI,
     &               NFAES,1,NNES,IPINES)
C
C ---CALCUL DES COORDONN�ES R�ELES DES POINTS D'INTERSECTION MAITRES
      CALL WKVECT(PINTMA,'V V R',NDIM*NDIM,IPINMA)
      DO 110 I=1,NDIM*NDIM
        ZR(IPINMA-1+I)=0.D0
 110  CONTINUE
      CALL XMPINT(MAIT,NDIM,IGEOMA,JPCPI,
     &               NFAMA,2,NNM,IPINMA)
C
C --- JACOBIEN POUR LE POINT DE CONTACT
C
      CALL MMMJAC(ELC   ,IPINES,FFPC  ,DFFPC ,IAXIS ,
     &            NDIM  ,JACOBI)
C
C----CALCUL DES COORDONN�ES R�ELES DU POINT DE CONTACT
      DO 120 I = 1,NDIM
        DO 130 J = 1,NNC
          GEOME(I) = GEOME(I) +
     &               FFPC(J)*ZR(IPINES-1+(J-1)*NDIM+I)
 130    CONTINUE
 120  CONTINUE
C
C---- FONCTIONS DE FORME POUR LE POINT DE CONTACT DANS LA MAILLE ESCLAVE
C
      CALL REEREF(ESC,NNES,IGEOES,GEOME,RBID,.FALSE.,NDIM,RBID,
     &            IBID,IBID,IBID,RBID,RBID,'NON',XES,FFES,DFDI,
     &            F,EPS,GRAD)
C
C----CALCUL DES COORDONN�ES R�ELES DU PROJETE DU POINT DE CONTACT
      DO 140 I = 1,NDIM
        DO 150 J = 1,NNC
          GEOMM(I) = GEOMM(I) +
     &               FFPR(J)*ZR(IPINMA-1+(J-1)*NDIM+I)
 150    CONTINUE
 140  CONTINUE
C
C---- FONCTIONS DE FORME POUR LE PROJETEDU POINT DE CONTACT
C-----DANS LA MAILLE MAITRE

      CALL REEREF(MAIT,NNM,IGEOMA,GEOMM,RBID,.FALSE.,NDIM,RBID,
     &            IBID,IBID,IBID,RBID,RBID,'NON',XMA,FFMA,DFDI,
     &            F,EPS,GRAD)
C
C --- CALCUL DE LA NORMALE
C
      CALL MMNORM(NDIM,TAU1,TAU2,NORM,NOOR)
      IF (NOOR.LE.R8PREM()) THEN
        CALL ASSERT(.FALSE.)
      ENDIF
C
      IF (INDNOR .EQ. 1) THEN
        INDCO = 0
      ENDIF
C
C --- RECUPERATION DE LA MATRICE 'OUT' (A REMPLIR => MODE ECRITURE)
C
      CALL JEVECH('PMATUUR','E',IMATT)
C
C --- CALCUL DES MATRICES DE CONTACT

      IF (OPTION.EQ.'RIGI_CONT') THEN
        IF (INDCO.EQ.1) THEN
C
C --- CALCUL DE LA MATRICE A - CAS DU CONTACT
C
          CALL XMMAA1(NDIM,NNE,NNES,NNC,NNM,NFAES,CFACE,
     &                HPG,FFPC,FFES,FFMA,JACOBI,IAINES,
     &                COEFCA,NORM,ESQ,MMAT)
C
        ELSE IF (INDCO .EQ. 0) THEN
C
C --- CALCUL DE LA MATRICE A - CAS SANS CONTACT
C
          CALL XMMAA0(NDIM,NNC,NNE,NNES,HPG,NFAES,CFACE,
     &              FFPC,JACOBI,IAINES,COEFCA,ESQ,MMAT)
        ELSE
C             SI INDCO N'EST NI EGAL A 0 NI EGAL A 1
          CALL U2MESS('F','DVP_98')
        ENDIF
C
      ELSEIF (OPTION.EQ.'RIGI_FROT') THEN
        IF (IFROTT.NE.3)    INDCO = 0
C
        IF (INDCO.EQ.0) THEN
C
C --- CALCUL DE LA MATRICE F - CAS SANS FROTTEMENT
C
          CALL XMMAB0(NDIM,NNC,NNE,NNES,NFAES,IAINES,
     &                HPG,FFPC,JACOBI,ESQ,CFACE,
     &                TAU1,TAU2,
     &                MMAT)
        ELSE
C
C --- ATTENTION, LE FROTTEMENT PAS
C --- PRIS EN COMPTE POUR LES GRANDS GLISSEMENTS!!!---'
        CALL ASSERT(.FALSE.)
C
        ENDIF

      ENDIF
C
C --- FIN DE CHANGEMENT ET COPIE
C
      DO 760 J = 1,NDDL
        DO 750 I = 1,J
          IJ = (J-1)*J/2 + I
          ZR(IMATT+IJ-1) = MMAT(I,J)
 750    CONTINUE
 760  CONTINUE
C
      CALL JEDETR(GEOM2)
      CALL JEDETR(PINTES)
      CALL JEDETR(PINTMA)
      CALL JEDETR(COORDE)
      CALL JEDETR(COORDM)
      CALL JEDETR(AINTES)
      CALL JEDETR(AINTMA)
      CALL JEDETR(CFACES)
      CALL JEDETR(CFACMA)
C
      CALL JEDEMA()
      END
