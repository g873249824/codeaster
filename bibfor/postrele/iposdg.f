      INTEGER FUNCTION IPOSDG(DG,CMP)
      IMPLICIT NONE
C
      INTEGER DG(*),CMP
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 06/08/2012   AUTEUR LEFEBVRE J-P.LEFEBVRE 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C TOLE CRP_6
C
C***********************************************************************
C
C     REND LA POSITION D'1 CMP DANS UN DESCRIPTEUR-GRANDEUR DG
C
C       DG   (IN) : TABLE DES ENTIERS CODES
C
C       CMP  (IN) : NUMERO DE LA COMPOSANTE
C
C     EXEMPLE
C
C      POUR LE GRANDEUR DEPLA_R :
C
C         L' ENVELOPPE DU DESCRIPTEUR EST
C
C            DX DY DZ DRX DRY DRZ LAGR
C
C         SUPPOSONS QUE LA DESCRIPTION LOCALE SOIT : DX DZ DRY
C
C         ALORS IPOSDG(DG,NUM('DZ') ---> 2
C
C         LA COMPOSAMTE DZ APPARAIT EN POSITION 2 DANS LA DESCRIPTION
C
C***********************************************************************
C
      INTEGER PAQUET,VALEC,NBEC,RESTE,CODE,CMPT,I,LSHIFT
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      NBEC  = (CMP - 1)/30 + 1
      CMPT  = 0
      RESTE = CMP - 30*(NBEC-1)
      CODE  = LSHIFT(1,RESTE)
C
      IF ( IAND(DG(NBEC),CODE) .EQ. CODE ) THEN
C
         DO 10, PAQUET = 1, NBEC-1, 1
C
            VALEC = DG(PAQUET)
C
            DO 11, I = 1, 30, 1
C
               CODE = LSHIFT(1,I)
C
               IF ( IAND(VALEC,CODE) .EQ. CODE) THEN
C
                  CMPT = CMPT + 1
C
               ENDIF
C
11          CONTINUE
C
10       CONTINUE
C
         VALEC = DG(NBEC)
C
         DO 20, I = 1, RESTE, 1
C
            CODE = LSHIFT(1,I)
C
            IF ( IAND(VALEC,CODE) .EQ. CODE) THEN
C
               CMPT = CMPT + 1
C
            ENDIF
C
20       CONTINUE
C
      ENDIF
C
      IPOSDG = CMPT
C
      END
