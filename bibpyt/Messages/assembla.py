#@ MODIF assembla Messages  DATE 11/09/2007   AUTEUR DURAND C.DURAND 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
  le type  :  %(k1)s   de la matrice est incorrect.
  on attend : "S" pour une r�solution par methode it�rative
"""),

2: _("""
 matrice non sym�trique pour l'instant proscrite avec FETI
"""),

3: _("""
  le parametre :  %(k1)s  est incorrect.
  on attend : "CUMU" ou "ZERO" 
"""),

4: _("""
  on ne peut assembler que des matrices r�elles ou complexes
"""),

5: _("""
 mod�les discordants
"""),

6: _("""
 FETI : maille positive avec LIGREL de charge !
"""),

7: _("""
 FETI : maille n�gative avec LIGREL de modele !
"""),

8: _("""
 le motcle :  %(k1)s  est incorrect.
 on attend : "CUMU" ou "ZERO" 
"""),

9: _("""
 on ne trouve pas la composante "LAGR" dans la grandeur
"""),

10: _("""
 il est imprevu d avoir le cmp "lagr" au dela de 30
"""),

11: _("""
 on ne peut assembler que des vecteurs r�els ou complexes
"""),

12: _("""
 le maillage  %(k1)s  contient des super-mailles
 pour l'instant, elles sont proscrites avec FETI
"""),

13: _("""
 ICHIN = 0 
"""),

14: _("""
 ICHIN < -2 
"""),

15: _("""
 S => ICHIN=/0 
"""),

16: _("""
 action : E/L/S 
"""),

17: _("""
 message vide    
"""),

18: _("""
 incoh�rence des MATR_ELEM
"""),

19: _("""
 MATR_ELEM sans SSS et sans LISTE_RESU
"""),

20: _("""
  -  aucun LIGREL dans les RESUELEM 
"""),

21: _("""
 mod�les diff�rents
"""),

22: _("""
 les valeurs de la matrice  %(k1)s  doivent etre r�elles
 on ne traite pas encore les matrices non-sym�triques complexes.
"""),

23: _("""
 la matrice %(k1)s � transformer en matrice non-sym�trique doit etre sym�trique.
"""),

24: _("""
 le nombre maximum de composante de la grandeur est nul
"""),

25: _("""
 le nombre d'entiers codes est nul
"""),

26: _("""
 le noeud:  %(k1)s composante:  %(k2)s  est bloqu� plusieurs fois.
"""),

27: _("""
 l'entier d�crivant la position du premier lagrange ne peut etre �gal qu'� +1 ou -1 .
"""),

28: _("""
 le nombre de noeuds effectivement numerot�s ne correspond pas au nombre
 de noeuds � num�roter
"""),

29: _("""
  -  aucun LIGREL  
"""),

30: _("""
  plusieurs ph�nom�nes 
"""),

31: _("""
 les DDL du NUME_DDL ont boug�
"""),

32: _("""
 ph�nom�ne non pr�vu dans le MOLOC de NUMER2 pour DD
"""),

33: _("""
 le .PRNO est construit sur plus que le maillage
"""),

34: _("""
 le .PRNO est de dimension nulle
"""),

35: _("""
 il n y a pas de mod�le dans la liste  %(k1)s .NUME.LILI
"""),

36: _("""
 noeud inexistant
"""),

37: _("""
 m�thode :  %(k1)s  inconnue.
"""),

38: _("""
 noeud incorrect
"""),

39: _("""
 le ph�nom�ne  %(k1)s  n'est pas admis pour la sym�trisation des matrices.
 seuls sont admis les ph�nom�nes "MECANIQUE" et "THERMIQUE"
"""),

40: _("""
 erreur programmeur :
 certains type_element ne savent pas calculer les options SYME_M?NS_R
"""),

41: _("""
 le noeud  : %(i1)d  du RESUEL : %(k1)s  du VECT_ELEM  : %(k2)s 
 n'a pas d'adresse dans : %(k3)s 
"""),

42: _("""
 le noeud  : %(i1)d  du RESUEL : %(k1)s  du VECT_ELEM  : %(k2)s 
   a une adresse  : %(i2)d  > NEQUA : %(i3)d 
"""),

43: _("""
 NDDL :  %(i1)d  > NDDL_MAX : %(i2)d 
"""),

44: _("""
 --- VECT_ELEM     : %(k1)s
 --- RESU          : %(k2)s
 --- NOMLI         : %(k3)s 
 --- GREL num�ro   : %(i1)d 
 --- MAILLE num�ro : %(i2)d 
 --- NNOE par NEMA : %(i3)d 
 --- NNOE par NODE : %(i4)d 
"""),

45: _("""
 --- le LIGREL    : %(k1)s  r�f. par le noeud supl.  : %(i1)d 
 --- de la maille : %(i2)d 
 --- du RESUELEM  : %(k2)s 
 --- du VECT_ELEM : %(k3)s 
 --- n'est pas pr�sent  dans la num�rotation : %(k4)s 
"""),

46: _("""
 --- NDDL :  %(i1)d  > NDDL_MAX : %(i2)d 
"""),

47: _("""
 --- NDDL :  %(i1)d  > NDDL_MAX : %(i2)d 
"""),

48: _("""
 --- le noeud  : %(i1)d  du RESUEL    : %(k1)s  du VECT_ELEM   : %(k2)s 
 --- n'a pas d''adresse  dans la num�rotation : %(k3)s 
"""),

49: _("""
 --- le noeud  : %(i1)d  du RESUEL    : %(k1)s  du VECT_ELEM   : %(k2)s 
 --- a une adresse : %(i2)d   > NEQUA : %(i3)d 
"""),

50: _("""
 NDDL :  %(i1)d  > NDDL_MAX : %(i2)d 
"""),

52: _("""
 NDDL :  %(i1)d  > NDDL_MAX : %(i2)d 
"""),

53: _("""
 NDDL :  %(i1)d  > NDDL_MAX : %(i2)d 
"""),

63: _("""
 erreur sur le premier lagrange d'une LIAISON_DDL
 on a mis 2 fois le premier  lagrange :  %(i1)d 
 derri�re le noeud :  %(i2)d 
"""),

64: _("""
 erreur sur le  2�me lagrange d'une LIAISON_DDL
 on a mis 2 fois le 2�me  lagrange :  %(i1)d 
 derri�re le noeud :  %(i2)d 
"""),

65: _("""
 incoh�rence dans le d�nombrement des ddls
 nombre de ddl a priori    : %(i1)d 
 nombre de ddl a posteriori: %(i2)d 
"""),
66: _("""
 Probl�me dans NULILI.F: on a au moins deux maillages diff�rents:
  - maillage 1: %(k1)s
  - maillage 2: %(k2)s
"""),
67: _("""
 Probl�me dans NUMERO.F avec FETI: L'objet PROF_CHNO.NUEQ est diff�rent de
 l'identit� pour i= %(i1)d on a NUEQ(i)= %(i2)d
"""),
68: _("""
 Probl�me dans NUMERO.F avec FETI: Incoh�rence entre la SD_FETI et le param�trage
 de l'op�rateur. Nombre d'incoh�rences= %(i1)d
"""),
}
