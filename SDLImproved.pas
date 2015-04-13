{
* Copyright © 2015 Samuel Guillaume <samuel.guillaumes@eisti.eu> 
* This work is free. You can redistribute it and/or modify it under the
* terms of the Do What The Fuck You Want To Public License, Version 2,
* as published by Sam Hocevar. See the LICENSE file for more details.
}

{$MODE ObjFPC} 
Unit SDLImproved;

Interface

uses crt, sysutils, gLib2D,GL, SDL, SDL_TTF, SDL_Addon;

Type
	loadType = Procedure (); 
	updateType = Procedure (dt : Real); 
	drawType = Procedure (fps : Real);
	mousepressedType = Procedure (left : Boolean ; x,y : real ; release : Boolean);
	keypressedType = Procedure (key : Word ; release : Boolean);

	Vector2D = Record
			x,y : Real;
		End;

Procedure StartApp(load : loadType ; update : updateType ; draw : drawType ; mousepressed : mousepressedType; keypressed : keypressedType);
Procedure StartApp(load : loadType ; update : updateType ; draw : drawType ; mousepressed : mousepressedType);
	Procedure StartApp(load : loadType ; update : updateType ; draw : drawType ; keypressed : keypressedType);
Procedure StartApp(load : loadType ; update : updateType ; draw : drawType);

	
Procedure WindowSetting(Caption : PChar);
Procedure WindowSetting(Caption : PChar; width,height : Word);

Function isKeyDown(k : Word) : Boolean;
Function GetMouseXY() : Vector2D;
Function IsVisible() : Boolean;

// Shortcuts
Procedure gDrawText(s : String; font : PTTF_Font; x,y : Real; color : gColor; mode : byte);
Procedure gDrawPoint(x,y : Real; color : gColor);
Procedure gDrawLine(x1,y1,x2,y2 : Real; color : gColor);
Procedure gDrawTriangle(x1,y1,x2,y2,x3,y3 : Real; color : gColor);
Procedure gFillTriangle(x1,y1,x2,y2,x3,y3 : Real; color : gColor);


Implementation

Var
	i : Word;
	AppStarted,focus : Boolean;
	keymap : array[0..512] of Boolean;
	mousePosition : Vector2D;

Function TimeMS() : Real;
Begin 
	exit(TimeStampToMSecs(DateTimeToTimeStamp(Now)));
End;

Procedure WindowSetting(Caption : PChar);
Begin
	SDL_WM_SetCaption(Caption, nil);
End;

Procedure WindowSetting(Caption : PChar; width,height : Word);
Begin
	SDL_WM_SetCaption(Caption, nil);
	If(not AppStarted) Then
	Begin
		G_SCR_W := width;
	  G_SCR_H := height;
	End;
End;

Procedure StartApp(load : loadType ; update : updateType ; draw : drawType ; mousepressed : mousepressedType; keypressed : keypressedType);
Var
	k : Integer;
	delatimer,dt,fpstimer : Real;
	mousep,mouseLeft : Boolean;
Begin
	AppStarted := True;
	mousep := False;
	mouseLeft := False;

	gClear(BLACK);
	load;
	delatimer := TimeMS;
	fpstimer := TimeMS;
	Repeat
		dt := TimeMS - delatimer;
		If(dt <> 0) Then
		Begin
			update(dt);
			delatimer := TimeMS;
		End;
		focus := (sdl_get_mouse_x <> 0) and (sdl_get_mouse_y <> 0);
		If(focus) Then
		Begin
			mousePosition.x := sdl_get_mouse_x;
			mousePosition.y := sdl_get_mouse_y;
		End;

		If(mousep and (sdl_mouse_left_click_released or sdl_mouse_right_click_released)) Then
		Begin
			mousepressed(sdl_mouse_left_click_released,sdl_get_mouse_x,sdl_get_mouse_y,True);
			mousep := False;
		End
		Else If(mousep) Then
			mousepressed(mouseLeft,sdl_get_mouse_x,sdl_get_mouse_y,False)
		Else If(not mousep) Then
		Begin
			mousep := (sdl_mouse_left_click or sdl_mouse_right_click);
			mouseLeft := sdl_mouse_left_click;
		End;

		k := sdl_get_keypressed;
		If(k <> -1) Then
			keymap[k] := True;

		k := sdl_get_keyreleased;
		If(k <> -1) Then
			If(keymap[k]) Then
			Begin
				keypressed(k, True);
				keymap[k] := False;
			End;

		For i := 0 to Length(keymap)-1 do
			If(keymap[i]) Then
				keypressed(i, False);

		If((TimeMS - fpstimer) > (1000/60)) Then
		Begin
			gClear(BLACK);
			draw(1000/(TimeMS - fpstimer));
			gFlip();

			While (sdl_update = 1) Do
			Begin
				If (sdl_do_quit) Then
					exit;
			End;
			fpstimer := TimeMS;
		End;
	Until False;
