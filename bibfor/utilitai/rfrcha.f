      SUBROUTINE RFRCHA(IER)
      IMPLICIT NONE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 30/01/2006   AUTEUR LEBOUVIE F.LEBOUVIER 
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
C     OPERATEUR "RECU_FONCTION"
C     ------------------------------------------------------------------
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
      INTEGER LVALE,LXLGUT,LG1,LG2,IDDL,INOEUD,NCH,NVERI1
      INTEGER L,NVERI2,N1,N2,N3,IRET,IVARI
      INTEGER IER,NM,NGM,NPOINT,NP,NN
      INTEGER NGN,IBID,IE,NC,IFM,NIV,NUSP
      REAL*8 EPSI,VALR
      COMPLEX*16 VALC
      CHARACTER*1 TYPE
      CHARACTER*8 K8B,CRIT,MAILLE,NOMA,INTRES
      CHARACTER*8 NOEUD,CMP,NOGMA,NOGNO,NOMGD
      CHARACTER*16 NOMCMD,TYPCON,NOMACC,TYPCHA,NOMCHA
      CHARACTER*19 NOMFON,CHAM19
C     ------------------------------------------------------------------
      CALL JEMARQ()
C --- RECUPERATION DU NIVEAU D'IMPRESSION
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)
C
      CALL GETRES(NOMFON,TYPCON,NOMCMD)

      CALL GETVTX(' ','CRITERE',0,1,1,CRIT,N1)
      CALL GETVR8(' ','PRECISION',0,1,1,EPSI,N1)
      INTRES = 'NON     '
      CALL GETVTX(' ','INTERP_NUME',0,1,1,INTRES,N1)

      NPOINT = 0
      CMP = ' '
      NOEUD = ' '
      MAILLE = ' '
      NOGMA = ' '
      NOGNO = ' '
      CALL GETVID(' ','MAILLE',0,1,1,MAILLE,NM)
      CALL GETVID(' ','GROUP_MA',0,1,1,NOGMA,NGM)
      CALL GETVIS(' ','SOUS_POINT',0,1,1,NUSP,NP)
      IF (NP.EQ.0) NUSP = 0
      CALL GETVIS(' ','POINT',0,1,1,NPOINT,NP)
      CALL GETVID(' ','NOEUD',0,1,1,NOEUD,NN)
      CALL GETVID(' ','GROUP_NO',0,1,1,NOGNO,NGN)

      NVERI1 = NM + NGM
      NVERI2 = NN + NP + NGN
C
C     -----------------------------------------------------------------
C                      --- CAS D'UN CHAM_GD ---
C     -----------------------------------------------------------------
      CALL GETVID(' ','CHAM_GD',0,1,1,CHAM19,NCH)
      IF (NCH.NE.0) THEN
        CALL DISMOI('F','TYPE_SUPERVIS',CHAM19,'CHAMP',IBID,TYPCHA,IE)
        CALL DISMOI('F','NOM_MAILLA',CHAM19,'CHAMP',IBID,NOMA,IE)
        CALL GETTCO(CHAM19,NOMACC)
        IF (TYPCHA(1:7).EQ.'CHAM_NO') THEN
