#@ MODIF xfem2 Messages  DATE 07/11/2011   AUTEUR COURTOIS M.COURTOIS 
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
  -> On ne peut pas faire propager une interface.
     Seule les fissures (poss�dant un fond de fissure) peuvent �tre propag�es.
"""),


2 : _(u"""
  -> Seules les mod�lisations C_PLAN/D_PLAN sont disponibles pour XFEM.
  -> Risques et conseils:
     Veuillez consid�rer l'une des deux mod�lisations dans AFFE_MODELE.
"""),

3 : _(u"""
  -> Erreur utilisateur : Pour le post-traitement de visualisation en pr�sence
     de contact aux ar�tes ('P1P1A' dans la commande MODI_MODELE_XFEM), il faut
     obligatoirement renseigner le mot-cl� MAILLAGE_SAIN de la commande %(k1)s.
  -> Risques et conseils:
     Veuillez renseigner le mot-cl� MAILLAGE_SAIN avec le maillage lin�aire.
"""),

4 : _(u"""
  -> Pour le post-traitement de visualisation standard (sans pr�sence
     de contact aux ar�tes dans la commande MODI_MODELE_XFEM), le mot-cl�
     MAILLAGE_SAIN de la commande %(k1)s ne sert � rien. Il ne sera pas
     utilis�.
  -> Risques et conseils:
     Pour ne plus avoir cette alarme, veuillez supprimer le mot-cl� MAILLAGE_SAIN
     de la commande %(k1)s.
"""),

7 : _(u"""
  -> Le contact a �t� activ� dans XFEM (CONTACT_XFEM='OUI' dans MODI_MODELE_XFEM)
  -> Risque & Conseil:
     Vous devez �galement l'activer dans AFFE_CHAR_MECA/CONTACT_XFEM
"""),

8 : _(u"""
  -> Le mod�le %(k1)s transmis dans AFFE_CHAR_MECA/CONTACT n'est pas un mod�le
     XFEM.
  -> Risque & Conseil:
     Veuillez utiliser la commande MODI_MODELE_XFEM pour fournir �
     AFFE_CHAR_MECA/CONTACT un mod�le XFEM.
"""),

9 : _(u"""
  -> Le mod�le %(k1)s transmis dans AFFE_CHAR_MECA/CONTACT n'est pas un mod�le
     XFEM avec contact.
  -> Risque & Conseil:
     Veuillez activer CONTACT='OUI' dans MODI_MODELE_XFEM.
"""),

11 : _(u"""
  -> Le mod�le %(k1)s transmis dans AFFE_CHAR_MECA/CONTACT_XFEM n'est pas
     le mod�le XFEM utilis� dans le AFFE_CHAR_MECA/CONTACT nomm� %(k2)s.
  -> Risque & Conseil:
     Risques de r�sultats faux.
"""),

12 : _(u"""
  -> Le mod�le %(k1)s transmis dans AFFE_CHAR_MECA/CONTACT_XFEM n'est pas un mod�le
     XFEM.
  -> Risque & Conseil:
     Veuillez utiliser la commande MODI_MODELE_XFEM pour fournir �
     AFFE_CHAR_MECA/CONTACT_XFEM un mod�le XFEM.
"""),

15 : _(u"""
  -> Point de FOND_FISS sans maille de surface rattach�e.
  -> Risque & Conseil:
     Veuillez revoir la d�finition des level-sets.
"""),

17 : _(u"""
  -> Segment de FOND_FISS sans maille de surface rattach�e
  -> Risque & Conseil:
     Veuillez revoir la d�finition des level-sets.
"""),

20 : _(u"""
  -> PFON_INI = POINT_ORIG
  -> Risque & Conseil :
     Veuillez d�finir deux points diff�rents pour PFON_INI et POINT_ORIG.
"""),

21 : _(u"""
  -> Probl�me dans l'orientation du fond de fissure : POINT_ORIG mal choisi.
  -> Risque & Conseil :
     Veuillez red�finir POINT_ORIG.
"""),

22 : _(u"""
  -> Tous les points du fond de fissure sont des points de bord.
  -> Risque & Conseil :
     Assurez-vous du bon choix des param�tres d'orientation de fissure.
