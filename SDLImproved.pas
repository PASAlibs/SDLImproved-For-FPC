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
	keypressedType = Procedure (key : Integer ; release : Boolean);

Procedure StartApp(load : loadType ; update : updateType ; draw : drawType ; mousepressed : mousepressedType; keypressed : keypressedType);
	
Procedure WindowSetting(Caption : PChar);
Procedure WindowSetting(Caption : PChar; width,height : Word);


Implementation

Var
	AppStarted : Boolean;

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
	delatimer,dt,fpstimer : Real;
	mousep,mouseLeft,keyp : Boolean;
Begin
	AppStarted := True;
	mousep := False;
	mouseLeft := False;
	keyp := False;
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

		If(keyp and (sdl_get_keyreleased <> -1)) Then
		Begin
			keypressed(sdl_get_keyreleased, True);
			keyp := False;
		End
		Else If(not keyp) Then
			keyp := (sdl_get_keypressed <> -1);

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

Initialization
	AppStarted := False;

End.
