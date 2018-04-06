UNAME := $(shell uname -s)
ifeq ($(UNAME),Darwin)
  OPEN := open
endif
ifeq ($(UNAME),Linux)
  OPEN := xdg-open
endif

OPAM=opam
EXEC=${OPAM} config exec --
DUNE=${EXEC} jbuilder

.PHONY: all build clean doc test top

all: build

build:
	@${DUNE} build -j 12 -f @install

clean:
	@${DUNE} clean

doc:
	@${DUNE} build @doc
ifdef OPEN
	@${OPEN} _build/default/_doc/lambda-battle/index.html
endif

top:
	@${DUNE} utop src/lib
