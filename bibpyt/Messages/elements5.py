#@ MODIF elements5 Messages  DATE 20/02/2007   AUTEUR LEBOUVIER F.LEBOUVIER 

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

}