"""),

23 : _(u"""
  -> PFON_INI semble �tre un point mal choisi, on le modifie automatiquement.
"""),

25 : _(u"""
  -> La norme du vecteur VECT_ORIE est nulle.
  -> Risque & Conseil :
     Veuillez red�finir VECT_ORIE.
"""),


50 : _(u"""
  -> Le maillage utilis� pour la repr�sentation des level-sets est 2D
     mais il contient des �l�ments 1D aussi.
  -> La m�thode UPWIND s�lectionn�e dans PROPA_FISS peut g�rer des
     grilles 2D d�finies seulement par des �l�ments QUAD4.
  -> Risque & Conseil:
     Veuillez donner un maillage d�fini seulement par des �l�ments
     QUAD4.
  """),

51 : _(u"""
  -> Il n'y a aucune maille enrichie.
  -> Risque & Conseil:
     Veuillez v�rifier les d�finitions des level-sets.
  """),

52 : _(u"""
  -> Le maillage utilis� pour la repr�sentation des level-sets est 3D
     mais il contient des �l�ments 2D et/ou 1D aussi.
  -> La m�thode UPWIND s�lectionn�e dans PROPA_FISS peut g�rer des
     grilles 3D d�finies seulement par des �l�ments HEXA8.
  -> Risque & Conseil:
     Veuillez donner un maillage d�fini seulement par des �l�ments
     HEXA8.
  """),

53 : _(u"""
  -> Dans le maillage utilis� pour la repr�sentation des level-sets,
     il y a des �l�ments qui ne sont pas disponibles pour la m�thode
     UPWIND (PROPA_FISS).
  -> Risque & Conseil:
     Veuillez v�rifier le maillage et utiliser uniquement des �l�ments
     QUAD4 en 2D et HEXA8 en 3D.
  """),

54 : _(u"""
  -> Il n'y a pas d'�l�ments disponibles pour la m�thode UPWIND
     (PROPA_FISS) dans le maillage utilis� pour la repr�sentation
     des level-sets.
  -> Risque & Conseil:
     Veuillez v�rifier le maillage et utiliser uniquement des �l�ments
     QUAD4 en 2D et HEXA8 en 3D.
  """),

55 : _(u"""
  -> Dans le maillage utilis� pour la repr�sentation des level-sets
     (PROPA_FISS), il y a des ar�tes qui ne sont pas orthogonales aux
     autres ar�tes.
  -> Risque & Conseil:
     Risques de r�sultats faux.
     Veuillez v�rifier que toutes les ar�tes des �l�ments du maillage
     soient orthogonales entre elles.
  """),

56 : _(u"""
  -> Aucun noeud n'a �t� trouv� pour le calcul du r�sidu local.
  -> Le calcul du r�sidu local n'est pas possible.
  -> Risque & Conseil:
     Veuillez v�rifier que la fissure n'est pas � l'ext�rieur du
     maillage apr�s la propagation actuelle.
  """),

57 : _(u"""
  -> La d�finition de un ou plusieurs �l�ments du maillage utilis� pour
     la repr�sentation des level-sets (PROPA_FISS) n'est pas correcte.
  -> Risque & Conseil:
     Il y a une ar�te avec une longueur nulle dans le maillage.
     Veuillez v�rifier la d�finition des �l�ments du maillage (par
     exemple: un noeud est utilis� seulement une fois dans la d�finition
     d'un �l�ment; il n'y a pas de noeuds doubles...)
  """),

58 : _(u"""
  -> La dimension (2D ou 3D) du mod�le physique et la dimension (2D ou
     3D) du mod�le utilis� pour la grille auxiliaire ne sont pas �gales.
  -> Risque & Conseil:
     Veuillez utiliser deux mod�les avec la m�me dimension (les deux 2D
     ou les deux 3D).
  """),

60 : _(u"""
  -> L'op�rande TEST_MAIL a �t� utilis�e dans l'op�rateur PROPA_FISS.
     La m�me vitesse d'avanc�e est utilis�e pour tous les points du
     fond de fissure et l'angle de propagation est fix� �gal � z�ro.
  -> Risque & Conseil:
     L'avanc�e de la fissure n'est pas li�e aux contraintes affectant
     la structure et donc les r�sultats de la propagation n'ont pas
     une signification physique.
     L'op�rande TEST_MAIL doit �tre utilis� uniquement pour v�rifier
     si le maillage est suffisamment raffin� pour la repr�sentation
     des level-sets.
  """),

63 : _(u"""
  -> La valeur de l'avanc�e DA_MAX utilis�e est petite par rapport � la
     longueur de la plus petite arr�te du maillage utilis� pour
     la repr�sentation des level-sets:
     DA_MAX = %(r1)f
     Longueur minimale arr�t = %(r2)f
  -> Risque & Conseil:
     Risques de r�sultats faux. Veuillez v�rifier les r�sultats en
     utilisant un maillage plus raffin� pour la repr�sentation des
     level-sets.
  """),

64 : _(u"""
  -> La valeur du RAYON est plus petite que la longueur de la plus petite
     arr�te du maillage utilis� pour la repr�sentation des level-sets:
     RAYON = %(r1)f
     LONGUEUR minimale arr�t = %(r2)f
  -> Le calcul du r�sidu local n'est pas possible.
  -> Risque & Conseil:
     Veuillez utiliser une valeur du RAYON plus grande.
  """),

65 : _(u"""
  -> Le nombre maximal d'it�rations a �t� atteint.
  -> Risque & Conseil:
     Essayer d'utiliser un maillage plus raffin�, ou bien une grille auxiliaire.
  """),

66 : _(u"""
  -> Le taux de restitution d'�nergie G est n�gatif sur certains des
     noeuds du fond de fissure : le calcul de propagation est impossible.
  -> Risque & Conseil:
     Veuillez v�rifier les param�tres du calcul de G (rayons des
     couronnes, type de lissage...).
  """),

68 : _(u"""
  -> Le nombre des r�sultats dans un des tableaux des facteurs
     d'intensit� de contraintes (SIF) donn� � PROPA_FISS est sup�rieur
     � deux.
  -> Risque & Conseil:
     Veuillez donner des tableaux avec seulement les SIF correspondant
     aux conditions de chargement maximal et minimal du cycle de
     fatigue.
     Dans le cas de tableau contenant un seul r�sultat, on se place dans
     l'hypoth�se de rapport de charge �gal � z�ro (R=0).
  """),

71 : _(u"""
     Un tableau doit �tre donn� pour chaque fissure du mod�le.

     Attention! Si une fissure est form�e par plusieurs morceaux, un
     tableau n'est pas suffisant et on doit donner un tableau pour
     chaque morceau.
  """),

72 : _(u"""
  -> L'angle de propagation de la fissure n'est pas constant dans le
     cycle de chargement.
  -> La valeur de la premi�re configuration donn�e dans les tableaux des
     facteurs d'intensit� de contraintes a �t� retenue.
  -> Risque & Conseil:
     Risques des r�sultats faux.
     Veuillez v�rifier les conditions de chargement du mod�le.
  """),

73 : _(u"""
  -> L'option NB_POINT_FOND a �t� utilis� dans PROPA_FISS mais le
     mod�le est 2D.
  -> Risque & Conseil:
     Ne pas utiliser cette option avec un mod�le 2D.
  """),

74 : _(u"""
  -> Aucune fissure du mod�le ne propage.
  -> Risque & Conseil:
     Veuillez v�rifier les conditions du chargement du mod�le et les
     constantes de la loi de propagation donn�es � PROPA_FISS.
  """),

76 : _(u"""
  -> Une seule valeur des facteurs d'intensit� de contraintes (SIF) a
     �t� donn� pour chaque point du fond de la fissure. Cela ne permit
     pas de bien d�finir le cycle de fatigue.
  -> En d�faut, le rapport de charge du cycle de fatigue a �t� fix� �gal
     � z�ro et les  SIF donn�s ont �t� affect�s � le chargement maximal
     du cycle.
  -> Risque & Conseil:
     Veuillez v�rifier si les hypoth�ses faits ci-dessus sont correctes.
     Dans ce cas, c'est mieux de les bien expliciter en utilisant dans
     PROPA_FISS l'op�rateur COMP_LINE comme ceci:

     COMP_LINE=_F(COEF_MULT_MINI=0.,
                  COEF_MULT_MAXI=1.),

     Cela permit d'�viter aussi l'�mission de cette alarme.

     Sinon, si le rapport de charge du cycle de fatigue n'est pas �gal �
     z�ro, veuillez donner un tableau avec les SIF correspondants � les
     conditions de chargement maximal et minimal du cycle de fatigue.
  """),

77 : _(u"""
  -> La valeur des facteurs d'intensit� de contraintes (SIF) n'a pas
     �t� trouv�e pour un point du fond de fissure:
     Nom de la fissure = %(k1)s
     Nombre des morceaux = %(i1)d
     Morceau �labor� = %(i2)d
     Point inexistant = %(i3)d
  -> Risque & Conseil:
     Veuillez v�rifier que les tableaux de SIF donn�s dans l'op�rateur
     PROPA_FISS sont corrects. Si NB_POINT_FOND a �t� utilis�, veuillez
     v�rifier aussi que les valeurs donn�es sont correctes.
  """),

78 : _(u"""
  -> L'option NB_POINT_FOND a �t� utilis�e dans PROPA_FISS
     mais le nombre de valeurs donn�es n'est pas �gale au nombre total
     des morceaux des fissures dans le mod�le.
  -> Nombre total de valeurs donn�es %(k2)s au nombre total
     des morceaux des fissures du mod�le.

  -> Conseil:
     Veuillez v�rifier que l'option NB_POINT_FOND a �t� utilis�e
     correctement dans PROPA_FISS et que les valeurs donn�es pour
     chaque fissure sont correctes.
  """),

79 : _(u"""
  -> Une des valeurs donn�e pour NB_POINT_FOND n'est pas valide.
  -> Risque & Conseil:
     Veuillez v�rifier que toutes les valeurs sont �gales � 0 ou
     sup�rieures � 1.
  """),

80 : _(u"""
  -> Le nombre des valeurs dans un des tableaux des facteurs
     d'intensit� de contraintes (SIF) est sup�rieur au nombre des
     points du fond de la fissure correspondante.
  -> Risque & Conseil:
     Veuillez v�rifier que les tableaux de SIF donn�s par l'op�rateur
     PROPA_FISS sont corrects. Si NB_POINT_FOND a �t� utilis�, veuillez
     v�rifier aussi que la liste donn�e pour chaque fissure est correcte.
  """),

81 : _(u"""
  -> Les valeurs de COEF_MULT_MAXI et COEF_MULT_MINI de COMP_LINE donn�es
     dans l'op�rateur PROPA_FISS sont �gales � z�ro.
  -> Risque & Conseil:
     Au moins une des deux valeurs doit �tre diff�rente de z�ro pour
     avoir une cycle de fatigue. Veuillez v�rifier les valeurs donn�es.
  """),

82 : _(u"""
  -> L'op�rande COMP_LINE a �t� utilis�e dans PROPA_FISS et il y a
     plusieurs r�sultats dans un des tableaux des facteurs d'intensit�
     de contraintes (SIF).
  -> Risque & Conseil:
     Veuillez donner des tableaux avec seulement les SIF correspondant �
     la conditions de chargement de r�f�rence.
  """),

83 : _(u"""
  -> Le taux de restitution maximal d'�nergie G dans le cycle de fatigue
     est z�ro sur certains des noeuds du fond de fissure:
     le calcul de propagation est impossible.
  -> Risque & Conseil:
     Veuillez v�rifier les param�tres du calcul de G (rayons des
     couronnes, type de lissage...) et les chargements affectant le
     mod�le.
