      SUBROUTINE PRNCHK(NBSN,ADRESS,GLOBAL,FILS,FRERE,
     &     LGSN,LFRONT,INVSUP,SEQ)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 19/05/2008   AUTEUR PELLET J.PELLET 
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
      INTEGER ADRESS(*),GLOBAL(*),FILS(*),FRERE(*),LGSN(*),LFRONT(*)
      INTEGER INVSUP(*),SEQ(*),NBSN
      INTEGER SNI,SN,SN0,VOIS,N,M,P,VALI(2),I
      LOGICAL TROUV
      DO 1 I=1,NBSN
         SNI=SEQ(I)
         M = LFRONT(SNI)

         IF(M.GT.0) THEN
            VOIS=GLOBAL(ADRESS(SNI)+LGSN(SNI))
            SN0=INVSUP(VOIS)
            TROUV=.FALSE.
            SN = FILS(SN0)

 2          CONTINUE
            IF (SN.NE.0) THEN
               IF(SN.EQ.SNI) TROUV=.TRUE.
               SN=FRERE(SN)
               GOTO 2
            ENDIF

            IF(.NOT.TROUV) THEN
               VALI(1)=SNI
               VALI(2)=SN0
               CALL U2MESG('A','ALGELINE5_59',0,' ',2,VALI,0,0.D0)
            ENDIF
         ENDIF
 1    CONTINUE
      END
