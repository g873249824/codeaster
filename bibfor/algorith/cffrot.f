      SUBROUTINE CFFROT(MAF1  ,KOPER ,MAF2  ,MAFROT,NUMEDD)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSBALE
C
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*1  KOPER
      CHARACTER*19 MAF1
      CHARACTER*19 MAF2
      CHARACTER*19 MAFROT
      CHARACTER*14 NUMEDD
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - FROTTEMENT)
C
C CALCUL DE LA MATRICE DE FROTTEMENT
C
C ----------------------------------------------------------------------
C
C
C IN  MAF1   : PARTIE 1 DE LA MATRICE FROTTEMENT
C IN  KOPER  : ADDITION ('+') OU SOUSTRACTION ('-')
C IN  MAF2   : PARTIE 2 DE LA MATRICE FROTTEMENT
C OUT MAFROT : MATRICE GLOBALE TANGENTE AVEC FROTTEMENT RESULTANTE
C OUT NUMEDD : NUME_DDL DE LA MATRICE DE FROTTEMENT
C
C
C
C
      INTEGER       IRET,IBID,IER
      REAL*8        COEFMU(2)
      CHARACTER*1   TYPCST(2)
      CHARACTER*14  NUMEDF,NUMEF1, NUMEF2
      CHARACTER*24  LIMAT(2)
C ----------------------------------------------------------------------
C
C --- DESTRUCTION ANCIENNE MATRICE FROTTEMENT
C
      CALL EXISD('MATR_ASSE',MAFROT,IRET)
      IF (IRET.NE.0) THEN
         CALL DISMOI('F','NOM_NUME_DDL',MAFROT,'MATR_ASSE',IBID,NUMEDF,
     &                                                          IER)
         CALL DETRSD('NUME_DDL' ,NUMEDF)
         CALL DETRSD('MATR_ASSE',MAFROT)
      ENDIF
C
C --- PREPARATION COMBINAISON LINEAIRE MAFROT=MAF1-MAF2
C
      LIMAT(1)  = MAF1
      LIMAT(2)  = MAF2
      COEFMU(1) =  1.0D0
      IF (KOPER.EQ.'+') THEN
        COEFMU(2) = +1.0D0
      ELSEIF (KOPER.EQ.'-') THEN
        COEFMU(2) = -1.0D0
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
      TYPCST(1) = 'R'
      TYPCST(2) = 'R'
C
C --- COMBINAISON LINEAIRE MAFROT=MAF1-MAF2
C
      CALL MTDEFS(MAFROT,MAF1,'V','R')
      CALL MTCMBL(2,TYPCST,COEFMU,LIMAT,MAFROT,' ',NUMEDD,'ELIM=')
C
C --- DESTRUCTION DES NUME_DDL
C
      CALL DISMOI('F','NOM_NUME_DDL',MAF1,'MATR_ASSE',IBID,NUMEF1,IER)
      CALL DISMOI('F','NOM_NUME_DDL',MAF2,'MATR_ASSE',IBID,NUMEF2,IER)
      CALL DETRSD('NUME_DDL',NUMEF1)
      CALL DETRSD('NUME_DDL',NUMEF2)
C
C --- DESTRUCTION DES MATRICES DE CONSTRUCTION
C
      CALL DETRSD('MATR_ASSE',MAF1  )
      CALL DETRSD('MATR_ASSE',MAF2  )
C
      END
