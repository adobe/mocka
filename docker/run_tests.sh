#!/bin/sh

lua -lluacov run_tests.lua \
    && luacov-cobertura -o coverage_report.xml