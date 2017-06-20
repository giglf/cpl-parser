#include <stdio.h>
#include "node.h"
#include "parse.hpp"


int ex(NodeType *p){

	if(!p) return 0;

	switch (p->type){
		case typeCon:
			return p->con.value;
		case typeId:
			return intTable[*(p->id.name)];
		case typeOpr:
			switch (p->opr.oper) {
				case WHILE:
					while (ex(p->opr.op[0]))
						ex(p->opr.op[1]);
					return 0;
				case IF:
					if (ex(p->opr.op[0]))
						ex(p->opr.op[1]);
					else if (p->opr.nops > 2)
						ex(p->opr.op[2]);
					return 0;
				case PRINT:
					printf("%d\n", ex(p->opr.op[0]));
					return 0;
				case ';':
					ex(p->opr.op[0]);
					return ex(p->opr.op[1]);
				case '=':
					return intTable[*(p->opr.op[0]->id.name)] = ex(p->opr.op[1]);
				case UMINUS:
					return -ex(p->opr.op[0]);
				case '+':
					return ex(p->opr.op[0]) + ex(p->opr.op[1]);
				case '-':
					return ex(p->opr.op[0]) - ex(p->opr.op[1]);
				case '*':
					return ex(p->opr.op[0]) * ex(p->opr.op[1]);
				case '/':
					return ex(p->opr.op[0]) / ex(p->opr.op[1]);
				case '<':
					return ex(p->opr.op[0]) < ex(p->opr.op[1]);
				case '>':
					return ex(p->opr.op[0]) > ex(p->opr.op[1]);
				case GE:
					return ex(p->opr.op[0]) >= ex(p->opr.op[1]);
				case LE:
					return ex(p->opr.op[0]) <= ex(p->opr.op[1]);
				case NE:
					return ex(p->opr.op[0]) != ex(p->opr.op[1]);
				case EQ:
					return ex(p->opr.op[0]) == ex(p->opr.op[1]);
				case NOT:
					return !ex(p->opr.op[0]);
				case AND:
					return ex(p->opr.op[0]) && ex(p->opr.op[1]);
				case OR:
					return ex(p->opr.op[0]) || ex(p->opr.op[1]);

			}
	}
}