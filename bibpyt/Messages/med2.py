#@ MODIF med2 Messages  DATE 18/03/2013   AUTEUR SELLENET N.SELLENET 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
  -> Les groupes '%(k1)s' et '%(k2)s'
     ont les m�mes vingt quatre premiers caract�res, leur nom
     court est donc '%(k3)s'.
     Comme il n'est pas l�gitime dans le cas g�n�ral que deux
     groupes aux noms initialement diff�rents soient fusionn�s,
     le calcul s'arr�te.
  -> Conseil :
     Dans le cas o� certains des noms de groupes de votre maillage
     sont trop longs, modifiez les pour qu'ils ne d�passent pas
     les 8 caract�res.
"""),

2 : _(u"""
     '%(k1)s'
"""),

3 : _(u"""
     Fichier MED introuvable.
"""),

4 : _(u"""
Le champ '%(k1)s' est d�j� pr�sent
dans le fichier MED pour l'instant %(r1)G.
  -> Conseil :
     Vous pouvez soit imprimer le champ dans un autre fichier, soit
     nommer le champ diff�remment.
"""),

5 : _(u"""
Le champ '%(k1)s' dont vous avez demand� l'impression au format MED
est d�fini sur des �l�ments utilisant la famille de points de Gauss
'%(k2)s'. Or l'impression de cette famille n'est pas possible au
format MED.
  -> Conseil :
     Restreignez l'impression demand�e aux �l�ments ne contenant pas
     la famille de point de Gauss incrimin�e.
"""),

6 : _(u"""
    Les mots-cl�s %(k1)s et %(k2)s sont incompatibles.
"""),

7 : _(u"""
  Il n'a pas �t� possible d'imprimer le champ %(k1)s en utilisant
  IMPR_NOM_VARI='OUI'. Cela est d� au fait que certains comportements
  dans votre mod�le ne sont pas imprimables avec cette option.

  -> Conseils :
     - N'utilisez pas IMPR_NOM_VARI='OUI' pour imprimer ce champ,
     - Demandez l'�volution pour que ces comportements soient
       compatibles avec IMPR_NOM_VARI='OUI'.
"""),

8 : _(u"""
  Vous utilisez IMPR_RESU avec le mot-cl� RESTREINT. Or vous avez
  d�j� utilis� cette commande avec ce m�me mot-cl� sur ce m�me
  fichier pr�c�demment.
  
  Cet usage est interdit en raison des risques de r�sultats
  inattendus que cela peut provoquer.

  -> Conseils :
     - Utilisez EXTR_RESU pour restreindre vos r�sultats,
     - Faites votre deuxi�me IMPR_RESU RESTREINT sur un nouveau
       fichier.
"""),

}
