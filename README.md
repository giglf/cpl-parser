[TOC]

# cpl-parser

这是一个简单的cpl (Core Programming Language)的解析器



## 环境

Ubuntu 15.10

flex 2.5.39

bison 3.0.2

g++ 5.2.1

---

## 使用说明

make进行编译

通过-h参数可以打印用法

``` shell
./cpl-parser -h
Usage:
	./cpl-parser		Enter interactive model
	./cpl-parser <file>	Parse the file and output on shell
	./cpl-parser -h		Show this usage messages
```

---

## 语法说明

* `;`分号表示一条语句的结束
* `+-*/`表示普通的加减乘除操作
* `-`表示负号，取相反数
* `=`表示赋值负号
* `while`表示循环
  * while(x<3){x = x+1;} 类似的语法
* `if...else...`表示选择分支
  * if(x<3){x=x+1;} else{x=x-1;} 类似语法
  * 可以单纯只用if缺省else
* `print`打印值，只能打印整数，默认换行
* `printb`打印布尔值，默认整数为0表示`false`，否则表示`true`
* `true`表示布尔值的true，实际为常量1
* `false`表示布尔值的false，实际为常量0
* `!` 取反操作
* `&&` 与操作
* `||` 或操作



语法与c语言类似