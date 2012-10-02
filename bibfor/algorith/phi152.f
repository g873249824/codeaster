      SUBROUTINE PHI152(MODEL,OPTION,MATE,PHIBAR,
     &                  MA,NU,NUM,NBMODE,SOLVEZ,INDICE,TABAD)
      IMPLICIT NONE
C---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/10/2012   AUTEUR DESOZA T.DESOZA 
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
C---------------------------------------------------------------------
C AUTEUR : G.ROUSSEAU
C
C CALCULS DES CONDITIONS AUX LIMITES POUR LA DETERMINATION
C DES POTENTIELS FLUCTUANTS POUR LA MASSE AJOUTEE, LA RAIDEUR
C AJOUTEE ET L AMORTISSEMENT AJOUTE EN THEORIE POTENTIELLE
C ET RESOLUTION DES PROBLEMES DE LAPLACE ASSOCIES
C IN : K* : MODEL : TYPE DE MODELISATION FLUIDE
C IN : K* : OPTION : OPTION DE CALCUL DES GRANDEURS AJOUTEES
C IN : K* : MATE : MATERIAU FLUIDE
C IN : K* : PHIBAR : NOM DU POTENTIEL PERMANENT
C IN : K* : MA : NOM DE LA MATRICE DE RAIDEUR FLUIDE
C IN : K* : NU : NUMEROTATION DES DDLS ASSOCIES AU FLUIDE
C IN : K* : NUM : NUMEROTATION DES DDLS ASSOCIES A L'INTERFACE
C           POTENTIELS FLUCTUANTS : 1 : MASSE AJOUTEE
C                                 : 2 : AMORTISSEMENT ET RAIDEUR
C IN : K* : SOLVEZ : METHODE DE RESOLUTION 'MULT_FRONT','LDLT' OU 'GCPC'
C---------------------------------------------------------------------
      INCLUDE 'jeveux.h'
      INTEGER       IBID,NBVALE,NBREFE,NBDESC,NBMODE,IRET,IERD
      INTEGER       ILIRES,J,NBID,IVALK,INDICE,TABAD(5)
      INTEGER       IPHI1,IPHI2,N5,N6,N7,N1,ICOR(2),N2,NDBLE
      REAL*8        BID,EBID,RBID
      CHARACTER*(*) OPTION,MATE, PHIBAR,SOLVEZ
      CHARACTER*2   MODEL
      CHARACTER*8   K8BID,MODMEC,MAILLA,MAFLUI,MA
      CHARACTER*8   MOFLUI,MOINT
      CHARACTER*14  NU,NUM
      CHARACTER*19  VECSO1,VECSO2,MAPREC,SOLVEU,CHSOL
      CHARACTER*19  VESTO1,VESTO2,CHAMNO
      CHARACTER*24  NOMCHA
      CHARACTER*24  PHIB24,CRITER
      COMPLEX*16    CBID
      INTEGER      IARG
      DATA MAPREC   /'&&OP0152.MAPREC'/
      DATA CHSOL    /'&&OP0152.SOLUTION'/
C -----------------------------------------------------------------
      DATA NDBLE /0/
C
      CALL JEMARQ()
      SOLVEU = SOLVEZ
      CRITER = '&&RESGRA_GCPC'
      INDICE=0
      CALL GETVID(' ','MODE_MECA',0,IARG,1,MODMEC,N5)
      CALL GETVID(' ','MODELE_FLUIDE',0,IARG,1,MOFLUI,N1)
      CALL GETVID(' ','MODELE_INTERFACE',0,IARG,1,MOINT,N2)
      CALL GETVID(' ','CHAM_NO',0,IARG,0,CHAMNO,N6)

