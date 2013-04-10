#@ MODIF xfem Messages  DATE 09/04/2013   AUTEUR JAUBERT A.JAUBERT 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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

2: _(u"""
  -> Le calcul de la distance d'un noeud � l'ellipse n'a pas converg�
     avec le nombre d'it�rations maximal fix� (10). Cela est d� � une
     ellipse tr�s allong�e.
  -> Conseil:
     Contacter les d�veloppeurs.
     Dans la mesure du possible, d�finissez une ellipse moins allong�e.
"""),


3: _(u"""
  -> Le mod�le %(k1)s est incompatible avec la m�thode X-FEM.
  -> Risque & Conseil:
     V�rifiez qu'il a bien �t� cr�� par l'op�rateur MODI_MODELE_XFEM.
"""),

4: _(u"""
  -> Il est interdit de m�langer dans un mod�le les fissures X-FEM
     avec et sans contact.
  -> Risque & Conseil:
     Veuillez rajouter les mots cl�s CONTACT manquants
     dans DEFI_FISS_XFEM.
"""),

5: _(u"""
  -> Attention, vous avez d�fini un enrichissement g�om�trique sur %(i1)d
     couches d'�l�ments autour du fond de fissure.
  -> Risque :
     Au del� de 7 couches, il y a des risques de pivots nuls lors de la
     r�solution dans STAT_NON_LINE.
  -> Conseils :
     Pour �viter ces risques de pivots nuls, il est conseill� de ne pas
     d�passer NB_COUCHES = 7.
     Vous pouvez aussi laisser NB_COUCHES = %(i1)d, mais il pourra s'av�rer
     n�cessaire d'augmenter le nombre maximales de d�cimales perdues dans
     STAT_NON_LINE (mot-cl� NPREC de SOLVEUR pour les m�thodes LDLT, MULT_FRONT
     ou FETI.
"""),

6: _(u"""
  -> Le rayon d'enrichissement RAYON_ENRI doit �tre un r�el strictement
     sup�rieur � 0.
"""),

7: _(u"""
     Il y a %(i1)d mailles %(k1)s
"""),

8: _(u"""
     Le nombre de %(k1)s X-FEM est limit� � 10E6.
     Risque & Conseil:
     Veuillez r�duire la taille du maillage.
"""),

9: _(u"""
     Le groupe de mailles donn� pour d�finir la fissure contient des
     mailles qui ne sont pas connect�es aux autres. Cela emp�che
     d'orienter correctement la normale � la surface de la fissure.

     Risque & Conseil:
       Veuillez v�rifier que les mailles donn�es en entr�e sont toutes
       connect�es entre elles, c'est-�-dire qu'elle forme un groupe de
       mailles contigu�s.
       Sinon, il faut d�finir une fissure pour chacun des groupes
       non connexes.
"""),

10: _(u"""
     La direction du champ th�ta n'a pas �t� donn�e. La direction automatique
     est une direction variable, bas�e sur le gradient de la level-set tangente.
"""),

11: _(u"""
  -> On a trouv� plus de 2 points de fond de fissure, ce qui est impossible en 2D.
  -> Risque & Conseil:
     Cela est normalement caus� par une mauvaise d�finition des level-sets.

     Si les level-sets ont �t� d�finies par DEFI_FISS_XFEM, veuillez revoir leur
     d�finition.

     Si les level-sets ont �t� calcul�es par PROPA_FISS, vous pouvez essayer
     d'utiliser un maillage plus raffin� dans toute la zone de propagation ou bien
     une grille auxiliaire.
     Si vous avez utilis� la m�thode simplexe avec restriction de la zone de mise �
     jour des level-sets (ZONA_MAJ='TORE'), vous pouvez sp�cifier un rayon plus �lev�
     de celui qui a �t� utilis� (�crit dans le fichier .mess) en utilisant l'op�rande
     RAYON_TORE ou vous pouvez d�activer la restriction de la zone de mise � jour
     (ZONE_MAJ='TOUT').
     Sinon vous pouvez changer la m�thode utilis�e par PROPA_FISS (op�rande
     METHODE_PROPA).
"""),

