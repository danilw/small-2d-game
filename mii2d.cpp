#include <nanogui/opengl.h>
#include <nanogui/glutil.h>
#include <nanogui/screen.h>
#include <nanogui/window.h>
#include <nanogui/layout.h>
#include <nanogui/label.h>
#include <nanogui/checkbox.h>
#include <nanogui/button.h>
#include <nanogui/toolbutton.h>
#include <nanogui/popupbutton.h>
#include <nanogui/combobox.h>
#include <nanogui/progressbar.h>
#include <nanogui/entypo.h>
#include <nanogui/messagedialog.h>
#include <nanogui/textbox.h>
#include <nanogui/slider.h>
#include <nanogui/imagepanel.h>
#include <nanogui/imageview.h>
#include <nanogui/vscrollpanel.h>
#include <nanogui/colorwheel.h>
#include <nanogui/colorpicker.h>
#include <nanogui/graph.h>
#include <nanogui/tabwidget.h>
#include <iostream>
#include <string>
#include <emscripten.h>
#include <random>
#include "emscripten/html5.h"
#include <cmath>

// Includes for the GLTexture class.
#include <cstdint>
#include <memory>
#include <utility>

#include "Box2D/Box2D.h"


#if defined(__GNUC__)
#pragma GCC diagnostic ignored "-Wmissing-field-initializers"
#endif
#if defined(_WIN32)
#pragma warning(push)
#pragma warning(disable: 4457 4456 4005 4312)
#endif

//#define STB_IMAGE_IMPLEMENTATION
#include <stb_image.h>

#if defined(_WIN32)
#pragma warning(pop)
#endif
#if defined(_WIN32)
#if defined(APIENTRY)
#undef APIENTRY
#endif
#include <windows.h>
#endif

using std::cout;
using std::cerr;
using std::endl;
using std::string;
using std::vector;
using std::pair;
using std::to_string;

//random
std::random_device rd;
std::mt19937 rng(rd());

//support drawing types
#define B_TRI 0
#define B_RECT 1
#define B_CIRCLE 2

#define TILE_SDF 0
#define TILE_0 1
#define TILE_1 2
#define TILE_2 3
#define TILE_2_2 4
#define TILE_3 5
#define TILE_3_2 6
#define TILE_4 7
#define TILE_4_2 8
#define TILE_SDF_SPAWN 9
#define TILE_PLAYER 10

#define B_TRI_vertexCount 32//1 //single triangle
#define B_RECT_vertexCount 2 //two triangles
#define B_CIRCLE_vertexCount 32 //many triangles

bool animonce = true;
float animtime = 15 + 8 + 2;

class GLTexture {
public:
    using handleType = std::unique_ptr<uint8_t[], void(*)(void*) >;
    GLTexture() = default;

    GLTexture(const std::string& textureName)
    : mTextureName(textureName), mTextureId(0) {
    }

    GLTexture(const std::string& textureName, GLint textureId)
    : mTextureName(textureName), mTextureId(textureId) {
    }

    GLTexture(const GLTexture& other) = delete;

    GLTexture(GLTexture&& other) noexcept
    : mTextureName(std::move(other.mTextureName)),
    mTextureId(other.mTextureId) {
        other.mTextureId = 0;
    }
    GLTexture& operator=(const GLTexture& other) = delete;

    GLTexture& operator=(GLTexture&& other) noexcept {
        mTextureName = std::move(other.mTextureName);
        std::swap(mTextureId, other.mTextureId);
        return *this;
    }

    ~GLTexture() noexcept {
        if (mTextureId)
            glDeleteTextures(1, &mTextureId);
    }

    GLuint texture() const {
        return mTextureId;
    }

    const std::string& textureName() const {
        return mTextureName;
    }

    /**
     *  Load a file in memory and create an OpenGL texture.
     *  Returns a handle type (an std::unique_ptr) to the loaded pixels.
     */
    handleType load(const std::string& fileName, bool q, bool exf) {
        if (mTextureId) {
            glDeleteTextures(1, &mTextureId);
            mTextureId = 0;
        }
        int force_channels = 0;
        int w, h, n;
        handleType textureData(stbi_load(fileName.c_str(), &w, &h, &n, force_channels), stbi_image_free);
        if (!textureData) {
            throw std::invalid_argument("Could not load texture data from file " + fileName);
        }
        glGenTextures(1, &mTextureId);
        glBindTexture(GL_TEXTURE_2D, mTextureId);
        GLint internalFormat;
        GLint format;
        switch (n) {
            case 1: internalFormat = GL_R8;
                format = GL_RED;
                break;
            case 2: internalFormat = GL_RG8;
                format = GL_RG;
                break;
            case 3: internalFormat = GL_RGB8;
                format = GL_RGB;
                break;
            case 4: internalFormat = GL_RGBA8;
                format = GL_RGBA;
                break;
            default: internalFormat = 0;
                format = 0;
                break;
        }
        glTexImage2D(GL_TEXTURE_2D, 0, internalFormat, w, h, 0, format, GL_UNSIGNED_BYTE, textureData.get());

        if (!exf) {
            if (!q) {
                glGenerateMipmap(GL_TEXTURE_2D);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
            } else {
                glGenerateMipmap(GL_TEXTURE_2D);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

            }
        } else {
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        }
        return textureData;
    }

private:
    std::string mTextureName;
    GLuint mTextureId;
};

Eigen::Vector2f rotate2d(float originx, float originy, float pointx, float pointy, float radian) {

    float s = std::sin(radian);
    float c = std::cos(radian);
    pointx -= originx;
    pointy -= originy;
    float xnew = pointx * c - pointy * s;
    float ynew = pointx * s + pointy * c;
    Eigen::Vector2f retval;
    retval[0] = xnew + originx;
    retval[1] = ynew + originy;
    return retval;

}

float angle2d(float cx, float cy, float ex, float ey) {
    float dy = ey - cy;
    float dx = ex - cx;
    float theta = std::atan2(dy, dx);
    return theta;
}

int squaresize = 44;

// w/h in pixels for types on 1366x768 screen
int type_RECT_size[2] = {squaresize, squaresize};
//int type_RECT_angles = 4;

int type_CIRCLE_size[2] = {squaresize, squaresize};
//int type_CIRCLE_angles = 320; //this is not polygons

int type_TRI_size[2] = {squaresize, squaresize};
//int type_TRI_angles = 3;

int type_PLAYER_size[2] = {90, 90};
int type_RECT_tile_size[2] = {50, 50};

class spawn_me {
public:
    float x = 0;
    float y = 0;
    int type_m = 0;
    int tile_m = 0;
    bool its = false;
    bool bkfw = false;
    float fposx = 0;
    float fposy = 0;
    float xscale = 0;

    void set_vals(int lx, int ly, int ltype_m, int ltile_m, bool lits, bool lbkfw, float fposxl, float fposyl, float xs) {
        x = lx;
        y = ly;
        type_m = ltype_m;
        tile_m = ltile_m;
        its = lits;
        bkfw = lbkfw;
        fposx = fposxl;
        fposy = fposyl;
        xscale = xs;
        recalc_size();
    }

    spawn_me() {
    }

    void recalc_size() {
        x = xscale + x*fposx;
        y = y*fposy;
    }

};

class m_body {
public:
    float WIDTH = 0;
    float HEIGHT = 0;

    float fb_WIDTH = 0;
    float fb_HEIGHT = 0;

    //resize scale base on current resolution
    float fposx = 0;
    float fposy = 0;
    float xscale = 0;
    float l_shift = 0;



    //int shape_angles = 0;
    int vertex_Count = 0;


    int type_m = 0; // B_TRI/RECT/CIRCLE
    int tile_m = 0; //tile TILE_SDF...
    int newc = 0;

    float x = 0;
    float y = 0;
    float angle = 0;

    m_body() {
    }

    void set_vals(float xl, float yl, float anglel, int t, float fposxl, float fposyl, float xs, int ti, float lsh) {
        type_m = t;
        tile_m = ti;
        newc = 0;
        if (tile_m > 100) {
            tile_m = tile_m - 100;
            newc = 100;
        } else
            if (tile_m > 10) {
            tile_m = tile_m - 10;
            newc = 10;
        }
        x = xl;
        y = yl;
        angle = anglel;
        fposx = fposxl;
        fposy = fposyl;
        xscale = xs;
        l_shift = lsh;
        recalc_size();
    }

private:

    void recalc_size() {
        if ((tile_m == TILE_SDF) || ((tile_m == TILE_SDF_SPAWN)) || (tile_m == TILE_PLAYER)) {
            if (type_m == B_RECT) {
                x = xscale + x*fposx;
                y = y*fposy;
                HEIGHT = WIDTH = type_RECT_size[1] * fposy;
                fb_WIDTH = fb_HEIGHT = (sqrt(type_RECT_size[0] * type_RECT_size[0] + type_RECT_size[1] * type_RECT_size[1]) + 8.) * fposy; //+8(4 on each side) extra pixels for AA
                //shape_angles = type_RECT_angles;
                vertex_Count = B_RECT_vertexCount;
            }
            if (type_m == B_CIRCLE) {
                x = xscale + x*fposx;
                y = y*fposy;
                HEIGHT = WIDTH = type_CIRCLE_size[1] * fposy;
                if (tile_m == TILE_PLAYER)HEIGHT = WIDTH = type_PLAYER_size[1] * fposy;
                fb_WIDTH = fb_HEIGHT = (type_CIRCLE_size[0] + 8.) * fposy; //+8(4 on each side) extra pixels for AA
                if (tile_m == TILE_PLAYER)fb_WIDTH = fb_HEIGHT = (type_PLAYER_size[0] + 8.) * fposy;
                //shape_angles = type_CIRCLE_angles;
                vertex_Count = B_CIRCLE_vertexCount;
            }
            if (type_m == B_TRI) {
                x = xscale + x*fposx;
                y = y*fposy;
                HEIGHT = WIDTH = type_TRI_size[1] * fposy;
                fb_WIDTH = fb_HEIGHT = (type_TRI_size[0] + 8.) * fposy; //+8(4 on each side) extra pixels for AA
                //shape_angles = type_CIRCLE_angles;
                vertex_Count = B_TRI_vertexCount;
            }

        } else {
            x = xscale + x*fposx;
            y = y*fposy;
            HEIGHT = WIDTH = type_RECT_tile_size[1] * fposy;
            fb_WIDTH = fb_HEIGHT = HEIGHT;
            //shape_angles = type_RECT_angles;
            vertex_Count = B_RECT_vertexCount;
        }
    }

};

bool game_over_win = false;
bool game_over_lose = false;
float wtime = 0;

class box2dhelper_uni {
public:
    //game board size
    const int WIDTH = 1360;
    const int HEIGHT = 760;

    static const int maxobj = 25000;
    m_body m_bodyes[maxobj];
    spawn_me s_bodyes[maxobj];
    int numobj = 0;
    int num_onscr_obj = 0;
    int to_spawn = 0;

    //current resolution
    float sWIDTH = 1366;
    float sHEIGHT = 768;

    float player_rot = 0;
    float playerpos_x = 0;
    float playerpos_y = 0;

    float boardpos_x = 0.;
    float boardpos_y = 0.;
    bool jumpx = false;

    //resize scale base on current resolution
    float fposx = 1.;
    float fposy = 1.;

    //anim control
    bool ppowerht = false;
    float ppower = 0.;
    float ppowerx = 0.;
    float ppowery = 0.;
    float ppowercd = 2.;
    bool ppowerhn = false;
    float ppowerhitr = 0.;
    float ppowerhitrm = 1.;
    float appowercd = 0.;
    float jcd = 1.;
    float ajcd = 1.;
    float ajcd2 = 0.;

    //to box2d meters
    const float M2P = 80.0f;
    const float P2M = 1.0f / M2P;

