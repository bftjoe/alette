TARGET_NAME := alette
TARGET_BIN_DIR := ./build
CXX := clang++

TARGET_SUFFIX =
ifeq ($(OS), Windows_NT)
	TARGET_SUFFIX = .exe
endif

SRC := main.cpp

# idea from Stormphrax
PGO_EXEC := profile-alette
PGO_GENERATE := -fprofile-instr-generate
PGO_DATA := alette.profdata
PGO_MERGE := llvm-profdata merge -output=$(PGO_DATA) *.profraw
PGO_USE := -fprofile-instr-use=$(PGO_DATA)

CPPFLAGS := -std=c++2c -fno-rtti -fno-exceptions -mbmi -mbmi2 -mpopcnt -msse2 -msse3 -msse4.1 -mavx2 -D_CRT_SECURE_NO_WARNINGS
CPPFLAGS_DEBUG := $(CPPFLAGS) -g -O1 -DDEBUG
CPPFLAGS_RELEASE := $(CPPFLAGS) -O3 -fomit-frame-pointer -DNDEBUG

.PHONY: all debug release profile

all: release

pgo:
# idea from Stormphrax
	$(eval TARGET_EXEC = $(TARGET_NAME)-pgo)
	$(CXX) $(CPPFLAGS_RELEASE) $(PGO_GENERATE) $(SRC) -o $(TARGET_BIN_DIR)/$(TARGET_EXEC)$(TARGET_SUFFIX) $^
	$(TARGET_BIN_DIR)/$(TARGET_EXEC)$(TARGET_SUFFIX) bench
	$(RM) $(TARGET_BIN_DIR)/$(TARGET_EXEC)$(TARGET_SUFFIX)
	$(PGO_MERGE)
	$(CXX) $(CPPFLAGS_RELEASE) $(PGO_USE) $(SRC) -o $(TARGET_BIN_DIR)/$(TARGET_NAME)$(TARGET_SUFFIX) $^
	$(RM) *.profraw $(PGO_DATA)

release:
	$(eval TARGET_EXEC = $(TARGET_NAME)-release)
	$(CXX) $(CPPFLAGS_RELEASE) $(SRC) -o $(TARGET_BIN_DIR)/$(TARGET_NAME)$(TARGET_SUFFIX) $^

debug:
	$(eval TARGET_EXEC = $(TARGET_NAME)-debug)
	$(CXX) $(CPPFLAGS_DEBUG) $(SRC) -o $(TARGET_BIN_DIR)/$(TARGET_NAME)$(TARGET_SUFFIX) $^