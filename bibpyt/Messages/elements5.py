#@ MODIF elements5 Messages  DATE 19/06/2007   AUTEUR LEBOUVIER F.LEBOUVIER 
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







2: _("""
 tuyau : le nombre de couches est limite a  %(i1)d 
"""),

3: _("""
 tuyau : le nombre de secteurs est limite a  %(i1)d 
"""),





























8: _("""
 Vous voulez utiliser l'indicateur de convergence RESI_REFE_RELA mais vous n'avez pas
 renseign� le mot-cl� %(k1)s .
"""),

9: _("""
 Employez la mod�lisation sp�cifique aux grandes d�formations XX_INCO_GD
"""), 

10: _("""
 La mod�lisation GRAD_VARI n'est plus disponible en grandes d�formations. Pour Rousselier
 version SIMO_MIEHE, vous pouvez faire du non-local en utilisant la mod�lisation XX_INCO_GD
 et en d�finissant C_GONF<>0 sous l'op�rande NON_LOCAL de DEFI_MATERIAU
"""), 

11: _("""
 Le rayon R_SUP (ou R_SUP_FO) doit obligatoirement etre sup�rieur au rayon R_INF 
 (resp. R_INF_FO).
"""), 

12: _("""
 Le noeud %(k1)s du fond de fissure n est rattach� � aucune maille surfacique 
 de la l�vre sup�rieure : v�rifier les groupes de mailles.
"""), 

13: _("""
 Le noeud %(k1)s du fond de fissure n est rattach� � aucune maille surfacique 
 de la l�vre inf�rieure : v�rifier les groupes de mailles.
"""), 

14: _("""
 Les noeuds %(k1)s de FOND_INF et %(k2)s de FOND_SUP ne sont pas en vis � vis. 
"""), 

15: _("""
 FONFIS - occurence %(i1)s : les objets pr�c�demment �voqu�s sont inexistants
 ou de type incompatible.
"""), 

16: _("""
 FONFIS - occurence %(i1)s : les mailles sp�cifi�es ne permettent pas de d�finir 
 une ligne continue.
 Conseil (si op�rateur DEFI_FOND_FISS) : v�rifier le groupe de maille du fond de fissure.
"""), 

17: _("""
 FONFIS - Trop de noeuds dans le groupe de noeuds %(k1)s.
 --> Noeud utilis� : %(k2)s
"""), 

18: _("""
 FONFIS - Trop de mailles dans le groupe de mailles GROUP_MA_ORIG.
 --> Maille utilis�e : %(k1)s
"""), 

19: _("""
 FONFIS - Occurence %(i1)s : maille %(k1)s inexistante.
"""), 

20: _("""
 FONFIS - Occurence %(i1)s : maille %(k1)s non lin�ique.
"""), 

21: _("""
 FONFIS - Occurence %(i1)s : m�lange de SEG2 et de SEG3 (maille %(k1)s).
"""), 

22: _("""
   Erreur, le nombre de noeuds d'un element de joint 3D n'est pas correct   
"""),


23: _("""
   Erreur, le nombre de points de Gauss d'un element de joint 3D n'est pas correct   
"""),

24: _("""
  le nombre de mailles du modele %(i1)d est diff�rent de la somme des mailles des sous-domaines %(i2)d 
"""),
25: _("""
  le sous-domaine n %(i1)d n'est pas renseign� ou vide dans DEFI_PART_OPS
"""),








28: _("""
  le modele comporte %(i1)d mailles de plus que l'ensemble des sous-domaines 
"""),
29: _("""
  le modele comporte %(i1)d mailles de moins que l'ensemble des sous-domaines 
"""),

30: _("""
 jacobien negatif ou nul : jacobien =  %(r1)f 
"""),

31: _("""
 jacobien negatif ou nul : jacobien =  %(r1)f 
"""),

32: _("""
  Toute m�thode de contact autre que la m�thode continue est proscrite avec
  FETI! En effet cette derni�re m�thode est bas�e sur un vision maille/calcul
  �l�mentaire et non pas sur une approche globale discr�te dont le flot de
  donn�es est plus difficilement dissociable par sous-domaine.
  Merci, d'activer donc toutes les zones de contact avec ladite m�thode. 
"""),

33: _("""
  Avec FETI, on ne peut m�langer dans une seul AFFE_CHAR_MECA, du contact
  avec des chargements � LIGREL tardif (Dirichlet, Force Nodale...).
  Merci, de dissocier les types de chargement par AFFE_CHAR_MECA.
"""),
34: _("""
  Contact m�thode continue avec FETI: la maille %(i1)d de la zone %(i2)d
  du chargement %(i3)d , semble etre � cheval entre les sous-domaines
  %(i4)d et %(i5)d !
  Solution paliative: il faut forcer le partitionnement � ne pas couper
  cette zone de contact ou essayer de la d�doubler en deux zones.
"""),

35: _("""
  Contact m�thode continue avec FETI: la surface %(i1)d de la zone %(i2)d
  du chargement %(i3)d n'est port�e par aucun sous-domaine !
"""),

36: _("""
  Contact m�thode continue avec FETI: le noeud %(i1)d est pr�sent plusieurs
  fois dans la zone de contact %(i2)d . Cela ne devrait pas etre un probl�me
  pour l'algorithme, mais ce n'est pas une mod�lisation du contact tr�s
  orthodoxe !
"""),

37: _("""
  Contact m�thode continue avec FETI: le noeud %(i1)d est a l'intersection de
  plusieurs zones de contact. Cela va probablement g�n�rer un probl�me dans
  l'algorithme de contact (pivot nul) !
"""),

38: _("""
  Contact m�thode continue avec FETI: le noeud %(i1)d de la zone de contact
  %(i2)d est aussi sur l'interface FETI ! Pour l'instant ce cas de figure
  est proscrit. Essayer de l'enlevez de la zone de contact ou de reconfigurer
  vos sous-domaines.
"""),
}
