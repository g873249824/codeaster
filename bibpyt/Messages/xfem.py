#@ MODIF xfem Messages  DATE 22/09/2008   AUTEUR LAVERNE J.LAVERNE 
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

cata_msg={

1: _("""
  -> Les fissures X-FEM sont surement trop proches.
     Il faut au minimum 2 mailles entre les fissures.
  -> Risque & Conseil:
     Veuillez raffiner le maillage entre les fissures
     (ou �carter les fissures). 
"""),

2: _("""
  -> Le calcul de la distance d'un noued � l'ellipse n'a pas converg� 
     avec le nombre d'it�rations maximal fix� (10). Cela est d� � une
     ellipse tr�s allong�e.
  -> Conseil:
     Contacter les d�veloppeur.
     Dans la mesure du possible, d�finissez une ellipse moins allong�e.
"""),


3: _("""
  -> Le mod�le %(k1)s est incompatible avec la m�thode X-FEM.
  -> Risque & Conseil:
     V�rifier qu'il a bien �t� cr�� par l'op�rateur MODI_MODELE_XFEM. 
"""),

4: _("""
  -> Il est interdit de m�langer dans un mod�le les fissures X-FEM 
     avec et sans contact. 
  -> Risque & Conseil:
     Veuillez rajouter les mots cl�s CONTACT manquants 
     dans DEFI_FISS_XFEM.
"""),

7: _("""
     Il y a %(i1)s mailles %(k1)s 
"""),

8: _("""
     Le nombre de %(k1)s X-FEM est limit� � 10E6. 
     Risque & Conseil:
     Veuillez r�duire la taille du maillage.
"""),

9: _("""
     L'option K_G_MODA n'est pas autoris�e avec une fissure d�finie 
     par la commande DEFI_FISS_XFEM (m�thode X-FEM).
"""),

10: _("""
     La direction du champ theta n'a pas �t� donn�e. La direction automatique
     est une direction variable, bas�e sur le grandient de la level set tangente.
"""),

11: _("""
  -> On a trouv� plus de 2 points de fond de fissure, ce qui est impossible en 2d.
  -> Risque & Conseil:
     Veuillez revoir la d�finition des level sets.
"""),

12: _("""
  Le gradient de la level set tangente est nul au noeud %(k1)s.
  Ceci est certainement du � un point singulier dans la d�finition de la levet set.
  Il vaut veuiller � ce que ce point singulier ne soit pas inclus dans la couronne
  d'int�gration du champ theta. 
  Conseil : r�duisez la taille de la couronne du champ theta : (mot-cl�s RSUP et RINF).
"""),

13: _("""
     Dans le mod�le, des mailles SEG2 ou SEG3 poss�dent des noeuds enrichis par X-FEM.
     Ceci n'est pas encore possible en 3D.
     Conseils : si ces mailles sont importantes pour le calcul (charge lin�ique...), il faut
     les mettre loin de de la fissure.
     Si ces mailles ne servent pas pour le calcul, il vaut mieux ne pas les affecter dans le mod�le,
     ou bien les supprimer du maillage.
"""),

14: _("""
     On ne peut pas appliquer un cisaillement 2d sur les l�vres d'une fissure X-FEM.
"""),

15: _("""
  -> Cette option n'a pas encore �t� programm�e.
  -> Risque & Conseil:
     Veuillez utiliser un autre chargement (en pression) ou contacter votre
     correspondant.
"""),

16: _("""
  -> Il n'y a aucun �l�ment enrichi.
  -> Risque & Conseil:
     - Si le contact est d�fini sur les l�vres de la fissure, la mod�lisation
       doit etre 3D_XFEM_CONT ou C_PLAN_XFEM_CONT ou D_PLAN_XFEM_CONT.
     - Si le contact n'est pas d�fini sur les l�vres de la fissure,
       la mod�lisation doit etre 3D ou C_PLAN ou D_PLAN'.
"""),

18: _("""
     Dimension de l'espace incorrecte. 
     Le mod�le doit etre 2D ou 3D et ne pas comporter de sous-structures.
"""),

21: _("""
     Le mot-clef ORIE_FOND n'est pas n�cessaire en 2D.
"""),

22: _("""
     Plus d'une occurrence du mot-clef ORIE_FOND.
"""),

23: _("""
  -> Erreur dans le choix de la m�thode de calcul des level-sets
  -> Risque & Conseil :
     Veuillez renseignez FONC_LT/LN ou GROUP_MA_FISS/FOND.
"""),

26: _("""
     L'approche <<Grands glissements avec XFEM>> fonctionne seulement pour le cas 2D.
"""),

27: _("""
     Seulement les mailles QUAD4 sont prises en compte par l'approche
     <<Grands glissements avec XFEM>>.
"""),

57: _("""
  -> Aucune maille de fissure n'a �t� trouv�e. 
  -> Risque & Conseil :
     Suite des calculs risqu�e.
"""),

58: _("""
  -> Aucun point du fond de fissure n'a �t� trouv� !
  -> Risque & Conseil :
     Ce message est normal si vous souhaitiez d�finir une interface (et non une fissure).
     Si vous souhaitiez d�finir une fissure, la d�finition des level sets (M�thode XFEM)
     ne permet pas de trouver de points du fond de fissure � l'int�rieur de la structure.
     Il doit y avoir une erreur lors de la d�finition de la level set tangente.
     V�rifier la d�finition des level sets.
"""),

59: _("""
     Ne pas utiliser le mot-clef RAYON_ENRI lorsque le fond de fissure
     est en dehors de la structure.
"""),

60: _("""
  -> Le point initial de fissure n'est pas un point de bord de fissure,
     bien que la fissure soit d�bouchante
  -> Risque & Conseil:
     Assurez-vous de la bonne d�finition de PFON_INI.
"""),


}
