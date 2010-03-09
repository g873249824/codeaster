      SUBROUTINE DIBCLE(SDDISC,NOMBCZ,ACTION,VALI  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/03/2010   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*(*) NOMBCZ
      CHARACTER*1   ACTION
      CHARACTER*19  SDDISC
      INTEGER       VALI
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (UTILITAIRE - DISCRETISATION)
C
C ACCES AU NIVEAU DE BOUCLE
C
C ----------------------------------------------------------------------
C
C
C IN  SDDISC : SD DISCRETISATION
C IN  NOMBCL : NOM DE LA BOUCLE
C               'ITERAT' - NEWTON
C               'NUMINS' - PAS DE TEMPS
C               'NIVEAU' - BOUCLE CONTACT (ENTRE NEWTON ET PAS DE TEMPS)
C               'PREMIE' - RETOURNE ZERO SI VRAI PREMIER INSTANT
C                          UN SINON
C                          "VRAI" CAR EN CAS DE REDECOUPAGE AU 
C                          PREMIER INSTANT,
C                          PREMIE DEVIENT UN                   
C IN  ACTION : TYPE d'ACTION
C                'L'     - LECTURE (RETOURNE DANS DIBCLE)
C                'E'     - ECRITURE D'UNE VALEUR           
C IN  VALI   : VALEUR 
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      CHARACTER*24 TPSBCL
      INTEGER      JBCLE
      CHARACTER*8  NOMBCL
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- ACCES SD LISTE D'INSTANTS
C 
      TPSBCL = SDDISC(1:19)//'.BCLE'  
      CALL JEVEUO(TPSBCL,'E',JBCLE)  
      NOMBCL = NOMBCZ 
C
C --- SEUL PREMIER EST BRANCHE POUR L'INSTANT
C
      IF (NOMBCL.EQ.'PREMIE') THEN
        IF (ACTION.EQ.'L') THEN
          VALI   = ZI(JBCLE+4-1)
        ELSEIF (ACTION.EQ.'E') THEN
          IF ((VALI.LT.0).OR.(VALI.GT.1)) THEN
            CALL ASSERT(.FALSE.)
          ELSE
            ZI(JBCLE+4-1) = VALI
          ENDIF
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF      
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C      
      CALL JEDEMA()
      END
