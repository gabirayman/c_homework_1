CFLAGS = -Wall -g -fPIC

all: mains maindloop maindrec loops recursive

loops: libclassloops.a

libclassloops.a: advancedClassificationLoop.o basicClassification.o
	ar rcs libclassloops.a advancedClassificationLoop.o basicClassification.o

recursive: libclassrec.a

libclassrec.a: advancedClassificationRecursion.o basicClassification.o
	ar rcs libclassrec.a advancedClassificationRecursion.o basicClassification.o

mains: mains.o libclassrec.a
	gcc $(CFLAGS) -o mains mains.o libclassrec.a

libclassloops.so: advancedClassificationLoop.o basicClassification.o
	gcc $(CFLAGS) -shared -o libclassloops.so advancedClassificationLoop.o basicClassification.o

libclassrec.so: advancedClassificationRecursion.o basicClassification.o
	gcc $(CFLAGS) -shared -o libclassrec.so advancedClassificationRecursion.o basicClassification.o

maindloop: mains.o libclassloops.so
	gcc $(CFLAGS) -o maindloop mains.o -L. -lclassloops -Wl,-rpath=.


maindrec: mains.o libclassrec.so
	gcc $(CFLAGS) -o maindrec mains.o -L. -lclassrec -Wl,-rpath=.


%.o: %.c Numclass.h
	gcc $(CFLAGS) -c $<

clean:
	rm -f *.o *.a *.so mains maindloop maindrec