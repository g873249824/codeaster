#@ MODIF intemail Messages  DATE 12/07/2010   AUTEUR DESROCHES X.DESROCHES 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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

def _(x) : return x

cata_msg={

1: _("""
 on a un arc ouvert et le "NOEUD_ORIG" n'est pas une extr�mit�
"""),

2: _("""
 le "NOEUD_ORIG" ne fait pas parti du chemin
"""),

3: _("""
 il faut que les angles soient croissants
"""),

4: _("""
 il faut que les angles soient dans l'intervalle [-180,180]
"""),

5: _("""
 il faut un rayon strictement positif !
"""),

6: _("""
 face ill�gale pour une maille de type %(k1)s
"""),

7: _("""
 type de maille non trait�e
"""),

8: _("""
 type d'intersection non trait�: %(k1)s
"""),

9: _("""
 d�tection de deux sommets confondus dans une meme face
"""),

10: _("""
 la commande "INTE_MAIL_2D" suppose que le maillage est plan (z=cste) ce qui n'est pas le cas ici.
 utilisez la commande "INTE_MAIL_3D".
"""),

11: _("""
 aucun segment ne coupe le maillage
"""),

12: _("""
 mot cl� facteur: %(k1)s, occurence num�ro: %(i1)d
 maille inexistante: %(k2)s 
"""),

13: _("""
 mot cl� facteur: %(k1)s, occurence num�ro: %(i1)d
 pr�sence de maille(s) surfacique(s), groupe: %(k2)s 
"""),

14: _("""
 arret sur erreur(s) de donn�es
"""),

15: _("""
 mot cl� facteur: %(k1)s, occurence num�ro: %(i1)d
 pr�sence de maille surfacique: %(k2)s 
"""),

16: _("""
 mot cl� facteur: %(k1)s, occurence num�ro: %(i1)d
 groupe de mailles inexistant: %(k2)s
"""),

17: _("""
 au noeud %(k1)s on ne peut avoir plus de 2 mailles, nombre de mailles: %(i1)d
"""),

18: _("""
 trop de noeuds dans le GROUP_NO: %(k1)s, noeud utilis�: %(k2)s 
"""),

19: _("""
  mot cl� facteur: %(k1)s, occurence num�ro: %(i1)d
  le mot cl� %(k2)s admet pour argument une liste de 2 r�els (a1,a2)
  telle que -180. < a1 <= a2 < 180.
"""),

20: _("""
 mot cl� facteur: %(k1)s, occurence num�ro: %(i1)d
 le centre n'est pas vraiment le centre du cercle
"""),

21: _("""
 la partie %(i1)d de la courbe de nom: %(k1)s ne coupe pas le domaine maille
 non production du concept
"""),

22: _("""
 face inconnue, maille num�ro: %(i1)d  face: %(i2)d 
"""),

23: _("""
 probleme pour trouver l'intersection pour la face %(i1)d de la maille %(i2)d
"""),

24: _("""
 face d�g�n�r�e pour la maille num�ro: %(i1)d face: %(i2)d 
"""),

25: _("""
 segment et face coplanaire, nombre de points: %(i3)d
 probleme pour trouver l'intersection pour la maille num�ro: %(i1)d face: %(i2)d 
"""),

26: _("""
 face d�g�n�r�e pour la maille num�ro: %(i1)d face: %(i2)d arete: %(i3)d 
"""),

27: _("""
 mot cl� facteur: %(k1)s, occurence num�ro: %(i1)d
 origine et extr�mit� confondues � la pr�cision: %(r1)f 
"""),

28: _("""
 l'intersection segment %(k1)s avec le maillage %(k2)s est vide
    origine   : %(r1)f %(r2)f %(r3)f
    extr�mit� : %(r4)f %(r5)f %(r6)f
"""),

29: _("""
 il y chevauchement entre les mailles %(k1)s et %(k2)s 
"""),

30: _("""
 il y a un saut d'abscisse entre les mailles %(k1)s et %(k2)s 
"""),

31: _("""
 le GROUP_NO_ORIG %(k1)s n'existe pas.
"""),

32: _("""
 probleme pour r�cup�rer la grandeur %(k1)s dans la table "CARA_GEOM"
"""),

33: _("""
 occurence %(i1)d de DEFI_SEGMENT : le segment comporte trop de points 
d intersection avec le maillage. Il faut le diviser en %(i2)d segments
"""),

}
