#@ MODIF xfem2 Messages  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
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
  -> On ne peut pas faire propager une interface.
     Seule les fissures (poss�dant un fond de fissure) peuvent etre propag�es.
"""),


2 : _("""
  -> Seules les mod�lisations C_PLAN/D_PLAN sont disponibles pour XFEM.
  -> Risques et conseils:
     Veuillez consid�rer l'une des deux mod�lisations dans AFFE_MODELE.
"""),


7 : _("""
  -> Le contact a �t� activ� dans XFEM (CONTACT_XFEM='OUI' dans MODI_MODELE_XFEM)
  -> Risque & Conseil:
     Vous devez �galement l'activer dans AFFE_CHAR_MECA/CONTACT_XFEM
"""),

8 : _("""
  -> Le mod�le %(k1)s transmis dans AFFE_CHAR_MECA/CONTACT n'est pas un mod�le
     XFEM. 
  -> Risque & Conseil:
     Veuillez utiliser la commande MODI_MODELE_XFEM pour fournir � 
     AFFE_CHAR_MECA/CONTACT un mod�le XFEM.
"""),

9 : _("""
  -> Le mod�le %(k1)s transmis dans AFFE_CHAR_MECA/CONTACT n'est pas un mod�le
     XFEM avec contact.
  -> Risque & Conseil:
     Veuillez activer CONTACT='OUI' dans MODI_MODELE_XFEM.
"""),

11 : _("""
  -> Le mod�le %(k1)s transmis dans AFFE_CHAR_MECA/CONTACT_XFEM n'est pas 
     le mod�le XFEM utilis� dans le AFFE_CHAR_MECA/CONTACT nomm� %(k2)s.
  -> Risque & Conseil:
     Risques de r�sultats faux.
"""),

12 : _("""
  -> Le mod�le %(k1)s transmis dans AFFE_CHAR_MECA/CONTACT_XFEM n'est pas un mod�le
     XFEM. 
  -> Risque & Conseil:
     Veuillez utiliser la commande MODI_MODELE_XFEM pour fournir � 
     AFFE_CHAR_MECA/CONTACT_XFEM un mod�le XFEM.
"""),

15 : _("""
  -> Point de FOND_FISS sans maille de surface rattach�e.
  -> Risque & Conseil:
     Veuillez revoir la d�finition des level sets.
"""),

17 : _("""
  -> Segment de fond_fiss sans maille de surface rattach�e
  -> Risque & Conseil:
     Veuillez revoir la d�finition des level sets.
"""),

20 : _("""
  -> PFON_INI = POINT_ORIG
  -> Risque & Conseil :
     Veuillez d�finir deux points diff�rents pour PFON_INI et POINT_ORIG.
"""),

21 : _("""
  -> Probl�me dans l'orientation du fond de fissure : POINT_ORIG mal choisi.
  -> Risque & Conseil : 
     Veuillez red�finir POINT_ORIG.
"""),

22 : _("""
  -> Tous les points du fond de fissure sont des points de bord.
  -> Risque & Conseil : 
     Assurez-vous du bon choix des param�tres d'orientation de fissure.
"""),

23 : _("""
  -> PFON_INI semble etre un point mal choisi, on le modifie automatiquement.
"""),

24 : _("""
  -> La m�thode "UPWIND" est en cours d'impl�mentation.
  -> Risque & Conseil :
     Veuillez choisir une autre m�thode.
"""),

25 : _("""
  -> La norme du vecteur VECT_ORIE est nulle.
  -> Risque & Conseil :
     Veuillez red�finir VECT_ORIE.
"""),


39 : _("""
  -> Deux points du fond de fissure sont tr�s proches ou coincident.
  -> Risque & Conseil :
     V�rifier les d�finitions des level sets et la liste des points du fond
     de fissure trouv�s. Si c'est normal, contactez votre correspondant.
