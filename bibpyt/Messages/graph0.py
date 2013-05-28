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

cata_msg = {
 1 : _(u"""'%(k1)s' doit �tre une liste de 2 ou 3 listes de r�els de m�me longueur.
"""),

 2 : _(u"""'%(k1)s' doit �tre une liste de 2 ou 3 cha�nes de caract�res.
"""),

 3 : _(u"""Le format est inconnu : %(k1)s.
"""),

 4 : _(u"""On limite la fen�tre aux abscisses positives.
"""),

 5 : _(u"""On limite la fen�tre aux ordonn�es positives.
"""),

 6 : _(u"""Des erreurs se sont produites :
   %(k1)s
"""),

 7 : _(u"""La variable DISPLAY n'est pas d�finie.
"""),

 8 : _(u"""On fixe la variable DISPLAY � %(k1)s.
"""),

 9 : _(u"""Erreur lors de l'utilisation du filtre '%(k1)s'.
Le fichier retourn� est le fichier au format texte de xmgrace.
"""),

10 : _(u"""
   <I> Informations sur le fichier '%(k1)s' :
      Nombre de courbes    : %(i1)3d
      Bornes des abscisses : [ %(r1)13.6G , %(r2)13.6G ]
      Bornes des ordonn�es : [ %(r3)13.6G , %(r4)13.6G ]
"""),

11 : _(u"""
   Le fichier '%(k1)s' ne semble pas �tre au format texte de xmgrace.
   On ne peut donc pas recalculer les valeurs extr�mes.
   Le pilote ne permet probablement pas d'imprimer plusieurs
   graphiques dans le m�me fichier.

Conseil :
   N'utilisez pas le mot-cl� PILOTE et produisez l'image en
   utilisant xmgrace.
"""),

}
