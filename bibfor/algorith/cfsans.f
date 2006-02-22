      SUBROUTINE CFSANS(DEFICO,RESOCO,NOMA,JCNSVR)


C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/02/2006   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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

      IMPLICIT     NONE

      CHARACTER*24 DEFICO
      CHARACTER*24 RESOCO

      CHARACTER*8  NOMA
      INTEGER      JCNSVR

C
C ======================================================================
C ROUTINE APPELEE PAR : CFRESU
C ======================================================================
C
C TRAITEMENT DU CAS DE CONTACT SANS CALCUL:
C  AFFICHAGE DES INTERPENETRATIONS ET ARRET OU ALARME
C
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  NOMA   : NOM DU MAILLAGE
C IN  JCNSVR : POINTEUR CHAM_NO_S POUR L'ARCHIVAGE DU CONTACT
C
C ------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32 JEXNUM
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
C --------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------
C 
      INTEGER      ZTOLE
      PARAMETER    (ZTOLE=6)
      INTEGER      ZCONV
      PARAMETER    (ZCONV=4)
      INTEGER      ZAPPAR
      PARAMETER    (ZAPPAR=3)
      INTEGER      ZCMP
      PARAMETER    (ZCMP=19)

      CHARACTER*24 TOLECO,CONVCO,CONTNO,CONTMA,APPARI
      INTEGER      JTOLE,JCONV,JNOCO,JMACO,JAPPAR
      CHARACTER*8  NOMESC,NOMMAI
      INTEGER      POSESC,NUMESC,POSMAI,NUMMAI
      INTEGER      IZONE,INTERP
      INTEGER      NESCL,NBLIAI,ILIAI
      INTEGER      IFM,NIV
      LOGICAL      ARRET
      REAL*8       JEU,JEUREF
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)

      IZONE = 1

C ======================================================================
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C ======================================================================
      TOLECO = DEFICO(1:16)//'.TOLECO'
      CONVCO = DEFICO(1:16)//'.CONVCO'
      APPARI = RESOCO(1:14)//'.APPARI'
      CONTNO = DEFICO(1:16)//'.NOEUCO'
      CONTMA = DEFICO(1:16)//'.MAILCO'
C ======================================================================
      CALL JEVEUO(TOLECO,'L',JTOLE)
      CALL JEVEUO(CONVCO,'L',JCONV)
      CALL JEVEUO(APPARI,'L',JAPPAR)
      CALL JEVEUO(CONTNO,'L',JNOCO )
      CALL JEVEUO(CONTMA,'L',JMACO )


C -- ALARME OU ERREUR ?
      IF (ZI(JCONV+ZCONV*(IZONE-1)+3).EQ.1) THEN
        ARRET = .TRUE.
      ELSE
        ARRET = .FALSE.
      ENDIF
C --- JEU MINIMUM POUR DECLARER INTERPENETRATION
      JEUREF = ZR(JTOLE+ZTOLE*(IZONE-1)+3)

      NESCL  = ZI(JAPPAR)
      NBLIAI = NESCL
      INTERP = 0

      DO 120 ILIAI = 1,NBLIAI
C
C --- RECHERCHE CONNECTIVITE
C
        POSESC = ZI(JAPPAR+ZAPPAR*(ILIAI-1)+1)
        NUMESC = ZI(JNOCO+POSESC-1)

        CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMESC),NOMESC)
        POSMAI = ZI(JAPPAR+ZAPPAR*(ILIAI-1)+2)
C
C --- PREPARATION DES CHAINES POUR LES NOMS
C
        IF (POSMAI.GT.0) THEN
          NUMMAI = ZI(JMACO+POSMAI-1)
          CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMMAI),NOMMAI)
        ELSE IF (POSMAI.LT.0) THEN   
          NUMMAI = ZI(JNOCO+ABS(POSMAI)-1)
          CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMMAI),NOMMAI)
        END IF
C
C --- VALEUR DU JEU
C 
        JEU = ZR(JCNSVR-1+ (NUMESC-1)*ZCMP+2 )
        IF (NIV.GE.2) THEN
          WRITE (IFM,2001) ' DU  NOEUD <',NOMESC,'> AVEC <',NOMMAI,
     &                     '> * JEU:',JEU
        ENDIF
        IF (JEU.LT.JEUREF) THEN
          INTERP = INTERP+1
          WRITE (IFM,2001) ' DU  NOEUD <',NOMESC,'> AVEC <',NOMMAI,
     &                     '> * JEU:',JEU

        ENDIF

 120  CONTINUE 

      IF (INTERP.GE.1) THEN
        WRITE (IFM,3000) INTERP,JEUREF
        IF (ARRET) THEN
          CALL UTMESS('F','CFSANS','INTERPENETRATIONS DES SURFACES')
        ELSE
          CALL UTMESS('A','CFSANS','INTERPENETRATIONS DES SURFACES')
        ENDIF
      ENDIF

2001  FORMAT (' <CONTACT>   * INTERPENETRATION ',A12,A8,A8,A8,
     &        A8,1PE12.5)
2000  FORMAT (' <CONTACT>   * LIAISON LIBRE    ',A12,A8,A8,A8,
     &        A8,1PE12.5)
3000  FORMAT (' <CONTACT>   * IL Y A ',I6,
     &        ' NOEUDS INTERPENETRES (JEU REF.: ',1PE12.5,')')
C
C ----------------------------------------------------------------------
C
      CALL JEDEMA()

      END
