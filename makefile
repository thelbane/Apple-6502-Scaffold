# The name of the destination disk image
IMAGE_TARGET = main.dsk

# Apple II command issued by the "run" recipe after booting the disk image.
RUN_CMD = "BRUN MAIN"

# Paths and flags for build/processing applications
DASM = dasm
DASM_FLAGS = -v0 -f2
AC = java -jar /usr/local/bin/ac.jar

# Source folder. All files in this folder will produce an object file (No subfolders)
SDIR = ./src

# Include folder. Changes to files in this folder will invalidate the current build (No subfolders)
IDIR = ./include

# Output folder for build product
BDIR = ./build

# Resource folder. Contains any resources required by this makefile. (No subfolders.)
RDIR = ./res

# Path to the runner script
RUNNER = osascript $(RDIR)/runner.scpt

# Paths to source files
SRC_FILES = $(shell ls $(SDIR))
ASM_FILES = $(filter %.asm,$(SRC_FILES))
# BAS_FILES = $(filter %.bas,$(SRC_FILES))

SRC = $(patsubst %,$(SDIR)/%,$(ASM_FILES))

# Paths to include files
_DEPS = $(shell ls $(IDIR))
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))

# Destination paths to object files
OBJ = $(patsubst %.asm,$(BDIR)/%,$(ASM_FILES))

# Path to disk image
IMAGE = $(abspath $(BDIR)/$(IMAGE_TARGET))

# Path to the blank bootable disk image
BOOTIMAGE = $(RDIR)/dos3.3bootable.dsk

# Shell commands to copy object files to the disk image
COPY_OBJ = $(foreach FN,$(OBJ),$(AC) -cc65 $(IMAGE) "$(shell echo $(notdir $(FN)) | tr a-z A-Z | tr '_' ' ')" B < $(FN);)

.PHONY: clean all disk run

# Build all object files
all: $(OBJ)
$(OBJ): $(DEPS) $(SRC)
	@mkdir -p $(BDIR)
	$(eval OBJNAME = $(notdir $@))
	$(eval SRCPATH = $(patsubst %,$(SDIR)/%.asm,$(OBJNAME)))
	$(eval LSTPATH = $(BDIR)/$(OBJNAME).lst)
	$(DASM) $(SRCPATH) -o$@ -l$(LSTPATH) $(DASM_FLAGS)

# Create disk image
disk: $(IMAGE)
$(IMAGE): $(OBJ)
	cp $(BOOTIMAGE) $(IMAGE)
	$(COPY_OBJ)

# Delete all build output
clean:
	@rm -rf $(BDIR)
	@echo All clean.

# Boot disk image in emulator
run: $(IMAGE)
	$(RUNNER) $(IMAGE) $(RUN_CMD)
	@echo Running...
