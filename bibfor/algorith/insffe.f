      SUBROUTINE INSFFE(EPSRX,STRNX,STRNRX,SIGMRX,SIGRX,TANG,S1X,
     1    EDT,EDC,EPST,EPSC,DEFR,RTM,IFISU,JFISU,IPLA,EQSTR,IDIR)
        IMPLICIT REAL*8 (A-H,O-Z)
C       -----------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 27/03/2002   AUTEUR VABHHTS J.PELLET 
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
C       -----------------------------------------------------------
C       NADAI_B :  BETON FISSURE
C
C       CE SOUS-PROGRAMME GERE LE COMPORTEMENT DU BETON EN UN POINT
C       OU LA FISSURE EST REFERMEE (IFISU=0 ET JFISU=1)
C
C ENTREES :
C           SIGRX : CONTRAINTE  A T
C           SIGMRX: PREDICTEUR ELASTIQUE SIGRX+DSIG
C           EPSRX : DEFORMATION TOTALE A T
C           STRNX : INCREMENT DE DEFORMATION
C
C  E/S :IFISU,IPLA,EQSTR,EPSEQ,JFISU,TANG,EPST,EPSC,EDC,EDT,RTM,DEFR
C        CE SONT TOUTES DES VARIABLES INTERNES, VOIR LEUR
C        SIGNIFICATION DANS LA PROCEDURE  INSPIF
C
C SORTIES :  S1X :  CONTRAINTE UNIAXIALE A T+DT
C       -----------------------------------------------------------
      INTEGER   IFISU,IPLA,JFISU,IDIR
      REAL*8  EPSRX,STRNX,STRNRX,SIGMRX,SIGRX,TANG,S1X,EDT,EDC,EPST
      REAL*8  EPSC,DEFR,RTM,EQSTR
C------------------------------------------------------------------
      COMMON/CARMA/EX,RB,ALPHA,EMAX,PENT,ICU
C
      RBT=ALPHA*RB
      IF ( ABS(EDC) .LT. 1.D-06 ) EDC = 0.D0
      IF(EDC.EQ.0.D0.OR.(EQSTR.LE.RBT.AND.IPLA.EQ.0)) THEN
C-------------------------------------------------------------
C       POINT INITIALLEMENT TENDU OU PAS COMPRIME PLUS LOIN
C       QUE -RBT
C
      IF ( STRNRX .LT. EPSRX ) THEN
C
C        COMPRESSION DE LA FISSURE (CHARGE)
C
       IF(STRNRX.GT.EPST) THEN
        S1X=SIGRX+EDT*STRNX
        TANG=EDT
        EQSTR=ABS(S1X)
        IF(S1X .GE.0.D0) EQSTR=0.D0
       ELSE
        A=ABS(STRNRX)
        CALL INSCU (A,SEQ,EPEQ,IPLA,TANG)
        EQSTR=SEQ
        S1X=-SEQ
       ENDIF
      GOTO 9999
      ENDIF
C==================================================================
C        DECOMPRESSION DE LA FISSURE (DECHARGE)
C
       IF(EPSRX.GT.EPST) THEN
C
C          PENTE DE DECHARGE ---> EDT
C
        S1X=SIGRX+EDT*STRNX
        TANG=EDT
C
C       REOUVERTURE DE LA FISSURE
C
         IF(S1X.GT.RTM) THEN
            CALL INSFI2 (S1X,SIGRX,STRNX,RTM,PENT,TANG)
          IFISU=1
         ENDIF
        GOTO 9999
C
       ELSE
C
C          PENTE DE DECHARGE ---> EDC
C
       CALL INSDC (S1X,EDC,EPST,EDT,RTM,EPSC,DEFR,
     1 SIGRX,STRNX,STRNRX,EPSRX,IFISU,JFISU,SIGMRX,IPLA,TANG,IDIR)
       GOTO 9999
       ENDIF
      ENDIF
C======================================================================
C
C       POINT AYANT SUBIT UNE DECHARGE EN COMPRESSION (EDC .NE. 0)
C
       IF(ABS(SIGMRX).GT.EQSTR.AND.SIGMRX.LE.0.D0) THEN
C======================================================================
C    ************************
C    * DOMAINES DES CHARGES *
C    ************************
C
C       ECROUISSAGE ?
C
      IF(STRNRX.LT.EPSC) THEN
C
C        ON EST SUR LA COURBE DE COMPRESSION (CHARGE)
C
       A = ABS(STRNRX)
       CALL INSCU (A,SEQ,EPEQ,IPLA,TANG)
       EQSTR=SEQ
       S1X=-SEQ
      ELSE
C
C        ON EST SUR LA COURBE DE COMPRESSION ---> EDC
C                                         OU ---> EDT
          IF(STRNRX.LT.EPST) THEN
           S1X=EDC*(STRNRX-DEFR)
           TANG=EDC
          ELSE
           S1X=SIGRX+EDT*STRNX
           TANG=EDT
          ENDIF
      ENDIF
C
      ELSE
C======================================================================
C    **************************
C    * DOMAINES DES DECHARGES *
C    **************************
       IF(EPSRX.LT.EPSC) THEN
C
C       DECHARGE A PARTIR DE LA COURBE DE COMPRESSION
C       LE CALCUL DES NOUVELLES VALEURS EPSC/EPST/EDC SERA EFFECTUE
C           DANS DECHARC
C
      CALL INSDC (S1X,EDC,EPST,EDT,RTM,EPSC,DEFR,
     1  SIGRX,STRNX,STRNRX,EPSRX,IFISU,JFISU,SIGMRX,IPLA,TANG,IDIR)
      GOTO 9999
       ELSE
      IF(STRNRX.LT.EPST) THEN
C
C       ON EST SUR LA COURBE DE DECHARGE EDC
C
       IF(EPSRX.GT.EPST) THEN
C
C         PASSAGE DE LA COURBE EDT A LA COURBE EDC
C
       S1X=EDC*(STRNRX-DEFR)
       TANG=EDC
       ELSE
C
C         ON RESTE SUR LA COURBE EDC
C
       S1X=SIGRX+EDC*STRNX
       TANG=EDC
       ENDIF
      ELSE
C
C         ON EST SUR LA COURBE DE DECHARGE EDT
C
       TANG=EDT
       IF(EPSRX.GT.EPST) THEN
C
C         ON RESTE SUR LA COURBE EDT
C
        S1X=SIGRX+EDT*STRNX
       ELSE
C
C         PASSAGE DE LA COURBE EDC A LA COURBE EDT
C
        S1X=-RBT+EDT*(STRNRX-EPST)
       ENDIF
      ENDIF
      ENDIF
      ENDIF
C==================================================================
      IF(S1X.GT.RTM) THEN
C
C       REOUVERTURE DE LA FISSURE
C
       CALL INSFI2 (S1X,SIGRX,STRNX,RTM,PENT,TANG)
       IFISU=1
      ENDIF
C==================================================================
 9999 CONTINUE
      END
