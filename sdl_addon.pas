unit sdl_addon;

interface
    uses sdl, sdl_ttf, gl, glu;


    (*
        sdl_update;
        * Update SDL events
    *)
    
    function sdl_update : integer;
    
    
    (*
        sdl_do_quit;
        * Check if the user clicks on the cross to close the window
    *)
    
    function sdl_do_quit : boolean;
    
    
    (*
        sdl_get_mouse_x; sdl_get_mouse_y;
        * Get the X or Y cooridinate of the mouse
    *)
    
    function sdl_get_mouse_x : Uint16;
    function sdl_get_mouse_y : Uint16;
    
    (*
        sdl_mouse_left_click; sdl_mouse_right_click;
        * Check if the user left clicks, or right clicks
    *)
    
    function sdl_mouse_left_click : boolean;
    function sdl_mouse_right_click : boolean;
    function sdl_mouse_left_click_released : boolean;
    function sdl_mouse_right_click_released : boolean;
    
    
    (*
        sdl_get_keypressed
        * If a key is pressed, return its value
        * See the keys list : 
            http://www.siteduzero.com/uploads/fr/ftp/mateo21/sdlkeysym.html
    *)
    
    function sdl_get_keypressed : integer;
    function sdl_get_keyreleased : integer;

implementation

var
    _event : TSDL_Event;

function sdl_update : integer;
begin
    exit(SDL_PollEvent(@_event));
end;

function sdl_do_quit : boolean;
begin
    exit(_event.type_ = SDL_QUITEV);
end;


function sdl_get_mouse_x : Uint16;
begin
    exit(_event.motion.x);
end;

function sdl_get_mouse_y : Uint16;
begin
    exit(_event.motion.y);
end;

function sdl_mouse_left_click : boolean;
begin
    exit((_event.type_ = SDL_MOUSEBUTTONDOWN) 
    and  (_event.button.button = SDL_BUTTON_LEFT));
end;

function sdl_mouse_left_click_released : boolean;
begin
    exit((_event.type_ = SDL_MOUSEBUTTONUP) 
    and  (_event.button.button = SDL_BUTTON_LEFT));
end;

function sdl_mouse_right_click : boolean;
begin
    exit((_event.type_ = SDL_MOUSEBUTTONDOWN) 
    and  (_event.button.button = SDL_BUTTON_RIGHT));
end;

function sdl_mouse_right_click_released : boolean;
begin
    exit((_event.type_ = SDL_MOUSEBUTTONUP) 
    and  (_event.button.button = SDL_BUTTON_RIGHT));
end;

function sdl_get_keypressed : integer;
begin
    if (_event.type_ <> SDL_KEYDOWN) then
        exit(-1);
    
    exit(_event.key.keysym.sym);
end;

function sdl_get_keyreleased : integer;
begin
    if (_event.type_ <> SDL_KEYUP) then
        exit(-1);
    
    exit(_event.key.keysym.sym);
end;

end.

(* EOF *)
