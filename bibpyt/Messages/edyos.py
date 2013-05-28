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
# person_in_charge: josselin.delmas at edf.fr



#
#  messages d'erreur pour interface Aster/edyos 
# 
#        


#    Ce script python permet d'associer un texte aux num�ros d'erreur
#    appel�s dans le sous programme errcou.f 

#    Ces messages d'erreur sont issus de la note HI-26/03/007A
#    "DEVELOPPEMENT D'UN MODE PRODUCTION POUR CALCIUM: MANUEL UTILISATEUR"
#    ANNEXE 1: CODES D'ERREURS  (PAGE 70)
#    FAYOLLE ERIC, DEMKO BERTRAND (CS SI)  JUILLET 2003
#
#    Les num�ros des erreurs de ce script correspondent aux num�ros de la
#    r�f�rence bibliographique 
 

cata_msg={

1 : _(u"""
      YACS : �metteur inconnu
"""),

2 : _(u"""
      YACS : Nom de variable inconnu
"""),

3 : _(u"""
      YACS : Variable ne devant pas �tre lue mais �crite
"""),


4 : _(u"""
      YACS : Type de variable inconnu
"""),

5 : _(u"""
      YACS : Type de variable diff�rent de celui d�clar�
"""),

6 : _(u"""
      YACS : Mode de d�pendance inconnu
"""),

7 : _(u"""
      YACS : Mode de d�pendance diff�rent de celui d�clar�
"""),

8 : _(u"""
      YACS : Requ�te non autoris�e
"""),

9 : _(u"""
      YACS : Type de d�connexion incorrect
"""),

10 : _(u"""
       YACS : Directive de d�connexion incorrecte
"""),

11 : _(u"""
       YACS : Nom de code inconnu
"""),

12 : _(u"""
       YACS : Nom d'instance inconnue
"""),

13 : _(u"""
      YACS : Requ�te en attente
"""),

14 : _(u"""
      YACS : Message de service
"""),

15 : _(u"""
      YACS : Nombre de valeurs transmises nul
"""),

16 : _(u"""
       YACS : Dimension de tableau r�cepteur insuffisante
"""),

17 : _(u"""
      YACS : Blocage
"""),

18 : _(u"""
      YACS : Arr�t anormal d'une instance
"""),

19 : _(u"""
      YACS : Coupleur absent...
"""),

20 : _(u"""
      YACS : Variable ne figurant dans aucun lien
"""),

21 : _(u"""
      YACS : Nombre de pas de calcul �gal � z�ro
"""),

22 : _(u"""
      YACS : Machine non d�clar�e
"""),

23 : _(u"""
      YACS : Erreur variable d'environnement COUPLAGE_GROUPE non positionn�e
"""),

24 : _(u"""
=      YACS : Variable d'environnement COUPLAGE_GROUPE inconnue
"""),

25 : _(u"""
      YACS : Valeur d'information non utilis�e
"""),  

26 : _(u"""
      YACS : Erreur de format dans le fichier de couplage
"""),

27 : _(u"""
      YACS : Requ�te annul�e � cause du passage en mode normal
"""),

28 : _(u"""
      YACS : Coupleur en mode d'ex�cution normal
"""),

29 : _(u"""
      YACS : Option inconnue
"""),

30 : _(u"""
      YACS : Valeur d'option incorrecte
"""),

31 : _(u"""
      YACS : �criture d'une variable dont l'effacement est demand�
"""),

32 : _(u"""
      YACS : Lecture d'une variable incorrectement connect�e
"""),

33 : _(u"""
      YACS : Valeur d'information non utilis�e
"""),  

34 : _(u"""
      YACS : Valeur d'information non utilis�e
"""),  

35 : _(u"""
      YACS : Erreur dans la cha�ne de d�claration
"""),

36 : _(u"""
      YACS : Erreur dans le lancement dynamique d'une instance
"""),

37 : _(u"""
      YACS : Erreur de communication 
"""),

38 : _(u"""
      YACS : Valeur d'information non utilis�e
"""),

39 : _(u"""
      YACS : Mode d'ex�cution non d�fini
"""),    

40 : _(u"""   
      YACS : Instance d�connect�e
"""),


41 : _(u"""
 Avertissement YACS (gravit� faible) :
       Dans le SSP %(k1)s la variable %(k2)s a une valeur diff�rente
       de celle envoy�e
"""),

42 : _(u"""
 Erreur YACS :
       Probl�me dans le SSP  : %(k1)s
       Pour la variable      : %(k2)s
       A l'it�ration num�ro  : %(i1)d
"""),

43 : _(u"""   
      Attention, le nombre maximal de palier est 20 
"""),

45 : _(u"""   
      Non convergence du code EDYOS
"""),

46 : _(u"""   
      Le code EDYOS n'a pas converg�
      Avec le sch�ma en temps d'Euler, on ne sous divise pas le pas de temps
      Le calcul s'arr�te donc
      Conseil : tester le sch�ma en temps adaptatif
"""),

47 : _(u"""   
      Le code EDYOS n'a pas converg�
      Avec le sch�ma en temps adaptatif, on va tenter de diminuer le pas de temps
"""),

48 : _(u"""   
      Erreur de syntaxe pour le couplage avec EDYOS :
      Il faut obligatoirement renseigner COUPLAGE_EDYOS et PALIERS_EDYOS
"""),

49 : _(u"""   
      Erreur de syntaxe pour le couplage avec EDYOS :
      Pour le mot-cl� PALIERS_EDYOS dans le cas o� l'on utilise TYPE_EDYOS, 
      il faut donner � chaque occurrence soit le GROUP_NO du palier, soit son NOEUD.
      
"""),

}
