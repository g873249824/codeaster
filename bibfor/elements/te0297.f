      SUBROUTINE TE0297(OPTION,NOMTE)
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 31/01/2012   AUTEUR REZETTE C.REZETTE 
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
C RESPONSABLE GENIAUT S.GENIAUT
C
C    - FONCTION REALISEE:  CALCUL DES OPTIONS DE POST-TRAITEMENT
C                          EN M�CANIQUE DE LA RUPTURE
C                          POUR LES �L�MENTS X-FEM
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................


C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      INTEGER NDIM,NNO,NNOP,NPG,IER
      INTEGER NFH,NFE,DDLC,NSE,ISE,IN,INO
      INTEGER JPINTT,JCNSET,JHEAVT,JLONCH,JBASLO,IGEOM,IDEPL
      INTEGER IPRES,IPREF,ITEMPS,JPTINT,JAINT,JCFACE,JLONGC,IMATE
      INTEGER ITHET,I,J,COMPT,IGTHET,IBID,JLSN,JLST,IDECPG,ICODE
      INTEGER NFACE,CFACE(5,3),IFA,SINGU,JPMILT
      INTEGER IRESE,DDLM,JBASEC,NPTF,NFISS,JFISNO
      REAL*8  THET,R8PREM,VALRES(3),DEVRES(3),PRESN(27),VALPAR(4)
      REAL*8  PRES,FNO(81),RHO,COORSE(81)
      INTEGER   ICODRE(3)
      CHARACTER*8   ELREFP,ELRESE(6),FAMI(6),NOMRES(3),NOMPAR(4),ENR
      LOGICAL ISMALI

      DATA    ELRESE /'SE2','TR3','TE4','SE3','TR6','TE4'/
      DATA    FAMI   /'BID','RIGI','XINT','BID','RIGI','XINT'/
      DATA    NOMRES /'E','NU','ALPHA'/

      CALL ELREF1(ELREFP)
      CALL JEVECH('PTHETAR','L',ITHET)
      CALL ELREF4(' ','RIGI',NDIM,NNOP,IBID,IBID,IBID,IBID,IBID,IBID)

C     SI LA VALEUR DE THETA EST NULLE SUR L'�L�MENT, ON SORT
      COMPT = 0
      DO 10 I = 1,NNOP
        THET = 0.D0
        DO 11 J = 1,NDIM
          THET = THET + ABS(ZR(ITHET+NDIM*(I-1)+J-1))
 11     CONTINUE
        IF (THET.LT.R8PREM()) COMPT = COMPT + 1
 10   CONTINUE
      IF (COMPT.EQ.NNOP) GOTO 9999

C     SOUS-ELEMENT DE REFERENCE : RECUP DE NNO, NPG ET IVF
      IF (.NOT.ISMALI(ELREFP).AND. NDIM.LE.2) THEN
        IRESE=3
      ELSE
        IRESE=0
      ENDIF
      CALL ELREF4(ELRESE(NDIM+IRESE),FAMI(NDIM+IRESE),IBID,NNO,IBID,NPG,
     &                                          IBID,IBID,IBID,IBID)

C     INITIALISATION DES DIMENSIONS DES DDLS X-FEM
      CALL XTEINI(NOMTE,NFH,NFE,SINGU,DDLC,IBID,IBID,IBID,
     &            DDLM,NFISS,IBID)

C     ------------------------------------------------------------------
C              CALCUL DE G, K1, K2, K3 SUR L'ELEMENT MASSIF
C     ------------------------------------------------------------------
C
C     PARAM�TRES PROPRES � X-FEM
      CALL JEVECH('PPINTTO','L',JPINTT)
      CALL JEVECH('PCNSETO','L',JCNSET)
      CALL JEVECH('PHEAVTO','L',JHEAVT)
      CALL JEVECH('PLONCHA','L',JLONCH)
      CALL JEVECH('PBASLOR','L',JBASLO)
      CALL JEVECH('PLSN','L',JLSN)
      CALL JEVECH('PLST','L',JLST)
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PDEPLAR','L',IDEPL)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PGTHETA','E',IGTHET)
C     PROPRE AUX ELEMENTS 1D ET 2D (QUADRATIQUES)
      CALL TEATTR (NOMTE,'S','XFEM',ENR,IER)
      IF (IER.EQ.0 .AND.(ENR.EQ.'XH'.OR.ENR.EQ.'XHC').AND. NDIM.LE.2)
     &  CALL JEVECH('PPMILTO','L',JPMILT)
      IF (NFISS.GT.1) CALL JEVECH('PFISNO','L',JFISNO)

C     CALCUL DES FORCES NODALES CORRESPONDANT AUX CHARGES VOLUMIQUES
      CALL XCGFVO(OPTION,NDIM,NNOP,FNO,RHO)

C     R�CUP�RATION DE LA SUBDIVISION DE L'�L�MENT EN NSE SOUS ELEMENT
      NSE=ZI(JLONCH-1+1)

C       BOUCLE SUR LES NSE SOUS-ELEMENTS
      DO 110 ISE=1,NSE

