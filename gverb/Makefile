HEADERS = gverb.h gverbdsp.h

OBJECTS = gverb.o gverbdsp.o

all: $(OBJECTS)

libgverb.a: $(HEADERS) $(OBJECTS)
	ar rvu $@ $(OBJECTS)
	ranlib $@
