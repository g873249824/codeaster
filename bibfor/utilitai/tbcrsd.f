      SUBROUTINE TBCRSD ( NOMTA , BASETA )
      IMPLICIT   NONE
      CHARACTER*(*)       NOMTA , BASETA
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 27/09/2004   AUTEUR CIBHHLV L.VIVAN 
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
C      CREATION D'UNE STRUCTURE DE DONNEES "TABLE".
C      LA STRUCTURE D'UNE TABLE :
C       .TBBA : K8  : DEFINITION DE LA BASE
C       .TBNP :  I  : (1) NOMBRE DE PARAMETRES DE LA TABLE
C                     (2) NOMBRE DE LIGNES DE LA TABLE
C       .TBLP : K24 : DECRIT LES PARAMETRES DE LA TABLE
C                     (1) NOM DU PARAMETRE
C                     (2) TYPE DU PARAMETRE
C                     (3) NOM OBJET JEVEUX CONTENANT LES VALEURS
C                     (4) NOM OBJET JEVEUX CONTENANT DES LOGIQUES
C     ------------------------------------------------------------------
C IN  : NOMTA  : NOM DE LA STRUCTURE "TABLE" A CREER.
C IN  : BASETA : BASE SUR LAQUELLE ON CREE LA "TABLE".
C     ------------------------------------------------------------------
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER         ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8          ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16      ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL         ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8     ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                     ZK24
      CHARACTER*32                              ZK32
      CHARACTER*80                                       ZK80
      COMMON /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
      INTEGER      JTBBA, JTBNP, NDIM
      CHARACTER*1  BASE
      CHARACTER*19 NOMTAB
C DEB------------------------------------------------------------------
C
      CALL JEMARQ ( )
C
      NOMTAB = NOMTA
      IF (NOMTAB(18:19).NE.'  ') CALL UTMESS('F','TBCRSD',
     &   'ERREUR PGMATION '
     &   //'LE NOM D''UNE TABLE NE DOIT PAS DEPASSER 17 CARACTERES.')

      BASE   = BASETA(1:1)
      IF (BASE.NE.'V' .AND. BASE.NE.'G') THEN
         CALL UTMESS('F','TBCRSD','TYPE BASE INCONNU :'//BASE)
      ENDIF
C
C     --- CREATION DU .TBBA ---
C
      CALL WKVECT(NOMTAB//'.TBBA',BASE//' V K8',1,JTBBA)
      ZK8(JTBBA) = BASE
C
C     --- CREATION DU .TBNP ---
C
      CALL WKVECT(NOMTAB//'.TBNP',BASE//' V I',2,JTBNP)
      ZI(JTBNP  ) = 0
      ZI(JTBNP+1) = 0
C
C     --- CREATION DU .TBLP ---
C
C     LE VECTEUR EST CREE DANS LA ROUTINE "TBAJPA"
C      CALL JECREO(NOMTAB//'.TBLP',BASE//' V K24')
C      CALL JEECRA(NOMTAB//'.TBLP','LONMAX',...,' ')
C      CALL JEECRA(NOMTAB//'.TBLP','LONUTI',0,' ')
C
      CALL JEDEMA ( )
      END
