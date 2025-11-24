CFG=GYRE_PISCES
ARCH=bisheng
MCFG=MY_GYRE



.PHONY : all mkdir

all :
	./makenemo -m $(ARCH) -r $(CFG) -n '$(MCFG)' -j32



clean :
	./makenemo -m $(ARCH) -r $(CFG) -n '$(MCFG)' -j 4 clean