    float timeStep = 1.0f / 10.0f; //min tick
    int velocityIterations = 6; //box2d val
    int positionIterations = 3; //box2d val

    bool resetx = false; //reset pressed

    struct myUserData {
        int hp;
        int type_m;
        int tile_m;
        float l_shift;
        float l_spawn;
        bool its;
        bool bkfw;
        bool deleteme;
    };

    b2World* world;

    b2RevoluteJoint* wheel;

    box2dhelper_uni() {

    }

    void updpsize() {
        float tsWIDTH = sHEIGHT * ((float) WIDTH / HEIGHT);
        fposx = (float) tsWIDTH / WIDTH;
        fposy = (float) sHEIGHT / HEIGHT;
    }

    void Edge() {
        {
            b2BodyDef bodydef;
            bodydef.position.Set(0.f, HEIGHT * P2M);
            b2Body* grbody = world->CreateBody(&bodydef);
            b2Vec2 v1(-WIDTH * P2M / 2., 0.0f);
            b2Vec2 v2(WIDTH * P2M * 2, 0.0f);
            b2EdgeShape edge;
            b2FixtureDef fixtureshape;
            fixtureshape.filter.categoryBits = 0x0002;
            //fixtureshape.filter.maskBits=4;
            fixtureshape.shape = &edge;
            fixtureshape.friction = 0.01f;
            edge.Set(v1, v2);
            grbody->CreateFixture(&fixtureshape);
        }

        {
            b2BodyDef bodydef;
            bodydef.position.Set(0.f, HEIGHT * P2M);
            b2Body* grbody = world->CreateBody(&bodydef);
            b2Vec2 v1(0.0f, 0.0f);
            b2Vec2 v2(0.0f, -HEIGHT * P2M * 20);
            b2EdgeShape edge;
            b2FixtureDef fixtureshape;
            fixtureshape.filter.categoryBits = 0x0002;
            //fixtureshape.filter.maskBits=4;
            fixtureshape.shape = &edge;
            fixtureshape.friction = 0.01f;
            edge.Set(v1, v2);
            grbody->CreateFixture(&fixtureshape);
        }

        {
            b2BodyDef bodydef;
            bodydef.position.Set(0.f, HEIGHT * P2M);
            b2Body* grbody = world->CreateBody(&bodydef);
            b2Vec2 v1(WIDTH*P2M, 0.0f);
            b2Vec2 v2(WIDTH*P2M, -HEIGHT * P2M * 20);
            b2EdgeShape edge;
            b2FixtureDef fixtureshape;
            fixtureshape.filter.categoryBits = 0x0002;
            //fixtureshape.filter.maskBits=4;
            fixtureshape.shape = &edge;
            fixtureshape.friction = 0.01f;
            edge.Set(v1, v2);
            grbody->CreateFixture(&fixtureshape);
        }

    }




#define _NL_ opxa=-2.*(type_RECT_tile_size[0]) * fposy;opya += -(type_RECT_tile_size[0]) * fposy;
#define _L__ opxa+= (type_RECT_tile_size[0]) * fposy;
#define _x0a add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_0,false,false);
#define _x1a add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_1,false,false);
#define _x2b add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_2_2,false,false);
#define _x2a add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_2,false,false);
#define _x3b add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_3_2,false,false);
#define _x3a add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_3,false,false);
#define _x4b add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_4_2,false,false);
#define _x4a add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_4,false,false);

#define _x0c add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_0+10,false,false);
#define _x1c add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_1+10,false,false);
#define _x2d add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_2_2+10,false,false);
#define _x2c add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_2+10,false,false);
#define _x3d add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_3_2+10,false,false);
#define _x3c add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_3+10,false,false);
#define _x4d add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_4_2+10,false,false);
#define _x4c add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_4+10,false,false);

#define _x1e add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_1+100,false,false);
#define _x2f add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_2_2+100,false,false);
#define _x2e add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_2+100,false,false);

#define _x5a add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_SDF_SPAWN,true,false);
#define _x5b add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_CIRCLE, TILE_SDF_SPAWN,true,false);
#define _x5c add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_TRI, TILE_SDF_SPAWN,true,false);
#define _x5d add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_RECT, TILE_SDF_SPAWN,true,true);
#define _x5e add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_CIRCLE, TILE_SDF_SPAWN,true,true);
#define _x5f add_obj((opxa+=(type_RECT_tile_size[0]) * fposy)+(type_RECT_tile_size[0]) * fposy/2., opya+(type_RECT_tile_size[0]) * fposy/2., B_TRI, TILE_SDF_SPAWN,true,true);

    //game map

    void genmap() {
        int linex = 69;
        int opxa = -2. * (type_RECT_tile_size[0]) * fposy;
        int opya = linex * (type_RECT_tile_size[0]) * fposy + (type_RECT_tile_size[0]) * fposy / 2.;
        //static map no random
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x5e _L__ _x2b _x2f _x1e _x1e _x1e _x1e _x1e _x1e _x1e _x1e _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _x2d _x1c _x1c _x1c _x2c _L__ _L__ _x2d _x1c _x1c _x1c _x2c _L__ _x4b _x0a _x0a _x0a _x0a _x0a _x0a _x0a _x0a _x0a _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _x5a _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _x2d _x1c _x1c _x1c _x2c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _x1c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x1c _x1c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x1c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x5a _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x2d _x1c _x1c _x2c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x1c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x5e _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x2d _x1c _x1c _x1c _x2c _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x5d _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x1c _L__ _L__ _x1c _x1c _L__ _L__ _x1c _x1c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x5f _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x1c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _x1c _x1c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _x5b _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _x1c _x1c _x1c _x2c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x5d _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _x2d _x1c _x1c _x1c _x2c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x1c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _x1c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x1c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x1c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x2d _x1c _x1c _x1c _x2c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x1c _x1c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x1c _x1c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x1c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x1c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x5b _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x2d _x1c _x1c _x1c _x1c _x2c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x2d _x1c _x2c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x4d _x0c _x4c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x4d _x0c _x4c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x1c _L__ _x4d _x0c _x4c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x4d _x0c _x4c _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x5f _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _x2b _x1a _x1a _x1a _x1a _x1a _x1a _x1a _x2a _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _x5b _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _x2b _x1a _x2a _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _x4b _x0a _x4a _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _x4b _x0a _x4a _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _x4b _x0a _x4a _L__ _x2b _x2a _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _x4b _x0a _x4a _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _x4b _x0a _x4a _L__ _L__ _L__ _x5a _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _x4b _x0a _x4a _L__ _L__ _L__ _x2b _x1a _x1a _x1a _x2a _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _x4b _x0a _x4a _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _L__ _L__ _L__ _x4b _x0a _x4a _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _x2b _x2a _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _L__ _NL_
        _x2b _x1a _x1a _x3a _x0a _x3b _x1a _x1a _x1a _x1a _x1a _x1a _x1a _x1a _x1a _x1a _x3a _x3b _x1a _x1a _x1a _x1a _x1a _x1a _x1a _x1a _x1a _x1a _x2a

    }

    b2Body* addRect(int x, int y, int w, int h, bool dyn = true) {
        b2BodyDef bodydef;
        bodydef.position.Set(x*P2M, y * P2M);
        bodydef.fixedRotation = true;
        if (dyn)
            bodydef.type = b2_dynamicBody;
        b2Body* body = world->CreateBody(&bodydef);

        b2PolygonShape shape;
        shape.SetAsBox(P2M * w / 2, P2M * h / 2);

        b2FixtureDef fixturedef;
        fixturedef.shape = &shape;
        fixturedef.density = 1.0;
        body->CreateFixture(&fixturedef);
        return body;
    }

