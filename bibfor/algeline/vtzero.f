      SUBROUTINE VTZERO(CHAMNA)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 14/03/2006   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C-----------------------------------------------------------------------
C    - FONCTION REALISEE:  INITIALISATION A ZERO DU .VALE DU CHAM_NO
C      CHAMN EN RESPECTANT L'ENCAPSULATION FETI.
C     ------------------------------------------------------------------
C     IN  CHAMNA  :  K* : CHAM_NO MAITRE
C----------------------------------------------------------------------
      IMPLICIT NONE

C DECLARATION PARAMETRES D'APPELS
      CHARACTER*(*) CHAMNA

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      
C DECLARATION VARIABLES LOCALES
      INTEGER      IDIME,NBSD,ILIMPI,IFETC,IDD,NEQ,IVAL,I,NEQ1,IRET
      CHARACTER*8  K8BID
      CHARACTER*24 KVAL,CHAMN
      LOGICAL      IDDOK,LFETI

C CORPS DU PROGRAMME
      CALL JEMARQ()
      CHAMN=CHAMNA

C --- TEST POUR SAVOIR SI LE SOLVEUR EST DE TYPE FETI
      CALL JEEXIN(CHAMN(1:19)//'.FETC',IRET)
      IF (IRET.NE.0) THEN
        LFETI=.TRUE.
      ELSE
        LFETI=.FALSE.
      ENDIF
      IF (LFETI) THEN
        CALL JELIRA(CHAMN(1:19)//'.FETC','LONMAX',NBSD,K8BID)
        CALL JEVEUO('&FETI.LISTE.SD.MPI','L',ILIMPI)
        CALL JEVEUO(CHAMN(1:19)//'.FETC','L',IFETC)
      ELSE
        NBSD=0
      ENDIF
            
C --- BOUCLE SUR LES SOUS-DOMAINES CF ASSMAM OU VTCMBL PAR EXEMPLE
      DO 20 IDD=0,NBSD
        IDDOK=.FALSE.
        IF (.NOT.LFETI) THEN
          IDDOK=.TRUE.
        ELSE 
          IF (ZI(ILIMPI+IDD).EQ.1) IDDOK=.TRUE.
        ENDIF
        IF (IDDOK) THEN
          IF (IDD.EQ.0) THEN
            KVAL=CHAMN(1:19)//'.VALE'
          ELSE
            KVAL=ZK24(IFETC+IDD-1)(1:19)//'.VALE'
          ENDIF
          CALL JEVEUO(KVAL,'E',IVAL)
          CALL JELIRA(KVAL,'LONMAX',NEQ,K8BID)
          NEQ1=NEQ-1
          DO 10 I=0,NEQ1
            ZR(IVAL+I)=0.D0
   10     CONTINUE
        ENDIF
   20 CONTINUE
   
      CALL JEDEMA()
      END
