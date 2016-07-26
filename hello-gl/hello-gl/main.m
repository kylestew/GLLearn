#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
#include <GLUT/glut.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <stdio.h>
#include <stdlib.h>

#include "util.h"


static struct {
    GLuint vertexBuffer;
    GLuint elementBuffer;
    GLuint textures[2];
} gResources;

static const GLfloat VERTEX_BUFFER_DATA[] = {
    -1.0f, -1.0f,
    1.0f, -1.0f,
    -1.0f, 1.0f,
    1.0f, 1.0f};
static const GLushort ELEMENT_BUFFER_DATA[] = {
    0, 1, 2, 3};

#pragma mark - OpenGL Creation Helpers
static GLuint makeBuffer(GLenum target, const void *buffer_data, GLsizei buffer_size) {
    GLuint buffer;
    // generate
    // bind
    // fill
    glGenBuffers(1, &buffer);
    glBindBuffer(target, buffer);
    glBufferData(target, buffer_size, buffer_data, GL_STATIC_DRAW);
    return buffer;
}

static GLuint makeTexture(const char *filename) {
    int width, height;
    void *pixels = read_tga(filename, &width, &height);
    GLuint texture;

    glGenTextures(1, &texture);

    return texture;
}


static int makeResources(void) {
    gResources.vertexBuffer = makeBuffer(GL_ARRAY_BUFFER, VERTEX_BUFFER_DATA, sizeof(VERTEX_BUFFER_DATA));
    gResources.vertexBuffer = makeBuffer(GL_ELEMENT_ARRAY_BUFFER, ELEMENT_BUFFER_DATA, sizeof(ELEMENT_BUFFER_DATA));

    gResources.textures[0] = makeTexture("hello1.tga");
    gResources.textures[1] = makeTexture("hello2.tga");

    return 1;
}

static void update_fade_factor(void) {
}

static void render(void) {
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    glutSwapBuffers();
}

int main(int argc, char **argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE);
    glutInitWindowSize(400, 300);
    glutCreateWindow("Hello World");
    glutIdleFunc(&update_fade_factor);
    glutDisplayFunc(&render);

    if (!makeResources()) {
        fprintf(stderr, "Failed to load resources\n");
        return 1;
    }

    glutMainLoop();
    return 0;
}
