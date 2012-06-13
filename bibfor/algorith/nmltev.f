      SUBROUTINE NMLTEV(SDERRO,TYPEVT,NOMBCL,LEVENT)
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
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24 SDERRO
      CHARACTER*4  TYPEVT
      CHARACTER*4  NOMBCL
      LOGICAL      LEVENT
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (SD ERREUR)
C
C DIT SI UN EVENEMENT DE TYPE DONNE EST ACTIVE
C
C ----------------------------------------------------------------------
C
C
C IN  SDERRO : SD GESTION DES ERREURS
C IN  TYPEVT : TYPE EVENEMENT
C               'EVEN' - EVENEMENT SIMPLE
C               'ERRI' - EVENEMENT DE TYPE ERREUR IMMEDIATE
C               'ERRC' - EVENEMENT DE TYPE ERREUR A CONVERGENCE
C               'CONV' - EVENEMENT POUR DETERMINER LA CONVERGENCE
C IN  NOMBCL : NOM DE LA BOUCLE
C               'RESI' - RESIDUS D'EQUILIBRE
C               'NEWT' - BOUCLE DE NEWTON
C               'FIXE' - BOUCLE DE POINT FIXE
C               'INST' - BOUCLE SUR LES PAS DE TEMPS
C OUT LEVENT : .TRUE. SI AU MOINS UN EVENT EST ACTIVE
C
C
C
C
      INTEGER      IEVEN,ZEVEN
      CHARACTER*24 ERRINF
      INTEGER      JEINFO
      CHARACTER*24 ERRAAC,ERRENI
      INTEGER      JEEACT,JEENIV
      INTEGER      ICODE
      CHARACTER*9  TEVEN
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      LEVENT = .FALSE.
C
C --- ACCES SD
C
      ERRINF = SDERRO(1:19)//'.INFO'
      CALL JEVEUO(ERRINF,'L',JEINFO)
      ZEVEN  = ZI(JEINFO-1+1)
C
      ERRAAC = SDERRO(1:19)//'.EACT'
      ERRENI = SDERRO(1:19)//'.ENIV'
      CALL JEVEUO(ERRAAC,'L',JEEACT)
      CALL JEVEUO(ERRENI,'L',JEENIV)
C
C --- AU MOINS UN EVENEMENT DE CE NIVEAU D'ERREUR EST ACTIVE ?
C
      DO 15 IEVEN = 1,ZEVEN
       ICODE  = ZI(JEEACT-1+IEVEN)
       TEVEN  = ZK16(JEENIV-1+IEVEN)(1:9)
       IF (TEVEN(1:4).EQ.TYPEVT) THEN
         IF (TYPEVT.EQ.'EVEN') THEN
           IF (ICODE.EQ.1) LEVENT = .TRUE.
         ELSE
           IF (TEVEN(6:9).EQ.NOMBCL) THEN
             IF (ICODE.EQ.1) LEVENT = .TRUE.
           ENDIF
         ENDIF
       ENDIF
 15   CONTINUE
C
      CALL JEDEMA()
      END
