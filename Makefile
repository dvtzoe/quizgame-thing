QML_FILES := $(shell find src -name "*.qml")
PY_FILES := $(shell find src -name "*.py")

VENV := .venv
VENV_BIN_DIR := $(VENV)/bin

GAME_ENTRY_POINT := src/game/app.py

QML_BUILD_DIR := qml-build
QML_DIR := $(QML_BUILD_DIR)/qml

RUFF := $(VENV_BIN_DIR)/ruff
QML_LINT := $(VENV_BIN_DIR)/pyside6-qmllint
QML_FORMAT := $(VENV_BIN_DIR)/pyside6-qmlformat

.PHONY: lint lint-fix qml-generate-types clean game

lint:
	make qml-generate-types
	$(RUFF) check $(PY_FILES)
	$(RUFF) format --check $(PY_FILES)
	$(QML_LINT) --qmldirs $(QML_DIR) $(QML_FILES)
	for file in $(QML_FILES); do \
		if ! $(QML_FORMAT) "$$file" | diff -u "$$file" - ; then \
			exit 1; \
		fi; \
	done

lint-fix:
	make qml-generate-types
	$(RUFF) check --fix $(PY_FILES)
	$(RUFF) format $(PY_FILES)
	$(QML_LINT) --qmldirs $(QML_DIR) --fix $(QML_FILES)
	$(QML_FORMAT) $(QML_FILES)


qml-generate-types:
	mkdir -p $(QML_DIR)/App
	$(VENV_BIN_DIR)/pyside6-metaobjectdump -o $(QML_BUILD_DIR)/app.json $(wildcard src/game/*.py)
	$(VENV_BIN_DIR)/pyside6-qmltyperegistrar \
	    --generate-qmltypes=$(QML_DIR)/App/app.qmltypes \
	    --import-name=App --major-version=1 \
	    $(QML_BUILD_DIR)/app.json -o $(QML_BUILD_DIR)/app_reg.cpp
	printf 'module App\ntypeinfo app.qmltypes\n' > $(QML_DIR)/App/qmldir

clean:
	rm -rf $(QML_BUILD_DIR)
	rm -rf $(VENV)

game:
	$(VENV_BIN_DIR)/python $(GAME_ENTRY_POINT)
