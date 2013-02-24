#import "NexusViewController.h"
#import "NexusCommon.h"

#define PERSPECTIVE (1.0f)
#define PERSPECTIVE_INV (1.0f/PERSPECTIVE)

@implementation NexusViewController
@synthesize img;

-(GLKTextureInfo*)bg
{
    return bg;
}

-(GLKTextureInfo*)tip
{
    return tip;
}

-(void)setBg:(GLKTextureInfo*)t
{
    if (t == bg) return;
    if (bg)
    {
        GLuint nn = bg.name;
        glDeleteTextures(1, &nn);
    }
    [bg release];
    [t retain];
    bg = t;
}

-(void)setTip:(GLKTextureInfo*)t
{
    if (t == tip) return;
    if (tip)
    {
        GLuint nn = tip.name;
        glDeleteTextures(1, &nn);
    }
    [tip release];
    [t retain];
    tip = t;
}

-(void)updateTexture
{
    UIImage * i = wallpaper ? img : NULL;
    if (i == last_img) return;
    last_img = i;
    if (i)
    {
        self.bg = [self textureFromUIImage:i];
    } else {
        self.bg = [self textureNamed:@"bg"];
        glBindTexture(bg.target, bg.name);
        glTexParameteri(bg.target, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(bg.target, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    }

    [self updateBgMatrix];
}

-(void)updateBgMatrix
{
    LPMatrix4 m;
    LPVector2 vsize = self.view.bounds.size;

    if (last_img)
        m.loadScaling(1.0f / imgRect.size.width, 1.0f / imgRect.size.height, 1.0f);
    else
    {
        LPVector2 ims(bg.width, bg.height);
        LPVector2 scn = vsize;
        BOOL rotate = scn.width > scn.height;
        if (rotate)
        {
            float aux = scn.width;
            scn.width = scn.height;
            scn.height = aux;
            m.loadRotation(M_PI_2);
        } else
            m.loadIdentity();

        float ar_ims = ims.width / ims.height;
        float ar_scn = scn.width / scn.height;
        if (ar_scn > ar_ims)
            m *= LPMatrix4::scaling(1.0f, ar_scn / ar_ims);
        else 
            m *= LPMatrix4::scaling(ar_ims / ar_scn, 1.0f);
    }

    glUseProgram(basic_program);
    m.setUniform(modelViewProj_uniform_basic);

    sz = LPVector2(vsize.width / vsize.height, 1.0f);
    m.loadScaling(1.0f / sz.width, 1.0f);
    m.m[11] = PERSPECTIVE; //we're using the w component to create perspective

    glUseProgram(part_program);
    m.setUniform(modelViewProj_uniform_part);
    glUseProgram(tip_program);
    m.setUniform(modelViewProj_uniform_tip);
}

-(void)reloadPreferences
{
    [self setCurrentContext];
    
    NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:NXPrefsPath];

    NSNumber * nr;
#define getparam(key, type, var, def) nr = [prefs objectForKey:key]; if([nr isKindOfClass:[NSNumber class]]) var = nr. type ## Value; else var = def
    getparam(NXWallKey,       bool, wallpaper, NO);
    getparam(NXLengthKey,     float, length, 0.6f);
    getparam(NXWidthKey,      float, width, 0.035f);
    getparam(NXVelocityKey,   float, velocity, 0.4f);
    getparam(NXZToleranceKey, float, zTolerance, 0.5f);
    getparam(NXCountKey,      int, count, 10);

    [self updateTexture];
}

-(void)setWallpaperImage:(UIImage*)_img
{
    self.img = _img;
    [self setCurrentContext];
    [self updateTexture];
}

-(void)setWallpaperRect:(CGRect)r
{
    imgRect = r;
    [self setCurrentContext];
    [self updateBgMatrix];
}

-(void)reshape
{
    [self setCurrentContext];
    [self updateBgMatrix];
}

-(void)setupGL
{
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glActiveTexture(GL_TEXTURE0);

	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_DST_ALPHA); //additive blending

    self.view.multipleTouchEnabled = YES;

    srand(time(NULL));

    //load bg shader
    basic_program = [self programNamed:@"basic" withBindings:^(GLuint program) {
        glBindAttribLocation(program, 0, "position");
        glBindAttribLocation(program, 1, "texCoord");
    }];
    glUseProgram(basic_program);
    glUniform1i(glGetUniformLocation(basic_program, "texture"), 0);
    modelViewProj_uniform_basic = glGetUniformLocation(basic_program, "modelViewProjectionMatrix");

    //load part shader
    part_program = [self programNamed:@"strips" withBindings:^(GLuint program) {
        glBindAttribLocation(program, 0, "position");
        glBindAttribLocation(program, 1, "color");
    }];
    modelViewProj_uniform_part = glGetUniformLocation(part_program, "modelViewProjectionMatrix");

    //load tip shader
    tip_program = [self programNamed:@"tip" withBindings:^(GLuint program) {
        glBindAttribLocation(program, 0, "position");
        glBindAttribLocation(program, 1, "color");
        glBindAttribLocation(program, 2, "texCoord");
    }];
    glUseProgram(tip_program);
    glUniform1i(glGetUniformLocation(tip_program, "texture"), 0);
    modelViewProj_uniform_tip = glGetUniformLocation(tip_program, "modelViewProjectionMatrix");

    //load tip texture
    self.tip = [self textureNamed:@"tip"];

    //create bg vao
    glGenVertexArraysOES(1, &bg_vao);
    glBindVertexArrayOES(bg_vao);

    glGenBuffers(1, &bg_vbo);
    glBindBuffer(GL_ARRAY_BUFFER, bg_vbo);
    GLfloat array[] = {
        -1.0f, -1.0f,  0.0f,  0.0f,
        -1.0f,  1.0f,  0.0f,  1.0f,
         1.0f, -1.0f,  1.0f,  0.0f,
         1.0f,  1.0f,  1.0f,  1.0f,
    };
    glBufferData(GL_ARRAY_BUFFER, sizeof(array), array, GL_STATIC_DRAW);

    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), NULL);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), ((GLfloat*)NULL)+2);

    //create particle vao
    glGenVertexArraysOES(1, &part_vao);
    glBindVertexArrayOES(part_vao);

    glGenBuffers(1, &part_vbo);
    glBindBuffer(GL_ARRAY_BUFFER, part_vbo);

    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), NULL);
    glVertexAttribPointer(1, 4, GL_UNSIGNED_BYTE, GL_TRUE, 4*sizeof(GLfloat), ((GLfloat*)NULL)+3);

    //create tip vao
    glGenVertexArraysOES(1, &tip_vao);
    glBindVertexArrayOES(tip_vao);

    glGenBuffers(1, &tip_vbo);
    glBindBuffer(GL_ARRAY_BUFFER, tip_vbo);

    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6*sizeof(GLfloat), NULL);
    glVertexAttribPointer(1, 4, GL_UNSIGNED_BYTE, GL_TRUE, 6*sizeof(GLfloat), ((GLfloat*)NULL)+3);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 6*sizeof(GLfloat), ((GLfloat*)NULL)+4);

    //load preferences
    last_img = (UIImage*)(void*)(size_t)(-1);
    [self reloadPreferences];
}

