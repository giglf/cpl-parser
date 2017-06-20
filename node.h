#ifndef CPL_COMPILER_NODE_H
#define CPL_COMPILER_NODE_H

#include <string>
#include <map>

typedef enum{
    typeCon, 	//常量类型
    typeId,		//变量标识符
    typeOpr		//操作类型
} NodeEnum;

typedef struct{
    int value;	//常量
} ConNodeType;

typedef struct{
    std::string *name; //指向变量名
}IdNodeType;

typedef struct{
    int oper;		//操作类型
    int nops;		//操作数个数
    struct NodeTypeTag *op[1];	//扩展节点
}OprNodeType;

typedef struct NodeTypeTag{
    NodeEnum type;  //type of node

    union{
        ConNodeType con;
        IdNodeType id;
        OprNodeType opr;
    };
}NodeType;

extern std::map<std::string, int> intTable;		//储存变量对应的int值

#endif //CPL_COMPILER_NODE_H
