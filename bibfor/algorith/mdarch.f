      SUBROUTINE MDARCH (ISTO1,IPAS,T,DT,NBMODE,DEPGEN,VITGEN,ACCGEN,
     +                   ISTO2,NBCHOC,SAUCHO,NBSCHO,
     +                   ISTO3,NBREDE,SAURED,SAREDI,
     +                   DEPSTO,VITSTO,ACCSTO,PASSTO,LPSTO, IORSTO,
     +                   TEMSTO,FCHOST,DCHOST,VCHOST, ICHOST, VINT,
     +                   IREDST,DREDST )
      IMPLICIT NONE
      INTEGER    IORSTO(*),IREDST(*),SAREDI(*),ICHOST(*)
      REAL*8     DEPGEN(*),VITGEN(*),ACCGEN(*),DEPSTO(*),VITSTO(*),
     +           SAUCHO(NBCHOC,*),SAURED(*),DREDST(*),PASSTO(*),
     +           ACCSTO(*),TEMSTO(*),FCHOST(*),DCHOST(*),VCHOST(*)
      REAL*8     VINT(*)
      LOGICAL LPSTO
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C TOLE CRP_21
C
C     ARCHIVAGE DES VALEURS
C     ------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      INTEGER IC ,IM ,IND ,IPAS ,IR ,ISTO1 ,ISTO2 
      INTEGER ISTO3 ,NBCHOC ,NBMODE ,NBREDE ,NBSCHO ,NDEC 
      REAL*8 DT ,T 
C-----------------------------------------------------------------------
      IORSTO(ISTO1+1) = IPAS
      TEMSTO(ISTO1+1) = T
      NDEC = NBCHOC*ISTO1
      IF (LPSTO) PASSTO(ISTO1+1) = DT
      IND = NBMODE * ISTO1
      DO 202 IM = 1,NBMODE
         DEPSTO(IND+IM) = DEPGEN(IM)
         VITSTO(IND+IM) = VITGEN(IM)
         ACCSTO(IND+IM) = ACCGEN(IM)
 202  CONTINUE
      IF ( NBCHOC.NE.0 ) THEN
         IND = NBCHOC * ISTO1
         DO 204 IC = 1,NBCHOC
            ISTO2 = ISTO2 + 1
            FCHOST(ISTO2) = SAUCHO(IC,1)
            DCHOST(ISTO2) = SAUCHO(IC,4)
            VCHOST(ISTO2) = SAUCHO(IC,7)
            DCHOST(NBSCHO+ISTO2) = SAUCHO(IC,10)
            ISTO2 = ISTO2 + 1
            FCHOST(ISTO2) = SAUCHO(IC,2)
            DCHOST(ISTO2) = SAUCHO(IC,5)
            VCHOST(ISTO2) = SAUCHO(IC,8)
            DCHOST(NBSCHO+ISTO2) = SAUCHO(IC,11)
            ISTO2 = ISTO2 + 1
            FCHOST(ISTO2) = SAUCHO(IC,3)
            DCHOST(ISTO2) = SAUCHO(IC,6)
            VCHOST(ISTO2) = SAUCHO(IC,9)
            DCHOST(NBSCHO+ISTO2) = SAUCHO(IC,12)
            ICHOST(NDEC+IC) = NINT(SAUCHO(IC,13))
C           --- VARIABLES INTERNES : FLAMBAGE ---
            VINT(IND+IC) = SAUCHO(IC,14)
 204     CONTINUE
      ENDIF
      IF ( NBREDE.NE.0 ) THEN
         DO 206 IR = 1,NBREDE
            ISTO3 = ISTO3 + 1
            IREDST(ISTO3) = SAREDI(IR)
            DREDST(ISTO3) = SAURED(IR)
 206     CONTINUE
      ENDIF
C
      END
