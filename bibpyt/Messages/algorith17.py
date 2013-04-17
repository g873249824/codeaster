#@ MODIF algorith17 Messages  DATE 16/04/2013   AUTEUR DESROCHE X.DESROCHES 
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
1: _(u"""
 Il y a moins de sous-domaines (%(i1)d) que de processeurs participant au calcul (%(i2)d).

 Conseils :
   - augmentez le nombre de sous-domaines de la partition du mot-cl� PARTITION
   - diminuez le nombre de processeurs du calcul
"""),

2: _(u"""
         Comportement %(k1)s non implant� pour l'�l�ment d'interface
"""),

4: _(u"""
        La formulation n'est ni en contrainte nette ni en Bishop
"""),

5 : _(u"""
  Le champ post-trait� est un CHAM_ELEM, le calcul de moyenne ne fonctionne que
 sur les CHAM_NO. Pour les CHAM_ELEM utiliser POST_ELEM mot-cl� INTEGRALE.
"""),

6 : _(u"""
  Le calcul de la racine num�ro %(i1)d par la m�thode de la matrice compagnon a �chou�.
"""),

7 : _(u"""
  Il n'y a qu'un seul MODE_MECA en entr�e de DEFI_BASE_MODALE. La num�rotation
  de r�f�rence prise est celle associ�e a celui-ci. Le mot-cl� NUME_REF
  n'est pas pris en compte
"""),

8 : _(u"""
  Il manque le nume_ddl dans le concept %(k1)s.
  Propositions :
   - Si ce concept est issu de l'op�rateur DEFI_BASE_MODALE, renseigner le mot-cl� NUME_REF dans DEFI_BASE_MODALE.
   - Si ce concept est issu de l'op�rateur CREA_RESU, utiliser les mots-cl�s MATR_RIGI et MATR_MASS dans CREA_RESU.
"""),

9 : _(u"""
  Il faut renseigner le mot-cl� NUME_REF.
"""),

10 : _(u"""
  La loi de comportement m�canique %(k1)s n'est pas compatible avec les
  �l�ments de joint avec couplage hydro-m�canique.
"""),
11 : _(u"""
  La fermeture du joint sort des bornes [0,fermeture maximale] sur la maille %(k1)s.
  fermeture du joint CLO = %(r1)f
  fermeture maximale UMC = %(r2)f
  V�rifier la coh�rence chargement m�canique, fermeture asymptotique et ouverture
  initiale.
"""),

12 : _(u"""
  La temp�rature de r�f�rence (exprim�e en Kelvin) doit toujours �tre strictement sup�rieure � z�ro.
"""),

13 : _(u"""
  La pression de gaz de r�f�rence doit toujours �tre diff�rente de z�ro.
"""),

14 : _(u"""
  Les mots cl�s PRES_FLUIDE et PRES_CLAVAGE sont incompatibles avec les mod�lisations xxx_JOINT_HYME
"""),

15 : _(u"""
  Les donn�es mat�riau RHO_FLUIDE, VISC_FLUIDE et OUV_MIN sont obligatoires avec les mod�lisations xxx_JOINT_HYME
"""),

16 : _(u"""
  Les donn�es mat�riau RHO_FLUIDE, VISC_FLUIDE et OUV_MIN sont incompatibles avec les mod�lisations xxx_JOINT
"""),

17 : _(u"""
  La partition %(k1)s que vous utilisez pour partitionner le mod�le %(k2)s en sous-domaines a �t� construite sur un autre mod�le (%(k3)s).

  Conseil : v�rifiez la coh�rence des mod�les.
"""),

18 : _(u"""
  La base de modes associ�e au r�sultat g�n�ralis� sous le mot-cl�
  EXCIT_RESU %(i1)d n'est pas la m�me que celle utilis�e pour la
  fabrication des matrices g�n�ralis�es.
"""),

19 : _(u"""
  La projection d'un resultat non r�el sur une base de mode (de type
  r�sultat harmonique) n'est pas possible. Vous pouvez demander
  l'�volution.
"""),

20 : _(u"""
  La prise en compte d'un amortissement �quivalent a un amortissement modal par le mot-cl� AMOR_MODAL n�cessite 
  une base de modes pr� calcul�e sur laquelle est d�compos� l'amortissement. 
  Conseil: v�rifiez qu'un base de modes est bien renseign�e sous le mot-cl� MODE_MECA.
"""),
21 : _(u"""
  Aucune valeur d'amortissement modal n'a �t� trouv�e sous le mot-cl� AMOR_MODAL. 
  Cette information est n�cessaire pour la prise en compte d'un amortissement de type modal.

"""),

22 : _(u"""
  Il y a %(i1)d points de Gauss sur l'axe de rotation. En ces points les axes Or et suivant th�ta ne sont pas d�finis. On prend
   un axe Or quelconque normal � Oz pour continuer le changement de rep�re mais seules les composantes suivant z ont un sens en ces points.
"""),

25 : _(u"""
  Lors de la reprise du calcul, la liste des champs calcul�s (DEPL, VITE, ACCE) doit �tre la m�me 
  pour le concept entrant et sortant.
"""),
26 : _(u"""
  La structure de donn�es resultat est corrompue. Elle ne contient pas d'objet avec la liste des num�ros d'ordre.
"""),
27 : _(u"""
  La structure de donn�es resultat est corrompue. La liste des num�ros d'ordres ne correspond pas
  � la liste des discr�tisations temporelles ou fr�quentielles.
"""),
28 : _(u"""
  La structure de donn�es en entr�e ne contient aucun des champs requis pour la restitution temporelle.
  Conseil: v�rifiez la liste des champs renseign�e sous NOM_CHAM, ou bien testez l'option TOUT_CHAM='OUI'.
"""),
29 : _(u"""
  Erreur dans l'allocation de la structure de donn�es dynamique. La liste des champs � allouer n'est pas valide.
"""),
30 : _(u"""
  On n'arrive pas � r�cup�rer la temp�rature au temps T-.
"""),
31 : _(u"""
  Il faut donner autant de coefficients pour le param�tre %(k1)s 
  qu'il y a de modes propres dans la base sur laquelle est fabriqu�e
  le macro-�l�ment.
   - Nombre de modes de la base : %(i1)d
   - Nombre de coefficients donn�s : %(i2)d.
"""),
32 : _(u"""
  Le macro-�l�ment est assembl� � partir de donn�es mesur�es.
  Le calcul des masses effectives est impossible. Ne pas en tenir
  compte dans les calculs post�rieurs.
"""),
}
