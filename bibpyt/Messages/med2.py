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

cata_msg = {

    2 : _("""
     '%(k1)s'
"""),

    3 : _("""
     Fichier MED introuvable.
"""),

    4 : _("""
Le champ '%(k1)s' est déjà présent
dans le fichier MED pour l'instant %(r1)G.
  -> Conseil :
     Vous pouvez soit imprimer le champ dans un autre fichier, soit
     nommer le champ différemment.
"""),

    5 : _("""
Le champ '%(k1)s' dont vous avez demandé l'impression au format MED
est défini sur des éléments utilisant la famille de points de Gauss
'%(k2)s'. Or l'impression de cette famille n'est pas possible au
format MED.
  -> Conseil :
     Restreignez l'impression demandée aux éléments ne contenant pas
     la famille de point de Gauss incriminée.
"""),

    6 : _("""
    Les mots-clés %(k1)s et %(k2)s sont incompatibles.
"""),

    7 : _("""
  Il n'a pas été possible d'imprimer le champ des variables internes en utilisant IMPR_NOM_VARI='OUI'.
  Cela est dû au fait que certains comportements  dans votre modèle ne sont pas imprimables avec cette option:
  - Le comportement a été défini avec MFRONT ou UMAT en mode prototype
  - Le comportement a été défini sur une poutre multifibres

  -> Conseils :
     - N'utilisez pas IMPR_NOM_VARI='OUI' pour imprimer ce champ
"""),

    8 : _("""
  Il n'y a pas de groupe de mailles ou de noeuds dans ce maillage.
"""),

    9 : _("""
  Vous demandez l'impression du champ %(k1)s issu de la commande
  PROJ_CHAMP utilisant la méthode 'SOUS_POINT'.

  Cette impression n'est pas possible au format MED.
"""),

    11 : _("""
  Votre champ repose sur un modèle comportant des éléments joints
  ou interfaces non encore imprimables au format MED.

  Conseil : Pour que cette impression soit possible, il vous faut
            faire une demande d'évolution.
"""),

    12 : _("""
Le modèle contient des éléments de structure. Or le champ  %(k1)s n'a pas la bonne structure pour être imprimé sur ce format.
Il ne faut pas imprimer ce champ ou faire deux IMPR_RESU différents.
"""),

}
