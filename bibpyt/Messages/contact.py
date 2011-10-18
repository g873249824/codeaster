#@ MODIF contact Messages  DATE 17/10/2011   AUTEUR ABBAS M.ABBAS 
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
# RESPONSABLE DELMAS J.DELMAS

cata_msg = {

1 : _(u"""
Contact m�thodes discr�tes.
 -> Les m�thodes de contact discr�tes supposent la sym�trie de la matrice obtenue apr�s assemblage.
    Si votre mod�lisation produit une matrice non-sym�trique, on force donc sa sym�trie pour r�soudre
    le contact.
 -> Risque & Conseil :
    Ce changement peut conduire � des difficult�s de convergence dans le processus de Newton mais en
    aucun cas il ne produit des r�sultats faux.
    
    Si la matrice de rigidit� de votre structure est sym�trique, vous pouvez ignorer ce qui pr�c�de.
    Enfin, il est possible de supprimer l'affichage de cette alarme en renseignant SYME='OUI'
    sous le mot-cl� facteur SOLVEUR.
"""),

3 : _(u"""
Contact methode GCP. Nombre d'it�rations maximal (%(i1)d) d�pass� pour le pr�conditionneur.
Vous pouvez essayer d'augmenter ITER_PRE_MAXI
"""),

4 : _(u"""
Contact methode GCP. Le param�tre RESI_ABSO doit etre obligatoirement renseign�.
"""),

7 : _(u"""
Contact methode GCP. Le pas d'avancement est negatif ; risque de comportement hasardeux de l'algorithme
"""),

8 : _(u"""
Contact m�thodes discr�tes.
 -> Il y a des �l�ments de type QUAD8 sur la surface esclave de contact. Ces �l�ments produisent des forces nodales n�gatives aux noeuds sommets.
    Afin de limiter les oscillations des forces et d'emp�cher une p�n�tration intempestive de la surface ma�tre dans la surface esclave, on
    a proc�d� � des liaisons cin�matiques (LIAISON_DDL) entre les noeuds milieux et les noeuds sommets, sur les deux surfaces (ma�tre et esclave).
 -> Risque & Conseil :
    Il est pr�f�rable d'utiliser des �l�ments de type QUAD9. Changer votre maillage ou utiliser la commande MODI_MAILLAGE.
    Ces liaisons suppl�mentaires peuvent provoquer des incompatibilit�s avec les conditions limites, ce qui se traduira par un pivot nul dans
    la matrice.
"""),

9 : _(u"""
Contact liaison glissiere. Des noeuds se d�collent plus que la valeur d'ALARME_JEU:
"""),

13 : _(u"""
La normale que vous avez pr�d�finie (VECT_* = 'FIXE') sur le noeud %(k1)s est colin�aire � la tangente � la maille.
"""),

14 : _(u"""
La normale que vous avez pr�d�finie (VECT_* = 'FIXE') sur la maille %(k1)s est colin�aire � la tangente � la maille.
"""),

15 : _(u"""
Le vecteur MAIT_FIXE ou ESCL_FIXE est nul !
"""),

16 : _(u"""
Le vecteur MAIT_VECT_Y ou ESCL_VECT_Y est nul !
"""),

60 : _(u"""
La maille %(k1)s est de type 'SEG' (poutres) en 3D. Pour ces mailles la normale ne peut pas �tre d�termin�e automatiquement.
Vous devez utilisez l'option NORMALE :
- FIXE : qui d�crit une normale constante pour la poutre
- ou VECT_Y : qui d�crit une normale par construction d'un rep�re bas� sur la tangente (voir documentation)
"""),

61 : _(u"""
Le noeud %(k1)s fait partie d'une maille de type 'SEG' (poutres) en 3D. Pour ces mailles la normale ne peut pas �tre d�termin�e automatiquement.
Vous devez utilisez l'option NORMALE :
- FIXE : qui d�crit une normale constante pour la poutre
- ou VECT_Y: qui d�crit une normale par construction d'un rep�re bas� sur la tangente (voir documentation)
"""),


84 : _(u"""
Le mod�le m�lange des mailles avec des mod�lisations de dimensions diff�rentes (2D avec 3D ou macro-�l�ments).
� ce moment du fichier de commandes, on ne peut dire si ce m�lange sera compatible avec le contact.
"""),

85 : _(u"""
L'alarme CONTACT_84 se transforme en erreur fatale !
Il ne faut pas que les surfaces de contact m�langent des mailles affect�es d'une mod�lisation plane (D_PLAN, C_PLAN ou AXI)
avec des mailles affect�es d'une mod�lisation 3D. 
"""),

88 : _(u"""
N'utilisez pas REAC_INCR=0 avec le frottement.
"""),

93 : _(u"""
Contact methode VERIF.
 -> Interp�n�trations des surfaces.
 
 -> Risque & Conseil :
    V�rifier si le niveau d'interp�n�tration des surfaces est acceptable dans
    votre probl�me.
"""),

94 : _(u"""
Contact m�thode continue. La mod�lisation COQUE_3D n'est pas encore compatible avec la formulation 'CONTINUE'.
"""),

95 : _(u"""
Contact m�thode continue. Les options RACCORD_LINE_QUAD et FOND_FISSURE sont exclusives.
"""),

96 : _(u"""
Contact m�thode continue. La prise en compte d'un contact entre une maille '%(k1)s' et une maille '%(k2)s' n'est pas pr�vu.

Conseils :
- utilisez une formulation 'DISCRETE'
- contactez votre assistance technique
"""),

97 : _(u"""
Contact m�thode continue. Pour l'option SANS_GROUP_NO et SANS_GROUP_NO_FR, l'int�gration aux noeuds est obligatoire.
"""),

98 : _(u"""
Contact m�thode continue. Pour l'option NORMALE = 'MAIT_ESCL' ou NORMALE = 'ESCL', l'int�gration aux noeuds est obligatoire.
"""),

99 : _(u"""
Contact m�thode continue. Vos surfaces de contact esclaves comportent des QUAD8 et vous avez demand� l'option NORMALE = 'MAIT_ESCL' ou NORMALE = 'ESCL'
L'int�gration aux noeuds est incompatible avec cette option.

Conseil : utilisez un autre sch�ma d'int�gration ou bien des QUAD9.

"""),

}
