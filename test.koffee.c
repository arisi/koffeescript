#include "koffeescript.h"

int xxxx=1;                                       // pellejuttu:3   : int xxxx=1
int pf() {                                        // pellejuttu:5   : int pf = () ->
  return  ( 0x1234 );                             // pellejuttu:6   :   return 0x1234
}

int pelle(int c) {                                // ./test:7       : int pelle =(int c) ->
  return printf  ( "tadaa %d\n",c );              // ./test:8       :   printf "tadaa %d\n",c
}

int main(int argc,char **argv) {                  // ./test:10      : int main = (int argc,char **argv) ->
  if (argc<2 || ! true) {                         // ./test:11      :   if argc<2 or not true
    printf  ( "EI ARGUMENNTTIA\n" );              // ./test:12      :     printf "EI ARGUMENNTTIA\n"
    exit(-1);                                     // ./test:13      :     exit(-1)
    }
  int x=atoi(argv[1]);                            // ./test:14      :   int x=atoi(argv[1])
  int y=(1);                                      // ./test:15      :   int y=:pellekoodi
  for (y=0;y<10;y++) {                            // ./test:16      :   for y=0;y<10;y++
    printf  ( "LUUPPI %d\n", y );                 // ./test:17      :     printf "LUUPPI %d\n", y
    if ((y>4) && (y<9)) {                         // ./test:18      :     if (y>4) and (y<9)
      printf  ( "kohta loppuu luuppi\n" );        // ./test:19      :       printf "kohta loppuu luuppi\n"
    }
    }
  if (x>10) {                                     // ./test:20      :   if x>10
    printf("iso\n") ;                             // ./test:21      :     printf("iso\n") 
    if (x>100) {                                  // ./test:22      :     if x>100
      printf  ( "TOSI ISO\n" );                   // ./test:23      :       printf "TOSI ISO\n"
      if (x>1000) {                               // ./test:24      :       if x>1000
        printf  ( "HIMUTOSI ISO\n" );             // ./test:25      :         printf "HIMUTOSI ISO\n"
    }
    }
  } else if (x>5) {                               // ./test:26      :   else if x>5
    printf  ( "keskikoko\n" );                    // ./test:27      :     printf "keskikoko\n"
    printf  ( "keskikoko juu!\n" );               // ./test:28      :     printf "keskikoko juu!\n"
  } else {                                        // ./test:29      :   else
    printf  ( "pieni\n"   );                      // ./test:30      :     printf "pieni\n"  
    }
  pelle((1));                                     // ./test:31      :   pelle(:pellekoodi)
  return printf  ( "Required öä 0x%08X\n",pf() ); // ./test:32      :   printf "Required öä 0x%08X\n",pf()
}

