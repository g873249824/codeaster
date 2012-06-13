      SUBROUTINE DY2MBR(NUMDDL,NEQ   ,LISCHA,FREQ  ,VEDIRI,
     &                  VENEUM,VEVOCH,VASSEC,J2ND  )
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
C
      IMPLICIT      NONE
      INCLUDE 'jeveux.h'
      CHARACTER*19  LISCHA
      INTEGER       NEQ,J2ND
      REAL*8        FREQ
      CHARACTER*14  NUMDDL
      CHARACTER*19  VEDIRI,VENEUM,VEVOCH,VASSEC
C
C ----------------------------------------------------------------------
C
C DYNA_LINE_HARM
C
C CALCUL DU SECOND MEMBRE
C
C ----------------------------------------------------------------------
C
C
C IN  VEDIRI : VECT_ELEM DE L'ASSEMBLAGE DES ELEMENTS DE LAGRANGE
C IN  VENEUM : VECT_ELEM DE L'ASSEMBLAGE DES CHARGEMENTS DE NEUMANN
C IN  VEVOCH : VECT_ELEM DE L'ASSEMBLAGE DES CHARGEMENTS EVOL_CHAR
C IN  VASSEC : VECT_ELEM DE L'ASSEMBLAGE DES CHARGEMENTS VECT_ASSE_CHAR
C IN  LISCHA : SD LISTE DES CHARGES
C IN  NUMDDL : NOM DU NUME_DDL
C IN  FREQ   : VALEUR DE LA FREQUENCE
C IN  NEQ    : NOMBRE D'EQUATIONS DU SYSTEME
C IN  J2ND   : ADRESSE DU VECTEUR ASSEMBLE SECOND MEMBRE
C
C
C
C
      INTEGER      IEQ
      INTEGER      J2ND1,J2ND2,J2ND3,J2ND4,J2ND5
      CHARACTER*1  TYPRES
      CHARACTER*8  PARA
      CHARACTER*19 CNDIRI,CNNEUM,CNVOCH,CNVEAC,CNVASS
      COMPLEX*16   CZERO
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      TYPRES = 'C'
      PARA   = 'FREQ'
      CZERO  = DCMPLX(0.D0,0.D0)
      CNDIRI = '&&DY2MBR.CNDIRI'
      CNNEUM = '&&DY2MBR.CNNEUM'
      CNVOCH = '&&DY2MBR.CNVOCH'
      CNVEAC = '&&DY2MBR.CNVEAC'
      CNVASS = '&&DY2MBR.CNVASS'
      CALL VTCREB(CNDIRI,NUMDDL,'V',TYPRES,NEQ)
      CALL VTCREB(CNNEUM,NUMDDL,'V',TYPRES,NEQ)
      CALL VTCREB(CNVOCH,NUMDDL,'V',TYPRES,NEQ)
      CALL VTCREB(CNVEAC,NUMDDL,'V',TYPRES,NEQ)
      CALL VTCREB(CNVASS,NUMDDL,'V',TYPRES,NEQ)
C
C --- VECTEUR RESULTANT
C
      CALL ZINIT(NEQ,CZERO,ZC(J2ND),1)
C
C --- ASSEMBLAGE DES CHARGEMENTS DE DIRICHLET
C
      CALL ASCOMB(LISCHA,VEDIRI,TYPRES,PARA  ,FREQ  ,
     &            CNDIRI)
C
C --- ASSEMBLAGE DES CHARGEMENTS DE NEUMANN STANDARDS
C
      CALL ASCOMB(LISCHA,VENEUM,TYPRES,PARA  ,FREQ  ,
     &            CNNEUM)
C
C --- ASSEMBLAGE DU CHARGEMENT DE TYPE EVOL_CHAR
C
      CALL ASCOMB(LISCHA,VEVOCH,TYPRES,PARA  ,FREQ  ,
     &            CNVOCH)
C
C --- ASSEMBLAGE DU CHARGEMENT DE TYPE VECT_ASSE_CHAR
C
      CALL ASCOMB(LISCHA,VASSEC,TYPRES,PARA  ,FREQ  ,
     &            CNVEAC)
C
C --- CHARGEMENT DE TYPE VECT_ASSE
C
      CALL CNVESL(LISCHA,TYPRES,NEQ   ,PARA  ,FREQ  ,
     &            CNVASS)
C
C --- CUMUL DES DIFFERENTS TERMES DU SECOND MEMBRE DEFINITIF
C
      CALL JEVEUO(CNDIRI(1:19)//'.VALE','L',J2ND1)
      CALL JEVEUO(CNNEUM(1:19)//'.VALE','L',J2ND2)
      CALL JEVEUO(CNVOCH(1:19)//'.VALE','L',J2ND3)
      CALL JEVEUO(CNVEAC(1:19)//'.VALE','L',J2ND4)
      CALL JEVEUO(CNVASS(1:19)//'.VALE','L',J2ND5)
      DO 300 IEQ = 1, NEQ
        ZC(J2ND+IEQ-1) =
     &                   ZC(J2ND1+IEQ-1) +
     &                   ZC(J2ND2+IEQ-1) +
     &                   ZC(J2ND3+IEQ-1) +
     &                   ZC(J2ND4+IEQ-1) +
     &                   ZC(J2ND5+IEQ-1)
 300  CONTINUE
C
      CALL DETRSD('CHAMP_GD',CNDIRI)
      CALL DETRSD('CHAMP_GD',CNNEUM)
      CALL DETRSD('CHAMP_GD',CNVOCH)
      CALL DETRSD('CHAMP_GD',CNVEAC)
      CALL DETRSD('CHAMP_GD',CNVASS)
C
      CALL JEDEMA()

      END