-(void)tearDownGL
{
    self.bg = nil;
    self.tip = nil;

    glDeleteProgram(basic_program);
    glDeleteVertexArraysOES(1, &bg_vao);
    glDeleteBuffers(1, &bg_vbo);

    glDeleteProgram(part_program);
    glDeleteVertexArraysOES(1, &part_vao);
    glDeleteBuffers(1, &part_vbo);

    glDeleteProgram(tip_program);
    glDeleteVertexArraysOES(1, &tip_vao);
    glDeleteBuffers(1, &tip_vbo);
}

-(void)dealloc
{
    free(v);
    free(data);
    free(tip_data);
    self.bg = nil;
    [super dealloc];
}

inline float randf()
{
    return rand() * (1.0f / RAND_MAX);
}

#define randfw() ((randf() - 0.5f) * 2.0f)

static const uint32_t particle_colors[] = {
    0xff9f00,
    0xff0000,
    0x00ff00,
    0x0000ff,
};

void generateParticle(NexusViewController * self, particle * p)
{
    p->type = rand() & 3;
    p->color = (particle_colors[rand() % (sizeof(particle_colors)/sizeof(uint32_t))] << 8) | 0x80;

    static const LPVector2 a[] = {
        LPVector2( 0, -1),
        LPVector2( 0,  1),
        LPVector2(-1,  0),
        LPVector2( 1,  0),
    };
    static const LPVector2 b[] = {
        LPVector2(1, 0),
        LPVector2(1, 0),
        LPVector2(0, 1),
        LPVector2(0, 1),
    };
    
    float z = randfw() * self->zTolerance;
    LPVector2 sz = self->sz * (1.0f + PERSPECTIVE * z);
    p->pos = LPVector3(a[p->type] * (sz * (1.0f + randf()) + LPVector2(self->width, self->width)) + b[p->type] * sz * randfw(), z);
}

