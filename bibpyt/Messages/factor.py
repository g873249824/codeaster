#@ MODIF factor Messages  DATE 26/03/2012   AUTEUR PELLET J.PELLET 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
Le syst�me lin�aire � r�soudre contient %(i1)d noeuds dont:
   - %(i2)d noeuds portant des degr�s de libert� physiques
   - %(i3)d noeuds portant des degr�s de libert� de Lagrange
Pour un total de %(i4)d �quations.
"""),

2: _(u"""
La matrice est de taille %(i1)d �quations.
Mais elle contient:
   -  %(i2)d termes non nuls si elle est sym�trique (soit un taux de remplissage de  %(r1)9.2e %%)
   -  %(i3)d termes non nuls si elle n'est pas sym�trique (soit un taux de remplissage de  %(r2)9.2e %%)
Le nombre de termes non nuls est susceptible de varier si l'on utilise le contact en m�thode continue
ou la m�thode XFEM avec contact.
"""),



10: _(u"""
Probl�me : la matrice n'est pas factorisable :
  Lors de la factorisation de la matrice, on a rencontr� un probl�me
  (pivot nul ou presque nul) � la ligne %(i1)d
  Le degr� de libert� associ� � cette ligne est de type : (%(k4)s)
  Le nombre de d�cimales "perdues" pour cette ligne est : %(i2)d.
  Ce nombre de d�cimales perdues est li� au degr� de singularit� de la matrice. Plus il est grand,
  plus le syst�me est singulier. Quand il d�passe 8, on consid�re que l'on a perdu 50%% de la pr�cision
  sur les nombres r�els (qui ont 15 d�cimales environ).

  Les diff�rents types du degr� de libert� sont :
    * (A) : Degr� libert� physique associ� au noeud : %(k1)s et � la composante : %(k2)s.
    * (B) : Degr� de libert� de Lagrange associ� au blocage : (%(k3)s).
    * (C) : Degr� de libert� de Lagrange associ� � une relation lin�aire entre plusieurs degr�s de libert�.
            La liste des noeuds impliqu�s dans cette relation lin�aire est imprim�e ci-dessus.
    * (D) : Degr� de libert� d'un syst�me "g�n�ralis�".
            Nom du noeud : %(k5)s
            Composante   : %(k6)s
            Information compl�mentaire (�ventuellement)   : %(k7)s

Conventions :
  Ce message peut �tre �mis dans des situations diff�rentes pour lesquelles on ne conna�t
  pas toutes les informations imprim�es ci-dessus.
  On adopte alors les conventions suivantes :
    * Si le num�ro de la ligne est -999 :
        Soit la matrice est vraiment singuli�re et la factorisation n'a pu aller jusqu'au bout.
        Soit on ne sait pas attribuer la singularit� de la matrice � une ligne de la matrice.
    * Si le nombre de d�cimales perdues est -999 :
        On ne sait pas d�terminer la perte de d�cimales sur la ligne incrimin�e,

Risques et conseils :
   * Si la ligne correspond a un degr� de libert� physique (A), il s'agit probablement d'un mouvement
     de corps rigide mal bloqu�.
     V�rifiez les conditions aux limites.
     Si vous faites du contact, il ne faut pas que la structure ne "tienne" que par le contact.
     V�rifiez �galement les caract�ristiques mat�riaux (module d'Young, ...).

   * Si la ligne correspond a un degr� de libert� de Lagrange (B) ou (C), il s'agit sans doute d'une condition
     limite redondante.
     En particulier, il se peut que la relation lin�aire surabondante provienne des conditions de contact.
     Peut-�tre devriez vous exclure certains noeuds des conditions de contact
     (mots cl�s SANS_NOEUD et SANS_GROUP_NO).

   * Si le solveur utilis� est LDLT ou MULT_FRONT, vous pouvez utiliser le solveur MUMPS
     car celui-ci est le seul � pouvoir factoriser les matrices qui ne sont pas d�finies positives.

   * Il se peut aussi que ce ph�nom�ne soit tout � fait normal avec X-FEM si la fissure passe
     tr�s pr�s d'un noeud.
     Si le nombre de d�cimales perdues n'est pas trop grand (max 10 d�cimales),
     vous pouvez relancer le calcul en augmentant le nombre de d�cimales perdues autoris� :
     mot-cl� NPREC du mot cl� facteur SOLVEUR.
     Sinon, contactez l'�quipe de d�veloppement.

"""),


13: _(u"""
Solveur FETI :
  Le solveur FETI est impossible dans ce contexte.
Solution :
  Il faut changer de solveur.
"""),



42: _(u"""
Matrice non factorisable :
  Le solveur MUMPS consid�re la matrice comme singuli�re (en structure ou num�riquement).

Conseil :
  Il peut s'agir d'une erreur de programmation ou d'un probl�me de mise en donn�es (blocage
  absent ou surabondant).
