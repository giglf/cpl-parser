%{
	
	#include <stdlib.h>
	#include <string>
	#include "node.h"
	#include "parse.hpp"
	int yyerror(char *);

%}

%%

">="		return GE;
"<="		return LE;
"=="		return EQ;
"!="		return NE;
"!"         return NOT;
"&&"        return AND;
"||"        return OR;
"while"		return WHILE;
"if"		return IF;
"else"		return ELSE;
"print"		return PRINT;
"printb"    return PRINTB;

"false"     {
                yylval.iValue = 0;
                return INTEGER;
            }

"true"      {
                yylval.iValue = 1;
                return INTEGER;
            }

[a-zA-z][a-zA-z0-9]*	{
							yylval.varName = new std::string(yytext);
							return VARIABLE;
						}

[0-9]+	{
			yylval.iValue = atoi(yytext);
			return INTEGER;
		}


[-()<>=+*/;{}.] {
					return *yytext;
				}


[ \t\n]+	;
.			yyerror("Unknown character");


%%

int yywrap(void){
	return 1;
}
