#@ MODIF algorith7 Messages  DATE 19/12/2007   AUTEUR ABBAS M.ABBAS 
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
 couplage fluage/fissuration :
 il faut d�finir deux lois de comportement exactement. 
"""),

2 : _("""
 GRANGER et ENDO_ISOT_BETON ou MAZARS non encore d�velopp�
"""),

3 : _("""
 loi de comportement non autoris�e dans le couplage fluage/fissuration
"""),

4 : _("""
 UMLV_FP et MAZARS non encore developp�
"""),

5 : _("""
 pas de C_PLAN pour ENDO_ISOT_BETON
 utiliser C_PLAN_DEBORST
"""),

6 : _("""
 loi de fluage non autorisee dans le couplage fluage/fissuration
"""),

7 : _("""
 pas d'orthotropie non lin�aire
"""),

8 : _("""
 loi de comportement hyper-�lastique non prevue
"""),

9 : _("""
 C_PLAN m�thode DEBORST et SIMO_MIEHE incompatibles
"""),

10 : _("""
 COMP1D et SIMO_MIEHE incompatibles
"""),

11 : _("""
 couplage fluage/fissuration :
 la premi�re loi doit etre une loi de fluage de type GRANGER_FP ou GRANGER_FP_V.
"""),

12 : _("""
 couplage fluage/fissuration :
 nombre total de variables internes incoh�rent <--> erreur de programmation. 
"""),

13 : _("""
 f(0)=  %(k1)s  > 0 
"""),

15 : _("""
  le concept EVOL_CHAR :  %(k1)s  n'en est pas un !
"""),

16 : _("""
  le concept EVOL_CHAR :  %(k1)s  ne contient aucun champ de type EVOL_CHAR.
"""),

17 : _("""
  on ne trouve pas le r�sultat deriv� associ� �  %(k1)s  et  %(k2)s 
"""),

18 : _("""
  le concept EVOL_THER :  %(k1)s  ne contient aucun champ.
"""),

19 : _("""
 erreur de type sur la charge thermique  %(k1)s 
"""),

20 : _("""
 le champ de d�placement DIDI n'est pas trouv� dans le concept  %(k1)s 
"""),

21 : _("""
  -> Crit�re de convergence est lache !
  -> Risque & Conseil : La valeur de RESI_GLOB_RELA est sup�rieure a 10-4.
     Cela peut nuire � la qualit� de la solution. Vous ne v�rifiez pas l'�quilibre de mani�re rigoureuse.
"""),

22 : _("""
 la charge  %(k1)s  n'est pas m�canique
"""),

23 : _("""
 la charge  %(k1)s  ne peut etre suiveuse
"""),

24 : _("""
 la charge  %(k1)s  ne peut etre diff�rentielle
"""),

25 : _("""
 il y a plusieurs charges thermiques 
"""),

27 : _("""
 la charge  %(k1)s  ne peut etre pilot�e
"""),

28 : _("""
 on ne peut piloter une charge fonction du temps
"""),

29 : _("""
 la charge thermique  %(k1)s  ne peut etre pilot�e
"""),

30 : _("""
 il y a plusieurs charges de s�chage 
"""),

31 : _("""
 la charge de s�chage  %(k1)s  ne peut etre pilot�e
"""),

32 : _("""
 il y a plusieurs charges de d�formations an�lastiques 
"""),

33 : _("""
 la charge de d�formations an�lastiques  %(k1)s  ne peut etre pilot�e
"""),

34 : _("""
 la charge de type EVOL_CHAR  %(k1)s  ne peut etre pilot�e
"""),

35 : _("""
 une meme charge ne peut contenir � la fois
 le mot-cle "LIAISON_UNIL" et le mot-cle "CONTACT"
"""),

36 : _("""
 la charge de type liaison_unilat�rale  %(k1)s  ne peut etre pilot�e
"""),

37 : _("""
 la charge de type contact  %(k1)s  ne peut etre pilot�e
"""),

38 : _("""
 la charge  %(k1)s  ne peut pas utiliser de fonction multiplicative FONC_MULT
 car elle est pilot�e
"""),

39 : _("""
 on ne peut pas faire de pilotage en l'absence de forces de type "FIXE_PILO"
"""),

40 : _("""
 il ne peut pas y avoir de contact (mot-cle "contact") dans plus d'une charge
"""),

41 : _("""
 il y a au moins une charge non m�canique : v�rifier le fichier de commandes
"""),

42 : _("""
  REAC_INCR n�gatif
