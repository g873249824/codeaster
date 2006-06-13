      SUBROUTINE RLDLG3(METRES,LMAT,XSOL,CXSOL,NBSOL)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*) METRES
      INTEGER LMAT,NBSOL
      REAL*8 XSOL
      COMPLEX*16 CXSOL
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 28/02/2006   AUTEUR VABHHTS J.PELLET 
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
C ======================================================================
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER TYPVAR,TYPSYM
      CHARACTER*19 MAT19
      CHARACTER*8 KBID
C------------------------------------------------------------------
      CALL JEMARQ()
      NEQ = ZI(LMAT+2)
      TYPVAR = ZI(LMAT+3)
      TYPSYM = ZI(LMAT+4)
      MAT19=ZK24(ZI(LMAT+1))



      IF (METRES.EQ.'LDLT') THEN
C     ---------------------------------
        CALL JELIRA(MAT19//'.UALF','NMAXOC',NBBLOC,KBID)
        CALL MTDSC2(MAT19,'SCHC','L',JSCHC)
        CALL MTDSC2(MAT19,'SCDI','L',JSCDI)
        CALL MTDSC2(MAT19,'SCBL','L',JSCBL)

        IF (TYPVAR.EQ.1) THEN
C           --- SYSTEME REELLE ---

C         -- CAS D'UNE MATRICE SYMETRIQUE
          IF (TYPSYM.EQ.1) THEN
            CALL RLDLR8(MAT19,ZI(JSCHC),ZI(JSCDI),ZI(JSCBL),
     &                  NEQ,NBBLOC,XSOL,NBSOL)

C        -- CAS D'UNE MATRICE NON_SYMETRIQUE
          ELSE IF (TYPSYM.EQ.0) THEN
            CALL RLDUR8(MAT19,ZI(JSCHC),ZI(JSCDI),ZI(JSCBL),
     &                  NEQ,NBBLOC/2,XSOL,NBSOL)
          END IF

        ELSE IF (TYPVAR.EQ.2) THEN
C         -- SYSTEME COMPLEXE (SYMETRIQUE) ---
          CALL RLDLC8(MAT19,ZI(JSCHC),ZI(JSCDI),ZI(JSCBL),
     &                NEQ,NBBLOC,CXSOL,NBSOL)
        END IF


      ELSE IF (METRES.EQ.'MULT_FRO') THEN
C     ------------------------------------
        IF (TYPVAR.EQ.1) THEN
          CALL RLTFR8(MAT19,NEQ,XSOL,NBSOL,TYPSYM)
        ELSE IF (TYPVAR.EQ.2) THEN
          CALL RLFC16(MAT19,NEQ,CXSOL,NBSOL,TYPSYM)
        END IF
      END IF
   10 CONTINUE

      CALL JEDEMA()

      END
