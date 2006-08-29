      SUBROUTINE NMVCLE(MODELZ,MATZ,CARELZ,LISCHZ,INSTAN,COMZ)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 28/08/2006   AUTEUR CIBHHPD L.SALMONA 
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

      IMPLICIT NONE

      CHARACTER*(*) MODELZ, MATZ, CARELZ, LISCHZ, COMZ
      REAL*8        INSTAN

      CHARACTER*8   MODELE, MATE, CARELE
      CHARACTER*19  LISCHA
      CHARACTER*14  COM

C ----------------------------------------------------------------------
C  LECTURE DES VARIABLES DE COMMANDE
C ----------------------------------------------------------------------
C IN/JXIN   MODELE  K8  SD MODELE
C IN/JXIN   MATE    K8  SD MATERIAU
C IN/JXIN   LISCHA  K19 SD L_CHARGES
C IN        INSTAN   R  INSTANT D'EVALUATION
C IN/JXOUT  COM     K14 SD VARI_COM
C ----------------------------------------------------------------------

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      LOGICAL      EXITMP, EXIVRC, EXIIRR
      CHARACTER*24 CHARGE, INFOCH
      CHARACTER*19 TEMP, SECH, CTPS, TOUT
      INTEGER      IBID, IEX,IRET
      INTEGER TYPESE
      CHARACTER*8 NOPASE
      CHARACTER*8  K8BID
      CHARACTER*24 STYPSE
      COMPLEX*16   CBID
      LOGICAL        GETEXM


      CALL JEMARQ()
      COM    = COMZ
      MODELE = MODELZ
      CARELE = CARELZ
      MATE   = MATZ
      LISCHA = LISCHZ
      EXIVRC = .FALSE.


C    SUPPRESSION DE L'OBJET S'IL EXISTE DEJA
      CALL DETRSD('VARI_COM',COM)


C    INITIALISATION
      CHARGE = LISCHA // '.LCHA'
      INFOCH = LISCHA // '.INFC'
      TYPESE = 0
      NOPASE = '        '


C    LISTE DES VARIABLES DE COMMANDE
      TEMP =  COM // '.TEMP'
      CTPS =  COM // '.INST'
      TOUT =  COM // '.TOUT'


C    CREATION DE LA SD VARI_COM

C    DETERMINATION DU CHAMP DE TEMPERATURE
      CALL NMDETE ( MODELE, MATE, CHARGE, INFOCH, INSTAN,
     >              TYPESE, STYPSE, NOPASE,
     >              TEMP, EXITMP )

C    DETERMINATION DU CHAMP DE VARC :
      CALL VRCINS(MODELE,MATE,CARELE,INSTAN,TOUT)
      CALL EXISD('CHAMP',TOUT,IRET)
      IF ( IRET.EQ.1 ) EXIVRC=.TRUE.
C    CARTE DE L'INSTANT COURANT
      CALL MECACT('V', CTPS, 'MODELE', MODELE(1:8)//'.MODELE',
     &            'INST_R', 1, 'INST', IBID, INSTAN, CBID, K8BID)

C    CHAMPS REELS (TRUE) OU PAR DEFAUT (FALSE)
      CALL WKVECT(COM//'.EXISTENCE','V V L ',2,IEX)
      ZL(IEX+0) = EXITMP
      ZL(IEX+1) = EXIVRC


      CALL JEDEMA()
      END
