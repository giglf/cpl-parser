# Strong calc

compile command:
``` shell
flex -o lex.c lex.l
bison -d -o parse.c parse.y
gcc lex.c parse.c codegen.c -o codegen

echo "x=0;while(x<3){print(x);x=x+1;}" | ./codegen
0
1
2