    void add_obj(float x, float y, int type_m, int tile_m, bool its, bool bkfw) {
        if (numobj >= maxobj)return;
        x = x - (sWIDTH - sHEIGHT * ((float) WIDTH / HEIGHT)) / 2.;
        x /= fposx;
        y /= fposy;
        x = WIDTH - x;
        y = HEIGHT - y;

        if ((tile_m == TILE_SDF) || (tile_m == TILE_PLAYER)) {
            if (tile_m == TILE_PLAYER) {
                b2BodyDef bodydef;
                myUserData* myS = new myUserData;
                myS->type_m = B_CIRCLE;
                myS->tile_m = tile_m;
                myS->hp = 10;
                myS->its = its;
                myS->bkfw = bkfw;
                myS->l_spawn = 0;
                std::uniform_int_distribution<int> uni(0, 400);
                int cx = uni(rng);
                myS->l_shift = cx / (float) 100.;
                myS->l_shift = 0.;
                myS->deleteme = false;
                bodydef.position.Set((x) * P2M, y * P2M);
                bodydef.type = b2_dynamicBody;
                b2Body* body = world->CreateBody(&bodydef);
                b2CircleShape circle;
                circle.m_p.Set(0, 0);
                circle.m_radius = P2M * type_CIRCLE_size[0] / 2.f;
                if (tile_m == TILE_PLAYER)circle.m_radius = P2M * type_PLAYER_size[0] / 2.f;
                b2FixtureDef fixturedef;
                fixturedef.shape = &circle;
                fixturedef.density = .3;
                fixturedef.friction = 0.8f;
                if (tile_m != TILE_PLAYER)body->SetFixedRotation(true);
                body->SetUserData(myS);
                body->CreateFixture(&fixturedef);
                b2Fixture *tempF = body->GetFixtureList();
                b2Filter temp = tempF->GetFilterData();
                temp.maskBits = 0xFFFF & ~0x0008;
                tempF->SetFilterData(temp);

                b2Body* body1 = addRect(x, y, 1, 1);
                b2RevoluteJointDef jointDef;
                jointDef.bodyA = body1;
                jointDef.bodyB = body;
                jointDef.localAnchorA.Set(0 * P2M, 0 * P2M);
                jointDef.localAnchorB.Set(0, 0);
                jointDef.enableMotor = true;
                jointDef.maxMotorTorque = 3.0;
                wheel = (b2RevoluteJoint*) world->CreateJoint(&jointDef);

                numobj++;
            } else
                if (type_m == B_CIRCLE) {
                b2BodyDef bodydef;
                myUserData* myS = new myUserData;
                myS->type_m = B_CIRCLE;
                myS->tile_m = tile_m;
                myS->hp = 10;
                myS->its = its;
                myS->bkfw = bkfw;
                myS->l_spawn = 0;
                myS->deleteme = false;
                std::uniform_int_distribution<int> uni(0, 400);
                int cx = uni(rng);
                myS->l_shift = cx / (float) 100.;
                bodydef.position.Set((x) * P2M, y * P2M);
                bodydef.type = b2_dynamicBody;
                b2Body* body = world->CreateBody(&bodydef);
                b2CircleShape circle;
                circle.m_p.Set(0, 0);
                circle.m_radius = P2M * type_CIRCLE_size[0] / 2.f;
                if (tile_m == TILE_PLAYER)circle.m_radius = P2M * type_PLAYER_size[0] / 2.f;
                b2FixtureDef fixturedef;
                fixturedef.shape = &circle;
                fixturedef.friction = 0.1f;
                fixturedef.density = 1.0;
                if (tile_m != TILE_PLAYER)body->SetFixedRotation(true);
                body->SetUserData(myS);
                body->CreateFixture(&fixturedef);
                b2Fixture *tempF = body->GetFixtureList();
                b2Filter temp = tempF->GetFilterData();
                temp.maskBits = 0xFFFF & ~0x0008;
                tempF->SetFilterData(temp);
                if (its)body->ApplyLinearImpulse(body->GetMass() *(b2Vec2((bkfw ? 1 : -1) * body->GetMass() *(15. + 10 * (cx / (float) 100.)), 0.)), body->GetWorldCenter(), true);
                numobj++;
            }

            if (type_m == B_RECT) {
                b2BodyDef bodydef;
                myUserData* myS = new myUserData;
                myS->type_m = B_RECT;
                myS->tile_m = tile_m;
                myS->hp = 10;
                myS->its = its;
                myS->bkfw = bkfw;
                myS->l_spawn = 0;
                myS->deleteme = false;
                std::uniform_int_distribution<int> uni(0, 400);
                int cx = uni(rng);
                myS->l_shift = cx / (float) 100.;
                bodydef.position.Set((x) * P2M, y * P2M);
                bodydef.type = b2_dynamicBody;
                b2Body* body = world->CreateBody(&bodydef);
                b2PolygonShape shape;
                shape.SetAsBox(P2M * type_RECT_size[0] / 2.f, P2M * type_RECT_size[1] / 2.f);
                b2FixtureDef fixturedef;
                fixturedef.shape = &shape;
                fixturedef.density = 1.0;
                fixturedef.friction = 0.1f;
                body->SetUserData(myS);
                body->CreateFixture(&fixturedef);
                b2Fixture *tempF = body->GetFixtureList();
                b2Filter temp = tempF->GetFilterData();
                temp.maskBits = 0xFFFF & ~0x0008;
                tempF->SetFilterData(temp);
                if (its)body->ApplyLinearImpulse(body->GetMass() *(b2Vec2((bkfw ? 1 : -1) * body->GetMass() *(15. + 10 * (cx / (float) 100.)), 0.)), body->GetWorldCenter(), true);
                numobj++;
            }

            if (type_m == B_TRI) {
                y += -type_TRI_size[1] / 2.;
                b2BodyDef bodydef;
                myUserData* myS = new myUserData;
                myS->type_m = B_TRI;
                myS->tile_m = tile_m;
                myS->hp = 10;
                myS->its = its;
                myS->bkfw = bkfw;
                myS->l_spawn = 0;
                myS->deleteme = false;
                std::uniform_int_distribution<int> uni(0, 400);
                int cx = uni(rng);
                myS->l_shift = cx / (float) 100.;
                bodydef.position.Set((x) * P2M, y * P2M);
                bodydef.type = b2_dynamicBody;
                b2Body* body = world->CreateBody(&bodydef);
                b2PolygonShape shape;
                b2Vec2 vertices[3];

                Eigen::Vector2f rt = rotate2d(0., type_TRI_size[1] / 2., 0., 0., (2. * b2_pi) / 3.);
                //because I render triangle in rectangle, triangle in circle that in rectangle(square size type_TRI_size[0 1])
                float n_tri = (type_TRI_size[1] - rt.y()) / 2.;

                rt = rotate2d(0., (type_TRI_size[1] + n_tri) / 2., 0., 0., 0.);
                vertices[0].Set(P2M * rt.x(), P2M * rt.y());
                rt = rotate2d(0., (type_TRI_size[1] + n_tri) / 2., 0., 0., (2. * b2_pi) / 3.);
                vertices[1].Set(P2M * rt.x(), P2M * rt.y());
                rt = rotate2d(0., (type_TRI_size[1] + n_tri) / 2., 0., 0., ((2. * b2_pi) / 3.)*2.);
                vertices[2].Set(P2M * rt.x(), P2M * rt.y());
                shape.Set(vertices, 3);
                b2FixtureDef fixturedef;
                fixturedef.shape = &shape;
                fixturedef.density = 1.0;
                fixturedef.friction = 0.1f;
                body->SetUserData(myS);
                body->CreateFixture(&fixturedef);
                b2Fixture *tempF = body->GetFixtureList();
                b2Filter temp = tempF->GetFilterData();
                temp.maskBits = 0xFFFF & ~0x0008;
                tempF->SetFilterData(temp);
                if (its)body->ApplyLinearImpulse(body->GetMass() *(b2Vec2((bkfw ? 1 : -1) * body->GetMass() *(35. + 10 * (cx / (float) 100.)), 0.)), body->GetWorldCenter(), true);
                numobj++;
            }
        } else
            if (tile_m == TILE_SDF_SPAWN) {
            if (type_m == B_CIRCLE) {
                b2BodyDef bodydef;
                myUserData* myS = new myUserData;
                myS->type_m = B_CIRCLE;
                myS->tile_m = tile_m;
                myS->hp = 10;
                myS->its = its;
                myS->l_spawn = 0;
                myS->bkfw = bkfw;
                myS->deleteme = false;
                std::uniform_int_distribution<int> uni(0, 400);
                int cx = uni(rng);
                myS->l_shift = cx / (float) 100.;
                bodydef.position.Set((x) * P2M, y * P2M);
                bodydef.type = b2_staticBody;
                b2Body* body = world->CreateBody(&bodydef);
                b2CircleShape circle;
                circle.m_p.Set(0, 0);
                circle.m_radius = P2M * type_CIRCLE_size[0] / 2.f;
                b2FixtureDef fixturedef;
                fixturedef.filter.categoryBits = 0x0008;
                fixturedef.shape = &circle;
                fixturedef.density = 1.0;
                fixturedef.friction = 0.1f;
                body->SetFixedRotation(true);
                body->SetUserData(myS);
                body->CreateFixture(&fixturedef);
                numobj++;
            }

            if (type_m == B_RECT) {
                b2BodyDef bodydef;
                myUserData* myS = new myUserData;
                myS->type_m = B_RECT;
                myS->tile_m = tile_m;
                myS->hp = 10;
                myS->its = its;
                myS->l_spawn = 0;
                myS->bkfw = bkfw;
                myS->deleteme = false;
                std::uniform_int_distribution<int> uni(0, 400);
                int cx = uni(rng);
                myS->l_shift = cx / (float) 100.;
                bodydef.position.Set((x) * P2M, y * P2M);
                bodydef.type = b2_staticBody;
                b2Body* body = world->CreateBody(&bodydef);
                b2PolygonShape shape;
                shape.SetAsBox(P2M * type_RECT_size[0] / 2.f, P2M * type_RECT_size[1] / 2.f);
                b2FixtureDef fixturedef;
                fixturedef.filter.categoryBits = 0x0008;
                fixturedef.shape = &shape;
                fixturedef.density = 1.0;
                fixturedef.friction = 0.1f;
                body->SetUserData(myS);
                body->CreateFixture(&fixturedef);
                numobj++;
            }

            if (type_m == B_TRI) {
                b2BodyDef bodydef;
                myUserData* myS = new myUserData;
                myS->type_m = B_TRI;
                myS->tile_m = tile_m;
                myS->hp = 10;
                myS->its = its;
                myS->l_spawn = 0;
                myS->bkfw = bkfw;
                myS->deleteme = false;
                std::uniform_int_distribution<int> uni(0, 400);
                int cx = uni(rng);
                myS->l_shift = cx / (float) 100.;
                bodydef.position.Set((x) * P2M, y * P2M);
                bodydef.type = b2_staticBody;
                b2Body* body = world->CreateBody(&bodydef);
                b2PolygonShape shape;
                b2Vec2 vertices[3];

                Eigen::Vector2f rt = rotate2d(0., type_TRI_size[1] / 2., 0., 0., (2. * b2_pi) / 3.);
                //because I render triangle in rectangle, triangle in circle that in rectangle(square size type_TRI_size[0 1])
                float n_tri = (type_TRI_size[1] - rt.y()) / 2.;

                rt = rotate2d(0., (type_TRI_size[1] + n_tri) / 2., 0., 0., 0.);
                vertices[0].Set(P2M * rt.x(), P2M * rt.y());
                rt = rotate2d(0., (type_TRI_size[1] + n_tri) / 2., 0., 0., (2. * b2_pi) / 3.);
                vertices[1].Set(P2M * rt.x(), P2M * rt.y());
                rt = rotate2d(0., (type_TRI_size[1] + n_tri) / 2., 0., 0., ((2. * b2_pi) / 3.)*2.);
                vertices[2].Set(P2M * rt.x(), P2M * rt.y());
                shape.Set(vertices, 3);
                b2FixtureDef fixturedef;
                fixturedef.filter.categoryBits = 0x0008;
                fixturedef.shape = &shape;
                fixturedef.density = 1.0;
                fixturedef.friction = 0.1f;
                body->SetUserData(myS);
                body->CreateFixture(&fixturedef);
                numobj++;
            }
        } else {
            b2BodyDef bodydef;
            myUserData* myS = new myUserData;
            myS->type_m = B_RECT;
            myS->tile_m = tile_m;
            myS->hp = 10;
            myS->its = its;
            myS->l_spawn = 0;
            myS->bkfw = bkfw;
            myS->deleteme = false;

            std::uniform_int_distribution<int> uni(0, 400);
            int cx = uni(rng);
            myS->l_shift = cx / (float) 100.;
            myS->l_shift = 0;
            bodydef.position.Set((x) * P2M, y * P2M);
            bodydef.type = b2_staticBody;
            b2Body* body = world->CreateBody(&bodydef);
            b2PolygonShape shape;
            shape.SetAsBox(P2M * type_RECT_tile_size[0] / 2.f, P2M * type_RECT_tile_size[1] / 2.f);
            b2FixtureDef fixturedef;
            fixturedef.shape = &shape;
            fixturedef.density = 1.0;
            fixturedef.friction = 0.3f;
            body->SetUserData(myS);
            body->CreateFixture(&fixturedef);
            numobj++;
        }

    }

    void spawner() {
        for (int i = 0; i < to_spawn; i++) {
            add_obj(s_bodyes[i].x, s_bodyes[i].y, s_bodyes[i].type_m, s_bodyes[i].tile_m, s_bodyes[i].its, s_bodyes[i].bkfw);
        }
    }

    void spawn_player() {
        add_obj(500, 500, B_CIRCLE, TILE_PLAYER, false, false);
    }

    void init() {
        updpsize();
        for (int i = 0; i < maxobj; i++) {
            m_bodyes[i] = m_body();
            s_bodyes[i] = spawn_me();
        }
        world = new b2World(b2Vec2(0.0, 9.81));
        Edge();
        genmap();
        spawn_player();
        world->SetContactListener(&contactListenerInstance);
        game_over_win = false;
        game_over_lose = false;
    }

    float ppowerx_o = 0;
    float ppowery_o = 0;

    void reg_ex(float xscale, float xl, float yl) {
        ppowerx_o = xl;
        ppowery_o = yl;
        ppowerx = xscale + xl*fposx;
        ppowery = yl*fposy;
    }

    bool ppcd = false;
    float playerpos_o_x = 0;
    float playerpos_o_y = 0;

    class MyQueryCallback : public b2QueryCallback {
    public:
        std::vector<b2Body*> foundBodies;

        bool ReportFixture(b2Fixture* fixture) {
            foundBodies.push_back(fixture->GetBody());
            return true;
        }
    };

    void calcex(b2Vec2 center) {
        MyQueryCallback queryCallback;
        int blastRadius = 300 * P2M;
        b2AABB aabb;
        aabb.lowerBound = center - b2Vec2(blastRadius, blastRadius);
        aabb.upperBound = center + b2Vec2(blastRadius, blastRadius);
        world->QueryAABB(&queryCallback, aabb);

        for (int i = 0; i < queryCallback.foundBodies.size(); i++) {
            b2Body* b = queryCallback.foundBodies[i];
            b2Vec2 bodyCom = b->GetWorldCenter();
            //ignore bodies outside the blast range
            if ((bodyCom - center).Length() >= blastRadius)
                continue;
            //applyBlastImpulse(body, center, bodyCom, blastPower);
            myUserData* uS = (myUserData*) b->GetUserData();
            if (uS) {
                if ((uS->tile_m == TILE_SDF) || (uS->tile_m == TILE_SDF_SPAWN)) {
                    uS->deleteme = true;
                }
            }
        }
    }

