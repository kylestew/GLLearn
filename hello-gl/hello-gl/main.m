#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
#include <GLUT/glut.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <stdio.h>
#include <stdlib.h>

#include "util.h"

#define PFNGLGETSHADERIVPROC typeof(glGetShaderiv) *
#define PFNGLGETSHADERINFOLOGPROC typeof(glGetShaderInfoLog) *


static struct {
    GLuint vertexBuffer;
    GLuint elementBuffer;

    GLuint textures[2];

    GLuint vertexShader;
    GLuint fragmentShader;
    GLuint program;

    struct {
        GLint timer;
        GLint textures[2];
    } uniforms;

    struct {
        GLint position;
    } attributes;

    GLfloat timer;
} gResources;

static const GLfloat VERTEX_BUFFER_DATA[] = {
    -1.0f, -1.0f, 0.0f, 1.0f,
    1.0f, -1.0f, 0.0f, 1.0f,
    -1.0f, 1.0f, 0.0f, 1.0f,
    1.0f, 1.0f, 0.0f, 1.0f};
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

    if (!pixels)
        return 0;

    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(
        GL_TEXTURE_2D, 0,         /* target, level */
        GL_RGB8,                  /* internal format */
        width, height, 0,         /* width, height, border */
        GL_BGR, GL_UNSIGNED_BYTE, /* external format, type */
        pixels                    /* pixels */
        );

    free(pixels);
    return texture;
}

static void showInfoLog(GLuint object,
                        PFNGLGETSHADERIVPROC glGet__iv,
                        PFNGLGETSHADERINFOLOGPROC glGet__InfoLog) {
    GLint log_length;
    char *log;

    glGet__iv(object, GL_INFO_LOG_LENGTH, &log_length);
    log = malloc(log_length);
    glGet__InfoLog(object, log_length, NULL, log);
    fprintf(stderr, "%s", log);
    free(log);
}

static GLuint makeShader(GLenum type, const char *filename) {
    GLint length;
    GLchar *source = file_contents(filename, &length);
    GLuint shader;
    GLint shaderOk;

    if (!source)
        return 0;

    shader = glCreateShader(type);
    glShaderSource(shader, 1, (const GLchar **)&source, &length);
    free(source);
    glCompileShader(shader);

    glGetShaderiv(shader, GL_COMPILE_STATUS, &shaderOk);
    if (!shaderOk) {
        fprintf(stderr, "Failed to compile %s:\n", filename);
        showInfoLog(shader, glGetShaderiv, glGetShaderInfoLog);
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}

static GLuint makeProgram(GLuint vertexShader, GLuint fragmentShader) {
    GLint programOk;

    GLuint program = glCreateProgram();

    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    glLinkProgram(program);

    glGetProgramiv(program, GL_LINK_STATUS, &programOk);
    if (!programOk) {
        fprintf(stderr, "Failed to link shader program\n");
        showInfoLog(program, glGetProgramiv, glGetProgramInfoLog);
        glDeleteProgram(program);
        return 0;
    }
    return program;
}


static int makeResources(void) {
    gResources.vertexBuffer = makeBuffer(GL_ARRAY_BUFFER, VERTEX_BUFFER_DATA, sizeof(VERTEX_BUFFER_DATA));
    gResources.elementBuffer = makeBuffer(GL_ELEMENT_ARRAY_BUFFER, ELEMENT_BUFFER_DATA, sizeof(ELEMENT_BUFFER_DATA));

    gResources.textures[0] = makeTexture("hello1.tga");
    gResources.textures[1] = makeTexture("hello2.tga");

    if (gResources.textures[0] == 0 || gResources.textures[1] == 0)
        return 0;

    gResources.vertexShader = makeShader(GL_VERTEX_SHADER, "hello-gl.v.glsl");
    gResources.fragmentShader = makeShader(GL_FRAGMENT_SHADER, "hello-gl.f.glsl");
    if (gResources.vertexShader == 0 || gResources.fragmentShader == 0)
        return 0;

    gResources.program = makeProgram(gResources.vertexShader, gResources.fragmentShader);
    if (gResources.program == 0)
        return 0;

    gResources.uniforms.timer = glGetUniformLocation(gResources.program, "timer");
    gResources.uniforms.textures[0] = glGetUniformLocation(gResources.program, "textures[0]");
    gResources.uniforms.textures[1] = glGetUniformLocation(gResources.program, "textures[1]");

    gResources.attributes.position = glGetAttribLocation(gResources.program, "position");

    return 1;
}

static void update(void) {
    int milliseconds = glutGet(GLUT_ELAPSED_TIME);
    gResources.timer = (float)milliseconds * 0.001f;
    glutPostRedisplay();
}

static void render(void) {
    glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    glUseProgram(gResources.program);

    glUniform1f(gResources.uniforms.timer, gResources.timer);

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, gResources.textures[0]);
    glUniform1i(gResources.uniforms.textures[0], 0);

    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, gResources.textures[1]);
    glUniform1i(gResources.uniforms.textures[1], 1);

    glBindBuffer(GL_ARRAY_BUFFER, gResources.vertexBuffer);
    glVertexAttribPointer(
        gResources.attributes.position, /* attribute */
        4,                              /* size */
        GL_FLOAT,                       /* type */
        GL_FALSE,                       /* normalized? */
        sizeof(GLfloat) * 4,            /* stride */
        (void *)0                       /* array buffer offset */
        );
    glEnableVertexAttribArray(gResources.attributes.position);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, gResources.elementBuffer);
    glDrawElements(
        GL_TRIANGLE_STRIP, /* mode */
        4,                 /* count */
        GL_UNSIGNED_SHORT, /* type */
        (void *)0          /* element array buffer offset */
        );

    glDisableVertexAttribArray(gResources.attributes.position);
    glutSwapBuffers();
}

int main(int argc, char **argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE);
    glutInitWindowSize(400, 300);
    glutCreateWindow("Hello World");
    glutIdleFunc(&update);
    glutDisplayFunc(&render);

    if (!makeResources()) {
        fprintf(stderr, "Failed to load resources\n");
        return 1;
    }

    glutMainLoop();
    return 0;
}
