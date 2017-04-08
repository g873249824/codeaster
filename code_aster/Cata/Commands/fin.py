# coding=utf-8
# ======================================================================
# COPYRIGHT (C) 1991 - 2017  EDF R&D                  WWW.CODE-ASTER.ORG
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
# person_in_charge: j-pierre.lefebvre at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


FIN = FIN_PROC(nom="FIN",
               op=9999,
               repetable='n',
               fr=tr("Fin d'une étude, fin du travail engagé par une des commandes DEBUT ou POURSUITE"),

        # FIN est appelé prématurément en cas d'exception ("SIGUSR1", ArretCPUError,
        # NonConvergenceError..., erreurs <S> ou erreurs <F> récupérées).
        # En cas d'ArretCPUError, on limite au maximum le travail à faire dans FIN.
        # Pour cela, on force certains mots-clés dans Execution/E_JDC.py.
        FORMAT_HDF=SIMP(
            fr=tr("sauvegarde de la base GLOBALE au format HDF"),
            statut='f', typ='TXM', defaut="NON", into=("OUI", "NON",)),
        RETASSAGE=SIMP(
            fr=tr("provoque le retassage de la base GLOBALE"),
            statut='f', typ='TXM', defaut="NON", into=("OUI", "NON",)),
        INFO_RESU=SIMP(
            fr=tr("provoque l'impression des informations sur les structures de données"),
            statut='f', typ='TXM', defaut="OUI", into=("OUI", "NON",)),

        PROC0=SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON") ),

        UNITE=SIMP(
            statut='f', typ=UnitType(), defaut=6, inout='out'),
        # hidden keyword used to ensure that the fortran knows that an error occurred
        # because when an exception is raised, the global status is reset by utmess.
        STATUT=SIMP(
            statut='c', typ='I', defaut=0),
)
