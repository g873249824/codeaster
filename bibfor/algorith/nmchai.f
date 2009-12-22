      SUBROUTINE NMCHAI(TYCHAP,TYVARZ,VALI  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*6   TYCHAP
      CHARACTER*(*) TYVARZ 
      INTEGER       VALI  
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
C
C INDEX OU EST STOCKE LE NOM DE LA VARIABLE DANS UNE VARIABLE CHAPEAU
C
C ----------------------------------------------------------------------
C
C
C IN  TYCHAP : TYPE DE VARIABLE CHAPEAU
C                MEELEM - NOMS DES MATR_ELEM
C                MEASSE - NOMS DES MATR_ASSE
C                VEELEM - NOMS DES VECT_ELEM
C                VEASSE - NOMS DES VECT_ASSE
C                SOLALG - NOMS DES CHAM_NO SOLUTIONS
C                VALINC - VALEURS SOLUTION INCREMENTALE
C IN  TYVARI : TYPE DE LA VARIABLE
C                OU  LONUTI - NOMBRE DE VAR. STOCKEES
C OUT VALI   : INDEX OU EST STOCKE LE NOM DE LA VARIABLE DANS UNE 
C              VARIABLE CHAPEAU
C                OU NOMBRE DE VAR. STOCKEES 
C      
C ----------------------------------------------------------------------
C
      INTEGER      NMEELM,NMEASS
      PARAMETER    (NMEELM=9 ,NMEASS=4 )
      INTEGER      NVEELM,NVEASS
      PARAMETER    (NVEELM=22,NVEASS=32) 
      INTEGER      NSOLAL,NVALIN
      PARAMETER    (NSOLAL=17,NVALIN=18)              
C
      CHARACTER*8  LMEELM(NMEELM),LMEASS(NMEASS)
      CHARACTER*8  LVEELM(NVEELM),LVEASS(NVEASS)
      CHARACTER*8  LSOLAL(NSOLAL)
      CHARACTER*8  LVALIN(NVALIN)      
C
      INTEGER      INDIK8      
      CHARACTER*8  TYVARI
C
      DATA LMEELM /'MERIGI','MEDIRI','MEMASS','MEAMOR','MESUIV',
     &             'MESSTR','MEGEOM','MEELTC','MEELTF'/
      DATA LMEASS /'MERIGI','MEMASS','MEAMOR','MESSTR'/
C
      DATA LVEELM /'CNFINT','CNDIRI','CNBUDI','CNFNOD','CNDIDO',
     &             'CNDIPI','CNFEDO','CNFEPI','CNLAPL','CNONDP',
     &             'CNFSDO','CNIMPP','CNMSME','CNDIDI','CNSSTF',
     &             'CNELTC','CNELTF','CNREFE','CNVCF1','CNVCF0',
     &             'CNIMPC','CNUSUR'/
      DATA LVEASS /'CNFINT','CNDIRI','CNBUDI','CNFNOD','CNDIDO',
     &             'CNDIPI','CNFEDO','CNFEPI','CNLAPL','CNONDP',
     &             'CNFSDO','CNIMPP','CNMSME','CNDIDI','CNSSTF',
     &             'CNELTC','CNELTF','CNREFE','CNVCF1','CNVCF0',
     &             'CNCINE','CNSSTR','CNCTDF','CNVCPR','CNDYNA',
     &             'CNMODP','CNMODC','CNCTDC','CNUNIL','CNFEXT',
     &             'CNIMPC','CNUSUR'/
C
      DATA LSOLAL /'DDEPLA','DEPDEL','DEPOLD','DEPPR1','DEPPR2',
     &             'DVITLA','VITDEL','VITOLD','VITPR1','VITPR2',
     &             'DACCLA','ACCDEL','ACCOLD','ACCPR1','ACCPR2',
     &             'DEPSO1','DEPSO2'/
C
      DATA LVALIN /'DEPMOI','SIGMOI','VARMOI','VITMOI','ACCMOI',
     &             'COMMOI','DEPPLU','SIGPLU','VARPLU','VITPLU',
     &             'ACCPLU','COMPLU','SIGEXT','DEPKM1','VITKM1',
     &             'ACCKM1','ROMKM1','ROMK'  /
     
C      
C ----------------------------------------------------------------------
C
      VALI   = -1
      TYVARI = TYVARZ
C
C ---
C
      IF (TYCHAP.EQ.'MEELEM') THEN
        IF (TYVARI.EQ.'LONMAX') THEN
          VALI = NMEELM
        ELSE
          VALI = INDIK8(LMEELM,TYVARI,1,NMEELM)
        ENDIF  
      ELSEIF (TYCHAP.EQ.'MEASSE') THEN
        IF (TYVARI.EQ.'LONMAX') THEN
          VALI = NMEASS
        ELSE      
          VALI = INDIK8(LMEASS,TYVARI,1,NMEASS)
        ENDIF  
      ELSEIF (TYCHAP.EQ.'VEELEM') THEN
        IF (TYVARI.EQ.'LONMAX') THEN
          VALI = NVEELM
        ELSE      
          VALI = INDIK8(LVEELM,TYVARI,1,NVEELM)
        ENDIF  
      ELSEIF (TYCHAP.EQ.'VEASSE') THEN
        IF (TYVARI.EQ.'LONMAX') THEN
          VALI = NVEASS
        ELSE      
          VALI = INDIK8(LVEASS,TYVARI,1,NVEASS)
        ENDIF  
      ELSEIF (TYCHAP.EQ.'SOLALG') THEN
        IF (TYVARI.EQ.'LONMAX') THEN
          VALI = NSOLAL
        ELSE      
          VALI = INDIK8(LSOLAL,TYVARI,1,NSOLAL)
        ENDIF  
      ELSEIF (TYCHAP.EQ.'VALINC') THEN
        IF (TYVARI.EQ.'LONMAX') THEN
          VALI = NVALIN
        ELSE      
          VALI = INDIK8(LVALIN,TYVARI,1,NVALIN)
        ENDIF
      ELSE
        CALL ASSERT(.FALSE.)         
      ENDIF
C
      CALL ASSERT(VALI.GT.0)      
C
      END
