      SUBROUTINE NBNOCP(LIGRMO,NOMTM ,NBNO  ,NUMAIL,INDQUA,
     &                  INPROJ,NOEUMI,NOEUSO,LVERIF,LQUADV)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 23/10/2007   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INTEGER      INDQUA,INPROJ,NUMAIL,NBNO
      INTEGER      NOEUMI,NOEUSO
      CHARACTER*8  NOMTM
      CHARACTER*19 LIGRMO
      LOGICAL      LVERIF,LQUADV 
C     
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES - LECTURE DONNEES)
C
C COMPTE NOMBRE NOEUDS SOMMETS/NOEUDS MILIEUX SUIVANT OPTION ET
C TYPE ELEMENT
C      
C ----------------------------------------------------------------------
C
C
C IN  LIGRMO : NOM DU LIGREL DU MODELE
C IN  NOMTM  : NOM DU TYPE DE MAILLE
C IN  NBNO   : NOMBRE NOEUDS TOTAL DE LA MAILLE
C IN  INDQUA : VAUT 0 LORSQUE L'ON DOIT PRENDRE LES NOEUDS MILIEUX
C              VAUT 1 LORSQUE L'ON DOIT IGNORER LES NOEUDS MILIEUX
C IN  INPROJ : VAUT 2 SI PROJECTION = QUADRATIQUE
C              VAUT 1 SI PROJECTION = LINEAIRE
C IN  LVERIF : VAUT .TRUE. SI METHODE = 'VERIF'
C OUT NOEUMI : NOMBRE DE NOEUDS MILIEUX DE LA MAILLE
C OUT NOEUSO : NOMBRE DE NOEUDS SOMMETS DE LA MAILLE
C OUT LQUADV : VAUT .TRUE. SI METHODE='VERIF' ET  NOMTM='QUAD8'OU'QUAD9'
C              DECLANCHE L'ALARME 'CONTACT3_94' DANS NBSUCO
C
C LES NOEUDS QUADRATIQUES (MILIEUX) SONT DISTINGUES DES AUTRES (ET
C DONC NOEUMI !=0) SI:
C  - QUAD8
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
      INTEGER NBNOMI,IRET
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C 
      CALL JEEXIN(LIGRMO(1:19)//'.LIEL',IRET)
      
      IF (INDQUA.EQ.1) THEN
        NOEUMI = 0
        NOEUSO = NBNO
        IF (  LVERIF .AND. 
     &        (NOMTM(1:5).EQ.'QUAD8'.OR.NOMTM(1:5).EQ.'QUAD9'))THEN
           LQUADV=.TRUE.
        ENDIF
      ELSE
        IF (NOMTM(1:5).EQ.'QUAD8') THEN
          NOEUMI = NBNOMI(NOMTM(1:5))
          NOEUSO = NBNO - NOEUMI
        ELSE
          NOEUMI = 0
          NOEUSO = NBNO
        END IF
      END IF
C
      CALL JEDEMA()
      END
