      SUBROUTINE CALFNL(NP1,NP2,NP3,NP4,NBM,NBMCD,NPFTS,TC,
     &                  NBNL,TYPCH,NBSEG,PHII,
     &                  CHOC,ALPHA,BETA,GAMMA,ORIG,RC,THETA,
     &                  MASGI,AMORI,PULSI,
     &                  VITG,DEPG,VITG0,DEPG0,
     &                  CMOD,KMOD,CMODCA,KMODCA,
     &                  TEXTTS,FEXTTS,NDEF,INDT,NITER,
     &                  FEXMOD,FNLMOD,FMRES,FMODA,FTMP,MTMP1,MTMP6,
     &                  OLD,OLDIA,TESTC,ITFORN,INEWTO,TOLN)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/01/2010   AUTEUR MACOCCO K.MACOCCO 
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
C TOLE  CRP_21
C-----------------------------------------------------------------------
C DESCRIPTION : ESTIMATION ET "LINEARISATION" DE LA FORCE NON-LINEAIRE
C -----------   CALCUL DE LA FORCE EXTERIEURE
C
C               APPELANTS : ALITMI, NEWTON
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C ARGUMENTS
C ---------
      INTEGER   NP1, NP2, NP3, NP4, NBM, NBMCD, NPFTS
      REAL*8    TC
      INTEGER   NBNL, TYPCH(*), NBSEG(*)
      REAL*8    PHII(NP2,NP1,*), CHOC(6,*), ALPHA(2,*), BETA(2,*),
     &          GAMMA(2,*), ORIG(6,*), RC(NP3,*), THETA(NP3,*),
     &          MASGI(*), AMORI(*), PULSI(*),
     &          VITG(*), DEPG(*), VITG0(*), DEPG0(*),
     &          CMOD(NP1,*), KMOD(NP1,*), CMODCA(NP1,*), KMODCA(NP1,*),
     &          TEXTTS(*), FEXTTS(NP4,*)
      INTEGER   NDEF, INDT, NITER
      REAL*8    FEXMOD(*), FNLMOD(*), FMRES(*), FMODA(*),
     &          FTMP(*), MTMP1(NP1,*), MTMP6(3,*), OLD(9,*)
      INTEGER   OLDIA(*), TESTC, ITFORN(*), INEWTO
      REAL*8    TOLN
C
C ROUTINES EXTERNES
C -----------------
C     EXTERNAL  ADIMEQ, DEFEXT, LCINVN, MDCHOE, SOMMVE
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
C  1. CALCUL DE L'EFFORT GENERALISE DU AUX NON-LINEARITES
C     DE TYPE CHOC (IMPACT-FROTTEMENT)
C     --------------------------------
C
      CALL VECINI(NP1,0.D0,FMRES)
      CALL MDCHOE(NP1,NP2,NP3,NBM,NBMCD,
     &            NBNL,TYPCH,NBSEG,PHII,
     &            CHOC,ALPHA,BETA,GAMMA,ORIG,RC,THETA,
     &            CMOD,KMOD,VITG,DEPG,VITG0,DEPG0,
     &            OLD,OLDIA,FNLMOD,FMRES,FTMP,MTMP1,MTMP6,TESTC,
     &            ITFORN,INEWTO,TOLN)
C
C  2. RECUPERATION DE L'EFFORT EXTERIEUR (EFFORT GENERALISE)
C     ------------------------------------------------------
C
      CALL DEFEXT(NP4,NBM,NPFTS,NDEF,
     &            TC,TEXTTS,FEXTTS,FEXMOD,INDT,NITER)
C
C  3. SOMMATION DES EFFORTS GENERALISES
C     ---------------------------------
C
      CALL SOMMVE(NP1,FEXMOD,NBM,FMRES,NBM,FMODA)
C
C  4. MULTIPLICATION DE CMOD+AMORI, KMOD+PULSI**2, FMOD PAR (M-1)
C     -----------------------------------------------------------
C
      CALL ADIMEQ(NP1,NBM,CMOD,KMOD,FMODA,MASGI,AMORI,PULSI,
     &            CMODCA,KMODCA,FMODA)
C
C --- FIN DE CALFNL.
      END
