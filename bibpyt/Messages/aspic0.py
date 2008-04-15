#@ MODIF aspic0 Messages  DATE 14/04/2008   AUTEUR GALENNE E.GALENNE 
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
Vous affectez plus d'un materiau contenant l'option rccm.
"""),

2: _("""
Pour les piquages sains, TUBULURE doit etre renseign�.
"""),

3: _("""
EQUILIBRE[NOEUD] : on attend P1_CORP ou P2_CORP.
"""),

4: _("""
Il faut pr�ciser un noeud pour EFFE_FOND.
"""),

5: _("""
PRES_REP[NOEUD] : on attend P1_CORP ou P2_CORP.
"""),

6: _("""
On ne peut appliquer un EFFE_FOND sur PRES_REP[NOEUD] car ce noeud est bloqu�"
"""),

7: _("""
TORS_CORP[NOEUD] : on attend P1_CORP ou P2_CORP.
"""),

8: _("""
On ne peut appliquer un torseur sur TORS_CORP[NOEUD] car ce noeud est bloqu�.
"""),

9: _("""
Si TYPE_MAILLAGE sain : m�canique de la rupture impossible.
"""),

10: _("""
Mot-clef <BORNES> obligatoire avec cette option.
"""),

11: _("""
Impression de r�sultats demand�e sans pr�ciser le nom des champs cf. la documentation utilisateur : U4.PC.20.
"""),

12: _("""
Les piquages p�netrants sont autoris�s uniquement avec les soudures de type 1.
"""),

13: _("""
 La valeur de Z_MAX (cote maximale de la tubulure) est inf�rieure � la longueur 
 d'amortissement calcul�e :
 Z_MAX fournie   : %(r1)f
 Z_MAX calculee  : %(r2)f
-> Risque et Conseil :
 La longueur d'amortissement est li�e � l'onde de flexion se propageant depuis le piquage.
 Si la longueur de la tubulure est inf�rieure � cette longueur, le calcul des contraintes 
 dans le piquage ne sera pas ind�pendant du mode d'application des conditions aux limites.
"""),

14: _("""
 Erreur donnees
 Dans le cas de fissures inclinees debouchant en peau interne avec
 piquage penetrant, le jeu doit etre nul.
"""),

15: _("""
 Erreur donnees
 Dans le cas de fissures internes (NON_DEB) le ligament inf�rieur est obligatoire.
"""),

16: _("""
Dans le cas de fissures internes (NON_DEB) le ligament est trop petit.
"""),

17: _("""
Dans le cas de fissures internes (NON_DEB) le ligament est trop grand.
"""),

18: _("""
Dans le cas de fissures courte il faut pr�ciser la longueur.
"""),

19: _("""
Dans le cas de la fissure longue il faut pr�ciser la longueur ou axis=oui.
"""),

20: _("""
Fissure axisymetrique : le mot clef <LONGUEUR> ne doit pas etre renseign�.
"""),

21: _("""
Seuls gibi98 et gibi2000 sont appelables.
"""),

22: _("""
Une interp�n�tration des l�vres est d�tect�e pour le num�ro d'ordre %(i1)d : sur les
%(i2)d noeuds de chaque l�vre, %(i3)d noeuds s'interp�n�trent.
-> Risque et Conseil :
Le contact n'est pas pris en compte dans le calcul. Le taux de restitution de l'�nergie G
est donc positif y compris l� o� la fissure tend � se refermer, ce qui peut conduire �
des r�sultats trop p�nalisants.
Pour prendre en compte le contact entre les l�vres, il faut lancer le calcul hors macro.
"""),

23: _("""
 La valeur de X_MAX (cote maximale du corps) est inf�rieure � la longueur d'amortissement 
 calcul�e :
 X_MAX fournie   : %(r1)f
 X_MAX calculee  : %(r2)f
-> Risque et Conseil :
 La longueur d'amortissement est li�e � l'onde de flexion se propageant depuis le piquage.
 Si la longueur ddu corps est inf�rieure � cette longueur, le calcul des contraintes 
 dans le piquage ne sera pas ind�pendant du mode d'application des conditions aux limites.
"""),

}