C       BOUCLE SUR LES SOMMETS DU SOUS-TRIA (DU SOUS-SEG)
        DO 111 IN=1,NNO
          INO=ZI(JCNSET-1+NNO*(ISE-1)+IN)
          DO 112 J=1,NDIM
            IF (INO.LT.1000) THEN
              COORSE(NDIM*(IN-1)+J)=ZR(IGEOM-1+NDIM*(INO-1)+J)
            ELSEIF (INO.GT.1000 .AND. INO.LT.2000) THEN
              COORSE(NDIM*(IN-1)+J)=ZR(JPINTT-1+NDIM*(INO-1000-1)+J)
            ELSEIF (INO.GT.2000 .AND. INO.LT.3000) THEN
              COORSE(NDIM*(IN-1)+J)=ZR(JPMILT-1+NDIM*(INO-2000-1)+J)
            ELSEIF (INO.GT.3000) THEN
              COORSE(NDIM*(IN-1)+J)=ZR(JPMILT-1+NDIM*(INO-3000-1)+J)
            ENDIF
 112      CONTINUE
 111    CONTINUE

        IDECPG = NPG * (ISE-1)

        CALL XSIFEL(ELREFP,NDIM,COORSE,IGEOM,JHEAVT,ISE,NFH,
     &              DDLC,DDLM,NFE,RHO,ZR(JBASLO),NNOP,IDEPL,
     &              ZR(JLSN),ZR(JLST),IDECPG,IGTHET,FNO,NFISS,JFISNO)

 110  CONTINUE

      IF (OPTION.EQ.'K_G_MODA') GOTO 9999

C     ------------------------------------------------------------------
C              CALCUL DE G, K1, K2, K3 SUR LES LEVRES
C     ------------------------------------------------------------------

      IF (OPTION.EQ.'CALC_K_G') THEN
C       SI LA PRESSION N'EST CONNUE SUR AUCUN NOEUD, ON LA PREND=0.
        CALL JEVECD('PPRESSR',IPRES,0.D0)
      ELSEIF (OPTION.EQ.'CALC_K_G_F') THEN
        CALL JEVECH('PPRESSF','L',IPREF)
        CALL JEVECH('PTEMPSR','L',ITEMPS)

C       RECUPERATION DES PRESSIONS AUX NOEUDS PARENTS
        NOMPAR(1)='X'
        NOMPAR(2)='Y'
        IF (NDIM.EQ.3) NOMPAR(3)='Z'
        IF (NDIM.EQ.3) NOMPAR(4)='INST'
        IF (NDIM.EQ.2) NOMPAR(3)='INST'
        DO 70 I = 1,NNOP
          DO 80 J = 1,NDIM
            VALPAR(J) = ZR(IGEOM+NDIM*(I-1)+J-1)
 80       CONTINUE
          VALPAR(NDIM+1)= ZR(ITEMPS)
          CALL FOINTE('FM',ZK8(IPREF),NDIM+1,NOMPAR,VALPAR,
     &                                      PRESN(I),ICODE)
 70     CONTINUE
      ENDIF

C     SI LA VALEUR DE LA PRESSION EST NULLE SUR L'�L�MENT, ON SORT
      COMPT = 0
      DO 90 I = 1,NNOP
        IF (OPTION.EQ.'CALC_K_G')   PRES = ABS(ZR(IPRES-1+I))
        IF (OPTION.EQ.'CALC_K_G_F') PRES = ABS(PRESN(I))
        IF (PRES.LT.R8PREM()) COMPT = COMPT + 1
 90   CONTINUE
      IF (COMPT.EQ.NNOP) GOTO 9999

C     PARAMETRES PROPRES A X-FEM
      CALL JEVECH('PPINTER','L',JPTINT)
      CALL JEVECH('PAINTER','L',JAINT)
      CALL JEVECH('PCFACE' ,'L',JCFACE)
      CALL JEVECH('PLONGCO','L',JLONGC)
      CALL JEVECH('PBASECO','L',JBASEC)

C     R�CUP�RATIONS DES DONN�ES SUR LA TOPOLOGIE DES FACETTES
      NFACE=ZI(JLONGC-1+2)
      NPTF=ZI(JLONGC-1+3)
      DO 20 I=1,NFACE
        DO 21 J=1,NPTF
          CFACE(I,J)=ZI(JCFACE-1+NDIM*(I-1)+J)
 21     CONTINUE
 20   CONTINUE

C     RECUPERATION DES DONNEES MATERIAU AU 1ER POINT DE GAUSS DE
C     DE L'ELEMENT PARENT !!
C     LE MAT�RIAU DOIT ETRE HOMOGENE DANS TOUT L'ELEMENT
      CALL RCVAD2('RIGI',1,1,'+',ZI(IMATE),'ELAS',3,NOMRES,
     &            VALRES,DEVRES,ICODRE)
      IF ((ICODRE(1).NE.0) .OR. (ICODRE(2).NE.0)) THEN
        CALL U2MESS('F','RUPTURE1_25')
      END IF
      IF (ICODRE(3) .NE. 0) THEN
        VALRES(3) = 0.D0
        DEVRES(3) = 0.D0
      END IF

C     BOUCLE SUR LES FACETTES
      DO 200 IFA=1,NFACE
        CALL XSIFLE(NDIM,IFA,JPTINT,JAINT,CFACE,IGEOM,NFH,SINGU,
     &       NFE,DDLC,DDLM,JLST,IPRES,IPREF,ITEMPS,IDEPL,NNOP,
     &       VALRES,ZR(JBASLO),ITHET,NOMPAR,PRESN,OPTION,IGTHET,JBASEC)
 200  CONTINUE


9999  CONTINUE
      END
