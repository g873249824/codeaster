# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

    1 : _("""
   Arrêt par manque de temps CPU pendant les itérations de Newton, au numéro d'instant < %(i1)d >
      - Temps moyen par itération de Newton : %(r1)f
      - Temps restant                       : %(r2)f
   La base globale est sauvegardée. Elle contient les pas archivés avant l'arrêt.

   Conseil :
      - Augmentez le temps CPU.
"""),

    2 : _("""
   Arrêt par manque de temps CPU au numéro d'instant < %(i1)d >
      - Temps moyen par pas de temps        : %(r1)f
      - Temps restant                       : %(r2)f
   La base globale est sauvegardée. Elle contient les pas archivés avant l'arrêt.

   Conseil :
      - Augmentez le temps CPU.
"""),

    3 : _("""
   Arrêt suite à l'échec de l'intégration de la loi de comportement.
   La base globale est sauvegardée. Elle contient les pas archivés avant l'arrêt.

   Conseils :
      - Vérifiez vos paramètres, la cohérence des unités.
      - Essayez d'augmenter ITER_INTE_MAXI, ou de subdiviser le pas de temps localement via ITER_INTE_PAS.
"""),

    4 : _("""
   Arrêt pour cause de matrice non inversible.
   La base globale est sauvegardée. Elle contient les pas archivés avant l'arrêt.

   Conseils :
      - Vérifiez vos conditions aux limites.
      - Vérifiez votre modèle, la cohérence des unités.
      - Si vous faites du contact, il ne faut pas que la structure ne "tienne" que par le contact.

      - Parfois, en parallèle, le critère de détection de singularité de MUMPS est trop pessimiste ! Il reste néanmoins souvent
        possible de faire passer le calcul complet en relaxant ce critère (augmenter de 1 ou 2 la valeur du mot-clé NPREC) ou
        en le débranchant (valeur du mot-clé NPREC=-1) ou en relançant le calcul sur moins de processeurs.
"""),

    5 : _("""
   Arrêt pour cause d'échec lors du traitement du contact discret.
   La base globale est sauvegardée. Elle contient les pas archivés avant l'arrêt.
"""),

    6 : _("""
   Arrêt pour cause de matrice de contact singulière.
   La base globale est sauvegardée. Elle contient les pas archivés avant l'arrêt.
"""),

    7 : _("""
   Arrêt pour cause d'absence de convergence avec le nombre d'itérations requis dans l'algorithme non-linéaire de Newton.
   La base globale est sauvegardée. Elle contient les pas archivés avant l'arrêt.

   Conseils :
   - Augmentez ITER_GLOB_MAXI.
   - Réactualisez plus souvent la matrice tangente.
   - Raffinez votre discrétisation temporelle.
   - Essayez d'activer la gestion des événements (découpe du pas de temps par exemple) dans la commande DEFI_LIST_INST.
"""),

    8  : _("""
   Arrêt par échec dans le pilotage.
   La base globale est sauvegardée. Elle contient les pas archivés avant l'arrêt.
"""),

    9  : _("""
   Arrêt par échec dans la boucle de point fixe sur la géométrie.
   La base globale est sauvegardée. Elle contient les pas archivés avant l'arrêt.
"""),

    10  : _("""
   Arrêt par échec dans la boucle de point fixe sur le seuil de frottement.
   La base globale est sauvegardée. Elle contient les pas archivés avant l'arrêt.
"""),

    11  : _("""
   Arrêt par échec dans la boucle de point fixe sur le statut de contact.
   La base globale est sauvegardée. Elle contient les pas archivés avant l'arrêt.
"""),

    12 : _("""
   Arrêt pour cause d'absence de convergence avec le nombre d'itérations requis dans le solveur linéaire itératif.
   La base globale est sauvegardée. Elle contient les pas archivés avant l'arrêt.

   Conseils :
   - Augmentez le nombre maximum d'itérations (NMAX_ITER).
   - Utilisez un préconditionneur plus précis ou changez d'algorithme.
"""),

    50 : _("""Arrêt par échec de l'action <%(k1)s>  pour le traitement de l'évènement <%(k2)s>. """),
    51 : _("""Arrêt demandé pour le déclenchement de l'évènement <%(k1)s>. """),

    60 : _("""
   Les forces de contact sont mal définies dans le domaine de Fourier.

   Conseil :
   - Augmenter le nombre d'harmoniques des forces de contact (NB_HARM_NONL).
"""),

    61 : _("""
   Le dernier terme de la série entière est nul. On force le rayon de convergence à 1.
"""),

    62 : _("""
   Correction échouée !!!
"""),

    63 : _("""
   Le nombre d'harmoniques des forces de contact doit être supérieur ou égale au nombre d'harmoniques des autres variables.
   NB_HARM_NONL >= NB_HARM_LINE
"""),

    64 : _("""
   -----------------------------------------------------------------------
   ||    Erreur absolue   ||    Erreur relative  || Max. coefficient   ||
   -----------------------------------------------------------------------
   || %(r1)19.8e || %(r2)19.8e || %(r3)19.8e ||
   -----------------------------------------------------------------------
"""),

    65 : _("""
   La solution périodique est stable
"""),

    66 : _("""
   La solution périodique est instable
"""),

    67 : _("""
                         Numéro ordre : %(i1)d
"""),

    68 : _("""Le mot-clé GROUP_NO du mot-clé facteur CHOC ne doit contenir qu'un noeud."""),

}
