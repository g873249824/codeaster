      SUBROUTINE CCCHCR(CRIT,   NOMGD,  NBCMP, VALIN, LICMP,
     &                  NBCMPR, VALRES, IRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/09/2011   AUTEUR COURTOIS M.COURTOIS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
      IMPLICIT NONE
      INTEGER      NBCMP, NBCMPR, IRET
      REAL*8       VALIN(NBCMP), VALRES(NBCMPR)
      CHARACTER*8  NOMGD, LICMP(NBCMP)
      CHARACTER*16 CRIT
C RESPONSABLE COURTOIS M.COURTOIS
C ----------------------------------------------------------------------
C  CALC_CHAMP - TRAITEMENT DE CHAM_UTIL - CRITERE
C  -    -                     --          --
C  CALCUL DU CRITERE 'CRIT' (SUR LA GRANDEUR 'NOMGD') A PARTIR DES
C  'NBCMP' VALEURS DES COMPOSANTES. RANGE LE RESULTAT DANS 'VALRES'.
C ----------------------------------------------------------------------
C IN  :
C   CRIT   K16   NOM DU CRITERE A CALCULER
C   NOMGD  K8    NOM DE LA GRANDEUR DU CHAMP IN
C   NBCMP  I     NBRE DE COMPOSANTES DEFINIES SUR LE POINT COURANT
C   VALIN  R(*)  VALEURS DES COMPOSANTES
C   LICMP  K8(*) NOM DES COMPOSANTES EFFECTIVEMENT REMPLIES
C   NBCMPR I     NOMBRE DE COMPOSANTES EN SORTIE
C IN :
C   VALRES R(*)  VALEURS DU CRITERE
C   IRET   I     CODE RETOUR : = 0 OK,
C                              > 0 ON N'A PAS PU CALCULER LE CRITERE
C ----------------------------------------------------------------------
C   ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER        ZI
      COMMON /IVARJE/ZI(1)
      REAL*8         ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16     ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL        ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8    ZK8
      CHARACTER*16          ZK16
      CHARACTER*24                  ZK24
      CHARACTER*32                          ZK32
      CHARACTER*80                                  ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      REAL*8       LCIV2S, LCIV2E
C
      INTEGER      NCSIG
      PARAMETER   (NCSIG=6)
      INTEGER      I
      REAL*8       RAC2, VALE(6)
      CHARACTER*4  CMPSIG(NCSIG), CMPEPS(NCSIG), NOMCMP(NCSIG)
      CHARACTER*16 VALK(2)
      INTEGER       NT,ND
      COMMON /TDIM/ NT,ND
      DATA CMPSIG / 'SIXX', 'SIYY', 'SIZZ', 'SIXY', 'SIXZ', 'SIYZ'/
      DATA CMPEPS / 'EPXX', 'EPYY', 'EPZZ', 'EPXY', 'EPXZ', 'EPYZ'/
C     ----- FIN  DECLARATIONS ------------------------------------------
C
      CALL JEMARQ()
      IRET = 1
C
C --- VERIFICATIONS COMMUNES POUR VMIS, INVA_2, TRACE
      IF (CRIT.EQ.'VMIS' .OR. CRIT.EQ.'INVA_2' .OR.
     &      CRIT.EQ.'TRACE') THEN
        CALL ASSERT(NBCMPR.EQ.1)
        IF (NOMGD.EQ.'SIEF_R') THEN
          NOMCMP = CMPSIG
        ELSEIF (NOMGD.EQ.'EPSI_R') THEN
          NOMCMP = CMPEPS
        ELSE
          VALK(1) = CRIT
          VALK(2) = NOMGD
          CALL U2MESK('F', 'CHAMPS_7', 2, VALK)
        ENDIF
C       CELCES ASSURE QUE LES COMPOSANTES SONT DANS L'ORDRE DU CATALOGUE
C       LE MEME QUE CELUI DE CMPSIG/CMPEPS
C       IL SUFFIT DONC DE VERIFIER QUE :
C       - SI NBCMP=6, CE SONT CELLES DE CMPSIG/CMPEPS
C       - SI NBCMP=4, CE SONT LES 4 PREMIERES
        IF (NBCMP.NE.4 .AND. NBCMP.NE.6) THEN
          GOTO 9999
        ENDIF
        DO 10 I=1, NBCMP
          IF (NOMCMP(I).NE.LICMP(I)) THEN
            GOTO 9999
          ENDIF
 10     CONTINUE
      ENDIF
C
C --- VMIS
      IF (CRIT .EQ. 'VMIS') THEN
        IF (NOMGD.NE.'SIEF_R') THEN
          VALK(1) = CRIT
          VALK(2) = NOMGD
          CALL U2MESK('F', 'CHAMPS_7', 2, VALK)
        ENDIF
C       COMMON POUR LCIV2S
        NT = NBCMP
        ND = 3
        RAC2 = SQRT(2.0D0)
        DO 21 I = 1,ND
          VALE(I) = VALIN(I)
 21     CONTINUE
        DO 22 I = ND+1, NT
          VALE(I) = RAC2 * VALIN(I)
 22     CONTINUE
        VALRES(1) = LCIV2S(VALE)
        IRET = 0
C
C --- INVA_2
      ELSEIF (CRIT .EQ. 'INVA_2') THEN
        IF (NOMGD.NE.'EPSI_R') THEN
          VALK(1) = CRIT
          VALK(2) = NOMGD
          CALL U2MESK('F', 'CHAMPS_7', 2, VALK)
        ENDIF
C       COMMON POUR LCIV2S
        NT = NBCMP
        ND = 3
        RAC2 = SQRT(2.0D0)
        DO 31 I = 1,ND
          VALE(I) = VALIN(I)
 31     CONTINUE
        DO 32 I = ND+1, NT
          VALE(I) = RAC2 * VALIN(I)
 32     CONTINUE
        VALRES(1) = LCIV2E(VALE)
        IRET = 0
C
C --- TRACE
      ELSEIF (CRIT .EQ. 'TRACE') THEN
        VALRES(1) = VALIN(1) + VALIN(2) + VALIN(3)
        IRET = 0
C
      ELSE
C ---   INTERDIT DANS LE CATALOGUE
        CALL ASSERT(.FALSE.)
      ENDIF
C
 9999 CONTINUE
      CALL JEDEMA()
C
      END
