#@ MODIF elements5 Messages  DATE 25/03/2013   AUTEUR DELMAS J.DELMAS 
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

cata_msg = {

2 : _(u"""
 tuyau : le nombre de couches est limite a  %(i1)d
"""),

3 : _(u"""
 tuyau : le nombre de secteurs est limite a  %(i1)d
"""),

4 : _(u"""
 Le nombre de sous-points est limit� � %(i1)d, or vous en avez d�finis %(i2)d !
 Veuillez contacter votre assistance technique.
"""),

15 : _(u"""
A l'occurrence %(i1)d, les objets pr�c�demment �voqu�s sont inexistants ou de type incompatible.
"""),

16 : _(u"""
Les mailles fournies sont non cons�cutives dans la num�rotation des noeuds.
En effet, les mailles segment doivent �tre ordonn�es de telle sorte que pour deux segments
cons�cutifs, le deuxi�me noeud sommet du premier segment soit le m�me que le premier noeud
sommet du deuxi�me segment.

Conseil : Pour ordonner les mailles du fond de fissure, veuillez
utiliser NOEUD_ORIG (ou GROUP_NO_ORIG) et NOEUD_EXTR (ou GROUP_NO_EXTR).
"""),

17 : _(u"""
Un seul noeud doit constituer le groupe de noeuds %(k1)s. On n'utilisera que le noeud %(k2)s.
"""),

19 : _(u"""
 A l'occurrence %(i1)d, la maille %(k1)s est inexistante.
"""),

20 : _(u"""
 A l'occurrence %(i1)d, la maille %(k1)s n'est pas lin�ique.
"""),

21 : _(u"""
 A l'occurrence %(i1)d, le m�lange de SEG2 et de SEG3 (maille %(k1)s) n'est possible.
"""),

22 : _(u"""
   Erreur, le nombre de noeuds d'un �l�ment de joint 3D n'est pas correct
"""),

23 : _(u"""
   Erreur, le nombre de points de Gauss d'un �l�ment de joint 3D n'est pas correct
"""),

24 : _(u"""
  le nombre de mailles du mod�le %(i1)d est diff�rent de la somme des mailles des
  sous-domaines %(i2)d
"""),

25 : _(u"""
  le sous-domaine n %(i1)d n'est pas renseign� ou vide dans DEFI_PART_OPS
"""),

28 : _(u"""
  le mod�le comporte %(i1)d mailles de plus que l'ensemble des sous-domaines
"""),

29 : _(u"""
  le mod�le comporte %(i1)d mailles de moins que l'ensemble des sous-domaines
"""),

30 : _(u"""
 jacobien n�gatif ou nul : jacobien =  %(r1)f
"""),

32 : _(u"""
  Toute m�thode de contact autre que la m�thode continue est proscrite avec
  FETI! En effet cette derni�re m�thode est bas�e sur un vision maille/calcul
  �l�mentaire et non pas sur une approche globale discr�te dont le flot de
  donn�es est plus difficilement dissociable par sous-domaine.
  Merci, d'activer donc toutes les zones de contact avec ladite m�thode.
"""),

33 : _(u"""
  Avec FETI, on ne peut m�langer dans une seul AFFE_CHAR_MECA, du contact
  avec des chargements � LIGREL tardif (Dirichlet, Force Nodale...).
  Merci, de dissocier les types de chargement par AFFE_CHAR_MECA.
"""),

34 : _(u"""
  Contact m�thode continue avec FETI: la maille %(i1)d de la zone %(i2)d
  du chargement %(i3)d , semble �tre � cheval entre les sous-domaines
  %(i4)d et %(i5)d !
  Solution palliative: il faut forcer le partitionnement � ne pas couper
  cette zone de contact ou essayer de la d�doubler en deux zones.
"""),

35 : _(u"""
  Contact m�thode continue avec FETI: la surface %(i1)d de la zone %(i2)d
  du chargement %(i3)d n'est port�e par aucun sous-domaine !
"""),

36 : _(u"""
  Contact m�thode continue avec FETI: le noeud %(i1)d est pr�sent plusieurs
  fois dans la zone de contact %(i2)d . Cela ne devrait pas �tre un probl�me
  pour l'algorithme, mais ce n'est pas une mod�lisation du contact tr�s
  orthodoxe !
"""),

37 : _(u"""
  Contact m�thode continue avec FETI: le noeud %(i1)d est a l'intersection de
  plusieurs zones de contact. Cela va probablement g�n�rer un probl�me dans
  l'algorithme de contact (pivot nul) !
"""),

38 : _(u"""
  Contact m�thode continue avec FETI: le noeud %(i1)d de la zone de contact
  %(i2)d est aussi sur l'interface FETI ! Pour l'instant ce cas de figure
  est proscrit. Essayer de l'enlevez de la zone de contact ou de reconfigurer
  vos sous-domaines.
"""),

39 : _(u"""
 �chec de la recherche de z�ro a l'it�ration :  %(i1)d
  fonction d�croissante - pour x=a:  %(r1)f
  / fonction(a):  %(r2)f
                          et   x=b:  %(r3)f
  / fonction(b):  %(r4)f

  fonction x=:  %(r5)f  %(r6)f  %(r7)f  %(r8)f  %(r9)f  %(r10)f %(r11)f %(r12)f %(r13)f %(r14)f
                %(r15)f %(r16)f %(r17)f %(r18)f %(r19)f %(r20)f %(r21)f %(r22)f %(r23)f %(r24)f

  fonction f=:  %(r25)f  %(r26)f  %(r27)f  %(r28)f  %(r29)f  %(r30)f %(r31)f %(r32)f %(r33)f %(r34)f
                %(r35)f  %(r36)f  %(r37)f  %(r38)f  %(r39)f  %(r40)f %(r41)f %(r42)f %(r43)f %(r44)f

"""),

40 : _(u"""
 �chec de la recherche de z�ro a l'it�ration :  %(i1)d
  fonction constante    - pour x=a:  %(r1)f
  / fonction(a):  %(r2)f
                          et   x=b:  %(r3)f
  / fonction(b):  %(r4)f

  fonction x=:  %(r5)f  %(r6)f  %(r7)f  %(r8)f  %(r9)f  %(r10)f %(r11)f %(r12)f %(r13)f %(r14)f
                %(r15)f %(r16)f %(r17)f %(r18)f %(r19)f %(r20)f %(r21)f %(r22)f %(r23)f %(r24)f

  fonction f=:  %(r25)f  %(r26)f  %(r27)f  %(r28)f  %(r29)f  %(r30)f %(r31)f %(r32)f %(r33)f %(r34)f
                %(r35)f  %(r36)f  %(r37)f  %(r38)f  %(r39)f  %(r40)f %(r41)f %(r42)f %(r43)f %(r44)f

"""),

41 : _(u"""
     Temp�rature n�gative � la maille :  %(k1)s
"""),

42 : _(u"""
 L'�paisseur d�finie dans DEFI_GLRC et celle d�finie dans AFFE_CARA_ELEM ne sont pas coh�rentes.
 �paisseur dans DEFI_GLRC: %(r1)f
 �paisseur dans AFFE_CARA_ELEM: %(r2)f
"""),

43 : _(u"""
Avec l'op�rateur STAT_NON_LINE et l'�l�ment de poutre POU_C_T, vous ne pouvez utiliser
que les mots cl�s RELATION='ELAS' et  DEFORMATION='PETIT' avec COMP_INCR et COMP_ELAS.
"""),

44 : _(u"""
Erreur utilisateur :
  L'�tat m�tallurgique initial produit par CREA_CHAMP est incomplet.
Conseil :
  Pour le Zircaloy, il faut renseigner V1, V2 et V4
  Pour l'acier, il faut renseigner V1, V2, ..., V5
"""),

45 : _(u"""
OPTION MASS_INER : la masse volumique RHO doit �tre non nulle
"""),

46 : _(u"""
  relation :  %(k1)s  non implant�e pour les �l�ments COQUE_3D
  relation : ELAS obligatoirement
"""),

47 : _(u"""
    Il n'est pas possible d'utiliser ANGL_AXE et ORIG_AXE de AFFE_CARA_ELEM pour les mod�lisations XXX_INTERFACE
"""),

48 : _(u"""
    Il n'est pas possible d'utiliser ANGL_AXE et ORIG_AXE de AFFE_CARA_ELEM pour les mod�lisations XXX_JHMS
"""),
49 : _(u"""
   La m�thode IMPLEX ne peut pas �tre utilis�e avec la loi de comportement que vous
   avez choisi ; sur les �l�ments BARRE elle n'est utilisable qu'avec VMIS_ISOT_LINE et ELAS
"""),

50 : _(u"""
   La m�thode IMPLEX ne peut pas �tre utilis�e avec la loi de comportement que vous
   avez choisi ; sur les �l�ments 2D et 3D elle n'est utilisable qu'avec VMIS_ISOT_LINE,
   ENDO_FRAGILE et ENDO_ISOT_BETON
"""),

51 : _(u"""
  CHAMP :  %(k1)s  non trait� sous le type COQUE_GENE. Les champs trait�s sont
  EFGE et DEGE (ELGA ou ELNO)
"""),

52 : _(u"""
  CHAMP :  %(k1)s  non trait� sous le type TENS_3D. Les champs trait�s sont
  SIGM et EPSI (ELGA ou ELNO)
"""),

53 : _(u"""
  TYPE :  %(k1)s  non trait� pour les coques. Les types trait�s sont
  TENS_3D et COQUE_GENE.
"""),

54 : _(u"""
  Le nombre de sous-points est : %(i1)d. Il doit soit valoir 1 (si on a d�j� extrait le champ) soit un
  multiple de 3 (si le champ est complet).
"""),

}
