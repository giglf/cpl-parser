

%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <stdarg.h>
	#include <string>
	#include <map>
	#include "node.h"

	NodeType *opr(int oper, int nops, ...);
	NodeType *id(std::string *name);
	NodeType *con(int value);
	void freeNode(NodeType *p);
	int yyerror(char *);
	int yylex(void);
	int ex(NodeType *p);
	std::map<std::string, int> intTable;

	extern FILE *yyin;

%}


%union{
	int iValue;
	std::string *varName;
	NodeType *nPtr;
}

%token <iValue> INTEGER
%token <varName> VARIABLE
%token WHILE IF PRINT PRINTB
%nonassoc IFX
%nonassoc ELSE

%left NOT AND OR
%left GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%type <nPtr> stmt expr stmt_list


%%

program : function	{exit(0);}
		;

function : function stmt	{ex($2); freeNode($2);}
		 |
		 ;

stmt : ';'								{$$ = opr(';', 2, NULL, NULL);}
	 | expr ';'							{$$ = $1;}
	 | PRINT expr ';'					{$$ = opr(PRINT, 1, $2);}
	 | PRINTB expr ';'					{$$ = opr(PRINTB, 1, $2);}
	 | VARIABLE '=' expr ';' 			{$$ = opr('=', 2, id($1), $3);}
	 | WHILE '(' expr ')' stmt 			{$$ = opr(WHILE, 2, $3, $5);}
	 | IF '(' expr ')' stmt %prec IFX	{$$ = opr(IF, 2, $3, $5);}
	 | IF '(' expr ')' stmt ELSE stmt 	{$$ = opr(IF, 3, $3, $5, $7);}
	 | '{' stmt_list '}' 				{$$ = $2;}
	 ;

stmt_list : stmt	{$$ = $1;}
		  | stmt_list stmt	{$$ = opr(';', 2, $1, $2);}
		  ;


expr : INTEGER			{$$ = con($1);}
	 | VARIABLE			{$$ = id($1);}
	 | '-' expr %prec UMINUS	{$$ = opr(UMINUS, 1, $2);}
	 | expr '+' expr	{$$ = opr('+', 2, $1, $3);}
	 | expr '-' expr	{$$ = opr('-', 2, $1, $3);}
	 | expr '*' expr	{$$ = opr('*', 2, $1, $3);}
	 | expr '/'	expr	{$$ = opr('/', 2, $1, $3);}
	 | expr '<' expr	{$$ = opr('<', 2, $1, $3);}
	 | expr '>' expr	{$$ = opr('>', 2, $1, $3);}
	 | expr GE expr		{$$ = opr(GE, 2, $1, $3);}
	 | expr LE expr		{$$ = opr(LE, 2, $1, $3);}
	 | expr NE expr		{$$ = opr(NE, 2, $1, $3);}
	 | expr EQ expr		{$$ = opr(EQ, 2, $1, $3);}
	 | '(' expr ')'		{$$ = $2;}
	 | NOT expr			{$$ = opr(NOT, 1, $2);}
	 | expr AND expr	{$$ = opr(AND, 2, $1, $3);}
	 | expr OR expr		{$$ = opr(OR, 2, $1, $3);}
	 ;

%%

/* 计算从NodeType结构体地址起始到con地址的距离，即type的大小 */
#define SIZEOF_NODETYPE ((char*)&p->con - (char*)p)


//构建常量node
NodeType *con(int value){
	NodeType *p;
	size_t nodeSize;

	nodeSize = SIZEOF_NODETYPE + sizeof(ConNodeType);
	if((p = (NodeType *)malloc(nodeSize)) == NULL)
		yyerror("out of memory");

	p->type = typeCon;
	p->con.value = value;

	return p;
}


//构建变量类型的node
NodeType *id(std::string *name){
	NodeType *p;
	size_t nodeSize;

	nodeSize = SIZEOF_NODETYPE + sizeof(IdNodeType);
	if((p = (NodeType *)malloc(nodeSize)) == NULL)
		yyerror("out of memory");

	p->type = typeId;
	p->id.name = name;
	
	return p;
}


//构建操作类型的node
NodeType *opr(int oper, int nops, ...){
	va_list ap;
	NodeType *p;
	size_t nodeSize;
	int i;

	nodeSize = SIZEOF_NODETYPE + sizeof(OprNodeType) + (nops - 1)* sizeof(NodeType*);
	if((p = (NodeType *)malloc(nodeSize)) == NULL){
		yyerror("out of memory");
	}

	p->type = typeOpr;
	p->opr.oper = oper;
	p->opr.nops = nops;
	va_start(ap, nops);
	for(i=0; i<nops; i++){
		p->opr.op[i] = va_arg(ap, NodeType*);
	}
	va_end(ap);
	return p;
}


void freeNode(NodeType *p){
	int i;
	if(!p) return;
	if(p->type == typeOpr){
		for(i=0; i<p->opr.nops; i++)
			freeNode(p->opr.op[i]);
	}
	free(p);
}

int yyerror(char *s)
{
	fprintf(stderr, "%s\n", s);
	return 0;
}

int main(int args, char **argv)
{
	if(args > 1 && argv[1][1] == 'h'){
		printf("Usage:\n");
		printf("\t%s\t\tEnter interactive model\n", argv[0]);
		printf("\t%s <file>\tParse the file and output on shell\n", argv[0]);
		printf("\t%s -h\t\tShow this usage messages\n", argv[0]);
		return 0;
	}

	if(args > 1) {
		yyin = fopen(argv[1], "r");
	} else{
		yyin = stdin;
	}

	yyparse();

	fclose(yyin);

	return 0;
}
