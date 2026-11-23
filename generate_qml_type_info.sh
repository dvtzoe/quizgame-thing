#!/usr/bin/env bash

mkdir -p build/qml/App

.venv/bin/pyside6-metaobjectdump -o build/app.json src/game/app.py
.venv/bin/pyside6-qmltyperegistrar \
    --generate-qmltypes=build/qml/App/app.qmltypes \
    --import-name=App --major-version=1 \
    build/app.json -o build/app_reg.cpp

printf 'module App\ntypeinfo app.qmltypes\n' > build/qml/App/qmldir
