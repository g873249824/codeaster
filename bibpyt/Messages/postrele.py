#@ MODIF postrele Messages  DATE 19/02/2008   AUTEUR COURTOIS M.COURTOIS 
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
 cr�ation/extension de la table %(k1)s 
"""),

2 : _("""
 post_traitement num�ro :  %(i1)d 
 inexistence de CHAM_GD 
 pas de post-traitement 
 """),

3 : _("""
 post_traitement num�ro :  %(i1)d 
 aucune maille ne correspond aux crit�res demand�s
 pas de post-traitement
"""),

5 : _("""
 il manque le vecteur des composantes "NOCP".
 Contactez le support.
"""),

6 : _("""
 chemin nul ou d�fini en un noeud
"""),

7 : _("""
 le nombre de composantes � traiter est limit� � 6 pour operation "MOYENNE".
 utiliser "NOM_CMP" avec au plus 6 composantes.
"""),

8 : _("""
 initialisation de la table %(k1)s
"""),

9 : _("""
 pas de champ trouv� pour l'option %(k1)s
"""),

10 : _("""
 param�tre %(k1)s de type %(k2)s 
"""),

11 : _("""
 on ne traite que les champs complexes
"""),

12 : _("""
 tableau de travail limit�, reduire le nombre de composantes � traiter
"""),

13 : _("""
 plus de 3000 composantes.
 Contactez le support
"""),

14 : _("""
 en rep�re local, on ne traite pas le champ %(k1)s 
"""),

15 : _("""
 ICOEF trop grand
 Contactez le support
"""),

16 : _("""
 probl�me maillage
 Contactez le support
"""),

17 : _("""
 on ne traite que des champs de type "DEPL_R" pour un changement de rep�re
"""),

18 : _("""
 le type de maille %(k1)s n'est pas trait�
"""),

19 : _("""
 mauvaise d�finition du chemin, probleme de continuit� du chemin sur une maille
 diminuer la pr�cision dans l'op�rateur INTE_MAIL_(2D/3D)
"""),

20 : _("""
 on ne traite pas ce cas
 Contactez le support
"""),

21 : _("""
 avec VECT_Y, le groupe de noeuds doit contenir au moins 2 noeuds
"""),

22 : _("""
 avec VECT_Y, il faut pr�ciser 
   - soit un seul groupe de noeuds
   - soit plusieurs noeuds
"""),

23 : _("""
 on ne peut pas m�langer des arcs et des segments.
"""),

24 : _("""
 chemin de maille vide
"""),

25 : _("""
 contradiction avec INTE_MAIL_2D
"""),

26 : _("""
 changement de rep�re:
 champ non trait� %(k1)s
 option de calcul %(k2)s 
"""),

27 : _("""
 noeud sur l'AXE_Z
 maille      : %(k1)s
 noeud       : %(k2)s
 coordonn�es : %(r1)f 
"""),

28 : _("""
 les noeuds du maillage ne sont pas tous dans un meme plan Z = CST
 changement de rep�re non trait�
"""),

29 : _("""
 on ne sait pas faire ce post-traitement pour le chemin %(k1)s en rep�re %(k2)s 
"""),

30 : _("""
 le noeud %(k1)s est confondu avec l'origine
"""),

31 : _("""
 le noeud %(k1)s est sur l'AXE_Z
"""),

32 : _("""
 les noeuds du maillage ne sont pas tous dans un meme plan Z = CST
 option TRAC_NOR non trait�e
 utiliser l'option TRAC_DIR
"""),

33 : _("""
 option non trait�e: %(k1)s, post-traitement: %(i1)d 
 les invariants tensoriels sont calcul�s
   pour les options :  %(k2)s 
                       %(k3)s 
                       %(k4)s 
                       %(k5)s 
                       %(k6)s 
                       %(k7)s 
                       %(k8)s 
                       %(k9)s 
                       %(k10)s 
                       %(k11)s 
                       %(k12)s 
                       %(k13)s 
                       %(k14)s 
                       %(k15)s 
                       %(k16)s 
                       %(k17)s 
                       %(k18)s 
                       %(k19)s 
                       %(k20)s 
"""),

34 : _("""
 option non trait�e: %(k1)s, post-traitement: %(i1)d 
 les traces normales sont calcul�es 
   pour les options :  %(k2)s 
                       %(k3)s 
                       %(k4)s 
                       %(k5)s 
                       %(k6)s 
                       %(k7)s 
                       %(k8)s 
                       %(k9)s 
                       %(k10)s 
                       %(k11)s 
                       %(k12)s 
                       %(k13)s 
                       %(k14)s 
                       %(k15)s 
                       %(k16)s 
                       %(k17)s 
                       %(k18)s 
   ou pour les grandeurs %(k19)s 
                         %(k20)s 
