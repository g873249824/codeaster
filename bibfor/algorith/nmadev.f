      SUBROUTINE NMADEV(SDDISC,CONVER,ITERAT,ITEMAX,ERROR)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 31/05/2011   AUTEUR GENIAUT S.GENIAUT 
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
C RESPONSABLE GENIAUT S.GENIAUT
C
      IMPLICIT     NONE
      CHARACTER*19 SDDISC
      INTEGER      ITERAT
      LOGICAL      CONVER,ITEMAX,ERROR
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C     MISE A JOUR DE L'INDICATEUR DE SUCCES DES ITERATIONS DE NEWTON
C
C ----------------------------------------------------------------------
C
C
C IN/OUT  SDDISC : SD DISCRETISATION TEMPORELLE
C IN      CONVER : .TRUE. SI CONVERGENCE REALISEE
C IN      ITERAT : NB D'ITERATIONS DE NEWTON
C IN      ITEMAX : .TRUE. SI ITERATION MAXIMUM ATTEINTE
C IN      ERROR  : .TRUE. SI ERREUR
C
C
      INTEGER     IFM,NIV,IBID,NOCC,IOCC,NB,IB,VALI,NBOK
      REAL*8       R8B,VALE
      CHARACTER*8  K8B,CRICOM,METLIS
      CHARACTER*16 NOPARA
      CHARACTER*19 EVEN
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C     LA MISE A JOUR DE L'INDICATEUR DE SUCCES DES ITERATIONS DE NEWTON
C     N'EST FAITE QU'EN GESTION AUTO DU PAS DE TEMPS
      CALL UTDIDT('L',SDDISC,'LIST',IBID,'METHODE',R8B,IBID,METLIS)
      IF (METLIS.NE.'AUTO') GOTO 9999


      CALL UTDIDT('L',SDDISC,'ADAP',IBID,'NB_OCC',R8B,NOCC,K8B)

C     BOUCLE SUR LES OCCURENCES D'ADAPTATION
      DO 10 IOCC=1,NOCC

        CALL UTDIDT('L',SDDISC,'ADAP',IOCC,'NOM_EVEN',R8B,IBID,EVEN)

        IF (EVEN.EQ.'SEUIL_SANS_FORMULE') THEN
          CALL UTDIDT('L',SDDISC,'ADAP',IOCC,'NOM_PARA',R8B,IB,NOPARA)
          CALL UTDIDT('L',SDDISC,'ADAP',IOCC,'CRIT_COMP',R8B,IB,CRICOM)
          CALL UTDIDT('L',SDDISC,'ADAP',IOCC,'VALE',VALE,VALI,K8B)

C         RECUP DU NB DE SUCCES CONSECUTIFS : NBOK
          CALL UTDIDT('L',SDDISC,'ADAP',IOCC,'NB_EVEN_OK',R8B,NBOK,K8B)

          CALL ASSERT(NOPARA.EQ.'NB_ITER_NEWT')

C         EN CAS DE NOUVEAU SUCCES A CONVERGENCE
          IF (CONVER) THEN
            IF (CRICOM.EQ.'LT'.AND.ITERAT.LT.VALI.OR.
     &          CRICOM.EQ.'GT'.AND.ITERAT.GT.VALI.OR.
     &          CRICOM.EQ.'LE'.AND.ITERAT.LE.VALI.OR.
     &          CRICOM.EQ.'GE'.AND.ITERAT.GE.VALI) NBOK = NBOK+1
          ENDIF

C         EN CAS D'ECHEC: ON REMET A ZERO
          IF (ERROR.OR.ITEMAX) NBOK=0

C         ENREGISTREMENT DU NB DE SUCCES CONSECUTIFS
          CALL UTDIDT('E',SDDISC,'ADAP',IOCC,'NB_EVEN_OK',R8B,NBOK,K8B)
               
        ENDIF
 10   CONTINUE
C
 9999 CONTINUE
C
      CALL JEDEMA()
      END
