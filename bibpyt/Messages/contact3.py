# coding=utf-8
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
# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

    1 : _(u"""
Formulation continue.
Vous avez activé le frottement de Coulomb (FROTTEMENT='COULOMB') pourtant toutes les zones de contact
portent un coefficient de frottement nul.

Le frottement est donc désactivé.

Conseil : vérifiez que vous avez correctement défini le coefficient de frottement (mot-clé COULOMB) dans chaque zone.
"""),

    2 : _(u"""
La maille < %(k1)s > est de type POI1. C'est impossible dans la méthode continue.
"""),

    3 : _(u"""
  Pour la formulation de contact < %(k1)s > le couple :
  ALGO_CONT : < %(k2)s >
  ALGO_FROT : < %(k3)s >
  n'est pas permis.

  Conseil : consultez la documentation pour connaître les couples autorisés.
"""),

    4 : _(u"""
  Le mot-clef < %(k1)s > doit avoir la même valeur sur toutes les zones
  de contact
"""),


    15 : _(u"""
La direction d'appariement fixe données par le vecteur DIRE_APPA est nulle !
"""),

    16 : _(u"""
Contact méthode continue.
La méthode d'intégration n'est pas 'AUTO', le champ VALE_CONT n'est pas créé.
"""),

    18 : _(u"""
Contact méthode continue.
La direction d'exclusion du frottement fournie pour la zone de contact numéro %(i1)d (%(r1)f,%(r2)f,%(r3)f) est perpendiculaire au plan de contact sur la maille %(k1)s.

Conseil :
   - Vérifiez le vecteur DIRE_EXCL_FROT. Sa projection sur le plan tangent de contact doit exister
     pour indiquer une direction à exclure.

"""),

    19 : _(u"""
La surface maître est fortement facétisée sur %(i1)d noeuds.
A cause des variations brusques de normale d'un noeud à l'autre, vous risquez d'avoir des problèmes de convergence du contact, surtout dans le cas de grands glissements relatifs des deux surfaces,.
Vous pouvez raffiner le maillage, utiliser un maillage quadratique (si c'est possible) ou activer le lissage (LISSAGE='OUI' dans DEFI_CONTACT).

Pour information, voici la liste des noeuds avec l'angle (en degré) mesuré entre la normale nodale et les normales aux éléments:
Noeud      Angle
"""),

    23 : _(u"""
Le vecteur normal est nul au niveau du projeté du point de contact de coordonnées
  (%(r1)f,%(r2)f,%(r3)f)
sur la maille %(k1)s,
Erreur de définition de la maille ou projection difficile. Contactez l'assistance dans ce dernier cas.
"""),

    24 : _(u"""
Le vecteur normal est nul sur la maille %(k1)s,
Erreur de définition de la maille ou projection difficile. Contactez l'assistance dans ce dernier cas.
"""),

    26 : _(u"""
Le vecteur normal est nul au niveau du noeud %(k1)s.
"""),

    27 : _(u"""
Le vecteur normal est nul au niveau de la maille %(k1)s.
"""),

    31 : _(u"""
Les vecteurs tangents sont nuls au niveau quand on projette le noeud esclave
%(k1)s sur la maille %(k2)s
"""),

    32: _(u"""
Le mot-clef DIST_POUT ne fonctionne qu'avec des sections circulaires définies dans AFFE_CARA_ELEM.
 """),

    35 : _(u"""
Les vecteurs tangents sont nuls au niveau quand on projette le noeud esclave
%(k1)s sur la noeud maître %(k2)s
"""),


    37: _(u"""
La section de la poutre n'est pas constante sur l'élément. On prend la moyenne.
 """),


    39: _(u"""
Problème pour récupérer l'épaisseur de la coque pour la maille  %(k1)s
"""),

    40: _(u"""
L'excentricité de la coque pour la maille %(k1)s ne peut pas être traitée
"""),

    41: _(u"""
Problème pour récupérer l'excentricité de la coque pour la maille  %(k1)s
"""),

    43 : _(u"""
La normale que vous avez prédéfinie par (VECT_* = 'VECT_Y') sur la maille %(k1)s n'est pas utilisable en 2D.
Utilisez plutôt VECT_* = 'FIXE'
"""),

    50: _(u"""
Avec l'option VECT_MAIT = 'FIXE', seule l'option NORMALE = 'MAIT' est possible.
"""),

    51: _(u"""
Avec l'option VECT_MAIT = 'VECT_Y', seule l'option NORMALE = 'MAIT' est possible.
"""),

    52: _(u"""
Avec l'option VECT_ESCL = 'FIXE', seule l'option NORMALE = 'ESCL' est possible.
"""),

    53: _(u"""
Avec l'option VECT_ESCL = 'VECT_Y', seule l'option NORMALE = 'ESCL' est possible.
"""),

    54: _(u"""
Le LISSAGE n'est possible qu'avec des normales automatiques VECT_ESCL='AUTO' et/ou VECT_MAIT='AUTO'.
"""),

    54: _(u"""
Le LISSAGE n'est possible qu'avec des normales automatiques VECT_ESCL='AUTO' et/ou VECT_MAIT='AUTO'.
"""),

    60 : _(u"""
La maille %(k1)s est de type 'POI1', elle nécessite l'utilisation de l'option
NORMALE='FIXE' avec une normale non nulle.
"""),

    61 : _(u"""
La maille %(k1)s est de type poutre, elle nécessite la définition d'une base locale.
Utilisez NORMALE='FIXE' ou NORMALE='VECT_Y' dans DEFI_CONTACT.
"""),

    75 : _(u"""
La maille %(k1)s est de type 'POI1', elle ne peut pas être une maille maître.
"""),

    86 : _(u"""
Contact méthode continue.
  -> Il y a convergence forcée sur la boucle des contraintes actives lors du traitement du contact.
  -> Risque & conseil :
     La convergence forcée sur les statuts de contact se déclenche lorsque le problème a du mal à converger.
     Il y a des risques que le problème soit un peu moins bien traité.
     Vérifiez bien que vous n'avez pas d'interpénétration au niveau des zones de contact.
     S'il y a des interpénétrations intempestives, découpez plus finement le pas de temps."""),

    96 : _(u"""
Contact.
    -> Les surfaces en contact ont bougé de plus de 1%% depuis la dernière réactualisation.
       Or vous n'avez pas activé la réactualisation géométrique automatique dans la commande DEFI_CONTACT
       (REAC_GEOM='AUTOMATIQUE') ou bien vous utilisez le mode 'CONTROLE'
    -> Risque & conseil :
       Vos résultats risquent d'être faux, les mailles ne seront peut-être pas correctement appariées
       et des interpénétrations pourraient apparaître.
       Si vous avez volontairement négligé la non-linéarité géométrique de contact (pour des raisons
       de performance), nous vous invitons à vérifier visuellement qu'il n'y a effectivement
       pas d'interpénétrations.
"""),

    98 : _(u"""
Contact et détection de collision.
    Le contact semble "rasant", c'est-à-dire que le jeu est nul mais que la pression de contact est quasiment
    nulle également.
    -> Risque & Conseil :
      La découpe automatique du pas de temps ne sera probablement pas efficace. Si vous constatez de fortes oscillations
      de la vitesse ou du déplacement au point de contact pour cet instant de calcul malgré l'activation du mode de
      traitement automatique de la collision, vous pouvez essayer d'éviter l'instant pour lequel le contact "rasant"
      apparaît de deux manières différentes:
       - changer la discrétisation en temps initiale
       - changer la valeur de SUBD_INST
"""),


}
