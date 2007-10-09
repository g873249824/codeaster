#@ MODIF algorith16 Messages  DATE 09/10/2007   AUTEUR COURTOIS M.COURTOIS 
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
 nombre de pas de calcul       :  %(i1)d
 nombre d'it�rations           :  %(i2)d
 ----------------------------------------------

"""),

2 : _("""
  infos noeuds de choc
  lieu de choc   :  %(i1)d
  noeud de choc  :  %(k1)s
"""),

3 : _("""
 sous-structure : %(k1)s
"""),

4 : _("""
 coordonnees    : x :  %(r1)f
                  y :  %(r2)f
                  z :  %(r3)f
"""),

5 : _("""
 noeud de choc  : %(k1)s
"""),

6 : _("""
 sous-structure : %(k1)s
"""),

7 : _("""
 coordonnees    : x : %(r1)f
                  y : %(r2)f
                  z : %(r3)f
"""),

8 : _("""
 amortissement tangent utilise :  %(r1)f

 origine choc x : %(r2)f
              y : %(r3)f
              z : %(r4)f

 norm_obst sin(alpha) : %(r5)f
           cos(alpha) : %(r6)f
           sin(beta)  : %(r7)f
           cos(beta)  : %(r8)f

 angl_vrille : sin(gamma) : %(r9)f
               cos(gamma) : %(r10)f
"""),

9 : _("""
 jeu initial :  %(r1)f
"""),

10 : _("""
"""),

11 : _("""
 le nb max d'iterations  %(i1)d  est atteint sans converger
 le r�sidu relatif final est  : %(r1)f

"""),

12 : _("""
 le nombre d'amortissements r�duits est trop grand
 le nombre de modes retenus vaut  %(i1)d
 et le nombre de coefficients :  %(i2)d
 on ne garde donc que les  %(i3)d
   %(k1)s
"""),

13 : _("""
 le nombre d'amortissements reduits est insuffisant
 il en manque :  %(i1)d
 car le nombre de modes vaut :  %(i2)d
 on rajoute  %(i3)d
   %(k1)s
   %(k2)s
"""),

14 : _("""
 pas de temps utilisateur trop grand :   %(r1)f
 pas de temps necessaire pour le calcul: %(r2)f
 risques de problemes de precision

"""),

15 : _("""
 pas de temps utilisateur trop grand :   %(r1)f
 pas de temps necessaire pour le calcul: %(r2)f
 parametres de calcul dans ce cas
 nb de pas de calcul :  %(i1)d

"""),

16 : _("""
 pas de temps utilisateur trop grand   : %(r1)f
 pas de temps necessaire pour le calcul: %(r2)f
"""),

17 : _("""
 parametres de calcul dans ce cas
 nb de pas de calcul :  %(i1)d

"""),

18 : _("""
 le nombre d'amortissements reduits est trop grand
 le nombre de modes propres vaut  %(i1)d
 et le nombre de coefficients :  %(i2)d
 on ne garde donc que les  %(i3)d
   %(k1)s

"""),

19 : _("""
 le nombre d'amortissements reduits est insuffisantil en manque :  %(i1)d
 car le nombre de modes vaut :  %(i2)d
 on rajoute  %(i3)d
   %(k1)s
   %(k2)s

"""),

20 : _("""
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!mode dynamique           :  %(i1)d
 amortissement trop grand :  %(r1)f
 amortissement critique   :  %(r2)f
 problemes de convergence possibles %(k1)s

"""),

21 : _("""
 taux de souplesse neglig�e : %(r1)f
"""),

22 : _("""
 calcul par superposition modale :
 la base de projection est un %(k1)s
 le nb d'�quations est          : %(i1)d
 la methode utilis�e est        : %(k2)s
 la base utilis�e est           : %(k3)s
 le nb de vecteurs de base est  :  %(i2)d
"""),

23 : _("""
 le pas de temps initial est  : %(r1)f
 le nb de pas d'archive est     :  %(i1)d
"""),

24 : _("""
 NUME_VITE_FLUI                 :  %(i1)d
 vitesse gap                    :  %(r1)f
 le nb de modes de BASE_FLUI    :  %(i2)d
 le nb total de modes de la base:  %(i3)d
 le pas de temps initial est    :  %(r2)f
 dur�e de l'excitation          :  %(r3)f
