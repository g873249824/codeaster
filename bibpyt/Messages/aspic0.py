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

cata_msg={
1: _(u"""
Vous affectez plus d'un mat�riau contenant l'option RCCM.
"""),

2: _(u"""
Pour les piquages sains, TUBULURE doit �tre renseign�.
"""),

3: _(u"""
EQUILIBRE[NOEUD] : on attend P1_CORP ou P2_CORP.
"""),

4: _(u"""
Il faut pr�ciser un noeud pour EFFE_FOND.
"""),

5: _(u"""
PRES_REP[NOEUD] : on attend P1_CORP ou P2_CORP.
"""),

6: _(u"""
On ne peut appliquer un EFFE_FOND sur PRES_REP[NOEUD] car ce noeud est bloqu�"
"""),

7: _(u"""
TORS_CORP[NOEUD] : on attend P1_CORP ou P2_CORP.
"""),

8: _(u"""
On ne peut appliquer un torseur sur TORS_CORP[NOEUD] car ce noeud est bloqu�.
"""),

9: _(u"""
Si TYPE_MAILLAGE sain : m�canique de la rupture impossible.
"""),

10: _(u"""
Mot-clef <BORNES> obligatoire avec cette option.
"""),

11: _(u"""
Impression de r�sultats demand�e sans pr�ciser le nom des champs cf. la documentation utilisateur : U4.PC.20.
"""),

12: _(u"""
Les piquages p�n�trants sont autoris�s uniquement avec les soudures de type 1.
"""),

13: _(u"""
 La valeur de Z_MAX (cote maximale de la tubulure) est inf�rieure � la longueur 
 d'amortissement calcul�e :
 Z_MAX fournie   : %(r1)f
 Z_MAX calcul�e  : %(r2)f
-> Risque et Conseil :
 La longueur d'amortissement est li�e � l'onde de flexion se propageant depuis le piquage.
 Si la longueur de la tubulure est inf�rieure � cette longueur, le calcul des contraintes 
 dans le piquage ne sera pas ind�pendant du mode d'application des conditions aux limites.
"""),

14: _(u"""
 Erreur donn�es
 Dans le cas de fissures inclin�es d�bouchant en peau interne avec
 piquage p�n�trant, le jeu doit �tre nul.
"""),

15: _(u"""
 Erreur donn�es
 Dans le cas de fissures internes (NON_DEB) le ligament inf�rieur est obligatoire.
"""),

16: _(u"""
Dans le cas de fissures internes (NON_DEB) le ligament est trop petit.
"""),

17: _(u"""
Dans le cas de fissures internes (NON_DEB) le ligament est trop grand.
"""),

18: _(u"""
Dans le cas de fissures courte il faut pr�ciser la longueur.
"""),

19: _(u"""
Dans le cas de la fissure longue il faut pr�ciser la longueur ou axis=oui.
"""),

20: _(u"""
Fissure axisym�trique : le mot clef <LONGUEUR> ne doit pas �tre renseign�.
"""),

21: _(u"""
Seuls GIBI98 et GIBI2000 sont appelables.
"""),

22: _(u"""
Une interp�n�tration des l�vres est d�tect�e pour le num�ro d'ordre %(i1)d : sur les
%(i2)d noeuds de chaque l�vre, %(i3)d noeuds s'interp�n�trent.
-> Risque et Conseil :
Le contact n'est pas pris en compte dans le calcul. Le taux de restitution de l'�nergie G
est donc positif y compris l� o� la fissure tend � se refermer, ce qui peut conduire �
des r�sultats trop p�nalisants.
Pour prendre en compte le contact entre les l�vres, il faut lancer le calcul hors macro-commande.
"""),

23: _(u"""
 La valeur de X_MAX (cote maximale du corps) est inf�rieure � la longueur d'amortissement 
 calcul�e :
 X_MAX fournie   : %(r1)f
 X_MAX calcul�e  : %(r2)f
-> Risque et Conseil :
 La longueur d'amortissement est li�e � l'onde de flexion se propageant depuis le piquage.
 Si la longueur du corps est inf�rieure � cette longueur, le calcul des contraintes 
 dans le piquage ne sera pas ind�pendant du mode d'application des conditions aux limites.
"""),

}
