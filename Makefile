all: cpl-parser

OBJS = parse.o	\
	   codegen.o\
	   lex.o	\

CPPFLAGS = -std=c++11

clean:
	$(RM) -rf parse.cpp parse.hpp lex.cpp $(OBJS) 


parse.cpp: parse.y
	bison -d -o $@ $^

parse.hpp: parse.cpp


lex.cpp: lex.l parse.hpp
	flex -o $@ $^

%.o: %.cpp
	g++ -c $(CPPFLAGS) -o $@ $<

cpl-parser: $(OBJS)
	g++ -o $@ $(OBJS)
