#@ MODIF fatigue1 Messages  DATE 26/11/2007   AUTEUR ANGLES J.ANGLES 
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
 Aucun �l�ment du mod�le ne sait calculer l'option
 de fatigue multiaxiale, ('PFACY_R').
 Il se peut que la mod�lisation affect�e au groupe de mailles
 sur lequel vous faites un calcul de fatigue ne soit pas "3D".

 Le crit�re de fatigue que vous utilisez n'est utilisable qu'en 3D.

"""),

2: _("""
 La mod�lisation affect�e au groupe de mailles sur lequel vous
 faites un calcul de fatigue n'est problament pas "3D".
 La composante %(i1)d du tenseur des contraintes n'existe pas.

 Le crit�re de fatigue que vous utilisez n'est utilisable qu'en 3D.

"""),

3: _("""
 La mod�lisation affect�e au groupe de mailles sur lequel vous
 faites un calcul de fatigue n'est problament pas "3D".
 La composante %(i1)d du tenseur des d�formations n'existe pas.

 Le crit�re de fatigue que vous utilisez n'est utilisable qu'en 3D.

"""),

4: _("""
 le coefficient de Goodman n'est pas calculable
"""),

5: _("""
 le coefficient de Gerber n'est pas calculable
"""),

6: _("""
 pour calculer le dommage de Lemaitre-Sermage,
 il faut d�finir le comportement DOMMA_LEMAITRE dans DEFI_MATERIAU
"""),

7: _("""
 pour calculer le dommage de Lemaitre_Sermage,
 il faut d�finir le comportement ELAS_FO dans DEFI_MATERIAU
"""),

8: _("""
 le mat�riau est obligatoire pour le calcul du dommage par TAHERI_MANSON
"""),

9: _("""
 une fonction doit �tre introduite sous le mot cl� TAHERI_FONC
"""),

10: _("""
 une nappe doit �tre introduite sous le mot cl� TAHERI_NAPPE
"""),

11: _("""
 la courbe de MANSON_COFFIN est n�cessaire pour le calcul du dommage TAHERI_MANSON_COFFIN
"""),

12: _("""
 le mat�riau est obligatoire pour le calcul du dommage par TAHERI_MIXTE
"""),

13: _("""
 la courbe de MANSON_COFFIN est n�cessaire pour le calcul du dommage TAHERI_MIXTE
"""),

14: _("""
 la courbe de WOHLER est n�cessaire pour le calcul du dommage TAHERI_MIXTE
"""),

15: _("""
 m�thode de comptage inconnue
"""),

16: _("""
 nombre de cycles nul
"""),

17: _("""
 l'utilisation de MANSON_COFFIN est r�serv� � des histoires de chargements en d�formations
"""),

18: _("""
 la courbe de MANSON_COFFIN doit �tre donn�e dans DEFI_MATERIAU
"""),

19: _("""
 les lois de TAHERI sont r�serv�es pour des chargements en d�formations
"""),

20: _("""
 loi de dommage non compatible
"""),

21: _("""
 l'histoire de chargement doit avoir m�me discr�tisation pour toutes les composantes
"""),

22: _("""
 l'histoire de la d�formation plastique cumul�e doit avoir m�me discr�tisation que l'histoire des contraintes
"""),

23: _("""
 l'histoire de la temp�rature doit avoir m�me discr�tisation que l'histoire des contraintes
"""),

24: _("""
 pour calculer le dommage, il faut d�finir le comportement "FATIGUE" dans DEFI_MATERIAU
"""),

25: _("""
 la m�thode 'TAHERI_MANSON' ne peut pas etre utilis�e avec l'option %(k1)s
"""),

26: _("""
 le nom de la fonction  nappe DSIGM(DEPSI,DEPSIMAX)
 doit �tre pr�sent sous le mot cle 'TAHERI_NAPPE'
"""),

27: _("""
 le nom de la fonction DSIGM(DEPSI)
 doit �tre pr�sent sous le mot cle 'TAHERI_FONC'
"""),

28: _("""
 la m�thode 'TAHERI_MIXTE' ne peut pas �tre utilis�e avec l'option %(k1)s
"""),

29: _("""
 la methode 'WOHLER' ne peut pas �tre utilis�e avec l'option %(k1)s 
"""),

30: _("""
 une courbe de WOHLER doit �tre d�finie dans DEFI_MATERIAU
"""),

31: _("""
 la methode 'MANSON_COFFIN' ne peut pas �tre utilis�e avec l'option %(k1)s 
"""),

32: _("""
 une courbe de MANSON_COFFIN doit �tre d�finie dans DEFI_MATERIAU
"""),

33: _("""
 les mailles attach�es au noeud trait� ne sont pas affect�es du m�me mat�riau.
"""),

34: _("""
 la donn�e d'une courbe de WOHLER est obligatoire
"""),

35: _("""
 la donn�e du moment spectral d'ordre 4 est obligatoire pour le comptage des pics de contraintes
"""),

36: _("""
 la valeur du moment spectral d'ordre 0 (lambda_0) est certainement nulle
"""),

37: _("""
 la valeur du moment spectral d'ordre 2 (lambda_2) est nulle
"""),

38: _("""
 la valeur du moment spectral d'ordre 4 (lambda_4) est nulle
"""),

63: _("""
 pour calculer le dommage max,
 il faut renseigner CISA_PLAN_CRIT dans la commande DEFI_MATERIAU
"""),

64: _("""
 nous ne pouvons pas r�cup�rer la valeur du param�tre A du crit�re de MATAKE
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

65: _("""
 nous ne pouvons pas r�cup�rer la valeur du param�tre B du crit�re de MATAKE
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

66: _("""
 nous ne pouvons pas r�cup�rer la valeur du coefficient de passage flexion-torsion
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

67: _("""
 nous ne pouvons pas r�cup�rer la valeur du param�tre A du crit�re de DANG_VAN_MODI_AC
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

68: _("""
 nous ne pouvons  pas r�cup�rer la valeur du param�tre B du crit�re de DANG_VAN_MODI_AC
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

69: _("""
 nous ne pouvons  pas r�cup�rer la valeur du coefficient de passage cisaillement-traction
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

70: _("""
 nous ne pouvons pas r�cup�rer la valeur du param�tre A du crit�re DOMM_MAXI
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

71: _("""
 nous ne pouvons pas r�cup�rer la valeur du param�tre B du crit�re DOMM_MAXI
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

72: _("""
 nous ne pouvons pas r�cup�rer la valeur du coefficient de passage cisaillement-traction
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

73: _("""
 nous ne pouvons pas r�cup�rer la valeur du param�tre A du crit�re DANG_VAN_MODI_AV
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

74: _("""
 nous ne pouvons pas r�cup�rer la valeur du param�tre B du crit�re DANG_VAN_MODI_AV
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

75: _("""
 nous ne pouvons pas r�cup�rer la valeur du param�tre A du crit�re FATEMI_SOCIE
 commande: DEFI_MATERIAU
 op�rande: CISA_PLAN_CRIT
"""),

76: _("""
 Le nombre d'instants calcul�s est �gal � %(i1)d.

 Il faut que l'histoire du chargement comporte au moins 2 instants
 pour calculer un dommage.

"""),

77: _("""
 Le nombre de cycles extraits est �gal � %(i1)d.

 Votre chargement est constant.
 On ne peut donc pas extraire de cycles.

"""),

}
