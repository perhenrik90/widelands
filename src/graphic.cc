/*
 * Copyright (C) 2001 by Holger Rapp 
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */

#include "graphic.h"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

namespace Graph {

		  /** class Graphic
			*
			* This functions is responsible for displaying graphics and keeping them up to date
			*
			* It's little strange in it's interface, but it is optimzed for speed, not beauty
			* This is a singleton
			*/

		  /** Graphic::Graphic(void) 
			*
			* Default Constructor. Simple Inits
			*
			* Args: none
			* Returns: nothing
			*/
		  Graphic::Graphic(void) {
					 lpix=0;
					 sc=NULL;
					 pixels=NULL;
					 xres=yres=0;
					 st=NOT_INIT;
					 bis_fs=0;

					 SDL_Init(SDL_INIT_VIDEO);
		  }

		  /** Graphic::~Graphic(void) 
			*
			* simple cleanups. 
			*
			* Args: none
			* Returns: nothing
			*/
		  Graphic::~Graphic(void) {
					 lpix=0;
					 if(sc) {
								SDL_FreeSurface(sc);
								sc=NULL;
					 }
					 pixels=NULL;
					 xres=yres=0;
					 st=NOT_INIT;

					 SDL_Quit();
		  }

		  /** void Graphic::set_mode(const unsigned short x, const unsigned short y, const Mode m)
			*
			* This function sets a new graphics mode.
			*
			* Args:	x	x resolution
			* 		y	y resolution
			* 		m	either windows or fullscreen
			* Returns: Nothing
			*/
		  void Graphic::set_mode(const unsigned short x, const unsigned short y, const Mode m) {
					 if(sc)
								SDL_FreeSurface(sc);

					 if(m==MODE_FS) {
								sc = SDL_SetVideoMode(x, y, 16, SDL_SWSURFACE | SDL_FULLSCREEN);
								bis_fs=1;
					 } else {
								sc = SDL_SetVideoMode(x, y, 16, SDL_SWSURFACE);
								bis_fs=0;
					 }

					 xres=x; 
					 yres=y;
					 pixels=(unsigned short*) sc->pixels;

					 st=OK;

					 return;
		  }

		  /** void Graphic::update_screen(void);
			* 
			* This updates the whole screen
			*
			* Args: None
			* Returns: Nothing
			*/
		  void Graphic::update_screen(void) {
					 if(!sc) {
								st=ERROR;
								return;
					 }

					 SDL_UpdateRect(sc, 0, 0, xres, yres);
		  }
		  
		  /** void Graphic::update_rect(const unsigned short x, const unsigned short y, const unsigned short w, const unsigned short h);
			*
			* This updates a rect of the screen
			*
			* Args: 	x	upper left corner of rect
			* 			y  upper left corner of rect
			* 			w	width
			* 			h	height
			*/
		  void Graphic::update_rect(const unsigned short x, const unsigned short y, const unsigned short w, const unsigned short h) {
					 if(!sc) {
								st=ERROR;
								return;
					 }

					 SDL_UpdateRect(sc, x, y, w, h);
		  }

		  /** void Graphic::update_quarter(void) 
			*
			* This function updates a bit of the screen, but this bit moves around each time
			* this function gets called. 
			* So it's made sure, that the whole screen gets updated, when this function gets called
			* every frame
			*
			* Args: none
			* Returns: Nothing
			*/
		  void Graphic::update_quarter(void) {
					static unsigned int x; 
					static unsigned int y;
					static unsigned int xadd=xres/4;
					static unsigned int yadd=yres/4;

					if(x==xres) { x=0; y+=yadd; }
					if(y==yres) y=0;

					SDL_UpdateRect(sc, x, y, xadd, yadd);
					x+=xadd;
		  }
		  
