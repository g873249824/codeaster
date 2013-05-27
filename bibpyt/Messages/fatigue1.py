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
# person_in_charge: josselin.delmas at edf.fr

cata_msg={
1: _(u"""
 Aucun �l�ment du mod�le ne sait calculer l'option
 de fatigue multiaxiale, ('PFACY_R').
 Il se peut que la mod�lisation affect�e au groupe de mailles
 sur lequel vous faites un calcul de fatigue ne soit pas "3D".

 Le crit�re de fatigue que vous utilisez n'est utilisable qu'en 3D.

"""),

2: _(u"""
 La mod�lisation affect�e au groupe de mailles sur lequel vous
 faites un calcul de fatigue n'est probablement pas "3D".
 La composante %(i1)d du tenseur des contraintes n'existe pas.

 Le crit�re de fatigue que vous utilisez n'est utilisable qu'en 3D.

"""),

3: _(u"""
 La mod�lisation affect�e au groupe de mailles sur lequel vous
 faites un calcul de fatigue n'est probablement pas "3D".
 La composante %(i1)d du tenseur des d�formations n'existe pas.

 Le crit�re de fatigue que vous utilisez n'est utilisable qu'en 3D.

"""),

4: _(u"""
 le coefficient de GOODMAN n'est pas calculable
"""),

5: _(u"""
 le coefficient de Gerber n'est pas calculable
"""),

6: _(u"""
 pour calculer le dommage de Lemaitre-Sermage,
 il faut d�finir le comportement DOMMA_LEMAITRE dans DEFI_MATERIAU
"""),

7: _(u"""
 pour calculer le dommage de Lemaitre-Sermage,
 il faut d�finir le comportement ELAS_FO dans DEFI_MATERIAU
"""),

8: _(u"""
 le mat�riau est obligatoire pour le calcul du dommage par TAHERI_MANSON
"""),

9: _(u"""
 une fonction doit �tre introduite sous le mot cl� TAHERI_FONC
"""),

10: _(u"""
 une nappe doit �tre introduite sous le mot cl� TAHERI_NAPPE
"""),

11: _(u"""
 la courbe de MANSON_COFFIN est n�cessaire pour le calcul du dommage TAHERI_MANSON_COFFIN
"""),

12: _(u"""
 le mat�riau est obligatoire pour le calcul du dommage par TAHERI_MIXTE
"""),

13: _(u"""
 la courbe de MANSON_COFFIN est n�cessaire pour le calcul du dommage TAHERI_MIXTE
"""),

14: _(u"""
 la courbe de WOHLER est n�cessaire pour le calcul du dommage TAHERI_MIXTE
"""),

15: _(u"""
 m�thode de comptage inconnue
"""),

16: _(u"""
 nombre de cycles nul
"""),

17: _(u"""
 l'utilisation de MANSON_COFFIN est r�serv� � des histoires de chargements en d�formations
"""),

18: _(u"""
 la courbe de MANSON_COFFIN doit �tre donn�e dans DEFI_MATERIAU
"""),

19: _(u"""
 les lois de TAHERI sont r�serv�es pour des chargements en d�formations
"""),

20: _(u"""
 loi de dommage non compatible
"""),

21: _(u"""
 l'histoire de chargement doit avoir m�me discr�tisation pour toutes les composantes
"""),

22: _(u"""
 l'histoire de la d�formation plastique cumul�e doit avoir m�me discr�tisation que l'histoire des contraintes
"""),

23: _(u"""
 l'histoire de la temp�rature doit avoir m�me discr�tisation que l'histoire des contraintes
"""),

24: _(u"""
 pour calculer le dommage, il faut d�finir le comportement "FATIGUE" dans DEFI_MATERIAU
"""),

25: _(u"""
 la m�thode 'TAHERI_MANSON' ne peut pas �tre utilis�e avec l'option %(k1)s
"""),

26: _(u"""
 le nom de la fonction  nappe DSIGM(DEPSI,DEPSIMAX)
 doit �tre pr�sent sous le mot cl� 'TAHERI_NAPPE'
"""),

27: _(u"""
 le nom de la fonction DSIGM(DEPSI)
 doit �tre pr�sent sous le mot cl� 'TAHERI_FONC'
"""),

28: _(u"""
 la m�thode 'TAHERI_MIXTE' ne peut pas �tre utilis�e avec l'option %(k1)s
"""),

29: _(u"""
 la m�thode 'WOHLER' ne peut pas �tre utilis�e avec l'option %(k1)s
"""),

30: _(u"""
 une courbe de WOHLER doit �tre d�finie dans DEFI_MATERIAU
"""),

31: _(u"""
 la m�thode 'MANSON_COFFIN' ne peut pas �tre utilis�e avec l'option %(k1)s
"""),

32: _(u"""
 une courbe de MANSON_COFFIN doit �tre d�finie dans DEFI_MATERIAU
"""),

33: _(u"""
 les mailles attach�es au noeud trait� ne sont pas affect�es du m�me mat�riau.
"""),

34: _(u"""
 la donn�e d'une courbe de WOHLER est obligatoire
"""),

35: _(u"""
 la donn�e du moment spectral d'ordre 4 est obligatoire pour le comptage des pics de contraintes
"""),

36: _(u"""
 la valeur du moment spectral d'ordre 0 (lambda_0) est certainement nulle
"""),

37: _(u"""
 la valeur du moment spectral d'ordre 2 (lambda_2) est nulle
"""),

38: _(u"""
 la valeur du moment spectral d'ordre 4 (lambda_4) est nulle
"""),

39: _(u"""
Le chargement � compter est un chargement constant. On consid�re tous les chargements comme un cycle
avec valeur_max = valeur_min = valeur du chargement, i.e., amplitude = 0.
"""),

63: _(u"""
 pour calculer le dommage max,
 il faut renseigner CISA_PLAN_CRIT dans la commande DEFI_MATERIAU
"""),

64: _(u"""
 nous ne pouvons pas r�cup�rer la valeur du param�tre A du crit�re de MATAKE
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

65: _(u"""
 nous ne pouvons pas r�cup�rer la valeur du param�tre B du crit�re de MATAKE
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

66: _(u"""
 nous ne pouvons pas r�cup�rer la valeur du coefficient de passage flexion-torsion
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

67: _(u"""
 nous ne pouvons pas r�cup�rer la valeur du param�tre A du crit�re de DANG_VAN_MODI_AC
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

68: _(u"""
 nous ne pouvons  pas r�cup�rer la valeur du param�tre B du crit�re de DANG_VAN_MODI_AC
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

69: _(u"""
 nous ne pouvons  pas r�cup�rer la valeur du coefficient de passage cisaillement-traction
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

70: _(u"""
 nous ne pouvons pas r�cup�rer la valeur du param�tre A du crit�re DOMM_MAXI
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

71: _(u"""
 nous ne pouvons pas r�cup�rer la valeur du param�tre B du crit�re DOMM_MAXI
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

72: _(u"""
 nous ne pouvons pas r�cup�rer la valeur du coefficient de passage cisaillement-traction
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

73: _(u"""
 nous ne pouvons pas r�cup�rer la valeur du param�tre A du crit�re DANG_VAN_MODI_AV
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

74: _(u"""
 nous ne pouvons pas r�cup�rer la valeur du param�tre B du crit�re DANG_VAN_MODI_AV
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

75: _(u"""
 nous ne pouvons pas r�cup�rer la valeur du param�tre A du crit�re FATEMI_SOCIE
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

76: _(u"""
 Le nombre d'instants calcul�s est �gal � %(i1)d.

 Il faut que l'histoire du chargement comporte au moins 2 instants
 pour calculer un dommage.

"""),

77: _(u"""
 Le nombre de cycles extraits est �gal � %(i1)d.

 Votre chargement est constant.
 On ne peut donc pas extraire de cycles.

"""),

78: _(u"""
 Le nombre de points � traiter n'est pas correcte.

 Soit les mailles comportent des sous-points, or ce cas n'est pas pr�vu.

 Soit le nombre total de composantes de l'option : %(k1)s a chang� et n'est plus �gal � %(i1)d.

"""),

79 : _(u"""
   *** Point  %(i1)d
   Contrainte statique        =  %(r1)f
   Contrainte dynamique       =  %(r2)f
   Amplitude maximale admissible en ce point  =  %(r3)f
"""),

80 : _(u"""
   Attention, la contrainte statique en ce point est sup�rieure � la contrainte
   � la rupture du mat�riau.
"""),

81 : _(u"""
 Calcul du dommage en %(k1)s (composante grandeur �quivalente %(k3)s)
 Points de calcul du dommage : %(k2)s
 Nombre de points de calcul : %(i1)d
 Nombre de modes consid�r�s : %(i2)d
"""),

82 : _(u"""

 Amplitude de vibration maximale admissible par la structure :  %(r1)f

"""),

83 : _(u"""
   Attention, la contrainte statique en un ou plusieurs points est sup�rieure �
   la contrainte � la rupture du mat�riau.
   Contrainte statique maximale = %(r1)f
   Contrainte � la rupture      = %(r2)f
"""),

84 : _(u"""
   Le r�sultat correspondant � la contrainte statique (mot cl�
   RESULTAT_STATIQUE) comporte %(i1)d instants.
   Le calcul en fatigue vibratoire n'est possible que si le r�sultat statique
   comporte un et un seul instant. V�rifiez les donn�es.
"""),

85 : _(u"""
   Le nombre de points de calcul est diff�rent entre la contrainte statique
   ( %(i1)d points) et la contrainte modale (%(i2)d points).
   V�rifiez la coh�rence des donn�es.
"""),

86 : _(u"""
   La longueur de la liste des coefficients modaux COEF_MODE est diff�rente
   du nombre de modes retenus pour le calcul NUME_MODE.
   V�rifiez la coh�rence des donn�es.
"""),

87 : _(u"""
 Contrainte � la rupture : %(r1)f
 Limite d'endurance : %(r2)f
"""),

88 : _(u"""
 Le param�tre %(k1)s est absent dans la d�finition du mat�riau. Le calcul est impossible.
 Risques et conseils : pour l'option FATIGUE_VIBR de CALC_FATIGUE, il est obligatoire de
 d�finir les propri�t�s mat�riaux suivantes (dans DEFI_MATERIAU) :
 - la contrainte � la rupture (op�rande SU, mot cl� facteur RCCM) ;
 - la limite d'endurance (premi�re abscisse de la courbe de fatigue d�finie dans l'op�rande
 WOHLER du mot cl� facteur FATIGUE).

"""),

89: _(u"""
 Dans la commande DEFI_MATERIAU, l'op�rande WOHLER du mot cl� facteur
 FATIGUE est incompatible avec le crit�re %(k1)s requis dans le mot
 cl� facteur CISA_PLAN_CRIT.

"""),

90: _(u"""
 Dans la commande DEFI_MATERIAU, l'op�rande MANSON_COFFIN du mot cl�
 facteur FATIGUE est incompatible avec le crit�re %(k1)s requis dans
 le mot cl� facteur CISA_PLAN_CRIT.

"""),

91: _(u"""
 Dans CALC_FATIGUE/POST_FATIGUE  pour le crit�re d'amor�age fournis par la formule, le calcul
 de la grandeur %(k1)s n'est pas disponible. Merci de fournir les noms des grandeurs
 disponibles ou contacter le d�veloppeur.
"""),

92: _(u"""
 Dans CALC_FATIGUE/POST_FATIGUE, pour le crit�re d'amor�age fournis par la formule, pour d�terminer
 le plan de dommage maximal, il n'est pas possible de projeter simultan�ment la contrainte
 et la d�formation. Les grandeurs sont incompatibles avec le crit�re requis.
"""),

93: _(u"""
 Dans CALC_FATIGUE/POST_FATIGUE, pour le crit�re d'amor�age fournis par la formule, le mot-cl�
 FORMULE_VIE est fournis par une formule le seul param�tre accept� est NBRUP,
 c'est-�-dire, N_f, car le crit�re formule est pour GRDEQ = f(N_f).
 Changez le nom et v�rifiez bien que la fonction est de type: GRDEQ = f(N_f).
"""),

94: _(u"""
 Dans CALC_FATIGUE/POST_FATIGUE, pour le crit�re d'amor�age fournis par la formule et le mot-cl�
 FORMULE_VIE est fournis par la formule, la grandeur �quivalente pour l'instant est
 plus grande que f(N_f =1 ). V�rifiez la formule de la courbe FORMULE_VIE.
"""),

95: _(u"""
 Pour le crit�re utilis�, au moins d'une histoire de la tenseur de d�formation est demand�e.
"""),

96: _(u"""
 On note que DEFORMATION ELASTIQUE  = DEFORMATION TOTALE - DEFORMATION PLASTIQUE. Si les d�formations 
 totale ou plastique ne sont pas fournies, on prendre la valeur z�ro. 
"""),


97: _(u"""
 Pour le crit�re utilis�, l'histoire de la tenseur de contrainte(SIGM_XX...) est demand�e.
"""),

98: _(u"""
 Pour le crit�re utilis�, l'histoire de la tenseur de d�formation totale (EPS_XX...)est demand�e.
"""),

99: _(u"""
 Pour le crit�re utilis�e, l'histoire de la tenseur de d�formation plastique (EPSP_XX...) est demand�e.
"""),

}
