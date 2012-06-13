      SUBROUTINE NMEXTJ(NOMCHA,NBCMP ,LISTCP,EXTRCP,NUM   ,
     &                  SNUM  ,NVALCP,NUMMAI,JCESD ,JCESV ,
     &                  JCESL ,JCESC ,VALRES)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT      NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24  NOMCHA
      INTEGER       NBCMP
      INTEGER       NVALCP
      REAL*8        VALRES(*)
      CHARACTER*24  LISTCP
      CHARACTER*8   EXTRCP
      INTEGER       NUM,SNUM
      INTEGER       NUMMAI
      INTEGER       JCESD,JCESV,JCESL,JCESC
C
C ----------------------------------------------------------------------
C
C ROUTINE *_NON_LINE (EXTRACTION - UTILITAIRE)
C
C EXTRAIRE LES VALEURS DES COMPOSANTES - ELEMENT
C
C ----------------------------------------------------------------------
C
C
C IN  EXTRCP : TYPE D'EXTRACTION SUR LES COMPOSANTES
C IN  NOMCHA : NOM DU CHAMP
C IN  NBCMP  : NOMBRE DE COMPOSANTES
C IN  LISTCP : LISTE DES COMPOSANTES
C IN  NUM    : NUMERO POINT DE GAUSS
C IN  SNUM   : NUMERO SOUS-POINT DE GAUSS
C IN  JCESD  : ADRESSE ACCES CHAM_ELEM_S.CESD
C IN  JCESV  : ADRESSE ACCES CHAM_ELEM_S.CESV
C IN  JCESL  : ADRESSE ACCES CHAM_ELEM_S.CESL
C IN  JCESC  : ADRESSE ACCES CHAM_ELEM_S.CESC
C OUT VALRES : VALEUR DES COMPOSANTES
C OUT NVALCP : NOMBRE EFFECTIF DE COMPOSANTES
C
C
C
C
      INTEGER      NPARX
      PARAMETER    (NPARX=20)
      CHARACTER*8  NOMCMP(NPARX)
      REAL*8       VALCMP(NPARX)           
      INTEGER      NEFF,NBCMPX
      INTEGER      ICMP,IPAR,IRET,IEFF,I
      INTEGER      JCMP,IAD
      CHARACTER*8  CMP,NOMVAR
      INTEGER      IVARI
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C      
      IEFF   = 1
      NBCMPX = ZI(JCESD+4)
      CALL ASSERT(NBCMP.LE.NPARX)  
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
        IF (NOMCHA(1:4).EQ.'VARI') THEN
          NOMVAR = CMP(2:8)//' '
          CALL LXLIIS(NOMVAR,IVARI ,IRET )
        ELSE 
          IVARI  = 0
        ENDIF
        IF (NOMCHA(1:4).EQ.'VARI') THEN
          ICMP = IVARI
        ELSE
          DO 40 I=1,NBCMPX
            IF (CMP.EQ.ZK8(JCESC-1+I)) ICMP=I
  40      CONTINUE
        ENDIF
        CALL CESEXI('C',JCESD,JCESL,NUMMAI,NUM,SNUM,ICMP,IAD)
        IF (IAD.GT.0) THEN
          VALCMP(IEFF) = ZR(JCESV+IAD-1)
          IEFF         = IEFF + 1
        ENDIF
  30  CONTINUE
      NEFF = IEFF - 1
C
C --- EVALUATION
C
      CALL NMEXTV(NEFF  ,EXTRCP,NOMCMP,VALCMP,NVALCP,
     &            VALRES)
C
      CALL ASSERT(NVALCP.LE.NBCMP)
C
      CALL JEDEMA()
C
      END
