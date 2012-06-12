      SUBROUTINE PROJMC(MATRAS,NOMRES,BASEMO,NUGENE,NU,NEQ,NBMO)
      IMPLICIT NONE
      INTEGER             NEQ, NBMO
      CHARACTER*8         MATRAS, NOMRES, BASEMO
      CHARACTER*14        NU
      CHARACTER*19        NOMSTO
      CHARACTER*14        NUGENE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/06/2012   AUTEUR PELLET J.PELLET 
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
C-----------------------------------------------------------------------
C
C     CALCUL PROJECTION MATRICE COMPLEXE SUR BASE DE RITZ
C
C-----------------------------------------------------------------------
C      ---- DEBUT DES COMMUNS JEVEUX ----------------------------------
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
      CHARACTER*32   JEXNUM
C      ---- FIN DES COMMUNS JEVEUX ------------------------------------
C
      INTEGER       IDDEEQ, JSCDE, NUEQ, NTBLOC, NBLOC, IALIME,
     &             IACONL, JREFA, IADESC, I, J, K, IMATRA, JSCDI,
     &             JSCBL, JSCHC, IBLO, LDBLO, N1BLOC, N2BLOC,
     &              IDVEC2, IDVEC3, IDBASE
      COMPLEX*16   PIJ
      CHARACTER*8  K8B
      CHARACTER*16 TYPBAS
      CHARACTER*19 RESU
      REAL*8       ZERO
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      ZERO = 0.D0
      RESU = ' '
      RESU(1:8) = NOMRES
      CALL GETTCO(BASEMO,TYPBAS)
      CALL JEVEUO ( NU//'.NUME.DEEQ', 'L', IDDEEQ )
C
      NOMSTO=NUGENE//'.SLCS'
      CALL JEVEUO ( NOMSTO//'.SCDE', 'L', JSCDE )
      NUEQ   = ZI(JSCDE-1+1)
      NTBLOC = ZI(JSCDE-1+2)
      NBLOC  = ZI(JSCDE-1+3)
C
      CALL JECREC ( RESU//'.UALF', 'G V C', 'NU', 'DISPERSE',
     &                                            'CONSTANT', NBLOC )
      CALL JEECRA ( RESU//'.UALF', 'LONMAX', NTBLOC, K8B )
C
      CALL WKVECT ( RESU//'.LIME', 'G V K24', 1, IALIME )
      ZK24(IALIME) = '                        '
C
      CALL WKVECT ( RESU//'.CONL', 'G V C' , NUEQ, IACONL )
      DO 10 I = 1 , NUEQ
         ZC(IACONL+I-1) = DCMPLX(1.0D0,0.0D0)
 10   CONTINUE
C
      CALL WKVECT ( RESU//'.REFA', 'G V K24',11,JREFA )
      ZK24(JREFA-1+11)='MPI_COMPLET'
      ZK24(JREFA-1+1)   = BASEMO
      ZK24(JREFA-1+2) = NUGENE
      ZK24(JREFA-1+9) = 'MS'
      ZK24(JREFA-1+10) = 'GENE'
C
      CALL WKVECT ( RESU//'.DESC', 'G V I', 3, IADESC )
      ZI(IADESC)   = 2
      ZI(IADESC+1) = NUEQ
C   ON TESTE LA HAUTEUR MAXIMALE DES COLONNES DE LA MATRICE
C   SI CETTE HAUTEUR VAUT 1, ON SUPPOSE QUE LE STOCKAGE EST DIAGONAL
      IF (ZI(JSCDE-1+4).EQ.1) THEN
        ZI(IADESC+2) = 1
      ELSE
        ZI(IADESC+2) = 2
      ENDIF
C
      CALL WKVECT ( '&&PROJMC.VECTASS2', 'V V C', NEQ, IDVEC2 )
      CALL WKVECT ( '&&PROJMC.VECTASS3', 'V V C', NEQ, IDVEC3 )
      CALL WKVECT ( '&&PROJMC.BASEMO','V V R',NBMO*NEQ,IDBASE)
C ----- CONVERSION DE BASEMO A LA NUMEROTATION NU
      IF (TYPBAS.EQ.'MODE_GENE') THEN
         CALL COPMOD(BASEMO,'DEPL',NEQ,NU,NBMO,ZR(IDBASE))
      ELSE
         CALL COPMO2(BASEMO,NEQ,NU,NBMO,ZR(IDBASE))
      ENDIF
C
      CALL MTDSCR ( MATRAS )
      CALL JEVEUO ( MATRAS//'           .&INT', 'E', IMATRA )
C
C --- RECUPERATION DE LA STRUCTURE DE LA MATR_ASSE_GENE
C
      CALL JEVEUO ( NOMSTO//'.SCDI', 'L', JSCDI )
      CALL JEVEUO ( NOMSTO//'.SCBL', 'L', JSCBL )
      CALL JEVEUO ( NOMSTO//'.SCHC', 'L', JSCHC )
C
      DO 20 IBLO = 1 , NBLOC
C
         CALL JECROC ( JEXNUM(RESU//'.UALF',IBLO) )
         CALL JEVEUO ( JEXNUM(RESU//'.UALF',IBLO), 'E', LDBLO )
C
C ------ PROJECTION DE LA MATRICE ASSEMBLEE
C
C        BOUCLE SUR LES COLONNES DE LA MATRICE ASSEMBLEE
C
         N1BLOC = ZI(JSCBL+IBLO-1)+1
         N2BLOC = ZI(JSCBL+IBLO)
C
         DO 30 I = N1BLOC , N2BLOC
C
            DO 32 K = 1 , NEQ
              ZC(IDVEC2+K-1)=DCMPLX(ZR(IDBASE+(I-1)*NEQ+K-1),ZERO)
 32         CONTINUE
C
C --------- CALCUL PRODUIT MATRICE*MODE I
C
            CALL MCMULT ('ZERO',IMATRA,ZC(IDVEC2),ZC(IDVEC3),1,
     &.TRUE.)
            CALL ZECLAG (ZC(IDVEC3), NEQ, ZI(IDDEEQ))
C
C --------- BOUCLE SUR LES INDICES VALIDES DE LA COLONNE I
C
            DO 40 J = (I-ZI(JSCHC+I-1)+1) , I
C
C ----------- PRODUIT SCALAIRE VECTASS * MODE
C
              PIJ = DCMPLX(ZERO,ZERO)
              DO 42 K = 1 , NEQ
                PIJ = PIJ + ZC(IDVEC3+K-1)*
     &                DCMPLX(ZR(IDBASE+(J-1)*NEQ+K-1),ZERO)
 42           CONTINUE
C
C ----------- STOCKAGE DANS LE .UALF A LA BONNE PLACE (1 BLOC)
C
              ZC(LDBLO+ZI(JSCDI+I-1)+J-I-1) = PIJ
C
 40      CONTINUE
 30      CONTINUE
         CALL JELIBE(JEXNUM(RESU//'.UALF',IBLO))
 20   CONTINUE
C
      CALL JEDETR('&&PROJMC.VECTASS2')
      CALL JEDETR('&&PROJMC.VECTASS3')
      CALL JEDETR('&&PROJMC.BASEMO')
C

      CALL UALFVA(RESU,'G')
      CALL JEDEMA()
      END
