.PHONY: build build-debug run clean default install venv deps

VENV ?= .venv
PYTHON ?= $(VENV)/bin/python
PIP ?= $(VENV)/bin/pip

default: build

build: deps
	meson setup build
	ninja -C build

build-debug: deps
	meson setup build --buildtype=debug
	ninja -C build

venv:
	python3 -m venv $(VENV)

deps: venv
	$(PIP) install -r requirements-dev.txt
	source $(VENV)/bin/activate && pre-commit install

install: build
	ninja -C build install

run: build
	./build/waybar

debug-run: build-debug
	./build/waybar --log-level debug

test:
	meson test -C build --verbose --suite waybar
.PHONY: test

test-detailed:
	meson test -C build --verbose --print-errorlogs --test-args='--reporter console -s'
.PHONY: test-detailed

clean:
	rm -rf build
