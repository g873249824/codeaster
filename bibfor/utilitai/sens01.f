      SUBROUTINE SENS01 ( INPSCO,
     &                    NEQ, MASSE,
     &                    CHOIX, CHAMP1, CHAMP2 )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 15/05/2007   AUTEUR GNICOLAS G.NICOLAS 
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
C ----------------------------------------------------------------------
C
C       SENSIBILITE - UTILITAIRE 01
C       ---                      --
C       SAUVEGARDE DE LA SOLUTION NOMINALE DANS DES TABLEAUX
C       SPECICIFIQUES POUR LES FUTURS CALCULS DE SENSIBILITE
C       CAS DES CHAMPS REELS
C
C ----------------------------------------------------------------------
C  IN  : INPSCO    : STRUCTURE CONTENANT LA LISTE DES NOMS
C  IN  : NEQ       : NOMBRE D'EQUATIONS
C  IN  : MASSE     : MATRICE DE MASSE
C  IN  : CHOIX     : CHOIX DES CHAMPS A SAUVEGARDER
C                    2X : LE PREMIER CHAMP
C                    3X : LE SECOND CHAMP
C  IN  : CHAMP1    : PREMIER CHAMP A SAUVEGARDER
C  IN  : CHAMP2    : SECOND CHAMP A SAUVEGARDER
C ----------------------------------------------------------------------
C
C CORPS DU PROGRAMME
      IMPLICIT NONE
C DECLARATION PARAMETRES D'APPELS
C
      INTEGER NEQ, CHOIX
C
      REAL*8 CHAMP1(NEQ), CHAMP2(NEQ)
C
      CHARACTER*8 MASSE
      CHARACTER*13 INPSCO

C    ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNUM,JEXNOM
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
C DECLARATION VARIABLES LOCALES
C
      INTEGER IAUX, JAUX
C
      CHARACTER*1 TYPSOL
      CHARACTER*24 VAPRIN, VACOMP

C     -----------------------------------------------------------------
C
      TYPSOL = 'R'
C
C====
C 1. CHOIX EST MULTIPLE DE 2 : SAUVEGARDE DU PREMIER CHAMP
C====
C
      IF ( MOD(CHOIX,2).EQ.0 ) THEN
C
        IAUX = 0
        JAUX = 4
        CALL PSNSLE ( INPSCO, IAUX, JAUX, VAPRIN )
C
        CALL JEEXIN(VAPRIN(1:19)//'.REFE',IAUX)
        IF ( IAUX.EQ.0 ) THEN
          CALL VTCREM ( VAPRIN(1:19),MASSE,'V',TYPSOL)
        ENDIF
        CALL JEVEUO(VAPRIN(1:19)//'.VALE','E',IAUX)
        DO 11 , JAUX = 1, NEQ
          ZR(IAUX-1+JAUX) = CHAMP1(JAUX)
   11   CONTINUE
C
      ENDIF
C
C====
C 2. CHOIX EST MULTIPLE DE 3 : SAUVEGARDE DU SECOND CHAMP
C====
C
      IF ( MOD(CHOIX,3).EQ.0 ) THEN
C
        IAUX = 0
        JAUX = 16
        CALL PSNSLE ( INPSCO, IAUX, JAUX, VACOMP )
C
        CALL JEEXIN(VACOMP(1:19)//'.REFE',IAUX)
        IF ( IAUX.EQ.0 ) THEN
          CALL VTCREM ( VACOMP(1:19),MASSE,'V',TYPSOL)
        ENDIF
        CALL JEVEUO(VACOMP(1:19)//'.VALE','E',IAUX)
        DO 21 , JAUX = 1, NEQ
          ZR(IAUX-1+JAUX) = CHAMP2(JAUX)
   21   CONTINUE
C
      ENDIF
C
      END
