function keyboard_callback(Text, ~) % needs 2 inputs to work; placeholder
button_pressed = get(Text,'String');
assignin('base', 'key', button_pressed) 
end