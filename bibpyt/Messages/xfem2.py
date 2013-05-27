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
# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

1 : _(u"""
  -> On ne peut pas faire propager une interface.
     Seule les fissures (poss�dant un fond de fissure) peuvent �tre propag�es.
"""),


2 : _(u"""
  -> GROT_GDEP n'est pas disponible avec COMP_ELAS.
  -> Conseils : Utilisez COMP_INCR.
"""),

5 : _(u"""
  -> Avec GROT_GDEP + COMP_INCR, la mod�lisation axisym�trique n'est pas disponible.
"""),

6 : _(u"""
  -> Le nombre de fissures est limit� � %(i1)d, or vous en avez d�finies %(i2)d !
     Veuillez contacter votre assistance technique.
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

10 : _(u"""
  -> Toutes les fissures ne sont pas rattach�es au m�me maillage.
     La fissure %(k1)s est rattach�e au maillage %(k2)s alors que 
     la fissure %(k3)s est rattach�e au maillage %(k4)s.
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

18 : _(u"""
  -> Le mot-cl� CRITERE de PROPA_FISS est diff�rent de 'ANGLE_IMPO' et le tableau
     des facteurs d'intensit� de contraintes (SIF) de la fissure %(k1)s contient
     une colonne 'BETA'.
  -> Risque & Conseil:
     Les valeurs de l'angle de bifurcation not�es dans ce tableau ne sont
     pas prises en compte. Si vous souhaitez imposer les valeurs de l'angle
     de bifurcation aux points du fonds de fissure, veuillez indiquer
     CRITERE='ANGLE_IMPO'.
"""),

19 : _(u"""
  -> Le mot-cl� CRITERE de PROPA_FISS vaut 'ANGLE_IMPO' et le tableau
     des facteurs d'intensit� de contraintes (SIF) de la fissure %(k1)s ne contient
     pas de colonne 'BETA'.
  -> Risque & Conseil:
     Si vous souhaitez imposer les valeurs de l'angle de bifurcation aux points 
     du fonds de fissure, veuillez indiquer CRITERE='ANGLE_IMPO' et ajouter
     une colonne 'BETA' au tableau de SIF manuellement ou si le mod�le est en 3D,
     en utilisant l'option 'CALC_K_G' de la commande CALC_G.
"""),

20 : _(u"""
  -> En 3D, si METHODE_PROPA='MAILLAGE' dans PROPA_FISS il faut absolument une
     colonne 'ABSC_CURV' contenant les abscisses curvilignes des points du fond
     dans le tableau des facteurs d'intensit� de contraintes (SIF).
  -> Risque & Conseil:
     Veuillez v�rifier la pr�sence de cette colonne.
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

70 : _(u"""
  -> La macro-commande PROPA_FISS ne peut traiter qu'un seul instant de calcul.
  -> Risque & Conseil:
     Veuillez v�rifier que les tableaux des facteurs d'intensit� de contraintes
     donn�s dans l'op�rateur PROPA_FISS ne contiennent qu'un seul instant.
"""),




73 : _(u"""
  -> L'option NB_POINT_FOND a �t� utilis� dans PROPA_FISS mais le
     mod�le est 2D.
  -> Risque & Conseil:
     Cette option n'est utile qu'avec un mod�le 3D.
     Ce mot-cl� n'est pas pris en compte.
  """),

74 : _(u"""
  -> Aucune fissure du mod�le ne se propage.
  -> Risque & Conseil:
     Veuillez v�rifier les conditions du chargement du mod�le et les
     constantes de la loi de propagation donn�es � PROPA_FISS.
  """),

75 : _(u"""
  -> Une valeur de la liste de NB_POINT_FOND ne correspond pas au nombre de
     lignes du tableau des facteurs d'intensit� de contraintes (SIF) pour
     le fond %(i1)d de la fissure %(k1)s.
  -> Risque & Conseil:
     Veuillez v�rifier que la liste NB_POINT_FOND donn�e dans PROPA_FISS
     soit identique � celle utilis�e pour construire le tableau des SIF.
  """),



78 : _(u"""
  -> L'option NB_POINT_FOND a �t� utilis�e dans PROPA_FISS
     mais le nombre de valeurs donn�es n'est pas �gale au nombre total
     des morceaux des fissures dans le mod�le.

  -> Conseil:
     Veuillez v�rifier que l'option NB_POINT_FOND a �t� utilis�e
     correctement dans PROPA_FISS et que les valeurs donn�es pour
     chaque fissure sont correctes.
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
  -> Les valeurs de COEF_MULT_MAXI et COEF_MULT_MINI de COMP_LINE sont
     �gales � z�ro.
  -> Risque & Conseil:
     Au moins une des deux valeurs doit �tre diff�rente de z�ro pour
     avoir un cycle de fatigue. Veuillez v�rifier les valeurs donn�es.
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
  -> Cet op�rande n'a de sens que pour un mod�le 3D.
  -> Risque & Conseil:
     Ne pas utiliser TEST_MAIL pour un mod�le 2D.
  """),

88 : _(u"""
  -> La valeur du rayon du tore de localisation de la zone de mise �
     jour est sup�rieure � la valeur limite. Cette derni�re est
     d�termin�e par la valeur du rayon du tore utilis�e � la propagation
     pr�c�dente et la valeur de l'avanc�e de la fissure (DA_MAX) impos�e
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
