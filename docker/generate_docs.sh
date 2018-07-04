echo " Running ldoc for ${LUA_LIBRARIES} "

if [ -d "${DOCS_FOLDER:-docs}/style" ]; then
    ldoc -B "${LUA_LIBRARIES}" -d "${DOCS_FOLDER:-docs}" -s "${DOCS_FOLDER:-docs}/style" -a
else
    ldoc -B "${LUA_LIBRARIES}" -d "${DOCS_FOLDER:-docs}" -a
fi