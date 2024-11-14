SD  := SD
BIN := $(SD)/SUPER-MARIO-KART.PRG
TBL := $(SD)/TBL
EXTRACTED_FILES  := $(TBL)/MARIO-MAP.BIN $(TBL)/MARIO-TILES.BIN
GENERATED_FILES := $(TBL)/PERSPECTIVE.BIN
EXTRACT := utils/extract_tiles_and_tilemap.py
GENERATE := utils/generate_mode7_tables.py
UNAME := $(shell uname)

run: $(BIN) $(EXTRACTED_FILES) $(GENERATED_FILES)
	x16emu -fsroot SD -prg "$(BIN)" -run

$(EXTRACTED_FILES): depends $(EXTRACT) $(TBL)
	python3 "$(EXTRACT)"

$(GENERATED_FILES): depends $(GENERATE) $(TBL)
	python3 "$(GENERATE)"

$(BIN): super_mario_kart.s $(SD) 
	cl65 -t cx16 -o "$@" "$<"

depends: utils/requirements.txt
	python3 -mpip install -r utils/requirements.txt && echo > depends

$(SD): 
	mkdir "$(SD)"

$(TBL): $(SD)
	mkdir "$(TBL)"

clean: 
ifeq ($(UNAME),)
	rd /s SD
	del depends
else
	rm -rf SD depends
endif