12: _(u"""
  Le gradient de la level-set tangente est nul au noeud %(k1)s.
  Ceci est certainement du � un point singulier dans la d�finition de la level-set.
  Il vaut veiller � ce que ce point singulier ne soit pas inclus dans la couronne
  d'int�gration du champ th�ta.
  Conseil : r�duisez la taille de la couronne du champ th�ta : (mots-cl�s RSUP et RINF).
"""),

13: _(u"""
     Dans le mod�le, des mailles SEG2 ou SEG3 poss�dent des noeuds enrichis par X-FEM.
     Ceci n'est pas encore possible en 3D.
     Conseils : si ces mailles sont importantes pour le calcul (charge lin�ique...), il faut
     les mettre loin de de la fissure.
     Si ces mailles ne servent pas pour le calcul, il vaut mieux ne pas les affecter dans le mod�le,
     ou bien les supprimer du maillage.
"""),

14: _(u"""
     On ne peut pas appliquer un cisaillement 2d sur les l�vres d'une fissure X-FEM.
"""),

15: _(u"""
  -> Cette option n'a pas encore �t� programm�e.
  -> Risque & Conseil:
     Veuillez utiliser un autre chargement (en pression) ou contacter votre
     correspondant.
"""),

16: _(u"""
  -> Il n'y a aucun �l�ment enrichi.
"""),

17: _(u"""
     il ne faut qu'un mot-cl� parmi RAYON_ENRI et NB_COUCHES.
"""),

18: _(u"""
     Dimension de l'espace incorrecte.
     Le mod�le doit �tre 2D ou 3D et ne pas comporter de sous-structures.
"""),

19: _(u"""
     Il y a %(i1)d mailles dans la zone fissure.
"""),

20: _(u"""
     Vous avez d�fini plus d'un fond ferm� lors d'un appel � DEFI_FISS_XFEM.
     Conseil:
     Veuillez d�finir chacun des fonds dans des DEFI_FISS_XFEM diff�rents.
"""),

21: _(u"""
     Vous avez d�fini au moins un fond ouvert et un fond ferm� lors d'un appel � 
     DEFI_FISS_XFEM.
     Conseil:
     Veuillez d�finir chacun des fonds dans des DEFI_FISS_XFEM diff�rents.
"""),



23: _(u"""
     Erreur dans le choix de la m�thode de calcul des level-sets.
     Vous souhaitez d�finir une %(k1)s.
     Or la forme que vous avez s�lectionn�e < %(k2)s >
     correspond � une %(k3)s.
     Conseil :
     S�lectionnez une forme de %(k1)s.
"""),

24: _(u"""
     Erreur dans le choix de la m�thode de calcul des level-sets.
     Vous souhaitez d�finir une fissure.
     Pour cela il est n�cessaire de d�finir 2 level-sets : LT et LN.
     Conseil :
     Veuillez renseignez %(k1)s.
"""),

25: _(u"""
     Erreur dans le choix de la m�thode de calcul des level-sets.
     Vous souhaitez d�finir une interface.
     Pour cela il ne faut est pas d�finir la level-set normale LT.
     %(k1)s ne sera pas consid�r�.
     Conseil :
     Pour ne plus obtenir ce message, ne renseignez pas %(k1)s.
"""),

26: _(u"""
     Num�ros des mailles de la zone fissure.
"""),

29: _(u"""
     Nombre de mailles contenant le fond de fissure : %(i1)d
"""),

30: _(u"""
     Nombre de mailles de type Heaviside : %(i1)d
"""),

31: _(u"""
     Nombre de mailles de type Crack-tip : %(i1)d
"""),

32: _(u"""
     Nombre de mailles de type Heaviside Crack-tip : %(i1)d
"""),

33: _(u"""
     Nombre de points du fond de fissure : %(i1)d
"""),

34: _(u"""
     Nombre de fonds de fissure : %(i1)d
"""),

35: _(u"""
     Coordonn�es des points des fonds de fissure
"""),

36: _(u"""
     fond de fissure : %(i1)d
"""),

37: _(u"""
     Nombre de level-sets r�ajust�es : %(i1)d
"""),

38: _(u"""
     Si vous �tes en 2D pour l'approche de contact <<Grands glissements avec XFEM>>,
     seule la formulation aux noeuds sommets est possible si la fissure poss�de un fond.
     Vous pouvez activer cette formulation en commentant LINE_QUAD afin que les mailles
     soient de type QUAD4 ou TRIA3.

"""),