End;

Procedure emptykeypressed(key : Word ; release : Boolean);
Begin
End;

Procedure emptymousepressed(left : Boolean; x,y : real ; release : Boolean);
Begin
End;

Procedure StartApp(load : loadType ; update : updateType ; draw : drawType ; mousepressed : mousepressedType);
Begin
	StartApp(load,update,draw,mousepressed,@emptykeypressed);
End;

Procedure StartApp(load : loadType ; update : updateType ; draw : drawType ; keypressed : keypressedType);
Begin
	StartApp(load,update,draw,@emptymousepressed,keypressed);
End;

Procedure StartApp(load : loadType ; update : updateType ; draw : drawType );
Begin
	StartApp(load,update,draw,@emptymousepressed,@emptykeypressed);
End;

Function isKeyDown(k : Word) : Boolean;
Begin
	If(k < Length(keymap)) Then
		exit(keymap[k])
	Else
		exit(False);
End;

Function GetMouseXY() : Vector2D;
Begin
	exit(mousePosition);
End;

Function IsVisible() : Boolean;
Begin
	exit(focus);
End;

// Shortcuts
Procedure gDrawText(s : String; font : PTTF_Font; x,y : Real; color : gColor; mode : byte);
Var
	text : gImage;
Begin
	text := gTextLoad(s, font);
	gBeginRects(text);
		gSetCoordMode(mode);
		gSetCoord(x,y);
		gSetColor(color);
		gAdd();
	gEnd();
End;

Procedure gDrawPoint(x,y : Real; color : gColor);
Begin
 	gBeginPoints();
 		gSetColor(color);
		gSetCoord(x,y);
		gAdd();
	gEnd;
End;

Procedure gDrawLine(x1,y1,x2,y2 : Real; color : gColor);
Begin
	gBeginLines(G_STRIP);
		gSetColor(color);
		gSetCoord(x1, y1);
		gAdd();
		gSetCoord(x2, y2);
		gAdd();
	gEnd();
End;

Procedure gDrawTriangle(x1,y1,x2,y2,x3,y3 : Real; color : gColor);
Begin
	gBeginLines(G_STRIP);
		gSetColor(color);
		gSetCoord(x1, y1);
		gAdd();
		gSetCoord(x2, y2);
		gAdd();
		gSetCoord(x3, y3);
		gAdd();
		gSetCoord(x1, y1);
		gAdd();
	gEnd();
End;

Procedure gFillTriangle(x1,y1,x2,y2,x3,y3 : Real; color : gColor);
Var
	centerX,centerY,i : Real;
Begin
	i := 0.1;
	centerX := (x1 + x2 + x3)/3;
	centerY := (y1 + y2 + y3)/3;
	Repeat
		gDrawTriangle(x1,y1,x2,y2,x3,y3,color);
		If(x1 > centerX) Then x1 := x1 - i
		Else x1 := x1 + i;
		If(x2 > centerX) Then x2 := x2 - i
		Else x2 := x2 + i;
		If(x3 > centerX) Then x3 := x3 - i
		Else x3 := x3 + i;

		If(y1 > centerY) Then y1 := y1 - i
		Else y1 := y1 + i;
		If(y2 > centerY) Then y2 := y2 - i
		Else y2 := y2 + i;
		If(y3 > centerY) Then y3 := y3 - i
		Else y3 := y3 + i;
	Until ((ABS(x1-centerX) < i) and ((ABS(x2-centerX) < i)) and (ABS(x3-centerX) < i)) and ((ABS(y1-centerY) < i) and ((ABS(y2-centerY) < i)) and (ABS(y3-centerY) < i));
End;

Initialization
	AppStarted := False;
	focus := True;
	For i := 0 to Length(keymap)-1 do
		keymap[i] := False;

	mousePosition.x := 0;
	mousePosition.y := 0;
End.
