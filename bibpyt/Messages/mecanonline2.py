#@ MODIF mecanonline2 Messages  DATE 02/07/2007   AUTEUR PROIX J-M.PROIX 
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

67: _("""
 Le code %(i1)d retourn� lors de l'int�gration de la loi de comportement n'est
 pas trait�.  
"""),

96: _("""
    -> Les surfaces en contact relatif ont boug� de plus de 5%.
       Or vous n'avez pas activ� la r�actualisation g�om�trique (REAC_GEOM) automatique ou
       vous utiliser le mode "CONTROLE"
    -> Risque & Conseil : Vos r�sultats risquent d'etre faux, les mailles ne
       seront peut-etre pas correctement appari�es et donc la condition de contact sera peut
       etre fausse.
       Si vous avez volontairement n�glig� la non-lin�arit� g�o�mtrique de contact (pour des raisons
       de performance), nous vous invitons � v�rifier visuellement qu'il n'y a effectivement
       pas interp�n�tration.
"""),

97: _("""
  -> Les variables de commandes initiales induisent des contraintes 
     incompatibles : 
     l'�tat initial (avant le premier instant de calcul) est tel que 
     les variables de commande (temp�rature, hydratation, s�chage...)
     conduisent � des contraintes non �quilibr�es. 
"""),

98: _("""
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

99: _("""
  -> Le chargement ext�rieur est nul (� la pr�cision pr�s).
     Or vous avez demand� une convergence avec le crit�re relatif (RESI_GLOB_RELA). 
  -> Risque & Conseil : V�rifier bien que votre chargement doit etre nul � cet instant 
     Le chargement est "nul" dans le cas de l'utilisation d'AFFE_CHAR_CINE en particulier.
     Il vous faut changer votre crit�re de convergence: RESI_GLOB_MAXI ou RESI_REFE_RELA
"""),

94: _("""
  -> Indications suppl�mentaires : pour la variable de commande :  %(k1)s
     et la composante :  %(k2)s
     Valeur maximum : %(r1)f sur la maille : %(k3)s
     Valeur minimum : %(r2)f sur la maille : %(k4)s
"""),
95: _("""
  -> Indications suppl�mentaires : pour la variable de commande :  %(k1)s 
     et la composante :  %(k2)s
     Valeur maximum de abs( %(k2)s - %(k5)s_REF) : %(r1)f sur la maille : %(k3)s
     Valeur minimum de abs( %(k2)s - %(k5)s_REF) : %(r2)f sur la maille : %(k4)s
"""),

93: _("""
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

}
