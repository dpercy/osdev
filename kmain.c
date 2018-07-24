
typedef int size_t;
#define offsetof(st, m) ((size_t)&(((st *)0)->m))


enum color {
    Black = 0,
    Blue,
    Green,
    Cyan,
    Red,
    Magenta,
    Brown,
    LightGray,
    Lighter = 8,
    DarkGray = Lighter|Black,
    White = Lighter|LightGray,
};

struct framebuffer_paint {
    enum color fg:4;
    enum color bg:4;
} __attribute__((packed));

struct framebuffer_cell {
    unsigned char ascii;
    struct framebuffer_paint paint;
};

_Static_assert(sizeof(struct framebuffer_cell) == 2, "sizeof framebuffer_cell");
_Static_assert(offsetof(struct framebuffer_cell, ascii) == 0, "offsetof ascii");
_Static_assert(offsetof(struct framebuffer_cell, paint) == 1, "offsetof paint");

// The framebuffer is almost like a global variable that the CPU defines,
// instead of the C compiler.
// So we can define it "extern", and set its address in the linker script.
// Also it has to be volatile so that the C compiler knows that
// it can't assume apparently-unused writes are really unused.
extern volatile struct framebuffer_cell framebuffer[25][80];


int kmain() {
    struct framebuffer_paint paint = { .bg = Black, .fg = LightGray };

    framebuffer[0][0] = (struct framebuffer_cell){ .paint = paint, .ascii = 'H' };
    framebuffer[0][1] = (struct framebuffer_cell){ .paint = paint, .ascii = 'i' };
    framebuffer[0][2] = (struct framebuffer_cell){ .paint = paint, .ascii = '!' };

    return 0;
}

