#@ MODIF mecanonline2 Messages  DATE 22/08/2011   AUTEUR ABBAS M.ABBAS 
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

def _(x) : return x

cata_msg = {

1 : _("""
 L'erreur pr�c�dente est fatale.
 Conseils:
   - S'il s'agit d'un manque de temps CPU, augmentez-le.
   - V�rifiez votre mod�le 
   - Essayez d'activer la gestion des �v�nements (d�coupe du pas de temps par exemple) dans la commande DEFI_LIST_INST.
 
 La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
"""),

3 : _("""

 Le r�sidu global converge plus vite que la condition des contraintes planes. 
 La convergence de la condition des contraintes planes peut �tre am�lior�e en 
 augmentant ITER_MAXI_DEBORST (=1 par d�faut), sous le mot clef facteur COMP_INCR. 

"""),

4 : _("""
 La charge definie dans STAT_NON_LINE en tant que une charge de type suiveuse, 
 sous le mot-cl� TYPE_CHARGE = 'SUIV' n'est pas une Charge SUIVEUSE.
"""),

27 : _("""
 La pr�diction par DEPL_CALCULE � l'instant de calcul %(r1)f � partir du concept %(k1)s n'a pas pu �tre construite.
 Explications possibles :
  - le concept ne contient pas de champs de d�placement
  - l'instant de calcul demand� est en dehors de l'intervalle des instants calcul�s dans le concept fourni (il n'y a pas de prolongement � gauche ni � droite)
  
 Conseil :
 - v�rifiez que le concept fourni sous le mot-cl� EVOL_NOLI contient suffisamment d'instants pour interpoler le champ souhait�
"""),

36 : _("""
 Erreur dans la d�coupe initiale des pas.
"""),

37 : _("""
 Attention, ARRET=NON donc poursuite du calcul sans avoir eu convergence.
"""),

67 : _("""
 Le code %(i1)d retourn� lors de l'int�gration de la loi de comportement n'est pas trait�.  
"""),

93 : _("""
  -> Risque & Conseil :  dans le cas d'une r�solution incr�mentale, 
     on ne consid�re que la variation des variables de commande entre
     l'instant pr�c�dent et l'instant actuel.
     On  ne prend donc pas en compte d'�ventuelles contraintes incompatibles
     dues � ces variables de commande initiales. 
     Pour tenir compte de ces contraintes vous pouvez :
     - partir d'un instant fictif ant�rieur o� toutes les variables de 
       commande sont nulles ou �gales aux valeurs de r�f�rence
     - choisir des valeurs de r�f�rence adapt�es
     Pour plus d'informations, voir la documentation de STAT_NON_LINE 
     (U4.51.03) mot-cl� EXCIT, et le test FORMA09 (V7.20.101).
"""),

94 : _("""
  -> Indications suppl�mentaires : pour la variable de commande :  %(k1)s
     et la composante :  %(k2)s
     Valeur maximum : %(r1)f sur la maille : %(k3)s
     Valeur minimum : %(r2)f sur la maille : %(k4)s
"""),

95 : _("""
  -> Indications suppl�mentaires : pour la variable de commande :  %(k1)s 
     et la composante :  %(k2)s
     Valeur maximum de abs( %(k2)s - %(k5)s_REF) : %(r1)f sur la maille : %(k3)s
     Valeur minimum de abs( %(k2)s - %(k5)s_REF) : %(r2)f sur la maille : %(k4)s
"""),



97 : _("""
  -> Les variables de commandes initiales induisent des contraintes 
     incompatibles : 
     l'�tat initial (avant le premier instant de calcul) est tel que 
     les variables de commande (temp�rature, hydratation, s�chage...)
     conduisent � des contraintes non �quilibr�es. 
"""),

98 : _("""
  -> Les forces ext�rieures (chargement impos� et r�actions d'appui) sont d�tect�es comme quasiment nulles (%(r1)g).
     Or vous avez demand� une convergence avec le crit�re relatif (RESI_GLOB_RELA). 
     Pour �viter une division par z�ro, le code est pass� automatiquement en mode de convergence
     de type absolu (RESI_GLOB_MAXI).
     On a choisi un RESI_GLOB_MAXI de mani�re automatique et de valeur %(r2)g.
  -> Risque & Conseil : V�rifier bien que votre chargement doit etre nul (ainsi que les r�actions d'appui) � cet instant 
     Dans le cas des probl�mes de type THM, penser � utiliser �ventuellement un 
     crit�re de type r�f�rence (RESI_REFE_RELA).
"""),

}
