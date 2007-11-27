      SUBROUTINE QUADCO(CHAR,MOTFAC,NZOCP,
     &                  INDQUA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 27/11/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MABBAS M.ABBAS
C
      IMPLICIT      NONE
      CHARACTER*8  CHAR
      CHARACTER*16 MOTFAC
      INTEGER      NZOCP
      INTEGER      INDQUA
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES - LECTURE DONNEES)
C
C TRAITEMENT DU CAS DES MAILLES QUADRATIQUES
C      
C ----------------------------------------------------------------------
C
C
C INDQUA VAUT 0 SI L'ON DOIT CONSIDERER LES NOEUDS MILIEUX A PART
C DANS CE CAS, PERMETTRA DE FAIRE LA LIAISON LINEAIRE DANS CACOEQ
C MASI UNQIUEMENT POUR LES QUAD8 EN SOLIDE.
C 
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  MOTFAC : MOT-CLE FACTEUR (VALANT 'CONTACT')
C IN  NZOCP  : NOMBRE DE ZONES DE CONTACT PRINCIPALES
C OUT INDQUA : VAUT 0 LORSQUE L'ON DOIT TRAITER LES NOEUDS MILIEUX
C                     A PART
C              VAUT 1 LORSQUE L'ON DOIT TRAITER LES NOEUDS MILIEUX
C                     NORMALEMENT
C   
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      IZONE,FORM,METH 
      CHARACTER*24 FORMCO,METHCO
      INTEGER      JFORM,JMETH
      INTEGER      CFMMVD,ZMETH          
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C 
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C 
      FORMCO = CHAR(1:8)//'.CONTACT.FORMCO'  
      METHCO = CHAR(1:8)//'.CONTACT.METHCO'           
      CALL JEVEUO(FORMCO,'L',JFORM) 
      CALL JEVEUO(METHCO,'L',JMETH)
C
      ZMETH  = CFMMVD('ZMETH')            
C
C --- INITIALISATIONS
C      
      INDQUA = 0
C
      DO 2 IZONE = 1,NZOCP
        FORM   = ZI(JFORM-1+IZONE)
        METH   = ZI(JMETH+ZMETH*(IZONE-1)+6)
        IF (FORM.EQ.1) THEN     
          IF (METH.EQ.-2) THEN  
            INDQUA = 1            
          ELSEIF (METH.EQ.-1) THEN  
            INDQUA = 0            
          ELSEIF (METH.EQ.0) THEN  
            INDQUA = 0
          ELSEIF (METH.EQ.1) THEN  
            INDQUA = 0
          ELSEIF (METH.EQ.2) THEN  
            INDQUA = 0             
          ELSEIF (METH.EQ.3) THEN  
            INDQUA = 0 
          ELSEIF (METH.EQ.4) THEN  
            INDQUA = 0                        
          ELSEIF (METH.EQ.5) THEN  
            INDQUA = 1           
          ELSEIF (METH.EQ.7) THEN
            INDQUA = 1            
          ELSEIF (METH.EQ.9) THEN  
            INDQUA = 0  
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF                                    
        ELSEIF (FORM.EQ.2) THEN
          IF (METH.EQ.6) THEN  
            INDQUA = 1            
          ELSEIF (METH.EQ.8) THEN
            INDQUA = 1
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ELSEIF (FORM.EQ.3) THEN
          INDQUA = 1
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
  2   CONTINUE  
C
      CALL JEDEMA()
      END
