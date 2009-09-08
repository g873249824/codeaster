      SUBROUTINE PREML2(N1,DIAG,COL,DELG,XADJ1,ADJNC1,
     +     ESTIM,ADRESS,PAREND,FILS,FRERE,ANC,NOUV,SUPND,
     +     DHEAD,QSIZE,LLIST,MARKER,
     +     INVSUP,LOCAL,GLOBAL,LFRONT,NBLIGN,
     +     DECAL,LGSN,DEBFAC,DEBFSN,SEQ,LMAT,ADPILE,
     +     CHAINE,SUIV,PLACE,NBASS,NCBLOC,LGBLOC,NBLOC,
     +     LGIND,NBSND,IER)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 07/09/2009   AUTEUR PELLET J.PELLET 
C RESPONSABLE JFBHHUC C.ROSE
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
C     TOLE CRP_21 CRP_4
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER  COL(*)
      INTEGER N1,DIAG(0:N1),ADPILE(N1),ESTIM,LGIND
      INTEGER XADJ1(N1+1),ADJNC1(*),DECAL(*),MXFACT
      INTEGER DELG(*),ADRESS(*),PAREND(*)
      INTEGER*4 LOCAL(*),GLOBAL(*)
      INTEGER FILS(N1),FRERE(N1)
      INTEGER LFRONT(N1),NBLIGN(N1),LGSN(N1),DEBFAC(N1+1),DEBFSN(N1)
      INTEGER CHAINE(N1),SUIV(N1),PLACE(N1),NBASS(N1)
      INTEGER ANC(N1),NOUV(N1),SUPND(N1),IER
      INTEGER INVSUP(N1),LMAT,SEQ(N1)
      INTEGER NCBLOC(*),LGBLOC(*),NBLOC
      REAL*8 TEMPS(6)
C     VARIABLES LOCALES
      INTEGER DHEAD(*),QSIZE(*),LLIST(*),MARKER(*)
      INTEGER NBSND,I,LONG,J,IDER1,IDER2,IPRM1,IPRM2,SN,SNI
      INTEGER IFM     ,  NIV


C------------------------------------------------------------
C     1) A PARTIR DE DIAG ET COL -> ADJNC1 AVEC TOUS
C     LES DDL ASTER 1:N1
C     2) CALCUL DE ADJNC2 EN ENLEVANT LES LAMBDA
C     DE LAGRANGE 1:N2
C     (1:N1) -> (1:N2) PAR NUM P EN SENS INVERSE PAR NUM Q
C     3) POUR CHQE REL.LIN. I,RL(1,I) = LAMBD1 RL(2,I) = LAMBD2
C     POUR LES BLOCAGES : LBD1(NOBL) = NO DU LAMBDA1
C     QUI BLOQUE LE DDL NOBL
C     4) GENMMD SUR ADJNC2
C     5) POUR LES REL.LIN.,ON FAIT RL1(I)=LAMBD1,I ETANT
C     LE DDL DE REL.LIN.
C     DONT L'IMAGE PAR LA NOUVELLE NUMEROTATION EST
C     L'INF DES DDL. ENCADRES
C     6) ON ECRIT LA NOUVELLE NUMEROTATION DE TOUS LES DDL
C     APRES GENMMD
C     => TAB NOUV ET ANC (1:N1) <-> (1:N2)
C     --> AVEC LES R.L. ON CREE UN NOUVEAU SUPERND EGAL
C     AU LAMBDA1 DE LA
C     RELATION.(EN EFFET  ON NE PEUT PAS TOUJOURS
C     L'AMALGAMER AU PREMIER
C     SN ENCADRE PAR CE LAMBDA1 !! )
C     LAMBDA2 LUI EST AMALGAME AU DERNIER ND ENCADRE
C     NBSND : NBRE DE SND AVEC LES LAMBDA1 = NBSN + NRL

C     PARENTD REPRESENTE LE NOUVEL ARBRE D'ELIMINATION
C     RQE GENERALE AVEC LES REL.LIN. ON UTILISE LA DONNEE SUIVANTE :
C     LES DDL ENCADRES SONT DEFINIS PAR
C     ( COL(J),J=DIAG(LAMBDA2-1)+2,DIAG(LAMBDA2)-1 )
C----------------------------------- FACTORISATION SYMBOLIQUE
      DIAG(0) = 0
