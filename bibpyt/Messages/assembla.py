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
# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

1 : _(u"""
  Erreur d'utilisation :
    Pour les m�thodes it�ratives GCPC et FETI, on ne peut pas encore utiliser
    de matrice non-sym�trique.

  Conseil : Changer de solveur
"""),

3: _(u"""
 Le calcul est s�quentiel, on ne peut donc pas utiliser MATR_DISTRIBUEE='OUI'.
 On force MATR_DISTRIBUEE='NON'.
"""),

4: _(u"""
 L'utilisation de MATR_DISTRIBUEE='OUI' n�cessite que chaque processeur ait
 au moins 1 degr� de libert� qui lui soit allou�.
 Ici, le processeur %(i1)d ne s'est vu attribu� aucun ddl.

 Conseil : Modifiez le partitionnement des mailles de votre mod�le dans
           AFFE_MODELE/PARTITION/PARALLELISME ou diminuez le nombre de processeurs.
"""),

5 : _(u"""
 mod�les discordants
"""),

6 : _(u"""
 FETI : maille positive avec LIGREL de charge !
"""),

7 : _(u"""
 FETI : maille n�gative avec LIGREL de mod�le !
"""),

8 : _(u"""
 le mot-cl� :  %(k1)s  est incorrect.
 on attend : "CUMU" ou "ZERO"
"""),

9 : _(u"""
 on ne trouve pas la composante "LAGR" dans la grandeur
"""),

10 : _(u"""
 il est impr�vu d avoir la composante "LAGR" au del� de 30
"""),

11 : _(u"""
 on ne peut assembler que des vecteurs r�els ou complexes
"""),

12 : _(u"""
 le maillage  %(k1)s  contient des super-mailles
 pour l'instant, elles sont proscrites avec FETI
"""),

13 : _(u"""
 ICHIN = 0
"""),

14 : _(u"""
 ICHIN < -2
"""),

15 : _(u"""
 S => ICHIN=/0
"""),

16 : _(u"""
 action : E/L/S
"""),

18 : _(u"""
 Erreur d�veloppeur dans l'assemblage.
 Les vecteurs �l�mentaires ou les matrices �l�mentaires sont incoh�rentes: ils ne portent pas sur le m�me mod�le ou ils ne calculent pas la m�me option.
"""),

19 : _(u"""
 Erreur d�veloppeur dans l'assemblage.
 Les vecteurs �l�mentaires ou les matrices �l�mentaires ne contiennent ni sous-structures, ni objet LISTE_RESU.
"""),

20 : _(u"""
  Erreur programmeur :
    lors d'un assemblage, dans la liste des MATR_ELEM (ou VECT_ELEM) que l'on veut
    assembler, on ne trouve aucun resuelem.
"""),

21 : _(u"""
 mod�les diff�rents
"""),

24 : _(u"""
 le nombre maximum de composante de la grandeur est nul
"""),

25 : _(u"""
 le nombre d'entiers codes est nul
"""),

26 : _(u"""
 le noeud:  %(k1)s composante:  %(k2)s  est bloqu� plusieurs fois.
"""),

27 : _(u"""
 l'entier d�crivant la position du premier Lagrange ne peut �tre �gal qu'� +1 ou -1 .
"""),

28 : _(u"""
 le nombre de noeuds effectivement num�rot�s ne correspond pas au nombre
 de noeuds � num�roter
"""),

29 : _(u"""
  -  aucun LIGREL
"""),

30 : _(u"""
  plusieurs ph�nom�nes
"""),

31 : _(u"""
 les DDL du NUME_DDL ont boug�
"""),

32 : _(u"""
 ph�nom�ne non pr�vu dans le MOLOC de NUMER2 pour DD
"""),

33 : _(u"""
 le .PRNO est construit sur plus que le maillage
"""),

34 : _(u"""
 le .PRNO est de dimension nulle
"""),

35 : _(u"""
 il n y a pas de mod�le dans la liste  %(k1)s .NUME.LILI
"""),

36 : _(u"""
 noeud inexistant
"""),

37 : _(u"""
 m�thode :  %(k1)s  inconnue.
"""),

38 : _(u"""
 noeud incorrect
"""),

39 : _(u"""
 le ph�nom�ne  %(k1)s  n'est pas admis pour la sym�trisation des matrices.
 seuls sont admis les ph�nom�nes "MECANIQUE" et "THERMIQUE"
"""),

41 : _(u"""
 le noeud  : %(i1)d  du RESUEL : %(k1)s  du VECT_ELEM  : %(k2)s
 n'a pas d'adresse dans : %(k3)s
"""),