C       ----------------------------------
          IF (NGN.NE.0) THEN
            CALL UTNONO(' ',NOMA,'NOEUD',NOGNO,NOEUD,IRET)
            IF (IRET.EQ.10) THEN
              CALL UTMESS('F','OP0090','LE GROUP_NO : '//NOGNO//
     &                    'N''EXISTE PAS.')
            ELSE IF (IRET.EQ.1) THEN
              CALL UTDEBM('A','RECU_FONCTION',
     &                    'TROP DE NOEUDS DANS LE GROUP_NO')
              CALL UTIMPK('L','  NOEUD UTILISE: ',1,NOEUD)
              CALL UTFINM()
            END IF
          END IF
          CALL GETVTX(' ','NOM_CMP',0,1,1,CMP,NC)
          CALL POSDDL('CHAM_NO',CHAM19,NOEUD,CMP,INOEUD,IDDL)
          IF (INOEUD.EQ.0) THEN
            LG1 = LXLGUT(NOEUD)
            CALL UTMESS('F','RFRCHA','LE NOEUD "'//NOEUD(1:LG1)//
     &                  '" N''EXISTE PAS.')
          ELSE IF (IDDL.EQ.0) THEN
            LG1 = LXLGUT(NOEUD)
            LG2 = LXLGUT(CMP)
            CALL UTMESS('F','RFRCHA','LA COMPOSANTE "'//CMP(1:LG2)//
     &        '" '//'DU NOEUD "'//NOEUD(1:LG1)//'" N''EXISTE PAS.')
          END IF
          CALL JEVEUO(CHAM19//'.VALE','L',LVALE)
          CALL FOCSTE(NOMFON,NOMACC(09:12),ZR(LVALE+IDDL-1),'G')
          GO TO 10
        ELSE IF (TYPCHA(1:9).EQ.'CHAM_ELEM') THEN
C     -----------------------------------
C ---  VERIFICATION DE LA PRESENCE DES MOTS CLE GROUP_MA (OU MAILLE)
C ---  ET GROUP_NO (OU NOEUD OU POINT) DANS LE CAS D'UN CHAM_ELEM
          IF (NVERI1.EQ.0 .OR. NVERI2.EQ.0) THEN
            CALL UTDEBM('F','RFRCHA','POUR UN "NOM_CHAM",
     &              IL FAUT DONNER :')
            CALL UTIMPK('L','   - UNE MAILLE OU UN GROUP_MA',0,K8B)
            CALL UTIMPK('L','   - UN NOEUD OU UN GROUP_NO 
     &            OU UN POINT',0,K8B)
            CALL UTFINM()
          END IF
          IF (NGM.NE.0) THEN
            CALL UTNONO(' ',NOMA,'MAILLE',NOGMA,MAILLE,IRET)
            IF (IRET.EQ.10) THEN
              CALL UTMESS('F','OP0090','LE GROUP_MA : '//NOGMA//
     &                    'N''EXISTE PAS.')
            ELSE IF (IRET.EQ.1) THEN
              CALL UTDEBM('A','RECU_FONCTION',
     &                    'TROP DE MAILLES DANS LE GROUP_MA')
              CALL UTIMPK('L','  MAILLE UTILISEE: ',1,MAILLE)
              CALL UTFINM()
            END IF
          END IF
          IF (NGN.NE.0) THEN
            CALL UTNONO(' ',NOMA,'NOEUD',NOGNO,NOEUD,IRET)
            IF (IRET.EQ.10) THEN
              CALL UTMESS('F','OP0090','LE GROUP_NO : '//NOGNO//
     &                    'N''EXISTE PAS.')
            ELSE IF (IRET.EQ.1) THEN
              CALL UTDEBM('A','RECU_FONCTION',
     &                    'TROP DE NOEUDS DANS LE GROUP_NO')
              CALL UTIMPK('L','  NOEUD UTILISE: ',1,NOEUD)
              CALL UTFINM()
            END IF
          END IF
          CALL DISMOI('F','NOM_GD',CHAM19,'CHAM_ELEM',IBID,NOMGD,IE)
          CALL DISMOI('F','TYPE_SCA',NOMGD,'GRANDEUR',IBID,TYPE,IE)
          IF (TYPE.NE.'R') THEN
            CALL UTMESS('F','RFRCHA',
     &          'ON NE TRAITE QUE LES CHAMPS PAR ELEMENTS DE 
     &           TYPE REEL.' )
          END IF
          CALL UTCMP1(NOMGD,' ',1,CMP,IVARI)
          CALL UTCH19(CHAM19,NOMA,MAILLE,NOEUD,NPOINT,NUSP,
     &                IVARI,CMP,TYPE,VALR,VALC,IRET)
          IF (IRET.EQ.0) THEN
            CALL FOCSTE(NOMFON,NOMACC(11:14),VALR,'G')
          END IF
          GO TO 10
        ELSE
          CALL UTMESS('F','RFRCHA','ON NE TRAITE PAS CE TYPE 
     &                DE CHAMP:'//TYPCHA)
        END IF
      END IF

C     -----------------------------------------------------------------
   10 CONTINUE
      CALL FOATTR(' ',1,NOMFON)
C
C     --- VERIFICATION QU'ON A BIEN CREER UNE FONCTION ---
C         ET REMISE DES ABSCISSES EN ORDRE CROISSANT
      CALL ORDONN(NOMFON,NOMCMD,0)
C 
      CALL TITRE
      IF (NIV.GT.1) CALL FOIMPR(NOMFON,NIV,IFM,0,K8B)

      CALL JEDEMA()
      END