39: _(u"""
     Erreur utilisateur : incoh�rence entre les mots-cl�s FISSURE et MODELE_IN.
     Il faut que les (ou la) fissure sous le mot-cl� FISSURE soient toutes d�finies �
     partir du m�me mod�le.
     Or :
     - la fissure %(k1)s est d�finie � partir du mod�le %(k2)s
     - le mod�le renseign� sous MODELE_IN est %(k3)s.
     Conseil :
     Veuillez revoir la d�finition de la fissure %(k1)s ou bien changer MODELE_IN.
"""),

40: _(u"""
      La maille %(k1)s doit �tre enrichie avec plus de 4 fonctions Heaviside,
      le multi-Heaviside est limit� � 4 fonctions Heaviside, un noeud du maillage
      ne doit pas �tre connect� � plus de 4 fissures.
      Pour ne pas activer le multi-Heaviside, les fissures doivent �tre s�par�es de 2 mailles
      minimum. Veuillez raffiner le maillage entre les fissures (ou �carter les fissures).
"""),

41: _(u"""
      La maille %(k1)s est quadratique et elle est connect�e � 2 fissures,
      le multi-Heaviside n'a �t� g�n�ralis� en quadratique.
      Pour ne pas activer le multi-Heaviside, les fissures doivent �tre s�par�es de 2 mailles
      minimum. Veuillez raffiner le maillage entre les fissures (ou �carter les fissures).
"""),

42: _(u"""
      La table de facteurs d'intensit� des contraintes donn�e en entr� pour la fissure
      %(k1)s ne contient pas le bon num�ro de fonds de fissure et/ou de points.

      Veuillez faire les v�rifications suivantes:
      - si la fissure %(k1)s  est form�e par un seul fond, veuillez v�rifier d'avoir donn�
        la bonne table
      - si la fissure %(k1)s est form�e par plusieurs fonds, veuillez v�rifier que la
        table donn�e contient les valeurs des facteurs d'intensit� des contraintes de
        chaque fond (voir colonne NUME_FOND de la table)
"""),


43: _(u"""
      Le contact autre que P1P1 est actif et la maille %(k1)s est connect�e � 2 fissures,
      le multi-Heaviside ne peut pas �tre pris en compte si le contact autre que P1P1 est utilis�.
      Pour ne pas activer le multi-Heaviside, les fissures doivent �tre s�par�es de 2 mailles
      minimum. Veuillez raffiner le maillage entre les fissures (ou �carter les fissures).
"""),

44: _(u"""
      La maille %(k1)s est connect�e � 2 fissures, or il s'agit d'une maille poss�dant des
      enrichissements de fond de fissure.
      Le multi-Heaviside ne peut pas �tre pris en compte en fond de fissure.
      Pour ne pas activer le multi-Heaviside, les fissures doivent �tre s�par�es de 2 mailles
      minimum. Veuillez raffiner le maillage entre les fissures (ou �carter les fissures).
"""),

45: _(u"""
      Jonction X-FEM et contact

      Une facette de contact XFEM doit �tre red�coup�e. Ceci n'est pas impl�ment� pour l'instant.
      Les efforts de contact ne seront pas prise en compte sur cette facette.
"""),

46: _(u"""
      Les fissures sont mal ordonn�es dans le mot cl� FISSURE de MODI_MODELE_XFEM

      L'ordre dans lequel sont d�finis les fissures avec l'utilisation du mot cl� JONCTION impose que %(k1)s doit
      �tre donn� apr�s %(k2)s. Veiller permuter %(k1)s et %(k2)s dans le mot cl� FISSURE de MODI_MODELE_XFEM.
"""),

