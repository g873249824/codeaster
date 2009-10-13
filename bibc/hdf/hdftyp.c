/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* MODIF hdftyp hdf  DATE 13/10/2009   AUTEUR COURTOIS M.COURTOIS */
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
#include <stdlib.h>
#include "aster.h"
/*-----------------------------------------------------------------------------/
/ R�cup�ration du type associ� (dataset,group,etc) de chaque entit� d'une liste 
/ de noms d'un groupe donn� au sein d'un fichier HDF 
/  Param�tres :
/   - in  idfic : identificateur du fichier (hid_t)
/   - in  nomgr : identificateur du fichier (hid_t)
/   - in  lnom :  liste de noms (char *)
/   - out ltype : liste des types (char *)
/  R�sultats :
/     nombre de datasets et de groups
/-----------------------------------------------------------------------------*/
#include "hdf5.h"
#define FALSE   0

INTEGER DEFPSPS(HDFTYP, hdftyp, INTEGER *idf, char *nomgr, STRING_SIZE ln, INTEGER *nbnom, char *typ, STRING_SIZE ltp)
{
  hid_t idfic;
  char *nomg, *pt, *ptype; 
  int indx,j,ind;
  int k, ll;
  void *malloc(size_t size);
  
  herr_t indiceType(hid_t loc_id, const char *name, void *opdata);

  idfic=(hid_t) *idf;

  nomg = (char *) malloc((ln+1) * sizeof(char));
  for (k=0;k<ln;k++)  
     nomg[k] = nomgr[k];
  k=ln-1;
  while (nomg[k] == ' ') { k--;}
  nomg[k+1] = '\0';

  ptype=(char *) malloc((ltp+1) * sizeof(char));
  pt=typ;
  for (j=0;j<*nbnom;j++) {
    ind=j;
    indx = H5Giterate(idfic, nomg, &ind, indiceType, ptype);
    ll=strlen(ptype);
    for (k=0;k<ll;k++)
      *(pt+k) = *(ptype+k);
    for (k=ll;k<ltp;k++)
      *(pt+k) = ' ';
    pt=pt+ltp;
  }
  free(nomg);
  free(ptype);
  return 0; 
}
   
herr_t indiceType(hid_t id, const char *nom, void *donnees)
{
  char *retour;
  H5G_stat_t statbuf;
  int iret;

  retour =(char *)donnees;
  iret=H5Gget_objinfo(id, nom, FALSE, &statbuf);

  switch (statbuf.type) {
  case H5G_GROUP: 
     strcpy(retour,"group");
     break;
  case H5G_DATASET: 
     strcpy(retour,"dataset");
     break;
  case H5G_TYPE: 
     strcpy(retour,"datatype");
     break;
  default:
     strcpy(retour,"unknown");
  }
  return 1;
}
