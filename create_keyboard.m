% Create Keyboard For User Inputs
function [keyfig] = create_keyboard

% uieditfield; % Buttons
% https://www.mathworks.com/matlabcentral/answers/457040-looking-to-generate-an-array-grid-of-pushbuttons-in-a-figure

keyfig = figure('Position',[1200 250 400 350],'Name','Wordle Keyboard','NumberTitle','off','ToolBar','None','MenuBar','None');

buttonSize = 0.07; N = 4; M = 7; 
hGroup = uibuttongroup('Units','Normalized','Position',[0 0 1 1]);
% [left bottom width height]
xpos = 0.075; ypos = 0; height = 1;
for i = 1:N*M
    if mod(i,5) == 1 && i ~= 1
        xpos = xpos + buttonSize*2; % controls horizontal spacing
        height = 1; % controls height
    end
    ypos = (height+2)*buttonSize;
    if i == 27 % create an enter button of larger size
        hText(i) = uicontrol('Style','pushbutton','String',['ENTER'],...
            'Parent',hGroup,'Units','normalized','Position',[xpos ypos .2 .05],...
            'BackgroundColor','white','Callback',{@keyboard_callback});
    elseif i == 28 % create a delete button of larger size
        hText(i) = uicontrol('Style','pushbutton','String',['DELETE'],...
            'Parent',hGroup,'Units','normalized','Position',[xpos ypos .2 .05],...
            'BackgroundColor','white','Callback',{@keyboard_callback});
    else
        hText(i) = uicontrol('Style','pushbutton','String',[char(i+64)],...
            'Parent',hGroup,'Units','normalized','Position',[xpos ypos buttonSize buttonSize],...
            'BackgroundColor','white','Callback',{@keyboard_callback});
    end
    height = height + 2; % controls vertical spacing
end
end