"""),

84 : _(u"""
  -> Le taux de restitution d'�nergie G ne change pas dans le cycle de
     fatigue sur certains des noeuds du fond de fissure:
     le calcul de propagation est impossible.
  -> Risque & Conseil:
     Veuillez v�rifier les param�tres du calcul de G (rayons des
     couronnes, type de lissage...) et les chargements affectant le
     mod�le.
"""),

85 : _(u"""
   Les propri�t�s mat�riaux d�pendent de la temp�rature. La temp�rature en fond
   de fissure n'�tant pas connue, le calcul se poursuit en prenant la temp�rature
   de r�f�rence du mat�riau (TEMP = %(r1)f).
"""),

86 : _(u"""
 -> Le maillage/la grille sur lequel/laquelle vous voulez cr�er le group
    n'est pas associ�/associ�e � la fissure donn�e.

 -> Risque & Conseil:
    Veuillez v�rifier d'avoir sp�cifi� le bon maillage/grille et/ou
    la bonne fissure.
"""),

87 : _(u"""
  -> L'op�rande TEST_MAIL a �t� utilis� dans l'op�rateur PROPA_FISS.
  -> Cet op�rande n'a pas des sens que pour un mod�le 3D.
  -> Risque & Conseil:
     Ne pas utiliser TEST_MAIL pour un mod�le 2D.
  """),

88 : _(u"""
  -> La valeur du rayon du tore de localisation de la zone de mise �
     jour est sup�rieure � la valeur limite. Cette derni�re est
     d�termin�e par la valeur du rayon du tore utilis�e � la propagation
     pr�c�dente et la valeur de l'avanc�e de la fissure (DA_MAX) impos�
     � la propagation courante.

     Rayon actuel = %(r1)f
     Rayon limite = %(r2)f

  -> Risque & Conseil:
     Risques de r�sultats faux si la fissure ne propage pas en mode I.

     Pour �viter ce risque, vous pouvez utiliser la m�me avanc�e de la
     fissure (DA_MAX) et le m�me rayon (RAYON) que ceux qui ont �t�
     utilis�s � la propagation pr�c�dente.

     Si vous ne pouvez pas utiliser les m�me valeurs, vous pouvez
     choisir une des solutions suivantes:
     - donner une valeur de RAYON_TORE inf�rieure � la valeur limite
       pour la propagation courante
     - utiliser une valeur de RAYON_TORE plus grande pour les
       propagations pr�c�dentes
     - augmenter l'avanc�e de la fissure (DA_MAX) � la propagation
       courante

     Sinon, m�me si fortement d�conseill�, vous pouvez choisir de ne pas
     utiliser la localisation de la zone de mise � jour
     (ZONE_MAJ='TOUT').
  """),

89 : _(u"""
  -> La fissure � propager n'existe pas dans le mod�le:
     FISS_ACTUELLE = %(k1)s
     MODELE        = %(k2)s
  -> Conseil:
     Veuillez v�rifier que la fissure et le mod�le sont correctement
     d�finis.
  """),

90 : _(u"""
  -> Un ou plusieurs tableaux des facteurs d'intensit� de contraintes
     ne contient pas la colonne NUME_FOND.
  -> Conseil:
     Veuillez ajouter cette colonne aux tableaux (voir documentation
     utilisateur de PROPA_FISS).
  """),

91 : _(u"""
  -> Le nouveau fond de fissure n'est pas tr�s r�gulier. Cela signifie
     que le maillage ou la grille auxiliaire utilis�s pour la
     repr�sentation de la fissure par level-sets ne sont pas
     suffisamment raffin�s pour bien d�crire la forme du fond de la
     fissure utilis�e.
  -> Risque & Conseil:
     Risques de r�sultats faux en utilisant le maillage ou la grille
     auxiliaire test�s. Veuillez utiliser un maillage ou une grille
     auxiliaire plus raffin�s.
  """),

92 : _(u"""
  -> Vous avez demand� la cr�ation d'un group de noeuds dans un tore
     construit autour du fond de la fissure suivante:

     FISSURE = %(k1)s

     Toutefois cette fissure a �t� calcul�e par PROPA_FISS en utilisant
     la localisation du domaine (ZONE_MAJ='TORE', par d�faut).
     Dans ce cas le group de noeuds doit �tre forcement d�fini en
     utilisant le tore d�j� utilis� par PROPA_FISS.

  -> Le group de noeuds sera cr�e en utilisant le domaine de
     localisation de la fissure (option TYPE_GROUP='ZONE_MAJ').

  """),


93 : _(u"""
  -> Aucune fissure n'est d�finie sur le mod�le sp�cifi�:
     MODELE = %(k1)s
  -> Risque & Conseil:
     Veuillez d�finir une fissure sur le mod�le ci-dessus en utilisant
     les op�rateurs DEFI_FISS_XFEM et MODI_MODELE_XFEM avant
     l'utilisation de PROPA_FISS.
  """),

94 : _(u"""
  -> L'avanc�e donn�e (DA_MAX) pour la propagation courante est
     inf�rieure � la valeur minimale conseill�e.

     DA_MAX donn�e                     = %(r1)f
     Avanc�e maximale fissure courante = %(r2)f
     DA_MAX minimal conseill�          = %(r3)f

  -> Risque & Conseil:
     Risque de r�sultats faux. Dans le cas de propagation 3D en mode
     mixte, on conseille en g�n�ral d'utiliser une avanc�e de fissure
     sup�rieure � celle minimale �crite ci-dessus, m�me si des bonnes
     r�sultats peuvent �tre obtenus en utilisant une avanc�e inf�rieure.

     La valeur minimale de DA_MAX d�pende de la valeur de l'op�rande
     RAYON et de l'angle de propagation de la fissure. Dans le cas o� la
     valeur DA_MAX donn�e ne peut pas �tre chang�e, sa valeur minimale
     conseill�e peut �tre diminu�e en agissant sur la valeur de RAYON,
     c'est-�-dire en utilisant une valeur de RAYON plus petite. Cela
     influence l'op�rateur CALC_G aussi et normalement est faisable en
     utilisant un maillage plus raffin�.
  """),

95 : _(u"""
  -> Le mod�le grille donn� est d�fini sur un maillage (%(k1)s)
     et pas sur une grille.

  -> Risque & Conseil:
     Veuillez donner un mod�le grille d�fini sur une grille. Cette
     grille doit �tre d�finie par DEFI_GRILLE � partir d'un maillage.
  """),

96 : _(u"""
 -> Le maillage sur lequel vous voulez cr�er le group n'est pas associ� �
    la fissure donn�e.

 -> Les maillages suivants sont associ�s � cette fissure:
      maillage physique = %(k1)s
      maillage grille   = %(k2)s

 -> Risque & Conseil:
    Veuillez v�rifier d'avoir sp�cifi� le bon maillage et/ou la bonne fissure.
