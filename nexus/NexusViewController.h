#import "LPGL/LPGL.h"

struct particle
{
    LPVector3 pos;
    uint32_t color;
    int type;
};

@interface NexusViewController : LPGLViewController
{
    GLuint basic_program;
    GLuint bg_vbo;
    GLuint bg_vao;

    GLuint part_program;
    GLuint part_vao;
    GLuint part_vbo;

    GLuint tip_program;
    GLuint tip_vao;
    GLuint tip_vbo;

    BOOL wallpaper;

    GLint modelViewProj_uniform_basic;
    GLint modelViewProj_uniform_part;
    GLint modelViewProj_uniform_tip;

    CGRect imgRect;
    UIImage * last_img;

    particle * v;
    GLfloat * data;
    GLfloat * tip_data;
    size_t count, n, spawns;

    float length, width, velocity, zTolerance;

    LPVector2 sz;

    GLKTextureInfo * tip;
    GLKTextureInfo * bg;
    
    uint32_t particle_colors[4]; 
   
}
@property(nonatomic,retain) GLKTextureInfo * bg;
@property(nonatomic,retain) GLKTextureInfo * tip;
@property(nonatomic,retain) UIImage * img;

-(void)setupGL;
-(void)tearDownGL;
-(void)update;
-(void)render;
-(void)reshape;

-(void)dealloc;

-(void)spawn:(CGPoint)pnt;

-(void)updateBgMatrix;
-(void)updateTexture;

-(void)reloadPreferences;
-(void)setWallpaperImage:(UIImage*)img;
-(void)setWallpaperRect:(CGRect)r;

@end