"""),

25 : _("""
 le nb de pas d'archive est     :  %(i1)d
"""),

26 : _("""
 le pas de temps du calcul est  : %(r1)f
 le nb de pas de calcul est     :  %(i1)d
 le nb de pas d'archive est     :  %(i2)d
"""),

27 : _("""
"""),

28 : _("""
 trop d'amortissements modaux
 nombre d'amortissement :  %(i1)d
 nombre de mode         :  %(i2)d

"""),

29 : _("""
 trop d'amortissements modaux
 nombre d'amortissement :  %(i1)d
 nombre de mode         :  %(i2)d

"""),

30 : _("""
 amortissement non diagonal
 on ne sait pas traiter  %(i1)d
"""),

31 : _("""
 il manque des amortissements modaux
 nombre d'amortissements :  %(i1)d
 nombre de modes         :  %(i2)d

"""),

32 : _("""
 on ne peut pas demander de r�ponse secondaire sans la r�ponse primaire
"""),

33 : _("""
 analyse spectrale :
 la base modale utilisee est :  %(k1)s
 le nombre de vecteurs de base est :  %(i1)d
 regle de combinaison modale :  %(k2)s
 les options de calcul demandees sont :  %(k3)s
"""),

34 : _("""
   %(k1)s
"""),

35 : _("""
 r�gle de combinaison des contributions
 de chaque mouvement d'appui :  %(k1)s
"""),

36 : _("""
 erreur dans les donn�es
 la masse n'existe pas dans la table  %(k1)s
"""),

37 : _("""
 erreur dans les donn�es
 la masse n"existe pas dans la table  %(k1)s
"""),

38 : _("""
 mode dynamique           :  %(i1)d
 amortissement trop grand :  %(r1)f
 amortissement critique   :  %(r2)f
 probleme de convergence possible %(k1)s
"""),

39 : _("""
 sous-structuration dynamique
 calcul par superposition modale
 ----------------------------------------------
 ! la numerotation utilisee est   :  %(k1)s
 ! le nb d'equations est          :  %(i1)d
 ! la methode utilisee est        :  %(k2)s
 !    - nb de vecteurs dynamiques :  %(i2)d
 !    - nb de deformees statiques :  %(i3)d
"""),

40 : _("""
 ! le pas de temps initial est  : %(r1)f
"""),

41 : _("""
 ! le pas de temps du calcul est  : %(r1)f
 ! le nb de pas de calcul est     :  %(i1)d
"""),

42 : _("""
 ! le nb de pas d'archive est     :  %(i1)d
"""),

43 : _("""
"""),

44 : _("""
 les interfaces de la liaison n'ont pas la meme longueur
  sous-structure 1 -->  %(k1)s
  interface 1      -->  %(k2)s
  sous-structure 2 -->  %(k3)s
  interface 2      -->  %(k4)s

"""),

45 : _("""
 conflit dans les vis_a_vis des noeudsle noeud  %(k1)s
 est le vis-a-vis des noeuds  %(k2)s
 et  %(k3)s

"""),

46 : _("""
 Le crit�re de v�rification ne peut etre relatif dans votre cas,
 la longueur caracteristique de l'interface de la sous-structure etant nulle.
  sous-structure 1 -->  %(k1)s
  interface 1      -->  %(k2)s
  sous-structure 2 -->  %(k3)s
  interface 2      -->  %(k4)s

"""),

47 : _("""
 les interfaces ne sont pas compatibles sous-structure 1 -->  %(k1)s
  interface 1      -->  %(k2)s
  sous-structure 2 -->  %(k3)s
  interface 2      -->  %(k4)s

"""),

48 : _("""
 les interfaces ne sont pas compatibles sous-structure 1 -->  %(k1)s
  interface 1      -->  %(k2)s
  sous-structure 2 -->  %(k3)s
  interface 2      -->  %(k4)s

