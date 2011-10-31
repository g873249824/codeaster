#@ MODIF supervis2 Messages  DATE 31/10/2011   AUTEUR COURTOIS M.COURTOIS 
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

1 : _(u"""
Lecture du fichier %(k1)s..."""),

3 : _(u"""%(k1)-8s %(k2)-16s ignor�"""),

5 : _(u"""
Erreur inattendue lors de l'ex�cution de la commande '%(k1)s'.
Merci de signaler cette anomalie.

Erreur :

%(k2)s
%(k3)s
"""),

6 : _(u"""
Erreur lors du chargement du catalogue du mat�riau '%(k1)s'.
"""),

7 : _(u"""
Erreur dans le catalogue du mat�riau '%(k1)s'.

Il n'est pas possible d'avoir plusieurs occurrences pour le
mot-cl� facteur '%(k2)s'.
"""),

8 : _(u"""
L'op�ration de retassage de la base GLOBALE (mot cl� RETASSAGE="OUI"
dans la commande FIN) est inutile lorsque l'on sauvegarde cette
derni�re au format HDF (mot cl� FORMAT_HDF="OUI" dans la commande FIN).
"""),

# Lignes d'entete
10 : {  'message' : _(u"""

                -- CODE_ASTER -- VERSION : %(k1)s --

                Version %(k2)s du %(k3)s
                Copyright EDF R&D %(k4)s - %(k5)s
                Ex�cution du : %(k6)s
                Nom de la machine : %(k7)s
                Architecture : %(k8)s
                Type de processeur : %(k9)s
                Syst�me d'exploitation : %(k10)s
                Langue des messages : %(k11)s
"""), 'flags' : 'CENTER | ALL_UNIT',
},

11 : {  'message' : _(u"""Parall�lisme MPI : actif
                Rang du processeur courant : %(i1)d
                Nombre de processeurs utilis�s : %(i2)d"""),
        'flags' : 'CENTER | ALL_UNIT',
},

12 : {  'message' : _(u"""Parall�lisme MPI : inactif"""),
        'flags' : 'CENTER | ALL_UNIT',
},

13 : {  'message' : _(u"""Parall�lisme OpenMP : actif
                Nombre de processus utilis�s : %(i1)d"""),
        'flags' : 'CENTER | ALL_UNIT',
},

14 : {  'message' : _(u"""Version de la librairie HDF5 : %(i1)d.%(i2)d.%(i3)d"""),
        'flags' : 'CENTER | ALL_UNIT',
},

15 : {  'message' : _(u"""Librairie HDF5 : non disponible"""),
        'flags' : 'CENTER | ALL_UNIT',
},

16 : {  'message' : _(u"""Version de la librairie MED : %(i1)d.%(i2)d.%(i3)d"""),
        'flags' : 'CENTER | ALL_UNIT',
},

17 : {  'message' : _(u"""Librairie MED : non disponible"""),
        'flags' : 'CENTER | ALL_UNIT',
},

18 : {  'message' : _(u"""Librairie MUMPS : install�e"""),
        'flags' : 'CENTER | ALL_UNIT',
},

19 : {  'message' : _(u"""Librairie MUMPS : non disponible"""),
        'flags' : 'CENTER | ALL_UNIT',
},

20 : {  'message' : _(u"""Version de la librairie SCOTCH : %(i1)d.%(i2)d.%(i3)d"""),
        'flags' : 'CENTER | ALL_UNIT',
},

21 : {  'message' : _(u"""Librairie SCOTCH : non disponible"""),
        'flags' : 'CENTER | ALL_UNIT',
},

22 : {  'message' : _(u"""Limite de la m�moire statique : %(r1).3f Mo
Limite de la m�moire dynamique : %(r2).3f Mo
Taille limite des fichiers d'�change : %(r3).3f Go
"""), 'flags' : 'CENTER | ALL_UNIT',
},

# Affichage des commandes
70 : u"""  # ------------------------------------------------------------------------------------------""",

71 : _(u"""  # Commande No :  %(i1)04d            Concept de type : %(k1)s"""),

72 : _(u"""  # Commande :
  # ----------"""),

73 : _(u"""  # Statistiques m�moire (Mo) : %(r1)9.2f / %(r2)9.2f / %(r3)9.2f (VmPeak / Optimum / Minimum)"""),

74 : _(u"""  # Statistiques m�moire (Mo) : %(r1)9.2f / %(r2)9.2f (Optimum / Minimum)"""),

75 : _(u"""  # Fin commande No : %(i1)04d   user+syst:%(r1)12.2fs (syst:%(r2)12.2fs, elaps:%(r3)12.2fs)"""),

76 : _(u"""  # Fin commande : %(k1)s"""),


97 : {  'message' : _(u"""
 <FIN> Arr�t normal dans "FIN".
"""), 'flags' : 'ALL_UNIT',
},

}
