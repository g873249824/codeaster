      SUBROUTINE COCHRE (KCHAR,NBCHAR,NBCHRE,IOCC)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER                   NBCHAR,NBCHRE,IOCC
      CHARACTER*(*)     KCHAR(*)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 28/11/2000   AUTEUR JMBHH01 J.M.PROIX 
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
C     ROUTINE QUI VERIFIE SUR UNE LISTE DE CHARGE LA PRESENCE D'UNE 
C     SEULE CHARGE REPARTIE ET FOURNIT LE NUMERO D'OCCURENCE QUI
C     CORRESPOND A CETTE CHARGE 
C      
C     IN  : KCHAR   : LISTE DES CHARGES ET DES INFOS SUR LES CHARGES
C     IN  : NBCHAR   : NOMBRE DE CHARGE
C     OUT : NBCHRE   : NOMBRE DE CHARGES REPARTIES
C     OUT : IOCC     : NUMERO D'OCCURENCE DU MOT-CLE FACTEUR EXCIT  
C                      CORRESPONDANT A LA CHARGE REPARTIE
C ----------------------------------------------------------------------
C   
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16               ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                 ZK32
      CHARACTER*80                                          ZK80
      COMMON  / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32      JEXNOM, JEXNUM, JEXATR, JEXR8
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*8  K8B
      CHARACTER*19 CHRREP, CHPESA
C DEB-------------------------------------------------------------------
      CALL JEMARQ()
      NBCHRE = 0
      IOCC   = 0
C
      DO 10 I = 1 , NBCHAR
        CHRREP = KCHAR(I)(1:8)//'.CHME.F1D1D'
        CHPESA = KCHAR(I)(1:8)//'.CHME.PESAN'
C
        CALL JEEXIN(CHRREP//'.DESC',IRET1)
        CALL JEEXIN(CHPESA//'.DESC',IRET2)
C
        IF ( IRET1 .NE. 0 ) THEN
           NBCHRE = NBCHRE + 1
           IOCC   = I
        ELSEIF ( IRET2 .NE. 0 ) THEN
          NBCHRE = NBCHRE + 1
          IOCC   = I  
        ENDIF 
 10   CONTINUE
C
      CALL JEDEMA()
      END
