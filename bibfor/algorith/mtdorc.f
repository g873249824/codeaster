      SUBROUTINE MTDORC(MODELZ,COMPOZ,CARCRI)
      IMPLICIT NONE
      CHARACTER*(*) MODELZ,COMPOZ
      CHARACTER*24  CARCRI
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/12/2010   AUTEUR GENIAUT S.GENIAUT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     SAISIE ET VERIFICATION DE LA RELATION DE COMPORTEMENT UTILISEE
C     POUR CALC_META
C IN  MODELZ  : NOM DU MODELE
C OUT COMPOZ  : CARTE DECRIVANT LE TYPE DE COMPORTEMENT
C OUT CARCRI  : CARTE DECRIVANT LES CRITERES LOCAUX DE CONVERGENCE
C                     0 : ITER_INTE_MAXI
C                     1 : COMPOSANTE INUTILISEE
C                     2 : RESI_INTE_RELA
C                     3 : THETA 
C                     4 : ITER_INTE_PAS
C                     5 : ALGO_INTE
C ----------------------------------------------------------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

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
      CHARACTER*32     JEXNUM, JEXNOM
C ----------------------------------------------------------------------
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      INTEGER NCMPMA,DIMAKI,N2,N3,IBID,NBOCC,I,ICMP,II,JMA,JNCMP
      INTEGER JNOMA,JVALV,K,N1,NBMA,NBMO1,NBVARI,NBVARM
      INTEGER NBMAT,NBKIT,IMA,IM,IRET,ICPRI,NBSYST
      INTEGER INV,DIMANV,NBMONO,NUMGD,NUMLC,NUNIT,NUMLC2
C    DIMAKI = DIMENSION MAX DE LA LISTE DES RELATIONS KIT
      PARAMETER (DIMAKI=9)
C    DIMANV = DIMENSION MAX DE LA LISTE DU NOMBRE DE VAR INT EN THM
      PARAMETER (DIMANV=4)
      INTEGER NBNVI(DIMANV),NCOMEL
      PARAMETER (NCMPMA=7+DIMAKI+DIMANV)
      CHARACTER*6 NOMPRO
      PARAMETER (NOMPRO='MTDORC')
      CHARACTER*8  NOMA,NOMGRD,NOMCMP(NCMPMA),K8B,TYPMCL(2),SDCOMP,CHMAT
      CHARACTER*16 COMP,DEFO,MOCLEF(2),K16BID,NOMCMD,MOCLES(2)
      CHARACTER*16 LCOMEL(5),COMCOD
      CHARACTER*16 VALCMP(NCMPMA),TXCP,TX1D,TYMATG,NOMKIT(DIMAKI)
      CHARACTER*19 COMPOR,CHS(2),CHS3
      CHARACTER*24 LIGRMO,MODELE,MESMAI
      REAL*8 RBID
      COMPLEX*16 LCOEC(2),CBID
      LOGICAL EXIST,GETEXM
      
      DATA NOMGRD/'COMPOR  '/
      DATA NOMCMP/'RELCOM  ','NBVARI  ','DEFORM  ','INCELA  ',
     &     'C_PLAN  ','XXXX1','XXXX2','KIT1    ','KIT2    ','KIT3    ',
     &     'KIT4    ','KIT5    ','KIT6    ','KIT7    ','KIT8    ',
     &     'KIT9    ', 'NVI_C   ', 'NVI_T   ', 'NVI_H   ', 'NVI_M   '/
C     ------------------------------------------------------------------
      CALL JEMARQ()
C     initialisations
      MODELE = MODELZ

      CALL GETRES(K8B,K16BID,NOMCMD)

      COMPOR = '&&'//NOMPRO//'.COMPOR'
        NBMO1 = 1
        MOCLEF(1) = 'COMP_INCR'

      MOCLES(1) = 'GROUP_MA'
      MOCLES(2) = 'MAILLE'
      TYPMCL(1) = 'GROUP_MA'
      TYPMCL(2) = 'MAILLE'
      MESMAI = '&&'//NOMPRO//'.MES_MAILLES'

      LIGRMO = MODELE(1:8)//'.MODELE'
      CALL JEVEUO(LIGRMO(1:19)//'.LGRF','L',JNOMA)
      NOMA = ZK8(JNOMA)

C ======================================================================
C                       REMPLISSAGE DE LA CARTE COMPOR :
C --- ON STOCKE LE NOMBRE DE VARIABLES INTERNES PAR RELATION -----------
C --- DE COMPORTEMENT --------------------------------------------------
C ======================================================================

      CALL ALCART('V',COMPOR,NOMA,NOMGRD)
      CALL JEVEUO(COMPOR//'.NCMP','E',JNCMP)
      CALL JEVEUO(COMPOR//'.VALV','E',JVALV)
      DO 90 ICMP = 1,NCMPMA
        ZK8(JNCMP+ICMP-1) = NOMCMP(ICMP)
   90 CONTINUE

C     mots cles facteur
      DO 160 I = 1,NBMO1
        CALL GETFAC(MOCLEF(I),NBOCC)

C       nombre d'occurrences
        DO 150 K = 1,NBOCC

          CALL GETVTX(MOCLEF(I),'RELATION',K,1,1,COMP,N1)
          CALL GETVIS(MOCLEF(I),COMP,K,1,1,NBVARI,N1)
          ZK16(JVALV-1+1) = COMP
          WRITE (ZK16(JVALV-1+2),'(I16)') NBVARI
          ZK16(JVALV-1+3) = ' '
          ZK16(JVALV-1+4) = MOCLEF(I)
          ZK16(JVALV-1+5) = ' '
          CALL RELIEM(MODELE,NOMA,'NU_MAILLE',MOCLEF(I),K,2,MOCLES,
     &                TYPMCL,MESMAI,NBMA)
          IF (NBMA.NE.0) THEN
            CALL JEVEUO(MESMAI,'L',JMA)
            CALL NOCART(COMPOR,3,K8B,'NUM',NBMA,K8B,ZI(JMA),' ',NCMPMA)
            CALL JEDETR(MESMAI)
          ELSE
C -----   PAR DEFAUT C'EST TOUT='OUI'
            CALL NOCART(COMPOR,1,K8B,K8B,0,K8B,IBID,K8B,NCMPMA)
          END IF
  150   CONTINUE
  160 CONTINUE
  170 CONTINUE

      CALL JEDETR(COMPOR//'.NCMP')
      CALL JEDETR(COMPOR//'.VALV')
      COMPOZ = COMPOR
C FIN ------------------------------------------------------------------
      CALL JEDEMA()
      END
