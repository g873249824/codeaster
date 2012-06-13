      SUBROUTINE OP0105()
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SOUSTRUC  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C
C     OPERATEUR: ASSE_MAILLAGE
C
C-----------------------------------------------------------------------
C
      INCLUDE 'jeveux.h'
      CHARACTER*8   MAG, DM(2)
      CHARACTER*16 KBI1,KBI2
      CHARACTER*8  OPER
      INTEGER      N1, IADIM1, IADIM2, IBID
      INTEGER      IARG
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFMAJ()
C
      CALL GETVTX(' ','OPERATION',1,IARG,1,OPER,N1)
C
      CALL GETRES( MAG, KBI1, KBI2 )
      CALL GETVID(' ','MAILLAGE_1',1,IARG,1,DM(1),N1)
      CALL GETVID(' ','MAILLAGE_2',1,IARG,1,DM(2),N1)
C
C     --OBJET .TITR:
C     ---------------
      CALL WKVECT(MAG//'           .TITR','G V K80',2,IBID)
      ZK80(IBID)=' MAILLAGE OBTENU PAR CONCATENATION DES MAILLAGES : '
      ZK80(IBID+1)='  '//DM(1)//' ET '//DM(2)
C
C
C     -- TRAITEMENT DU TYPE D OPERATION :
C     -----------------------------------
      IF (OPER(1:8).EQ.'SOUS_STR') THEN
            CALL ASMAEL(DM(1),DM(2),MAG)
      ELSE
C
            CALL JEVEUO(DM(1)//'.DIME','L',IADIM1)
            CALL JEVEUO(DM(2)//'.DIME','L',IADIM2)
            IF ((ZI(IADIM1-1+4).NE.0).OR.(ZI(IADIM2-1+4).NE.0)) THEN
               CALL U2MESS('F','SOUSTRUC_16')
            ENDIF
            IF     (OPER(1:7).EQ.'COLLAGE') THEN
                CALL ASMACO(DM(1),DM(2),MAG)
            ELSEIF (OPER(1:7).EQ.'SUPERPO') THEN
                CALL ASMASU(DM(1),DM(2),MAG)
            ENDIF
      ENDIF
C
C
C     --ON CALCULE LES CARACTERISTIQUES DU MAILLAGE:
C     ----------------------------------------------
C
      CALL CARGEO(MAG)
C
      CALL JEDEMA()
      END
