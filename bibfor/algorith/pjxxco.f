      SUBROUTINE PJXXCO(METHOD,LCORRE,
     &                  ISOLE,RESUIN,CHAM1,
     &                  MOA1,MOA2,
     &                  NOMA1,NOMA2,CNREF)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/04/2010   AUTEUR BERARD A.BERARD 
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
C
C RESPONSABLE BERARD A.BERARD
C
C
C COMMANDE:  PROJ_CHAMP
C BUT : ROUTINE "CHAPEAU" CONCERNANT LA SD LCORRESP_2_MAILLA
C
C  SI METHOD='NUAGE_DEG' 
C    ON NE FAIT QUE PASSER ET ON APPELLE PJNGCO 
C    VIA LE 1ER ARGUMENT DE LA SD LCORRESP_2_MAILLA
C
C  SI METHOD='ELEM' 
C    ON REGARDE QUELS SONT LES TYPES DE CHAMPS A PROJETER ET
C    ON APPELLE PJEFCO VIA LE 1ER ARGUMENT DE LA SD LCORRESP_2_MAILLA
C         ET/OU PJELCO VIA LE 2ND ARGUMENT DE LA SD LCORRESP_2_MAILLA
C              (POUR LE MOMENT, PJELCO N'EST PAS BRANCHE)
C
C
      IMPLICIT   NONE
C
C 0.1. ==> ARGUMENTS
C

      LOGICAL ISOLE

      CHARACTER*8 RESUIN
      CHARACTER*8 MOA1,MOA2
      CHARACTER*8 NOMA1,NOMA2,CNREF

      CHARACTER*16 LCORRE(2)
      CHARACTER*19 CHAM1,METHOD


C
C 0.2. ==> COMMUNS
C ----------------------------------------------------------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR,R8B
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
C
      LOGICAL LNOEU,LELNO,LELEM,LELGA
C




C DEB ------------------------------------------------------------------
      CALL JEMARQ()





C 1. CAS DE LA METHODE NUAGE_DEG
C ------------------------------

      IF (METHOD(1:10).EQ.'NUAGE_DEG_') THEN
        CALL PJNGCO(LCORRE(1),NOMA1,NOMA2,METHOD,CNREF,'V')


C 2. CAS DE LA METHODE ELEM
C ------------------------------

      ELSEIF (METHOD.EQ.'ELEM') THEN

        CALL PJTYCO(ISOLE,RESUIN,CHAM1,
     &              LNOEU,LELNO,LELEM,LELGA)


        IF ((LNOEU) .OR. (LELNO) .OR. (LELEM)) THEN
          CALL PJEFCO(MOA1,MOA2,LCORRE(1),'V')
        ENDIF

C POUR LE MOMENT, RIEN N'EST FAIT POUR LE TRANSFERT ENTRE ELGA
C S'IL N'Y A QUE DES ELGA, ON NE MET PAS DE MESSAGE D'ERREUR ICI
C ON S'ARRETERA EN <F> PLUS TARD

C        IF (LELGA) THEN
C          CALL PJELCO(MOA1,MOA2,LCORRE(2),'V')
C        ENDIF


C 3. IL N'Y A QUE CES DEUX METHODES ACTUELLEMENT
C ----------------------------------------------

      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF





      CALL JEDEMA()
      END
