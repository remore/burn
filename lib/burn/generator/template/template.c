#include "neslib.h"
#include "test.h"

#define NTADR(x,y) ((0x2000|((y)<<5)|x))
#define MSB(x) (((x)>>8))
#define LSB(x) (((x)&0xff))

const unsigned char palSprites[16]={
	0x0f,0x17,0x27,0x37,
	0x0f,0x11,0x21,0x31,
	0x0f,0x15,0x25,0x35,
	0x0f,0x19,0x29,0x39
};

static unsigned char vram_buffer[896]; // 896:32*28
static unsigned char spr;

void put_str(unsigned int adr,const char *str)
{
	vram_adr(adr);

	while(1)
	{
		if(!*str) break;
		vram_put((*str++)-0x20); //-0x20 because ASCII code 0x20 is placed in tile 0 of the CHR
	}
}

void screen_fade_out(interval){
	unsigned char i=0x05;
	while(1){
		//ppu_waitnmi();//wait for next TV frame
		i--;
		pal_bright(i);
		delay(interval);
		if (i==0){
			break;
		}
	}
}

void screen_fade_in(){
	unsigned char i=0x00;
	while(1){
		//ppu_waitnmi();//wait for next TV frame
		i++;
		pal_bright(i);
		delay(5);
		if (i==4){
			break;
			//goto mystart;
		}
	}
}

void init_screen(){
	memfill(vram_buffer, 0, 896); // 896:32*28
	vram_write((unsigned char *)vram_buffer, NTADR(0, 1), 32 * 28);
}

void init(){
	pal_spr(palSprites);//set palette for sprites
	pal_col(1,0x30);//set while color
}

int is_pressed(unsigned char pad){
	unsigned char i;
	i=pad_poll(0);
	return i&pad;
}

typedef struct {
	int x;
	int y;
	unsigned char pattern[];
} sprite_schema;

__@__GLOBAL__@__

void sprite(sprite_schema *data){
	spr=oam_meta_spr(data->x,data->y,spr,data->pattern);
}

void main(void)
{
__@__MAIN__@__
}

