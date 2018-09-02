TARGET    = doubleH3lix
HEADLESS  = lib$(TARGET).a
BOOTSTRAP = DH.tar.xz
INC       = external/liboffsetfinder64/include
LIB       = $(TARGET)/libs
OBJ       = obj
DEP_C     = $(patsubst $(TARGET)/%.m,%,$(wildcard $(TARGET)/*.m))
DEP_CXX   = $(patsubst $(TARGET)/%.mm,%,$(wildcard $(TARGET)/*.mm))
FLAGS    ?= -Wall -O3 -DHEADLESS=1 -fobjc-arc -miphoneos-version-min=10.0 $(CFLAGS)

.PHONY: all bootstrap headless clean

all: $(TARGET).ipa

$(TARGET).ipa: Payload
	zip -r9 $(TARGET).ipa Payload/$(TARGET).app

Payload: build/Release-iphoneos
	ln -sf build/Release-iphoneos Payload

build/Release-iphoneos:
	xcodebuild clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -sdk iphoneos

headless: $(HEADLESS)

#$(HEADLESS): $(TARGET)/*.h $(TARGET)/*.m $(TARGET)/*.mm $(INC)/liboffsetfinder64/*.h $(INC)/liboffsetfinder64/*.hpp $(LIB)/*.a
#	xcrun -sdk iphoneos clang++ -arch arm64 -o $@ -Wall -O3 -DHEADLESS=1 -xobjective-c++ -std=gnu++14 $(TARGET)/*.mm -xobjective-c $(TARGET)/*.m -I$(INC) -L$(LIB) -loffsetfinder64 -limg4tool -lplist++ -lplist

$(HEADLESS): $(addsuffix .o, $(addprefix $(OBJ)/c/, $(DEP_C))) $(addsuffix .o, $(addprefix $(OBJ)/c++/, $(DEP_CXX)))
#	xcrun -sdk iphoneos clang++ -arch arm64 -o $@ $(FLAGS) $^ -L$(LIB) -loffsetfinder64 -limg4tool -lplist++ -lplist -F. -framework IOKit
	xcrun -sdk iphoneos libtool -static -o $@ $^

$(OBJ)/c/%.o: $(TARGET)/%.m | $(OBJ)/c
	xcrun -sdk iphoneos clang++ -arch arm64 -c -o $@ $(FLAGS) -xobjective-c -std=gnu11 $< -I$(INC)

$(OBJ)/c++/%.o: $(TARGET)/%.mm | $(OBJ)/c++
	xcrun -sdk iphoneos clang++ -arch arm64 -c -o $@ $(FLAGS) -xobjective-c++ -std=gnu++14 $< -I$(INC)

$(OBJ)/c:
	mkdir -p $@

$(OBJ)/c++:
	mkdir -p $@

bootstrap: $(BOOTSTRAP)

$(BOOTSTRAP): $(TARGET)/jbresources/*
	cd $(TARGET)/jbresources && bsdtar -cJf ../../$@ ./*

clean:
	rm -rf build Payload $(TARGET).ipa $(HEADLESS) $(OBJ) $(BOOTSTRAP)
