# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

# Attention a ne pas faire de retour � la ligne !

cata_msg = {

1 : _(u"""
 On utilise l'op�rateur en enrichissant les r�sultats (REUSE).
 Mais on ne d�finit pas d'�tat initial: on prend un �tat initial nul.
"""),

2 : _(u"""
 On ne trouve aucun num�ro d'ordre dans la structure de donn�es r�sultat de nom <%(k1)s> 
"""),

3 : _(u"""
 L'instant sp�cifi� sous ETAT_INIT/INST n'est pas trouv� dans la structure de donn�es r�sultat de nom <%(k1)s>.
"""),

4 : _(u"""
 Il y a plusieurs instants dans la structure de donn�es r�sultat de nom <%(k1)s> qui correspondent � celui sp�cifi� sous ETAT_INIT/INIT.
"""),

5 : _(u"""
 A l'instant initial, tous les termes du bilan d'�nergie sont nuls bien qu'un �tat initial non vierge soit renseign�. Le bilan d'�nergie indique la variation des diff�rents termes d'�nergie entre deux instants de calcul cons�cutifs ainsi que leur variation totale entre l'instant courant et l'instant initial.
"""),

10 : _(u"""
 Lecture de l'�tat initial
"""),

20 : _(u"""
 Il n'y a pas d'�tat initial d�fini. On prend un �tat initial nul.
"""),

30 : _(u"""
  Le champ %(k1)s n'est pas trouv� dans ETAT_INIT et on ne sait pas l'initialiser � z�ro.
"""),

31 : _(u"""  Le champ <%(k1)s> est initialis� a z�ro"""),

32 : _(u"""  Le champ <%(k1)s> est lu dans ETAT_INIT dans la structure de donn�es r�sultats de nom <%(k2)s>"""),

33 : _(u"""  Le champ <%(k1)s> est lu dans ETAT_INIT, par un champ donn� explicitement"""),

34 : _(u"""  Le champ de temp�rature initiale est calcul� par un �tat stationnaire"""),

35 : _(u"""  Le champ de temp�rature initiale est donn� par une valeur qui vaut %(r1)19.12e"""),

50 : _(u"""
  Le champ <%(k1)s> est d'un type inconnu.
"""),

51 : _(u"""  Le champ <%(k1)s> est de type <%(k2)s> mais on attend un champ de type <%(k3)s>. On le convertit automatiquement"""),

52 : _(u"""
  Le champ <%(k1)s> est de type <%(k2)s> mais on attend un champ de type <%(k3)s>. On ne sait pas le convertir automatiquement
"""),

}
