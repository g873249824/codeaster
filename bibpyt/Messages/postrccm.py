#@ MODIF postrccm Messages  DATE 11/09/2007   AUTEUR DURAND C.DURAND 
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
 le parametre %(k2)s n'existe pas dans la table %(k1)s
"""),

2: _("""
 probleme pour r�cup�rer dans la table %(k1)s la valeur du parametre %(k2)s
   pour le parametre %(k3)s de valeur %(r1)12.5E et
   pour le parametre %(k4)s de valeur %(r2)12.5E
"""),

3: _("""
 l'option "AMORCAGE" est trait�e seule
"""),

4: _("""
 il manque la donn�e de la limite d'�lasticit� (SY_02 ou SY_MAX) pour le calcul du rochet thermique
"""),

5: _("""
 le calcul du critere du rochet thermique pour une variation de temp�rature lin�aire est impossible
        X = SIGM / SYMAX =  %(r1)12.5E
         SIGM =  %(r2)12.5E
        SYMAX =  %(r3)12.5E
        on doit avoir 0. < X < 1.
"""),

6: _("""
 le calcul du critere du rochet thermique pour une variation de temp�rature parabolique est impossible
        X = SIGM / SYMAX =  %(r1)12.5E
         SIGM =  %(r2)12.5E
        SYMAX =  %(r3)12.5E
        on doit avoir 0.3 < X < 1.
"""),

7: _("""
 il faut d�finir le comportement %(k1)s dans "DEFI_MATERIAU"
"""),

8: _("""
 erreur donn�es, pour le noeud %(k1)s de la maille %(k2)s 
 il manque les caract�ristiques �l�mentaires (le CARA_ELEM)
"""),

9: _("""
 erreur donn�es, pour le noeud %(k1)s de la maille %(k2)s 
 il manque l'indice de contraintes %(k3)s 
"""),

10: _("""
 materiau non d�fini, maille %(k1)s 
"""),

11: _("""
 un seul "NB_CYCL_SEISME"
"""),

12: _("""
 "NUME_GROUPE" doit etre strictement positif
"""),

13: _("""
 Probleme lors du passage du CH_MATER en CARTE
 Contactez le support
"""),

14: _("""
 Probleme lors du passage du TEMPE_REF en CARTE
 Contactez le support
"""),

15: _("""
 erreur donn�es, pour la situation num�ro %(i1)d sur la maille num�ro %(i2)d 
 il manque le %(k1)s
"""),

16: _("""
 probleme pour r�cup�rer dans la table %(k1)s la valeur du parametre %(k2)s
   pour le parametre %(k3)s de valeur %(k5)s et
   pour le parametre %(k4)s de valeur %(r1)12.5E
"""),

17: _("""
 probleme pour r�cup�rer dans la table  %(k1)s les valeurs du parametre %(k4)s
   pour le parametre %(k2)s de valeur %(k3)s
"""),

18: _("""
 erreur donn�es, il manque le %(k1)s 
   pour la maille num�ro %(i1)d et le noeud num�ro %(i2)d 
"""),

19: _("""
 si on est la, y a un bug!
 Contactez le support
"""),

20: _("""
 champ de nom symbolique %(k1)s inexistant pour le RESULTAT %(k2)s
 d�fini sous l'occurence num�ro %(i1)d
"""),

21: _("""
 il ne faut qu'un seul champ de nom symbolique %(k1)s pour le RESULTAT %(k2)s
 d�fini sous l'occurence num�ro %(i1)d
"""),

22: _("""
 probleme pour r�cup�rer le champ de nom symbolique %(k1)s pour le RESULTAT %(k2)s
 d�fini sous l'occurence num�ro %(i1)d
"""),

23: _("""
 on n'a pas pu r�cup�rer le r�sultat thermique correspondant au numero %(i2)d 
 d�fini par le mot cl� "NUME_RESU_THER" sous le mot cl� facteur "RESU_THER"
 occurence num�ro %(i1)d
"""),

24: _("""
 erreur donn�es, pour la situation num�ro %(i1)d sur la maille num�ro %(i2)d 
   probleme sur le r�sultat thermique
"""),

25: _("""
 erreur donn�es, pour la situation num�ro %(i1)d sur la maille num�ro %(i2)d et le noeud num�ro %(i3)d
   probleme sur le r�sultat thermique
"""),

26: _("""
 il faut d�finir qu'un seul s�isme dans un groupe
   groupe num�ro %(i1)d 
   occurence situation %(i2)d et %(i3)d 
"""),

28: _("""
 erreur donn�es, pour la situation numero %(i1)d 
 on n'a pas pu r�cup�rer le "RESU_MECA" correspondant au num�ro du cas de charge %(i2)d 
"""),

29: _("""
 erreur donn�es, pour la situation numero %(i1)d 
 on ne peut pas avoir des charges de type "seisme" et "autre".
"""),

30: _("""
 probleme pour recuperer IOC SEISME.
 Contactez le support
"""),

31: _("""
 probleme avec TYPEKE.
 Contactez le support
"""),

32: _("""
 le nombre de cycles admissibles est n�gatif, v�rifiez la courbe de WOHLER
   contrainte calcul�e: %(r1)12.5E
   Nadm: %(r2)12.5E
"""),

33: _("""
 la distance calcul�e � partir des ABSC_CURV de la table fournie %(k1)s
 est sup�rieure � 1 pour cent � la distance r�cup�r�e dans le mat�riau. V�rifiez vos donn�es.
   distance calcul�e: %(r1)12.5E
   D_AMORC          : %(r2)12.5E
"""),

}