"""),

50 : _("""
  -> Le maillage utilis� pour la repr�sentation des level sets est 2D
     mais il contient des �l�ments 1D aussi.
  -> La m�thode upwind s�lectionn�e dans PROPA_FISS peut g�rer des
     grilles 2D d�finies seulement par des �l�ments QUAD4.
  -> Risque & Conseil:
     Veuillez donner un maillage d�fini seulement par des �l�ments
     QUAD4.
  """),

51 : _("""
  -> Il n'y a aucune maille enrichie.
  -> Risque & Conseil:
     Veuillez v�rifier les d�finitions des level sets.
  """),

52 : _("""
  -> Le maillage utilis� pour la repr�sentation des level sets est 3D
     mais il contient des �l�ments 2D et/ou 1D aussi.
  -> La m�thode upwind s�lectionn�e dans PROPA_FISS peut g�rer des
     grilles 3D d�finies seulement par des �l�ments HEXA8.
  -> Risque & Conseil:
     Veuillez donner un maillage d�fini seulement par des �l�ments
     HEXA8.
  """),
  
53 : _("""
  -> Dans le maillage utilis� pour la repr�sentation des level sets,
     il y a des �l�ments qui ne sont pas disponibles pour la m�thode 
     upwind (PROPA_FISS).
  -> Risque & Conseil:
     Veuillez v�rifier le maillage et utiliser uniquement des �l�ments
     QUAD4 en 2D et HEXA8 en 3D.
  """),

54 : _("""
  -> Il n'y a pas d'�l�ments disponibles pour la m�thode upwind 
     (PROPA_FISS) dans le maillage utilis� pour la repr�sentation 
     des level sets.
  -> Risque & Conseil:
     Veuillez v�rifier le maillage et utiliser uniquement des �l�ments
     QUAD4 en 2D et HEXA8 en 3D.
  """),

55 : _("""
  -> Dans le maillage utilis� pour la repr�sentation des level sets
     (PROPA_FISS), il y a des ar�tes qui ne sont pas orthogonales aux
     autres ar�tes.
  -> Risque & Conseil:
     Risques de r�sultats faux.
     Veuillez v�rifier que toutes les ar�tes des �l�ments du maillage
     soient orthogonales entre elles.
  """),

56 : _("""
  -> Aucun noeud n'a �t� trouv� pour le calcul du r�sidu local.
  -> Le calcul du r�sidu local n'est pas possible.
  -> Risque & Conseil:
     Veuillez v�rifier que la fissure n'est pas � l'ext�rieur du 
     maillage apr�s la propagation actuelle.
  """),

57 : _("""
  -> La d�finition de un ou plusieurs �l�ments du maillage utilis� pour
     la repr�sentation des level sets (PROPA_FISS) n'est pas correcte.
  -> Risque & Conseil:
     Il y a une ar�te avec une longueur nulle dans le maillage.
     Veuillez v�rifier la d�finition des �l�ments du maillage (par
     exemple: un noeud est utilis� seulement une fois dans la d�finition
     d'un �l�ment; il n'y a pas de noeuds doubles...)
  """),
  
58 : _("""
  -> La dimension (2D ou 3D) du mod�le physique et la dimension (2D ou 
     3D) du mod�le utilis� pour la repr�sentation des level sets ne sont
     pas �gales.
  -> Risque & Conseil:
     Veuillez utiliser deux mod�les avec la m�me dimension (tous deux 2D
     ou tous deux 3D).
  """),
  
60 : _("""
  -> L'op�rande TEST_MAIL a �t� utilis�e dans l'op�rateur PROPA_FISS.
     La m�me vitesse d'avanc�e est utilis�e pour tous les points du
     fond de fissure et l'angle de propagation est fix� �gal � z�ro.
  -> Risque & Conseil:
     L'avanc�e de la fissure n'est pas li�e aux contraintes affectant
     la structure et donc les r�sultats de la propagation n'ont pas
     une signification physique.
     L'op�rande TEST_MAIL doit �tre utilis� uniquement pour v�rifier
     si le maillage est suffisamment raffin� pour la repr�sentation
     des level sets.
  """),
  
63 : _("""
  -> La valeur de l'avanc�e DA_MAX utilis�e est petite par rapport � la
     longueur de la plus petite arr�te du maillage utilis� pour
     la repr�sentation des level sets:
     DA_MAX = %(r1)f
     Longeur minimale arr�t = %(r2)f
  -> Risque & Conseil:
     Risques de r�sultats faux. Veuillez v�rifier les r�sultats en
     utilisant un maillage plus raffin� pour la repr�sentation des
     level sets.
  """),
  
64 : _("""
  -> La valeur du RAYON est plus petite que la longueur de la plus petite
     arr�te du maillage utilis� pour la repr�sentation des level sets:
     RAYON = %(r1)f
     Longeur minimale arr�t = %(r2)f
  -> Le calcul du r�sidu local n'est pas possible.
  -> Risque & Conseil:
     Veuillez utiliser une valeur du RAYON plus grande.
  """),
  
65 : _("""
  -> Le nombre maximal d'it�rations a �t� atteint.
  -> Risque & Conseil:
     Essayer d'utiliser un maillage plus raffin�, ou bien une grille auxiliaire.
  """),
  
66 : _("""
  -> Le taux de restitution d'�nergie G est n�gatif sur certains des 
     noeuds du fond de fissure : le calcul de propagation est impossible.
  -> Risque & Conseil:
     Veuillez v�rifier les param�tres du calcul de G (rayons des
     couronnes, type de lissage...). 
  """),
  
68 : _("""
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
  
