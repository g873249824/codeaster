# ======================================================================
# COPYRIGHT (C) 1991 - 2015  EDF R&D                  WWW.CODE-ASTER.ORG
# THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
# IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
# THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
# (AT YOUR OPTION) ANY LATER VERSION.
#
# THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
# WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
# GENERAL PUBLIC LICENSE FOR MORE DETAILS.
#
# YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
# ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
#    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
# ======================================================================
# person_in_charge: mathieu.courtois at edf.fr

TEST_TEMPS=MACRO(nom="TEST_TEMPS",
                 op=OPS('Macro.test_temps_ops.test_temps_ops'),
                 sd_prod=None,
                 UIinfo={"groupes":("Utilitaires",)},
                 fr=tr("Permet de vérifier le temps passé dans les commandes"),
                 reentrant='n',

   RESU = FACT(statut='o',max='**',
      COMMANDE   = SIMP(statut='o', typ='TXM',
            fr=tr("Nom de la commande testee")),
      NUME_ORDRE = SIMP(statut='f', typ='I', defaut=1, val_min=1,
            fr=tr("Numero de l'occurrence de la commande testee")),
      MACHINE    = SIMP(statut='o', typ='TXM', max='**',
            fr=tr("Liste des machines dont on a la référence")),
      VALE       = SIMP(statut='o', typ='R', max='**',
            fr=tr("Temps CPU sur les machines listees en secondes")),
      CRITERE    = SIMP(statut='f', typ='TXM', defaut='RELATIF', into=('ABSOLU', 'RELATIF')),
      PRECISION  = SIMP(statut='f', typ='R', defaut=0.01, max='**',
            fr=tr("Ecart admissible pour chaque machine")),
      TYPE_TEST  = SIMP(statut='o', typ='TXM', into=('USER', 'SYSTEM', 'USER+SYS', 'ELAPSED'),
            defaut='USER+SYS',
            fr=tr("Valeur testee parmi 'USER', 'SYSTEM', 'USER+SYS', 'ELAPSED'")),
   ),

   INFO  = SIMP(statut='f',typ='I',defaut=1,into=(1,2) ),
)
