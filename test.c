#include "koffeescript.h"                         // 0: int pelle =() ->
                                                  
int pelle() {                                     // 0: int pelle =() ->
  return printf  ( "tadaa\n" );                   // 1:   printf "tadaa\n"
}                                                 
                                                  
int main(int argc,char **argv) {                  // 2: int main = (int argc,char **argv) ->
  if (argc<2) {                                   // 3:   if argc<2
    printf  ( "EI ARGUMENNTTIA\n" );              // 4:     printf "EI ARGUMENNTTIA\n"
    exit(-1);                                     // 5:     exit(-1)
    }                                             
  int x=atoi(argv[1]);                            // 6:   int x=atoi(argv[1])
  int y;                                          // 7:   int y
  for (y=0;y<10;y++) {                            // 8:   for y=0;y<10;y++
    printf  ( "LUUPPI %d\n", y );                 // 9:     printf "LUUPPI %d\n", y
    if (y>4) {                                    // 10:     if y>4
      printf  ( "kohta loppuu luuppi\n" );        // 11:       printf "kohta loppuu luuppi\n"
    }                                             
    }                                             
  if (x>10) {                                     // 12:   if x>10
    printf("iso\n") ;                             // 13:     printf("iso\n") ;;;
    if (x>100) {                                  // 14:     if x>100
      printf  ( "TOSI ISO\n" );                   // 15:       printf "TOSI ISO\n"
      if (x>1000) {                               // 16:       if x>1000
        printf  ( "HIMUTOSI ISO\n" );             // 17:         printf "HIMUTOSI ISO\n"
    }                                             
    }                                             
  } else if (x>5) {                               // 18:   else if x>5
    printf  ( "keskikoko\n" );                    // 19:     printf "keskikoko\n"
    printf  ( "keskikoko\n" );                    // 20:     printf "keskikoko\n"
  } else {                                        // 21:   else
    printf  ( "pieni\n"   );                      // 22:     printf "pieni\n"  #KOMMENTTI
    }                                             
  return pelle(55);                               // 23:   pelle(55)
}                                                 
                                                  
;                                                 
