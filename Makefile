include .knightos/variables.make

# This is a list of files that need to be added to the filesystem when installing your program
ALL_TARGETS:=$(BIN)life $(APPS)life.app $(SHARE)icons/life.img

# This is all the make targets to produce said files
$(BIN)life: main.asm
	mkdir -p $(BIN)
	$(AS) $(ASFLAGS) --listing $(OUT)main.list main.asm $(BIN)life

$(APPS)life.app: life.app
	mkdir -p $(APPS)
	cp life.app $(APPS)

$(SHARE)icons/life.img: life.png
	mkdir -p $(SHARE)icons
	kimg -c life.png $(SHARE)icons/life.img

include .knightos/sdk.make
