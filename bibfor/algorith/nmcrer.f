      SUBROUTINE NMCRER(CARCRI,SDCRIQ)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 31/07/2012   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      INCLUDE      'jeveux.h'
      CHARACTER*24 SDCRIQ,CARCRI
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (SD CRITERE QUALITE)
C
C CREATION DE LA SD
C
C ----------------------------------------------------------------------
C
C
C IN  CARCRI : PARAMETRES DES METHODES D'INTEGRATION LOCALES
C OUT SDCRIQ : SD CRITERE QUALITE
C
C ----------------------------------------------------------------------
C
      INTEGER      IFM,NIV
      INTEGER      IARG,IBID,JVALE
      CHARACTER*24 ERRTHM
      INTEGER      JERRT
      CHARACTER*16 MOTFAC,CHAINE
      REAL*8       THETA
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... LECTURE CALCUL ERREUR'
      ENDIF
C
C --- INITIALISATIONS
C
      MOTFAC = 'CRIT_QUALITE'
C
C --- VALEUR DE THETA
C
      CALL JEVEUO(CARCRI(1:19)//'.VALV','L',JVALE)
      THETA  =  ZR(JVALE+3)
C
C --- ERREUR EN TEMPS (THM)
C
      CALL GETVTX(MOTFAC,'ERRE_TEMPS_THM',1,IARG,1,CHAINE,IBID)
      IF (CHAINE.EQ.'OUI') THEN
        ERRTHM = SDCRIQ(1:19)//'.ERRT'
        CALL WKVECT(ERRTHM,'V V R',3,JERRT)
        ZR(JERRT-1+3) = THETA
      ENDIF
C
      CALL JEDEMA()
      END
