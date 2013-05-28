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
1 : _(u"""
Expression r�guli�re invalide : %(k2)s

Exception retourn�e :
   %(k1)s
"""),

2 : _(u"""
Le fichier n'a pas �t� ferm� : %(k1)s
"""),

3 : _(u"""
TEST_FICHIER impossible, fichier inexistant : %(k1)s
"""),

4 : _(u"""
    Nom du fichier   : %(k3)s

    Valeurs de r�f�rences :
     - Nombre de valeurs : %(i2)d
     - Somme des valeurs : %(k4)s
     - Somme de contr�le : %(k2)s

    Valeurs du fichier :
     - Nombre de valeurs : %(i1)d
     - Somme des valeurs : %(r1)20.13e
     - Somme de contr�le : %(k1)s
"""),

5 : _(u"""
      Fichier de configuration                    : %(k1)s
      Identifiant pour la mesure des performances : %(k2)s
"""),

7 : _(u"""
La commande '%(k1)s' n'a pas �t� ex�cut�e %(i1)d fois.
"""),

8 : _(u"""
- soit PRECISION contient une seule valeur, et alors, celle-ci sera utilis�e
  pour toutes les machines,
- soit PRECISION contient autant de valeurs qu'il y a de machines.
"""),

9 : _(u"""Les temps de r�f�rence ne sont pas connus pour l'identifiant '%(k1)s'.
On utilise les valeurs de '%(k2)s'.
"""),

10 : _(u"""
Les listes fournies aux mots-cl�s MACHINE et VALE doivent avoir le m�me cardinal.
"""),

}
