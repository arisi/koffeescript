#include "koffeescript.h"

typedef struct {                                  // ./koe:4        : struct rec
  int aa;                                         // ./koe:5        :   int aa
} rec;

rec recs[100];                                    // ./koe:7        : rec recs[100]
int main(int argc,char **argv) {                  // ./koe:9        : int main = (int argc,char **argv) ->
  int i;                                          // ./koe:10       :   int i
  i= (argc>5) ? (6) : (7);                        // ./koe:11       :   i= if argc>5 then 6 else 7
  while (! (i>10)) { printf("luuppi %d\n",i+=1); }// ./koe:12       :   printf("luuppi %d\n",i+=1) until i>10
  recs[0].aa=123;                                 // ./koe:13       :   recs[0].aa=123
  printf  ( "\nKoffeeScript: -- here we go!\n" ); // ./koe:14       :   printf "\nKoffeeScript: -- here we go!\n"
  if (true) { printf("tadaa\n"); }                // ./koe:15       :   printf("tadaa\n") if true
  for (i=0;i<argc;i++) {                          // ./koe:16       :   for i=0;i<argc;i++
    printf  ( "arg:%d='%s'\n",i,argv[i] );        // ./koe:17       :     printf "arg:%d='%s'\n",i,argv[i]
    }
  if (argc<2 || ! true) {                         // ./koe:18       :   if argc<2 or not true
    printf  ( "EI ARGUMENTTIA!!!!!!!\n" );        // ./koe:19       :     printf "EI ARGUMENTTIA!!!!!!!\n"
    exit(-1);                                     // ./koe:20       :     exit(-1)
  }
}

