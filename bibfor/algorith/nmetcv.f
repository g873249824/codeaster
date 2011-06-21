      SUBROUTINE NMETCV(NOMCHS,CHREFE,LOCHIN,LOCOUT,CHAIN ,
     &                  CHAOUT)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/06/2011   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT     NONE
      CHARACTER*24 CHAIN,CHAOUT
      CHARACTER*24 NOMCHS,CHREFE
      CHARACTER*24 LOCHIN,LOCOUT
C
C ----------------------------------------------------------------------
C
C ROUTINE GESTION IN ET OUT
C
C CONVERSION D'UN CHAMP
C
C ----------------------------------------------------------------------
C
C
C IN  NOMCHS : NOM DU CHAMP DANS SD RESULTAT
C IN  CHREFE : CHAM_ELEM DE REFERENCE - 
C              SERT A LA CONVERSION CART -> ELGA
C IN  CHAIN  : CHAMP D'ENTREE A CONVERTIR
C IN  LOCHIN : TYPE DE LOCALISATION DU CHAMP
C IN  LOCOUT : TYPE DE LOCALISATION DU CHAMP DE SORTIE DEMANDE
C OUT CHAOUT : CHAMP DE SORTIE CONVERTI
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ---------------------------
C
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
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX -----------------------------
C
      INTEGER      IRET,IBID
      CHARACTER*24 VALK(3)
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()  
C
C --- LOCALISATION DU CHAMP EN ENTREE
C
      CALL DISMOI('C','TYPE_CHAMP',CHAIN,'CHAMP',IBID,LOCHIN,IRET)
      IF (IRET.EQ.1) THEN
        CALL U2MESK('F','ETATINIT_50',1,NOMCHS)
      ENDIF
C
C --- PAS DE CONVERSION SI BONS TYPES
C
      IF (LOCHIN.EQ.LOCOUT) THEN
        CALL COPISD('CHAMP_GD','V',CHAIN,CHAOUT)
        GOTO 99
      ENDIF
C
C --- CONVERSION POSSIBLE ?
C
      VALK(1) = CHAIN
      VALK(2) = LOCHIN
      VALK(3) = LOCOUT
      IF (LOCOUT.EQ.'ELGA') THEN
        IF (CHREFE.EQ.' ') THEN
          CALL U2MESK('F','ETATINIT_52',3,VALK)
        ELSE
          CALL U2MESK('I','ETATINIT_51',3,VALK)
        ENDIF
      ELSE
        CALL U2MESK('F','ETATINIT_52',3,VALK)
      ENDIF
C
C --- TRANSFORMER LE CHAM_ELEM EN CHAM_ELGA
C
      CALL CHPCHD(CHAIN ,LOCOUT,CHREFE,'NON','V',CHAOUT)
C      
   99 CONTINUE 
C
      CALL JEDEMA()
      END