42 : _(u"""
 le noeud  : %(i1)d  du RESUEL : %(k1)s  du VECT_ELEM  : %(k2)s
   a une adresse  : %(i2)d  > NEQUA : %(i3)d
"""),

43 : _(u"""
 NDDL :  %(i1)d  > NDDL_MAX : %(i2)d
"""),

44 : _(u"""
 --- VECT_ELEM     : %(k1)s
 --- RESU          : %(k2)s
 --- NOMLI         : %(k3)s
 --- GREL num�ro   : %(i1)d
 --- MAILLE num�ro : %(i2)d
 --- NNOE par NEMA : %(i3)d
 --- NNOE par NODE : %(i4)d
"""),

45 : _(u"""
Erreur Programmeur ou utilisateur :
-----------------------------------
 Le LIGREL    : %(k1)s  r�f�renc� par le noeud suppl�mentaire. : %(i1)d
 de la maille : %(i2)d  du resuelem  : %(k2)s  du sd_vect_elem : %(k3)s
 n'est pas pr�sent  dans le sd_nume_ddl : %(k4)s

Risques & conseils :
--------------------
 Si vous utilisez la commande MACRO_ELAS_MULT :
   Si %(k5)s est une charge contenant des conditions aux limites dualis�es (DDL_IMPO, ...),
   �tes-vous sur d'avoir indiqu� cette charge derri�re le mot cl� CHAR_MECA_GLOBAL ?
   En effet, il faut indiquer TOUTES les charges dualis�es derri�re CHAR_MECA_GLOBAL.

 Si vous utilisez directement la commande ASSE_VECTEUR :
   Si %(k5)s est une charge contenant des conditions aux limites dualis�es (DDL_IMPO, ...),
   �tes-vous sur d'avoir indiqu� cette charge derri�re le mot cl� CHARGE
   de la commande CALC_MATR_ELEM/OPTION='RIGI_MECA' ?
"""),

46 : _(u"""
 --- NDDL :  %(i1)d  > NDDL_MAX : %(i2)d
"""),

47 : _(u"""
 --- NDDL :  %(i1)d  > NDDL_MAX : %(i2)d
"""),

48 : _(u"""
 --- le noeud  : %(i1)d  du RESUEL    : %(k1)s  du VECT_ELEM   : %(k2)s
 --- n'a pas d''adresse  dans la num�rotation : %(k3)s
"""),

49 : _(u"""
 --- le noeud  : %(i1)d  du RESUEL    : %(k1)s  du VECT_ELEM   : %(k2)s
 --- a une adresse : %(i2)d   > NEQUA : %(i3)d
"""),

63 : _(u"""
 erreur sur le premier Lagrange d'une LIAISON_DDL
 on a mis 2 fois le premier  Lagrange :  %(i1)d
 derri�re le noeud :  %(i2)d
"""),

64 : _(u"""
 erreur sur le  2�me Lagrange d'une LIAISON_DDL
 on a mis 2 fois le 2�me  Lagrange :  %(i1)d
 derri�re le noeud :  %(i2)d
"""),

65 : _(u"""
 incoh�rence dans le d�nombrement des ddls
 nombre de ddl a priori    : %(i1)d
 nombre de ddl a posteriori: %(i2)d
"""),

66 : _(u"""
 Il faut v�rifier la coh�rence des maillages dans les structures de donn�es
 %(k5)s et %(k6)s. Les maillages devraient �tre les m�mes.

 On trouve au moins deux maillages diff�rents :
  - maillage 1 : %(k1)s
  - maillage 2 : %(k2)s

 D�tails :
   Le maillage 1 : %(k1)s est li� au ligrel 1 : %(k3)s
   Le maillage 2 : %(k2)s est li� au ligrel 2 : %(k4)s
"""),

67 : _(u"""
 Probl�me dans NUMERO.F avec FETI: L'objet PROF_CHNO.NUEQ est diff�rent de
 l'identit� pour i= %(i1)d on a NUEQ(i)= %(i2)d
"""),

68 : _(u"""
 Probl�me avec le solveur lin�aire FETI: %(i1)d incoh�rence(s) entre la SD_FETI
 et le param�trage de l'op�rateur.

 Conseil:
 ========
 V�rifiez bien que le mod�le et la liste de charges utilis�s lors du partitionnement
 (op�rateur DEFI_PART...) sont identiques � ceux utilis�s pour le calcul.

 D�tail informatique: arr�t dans NUMERO.f.
"""),

}
