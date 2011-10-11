#@ MODIF adaptation Messages  DATE 10/10/2011   AUTEUR GENIAUT S.GENIAUT 
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

# Pour la m�thode d'adaptation du pas de temps

cata_msg={

1: _("""
  Adaptation du pas de temps.
"""),

2: _("""
    Pour la m�thode d'adaptation de type <%(k1)s>, le pas de temps calcul� vaut <%(r1)E>.
"""),

3: _("""
    Pour la m�thode d'adaptation de type <%(k1)s>, le crit�re n'est pas v�rifi�. Le pas de temps n'est pas adapt�.
"""),

4: _("""
    Aucun crit�re d'adaption n'est v�rifi�. On garde le pas de temps <%(r1)E>.
"""),

5: _("""
    Sur tous les crit�res d'adaptation, le plus petit pas de temps vaut <%(r1)E>.
"""),

6: _("""
    Apr�s ajustement sur les points de passage obligatoires, le plus petit pas de temps vaut <%(r1)E>.
"""),

11 : _("""
    La valeur du pas de temps retenu (%(r1)s) est inf�rieure � PAS_MINI.
"""),

12 : _("""
    La valeur du pas de temps (%(r1)E) est sup�rieure � PAS_MAXI (%(r2)E).
    On limite le pas de temps � PAS_MAXI (%(r2)E).
"""),


13 : _("""
 On a depass� le nombre maximal de pas de temps autoris�.
"""),
}