47: _(u"""
      La fissure %(k1)s est d�j� attach� � la fissure %(k2)s, on ne peut pas l'attacher � %(k3)s.

      Il est possible d'attacher globalement %(k1)s � la fois � %(k2)s et %(k3)s,
      mais il ne faut pas qu'un �l�ment soit connect� � la fois � %(k2)s, %(k3)s et %(k1)s.

      Pour r�soudre ce probl�me, soit il faut �carter (ou raffiner le maillage entre) les fissures %(k2)s et %(k3)s.
      Soit il faut lier la fissure %(k3)s � la fissure %(k2)s en ajoutant une ligne du type
      JONCTION=_F(FISSURE=%(k2)s,POINT=...) lorsqu'on appelle DEFI_FISS_XFEM pour d�finir %(k3)s.
"""),

48: _(u"""
     Le calcul de G avec X-FEM est impossible avec COMP_INCR.
"""),

49: _(u"""
     Le calcul de G avec X-FEM est impossible en grandes d�formations.
"""),

50: _(u"""
     La m�thode X-FEM n'est pas disponible avec 'PETIT_REAC'.
"""),

51: _(u"""
     La maille %(k1)s poss�de %(i1)d points de fond de fissure de coordonn�es :
"""),

52: _(u"""
     Une ou des mailles contenant plus de 2 points du fond de fissure ont �t� d�tect�es.
     Le fond ne peut pas �tre orient� sous cette condition. Il n'est donc pas possible
     de calculer les abscisses curvilignes du fond et de d�tecter les fonds multiples.
     Par cons�quent le post-traitement avec la commande CALC_G n'est pas possible.
"""),

57: _(u"""
  -> La fissure (ou l'interface) d�finie dans DEFI_FISS_XFEM ne coupe aucune des mailles
     du maillage. La fissure (ou l'interface) se trouve donc en dehors de la structure ou
     bien co�ncide avec un bord de la structure. Cela est interdit. Il y a probablement
     une erreur de mise en donn�es.
  -> Conseil :
     V�rifier la coh�rence entre la d�finition de la g�om�trie de la fissure et le maillage.
"""),

58: _(u"""
  -> Aucun point du fond de fissure n'a �t� trouv� !
     Cela signifie que le fond de fissure se trouve en dehors de la structure.

  -> Risque & Conseil :
     - Si vous souhaitiez d�finir une interface, il faut choisir TYPE_DISCONTINUITE = 'INTERFACE'
        pour ne plus avoir ce message.
     -  Si vous souhaitiez d�finir une fissure, il doit y avoir une erreur lors de la d�finition
        de la level-set tangente V�rifier la d�finition des level-sets.
"""),

59: _(u"""
     Ne pas utiliser le mot-clef RAYON_ENRI lorsque le fond de fissure
     est en dehors de la structure.
"""),


61: _(u"""
  -> Une face contient au moins 3 points d'intersection avec la courbe d'isovaleur z�ro du champ
     de level-set car la valeur des level-sets aux noeuds de la maille a probablement �t�
     mal r�actualis�e lors de la phase de r�initialisation ou � la propagation pr�c�dente.
  -> Risque & Conseil:
     Vous pouvez utiliser un maillage plus raffin� ou bien une grille auxiliaire plus
     raffin� du maillage actuel.
     Vous pouvez v�rifier que la zone de mise � jour des level-sets est localis� autour du
     fond de la fissure (il ne faut pas utiliser ZONE_MAJ='TOUT' dans PROPA_FISS). Dans ce
     cas, si vous utilisez la m�thode simplexe (METHODE='SIMPLEXE'), vous pouvez essayer
     d'utiliser un rayon de localisation plus �lev� (op�rande RAYON_TORE).
     Si vous utilisez la m�thode simplexe, vous pouvez essayer d'utiliser la m�thode UPWIND
     qui est plus robuste, stable et performante (METHODE='UPWIND').

     Dans tout le cas, il faut v�rifier que l'angle de propagation de la fissure calcul�e
     par CALC_G a sens physique pour le probl�me � r�soudre.
"""),

63: _(u"""
  -> ---�l�ments XFEM quadratiques 2D---
       Un sous �l�ment est d�coup� par la courbe d'isovaleur z�ro de la level-set normale en deux endroits
       sur une ar�te.
       Cette configuration est proscrite.
"""),

64: _(u"""
  -> ---�l�ments XFEM quadratiques 2D---
     Le calcul ne peut aboutir pour l'une des raisons suivante :
     - les calculs des coordonn�es des points d'intersection entre un �l�ment et la fissure
       se sont mal d�roul�s
     - l'�l�ment ne peut �tre d�coup� selon la configuration de fissure qui le traverse
"""),