BOOL particleOutOfBounds(NexusViewController * self, particle * p)
{
    float f = 0;
    LPVector2 sz = self->sz * (1.0f + PERSPECTIVE * p->pos.z);
    switch (p->type)
    {
        case 0:
            f = p->pos.y - sz.height;
            break;
        case 1:
            f = -p->pos.y - sz.height;
            break;
        case 2:
            f = p->pos.x - sz.width;
            break;
        case 3:
            f = -p->pos.x - sz.width;
            break;
    }
    f -= self->length + self->width;
    return f > 0.0f;
}

void computeParticle(NexusViewController * self, particle * p, GLfloat * data, GLfloat * tip)
{
    if (p->type == 5)
    {
        memset(data, 0, sizeof(GLfloat) * 16);
        memset(tip, 0, sizeof(GLfloat) * 24);
        return;
    }

    uint32_t color = htonl(p->color);

#define tof(x) (*(GLfloat*)(&(x)))
    typedef union { 
        GLfloat f;
        struct { 
            uint8_t r,g,b,a;
        } c;
    } clr;
#define toc(x) (*(clr*)(&(x)))

    LPVector3 ps = p->pos;
    GLfloat margin = self->width;
    GLfloat len = self->length;

    GLfloat l,r,u,d,z;
    l = ps.x - margin;
    r = ps.x + margin;
    u = ps.y + margin;
    d = ps.y - margin;
    z = ps.z;

    switch (p->type)
    {
        case 0:
            d -= len;
            break;
        case 1:
            u += len;
            break;
        case 2:
            l -= len;
            break;
        case 3:
            r += len;
            break;
    }

    data[0] = l;  data[1] = d;  data[2] = z;  data[3] = tof(color);
    data[4] = l;  data[5] = u;  data[6] = z;  data[7] = tof(color);
    data[8] = r;  data[9] = d;  data[10] = z; data[11] = tof(color);
    data[12] = r; data[13] = u; data[14] = z; data[15] = tof(color);

    switch (p->type)
    {
        case 0:
            toc(data[3]).c.a = 0;
            toc(data[11]).c.a = 0;
            break;
        case 1:
            toc(data[7]).c.a = 0;
            toc(data[15]).c.a = 0;
            break;
        case 2:
            toc(data[3]).c.a = 0;
            toc(data[7]).c.a = 0;
            break;
        case 3:
            toc(data[11]).c.a = 0;
            toc(data[15]).c.a = 0;
            break;
    }

    margin *= 4;
    l = ps.x - margin;
    r = ps.x + margin;
    u = ps.y + margin;
    d = ps.y - margin;

    tip[0] = l;  tip[1] = d;  tip[2] = z;  tip[3] = tof(color);  tip[4] = 0;  tip[5] = 0;
    tip[6] = l;  tip[7] = u;  tip[8] = z;  tip[9] = tof(color);  tip[10] = 0; tip[11] = 1;
    tip[12] = r; tip[13] = d; tip[14] = z; tip[15] = tof(color); tip[16] = 1; tip[17] = 0;
    tip[18] = r; tip[19] = u; tip[20] = z; tip[21] = tof(color); tip[22] = 1; tip[23] = 1;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    for (UITouch * touch in touches)
        [self spawn:[touch locationInView:self.view]];
}

