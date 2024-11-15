SD  := SD
UNAME := $(shell uname)
ifeq ($(UNAME),)
    SEP = \\
else
    SEP = /
endif
BIN := $(SD)$(SEP)SUPER-MARIO-KART.PRG

TBL := $(SD)$(SEP)TBL
EXTRACTED_FILES  := $(TBL)$(SEP)MARIO-MAP.BIN $(TBL)$(SEP)MARIO-TILES.BIN
GENERATED_FILES := $(TBL)$(SEP)PERSPECTIVE.BIN
EXTRACT := utils$(SEP)extract_tiles_and_tilemap.py
GENERATE := utils$(SEP)generate_mode7_tables.py
PYTHON := $(shell python -c "import sys; print(sys.executable)")
ifeq ($(PYTHON),)
    PYTHON := $(shell python3 -c "import sys; print(sys.executable)")
endif
    

run: $(BIN) $(EXTRACTED_FILES) $(GENERATED_FILES)
	x16emu -fsroot SD -prg "$(BIN)" -run

$(EXTRACTED_FILES): depends $(EXTRACT) $(TBL)
	$(PYTHON) $(EXTRACT)

$(GENERATED_FILES): depends $(GENERATE) $(TBL)
	$(PYTHON) $(GENERATE)

$(BIN): super_mario_kart.s $(SD) 
	cl65 -t cx16 -o $@ $<

depends: utils$(SEP)requirements.txt
	$(PYTHON) -mpip install -r utils$(SEP)requirements.txt && echo > depends

$(SD): 
	mkdir $(SD)

$(TBL): $(SD)
	mkdir $(TBL)

clean: 
ifeq ($(UNAME),)
	rd /s SD
	del depends
else
	rm -rf SD depends
endif
