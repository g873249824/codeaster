# coding=utf-8
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
# person_in_charge: jean-michel.proix at edf.fr

"""Ce module définit les noms de variables internes valides.
Un comportement ne doit/peut pas utiliser une variable internes dont le
nom ne serait pas déclaré ici."""

DICT_NOM_VARI = {
    "ACIER1" : _(u"phase métallurgique acier variable interne 1"),
    "ACIER2" : _(u"phase métallurgique acier variable interne 2"),
    "ACIER3" : _(u"phase métallurgique acier variable interne 3"),
    "ACIER4" : _(u"phase métallurgique acier variable interne 4"),
    "ACIER5" : _(u"phase métallurgique acier variable interne 5"),
    "ADOUCOMP" : _(u"affaiblissement relatif de raideur en membrane en compression"),
    "ADOUFLEX" : _(u"affaiblissement relatif de raideur en flexion"),
    "ADOUTRAC" : _(u"affaiblissement relatif de raideur en membrane en traction"),
    "ALEA" : _(u"contrainte de rupture par amorçage,"),
    "ALPHA2XX" : _(u"écrouissage cinématique non linéaire variable interne 2  composante XX"),
    "ALPHA2XY" : _(u"écrouissage cinématique non linéaire variable interne 2  composante XY"),
    "ALPHA2XZ" : _(u"écrouissage cinématique non linéaire variable interne 2  composante XZ"),
    "ALPHA2YY" : _(u"écrouissage cinématique non linéaire variable interne 2  composante YY"),
    "ALPHA2YZ" : _(u"écrouissage cinématique non linéaire variable interne 2  composante YZ"),
    "ALPHA2ZZ" : _(u"écrouissage cinématique non linéaire variable interne 2  composante ZZ"),
    "ALPHAXX" : _(u"écrouissage cinématique non linéaire variable interne 1  composante XX"),
    "ALPHAXY" : _(u"écrouissage cinématique non linéaire variable interne 1  composante XY"),
    "ALPHAXZ" : _(u"écrouissage cinématique non linéaire variable interne 1  composante XZ"),
    "ALPHAYY" : _(u"écrouissage cinématique non linéaire variable interne 1  composante YY"),
    "ALPHAYZ" : _(u"écrouissage cinématique non linéaire variable interne 1  composante YZ"),
    "ALPHAZZ" : _(u"écrouissage cinématique non linéaire variable interne 1  composante ZZ"),
    "ANGL1" : _(u"GLRC_DAMAGE : angle d'orthotropie 1"),
    "ANGL2" : _(u"GLRC_DAMAGE : angle d'orthotropie 2"),
    "ANGL3" : _(u"GLRC_DAMAGE : angle d'orthotropie 3"),
    "ANGLEDEV" : _(u"angle du seuil déviatoire (CJS)"),
    "ARAG" : _(u"BETON_RAG : avancement de la réaction"),
    "ASSCORN1" : _(u"assemblage cornière, variable interne 1"),
    "ASSCORN2" : _(u"assemblage cornière, variable interne 2"),
    "ASSCORN3" : _(u"assemblage cornière, variable interne 3"),
    "ASSCORN4" : _(u"assemblage cornière, variable interne 4"),
    "ASSCORN5" : _(u"assemblage cornière, variable interne 5"),
    "ASSCORN6" : _(u"assemblage cornière, variable interne 6"),
    "ASSCORN7" : _(u"assemblage cornière, variable interne 7"),
    "BC" : _(u"BETON_RAG : Endommagement macroscopique en compression"),
    "BT11" : _(u"BETON_RAG : Endommagement macroscopique (indicateur de fissuration)  composante 1"),
    "BT12" : _(u"BETON_RAG : Endommagement macroscopique (indicateur de fissuration)  composante 2"),
    "BT13" : _(u"BETON_RAG : Endommagement macroscopique (indicateur de fissuration)  composante 3"),
    "BT22" : _(u"BETON_RAG : Endommagement macroscopique (indicateur de fissuration)  composante 4"),
    "BT23" : _(u"BETON_RAG : Endommagement macroscopique (indicateur de fissuration)  composante 5"),
    "BT33" : _(u"BETON_RAG : Endommagement macroscopique (indicateur de fissuration)  composante 6"),
    "COHESION" : _(u"cohésion"),
    "COMPT" : _(u"itération de Newton courante,"),
    "COMR" : _(u"itération de Newton de rupture,"),
    "CRITSIG": _(u"Critère en contrainte, utilisé en Génie Civil"),
    "CRITEPS": _(u"Critère en déformation, utilisé en Génie Civil"),
    "CRITHILL" : _(u"Critère de Hill : pour Hujeux : densité normalisée pour le travail du second ordre"),
    "DB1" : _(u"c_plan ou 1d algo Deborst, variable interne 1"),
    "DB2" : _(u"c_plan ou 1d algo Deborst, variable interne 2"),
    "DB3" : _(u"c_plan ou 1d algo Deborst, variable interne 3"),
    "DB4" : _(u"c_plan ou 1d algo Deborst, variable interne 4"),
    "DDISSM" : _(u"Vitesse de dissipation mécanique"),
    "DEPPLAS1" : _(u"JOINT_MECA_FROT  déplacement tangentiel plastique par rapport au point de départ, composante 1"),
    "DEPPLAS2" : _(u"JOINT_MECA_FROT  déplacement tangentiel plastique par rapport au point de départ, composante 2"),
    "DEPS-TH" : _(u"PINTO-MENEGOTTO V5"),
    "DEPSPEQ" : _(u"incrément de déformation plastique équivalente"),
    "DETOPTG" : _(u"Hujeux : déterminant de la matrice tangente"),
    "DINSTM" : _(u"Incrément de temps"),
    "DIS1" : _(u"éléments discrets, variable interne 1"),
    "DIS10" : _(u"éléments discrets, variable interne 10"),
    "DIS11" : _(u"éléments discrets, variable interne 11"),
    "DIS12" : _(u"éléments discrets, variable interne 12"),
    "DIS13" : _(u"éléments discrets, variable interne 13"),
    "DIS14" : _(u"éléments discrets, variable interne 14"),
    "DIS15" : _(u"éléments discrets, variable interne 15"),
    "DIS16" : _(u"éléments discrets, variable interne 16"),
    "DIS17" : _(u"éléments discrets, variable interne 17"),
    "DIS18" : _(u"éléments discrets, variable interne 18"),
    "DIS2" : _(u"éléments discrets, variable interne 2"),
    "DIS3" : _(u"éléments discrets, variable interne 3"),
    "DIS4" : _(u"éléments discrets, variable interne 4"),
    "DIS5" : _(u"éléments discrets, variable interne 5"),
    "DIS6" : _(u"éléments discrets, variable interne 6"),
    "DIS7" : _(u"éléments discrets, variable interne 7"),
    "DIS8" : _(u"éléments discrets, variable interne 8"),
    "DIS9" : _(u"éléments discrets, variable interne 9"),
    "DISSENDO" : _(u"dissipation d'endommagement"),
    "DISSIP"   : _(u"dissipation plastique"),
    "DISSGLIS" : _(u"dissipation de glissement"),
    "DISSTHER" : _(u"dissipation Thermodynamique"),
    "DISTSDEV" : _(u"CJS distance normalisée au seuil déviatoire"),
    "DISTSISO" : _(u"CJS distance normalisée au seuil isotrope"),
    "DOMAINE" : _(u"LETK : domaine de comportement de la roche"),
    "DOMCOMP" : _(u"Laigle : domaine de comportement de la roche"),
    "DPORO" : _(u"LIQU_AD_GAZ v1"),
    "DPVP" : _(u"LIQU_AD_GAZ v2"),
    "DUY" : _(u"valeur maximale de la différence déplacement local-déplacement limite"),
    "EBLOC" : _(u"énergie bloquée"),
    "ECRISOM1" : _(u"JOINT_BA : variable scalaire de l'écrouissage isotrope pour l'endommagement en mode 1"),
    "ECRISOM2" : _(u"JOINT_BA : variable scalaire de l'écrouissage isotrope pour l'endommagement en mode 2"),
    "ECROCINE" : _(u"JOINT_BA : valeur de l'écrouissage cinématique par frottement des fissures"),
    "ECROISOT" : _(u"Variable d'écrouissage isotrope"),
    "EDI11" : _(u"déformation seuil déviatorique irréversible, composante 11"),
    "EDI12" : _(u"déformation seuil déviatorique irréversible, composante 12"),
    "EDI13" : _(u"déformation seuil déviatorique irréversible, composante 13"),
    "EDI22" : _(u"déformation seuil déviatorique irréversible, composante 22"),
    "EDI23" : _(u"déformation seuil déviatorique irréversible, composante 23"),
    "EDI33" : _(u"déformation seuil déviatorique irréversible, composante 33"),
    "EDS11" : _(u"déformation seuil déviatorique irréversible, composante 11"),
    "EDS12" : _(u"déformation seuil déviatorique réversible, composante 12"),
    "EDS13" : _(u"déformation seuil déviatorique réversible, composante 13"),
    "EDS22" : _(u"déformation seuil déviatorique réversible, composante 22"),
    "EDS23" : _(u"déformation seuil déviatorique réversible, composante 23"),
    "EDS33" : _(u"déformation seuil déviatorique réversible, composante 33"),
    "EID11" : _(u"déformation déviatorique irréversible, composante 11"),
    "EID12" : _(u"déformation déviatorique irréversible, composante 12"),
    "EID31" : _(u"déformation déviatorique irréversible, composante 31"),
    "EID22" : _(u"déformation déviatorique irréversible, composante 22"),
    "EID23" : _(u"déformation déviatorique irréversible, composante 23"),
    "EID33" : _(u"déformation déviatorique irréversible, composante 33"),
    "EIEQM" : _(u"déformation équivalente irréversible maximale"),
    "ERD11" : _(u"déformation déviatorique réversible, composante 11"),
    "ERD12" : _(u"déformation déviatorique réversible, composante 12"),
    "ERD31" : _(u"déformation déviatorique réversible, composante 31"),
    "ERD22" : _(u"déformation déviatorique réversible, composante 22"),
    "ERD23" : _(u"déformation déviatorique réversible, composante 23"),
    "ERD33" : _(u"déformation déviatorique réversible, composante 33"),
    "EFD11" : _(u"retrait de dessiccation, composante 11"),
    "EFD12" : _(u"retrait de dessiccation, composante 12"),
    "EFD31" : _(u"retrait de dessiccation, composante 31"),
    "EFD22" : _(u"retrait de dessiccation, composante 22"),
    "EFD23" : _(u"retrait de dessiccation, composante 23"),
    "EFD33" : _(u"retrait de dessiccation, composante 33"),
    "EIS"   : _(u"déformation sphérique irréversible"),
    "EISP"  : _(u"déformation sphérique irréversible"),
    "ELEP1" : _(u"numéro de l'élément pointé numéro 1,"),
    "ELEP2" : _(u"numéro de l'élément pointé numéro 2 (quand amorçage),"),
    "ENDO" : _(u"endommagement scalaire"),
    "ENDO_C" : _(u"endommagement scalaire en compression"),
    "ENDO_T" : _(u"endommagement scalaire en traction"),
    "ENDOC0" : _(u"BETON_RAG : Endommagement intrinsèque de compression"),
    "ENDOCOMP" : _(u"endommagement scalaire en compression"),
    "ENDOFL-" : _(u"variable d'endommagement pour la flexion négative"),
    "ENDOFL+" : _(u"variable d'endommagement pour la flexion positive"),
    "ENDOSUP" : _(u"variable d'endommagement pour la moitié supérieure de la plaque"),
    "ENDOINF" : _(u"variable d'endommagement pour la moitié inférieure de la plaque"),
    "ENDONOR" : _(u"endommagement normal"),
    "ENDORIGI" : _(u"rigidité résiduelle"),
    "ENDOTAN" : _(u"endommagement tangentiel"),
    "ENDOT11" : _(u"BETON_RAG : Endommagement intrinsèque de traction,  composante 1"),
    "ENDOT12" : _(u"BETON_RAG : Endommagement intrinsèque de traction,  composante 2"),
    "ENDOT13" : _(u"BETON_RAG : Endommagement intrinsèque de traction,  composante 3"),
    "ENDOT22" : _(u"BETON_RAG : Endommagement intrinsèque de traction,  composante 4"),
    "ENDOT23" : _(u"BETON_RAG : Endommagement intrinsèque de traction,  composante 5"),
    "ENDOT33" : _(u"BETON_RAG : Endommagement intrinsèque de traction,  composante 6"),
    "ENDOXX" : _(u"tenseur endommagement, direction XX"),
    "ENDOXY" : _(u"tenseur endommagement, direction XY"),
    "ENDOXZ" : _(u"tenseur endommagement, direction XZ"),
    "ENDOYY" : _(u"tenseur endommagement, direction YY"),
    "ENDOYZ" : _(u"tenseur endommagement, direction YZ"),
    "ENDOZZ" : _(u"tenseur endommagement, direction ZZ"),
    "ENEL_RES" : _(u"énegie résiduelle"),
    "EPAISSJO" : _(u"épaisseur du joint clavé"),
    "EPEQIRRA" : _(u"déformation plastique équivalente d'irradiation"),
    "EPSEQ" : _(u"déformation équivalente, au sens de Mazars"),
    "EPSEQC" : _(u"déformation de compression équivalente, au sens de Mazars"),
    "EPSEQT" : _(u"déformation de traction équivalente, au sens de Mazars"),
    "EPSEXX" : _(u"déformation élastique composante XX"),
    "EPSEXY" : _(u"déformation élastique composante XY"),
    "EPSEXZ" : _(u"déformation élastique composante XZ"),
    "EPSEYY" : _(u"déformation élastique composante YY"),
    "EPSEYZ" : _(u"déformation élastique composante YZ"),
    "EPSEZZ" : _(u"déformation élastique composante ZZ"),
    "EPSGRD" : _(u"déformation de grandissement."),
    "EPSM+V5" : _(u" Pinto-Menegotto, déformation totale"),
    "EPSP" : _(u"déformation plastique"),
    "EPSP1" : _(u"GLRC_DAMAGE : extension membranaire plastique 1"),
    "EPSP2" : _(u"GLRC_DAMAGE : extension membranaire plastique 2"),
    "EPSP3" : _(u"GLRC_DAMAGE : extension membranaire plastique 3"),
    "EPSPEQ" : _(u"déformation plastique équivalente (déviatorique)  cumulée"),
    "EPSPEQC" : _(u"déformation plastique équivalente (déviatorique)  cumulée en compression"),
    "EPSPEQT" : _(u"déformation plastique équivalente (déviatorique)  cumulée en traction"),
    "EPSPVOL" : _(u"déformation plastique équivalente volumique"),
    "EPSPXX" : _(u"déformation plastique composante XX"),
    "EPSPXY" : _(u"déformation plastique composante XY"),
    "EPSPXZ" : _(u"déformation plastique composante XZ"),
    "EPSPYY" : _(u"déformation plastique composante YY"),
    "EPSPYZ" : _(u"déformation plastique composante YZ"),
    "EPSPZZ" : _(u"déformation plastique composante ZZ"),
    "EPSRN" : _(u"déformation du cycle actuel, Pinto-Menegotto"),
    "EPSRN-1" : _(u"déformation du cycle précédent  Pinto-Menegotto"),
    "ERS"  : _(u"Déformation sphérique réversible"),
    "ERSP" : _(u"Déformation sphérique réversible"),
    "ESI" : _(u"BETON_RAG : déformation seuil viscoplastique sphérique"),
    "ESS" : _(u"BETON_RAG : déformation seuil viscoplastique sphérique"),
    "EVP11" : _(u"BETON_RAG : déformation  viscoplastique composante 1"),
    "EVP12" : _(u"BETON_RAG : déformation  viscoplastique composante 2"),
    "EVP13" : _(u"BETON_RAG : déformation  viscoplastique composante 3"),
    "EVP22" : _(u"BETON_RAG : déformation  viscoplastique composante 4"),
    "EVP23" : _(u"BETON_RAG : déformation  viscoplastique composante 5"),
    "EVP33" : _(u"BETON_RAG : déformation  viscoplastique composante 6"),
    "FECRDVC1" : _(u"Hujeux : facteur de mobilisation du mécanisme déviatoire cyclique, k= 1"),
    "FECRDVC2" : _(u"Hujeux : facteur de mobilisation du mécanisme déviatoire cyclique, k= 1"),
    "FECRDVC3" : _(u"Hujeux : facteur de mobilisation du mécanisme déviatoire cyclique, k= 1"),
    "FECRDVM1" : _(u"Hujeux : facteur de mobilisation du mécanisme déviatoire monotone, k= 1"),
    "FECRDVM2" : _(u"Hujeux : facteur de mobilisation du mécanisme déviatoire monotone, k= 2"),
    "FECRDVM3" : _(u"Hujeux : facteur de mobilisation du mécanisme déviatoire monotone, k= 3"),
    "FECRISC1" : _(u"Hujeux : facteur de mobilisation du mécanisme de consolidation cyclique"),
    "FECRISM1" : _(u"Hujeux : facteur de mobilisation du mécanisme de consolidation monotone"),
    "FH_X" : _(u"flux hydraulique dans le repère global ( xxx_JOINT_HYME) composante 1"),
    "FH_Y" : _(u"flux hydraulique dans le repère global ( xxx_JOINT_HYME) composante 2"),
    "FH_Z" : _(u"flux hydraulique dans le repère global ( xxx_JOINT_HYME) composante 3"),
    "FVOLPORO" : _(u"fraction volumique de porosité"),
    "GAMMAECR" : _(u"le paramètre d'écrouissage correspondant à la déformation irréversible majeure."),
    "GAMMAP" : _(u"LETK : déformation déviatorique plastique"),
    "GAMMAVP" : _(u"LETK : déformation déviatorique viscoplastique"),
    "GAZ1" : _(u"GAZ : v1"),
    "GLIS" : _(u"JOINT_BA : déformation de glissement cumulée par frottement des fissures"),
    "GLISXINF" : _(u"DHRC : déformation de glissement le long des aciers orientés selon X dans la partie inférieure de la plaque"),
    "GLISXSUP" : _(u"DHRC : déformation de glissement le long des aciers orientés selon X dans la partie supérieure de la plaque"),
    "GLISYINF" : _(u"DHRC : déformation de glissement le long des aciers orientés selon Y dans la partie inférieure de la plaque"),
    "GLISYSUP" : _(u"DHRC : déformation de glissement le long des aciers orientés selon Y dans la partie supérieure de la plaque"),
    "GONF" : _(u"gonflement"),
    "GR1" : _(u"elas_poutre_GR v1"),
    "GR2" : _(u"elas_poutre_GR v2"),
    "GR3" : _(u"elas_poutre_GR v3"),
    "GRADP_X" : _(u"gradient de pression dans le repère global ( xxx_JOINT_HYME)  Composante 1"),
    "GRADP_Y" : _(u"gradient de pression dans le repère global ( xxx_JOINT_HYME)  Composante 2"),
    "GRADP_Z" : _(u"gradient de pression dans le repère global ( xxx_JOINT_HYME)  Composante 3"),
    "H1" : _(u"Hayhurst : variable d'écrouissage H1"),
    "H2" : _(u"Hayhurst : variable d'écrouissage H2"),
    "HIS10" : _(u"Hujeux : variable mémoratrice pour le mécanisme déviatoire cyclique du plan 1, composante 2"),
    "HIS11" : _(u"Hujeux : variable mémoratrice pour le mécanisme déviatoire cyclique du plan 1, composante 3"),
    "HIS12" : _(u"Hujeux : variable mémoratrice pour le mécanisme déviatoire cyclique du plan 1, composante 4"),
    "HIS13" : _(u"Hujeux : variable mémoratrice pour le mécanisme déviatoire cyclique du plan 2, composante 1"),
    "HIS14" : _(u"Hujeux : variable mémoratrice pour le mécanisme déviatoire cyclique du plan 2, composante 2"),
    "HIS15" : _(u"Hujeux : variable mémoratrice pour le mécanisme déviatoire cyclique du plan 2, composante 3"),
    "HIS16" : _(u"Hujeux : variable mémoratrice pour le mécanisme déviatoire cyclique du plan 2, composante 4"),
    "HIS17" : _(u"Hujeux : variable mémoratrice pour le mécanisme déviatoire cyclique du plan 3, composante 1"),
    "HIS18" : _(u"Hujeux : variable mémoratrice pour le mécanisme déviatoire cyclique du plan 3, composante 2"),
    "HIS19" : _(u"Hujeux : variable mémoratrice pour le mécanisme déviatoire cyclique du plan 3, composante 3"),
    "HIS20" : _(u"Hujeux : variable mémoratrice pour le mécanisme déviatoire cyclique du plan 3, composante 4"),
    "HIS21" : _(u"Hujeux : variable mémoratrice discontinue du mécanisme de consolidation"),
    "HIS22" : _(u"Hujeux : variable mémoratrice discontinue de normale à la surface de charge du mécanisme de consolidation"),
    "HIS34" : _(u"Hujeux : Indicateur d'état des mécanismes actifs après convergence"),
    "HIS9" : _(u"Hujeux : variable mémoratrice pour le mécanisme déviatoire cyclique du plan 1, composante 1"),
    "HYDR1" : _(u"HYDR : v1"),
    "HYDREND1" : _(u"HYDRENDO : v1"),
    "HYDRUTI1" : _(u"HYDR_UTIL : v1"),
    "INDIOUV" : _(u"JOINT_MECA_FROT : indicateur d'ouverture complète =0 fermé, =1 ouvert"),
    "INDETAC1" : _(u"Hujeux : indicateur d'activation (1) ou non (0) des mécanismes cycliques, composante 1"),
    "INDETAC2" : _(u"Hujeux : indicateur d'activation (1) ou non (0) des mécanismes cycliques, composante 2"),
    "INDETAC3" : _(u"Hujeux : indicateur d'activation (1) ou non (0) des mécanismes cycliques, composante 3"),
    "INDETAC4" : _(u"Hujeux : indicateur d'activation (1) ou non (0) des mécanismes cycliques, composante 4"),
    "INDETAM1" : _(u"Hujeux : indicateur d'activation (1) ou non (0) des mécanismes monotones ou de passage au cyclique, composante 1"),
    "INDETAM2" : _(u"Hujeux : indicateur d'activation (1) ou non (0) des mécanismes monotones ou de passage au cyclique, composante 2"),
    "INDETAM3" : _(u"Hujeux : indicateur d'activation (1) ou non (0) des mécanismes monotones ou de passage au cyclique, composante 3"),
    "INDETAM4" : _(u"Hujeux : indicateur d'activation (1) ou non (0) des mécanismes monotones ou de passage au cyclique, composante 4"),
    "INDIC" : _(u"LETK : indicateur de la position de l'etat de contrainte par rapport aux seuils viscoplastiques"),
    "INDICDIL" : _(u"LETK : indicateur de contractance ou de dilatance"),
    "INDICYCL" : _(u" Pinto-Menegotto, indicateur d'activation du comportement cyclique"),
    "INDIDISS" : _(u"Indicateur de dissipation =0 si régime linéaire, =1 si régime dissipatif."),
    "INDIEND1" : _(u"indicateur d'endommagement pour la flexion positive"),
    "INDIEND2" : _(u"indicateur d'endommagement pour la flexion négative"),
    "INDIENDO" : _(u"indicateur d'endommagement"),
    "INDIENDN" : _(u"indicateur d'endommagement normal =0 sain, =1 endommagé, =2 cassé"),
    "INDIENDT" : _(u"indicateur d'endommagement tangentiel =0 sain, =1 endommagé, =2 cassé"),
    "INDIFLAM" : _(u"indicateur de flambement"),
    "INDIHYDR" : _(u"indicateur d'irréversibilité hydrique"),
    "INDIPLAC" : _(u"indicateur de plasticité en compression  (0 : seuil non atteint, 1 ou > 1 : seuil atteint)"),
    "INDIPLAS" : _(u"indicateur de plasticité (0 : seuil non atteint, 1 ou > 1 : seuil atteint)"),
    "INDIPLAT" : _(u"indicateur de plasticité en traction  (0 : seuil non atteint, 1 ou > 1 : seuil atteint)"),
    "INDIVIDE" : _(u"indice des vides"),
    "INDIVISC" : _(u"indicateur de viscoplasticité"),
    "IRRA" : _(u"irradiation"),
    "IRVECU" : _(u"mémorisation de l'historique d'irradiation (fluence),"),
    "ISPH" : _(u"Beton_umlv_fp : v21"),
    "KHIP1" : _(u"GLRC_DAMAGE : courbure plastique 1"),
    "KHIP2" : _(u"GLRC_DAMAGE : courbure plastique 2"),
    "KHIP3" : _(u"GLRC_DAMAGE : courbure plastique 3"),
    "KSIXX" : _(u"tenseur de rappel pour l'effet de mémoire, composante XX"),
    "KSIXY" : _(u"tenseur de rappel pour l'effet de mémoire, composante XY"),
    "KSIXZ" : _(u"tenseur de rappel pour l'effet de mémoire, composante XZ"),
    "KSIYY" : _(u"tenseur de rappel pour l'effet de mémoire, composante YY"),
    "KSIYZ" : _(u"tenseur de rappel pour l'effet de mémoire, composante YZ"),
    "KSIZZ" : _(u"tenseur de rappel pour l'effet de mémoire, composante ZZ"),
    "LAMBDA" : _(u"JOINT_MECA_FROT : paramètre croissant indiquant le déplacement tangentiel plastique cumulé (sans orientation)."),
    "LIQADGV1" : _(u"LIQADGV1"),
    "LIQADGV2" : _(u"LIQADGV2"),
    "LIQADGV3" : _(u"LIQADGV3"),
    "LIQGATM1" : _(u"LIQGATM1"),
    "LIQGATM2" : _(u"LIQGATM2"),
    "LIQGAZ1" : _(u"LIQGAZ1"),
    "LIQGAZ2" : _(u"LIQGAZ2"),
    "LIQSAT1" : _(u"LIQSAT1"),
    "LIQVAP1" : _(u"LIQVAP1"),
    "LIQVAP2" : _(u"LIQVAP2"),
    "LIQVAP3" : _(u"LIQVAP3"),
    "LIQVG1" : _(u"LIQVG1"),
    "LIQVG2" : _(u"LIQVG2"),
    "LIQVG3" : _(u"LIQVG3"),
    "NBITER" : _(u"nombre d'itérations internes"),
    "NBSSPAS" : _(u"nombre de redécoupages locaux du pas de temps"),
    "SIGP" : _(u"cam_clay : contrainte de confinement"),
    "PCENERDI" : _(u"pourcentage d'endommagement normal (dans la zone adoucissante)"),
    "PCENDOT" : _(u"pourcentage d'endommagement tangentiel"),
    "PCH" : _(u"BETON_RAG : pression chimique"),
    "PCR" : _(u"pression critique"),
    "PEFFRAG" : _(u"BETON_RAG : pression effective due à la RAG"),
    "PERM_LONG" : _(u"perméabilité longitudinale de la fissure"),
    "PHI" : _(u"Hayhurst : variable PHI"),
    "POROSITE" : _(u"porosité"),
    "POS" : _(u"VISC_DRUC_PRAG : position du point de charge par rapport au seuil"),
    "PRE1" : _(u"LIQU_AD_GAZ v4"),
    "PRE2" : _(u"LIQU_AD_GAZ v5"),
    "PRESF" : _(u"pression de fluide"),
    "PW" : _(u"BETON_RAG : pression hydrique"),
    "SIEQ" : _(u"cam_clay : contrainte équivalente"),
    "RESIDU" : _(u"valeur du test local d'arrêt des itérations internes"),
    "RHXZ" : _(u"Hujeux : rayon du seuil déviatoire atteint par  la surface de charge avant le décharge du mécanisme déviatoire du plan 2"),
    "RHYZ" : _(u"Hujeux : rayon du seuil déviatoire atteint par  la surface de charge avant le décharge du mécanisme déviatoire du plan 1"),
    "RSIGMA": _(u"Facteur de triaxialité des contraintes, modèle Mazars"),
    "SATLIQ" : _(u"LIQU_AD_GAZ v3"),
    "SAUT_N" : _(u"saut normal"),
    "SAUT_T1" : _(u"saut tangentiel 1"),
    "SAUT_T2" : _(u"saut tangentiel 2"),
    "SDEVCRIT" : _(u"CJS rapport entre le seuil déviatoire et le seuil déviatorique critique"),
    "SDEVEPSP" : _(u"CJS signe du produit contracté de la contrainte déviatorique par la déformation plastique déviatorique"),
    "SEF11" : _(u"BETON_RAG : contrainte effective dans le modèle rhéologique,  composante 1"),
    "SEF12" : _(u"BETON_RAG : contrainte effective dans le modèle rhéologique,  composante 2"),
    "SEF13" : _(u"BETON_RAG : contrainte effective dans le modèle rhéologique,  composante 3"),
    "SEF22" : _(u"BETON_RAG : contrainte effective dans le modèle rhéologique,  composante 4"),
    "SEF23" : _(u"BETON_RAG : contrainte effective dans le modèle rhéologique,  composante 5"),
    "SEF33" : _(u"BETON_RAG : contrainte effective dans le modèle rhéologique,  composante 6"),
    "SEUIL" : _(u"seuil"),
    "SEUIL_C" : _(u"seuil de compression"),
    "SEUIL_T" : _(u"seuil de traction"),
    "SEUILDEP" : _(u"CZM  seuil correspondant au plus grand saut de déplacement (en norme)"),
    "SEUILHYD" : _(u"seuil hydrique"),
    "SEUILISO" : _(u"seuil isotrope"),
    "SH1" : _(u"gdef_hypo_elas, variable interne 1"),
    "SH2" : _(u"gdef_hypo_elas, variable interne 2"),
    "SH3" : _(u"gdef_hypo_elas, variable interne 3"),
    "SH4" : _(u"gdef_hypo_elas, variable interne 4"),
    "SH5" : _(u"gdef_hypo_elas, variable interne 5"),
    "SH6" : _(u"gdef_hypo_elas, variable interne 6"),
    "SH7" : _(u"gdef_hypo_elas, variable interne 7"),
    "SH8" : _(u"gdef_hypo_elas, variable interne 8"),
    "SH9" : _(u"gdef_hypo_elas, variable interne 9"),
    "SIGM_N" : _(u"contrainte normale"),
    "SIGM_T1" : _(u"contrainte tangentielle"),
    "SIGMAPIC" : _(u"contrainte de pic"),
    "SIGN_GLO" : _(u"contrainte mécanique normale (sans pression de fluide)"),
    "SIGRN" : _(u" Pinto-Menegotto, contrainte cycle N"),
    "SIGT" : _(u"norme de la contrainte tangente"),
    "SM1" : _(u"SIMO_MIEHE, variable interne 1"),
    "SM2" : _(u"SIMO_MIEHE, variable interne 2"),
    "SM3" : _(u"SIMO_MIEHE, variable interne 3"),
    "SM4" : _(u"SIMO_MIEHE, variable interne 4"),
    "SM5" : _(u"SIMO_MIEHE, variable interne 5"),
    "SM6" : _(u"SIMO_MIEHE, variable interne 6"),
    "SUC" : _(u"BETON_RAG : contraintes seuil de compression"),
    "SURF" : _(u"contrainte de rupture par propagation,"),
    "SUT11" : _(u"BETON_RAG : contraintes seuil de traction,  composante 1"),
    "SUT12" : _(u"BETON_RAG : contraintes seuil de traction,  composante 2"),
    "SUT13" : _(u"BETON_RAG : contraintes seuil de traction,  composante 3"),
    "SUT22" : _(u"BETON_RAG : contraintes seuil de traction,  composante 4"),
    "SUT23" : _(u"BETON_RAG : contraintes seuil de traction,  composante 5"),
    "SUT33" : _(u"BETON_RAG : contraintes seuil de traction,  composante 6"),
    "TEMP" : _(u"température"),
    "TEMP_MAX" : _(u"température maximum"),
    "THXY1" : _(u"Hujeux : normale entrante à la surface de charge du mécanisme père du mécanisme déviatoire du plan 3, composante 1"),
    "THXY2" : _(u"Hujeux : normale entrante à la surface de charge du mécanisme père du mécanisme déviatoire du plan 3, composante 2"),
    "THXZ1" : _(u"Hujeux : normale entrante à la surface de charge du mécanisme père du mécanisme déviatoire du plan 2, composante 1"),
    "THXZ2" : _(u"Hujeux : normale entrante à la surface de charge du mécanisme père du mécanisme déviatoire du plan 2, composante 2"),
    "THYZ1" : _(u"Hujeux : normale entrante à la surface de charge du mécanisme père du mécanisme déviatoire du plan 1, composante 1"),
    "THYZ2" : _(u"Hujeux : normale entrante à la surface de charge du mécanisme père du mécanisme déviatoire du plan 1, composante 2"),
    "TXX" : _(u"GDEF_LOG  contrainte T, composante XX"),
    "TXY" : _(u"GDEF_LOG  contrainte T, composante XY"),
    "TXZ" : _(u"GDEF_LOG  contrainte T, composante XZ"),
    "TYY" : _(u"GDEF_LOG  contrainte T, composante YY"),
    "TYZ" : _(u"GDEF_LOG  contrainte T, composante YZ"),
    "TZZ" : _(u"GDEF_LOG  contrainte T, composante ZZ"),
    "VG1" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 1"),
    "VG10" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 10"),
    "VG11" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 11"),
    "VG12" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 12"),
    "VG13" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 13"),
    "VG14" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 14"),
    "VG15" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 15"),
    "VG16" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 16"),
    "VG17" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 17"),
    "VG18" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 18"),
    "VG19" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 19"),
    "VG2" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 2"),
    "VG20" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 20"),
    "VG21" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 21"),
    "VG22" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 22"),
    "VG23" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 23"),
    "VG24" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 24"),
    "VG25" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 25"),
    "VG26" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 26"),
    "VG27" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 27"),
    "VG28" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 28"),
    "VG29" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 29"),
    "VG3" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 3"),
    "VG30" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 30"),
    "VG31" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 31"),
    "VG32" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 32"),
    "VG33" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 33"),
    "VG34" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 34"),
    "VG35" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 35"),
    "VG36" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 36"),
    "VG37" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 37"),
    "VG38" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 38"),
    "VG39" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 39"),
    "VG4" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 4"),
    "VG40" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 40"),
    "VG41" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 41"),
    "VG42" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 42"),
    "VG43" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 43"),
    "VG44" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 44"),
    "VG45" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 45"),
    "VG46" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 46"),
    "VG47" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 47"),
    "VG48" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 48"),
    "VG49" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 49"),
    "VG5" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 5"),
    "VG50" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 50"),
    "VG51" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 51"),
    "VG52" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 52"),
    "VG53" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 53"),
    "VG54" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 54"),
    "VG55" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 55"),
    "VG6" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 6"),
    "VG7" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 7"),
    "VG8" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 8"),
    "VG9" : _(u"comportement GRANGER_FP, voir R7.01.01, variable interne 9"),
    "VIDE" : _(u"variable interne vide"),
    "VISCHA1" : _(u"VISCOCHAB, voir R5.03.12, variable interne 1"),
    "VISCHA10" : _(u"VISCOCHAB, voir R5.03.12, variable interne 10"),
    "VISCHA11" : _(u"VISCOCHAB, voir R5.03.12, variable interne 11"),
    "VISCHA12" : _(u"VISCOCHAB, voir R5.03.12, variable interne 12"),
    "VISCHA13" : _(u"VISCOCHAB, voir R5.03.12, variable interne 13"),
    "VISCHA14" : _(u"VISCOCHAB, voir R5.03.12, variable interne 14"),
    "VISCHA15" : _(u"VISCOCHAB, voir R5.03.12, variable interne 15"),
    "VISCHA16" : _(u"VISCOCHAB, voir R5.03.12, variable interne 16"),
    "VISCHA17" : _(u"VISCOCHAB, voir R5.03.12, variable interne 17"),
    "VISCHA18" : _(u"VISCOCHAB, voir R5.03.12, variable interne 18"),
    "VISCHA19" : _(u"VISCOCHAB, voir R5.03.12, variable interne 19"),
    "VISCHA2" : _(u"VISCOCHAB, voir R5.03.12, variable interne 2"),
    "VISCHA20" : _(u"VISCOCHAB, voir R5.03.12, variable interne 20"),
    "VISCHA21" : _(u"VISCOCHAB, voir R5.03.12, variable interne 21"),
    "VISCHA22" : _(u"VISCOCHAB, voir R5.03.12, variable interne 22"),
    "VISCHA23" : _(u"VISCOCHAB, voir R5.03.12, variable interne 23"),
    "VISCHA24" : _(u"VISCOCHAB, voir R5.03.12, variable interne 24"),
    "VISCHA25" : _(u"VISCOCHAB, voir R5.03.12, variable interne 25"),
    "VISCHA26" : _(u"VISCOCHAB, voir R5.03.12, variable interne 26"),
    "VISCHA27" : _(u"VISCOCHAB, voir R5.03.12, variable interne 27"),
    "VISCHA28" : _(u"VISCOCHAB, voir R5.03.12, variable interne 28"),
    "VISCHA3" : _(u"VISCOCHAB, voir R5.03.12, variable interne 3"),
    "VISCHA4" : _(u"VISCOCHAB, voir R5.03.12, variable interne 4"),
    "VISCHA5" : _(u"VISCOCHAB, voir R5.03.12, variable interne 5"),
    "VISCHA6" : _(u"VISCOCHAB, voir R5.03.12, variable interne 6"),
    "VISCHA7" : _(u"VISCOCHAB, voir R5.03.12, variable interne 7"),
    "VISCHA8" : _(u"VISCOCHAB, voir R5.03.12, variable interne 8"),
    "VISCHA9" : _(u"VISCOCHAB, voir R5.03.12, variable interne 9"),
    "X1" : _(u"coordonnée X de la pointe de fissure après rupture par propagation,"),
    "X2" : _(u"coordonnée X de la pointe de fissure 2 lors de l'amorçage,"),
    "XCIN1XX" : _(u"tenseur cinématique 1, composante XX"),
    "XCIN1XY" : _(u"tenseur cinématique 1, composante XY"),
    "XCIN1XZ" : _(u"tenseur cinématique 1, composante XZ"),
    "XCIN1YY" : _(u"tenseur cinématique 1, composante YY"),
    "XCIN1YZ" : _(u"tenseur cinématique 1, composante YZ"),
    "XCIN1ZZ" : _(u"tenseur cinématique 1, composante ZZ"),
    "XCIN2XX" : _(u"tenseur cinématique 2, composante XX"),
    "XCIN2XY" : _(u"tenseur cinématique 2, composante XY"),
    "XCIN2XZ" : _(u"tenseur cinématique 2, composante XZ"),
    "XCIN2YY" : _(u"tenseur cinématique 2, composante YY"),
    "XCIN2YZ" : _(u"tenseur cinématique 2, composante YZ"),
    "XCIN2ZZ" : _(u"tenseur cinématique 2, composante ZZ"),
    "XCINXX" : _(u"tenseur cinématique, composante XX"),
    "XCINXY" : _(u"tenseur cinématique, composante XY"),
    "XCINXZ" : _(u"tenseur cinématique, composante XZ"),
    "XCINYY" : _(u"tenseur cinématique, composante YY"),
    "XCINYZ" : _(u"tenseur cinématique, composante YZ"),
    "XCINZZ" : _(u"tenseur cinématique, composante ZZ"),
    "XFLEX1" : _(u"GLRC_DAMAGE : tenseur d'écrouissage cinématique en flexion composante 1"),
    "XFLEX2" : _(u"GLRC_DAMAGE : tenseur d'écrouissage cinématique en flexion composante 2"),
    "XFLEX3" : _(u"GLRC_DAMAGE : tenseur d'écrouissage cinématique en flexion composante 3"),
    "XHXY1" : _(u"Hujeux : coordonnée du point de tangence à la surface de charge du mécanisme déviatoire du plan 3, composante 1"),
    "XHXY2" : _(u"Hujeux : coordonnée du point de tangence à la surface de charge du mécanisme déviatoire du plan 3, composante 2"),
    "XHXZ1" : _(u"Hujeux : coordonnée du point de tangence à la surface de charge du mécanisme déviatoire du plan 2, composante1"),
    "XHXZ2" : _(u"Hujeux : coordonnée du point de tangence à la surface de charge du mécanisme déviatoire du plan 2, composante2"),
    "XHYZ1" : _(u"Hujeux : coordonnée du point de tangence à la surface de charge du mécanisme déviatoire du plan 1, composante 1"),
    "XHYZ2" : _(u"Hujeux : coordonnée du point de tangence à la surface de charge du mécanisme déviatoire du plan 1, composante 2"),
    "XIP" : _(u"LETK : variable d'écrouissage élastoplastique"),
    "XIVP" : _(u"LETK : variable d'écrouissage viscoplastique"),
    "XMEMB1" : _(u"GLRC_DAMAGE : tenseur d'écrouissage cinématique en membrane composante 1"),
    "XMEMB2" : _(u"GLRC_DAMAGE : tenseur d'écrouissage cinématique en membrane composante 2"),
    "XMEMB3" : _(u"GLRC_DAMAGE : tenseur d'écrouissage cinématique en membrane composante 3"),
    "Y1" : _(u"coordonnée Y de la pointe de fissure après rupture par propagation,"),
    "Y2" : _(u"coordonnée Y de la pointe de fissure 2 lors de l'amorçage,"),
    "ZIRC1" : _(u"phase métallurgique zirconium variable interne 1"),
    "ZIRC2" : _(u"phase métallurgique zirconium variable interne 2"),
    "ZIRC3" : _(u"phase métallurgique zirconium variable interne 3"),
    "MEMOECRO" : _(u"CIN2_MEMO : variable relative à la mémoire d'écrouissage q"),
}
