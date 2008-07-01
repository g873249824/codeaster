#@ MODIF elements5 Messages  DATE 30/06/2008   AUTEUR FLEJOU J-L.FLEJOU 
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

2 : _("""
 tuyau : le nombre de couches est limite a  %(i1)d
"""),

3 : _("""
 tuyau : le nombre de secteurs est limite a  %(i1)d
"""),

8 : _("""
 Vous voulez utiliser l'indicateur de convergence RESI_REFE_RELA mais vous n'avez pas
 renseign� le mot-cl� %(k1)s .
"""),

9 : _("""
 Employez la mod�lisation sp�cifique aux grandes d�formations XX_INCO_GD
"""),

15 : _("""
 FONFIS - occurence %(i1)s : les objets pr�c�demment �voqu�s sont inexistants
 ou de type incompatible.
"""),

16 : _("""
 FONFIS - occurence %(i1)s : les mailles sp�cifi�es ne permettent pas de d�finir
 une ligne continue.
 Conseil (si op�rateur DEFI_FOND_FISS) : v�rifier le groupe de maille du fond de fissure.
"""),

17 : _("""
 FONFIS - Trop de noeuds dans le groupe de noeuds %(k1)s.
 --> Noeud utilis� : %(k2)s
"""),

18 : _("""
 FONFIS - Trop de mailles dans le groupe de mailles GROUP_MA_ORIG.
 --> Maille utilis�e : %(k1)s
"""),

19 : _("""
 FONFIS - Occurence %(i1)s : maille %(k1)s inexistante.
"""),

20 : _("""
 FONFIS - Occurence %(i1)s : maille %(k1)s non lin�ique.
"""),

21 : _("""
 FONFIS - Occurence %(i1)s : m�lange de SEG2 et de SEG3 (maille %(k1)s).
"""),

22 : _("""
   Erreur, le nombre de noeuds d'un element de joint 3D n'est pas correct
"""),

23 : _("""
   Erreur, le nombre de points de Gauss d'un element de joint 3D n'est pas correct
"""),

24 : _("""
  le nombre de mailles du modele %(i1)d est diff�rent de la somme des mailles des sous-domaines %(i2)d
"""),

25 : _("""
  le sous-domaine n %(i1)d n'est pas renseign� ou vide dans DEFI_PART_OPS
"""),

28 : _("""
  le modele comporte %(i1)d mailles de plus que l'ensemble des sous-domaines
"""),

29 : _("""
  le modele comporte %(i1)d mailles de moins que l'ensemble des sous-domaines
"""),

30 : _("""
 jacobien negatif ou nul : jacobien =  %(r1)f
"""),

32 : _("""
  Toute m�thode de contact autre que la m�thode continue est proscrite avec
  FETI! En effet cette derni�re m�thode est bas�e sur un vision maille/calcul
  �l�mentaire et non pas sur une approche globale discr�te dont le flot de
  donn�es est plus difficilement dissociable par sous-domaine.
  Merci, d'activer donc toutes les zones de contact avec ladite m�thode.
"""),

33 : _("""
  Avec FETI, on ne peut m�langer dans une seul AFFE_CHAR_MECA, du contact
  avec des chargements � LIGREL tardif (Dirichlet, Force Nodale...).
  Merci, de dissocier les types de chargement par AFFE_CHAR_MECA.
"""),

34 : _("""
  Contact m�thode continue avec FETI: la maille %(i1)d de la zone %(i2)d
  du chargement %(i3)d , semble etre � cheval entre les sous-domaines
  %(i4)d et %(i5)d !
  Solution paliative: il faut forcer le partitionnement � ne pas couper
  cette zone de contact ou essayer de la d�doubler en deux zones.
"""),

35 : _("""
  Contact m�thode continue avec FETI: la surface %(i1)d de la zone %(i2)d
  du chargement %(i3)d n'est port�e par aucun sous-domaine !
"""),

36 : _("""
  Contact m�thode continue avec FETI: le noeud %(i1)d est pr�sent plusieurs
  fois dans la zone de contact %(i2)d . Cela ne devrait pas etre un probl�me
  pour l'algorithme, mais ce n'est pas une mod�lisation du contact tr�s
  orthodoxe !
"""),

37 : _("""
  Contact m�thode continue avec FETI: le noeud %(i1)d est a l'intersection de
  plusieurs zones de contact. Cela va probablement g�n�rer un probl�me dans
  l'algorithme de contact (pivot nul) !
"""),

38 : _("""
  Contact m�thode continue avec FETI: le noeud %(i1)d de la zone de contact
  %(i2)d est aussi sur l'interface FETI ! Pour l'instant ce cas de figure
  est proscrit. Essayer de l'enlevez de la zone de contact ou de reconfigurer
  vos sous-domaines.
"""),

39 : _("""
 echec de la recherche de zero a l'iteration :  %(i1)d
  fonction decroissante - pour x=a:  %(r1)f
  / fonction(a):  %(r2)f
                          et   x=b:  %(r3)f
  / fonction(b):  %(r4)f

  fonction x=:  %(r5)f  %(r6)f  %(r7)f  %(r8)f  %(r9)f  %(r10)f %(r11)f %(r12)f %(r13)f %(r14)f
                %(r15)f %(r16)f %(r17)f %(r18)f %(r19)f %(r20)f %(r21)f %(r22)f %(r23)f %(r24)f

  fonction f=:  %(r25)f  %(r26)f  %(r27)f  %(r28)f  %(r29)f  %(r30)f %(r31)f %(r32)f %(r33)f %(r34)f
                %(r35)f  %(r36)f  %(r37)f  %(r38)f  %(r39)f  %(r40)f %(r41)f %(r42)f %(r43)f %(r44)f

"""),

40 : _("""
 echec de la recherche de zero a l'iteration :  %(i1)d
  fonction constante    - pour x=a:  %(r1)f
  / fonction(a):  %(r2)f
                          et   x=b:  %(r3)f
  / fonction(b):  %(r4)f

  fonction x=:  %(r5)f  %(r6)f  %(r7)f  %(r8)f  %(r9)f  %(r10)f %(r11)f %(r12)f %(r13)f %(r14)f
                %(r15)f %(r16)f %(r17)f %(r18)f %(r19)f %(r20)f %(r21)f %(r22)f %(r23)f %(r24)f

  fonction f=:  %(r25)f  %(r26)f  %(r27)f  %(r28)f  %(r29)f  %(r30)f %(r31)f %(r32)f %(r33)f %(r34)f
                %(r35)f  %(r36)f  %(r37)f  %(r38)f  %(r39)f  %(r40)f %(r41)f %(r42)f %(r43)f %(r44)f

"""),

41 : _("""
     Temp�rature n�gative � la maille :  %(k1)s
"""),

42 : _("""
 L'�paisseur definie dans DEFI_GLRC et celle d�finie dans AFFE_CARA_ELEM ne sont pas coh�rentes.
 Epaisseur dans DEFI_GLRC: %(r1)f
 Epaisseur dans AFFE_CARA_ELEM: %(r2)f
"""),

43 : _("""
Avec l'op�rateur STAT_NON_LINE et l'�l�ment de poutre POU_C_T, vous ne pouvez utiliser
que les mots cl�s RELATION='ELAS' et  DEFORMATION='PETIT' avec COMP_INCR et COMP_ELAS.
"""),

}
