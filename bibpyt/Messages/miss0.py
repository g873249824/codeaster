#@ MODIF miss0 Messages  DATE 04/05/2011   AUTEUR MACOCCO K.MACOCCO 
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
# RESPONSABLE DELMAS J.DELMAS

def _(x) : return x

cata_msg={
1: _("""
Longueur de LFREQ_LISTE incorrecte.
"""),

2: _("""
Longueur de CONTR_LISTE incorrecte.
"""),

3 : _("""
Il faut une et une seule couche avec SUBSTRATUM="OUI".
"""),

4 : _("""
La d�finition de la couche num�ro %(i1)d est incorrecte :
Il y a %(i2)d mat�riaux, or NUME_MATE=%(i3)d.
"""),

5 : _("""
La num�rotation des couches est incorrectes.
"""),

6 : _("""
Erreur lors de la copie de fichier pour MISS :
  source      : %(k1)s
  destination : %(k2)s
"""),

7 : _("""
Erreur lors de la lecture du fichier de r�sultat Aster
� la ligne num�ro %(i1)d.

Message d'erreur :
%(k1)s
"""),

8 : _("""
Les donn�es lues dans le fichier de r�sultat Aster ne sont pas coh�rentes.
La trace ci-dessous doit montrer l'incoh�rence relev�e.

Message d'erreur :
%(k1)s
"""),

9 : _("""
Les abscisses de l'acc�l�rogramme '%(k1)s' doivent �tre � pas constant.
"""),

10 : ("""
Interpolation des acc�l�rogrammes sur l'intervalle : [%(r1).4f, %(r2).4f]
par pas de %(r3).4f, soit %(i1)d instants.
"""),

11 : _("""
Les %(i1)d fr�quences du calcul harmonique sont :
    %(k1)s
"""),

12 : _("""
Plage de fr�quence du calcul harmonique : [%(r1).4f, %(r2).4f]
par pas de %(r3).4f Hz, soit %(i1)d fr�quences.
"""),

13 : _("""
Plage de fr�quence du calcul Miss : [%(r1).4f, %(r2).4f]
par pas de %(r3).4f Hz, soit %(i1)d fr�quences.
"""),

14 : _("""
Les %(i1)d fr�quences du calcul Miss sont :
    %(k1)s
"""),

15 : _("""
L'utilisation de MACRO_MISS_3D est d�conseill�e et maintenant exclue du p�rim�tre
qualifi� de Code_Aster.

Certaines fonctionnalit�s ne sont pas encore disponibles dans CALC_MISS.
Pour celles-ci, il faut encore utiliser MACRO_MISS_3D. Il s'agit :
    - des points de contr�le,
    - des ondes inclin�es,
    - des sources ponctuelles,
    - de l'interaction sol-fluide-structure.
"""),

16 : _("""
Dans le cas pr�sent (MODULE='MISS_IMPE' et ISSF='NON'), CALC_MISS r�pond � votre besoin.
Nous vous conseillons d'utiliser dor�navant CALC_MISS.
"""),

17 : _("""
Fournir une plage de fr�quence (mot-cl� LIST_FREQ) n'est possible que si
TYPE_RESU = 'FICHIER' ou 'HARM_GENE'.
Dans les autres cas, il est n�cessaire d'avoir un pas de fr�quences constant
pour le calcul des FFT.
"""),

}

