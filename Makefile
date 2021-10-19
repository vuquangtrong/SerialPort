LIBNAME=libserial.so
LIB_VERSION=1.0.0

CC=gcc
CXX=g++
CFLAGS= -Ofast -Wall
LIKER_LIBS=

SHARED_LINKER_FLAGS= -shared -Wl,-soname,libserial.so
SHARED_LINKER_LIBS=

LIB_DIR=/usr/local/lib
HEADER_DIR=/usr/local/include/serial

LDCONFIG=ldconfig

OBJECTS=SerialPort.o

all: $(LIBNAME)

# Make the library
$(LIBNAME): $(OBJECTS)
	@echo "[Linking]"
	$(CXX) $(SHARED_LINKER_FLAGS) $(CFLAGS) -o $(LIBNAME) $^ $(SHARED_LINKER_LIBS)

# Library parts
SerialPort.o: SerialPort.cpp
	$(CXX) -fPIC $(CFLAGS) -c $^ $(LIKER_LIBS)

# clear build files
clean:
	@echo "[Cleaning]"
	rm -rf *.o $(LIBNAME)

install: all install-libs install-headers

# Install the library to LIBPATH
install-libs:
	@echo "[Installing Libs to $(LIB_DIR)]"
	@if ( test ! -d $(LIB_DIR) ); then mkdir -p $(LIB_DIR); fi
	@install -m 0755 $(LIBNAME) $(LIB_DIR)
ifneq ($(LDCONFIG),)
	@$(LDCONFIG)
endif

install-headers:
	@echo "[Installing Headers to $(HEADER_DIR)]"
	@mkdir -p $(HEADER_DIR)/$(DRIVER_DIR)
	@install -m 0644 *.h $(HEADER_DIR)
