#@ MODIF observation Messages  DATE 19/12/2007   AUTEUR ABBAS M.ABBAS 
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
 l'entit�  %(k1)s  n'est pas possible  %(k2)s 
"""),

2 : _("""
 erreur dans les donn�es  d'observation
 le noeud  %(k1)s n'existe pas dans  %(k2)s 
"""),

3 : _("""
 erreur dans les donn�es d'observation
 le GROUP_NO  %(k1)s n'existe pas dans  %(k2)s 
"""),

4 : _("""
 erreur dans les donn�es d'observation
 la maille  %(k1)s n'existe pas dans  %(k2)s 
"""),

5 : _("""
 erreur dans les donn�es d'observation
 le GROUP_MA  %(k1)s n'existe pas dans  %(k2)s 
"""),

6 : _("""
 erreur dans les donn�es d'observation
 pour "NOM_CHAM"  %(k1)s , il faut renseigner  %(k2)s ou  %(k3)s 
"""),

7 : _("""
 erreur dans les donn�es d'observation
 pour "NOM_CHAM"  %(k1)s , il faut renseigner  %(k2)s et  %(k3)s 
"""),

45 : _("""
 le champ absolu n'est accessible qu'en pr�sence de modes statiques
"""),

49 : _("""
 il faut definir "LIST_ARCH" ou "LIST_INST" ou "INST" ou "PAS_OBSE"
 au premier mot cle facteur "OBSERVATION"
"""),

50 : _("""
 seule la valeur de "LIST_ARCH" ou "LIST_INST" ou "INST" ou "PAS_OBSE"
 du premier mot cle facteur "OBSERVATION" est prise en compte
"""),

79 : _("""
 DDL inconnu sur le noeud ou la maille specifi�e pour le suivi
"""),

85 : _("""
Le nombre de SUIVI_DDL est limit� � 4.
"""),

86 : _("""
M�lange de champs de nature diff�rente dans le meme mot-cl� facteur SUIVI.
"""),

87 : _("""
M�lange de champs de nature diff�rente dans le meme mot-cl� facteur OBSERVATION
"""),

99: _("""
 le champ %(k1)s est incompatible avec la commande  %(k2)s
"""),

}
