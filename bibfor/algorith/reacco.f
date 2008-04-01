      SUBROUTINE REACCO(PREMIE,DEFICO,RESOCO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 01/04/2008   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      LOGICAL      PREMIE
      CHARACTER*24 DEFICO
      CHARACTER*24 RESOCO      
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT)
C
C PARAMETRES DE REACTUALISATION
C
C ----------------------------------------------------------------------
C
C
C IN  PREMIE : VAUT .TRUE. SI C'EST LE PREMIER CALCUL (PAS DE PASSE)
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      CFMMVD,ZREAC,CFDISI,IZONE,NZOCO
      CHARACTER*24 APREAC
      INTEGER      JREAC 
      INTEGER      IAPPA,IPROJ,IREAC
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      APREAC = RESOCO(1:14)//'.APREAC'
      CALL JEVEUO(APREAC,'E',JREAC)
      ZREAC  = CFMMVD('ZREAC')
      IZONE  = 0
      NZOCO  = CFDISI(DEFICO,'NZOCO',IZONE)  
C    
      DO 10 IZONE = 1,NZOCO
        IAPPA = CFDISI(DEFICO,'APPARIEMENT',IZONE)
        IPROJ = CFDISI(DEFICO,'PROJECTION' ,IZONE)
        IREAC = CFDISI(DEFICO,'REAC_GEOM'  ,IZONE)
        IF (PREMIE) THEN
          ZI(JREAC+ZREAC*(IZONE-1)+0) = 1
        ELSE
          ZI(JREAC+ZREAC*(IZONE-1)+0) = 1
          IF (IAPPA.EQ.0) THEN 
            ZI(JREAC+ZREAC*(IZONE-1)+0) = 
     &                           ABS(ZI(JREAC+ZREAC*(IZONE-1)+0))
          ENDIF
        END IF
C
        ZI(JREAC+ZREAC*(IZONE-1)+2) = IPROJ
C
        IF ((IREAC.EQ.0).AND.(IPROJ.GT.0)) THEN 
          ZI(JREAC+ZREAC*(IZONE-1)+2) = -ZI(JREAC+ZREAC*(IZONE-1)+2)
        ENDIF
 10   CONTINUE

C
      CALL JEDEMA()
      END
