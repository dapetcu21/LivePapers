EXECUTABLE=livepapersd
all: $(EXECUTABLE) 

LD_FLAGS = 
CXX = c++
CXX_FLAGS = -W -Wall -Wno-unused-parameter -O2
INSTALL_PATH = /usr/local/bin/
SOURCES=main.cpp
OBJECTS=$(SOURCES:.cpp=.o)

$(EXECUTABLE): $(SOURCES) $(LIBPORTAUDIO)
	$(CXX) $(CXX_FLAGS) $(LD_FLAGS) $(SOURCES) -o $@

clean:
	rm -f $(EXECUTABLE)

install: all
	mkdir -p $(INSTALL_PATH)
	cp $(EXECUTABLE) $(INSTALL_PATH)
