      SUBROUTINE CONLAG(MATASZ,COND)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      REAL*8        COND
      CHARACTER*(*) MATASZ
C
C ----------------------------------------------------------------------
C
C RECUPERATION DU CONDITIONNEMENT DES LAGRANGES D'UNE MATRICE ASSEMBLEE
C
C ----------------------------------------------------------------------
C
C IN   MATASZ : SD MATRICE ASSEMBLEE
C OUT  COND   : CONDITIONNEMENT DES LAGRANGES
C
C

C
C
      INTEGER      JCONL,NEQ,IRET,JCOL,NBSD,JFETM,IDD
      CHARACTER*8  K8BID
      CHARACTER*19 MATASS,MATDD
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      MATASS=MATASZ
      COND=1.D0
      CALL JEEXIN(MATASS//'.FETM',IRET)
C
C --- CAS FETI - ON BOUCLE SUR TOUTES LES MATRICES DES SOUS-DOMAINES.
C     DES QUE L'ON TROUVE UN CONDITIONNEMENT DE LAGRANGE, ON SORT CAR
C     CETTE VALEUR EST LA MEME POUR TOUTES LES MATRICES
C
      IF (IRET.NE.0) THEN
        CALL JEVEUO(MATASS//'.FETM','L',JFETM)
        CALL JELIRA(MATASS//'.FETM','LONUTI',NBSD,K8BID)
        DO 10 IDD=1,NBSD
          MATDD=ZK24(JFETM+IDD-1)
          CALL JEEXIN(MATDD//'.CONL',IRET)
          IF (IRET.NE.0) THEN
            CALL DISMOI('F','NB_EQUA',MATDD,'MATR_ASSE',NEQ,K8BID,IRET)
            CALL JEVEUO(MATDD//'.CONL','L',JCONL)
            DO 20 JCOL=1,NEQ
              COND = 1.D0/ZR(JCONL-1+JCOL)
              IF (COND.NE.1.D0) THEN
                GOTO 9999
              ENDIF
   20       CONTINUE
          ENDIF
   10   CONTINUE
C
C --- CAS AUTRE QUE FETI - ON SORT DES QUE L'ON TROUVE UN
C     CONDITIONNEMENT DE LAGRANGE
C
      ELSE
        CALL JEEXIN(MATASS//'.CONL',IRET)
        IF (IRET.NE.0) THEN
          CALL DISMOI('F','NB_EQUA',MATASS,'MATR_ASSE',NEQ,K8BID,IRET)
          CALL JEVEUO(MATASS//'.CONL','L',JCONL)
          DO 30 JCOL=1,NEQ
            COND = 1.D0/ZR(JCONL-1+JCOL)
            IF (COND.NE.1.D0) THEN
              GOTO 9999
            ENDIF
   30     CONTINUE
        ENDIF
      ENDIF
C
 9999 CONTINUE
C
      CALL JEDEMA()
      END
