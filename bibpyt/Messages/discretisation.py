#@ MODIF discretisation Messages  DATE 01/09/2008   AUTEUR DURAND C.DURAND 
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

def _(x) : return x

cata_msg = {

1 : _("""
Certains pas de temps de la liste (LISTE_INST) sont plus petits
 que le pas de temps minimal renseign� (SUBD_PAS_MINI)
"""),

2 : _("""
 il faut donner SUBD_NIVEAU et/ou SUBD_PAS_MINI
"""),

3 : _("""
 le nombre de subdivisions du pas de temps doit etre plus grand que 1 (SUBD_PAS)
"""),

6 : _("""
 valeur de SUBD_ITER_IGNO incoherent avec ITER_GLOB_MAXI.
 augmentez ITER_GLOB_MAXI
"""),

7 : _("""
 valeur de SUBD_ITER_FIN incoherent avec ITER_GLOB_MAXI.
 augmentez ITER_GLOB_MAXI
"""),

8 : _("""
 Vous faites un calcul de thermique sans r�solution stationnaire et sans
 non plus de r�solution transitoire.

 Conseils :
   Renseignez la discr�tisation temporelle par le mot cl� INCREMENT
"""),

86 : _("""
Il n'y a aucun pas de calcul temporel.
En m�canique, 'LIST_INST' est absent.
En thermique, 'LIST_INST' est absent ou un singleton.
"""),

87 : _("""
La liste d'instants n'est pas croissante.
"""),

88 : _("""
Vous tentez d'acc�der � l'instant initial ou final, alors que vous
n'avez pas une �volution ordonn�e (EVOLUTION='SANS')
"""),

89 : _("""
Instant initial introuvable dans la liste d'instants (LIST_INST).
"""),

90 : _("""
Instant final introuvable dans la liste d'instants (LIST_INST).
"""),

91 : _("""
 NUME_INST_INIT plus petit que NUME_INST_FIN avec EVOLUTION: 'RETROGRADE'
"""),

92 : _("""
 NUME_INST_INIT plus grand que NUME_INST_FIN
"""),

93: _("""
 NUME_INST_INIT n'appartient pas � la liste d'instants
"""),

94 : _("""
  -> Le num�ro d'ordre correspondant � l'instant final de calcul NUME_INST_FIN
     n'appartient pas � la liste des num�ros d'ordre.
     Dans ce cas, Aster consid�re pour num�ro d'ordre final, le dernier de
     la liste fournie.
  -> Risque & Conseil :
     Afin d'�viter des pertes de r�sultats, assurez-vous que le num�ro d'ordre
     associ� � l'instant NUME_INST_FIN appartienne bien � la liste des num�ros
     d'ordre.
"""),

99 : _("""
Le nombre de niveau de subdivisions doit etre plus grand que 1 (SUBD_NIVEAU)
"""),

}
