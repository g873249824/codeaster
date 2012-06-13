      SUBROUTINE SFIFJ ( NOMRES )
      IMPLICIT   NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C-----------------------------------------------------------------------
C     CALCUL DE LA FONCTION ACCEPTANCE
C     TURBULENCE DE COUCHE LIMITE
C     AUTEUR : G. ROUSSEAU
C-----------------------------------------------------------------------
C
      INCLUDE 'jeveux.h'
      INTEGER       NFINIT, NFIN,NBM,NBPOIN,NBPAR,NBID,IBAS,IPG,IARG
      INTEGER       NPOIN, IFF, IVARE, LVALE, LPROL, IBID, IN,IVAL(3)
      INTEGER       IM1, IM2, IVATE, IVECX, IVECY, IVECZ, NVECX, NVECY
      INTEGER       NVECO,IER,NCHAM,JPARA,JORDR,PGJ,NPG,INOMS,IND,NBPA2
      PARAMETER     ( NBPAR = 8,NBPA2 = 6 )
      REAL*8        FMIN, FMAX, FINIT, FFIN, DF, F, R8PREM, DSPPRS, PRS
      REAL*8        KSTE, UFLUI, DHYD, RHO, RBID, JC, FCOUPU, FMODEL
      REAL*8        R8B, DIR(3,3), FCOUP, COOPGJ(4)
      REAL*8        DEUXPI,PULS,UC,UT,LONG1,LONG2
      REAL*8 VALR
      COMPLEX*16    C16B
      CHARACTER*8   K8B, NOMRES, IS
      CHARACTER*8   SPECTR, METHOD, TYPAR(NBPAR),TYPA2(NBPA2)
      CHARACTER*16  NOPAR(NBPAR),NOPA2(NBPA2), KVAL(2), LOCOR
      CHARACTER*19  BASE, NOFON,FONCT, CHAMNO, PG, PHI,SPHI,NOFONS
      CHARACTER*24  LIGRMO
      LOGICAL       YANG
C
      DATA NOPAR / 'NOM_CHAM' , 'OPTION' , 'DIMENSION' ,
     &             'NUME_VITE_FLUI' , 'VITE_FLUIDE' ,
     &             'NUME_ORDRE_I' , 'NUME_ORDRE_J' , 'FONCTION_C' /
      DATA TYPAR / 'K16' , 'K16' , 'I' , 'I' , 'R' , 'I' , 'I' , 'K24' /
      DATA NOPA2 / 'NOM_CHAM' , 'OPTION' , 'DIMENSION' ,
     &             'NUME_ORDRE_I' , 'NUME_ORDRE_J' , 'FONCTION_C' /
      DATA TYPA2 / 'K16' , 'K16' , 'I' , 'I' , 'I' , 'K24' /
      DATA         DEUXPI/6.28318530718D0/,YANG/.FALSE./
C
C-----------------------------------------------------------------------
      CALL JEMARQ()
C
C RECHERCHE DE LA PRESENCE D'UN CHAMNO
      CALL GETVID(' ','CHAM_NO',0,IARG,0,CHAMNO,NCHAM)
C
      IF (NCHAM.EQ.0) THEN
C
C RECUPERATION DE LA BASE MODALE
         CALL GETVID ( ' ', 'MODE_MECA', 0,IARG,1, BASE, IBID )
