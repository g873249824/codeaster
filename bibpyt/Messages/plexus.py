#@ MODIF plexus Messages  DATE 09/04/2013   AUTEUR ASSIRE A.ASSIRE 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
# RESPONSABLE DELMAS J.DELMAS

cata_msg = {

1 : _(u"""
Pour que CALC_EUROPLEXUS fonctionne il faut ajouter DEBUG=_F(HIST_ETAPE='OUI')
dans la commande DEBUT.
Remarque : CALC_EUROPLEXUS ne fonctionne pas en POURSUITE"""),

2:  _(u"""Le mot-cl� %(k1)s n'existe pas"""),

3 : _(u"""Le mot-cl� GROUP_MA est obligatoire dans AFFE_MODELE"""),

4 : _(u"""Le type de section de poutre %(k1)s n'est pas encore pris en compte dans le passage vers Europlexus"""),

5 : _(u"""Le type de section de barre %(k1)s n'est pas encore pris en compte dans le passage vers Europlexus"""),

6 : _(u"""La mod�lisation %(k1)s n'est pas disponible dans CALC_EUROPLEXUS"""),

7 : _(u"""Le mot-cl� FONC_MULT est obligatoire pour le chargement de type PRES_REP"""),

8 : _(u"""Le concept EVOL_NOLI %(k1)s ne poss�de pas de mot-cl� CARA_ELEM"""),

9 : _(u"""Il faut avoir au moins un des mots-cl�s DDL_IMPO et PRES_REP dans AFFE_CHAR_MECA"""),

10: _(u"""
Les vecteurs y_local des GROUP_MA %(k1)s
calcul�s � partir des angles nautiques ne sont pas identiques.
Veuillez imposer directement VECT_Y dans AFFE_CARA_ELEM si vous
�tes sur de l'orientation
"""),

11: _(u"""
Les vecteurs y_local des mailles du GROUP_MA %(k1)s
calcul�s � partir des angles nautiques ne sont pas identiques.
Veuillez imposer directement VECT_Y dans AFFE_CARA_ELEM si vous
�tes sur de l'orientation
"""),

12: _(u"""
Le mot-cl� facteur FONC_PARASOL est obligatoire quand le mot-cl� RIGI_PARASOL e
est renseign� dans AFFE_CARA_ELEM
"""),

13: _(u"""
Les d�placements impos�s non nuls dans DDL_IMPO ne sont pas autoris�s
"""),

14 : _(u"""
Le fichier MED contenant les r�sultats d'Europlexus est introuvable.
L'ex�cution d'Europlexus s'est probablement mal d�roul�e
"""),

15 : _(u"""En pr�sence du mot-cl� %(k1)s dans AFFE_CARA_ELEM
le mot-cl� %(k2)s devrait �tre pr�sent dans CALC_EUROPLEXUS.
"""),

16 : _(u"""En pr�sence du mot-cl� %(k1)s dans CALC_EUROPLEXUS
le mot-cl� %(k2)s est obligatoire dans AFFE_CARA_ELEM.
"""),

17 : _(u"""On ne peut pas fournir un �tat initial de contraintes sur les �l�ments POU_D_EM.
"""),

18 : _(u"""Le mot cl� %(k1)s du concept CARA_ELEM n'est pas pris en compte par CALC_EUROPLEXUS'
"""),
19 : _(u"""Le type de charge %(k1)s n'est pas pris en compte par CALC_EUROPLEXUS'
"""),
20 : _(u"""Les groupes de mailles auxquels le mat�riau %(k1)s est affect� n'ont pas tous la m�me relation.
           Voir mot-cl� COMP_INCR.
"""),

21 : _(u"""On ne trouve pas les caract�ristiques �lastiques du mat�riau %(k1)s.
"""),
22 : _(u"""La valeur du mot-cl� RELATION du mat�riau %(k1)s est diff�rente de GLRC_DAMAGE.
"""),
23 : _(u"""On ne trouve pas le mot-cl� BETON dans le mat�riau %(k1)s.
           Ce mot-cl� est indispensable � la loi GLRC_DAMAGE.
"""),

}
