      SUBROUTINE IMPSUI(SDSUIV,ZDEF  ,COLACT,NCOL  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 15/11/2011   AUTEUR ABBAS M.ABBAS 
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
      INTEGER      ZDEF,NCOL
      CHARACTER*19 SDSUIV,COLACT 
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (AFFICHAGE)
C
C CAS DU SUIVI_DDL
C
C ----------------------------------------------------------------------
C
C
C IN  SDSUIV : NOM DE LA SD POUR LE SUIVI
C IN  ZDEF   : NOMBRE MAXI DE COLONNES DISPONIBLES POUR L'AFFICHAGE
C IN  COLACT : VECTEUR D'ACTIVATION DES COLONNES
C OUT NCOL   : NOMBRE DE COLONNES ACTIVES DANS COLACT
C
C COLACT CONTIENT LA LISTE DES CODES D'AFFICHAGES
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C      
      INTEGER      ISUI,ICOL,NSUIMX
      INTEGER      JIMCOL 
      INTEGER      NBSUIV      
      CHARACTER*24 OBSINF
      INTEGER      JOBSIN       
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- NOMBRE DE SUIVI_DDL
C
      OBSINF = SDSUIV(1:14)//'     .INFO'
      CALL JEVEUO(OBSINF,'L',JOBSIN)
      NBSUIV = ZI(JOBSIN+1-1)
C
C --- NOMBRE DE COLONNES ACTIVES
C
      ICOL   = NCOL
      NSUIMX = ZDEF - NCOL
C
C --- ACCES
C
      CALL JEVEUO(COLACT,'E',JIMCOL)       
C
      IF (NBSUIV.GT.NSUIMX) THEN
        CALL U2MESI('F','OBSERVATION_5',1,NSUIMX)
      ENDIF
C
      DO 10 ISUI = 1, NBSUIV
        ICOL              = ICOL + 1
        ZI(JIMCOL+ICOL-1) = -ISUI
   10 CONTINUE
C
C --- NOMBRE DE COLONNES ACTIVES
C
      NCOL  = NCOL + NBSUIV
C
      CALL JEDEMA()

      END
