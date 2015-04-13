{$MODE ObjFPC} 
Program Demo;
uses crt,sysutils,gLib2D, SDL_TTF, SDL_Addon, SDLImproved;

Type
	RectType = Record
			x,y,width,height : real;
			color : gColor;
		End;
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
	bottomLeft : RectType;

Procedure Load();
Begin
	WindowSetting('Demo',800,600);
	
	click := 0;
	font := TTF_OpenFont('CodeNewRoman.ttf', 20);
	circle.x := G_SCR_W/2 ; circle.y := G_SCR_H/2 ; circle.radius := 50; circle.color := WHITE;
	ball.x := G_SCR_W/2;
	ball.y := G_SCR_H/2;
	ball.dirX := 1;
	ball.dirY := -1;
	ball.radius := 25;
	ball.speedX := 550/1000;
	ball.speedY := 470/1000;
	ball.color := White;

	bottomLeft.width := 20;
	bottomLeft.height := 20;
	bottomLeft.x := G_SCR_W-bottomLeft.width;
	bottomLeft.y := G_SCR_H-bottomLeft.height;
	bottomLeft.color := WHITE;
End;

Procedure Update(dt : Real);
Var
	mousexy : Vector2D;
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

	mousexy := GetMouseXY();
	If(ABS(circle.x-mousexy.x)*ABS(circle.x-mousexy.x) + ABS(circle.y-mousexy.y)*ABS(circle.y-mousexy.y) < circle.radius*circle.radius) Then
		bottomLeft.color := GREEN
	Else
		bottomLeft.color := WHITE;
End;

Procedure Draw(fps : Real);
Begin
	gDrawText('FPS : ' + FloatToStr((fps)), font,0,0,WHITE,G_UP_LEFT);
	If(not IsVisible) Then
	Begin
		gDrawText('I know you are not looking here !', font,0,G_SCR_H,WHITE,G_DOWN_LEFT);
	End;


	gDrawCircle(circle.x,circle.y,circle.radius,circle.color);
	gDrawCircle(ball.x,ball.y,ball.radius,ball.color);
	gFillRect(bottomLeft.x,bottomLeft.y,bottomLeft.width,bottomLeft.height,bottomLeft.color);

 	gDrawPoint(100,100,GREEN);
	gDrawTriangle(100,100,150,100,140,140,GREEN);
	gFillTriangle(200,200,350,200,200,350,Red);
	gDrawLine(500,500,600,500,YELLOW);
End;

Procedure MousePressed(left : Boolean; x,y : real ; release : Boolean);
Begin
	If(release) Then
	Begin
		inc(click);
		Writeln(click);
		circle.x := x;
		circle.y := y;
		If(left) Then
			circle.color := WHITE
		Else
			circle.color := RED;
	End
	Else
	Begin
		circle.x := x;
		circle.y := y;
		circle.color := GREEN
	End;
End;

Procedure KeyPressed(key : Word ; release : Boolean);
Begin
	If(release) Then
	Begin
		Write(chr(key));
		ball.color := WHITE;
	End
	Else
		ball.color := ORANGE;
End;

Begin
	StartApp(@load,@update,@draw,@mousepressed,@keypressed);
	Writeln;
End.
