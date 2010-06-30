#@ MODIF seisme Messages  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
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
# RESPONSABLE DELMAS J.DELMAS

def _(x) : return x

cata_msg={

 1: _("""
 le noeud %(k1)s n'appartient pas au maillage: %(k2)s
"""),

 2: _("""
 le groupe de noeuds %(k1)s n'appartient pas au maillage: %(k2)s
"""),

 3: _("""
 le noeud %(k1)s n'est pas un noeud support.
"""),

 4: _("""
 le vecteur directeur du spectre est nul.
"""),

 5: _("""
 cas du MONO_APPUI: vous avez d�j� donn� un spectre pour cette direction.
"""),

 6: _("""
 erreur(s) rencontr�e(s) lors de la lecture des supports.
"""),

 7: _("""
 vous avez d�j� donn� un spectre pour le support %(k1)s
"""),

 8: _("""
 on ne peut pas traiter du MONO_APPUI et du MULTI_APPUI simultan�ment.
"""),

 9: _("""
 on n'a pas pu extraire le premier champ des modes m�caniques.
"""),

10: _("""
 correction statique non prise en compte pour l'option: %(k1)s
"""),

11: _("""
 trop d'amortissements modaux
   nombre d'amortissement: %(i1)d
   nombre de mode        : %(i2)d
"""),

12: _("""
 amortissement non diagonal, on ne sait pas traiter.
"""),

13: _("""
 il manque des amortissements modaux
   nombre d'amortissements: %(i1)d
   nombre de modes        : %(i2)d
"""),

14: _("""
 on ne peut pas demander de r�ponse secondaire sans la r�ponse primaire
"""),

15: _("""
 analyse spectrale :
   la base modale utilis�e est               : %(k1)s
   le nombre de vecteurs de base est         : %(i1)d
   la r�gle de combinaison modale est        : %(k2)s
   les options de calcul demand�es sont      : %(k3)s """
   ),

16: _("""
                                               %(k1)s """
   ),

17: _("""
   la nature de l'excitation est             : %(k1)s """
   ),

18: _("""
   la r�gle de combinaison des r�ponses
   directionnelles est                       : %(k1)s """
   ),

19: _("""
   la r�gle de combinaison des contributions
   de chaque mouvement d'appui est           : %(k1)s """
   ),

20: _("""
 erreur dans les donn�es
   la masse de la structure n'existe pas dans la table: %(k1)s
"""),

21: _("""
 il faut au moins 2 occurences de DEPL_MULT_APPUI pour la combinaison des appuis.
"""),

22: _("""
 COMB_DEPL_APPUI: il faut au moins d�finir 2 cas derri�re le mot cl� LIST_CAS.
"""),

23: _("""
 donn�es incompatibles
   pour la direction   : %(k1)s
   nombre de blocage   : %(i1)d
   nombre d'excitations: %(i2)d
"""),

24: _("""
 donn�es incompatibles
   pour les modes m�caniques : %(k1)s
   il manque l'option        : %(k2)s
"""),

25: _("""
  probl�me stockage
    option de calcul: %(k1)s
    occurence       : %(i1)d
    nom du champ    : %(k3)s
"""),

26: _("""
  probl�me stockage
    option de calcul: %(k1)s
    direction       : %(k2)s
    nom du champ    : %(k3)s
"""),

27: _("""
  La base modale utilis� %(k1)s ne contient pas tous les param�tres modaux 
  n�cessaires au calcul.
  Il faut que le concept soit issu d'un calcul sur coordonn�es physiques et
  non pas g�n�ralis�es.
"""),

28: _("""
  Dans le cas d'excitations d�correl�es, 
  le mot-cl� COMB_MULT_APPUI n'est pas pris en compte.
"""),

29: _("""
  La d�finition du groupe d'appuis n'est pas correcte dans le cas d�corr�l�:
  au moins une excitation appartient � plusieurs groupes d'appuis. 
  Les groupes d'appuis doivent �tre disjoints.
"""),

30: _("""
  La d�finition du groupe d'appuis n'est pas correcte dans le cas d�corr�l�.
  Un seul groupe d'appuis a �t� constitu� contenant tous les appuis. 
  Relancez le calcul avec le mot-cl� MULTI_APPUI=CORRELE.
"""),


}