C*************************************************************
C*************************************************************
      CALL FACSMB(N1,NBSND,SUPND,INVSUP,PAREND,XADJ1,ADJNC1,ANC,NOUV,
     +     FILS,FRERE,LOCAL,GLOBAL,ADRESS,LFRONT,
     +     NBLIGN,LGSN,DEBFAC,DEBFSN,CHAINE,PLACE,NBASS,
     +     DELG,LGIND,IER)
      IF(IER.NE.0) GOTO 999
C*************************************************************
C*************************************************************
C
C-----RECUPERATION DU NIVEAU D'IMPRESSION
C
      CALL INFNIV(IFM,NIV)
C------------------------------------------------------------
C     IF (NIV.EQ.1) THEN
C     WRITE(IFM,*)'FACTORISATION SYMBOLIQUE: '//
C     *  'TEMPS CPU',TEMPS(3),
C     *  ' + TEMPS CPU SYSTEME ',TEMPS(6)
C     ENDIF
      IF (NIV.EQ.2) THEN
         WRITE(IFM,*)'RESULTATS DE FACSMB '//
     *        'LONGUEUR DE LA FACTORISEE ',(DEBFAC(N1+1)-1)
      ENDIF
C     EVALUATION DE MXFACT
      MXFACT = 0
      DO 110 I = 1,NBSND
         LONG = DEBFSN(1+I) - DEBFSN(I)
         MXFACT = MAX(LONG,MXFACT)
 110  CONTINUE
C-------------------------------ESTIMATION DE LA PILE
C*************************************************************
C*************************************************************
      CALL MLTPOS(NBSND,PAREND,FILS,FRERE,ADPILE,LFRONT,SEQ,DHEAD,ESTIM,
     +     QSIZE,SUIV,MARKER,LLIST)
C*************************************************************
C*************************************************************
C
      IF (NIV.EQ.2) THEN
C     WRITE(IFM,*)'RENUMEROTATION DE L''ARBRE D''ELIMI'//
C     +            'NATION:'//
C     *  'TEMPS CPU',TEMPS(3),
C     *  ' + TEMPS CPU SYSTEME ',TEMPS(6)
         WRITE(IFM,*)'RESULTATS DE MLTPOS '//
     *        ' LONGUEUR DE LA PILE ',ESTIM
      ENDIF
C-----------------------------------CALCUL DE LA REPARTITION
C     EN BLOCS
      CALL MLTBLC(NBSND,DEBFSN,MXFACT,SEQ,NBLOC,DECAL,LGBLOC,NCBLOC)
C--------------------------------CALCUL DES ADRESSES DES
      IF (NIV.EQ.2) THEN
         WRITE(IFM,*)'RESULTATS DE MLTBLC '//
     *        'NBRE DE BLOCS ',NBLOC
         DO 120 I = 1,NBLOC
            WRITE(IFM,*)'LONGUEUR DU BLOC ',I,
     *           ': ',LGBLOC(I),
     *           'NOMBRE DE SUPERNOEUDS DU BLOC ',I,
     *           ': ',NCBLOC(I)
 120     CONTINUE
      ENDIF
C     COEFFICIENTS INITIAUX
C*************************************************************
C*************************************************************
      CALL MLTPAS(N1,NBSND,SUPND,XADJ1,ADJNC1,ANC,NOUV,SEQ,GLOBAL,
     +     ADRESS,NBLIGN,LGSN,NBLOC,NCBLOC,LGBLOC,DIAG,COL,
     +     LMAT,PLACE)
C     PRNO,DEEQ,NEC,LBD2,NRL,RL,MARKER)

C*************************************************************
C*************************************************************
C     IF (NIV.EQ.2) THEN
C     WRITE(IFM,*)'POINTEUR DES TERMES INITIAUX: '//
C     *   'TEMPS CPU',TEMPS(3),
C     *   ' + TEMPS CPU SYSTEME ',TEMPS(6)
C     ENDIF
 999  CONTINUE
      END
