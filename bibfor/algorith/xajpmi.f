      SUBROUTINE XAJPMI(JLIST,LONG,IPT,CPT,NEWPT,LONGAR)
      IMPLICIT NONE

      INTEGER       JLIST,LONG,IPT,CPT
      REAL*8        NEWPT(3),LONGAR

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/06/2010   AUTEUR CARON A.CARON 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C         AJOUTER UN POINT MILIEU DANS UNE LISTE
C              ET INFORMATIONS COMPLÉMENTAIRES SUR LES ARETES
C
C     ENTREE
C       JLIST   : ADRESSE DE LA LISTE
C       LONG    : LONGUEUR MAX DE LA LISTE
C       IPT     : LONGUEUR DE LA LISTE AVANT AJOUT
C       CPT     : COMPTEUR SPÉCIFIQUE
C       NEWPT   : COORDONNES DU POINT A AJOUTER
C       LONGAR  : LONGUEUR DE L'ARETE
C     SORTIE
C       JLIST
C     ----------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  ------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  ------------------------
C
      CHARACTER*8     NOMA,KBID
      REAL*8          PADIST,P(3)
      INTEGER         I,J,NDIM,IBID,IADZI,IAZK24,IRET
      LOGICAL         DEJA
C
C --------------------------------------------------------------------

      CALL JEMARQ()

      CALL TECAEL(IADZI,IAZK24)
      NOMA=ZK24(IAZK24)
      CALL DISMOI('F','DIM_GEOM',NOMA,'MAILLAGE',NDIM,KBID,IRET)

C     VERIFICATION SI CE POINT EST DEJA DANS LA LISTE
      DEJA = .FALSE.

      DO 100 I = 1,IPT
        DO 99 J = 1, NDIM
         P(J) = ZR(JLIST-1+NDIM*(I-1)+J)
 99     CONTINUE
        IF (PADIST(NDIM,P,NEWPT) .LT. (LONGAR*1.D-6)) DEJA = .TRUE.
 100  CONTINUE

      IF (.NOT. DEJA) THEN
C       CE POINT N'A PAS DEJA ETE TROUVE, ON LE GARDE
        IPT = IPT + 1
        CPT = CPT + 1
C       TROP DE POINTS DANS LA LISTE
        CALL ASSERT(IPT .LE. LONG)
        DO 101 J = 1, NDIM
         ZR(JLIST-1+NDIM*(IPT-1)+J) = NEWPT(J)
 101    CONTINUE
      ENDIF

      CALL JEDEMA()
      END