    class MContactListener : public b2ContactListener {

        void BeginContact(b2Contact* contact) {
            myUserData* uS = (myUserData*) contact->GetFixtureA()->GetBody()->GetUserData();
            myUserData* uS2 = (myUserData*) contact->GetFixtureB()->GetBody()->GetUserData();
            if (uS) {
                if (uS2) {
                    if (((uS->tile_m == TILE_PLAYER) || (uS2->tile_m == TILE_PLAYER))&&((uS->tile_m >= 100) || (uS2->tile_m >= 100))) {
                        game_over_win = true;
                    }
                }
            }
        }
    };

    MContactListener contactListenerInstance;

    void ticknext(bool paused, float fps, double loctime, float umousex, float umousey, bool ffm) {
        float ts = timeStep > 1. / fps ? 1. / fps : timeStep;
        reset();
        updpsize();
        if (loctime <= animtime)wheel->SetMotorSpeed(0);
        if ((!paused)&&(!game_over_lose)&&(!game_over_win))world->Step(ts, velocityIterations, positionIterations);
        if ((!paused)&&(!game_over_lose)&&(!game_over_win)&&(loctime >= animtime))player_rot = angle2d(playerpos_x, playerpos_y, sWIDTH - umousex, sHEIGHT - umousey);
        int i = 0;
        int z = 0;
        float xs = (sWIDTH - sHEIGHT * ((float) WIDTH / HEIGHT)) / 2.;
        reg_ex(xs, ppowerx_o, ppowery_o);
        if ((!paused)&&(!game_over_lose)&&(!game_over_win)&&(loctime >= animtime)) {
            if (!ppcd)ppowerht = ffm;
            if (ppowerht) {
                ppcd = true;
                ppower += ts * 5.;
                ppowerht = !(ppower >= 1.);
                ppowerhn = !ppowerht;
                if (ppowerhn)reg_ex(xs, playerpos_o_x * M2P, playerpos_o_y * M2P + boardpos_y);
                ppower = ppower >= 1. ? 1. : ppower;
            } else {
                ppower -= ts;
                if (ppower <= 0.)ppcd = false;
                ppower = ppower <= 0. ? 0. : ppower;

            }
        }
        if ((!paused)&&(!game_over_lose)&&(!game_over_win)&&(loctime >= animtime)) {

            if (ppowerhn) {
                ppowerhitr += ts * 2.;
                if (ppowerhitr >= ppowerhitrm) {
                    ppowerhitr = ppowerhitrm;
                    ppowerhn = false;
                }
            } else {
                ppowerhitr -= ts * 2.;
                ppowerhitr = ppowerhitr <= 0. ? 0. : ppowerhitr;
            }
            if (ppowerhitr > 0.001)calcex(b2Vec2(ppowerx_o * P2M, ppowery_o * P2M - boardpos_y * P2M));
        }
        b2Body* tmp = world->GetBodyList();
        while (tmp) {
            b2Body* b = tmp;
            tmp = tmp->GetNext();
            b2Vec2 position = b->GetPosition();
            position = b->GetWorldCenter();
            float angle = b->GetAngle();
            myUserData* uS = (myUserData*) b->GetUserData();
            if (uS) {
                //do not display or delete if object out of screen
                if ((uS->deleteme) || (position.x * M2P < 0.f - WIDTH * 0.5) || (position.y * M2P < 0.f - HEIGHT * 0.5 - boardpos_y) ||
                        (position.x * M2P > WIDTH + WIDTH * 0.5) || (position.y * M2P > HEIGHT + HEIGHT * 0.5 - boardpos_y)) {
                    if (uS->tile_m == TILE_SDF) {
                        delete uS;
                        world->DestroyBody(b);
                        numobj--;
                    }
                } else {
                    if ((!paused)&&(!game_over_lose)&&(!game_over_win)&&(loctime >= animtime)) {
                        if (loctime < uS->l_spawn)uS->l_spawn = 0;
                        if ((uS->tile_m == TILE_SDF_SPAWN)&&(std::fmod((uS->l_shift + loctime), 4.) > 2.)&&(loctime - uS->l_spawn > 2.)) {
                            if (uS->l_spawn != 0) {
                                s_bodyes[z].set_vals(WIDTH - (position.x * M2P), HEIGHT - (position.y * M2P), uS->type_m, TILE_SDF, uS->its, uS->bkfw, fposx, fposy, xs);
                                z++;
                            }
                            uS->l_spawn = loctime;

                        }
                    }

                    m_bodyes[i].set_vals((position.x * M2P), (position.y * M2P) + boardpos_y, angle, uS->type_m, fposx, fposy,
                            xs, uS->tile_m, uS->l_shift);

                    if (uS->tile_m == TILE_PLAYER) {
                        if ((!paused)&&(!game_over_lose)&&(!game_over_win)&&(loctime >= animtime))if (std::abs(-HEIGHT + position.y * M2P) < boardpos_y - type_PLAYER_size[0] / 2.)game_over_lose = true;
                        if ((!paused)&&(!game_over_lose)&&(!game_over_win)&&(loctime >= animtime))if (std::abs(-HEIGHT + position.y * M2P) > boardpos_y + HEIGHT / 2.)
                                boardpos_y += ((loctime <= animtime + 5.) ? ((loctime - animtime) / 5.) : 1.)*15.2 *
                                ts * ((std::abs(-HEIGHT + position.y * M2P) - boardpos_y) / (HEIGHT));
                        if ((!paused)&&(!game_over_lose)&&(!game_over_win)&&(loctime >= animtime)) {
                            ajcd += ts;

                            if (ajcd >= jcd) {
                                ajcd = jcd;
                                ajcd2 += ts;
                                if (ajcd2 >= jcd)ajcd2 = jcd;
                            }
                        }
                        if (((!paused)&&(!game_over_lose)&&(!game_over_win)&&(loctime >= animtime)) && jumpx) {
                            jumpx = false;
                            if (ajcd >= jcd) {
                                if (ajcd2 >= jcd) {
                                    ajcd2 = 0;
                                    float impulse = b->GetMass() * 6 + b->GetMass() * b->GetLinearVelocity().y;
                                    b->ApplyLinearImpulse(-b2Vec2(0, impulse), b->GetWorldCenter(), true);
                                } else {
                                    ajcd = 0;
                                    float impulse = b->GetMass() * 6 + b->GetMass() * b->GetLinearVelocity().y;
                                    b->ApplyLinearImpulse(-b2Vec2(0, impulse), b->GetWorldCenter(), true);
                                }
                            }
                        }
                        playerpos_o_x = position.x;
                        playerpos_o_y = position.y;
                        playerpos_x = m_bodyes[i].x;
                        playerpos_y = m_bodyes[i].y;
                    }
                    i++;
                }

            }
        }
        num_onscr_obj = i;
        to_spawn = z;
        if ((!paused)&&(!game_over_lose)&&(!game_over_win)&&(loctime >= animtime)) {
            boardpos_y += ((loctime <= animtime + 5.) ? ((loctime - animtime) / 5.) : 1.)*8. * ts;
        }
        if ((!paused)&&(!game_over_lose)&&(!game_over_win)&&(loctime >= animtime))spawner();
    }

    void reset() {
        if (resetx) {
            b2Body* tmp = world->GetBodyList();
            while (tmp) {
                b2Body* b = tmp;
                tmp = tmp->GetNext();
                myUserData* uS = (myUserData*) b->GetUserData();
                if (uS) {
                    delete uS;
                    world->DestroyBody(b);
                    numobj--;
                }
            }
            num_onscr_obj = 0;
            ppower = 0.;
            ppowerht = false;
            ppowerhn = false;
            ppcd = false;
            ppowerhitr = 0.;
            to_spawn = 0;
            sWIDTH = 1366;
            sHEIGHT = 768;
            ajcd2 = 0;
            ajcd = jcd;
            boardpos_y = 0.;
            boardpos_x = 0.;
            wtime = 0.;
            game_over_win = false;
            game_over_lose = false;
            updpsize();
            genmap();
            spawn_player();
        }
    }

};


//------------------------
//only debug window on screen

class debug_table {
public:

    static const int c_max = 100;
    nanogui::Window *dwindow;
    nanogui::Button *closeb;
    nanogui::Label *r1[c_max];
    nanogui::Label *r2[c_max];
    nanogui::Label *r3[c_max];

    debug_table(nanogui::Widget *scr) {
        using namespace nanogui;
        dwindow = new Window(scr, "Debug", true);
        dwindow->setFixedSize(Vector2i(640, 510));
        dwindow->setLayout(new BoxLayout(Orientation::Vertical, Alignment::Middle, 0, 10));
        Widget *header = new Widget(dwindow);
        header->setLayout(new BoxLayout(Orientation::Horizontal, Alignment::Middle, 0, 6));
        Label *h1 = new Label(header, "Name", "sans-bold");
        setsize1(h1);
        Label *h2 = new Label(header, "Value 1", "sans-bold");
        setsize1(h2);
        Label *h3 = new Label(header, "Value 2", "sans-bold");
        setsize1(h3);
        Label *h33 = new Label(header, "", "sans-bold");
        h33->setColor(Color(230, 130, 180, 255));
        h33->setFixedSize(Eigen::Vector2i(15, 20));
        VScrollPanel *tablescroll = new VScrollPanel(dwindow);
        tablescroll->setFixedSize(Vector2i(640, 380));
        Widget *table = new Widget(tablescroll);
        table->setLayout(new BoxLayout(Orientation::Vertical, Alignment::Middle, 0, 10));
        for (int i = 0; i < c_max - 1; i++) {
            Widget *tableline = new Widget(table);
            tableline->setLayout(new BoxLayout(Orientation::Horizontal, Alignment::Middle, 0, 6));
            std::string str = "--------";
            r1[i] = new Label(tableline, to_string(i + 1), "sans");
            setsize(r1[i]);
            r2[i] = new Label(tableline, str, "sans");
            setsize(r2[i]);
            r3[i] = new Label(tableline, str, "sans");
            setsize(r3[i]);
        }

        Widget *btns = new Widget(dwindow);
        btns->setLayout(new BoxLayout(Orientation::Horizontal, Alignment::Middle, 0, 6));
        closeb = new Button(btns, "Close");
        closeb->setCallback([&] {

            dwindow->setVisible(false);
        });
        //dwindow->center();
        dwindow->setPosition(Vector2i(0, 200));
        dwindow->setVisible(false);



    }

    void switch_visible() {

        dwindow->setVisible(!dwindow->visible());
    }

    void set_text_on_id(const std::string &value1, const std::string &value2, const std::string &value3, int i) {

        r1[i]->setCaption(value1);
        r2[i]->setCaption(value2);
        r3[i]->setCaption(value3);
    }


private:

    void setsize(nanogui::Label *val) {

        val->setFontSize(25);
        val->setColor(nanogui::Color(204, 255, 255, 255));
        val->setFixedSize(Eigen::Vector2i(580 / 3, 20));
    }

    void setsize1(nanogui::Label *val) {

        val->setColor(nanogui::Color(255, 51, 0, 255));
        val->setFixedSize(Eigen::Vector2i(580 / 3, 20));
    }

};
//------------------------

//globals to make lambda work
nanogui::CheckBox *cb;
nanogui::CheckBox *fps_ch;
nanogui::CheckBox *fxaa_box;
nanogui::CheckBox *filtering;
nanogui::Button *b;
nanogui::Button *b1;
nanogui::Button *b2;
nanogui::Button *b3;
nanogui::Button *b4;
nanogui::ColorPicker *cp1;
nanogui::FloatBox<float> *ftextBox;
nanogui::Window *window1;
debug_table *debugw; //debug window
nanogui::TextBox *nametext;
nanogui::Button *nc;
nanogui::ComboBox *qs;
nanogui::ComboBox *qz;

