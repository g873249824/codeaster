#@ MODIF mecanonline2 Messages  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
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
# RESPONSABLE DELMAS J.DELMAS

def _(x) : return x

cata_msg = {

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
 Lecture du champ DEPL_CALCULE impossible.
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
  -> Le chargement ext�rieur est nul (� la pr�cision pr�s).
     Or vous avez demand� une convergence avec le crit�re relatif (RESI_GLOB_RELA). 
     Pour �viter une division par z�ro, le code est pass� automatiquement en mode de convergence
     de type absolu (RESI_GLOB_MAXI)
  -> Risque & Conseil : V�rifier bien que votre chargement doit etre nul � cet instant 
     Dans le cas des probl�mes de type THM, penser � utiliser �ventuellement un 
     crit�re de type r�f�rence (RESI_REFE_RELA).
     La valeur automatique prise pour RESI_GLOB_MAXI est �gale � 1E-6 fois la derni�re valeur
     de r�sidu maximum � l'instant pr�c�dent. 
"""),

}
