echo "... installing mocka luacov and luacov-coberutra ..." \
    && cd /tmp/mocka/ \
    && sudo luarocks make mocka-1.0-1.rockspec \
    && sudo luarocks install luacov