"""),

49 : _("""
 les noeuds des interfaces ne sont pas alignes en vis-a-vis
  sous-structure 1 -->  %(k1)s
  interface 1      -->  %(k2)s
  sous-structure 2 -->  %(k3)s
  interface 2      -->  %(k4)s
 les noeuds ont ete reordonnes %(k5)s

"""),

50 : _("""
 les deux interfaces ont pas meme nombre de noeuds
 nombre noeuds interface droite -->  %(i1)d
 nombre noeuds interface gauche -->  %(i2)d

"""),

51 : _("""
 conflit dans les vis_a_vis des noeuds
 le noeud  %(k1)s
 est le vis-a-vis des noeuds  %(k2)s et  %(k3)s

"""),

52 : _("""
 axe de sym�trie cyclique diff�rent de Oz
 num�ro du couple de noeuds :  %(i1)d
 noeud droite -->  %(k1)s
 noeud gauche -->  %(k2)s

"""),

53 : _("""
  probleme de rayon droite-gauche differents
  numero du couple de noeuds :  %(i1)d
 noeud droite -->  %(k1)s
 noeud gauche -->  %(k2)s

"""),

54 : _("""
 probleme signe angle entre droite et gauche
 numero du couple de noeuds:  %(i1)d
 noeud droite -->  %(k1)s
 noeud gauche -->  %(k2)s

"""),

55 : _("""
 probleme valeur angle r�p�titivit� cyclique
 numero du couple de noeuds:  %(i1)d
 noeud droite -->  %(k1)s
 noeud gauche -->  %(k2)s

"""),

56 : _("""
  v�rification r�p�titivit� : aucune erreur d�tect�e
"""),

57 : _("""
 les noeuds des interfaces ne sont pas align�s en vis-a-vis
 les noeuds ont ete r�ordonn�s

"""),

58 : _("""
  arret sur probleme r�p�titivit� cyclique
  tentative de diagnostic:  %(k1)s
"""),

60 : _("""
 VISCOCHABOCHE : erreur d'int�gration
  - Essai d'int�gration num�ro :  %(i1)d
  - Convergence vers une solution non conforme,
  - Incr�ment de d�formation cumul�e n�gative = %(r1)f,
  - Changer la taille d'incr�ment.
"""),

61 : _("""
 VISCOCHABOCHE : erreur
  - Non convergence � l'it�ration maxi : %(i1)d
  - Convergence r�guli�re mais trop lente,
  - Erreur > %(r1)f
  - Diminuer la taille d'incr�ment

"""),

62 : _("""
 VISCOCHABOCHE: ERREUR)
  - Non convergence � l'it�ration maxi : %(i1)d
  - Convergence r�guli�re
  - Erreur > %(r1)f
  - Diminuer la taille d'incr�ment
"""),

63 : _("""
 VISCOCHABOCHE: ERREUR)
  - Non convergence � l'it�ration maxi : %(i1)d
  - Erreur > %(r1)f
  - Diminuer la taille d'incr�ment
"""),

64 : _("""
    NADAI_B, erreur d'int�gration
     - Essai d'int�gration num�ro : %(i1)d
     - Convergence vers une solution non conforme,
     - Incr�ment de d�formation cumul�e n�gative = %(r1)f
     - Changer la taille d'incr�ment
