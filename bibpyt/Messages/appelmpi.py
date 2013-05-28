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
# person_in_charge: josselin.delmas at edf.fr

cata_msg={
1 : _(u"""%(i2)4d alarme a �t� �mise sur le processeur #%(i1)d.
"""),

2 : _(u"""%(i2)4d alarmes ont �t� �mises sur le processeur #%(i1)d.
"""),

3: _(u"""
 En parall�le, il faut au moins un sous-domaine par processeur.
"""),

5: _(u"""
 Erreur MPI: %(k1)s
"""),
6: _(u"""
 Probl�me li� a la distribution parall�le de calculs au sein d'une macro-commande.
 Le param�tre %(k1)s=%(i1)d est incoh�rent.
 
 Conseil:
 =======
   * Contacter l'�quipe de d�veloppement.
"""),

8: _(u"""
 Probl�me li� a la distribution parall�le de calculs au sein d'une macro-commande.
 Parmi les param�tres suivants, au moins un est incoh�rent. 
     - %(k1)s=%(i1)d,
     - %(k2)s=%(i2)d,
     - %(k3)s=%(i3)d.
 
 Conseil:
 =======
   * Contacter l'�quipe de d�veloppement.
"""),

80 : _(u"""  Le processeur #0 demande d'interrompre l'ex�cution."""),

81 : _(u"""  On demande au processeur #%(i1)d de s'arr�ter ou de lever une exception."""),

82 : _(u"""  On signale au processeur #0 qu'une erreur s'est produite."""),

83 : _(u"""  Communication de type '%(k1)s' annul�e."""),

84 : _(u"""  Le processeur #%(i1)d a �mis un message d'erreur."""),


92 : _(u"""  On signale au processeur #0 qu'une exception a �t� lev�e."""),



95 : _(u"""
    Tous les processeurs sont synchronis�s.
    Suite � une erreur sur un processeur, l'ex�cution est interrompue.
"""),

96 : _(u"""
  Le processeur #%(i1)d n'a pas r�pondu dans le d�lai imparti.
"""),

97 : _(u"""
    Le d�lai d'expiration de la communication est d�pass�.
    Cela signifie que le processeur #0 attend depuis plus de %(r1).0f secondes,
    ce qui n'est pas normal.
"""),

99 : { 'message' : _(u"""

    Au moins un processeur n'est pas en mesure de participer � la communication.
    L'ex�cution est donc interrompue.

"""), 'flags' : 'DECORATED',
},

}