nanogui::TextBox *res_display;
nanogui::IntBox<int> *max_fb_size_w; //max size of screen
nanogui::IntBox<int> *fps_edit;
nanogui::Label *fps_r;

class Ccgm : public nanogui::Screen {
public:

    Ccgm() : nanogui::Screen(Eigen::Vector2i(1366, 768), "game", /*resizable*/true, /*fullscreen*/false, /*colorBits*/8,
    /*alphaBits*/8, /*depthBits*/24, /*stencilBits*/8,
    /*nSamples*/0, /*glMajor*/3, /*glMinor*/0) {
        using namespace nanogui;
        hidecanvas();
        window1 = new Window(this, "Menu / Settings");
        window1->setFixedSize(Vector2i(350, 410));
        initall();
        //settextures();
        setBackground(Vector4f(0, 0, 0, 1));

        b = new Button(this, "Menu");
        b->setBackgroundColor(Color(235, 0, 0, 155));
        b->setTextColor(Color(235, 235, 235, 255));
        b->setCallback([&] {
            window1->setVisible(!window1->visible());
            if (window1->visible()) {
                window1->center();
            } else {
            }
        });

        b->setFixedSize(Eigen::Vector2i(63, 30));
        b1 = this->add<Button>("Pause");
        b1->setBackgroundColor(Color(0, 0, 205, 155));
        b1->setTextColor(Color(235, 235, 235, 255));
        b1->setPosition(Vector2i(0, 35));
        b1->setFixedSize(Eigen::Vector2i(63, 30));
        b1->setCallback([&] {
            paused = !paused;
            if (paused) {
                pto = glfwGetTime();
            } else {
                ptime = ptime + glfwGetTime() - pto;
                        pto = 0;
            }
        });

        b2 = this->add<Button>("Reset");
        b2->setTextColor(Color(235, 235, 235, 255));
        b2->setBackgroundColor(Color(205, 100, 0, 155));
        b2->setPosition(Vector2i(65, 0));
        b2->setFixedSize(Eigen::Vector2i(63, 30));
        b2->setCallback([&] {
            if (!paused) {
                resetx = true;
            } else {
                auto dlg = new MessageDialog(b2->parent(), MessageDialog::Type::Information, "!!", "Unpause first!");
            }
        });

        b3 = new Button(this, "FullScr");
        b3->setBackgroundColor(Color(102, 102, 153, 155));
        b3->setTextColor(Color(235, 235, 235, 255));
        b3->setPosition(Vector2i(65, 35));
        b3->setCallback([&] {
            bool ifc = isfullscreen();
            if (!ifc) {
                printf("Requesting fullscreen..\n"); emscripten_run_script("fullscreen()");
            } else {
                printf("Exiting fullscreen..\n"); EMSCRIPTEN_RESULT ret = emscripten_exit_fullscreen();
            }

        });
        b3->setFixedSize(Eigen::Vector2i(63, 30));

        b4 = new Button(this, "Debug");
        b4->setBackgroundColor(Color(0, 255, 0, 155));
        b4->setTextColor(Color(235, 235, 235, 255));
        b4->setPosition(Vector2i(165, 0));
        b4->setCallback([&] {
            debugw->switch_visible();
        });
        b4->setFixedSize(Eigen::Vector2i(63, 30));

        b->setVisible(false);
        b1->setVisible(false);
        b2->setVisible(false);
        b3->setVisible(false);

        b4->setVisible(false);
        //b4->setVisible(true);

        window1->setPosition(Vector2i(425, 300));
        GridLayout *layout =
                new GridLayout(Orientation::Horizontal, 2,
                Alignment::Middle, 5, 5);
        layout->setColAlignment({Alignment::Maximum, Alignment::Fill});
        layout->setRowAlignment({Alignment::Maximum, Alignment::Fill});
        layout->setSpacing(0, 10);
        window1->setLayout(new BoxLayout(Orientation::Vertical, Alignment::Fill, 0, 0));

        Widget *wcontent = new Widget(window1);
        wcontent->setLayout(layout);

        new Label(wcontent, "Hide Menu buttons :", "sans-bold");

        cb = new CheckBox(wcontent, "");
        cb->setFontSize(16);
        cb->setChecked(false);
        cb->setCallback([&](bool state) {
            if (!state) {
                b->setVisible(true);
                b1->setVisible(true);
                b2->setVisible(true);
                b3->setVisible(true);
            } else {
                b->setVisible(false);
                b1->setVisible(false);
                b2->setVisible(false);
                b3->setVisible(false);
            }
        });

        b->setVisible(!cb->checked());
        b1->setVisible(!cb->checked());
        b2->setVisible(!cb->checked());
        b3->setVisible(!cb->checked());
        new Label(wcontent, "Anti-aliasing FXAA (on/off) :", "sans-bold");

        fxaa_box = new CheckBox(wcontent, "");
        fxaa_box->setFontSize(16);
        fxaa_box->setChecked(false);

        new Label(wcontent, "Quality :", "sans-bold");
        qs = new ComboBox(wcontent,{"Minimal", "Lowest", "Low", "Medium", "Best"});
        qs->setSelectedIndex(2);
        qs->setTooltip("Minimal will disable all post-processing.");

        new Label(wcontent, "Current resolution :", "sans-bold");
        res_display = new TextBox(wcontent);
        res_display->setEditable(false);
        res_display->setValue("1366 x 768");
        res_display->setTooltip("Screen 1366 x 768");

        new Label(wcontent, "Resolution Scale :", "sans-bold");
        qz = new ComboBox(wcontent,{"x3 Minimal", "x2 Lowest", "x1.5 Low", "x1 Medium", "x0.5 Best"});
        qz->setSelectedIndex(3);
        qz->setTooltip("Set lowest for better FPS. Base on current screen size.");
        new Label(wcontent, "Max resolution :", "sans-bold");
        max_fb_size_w = new IntBox<int>(wcontent);
        max_fb_size_w->setEditable(true);
        max_fb_size_w->setValue(max_fb_size);
        max_fb_size_w->setUnits("px");
        max_fb_size_w->setDefaultValue("1");
        max_fb_size_w->setFormat("[1-9][0-9]*");
        max_fb_size_w->setSpinnable(true);
        max_fb_size_w->setMinValue(10);
        max_fb_size_w->setValueIncrement(1);
        max_fb_size_w->setFontSize(18);
        new Label(wcontent, "FPS autodetection :", "sans-bold");
        Widget *vals = new Widget(wcontent);
        vals->setLayout(new BoxLayout(Orientation::Horizontal, Alignment::Middle, 0, 6));
        fps_edit = new IntBox<int>(vals);
        fps_edit->setEditable(false);
        fps_edit->setValue(60);
        fps_edit->setUnits("fps");
        fps_edit->setDefaultValue("60");
        fps_edit->setFormat("[1-9][0-9]*");
        fps_edit->setSpinnable(true);
        fps_edit->setMinValue(10);
        fps_edit->setValueIncrement(1);
        fps_edit->setFontSize(18);

        fps_edit->setTooltip("uncheck to edit");
        fps_ch = new CheckBox(vals, "");
        fps_ch->setFontSize(16);
        fps_ch->setChecked(true);
        fps_ch->setCallback([&](bool state) {
            if (!state) {
                fps_edit->setEditable(true);
            } else {
                fps_edit->setValue(60);
                fps_edit->setEditable(false);
            }
        }
        );
        fps_r = new Label(vals, "100", "sans-bold");
        fps_r->setTooltip("FPS now");
        fps_r->setColor(Color(255, 153, 0, 255));

        new Label(wcontent, "Filtering linear :", "sans-bold");

        filtering = new CheckBox(wcontent, "");
        filtering->setFontSize(16);
        filtering->setChecked(true);
        filtering->setTooltip("Uncheck for better FPS.");

        new Label(wcontent, "Control :", "sans-bold");
        new Label(wcontent, "A D space, L-mouse", "sans-bold");

        performLayout();
        window1->setVisible(false);
        init_glsl_s();

    }

    ~Ccgm() {

        //mShader.free();
    }

    bool ka = false;
    bool kd = false;

    virtual bool keyboardEvent(int key, int scancode, int action, int modifiers) {
        if (Screen::keyboardEvent(key, scancode, action, modifiers))
            return true;

        //DO NOT USE IN WASM
        /*if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
            std::cout << "Exit(ESC) called" << std::endl;
            setVisible(false);
            return true;
        }*/
        if (key == GLFW_KEY_P && action == GLFW_PRESS) {

            return true;
        }


        if (((key == GLFW_KEY_A) || (key == GLFW_KEY_LEFT)) && action == GLFW_PRESS) {
            //ka=false;
            kd = true;
            boxhelper->wheel->SetMotorSpeed(3);

            return true;
        }

        if (((key == GLFW_KEY_A) || (key == GLFW_KEY_LEFT)) && action == GLFW_RELEASE) {
            kd = false;
            if (!ka)
                boxhelper->wheel->SetMotorSpeed(0);
            else
                boxhelper->wheel->SetMotorSpeed(-3);

            return true;
        }

        if (((key == GLFW_KEY_D) || (key == GLFW_KEY_RIGHT)) && action == GLFW_PRESS) {
            ka = true;
            //kd=false;
            boxhelper->wheel->SetMotorSpeed(-3);

            return true;
        }

        if (((key == GLFW_KEY_D) || (key == GLFW_KEY_RIGHT)) && action == GLFW_RELEASE) {
            ka = false;
            if (!kd)
                boxhelper->wheel->SetMotorSpeed(0);
            else
                boxhelper->wheel->SetMotorSpeed(3);

            return true;
        }

        if (((key == GLFW_KEY_SPACE) || (key == GLFW_KEY_W)) && action == GLFW_PRESS) {
            boxhelper->jumpx = true;
            return true;
        }

        return false;
    }

    virtual bool mouseMotionEvent(const Eigen::Vector2i &p, const Eigen::Vector2i &rel, int button, int modifiers) {
        if (Screen::mouseMotionEvent(p, rel, button, modifiers)) {
            return true;
        }
        Eigen::Vector2i tsxz = size();
        //if ((button & (1 << GLFW_MOUSE_BUTTON_1)) != 0) {
        umouse = scale_calc_all(tsxz, p.cast<float>());
        ;
        if (cb->checked()) {
            if (p[0] < 130 && p[1] < 80) {
                fadestop = true;
                b->setVisible(true);
                b1->setVisible(true);
                b2->setVisible(true);
                b3->setVisible(true);
            } else {

                b->setVisible(false);
                b1->setVisible(false);
                b2->setVisible(false);
                b3->setVisible(false);
            }
        }
        //return true;
        //}
        return false;
    }

    virtual bool mouseButtonEvent(const Eigen::Vector2i &p, int button, bool down, int modifiers) {
        if (Screen::mouseButtonEvent(p, button, down, modifiers))
            return true;
        ffm = button == GLFW_MOUSE_BUTTON_1 && down;
        if (ffm) {

            std::uniform_int_distribution<int> uni(0, 2);
            int cx = uni(rng);

            std::uniform_int_distribution<int> uni2(0, 8);
            int cx2 = uni2(rng);

            //if (!paused)boxhelper->wheel->SetMotorSpeed(0);
            //boxhelper->add_obj(umouse[0], umouse[1], cx, TILE_SDF, false, false);

            if (window1->visible())window1->setVisible(false);
        }
        return false;
    }

    virtual void draw(NVGcontext * ctx) {

        /* Draw the user interface */
        Screen::draw(ctx);
    }

    void FPS(double time) {
        numFrames++;
        if (time - lastFpsTime > frameRateSmoothing) {

            fps = (int) (numFrames / (time - lastFpsTime));
            numFrames = 0;
            lastFpsTime = time;
        }
    }

