#@ MODIF table0 Messages  DATE 09/10/2007   AUTEUR COURTOIS M.COURTOIS 
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
Erreur dans les donn�es. Le param�tre %(k1)s n'existe pas dans la table.
"""),

2 : _("""
Param�tre %(k1)s inexistant dans la table %(k2)s.
"""),

3 : _("""
Op�ration RENOMME. Erreur : %(k1)s
"""),

4 : _("""
Param�tre %(k1)s inexistant dans la table %(k2)s.
"""),

5 : _("""
Param�tre %(k1)s inexistant dans la table %(k2)s.
"""),

6 : _("""
Le fichier %(k1)s existe d�j�, on �crit � la suite.
"""),

7 : _("""
Param�tre absent de la table : %(k1)s.
"""),

8 : _("""
Param�tres absents de la table (ou de NOM_PARA) : %(k1)s.
"""),

10 : _("""
NUME_TABLE=%(i1)d incorrect : il n'y a que %(i2)d blocs de tables dans le fichier.
"""),

11 : _("""
Nombre de champs incorrect ligne %(i1)d.
"""),

12 : _("""
On attend %(i1)d param�tres.
"""),

13 : _("""
On a lu %(i1)d champs dans le fichier.
"""),

}
