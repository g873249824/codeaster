      SUBROUTINE INFOAR(NDIM,AR,IA,J,IGEOM,ILSN,A,B,M,LSNA,LSNB,LSNM)
      IMPLICIT NONE

      INTEGER   AR(12,3),IGEOM,ILSN,NDIM,IA,J
      REAL*8    A(NDIM),B(NDIM),M(NDIM),LSNA,LSNB,LSNM

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/06/2010   AUTEUR CARON A.CARON 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C                      CALCUL ET STOCKAGE DES COORDONNEES DU MILIEU DE 
C                      L'ARETE CREEE LORS DU SOUS DECOUPAGE
C                    
C......................................................................
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  ------------------------
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  ------------------------
      INTEGER   NA,NB,NM,I
C
C......................................................................

      CALL JEMARQ()

        NA=AR(IA,J)
        NB=AR(IA,3-J)                
        NM=AR(IA,3)

        CALL VECINI(NDIM,0.D0,A)
        CALL VECINI(NDIM,0.D0,B)
        CALL VECINI(NDIM,0.D0,M)

        DO 100 I=1,NDIM
          A(I)=ZR(IGEOM-1+NDIM*(NA-1)+I)
          B(I)=ZR(IGEOM-1+NDIM*(NB-1)+I)
          M(I)=ZR(IGEOM-1+NDIM*(NM-1)+I)
 100    CONTINUE

        LSNA=ZR(ILSN-1+NA)
        LSNB=ZR(ILSN-1+NB)
        LSNM=ZR(ILSN-1+NM)

      CALL JEDEMA()
      END
