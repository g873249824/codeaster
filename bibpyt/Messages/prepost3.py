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

cata_msg = {

4 : _(u"""
  le nombre de noeuds s�lectionn�s est sup�rieur au nombre de noeuds du maillage. on va tronquer la liste.
"""),

5 : _(u"""
 cha�ne de caract�res trop longues : imprimer moins de champs
"""),

6 : _(u"""
 type inconnu" %(k1)s "
"""),



9 : _(u"""
 type de base inconnu:  %(k1)s 
"""),

10 : _(u"""
 soit le fichier n'existe pas, soit c'est une mauvaise version de HDF (utilise par MED).
"""),


31 : _(u"""
 on n'a pas trouv� le num�ro d'ordre � l'adresse indiqu�e
"""),

32 : _(u"""
 on n'a pas trouv� l'instant � l'adresse indiqu�e
"""),

33 : _(u"""
 on n'a pas trouv� la fr�quence � l'adresse indiqu�e
"""),

34 : _(u"""
 on n'a pas trouv� dans le fichier UNV le type de champ
"""),

35 : _(u"""
 on n'a pas trouv� dans le fichier UNV le nombre de composantes � lire
"""),

36 : _(u"""
 on n'a pas trouv� dans le fichier UNV la nature du champ
 (r�el ou complexe)
"""),

37 : _(u"""
 le type de champ demand� est diff�rent du type de champ � lire
"""),

38 : _(u"""
 le champ demande n'est pas de m�me nature que le champ � lire
 (r�el/complexe)
"""),

39 : _(u"""
 le mot cl� MODELE est obligatoire pour un CHAM_ELEM
"""),

40 : _(u"""
 Probl�me correspondance noeud IDEAS
"""),

41 : _(u"""
 le champ de type ELGA n'est pas support�
"""),

63 : _(u"""
 on attend 10 ou 12 secteurs
"""),

64 : _(u"""
 ******* percement tube *******
"""),

65 : _(u"""
 pour la variable d'acc�s "NOEUD_CMP", il faut un nombre pair de valeurs.
"""),

66 : _(u"""
 le mod�le et le maillage introduits ne sont pas coh�rents
"""),

67 : _(u"""
 il faut donner le maillage pour une impression au format "CASTEM".
"""),

68 : _(u"""
 vous voulez imprimer sur un m�me fichier le maillage et un champ
 ce qui est incompatible avec le format GMSH
"""),

69 : _(u"""
 L'impression d'un champ complexe n�cessite l'utilisation du mot-cl� PARTIE.
 Ce mot-cl� permet de choisir la partie du champ � imprimer (r�elle ou imaginaire).
"""),

70 : _(u"""
 Vous avez demand� une impression au format ASTER sans pr�ciser de MAILLAGE.
 Aucune impression ne sera r�alis�e car IMPR_RESU au format ASTER n'imprime qu'un MAILLAGE.
"""),

73 : _(u"""
 l'impression avec s�lection sur des entit�s topologiques n'a pas de sens au format CASTEM  : toutes les valeurs sur tout le maillage seront donc imprim�es.
"""),

74 : _(u"""
 Le maillage %(k1)s n'est pas coh�rent avec le maillage %(k2)s portant le r�sultat %(k3)s
"""),

75 : _(u"""
 fichier GIBI cr�� par SORT FORMAT non support� dans cette version
"""),

76 : _(u"""
 version de GIBI non support�e, la lecture peut �chouer
"""),

77 : _(u"""
 fichier GIBI erron�
"""),

78 : _(u"""
 le fichier maillage GIBI est vide
"""),

81 : _(u"""
 lmat =0
"""),

84 : _(u"""
 il faut autant de composantes en i et j
"""),

85 : _(u"""
 il faut autant de composantes que de noeuds
"""),

93 : _(u"""
 la fonction n'existe pas.
"""),

94 : _(u"""
 il faut d�finir deux param�tres pour une nappe.
"""),

95 : _(u"""
 pour le param�tre donn� on n'a pas trouv� la fonction.
"""),


}
