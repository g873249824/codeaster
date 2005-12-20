/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* MODIF hdfclf hdf  DATE 08/11/2005   AUTEUR D6BHHJP J.P.LEFEBVRE */
/* ================================================================== */
/* COPYRIGHT (C) 1991 - 2003  EDF R&D              WWW.CODE-ASTER.ORG */
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
/*-----------------------------------------------------------------------------/
/ Fermeture d'un fichier HDF, renvoie une erreur si le fichier existe 
/  Param�tres :
/   - in  idfic : identificateur du fichier (hid_t)
/  R�sultats :
/     0 = fermeture OK, -1 sinon (long)
/-----------------------------------------------------------------------------*/
#include <hdf5.h>

#if defined SOLARIS || IRIX || P_LINUX || TRU64 || SOLARIS64 
   long hdfclf_( long *idf )
#elif defined HPUX
   long hdfclf ( long *idf )
#elif defined PPRO_NT
   extern long __stdcall HDFCLF( long  *idf )
#endif
{
hid_t idfic;
herr_t icode;

idfic=(hid_t) *idf;
if ((icode = H5Fclose(idfic)) < 0) 
   return -1 ;
return 0;
}     
