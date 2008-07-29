#@ MODIF xfem2 Messages  DATE 28/07/2008   AUTEUR LAVERNE J.LAVERNE 
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

cata_msg = {

1 : _("""
     Point : %(r1)f %(r2)f
  """),

2 : _("""
  -> Seules les mod�lisations C_PLAN/D_PLAN sont disponibles pour XFEM.
  -> Risques et conseils:
     Veuillez consid�rer l'une des deux mod�lisations dans AFFE_MODELE.
"""),

4 : _("""
  -> Le type de formulation du contact (DISCRET/CONTINUE/XFEM) doit etre le meme pour
     toutes les zones de contact.
  -> Risque & Conseil:
     Veuillez revoir la mise en donn�es de AFFE_CHAR_MECA/CONTACT.
"""),

5 : _("""
  -> Le vecteur TAU1 correspondant � la premi�re direction du frottement dans
     l'�l�ment XFEM est nul. Ceci signifie que les gradients des level sets
     sont surement colin�aires en ce point.
"""),

6 : _("""
     Multifissuration interdite avec l'op�rateur PROPA_XFEM.
"""),

7 : _("""
  -> Le contact a �t� activ� dans XFEM (CONTACT_XFEM='OUI' dans MODI_MODELE_XFEM)
  -> Risque & Conseil:
     Vous devez �galement l'activer dans AFFE_CHAR_MECA/CONTACT_XFEM
"""),

8 : _("""
  -> Le mod�le %(k1)s transmis dans AFFE_CHAR_MECA/CONTACT n'est pas un mod�le
     XFEM. 
  -> Risque & Conseil:
     Veuillez utiliser la commande MODI_MODELE_XFEM pour fournir � 
     AFFE_CHAR_MECA/CONTACT un mod�le XFEM.
"""),

9 : _("""
  -> Le mod�le %(k1)s transmis dans AFFE_CHAR_MECA/CONTACT n'est pas un mod�le
     XFEM avec contact.
  -> Risque & Conseil:
     Veuillez activer CONTACT='OUI' dans MODI_MODELE_XFEM.
"""),

11 : _("""
  -> Le mod�le %(k1)s transmis dans AFFE_CHAR_MECA/CONTACT_XFEM n'est pas 
     le mod�le XFEM utilis� dans le AFFE_CHAR_MECA/CONTACT nomm� %(k2)s.
  -> Risque & Conseil:
     Risques de r�sultats faux.
"""),

12 : _("""
  -> Le mod�le %(k1)s transmis dans AFFE_CHAR_MECA/CONTACT_XFEM n'est pas un mod�le
     XFEM. 
  -> Risque & Conseil:
     Veuillez utiliser la commande MODI_MODELE_XFEM pour fournir � 
     AFFE_CHAR_MECA/CONTACT_XFEM un mod�le XFEM.
"""),

13 : _("""
     Point : %(r1)f %(r2)f %(r3)f
  """),

14 : _("""
  -> La discr�tisation du fond de fissure est grossi�re par rapport � la 
     courbure du fond de fissure.
  -> Risque & Conseil:
     - possibilit� de r�sultats faux
     - il faudrait raffiner le maillage autour du fond de fissure.
"""),

15 : _("""
  -> Point de FOND_FISS sans maille de surface rattach�e.
  -> Risque & Conseil:
     Veuillez revoir la d�finition des level sets.
"""),

16 : _("""
  -> Probl�me dans l'orientation des normales a fond_fiss.
  -> Risque & Conseil: 
     Veuillez v�rifier la continuit� des mailles de FOND_FISS
"""),

17 : _("""
  -> Segment de fond_fiss sans maille de surface rattach�e
  -> Risque & Conseil:
     Veuillez revoir la d�finition des level sets.
"""),

20 : _("""
  -> PFON_INI = POINT_ORIG
  -> Risque & Conseil :
     Veuillez d�finir deux points diff�rents pour PFON_INI et POINT_ORIG.
"""),

21 : _("""
  -> Probl�me dans l'orientation du fond de fissure : POINT_ORIG mal choisi.
  -> Risque & Conseil : 
     Veuillez red�finir POINT_ORIG.
"""),

22 : _("""
  -> Tous les points du fond de fissure sont des points de bord.
  -> Risque & Conseil : 
     Assurez-vous du bon choix des param�tres d'orientation de fissure.
"""),

23 : _("""
  -> PFON_INI semble etre un point mal choisit, on le modifie automatiquement.
"""),

24 : _("""
  -> La m�thode "UPWIND" est en cours d'impl�mentation.
  -> Risque & Conseil :
     Veuillez choisir une autre m�thode.
"""),

25 : _("""
  -> La norme du vecteur VECT_ORIE est nulle.
  -> Risque & Conseil :
     Veuillez red�finir VECT_ORIE.
"""),


39 : _("""
  -> Deux points du fond de fissure sont tr�s proches ou coincident.
  -> Risque & Conseil :
     V�rifier les d�finitions des level sets et la liste des points du fond
     de fissure trouv�s. Si c'est normal, contactez votre correspondant.
"""),

51 : _("""
  -> Il n'y a aucune maille enrichie.
  -> Risque & Conseil:
     Veuillez v�rifier les d�finitions des level sets.
  """),

}