-(void)spawn:(CGPoint)pnt
{
    LPVector2 p(pnt);
    LPVector2 siz(self.view.bounds.size);
    p = p * (2.0f / siz.height) - LPVector2(siz.width / siz.height, 1.0f);
    p.y = -p.y;

    uint32_t colors[4] = { particle_colors[0], particle_colors[1], particle_colors[2], particle_colors[3] };
    for (int i = 0; i < 5; i++)
    {
        int a = rand() & 3, b = rand() & 3;
        if (a!=b)
        {
            colors[a] = colors[a] ^ colors[b];
            colors[b] = colors[a] ^ colors[b];
            colors[a] = colors[a] ^ colors[b];
        }
    }
    v = (particle*)realloc(v, sizeof(particle) * (count + spawns + 4));
    particle * vv = v + (count + spawns);
    spawns += 4;
    for (int i = 0; i < 4; i++)
    {
        vv[i].type = i;
        vv[i].color = colors[i] << 8 | 0x80;
        vv[i].pos = p;
    }
}

-(void)update
{
    [self setCurrentContext];
    if (n != count + spawns)
    {
        size_t oldn = n;
        n = count + spawns;
        v = (particle*)realloc(v, sizeof(particle) * n);
        data = (GLfloat*)realloc(data, count ? sizeof(GLfloat) * (n * 6 - 2) * 4 : 0);
        tip_data = (GLfloat*)realloc(tip_data, count ? sizeof(GLfloat) * (n * 6 - 2) * 6 : 0);
        for (size_t i = oldn; i < count; i++)
            generateParticle(self, v + i);
    }
    for (size_t i = 0; i < n; i++)
    {
        particle * p = v + i;
        const LPVector2 a[] = { 
            LPVector2(0, 1),
            LPVector2(0, -1),
            LPVector2(1, 0),
            LPVector2(-1, 0)
        };
        p->pos += a[p->type] * (velocity * self.adjustedTimeSinceLastUpdate);
        if (particleOutOfBounds(self, p))
        {
            if (i >= count)
                p->type = 5;
            else
                generateParticle(self, p);
        }
    }
    while (spawns && v[count + spawns - 1].type == 5)
    {
        spawns--;
        n--;
    }
    if (n)
    {
        computeParticle(self, v, data, tip_data);
        GLfloat * dt = data + 4*4;
        GLfloat * tt = tip_data + 6*4;
        for (size_t i = 1; i < n; i++, dt += 4*6, tt += 6*6)
        {
            computeParticle(self, v + i, dt + 4*2, tt + 6*2);
            for (int j = 0; j < 4; j++)
                dt[j] = dt[j-4];
            for (int j = 4; j < 8; j++)
                dt[j] = dt[j+4];
            for (int j = 0; j < 6; j++)
                tt[j] = tt[j-6];
            for (int j = 6; j < 12; j++)
                tt[j] = tt[j+6];
        }

        glBindBuffer(GL_ARRAY_BUFFER, part_vbo);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * (n*6-2) * 4, data, GL_STREAM_DRAW);
        glBindBuffer(GL_ARRAY_BUFFER, tip_vbo);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * (n*6-2) * 6, tip_data, GL_STREAM_DRAW);
    }

}

-(void)render
{
    glClear(GL_COLOR_BUFFER_BIT);

    glBindTexture(bg.target, bg.name);
    glUseProgram(basic_program);
    glBindVertexArrayOES(bg_vao);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    if (n)
    {
        glUseProgram(part_program);
        glBindVertexArrayOES(part_vao);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, n * 6 - 2);

        glBindTexture(tip.target, tip.name);
        glUseProgram(tip_program);
        glBindVertexArrayOES(tip_vao);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, n * 6 - 2);
    }
}

//#define test(x) -(void)x:(BOOL)animated { [super x:animated]; NSLog(@"------------" #x ); }
#define test(x)
test(viewWillAppear);
test(viewWillDisappear);
test(viewDidAppear);
test(viewDidDisappear);

@end
