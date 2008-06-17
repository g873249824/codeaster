      SUBROUTINE SDMPIC(TYPESD,NOMSD)
      IMPLICIT NONE
      INTEGER IORDR
      CHARACTER*(*) NOMSD,TYPESD
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 18/03/2008   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE PELLET J.PELLET

C ----------------------------------------------------------------------
C  BUT : "COMPLETER" LE CALCUL D'UNE STRUCTURE DE DONNEES INCOMPLETEMENT
C        CALCULEE  DU FAIT DE L'UTILISATION DE CALCULS PARALLELES (MPI)
C
C  LA ROUTINE ECHANGE LES MORCEAUX CALCULES PARTIELLEMENT SUR LES
C  DIFFERENTS PROCESSEURS (MPI_ALL_REDUCE)
C
C ----------------------------------------------------------------------
C IN TYPESD (K*) :  TYPE DE LA SD A COMPLETER
C IN NOMSD  (K*) :  NOM DE LA SD A COMPLETER
C ----------------------------------------------------------------------
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR,JEXR8
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
      INTEGER CADIST
      COMMON /CAII18/CADIST
      CHARACTER*24 NOMS2, TYPES2
      CHARACTER*19 K19
      CHARACTER*8  KBID,KMPIC
      INTEGER JAD,NLONG,IFM,NIV,IBID,JCELK
C ----------------------------------------------------------------------

      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)

      NOMS2 = NOMSD
      TYPES2 = TYPESD
      CALL ASSERT(TYPES2.EQ.'CHAM_ELEM')


      IF (TYPES2.EQ.'CHAM_ELEM') THEN
C     ----------------------------------
        K19=NOMS2
        CALL DISMOI('F','MPI_COMPLET',K19,'CHAM_ELEM',IBID,
     &             KMPIC,IBID)
        IF (KMPIC.EQ.'OUI') GOTO 9999
        CALL ASSERT(CADIST.EQ.1)
        CALL JELIRA(K19//'.CELV','LONMAX',NLONG,KBID)
        CALL MUMMPI(5,IFM,NIV,K19//'.CELV',NLONG,IBID)
        CALL JEVEUO(K19//'.CELK','E',JCELK)
        ZK24(JCELK-1+7)='MPI_COMPLET'

      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF

9999  CONTINUE
      CALL JEDEMA()
      END