69 : _("""
  -> Pour l'instant la restriction du domaine de calcul et la m�thode
     upwind peuvent �tre utilis�s au m�me temps seulement si une grille
     auxiliaire est donn�e.
  -> Risque & Conseil:
     Veuillez utiliser la m�thode simplexe ou utiliser la m�thode upwind
     avec une grille auxiliaire. Sinon veuillez d�sactiver l'option de
     restriction du domaine de calcul (DOMAINE='MODELE').
  """),
  
71 : _("""
     Un tableau doit �tre donn� pour chaque fissure du mod�le.
     
     Attention! Si une fissure est form�e par plusieurs morceaux, un
     tableau n'est pas suffisant et on doit donner un tableau pour
     chaque morceau.
  """),
  
72 : _("""
  -> L'angle de propagation de la fissure n'est pas constant dans le
     cycle de chargement.
  -> La valeur de la premi�re configuration donn�e dans les tableaux des
     facteurs d'intensit� de contraintes a �t� retenue.
  -> Risque & Conseil:
     Risques des r�sultats faux.
     Veuillez v�rifier les conditions de chargement du mod�le.
  """),
  
73 : _("""
  -> L'option NB_POINT_FOND a �t� utilis� dans PROPA_FISS mais le
     mod�le est 2D.
  -> Risque & Conseil:
     Ne pas utiliser cette option avec un mod�le 2D.
  """),
  
74 : _("""
  -> Aucune fissure du mod�le ne propage.
  -> Risque & Conseil:
     Veuillez v�rifier les conditions du chargement du mod�le et les
     constantes de la loi de propagation donn�es � PROPA_FISS.
  """),
  
75 : _("""
  -> Le nombre des fissures d�finies dans le mod�le donn� pour la grille
     des level sets n'est pas correct.
  -> Mod�le: %(k1)s
     Nombre de fissures: %(i1)d
  -> Risque & Conseil:
     Veuillez donner un mod�le contenant une seule fissure.
  """),
  
