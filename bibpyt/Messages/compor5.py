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
On ne trouve pas la courbe de traction (mot-clef %(k1)s) dans le matériau fourni.
"""),

    2 : _(u"""
La courbe de traction est une fonction du paramètre %(k1)s alors qu'on attend le paramètre EPSI.
"""),

    4 : _(u"""
La courbe de traction est une nappe dont le paramètre qui n'est pas EPSI n'est pas traité dans la loi de comportement.
"""),

    5 : _(u"""
La courbe de traction est une nappe qui dépend de %(k1)s mais la variable de commande est absente ou mal définie dans le matériau (AFFE_VARC).
"""),

    6 : _(u"""
On ne peut pas calculer de déformation thermique pour les matériaux de type ELAS_HYPER.
"""),

    8 : _(u"""
Erreur utilisateur :
  Sur la maille %(k1)s le calcul est thermo mécanique. Mais il manque la température de référence.
  On ne peut donc pas calculer de déformation thermique.
"""),

    9 : _(u"""
  Sur la maille %(k1)s le calcul est thermo-mécanique mais non isotrope.
  Le comportement ou l'élément concerné ne savent pas gérer ce cas.
"""),

    10 : _(u"""
  Sur la maille %(k1)s le calcul est thermo-mécanique de type métallurgique (avec deux coefficients de dilatation).
  Le comportement ou l'élément concerné ne savent pas gérer ce cas.
"""),

    11 : _(u"""
  Sur la maille %(k1)s le matériau est de type métallurgique (ELAS_META).
  L'option %(k2)s que l'on cherche à calculer n'est pas possible.
  NB: si vous calculer une déformation partielle comme EPSP_ELGA, il est nécessaire de calculer la 
contribution thermique EPVC_ELGA.
"""),

    12 : _(u"""
Problème lors du calcul des déformations hydriques (retrait endogène).
Il manque la définition du coefficient B_ENDOGE dans DEFI_MATERIAU.
La déformation est supposée nulle.
"""),

    13 : _(u"""
Problème lors du calcul des déformations dues à la pression du fluide.
Il manque la définition du coefficient BIOT_COEF dans DEFI_MATERIAU.
La déformation est supposée nulle.
"""),

    15 : _(u"""
 La nature du matériau élastique %(k1)s n'est pas traitée.
"""),

    20: _(u"""
 Sur certaines mailles, la modélisation est incompatible avec le comportement. Pour modéliser
 des contraintes planes (ou des coques) ou des contraintes 1D (barres, poutres) avec ce comportement, on a utilisé  DEBORST.
 """),

    21: _(u"""
 Sur certaines mailles, aucun comportement n'est défini. Code_Aster a défini par défaut
  COMPORTEMENT='ELAS', DEFORMATION='PETIT'.
"""),

    22: _(u"""
 Sur certaines mailles, la modélisation est incompatible avec le comportement.
 Une erreur fatale pourrait suivre se message.
"""),

    23: _(u"""
 La modélisation choisie <%(k1)s> sur la maille <%(k2)s> est incompatible avec les déformations <%(k3)s>.
 Utilisez un autre type de déformations (cf. U4.51.11 et les documents R).
"""),

    30: _(u"""
  Pour les poutres multifibres, l'utilisation de lois de comportement via
  DEBORST nécessite d'avoir un seul matériau par poutre!
 """),
 
    32 : _(u"""
Sur la maille %(k1)s le calcul est thermo mécanique. Mais il manque le paramètre matériau %(k2)s.
On ne peut donc pas calculer la déformation thermique.
"""),

    40 : _(u"""
Les caractéristiques matériaux dans %(k1)s dépendent de la température mais elle n'est pas renseignée.
Il faut une température dans AFFE_MATERIAU/AFFE_VARC.
"""),

    41 : _(u"""
Le paramètre ALPHA a été fourni mais on ne peut pas calculer la déformation thermique car la température n'est pas renseignée.
"""),

    42 : _(u"""
Il existe un champ de température mais vous n'avez pas renseigné la paramètre ALPHA dans DEFI_MATERIAU ou la 
température de référence dans AFFE_MATERIAU/AFFE_VARC.
On ne peut pas calculer la déformation thermique.
"""),

    43 : _(u"""
Il existe un champ de température mais il manque la température de référence dans AFFE_MATERIAU/AFFE_VARC.
"""),

    44 : _(u"""
Il existe un champ de température mais vous n'avez pas renseigné la paramètre ALPHA dans DEFI_MATERIAU.
"""),

    56 : _(u"""
Plusieurs matériaux de type %(k1)s ont été trouvés.
  -> Conseil:
     Vous avez sans doute enrichi votre matériau. Vous ne pouvez pas
     avoir en même temps les mots clés 'ELAS', 'ELAS_FO', 'ELAS_xxx',...
"""),

    57 : _(u"""
Le matériau de type %(k1)s n'a pas été trouvé.
"""),

    59 : _(u"""
La déformation plastique cumulée est négative.
"""),

    60 : _(u"""
Le prolongement à droite étant exclu pour la fonction %(k1)s, il n'est pas possible d'extrapoler la fonction R(p) au delà de p = %(r1)f
"""),



}
