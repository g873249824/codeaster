      SUBROUTINE PROJMR(MATRAS,NOMRES,NOMSTO,BASEMO,NOMNUM,NU,NEQ,NBMO)
      IMPLICIT NONE
      INTEGER             NEQ, NBMO
      CHARACTER*8         MATRAS, NOMRES, BASEMO
      CHARACTER*14        NU
      CHARACTER*19        NOMSTO, NOMNUM
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/03/2004   AUTEUR OUGLOVA A.OUGLOVA 
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
C-----------------------------------------------------------------------
C
C     CALCUL PROJECTION MATRICE REELLE SUR BASE DE RITZ
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
      CHARACTER*32   JEXNUM,JEXNOM
C      ---- FIN DES COMMUNS JEVEUX ------------------------------------
C
      INTEGER      IBID, IDDEEQ, LLDESC, NUEQ, NTBLOC, NBLOC, IALIME,
     +             IACONL, IAREFE, IADESC, I, J, IMATRA, IADIA, IABLO, 
     +             IHCOL, IBLO, LDBLO, N1BLOC, N2BLOC, IADMOD, IRET,
     +             IDVEC2, IDBASE
      REAL*8       PIJ, R8DOT
      CHARACTER*8  K8B
      CHARACTER*16 TYPBAS
      CHARACTER*19 MATR, RESU, NOMCHA
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      RESU = NOMRES
      MATR = MATRAS
      CALL GETTCO(BASEMO,TYPBAS)
      CALL JEVEUO ( NU//'.NUME.DEEQ', 'L', IDDEEQ )
C
      CALL JEVEUO ( NOMSTO//'.DESC', 'L', LLDESC )
      NUEQ   = ZI(LLDESC)
      NTBLOC = ZI(LLDESC+1)
      NBLOC  = ZI(LLDESC+2)
C
      CALL JECREC ( RESU//'.VALE', 'G V R', 'NU', 'DISPERSE', 
     &                                            'CONSTANT', NBLOC )
      CALL JEECRA ( RESU//'.VALE', 'LONMAX', NTBLOC, K8B )
      CALL JEECRA ( RESU//'.VALE', 'DOCU', IBID, 'MS' )
C
      CALL WKVECT ( RESU//'.LIME', 'G V K8', 1, IALIME )
      ZK8(IALIME) = '        '
C
      CALL WKVECT ( RESU//'.CONL', 'G V R' , NUEQ, IACONL )
      DO 10 I = 1 , NUEQ
         ZR(IACONL+I-1) = 1.0D0
 10   CONTINUE
C
      CALL WKVECT ( RESU//'.REFA', 'G V K24', 4, IAREFE )
      CALL JEECRA ( RESU//'.REFA', 'DOCU', IBID, 'SLCS' )
      ZK24(IAREFE)   = BASEMO
      ZK24(IAREFE+1) = NOMNUM
      ZK24(IAREFE+2) = NOMSTO
C
      CALL WKVECT ( RESU//'.DESC', 'G V I', 3, IADESC )
      ZI(IADESC)   = 2
      ZI(IADESC+1) = NUEQ
C   On teste la hauteur maximale des colonnes de la matrice
C   si cette hauteur vaut 1, on suppose que le stockage est diagonal
      IF (ZI(LLDESC+3).EQ.1) THEN
        ZI(IADESC+2) = 1
      ELSE
        ZI(IADESC+2) = 2
      ENDIF  
C
      CALL WKVECT ( '&&PROJMR.VECTASS2', 'V V R', NEQ, IDVEC2 )
      CALL WKVECT ( '&&PROJMR.BASEMO','V V R',NBMO*NEQ,IDBASE)
C ----- CONVERSION DE BASEMO A LA NUMEROTATION NU
      IF ((TYPBAS.EQ.'MODE_MECA').OR.(TYPBAS.EQ.'MODE_GENE')) THEN
         CALL COPMOD(BASEMO,'DEPL',NEQ,NU,NBMO,ZR(IDBASE))
      ELSE
         CALL COPMO2(BASEMO,NEQ,NU,NBMO,ZR(IDBASE))
      ENDIF
C
      CALL MTDSCR ( MATRAS )
      CALL JEVEUO ( MATR//'.&INT', 'E', IMATRA )
C
C --- RECUPERATION DE LA STRUCTURE DE LA MATR_ASSE_GENE
C
      CALL JEVEUO ( NOMSTO//'.ADIA', 'L', IADIA )
      CALL JEVEUO ( NOMSTO//'.ABLO', 'L', IABLO )
      CALL JEVEUO ( NOMSTO//'.HCOL', 'L', IHCOL )
C
      DO 20 IBLO = 1 , NBLOC
C
         CALL JECROC ( JEXNUM(RESU//'.VALE',IBLO) )
         CALL JEVEUO ( JEXNUM(RESU//'.VALE',IBLO), 'E', LDBLO )
C
C ------ PROJECTION DE LA MATRICE ASSEMBLEE
C
C        BOUCLE SUR LES COLONNES DE LA MATRICE ASSEMBLEE
C
         N1BLOC = ZI(IABLO+IBLO-1)+1
         N2BLOC = ZI(IABLO+IBLO)
C
         DO 30 I = N1BLOC , N2BLOC
C
C --------- CALCUL PRODUIT MATRICE*MODE I
C
            CALL MRMULT ( 'ZERO', IMATRA, ZR(IDBASE+(I-1)*NEQ),
     &                    'R',ZR(IDVEC2),1)
            CALL ZERLAG ( ZR(IDVEC2), NEQ, ZI(IDDEEQ) )
C
C --------- BOUCLE SUR LES INDICES VALIDES DE LA COLONNE I
C
            DO 40 J = (I-ZI(IHCOL+I-1)+1) , I
C
C ------------ PRODUIT SCALAIRE VECTASS * MODE
C
               PIJ = R8DOT( NEQ, ZR(IDBASE+(J-1)*NEQ),1,ZR(IDVEC2),1)
C
C ------------ STOCKAGE DANS LE .VALE A LA BONNE PLACE (1 BLOC)
C
               ZR(LDBLO+ZI(IADIA+I-1)+J-I-1) = PIJ
C
 40         CONTINUE
 30      CONTINUE
         CALL JELIBE ( JEXNUM(RESU//'.VALE', IBLO) )
 20   CONTINUE
C
      CALL JEDETR('&&PROJMR.VECTASS2')
      CALL JEDETR('&&PROJMR.BASEMO')
C
      CALL JEDEMA()
      END
