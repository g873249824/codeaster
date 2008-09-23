      SUBROUTINE MGINFO(MODMEC,NUMDDL,NBMODE,NEQ   )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/09/2008   AUTEUR ABBAS M.ABBAS 
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
C
      IMPLICIT     NONE
      CHARACTER*8  MODMEC
      INTEGER      NBMODE,NEQ
      CHARACTER*14 NUMDDL
      
C
C ----------------------------------------------------------------------
C
C UTILITAIRE
C
C INFORMATIONS SUR MATRICE MODES MECANIQUES
C
C ----------------------------------------------------------------------
C
C
C IN  MODMEC : NOM DE LA MATRICE DES MODES MECANIQUES
C OUT NUMDDL : NOM DU DDL
C OUT NBMODE : NOMBRE DE MODES
C OUT NEQ    : NOMBRE D'EQUATIONS
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
      INTEGER      IADRIF,IRET,IBID
      CHARACTER*8  K8BID
      CHARACTER*24 MATRIC
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INFORMATIONS SUR MATRICE DES MODES MECANIQUES
C
      CALL JEVEUO(MODMEC//'           .REFD','L',IADRIF)
      MATRIC =  ZK24(IADRIF)(1:8)
      IF (MATRIC(1:1).EQ.' ') THEN
        NUMDDL =  ZK24(IADRIF+3)(1:14)
        CALL DISMOI('F','NB_EQUA'     ,NUMDDL,'NUME_DDL',NEQ   ,
     &              K8BID ,IRET)        
      ELSE
        CALL DISMOI('F','NOM_NUME_DDL',MATRIC,'MATR_ASSE',IBID  ,
     &              NUMDDL,IRET)
        CALL DISMOI('F','NB_EQUA'     ,MATRIC,'MATR_ASSE',NEQ   ,
     &              K8BID ,IRET)     
      ENDIF
C
C --- NOMBRE DE MODES
C
      CALL JELIRA(MODMEC//'           .ORDR','LONMAX',NBMODE,K8BID)

      CALL JEDEMA()
      END