"""),


50: _(u"""
 Solveur MUMPS :
   -> Vous avez demand� comme num�roteur RENUM = '%(k1)s', or MUMPS en a
      utilis� un autre.
   -> Risque & Conseil :
      Il se peut que votre version de MUMPS n'ait pas �t� compil�e avec
      le support de ce num�roteur. Dans le doute, RENUM='AUTO' permet
      de laisser MUMPS faire le meilleur choix.
 """),

52: _(u"""
  -> Vous avez demand� une analyse de stabilit� et vous utilisez le solveur lin�aire '%(k1)s'.
     Ces deux fonctionnalit�s ne sont pas compatibles.

  -> Conseil :
     Changez de solveur lin�aire en utilisant le mot-cl� METHODE de SOLVEUR.
"""),

53: _(u"""
Solveur MUMPS :
  MUMPS manque de m�moire lors de la factorisation de la matrice.
Solution :
  Il faut augmenter la valeur du mot cl�  SOLVEUR/PCENT_PIVOT.
Remarque : on a le droit de d�passer la valeur 100.
"""),

54: _(u"""
Solveur MUMPS :
  Le solveur MUMPS manque de m�moire lors de la factorisation de la matrice.

Solution :
  Il faut augmenter la m�moire accessible � MUMPS (et autres programmes hors fortran de Code_Aster).
  Pour cela, il faut diminuer la m�moire donn�e � JEVEUX (ASTK : case "dont Aster (Mo)") ou bien
  augmenter la m�moire totale (ASTK : case "M�moire totale (Mo))".
"""),

55: _(u"""
Solveur MUMPS :
  Probl�me ou alarme dans le solveur MUMPS.
  Le code retour de MUMPS (INFOG(1)) est : %(i1)d
Solution :
  Consulter le manuel d'utilisation de MUMPS.
  Pr�venir l'�quipe de d�veloppement de Code_Aster.
"""),

56: _(u"""
Solveur MUMPS :
  Il ne faut pas utiliser TYPE_RESOL = '%(k1)s'
  Pour une matrice non-sym�trique.
Solution :
  Il faut utiliser TYPE_RESOL = 'NONSYM' (ou 'AUTO').
"""),

57: _(u"""
Solveur MUMPS :
  La solution du syst�me lin�aire est trop impr�cise :
  Erreur calcul�e   : %(r1)g
  Erreur acceptable : %(r2)g   (RESI_RELA)
Solution :
  On peut augmenter la valeur du mot cl� SOLVEUR/RESI_RELA.
"""),

59: _(u"""
Solveur MUMPS :
  La matrice est d�j� factoris�e. On ne fait rien.
Solution :
  Il y a sans doute une erreur de programmation.
  Contactez l'assistance.
"""),

60: _(u"""
Solveur MUMPS :
  Limite atteinte : le solveur MUMPS est utilis� par plus de 5 matrices simultan�ment.
Solution :
  Contactez l'assistance.
"""),

61: _(u"""
Erreur Programmeur lors de la r�solution d'un syst�me lin�aire :
 La num�rotation des inconnues est incoh�rente entre la matrice et le second membre.
 Matrice       : %(k1)s
 Second membre : %(k2)s

 Si solveur : 'FETI' : num�ro du sous-domaine (ou domaine global) : %(i1)d
"""),

62: _(u"""
Alarme Solveur MUMPS :
  La proc�dure de raffinement it�ratif aurait besoin de plus que les %(i1)d d'it�rations
  impos�es en dur dans l'appel MUMPS par Code_Aster.
Solution :
  On peut essayer la valeur du mot-cl� POSTTRAITEMENTS='FORCE'.
"""),

64: _(u"""
Solveur MUMPS :
  Le solveur MUMPS manque de m�moire lors de la phase d'analyse de la matrice.

Solution :
  Il faut augmenter la m�moire accessible � MUMPS (et autres programmes hors fortran de Code_Aster).
  Pour cela, il faut diminuer la m�moire donn�e � JEVEUX (ASTK : case "dont Aster (Mo)") ou bien
  augmenter la m�moire totale (ASTK : case "M�moire totale (Mo))".
"""),

65: _(u"""
Solveur MUMPS :
  MUMPS ne peut pas factoriser la matrice � cause d'un d�passement d'entiers.

Solution :
  Si vous utilisez la version s�quentielle, alors il vous faut passer � la version parall�le.
  Si vous utilisez d�j� la version parall�le, alors il faut augmenter le nombre de processeurs
  allou�s au calcul.
"""),

66: _(u"""
Solveur MUMPS :
  �chec de la factorisation OUT-OF-CORE de MUMPS.
  Consulter les  messages d�livr�s  par MUMPS.
Conseil: Augmenter  le nombre de processeurs utilis�s.
"""),

67: _(u"""
Erreur d'utilisation (commande RESOUDRE) :
  La matrice et le second membre fournis � la commande RESOUDRE
  ne sont pas de m�me dimension (nombre de ddls).
Conseil: V�rifier la coh�rence des arguments MATR et CHAM_NO.
"""),

68: _(u"""
Erreur d'utilisation (commande RESOUDRE) :
  La matrice et le second membre fournis � la commande RESOUDRE
  ne sont pas du m�me type (r�el/complexe).
Conseil: V�rifier la coh�rence des arguments MATR et CHAM_NO.
"""),

70: _(u"""
Solveur MUMPS :
  Vous avez activ� l'option IMPR='OUI_SOLVE' en surchargeant AMUMPS.F. La r�solution
  du syst�me lin�aire en cours va donc s'effectuer normalement mais en plus
  sa matrice et son second membre vont �tre �crits dans le fichier d'unit� logique
  %(i1)d. Vous pouvez le r�cup�rer (sur le processeur 0) via ASTK.
"""),

71: _(u"""
Solveur MUMPS :
  Vous avez activ� l'option IMPR='OUI_NOSOLVE' en surchargeant AMUMPS.F. La r�solution
  du syst�me lin�aire en cours ne va donc pas s'effectuer mais sa matrice et
  son second membre vont �tre �crits dans le fichier d'unit� logique %(i1)d.
  Apr�s cette �criture, l'ex�cution Aster s'arr�te en ERREUR_FATALE pour vous
  permettre de r�cup�rer plus rapidement votre fichier.
  Vous pouvez le r�cup�rer (sur le processeur 0) via ASTK.
"""),

72: _(u"""
Solveur MUMPS :
  Vous utilisez une version de MUMPS ant�rieure � la 4.7.3: la %(k1)s.
  Celle-ci n'est plus support�e pour le couplage Code_Aster/MUMPS.
Solution:
  T�l�charger et installer une version de MUMPS plus r�cente.
"""),

73: _(u"""
Solveur MUMPS :
  Lors de la factorisation num�rique, le pourcentage de pivots, %(r1).0f %%, a d�pass� le
  pourcentage pr�vu par le param�tre SOLVEUR/PCENT_PIVOT= %(r2).0f %%.
  Cela peut engendrer un r�sultat de mauvaise qualit�. V�rifiez bien la qualit� de celui-ci
  en fin de r�solution via la mot-cl� RESI_RELA.
Solution:
  Pour am�liorer la qualit� de la solution vous pouvez activez les options de pr� et
  post-traitements (PRETRAITEMENTS='AUTO' et POSTTRAITEMENTS='FORCE' ou 'AUTO'), durcir le crit�re
  de qualit� RESI_RELA ou, si vous avez beaucoup de Lagrange (>10%% de la taille du probl�me),
  d�sactivez l'option ELIM_LAGR2 (ELIM_LAGR2='NON').
  Sinon, contactez l'�quipe de d�veloppement.
"""),

74: _(u"""
Solveur MUMPS :
  Vous utilisez une version de MUMPS ant�rieure � la 4.8.4: la %(k1)s.
  Celle-ci ne permet pas la d�tection de singularit�. On d�sactive cette fonctionnalit� avec
  une valeur SOLVEUR/NPREC n�gative.
Attention:
  Cette d�sactivation peut nuire � certains type de calculs (modal, option CRIT_FLAMB...).
"""),




80: _(u"""
(solveur lin�aire MUMPS) Probl�me de param�trage du solveur !

  Attention, vous avez param�tr� le solveur lin�aire MUMPS de mani�re a r�soudre un syst�me
  lin�aire SPD (r�el Sym�trique D�fini Positif): mot-cl� SOLVEUR/TYPE_RESOL='SYMDEF'. Or votre
  matrice est a valeur complexe. Ceci est contradictoire.

    -> Conseil & Risque :
      Utilisez le solveur lin�aire MUMPS avec TYPE_RESOL='AUTO'.
"""),



84: _(u"""
(solveur lin�aire MUMPS) Probl�me de param�trage du solveur !

Attention, vous avez param�tre le solveur lin�aire MUMPS de mani�re a r�soudre un syst�me
lin�aire SPD (r�el Sym�trique D�fini Positif): mot-cl� SOLVEUR/TYPE_RESOL='SYMDEF'. Or votre
matrice comporte des termes n�gatifs ou nuls sur sa diagonale. Ceci est contradictoire.

    -> Conseil & Risque :
      Si il s'agit d'un test vous voila averti, sinon utilisez le solveur lin�aire MUMPS
      avec TYPE_RESOL='AUTO'.
"""),
}
