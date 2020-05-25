# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

# person_in_charge: jean-michel.proix at edf.fr


def macr_cara_poutre_ops(self, MAILLAGE, SYME_Y, SYME_Z, GROUP_MA_BORD,
                         GROUP_MA, ORIG_INER, TABLE_CARA, **args):
    """
       Ecriture de la macro MACR_CARA_POUTRE
    """
    from code_aster.Cata.Syntax import _F
    import aster
    from Utilitai.Utmess import UTMESS, MasquerAlarme, RetablirAlarme
    #
    ier = 0
    # On importe les définitions des commandes a utiliser dans la macro
    # Le nom de la variable doit être obligatoirement le nom de la commande
    LIRE_MAILLAGE = self.get_cmd('LIRE_MAILLAGE')
    DEFI_GROUP = self.get_cmd('DEFI_GROUP')
    CREA_MAILLAGE = self.get_cmd('CREA_MAILLAGE')
    COPIER = self.get_cmd('COPIER')
    AFFE_MODELE = self.get_cmd('AFFE_MODELE')
    DEFI_MATERIAU = self.get_cmd('DEFI_MATERIAU')
    AFFE_MATERIAU = self.get_cmd('AFFE_MATERIAU')
    DEFI_FONCTION = self.get_cmd('DEFI_FONCTION')
    DEFI_CONSTANTE = self.get_cmd('DEFI_CONSTANTE')
    AFFE_CHAR_THER = self.get_cmd('AFFE_CHAR_THER')
    AFFE_CHAR_THER_F = self.get_cmd('AFFE_CHAR_THER_F')
    THER_LINEAIRE = self.get_cmd('THER_LINEAIRE')
    CALC_VECT_ELEM = self.get_cmd('CALC_VECT_ELEM')
    CALC_MATR_ELEM = self.get_cmd('CALC_MATR_ELEM')
    NUME_DDL = self.get_cmd('NUME_DDL')
    ASSE_VECTEUR = self.get_cmd('ASSE_VECTEUR')
    POST_ELEM = self.get_cmd('POST_ELEM')
    CALC_CHAMP = self.get_cmd('CALC_CHAMP')
    MACR_LIGN_COUPE = self.get_cmd('MACR_LIGN_COUPE')
    IMPR_TABLE = self.get_cmd('IMPR_TABLE')
    CREA_TABLE = self.get_cmd('CREA_TABLE')
    CALC_TABLE = self.get_cmd('CALC_TABLE')
    DETRUIRE = self.get_cmd('DETRUIRE')
    # La macro compte pour 1 dans la numérotation des commandes
    self.set_icmd(1)
    # Le concept sortant (de type table_sdaster) est nommé 'nomres' dans le
    # contexte de la macro
    self.DeclareOut('nomres', self.sd)
    #
    ImprTable = False
    #
    UNITE = args.get("UNITE") or 20
    if (MAILLAGE is not None):
        __nomlma = COPIER(CONCEPT=MAILLAGE)
    else:
        __nomlma = LIRE_MAILLAGE(UNITE=args['UNITE'], FORMAT=args['FORMAT'])
    #
    # Dans les tables on retrouve une ligne avec __nomlma.nom. Soit :
    #   - on remplace __nomlma.nom par NomMaillageNew.
    #   - on supprime la ligne

    NomMaillage = (None, __nomlma.get_name())
    if ('NOM' in args):
        NomMaillage = (args['NOM'], __nomlma.get_name())
    #
    #
    __nomamo = AFFE_MODELE(
        MAILLAGE=__nomlma,
        AFFE=_F(TOUT='OUI', PHENOMENE='MECANIQUE', MODELISATION='D_PLAN',), )

    __nomdma = DEFI_MATERIAU(ELAS=_F(E=1.0, NU=0., RHO=1.0),)

    __nomama = AFFE_MATERIAU(
        MAILLAGE=__nomlma, AFFE=_F(TOUT='OUI', MATER=__nomdma,),)
    #
    # L'utilisateur ne peut rien faire pour éviter ces "Alarmes" donc pas d'impression
    MasquerAlarme('CHARGES2_87')
    MasquerAlarme('CALCULEL_40')
    #
    #
    # calcul des caractéristiques géométriques de la section
    motsimps = {}
    if GROUP_MA:
        motsimps['GROUP_MA'] = GROUP_MA
    if SYME_Y:
        motsimps['SYME_X'] = SYME_Y
    if SYME_Z:
        motsimps['SYME_Y'] = SYME_Z
    motsimps['ORIG_INER'] = ORIG_INER
    mfact = _F(TOUT='OUI', **motsimps)
    __cageo = POST_ELEM(MODELE=__nomamo, CHAM_MATER=__nomama, CARA_GEOM=mfact)

    #
    # Création d'un modèle plan 2D thermique représentant la section
    # de la poutre car on doit résoudre des E.D.P. avec des laplaciens
    #
    # Calcul de la constante de torsion sur tout le maillage
    # du centre de torsion/cisaillement des coefficients de cisaillement
    # de l inertie de gauchissement
    # du rayon de torsion
    #
    if GROUP_MA_BORD and not GROUP_MA:
        # Transformation des GROUP_MA en GROUP_NO sur lesquels
        # on pourra appliquer des conditions de température imposée
        #
        # les groupes doivent exister
        collgrma = aster.getcolljev('%-8s.GROUPEMA' % __nomlma.nom)
        collgrma = list(map(lambda x: x.strip(), collgrma))
        if type(GROUP_MA_BORD) == str:
            l_group_ma_bord = [ GROUP_MA_BORD,  ]
        else:
            l_group_ma_bord = GROUP_MA_BORD
        for igr in l_group_ma_bord:
            if ( not igr.strip() in collgrma):
                UTMESS('F', 'POUTRE0_20',valk=[igr,'GROUP_MA_BORD'])
        if 'GROUP_MA_INTE' in args:
            if args['GROUP_MA_INTE'] is not None:
                if type(args['GROUP_MA_INTE']) == str:
                    l_group_ma_inte = [args['GROUP_MA_INTE'], ]
                else:
                    l_group_ma_inte = args['GROUP_MA_INTE']
                for igr in l_group_ma_inte:
                    if ( not igr.strip() in collgrma):
                        UTMESS('F', 'POUTRE0_20',valk=[igr,'GROUP_MA_INTE'])
        #
        motscles = {}
        if type(GROUP_MA_BORD) == str:
            motscles['CREA_GROUP_NO'] = _F(GROUP_MA=GROUP_MA_BORD,)
        else:
            motscles['CREA_GROUP_NO'] = []
            for grma in GROUP_MA_BORD:
                motscles['CREA_GROUP_NO'].append(_F(GROUP_MA=grma,))
        #
        __nomlma = DEFI_GROUP(reuse=__nomlma, MAILLAGE=__nomlma, **motscles)


        # Création d'un maillage identique au premier a ceci près
        # que les coordonnées sont exprimées dans le repère principal
        # d'inertie dont l'origine est le centre de gravite de la section
        __nomapi = CREA_MAILLAGE(
            MAILLAGE=__nomlma, REPERE=_F(TABLE=__cageo, NOM_ORIG='CDG', ), )

        # Affectation du phénomène 'thermique' au modèle en vue de
        # la construction d un opérateur laplacien sur ce modèle
        __nomoth = AFFE_MODELE(
            MAILLAGE=__nomapi,
            AFFE=_F(TOUT='OUI', PHENOMENE='THERMIQUE', MODELISATION='PLAN',), )

        # Pour la construction du laplacien, on définit un matériau dont les
        # caractéristiques thermiques sont : lambda = 1, rho*cp = 0
        __nomath = DEFI_MATERIAU(THER=_F(LAMBDA=1.0, RHO_CP=0.,),)

        # Définition d'un CHAM_MATER à partir du matériau précédent
        __chmath = AFFE_MATERIAU(MAILLAGE=__nomapi,AFFE=_F(TOUT='OUI', MATER=__nomath,),)

        # CALCUL DE LA CONSTANTE DE TORSION PAR RESOLUTION
        # D UN LAPLACIEN AVEC UN TERME SOURCE EGAL A -2
        # L INCONNUE ETANT NULLE SUR LE CONTOUR DE LA SECTION :
        #     LAPLACIEN(PHI) = -2 DANS LA SECTION
        #     PHI = 0 SUR LE CONTOUR :
        #------------------------------------------------------------
        #
        #  ON IMPOSE LA VALEUR 0 A L INCONNUE SCALAIRE SUR LE CONTOUR DE LA SECTION
        #  ET ON A UN TERME SOURCE EGAL A -2 DANS TOUTE LA SECTION
        #------------------------------------------------------------
        motscles = {}
        if 'GROUP_MA_INTE' in args:
            if args['GROUP_MA_INTE'] is not None:
                motscles['LIAISON_UNIF'] = _F(
                    GROUP_MA=args['GROUP_MA_INTE'], DDL='TEMP'),

        __chart1 = AFFE_CHAR_THER(MODELE=__nomoth,
                                  TEMP_IMPO=_F(GROUP_NO=GROUP_MA_BORD,
                                               TEMP=0.),
                                  SOURCE=_F(TOUT='OUI',
                                            SOUR=2.0),
                                  **motscles)

        # POUR CHAQUE TROU DE LA SECTION :
        # ON A IMPOSE QUE PHI EST CONSTANT SUR LE CONTOUR INTERIEUR
        # EN FAISANT LE LIAISON_UNIF DANS LE AFFE_CHAR_THER PRECEDENT
        # ON IMPOSE EN PLUS D(PHI)/DN = 2*AIRE(TROU)/L(TROU)
        # OU D/DN DESIGNE LA DERIVEE PAR RAPPORT A LA
        # NORMALE ET L DESIGNE LA LONGUEUR DU BORD DU TROU :
        if 'GROUP_MA_INTE' in args:
            lgmaint = args['GROUP_MA_INTE']
            if lgmaint is not None:
                __tbaire = POST_ELEM(
                    MODELE=__nomoth,
                    AIRE_INTERNE=_F(GROUP_MA_BORD=args['GROUP_MA_INTE'],),)

                motscles = {}
                motscles['FLUX_REP'] = []

                if type(lgmaint) == str:
                    motscles['FLUX_REP'] = _F(
                        GROUP_MA=args['GROUP_MA_INTE'], CARA_TORSION=__tbaire)
                else:
                    motscles['FLUX_REP'] = []
                    for grma in lgmaint:
                        motscles['FLUX_REP'].append(
                            _F(GROUP_MA=grma, CARA_TORSION=__tbaire),)
                __chart2 = AFFE_CHAR_THER(MODELE=__nomoth, **motscles)

        #------------------------------------------------------------
        # RESOLUTION DE LAPLACIEN(PHI) = -2
        # AVEC PHI = 0 SUR LE CONTOUR :
        motscles = {}
        motscles['EXCIT'] = [_F(CHARGE=__chart1,), ]
        if 'GROUP_MA_INTE' in args:
            if lgmaint is not None:
                motscles['EXCIT'].append(_F(CHARGE=__chart2,))
        __tempe1 = THER_LINEAIRE(
            MODELE=__nomoth,
            CHAM_MATER=__chmath,
            SOLVEUR=_F(STOP_SINGULIER='NON',),
            **motscles)

        #------------------------------------------------------------
        # CALCUL DU  CENTRE DE TORSION/CISAILLEMENT  -
        # ET DES COEFFICIENTS DE CISAILLEMENT :      -
        #
        # POUR LE CALCUL DES CONSTANTES DE CISAILLEMENT, ON VA DEFINIR
        # UN PREMIER TERME SOURCE, SECOND MEMBRE DE L EQUATION DE LAPLACE
        # PAR UNE FONCTION EGALE A Y :
        __fnsec1 = DEFI_FONCTION(
            NOM_PARA='X',
            VALE=(0., 0., 10., 10.),
            PROL_DROITE='LINEAIRE',
            PROL_GAUCHE='LINEAIRE',
        )

        __fnsec0 = DEFI_CONSTANTE(VALE=0.,)

        #------------------------------------------------------------
        # LE TERME SOURCE CONSTITUANT LE SECOND MEMBRE DE L ÉQUATION
        # DE LAPLACE EST PRIS ÉGAL A Y DANS TOUTE LA SECTION :
        mctimpo = {}
        if args['NOEUD'] is not None:
            if len( args['NOEUD'] ) != 1:
                UTMESS('F', 'POUTRE0_3')
            nthno = args['NOEUD'][0].strip()
            # nthno est-il dans le maillage ?
            nomnoe = aster.getvectjev('%-8s.NOMNOE' % __nomlma.nom)
            nomnoe = list(map(lambda x: x.strip(), nomnoe))
            if ( not nthno in nomnoe ):
                UTMESS('F', 'POUTRE0_9',valk=nthno)

            mctimpo['TEMP_IMPO'] = (_F(NOEUD=nthno, TEMP=__fnsec0))
        elif args['GROUP_NO'] is not None:
            if len( args['GROUP_NO'] ) != 1:
                UTMESS('F', 'POUTRE0_3')
            grthno = args['GROUP_NO'][0]
            #grthno = grthno[0]
            collgrno = aster.getcolljev('%-8s.GROUPENO' % __nomapi.nom)
            nomnoe = aster.getvectjev('%-8s.NOMNOE' % __nomapi.nom)
            # Plantage si grthno n'existe pas dans le maillage
            try:
                l_no = collgrno[grthno.ljust(24)]
            except:
                UTMESS('F', 'POUTRE0_8',valk=grthno)
            if len(l_no) != 1:
                UTMESS('F', 'POUTRE0_3')
            nthno = nomnoe[l_no[0] - 1]
            mctimpo['TEMP_IMPO'] = (_F(NOEUD=nthno, TEMP=__fnsec0))
        #
        __chart2 = AFFE_CHAR_THER_F(
            MODELE=__nomoth,
            SOURCE=_F(TOUT='OUI', SOUR=__fnsec1,),
            **mctimpo
        )

        #------------------------------------------------------------
        # RESOLUTION DE   LAPLACIEN(PHI) = -Y
        #                 AVEC D(PHI)/D(N) = 0 SUR LE CONTOUR :
        __tempe2 = THER_LINEAIRE(
            MODELE=__nomoth,
            CHAM_MATER=__chmath,
            EXCIT=_F(CHARGE=__chart2,),
            SOLVEUR=_F(STOP_SINGULIER='NON',),
        )

        #------------------------------------------------------------
        # POUR LE CALCUL DES CONSTANTES DE CISAILLEMENT, ON VA DEFINIR
        # UN PREMIER TERME SOURCE, SECOND MEMBRE DE L EQUATION DE LAPLACE
        # PAR UNE FONCTION EGALE A Z :
        __fnsec2 = DEFI_FONCTION(
            NOM_PARA='Y',
            VALE=(0., 0., 10., 10.),
            PROL_DROITE='LINEAIRE',
            PROL_GAUCHE='LINEAIRE',
        )

        #------------------------------------------------------------
        # LE TERME SOURCE CONSTITUANT LE SECOND MEMBRE DE L EQUATION
        # DE LAPLACE EST PRIS EGAL A Z DANS TOUTE LA SECTION :
        __chart3 = AFFE_CHAR_THER_F(
            MODELE=__nomoth,
            SOURCE=_F(TOUT='OUI', SOUR=__fnsec2,),
            **mctimpo
        )

        #------------------------------------------------------------
        # RESOLUTION DE   LAPLACIEN(PHI) = -Z
        #                 AVEC D(PHI)/D(N) = 0 SUR LE CONTOUR :
        __tempe3 = THER_LINEAIRE(
            MODELE=__nomoth,
            CHAM_MATER=__chmath,
            EXCIT=_F(CHARGE=__chart3,),
            SOLVEUR=_F(STOP_SINGULIER='NON',),
        )

        #------------------------------------------------------------
        # CALCUL DU RAYON DE TORSION :
        # CALCUL DU RAYON DE TORSION EXTERNE : rtext
        __tempe1 = CALC_CHAMP(
            reuse=__tempe1,
            RESULTAT=__tempe1,
            TOUT_ORDRE='OUI',
            THERMIQUE='FLUX_ELNO',
        )

        __flun = MACR_LIGN_COUPE(
                      RESULTAT=__tempe1,
                      NOM_CHAM='FLUX_ELNO',
                      LIGN_COUPE = _F(TYPE='GROUP_MA',
                                      MAILLAGE=__nomapi,
                                      TRAC_NOR='OUI',
                                      NOM_CMP=('FLUX', 'FLUY'),
                                      OPERATION='MOYENNE',
                                      INTITULE='FLUX_NORM',
                                      GROUP_MA=GROUP_MA_BORD,
                      ))
        __nomapi = DEFI_GROUP(reuse=__nomapi, MAILLAGE=__nomapi,
                          DETR_GROUP_NO=_F(NOM=GROUP_MA_BORD,))


        __m1 = abs(__flun['TRAC_NOR', 3])
        __m2 = abs(__flun['TRAC_NOR', 4])
        __rtext = max(__m1, __m2)

        #    CALCUL DU RAYON DE TORSION : rt
        #    rt = max ( rtext , 2*AIRE(TROU)/L(TROU) )
        if 'GROUP_MA_INTE' in args:
            if args['GROUP_MA_INTE'] is not None:
                if type(args['GROUP_MA_INTE']) == str:
                    l_group_ma_inte = [args['GROUP_MA_INTE'], ]
                else:
                    l_group_ma_inte = args['GROUP_MA_INTE']
                for i in range(0, len(l_group_ma_inte)):
                    __flun = MACR_LIGN_COUPE(
                                  RESULTAT=__tempe1,
                                  NOM_CHAM='FLUX_ELNO',
                                  LIGN_COUPE = _F(TYPE='GROUP_MA',
                                                  MAILLAGE=__nomapi,
                                                  TRAC_NOR='OUI',
                                                  NOM_CMP=('FLUX', 'FLUY'),
                                                  OPERATION='MOYENNE',
                                                  INTITULE='FLUX_NORM',
                                                  GROUP_MA=l_group_ma_inte[i],
                                  ))
                    __nomapi = DEFI_GROUP(reuse=__nomapi, MAILLAGE=__nomapi,
                                      DETR_GROUP_NO=_F(NOM=l_group_ma_inte[i],))

                    __m1 = (
                        abs(__flun['TRAC_NOR', 3]) + abs(__flun['TRAC_NOR', 4])) / 2.
                    if __m1 > __rtext:
                        __rtext = __m1
        #
        __rt = __rtext

        #------------------------------------------------------------
        # CALCUL DE LA CONSTANTE DE TORSION :
        motscles = {}
        if 'GROUP_MA_INTE' in args:
            lgmaint = args['GROUP_MA_INTE']
            if lgmaint is not None:
                motscles['CARA_POUTRE'] = _F(CARA_GEOM=__cageo, LAPL_PHI=__tempe1, RT=__rt,
                                        TOUT='OUI', OPTION='CARA_TORSION',
                                        GROUP_MA_INTE=args['GROUP_MA_INTE'],)
            else:
                motscles['CARA_POUTRE'] = _F(CARA_GEOM=__cageo, LAPL_PHI=__tempe1, RT=__rt,
                                        TOUT='OUI', OPTION='CARA_TORSION', )
        #
        __cator = POST_ELEM(MODELE=__nomoth, CHAM_MATER=__chmath, **motscles)

        #------------------------------------------------------------
        # CALCUL DES COEFFICIENTS DE CISAILLEMENT ET DES COORDONNEES DU
        # CENTRE DE CISAILLEMENT/TORSION :
        __cacis = POST_ELEM(
            MODELE=__nomoth,
            CHAM_MATER=__chmath,
            CARA_POUTRE=_F(CARA_GEOM=__cator, LAPL_PHI_Y=__tempe2, LAPL_PHI_Z=__tempe3,
                           TOUT='OUI', OPTION='CARA_CISAILLEMENT',),)

        #------------------------------------------------------------
        #  CALCUL DE L INERTIE DE GAUCHISSEMENT PAR RESOLUTION  DE  -
        #     LAPLACIEN(OMEGA) = 0     DANS LA SECTION              -
        #     AVEC D(OMEGA)/D(N) = Z*NY-Y*NZ   SUR LE               -
        #     CONTOUR DE LA SECTION                                 -
        #     NY ET NZ SONT LES COMPOSANTES DU VECTEUR N NORMAL     -
        #     A CE CONTOUR                                          -
        #     ET SOMME_S(OMEGA.DS) = 0                              -
        #     OMEGA EST LA FONCTION DE GAUCHISSEMENT                -
        #     L INERTIE DE GAUCHISSEMENT EST SOMME_S(OMEGA**2.DS)   -
        # -----------------------------------------------------------
        #
        #  CREATION D UN MAILLAGE DONT LES COORDONNEES SONT EXPRIMEES
        #  DANS LE REPERE PRINCIPAL D INERTIE MAIS AVEC COMME ORIGINE
        #  LE CENTRE DE TORSION DE LA SECTION, ON VA DONC UTILISER
        #  LE MAILLAGE DE NOM NOMAPI DONT LES COORDONNEES SONT
        #  EXPRIMEES DANS LE REPERE PRINCIPAL D'INERTIE, L'ORIGINE
        #  ETANT LE CENTRE DE GRAVITE DE LA SECTION (QUI EST DONC A CHANGER)
        __nomapt = CREA_MAILLAGE(
            MAILLAGE=__nomapi,
            REPERE=_F(TABLE=__cacis, NOM_ORIG='TORSION',))

        #------------------------------------------------------------
        # AFFECTATION DU PHENOMENE 'THERMIQUE' AU MODELE EN VUE DE
        # LA CONSTRUCTION D UN OPERATEUR LAPLACIEN SUR CE MODELE :
        __nomot2 = AFFE_MODELE(
            MAILLAGE=__nomapt,
            AFFE=_F(TOUT='OUI', PHENOMENE='THERMIQUE', MODELISATION='PLAN', ))

        # DEFINITION D UN CHAM_MATER A PARTIR DU MATERIAU PRECEDENT :
        __chmat2 = AFFE_MATERIAU(
            MAILLAGE=__nomapt,
            AFFE=_F(TOUT='OUI', MATER=__nomath, ), )

        # POUR LE CALCUL DE L INERTIE DE GAUCHISSEMENT, ON VA DEFINIR
        # LA COMPOSANTE SELON Y DU FLUX A IMPOSER SUR LE CONTOUR
        # PAR UNE FONCTION EGALE A -X :
        __fnsec3 = DEFI_FONCTION(
            NOM_PARA='X',
            VALE=(0., 0., 10., -10.),
            PROL_DROITE='LINEAIRE',
            PROL_GAUCHE='LINEAIRE',
        )

        # POUR LE CALCUL DE L INERTIE DE GAUCHISSEMENT, ON VA DEFINIR
        # LA COMPOSANTE SELON X DU FLUX A IMPOSER SUR LE CONTOUR
        # PAR UNE FONCTION EGALE A Y :
        __fnsec4 = DEFI_FONCTION(
            NOM_PARA='Y',
            VALE=(0., 0., 10., 10.),
            PROL_DROITE='LINEAIRE',
            PROL_GAUCHE='LINEAIRE',
        )

        # DANS LE BUT D IMPOSER LA RELATION LINEAIRE ENTRE DDLS
        #  SOMME_SECTION(OMEGA.DS) = 0 ( CETTE CONDITION
        # VENANT DE L EQUATION D EQUILIBRE SELON L AXE DE LA POUTRE
        # N = 0, N ETANT L EFFORT NORMAL)
        # ON CALCULE LE VECTEUR DE CHARGEMENT DU A UN TERME SOURCE EGAL
        # A 1., LES TERMES DE CE VECTEUR SONT EGAUX A
        # SOMME_SECTION(NI.DS) ET SONT DONC LES COEFFICIENTS DE
        # LA RELATION LINEAIRE A IMPOSER.
        # ON DEFINIT DONC UN CHARGEMENT DU A UN TERME SOURCE EGAL A 1 :
        __chart4 = AFFE_CHAR_THER(
            MODELE=__nomot2, SOURCE=_F(TOUT='OUI', SOUR=1.0),)

        # ON CALCULE LE VECT_ELEM DU AU CHARGEMENT PRECEDENT
        # IL S AGIT DES VECTEURS ELEMENTAIRES DONT LE TERME
        # AU NOEUD COURANT I EST EGAL A SOMME_SECTION(NI.DS) :
        __vecel = CALC_VECT_ELEM(CHARGE=__chart4, OPTION='CHAR_THER')

        # ON CALCULE LE MATR_ELEM DES MATRICES ELEMENTAIRES
        # DE CONDUCTIVITE UNIQUEMENT POUR GENERER LE NUME_DDL
        # SUR-LEQUEL S APPUIERA LE CHAMNO UTILISE POUR ECRIRE LA
        # RELATION LINEAIRE ENTRE DDLS :
        __matel = CALC_MATR_ELEM(
            MODELE=__nomot2,
            CHAM_MATER=__chmat2, CHARGE=__chart4, OPTION='RIGI_THER',)

        # ON DEFINIT LE NUME_DDL ASSOCIE AU MATR_ELEM DEFINI
        # PRECEDEMMENT POUR CONSTRUIRE LE CHAMNO UTILISE POUR ECRIRE LA
        # RELATION LINEAIRE ENTRE DDLS :
        __numddl = NUME_DDL(MATR_RIGI=__matel,)

        # ON CONSTRUIT LE CHAMNO QUI VA ETRE UTILISE POUR ECRIRE LA
        # RELATION LINEAIRE ENTRE DDLS :
        __chamno = ASSE_VECTEUR(VECT_ELEM=__vecel, NUME_DDL=__numddl,)

        # ON IMPOSE LA RELATION LINEAIRE ENTRE DDLS
        #  SOMME_SECTION(OMEGA.DS) = 0 ( CETTE CONDITION
        # VENANT DE L EQUATION D EQUILIBRE SELON L AXE DE LA POUTRE
        # N = 0, N ETANT L EFFORT NORMAL)
        # POUR IMPOSER CETTE RELATION ON PASSE PAR LIAISON_CHAMNO,
        # LES TERMES DU CHAMNO (I.E. SOMME_SECTION(NI.DS))
        # SONT LES COEFFICIENTS DE LA RELATION LINEAIRE :
        __chart5 = AFFE_CHAR_THER(
            MODELE=__nomot2,
            LIAISON_CHAMNO=_F(CHAM_NO=__chamno, COEF_IMPO=0.),)

        # LE CHARGEMENT EST UN FLUX REPARTI NORMAL AU CONTOUR
        # DONT LES COMPOSANTES SONT +Z (I.E. +Y) ET -Y (I.E. -X)
        # SELON LA DIRECTION NORMALE AU CONTOUR :
        __chart6 = AFFE_CHAR_THER_F(
            MODELE=__nomot2,
            FLUX_REP=_F(GROUP_MA=GROUP_MA_BORD, FLUX_X=__fnsec4, FLUX_Y=__fnsec3,),)

        # RESOLUTION DE     LAPLACIEN(OMEGA) = 0
        # AVEC D(OMEGA)/D(N) = Z*NY-Y*NZ   SUR LE CONTOUR DE LA SECTION
        # ET SOMME_SECTION(OMEGA.DS) = 0 ( CETTE CONDITION
        # VENANT DE L EQUATION D EQUILIBRE SELON L AXE DE LA POUTRE
        # N = 0, N ETANT L EFFORT NORMAL)  :
        __tempe4 = THER_LINEAIRE(
            MODELE=__nomot2,
            CHAM_MATER=__chmat2,
            EXCIT=(_F(CHARGE=__chart5,), _F(CHARGE=__chart6,),),
            SOLVEUR=_F(STOP_SINGULIER='NON', METHODE='LDLT',),)

        # CALCUL DE L INERTIE DE GAUCHISSEMENT :
        __tabtmp = POST_ELEM(
            MODELE=__nomot2,
            CHAM_MATER=__chmat2,
            CARA_POUTRE=_F(
                CARA_GEOM=__cacis, LAPL_PHI=__tempe4, TOUT='OUI', OPTION='CARA_GAUCHI'),
        )

    # ==================================================================
    # = CALCUL DE LA CONSTANTE DE TORSION SUR CHAQUE GROUPE            =
    # =     ET DU RAYON DE TORSION SUR CHAQUE GROUPE                   =
    # =        DU  CENTRE DE TORSION/CISAILLEMENT                      =
    # =        DES COEFFICIENTS DE CISAILLEMENT                        =
    # ==================================================================
    if GROUP_MA_BORD and GROUP_MA:
        # CALCUL DES CARACTERISTIQUES GEOMETRIQUES DE LA SECTION :
        l_group_ma_bord = GROUP_MA_BORD
        l_group_ma = GROUP_MA
        l_noeud = None
        #
        if len(l_group_ma) != len(l_group_ma_bord):
            UTMESS('F', 'POUTRE0_1')
        #
        # les groupes doivent exister
        collgrma = aster.getcolljev('%-8s.GROUPEMA' % __nomlma.nom)
        collgrma = list(map(lambda x: x.strip(), collgrma))
        for igr in l_group_ma_bord:
            if ( not igr.strip() in collgrma):
                UTMESS('F', 'POUTRE0_20',valk=[igr,'GROUP_MA_BORD'])
        #
        for igr in GROUP_MA:
            if ( not igr.strip() in collgrma):
                UTMESS('F', 'POUTRE0_20',valk=[igr,'GROUP_MA'])
        #
        if 'GROUP_MA_INTE' in args:
            if args['GROUP_MA_INTE'] is not None:
                if type(args['GROUP_MA_INTE']) == str:
                    l_group_ma_inte = [args['GROUP_MA_INTE'], ]
                else:
                    l_group_ma_inte = args['GROUP_MA_INTE']
                for igr in l_group_ma_inte:
                    if ( not igr.strip() in collgrma):
                        UTMESS('F', 'POUTRE0_20',valk=[igr,'GROUP_MA_INTE'])

        if args['NOEUD'] is not None:
            l_noeud = list(map(lambda x: x.strip(), args['NOEUD'] ))
            if (len(l_group_ma) != len(l_noeud)):
                UTMESS('F', 'POUTRE0_2')
            # Les noeuds doivent faire partie du maillage
            nomnoe = aster.getvectjev('%-8s.NOMNOE' % __nomlma.nom)
            nomnoe = list(map(lambda x: x.strip(), nomnoe))
            for ino in l_noeud:
                if ( not ino in nomnoe ):
                    UTMESS('F', 'POUTRE0_9',valk=ino)
        elif args['GROUP_NO'] is not None:
            collgrno = aster.getcolljev('%-8s.GROUPENO' % __nomlma.nom)
            nomnoe = aster.getvectjev('%-8s.NOMNOE' % __nomlma.nom)
            l_nu_no = []
            for grno in args['GROUP_NO']:
                try:
                    l_nu_no.extend(collgrno[grno.ljust(24)])
                except:
                    UTMESS('F', 'POUTRE0_8',valk=grno)
            l_noeud = [nomnoe[no_i - 1] for no_i in l_nu_no]
            if (len(l_group_ma) != len(l_noeud)): UTMESS('F', 'POUTRE0_5')

        # Si len(l_group_ma_bord) > 1, alors il faut donner : 'LONGUEUR', 'MATERIAU', 'LIAISON'
        if ( len(l_group_ma_bord) > 1 ):
            if ( (args['LONGUEUR'] is None) or (args['MATERIAU'] is None) or (args['LIAISON'] is None) ):
                UTMESS('F', 'POUTRE0_6')
        else:
            if ( (args['LONGUEUR'] is not None) or (args['MATERIAU'] is not None) or (args['LIAISON'] is not None) ):
                UTMESS('A', 'POUTRE0_7')


        __catp2 = __cageo
        for i in range(0, len(l_group_ma_bord)):
            # TRANSFORMATION DES GROUP_MA EN GROUP_NO SUR-LESQUELS
            # ON POURRA APPLIQUER DES CONDITIONS DE TEMPERATURE IMPOSEE :
            __nomlma = DEFI_GROUP(reuse=__nomlma, MAILLAGE=__nomlma,
                                  DETR_GROUP_NO=_F(NOM=l_group_ma_bord[i],),
                                  CREA_GROUP_NO=_F(GROUP_MA=l_group_ma_bord[i],))

            # CREATION D UN MAILLAGE IDENTIQUE AU PREMIER A CECI PRES
            # QUE LES COORDONNEES SONT EXPRIMEES DANS LE REPERE PRINCIPAL
            # D INERTIE DONT L ORIGINE EST LE CENTRE DE GRAVITE DE LA SECTION :
            __nomapi = CREA_MAILLAGE(
                MAILLAGE=__nomlma,
                REPERE=_F(TABLE=__cageo, NOM_ORIG='CDG', GROUP_MA=l_group_ma[i],), )

            # AFFECTATION DU PHENOMENE 'THERMIQUE' AU MODELE EN VUE DE
            # LA CONSTRUCTION D UN OPERATEUR LAPLACIEN SUR CE MODELE :
            __nomoth = AFFE_MODELE(
                MAILLAGE=__nomapi,
                AFFE=_F(GROUP_MA=l_group_ma[i], PHENOMENE='THERMIQUE', MODELISATION='PLAN',),)

            # POUR LA CONSTRUCTION DU LAPLACIEN, ON  DEFINIT UN
            # PSEUDO-MATERIAU DONT LES CARACTERISTIQUES THERMIQUES SONT :
            # LAMBDA = 1, RHO*CP = 0 :
            __nomath = DEFI_MATERIAU(
                THER=_F(LAMBDA=1.0, RHO_CP=0.0,),)

            # DEFINITION D UN CHAM_MATER A PARTIR DU MATERIAU PRECEDENT :
            __chmath = AFFE_MATERIAU(
                MAILLAGE=__nomapi, AFFE=_F(TOUT='OUI', MATER=__nomath),)

            # CALCUL DE LA CONSTANTE DE TORSION PAR RESOLUTION         -
            # D UN LAPLACIEN AVEC UN TERME SOURCE EGAL A -2            -
            # L INCONNUE ETANT NULLE SUR LE CONTOUR DE LA SECTION :    -
            #    LAPLACIEN(PHI) = -2 DANS LA SECTION                   -
            #    PHI = 0 SUR LE CONTOUR :                              -
            #
            # ON IMPOSE LA VALEUR 0 A L INCONNUE SCALAIRE SUR LE CONTOUR
            # DE LA SECTION
            # ET ON A UN TERME SOURCE EGAL A -2 DANS TOUTE LA SECTION :
            __chart1 = AFFE_CHAR_THER(
                MODELE=__nomoth,
                TEMP_IMPO=_F(GROUP_NO=l_group_ma_bord[i], TEMP=0.0),
                SOURCE=_F(TOUT='OUI', SOUR=2.0),)

            # RESOLUTION DE   LAPLACIEN(PHI) = -2
            #                 AVEC PHI = 0 SUR LE CONTOUR :
            __tempe1 = THER_LINEAIRE(
                MODELE=__nomoth, CHAM_MATER=__chmath,
                EXCIT=_F(CHARGE=__chart1, ),
                SOLVEUR=_F(STOP_SINGULIER='NON',),)

            # ----------------------------------------------
            # CALCUL DU  CENTRE DE TORSION/CISAILLEMENT
            # ET DES COEFFICIENTS DE CISAILLEMENT :
            #
            # POUR LE CALCUL DES CONSTANTES DE CISAILLEMENT, ON VA DEFINIR
            # UN PREMIER TERME SOURCE, SECOND MEMBRE DE L EQUATION DE LAPLACE
            # PAR UNE FONCTION EGALE A Y :
            __fnsec1 = DEFI_FONCTION(
                NOM_PARA='X',
                VALE=(0., 0., 10., 10.),
                PROL_DROITE='LINEAIRE',
                PROL_GAUCHE='LINEAIRE',)

            __fnsec0 = DEFI_CONSTANTE(VALE=0.0,)

            # LE TERME SOURCE CONSTITUANT LE SECOND MEMBRE DE L EQUATION
            # DE LAPLACE EST PRIS EGAL A Y DANS TOUTE LA SECTION :
            __chart2 = AFFE_CHAR_THER_F(
                MODELE=__nomoth,
                TEMP_IMPO=_F(NOEUD=l_noeud[i], TEMP=__fnsec0),
                SOURCE=_F(TOUT='OUI', SOUR=__fnsec1,),)

            # RESOLUTION DE   LAPLACIEN(PHI) = -Y
            #                 AVEC D(PHI)/D(N) = 0 SUR LE CONTOUR :
            __tempe2 = THER_LINEAIRE(
                MODELE=__nomoth, CHAM_MATER=__chmath,
                EXCIT=_F(CHARGE=__chart2, ),
                SOLVEUR=_F(STOP_SINGULIER='NON',),)

            # POUR LE CALCUL DES CONSTANTES DE CISAILLEMENT, ON VA DEFINIR
            # UN PREMIER TERME SOURCE, SECOND MEMBRE DE L EQUATION DE LAPLACE
            # PAR UNE FONCTION EGALE A Z :
            __fnsec2 = DEFI_FONCTION(
                NOM_PARA='Y',
                VALE=(0., 0., 10., 10.),
                PROL_DROITE='LINEAIRE',
                PROL_GAUCHE='LINEAIRE',)

            # LE TERME SOURCE CONSTITUANT LE SECOND MEMBRE DE L EQUATION
            # DE LAPLACE EST PRIS EGAL A Z DANS TOUTE LA SECTION :
            __chart3 = AFFE_CHAR_THER_F(
                MODELE=__nomoth,
                TEMP_IMPO=_F(NOEUD=l_noeud[i], TEMP=__fnsec0),
                SOURCE=_F(TOUT='OUI', SOUR=__fnsec2,), )

            # RESOLUTION DE   LAPLACIEN(PHI) = -Z
            #                 AVEC D(PHI)/D(N) = 0 SUR LE CONTOUR :
            __tempe3 = THER_LINEAIRE(
                MODELE=__nomoth,
                CHAM_MATER=__chmath,
                EXCIT=_F(CHARGE=__chart3, ),
                SOLVEUR=_F(STOP_SINGULIER='NON',),)

            # CALCUL DU RAYON DE TORSION :
            # CALCUL DU RAYON DE TORSION EXTERNE : rtext
            __tempe1 = CALC_CHAMP(
                reuse=__tempe1,
                RESULTAT=__tempe1,
                TOUT_ORDRE='OUI',
                THERMIQUE='FLUX_ELNO',
            )

            __flun = MACR_LIGN_COUPE(
                          RESULTAT=__tempe1,
                          NOM_CHAM='FLUX_ELNO',
                          LIGN_COUPE = _F(TYPE='GROUP_MA',
                                          MAILLAGE=__nomapi,
                                          TRAC_NOR='OUI',
                                          NOM_CMP=('FLUX', 'FLUY'),
                                          OPERATION='MOYENNE',
                                          INTITULE='FLUX_NORM',
                                          GROUP_MA=l_group_ma_bord[i],
                          ))
            __nomapi = DEFI_GROUP(reuse=__nomapi, MAILLAGE=__nomapi,
                              DETR_GROUP_NO=_F(NOM=l_group_ma_bord[i],))

            __m1 = abs(__flun['TRAC_NOR', 3])
            __m2 = abs(__flun['TRAC_NOR', 4])
            __rtext = max(__m1, __m2)

            # CALCUL DU RAYON DE TORSION : rt
            # rt = max ( rtext , 2*AIRE(TROU)/L(TROU) )
            if 'GROUP_MA_INTE' in args:
                if args['GROUP_MA_INTE'] is not None:
                    if type(args['GROUP_MA_INTE']) == str:
                        l_group_ma_inte = [args['GROUP_MA_INTE'], ]
                    else:
                        l_group_ma_inte = args['GROUP_MA_INTE']

                    for j in range(0, len(l_group_ma_inte)):
                        __flun = MACR_LIGN_COUPE(
                                      RESULTAT=__tempe1,
                                      NOM_CHAM='FLUX_ELNO',
                                      LIGN_COUPE = _F(TYPE='GROUP_MA',
                                                      MAILLAGE=__nomapi,
                                                      TRAC_NOR='OUI',
                                                      NOM_CMP=('FLUX', 'FLUY'),
                                                      OPERATION='MOYENNE',
                                                      INTITULE='FLUX_NORM',
                                                      GROUP_MA=l_group_ma_inte[i],
                                      ))
                        __nomapi = DEFI_GROUP(reuse=__nomapi, MAILLAGE=__nomapi,
                                          DETR_GROUP_NO=_F(NOM=l_group_ma_inte[i],))
                        __m1 = (abs(__flun['TRAC_NOR', 3]) + abs(__flun['TRAC_NOR', 4])) / 2.0
                        if __m1 > __rtext:  __rtext = __m1

            __rt = __rtext

            # CALCUL DE LA CONSTANTE DE TORSION :
            __catp1 = POST_ELEM(
                MODELE=__nomoth,
                CHAM_MATER=__chmath,
                CARA_POUTRE=_F(CARA_GEOM=__catp2, LAPL_PHI=__tempe1,
                               RT=__rt, GROUP_MA=l_group_ma[i], OPTION='CARA_TORSION'),
            )

            # CALCUL DES COEFFICIENTS DE CISAILLEMENT ET DES COORDONNEES DU
            # CENTRE DE CISAILLEMENT/TORSION :
            if ( len(l_group_ma_bord) > 1 ):
                __catp2 = POST_ELEM(
                    MODELE=__nomoth,
                    CHAM_MATER=__chmath,
                    CARA_POUTRE=_F(CARA_GEOM=__catp1,
                               LAPL_PHI_Y=__tempe2, LAPL_PHI_Z=__tempe3,
                               GROUP_MA=l_group_ma[i],
                               LONGUEUR=args['LONGUEUR'],
                               MATERIAU=args['MATERIAU'],
                               LIAISON=args['LIAISON'],
                               OPTION='CARA_CISAILLEMENT',),
                )
            else:
                __nomtmp = DEFI_MATERIAU(ELAS=_F(E=1.0, NU=0.123, RHO=1.0),)
                __catp2 = POST_ELEM(
                    MODELE=__nomoth,
                    CHAM_MATER=__chmath,
                    CARA_POUTRE=_F(CARA_GEOM=__catp1,
                               LAPL_PHI_Y=__tempe2, LAPL_PHI_Z=__tempe3,
                               GROUP_MA =l_group_ma[i],
                               LONGUEUR = 123.0,
                               MATERIAU = __nomtmp,
                               LIAISON  = 'ENCASTREMENT',
                               OPTION   = 'CARA_CISAILLEMENT',),
                )
            #
        #
        dprod = __catp2.EXTR_TABLE().dict_CREA_TABLE()
        # On remplace dans le TITRE le nom du concept __catp2.nom par self.sd.nom
        if ('TITRE' in list(dprod.keys())):
            conceptOld = __catp2.nom
            conceptNew = self.sd.nom
            for ii in range(len(dprod['TITRE'])):
                zz = dprod['TITRE'][ii]
                if (conceptOld.strip() in zz):
                    dprod['TITRE'][ii] = zz.replace(conceptOld.strip(), conceptNew.strip())
        #
        dprod['TYPE_TABLE'] = 'TABLE_CONTAINER'
        __tabtmp = CREA_TABLE(**dprod)
    #
    if not GROUP_MA_BORD:

        __tabtmp = POST_ELEM(
            MODELE=__nomamo, CHAM_MATER=__nomama, CARA_GEOM=mfact
        )

    #
    # mise au propre de la table
    #

    # On enlève la ligne avec LIEU='-' et donc les colonnes TYPE_OBJET, NOM_SD
    # on utilise TYPE_TABLE pour forcer le type à table_sdaster et plus table_container
    nomres = CALC_TABLE(
            TABLE=__tabtmp, TYPE_TABLE='TABLE',
            ACTION=_F(
                OPERATION='FILTRE', NOM_PARA='LIEU', CRIT_COMP='NON_VIDE'),
        )

    NomMaillageNew, NomMaillageOld = NomMaillage

    # Suppression de la référence à NomMaillageOld, remplacé par NOM = NomMaillageNew
    # Si TABLE_CARA == "OUI" et GROUP_MA la ligne est supprimée

    if not (TABLE_CARA == "OUI" and GROUP_MA):

        TabTmp = nomres.EXTR_TABLE()
        for ii in range(len(TabTmp.rows)):
            zz = TabTmp.rows[ii]['LIEU']
            if (zz.strip() == NomMaillageOld):
                TabTmp.rows[ii]['LIEU'] = NomMaillageNew
        #
        TabTmp = TabTmp.dict_CREA_TABLE()
    else:
        # Une ligne avec LIEU=NomMaillageOld ==> on la supprime
        nomres = CALC_TABLE(
            reuse=nomres, TABLE=nomres,
            ACTION=_F(OPERATION='FILTRE', NOM_PARA='LIEU',
                      CRIT_COMP='NE', VALE_K=NomMaillageOld),
        )
        TabTmp = nomres.EXTR_TABLE().dict_CREA_TABLE()

    DETRUIRE(CONCEPT=_F(NOM=nomres), INFO=1)
    nomres = CREA_TABLE(**TabTmp)

    #
    # On retourne une table exploitable par AFFE_CARA_ELEM, avec seulement les
    # caractéristiques nécessaires
    if (TABLE_CARA == "OUI"):

        #
        if GROUP_MA_BORD and not GROUP_MA:
            nomres = CALC_TABLE(
                TABLE=nomres,
                reuse=nomres,
                ACTION=(
                    _F(OPERATION='EXTR', NOM_PARA=('LIEU', 'A', 'IY', 'IZ', 'AY',
                                                   'AZ', 'EY', 'EZ', 'JX', 'JG', 'IYR2', 'IZR2', 'RY', 'RZ', 'RT',
                                                   'ALPHA','CDG_Y','CDG_Z'),),
                ),
            )
        elif GROUP_MA_BORD and GROUP_MA:
            nomres = CALC_TABLE(
                TABLE=nomres,
                reuse=nomres,
                ACTION=(
                    _F(OPERATION='EXTR', NOM_PARA=('LIEU', 'A', 'IY', 'IZ', 'AY',
                                                   'AZ', 'EY', 'EZ', 'JX', 'IYR2', 'IZR2', 'RY', 'RZ', 'RT',
                                                   'ALPHA','CDG_Y','CDG_Z'),),
                ),
            )
        else:
            nomres = CALC_TABLE(
                TABLE=nomres,
                reuse=nomres,
                ACTION=(
                    _F(OPERATION='EXTR', NOM_PARA=('LIEU', 'A', 'IY', 'IZ', 'IYR2', 'IZR2', 'RY', 'RZ',
                                                   'ALPHA','CDG_Y','CDG_Z'),),
                ),
            )
        #
        # Validation des résultats qui doivent toujours être >=0
        TabTmp = nomres.EXTR_TABLE()
        for ii in range(len(TabTmp.rows)):
            ligne = TabTmp.rows[ii]
            # on recherche la bonne ligne
            if (ligne['LIEU'].strip() == NomMaillageNew):
                paras = TabTmp.para
                # Vérification des grandeurs qui doivent toujours rester positive
                Lparas = ('A', 'IY', 'IZ', 'AY', 'AZ', 'JX', 'JG', )
                iergd = 0
                for unpara in Lparas:
                    if ( unpara in paras ):
                        if ( ligne[unpara] <=0 ): iergd += 1
                if ( iergd != 0):
                    if ( not ImprTable ): IMPR_TABLE(TABLE=nomres)
                    ImprTable = True
                    for unpara in Lparas:
                        if ( unpara in paras ):
                            if ( ligne[unpara] <= 0 ):
                                UTMESS('E', 'POUTRE0_10',valk=unpara, valr=ligne[unpara])
                    UTMESS('F', 'POUTRE0_11')
                #
                # Vérification que le CDG est l'origine du maillage
                cdgy = ligne['CDG_Y']; cdgz = ligne['CDG_Z']
                dcdg = (cdgy*cdgy + cdgz*cdgz)/ligne['A']
                if ( dcdg > 1.0E-08 ):
                    if ( not ImprTable ): IMPR_TABLE(TABLE=nomres)
                    ImprTable = True
                    UTMESS('A', 'POUTRE0_12',valr=[cdgy,cdgz])
                # Vérification que la section n'est pas tournée
                alpha = ligne['ALPHA']
                if ( abs(alpha) > 0.001 ):
                    if ( not ImprTable ): IMPR_TABLE(TABLE=nomres)
                    ImprTable = True
                    UTMESS('A', 'POUTRE0_13',valr=[alpha, -alpha])
    #
    # On retourne une table contenant toutes les caractéristiques calculées
    else:

        if GROUP_MA_BORD and not GROUP_MA:
            nomres = CALC_TABLE(
                TABLE=nomres,
                reuse=nomres,
                ACTION=(
                    _F(OPERATION='EXTR', NOM_PARA=('LIEU', 'ENTITE', 'A_M', 'CDG_Y_M', 'CDG_Z_M', 'IY_G_M',
                                                   'IZ_G_M', 'IYZ_G_M', 'Y_MAX', 'Z_MAX', 'Y_MIN', 'Z_MIN', 'R_MAX',
                                                   'A', 'CDG_Y', 'CDG_Z', 'IY_G', 'IZ_G', 'IYZ_G', 'IY',
                                                   'IZ', 'ALPHA', 'Y_P', 'Z_P', 'IY_P', 'IZ_P', 'IYZ_P', 'JX',
                                                   'AY', 'AZ', 'EY', 'EZ', 'PCTY', 'PCTZ', 'JG', 'KY', 'KZ', 'IYR2_G',
                                                   'IZR2_G', 'IYR2', 'IZR2', 'IYR2_P', 'IZR2_P', 'RY', 'RZ', 'RT',),),
                ),
            )
        elif GROUP_MA_BORD and GROUP_MA:
            nomres = CALC_TABLE(
                TABLE=nomres,
                reuse=nomres,
                ACTION=(
                    _F(OPERATION='EXTR', NOM_PARA=('LIEU', 'ENTITE', 'A_M', 'CDG_Y_M', 'CDG_Z_M', 'IY_G_M',
                                                   'IZ_G_M', 'IYZ_G_M', 'Y_MAX', 'Z_MAX', 'Y_MIN', 'Z_MIN', 'R_MAX',
                                                   'A', 'CDG_Y', 'CDG_Z', 'IY_G', 'IZ_G', 'IYZ_G', 'IY',
                                                   'IZ', 'ALPHA', 'Y_P', 'Z_P', 'IY_P', 'IZ_P', 'IYZ_P', 'JX',
                                                   'AY', 'AZ', 'EY', 'EZ', 'PCTY', 'PCTZ', 'KY', 'KZ', 'IYR2_G',
                                                   'IZR2_G', 'IYR2', 'IZR2', 'IYR2_P', 'IZR2_P', 'RY', 'RZ', 'RT',),),
                ),
            )
        else:
            nomres = CALC_TABLE(
                TABLE=nomres,
                reuse=nomres,
                ACTION=(
                    _F(OPERATION='EXTR', NOM_PARA=('LIEU', 'ENTITE', 'A_M', 'CDG_Y_M', 'CDG_Z_M', 'IY_G_M',
                                                   'IZ_G_M', 'IYZ_G_M', 'Y_MAX', 'Z_MAX', 'Y_MIN', 'Z_MIN', 'R_MAX',
                                                   'A', 'CDG_Y', 'CDG_Z', 'IY_G', 'IZ_G', 'IYZ_G', 'IY',
                                                   'IZ', 'ALPHA', 'Y_P', 'Z_P', 'IY_P', 'IZ_P', 'IYZ_P',
                                                   'IYR2_G', 'IZR2_G', 'IYR2', 'IZR2', 'IYR2_P', 'IZR2_P', 'RY', 'RZ',),),
                ),
            )
    #
    if ( not ImprTable ): IMPR_TABLE(TABLE=nomres)
    #
    RetablirAlarme('CHARGES2_87')
    RetablirAlarme('CALCULEL_40')
    return ier
