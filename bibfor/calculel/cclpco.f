      SUBROUTINE CCLPCO(OPTION,RESUOU,NUMORD,NBPAOU,LIPAOU,
     &                  LICHOU)
      IMPLICIT NONE
C     --- ARGUMENTS ---
      INTEGER      NBPAOU,NUMORD
      CHARACTER*8  RESUOU
      CHARACTER*8  LIPAOU(*)
      CHARACTER*16 OPTION
      CHARACTER*24 LICHOU(*)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 05/10/2010   AUTEUR SELLENET N.SELLENET 
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
C ----------------------------------------------------------------------
C  CALC_CHAMP - DETERMINATION LISTE DE PARAMETRES ET LISTE DE CHAMPS OUT
C  -    -                     -        -                      -      -
C ----------------------------------------------------------------------
C
C IN  :
C   OPTION  K16  NOM DE L'OPTION A CALCULER
C   RESUOU  K8   NOM DE LA STRUCUTRE DE DONNEES RESULTAT OUT
C   NUMORD  I    NUMERO D'ORDRE COURANT
C
C OUT :
C   NBPAOU  I    NOMBRE DE PARAMETRES OUT
C   LIPAOU  K8*  LISTE DES PARAMETRES OUT
C   LICHOU  K8*  LISTE DES CHAMPS OUT
C ----------------------------------------------------------------------
C RESPONSABLE SELLENET N.SELLENET
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER        ZI
      COMMON /IVARJE/ZI(1)
      REAL*8         ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16     ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL        ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8    ZK8
      CHARACTER*16          ZK16
      CHARACTER*24                  ZK24
      CHARACTER*32                          ZK32
      CHARACTER*80                                  ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      INTEGER      OPT,IAOPDS,IAOPLO,IAPARA,NPARIN,IPARA,OPT2,IERD,IBID
      INTEGER      DECAL,NPAROU
      
      CHARACTER*8  NOMA
      CHARACTER*16 OPTIO2
      CHARACTER*19 NOCHOU
      CHARACTER*32 JEXNUM,JEXNOM
      
      CALL JEMARQ()
      
      CALL JENONU(JEXNOM('&CATA.OP.NOMOPT',OPTION),OPT)
      CALL JEVEUO(JEXNUM('&CATA.OP.DESCOPT',OPT),'L',IAOPDS)
      CALL JEVEUO(JEXNUM('&CATA.OP.LOCALIS',OPT),'L',IAOPLO)
      CALL JEVEUO(JEXNUM('&CATA.OP.OPTPARA',OPT),'L',IAPARA)
      
      NPARIN = ZI(IAOPDS-1+2)
      NPAROU = ZI(IAOPDS-1+3)
      
      NBPAOU = 0
      
      NPAROU = 1
      
C     BOUCLE SUR LES PARAMETRES DE L'OPTION
      DO 10 IPARA = 1,NPAROU
        NBPAOU = NBPAOU + 1
        LIPAOU(NBPAOU) = ZK8(IAPARA+NPARIN+IPARA-1)
        
        CALL RSEXC1(RESUOU,OPTION,NUMORD,NOCHOU)
        LICHOU(NBPAOU) = NOCHOU
   10 CONTINUE
      
      CALL JEDEMA()
      
      END
