      SUBROUTINE DLIEXT()
      IMPLICIT NONE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C     ------------------------------------------------------------------
C
C     COMMANDE : DEFI_LIST_ENTI/OPERATION='NUME_ORDRE'
C
C     ------------------------------------------------------------------
      INCLUDE 'jeveux.h'
      CHARACTER*8 RESU,K8B,KBID
      CHARACTER*16 NOMCMD,CONCEP,PARAM
      CHARACTER*19 SDRESU,RESU19
      CHARACTER*24 KNUM
      REAL*8 INTER2(2),R8B,VPARA
      COMPLEX*16 C16B
      INTEGER IBID,N1,N2,N3,NBORDR,K,IORD,K1,JORDR,NBVALE,JVALE,IAD
      INTEGER JNBPA,JBINT,JLPAS
      INTEGER      IARG
C     ------------------------------------------------------------------
      CALL JEMARQ()
      KNUM = '&&DLIEXT.KNUM'

      CALL GETRES(RESU,CONCEP,NOMCMD)

      CALL GETVID(' ','RESULTAT',0,IARG,1,SDRESU,N1)
      RESU19 = RESU
      CALL GETVTX(' ','PARAMETRE',0,IARG,1,PARAM,N2)
      CALL GETVR8(' ','INTERV_R',0,IARG,2,INTER2,N3)
      CALL ASSERT(N1+N2+N3.EQ.4)




C     1) CALCUL DE LA LISTE DES NUMEROS D'ORDRE (KNUM) :
C     ----------------------------------------------------
C     -- ON PARCOURT TOUS LES NUME_ORDRE ET ON NE CONSERVE
C        QUE CEUX QUI SONT DANS L'INTERVALLE
C        ATTENTION : ON LIT ET ECRIT DANS KNUM
      CALL RSORAC(SDRESU,'LONUTI',IBID,R8B,K8B,C16B,R8B,K8B,NBORDR,1,
     &            IBID)
      CALL WKVECT(KNUM,'V V I',NBORDR,JORDR)
      CALL RSORAC(SDRESU,'TOUT_ORDRE',IBID,R8B,K8B,C16B,R8B,K8B,
     &            ZI(JORDR),NBORDR,IBID)
      K1 = 0
      DO 10,K = 1,NBORDR
        IORD = ZI(JORDR-1+K)
        CALL RSADPA(SDRESU,'L',1,PARAM,IORD,0,IAD,KBID)
        CALL ASSERT(IAD.NE.0)
        VPARA = ZR(IAD)
        IF (VPARA.GE.INTER2(1) .AND. VPARA.LE.INTER2(2)) THEN
          K1 = K1 + 1
          ZI(JORDR-1+K1) = IORD
        ENDIF
   10 CONTINUE
      NBORDR = K1
      NBVALE = NBORDR
      CALL ASSERT(NBORDR.GT.0)


C     2) CREATION DE LA STRUCTURE DE DONNEES :
C     ----------------------------------------------------
      CALL WKVECT(RESU19//'.VALE','G V I',NBVALE,JVALE)
      CALL WKVECT(RESU19//'.BINT','G V I',NBVALE,JBINT)
      DO 20,K = 1,NBVALE
        ZI(JVALE-1+K) = ZI(JORDR-1+K)
        ZI(JBINT-1+K) = ZI(JORDR-1+K)
  20  CONTINUE

      IF (NBVALE.GT.1) THEN
        CALL WKVECT(RESU19//'.NBPA','G V I',NBVALE-1,JNBPA)
        CALL WKVECT(RESU19//'.LPAS','G V I',NBVALE-1,JLPAS)
        DO 21,K = 1,NBVALE-1
          ZI(JNBPA-1+K) = 1
          ZI(JLPAS-1+K) = ZI(JORDR-1+K+1)-ZI(JORDR-1+K)
  21    CONTINUE
      ELSE
        CALL WKVECT(RESU19//'.NBPA','G V I',1,JNBPA)
        CALL WKVECT(RESU19//'.LPAS','G V I',1,JLPAS)
      ENDIF



      CALL JEDEMA()
      END
