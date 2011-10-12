#@ MODIF algorith16 Messages  DATE 12/10/2011   AUTEUR COURTOIS M.COURTOIS 
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

cata_msg = {

1 : _(u"""
 nombre de pas de calcul       :  %(i1)d
 nombre d'it�rations           :  %(i2)d
 ----------------------------------------------

"""),

2 : _(u"""
  infos noeuds de choc
  lieu de choc   :  %(i1)d
  noeud de choc  :  %(k1)s
"""),

3 : _(u"""
 sous-structure : %(k1)s
"""),

4 : _(u"""
 coordonn�es    : x :  %(r1)f
                  y :  %(r2)f
                  z :  %(r3)f
"""),

5 : _(u"""
 noeud de choc  : %(k1)s
"""),

8 : _(u"""
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

9 : _(u"""
 jeu initial :  %(r1)f
"""),

10 : _(u"""
 <INFO> Pour l'occurrence num�ro %(i1)d du mot-cl� facteur CHOC, RIGI_TAN est
 renseign� mais pas AMOR_TAN. Le code a donc attribu� � AMOR_TAN une valeur
 optimis�e : %(r1)f
"""),

11 : _(u"""
 le nb max d'iterations  %(i1)d  est atteint sans converger
 le r�sidu relatif final est  : %(r1)f

"""),

12 : _(u"""
 le nombre d'amortissements r�duits est trop grand
 le nombre de modes retenus vaut  %(i1)d
 et le nombre de coefficients :  %(i2)d
 on ne garde donc que les  %(i3)d
   %(k1)s
"""),

13 : _(u"""
 le nombre d'amortissements r�duits est insuffisant
 il en manque :  %(i1)d
 car le nombre de modes vaut :  %(i2)d
 on rajoute  %(i3)d
 amortissements r�duits avec la valeur du dernier mode propre

"""),

14 : _(u"""
 pas de temps utilisateur trop grand :   %(r1)f
 pas de temps necessaire pour le calcul: %(r2)f
 risques de problemes de precision

"""),

15 : _(u"""
 pas de temps utilisateur trop grand :   %(r1)f
 pas de temps necessaire pour le calcul: %(r2)f
 parametres de calcul dans ce cas
 nb de pas de calcul :  %(i1)d

"""),

16 : _(u"""
 pas de temps utilisateur trop grand   : %(r1)f
 pas de temps necessaire pour le calcul: %(r2)f
"""),

17 : _(u"""
 parametres de calcul dans ce cas
 nb de pas de calcul :  %(i1)d

"""),

18 : _(u"""
 le nombre d'amortissements reduits est trop grand
 le nombre de modes propres vaut  %(i1)d
 et le nombre de coefficients :  %(i2)d
 on ne garde donc que les  %(i3)d
   %(k1)s

"""),

19 : _(u"""
 le nombre d'amortissements reduits est insuffisantil en manque :  %(i1)d
 car le nombre de modes vaut :  %(i2)d
 on rajoute  %(i3)d
 amortissements r�duits avec la valeur du dernier mode propre

"""),

20 : _(u"""
 mode dynamique           :  %(i1)d
 amortissement trop grand :  %(r1)f
 amortissement critique   :  %(r2)f
 problemes de convergence possibles %(k1)s

"""),

21 : _(u"""
 taux de souplesse neglig�e : %(r1)f
"""),

22 : _(u"""
 calcul par superposition modale :
 la base de projection est un %(k1)s
 le nb d'�quations est          : %(i1)d
 la methode utilis�e est        : %(k2)s
 la base utilis�e est           : %(k3)s
 le nb de vecteurs de base est  :  %(i2)d
"""),

23 : _(u"""
 le pas de temps initial est  : %(r1)f
 le nb de pas d'archive est     :  %(i1)d
"""),

24 : _(u"""
 NUME_VITE_FLUI                 :  %(i1)d
 vitesse gap                    :  %(r1)f
 le nb de modes de BASE_FLUI    :  %(i2)d
 le nb total de modes de la base:  %(i3)d
 le pas de temps initial est    :  %(r2)f
 dur�e de l'excitation          :  %(r3)f
"""),

25 : _(u"""
 le nb de pas d'archive est     :  %(i1)d
"""),

26 : _(u"""
 le pas de temps du calcul est  : %(r1)f
 le nb de pas de calcul est     :  %(i1)d
 le nb de pas d'archive est     :  %(i2)d
"""),

38 : _(u"""
 mode dynamique           :  %(i1)d
 amortissement trop grand :  %(r1)f
 amortissement critique   :  %(r2)f
 probleme de convergence possible %(k1)s
"""),

39 : _(u"""
 sous-structuration dynamique
 calcul par superposition modale

 la numerotation utilisee est   :  %(k1)s
 le nb d'equations est          :  %(i1)d
 la methode utilisee est        :  %(k2)s
    - nb de vecteurs dynamiques :  %(i2)d
    - nb de deformees statiques :  %(i3)d
"""),

40 : _(u"""
 le pas de temps initial est  : %(r1)f
"""),

41 : _(u"""
 le pas de temps du calcul est  : %(r1)f
 le nb de pas de calcul est     :  %(i1)d
"""),

42 : _(u"""
 le nb de pas d'archive est     :  %(i1)d
"""),

44 : _(u"""
 les interfaces de la liaison n'ont pas la meme longueur
  sous-structure 1 -->  %(k1)s
  interface 1      -->  %(k2)s
  sous-structure 2 -->  %(k3)s
  interface 2      -->  %(k4)s

"""),

45 : _(u"""
 conflit dans les vis_a_vis des noeudsle noeud  %(k1)s
 est le vis-a-vis des noeuds  %(k2)s
 et  %(k3)s

"""),

46 : _(u"""
 Le crit�re de v�rification ne peut etre relatif dans votre cas,
 la longueur caracteristique de l'interface de la sous-structure etant nulle.
  sous-structure 1 -->  %(k1)s
  interface 1      -->  %(k2)s
  sous-structure 2 -->  %(k3)s
  interface 2      -->  %(k4)s

"""),

47 : _(u"""
 les interfaces ne sont pas compatibles sous-structure 1 -->  %(k1)s
  interface 1      -->  %(k2)s
  sous-structure 2 -->  %(k3)s
  interface 2      -->  %(k4)s

"""),

48 : _(u"""
 les interfaces ne sont pas compatibles sous-structure 1 -->  %(k1)s
  interface 1      -->  %(k2)s
  sous-structure 2 -->  %(k3)s
  interface 2      -->  %(k4)s

"""),


50 : _(u"""
 les deux interfaces ont pas meme nombre de noeuds
 nombre noeuds interface droite -->  %(i1)d
 nombre noeuds interface gauche -->  %(i2)d

"""),

51 : _(u"""
 conflit dans les vis_a_vis des noeuds
 le noeud  %(k1)s
 est le vis-a-vis des noeuds  %(k2)s et  %(k3)s

"""),

52 : _(u"""
 axe de sym�trie cyclique diff�rent de Oz
 num�ro du couple de noeuds :  %(i1)d
 noeud droite -->  %(k1)s
 noeud gauche -->  %(k2)s

"""),

53 : _(u"""
  probleme de rayon droite-gauche differents
  numero du couple de noeuds :  %(i1)d
 noeud droite -->  %(k1)s
 noeud gauche -->  %(k2)s

"""),

54 : _(u"""
 probleme signe angle entre droite et gauche
 numero du couple de noeuds:  %(i1)d
 noeud droite -->  %(k1)s
 noeud gauche -->  %(k2)s

"""),

55 : _(u"""
 probleme valeur angle r�p�titivit� cyclique
 numero du couple de noeuds:  %(i1)d
 noeud droite -->  %(k1)s
 noeud gauche -->  %(k2)s

"""),

56 : _(u"""
  v�rification r�p�titivit� : aucune erreur d�tect�e
"""),

57 : _(u"""
 les noeuds des interfaces ne sont pas align�s en vis-a-vis
 les noeuds ont ete r�ordonn�s

"""),

58 : _(u"""
  arret sur probleme r�p�titivit� cyclique
  tentative de diagnostic:  %(k1)s
"""),

60 : _(u"""
 VISCOCHABOCHE : erreur d'int�gration
  - Essai d'int�gration num�ro :  %(i1)d
  - Convergence vers une solution non conforme,
  - Incr�ment de d�formation cumul�e n�gative = %(r1)f,
  - Changer la taille d'incr�ment.
"""),

68 : _(u"""
 Arret par manque de temps CPU au num�ro d'ordre %(i1)d

   - Temps moyen par incr�ment de temps : %(r1)f
   - Temps CPU restant :                  %(r2)f

 La base globale est sauvegard�e, elle contient les pas archiv�s avant l'arret

 """),

72 : _(u"""
Erreur utilisateur :
  On veut d�placer "au quart" les noeuds milieux des ar�tes pr�s du fond de fissure
  (MODI_MAILLAGE / MODI_MAILLE / OPTION='NOEUD_QUART') pour obtenir des �l�ments de Barsoum.

  Mais on ne trouve aucun noeud � d�placer !

Risques & conseils :
  * Avez-vous v�rifi� que le maillage est "quadratique" ?
  * Si votre maillage est lin�aire et que vous souhaitez une solution pr�cise
    grace aux �l�ments de Barsoum, vous devez au pr�alable utiliser la commande :
      CREA_MAILLAGE / LINE_QUAD  pour rendre le maillage quadratique.
 """),




77 : _(u"""
   Arret par manque de temps CPU au num�ro d'ordre : %(i1)d
     - Dernier instant archiv� :      %(r1)f
     - Num�ro d'ordre correspondant : %(i2)d
     - Temps moyen par pas de temps : %(r2)f
     - Temps CPU restant :            %(r3)f
  """),

78 : _(u"""
  Pr�cision du transitoire : %(r1)f
  """),

79 : _(u"""
 Couplage temporel avec NB modes : %(i1)d
  """),

80 : _(u"""
 Le nombre de lieu(x) de choc est : %(i1)d
  """),

81 : _(u"""
 Le nombre de dispositifs anti-sismique est : %(i1)d
  """),

82 : _(u"""
 le nombre de lieu(x) de choc avec flambement est : %(i1)d
  """),

83 : _(u"""
 Le nombre de RELA_EFFO_DEPL est : %(i1)d
  """),

84 : _(u"""
 Le nombre de RELA_EFFO_VITE est : %(i1)d
  """),

87 : _(u"""
   Arret par manque de temps CPU
     - Instant courant :              %(r1)f
     - Nombre d'appels � ALITMI :     %(i1)d
     - Temps moyen par pas de temps : %(r2)f
     - Temps CPU restant :            %(r3)f
  """),

88 : _(u"""
   Arret par manque de temps CPU au pas de temps : %(i1)d
     - A l'instant  :                %(r1)f
     - Temps moyen par pas :         %(r2)f
     - Temps CPU restant :           %(r3)f
  """),

89 : _(u"""
   On passe outre car VERI_PAS = NON
  """),

91 : _(u"""
   La sous-structuration n'est compatible qu'avec un mode de parall�lisme centralis�.

   Conseil :
     - Renseignez le mot-cl� PARTITION/PARALLELISME de AFFE_MODELE (ou MODI_MODELE) avec 'CENTRALISE'
  """),

92 : _(u"""
   Au noeud de choc %(k1)s
  """),

93 : _(u"""
 Il y a moins de mailles (%(i1)d) dans le mod�le que de processeurs participant au calcul (%(i2)d).

 Conseils :
   - v�rifiez qu'un calcul parall�le est appropri� pour votre mod�le
   - diminuez le nombre de processeurs du calcul
"""),

94 : _(u"""
  il manque les param�tres de Van_Genuchten
 """),

95 : _(u"""
  Van_Genuchten non autoris� pour ce mod�le de couplage
 """),

96 : _(u"""
  Comportement ZEDGAR : la d�riv�e est nulle.
"""),

97 : _(u"""
Erreur d'utilisation pour le parall�lisme :
 Le mode de r�partition des �l�ments entre les diff�rents processeurs (PARTITION / PARALLELISME='GROUP_ELEM')
 ne peut pas etre utilis� ici car il y a moins de groupes d'�l�ments (%(i1)d) que de processeurs (%(i2)d).
 En d'autres termes, il n'y a pas assez d'�l�ments � r�partir (le mod�le est trop petit).

 Conseils :
   - diminuez le nombre de processeurs du calcul
   - changez le mode de distribution des mailles avec le mot-cl� PARTITION / PARALLELISME de l'op�rateur
     AFFE_MODELE (ou MODI_MODELE)
"""),

98: _(u"""
  La maille de num�ro:  %(i1)d appartient � plusieurs sous-domaines !
"""),

99 : _(u"""
 Le param�tre CHARGE_PROC0_SD du mot-cl� facteur PARTITION est mal renseign�.
 Il faut qu'il reste au moins un sous domaine par processeur une fois affect�s tous les sous-domaines du processeur 0.

 Conseils :
   - laissez le mot-cl� CHARGE_PROC0_SD � sa valeur par d�faut
   - diminuez le nombre de processeurs du calcul ou bien augmentez le nombre de sous-domaines de la partition du mot-cl� PARTITION
"""),

}
