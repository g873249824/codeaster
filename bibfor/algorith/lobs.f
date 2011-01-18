      SUBROUTINE LOBS  (SDOBSE,NUMINS,INST  ,LOBSV )
C 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/01/2011   AUTEUR ABBAS M.ABBAS 
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
      INTEGER      NUMINS
      REAL*8       INST
      CHARACTER*19 SDOBSE
      LOGICAL      LOBSV
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (UTILITAIRE)
C
C DOIT-ON FAIRE UNE OBSERVATION  ?
C
C ----------------------------------------------------------------------
C
C
C IN  NUMINS : NUMERO DE L'INSTANT COURANT
C IN  SDOBSE : NOM DE LA SD POUR OBSERVATION
C IN  INST   : INSTANT DE CALCUL COURANT
C OUT LOBSV  : .TRUE. SI AU MOINS UNE OBSERVATION
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
      CHARACTER*24 OBSINF,OBSACT
      INTEGER      JOBSIN,JOBSAC
      INTEGER      IOBS,NBOBSV
      CHARACTER*2  CHAINE
      CHARACTER*19 LISTLI
      LOGICAL      LSELEC
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      LOBSV  = .FALSE.
C
C --- ACCES DE LA SD
C      
      OBSINF = SDOBSE(1:14)//'     .INFO'
      OBSACT = SDOBSE(1:14)//'     .ACTI'
      CALL JEVEUO(OBSINF,'L',JOBSIN)
      NBOBSV = ZI(JOBSIN-1+1)
C      
      IF (NBOBSV.EQ.0) GOTO 99
C
C --- INFO
C
      CALL JEVEUO(OBSACT,'E',JOBSAC)
C
      DO 10 IOBS = 1 , NBOBSV        
        CALL IMPFOI(0,2,IOBS,CHAINE)
        LISTLI = SDOBSE(1:14)//CHAINE(1:2)//'.LI'
        CALL NMCRPO(LISTLI,NUMINS,INST  ,LSELEC )
        ZL(JOBSAC+IOBS-1) = LSELEC
        LOBSV  = LSELEC.OR.LOBSV
 10   CONTINUE
 99   CONTINUE
C           
      CALL JEDEMA()
      
      END
