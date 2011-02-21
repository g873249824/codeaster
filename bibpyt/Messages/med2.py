#@ MODIF med2 Messages  DATE 21/02/2011   AUTEUR SELLENET N.SELLENET 
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

cata_msg = {

1 : _("""
  -> Les groupes '%(k1)s' et '%(k2)s'
     ont les m�mes huit premiers caract�res, leur nom court est
     donc '%(k3)s'.
     Comme il n'est pas l�gitime dans le cas g�n�ral que deux
     groupes aux noms initialement diff�rents soient fusionn�s,
     le calcul s'arr�te.
  -> Conseil :
     Dans le cas o� certains des noms de groupes de votre maillage
     sont trop longs, modifiez les pour qu'ils ne d�passent pas
     les 8 caract�res.
"""),

2 : _("""
     '%(k1)s'
"""),

3 : _("""
     Fichier MED introuvable.
"""),

4 : _("""
Le champ '%(k1)s' est d�j� pr�sent
dans le fichier med pour l'instant %(r1)G.
  -> Conseil :
     Vous pouvez soit imprimer le champ dans un autre fichier, soit
     nommer le champ diff�remment.
"""),

5 : _("""
Le champ '%(k1)s' dont vous avez demand� l'impression au format MED
est d�fini sur des �l�ments utilisant la famille de points de Gauss
'%(k2)s'. Or l'impression de cette famille n'est pas possible au
format MED.
  -> Conseil :
     Restreignez l'impression demand�e aux �l�ments ne contenant pas
     la famille de point de Gauss incrimin�e.
"""),

}
