#@ MODIF discretisation Messages  DATE 21/02/2011   AUTEUR ABBAS M.ABBAS 
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
Certains pas de temps de la liste (LISTE_INST) sont plus petits
 que le pas de temps minimal renseign� (SUBD_PAS_MINI)
"""),

2 : _("""
 L'instant initial de la liste est plus grand que le deuxi�me instant.
 Si vous faites une reprise de calcul (REUSE), vous pouvez utiliser le mot-clef ETAT_INIT/INST_ETAT_INIT pour corriger cel�.
"""),

3 : _("""
Le nombre de subdivisions du pas de temps doit �tre plus grand que 1 (SUBD_PAS)
"""),


5 : _("""
 L'adaptation du pas de temps a �t� d�sactiv�e. Seuls les instants d�finis par LIST_INST seront calcul�s
 (hormis les sous-d�coupages �ventuels).
"""),

6 : _("""
 valeur de SUBD_ITER_IGNO incoherent avec ITER_GLOB_MAXI.
 augmentez ITER_GLOB_MAXI
"""),

7 : _("""
 valeur de SUBD_ITER_FIN incoherent avec ITER_GLOB_MAXI.
 augmentez ITER_GLOB_MAXI
"""),

8 : _("""
 Vous faites un calcul de thermique sans r�solution stationnaire et sans
 non plus de r�solution transitoire.

 Conseils :
   Renseignez la discr�tisation temporelle par le mot cl� INCREMENT
"""),

9 : _("""
 Attention, en cas d'erreur (contact, loi de comportement, pilotage, ...), le pas de temps
 ne sera pas re-decoupe.
"""),


10 : _("""
 On ne peut d�finir qu'une seule occurence de ECHEC/EVENEMENT='ERREUR'.
"""),

11 : _("""
 La valeur du pas de temps retenu (%(r1)s) est inf�rieure � PAS_MINI.
"""),

12 : _("""
 La valeur du pas de temps retenu (%(r1)s) est sup�rieure � PAS_MAXI.
"""),

13 : _("""
 On a depass� le nombre maximal de pas de temps autoris�.
"""),

86 : _("""
Il n'y a aucun pas de calcul temporel.
En m�canique, 'LIST_INST' est absent.
En thermique, 'LIST_INST' est absent ou un singleton.
"""),

87 : _("""
La liste d'instants n'est pas strictement croissante.
"""),

89 : _("""
Instant initial introuvable dans la liste d'instants (LIST_INST).
"""),

90 : _("""
Instant final introuvable dans la liste d'instants (LIST_INST).
"""),

92 : _("""
 NUME_INST_INIT plus grand que NUME_INST_FIN
"""),

93: _("""
 NUME_INST_INIT n'appartient pas � la liste d'instants
"""),

94 : _("""
  -> Le numto d'ordre correspondant � l'instant final de calcul NUME_INST_FIN
     n'appartient pas � la liste des num�ros d'ordre.
     Dans ce cas, Aster consid�re pour num�ro d'ordre final, le dernier de
     la liste fournie.
  -> Risque & Conseil :
     Afin d'�viter des pertes de r�sultats, assurez-vous que le num�ro d'ordre
     associ� � l'instant NUME_INST_FIN appartienne bien � la liste des num�ros
     d'ordre.
"""),

99 : _("""
Le nombre de niveau de subdivisions doit etre plus grand que 1 (SUBD_NIVEAU)
"""),

}