		  /** void draw_pic(Pic* p, const unsigned short d_x_pos, const unsigned short d_y_pos,  const unsigned short p_x_pos, 
			* 		const unsigned short p_y_pos, const unsigned short i_w, const unsigned short i_h)
			*
			* 	This functions plots a picture onto the current screen
			*	
			*	friend to class pic and class Graphic
			*
			* 	Args:	p 	picture to plot
			* 			d_x_pos	xpos on screen
			* 			d_y_pos	ypos on screen
			* 			p_x_pos	start xpos in picture
			* 			p_y_pos	start ypos in picture
			* 			i_w		width
			* 			i_h		height
			* 	returns: Nothing
			*/
		  void draw_pic(Pic* p, const unsigned short d_x_pos, const unsigned short d_y_pos,  const unsigned short p_x_pos, const unsigned short p_y_pos, 
								const unsigned short i_w, const unsigned short i_h) {
					 unsigned short clr;
					 unsigned short w=i_w;
					 unsigned short h=i_h; 

					 if(d_x_pos+w>g_gr.get_xres()) w=g_gr.get_xres()-d_x_pos;
					 if(d_y_pos+h>g_gr.get_yres()) h=g_gr.get_yres()-d_y_pos;

					 if(p->has_clrkey()) {
								// Slow blit, checking for clrkeys. This could probably speed up by copying
								// 2 pixels (==4bytes==register width)
								// in one rush. But this is a nontrivial task
								for(unsigned long  y=0; y<h; y++) {
										  clr=p->get_pixel(p_x_pos, p_y_pos+y);
										  if(clr != p->get_clrkey()) g_gr.set_pixel(d_x_pos, d_y_pos+y, clr);
										  else g_gr.set_cpixel(d_x_pos, d_y_pos+y);
										  for(unsigned long x=1; x<w; x++) {
													 clr=p->get_npixel();
													 if(clr != p->get_clrkey()) g_gr.set_npixel(clr);
													 else g_gr.npixel();
										  }
								}
					 } else {
								unsigned long poffs=p->get_w()*p_y_pos + p_x_pos;
								unsigned long doffs=g_gr.get_xres()*d_y_pos + d_x_pos;

								// fast blitting, using memcpy
								for(unsigned long y=0; y<h; y++) {
										  memcpy(g_gr.pixels+doffs, p->pixels+poffs, w<<1); // w*sizeof(short) 
										  doffs+=g_gr.get_xres();
										  poffs+=p->get_w();
								}
					 }
		  }
											        
		  /** void copy_pic(Pic* dst, Pic* src, const unsigned short d_x_pos, const unsigned short d_y_pos,  const unsigned short p_x_pos, 
			* 		const unsigned short p_y_pos, const unsigned short i_w, const unsigned short i_h)
			*
			* 	This functions plots a picture into an other
			*
			*	friend to class pic
			*
			* 	Args:	src 	picture to plot
			* 			dst	picture to plot inside
			* 			d_x_pos	xpos on screen
			* 			d_y_pos	ypos on screen
			* 			p_x_pos	start xpos in picture
			* 			p_y_pos	start ypos in picture
			* 			i_w		width
			* 			i_h		height
			* 	returns: Nothing
			*/
		  void copy_pic(Pic* dst, Pic* src, const unsigned short d_x_pos, const unsigned short d_y_pos,  const unsigned short p_x_pos, 
								const unsigned short p_y_pos, const unsigned short i_w, const unsigned short i_h) {
					 unsigned short clr;
					 unsigned short w=i_w;
					 unsigned short h=i_h; 

					 if(d_x_pos+w>g_gr.get_xres()) w=g_gr.get_xres()-d_x_pos;
					 if(d_y_pos+h>g_gr.get_yres()) h=g_gr.get_yres()-d_y_pos;

					 if(src->has_clrkey() && (dst->get_clrkey()!=src->get_clrkey())) {
								for(unsigned long  y=0; y<h; y++) {
										  clr=src->get_pixel(p_x_pos, p_y_pos+y);
										  dst->set_pixel(d_x_pos, d_y_pos+y, clr);
										  for(unsigned long x=1; x<w; x++) {
													 clr=src->get_npixel();
													 dst->set_npixel(clr);
										  }
								}
					 } else {
								unsigned long soffs=src->get_w()*p_y_pos + p_x_pos;
								unsigned long doffs=dst->get_w()*d_y_pos + d_x_pos;

								// fast blitting, using memcpy
								for(unsigned long y=0; y<h; y++) {
										  memcpy(dst->pixels+doffs, src->pixels+soffs, w<<1); // w*sizeof(short) 
										  doffs+=dst->get_w();
										  soffs+=src->get_w();
								}
					 }		  
		  }
}
