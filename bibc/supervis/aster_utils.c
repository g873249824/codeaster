/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* MODIF aster_utils supervis  DATE 04/04/2011   AUTEUR COURTOIS M.COURTOIS */
/* ================================================================== */
/* COPYRIGHT (C) 1991 - 2011  EDF R&D              WWW.CODE-ASTER.ORG */
/*                                                                    */
/* THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR      */
/* MODIFY IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS     */
/* PUBLISHED BY THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE */
/* LICENSE, OR (AT YOUR OPTION) ANY LATER VERSION.                    */
/* THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL,    */
/* BUT WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF     */
/* MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU   */
/* GENERAL PUBLIC LICENSE FOR MORE DETAILS.                           */
/*                                                                    */
/* YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE  */
/* ALONG WITH THIS PROGRAM; IF NOT, WRITE TO : EDF R&D CODE_ASTER,    */
/*    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.     */
/* ================================================================== */

#include "aster_utils.h"


STRING_SIZE FStrlen( _IN char *fstr, _IN STRING_SIZE flen )
{
    /* Retourne la longueur (dernier caract�re non blanc) de "fstr".
     */
    STRING_SIZE n;
    _check_string_length(flen);
    n = flen;
    while ( n > 1 && fstr[n-1] == ' ') { n--; }
    return n;
}


char * MakeCStrFromFStr( _IN char *fstr, _IN STRING_SIZE flen )
{
    /* Alloue et retourne une chaine C (terminant par \0) �tant
     * la copie de la chaine Fortran sans les blancs finaux.
     * La chaine devra etre lib�r�e par l'appelant.
     */
    char *cstr = NULL;
    STRING_SIZE n;

    n = FStrlen(fstr, flen);
    cstr = (char*)malloc((n + 1) * sizeof(char));
    strncpy(cstr, fstr, n);
    cstr[n] = '\0';

    return cstr;
}


void CopyCStrToFStr( _INOUT char *fstr, _IN char *cstr, _IN STRING_SIZE flen )
{
    /* Copie une chaine C dans une chaine Fortran d�j� allou�e (de taille
     * flen) et sans ajout du '\0' � la fin.
     */
    STRING_SIZE i, n;
    n = strlen(cstr);
    if ( n > flen ) {
        n = flen;
    }
    for (i = 0; i < n; i++ ) {
        fstr[i] = cstr[i];
    }
    while ( i < flen ) {
        fstr[i] = ' ';
        i++;
    }
}


char * MakeFStrFromCStr( _IN char *cstr, _IN STRING_SIZE flen )
{
    /* Alloue et retourne une chaine C (compl�t�e par des blancs
     * destin�e � �tre transmise au Fortran, d'o� FStr) �tant
     * la copie de la chaine C.
     * La chaine devra etre lib�r�e par l'appelant.
     */
    char *fstr = NULL;
    fstr = (char*)malloc((flen + 1) * sizeof(char));
    CopyCStrToFStr(fstr, cstr, flen);
    fstr[flen] = '\0';
    return fstr;
}


void BlankStr( _IN char *fstr, _IN STRING_SIZE flen )
{
    /* Initialise un blanc une chaine de caract�res (sans '\0' � la fin).
     * S'applique � une chaine allou�e par le Fortran.
     */
    memset(fstr, ' ', flen);
}


char * MakeBlankFStr( _IN STRING_SIZE flen )
{
    /* Initialise un blanc une chaine de caract�res avec '\0' � la fin
     * (qui peut ainsi �tre pass� au Fortran).
     * Alloue une chaine qui sera pass�e au Fortran.
     */
    char *fstr;
    fstr = (char*)malloc((flen + 1) * sizeof(char));
    BlankStr(fstr, flen);
    fstr[flen] = '\0';
    return fstr;
}


char * MakeTabFStr( _IN int size, _IN STRING_SIZE flen )
{
    /* Alloue un tableau de chaine de caract�res Fortran. Chaque chaine
     * est de longueur "flen". Le m�me "flen" sera utilis�
     * dans SetTabFStr.
     * Alloue un tableau de chaine qui sera pass� au Fortran.
     */
    return MakeBlankFStr(size * flen);
}


void SetTabFStr( _IN char *tab, _IN int index, _IN char *cstr, _IN STRING_SIZE flen )
{
    /* Remplit l'indice "index" (de 0 � size-1) du tableau de chaine
     * de caract�res "tab" avec la chaine "cstr".
     */
    char *strk = NULL;
    strk = &tab[index * flen];
    CopyCStrToFStr(strk, cstr, flen);
}


/* pour que ce soit clair */
void FreeStr(char *cstr)
{
    free(cstr);
}

void _check_string_length( STRING_SIZE flen )
{
    if ( flen > 2147483647 ) {
        printf("WARNING: The string length seems corrupted. " \
               "The value of STRING_SIZE is probably bad : %s (%d bytes)\n" \
               "Please contact your support.\n", xstr(STRING_SIZE), (int)sizeof(STRING_SIZE));
    }
}
