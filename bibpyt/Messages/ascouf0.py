#@ MODIF ascouf0 Messages  DATE 12/10/2011   AUTEUR COURTOIS M.COURTOIS 
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

cata_msg={
1: _(u"""
La condition aux limites sur bol � section conique 
est ignor�e pour un coude avec sous-�paisseurs.
"""),

2: _(u"""
Mot-cl� AZIMUT non autoris� dans le cas d'un coude sain"
"""),

3: _(u"""
POSI_ANGUL POSI_CURV_LONGI est obligatoire.
"""),

4: _(u"""
Il faut renseigner : ANGLE, R_CINTR et POSI_ANGUL ou ANGLE, R_CINTR et POSI_CURV_LONGI.
"""),

5: _(u"""
ANGL_COUDE et ANGL_SOUS_EPAI sont inutiles dans ce cas.
"""),

6: _(u"""
 ASCSEP valeur hors domaine
 sous-epaisseur numero : %(i1)d
 taille axe circonferentiel : %(r1)f
 bord plaque : %(r2)f
"""),

7: _(u"""
 ASCSEP cas de symetrie :
 la sous-epaisseur doit etre dans la section mediane du coude !
"""),


9: _(u"""
 Valeur hors domaine :
 sous-epaisseur numero :%(i1)d
 absc. curv. circonf. :%(r1)f
 bord plaque :%(r2)f
"""),

10: _(u"""
 Valeur hors domaine :
 sous-epaisseur numero :%(i1)d
 absc. curv. longit.  :%(r1)f
 bord plaque :%(r2)f
"""),

11: _(u"""
 valeur hors domaine :
 sous-epaisseur numero :%(i1)d
 bord inferieur  :%(r1)f
 bord plaque :%(r2)f
"""),


13: _(u"""
 Les quart et demi structure ne peuvent etre r�alisees 
 sur un mod�le comportant une transition d'�paisseur.
"""),

14: _(u"""
 Les deux embouts doivent etre de meme longueur pour les cas de sym�trie.
"""),

15: _(u"""
 Longueur d'embout P1 inf�rieure a la longueur d'amortissement = %(r1)f
"""),

16: _(u"""
 Longueur d'embout P2 inf�rieure � la longueur d'amortissement = %(r1)f
"""),

17: _(u"""
 La condition aux limites raccord 3d-poutre appliqu�e avec la macro de calcul
 ascouf n'est pas licite avec un embout de type conique.
"""),

18: _(u"""
 Le nombre d'elements dans l'epaisseur du coude n'est pas parametrable pour
 un coude avec fissure.
 Le mot-cle NB_ELEM_EPAIS est ignor�.
"""),

19: _(u"""
 Pour les fissures non axisymetriques, la longueur doit etre sp�cifi�e.
"""),

20: _(u"""
 La fissure est axisymetrique : on ne tient pas compte de la longueur sp�cifi�e.
"""),

21: _(u"""
 Avec une transition d'�paisseur,la fissure doit obligatoirement etre transverse.
"""),

23: _(u"""
 L'orientation de la fissure doit etre transverse (orien : 90.) pour mod�liser
 un quart ou une demi structure.
"""),

24: _(u"""
 La fissure est axisymetrique : son orientation doit etre transverse (ORIEN : 90.)
"""),

25: _(u"""
 Il ne peut pas y avoir plusieurs sous-�paisseurs en meme temps
 qu'une transition d'�paisseur: 
 si une seule sous-�paisseur, alors utiliser SOUS_EPAIS_COUDE.
"""),

26: _(u"""
 Avec une transition d'�paisseur,il doit obligatoirement y avoir un d�faut,
 soit une fissure  soit une sous-�paisseur.
"""),

27: _(u"""
 Ne mod�liser qu'une seule sous-�paisseur pour un quart ou demi-coude.
"""),

28: _(u"""
 Vous ne pouvez d�clarer la sous-epaisseur comme axisymetrique et donner
 une taille d'axe circonferentiel.
"""),

29: _(u"""
 Vous devez donner une taille d'axe circonf�rentiel pour une sous-�paisseur
 de type elliptique.
"""),

30: _(u"""
 Valeur hors domaine de validit� :
 sous-�paisseur num�ro :%(i1)d
 abscisse curv. longit. :%(r1)f
 valeur maximale autoris�e :%(r2)f
"""),

31: _(u"""
 Valeur hors domaine de validit� :
 sous-�paisseur num�ro :%(i1)d
 position angulaire centre sous-ep :%(r1)f
 valeur limite autoris�e :%(r2)f
"""),

32: _(u"""
 Valeur hors domaine de validit� : 
 sous-�paisseur numero :%(i1)d
 abscisse curv. circonf. :%(r1)f
 valeur limite autoris�e :%(r2)f
"""),

33: _(u"""
 Le centre d'une sous-�paisseur axisym�trique est impos� en intrados (pi*RM).
"""),

34: _(u"""
 Le centre d'une sous-�paisseur axisym�trique est impos� en intrados.
 L'azimut est fix� � 180 degr�s.
"""),

35: _(u"""
 Le nombre d'�lements dans l'�paisseur du coude n'est pas parametrable pour
 la version 2 de la procedure de plaque avec sous-�paisseur : 
 mot-cle NB_ELEM_EPAIS ignor�.
"""),

36: _(u"""
 Valeur hors domaine de validit� :
 sur�paisseur :%(i1)d
 valeur limite autoris�e (RM-EP1/2) :%(r1)f
"""),

37: _(u"""
 Valeur hors domaine de validit� :
 le rayon de cintrage : %(r1)f
 doit etre sup�rieur a (RM+EP1/2) :%(r2)f
"""),

38: _(u"""
 Valeur hors domaine de validit� (5,50)
 rapport RM/EP1 : %(r1)f
"""),

39: _(u"""
 Valeur hors domaine de validit� :
 abscisse curviligne centre fissure :%(r1)f
 valeur limite autoris�e :%(r2)f
"""),

40: _(u"""
 Valeur hors domaine de validit� : 
 nombre de tranches :%(i1)d
"""),

41: _(u"""
 Valeur hors domaine de validit� :
 position angulaire  centre fissure : %(r1)f
 posi_angul doit etre >= 0 et <= %(r2)f 
"""),

42: _(u"""
 Valeur hors domaine de validit� : 
 d�but transition d'�paisseur :%(r1)f
 valeur minimale autoris�e :%(r2)f
 valeur maximale autoris�e :%(r3)f
"""),

43: _(u"""
 Valeur hors domaine de validit� :
 angle de transition TETA1 : %(r1)f
 valeur minimale autoris�e : 0.
 valeur maximale autoris�e : 30.
"""),

44: _(u"""
 Valeur hors domaine de validit� :
 �paisseur avant la transition :%(r1)f
 valeur minimale autoris�e : 12
 valeur maximale autoris�e : 80
"""),

45: _(u"""
 Valeur hors domaine de validit� : 
 �paisseur apres la transition :%(r1)f
 valeur minimale autoris�e : 20
 valeur maximale autoris�e : 110
"""),

46: _(u"""
 L'�paisseur avant la transition doit etre inf�rieure
 � celle apres la transition.
"""),

47: _(u"""
 Valeur hors domaine de validit� :
 fin transition d'�paisseur :%(r1)f
 valeur limite autoris�e :%(r2)f
"""),

48: _(u"""
 Valeur hors domaine de validit� :
 diam ext du tube avant transition:%(r1)f
 valeur minimum autoris�e : 112.
 valeur maximum autoris�e : 880.
"""),

49: _(u"""
 Valeur hors domaine de validit� :
 angle de transition TETA2: %(r1)f
 valeur minimum autoris�e : 0.
 valeur maximum autoris�e : 45.
"""),

50: _(u"""
 Valeur hors domaine de validit� :
 epaisseur avant 1ere transition:%(r1)f
 valeur minimum autorisee : 7.
 valeur maximum autorisee : 35.
"""),

51: _(u"""
 Valeur hors domaine de validit� :
 epaisseur avant 2eme transition:%(r1)f
 valeur minimum autorisee : 15.
 valeur maximum autorisee : 40.
"""),

52: _(u"""
 Valeur hors domaine de validit� :
 �paisseur intermediaire:%(r1)f
 valeur minimum autoris�e : 15.
 valeur maximum autoris�e : 40.
"""),

53: _(u"""
 Valeur hors domaine de validit�.
 L'�paisseur avant la transition doit etre inf�rieure
 � l'�paisseur intermediaire.
"""),

54: _(u"""
 Valeur hors domaine de validit�.
 L'�paisseur apr�s la transition doit etre inf�rieure
 � l'�paisseur intermediaire.
"""),

55: _(u"""
 Valeur hors domaine de validit� :
 fin transition d'�paisseur:%(r1)f
 valeur limite autoris�e :%(r2)f
"""),

56: _(u"""
 Valeur hors domaine de validit� :
 diam ext du tube avant transition:%(r1)f
 valeur minimum autoris�e : 77.
 valeur maximum autoris�e : 355.
"""),

57: _(u"""
Seuls gibi98 et gibi2000 sont appelables.
"""),

58: _(u"""
Une interp�n�tration des l�vres est d�tect�e pour le num�ro d'ordre %(i1)d : sur les
%(i2)d noeuds de chaque l�vre, %(i3)d noeuds s'interp�n�trent.
-> Risque et Conseil :
Le contact n'est pas pris en compte dans le calcul. Le taux de restitution de l'�nergie G
est donc positif y compris l� o� la fissure tend � se refermer, ce qui peut conduire �
des r�sultats trop p�nalisants.
Pour prendre en compte le contact entre les l�vres, il faut lancer le calcul hors macro.
"""),

}
