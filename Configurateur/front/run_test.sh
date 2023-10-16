flutter test test/* --coverage 
genhtml coverage/lcov.info -o coverage/html
xdg-open coverage/html/index.html