"""),

97 : _(u"""
  -> La localisation de la zone de mise � jour a �t� utilis� pour la
     d�termination de la configuration actuelle des fissures du mod�le.
     Par contre, pour la propagation courante, la localisation n'a pas
     �t� activ�e.
  -> Risque & Conseil:
     Veuillez utiliser la localisation de la zone de mise � jour
     (ZONE_MAJ='TORE') pour la propagation courante aussi.
  """),

98 : _(u"""
  -> Aucune grille auxiliaire n'est utilis�e pour la repr�sentation de
     la fissure donn�e.
  -> Risque & Conseil:
     Veuillez v�rifier que vous avez demand� les level-sets de la bonne
     fissure.
  """),

99 : _(u"""
  -> La valeur du rayon du tore de localisation de la zone de mise �
     jour est plus petite que celle qui est n�cessaire pour la bonne
     mise � jour des level-sets.
     Rayon � utiliser = %(r1)f
     Rayon minimal    = %(r2)f
  -> Risque & Conseil:

  -> Si vous avez utilis� l'op�rande RAYON_TORE, veuillez augmenter la
     valeur donn� ou diminuer la valeur de DA_MAX ou RAYON.

  -> Si vous n'avez pas utilis� l'op�rande RAYON_TORE, cette erreur
     signifie que l'estimation automatique faite par l'op�rateur
     PROPA_FISS ne marche pas bien pour la propagation courante. Elle
     peut �tre utilis�e dans les cas o� les valeurs de RAYON et DA_MAX
     ne changent pas entre deux propagations successives et la taille
     des �l�ments dans la zone de propagation est presque constante.
     Veuillez donc donner explicitement une valeur du rayon en utilisant
     l'op�rande RAYON_TORE.
     Vous pouvez calculer une estimation de cette valeur en utilisant la
     formule suivante:

     RAYON_TORE=RAYON_max+DA_MAX_max+2*h_max

     o� RAYON_max et DA_MAX_max sont les valeurs maximales des op�randes
     RAYON et DA_MAX qu'on va utiliser et h_max est la valeur de la plus
     grande ar�te des �l�ments du maillage ou de la grille auxiliaire
     dans la zone de propagation.
  """),
}
