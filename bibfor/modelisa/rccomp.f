      SUBROUTINE RCCOMP ( CHMAT, NOMAIL, NOMODE )
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8         CHMAT, NOMAIL, NOMODE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 18/12/2012   AUTEUR SELLENET N.SELLENET 
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
C
C  IN : CHMAT  : CHAMP MATERIAU PRODUIT
C  IN : NOMAIL : NOM DU MAILLAGE
C ----------------------------------------------------------------------
C ----------------------------------------------------------------------
C
      INTEGER IBID, NOCC,I,J,NM, NT, JNCMP, JVALV, NBMA,JMAIL
      CHARACTER*8   TYPMCL(2)
      CHARACTER*16  MOTCLE(2)
      CHARACTER*24  MESMAI
      CHARACTER*1 K1BID

      INTEGER NCMPMA,ICMP,ICPRI,ICPRK,NBGMAX,ICP,NUMLC
      PARAMETER (NCMPMA=7+9+4)
      CHARACTER*8 NOMCMP(NCMPMA),K8B,SDCOMP
      CHARACTER*16 COMCOD
      CHARACTER*19 COMPOR
      INTEGER      IARG
      DATA NOMCMP/'RELCOM  ','NBVARI  ','DEFORM  ','INCELA  ',
     &     'C_PLAN  ','XXXX1','XXXX2','KIT1    ','KIT2    ','KIT3    ',
     &     'KIT4    ','KIT5    ','KIT6    ','KIT7    ','KIT8    ',
     &     'KIT9    ', 'NVI_C   ', 'NVI_T   ', 'NVI_H   ', 'NVI_M   '/
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL GETFAC ( 'AFFE_COMPOR' , NOCC )
      IF(NOCC.EQ.0)GOTO 999

      COMPOR = CHMAT//'.COMPOR'
C
      CALL ALCART ( 'G', COMPOR, NOMAIL, 'COMPOR')
      CALL JEVEUO ( COMPOR//'.NCMP', 'E', JNCMP )
      CALL JEVEUO ( COMPOR//'.VALV', 'E', JVALV )
C
      DO 90 ICMP = 1,NCMPMA
        ZK8(JNCMP+ICMP-1) = NOMCMP(ICMP)
        ZK16(JVALV+ICMP-1)= ' '
 90   CONTINUE
C
      MOTCLE(1) = 'GROUP_MA'
      MOTCLE(2) = 'MAILLE'
      TYPMCL(1) = 'GROUP_MA'
      TYPMCL(2) = 'MAILLE'
C
      MESMAI = '&&RCCOMP.MES_MAILLES'
C
      DO 10 I = 1 , NOCC
         CALL GETVID ( 'AFFE_COMPOR', 'COMPOR' , I,IARG,1, SDCOMP, NM )
         CALL JEVEUO(SDCOMP//'.CPRI','L',ICPRI)
         CALL ASSERT(ZI(ICPRI).EQ.3)
C ---ON MET LE NOM DE LA PREMIERE RELATION NON VIDE DANS RELCOM POUR QUE
C    ALGO1D FONCTIONNE (AVEC UN SEUL GROUPE DE FIBRE)
         CALL JEVEUO(SDCOMP//'.CPRK','L',ICPRK)
C --- RECHERCHE DE LA PREMIERE RELATION NON VIDE
         CALL JELIRA(SDCOMP//'.CPRK','LONMAX',NBGMAX,K1BID)
         NBGMAX=(NBGMAX-1)/6
         DO 20 J=1,NBGMAX
           ICP=ICPRK-1+6*(J-1)
           IF(ZK24(ICP+2).NE.'VIDE')GOTO 25
   20    CONTINUE
         CALL U2MESS('F','MODELISA7_99')
   25    CONTINUE
C---- REMPLISSAGE DE LA CARTE
         ZK16(JVALV-1+1) = ZK24(ICP+3)
         WRITE (ZK16(JVALV-1+2),'(I16)') ZI(ICPRI+1)
         ZK16(JVALV-1+3) = ZK24(ICP+5)
         ZK16(JVALV-1+4) = 'COMP_INCR'
         ZK16(JVALV-1+5) = ZK24(ICP+4)
C         APPEL A LCINFO POUR RECUPERER LE NUMERO DE LC
         CALL LCCREE(1, ZK24(ICP+3), COMCOD)
         CALL LCINFO(COMCOD, NUMLC, IBID)
         WRITE(ZK16(JVALV-1+6),'(I16)') NUMLC
         ZK16(JVALV-1+7) = SDCOMP//'.CPRK'

         CALL GETVTX ( 'AFFE_COMPOR', 'TOUT'  , I,IARG,1, K8B   , NT )
         IF ( NT .NE. 0 ) THEN
            CALL NOCART ( COMPOR, 1, K8B, K8B, 0, K8B, IBID, ' ',NCMPMA)
         ELSE
            CALL RELIEM(NOMODE,NOMAIL,'NU_MAILLE','AFFE_COMPOR',I,2,
     &                              MOTCLE(1),TYPMCL(1), MESMAI, NBMA )
            IF ( NBMA .NE. 0 ) THEN
               CALL JEVEUO ( MESMAI, 'L', JMAIL )
               CALL NOCART ( COMPOR, 3, K8B, 'NUM', NBMA, K8B,
     &                                         ZI(JMAIL), ' ', NCMPMA )
               CALL JEDETR ( MESMAI )
            ENDIF
         ENDIF
 10   CONTINUE


      CALL JEDETR ( COMPOR//'.VALV' )
      CALL JEDETR ( COMPOR//'.NCMP' )

999   CONTINUE
      CALL JEDEMA()
      END
