      SUBROUTINE TE0400(OPTION,NOMTE)
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 14/10/2008   AUTEUR DELMAS J.DELMAS 
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
C
C     BUT:
C         CREATION DE LA SD VOISIN POUR LES SOUS ELEMENTS D'UN ELEMENT 
C         PARENT XFEM (2D):
C         ON ETABLIT LA TABLE DE CONNECTIVITE INVERSE DES SOUS-ELEMENTS
C         PUIS ON EN DEDUIT LES VOISINS DES SOUS ELEMENTS
C         OPTION : 'CHVOIS_XFEM'
C
C
C     ARGUMENTS:
C     ----------
C
C      ENTREE :
C-------------
C IN   OPTION : OPTION DE CALCUL
C IN   NOMTE  : NOM DU TYPE ELEMENT
C
C ......................................................................
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER       NINTER
      PARAMETER    ( NINTER = 3 )

      INTEGER      NDIM,NNOP,NNO,NSETOT,IBID,NNOTOT
      INTEGER      JCNINX,JCNSET,JLONCH,IVOISX
      CHARACTER*8  ELRESE(3),FAMI(3),ELREFP
      CHARACTER*24 CNINVX

      DATA    ELRESE /'SE2','TR3','TE4'/
      DATA    FAMI   /'BID','RIGI','XINT'/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C      
C --- RECUPERATION DES DONNEES ELEMENT ET SOUS-ELEMENT
C
      CALL ELREF1(ELREFP) 
      CALL ELREF4(' ','RIGI',NDIM,NNOP,IBID,IBID,IBID,IBID,IBID,IBID)
      CALL ELREF4(ELRESE(NDIM),FAMI(NDIM),IBID,NNO,IBID,IBID,
     &     IBID,IBID,IBID,IBID)
C
C --- RECUPERATION DES CHAMPS IN ET OUT 
C
      CALL JEVECH('PCNSETO','L',JCNSET)
      CALL JEVECH('PLONCHA','L',JLONCH)  
      CALL JEVECH('PCVOISX','E',IVOISX)      
C
C --- PREALABLES
C      
      NSETOT = ZI(JLONCH-1+2)+ZI(JLONCH-1+3)
      NNOTOT = NNOP+NINTER
      
      CNINVX='&&TE0412.CNINVX'
      CALL WKVECT(CNINVX,'V V I',(NSETOT+1)*NNOTOT,JCNINX)
C
C --- CALCUL DE LA CONNECTIVITE INVERSE 
C
      CALL XCNINV(NDIM,NNOTOT,NSETOT,NNOP,NNO,JCNSET,JLONCH,ZI(JCNINX))
C      
C --- CALCUL DE LA SD VOISIN PAR SOUS ELEMENTS
C
      CALL XVOISE(NDIM,NNOTOT,NSETOT,NNOP,NNO,JCNSET,JLONCH, ZI(JCNINX),
     &            ZI(IVOISX))
C
C --- MENAGE
C
      CALL JEDETR(CNINVX)
C
      CALL JEDEMA()
C      
      END
