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
#
# person_in_charge: sylvie.granet at edf.fr

cata_msg = {

1 : _(u"""
Vous cherchez � faire du cha�nage HM avec une mod�lisation Thermo-hydro-m�canique comportant de la m�canique.
Le cha�nage est donc inutile !
"""),

2 : _(u"""
Le champ d'entr�e div(u) est mal construit. Il manque soit l'instant actuel soit l'instant pr�c�dent de div(u).
"""),

3 : _(u"""
Vous n'�tes pas sur une mod�lisation autoris�e pour faire du cha�nage.
Le cha�nage ne fonctionne pas sur la mod�lisation %(k1)s.

Conseil : V�rifiez que votre mod�lisation %(k2)s est sans m�canique
"""),

4 : _(u"""
Vous n'�tes pas sur une mod�lisation autoris�e pour faire du cha�nage.
Le cha�nage ne fonctionne pas sur la mod�lisation %(k1)s.

Conseil : V�rifiez que votre mod�lisation %(k2)s est 'D_PLAN' ou '3D'
ou une mod�lisation THM
"""),

5 : _(u"""
Il n'est pas possible de faire du cha�nage avec un coefficient d'emmagasinement
non nul.
"""),

6 : _(u"""
L'instant %(r1)e sp�cifi� en entr�e doit �tre sup�rieur au dernier
instant trouv� dans la SD r�sultat %(k1)s.
"""),

7 : _(u"""
  Impression du champ %(k1)s � l'instant %(r1)e sur le mod�le %(k2)s
"""),

8 : _(u"""
  Les mod�lisations THM n'ont de sens qu'en petites d�formations.
  Choisissez COMP_INCR/DEFORMATION='PETIT'.
"""),

9 : _(u"""
  Vous n'avez pas choisi une loi de comportement m�canique autoris�e pour les
  mod�lisations THM : %(k1)s
"""),

10 : _(u"""
  Si vous faites du cha�nage, il ne faut qu'un seul et unique mod�le dans le r�sultat. Si vous en voulez plusieurs, faites une demande d'�volution.
"""),

11 : _(u"""
  On a trouv� une �volution de variable de commandes PTOT incompl�te. Il manque un instant.
"""),

}
