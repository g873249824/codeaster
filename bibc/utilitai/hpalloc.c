/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* MODIF HPALLOC UTILITAI  DATE 19/05/2011   AUTEUR SELLENET N.SELLENET */
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
#include "aster.h"
#include <errno.h>

void DEFPPPP(HPALLOC, hpalloc, void **addr,INTEGER *length, INTEGER *errcode, INTEGER *abrt)
{
    void *malloc(),abort();
    if ( *length <= 0 ) {
        *errcode = -1;
    }
    else
    {
        *addr = (void *)malloc(*length * sizeof(INTEGER));
        if ( *addr == (void *)0 )
        {
            *errcode = -2;
        }
        else
        {
            *errcode = 0;
        }
    }
    if ( *errcode != 0 && *abrt != 0 )
    {
     abort();
    }
}
