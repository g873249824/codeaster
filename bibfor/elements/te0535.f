      SUBROUTINE TE0535(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 23/07/2012   AUTEUR FLEJOU J-L.FLEJOU 
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
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16 OPTION,NOMTE
C --- ------------------------------------------------------------------
C
C     CALCUL DES OPTIONS FULL_MECA OU RAPH_MECA OU RIGI_MECA_TANG
C     POUR LES ELEMENTS DE POUTRE 'MECA_POU_D_EM'
C
C     'MECA_POU_D_EM' : POUTRE DROITE D'EULER MULTIFIBRES
C
C --- ------------------------------------------------------------------
C IN  OPTION : K16 : NOM DE L'OPTION A CALCULER
C     NOMTE  : K16 : NOM DU TYPE ELEMENT
C --- ------------------------------------------------------------------
      INTEGER     IGEOM,ICOMPO,IMATE,ISECT,IORIEN,ND,NK,IRET
      INTEGER     ICARCR,ICONTM,IDEPLM,IDEPLP,IMATUU,ISECAN
      INTEGER     IVECTU,ICONTP,NNO,NC,IVARIM,IVARIP,I,ISICOM
      PARAMETER  (NNO=2,NC=6,ND=NC*NNO,NK=ND*(ND+1)/2)
      REAL*8      E,NU,G,XL,XJX,GXJX,EPSM
      INTEGER     LX
      REAL*8      PGL(3,3),FL(ND),KLV(NK),SK(NK)
      REAL*8      DEPLM(12),DEPLP(12),MATSEC(6),DEGE(6)
      REAL*8      ZERO,DEUX
      INTEGER     JDEFM,JDEFP,JMODFB,JSIGFB,NBFIB,NCARFI,JACF,NBVALC
      INTEGER     JTAB(7),IVARMP,ISTRXP,ISTRXM
      INTEGER     IP,INBF,JCRET,CODRET,CODREP
      INTEGER     IPOSCP,IPOSIG,IPOMOD,IINSTP,IINSTM
      INTEGER     ICOMAX,ICO,NBGF,ISDCOM,NBGFMX
      REAL*8      XI,WI,B(4),GG,VS(3),VE(12)
      REAL*8      DEFAM(6),DEFAP(6)
      REAL*8      ALICOM,DALICO,SS1,HV,HE,MINUS
      REAL*8      VV(12),FV(12),SV(78),KSG(3),R8PREM
      LOGICAL     VECTEU,MATRIC
      CHARACTER*8 MATOR
      PARAMETER  (ZERO=0.0D+0,DEUX=2.D+0)

C --- ------------------------------------------------------------------
      CALL JEVECH('PNBSP_I','L',INBF)
C     NOMBRE DE FIBRES TOTAL DE L'ELEMENT
      NBFIB = ZI(INBF)
      CALL JEVECH('PFIBRES','L',JACF)
      NCARFI = 3
      CODRET = 0
      CODREP = 0
C
C --- BOOLEENS PRATIQUES
      MATRIC = OPTION .EQ. 'FULL_MECA' .OR. OPTION .EQ. 'RIGI_MECA_TANG'
      VECTEU = OPTION .EQ. 'FULL_MECA' .OR. OPTION .EQ. 'RAPH_MECA'
C
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCOMPOR','L',ICOMPO)
      CALL JEVECH('PINSTMR','L',IINSTM)
      CALL JEVECH('PINSTPR','L',IINSTP)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PCAGNPO','L',ISECT)
      CALL JEVECH('PCAORIE','L',IORIEN)
      CALL JEVECH('PCARCRI','L',ICARCR)
      CALL JEVECH('PDEPLMR','L',IDEPLM)
C --- LA PRESENCE DU CHAMP DE DEPLACEMENT A L INSTANT T+
C     DEVRAIT ETRE CONDITIONNE  PAR L OPTION (AVEC RIGI_MECA_TANG
C     CA N A PAS DE SENS).
C     CEPENDANT CE CHAMP EST INITIALISE A 0 PAR LA ROUTINE NMMATR.
      CALL JEVECH('PDEPLPR','L',IDEPLP)
      CALL TECACH('OON','PCONTMR',7,JTAB,IRET)
      ICONTM = JTAB(1)

      CALL JEVECH('PSTRXMR','L',ISTRXM)

      CALL TECACH('OON','PVARIMR',7,JTAB,IRET)
      IVARIM = JTAB(1)

      IF (VECTEU) THEN
         CALL TECACH('OON','PVARIMP',7,JTAB,IRET)
         IVARMP = JTAB(1)
      ENDIF
C
C --- DEFORMATIONS ANELASTIQUES
      CALL R8INIR (6,0.D0,DEFAM,1)
      CALL R8INIR (6,0.D0,DEFAP,1)
C --- PARAMETRES EN SORTIE
      IF (OPTION.EQ.'RIGI_MECA_TANG') THEN
         CALL JEVECH('PMATUUR','E',IMATUU)
         IVARIP = IVARIM
         ICONTP = ICONTM
         ISTRXP = ISTRXM
      ELSE IF (OPTION.EQ.'FULL_MECA') THEN
         CALL JEVECH('PMATUUR','E',IMATUU)
         CALL JEVECH('PVECTUR','E',IVECTU)
         CALL JEVECH('PCONTPR','E',ICONTP)
         CALL JEVECH('PVARIPR','E',IVARIP)
         CALL JEVECH('PSTRXPR','E',ISTRXP)
      ELSE IF (OPTION.EQ.'RAPH_MECA') THEN
         CALL JEVECH('PVECTUR','E',IVECTU)
         CALL JEVECH('PCONTPR','E',ICONTP)
         CALL JEVECH('PVARIPR','E',IVARIP)
         CALL JEVECH('PSTRXPR','E',ISTRXP)
      END IF
C
C --- ------------------------------------------------------------------
C --- RECUPERATION DU NOMBRE DE FIBRES TOTAL DE L'ELEMENT
C     ET DU NOMBRE DE GROUPES DE FIBRES SUR CET ELEMENT
      NBGF = ZI(INBF+1)
C
C --- RECUPERATION DE LA SD_COMPOR OU LE COMPORTEMENT DES GROUPES DE
C     FIBRES DE CET ELEMENT EST STOCKE
C     (NOM, MATER, RELATION, NBFIG POUR CHAQUE GROUPE
C     DANS L'ORDRE CROISSANT DE NUMEROS DE GROUPES)
      CALL JEVEUO(ZK16(ICOMPO-1+7),'L',ISDCOM)
      READ (ZK16(ICOMPO-1+2),'(I16)') NBVALC
C
C --- ON RESERVE QUELQUES PLACES
      CALL WKVECT('&&TE0535.DEFMFIB','V V R8',NBFIB,JDEFM)
      CALL WKVECT('&&TE0535.DEFPFIB','V V R8',NBFIB,JDEFP)
      CALL WKVECT('&&TE0535.MODUFIB','V V R8',(NBFIB*2),JMODFB)
      CALL WKVECT('&&TE0535.SIGFIB', 'V V R8',(NBFIB*2),JSIGFB)
C --- ------------------------------------------------------------------
C --- LONGUEUR DE L'ELEMENT
      LX = IGEOM - 1
      XL = SQRT((ZR(LX+4)-ZR(LX+1))**2+ (ZR(LX+5)-ZR(LX+2))**2+
     &     (ZR(LX+6)-ZR(LX+3))**2)
      IF (XL.EQ.ZERO) THEN
         CALL U2MESS('F','ELEMENTS_17')
      END IF
C --- CARACTERISTIQUES ELASTIQUES (PAS DE TEMPERATURE POUR L'INSTANT)
C     ON PREND LE E ET NU DU MATERIAU TORSION (VOIR OP0059)
      CALL JEVEUO(ZK16(ICOMPO-1+7)(1:8)//'.CPRI','L',ISICOM)
      NBGFMX = ZI(ISICOM+2)
      MATOR  = ZK16(ISDCOM-1+NBGFMX*6+1)(1:8)
      CALL MATELA(ZI(IMATE),MATOR,0,0.D0,E,NU)
      G = E/ (2.D0* (1.D0+NU))
C --- TORSION A PART
      XJX  = ZR(ISECT+7)
      GXJX = G*XJX
C --- CALCUL DES MATRICES DE CHANGEMENT DE REPERE
      CALL MATROT(ZR(IORIEN),PGL)
C --- DEPLACEMENTS DANS LE REPERE LOCAL
      CALL UTPVGL(NNO,NC,PGL,ZR(IDEPLM),DEPLM)
      CALL UTPVGL(NNO,NC,PGL,ZR(IDEPLP),DEPLP)
      EPSM = (DEPLM(7)-DEPLM(1))/XL
C --- ON RECUPERE ALPHA MODE INCOMPATIBLE=ALICO
      ALICOM=ZR(ISTRXM+15)
C
C --- MISES A ZERO
      CALL R8INIR(NK,ZERO,KLV,1)
      CALL R8INIR(NK,ZERO,SK,1)
      CALL R8INIR(12,ZERO,FL,1)
      CALL R8INIR(12,ZERO,FV,1)
C
C --- BOUCLE POUR CALCULER LE ALPHA MODE INCOMPATIBLE : ALICO
      ICOMAX=100
      MINUS=1.D-6
      SS1=ZERO
      DALICO=ZERO
      DO 700 ICO=1,ICOMAX
         HE=ZERO
         HV=ZERO
C ---    BOUCLE SUR LES POINTS DE GAUSS
         DO 500 IP=1,2
C ---       POSITION, POIDS X JACOBIEN ET MATRICE B ET G
            CALL PMFPTI(IP,XL,XI,WI,B,GG)
C ---       DEFORMATIONS '-' ET INCREMENT DE DEFORMATION PAR FIBRE
C           MOINS --> M
            CALL PMFDGE(B,GG,DEPLM,ALICOM,DEGE)
            CALL PMFDEF(NBFIB,NCARFI,ZR(JACF),DEGE,ZR(JDEFM))
C  --       INCREMENT --> P
            CALL PMFDGE(B,GG,DEPLP,DALICO,DEGE)
            CALL PMFDEF(NBFIB,NCARFI,ZR(JACF),DEGE,ZR(JDEFP))
C
            IPOSIG=JSIGFB + NBFIB*(IP-1)
            IPOMOD=JMODFB + NBFIB*(IP-1)
C ---       MODULE ET CONTRAINTES SUR CHAQUE FIBRE (COMPORTEMENT)
            CALL PMFMCF(IP,NBGF,NBFIB,ZI(INBF+2),ZK16(ISDCOM),
     &            ZR(ICARCR),OPTION,ZR(IINSTM),ZR(IINSTP),ZI(IMATE),
     &            NBVALC,DEFAM,DEFAP,ZR(IVARIM),ZR(IVARMP),
     &            ZR(ICONTM),ZR(JDEFM),ZR(JDEFP),EPSM,ZR(IPOMOD),
     &            ZR(IPOSIG),ZR(IVARIP),ISECAN,CODREP)
C
            IF (CODREP.NE.0) THEN
               CODRET = CODREP
C              CODE 3: ON CONTINUE ET ON LE RENVOIE A LA FIN
C              AUTRE CODES: SORTIE IMMEDIATE
               IF (CODREP.NE.3) GOTO 900
            ENDIF
C ---       CALCUL MATRICE SECTION
            CALL PMFITE(NBFIB,NCARFI,ZR(JACF),ZR(IPOMOD),MATSEC)
C ---       INTEGRATION DES CONTRAINTES SUR LA SECTION
            CALL PMFITS(NBFIB,NCARFI,ZR(JACF),ZR(IPOSIG),VS)
C ---       CALCULS MODE INCOMPATIBLE HV=INT(GT KS G), HE=INT(GT FS)
            HV = HV+WI*GG*GG*MATSEC(1)
            HE = HE+WI*GG*VS(1)
500      CONTINUE
C ---    FIN BOUCLE POINTS DE GAUSS
C ---    ENCORE UN PEU DE MODE INCOMPATIBLE
         IF ( ABS(HV) .LE. R8PREM() ) THEN
            CALL U2MESS('F','ELEMENTS_8')
         ENDIF
         DALICO = DALICO-HE/HV
         IF(ICO.EQ.1)THEN
            IF (ABS(VS(1)).LE.MINUS)THEN
               GOTO 710
            ELSE
               SS1 = ABS(VS(1))
            ENDIF
         ENDIF
         IF(ABS(HE).LE.(SS1*MINUS))THEN
            GOTO 710
         ENDIF
700   CONTINUE
C --- FIN BOUCLE CALCUL ALICO
710   CONTINUE

C --- QUAND ON A CONVERGE SUR ALICO, ON PEUT INTEGRER SUR L'ELEMENT
      DO 800 IP=1,2
         CALL PMFPTI(IP,XL,XI,WI,B,GG)
C ---    CALCUL LA MATRICE ELEMENTAIRE (SAUF POUR RAPH_MECA)
         IF (OPTION.NE.'RAPH_MECA')THEN
            IPOMOD = JMODFB + NBFIB*(IP-1)
            CALL PMFITE(NBFIB,NCARFI,ZR(JACF),ZR(IPOMOD),MATSEC)
            CALL PMFBKB(MATSEC,B,WI,GXJX,SK)
            DO 320 I = 1,NK
               KLV(I) = KLV(I)+SK(I)
320         CONTINUE
C ---       ON SE SERT DE PMFBTS POUR CALCULER BT,KS,G. G EST SCALAIRE
            KSG(1) = MATSEC(1)*GG
            KSG(2) = MATSEC(2)*GG
            KSG(3) = MATSEC(3)*GG
            CALL PMFBTS(B,WI,KSG,VV)
            DO 340 I=1,12
               FV(I) = FV(I)+VV(I)
340         CONTINUE
         ENDIF
C ---    SI PAS RIGI_MECA_TANG, ON CALCULE LES FORCES INTERNES
         IF(OPTION.NE.'RIGI_MECA_TANG')THEN
            IPOSIG=JSIGFB + NBFIB*(IP-1)
            CALL PMFITS(NBFIB,NCARFI,ZR(JACF),ZR(IPOSIG),VS)
            CALL PMFBTS(B,WI,VS,VE)
            DO 360 I=1,12
               FL(I) = FL(I)+VE(I)
360         CONTINUE
         ENDIF
800   CONTINUE
C --  ON MODIFIE LA MATRICE DE RAIDEUR PAR CONDENSATION STATIQUE
      IF (OPTION.NE.'RAPH_MECA')THEN
         CALL PMFFFT(FV,SV)
         DO 380 I=1,NK
            KLV(I) = KLV(I) - SV(I)/HV
380     CONTINUE
      ENDIF
C
C --- TORSION A PART POUR LES FORCES INTERNE
      FL(10) = GXJX*(DEPLM(10)+DEPLP(10)-DEPLM(4)-DEPLP(4))/XL
      FL(4)  = -FL(10)
C --- PASSAGE DU REPERE LOCAL AU REPERE GLOBAL ---
      IF ( MATRIC ) THEN
C ---    ON SORT LA MATRICE DE RIGIDITE TANGENTE
         CALL UTPSLG(NNO,NC,PGL,KLV,ZR(IMATUU))
      END IF
      IF ( VECTEU ) THEN
C ---    ON SORT LES CONTRAINTES SUR CHAQUE FIBRE
         DO 310 IP=1,2
            IPOSCP=ICONTP + NBFIB*(IP-1)
            IPOSIG=JSIGFB + NBFIB*(IP-1)
            DO 300 I=0,NBFIB-1
               ZR(IPOSCP+I) = ZR(IPOSIG+I)
300         CONTINUE
310      CONTINUE
         CALL UTPVLG( NNO, NC, PGL, FL, ZR(IVECTU) )
C
C ---    STOCKE LES FORCES INTEGREES POUR EVITER DES CALCULS PLUS TARD
C        NX=FL(7), TY=FL(8), TZ=FL(9), MX=FL(10)
C        MY=(FL(11)-FL(5))/DEUX, MZ=(FL(12)-FL(6))/DEUX
         ZR(ISTRXP-1+1) =  FL(7)
         ZR(ISTRXP-1+2) =  FL(8)
         ZR(ISTRXP-1+3) =  FL(9)
         ZR(ISTRXP-1+4) =  FL(10)
         ZR(ISTRXP-1+5) = (FL(11)-FL(5))/DEUX
         ZR(ISTRXP-1+6) = (FL(12)-FL(6))/DEUX
C        ON STOCKE LE ALPHA MODE INCOMPATIBLE
         ZR(ISTRXP+15)=ALICOM+DALICO
      END IF

900   CONTINUE
C --- SORTIE PROPRE: CODE RETOUR ET LIBERATION DES RESSOURCES
      IF ( VECTEU ) THEN
         CALL JEVECH('PCODRET','E',JCRET)
         ZI(JCRET) = CODRET
      END IF
C
      CALL JEDETR('&&TE0535.DEFMFIB')
      CALL JEDETR('&&TE0535.DEFPFIB')
      CALL JEDETR('&&TE0535.MODUFIB')
      CALL JEDETR('&&TE0535.SIGFIB')
      END
