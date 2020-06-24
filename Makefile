all:
	cd src; \
	ghc -o ../interpreter Main.hs; \
	rm -f *.hi *.o

clean:
	-rm -f interpreter
