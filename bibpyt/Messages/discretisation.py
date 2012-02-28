#@ MODIF discretisation Messages  DATE 29/02/2012   AUTEUR MACOCCO K.MACOCCO 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

14 : _("""
 Attention : avec MODE_CALCUL_TPLUS = 'IMPLEX', on doit demander le calcul � tous les instants
 (EVENEMENT='TOUT_INST')
"""),

15 : _("""
 Attention : MODE_CALCUL_TPLUS = 'IMPLEX' ne permet qu'un mot cl� ADAPTATION
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
L'instant initial est introuvable dans la liste d'instants (LIST_INST).
Risque & Conseil :
   V�rifiez le mot-cl� INST_INIT (ou NUME_INST_INIT), en tenant compte de la pr�cision (mot-cl� PRECISION).
"""),

90 : _("""
Instant final introuvable dans la liste d'instants (LIST_INST).
"""),

92 : _("""
On ne peut faire le calcul car l'instant final donn� est �gal au dernier instant stock� dans la structure de donn�es RESULTAT. Il n'y a qu'un incr�ment disponible alors qu'il faut au moins deux pas de temps dans les op�rateurs non-lin�aires.  
"""),

93: _("""
 NUME_INST_INIT n'appartient pas � la liste d'instants
"""),

94 : _("""
L'instant final est introuvable dans la liste d'instants (LIST_INST).
Risque & Conseil :
   V�rifiez le mot-cl� INST_FIN (ou NUME_INST_FIN), en tenant compte de la pr�cision (mot-cl� PRECISION).
"""),

99 : _("""
Le nombre de niveau de subdivisions doit etre plus grand que 1 (SUBD_NIVEAU)
"""),

}