76 : _("""
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
  
77 : _("""
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
  
78 : _("""
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
  
79 : _("""
  -> Une des valeurs donn�e pour NB_POINT_FOND n'est pas valide.
  -> Risque & Conseil:
     Veuillez v�rifier que toutes les valeurs sont �gales � 0 ou
     sup�rieures � 1.
  """),
  
80 : _("""
  -> Le nombre des valeurs dans un des tableaux des facteurs
     d'intensit� de contraintes (SIF) est sup�rieur au nombre des 
     points du fond de la fissure correspondante.
  -> Risque & Conseil:
     Veuillez v�rifier que les tableaux de SIF donn�s par l'op�rateur
     PROPA_FISS sont corrects. Si NB_POINT_FOND a �t� utilis�, veuillez 
     v�rifier aussi que la liste donn�e pour chaque fissure est correcte.
  """),
  
81 : _("""
  -> Les valeurs de COEF_MULT_MAXI et COEF_MULT_MINI de COMP_LINE donn�es
     dans l'op�rateur PROPA_FISS sont �gales � z�ro.
  -> Risque & Conseil:
     Au moins une des deux valeurs doit �tre diff�rente de z�ro pour
     avoir une cycle de fatigue. Veuillez v�rifier les valeurs donn�es. 
  """),
  
82 : _("""
  -> L'op�rande COMP_LINE a �t� utilis�e dans PROPA_FISS et il y a
     plusieurs r�sultats dans un des tableaux des facteurs d'intensit�
     de contraintes (SIF).
  -> Risque & Conseil:
     Veuillez donner des tableaux avec seulement les SIF correspondant �
     la conditions de chargement de r�f�rence.
  """),
  
83 : _("""
  -> Le taux de restitution maximal d'�nergie G dans le cycle de fatigue
     est z�ro sur certains des noeuds du fond de fissure:
     le calcul de propagation est impossible.
  -> Risque & Conseil:
     Veuillez v�rifier les param�tres du calcul de G (rayons des
     couronnes, type de lissage...) et les chargements affectant le
     mod�le.
"""),
  
84 : _("""
  -> Le taux de restitution d'�nergie G ne change pas dans le cycle de
     fatigue sur certains des noeuds du fond de fissure:
     le calcul de propagation est impossible.
  -> Risque & Conseil:
     Veuillez v�rifier les param�tres du calcul de G (rayons des
     couronnes, type de lissage...) et les chargements affectant le
     mod�le.
"""),
  
85 : _("""
   Les propri�t�s mat�riaux d�pendent de la temp�rature. La temp�rature en fond
   de fissure n'�tant pas connue, le calcul se poursuit en prenant la temp�rature
   de r�f�rence du mat�riau (TEMP = %(r1)f).
"""),
  
87 : _("""
  -> L'op�rande TEST_MAIL a �t� utilis� dans l'op�rateur PROPA_FISS.
  -> Cet op�rande n'a pas des sens que pour un mod�le 3D.
  -> Risque & Conseil:
     Ne pas utiliser TEST_MAIL pour un mod�le 2D.
  """),
  
88 : _("""
  -> La valeur du rayon du tore de localisation du domaine de calcul est
     sup�rieure � la valeur limite. Cette derni�re est d�termin�e par
     la valeur du rayon du tore utilis�e � la propagation pr�c�dente et
     la valeur de l'avanc�e de la fissure (DA_MAX) impos� � la
     propagation courante.
     
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
     utiliser la localisation du domaine de calcul (DOMAINE='MODELE').
  """),
  
89 : _("""
  -> La fissure � propager n'existe pas dans le mod�le:
     FISS_ACTUELLE = %(k1)s
     MODELE        = %(k2)s
  -> Conseil:
     Veuillez v�rifier que la fissure et le mod�le sont correctement
     d�finis.
  """),
  
90 : _("""
  -> Un ou plusieurs tableaux des facteurs d'intensit� de contraintes
     ne contient pas la colonne NUME_FOND.
  -> Conseil:
     Veuillez ajouter cette colonne aux tableaux (voir documentation
     utilisateur de PROPA_FISS).
  """),
  
91 : _("""
  -> Le nouveau fond de fissure n'est pas tr�s r�gulier. Cela signifie
     que le maillage ou la grille auxiliaire utilis�s pour la
     repr�sentation de la fissure par level sets ne sont pas
     suffisamment raffin�s pour bien d�crire la forme du fond de la
     fissure utilis�e.
  -> Risque & Conseil:
     Risques de r�sultats faux en utilisant le maillage ou la grille
     auxiliaire test�s. Veuillez utiliser un maillage ou une grille
     auxiliaire plus raffin�s.
  """),
  
92 : _("""
  -> Aucune fissure n'est d�finie sur le mod�le sp�cifi� pour la grille
     auxiliaire:
     FISS_ACTUELLE = %(k1)s
     GRILLE_AUX    = %(k2)s
  -> Risque & Conseil:
     Veuillez d�finir une fissure sur le mod�le ci-dessus en utilisant
     les op�rateurs DEFI_FISS_XFEM et MODI_MODELE_XFEM avant
     l'utilisation de PROPA_FISS.
  """),
  
93 : _("""
  -> Aucune fissure n'est d�finie sur le mod�le sp�cifi�:
     MODELE = %(k1)s
  -> Risque & Conseil:
     Veuillez d�finir une fissure sur le mod�le ci-dessus en utilisant
     les op�rateurs DEFI_FISS_XFEM et MODI_MODELE_XFEM avant
     l'utilisation de PROPA_FISS.
  """),
  
95 : _("""
  -> Une grille auxiliaire a �t� utilis�e pour la d�termination des
     fissures actuelles du mod�le. Par contre, aucune grille n'a �t�
     donn�e pour la propagation courante.
  -> Risque & Conseil:
     Veuillez sp�cifier la m�me grille que celle qui a �t� utilis� pour
     la propagation pr�c�dente.
  """),
  
96 : _("""
  -> La grille auxiliaire qui a �t� utilis�e � la propagation pr�c�dente
     pour d�terminer la fissure actuelle n'est pas la m�me que celle qui
     a �t� sp�cifi�e pour la propagation courante:
     FISS_ACTUELLE         = %(k1)s
     GRILLE_AUX pr�c�dente = %(k2)s
     GRILLE_AUX actuelle   = %(k3)s
  -> Risque & Conseil:
     Veuillez utiliser la m�me grille pour la fissure ci-dessus.
  """),
  
97 : _("""
  -> La localisation du domaine de calcul a �t� utilis� pour la
     d�termination de la configuration actuelle des fissures du mod�le.
     Par contre, pour la propagation courante, la localisation n'a pas
     �t� activ�e.
  -> Risque & Conseil:
     Veuillez utiliser la localisation du domaine (DOMAINE='TORE') m�me
     pour la propagation courante.
  """),
  
98 : _("""
  -> La localisation du domaine de calcul a �t� utilis� sans grille
     auxiliaire pour la d�termination de la configuration actuelle des
     fissures du mod�le. Par contre, pour la propagation courante, on
     demande de l'utiliser avec une grille auxiliaire.
     FISS_ACTUELLE = %(k1)s
  -> Risque & Conseil:
     Veuillez continuer � utiliser la localisation du domaine sans
     grille auxiliaire. Si vous voulez utiliser une grille auxiliaire
     pour la propagation courante, vous devez forcement l'utiliser
     � partir de la premi�re propagation.
  """),
  
99 : _("""
  -> La valeur du rayon du tore de localisation du domaine de calcul est
     plus petite que celle qui est n�cessaire pour la bonne mise � jour
     des level sets.
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
