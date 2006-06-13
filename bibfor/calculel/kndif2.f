      SUBROUTINE KNDIF2 ( LONG, LK1,L1, LK2,L2, LK3,L3 )
      IMPLICIT NONE
      INTEGER             LONG, L1 ,L2, L3
      CHARACTER*(*)       LK1(L1), LK2(L2), LK3(L3)
C ---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 10/04/2006   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
C RESPONSABLE REZETTE C.REZETTE
C
C BUT: DIFFERENCE ENTRE 2 LISTES   LK3 = LK1 - LK2
C      CET UTILITAIRE EST A UTILISER LORSQUE LES LISTES LK1 ET LK2
C      SONT LONGUES : ON UTILISE DES POINTEURS DE NOMS JEVEUX
C ---------------------------------------------------------------------
C     ARGUMENTS:
C LONG   IN   I     : 8,16 OU 24 : LONGUEUR DES CHAINES DE LK1 ET LK2
C LK1    IN   V(K*) : LISTE DE K*
C L1     IN   I     : LONGUEUR DE LA LISTE LK1
C LK2    IN   V(K*) : LISTE DES K*
C L2     IN   I     : LONGUEUR DE LA LISTE LK2
C LK3    OUT  V(K*) : LISTE DES K* QUI DOIT CONTENIR LK1 - LK2
C L3     IN   I     : DIMENSION DU TABLEAU LK3
C L3     OUT  I     : LONGUEUR DE LA LISTE LK3
C----------------------------------------------------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNOM
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C----------------------------------------------------------------------
      CHARACTER*24  PN2 , KBID
      INTEGER K1,K2,NBK3

      IF ((LONG.NE.8) .AND. (LONG.NE.16) .AND.
     &    (LONG.NE.24)) CALL UTMESS('F','KNDIFF','LONG=8,16 OU 24')

      NBK3=L3
      L3 = 0
      IF (L1.EQ.0) GO TO 9999

      IF (L2.EQ.0) THEN
         L3=L1
         DO 20, K1 = 1 , L1
           LK3(K1)=LK1(K1)
 20      CONTINUE
         GO TO 9999
      ENDIF


C     -- ON RECOPIE LK2 DANS UN POINTEUR DE NOMS : PN2
C     -------------------------------------------------
      PN2='KNDIF2.PN2'
      CALL JECREO(PN2,'V N K24')
      CALL JEECRA(PN2,'NOMMAX',L2,KBID)
      DO 1, K2=1,L2
         CALL JECROC(JEXNOM(PN2,LK2(K2)))
  1   CONTINUE


C     -- ON BOUCLE SUR LES ELEMENTS DE LK1 :
C     ---------------------------------------
      DO 2, K1=1,L1
          CALL JENONU(JEXNOM(PN2,LK1(K1)),K2)
          IF (K2.EQ.0) THEN
             L3 = L3 + 1
             IF (L3.GT.NBK3) CALL UTMESS('F','KNDIF2','ERREUR PGMEUR'//
     &              ': LK3 PAS ASSEZ GRAND.')
             LK3(L3) = LK1(K1)
          ENDIF
  2   CONTINUE


C     -- MENAGE :
C     ------------
      CALL JEDETR(PN2)


9999  CONTINUE
      END
