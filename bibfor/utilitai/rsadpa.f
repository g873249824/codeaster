      SUBROUTINE RSADPA(NOMSD,CEL,NPARA,LPARA,IORDR,ITYPE,LJEVEU,CTYPE)
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      INTEGER NPARA,IORDR,ITYPE,LJEVEU(*)
      CHARACTER*1 CEL
      CHARACTER*(*) NOMSD,LPARA(*),CTYPE(*)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 04/09/2012   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE SELLENET N.SELLENET

C      RECUPERATION DES ADRESSES JEVEUX DES PARAMETRES DE CALCUL
C      (OU DES VARIABLES D'ACCES)
C      D'UN RESULTAT-COMPOSE POUR LE NUMERO D'ORDRE : IORDR
C      ET POUR LA LISTE DE VARIABLES DE NOMS SYMBOLIQUES LPARA.
C ----------------------------------------------------------------------
C IN  : NOMSD  : NOM DE LA STRUCTURE "RESULTAT".
C IN  : CEL    : CONDITION D'ACCES AUX PARAMETRES :
C                    'L' : LECTURE, 'E' : ECRITURE.
C IN  : NPARA  : NOMBRE DE PARAMETRES CHERCHES.
C IN  : LPARA  : LISTE DES NOMS SYMBOLIQUES DES PARAMETRES.
C IN  : IORDR  : NUMERO D'ORDRE SOUHAITE.
C IN  : ITYPE  : CODE INDIQUANT QUE L'ON DESIRE LE TYPE
C                     = 0  PAS DE TYPE
C                    /= 0  ON FOURNIT LE TYPE
C OUT : LJEVEU : LISTE DES ADRESSES JEVEUX DANS ZI,ZR,...
C OUT : CTYPE  : CODE DU TYPE
C               R REAL,I INTEGER,C COMPLEXE,K8 K16 K24 K32 K80 CHARACTER
C-----------------------------------------------------------------------
C REMARQUE : CETTE ROUTINE NE FAIT PAS JEMARQ/JEDEMA POUR NE PAS
C            INVALIDER LJEVEU
C-----------------------------------------------------------------------
      INTEGER IBID,NBORDR,NRANG,JORDR,I,IPARA,IER,IRANG,IFR,IUNIFI
      INTEGER VALI(2)
      REAL*8 R8BID
      CHARACTER*8 K8B
      CHARACTER*24 VALK(3)
      CHARACTER*16 PARAM,K16B
      CHARACTER*19 NOMS2
C ----------------------------------------------------------------------

      NOMS2 = NOMSD

C     --- RECUPERATION DU NUMERO DE RANGEMENT ---
      CALL RSUTRG(NOMSD,IORDR,IRANG,NRANG)

      IF (CEL.EQ.'L') THEN
        IF (IRANG.EQ.0) THEN
          VALK (1) = NOMSD
          VALI (1) = IORDR
          CALL U2MESG('F', 'UTILITAI6_77',1,VALK,1,VALI,0, R8BID)
        END IF
      ELSE
        IF (IRANG.EQ.0) THEN
          CALL JELIRA(NOMS2//'.ORDR','LONMAX',NBORDR,K8B)
          NRANG = NRANG + 1
          IF (NRANG.GT.NBORDR) THEN
            VALK (1) = NOMSD
            VALI (1) = IORDR
            VALI (2) = NBORDR
            CALL U2MESG('F', 'UTILITAI6_78',1,VALK,2,VALI,0, R8BID)
          END IF
          CALL JEECRA(NOMS2//'.ORDR','LONUTI',NRANG,' ')
          CALL JEVEUO(NOMS2//'.ORDR','E',JORDR)
          IF ( NRANG.GT.1 ) THEN
            CALL ASSERT(ZI(JORDR+NRANG-2).LT.IORDR)
          ENDIF
          ZI(JORDR+NRANG-1) = IORDR
          IRANG = NRANG
        END IF
      END IF

      CALL JELIRA(JEXNUM(NOMS2//'.TACH',1),'LONMAX',NBORDR,K8B)
      IF (IRANG.GT.NBORDR) THEN
          VALK (1) = NOMSD
          VALI (1) = IRANG
          VALI (2) = NBORDR
        CALL U2MESG('F', 'UTILITAI6_79',1,VALK,2,VALI,0, R8BID)
      END IF

      DO 10,I = 1,NPARA
        PARAM = LPARA(I)
        CALL JENONU(JEXNOM(NOMS2//'.NOVA',PARAM),IPARA)
        IF (IPARA.EQ.0) THEN
          IFR = IUNIFI('RESULTAT')
          CALL DISMOI('F','TYPE_RESU',NOMSD,'RESULTAT',IBID,K16B,IER)
          CALL JEIMPO(IFR,NOMS2//'.NOVA',' ',' ')
          VALK (1) = NOMSD
          VALK (2) = PARAM
          VALK (3) = K16B
          CALL U2MESG('F', 'UTILITAI6_80',3,VALK,0,0,0, R8BID)
        END IF

        CALL EXTRS3(NOMS2,PARAM,IRANG,CEL,ITYPE,CTYPE(I),LJEVEU(I))

   10 CONTINUE

      END
