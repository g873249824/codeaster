      SUBROUTINE NMACIN(FONACT,MATASS,DEPPLA,CNCIND)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 02/08/2011   AUTEUR MACOCCO K.MACOCCO 
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
      IMPLICIT NONE
      INTEGER      FONACT(*)
      CHARACTER*19 MATASS,DEPPLA,CNCIND
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE
C
C BUT : ACTUALISER LES CHARGES CINEMATIQUES DE FACON A CALCULER
C       UNE CORRECTION PAR RAPPORT AU DEPLACEMENT COURANT (DEPPLA)
C
C ----------------------------------------------------------------------
C
C
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  MATASS : SD MATRICE ASSEMBLEE
C IN  DEPPLA : DEPLACEMENT COURANT
C OUT CNCIND : CHAMP DES INCONNUES CINEMATIQUES CORRIGE PAR DEPPLA
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
      INTEGER      JCCID,NEQ,JCIND,JDEPLA,I
      CHARACTER*19 KBID
      LOGICAL      ISFONC,LCINE
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- FONCTIONNALITES ACTIVEES
C
      LCINE  = ISFONC(FONACT,'DIRI_CINE')
C
      IF (LCINE) THEN
        CALL JELIRA(CNCIND(1:19)//'.VALE','LONMAX',NEQ,KBID)
        CALL NMPCIN(MATASS)
        CALL JEVEUO(MATASS(1:19)//'.CCID','L',JCCID )
        CALL JEVEUO(DEPPLA(1:19)//'.VALE','L',JDEPLA)
        CALL JEVEUO(CNCIND(1:19)//'.VALE','E',JCIND )
C
C ---   CONSTRUCTION DU CHAMP CNCINE QUI RENDRA
C ---   DEPPLA CINEMATIQUEMENT ADMISSIBLE
C
        DO 10 I = 1,NEQ
            IF (ZI(JCCID+I-1).EQ.1) THEN
                ZR(JCIND-1+I) = ZR(JCIND-1+I)-ZR(JDEPLA-1+I)
            ENDIF
  10    CONTINUE
C
      ENDIF

      CALL JEDEMA()
      END
