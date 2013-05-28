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

1 : _(u"""
Le champ %(k1)s que l'on veut extraire est de type champ aux noeuds. 
Vous n'avez pas pr�cis� correctement son lieu d'extraction.
Il faut donner une maille, un groupe de mailles, un noeud ou un groupe de noeuds (MAILLE ou GROUP_MA ou NOEUD ou GROUP_NO).
"""),

2 : _(u"""
Le champ %(k1)s que l'on veut extraire est de type champ aux points d'int�gration. 
Vous n'avez pas pr�cis� correctement son lieu d'extraction.
Il faut donner une maille ou un groupe de mailles (MAILLE ou GROUP_MA).
"""),

3 : _(u"""
Le champ %(k1)s que l'on veut extraire est de type champ aux noeuds.
Les noeuds donn�s n'appartiennent pas au mod�le.
"""),

4 : _(u"""
Le champ %(k1)s que l'on veut extraire est de type champ aux points d'int�gration. 
Les mailles donn�s n'appartiennent pas au mod�le.
"""),

5 : _(u"""
Vous n'avez pas pr�cis� le type de l'extraction pour le champ %(k1)s.
On a pris <VALE> par d�faut.
"""),

6 : _(u"""
Le champ %(k1)s que l'on veut extraire est de type champ aux points d'int�gration. 
Vous n'avez pas pr�cis� le type de l'extraction.
On a pris <VALE> par d�faut.
"""),

7 : _(u"""
Le champ %(k1)s pour la maille %(k2)s est de type <ELGA> et vous voulez extraire sa valeur (EXTR_ELGA='VALE'). 
Vous n'avez pas pr�cis� l'endroit o� il est doit �tre extrait.
Il faut donner le point d'int�gration et le SOUS_POINT si c'est un �l�ment de structure (POINT/SOUS_POINT).
"""),

12 : _(u"""
 L'extraction doit se faire sur plus d'une composante et moins de %(i1)d composantes, or vous en avez %(i2)d.
"""),

20 : _(u"""
 La composante %(k2)s est inconnue sur le noeud %(k1)s .
"""),

21 : _(u"""
 La composante %(k2)s sur la maille %(k1)s sur le point d'int�gration %(i1)d et le SOUS_POINT %(k1)s n'existe pas.
"""),

99: _(u"""
 Le champ %(k1)s que l'on veut extraire est incompatible avec la commande ou les fonctionnalit�s actives.
 On l'ignore.
"""),

}
