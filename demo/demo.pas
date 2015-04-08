{$MODE ObjFPC} 
Program Demo;
uses crt,sysutils,gLib2D, SDL_TTF, SDL_Addon, SDLImproved;

Type
	CircleType = Record
			x,y,radius : real;
			color : gColor;
		End;
	BallType = Record
		x,y,radius,dirX,dirY : real;
		speedX,speedY : real;
		color : gColor;
	End;

Var
	font : PTTF_Font;
	circle : CircleType;
	ball : BallType;
	click : Word;

Procedure Load();
Begin
	WindowSetting('Demo',800,600);
	
	click := 0;
	font := TTF_OpenFont('CodeNewRoman.ttf', 20);
	circle.x := 0 ; circle.y := 0 ; circle.radius := 50; circle.color := WHITE;
	ball.x := G_SCR_W/2;
	ball.y := G_SCR_H/2;
	ball.dirX := 1;
	ball.dirY := -1;
	ball.radius := 25;
	ball.speedX := 550/1000;
	ball.speedY := 470/1000;
	ball.color := White;
End;

Procedure Update(dt : Real);
Begin
	ball.x := ball.x + dt*ball.speedX*ball.dirX;
	ball.y := ball.y + dt*ball.speedY*ball.dirY;

	If((ball.x < ball.radius)) Then
		ball.x := ball.radius
	Else If(ball.x > G_SCR_W-ball.radius) Then
		ball.x := G_SCR_W-ball.radius;

	If((ball.y < ball.radius)) Then
		ball.y := ball.radius
	Else If(ball.y > G_SCR_H-ball.radius) Then
		ball.y := G_SCR_H-ball.radius;

	If((ball.x <= ball.radius) or (ball.x >= G_SCR_W-ball.radius)) then
		ball.dirX := - ball.dirX;
	If((ball.y <= ball.radius) or (ball.y >= G_SCR_H-ball.radius)) then
		ball.dirY := - ball.dirY;
End;

Procedure Draw(fps : Real);
Var 
	fpsText : gImage;
Begin
	fpsText := gTextLoad('FPS : ' + FloatToStr((fps)), font);

	gBeginRects(fpsText);
		gSetCoordMode(G_UP_LEFT);
		gSetCoord(0,0);
		gSetColor(WHITE);
		gAdd();
	gEnd();

	gDrawCircle(circle.x,circle.y,circle.radius,circle.color);
	gDrawCircle(ball.x,ball.y,ball.radius,ball.color);
End;

Procedure MousePressed(left : Boolean; x,y : real);
Begin
	inc(click);
	Writeln(click);
	circle.x := x;
	circle.y := y;
	If(left) Then
		circle.color := WHITE
	Else
		circle.color := RED;
End;

Procedure KeyPressed(key : Integer);
Begin
	Write(chr(key));
End;

Begin
	StartApp(@load,@update,@draw,@mousepressed,@keypressed);
	Writeln;
End.