"""),

65 : _("""
    NADAI_B : ERREUR
     - Non convergence a it�ration maxi : %(i1)d
     - Convergence r�guli�re mais trop lente
     - ERREUR > %(r1)f
     - Diminuer la taille d'incr�ment
 """),

66 : _("""
    NADAI_B : ERREUR
     - Non convergence � it�ration maxi : %(i1)d
     - Convergence irr�guli�re & erreur > %(r1)f
     - Diminuer la taille d'incr�ment
 """),

67 : _("""
   NADAI_B : ERREUR
     - Non convergence � it�ration maxi : %(i1)d
     - ERREUR > %(r1)f
     - Diminuer la taille d'incr�ment
 """),

68 : _("""
 Arret par manque de temps CPU au num�ro d'ordre %(i1)d

   - Temps moyen par incr�ment de temps : %(r1)f
   - Temps CPU restant :                  %(r2)f

 La base globale est sauvegard�e, elle contient les pas archiv�s avant l'arret

 """),

69 : _("""
    %(k1)s: ERREUR
      - Non convergence a it�ration maxi : %(i1)d
      - Convergence r�guli�re mais trop lente
      - ERREUR > %(r1)f
      - Diminuer la taille d'incr�ment
 """),

70 : _("""
    %(k1)s: ERREUR
     - Non convergence � it�ration maxi : %(i1)d
     - Convergence irr�guli�re & erreur > %(r1)f
     - Diminuer la taille d'incr�ment
 """),

71 : _("""
    %(k1)s: ERREUR
     - Non convergence � it�ration maxi : %(i1)d
     - ERREUR > %(r1)f
     - Diminuer la taille d'incr�ment

 """),

72 : _("""
   LMARC : erreur d'int�gration
     - Essai d'int�gration num�ro : %(i1)d
     - Divergence de l'int�gration locale
     - Diminuer la taille d'incr�ment
 """),

73 : _("""
   LMARC : erreur d'int�gration
     - Essai d'int�gration num�ro : %(i1)d
     - Convergence vers une solution non conforme
     - Incr�ment de d�formation cumul�e n�gative : %(r1)f
     - Changer la taille d'incr�ment
 """),

74 : _("""
   LMARC : erreur
     - Non convergence a it�ration maxi :  %(i1)d
     - Convergence r�guli�re mais trop lente
     - Diminuer la taille d'incr�ment
 """),

75 : _("""
   LMARC : erreur
     - Non convergence a it�ration maxi :  %(i1)d
     - Convergence irr�guli�re & erreur >  %(r1)f
     - Diminuer la taille d'incr�ment
 """),

76 : _("""
   LMARC : erreur
     - Non convergence a it�ration maxi :  %(i1)d
     - erreur > %(r1)f
     - Diminuer la taille d'incr�ment
 """),

77 : _("""
   Arret par manque de temps CPU au num�ro d'ordre : %(i1)d
     - Dernier instant archiv� :      %(r1)f
     - Num�ro d'ordre correspondant : %(i2)d
     - Temps moyen par pas de temps : %(r2)f
     - Temps CPU restant :            %(r3)f
  """),

78 : _("""
  Pr�cision du transitoire : %(r1)f
  """),

79 : _("""
 Couplage temporel avec NB modes : %(i1)d
  """),

80 : _("""
 Le nombre de lieu(x) de choc est : %(i1)d
  """),

81 : _("""
 Le nombre de dispositifs anti-sismique est : %(i1)d
  """),

82 : _("""
 le nombre de lieu(x) de choc avec flambement est : %(i1)d
  """),

83 : _("""
 Le nombre de RELA_EFFO_DEPL est : %(i1)d
  """),

84 : _("""
 Le nombre de RELA_EFFO_VITE est : %(i1)d
  """),

85 : _("""
 Nature de l'excitation : %(k1)s
  """),

86 : _("""
 R�gles de combinaison des r�ponses directionnelles : %(k1)s
  """),

87 : _("""
   Arret par manque de temps CPU
     - Instant courant :              %(r1)f
     - Nombre d'appels � ALITMI :     %(i1)d
     - Temps moyen par pas de temps : %(r2)f
     - Temps CPU restant :            %(r3)f
  """),

88 : _("""
   Arret par manque de temps CPU au pas de temps : %(i1)d
     - A l'instant  :                %(r1)f
     - Temps moyen par pas :         %(r2)f
     - Temps CPU restant :           %(r3)f
  """),

89 : _("""
   On passe outre car VERI_PAS = NON
  """),

90 : _("""
   Point : %(r1)f %(r2)f
  """),

91 : _("""
   Point : %(r1)f %(r2)f %(r3)f

  """),

92 : _("""
   Au noeud de choc %(k1)s
  """),

93 : _("""
   Pour le noeud n0 : %(i1)d
    - Raideur locale DEPX : %(r1)f
    - Raideur locale DEPY : %(r2)f
    - Raideur locale DEPZ : %(r3)f
  """),

94 : _("""
  il manque les param�tres de Van_Genuchten
 """),

95 : _("""
  Van_Genuchten non autoris� pour ce mod�le de couplage
 """),

}
