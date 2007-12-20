      SUBROUTINE IMPMIN(SDIMPR,IMPTMP,FONACT,INFCMP,NBSUIV,
     &                  ZTIT  ,ZDEF  ,MOTFAC,IOCC)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*14 SDIMPR
      CHARACTER*14 IMPTMP
      LOGICAL      FONACT(*)
      INTEGER      INFCMP(4)
      INTEGER      NBSUIV
      INTEGER      ZTIT
      INTEGER      ZDEF
      CHARACTER*16 MOTFAC
      INTEGER      IOCC
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (AFFICHAGE)
C
C VALEURS MINIMALES DE L'AFFICHAGE DU TABLEAU DE CONVERGENCE
C
C ----------------------------------------------------------------------
C
C
C  * ITERATION DE NEWTON COURANTE
C  * RESI_RELA
C  * RESI_MAXI
C  * LES INFO DETAILLEES SUR LES RESIDUS SI DEMANDE (INFCMP)
C
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  SDIMPR : NOM DE LA SD AFFICHAGE
C IN  IMPTMP : NOM DU VECTEUR TEMPORAIRE D'ACTIVATION DES COLONNES
C IN  INFCMP : VAUT 1 SI ON DOIT AFFICHER DES INFOS SUR LE NOEUD OU
C              LES RESIDUS SONT EVALUES
C               (1) RESI_RELA
C               (2) RESI_MAXI
C               (3) RESI_REFE
C               (4) CTCD_GEOM
C IN  NBSUIV : NOMBRE DE SUIVIS AUTOMATIQUES
C IN  ZTIT   : NOMBRE MAXI DE LIGNES D'UN TITRE
C IN  ZDEF   : NOMBRE MAXI DE COLONNES DISPONIBLES POUR L'AFFICHAGE
C IN  MOTFAC : MOT-CLEF FACTEUR AFFICHAGE
C IN  IOCC   : OCCURRENCE DU MOT-CLEF FACTEUR AFFICHAGE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      ICOD,FORCOL,IBID,ICOL
      CHARACTER*16 TITCOL(ZTIT)
      INTEGER      LONGR,PRECR,LONGI,LONGK
      INTEGER      NBCOL,JIMCOL
      CHARACTER*24 SDSUIV
      INTEGER      JIMPSU      
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- NOM DE LA SD POUR LE SUIVI
C
      CALL JEVEUO(SDIMPR(1:14)//'SUIVI','L',JIMPSU)
      SDSUIV = ZK24(JIMPSU-1+1)      
C
      CALL JEVEUO(IMPTMP,'E',JIMCOL)
C
      IBID = 0
C
C --- DEFINITION DES COLONNES ACTIVEES
C
      CALL IMPDEF(ZDEF  ,FONACT,'MINIMUM ',INFCMP,NBSUIV,          
     &            JIMCOL,NBCOL)
C
C --- RECUPERATION DES PRECISIONS 
C
      CALL IMPPRE(MOTFAC,IOCC,
     &            LONGR,PRECR,LONGI,LONGK)
C
C --- ACTIVATION DES COLONNES
C
      DO 45 ICOL = 1,NBCOL
        IBID = 0
        ICOD = ZI(JIMCOL-1+ICOL)
        CALL IMPREF(ICOD,SDSUIV,
     &              TITCOL,FORCOL)
        CALL IMPSDA(SDIMPR,'AJOU',IBID,
     &              ICOD,TITCOL,FORCOL,
     &              LONGR,PRECR,LONGI,LONGK)
  45  CONTINUE
C
      CALL JEDETR('&&IMPMIN.COL')
C
      CALL JEDEMA()

      END
