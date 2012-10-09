      SUBROUTINE W039C3(CARELE,MODELE,IFI,FORM,TITRE)
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      INTEGER IFI
      CHARACTER*8  CARELE,MODELE
      CHARACTER*80 TITRE
      CHARACTER*(*) FORM

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 09/10/2012   AUTEUR DELMAS J.DELMAS 
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
C ----------------------------------------------------------------------
C     BUT:
C       IMPRIMER LES REPERES LOCAUX DES ELEMENTS
C ----------------------------------------------------------------------
C     IN MODELE  : MODELE
C     IN CARELE  : CARA_ELEM
C ----------------------------------------------------------------------
C     VARIABLES LOCALES
C
      INTEGER      IRET
      CHARACTER*1  NOMCMP(3)
      CHARACTER*8  TYPECH
      CHARACTER*19 CHREL1, CHREL2, CHREL3
      CHARACTER*64 NOMMED
      CHARACTER*80 TITRZ
      LOGICAL      L3D
      DATA  NOMCMP / 'X' , 'Y' , 'Z' /
C ----------------------------------------------------------------------
      CALL JEMARQ()

      CHREL1 = CARELE//'.REPLO_1'
      CHREL2 = CARELE//'.REPLO_2'
      CHREL3 = CARELE//'.REPLO_3'

      CALL CARELO(MODELE,CARELE,'V',CHREL1, CHREL2, CHREL3)

      CALL JEEXIN(CHREL3//'.CELD',IRET)
C     IL N'Y A QUE DEUX VECTEURS DANS LE CAS 2D
      IF (IRET.NE.0) THEN
        L3D = .TRUE.
      ELSE
        L3D = .FALSE.
      ENDIF
C     -- IMPRESSION DES CHAMPS DE VECTEURS :
C     -----------------------

      IF (FORM.EQ.'MED') THEN
C     -------------------------
        NOMMED=CHREL1
        TYPECH='ELEM'

        CALL IRCEME(IFI,NOMMED,CHREL1,TYPECH,MODELE,0,NOMCMP,' ',
     &        ' ',0,0.D0,0,0,0,IRET)
        CALL ASSERT(IRET.EQ.0)

        NOMMED=CHREL2
        CALL IRCEME(IFI,NOMMED,CHREL2,TYPECH,MODELE,0,NOMCMP,' ',
     &        ' ',0,0.D0,0,0,0,IRET)
        CALL ASSERT(IRET.EQ.0)

        NOMMED=CHREL3

        IF (L3D) THEN
          CALL IRCEME(IFI,NOMMED,CHREL3,TYPECH,MODELE,0,NOMCMP,' ',
     &          ' ',0,0.D0,0,0,0,IRET)
          CALL ASSERT(IRET.EQ.0)
        ENDIF

      ELSEIF (FORM.EQ.'RESULTAT') THEN
C     ---------------------------
        TITRZ ='1er '//TITRE
        CALL IMPRSD('CHAMP',CHREL1,IFI,TITRZ)
        TITRZ ='2eme '//TITRE
        CALL IMPRSD('CHAMP',CHREL2,IFI,TITRZ)
        IF (L3D) THEN
          TITRZ ='3eme '//TITRE
          CALL IMPRSD('CHAMP',CHREL3,IFI,TITRZ)
        ENDIF
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF

      CALL DETRSD('CHAM_ELEM',CHREL1)
      CALL DETRSD('CHAM_ELEM',CHREL2)
      IF (L3D) CALL DETRSD('CHAM_ELEM',CHREL3)

      CALL JEDEMA()
      END
