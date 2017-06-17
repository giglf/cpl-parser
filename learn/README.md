# Using to learn grammer of flex and bison

`cal.l` is a simple test using to count characters and lines.

```
flex cal.l ==> lex.yy.c
gcc lex.yy.c -o lex_test ==>lex_test
./lex_test
1 2 3 4 5 6
7 8 9 10
abcdef    
(ctrl+d => eof)
# of lines = 3, # of chars = 28

---

`calc.y` is a parser to a calculator. Supported + - * / ^

generate
```
bison calc.y ==> calc.tab.c
g++ calc.tab.c -o bison_test
./bison_test
1+2 
	3
5+6*8-5
	48
12/5
	2.4
12/7
	1.714285714
