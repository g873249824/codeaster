#@ MODIF edyos Messages  DATE 16/02/2010   AUTEUR GREFFET N.GREFFET 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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



#
#  messages d'erreur pour interface Aster/edyos 
# 
#        


#    Ce script python permet d'associer un texte aux numeros d'erreur
#    appeles dans le sous programme errcou.f 

#    Ces messages d'erreur sont issus de la note HI-26/03/007A
#    "DEVELOPPEMENT D'UN MODE PRODUCTION POUR CALCIUM: MANUEL UTILISATEUR"
#    ANNEXE 1: CODES D'ERREURS  (PAGE 70)
#    FAYOLLE ERIC, DEMKO BERTRAND (CS SI)  JUILLET 2003
#
#    Les numeros des erreurs de ce script correspondent aux numeros de la
#    reference bibliographique 
 

def _(x) : return x

cata_msg={

1 : _("""
      YACS : Emetteur inconnu
"""),

2 : _("""
      YACS : Nom de variable inconnu
"""),

3 : _("""
      YACS : Variable ne devant pas �tre lue mais �crite
"""),


4 : _("""
      YACS : Type de variable inconnu
"""),

5 : _("""
      YACS : Type de variable diff�rent de celui d�clar�
"""),

6 : _("""
      YACS : Mode de d�pendance inconnu
"""),

7 : _("""
      YACS : Mode de d�pendance diff�rent de celui d�clar�
"""),

8 : _("""
      YACS : Requ�te non autoris�e
"""),

9 : _("""
      YACS : Type de d�connection incorrect
"""),

10 : _("""
       YACS : Directive de d�connection incorrecte
"""),

11 : _("""
       YACS : Nom de code inconnu
"""),

12 : _("""
       YACS : Nom d'instance inconnue
"""),

13 : _("""
      YACS : Requ�te en attente
"""),

14 : _("""
      YACS : Message de service
"""),

15 : _("""
      YACS : Nombre de valeurs transmises nul
"""),

16 : _("""
       YACS : Dimension de tableau r�cepteur insuffisante
"""),

17 : _("""
      YACS : Blocage
"""),

18 : _("""
      YACS : Arr�t anormal d'une instance
"""),

19 : _("""
      YACS : Coupleur absent...
"""),

20 : _("""
      YACS : Variable ne figurant dans aucun lien
"""),

21 : _("""
      YACS : Nombre de pas de calcul �gal � z�ro
"""),

22 : _("""
      YACS : Machine non d�clar�e
"""),

23 : _("""
      YACS : Erreur variable d'environnement COUPLAGE_GROUPE non positionn�e
"""),

24 : _("""
=      YACS : Variable d'environnement COUPLAGE_GROUPE inconnue
"""),

25 : _("""
      YACS : Valeur d'info non utilis�e
"""),  

26 : _("""
      YACS : Erreur de format dans le fichier de couplage
"""),

27 : _("""
      YACS : Requ�te annul�e � cause du passage en mode normal
"""),

28 : _("""
      YACS : Coupleur en mode d'ex�cution normal
"""),

29 : _("""
      YACS : Option inconnue
"""),

30 : _("""
      YACS : Valeur d'option incorrecte
"""),

31 : _("""
      YACS : Ecriture d'une variable dont l'effacement est demand�
"""),

32 : _("""
      YACS : Lecture d'une variable incorrectement connect�e
"""),

33 : _("""
      YACS : Valeur d'info non utilis�e
"""),  

34 : _("""
      YACS : Valeur d'info non utilis�e
"""),  

35 : _("""
      YACS : Erreur dans la chaine de d�claration
"""),

36 : _("""
      YACS : Erreur dans le lancement dynamique d'une instance
"""),

37 : _("""
      YACS : Erreur de communication 
"""),

38 : _("""
      YACS : Valeur d'info non utilis�e
"""),

39 : _("""
      YACS : Mode d'ex�cution non d�fini
"""),    

40 : _("""   
      YACS : Instance d�connect�e
"""),


41 : _("""
 Avertissement YACS (gravit� faible) :
       Dans le SSP %(k1)s la variable %(k2)s a une valeur diff�rente
       de celle envoy�e
"""),

42 : _("""
 Erreur YACS :
       Probl�me dans le SSP  : %(k1)s
       Pour la variable      : %(k2)s
       A l'it�ration num�ro  : %(i1)d
"""),

43 : _("""   
      Attention, le nombre de palier d�passe 10 => v�rifiez les donn�es
"""),

44 : _("""   
      Probl�me noeud du palier %(i1)d = %(i2)d
"""),

45 : _("""   
      Non convergence du code EDYOS
"""),

46 : _("""   
      Le code EDYOS n'a pas converg�
      Avc le sch�ma en temps d'Euler, on ne sous-divise pas le pas de temps
      Le calcul s'arr�te donc
      Conseil : tester le sch�ma en temps adaptatif
"""),

47 : _("""   
      Le code EDYOS n'a pas converg�
      Avc le sch�ma en temps adaptatif, on va tenter de diminuer le pas de temps
"""),

}