65: _(u"""
  -> ---�l�ments XFEM quadratiques 2D---
     On recherche un point de la courbe d'isovaleur z�ro de la level-set normale d�coupant l'ar�te
     d'un sous �l�ment qui n'existe pas.
"""),

66: _(u"""
  -> ---�l�ments XFEM quadratiques 2D---
     Le calcul d'abscisse curviligne sur une ar�te quadratique ne peut aboutir pour l'une des
     raisons suivante :
     - les trois points qui d�finissent l'ar�te quadratique sont identiques
     - l'ar�te est "trop" arrondie
"""),

67: _(u"""
  -> ---�l�ments XFEM quadratiques 2D---
     Newton : nombre d'it�rations maximal atteint
"""),

68: _(u"""
  -> Aucune grille n'est associ�e � la fissure donn�e par FISS_GRILLE.

  -> Risque & Conseil:
     Veuillez donner une fissure avec une grille associ�e.

"""),

69: _(u"""
  -> La fissure � propager a �t� d�finie par DEFI_FISS_XFEM en donnant directement les deux
     champs level-sets (mots-cl�s CHAMP_NO_LSN et CHAMP_NO_LST).
     Aucune grille auxiliaire n'a �t� associ�e � cette fissure.

  -> Risque & Conseil:
     Dans le cas o� les deux champs level-sets ont �t� obtenus d'une fissure propag�e par
     PROPA_FISS, les informations sur la localisation du domaine (mot-cl� ZONE_MAJ) et sur
     l'utilisation d'une grille auxiliaire ont �t� perdues, ce qui fait que le calcul de la
     propagation de la fissure pourrait donner des r�sultats faux.

     Vous pouvez ignorer cette alarme seulement si les deux champs level-sets donn�s dans
     DEFI_FISS_XFEM:
     - n'ont pas �t� calcul�s par PROPA_FISS, c'est-�-dire qu'ils n'ont pas �t� extraits
       d'une fissure propag�e par PROPA_FISS
     - ont �t� extraits d'une fissure propag�e par PROPA_FISS sans grille auxiliaire associ�e
       et la mise � jours des level-sets a �t� faite sur tous les noeuds du maillage
       (mot-cl� ZONE_MAJ='TOUT' dans PROPA_FISS)

     Dans tous les autres cas, pour �viter des r�sultats faux, il faut absolument associer
     une grille auxiliaire � la fissure � propager, grille h�rit�e de la fissure de laquelle
     les deux level-sets ont �t� extraites (mot-cl� FISS_GRILLE de DEFI_FISS_XFEM).

"""),

70: _(u"""
  -> Un �l�ment convexe a �t� d�tect� sur le fond de la fissure %(k1)s. PROPA_FISS ne sait
     pas traiter ce cas. Le calcul de propagation ne peut se poursuivre.
  -> Conseil:
     Veuillez revoir la d�finition de votre fissure.

"""),

71: _(u"""
  -> DEFI_FISS_XFEM :
     La jonction de fissures n'est pas une fonctionnalit� disponible pour les mod�les 
     thermiques. Or le mod�le %(k1)s est un mod�le thermique.
"""),

72: _(u"""
  -> Vous utilisez le mot-cl� FISSURE, or le mod�le %(k1)s que vous avez renseign� 
     pour le mot cl� MODELE n'est pas un mod�le X-FEM.
  -> Conseil:
     Veuillez utiliser un autre mot-cl� ou revoyez la d�finition de votre mod�le.
"""),

73: _(u"""
  -> Vous avez renseign� %(k1)s pour le mot-cl� FISSURE, or cette fissure est absente
     du mod�le %(k2)s que vous avez renseign� pour le mot-cl� MODELE.
  -> Conseil:
     Assurez vous de renseigner pour le mot-cl� FISSURE une liste de fissures 
     pr�sentes dans le mod�le ou revoyez la d�finition de votre mod�le.
"""),

74: _(u"""
     Nombre de points du fond de fissure sur la grille : %(i1)d
"""),

75: _(u"""
     Coordonn�es des points du fond de fissure sur la grille
"""),

}
