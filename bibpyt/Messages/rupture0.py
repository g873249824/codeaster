#@ MODIF rupture0 Messages  DATE 17/07/2007   AUTEUR REZETTE C.REZETTE 
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
Interpolation hors du domaine (prolongement constant utilis�).
"""),

2: _("""
Le label %(k1)s doit etre pr�sent dans la table %(k2)s
"""),

4: _("""
Le label COOR_Z doit etre pr�sent dans la table %(k1)s
"""),

5: _("""
Il faut d�finir ELAS dans DEFI_MATERIAU.
"""),

6: _("""
Les propriet�s mat�riaux, n�cessaires aux calculs
des coefficients d'intensite des contraintes, ont ete obtenues a la
temp�rature de r�ference du materiau et non � la temp�rature calcul�e.
"""),

7: _("""
L operateur CALC_G -option CALC_K_G- calcule plus pr�cisement les %(k1)s
"""),

10: _("""
Mod�lisation non implant�e.
"""),

11: _("""
Probl�me � la r�cuperation des noeuds du fond de fissure.
"""),

12: _("""
Type de mailles du fond de fissure non d�fini.
"""),

13: _("""
Le group_no %(k1)s n'est pas dans le maillage.
"""),

14: _("""
Le group_no %(k1)s n'est pas dans le maillage.
"""),

15: _("""
le noeud %(k1)s n'appartient pas au fond de fissure.
"""),

16: _("""
Le mot cl� RESULTAT est obligatoire pour TYPE_MAILLAGE = LIBRE.
"""),

17: _("""
Le nombre de noeuds NB_NOEUD_COUPE doit etre sup�rieur a 3 : 
On prend la valeur par d�faut
"""),

18: _("""
Probl�me a la r�cuperation du mod�le dans la sd r�sultat fournie.
"""),

19: _("""
Probl�me � la r�cup�ration des noeuds de la l�vre sup : 
v�rifier que le mot-cl� LEVRE_SUP est bien renseign� dans DEFI_FOND_FISS.
"""),

20: _("""
Probl�me � la r�cuperation des noeuds de la l�vre inf : 
v�rifier que le mot-cl� LEVRE_INF est bien renseign� dans DEFI_FOND_FISS.
"""),

21: _("""
Les noeuds ne sont pas en vis-a-vis dans le plan
perpendiculaire au noeud %(k1)s
"""),

22: _("""
Il manque des points dans le plan d�fini par la l�vre
sup�rieure et perpendiculaire au fond %(k1)s.
"""),

23: _("""
V�rifier les tangentes extremit�s ou
"""),

24: _("""
Augmenter PREC_NORM dans DEFI_FOND_FISS.
"""),

25: _("""
Augmenter ABSC_CURV_MAXI.
"""),

26: _("""
Il manque des points dans le plan d�fini par la l�vre
inf�rieure et perpendiculaire au fond  %(k1)s.
"""),


30: _("""
Calcul possible pour aucun noeud du fond : v�rifier les donnees.
"""),

31: _("""
Probl�me a la r�cuperation du modele dans la sd r�sultat fournie.'
"""),

32: _("""
Diff�rence entre le vecteur VECT_K1 et la normale au plan de la fissure %(k1)s.
On continue avec la normale au plan : (%(r1)f,%(r2)f,%(r3)f)
"""),

33: _("""
Probl�me dans la r�cuperation du saut de d�placement sur les l�vres :
v�rifier que le r�sultat correspond bien a un calcul sur des �lements x-fem 
et que le maillage fourni est bien le maillage lin�aire initial.
"""),

34: _("""
Le nombre de noeuds NB_NOEUD_COUPE doit etre sup�rieur � 3 : 
on prend la valeur par d�faut.
"""),

35: _("""
TABL_DEPL_SUP et TABL_DEPL_INF sont obligatoires si SYME_CHAR=SANS.
"""),

36: _("""
TABL_DEPL_SUP et TABL_DEPL_INF sont obligatoires si SYME_CHAR=SANS.
"""),

37: _("""
Le num�ro d'ordre %(i1)d n'a pas �t� trouv� dans la table.
"""),

38: _("""
Pas d'instant trouv� dans la table pour l'instant %(r1)f.
"""),

39: _("""
Plusieurs instants trouv�s dans la table pour l'instant %(r1)f.
"""),

40: _("""
ABSC_CURV non croissants pour TABL_DEPL_INF.'
"""),

41: _("""
ABSC_CURV non croissants pour TABL_DEPL_SUP.'
"""),

42: _("""
Diff�rence de points entre la l�vre sup�rieure et la l�vre inf�rieure
"""),

43: _("""
Pour traiter le noeud %(k1)s:
 Nombre de points - levre superieure : %(i1)d
 Nombre de points - levre inferieure : %(i2)d
"""),

44: _("""
Les noeuds ne sont pas en VIS_A_VIS.
"""),

45: _("""
Probl�me dans la r�cup�ration du saut de d�placement sur les l�vres :
v�rifier que le r�sultat correspond bien � un calcul sur des �lements x-fem
et que le maillage fourni est bien le maillage lin�aire initial.
"""),

46: _("""
Il faut au moins trois noeuds dans le plan d�fini par les l�vres
et perpendiculaire au fond de fissure.
"""),

47: _("""
Noeud %(k1)s 
"""),


49: _("""
D�placement normal du noeud %(k1)s non nul
et SYME_CHAR = %(k2)s.
V�rifier les conditions aux limites et VECT_K1.
"""),

50: _("""
Nombre de modes diff�rent entre la base modale
et %(k1)s : on prend le minimum des deux %(i1)d.
"""),

51: _("""
Le num�ro d'ordre %(i1)d n'appartient pas au r�sultat %(k1)s.
"""),

52: _("""
Pas d'instant trouv� dans la table pour l'instant %(r1)f.
"""),

53: _("""
Plusieurs instants trouves dans la table pour l instant %(r1)f.
"""),

54: _("""
Aucun instant ou num�ro d'ordre trouv�.
"""),

}
