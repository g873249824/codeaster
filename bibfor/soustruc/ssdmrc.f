      SUBROUTINE SSDMRC(MAG)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SOUSTRUC  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
      IMPLICIT NONE
C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'
      CHARACTER*8 MAG
C ----------------------------------------------------------------------
C     BUT:
C        - INITILISER L' OBJET :  MAG.NOEUD_CONF    V V I DIM=NBNOE
C            POUR INO=1,NBNOE
C            SI (JNO= MAG.NOEUD_CONF(INO) .NE. INO) :
C               LE NOEUD INO A ETE  CONFONDU AVEC LE NOEUD JNO (<INO)
C               ATTENTION : LE NOEUD JNO PEUT ETRE LUI AUSSI CONFONDU
C                           AVEC UN AUTRE NOEUD KNO<JNO !!
C            SINON , LE NOEUD INO EST A CONSERVER.
C
C     IN:
C        MAG : NOM DU MAILLAGE QUE L'ON DEFINIT.
C
C ----------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER I ,IADIME ,IANCNF ,NNNOE 
C-----------------------------------------------------------------------
      CALL JEMARQ()
      CALL JEVEUO(MAG//'.DIME','L',IADIME)
      NNNOE=ZI(IADIME-1+1)
      CALL WKVECT(MAG//'.NOEUD_CONF','V V I',NNNOE,IANCNF)
      DO 1, I=1,NNNOE
        ZI(IANCNF-1+I)=I
 1    CONTINUE
      CALL JEDEMA()
      END
