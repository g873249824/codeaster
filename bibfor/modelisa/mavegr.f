      SUBROUTINE MAVEGR ( NOMU )
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8         NOMU
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C
C     SUPPRESSION DES GROUPES DE NOEUDS OU MAILLES DE NOM '      '
C ----------------------------------------------------------------------
C
      INTEGER       IRET, I, J, NBGRMA, NBGRMT, NBGRNO, NBGRNT, NBMA,
     &              NBNO, JVG, JGG
      CHARACTER*8   K8B, NOMG, BLANC
      CHARACTER*24  GRPNOE, GRPNOV, GRPMAI, GRPMAV
C ----------------------------------------------------------------------
      CALL JEMARQ()
C
      GRPNOE =   NOMU//'.GROUPENO'
      GRPNOV = '&&MAVEGR.GROUPENO'
      GRPMAI =   NOMU//'.GROUPEMA'
      GRPMAV = '&&MAVEGR.GROUPEMA'
      BLANC  = '        '
C
C --- TRAITEMENT DES GROUP_MA
C
      CALL JEEXIN ( GRPMAI, IRET )
      IF (IRET.GT.0) THEN
         CALL JELIRA ( GRPMAI, 'NMAXOC', NBGRMA, K8B )
         NBGRMT = NBGRMA
         DO 100 I = 1 , NBGRMA
            CALL JEEXIN ( JEXNUM ( GRPMAI, I ), IRET )
            IF (IRET.EQ.0) GOTO 100
            CALL JENUNO ( JEXNUM ( GRPMAI, I ), NOMG )
            IF ( NOMG .EQ. BLANC ) THEN
               NBGRMT = NBGRMT - 1
               CALL U2MESS('A','MODELISA5_36')
            ENDIF
 100     CONTINUE
         IF ( NBGRMT .EQ. 0 ) THEN
            CALL JEDETR ( GRPMAI )
         ELSEIF ( NBGRMT .NE. NBGRMA ) THEN
            CALL JEDUPO ( GRPMAI, 'V', GRPMAV, .FALSE. )
            CALL JEDETR ( GRPMAI )
            CALL JECREC ( GRPMAI, 'G V I', 'NOM', 'DISPERSE',
     &                                     'VARIABLE', NBGRMT )
            DO 110 I = 1 , NBGRMA
               CALL JEEXIN ( JEXNUM ( GRPMAV, I ), IRET )
               IF (IRET.EQ.0) GOTO 110
               CALL JENUNO ( JEXNUM ( GRPMAV, I ), NOMG )
               IF ( NOMG .EQ. BLANC ) GOTO 110
               CALL JECROC ( JEXNOM ( GRPMAI, NOMG ) )
               CALL JEVEUO ( JEXNUM(GRPMAV,I), 'L', JVG )
               CALL JELIRA ( JEXNUM(GRPMAV,I), 'LONUTI', NBMA, K8B )
               CALL JEECRA ( JEXNOM(GRPMAI,NOMG), 'LONMAX',
     &        MAX(1,NBMA), ' ' )
               CALL JEECRA ( JEXNOM(GRPMAI,NOMG), 'LONUTI', NBMA, ' ' )
               CALL JEVEUO ( JEXNOM(GRPMAI,NOMG), 'E', JGG )
               DO 112 J = 0, NBMA-1
                  ZI(JGG+J) = ZI(JVG+J)
  112          CONTINUE
  110       CONTINUE
            CALL JEDETR ( GRPMAV )
         ENDIF
      END IF
C
C --- TRAITEMENT DES GROUP_NO
C
      CALL JEEXIN ( GRPNOE, IRET )
      IF (IRET.GT.0) THEN
         CALL JELIRA ( GRPNOE, 'NMAXOC', NBGRNO, K8B )
         NBGRNT = NBGRNO
         DO 200 I = 1 , NBGRNO
            CALL JEEXIN ( JEXNUM ( GRPNOE, I ), IRET )
            IF (IRET.EQ.0) GOTO 200
            CALL JENUNO ( JEXNUM ( GRPNOE, I ), NOMG )
            IF ( NOMG .EQ. BLANC ) THEN
               NBGRNT = NBGRNT - 1
               CALL U2MESS('A','MODELISA5_37')
            ENDIF
 200     CONTINUE
         IF ( NBGRNT .EQ. 0 ) THEN
            CALL JEDETR ( GRPNOE )
         ELSEIF ( NBGRNT .NE. NBGRNO ) THEN
            CALL JEDUPO ( GRPNOE, 'V', GRPNOV, .FALSE. )
            CALL JEDETR ( GRPNOE )
            CALL JECREC ( GRPNOE, 'G V I', 'NOM', 'DISPERSE',
     &                                     'VARIABLE', NBGRNT )
            DO 210 I = 1 , NBGRNO
               CALL JEEXIN ( JEXNUM ( GRPNOV, I ), IRET )
               IF (IRET.EQ.0) GOTO 210
               CALL JENUNO ( JEXNUM ( GRPNOV, I ), NOMG )
               IF ( NOMG .EQ. BLANC ) GOTO 210
               CALL JECROC ( JEXNOM ( GRPNOE, NOMG ) )
               CALL JEVEUO ( JEXNUM(GRPNOV,I), 'L', JVG )
               CALL JELIRA ( JEXNUM(GRPNOV,I), 'LONUTI', NBNO, K8B )
               CALL JEECRA ( JEXNOM(GRPNOE,NOMG), 'LONMAX',
     &        MAX(1,NBNO), ' ' )
               CALL JEECRA ( JEXNOM(GRPNOE,NOMG), 'LONUTI', NBNO, ' ' )
               CALL JEVEUO ( JEXNOM(GRPNOE,NOMG), 'E', JGG )
               DO 212 J = 0, NBNO-1
                  ZI(JGG+J) = ZI(JVG+J)
  212          CONTINUE
  210       CONTINUE
            CALL JEDETR ( GRPNOV )
         ENDIF
      END IF
C
      CALL JEDEMA()
C
      END
