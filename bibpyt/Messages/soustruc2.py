#@ MODIF soustruc2 Messages  DATE 09/06/2009   AUTEUR REZETTE C.REZETTE 
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

cata_msg={
1: _("""
  !!! mode no : %(i1)d 
    lineairement dependant a def. statiqueval sing min :  %(r1)f 
    !! nous la forcons a :  %(r2)f 
"""),

2: _("""
  pour le mode no : %(i1)d participation :  %(r1)f 
"""),

3: _("""
 
"""),

4: _("""
 mot-clef "AMOR_MECA" interdit :
 il est deja calcule.
"""),

5: _("""
 mot-clef "AMOR_MECA" interdit :
 le resultat :  %(k1)s  existe deja.
"""),

6: _("""
 -> Utilisation d'une fonctionnalit� qui va disparaitre (APPUI_LACHE)
 -> Risque & Conseil:
    Utilisez  CREA_GROUP_MA / OPTION = 'APPUI', TYPE_APPUI='AU_MOINS_UN'.
"""),


7: _("""
 -> Le groupe de mailles %(k1)s est vide. On ne le cr�e donc pas !
 -> Risque & Conseil:
    Veuillez vous assurer que le type de mailles souhait� soit coh�rant
    avec votre maillage.
"""),


}
