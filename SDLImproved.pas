{$MODE ObjFPC} 
Unit SDLImproved;

Interface

uses crt, sysutils, gLib2D, SDL, SDL_TTF, SDL_Addon;

Type
	loadType = procedure (); 
	updateType = procedure (dt : Real); 
	drawType = procedure (fps : Real);
	mousepressedType = procedure (left : Boolean ; x,y : real);
	keypressedType = Procedure (key : Integer);

Procedure StartApp(load : loadType ; update : updateType ; draw : drawType ; mousepressed : mousepressedType; keypressed : keypressedType);


Implementation

Function TimeMS() : Real;
Begin 
	exit(TimeStampToMSecs(DateTimeToTimeStamp(Now)));
End;

Procedure StartApp(load : loadType ; update : updateType ; draw : drawType ; mousepressed : mousepressedType; keypressed : keypressedType);
Var
	delatimer,dt,fpstimer : Real;
	mousep,keyp : Boolean;
Begin
	mousep := False;
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
			mousepressed(sdl_mouse_left_click_released,sdl_get_mouse_x,sdl_get_mouse_y);
			mousep := False;
		End
		Else If(not mousep) Then
			mousep := (sdl_mouse_left_click or sdl_mouse_right_click);

		If(keyp and (sdl_get_keyreleased <> -1)) Then
		Begin
			keypressed(sdl_get_keyreleased);
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

End.