C
         CALL JEVEUO(BASE//'.ORDR', 'L', JORDR )
         CALL JELIRA(BASE//'.ORDR', 'LONUTI', NBM, K8B )
C
C RECUPERATION DE LA FREQUENCE MINIMALE ET MAX DES MODES
C
         CALL RSADPA(BASE,'L',1,'FREQ',ZI(JORDR-1+1),0,JPARA,K8B)
         FMIN = ZR(JPARA)
         CALL RSADPA(BASE,'L',1,'FREQ',ZI(JORDR-1+NBM),0,JPARA,K8B)
         FMAX = ZR(JPARA)
      ELSE
         CALL GETVID(' ','CHAM_NO',0,IARG,1,CHAMNO,NCHAM)
         CALL CHPVER('F',CHAMNO,'NOEU','DEPL_R',IER)
         NBM = 1
      ENDIF
C
C RECUPERATION DE LA FREQUENCE MINIMALE ET MAX DE LA PLAGE
C DE FREQUENCE ETUDIEE
C
      CALL GETVR8 ( ' ', 'FREQ_INIT', 0,IARG,1, FINIT, NFINIT )
      CALL GETVR8 ( ' ', 'FREQ_FIN' , 0,IARG,1, FFIN , NFIN   )
      IF ( (FFIN-FINIT) .LT. R8PREM() ) THEN
         CALL U2MESS('F','MODELISA6_97')
      ENDIF
C
      IF ( NFINIT .LT. 0 ) THEN
         IF (NCHAM.NE.0)
     &     CALL U2MESS('F','MODELISA6_98')
         VALR = FMIN
         CALL U2MESG('I','MODELISA9_15',0,' ',0,0,1,VALR)
         FINIT=FMIN
      ENDIF
      IF ( NFIN .LT. 0 ) THEN
         IF (NCHAM.NE.0)
     &     CALL U2MESS('F','MODELISA6_99')
         VALR = FMAX
         CALL U2MESG('I','MODELISA9_16',0,' ',0,0,1,VALR)
         FFIN=FMAX
      ENDIF
C
C DISCRETISATION FREQUENTIELLE
      CALL GETVIS ( ' ', 'NB_POIN', 0,IARG,1, NBPOIN, NPOIN )
C
C PAS FREQUENTIEL
      DF = (FFIN-FINIT) / (NBPOIN-1)
      IF ( DF .LT. R8PREM() ) THEN
         CALL U2MESS('F','MODELISA7_1')
      ENDIF
C
C CALCUL DE L'ACCEPTANCE
C
      CALL GETVID ( ' ', 'SPEC_TURB', 0,IARG,1, SPECTR, IBID )
      CALL JEVEUO(SPECTR//'           .VARE','L',IVARE)
      CALL JEVEUO(SPECTR//'           .VATE','L',IVATE)
C
C RECUPERATION DES CONSTANTES DU SPECTRES DU
C MODELE 5 : CONSTANT PUIS NUL POUR FR > 10
C
      IF (ZK16(IVATE).EQ.'SPEC_CORR_CONV_1') THEN
         UFLUI  = ZR(IVARE+2)
         RHO    = ZR(IVARE+3)
         FCOUPU = ZR(IVARE+4)
         KSTE   = ZR(IVARE+5)
         DHYD   = ZR(IVARE+6)
C LONGUEURS DE CORRELATION
         LONG1=ZR(IVARE)
         LONG2=ZR(IVARE+1)
C VITESSE CONVECTIVE RADIALE (METHODE AU-YANG)
         UC=ZR(IVARE+7)*UFLUI
C VITESSE CONVECTIVE ORTHORADIALE (METHODE AU-YANG)
         UT=ZR(IVARE+8)*UFLUI
C
C CALCUL DE LA FREQUENCE DE COUPURE PRONE PAR LE MODELE
C ET COMPARAISON AVEC LA FREQUENCE DE COUPURE DONNEE PAR
C L UTILISATEUR
C
        FMODEL = 10.D0 * UFLUI / DHYD
        IF ( FCOUPU .LE. FMODEL ) THEN
           VALR = FCOUPU
           CALL U2MESG('I','MODELISA9_17',0,' ',0,0,1,VALR)
           VALR = FMODEL
           CALL U2MESG('I','MODELISA9_18',0,' ',0,0,1,VALR)
           CALL U2MESG('I','MODELISA9_19',0,' ',0,0,0,0.D0)
           FCOUP = FCOUPU * DHYD / UFLUI
        ELSE
           VALR = FCOUPU
           CALL U2MESG('I','MODELISA9_20',0,' ',0,0,1,VALR)
           VALR = FMODEL
           CALL U2MESG('I','MODELISA9_21',0,' ',0,0,1,VALR)
           CALL U2MESG('I','MODELISA9_22',0,' ',0,0,0,0.D0)
           FCOUP = 10.D0
        ENDIF
C
C RECUPERATION DE LA METHOD DE LA FONCTION
C DE COHERENCE
C
        METHOD = ZK16(IVATE+10)(1:8)
      ELSEIF (ZK16(IVATE).EQ.'SPEC_CORR_CONV_2') THEN
        UFLUI=ZR(IVARE)
        FCOUP=ZR(IVARE+1)
        METHOD=ZK16(IVATE+4)(1:8)
        FONCT =ZK16(IVATE+1)
      ELSEIF (ZK16(IVATE).EQ.'SPEC_CORR_CONV_3') THEN
        FONCT =ZK16(IVATE+1)
        GOTO 10
      ENDIF
C

C RECUPERATION DES DIRECTIONS DU PLAN DE LA PLANCHE
      IF ( METHOD(1:6) .EQ. 'CORCOS' ) THEN
         CALL GETVR8(' ','VECT_X',0,IARG,0,RBID,NVECX)
         NVECX=-NVECX
         IF ( NVECX .GT. 0 ) THEN
            CALL WKVECT('&&SFIFJ.VECX','V V R',3,IVECX)
            CALL GETVR8(' ','VECT_X',0,IARG,NVECX,ZR(IVECX),NBID)
         ENDIF
         CALL GETVR8(' ','VECT_Y',0,IARG,0,RBID,NVECY)
         NVECY=-NVECY
         IF ( NVECY .GT. 0 ) THEN
            CALL WKVECT('&&SFIFJ.VECY','V V R',3,IVECY)
            CALL GETVR8(' ','VECT_Y',0,IARG,NVECY,ZR(IVECY),NBID)
         ENDIF
         IF (NVECX.LT.0 .OR. NVECY.LT.0 ) CALL U2MESS('F','MODELISA7_2')

C VECTEUR Z LOCAL = VECT-X VECTORIEL VECT-Y
         CALL WKVECT('&&SFIFJ.VECZ','V V R',3,IVECZ)
         ZR(IVECZ)=ZR(IVECX+1)*ZR(IVECY+2)-ZR(IVECY+1)*ZR(IVECX+2)
         ZR(IVECZ+1)=ZR(IVECX+2)*ZR(IVECY)-ZR(IVECY+2)*ZR(IVECX)
         ZR(IVECZ+2)=ZR(IVECX)*ZR(IVECY+1)-ZR(IVECY)*ZR(IVECX+1)
         DO 2 IN=1,3
            DIR(1,IN)=ZR(IVECX+IN-1)
            DIR(2,IN)=ZR(IVECY+IN-1)
            DIR(3,IN)=ZR(IVECZ+IN-1)
2        CONTINUE
      ELSEIF(METHOD(1:7).EQ.'AU_YANG') THEN
         YANG = .TRUE.
         CALL GETVR8(' ','VECT_X',0,IARG,0,RBID,NVECX)
         NVECX=-NVECX
         IF(NVECX.GT.0) CALL GETVR8(' ','VECT_X',0,IARG,NVECX,DIR,NBID)
         CALL GETVR8(' ','ORIG_AXE',0,IARG,0,RBID,NVECO)
         NVECO=-NVECO
         IF(NVECO.GT.0)
     &      CALL GETVR8(' ','ORIG_AXE',0,IARG,NVECO,DIR(1,2),NBID)
         IF (NVECX.LT.0 .OR. NVECO.LT.0 ) CALL U2MESS('F','MODELISA7_3')
      ENDIF
C
C VALEURS NON DEPENDANTES DE LA FREQUENCE
C
10    CONTINUE
      IF (ZK16(IVATE).EQ.'SPEC_CORR_CONV_3') THEN
        CALL ACCEP2(BASE(1:8),NBM,PG,PHI,SPHI)
      ELSE
        CALL ACCEP1 (NOMRES, BASE(1:8), LIGRMO, NBM, DIR, YANG)
      ENDIF 



C BOUCLE POUR LE CAS SPEC_CORR_CONV_3
      IF (ZK16(IVATE).EQ.'SPEC_CORR_CONV_3') THEN

C CREATION DE LA TABLE D'INTERSPECTRES
        CALL TBCRSD ( NOMRES, 'G' )
        CALL TBAJPA ( NOMRES, NBPA2, NOPA2, TYPA2 )

        KVAL(1) = 'DEPL'
        KVAL(2) = 'TOUT'
        CALL TBAJLI ( NOMRES, 3, NOPA2, NBM, R8B, C16B, KVAL, 0 )


C TABLE CONTENANT LES FONCTIONS DE FORME
        IS=ZK16(IVATE+1)
C VECTEUR CONTENANT LA LISTE DES NOMS DE FONCTIONS
        NOFONS='&&SFIFJ.NOMS'
        CALL WKVECT(NOFONS,'V V K24',NBM*(NBM+1)/2,INOMS)
C CREATION DE LA LISTE DES NOMS DE FONCTIONS
        IND=1
        DO 21 IM1 = 1 , NBM
           IVAL(1) = IM1
           DO 31 IM2 = IM1 , NBM              
             IVAL(2) = IM2
             WRITE (NOFON,'(A8,A2,3I3.3)') NOMRES, '.S', 1, IM1, IM2
             ZK24(INOMS-1+IND)=NOFON
             CALL TBAJLI ( NOMRES, 3, NOPA2(4),
     &                     IVAL, 0.D0, C16B, NOFON, 0 )
             CALL WKVECT (NOFON(1:19)//'.VALE','G V R ',3*NBPOIN,LVALE)
             CALL WKVECT (NOFON(1:19)//'.PROL','G V K24',6      ,LPROL)
             ZK24(LPROL  ) = 'FONCT_C '
             ZK24(LPROL+1) = 'LIN LIN '
             ZK24(LPROL+2) = 'FREQ'
             ZK24(LPROL+3) = 'DSP     '
             ZK24(LPROL+4) = 'LL      '
             ZK24(LPROL+5) = NOFON
             IND=IND+1
31         CONTINUE
21      CONTINUE

C BOUCLE SUR LES FREQUENCES        
        F = 0.D0
        DO 100 IFF=0,NBPOIN-1
          F=FINIT+IFF*DF
          CALL EVALIS(IS,PG,PHI,SPHI,F,NOFONS,IFF,NBPOIN)
100     CONTINUE


  
C CAS SPEC_CORR_CONV_1 ET 2                             
      ELSE
C CREATION DE LA TABLE D'INTERSPECTRES ---

      CALL TBCRSD ( NOMRES, 'G' )
      CALL TBAJPA ( NOMRES, NBPAR, NOPAR, TYPAR )

      KVAL(1) = 'DEPL'
      KVAL(2) = 'TOUT'
      CALL TBAJLI ( NOMRES, 3, NOPAR, NBM, R8B, C16B, KVAL, 0 )

      IVAL(1) = 0

        DO 221 IM2 = 1 , NBM
          IVAL(3) = IM2
          DO 211 IM1 = IM2 , NBM              
            IVAL(2) = IM1
            WRITE (NOFON,'(A8,A2,3I3.3)') NOMRES, '.S', 1, IM1, IM2
            CALL TBAJLI ( NOMRES, 5, NOPAR(4),
     &                    IVAL, 0.D0, C16B, NOFON, 0 )
            CALL WKVECT (NOFON(1:19)//'.VALE','G V R ',3*NBPOIN,LVALE)
            CALL WKVECT (NOFON(1:19)//'.PROL','G V K24',6      ,LPROL)
            ZK24(LPROL  ) = 'FONCT_C '
            ZK24(LPROL+1) = 'LIN LIN '
            ZK24(LPROL+2) = 'FREQ'
            ZK24(LPROL+3) = 'DSP     '
            ZK24(LPROL+4) = 'LL      '
            ZK24(LPROL+5) = NOFON

C BOUCLE SUR LES FREQUENCES ET REMPLISSAGE DU .VALE
C IE VALEURS DES INTERSPECTRS

            F = 0.D0
            IER = 0
            DO 201 IFF=0,NBPOIN-1
              F=FINIT+IFF*DF
              ZR(LVALE+IFF) = F
              IF (F.GT.FCOUP) THEN
                PRS = 0.D0
              ELSEIF(ZK16(IVATE).EQ.'SPEC_CORR_CONV_2') THEN
                PULS = DEUXPI*F
                CALL FOINTE('F',FONCT,1,'PULS',PULS,PRS,IER)
                CALL ACCEPT(F,NBM,METHOD,IM2,IM1,
     &                      UFLUI,JC,DIR,UC,UT,LONG1,LONG2)
              ELSE
                PRS = DSPPRS(KSTE,UFLUI,DHYD,RHO,F,FCOUP)
                CALL ACCEPT(F,NBM,METHOD,IM2,IM1,
     &                      UFLUI,JC,DIR,UC,UT,LONG1,LONG2)
              ENDIF
              ZR(LVALE+NBPOIN+2*IFF)=PRS*JC
201         CONTINUE
211       CONTINUE
221     CONTINUE

      ENDIF
C
      CALL JEDETC('V','&&329',1)
      CALL JEDETC('V','&&SFIFJ',1)
      CALL JEDETC('V','&&V.M',1)
      CALL JEDETC('V','&&GROTAB.TAB',1)
C
      CALL JEDEMA()
      END
