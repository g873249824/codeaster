# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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

cata_msg={

1: _(u"""
  Erreur dans les donn�es
  le param�tre %(k1)s n'existe pas dans la table %(k2)s
"""),

2: _(u"""
  Erreur dans les donn�es
  pas de tri sur les complexes
  param�tre:  %(k1)s
"""),

3: _(u"""
  Erreur dans les donn�es
  on n'a pas trouv� de ligne dans la table %(k1)s pour le param�tre %(k2)s
"""),

4: _(u"""
  Le num�ro d'occurrence est invalide %(i1)d pour le mot cl� facteur %(k1)s
"""),

5: _(u"""
  Le num�ro de la composante (pour VARI_R) est trop grand.
    MAILLE           : %(k1)s
    NUME_MAXI        : %(i1)d
    NUME_CMP demand� : %(i2)d
"""),


9: _(u"""
 Si on utilise l'option normale pour les changements de rep�re, il faut donner
 une �quation suppl�mentaire avec le mot-cl� VECT_X ou VECT_Y
 """),

11: _(u"""
  Erreur dans les donn�es, probl�me lors du traitement du mot cl� facteur FILTRE

  -> Risque & Conseil :
   soit le param�tre n'existe pas
   soit aucune ligne ne correspond au param�tre donn�
"""),

12: _(u"""
  Erreur utilisateur dans la commande POST_ELEM/INTEGRALE :
    Pour le champ %(k1)s,
    Sur les mailles s�lectionn�es %(k2)s,
    On n'a pas trouv� la composante %(k3)s

  Risque & Conseil:
    Veuillez v�rifier que le champ est d�fini sur les mailles du groupe sp�cifi� et
    que les composantes du champ disposent de valeurs. Vous pouvez effectuer un
    IMPR_RESU pour imprimer les valeurs du champ %(k1)s sur les mailles s�lectionn�es.
"""),

13: _(u"""
  Erreur utilisateur dans la commande POST_ELEM/INTEGRALE :
    Le champ %(k1)s est un CHAM_ELEM ELEM,
    Il faut renseigner le mot cl� INTEGRALE / DEJA_INTEGRE= 'OUI' / 'NON'
"""),

14 : _(u"""
  POST_ELEM VOLUMOGRAMME
  Num�ro d'occurrence du mot-cl� VOLUMOGRAMME = %(i1)d
  Num�ro d'ordre                             = %(i2)d
  Volume total concern�                      = %(r1)g
"""),

}