    bool wonce = false;
    bool lonce = false;

    void winh(double loctime) {
        using namespace nanogui;
        if (game_over_lose)if (!lonce) {
                lonce = true;
                auto dlg = new MessageDialog(window1->parent(), MessageDialog::Type::Information, "\\(O_o)/", "You lose :(");
            }
        if (game_over_win)if (!wonce) {
                wtime = (float) loctime;
                wonce = true;
                auto dlg = new MessageDialog(window1->parent(), MessageDialog::Type::Information, "¯\\(°_o)/¯", "You won :) \n Time: " + std::to_string((int) wtime));
            }
    }

    float antime = 0;

    virtual void drawContents() {
        using namespace nanogui;
        bool resize_to_copy = false; //if framebuffer size not same to screen size(when option zoom enabled)
        int c_u_id = 0; //uniform index to store without calling glGetUniformLocation every time

        reset_x();
        Vector2i tsxz = size();
        Vector2i tsxz_orig = tsxz;

        //resize to 16/9
        if ((int) (tsxz[0]*(float) 9 / 16) < tsxz[1]) {
            tsxz[1] = (int) (tsxz[0]*(float) 9 / 16);
        }
        tsxz_orig = tsxz;
        //Vector2i tmpval=Vector2i(1,1);
        scale_calc_all(tsxz, tsxz.cast<float>());
        resize_to_copy = (tsxz[0] != tsxz_orig[0]) || (tsxz[1] != tsxz_orig[1]);
        if ((qz->selectedIndex() > 3)&&((tsxz[0] > tsxz_orig[0]) || (tsxz[1] > tsxz_orig[1]))) {
            glViewport(0, 0, tsxz[0] - 0.01, tsxz[1] - 0.01); //WebGL or WASM...maybe bug, without -0.01 does not work
        } else {
            //if (qz->selectedIndex() <= 3) {
            glViewport(0, 0, tsxz_orig[0], tsxz_orig[1]);
            //}
        }

        res_display->setValue(to_string(tsxz[0]) + " x " + to_string(tsxz[1]));
        res_display->setTooltip("Screen " + to_string(tsxz_orig[0]) + " x " + to_string(tsxz_orig[1]));
        boxhelper->sWIDTH = tsxz[0];
        boxhelper->sHEIGHT = tsxz[1];
        /*
                debugw->set_text_on_id("orig fb", to_string(tsxz_orig[0]), to_string(tsxz_orig[1]), 0);
                debugw->set_text_on_id("resized fb", to_string(tsxz[0]), to_string(tsxz[1]), 1);
                debugw->set_text_on_id("mouse", to_string(umouse[0]), to_string(umouse[1]), 2);

                bool ifc = isfullscreen();
                debugw->set_text_on_id("is fullscreen", ifc ? "true" : "false", "----", 3);

                debugw->set_text_on_id("fps", to_string(fps), "--", 5);

                debugw->set_text_on_id("box2d numobj", to_string(boxhelper->numobj), "--", 7);
                debugw->set_text_on_id("box2d onscr_obj", to_string(boxhelper->num_onscr_obj), "--", 8);


                for (int i = 0; i < boxhelper->numobj; i++) {
                    if (i > 70)break;
                    debugw->set_text_on_id("box2d " + to_string(i),
                            "x " + to_string((int) boxhelper->s_bodyes[i].x) + " y " +
                            to_string((int) boxhelper->s_bodyes[i].y), to_string((int) boxhelper->m_bodyes[i].angle), 10 + i);
                }
         */
        FPS(glfwGetTime());
        double loctime = glfwGetTime() - ptime - ex_pause_skip_time;

        if (paused) {
            loctime = pto - ptime - ex_pause_skip_time;
        } else if (loctime - endframetime > FPSmin) {
            ex_pause_skip_time += loctime - endframetime - (float) 1 / 60;
            loctime = glfwGetTime() - ptime - ex_pause_skip_time;
        }
        if (animonce)animonce = !(loctime >= animtime);
        if ((!animonce)&&(loctime < animtime))antime = animtime;
        loctime += antime;
        winh(loctime);

        update_vals(loctime);

        //debugw->set_text_on_id("time", to_string(loctime), "----", 4);


        Vector2f screenSize = tsxz.cast<float>();
        Vector2f screenSize_orig = tsxz_orig.cast<float>();
        glDisable(GL_BLEND); //framebuffer

        /*
                //templates

                //texture
                glActiveTexture(GL_TEXTURE0 + 0);
                glBindTexture(GL_TEXTURE_2D, texturesData[indexfx[0]].first.texture());
                mShader.setUniform("u_texture1", 0);

                //framebuffer
                fb1.bind();
                fbother2.bindtexture(tsxz, 0);
                mShader.setUniform("u_texture1", 0);
                mShader.drawIndexed(GL_TRIANGLES, 0, 2);
                fb1.release();
         */

        //fix first black frame
        if (scrch) {
            if (filtering->checked()) {
                pause_fb_linear.bindtexture(tsxz, 0);
                nvfxaa_fb_linear.bindtexture(tsxz, 0);
                copy_fb_linear.bindtexture(tsxz, 0);
            } else {
                pause_fb_near.bindtexture(tsxz, 0);
                nvfxaa_fb_near.bindtexture(tsxz, 0);
                copy_fb_near.bindtexture(tsxz, 0);
            }
        }

        //sdf
        //box2d_draw(screenSize);

        //textured
        box2d_draw_texture(screenSize, loctime);

        if ((qz->selectedIndex() > 3)&&((tsxz[0] > tsxz_orig[0]) || (tsxz[1] > tsxz_orig[1]))) {
            glViewport(0, 0, tsxz[0] - 0.01, tsxz[1] - 0.01); //WebGL or WASM...maybe bug, without -0.01 does not work
        } else {
            glViewport(0, 0, tsxz_orig[0], tsxz_orig[1]);
        }

        if (filtering->checked())grays_fb_linear.bind();
        else grays_fb_near.bind();
        grays_sh.bind();
        if (filtering->checked())gmap_textured_fb_linear.bindtexture(tsxz, 0, true); //gmap_box2d_fb_linear for sdf
        else gmap_textured_fb_near.bindtexture(tsxz, 0, true);
        c_u_id = 0;
        grays_sh.setUniform("u_texture1", 0, c_u_id++);
        grays_sh.setUniform("u_resolution", screenSize, c_u_id++);
        grays_sh.setUniform("u_time", (float) loctime, c_u_id++);
        grays_sh.drawIndexed(GL_TRIANGLES, 0, 2);
        if (filtering->checked())grays_fb_linear.release();
        else grays_fb_near.release();

        if (paused) {
            if (filtering->checked())pause_fb_linear.bind();
            else pause_fb_near.bind();
        } else if (fxaa_box->checked()) {
            if (filtering->checked())nvfxaa_fb_linear.bind();
            else nvfxaa_fb_near.bind();
        } else
            if (resize_to_copy) {
            if (filtering->checked())copy_fb_linear.bind();
            else copy_fb_near.bind();
        }

        main_screen.bind();
        if (filtering->checked())grays_fb_linear.bindtexture(tsxz, 0, true);
        else grays_fb_near.bindtexture(tsxz, 0, true);
        c_u_id = 0;
        main_screen.setUniform("u_texture1", 0, c_u_id++);
        if (filtering->checked())gmap_textured_fb_linear.bindtexture(tsxz, 1, true);
        else gmap_textured_fb_near.bindtexture(tsxz, 1, true);
        main_screen.setUniform("u_texture2", 1, c_u_id++);
        main_screen.setUniform("u_time", (float) loctime, c_u_id++);
        main_screen.setUniform("u_resolution", screenSize, c_u_id++);
        main_screen.setUniform("QUALITY", qs->selectedIndex() - 1, c_u_id++);
        main_screen.setUniform("ppower", (float) boxhelper->ppower, c_u_id++);
        main_screen.setUniform("ppowerhitr", (float) boxhelper->ppowerhitr, c_u_id++);
        main_screen.setUniform("xshape_size", Eigen::Vector2f(type_PLAYER_size[1] * boxhelper->fposy, type_PLAYER_size[1] * boxhelper->fposy), c_u_id++);
        main_screen.setUniform("xshape_pos", Eigen::Vector2f(boxhelper->ppowerx, boxhelper->ppowery), c_u_id++);
        main_screen.drawIndexed(GL_TRIANGLES, 0, 2);


        if (paused) {
            if (filtering->checked())pause_fb_linear.release();
            else pause_fb_near.release();
        } else if (fxaa_box->checked()) {
            if (filtering->checked())nvfxaa_fb_linear.release();
            else nvfxaa_fb_near.release();
        } else if (resize_to_copy) {
            if (filtering->checked())copy_fb_linear.release();
            else copy_fb_near.release();
        }

        if (paused) {
            if (fxaa_box->checked()) {
                if (filtering->checked())nvfxaa_fb_linear.bind();
                else nvfxaa_fb_near.bind();
            } else if (resize_to_copy) {
                if (filtering->checked())copy_fb_linear.bind();
                else copy_fb_near.bind();
            }
            pause_sh.bind();
            if (filtering->checked())pause_fb_linear.bindtexture(tsxz, 0, true);
            else pause_fb_near.bindtexture(tsxz, 0, true);
            c_u_id = 0;
            pause_sh.setUniform("u_texture1", 0, c_u_id++);
            pause_sh.setUniform("u_resolution", screenSize, c_u_id++);
            pause_sh.drawIndexed(GL_TRIANGLES, 0, 2);
            if (fxaa_box->checked()) {
                if (filtering->checked())nvfxaa_fb_linear.release();
                else nvfxaa_fb_near.release();
            } else if (resize_to_copy) {
                if (filtering->checked())copy_fb_linear.release();
                else copy_fb_near.release();
            }
        }

        //Copy Framebuffers
        // <FROM_FB>.copyto(copy_fb.getFramebuffer());

        //shader copy
        /*copy_fb.bind();
        cp_sh.bind();
            <FROM_FB>.bindtexture(tsxz, 0, true);
            cp_sh.setUniform("u_texture1", 0);
            cp_sh.setUniform("u_resolution", screenSize);
            cp_sh.drawIndexed(GL_TRIANGLES, 0, 2);
        copy_fb.release();
         */

        //example
        /*copy_fb.bind();
        cp_sh.bind();
        nvfxaa_fb.bindtexture(tsxz, 0, true);
        cp_sh.setUniform("u_texture1", 0);
        cp_sh.setUniform("u_resolution", screenSize);
        cp_sh.drawIndexed(GL_TRIANGLES, 0, 2);
        copy_fb.release();*/

        //nvfxaa_fb.copyto(copy_fb.getFramebuffer());

        if (fxaa_box->checked()) {

            nvfxaa_sh.bind();
            if (filtering->checked())nvfxaa_fb_linear.bindtexture(tsxz, 0, true);
            else nvfxaa_fb_near.bindtexture(tsxz, 0, true);
            c_u_id = 0;
            nvfxaa_sh.setUniform("u_texture1", 0, c_u_id++);
            if (resize_to_copy) {
                nvfxaa_sh.setUniform("u_resolution", screenSize_orig, c_u_id++);
            } else nvfxaa_sh.setUniform("u_resolution", screenSize, c_u_id++);
            nvfxaa_sh.drawIndexed(GL_TRIANGLES, 0, 2);
        } else if (resize_to_copy) {
            cp_sh.bind();
            if (filtering->checked())copy_fb_linear.bindtexture(tsxz, 0, true);
            else copy_fb_near.bindtexture(tsxz, 0, true);
            c_u_id = 0;
            cp_sh.setUniform("u_texture1", 0, c_u_id++);
            cp_sh.setUniform("u_resolution", screenSize_orig, c_u_id++);
            cp_sh.drawIndexed(GL_TRIANGLES, 0, 2);
        }

        resetx = false;

        if (glfwGetTime() - ptime - ex_pause_skip_time > 300000) {
            if (!paused)resetx = true;
        }


        scrch = (!(((osize - tsxz).norm() == 0)));
        osize = tsxz;
        if ((dxo > 10)&&(!scrch)&&(!passfirstframe)) {
            displaycanvas();
            passfirstframe = true;
        } else {
            dxo++;
        }
        if (!paused) {

            endframetime = glfwGetTime() - ptime - ex_pause_skip_time;
        }

    }
private:

