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
# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

2 : _(u"""
 -> le nombre de mailles de votre maillage (%(i1)d) est sup�rieur
    � la limite de 9 999 999.
 -> Risque & Conseil : veuillez v�rifier le script GIBI qui vous a permis
    de g�n�rer le fichier MGIB.
"""),


3 : _(u"""
 le volume diff�re du volume use mais le nombre d'it�ration
  est sup�rieur a  %(i1)d
      volume use:  %(r1)f
  volume calcule:  %(r2)f
"""),

4 : _(u"""
 v�rifiez les param�tres d'usure pour le secteur  %(i1)d
"""),

5 : _(u"""
 v�rifiez les param�tres d'usure pour le secteur  %(i1)d
"""),

6 : _(u"""
 composante %(k1)s / point  %(i1)d
"""),

7 : _(u"""
   nombre de valeurs        =  %(i1)d
     %(r1)f, %(r2)f, ...
"""),

8 : _(u"""
   nombre de pics extraits   =  %(i1)d
     %(r1)f, %(r2)f, ...
"""),

9 : _(u"""
   nombre de cycles d�tect�s =  %(i1)d
"""),

10 : _(u"""
   %(i1)d  /  %(r1)f   %(r2)f
"""),

11 : _(u"""
   dommage en ce point/composante  =  %(r1)f
"""),

27 : _(u"""
 param�tres de calcul du dommage nombre de num�ros d'ordre  =  %(i1)d
 nombre de points de calcul =  %(i2)d
"""),

28 : _(u"""
 calcul     du      dommage en %(k1)s points  de   calcul  du    dommage %(k2)s
 composante(s) grandeur �quivalente %(k3)s
 m�thode  d'extraction  des    pics %(k4)s
 m�thode  de  comptage  des  cycles %(k5)s
 m�thode  de  calcul    du  dommage %(k6)s

"""),

29 : _(u"""
 maille:  %(k1)s
"""),

30 : _(u"""
 des mailles de peau ne s'appuient sur aucune maille support
    maille:  %(k1)s
"""),

31 : _(u"""

     ===== GROUP_MA ASTER / PHYSICAL GMSH =====

"""),

32 : _(u"""

  Le GROUP_MA GMSH GM10000 contient %(i1)d �l�ments :
"""),

33 : _(u"""
       %(i1)d �l�ments de type %(k1)s
"""),

34 : _(u"""
    La composante %(k1)s que vous avez renseign�e ne fait pas partie
    des composantes du champ � imprimer.
"""),

35 : _(u"""
    Le type de champ %(k1)s n'est pas autoris� avec les champs
    �l�mentaires %(k2)s.
    L'impression du champ sera effectu� avec le type SCALAIRE.
"""),

36 : _(u"""
 Veuillez utiliser IMPR_GENE pour l'impression
 de r�sultats en variables g�n�ralis�es.
"""),




38 : _(u"""
 Probl�me dans la lecture du fichier de maillage GMSH.
 Le fichier de maillage ne semble pas �tre un fichier de type GMSH :
 il manque la balise de d�but de fichier.
"""),

39 : _(u"""
 <I> Depuis la version 2.2.0 de GMSH il est possible de lire et �crire le format MED.
     Conseil : Utilisez plut�t GMSH avec MED comme format d'entr�e et de sortie.

"""),

40 : _(u"""
 <I> Le ficher de maillage GMSH est au format version %(i1)d.
"""),

41 : _(u"""
 Probl�me dans la lecture du fichier de maillage GMSH.
 Il manque la balise de fin de la liste de noeud.
"""),

42 : _(u"""
 Probl�me dans la lecture du fichier de maillage GMSH.
 Il manque la balise de d�but de la liste des �l�ments.
"""),

43 : _(u"""
 -> le nombre de mailles de votre maillage (%(i1)d) est sup�rieur
    � la limite de 9 999 999.
 -> Risque & Conseil : g�n�rez un fichier MED directement depuis GMSH.
"""),

44 : _(u"""
 Attention, l'origine de votre chemin est situ�e � l'int�rieur d'un �l�ment.
 Le premier segment �l�mentaire (origine - intersection avec la premi�re face)
 ne fera pas partie du chemin.
 Conseil : prolonger votre chemin � l'origine (mettre l'origine en dehors du
  maillage) si vous voulez que votre chemin ne soit pas tronqu�.
"""),

45 : _(u"""
 Attention, l'extr�mit� de votre chemin est situ�e � l'int�rieur d'un �l�ment.
 Le dernier segment �l�mentaire (intersection avec la derni�re face - extr�mit�)
 ne fera pas partie du chemin.
 Conseil : prolonger votre chemin � l'extr�mit� (mettre l'extr�mit� en dehors du
 maillage) si vous voulez que votre chemin ne soit pas tronqu�.
"""),

}