"""),

43 : _("""
  reac_iter negatif
"""),

44 : _("""
  REAC_ITER_ELAS n�gatif
"""),

45 : _("""
 il faut pr�ciser un concept EVOL_NOLI en pr�diction 'DEPL_CALCULE'
"""),

46 : _("""
  -> La d�finition des param�tres rho_min et rho_excl est contradictoire.
     On choisit de prendre RHO_MIN � RHO_EXCL.
  -> Risque & Conseil :
     RHO_MIN ne doit pas etre compris entre -RHO_EXCL et RHO_EXCL

"""),

47 : _("""
 les valeurs des param�tres RHO_MAX et RHO_EXCL sont contradictoires,
 on prend RHO_MAX � -RHO_EXCL
"""),

48 : _("""
 ETA_PILO_MAX doit etre inf�rieur a ETA_PILO_R_MAX
"""),

49 : _("""
 ETA_PILO_MIN doit etre sup�rieur � ETA_PILO_R_MIN
"""),

50 : _("""
 il faut au plus 1 noeud pour le pilotage DDL_IMPO
"""),

51 : _("""
 il faut au plus 1 groupe de noeud pour le pilotage DDL_IMPO
"""),

52 : _("""
 il faut au plus un noeud dans le groupe pour le pilotage DDL_IMPO
"""),

53 : _("""
 il faut pr�ciser un groupe de noeuds dans la m�thode LONG_ARC
"""),

54 : _("""
 groupe de noeud  %(k1)s  vide
"""),

55 : _("""
 liste de composantes vide pour la methode LONG_ARC
"""),

56 : _("""
 liste RELATION_KIT vide
"""),

57 : _("""
 liste RELATION_KIT trop longue
"""),

58 : _("""
 1D ou C_PLAN ?
"""),

59 : _("""
 liste RELATION_KIT trop
### trop quoi ?
"""),

60 : _("""
  -> Le crit�re de convergence pour int�grer le comportement 'RESI_INTE_RELA'
     est lache (tr�s sup�rieur � la valeur par d�faut).
  -> Risque & Conseil :
     Cela peut nuire � la qualit� de la solution et � la convergence.
"""),

61 : _("""
 option  %(k1)s  non traitee
"""),

62 : _("""
 matrice non inversible
"""),

63 : _("""
 pas existence de solution pour le saut
"""),

64 : _("""
 existence d'un �l�ment � discontinuit� trop grand
 non unicit� du saut
"""),

65 : _("""
 non convergence du NEWTON pour le calcul du saut num�ro 1
"""),

66 : _("""
 non convergence du NEWTON pour le calcul du saut num�ro 2
"""),

67 : _("""
 non convergence du NEWTON pour le calcul du saut num�ro 3
"""),

68 : _("""
 erreur dans le calcul du saut
"""),

69 : _("""
 loi %(k1)s  non implantee pour les elemdisc 
"""),

70 : _("""
 elements isoparam�triques 2D non disponibles en grandes rotations
"""),

71 : _("""
 elements isoparam�triques 3D non disponibles en grandes rotations
"""),

72 : _("""
 seule une loi de comportement �lastique isotrope est valide pour
 le calcul de DG
"""),

73 : _("""
 le tenseur EPSEQ=0 on a donc une deriv�e DEPSEQ tr�s grande !
"""),

74 : _("""
  valeur de D_SIGM_EPSI non trouv�e
"""),

75 : _("""
  valeur de SY non trouv�e
"""),

76 : _("""
 d�veloppement non implant�
"""),

79 : _("""
 N doit etre > 0
"""),

80 : _("""
 PHI_ZERO < ou = � z�ro
"""),

81 : _("""
 1/k et l doivent etre >=0
"""),

82 : _("""
 PHI/KPHI0+L=0 et BETA<0
"""),

83 : _("""
 F(0) > 0 : erreur de conception
"""),

84 : _("""
 calcul flambement non lin�aire HPP
"""),

85 : _("""
 flambement non lin�aire GREEN
"""),

86 : _("""
 fonctionnalite modifi�e (dvlp)
"""),



96 : _("""
 comportement ZMAT obligatoire
"""),

97 : _("""
 il faut declarer lam_visc                           pour le fluage de dessication intrinseque
"""),

98 : _("""
 il faut d�clarer FONC_DESORP sous ELAS_FO pour le fluage de dessication
 intrinseque avec SECH comme param�tre
"""),

99 : _("""
 mauvais dimensionnement de GEOMM et GEOMP
"""),

}
