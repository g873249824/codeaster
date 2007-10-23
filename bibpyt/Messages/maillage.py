#@ MODIF maillage Messages  DATE 23/10/2007   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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

def _(x) : return x

cata_msg={

1: _("""
   Le nom de groupe num�ro %(i1)d de la famille %(k1)s
   est trop long. Il sera tronqu� � 8 caract�res.
   Le groupe "%(k2)s" est renomm� en "%(k3)s".
"""),

2: _("""
Le nom de groupe num�ro %(i1)d de la famille %(k1)s
est vide.
"""),

3: _("""
Famille %(k1)s :
   Incoh�rence sur les nombres de %(k2)s, il y en a %(i1)d alors
   que la fonction MED en annonce %(i2)d.

Impossible de lire ce fichier. On peut utiliser mdump (utilitaire med)
pour voir si le probl�me vient du fichier MED ou de la lecture dans
Code_Aster.
"""),

4: _("""
La famille %(k1)s n'a ni groupe, ni attribut.
"""),

5: _("""
   Lecture de la famille num�ro %(i1)4d de nom %(k1)s.
"""),

6: _("""
      Groupe num�ro %(i1)6d : %(k1)s
"""),

7: _("""
      Groupe num�ro %(i1)6d : %(k1)s
                renomm� en : %(k2)s
"""),

8: _("""
Vous ne pouvez pas renommer le groupe "%(k1)s" en "%(k2)s"
car "%(k2)s" existe d�j� dans le fichier MED.
"""),

9: _("""
Arret en raison des conflits sur les noms de groupe.
"""),

10: _("""
   Le nom de groupe num�ro %(i1)d de la famille %(k1)s
   est contient des caract�res interdits.
   Le groupe "%(k2)s" est renomm� en "%(k3)s".
"""),

11: _("""
Plus de %(i1)d faces touchent le noeud %(k1)s.

Risque & conseils :
   V�rifier la validit� de votre maillage autour de ce point.
   Dans une grille, un noeud est commun � 12 faces.
"""),

12: _("""
 L'option HEXA20_27 ne traite pas les macros mailles
"""),

13: _("""
 L'option HEXA20_27 ne traite pas les absc_curv
"""),

14: _("""
 Le mot-cle MAILLAGE est obligatoire avec le mot-cle HEXA20_27.
"""),

}

