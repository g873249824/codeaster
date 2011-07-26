#@ MODIF mecanonline7 Messages  DATE 26/07/2011   AUTEUR ABBAS M.ABBAS 
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

def _(x) : return x

cata_msg = {

1 : _("""
  Temps CPU consomm� dans ce pas de temps: %(k1)s.
"""),

2 : _("""
    * Temps moyen par it�ration de Newton : %(k1)s ( %(i1)d it�rations     )
"""),

3 : _("""
    * Temps total factorisation matrice   : %(k1)s ( %(i1)d factorisations )
"""),

4 : _("""
    * Temps total int�gration LDC         : %(k1)s ( %(i1)d int�grations   )
"""),

5 : _("""
    * Temps total r�solution K.U=F        : %(k1)s ( %(i1)d r�solutions    )
"""),

6 : _("""
    * Temps autres op�rations             : %(k1)s
"""),

7 : _("""
    * Temps post-traitement (flambement)  : %(k1)s
"""),

8 : _("""
    * Nombre d'it�rations de recherche lin�aire   : %(i1)d 
"""),

9 : _("""
    * Nombre d'it�rations du solveur FETI         : %(i1)d 
"""),

10 : _("""
    * Temps r�solution contact            : %(k1)s ( %(i1)d it�rations     )
"""),

11 : _("""
    * Temps appariement contact           : %(k1)s ( %(i1)d appariements   )
"""),

12 : _("""
    * Temps construction second membre    : %(k1)s
"""),

13 : _("""
    * Temps assemblage matrice            : %(k1)s
"""),

20 : _("""
    * Temps construction matrices contact : %(k1)s ( %(i1)d constructions  )
"""),

22 : _("""
    * Temps frottement                    : %(k1)s ( %(i1)d boucles        )
"""),

23 : _("""
    * Temps contact                       : %(k1)s ( %(i1)d boucles        )
"""),

24 : _("""
    * Temps pr�paration donn�es contact   : %(k1)s ( %(i1)d pr�parations   )
"""),

30 :_("""
  Statistiques du contact dans ce pas de temps.
"""),

31 : _("""
    * Nombre de liaisons de contact       : %(i1)d 
"""),

32 : _("""
    * Nombre de liaisons de frottement    : %(i1)d 
"""),

}
