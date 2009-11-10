      SUBROUTINE NBNLMA ( NOMA, NBM, LIMANU, NBTYP, LITYP, NBN )
      IMPLICIT   NONE
      INTEGER        LIMANU(*), NBM, NBN, NBTYP
      CHARACTER*8    LITYP(*), NOMA
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 10/11/2009   AUTEUR MACOCCO K.MACOCCO 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C BUT : TROUVER LE NOMBRE DE NOEUDS QUI APPARTIENNENT A UNE LISTE DE
C       MAILLES, ET EVENTUELLEMENT LEURS NUMEROS
C       VERIFIER QUE LES MAILLES DE CETTE LISTE SONT D'UN TYPE CORRECT
C
C ARGUMENTS D'ENTREE:
C      NOMA : NOM DU MAILLAGE
C      NBM  : NOMBRE DE MAILLES DANS LA LISTE.
C    LIMANU : LISTE DES NUMEROS DE MAILLE
C     NBTYP : NOMBRE DE TYPE_MAILLES DANS LA LISTE LITYP.
C             SI NBTYP=0: AUCUNE VERIF N'EST FAITE SUR LES TYPES
C    LITYP  : LISTE DES TYPES DE MAILLE
C             SI NBTYP=0: LITYP=K8BID
C ARGUMENTS DE SORTIE:
C      NBN  : NOMBRE DE NOEUDS
C   OBJETS JEVEUX CREES
C      &&NBNLMA.LN   : NUMEROS DES NOEUDS
C      &&NBNLMA.NBN  : NOMBRES D'OCCURENCES DES NOEUDS
C-----------------------------------------------------------------------
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                       ZK24
      CHARACTER*32                                ZK32
      CHARACTER*80                                         ZK80
      COMMON / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32      JEXNOM, JEXNUM, JEXATR
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER      IATYMA, IBID, IRET, IT, ITROU, J, JDES, JLN, JNBN,
     +             JTYP, M, MI, N, NBNA, NBNM, NN, NUMTYP, P1, P2
      CHARACTER*8  MK,VALK
      CHARACTER*1  K1BID
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL JEVEUO ( NOMA//'.TYPMAIL', 'L', IATYMA )
      CALL JEVEUO ( JEXATR(NOMA//'.CONNEX','LONCUM'), 'L', P2 )
      CALL JEVEUO ( NOMA//'.CONNEX', 'L', P1 )
C
C --- SI ON SOUHAITE CONTROLEE LE TYPE DE MAILLE DE LIMANU:
      IF (NBTYP.NE.0)THEN

      NBNM = 0
      DO 10 M = 1 , NBM
         MI   = LIMANU(M)
         JTYP = IATYMA-1 + MI
         NN = 0

         DO 12 IT = 1 , NBTYP
             CALL JENONU(JEXNOM('&CATA.TM.NBNO',LITYP(IT)),NUMTYP)
             IF ( ZI(JTYP) .EQ. NUMTYP ) THEN
                NN = ZI(P2+MI+1-1) - ZI(P2+MI-1)
             END IF
   12    CONTINUE
         IF ( NN .EQ. 0 ) THEN
            CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',MI),MK)
            VALK = MK
            CALL U2MESG('F', 'MODELISA8_68',1,VALK,0,0,0,0.D0)
         ELSE
             NBNM = NBNM + NN
         END IF

 10   CONTINUE

C --- SINON:
      ELSE

      NBNM = 0
      DO 14 M = 1 , NBM
         MI   = LIMANU(M)
         NN = ZI(P2+MI+1-1) - ZI(P2+MI-1)
         NBNM = NBNM + NN
 14   CONTINUE

      ENDIF
C
C
      CALL JEEXIN('&&NBNLMA.LN',IRET)
      IF (IRET.NE.0) CALL JEDETR('&&NBNLMA.LN')
      CALL WKVECT ( '&&NBNLMA.LN', 'V V I', NBNM, JLN )
      CALL JEECRA ( '&&NBNLMA.LN' , 'LONUTI', 0, ' ')
C
      CALL JEEXIN('&&NBNLMA.NBN',IRET)
      IF (IRET.NE.0) CALL JEDETR('&&NBNLMA.NBN')
      CALL WKVECT ( '&&NBNLMA.NBN', 'V V I', NBNM, JNBN )
      CALL JEECRA ( '&&NBNLMA.NBN', 'LONUTI', 0, ' ')
C
      DO 20 M = 1 , NBM
         MI = LIMANU(M)
         NN = ZI(P2+MI+1-1) - ZI(P2+MI-1)
C
         DO 22 N = 1 , NN
C
C           NBNA EST LE NOMBRE DE NOEUDS ACTUELLEMENT STOCKES
C
            CALL JELIRA ( '&&NBNLMA.LN', 'LONUTI', NBNA, K1BID )
            ITROU = 0
C
C           SI LE NUMERO DE NOEUD EXISTE DEJA DANS .LN
C           ON INCREMENTE A LA PLACE J DANS LE TABLEAU &&NBNLMA.NBN
C
            DO 24 J = 1 , NBNA
               IF ( ZI(P1+ZI(P2+MI-1)-1+N-1) .EQ. ZI(JLN-1+J) ) THEN
                  ZI(JNBN-1+J) = ZI(JNBN-1+J)+1
                  ITROU = 1
               END IF
 24         CONTINUE
C
C           SI LE NUMERO DE NOEUD N'EXISTE PAS,
C           ON LE STOCKE A LA PLACE NBNA (A LA FIN ) DANS LE TABLEAU .LN
C           ET ON STOCKE 1 A LA PLACE NBNA LE TABLEAU &&NBNLMA.NBN
C
            IF ( ITROU .EQ. 0 ) THEN
               NBNA = NBNA + 1
               ZI( JLN-1+NBNA) = ZI(P1+ZI(P2+MI-1)-1+N-1)
               ZI(JNBN-1+NBNA) = 1
               CALL JEECRA ( '&&NBNLMA.LN' , 'LONUTI', NBNA, ' ')
               CALL JEECRA ( '&&NBNLMA.NBN', 'LONUTI', NBNA, ' ')
            END IF
 22      CONTINUE
 20   CONTINUE
C
      NBN = NBNA
C
      CALL JEDEMA()
      END
