#ifndef CPL_COMPILER_TEST3_H
#define CPL_COMPILER_TEST3_H

typedef enum{
    typeCon,
    typeId,
    typeOpr
} nodeEnum;

typedef struct{
    int value;
} conNodeType;

typedef struct{
    int i;
}idNodeType;

typedef struct{
    int oper;
    int nops;
    struct nodeTypeTag *op[1];
}oprNodeType;

typedef struct nodeTypeTag{
    nodeEnum type;  //type of node

    union{
        conNodeType con;
        idNodeType id;
        oprNodeType opr;
    };
}nodeType;

extern int sym[26];

#endif //CPL_COMPILER_TEST3_H
