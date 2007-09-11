#@ MODIF precalcul Messages  DATE 11/09/2007   AUTEUR DURAND C.DURAND 
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
Le type du parametre CARA_ELEM nomme <%(k1)s> est inconnu
Contactez le support
"""),

2: _("""
Le type du parametre XFEM nomme <%(k1)s> est inconnu
Contactez le support
"""),

11: _("""
Le type de param�tre pour le champ IN de temp�rature est inconnu (ni scalaire, ni fonction mais <%(k1)s>)
Contactez le support
"""),

20: _("""
Le type de calcul du chargement est invalide :  %(k1)s
Contactez le support
"""),

50: _("""
D�passement de la capacit� pour les tableaux de champs d'entr�e de CALCUL
Contactez le support
"""),

51: _("""
On tente d'�craser le param�tre de champ d'entr�e de CALCUL d�j� existant nomm� <%(k1)s>
par un autre param�tre d'entree nomm� <%(k2)s>
Contactez le support
"""),

52: _("""
On tente d'�craser le champ d'entr�e de CALCUL deja existant nomme <%(k1)s> par un autre champ d'entr�e nomme <%(k2)s>
Contactez le support
"""),

60: _("""
Appel � CALCUL
Le nom du param�tre de champ d'entree num�ro %(i1)d est vide.
"""),

61: _("""
Appel � CALCUL
Le champ d'entr�e num�ro %(i1)d est vide.
"""),

62: _("""
Appel � CALCUL. Le nom du param�tre de champ de sortie num�ro %(i1)d est vide.
"""),

63: _("""
Appel � CALCUL. Le champ de sortie num�ro %(i1)d est vide.
"""),


}
