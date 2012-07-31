      SUBROUTINE JERMXD ( RVAL , IRET )
      IMPLICIT NONE
      REAL*8              RVAL
      INTEGER                    IRET
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 30/07/2012   AUTEUR LEFEBVRE J-P.LEFEBVRE 
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
C TOLE CRS_512
C RESPONSABLE LEFEBVRE J-P.LEFEBVRE
C ----------------------------------------------------------------------
C REDUIT LA VALEUR LIMITE MAXIMUM DE LA MEMOIRE ALLOUEE DYNAMIQUEMENT 
C PAR JEVEUX
C
C IN   RVAL : NOUVELLE LIMITE EN OCTETS      
C
C OUT  IRET : CODE RETOUR 
C             = 0   LA NOUVELLE VALEUR EST PRISE EN COMPTE
C             =/= 0 IL N'A PAS ETE POSSIBLE D'AFFECTER LA
C                   NOUVELLE VALEUR ET ON RENVOIE LA VALEUR DE LA  
C                   MEMOIRE OCCUPEE PAR JEVEUX                    
C
C DEB ------------------------------------------------------------------
      REAL *8         MXDYN, MCDYN, MLDYN, VMXDYN, VMET, LGIO
      COMMON /R8DYJE/ MXDYN, MCDYN, MLDYN, VMXDYN, VMET, LGIO(2)
C ----------------------------------------------------------------------
      REAL*8  RV(2)
      IF ( RVAL .LE. 0 ) THEN
        RV(1)=MCDYN/(1024*1024)
        RV(2)=RVAL/(1024*1024)
        CALL U2MESG ( 'F' ,'JEVEUX1_72',0,' ',0,0,2,RV )
      ENDIF
C ON EVALUE LA VALEUR PASSEE EN ARGUMENT PAR RAPPORT A L'OCCUPATION
C TOTALE COURANTE JEVEUX (OBJETS UTILISÉS)
C
      IF ( MCDYN .LT. RVAL ) THEN
        VMXDYN = RVAL
        IRET = 0
      ELSE
        IRET = MAX(1, INT(MCDYN)) 
      ENDIF     
C FIN ------------------------------------------------------------------
      END
