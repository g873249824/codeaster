      SUBROUTINE OP0026 ( IER )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 10/10/2003   AUTEUR D6BHHJP J.P.LEFEBVRE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE D6BHHJP J.P.LEFEBVRE
      IMPLICIT REAL*8 (A-H,O-Z)
C
C    PROCEDURE DEFI_FICHIER
C
      INTEGER         IER
C
      CHARACTER*1     KACC,KTYP
      CHARACTER*8     K8B,KACT
      CHARACTER*16    KNOM
      CHARACTER*255   KFIC
      INTEGER         PRUNIT
      INTEGER         IOCC,IUN,NBNOM,NBFIC,NBOCC,NBUNIT,NBACCE,NBTYPE
C
      CALL INFMAJ()
C
      IUN = 1
      KNOM = ' '
      KFIC = ' '
      CALL GETVTX(' ','ACTION'     ,0,IUN,IUN,KACT,NBACCE)
      CALL GETVTX(' ','FICHIER'    ,0,IUN,IUN,KNOM,NBNOM)
      CALL GETVTX(' ','NOM_SYSTEME',0,IUN,IUN,KFIC,NBFIC)
      CALL GETVIS(' ','UNITE',      0,IUN,IUN,PRUNIT,NBUNIT)
      IF ( KACT .EQ. 'LIBERER' ) THEN
        PRUNIT = -PRUNIT
      ENDIF 
      CALL GETVTX(' ','ACCES'  ,0,IUN,IUN,K8B,NBACCE)
      KACC = K8B(1:1)
      CALL GETVTX(' ','TYPE'   ,0,IUN,IUN,K8B,NBTYPE)
      KTYP = K8B(1:1)
      CALL LXCADR(KNOM)
      IF ( KTYP .EQ. 'A' ) THEN
        CALL ULOPEN(PRUNIT,KFIC,KNOM,KACC,'O')
      ELSE  
        CALL ULDEFI(PRUNIT,KNOM,KTYP,KACC,'O') 
      ENDIF    
C      
      CALL INFNIV(IFM,NIV)
      IF (NIV.GT.1) CALL ULIMPR(IFM)

      END