    bool paused = false; //game paused
    bool resetx = true; //reset pressed
    bool fadestop = false; //keep buttons visible first fewsec, funciton fadebuttons

    double pto = 0; //time when pause clicked
    double ptime = 0; //shift time of all pause
    float FPSmin = 1; //min FPS to detect when this frame rendering paused by something
    int max_fb_size = 4096; //max size of screen

    int indexfx[8] = {0}; //textures indexed fixed

    bool ffm = false; //mouse left click


    Eigen::Vector2i osize = Eigen::Vector2i(1280, 720);
    bool scrch = true; //screen resolution changed

    int dxo = 0; //to pass first 10 frames
    bool passfirstframe = false; //pause passed for first few frames

    //FPS
    double lastFpsTime = 0;
    double frameRateSmoothing = 1.0;
    double numFrames = 0;
    double fps = 60;

    double endframetime = 0;
    double ex_pause_skip_time = 0; //time when window hiden somehow(fps < FPSmin)

    nanogui::GLShader main_screen;
    nanogui::GLShader pause_sh;
    nanogui::GLShader nvfxaa_sh;
    nanogui::GLShader grays_sh;

    nanogui::GLShader shape_sh;
    nanogui::GLShader shape_sh_texture;

    nanogui::GLFramebuffer pause_fb_near;
    nanogui::GLFramebuffer nvfxaa_fb_near;
    nanogui::GLFramebuffer grays_fb_near;
    nanogui::GLFramebuffer gmap_textured_fb_near;
    nanogui::GLFramebuffer gmap_box2d_fb_near;

    nanogui::GLFramebuffer pause_fb_linear;
    nanogui::GLFramebuffer nvfxaa_fb_linear;
    nanogui::GLFramebuffer grays_fb_linear;
    nanogui::GLFramebuffer gmap_textured_fb_linear;
    nanogui::GLFramebuffer gmap_box2d_fb_linear;

    nanogui::GLShader cp_sh;
    nanogui::GLFramebuffer copy_fb_near;
    nanogui::GLFramebuffer copy_fb_linear;

    void settextures();
    void initall();
    void update_vals(double loctime);
    void setupdebug();
    bool isfullscreen();
    void fadebuttons(float time);
    void displaycanvas();
    void hidecanvas();
    void reset_x();
    void box2d_draw(Eigen::Vector2f screenSize);
    void box2d_draw_texture(Eigen::Vector2f screenSize, double loctime);
    Eigen::Vector2f scale_calc(Eigen::Vector2f tsxz);
    Eigen::Vector2f scale_calc_all(Eigen::Vector2i &tsxz, Eigen::Vector2f umouse);
    box2dhelper_uni *boxhelper;
    Eigen::Vector2f umouse;
    nanogui::MatrixXu polygon_indices(int t);
    nanogui::MatrixXf polygon_positions(int t, Eigen::Vector2f center, Eigen::Vector2f screen_prop, float size_of);
    void init_glsl_s();

    using imagesDataType = vector<pair<GLTexture, GLTexture::handleType>>;
    imagesDataType mImagesData;
    imagesDataType texturesData;
    int mCurrentImage;
};

void Ccgm::init_glsl_s() {

    using namespace nanogui;
    pause_fb_near.inittexture(Vector2i(1280, 720), true);
    nvfxaa_fb_near.inittexture(Vector2i(1280, 720), true);
    copy_fb_near.inittexture(Vector2i(1280, 720), true);
    grays_fb_near.inittexture(Vector2i(1280, 720), true);
    gmap_textured_fb_near.inittexture(Vector2i(1280, 720), true);
    gmap_box2d_fb_near.inittexture(Vector2i(1280, 720), true);

    pause_fb_linear.inittexture(Vector2i(1280, 720), false);
    nvfxaa_fb_linear.inittexture(Vector2i(1280, 720), false);
    copy_fb_linear.inittexture(Vector2i(1280, 720), false);
    grays_fb_linear.inittexture(Vector2i(1280, 720), false);
    gmap_textured_fb_linear.inittexture(Vector2i(1280, 720), false);
    gmap_box2d_fb_linear.inittexture(Vector2i(1280, 720), false);

    main_screen.initFromFiles("main_screen", "shaders/mainv.glsl", "shaders/main_screen.glsl");
    pause_sh.initFromFiles("pause_sh", "shaders/mainv.glsl", "shaders/pause.glsl");
    nvfxaa_sh.initFromFiles("mvfxaa_sh", "shaders/mainv.glsl", "shaders/nv_fxaa.glsl");
    grays_sh.initFromFiles("grays_sh", "shaders/mainv.glsl", "shaders/graysfb.glsl");
    cp_sh.initFromFiles("cp_sh", "shaders/mainv.glsl", "shaders/cp.glsl");
    shape_sh.initFromFiles("shape_sh", "shaders/mainv.glsl", "shaders/shape.glsl");
    shape_sh_texture.initFromFiles("shape_sh_texture", "shaders/mainv.glsl", "shaders/shape_texture.glsl");


    MatrixXu indices = polygon_indices(B_RECT);

    MatrixXf positions = polygon_positions(B_RECT, Eigen::Vector2f(0., 0.), Eigen::Vector2f(1., 1.), 1.);
    Vector2f screenSize = size().cast<float>();

    pause_fb_linear.bind();
    pause_sh.bind();
    pause_sh.uploadIndices(indices);
    pause_sh.uploadAttrib("position", positions);
    pause_sh.setUniform("u_resolution", screenSize);
    pause_fb_linear.release();

    nvfxaa_fb_linear.bind();
    nvfxaa_sh.bind();
    nvfxaa_sh.uploadIndices(indices);
    nvfxaa_sh.uploadAttrib("position", positions);
    nvfxaa_sh.setUniform("u_resolution", screenSize);
    nvfxaa_fb_linear.release();

    copy_fb_linear.bind();
    cp_sh.bind();
    cp_sh.uploadIndices(indices);
    cp_sh.uploadAttrib("position", positions);
    cp_sh.setUniform("u_resolution", screenSize);
    copy_fb_linear.release();

    gmap_textured_fb_linear.bind();
    shape_sh_texture.bind();
    shape_sh_texture.uploadIndices(indices);
    shape_sh_texture.uploadAttrib("position", positions);
    shape_sh_texture.setUniform("u_resolution", screenSize);
    gmap_textured_fb_linear.release();

    grays_fb_linear.bind();
    grays_sh.bind();
    grays_sh.uploadIndices(indices);
    grays_sh.uploadAttrib("position", positions);
    grays_sh.setUniform("u_resolution", screenSize);
    grays_fb_linear.release();

    gmap_box2d_fb_linear.bind();
    shape_sh.bind();
    shape_sh.uploadIndices(indices);
    shape_sh.uploadAttrib("position", positions);
    shape_sh.setUniform("u_resolution", screenSize);
    gmap_box2d_fb_linear.release();

    main_screen.bind();
    main_screen.uploadIndices(indices);
    main_screen.uploadAttrib("position", positions);
    main_screen.setUniform("u_resolution", screenSize);
}

void Ccgm::reset_x() {
    if (resetx) {
        lonce = false;
        wonce = false;
        game_over_win = false;
        game_over_lose = false;
        max_fb_size_w->setValue(4096);
        qz->setSelectedIndex(3);
        ptime = glfwGetTime() - ex_pause_skip_time;
        endframetime = 0;
    }
}

bool Ccgm::isfullscreen() {
    EmscriptenFullscreenChangeEvent fsce;
    EMSCRIPTEN_RESULT ret = emscripten_get_fullscreen_status(&fsce);

    return fsce.isFullscreen;
}

void Ccgm::hidecanvas() {

    emscripten_run_script("document.getElementById('spinner').hidden = false;document.getElementById('imloader').style.display=\"\"");
}

void Ccgm::displaycanvas() {

    emscripten_run_script("resize_glfw_wasm()");
    emscripten_run_script("document.getElementById('spinner').hidden = true;document.getElementById('imloader').style.display=\"none\"");
}

void Ccgm::settextures() {
    using namespace nanogui;
    vector<pair<int, string>> textres = loadImageDirectory(mNVGContext, "textures");
    string resourcesFolderPath("./");
    int i = 0;
    for (auto& texturex : textres) {
        GLTexture texture(texturex.second);

        /*if (texturex.second == ("textures/txt1")) //its fixes for "random non sorted file names in readdir(loadImageDirectory use it)"
                                            indexfx[1] = i;

                                        if (texturex.second == ("textures/tx2"))
                                                    indexfx[1] = i;
                                                if (texturex.second == ("textures/tx3"))
                                                    indexfx[2] = i;
                                                if (texturex.second == ("textures/tx4"))
                                                    indexfx[3] = i;
                                                if (texturex.second == ("textures/tx5"))
                                                    indexfx[4] = i;
                                                if (texturex.second == ("textures/tx6"))
                                                    indexfx[5] = i;
                                                if (texturex.second == ("textures/tx7"))
                                                    indexfx[6] = i;*/
        if (texturex.second == ("textures/iqn"))
            indexfx[0] = i;
        //bool fmt = texturex.second == ("textures/tx6") || texturex.second == ("textures/tx7");
        auto data = texture.load(resourcesFolderPath + texturex.second + ".png", false, false);
        texturesData.emplace_back(std::move(texture), std::move(data));
        i++;
    }
}

void Ccgm::fadebuttons(float time) {
    using namespace nanogui;
    if (time < 3) {
        b->setVisible(true);
        b1->setVisible(true);
        b2->setVisible(true);
        b3->setVisible(true);
        return;
    } else
        if ((!fadestop)) {

        if (time > 8)return;
        b->setVisible(true);
        b1->setVisible(true);
        b2->setVisible(true);
        b3->setVisible(true);

    }
}

nanogui::MatrixXu Ccgm::polygon_indices(int t) {
    using namespace nanogui;
    switch (t) {
            /*case B_TRI:
            {
                MatrixXu indices(3, 2);
                indices.col(0) << 0, 1, 2;
                indices.col(1) << 2, 3, 0;
                return indices;
            }*/
        case B_RECT:
        {
            MatrixXu indices(3, 2);
            indices.col(0) << 0, 1, 2;
            indices.col(1) << 2, 3, 0;
            return indices;
        }
        default:
        { //B_CIRCLE
            MatrixXu indices(3, B_CIRCLE_vertexCount);

            for (int i = 0; i < B_CIRCLE_vertexCount; i++) {

                indices(0, i) = 0;
                indices(1, i) = (i + 1) % B_CIRCLE_vertexCount;
                indices(2, i) = (i + 2) % B_CIRCLE_vertexCount;
            }
            return indices;
        }
    }
}

