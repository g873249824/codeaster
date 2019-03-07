# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

# person_in_charge: josselin.delmas at edf.fr

cata_msg = {
    1 : _("""%(i2)4d alarme a été émise sur le processeur #%(i1)d.
"""),

    2 : _("""%(i2)4d alarmes ont été émises sur le processeur #%(i1)d.
"""),





    5: _("""
 Erreur lors de l'appel à une fonction MPI.
 Les détails de l'erreur devraient être affichés ci-dessus.
"""),

    6: _("""
 Problème lié a la distribution parallèle de calculs au sein d'une macro-commande.
 Le paramètre %(k1)s=%(i1)d est incohérent.

 Conseil:
 =======
   * Contacter l'équipe de développement.
"""),

    8: _("""
 Problème lié a la distribution parallèle de calculs au sein d'une macro-commande.
 Parmi les paramètres suivants, au moins un est incohérent.
     - %(k1)s=%(i1)d,
     - %(k2)s=%(i2)d,
     - %(k3)s=%(i3)d.

 Conseil:
 =======
   * Contacter l'équipe de développement.
"""),

    80 : _("""  Le processeur #0 demande d'interrompre l'exécution."""),

    81 : _("""  On demande au processeur #%(i1)d de s'arrêter ou de lever une exception."""),

    82 : _("""  On signale au processeur #0 qu'une erreur s'est produite."""),

    83 : _("""  Communication de type '%(k1)s' annulée."""),

    84 : _("""  Le processeur #%(i1)d a émis un message d'erreur."""),


    92 : _("""  On signale au processeur #0 qu'une exception a été levée."""),

    94 : _("""
    Il n'y a plus de temps pour continuer.
    Le calcul sera interrompu à la fin de la prochaine itération, du prochain
    pas de temps ou de la prochaine commande, ou bien brutalement par le système.

    On accorde un délai de %(r1).0f secondes pour la prochaine communication.

    Conseil :
        Augmentez la limite en temps du calcul.
"""),

    95 : _("""
    Tous les processeurs sont synchronisés.
    Suite à une erreur sur un processeur, l'exécution est interrompue.
"""),

    96 : _("""
  Le processeur #%(i1)d n'a pas répondu dans le délai imparti.
"""),

    97 : _("""
    Le délai d'expiration de la communication est dépassé.
    Cela signifie que le processeur #0 attend depuis plus de %(r1).0f secondes,
    ce qui n'est pas normal.
"""),

    99 : { 'message' : _("""

    Au moins un processeur n'est pas en mesure de participer à la communication.
    L'exécution est donc interrompue.

"""), 'flags' : 'DECORATED',
           },

}
