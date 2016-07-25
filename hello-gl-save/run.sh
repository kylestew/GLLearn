gcc -Wno-deprecated -o $1 $1.c \
    -I/usr/local/include -L/usr/local/lib \
    -framework OpenGL -framework GLUT -lGLEW
