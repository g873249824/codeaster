#@ MODIF algorith17 Messages  DATE 24/10/2011   AUTEUR PELLET J.PELLET 
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

cata_msg={
1: _(u"""
 Il y a moins de sous-domaines (%(i1)d) que de processeurs participant au calcul (%(i2)d).
 
 Conseils :
   - augmentez le nombre de sous-domaines de la partition du mot-cl� PARTITION
   - diminuez le nombre de processeurs du calcul
"""),

2: _(u"""
         Comportement %(k1)s non implant� pour l'�l�ment d'interface
"""),

4: _(u"""
        La formulation n'est ni en contrainte nette ni en bishop  
"""), 
5 : _(u"""
  Le champ posttrait� est un cham_elem, le calcul de moyenne ne fonctionne que
 sur les cham_no. Pour les cham_elem utiliser POST_ELEM mot-cl� INTEGRALE.
"""), 
6 : _(u"""
  Le calcul de la racine numero %(i1)d par la m�thode de la matrice compagnon a �chou�.
"""), 
7 : _(u"""
  Il n'y a qu'un seul mode_meca en entree de DEFI_BASE_MODALE. La numerotation
  de reference prise est celle associee a celui-ci. Le mot-cle NUME_REF
  n'est pas pris en compte
"""), 
8 : _(u"""
  Il manque le nume_ddl pour le resultat. Le mot-cle NUME_REF doit etre
  renseigne.
"""), 
9 : _(u"""L'�quation d'�volution de l'endommagement n'admet pas de solution r�elle  """),
10 : _(u"""
  La loi de comportement m�canique %(k1)s n'est pas compatible avec les 
  �l�ments de joint avec couplage hydro-m�canique.
"""),
11 : _(u"""
  La fermeture du joint sort des bornes [0,fermeture maximale] sur la maille %(k1)s.
  fermeture du joint CLO = %(r1)f
  fermeture maximale UMC = %(r2)f
  V�rifier la coh�rence chargement m�canique, fermeture asymptotique et ouverture 
  initiale.
"""),
12 : _(u"""
  La temp�rature de r�f�rence (exprim�e en Kelvin) doit toujours �tre strictement sup�rieure � z�ro.
"""),
13 : _(u"""
  La pression de gaz de r�f�rence doit toujours �tre diff�rente de z�ro.
"""),

14 : _(u"""
  Les mots cl�s PRES_FLU et PRES_CLAV sont incompatibles avec les mod�lisations xxx_JOINT_HYME
"""),

15 : _(u"""
  Les donn�es mat�riau RHO_F, VISC_F et OUV_MIN sont obligatoires avec les mod�lisations xxx_JOINT_HYME
"""),


16 : _(u"""
  Les donn�es mat�riau RHO_F, VISC_F et OUV_MIN sont incompatibles avec les mod�lisations xxx_JOINT
"""),

17 : _(u"""
  La partition %(k1)s que vous utilisez pour partitionner le mod�le %(k2)s en sous-domaines a �t� construite sur un autre mod�le (%(k3)s).
  
  Conseil : v�rifiez la coh�rence des mod�les.
"""),

}