nanogui::MatrixXf Ccgm::polygon_positions(int t, Eigen::Vector2f center, Eigen::Vector2f screen_prop, float size_of) {
    using namespace nanogui;
    switch (t) {
            /*case B_TRI:
            {
                MatrixXf positions(3, 3);
                positions.col(0) << -(size_of) * screen_prop.x() + center.x(), -(size_of) * screen_prop.y() + center.y(), 0;
                positions.col(1) << (size_of) * screen_prop.x() + center.x(), -(size_of) * screen_prop.y() + center.y(), 0;
                positions.col(2) << 0. + center.x(), (size_of) * screen_prop.y() + center.y(), 0;
                return positions;
            }*/
        case B_RECT:
        {
            MatrixXf positions(3, 4);
            positions.col(0) << -(size_of) * screen_prop.x() + center.x(), -(size_of + 0.002) * screen_prop.y() + center.y(), 0; //0.002 for tiles
            positions.col(1) << (size_of) * screen_prop.x() + center.x(), -(size_of + 0.002) * screen_prop.y() + center.y(), 0;
            positions.col(2) << (size_of) * screen_prop.x() + center.x(), (size_of) * screen_prop.y() + center.y(), 0;
            positions.col(3) << -(size_of) * screen_prop.x() + center.x(), (size_of) * screen_prop.y() + center.y(), 0;
            return positions;
        }
        default:
        { //B_CIRCLE
            MatrixXf positions(3, B_CIRCLE_vertexCount);
            const float segments = B_CIRCLE_vertexCount;

            float theta = 0.0f;
            const float k_increment = 2.0f * b2_pi / segments;
            float radius = size_of;
            for (int i = 0; i < segments; ++i) {

                Eigen::Vector2f v = Eigen::Vector2f(+center.x() + radius * cosf(theta) * screen_prop.x(), +center.y() + radius * sinf(theta) * screen_prop.y());
                positions(0, i) = v.x();
                positions(1, i) = v.y();
                positions(2, i) = 0;
                theta += k_increment;
            }
            return positions;
        };
    }

}

Eigen::Vector2f Ccgm::scale_calc_all(Eigen::Vector2i &tsxz, Eigen::Vector2f umouse) {
    tsxz = scale_calc(tsxz.cast<float>()).cast<int>();
    umouse = scale_calc(umouse);
    umouse = Eigen::Vector2f(umouse[0], tsxz[1] - umouse[1]);
    if (!(tsxz[0] > 0))tsxz[0] = 1;
    if (!(tsxz[1] > 0))tsxz[1] = 1;
    //to max size
    if ((tsxz[0] > max_fb_size) || (tsxz[1] > max_fb_size)) {
        float prop = (float) tsxz[0] / tsxz[1];
        if (prop >= 1) {
            float oposx = (float) umouse[0] / tsxz[0];
            float oposy = (float) umouse[1] / tsxz[1];
            tsxz[0] = max_fb_size;
            tsxz[1] = max_fb_size / prop;
            umouse[0] = tsxz[0] * oposx;
            umouse[1] = tsxz[1] * oposy;
        } else {

            float oposx = (float) umouse[0] / tsxz[0];
            float oposy = (float) umouse[1] / tsxz[1];
            tsxz[1] = max_fb_size;
            tsxz[0] = max_fb_size*prop;
            umouse[0] = tsxz[0] * oposx;
            umouse[1] = tsxz[1] * oposy;
        }
    }
    return umouse;
}

Eigen::Vector2f Ccgm::scale_calc(Eigen::Vector2f tsxz) {
    if (qz->selectedIndex() != 3) {
        if (qz->selectedIndex() == 0) {
            tsxz[0] = tsxz[0]*((float) 1 / 3);
            tsxz[1] = tsxz[1]*((float) 1 / 3);
        } else
            if (qz->selectedIndex() == 1) {
            tsxz[0] = tsxz[0]*((float) 1 / 2);
            tsxz[1] = tsxz[1]*((float) 1 / 2);
        } else
            if (qz->selectedIndex() == 2) {
            tsxz[0] = tsxz[0]*((float) 1 / 1.5);
            tsxz[1] = tsxz[1]*((float) 1 / 1.5);
        } else
            if (qz->selectedIndex() == 4) {

            tsxz[0] = tsxz[0]*((float) 2);
            tsxz[1] = tsxz[1]*((float) 2);
        }
    }
    return tsxz;
}

//sdf draw

void Ccgm::box2d_draw(Eigen::Vector2f screenSize) {
    if (filtering->checked())gmap_box2d_fb_linear.bind();
    else gmap_box2d_fb_near.bind();

    glClearColor(0., 0., 0., 1.);
    glClear(GL_COLOR_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);

    nanogui::MatrixXu indices = polygon_indices(B_CIRCLE);
    shape_sh.uploadIndices(indices);

    glViewport(0, 0, screenSize[0], screenSize[1]);
    for (int i = 0; i < boxhelper->numobj; i++) {

        /*nanogui::MatrixXu indices = polygon_indices(boxhelper->m_bodyes[i].type_m);
        shape_sh.uploadIndices(indices);*/

        //bpolygon_positions(oxhelper->m_bodyes[i].type_m
        nanogui::MatrixXf positions = polygon_positions(B_CIRCLE, Eigen::Vector2f(-(((boxhelper->m_bodyes[i].x)) / (screenSize.x()))*2. + 1.,
                1. - ((boxhelper->m_bodyes[i].y) / screenSize.y())*2.), Eigen::Vector2f(screenSize.y() / screenSize.x(), 1.), boxhelper->m_bodyes[i].fb_HEIGHT / screenSize.y());
        shape_sh.uploadAttrib("position", positions);


        shape_sh.bind();
        int c_u_id = 0;
        shape_sh.setUniform("u_resolution", screenSize, c_u_id++);
        shape_sh.setUniform("shape_type", (int) boxhelper->m_bodyes[i].type_m, c_u_id++);
        shape_sh.setUniform("shape_size", Eigen::Vector2f(boxhelper->m_bodyes[i].WIDTH, boxhelper->m_bodyes[i].HEIGHT), c_u_id++);
        shape_sh.setUniform("shape_pos", Eigen::Vector2f(boxhelper->m_bodyes[i].x, boxhelper->m_bodyes[i].y), c_u_id++);
        shape_sh.setUniform("shape_rotate_an", (float) boxhelper->m_bodyes[i].angle, c_u_id++);
        shape_sh.drawIndexed(GL_TRIANGLES, 0, B_CIRCLE_vertexCount); //boxhelper->m_bodyes[i].vertex_Count
    }

    glDisable(GL_DEPTH_TEST);
    glDisable(GL_BLEND);
    if (filtering->checked())gmap_box2d_fb_linear.release();

    else gmap_box2d_fb_near.release();
}

void Ccgm::box2d_draw_texture(Eigen::Vector2f screenSize, double loctime) {
    if (filtering->checked())gmap_textured_fb_linear.bind();
    else gmap_textured_fb_near.bind();

    glClearColor(0., 0., 0., 1.);
    glClear(GL_COLOR_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_COLOR, GL_ONE);

    glViewport(0, 0, screenSize[0], screenSize[1]);
    for (int i = 0; i < boxhelper->num_onscr_obj; i++) {
        int tp = B_CIRCLE;
        int vc = B_CIRCLE_vertexCount;
        float xf = 0;
        if ((boxhelper->m_bodyes[i].tile_m == TILE_SDF) || (boxhelper->m_bodyes[i].tile_m == TILE_SDF_SPAWN) || (boxhelper->m_bodyes[i].tile_m == TILE_PLAYER)) {
            if (boxhelper->m_bodyes[i].tile_m == TILE_PLAYER)xf = 15;
            glEnable(GL_DEPTH_TEST);
            glEnable(GL_BLEND);
            nanogui::MatrixXu indices = polygon_indices(B_CIRCLE);
            if (boxhelper->m_bodyes[i].tile_m == TILE_PLAYER) {
                tp = B_RECT;
                vc = B_RECT_vertexCount;
                indices = polygon_indices(B_RECT);
            }
            shape_sh_texture.uploadIndices(indices);
        } else {
            glDisable(GL_DEPTH_TEST);
            glDisable(GL_BLEND);
            tp = B_RECT;
            vc = B_RECT_vertexCount;
            nanogui::MatrixXu indices = polygon_indices(B_RECT);
            shape_sh_texture.uploadIndices(indices);
        }

        nanogui::MatrixXf positions = polygon_positions(tp, Eigen::Vector2f(-(((boxhelper->m_bodyes[i].x)) / (screenSize.x()))*2. + 1.,
                1. - ((boxhelper->m_bodyes[i].y) / screenSize.y())*2.), Eigen::Vector2f(screenSize.y() / screenSize.x(), 1.), boxhelper->m_bodyes[i].fb_HEIGHT / screenSize.y());
        shape_sh_texture.uploadAttrib("position", positions);


        shape_sh_texture.bind();
        int c_u_id = 0;
        shape_sh_texture.setUniform("u_resolution", screenSize, c_u_id++);
        shape_sh_texture.setUniform("shape_type", (int) boxhelper->m_bodyes[i].type_m, c_u_id++);
        shape_sh_texture.setUniform("shape_size", Eigen::Vector2f(boxhelper->m_bodyes[i].WIDTH, boxhelper->m_bodyes[i].HEIGHT), c_u_id++);
        shape_sh_texture.setUniform("shape_pos", Eigen::Vector2f(boxhelper->m_bodyes[i].x, boxhelper->m_bodyes[i].y), c_u_id++);
        shape_sh_texture.setUniform("shape_rotate_an", (float) boxhelper->m_bodyes[i].angle, c_u_id++);
        shape_sh_texture.setUniform("shape_rotate_Urot", (float) boxhelper->player_rot, c_u_id++);
        shape_sh_texture.setUniform("u_time", (float) loctime - (xf) + boxhelper->m_bodyes[i].l_shift, c_u_id++);
        shape_sh_texture.setUniform("u_rtime", (float) loctime, c_u_id++);
        shape_sh_texture.setUniform("ppower", (float) boxhelper->ppower, c_u_id++);
        shape_sh_texture.setUniform("ajcd", (float) boxhelper->ajcd / boxhelper->jcd, c_u_id++);
        shape_sh_texture.setUniform("ajcd2", (float) boxhelper->ajcd2 / boxhelper->jcd, c_u_id++);
        shape_sh_texture.setUniform("shape_tile", (int) boxhelper->m_bodyes[i].tile_m + (boxhelper->m_bodyes[i].newc), c_u_id++);

        shape_sh_texture.drawIndexed(GL_TRIANGLES, 0, vc); //boxhelper->m_bodyes[i].vertex_Count
    }

    glDisable(GL_DEPTH_TEST);
    glDisable(GL_BLEND);
    if (filtering->checked())gmap_textured_fb_linear.release();

    else gmap_textured_fb_near.release();
}

void Ccgm::setupdebug() {

    debugw = new debug_table(this);
}

void Ccgm::initall() {

    boxhelper = new box2dhelper_uni();
    boxhelper->init();
    setupdebug();
}

void Ccgm::update_vals(double loctime) {
    max_fb_size = max_fb_size_w->value();
    boxhelper->resetx = resetx;

    if (fps_ch->checked())fps_edit->setValue(std::max(fps_edit->value(), (int) fps));
    fps_r->setCaption(to_string((int) fps));
    boxhelper->ticknext(paused, fps_edit->value(), loctime, umouse[0], umouse[1], ffm);
}

void mainloop() {

    nanogui::mainloop();
}

int main(int /* argc */, char ** /* argv */) {
    try {
        nanogui::init();
        /* scoped variables */
        {
            nanogui::ref<Ccgm> app = new Ccgm();
            app->drawAll();
            app->setVisible(true);
            emscripten_set_main_loop(mainloop, 0, 1);
        }

        nanogui::shutdown();
    } catch (const std::runtime_error &e) {
        std::string error_msg = std::string("Caught a fatal error: ") + std::string(e.what());
#if defined(_WIN32)
        MessageBoxA(nullptr, error_msg.c_str(), NULL, MB_ICONERROR | MB_OK);
#else
        std::cerr << error_msg << endl;
#endif
        return -1;
    }

    return 0;
}
