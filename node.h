#ifndef CPL_COMPILER_NODE_H
#define CPL_COMPILER_NODE_H

#include <string>
#include <map>

typedef enum{
    typeCon,
    typeId,
    typeOpr
} NodeEnum;

typedef struct{
    int value;
} ConNodeType;

typedef struct{
    std::string *name;
}IdNodeType;

typedef struct{
    int oper;
    int nops;
    struct NodeTypeTag *op[1];
}OprNodeType;

typedef struct NodeTypeTag{
    NodeEnum type;  //type of node

    union{
        ConNodeType con;
        IdNodeType id;
        OprNodeType opr;
    };
}NodeType;

extern std::map<std::string, int> intTable;

#endif //CPL_COMPILER_NODE_H
