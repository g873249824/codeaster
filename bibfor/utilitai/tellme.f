      SUBROUTINE TELLME ( CODMES, QUESTI, CHAR01, CHAR02, CHAR03,
     >                    REPI, REPKZ, CODRET )
C
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 25/09/2001   AUTEUR GNICOLAS G.NICOLAS 
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
C ----------------------------------------------------------------------
C     RECHERCHE D'INFORMATIONS DIVERSES (OUAHHH !)
C     ------------------------------------------------------------------
C     IN:
C       CODMES : CODE DES MESSAGES A EMETTRE : 'F', 'A', ...
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       CHAR01 : CHAINE NUMERO 1
C       CHAR02 : CHAINE NUMERO 2
C       CHAR03 : CHAINE NUMERO 3
C     OUT:
C       REPI   : REPONSE ( SI ENTIERE )
C       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
C       CODRET   : CODE RETOUR (0--> OK, 1 --> PB)
C
C ----------------------------------------------------------------------
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER REPI, CODRET
      CHARACTER*(*) CHAR01, CHAR02, CHAR03
      CHARACTER*(*) QUESTI, CODMES, REPKZ
C
C 0.2. ==> COMMUNS
C
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR,JEXR8
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C --------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'TELLME' )
C
      INTEGER JVALE, IBID, IAUX, LONG
C
      CHARACTER*19 NOMFON, NOMCAR
      CHARACTER*24 REPK, K24BID
      CHARACTER*8  K8B, TYPE
C
C     ------------------------------------------------------------------
C====
C 1. EXPLORATION
C====
C
      CALL JEMARQ()
C
      CODRET = 0
      REPK = '??????'
C
C 1.1. ==> LA FONCTION DE NOM 'NOMFON' EST-ELLE DANS LA CARTE ?
C
      IF ( QUESTI.EQ.'NOM_FONCTION' ) THEN
         NOMCAR = CHAR01
         NOMFON = CHAR02
         CALL JEVEUO ( NOMCAR//'.VALE', 'L', JVALE )
         CALL JELIRA ( NOMCAR//'.VALE', 'TYPE', IBID, TYPE )
         IF (TYPE(1:1).EQ.'K') THEN
           CALL JELIRA(NOMCAR//'.VALE','LONMAX',LONG,K8B)
           DO 11 , IAUX = 1 , LONG
             K24BID = ZK8(JVALE+IAUX-1)
             IF ( K24BID(1:8) .EQ. NOMFON ) THEN
               REPK = 'OUI'
               GOTO 111
             ENDIF
   11      CONTINUE
           REPK = 'NON'
  111      CONTINUE
         ELSE
           CODRET = 1
           CALL UTMESS ( CODMES, NOMPRO,
     >           'LE TABLEAU'//NOMCAR//'.VALE" EST DE TYPE '//TYPE)
         ENDIF
C
C 1.N. ==> QUESTION INCONNUE
C
      ELSE
        CODRET = 1
        K24BID = QUESTI
        CALL UTMESS ( CODMES, NOMPRO,
     >                'LA QUESTION : "'//K24BID//'" EST INCONNUE')
      ENDIF
C
      REPKZ = REPK
      CALL JEDEMA()
C
      END
