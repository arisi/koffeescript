#include "koffeescript.h"

int main(int argc,char **argv) {                  // ./koe:5        : int main = (int argc,char **argv) ->
  int i;                                          // ./koe:6        :   int i
  printf  ( "tadaa -- here we go!\n" );           // ./koe:7        :   printf "tadaa -- here we go!\n"
  for (i=0;i<argc;i++) {                          // ./koe:8        :   for i=0;i<argc;i++
    printf  ( "arg:%d='%s'\n",i,argv[i] );        // ./koe:9        :     printf "arg:%d='%s'\n",i,argv[i]
    }
  if (argc<2 || ! true) {                         // ./koe:10       :   if argc<2 or not true
    printf  ( "EI ARGUMENTTIA\n" );               // ./koe:11       :     printf "EI ARGUMENTTIA\n"
    exit(-1);                                     // ./koe:12       :     exit(-1)
  }
}