"""),

35 : _("""
 option non trait�e: %(k1)s, post-traitement: %(i1)d 
 les traces directionnelles sont calcul�es
   pour les options :  %(k2)s 
                       %(k3)s 
                       %(k4)s 
                       %(k5)s 
                       %(k6)s 
                       %(k7)s 
                       %(k8)s 
                       %(k9)s 
                       %(k10)s 
                       %(k11)s 
                       %(k12)s 
                       %(k13)s 
                       %(k14)s 
                       %(k15)s 
                       %(k16)s 
                       %(k17)s 
                       %(k18)s 
                       %(k19)s 
                       %(k20)s 
   ou pour les grandeurs %(k21)s 
                         %(k22)s 
                         %(k23)s 
"""),

36 : _("""
 trace directionnelle, post-traitement: %(i1)d 
 direction nulle, pas de calul
"""),

37 : _("""
 attention post-traitement %(i1)d 
 seules les composantes du tenseur des contraintes sont trait�es
"""),

38 : _("""
 post-traitement %(i1)d 
 composante non trait�e dans un changement de repere
 Contactez le support
"""),

39 : _("""
 post-traitement %(i1)d 
 grandeur %(k1)s non trait�e dans un changement de repere
 les changements de repere sont possibles
   pour la grandeur %(k2)s  option: %(k3)s
   pour la grandeur %(k4)s  options: %(k5)s %(k6)s 
   pour les grandeurs %(k7)s  %(k8)s
"""),

40 : _("""
 le noeud num�ro %(i1)d n'est pas connect� � la maille de nom %(k1)s 
"""),

41 : _("""
 champ inexistant nom_cham: %(k1)s  nume_ordre: %(i1)d 
"""),

42 : _("""
 occurence %(i1)d du mot cl� facteur ACTION
 les listes arguments des mots cl�s RESULTANTE et MOMENT doivent etre de meme longueur
 cette longueur doit etre de 2 ou 3
"""),

43 : _("""
 occurence %(i1)d du mot cl� facteur ACTION
 la liste arguments du mot cl� POINT doit etre de longueur 2 ou 3
"""),

44 : _("""
 occurence %(i1)d du mot cl� facteur ACTION
 on ne peut acc�der au RESULTAT de nom %(k1)s et de type %(k2)s par %(k3)s ou par %(k4)s 
"""),

45 : _("""
 occurence %(i1)d du mot cl� facteur ACTION
 on ne peut acc�der au RESULTAT de nom %(k1)s et de type %(k2)s par %(k3)s
"""),

46 : _("""
 occurence %(i1)d du mot cl� facteur ACTION
 le NOM_CHAM %(k1)s n'est pas autoris� pour le RESULTAT %(k2)s de type %(k3)s
 ou le NOM_CHAM est autoris� mais aucun champ effectif n'existe.
"""),

47 : _("""
 occurence %(i1)d du mot cl� facteur ACTION
 le ou les champs �l�mentaires mis en jeu est ou sont donn�s aux pointe de gauss
 ce ou ces champs ne sont pas trait�s.
"""),

48 : _("""
 occurence %(i1)d du mot cl� facteur ACTION
 la composante %(k1)s n'est pas pr�sente au catalogue des grandeurs.
"""),

49 : _("""
 occurence %(i1)d du mot cl� facteur ACTION
 le maillage de la courbe %(k1)s est diff�rent du maillage du champ � traiter %(k2)s
"""),

50 : _("""
 occurence %(i1)d du mot cl� facteur ACTION
 le groupe de noeuds %(k1)s ne fait pas parti du maillage sous jacent au champ � traiter.
"""),

51 : _("""
 occurence %(i1)d du mot cl� facteur ACTION
 le noeud %(k1)s ne fait pas parti du maillage sous jacent au champ � traiter.
"""),

52 : _("""
 on ne traite pas le FORMAT_C %(k1)s
"""),

53 : _("""
 NEC trop grand
 Contactez le support
"""),

54 : _("""
 occurence %(i1)d du mot cl� facteur ACTION
 Impossible de r�cup�rer les composantes du champ. 
"""),

55 : _("""
 la composante %(k1)s est en double.
"""),

56 : _("""
 la composante %(k1)s n'est pas une composante de %(k2)s
"""),

57 : _("""
 la grandeur %(k1)s est inconnue au catalogue.
"""),

58 : _("""
 erreur de programmation
 Contactez le support
"""),

59 : _("""
 Le contenu de la table n'est pas celui attendu !
 Contactez le support
"""),

60 : _("""
 arret sur erreurs
 Contactez le support
"""),

61 : _("""
 Nombre de cycles admissibles n�gatif, 
 verifier la courbe de WOLHER
 contrainte calculee =  %(r1)f    nadm =  %(r2)f 
 
"""),

62 : _("""
 Attention lors de la d�finition de votre liste de noeuds,
 %(i1)d noeud est hors de la mati�re 
 
"""),

63 : _("""
 Attention lors de la d�finition de votre liste de noeuds,
 %(i1)d noeuds sont hors de la mati�re 
 
"""),

}