C TEST POUR DETERMINER SI FLUIDE ET STRUCTURE S APPUIENT SUR
C DES MAILLAGES COMMUNS
      IF (N5.GT.0) THEN
        CALL RSEXCH(' ',MODMEC,'DEPL',1,NOMCHA,IRET)
        CALL RSORAC(MODMEC,'LONUTI',IBID,BID,K8BID,CBID,EBID,'ABSOLU',
     &             NBMODE,1,NBID)
        CALL DISMOI('F','NOM_MAILLA',NOMCHA(1:19),
     &              'CHAM_NO',IBID,MAILLA,IERD)
        CALL DISMOI('F','NOM_MAILLA',MOINT,
     &              'MODELE',IBID,MAFLUI,IERD)
          IF (MAFLUI.NE.MAILLA) THEN
           CALL TABCOR(MODEL,MATE,MAILLA,MAFLUI,MOINT,NUM,NDBLE,ICOR)
           CALL MAJOU(MODEL,MODMEC,SOLVEU,
     &     NUM,NU,MA,MATE,MOINT,NDBLE,ICOR,TABAD)
           INDICE=1
          ENDIF
      ENDIF

C---------------------------------------------------------------------
      IF (N6 .NE. 0) THEN
        N7 = -N6
      ELSE
        N7=0
      ENDIF

C
C=====================================================================
C---------------- ALTERNATIVE CHAMNO OU MODE_MECA OU---------
C-----------------------------MODELE-GENE--------------------
C=====================================================================
C DANS LE CAS OU ON N A PAS CALCUL DE MASSE AJOUTEE SUR UN
C MAILLAGE SQUELETTE

        IF ((N5.GT.0).AND.(INDICE.NE.1)) THEN

C
C----- -RECUPERATION DU NB DE MODES DU CONCEPT MODE_MECA
C
        CALL RSORAC(MODMEC,'LONUTI',IBID,BID,K8BID,CBID,EBID,'ABSOLU',
     &             NBMODE,1,NBID)

        CALL WKVECT('&&OP0152.PHI1','V V K24',NBMODE,IPHI1)
        CALL WKVECT('&&OP0152.PHI2','V V K24',NBMODE,IPHI2)

C======================================================================
C BOUCLE SUR LE NOMBRE DE MODES: CALCUL DU FLUX FLUIDE MODAL
C======================================================================
        ILIRES = 0
        PHIB24=PHIBAR

        DO 20 J=1,NBMODE

           CALL RSEXCH(' ',MODMEC,'DEPL',J,NOMCHA,IRET)

           NOMCHA=NOMCHA(1:19)
           VECSO1 = '&&OP0152.VECSOL1'
           VECSO2 = '&&OP0152.VECSOL2'

           CALL CALFLU(NOMCHA,MOFLUI,MATE,NU,VECSO1,NBDESC,NBREFE,
     &                 NBVALE,'R')

           ILIRES = ILIRES + 1

C------------- RESOLUTION  DU LAPLACIEN EN 2D-----------------------

           CALL RESOUD(MA    ,MAPREC,SOLVEU,' '   ,0     ,
     &                 VECSO1,CHSOL ,'V'   ,RBID  ,CBID  ,
     &                 CRITER,.TRUE.,0     ,IRET  )
           CALL JEDUPC('V',CHSOL(1:19),1,'V',VECSO1(1:19),.FALSE.)
           CALL DETRSD('CHAMP_GD',CHSOL)

C------------ CREATION DU VECTEUR PRESSION MODAL-------------------
C
C- FORMATION DU TABLEAU CONTENANT LA PRESSION POUR CHAQUE MODE-----
C
C------------------------------------------------------------------
          VESTO1='&&OP0152.VEST1'
          CALL PRSTOC(VECSO1,VESTO1,
     &                 ILIRES,ILIRES,IPHI1,NBVALE,NBREFE,NBDESC)
C
          IF (OPTION.EQ.'AMOR_AJOU'.OR.OPTION.EQ.'RIGI_AJOU')THEN

             CALL CAL2M(NOMCHA(1:19),PHIB24,MOFLUI,MATE,NU,VECSO2,
     &             NBDESC,NBREFE,NBVALE)

             CALL RESOUD(MA    ,MAPREC,SOLVEU,' '   ,0     ,
     &                   VECSO2,CHSOL ,'V'   ,RBID  ,CBID  ,
     &                   CRITER,.TRUE.,0     ,IRET  )
             CALL JEDUPC('V',CHSOL(1:19),1,'V',VECSO2(1:19),.FALSE.)
             CALL DETRSD('CHAMP_GD',CHSOL)

             VESTO2='&&OP0152.VEST2'
             CALL PRSTOC(VECSO2,VESTO2,
     &                 ILIRES,ILIRES,IPHI2,NBVALE,NBREFE,NBDESC)

          ENDIF

