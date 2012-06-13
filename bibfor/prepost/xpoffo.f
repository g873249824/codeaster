      SUBROUTINE  XPOFFO(NDIM,NDIME,ELREFP,NNOP,IGEOM,CO,FF)
      IMPLICIT NONE

      INCLUDE 'jeveux.h'
      INTEGER     NDIM,NDIME,NNOP,IGEOM
      REAL*8      CO(NDIM),FF(NNOP)
      CHARACTER*8 ELREFP

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C TOLE CRS_1404
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
C RESPONSABLE GENIAUT S.GENIAUT
C
C     FF : FONCTIONS DE FORMES AU NOEUD SOMMET OU D'INTERSECTION

C   IN
C     NDIM   : DIMENSION DU MAILLAGE
C     NDIME  : DIMENSION TOPOLOGIQUE DE LA MAILLE PARENT
C     ELREFP : �L�MENT DE R�F�RENCE PARENT
C     NNOP   : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
C     IGEOM  : COORDONN�ES DES NOEUDS DE L'�L�MENT PARENT
C     CO     : COORDONN�ES DU NOUVEAU NOEUD
C
C   OUT
C     FF    : FONCTIONS DE FORMES DE L'ELEMENT PARENT AU NOUVEAU NOEUD

C
      REAL*8       A(3),B(3),C(3),AB(3),AC(3),ND(3),NORME,NAB,Y(3)
      REAL*8       AN(NDIM),COLOC(2),R0,R1,R2,R3,RBID,XE(3),N(NDIM)
      REAL*8       DDOT
      INTEGER      J,IGEOLO,INO,IBID
      CHARACTER*24 GEOMLO

      CALL JEMARQ()

C     CAS DES ELEMENTS PRINCIPAUX : C SIMPLE, ON APPELLE REEREF
      IF (NDIM.EQ.NDIME) THEN
        CALL REERE3(ELREFP,NNOP,IGEOM,CO,R0,.FALSE.,NDIM,R1,
     &              IBID,IBID,IBID,IBID,IBID,R2,R3,'NON',
     &              XE,FF,R0,R0,R0,R0)


C     CAS DES ELEMENTS DE BORDS : C PLUS COMPLIQU�
C     ON NE PROCEDE PAS COMME DANS TE0036 CAR ICI, ON N'EST PAS
C     DANS UNE BOUCLE SUR LES SOUS-ELEMENTS
      ELSEIF (NDIM.NE.NDIME) THEN

        CALL ASSERT(NDIM.EQ.NDIME+1)

C       CREATION D'UNE BASE LOCALE A LA MAILLE PARENT ABCD
        CALL VECINI(3,0.D0,AB)
        CALL VECINI(3,0.D0,AC)
        DO 113 J=1,NDIM
          A(J)=ZR(IGEOM-1+NDIM*(1-1)+J)
          B(J)=ZR(IGEOM-1+NDIM*(2-1)+J)
          IF (NDIM.EQ.3) C(J)=ZR(IGEOM-1+NDIM*(3-1)+J)
          AB(J)=B(J)-A(J)
           IF (NDIM.EQ.3) AC(J)=C(J)-A(J)
 113    CONTINUE

        IF (NDIME.EQ.2) THEN
C         CREATION DU REPERE LOCAL LO : (AB,Y)
          CALL PROVEC(AB,AC,ND)
          CALL NORMEV(ND,NORME)
          CALL NORMEV(AB,NAB)
          CALL PROVEC(ND,AB,Y)
        ELSEIF (NDIME.EQ.1) THEN
C         CREATION DU REPERE LOCAL 1D : AB/NAB
          CALL NORMEV(AB,NAB)
          CALL VECINI(3,0.D0,ND)
          ND(1) = AB(2)
          ND(2) = -AB(1)
        ENDIF

C       COORDONN�ES DES NOEUDS DE L'ELREFP DANS LE REP�RE LOCAL
        GEOMLO='&&TE0036.GEOMLO'
        CALL WKVECT(GEOMLO,'V V R',NNOP*NDIME,IGEOLO)
        DO 114 INO=1,NNOP
          DO 115 J=1,NDIM
            N(J)=ZR(IGEOM-1+NDIM*(INO-1)+J)
            AN(J)=N(J)-A(J)
 115      CONTINUE
          ZR(IGEOLO-1+NDIME*(INO-1)+1)=DDOT(NDIM,AN,1,AB,1)
          IF (NDIME.EQ.2)
     &      ZR(IGEOLO-1+NDIME*(INO-1)+2)=DDOT(NDIM,AN,1,Y ,1)
 114    CONTINUE

C       COORDONN�ES R�ELLES LOCALES DU POINT EN QUESTION : COLOC
        DO 116 J=1,NDIM
          AN(J)=CO(J)-A(J)
 116    CONTINUE
        COLOC(1)=DDOT(NDIM,AN,1,AB,1)
        IF (NDIME.EQ.2) COLOC(2)=DDOT(NDIM,AN,1,Y,1)
          CALL REERE3(ELREFP,NNOP,IGEOLO,COLOC,RBID,.FALSE.,NDIME,RBID,
     &                IBID,IBID,IBID,IBID,IBID,RBID,RBID,'NON',
     &                 XE,FF,RBID,RBID,RBID,RBID)

        CALL JEDETR(GEOMLO)

      ENDIF

      CALL JEDEMA()

      END
