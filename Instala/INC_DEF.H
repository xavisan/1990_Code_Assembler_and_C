/*
 * Fichero inc_def.h
 *
 */

#include <stdio.h>
#include <string.h>
#include <io.h>
#include <graph.h>
#include <dos.h>
#include <conio.h>
#include <bios.h>
#include <process.h>


#define clrscr()   _clearscreen(_GCLEARSCREEN)

#define ESC        27
#define RETURN     13
#define F1         59
#define F2         60
#define F3         61
#define F4         62
#define F5         63
#define F6         64
#define F7         65
#define F8         66
#define CURON()    _settextcursor(0x0707)
#define CUROFF()   _settextcursor(0x2000)
