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

cata_msg = {

1 : _(u"""
Le fichier %(k1)s existe d�j�, on �crit � la suite.
"""),

2 : _(u"""
Il n'y a pas de r�gles d'interpolation pour LIST_PARA/LIST_RESU,
LIST_PARA/LIST_RESU ne peut donc appara�tre qu'une seule fois
et � la premi�re occurrence de COURBE.
"""),

3 : _(u"""
LIST_PARA et LIST_RESU n'ont pas la m�me taille.
"""),

4 : _(u"""
FONC_X/FONC_Y ne peuvent pas �tre des nappes !
"""),

5 : _(u"""
Au format 'TABLEAU', FONC_X/FONC_Y ne peut appara�tre qu'une seule fois
et � la premi�re occurrence de COURBE
"""),

6 : _(u"""
Il n'y a pas de r�gles d'interpolation pour ABSCISSE/ORDONNEE,
ABSCISSE/ORDONNEE ne peut donc appara�tre qu'une seule fois
et � la premi�re occurrence de COURBE.
"""),

7 : _(u"""
ABSCISSE et ORDONNEE n'ont pas la m�me taille.
"""),

8 : _(u"""
Format inconnu : %(k1)s
"""),

9 : _(u"""
Erreur lors de l'interpolation de la fonction '%(k1)s'.
"""),

10 : _(u"""sur la maille '%(k1)s'
"""),

11 : _(u"""
L'interpolation de la fonction '%(k1)s' n'est pas autoris�e.
Le type d'interpolation de la fonction vaut 'NON'

  -> Risque & Conseil :
    Voir le mot-cl� INTERPOL des commandes qui cr�ent des fonctions.
"""),

12 : _(u"""
Une erreur s'est produite dans la recherche de l'intervalle des abscisses contenant la valeur %(r1)f.

  -> Risque & Conseil :
    V�rifiez que le type d'interpolation de la fonction ne vaut pas 'NON'
    (mot-cl� INTERPOL des commandes qui cr�ent des fonctions).
"""),

13 : _(u"""
Le type de la fonction '%(k1)s' est inconnu.
Seules les fonctions, nappes, fonctions constantes peuvent �tre trait�es par %(k3)s.

  -> D�bogage :
      le type est '%(k2)s'
"""),

14 : _(u"""
Il n'y a pas assez de param�tres pour �valuer la fonction.
Seulement %(i1)d param�tre(s) sont fourni(s) alors que la fonction en r�clame %(i2)d.
"""),

15 : _(u"""
Il y a des doublons dans la liste des param�tres fournis :
   %(ktout)s
"""),

16 : _(u"""
Les param�tres n�cessaires sont :
   %(ktout)s
"""),

17 : _(u"""
Les param�tres fournis sont :
   %(ktout)s
"""),

18 : _(u"""
La fonction n'a m�me pas un point !
"""),

19 : _(u"""
On est hors du domaine de d�finition de la fonction.
On ne peut pas interpoler la fonction pour cette abscisse car le prolongement � gauche est exclus.
   abscisse demand�e              : %(r1)f
   borne inf�rieure des abscisses : %(r2)f

  -> Risque & Conseil :
    Voir le mot-cl� PROL_GAUCHE des commandes qui cr�ent des fonctions.
"""),

20 : _(u"""
On est hors du domaine de d�finition de la fonction.
On ne peut pas interpoler la fonction pour cette abscisse car le prolongement � droite est exclus.
   abscisse demand�e              : %(r1)f
   borne sup�rieure des abscisses : %(r2)f

  -> Risque & Conseil :
    Voir le mot-cl� PROL_DROITE des commandes qui cr�ent des fonctions.
"""),

21 : _(u"""
Erreur de programmation : type d'extrapolation inconnu.

  -> D�bogage :
      le type d'extrapolation est '%(k1)s'
"""),

22 : _(u"""
La fonction n'est d�finie qu'en un point. On ne peut pas l'interpoler en
plus d'un point si le prolongement n'est pas constant des deux cot�s.

  -> Risque & Conseil :
    Voir les mots-cl�s PROL_GAUCHE/PROL_DROITE des commandes qui cr�ent des fonctions.
"""),

23 : _(u"""
La fonction n'est d�finie qu'en un point. On ne peut pas l'interpoler ailleurs
qu'en ce point si le prolongement n'est pas constant des deux cot�s.

  -> Risque & Conseil :
    Voir les mots-cl�s PROL_GAUCHE/PROL_DROITE des commandes qui cr�ent des fonctions.
"""),

24 : _(u"""
On attend une fonction d'un seul param�tre.
La fonction '%(k1)s' est une fonction de %(i1)d param�tres.
"""),

25 : _(u"""
Le type de la fonction '%(k1)s' est inconnu.
Seules les fonctions, nappes, fonctions constantes et formules sont
trait�es par %(k3)s.

  -> D�bogage :
      le type est '%(k2)s'
"""),

26 : _(u"""
   abscisse demand�e : %(r1)f
   intervalle trouv� : [%(r2)f, %(r3)f]
"""),

27 : _(u"""
Un probl�me d'interpolation a �t� rencontr�.
%(k1)s

  -> Risque & Conseil :
      V�rifier les valeurs fournies derri�re le mot-cl� 'INTERPOL' lors
      de la cr�ation de cette(ces) fonction(s).

  -> D�bogage :
      %(k2)s
"""),

28 : _(u"""
Un probl�me concernant le nom des abscisses ou ordonn�es a �t� rencontr�.
Vous ne pouvez pas faire la transform�e de Fourier d'une fonction dont les abscisses sont des fr�quences,
   ou si la fonction est a valeurs complexes
Vous ne pouvez pas faire la transform�e de Fourier inverse d'une fonction dont les abscisses sont des instants,
   ou si la fonction est a valeur r�elle.
%(k1)s

  -> Risque & Conseil :
      V�rifier la valeur fournie derri�re les mots-cl�s 'NOM_PARA'/'NOM_RESU' lors
      de la cr�ation de cette(ces) fonction(s).

  -> D�bogage :
      %(k2)s
"""),

29 : _(u"""
Un probl�me concernant le prolongement de la (des) fonction(s) a �t� rencontr�.
%(k1)s

  -> Risque & Conseil :
      V�rifier la valeur fournie derri�re les mots-cl�s 'PROL_GAUCHE'/'PROL_DROITE'
      lors de la cr�ation de cette(ces) fonction(s).

  -> D�bogage :
      %(k2)s
"""),

30 : _(u"""
Une erreur s'est produite lors de l'op�ration.
%(k1)s

  -> D�bogage :
      %(k2)s

Remont�e d'erreur (pour aider � l'analyse) :

%(k3)s

"""),

31 : _(u"""
   G�n�ration par d�faut de 3 amortissements :[%(r1)f,%(r2)f,%(r3)f]
"""),

32 : _(u"""
   G�n�ration par d�faut de 150 fr�quences :
   %(k1)s
"""),

33 : _(u"""
   SPEC_OSCI, la norme ne peut �tre nulle.
"""),

34 : _(u"""
   SPEC_OSCI, le type de la fonction doit �tre ACCE.
"""),

35 : _(u"""
   SPEC_OSCI, seule la m�thode NIGAM est cod�e.
"""),

36 : _(u"""
   SPEC_OSCI, la m�thode choisie suppose des amortissements sous critiques,
   (inf�rieurs � 1).
"""),

37 : _(u"""
 calcul du MAX, la liste de fonctions n'est pas
 homog�ne en type (fonctions et nappes)
"""),

38 : _(u"""
 Calcul du MAX, la liste de fonctions n'est pas homog�ne
 en label NOM_PARA :%(k1)s
"""),

39 : _(u"""
 Calcul du MAX, la liste de fonctions n'est pas homog�ne
 en label NOM_RESU :%(k1)s
"""),

40 : _(u"""
 Intensit� spectrale, avant de calculer l'intensit� spectrale,
 il est prudent de v�rifier la norme de la nappe sur laquelle
 porte le calcul, ceci peut �tre une source d'erreurs.
"""),

41 : _(u"""
 Le fichier %(k1)s est introuvable.
"""),

42 : _(u"""
Erreur lors de la lecture des blocs de valeurs :
   %(k1)s
"""),

43 : _(u"""
Les fr�quences doivent �tre strictement positives.
"""),

44 : _(u"""
Les abscisses de la fonction %(k1)s ne sont pas strictement croissantes.
"""),

45 : _(u"""
Les abscisses de la fonction %(k1)s ne sont pas croissantes.
"""),

46 : _(u"""
Les abscisses de la fonction %(k1)s ne sont pas d�croissantes.
"""),

47 : _(u"""
Les abscisses de la fonction %(k1)s ne sont pas strictement d�croissantes.
"""),

48 : _(u"""
La fonction ou formule ne doit avoir qu'une ou deux variables.
"""),

49 : (u"""
La nappe ou formule a deux param�tres. Il faut renseigner le mot-cl� NOM_PARA_FONC
et soit VALE_PARA_FONC, soit LIST_PARA_FONC.
"""),

50 : _(u"""
Seules les formules � une variable peuvent �tre trait�es directement par IMPR_FONCTION.

La formule '%(k1)s' d�pend de %(i1)d param�tres.

  -> Risque & Conseil :
      - Si votre formule d�pend de 2 param�tres, utilisez CALC_FONC_INTERP pour produire
        une nappe puis appeler IMPR_FONCTION.
      - Si votre formule d�pend de 3 param�tres ou plus, vous devez d'abord cr�er une
        nouvelle formule � un seul param�tre (et appel� IMPR_FONCTION) ou � 2 param�tres
        et passer par CALC_FONC_INTERP puis IMPR_FONCTION.
"""),

52 : _(u"""
Conseils :
  Si le probl�me report� ci-dessus ressemble � 'NameError: 'XXX'...',
  v�rifiez que le param�tre 'XXX' fait bien partie des param�tres de d�finition de
  la formule (mot cl� FORMULE / NOM_PARA).
"""),

53 : _(u"""sur le noeud '%(k1)s'
"""),

54 : (u"""
Nombre de param�tres fournis : %(i1)d
Noms des param�tres fournis  : %(ktout)s
"""),

55 : _(u"""
  La liste des bornes de l'intervalle n'est pas coh�rente.
  Elle doit comporter un nombre pair de valeurs.
"""),

56 : _(u"""
  La borne inf�rieurs doit �tre inf�rieure � la borne sup�rieure.
  Veuillez revoir la saisie du mot-cl� INTERVALLE.
"""),

57 : _(u"""
Le polyn�me est de la forme :
    a[0] x^N + a[1] x^(N-1) + a[2] x^(N-2) + ... + a[N]

avec :
   %(k1)s

"""),

58 :_(u"""
Erreur lors de la v�rification des noms des param�tres.
Le nom du premier param�tre de la formule en entr�e (%(k1)s) est '%(k2)s'.

Or vous avez demand� � cr�er une nappe avec NOM_PARA='%(k3)s'.
"""),

59 :_(u"""
Erreur lors de la v�rification des noms des param�tres.
Le nom du param�tre de la nappe en entr�e (%(k1)s) est '%(k2)s'.

Or vous avez demand� � cr�er une nappe avec NOM_PARA='%(k3)s'.
"""),

60 :_(u"""
Erreur lors de la v�rification des noms des param�tres.
Le nom du deuxi�me param�tre de la formule en entr�e (%(k1)s) est '%(k2)s'.

Or vous avez demand� � cr�er une nappe avec NOM_PARA_FONC='%(k3)s'
"""),

61 :_(u"""
Erreur lors de la v�rification des noms des param�tres.
Le nom du param�tre des fonctions de la nappe en entr�e (%(k1)s) est '%(k2)s'.

Or vous avez demand� � cr�er une nappe avec NOM_PARA_FONC='%(k3)s'
"""),

62 : _(u"""
Cr�ation de la fonction '%(k1)s'.
"""),

63 : _(u"""
Cr�ation d'une fonction de la nappe '%(k1)s'.
"""),

64 : _(u"""
Les abscisses ne sont pas strictement monotones.
"""),

65 : _(u"""
Les abscisses ont �t� r�ordonn�es.
"""),

66 : _(u"""
L'ordre des abscisses a �t� invers�.
"""),

67 : _(u"""
Le nombre de valeurs est diff�rent du nombre de param�tres
"""),

68 : _(u"""
Les param�tres de la formule n'ont pas �t� fournis.
Param�tres manquants : %(k1)s
"""),

69 : _(u"""
Certains param�tres de la formule ont �t� fournis plusieurs fois.
Param�tres r�p�t�s : %(k1)s
"""),

70 : _(u"""
Erreur lors de l'�valuation de la formule.
La remont�e d'erreur suivante peut aider � comprendre o� se situe l'erreur :
%(k1)s
"""),

}
