#@ MODIF elements5 Messages  DATE 12/03/2007   AUTEUR LAVERNE J.LAVERNE 
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
 la contrainte equivalente est nulle pour la maille  %(k1)s 
"""),

2: _("""
 tuyau : le nombre de couches est limite a  %(i1)d 
"""),

3: _("""
 tuyau : le nombre de secteurs est limite a  %(i1)d 
"""),

4: _("""
 tuyau : le nombre de couches est limite a  %(i1)d 
"""),

5: _("""
 tuyau : le nombre de secteurs est limite a  %(i1)d 
"""),

6: _("""
 tuyau : le nombre de couches est limite a  %(i1)d 
"""),

7: _("""
 tuyau : le nombre de secteurs est limite a  %(i1)d 
"""),

8: _("""
 Vous voulez utiliser l'indicateur de convergence RESI_REFE_RELA mais vous n'avez pas
 renseign� le mot-cl� %(k1)s .
"""),

9: _("""
 Employez la mod�lisation sp�cifique aux grandes d�formations XX_INCO_GD
"""), 

10: _("""
 La mod�lisation GRAD_VARI n'est plus disponible en grandes d�formations. Pour Rousselier
 version SIMO_MIEHE, vous pouvez faire du non-local en utilisant la mod�lisation XX_INCO_GD
 et en d�finissant C_GONF<>0 sous l'op�rande NON_LOCAL de DEFI_MATERIAU
"""), 

11: _("""
 Le rayon R_SUP (ou R_SUP_FO) doit obligatoirement etre sup�rieur au rayon R_INF 
 (resp. R_INF_FO).
"""), 

12: _("""
 Le noeud %(k1)s du fond de fissure n est rattach� � aucune maille surfacique 
 de la l�vre sup�rieure : v�rifier les groupes de mailles.
"""), 

13: _("""
 Le noeud %(k1)s du fond de fissure n est rattach� � aucune maille surfacique 
 de la l�vre inf�rieure : v�rifier les groupes de mailles.
"""), 

14: _("""
 Les noeuds %(k1)s de FOND_INF et %(k2)s de FOND_SUP ne sont pas en vis � vis. 
"""), 

15: _("""
 FONFIS - occurence %(i1)s : les objets pr�c�demment �voqu�s sont inexistants
 ou de type incompatible.
"""), 

16: _("""
 FONFIS - occurence %(i1)s : les mailles sp�cifi�es ne permettent pas de d�finir 
 une ligne continue.
 Conseil (si op�rateur DEFI_FOND_FISS) : v�rifier le groupe de maille du fond de fissure.
"""), 

17: _("""
 FONFIS - Trop de noeuds dans le groupe de noeuds %(k1)s.
 --> Noeud utilis� : %(k2)s
"""), 

18: _("""
 FONFIS - Trop de mailles dans le groupe de mailles GROUP_MA_ORIG.
 --> Maille utilis�e : %(k1)s
"""), 

19: _("""
 FONFIS - Occurence %(i1)s : maille %(k1)s inexistante.
"""), 

20: _("""
 FONFIS - Occurence %(i1)s : maille %(k1)s non lin�ique.
"""), 

21: _("""
 FONFIS - Occurence %(i1)s : m�lange de SEG2 et de SEG3 (maille %(k1)s).
"""), 

22: _("""
   Erreur, le nombre de noeuds d'un element de joint 3D n'est pas correct   
"""),


23: _("""
   Erreur, le nombre de points de Gauss d'un element de joint 3D n'est pas correct   
"""),


}
