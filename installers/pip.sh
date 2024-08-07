#!/usr/bin/env bash

NAME=$1
PIP_ARGS=$2

mkdir -p "${HOME}"/.local/bin
mkdir -p "${HOME}"/.local/share/py

VENV="${HOME}/.local/share/py/${NAME}"
BIN="${HOME}/.local/bin/${NAME}"

echo "remove previous ${BIN} ${VENV}"
rm -rf "${BIN}" "${VENV}"

echo "create venv ${VENV}"
python -m venv --copies "${VENV}"
#ls "${HOME}"/.local/share/py

echo "install ${NAME}"
"${VENV}"/bin/pip install -U pip
"${VENV}"/bin/pip install -U "${NAME}" "${PIP_ARGS}"

echo "link binary ${VENV}/bin/${NAME} -> ${BIN}"
ln -s "${VENV}/bin/${NAME}" "${BIN}"