20    CONTINUE

         ELSE
           IF((N7.GT.0).AND.(INDICE.NE.1)) THEN

C================================================================
C ON FAIT LA MEME OPERATION SUR LES CHAMNO DE DEPL_R FOURNIS
C================================================================

           CALL WKVECT('&&OP0152.PHI1','V V K24',N7,IPHI1)
           CALL WKVECT('&&OP0152.PHI2','V V K24',N7,IPHI2)
           CALL WKVECT('&&OP0152.VEC','V V K8',N7,IVALK)
           CALL GETVID(' ','CHAM_NO',0,IARG,N7,ZK8(IVALK),N6)

           ILIRES = 0
           PHIB24=PHIBAR

           DO 5000 J =1,N7

             CHAMNO=ZK8(IVALK+J-1)
             VECSO1 = '&&OP0152.VESL1'
             VECSO2 = '&&OP0152.VESL2'

             CALL CALFLU(CHAMNO,MOFLUI,MATE,NU,VECSO1,
     &                 NBDESC,NBREFE,NBVALE,'R')

             ILIRES = ILIRES + 1


C-------------- RESOLUTION  DU LAPLACIEN EN 2D OU 3D-------------

           CALL RESOUD(MA    ,MAPREC,SOLVEU,' '   ,0     ,
     &                 VECSO1,CHSOL ,'V'   ,RBID  ,CBID  ,
     &                 CRITER,.TRUE.,0     ,IRET  )
           CALL JEDUPC('V',CHSOL(1:19),1,'V',VECSO1(1:19),.FALSE.)
           CALL DETRSD('CHAMP_GD',CHSOL)

C--------------- CREATION DU VECTEUR PRESSION -------------------
C
C--------- FORMATION DU TABLEAU CONTENANT LA PRESSION------------
C-------------POUR CHAQUE CHAMP AUX NOEUDS-----------------------

           VESTO1='&&OP0152.VEST1'
           CALL PRSTOC(VECSO1,VESTO1,ILIRES,ILIRES,IPHI1,
     &                 NBVALE,NBREFE,NBDESC)

          IF (OPTION.EQ.'AMOR_AJOU'.OR.OPTION.EQ.'RIGI_AJOU')THEN
             CALL CAL2M(CHAMNO,PHIB24,MOFLUI,MATE,NU,VECSO2,
     &             NBDESC,NBREFE,NBVALE)
             CALL RESOUD(MA    ,MAPREC,SOLVEU,' '   ,0     ,
     &                   VECSO2,CHSOL ,'V'   ,RBID  ,CBID  ,
     &                   CRITER,.TRUE.,0     ,IRET  )
             CALL JEDUPC('V',CHSOL(1:19),1,'V',VECSO2(1:19),.FALSE.)
             CALL DETRSD('CHAMP_GD',CHSOL)

             VESTO2='&&OP0152.VEST2'
             CALL PRSTOC(VECSO2,VESTO2,
     &                 ILIRES,ILIRES,IPHI2,NBVALE,NBREFE,NBDESC)
          ENDIF
C
5000       CONTINUE
            ENDIF
           ENDIF
C
      CALL JEEXIN (CRITER(1:19)//'.CRTI',IRET)
      IF ( IRET .NE. 0 ) THEN
         CALL JEDETR ( CRITER(1:19)//'.CRTI' )
         CALL JEDETR ( CRITER(1:19)//'.CRTR' )
         CALL JEDETR ( CRITER(1:19)//'.CRDE' )
      ENDIF

C----------------------------------------------------------------
      CALL JEDEMA()
      END
