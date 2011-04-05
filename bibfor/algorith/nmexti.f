      SUBROUTINE NMEXTI(NOMNOE,CHAMP ,NBCMP ,LISTCP,EXTRCP,
     &                  NVALCP,VALRES)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/01/2011   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT      NONE
      REAL*8        VALRES(*)
      CHARACTER*8   NOMNOE
      INTEGER       NBCMP
      INTEGER       NVALCP
      CHARACTER*19  CHAMP
      CHARACTER*24  LISTCP
      CHARACTER*8   EXTRCP
C
C ----------------------------------------------------------------------
C
C ROUTINE *_NON_LINE (EXTRACTION - UTILITAIRE)
C
C EXTRAIRE LES VALEURS DES COMPOSANTES - NOEUD
C
C ----------------------------------------------------------------------
C
C
C IN  EXTRCP : TYPE D'EXTRACTION SUR LES COMPOSANTES
C IN  NOMNOE : NOM DU NOEUD
C IN  CHAMP  : CHAMP OBSERVE
C IN  NBCMP  : NOMBRE DE COMPOSANTES
C IN  LISTCP : LISTE DES COMPOSANTES
C OUT VALRES : VALEUR DES COMPOSANTES
C OUT NVALCP : NOMBRE EFFECTIF DE COMPOSANTES
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER      ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8       ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16   ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL      ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8  ZK8
      CHARACTER*16    ZK16
      CHARACTER*24        ZK24
      CHARACTER*32            ZK32
      CHARACTER*80                ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      NPARX
      PARAMETER    (NPARX=20)
      CHARACTER*8  NOMCMP(NPARX)
      REAL*8       VALCMP(NPARX)         
      INTEGER      NEFF
      INTEGER      IEFF,ICMP,IPAR
      INTEGER      JCMP,JCHAMP
      CHARACTER*8  CMP
      INTEGER      NUNO,NUDDL
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      IEFF   = 1
      CALL ASSERT(NBCMP.LE.NPARX)
C
C --- ACCES CHAMP
C
      CALL JEVEUO(CHAMP //'.VALE','L',JCHAMP)
C 
C --- NOM DES COMPOSANTES
C
      CALL JEVEUO(LISTCP,'L',JCMP  ) 
C      
      DO 20 ICMP = 1,NBCMP
        NOMCMP(ICMP) = ZK8(JCMP-1+ICMP)
  20  CONTINUE
C 
C --- VALEURS DES COMPOSANTES
C
      DO 30 IPAR = 1,NBCMP
        CMP = NOMCMP(IPAR)
        CALL POSDDL('CHAM_NO',CHAMP ,NOMNOE,CMP   ,NUNO  ,NUDDL )
        IF ((NUNO.NE.0).AND.(NUDDL.NE.0)) THEN
          VALCMP(IEFF) = ZR(JCHAMP+NUDDL-1)
          IEFF = IEFF + 1
        ENDIF
  30  CONTINUE
      NEFF = IEFF - 1
C
C --- EVALUATION
C
      CALL NMEXTV(NEFF  ,EXTRCP,NOMCMP,VALCMP,NVALCP,
     &            VALRES)
      CALL ASSERT(NVALCP.LE.NBCMP)
C
      CALL JEDEMA()
C
      END
