clear all, close all

% Load Image as Stensile
I = imread('Wordle.png'); ifig = imshow(I); wordle_fig = gcf;
set(gcf,'Name','Wordle','NumberTitle','off','WindowState','Maximized','color',[17 17 17]/250,...
    'ToolBar','None','MenuBar','None'); hold on;

words = upper(importdata('wordle_words.txt')); rng('Shuffle'); % import wordle words; shuffle seed
word = char(words(randi(numel(words)))); % correct type and upper case

% Plot Rectangles
for gg = 1:6 % loop for creating squares vertically => each guess
    for LL = 1:5 % loop for creating squares horizontally
        rects(LL,gg) = rectangle('position',[422+(100*LL) 200+(101*gg) 91 91],'edgecolor','white','linewidth',2);
        % indexing from top left square plus the width/height summed w/ space between squares
    end
end

ModePrompt = ['If you would like to play Wordle in grader mode, please enter ''grader mode''',newline...
    'If you would like to play Wordle in standard mode, please enter ''standard mode''',newline];
mode_dims = [1 80]; mode_title = 'Mode Selector'; % window properties
ModeInput = cell2mat(inputdlg(ModePrompt,mode_title,mode_dims)); % prompt for mode selection

if strcmp(ModeInput,'grader mode')  % condition for grader mode: word will sit above keyboard at all times
    WordPrompt = 'Please enter a word to be the answer.'; word_dims = [1 60];
    word_title = 'Word Selection'; word = upper(cell2mat(inputdlg(WordPrompt,word_title,word_dims)));
    if isempty(word) == 1
        word = char(words(randi(numel(words))));
    end
    
    ans_fig = figure('Position',[1200 700 400 60],'Name','Wordle Answer','NumberTitle','off',...
        'ToolBar','None','MenuBar','None'); ans_array = ['Wordle Word: ' word];
    ans_txt = text(0,0.3,ans_array,'color','white'); ans_txt.FontName = 'Helvetica';
    ans_txt.FontSize = 20; ans_txt.FontWeight = 'bold'; ans_txt.Color = 'Black'; axis off; hold on;
else
end

% https://www.mathworks.com/matlabcentral/answers/457040-looking-to-generate-an-array-grid-of-pushbuttons-in-a-figure
% Create Keyboard For User Inputs
keyfig = create_keyboard; % call create keyboard function

wait = 1; guess = ''; key = ''; p = 1; log_array = []; correct = 0; g = 0; % predefine variables for guesses
while correct == 0 && g < 6
    g = g + 1; p = 1; guess = '';
    while p < 7 && correct == 0 % while # presses is less than 7 (5 letters + enter/delete)
        p = p + 1; % presses grow per click
        while wait ~= 0 % loop that allows buttons to continuously be pressed
            wait = waitforbuttonpress; % wait for button to be pressed logic
            pause(0.5) % give callback function time necessary to store variable
        end
        guess = [guess key]; % combine entered buttons to formulate the guess
        wait = 1; % overwrite wait so that while loop contains
        
        % condition for any letter being pressed while guess is at most 5 letters
        if contains(guess,'ENTER') == 0 && contains(guess,'DELETE') == 0 && length(guess) < 6
            figure(wordle_fig) % pull wordle figure to current figure for plot - not keyboard
            if strcmp(ModeInput,'grader mode')
                figure(wordle_fig)
                letter(g,p-1) = text(368+100*p,244+101*g,guess(p-1)); letter(g,p-1).Color = 'White'; letter(g,p-1).FontSize = 42;
                letter(g,p-1).HorizontalAlignment = 'center'; letter(g,p-1).FontName = 'Helvetica';
                figure(ans_fig)
                figure(keyfig) % pull keyboard figure back to current figure
            else
                letter(g,p-1) = text(368+100*p,244+101*g,guess(p-1)); letter(g,p-1).Color = 'White'; letter(g,p-1).FontSize = 42;
                letter(g,p-1).HorizontalAlignment = 'center'; letter(g,p-1).FontName = 'Helvetica';
                figure(keyfig) % pull keyboard figure back to current figure
            end
            
        elseif length(guess) == 6 && contains(guess,'ENTER') == 0 && contains(guess,'DELETE') == 0 % condition for 6 letters entered
            p = p - 1; guess = guess(1:5); % press is ignored; guess is first 5 letters
            TML_txt = 'Too many letters.';
            TML_fig = figure('Name','Invalid Input Window','NumberTitle','off','ToolBar','None',...
                'ToolBar','None','MenuBar','None'); axis off; % [left bottom width height]
            IIW_txt = text(-0.075,0.3,TML_txt,'color','white'); IIW_txt.FontName = 'Helvetica';
            IIW_txt.FontSize = 20; IIW_txt.FontWeight = 'bold'; IIW_txt.Color = 'Black';
            set(gcf,'Position',[685 800 300 60],'color','White'); pause(1); close(TML_fig);
        end
        
        if length(guess) == 6 && contains(guess,'DELETE') == 1 % condition for guess pressed w/out letters
            p = 1; % press ignored
            guess = ''; % removes 'DELETE' from guess
            
        elseif contains(guess,'DELETE') == 1 % condition for delete key pressed
            letter(g,p-2).String = ''; % erase last plotted element
            guess = guess(1:end-7); % latest element of guess is erased
            p = p - 2; % number of presses is adjusted to match number of clicks remaining
        end
        
        if contains(guess,'ENTER') == 1 && length(guess) < 10 % condition for enter pressed early
            p = p - 1; % press ignored
            guess = guess(1:end-5); % guess erases 'ENTER' from guess
            NEL_txt = 'Not engough letters.';
            IIW_fig = figure('Name','Invalid Input Window','NumberTitle','off','ToolBar','None',...
                'ToolBar','None','MenuBar','None'); axis off; % [left bottom width height]
            IIW_txt = text(-0.075,0.3,NEL_txt,'color','white'); IIW_txt.FontName = 'Helvetica';
            IIW_txt.FontSize = 20; IIW_txt.FontWeight = 'bold'; IIW_txt.Color = 'Black';
            set(gcf,'Position',[685 800 300 60],'color','White'); pause(1); close(IIW_fig);
            
        elseif contains(guess(6:end),'ENTER') == 1 && contains(guess(1:5),words) == 0 % condition for guess not in word list
            p = p - 1; guess = guess(1:5); % press is ignored; guess is first 5 letters
            IWE_txt = 'Not in word list.';
            IWE_fig = figure('Name','Invalid Input Window','NumberTitle','off','ToolBar','None',...
                'ToolBar','None','MenuBar','None'); axis off; % [left bottom width height]
            IIW_txt = text(0.05,0.3,IWE_txt,'color','white'); IIW_txt.FontName = 'Helvetica';
            IIW_txt.FontSize = 20; IIW_txt.FontWeight = 'bold'; IIW_txt.Color = 'Black';
            set(gcf,'Position',[685 800 300 60],'color','White'); pause(1); close(IWE_fig);
            
        elseif contains(guess(6:end),'ENTER') == 1 % when enter is pressed as last element with 5 letters
            for L = 1:5 % hexidecimal link: https://g.co/kgs/6eEbAj
                contains_logic = contains(word,guess(L));
                log_array = [log_array contains_logic];
                
                if guess(L) == word(L) % letters and indicies agree
                    rects(L,g).FaceColor = '#50944b'; % Color => Green
                elseif log_array(L) > 0 % if letter exists in guess
                    rects(L,g).FaceColor = '#a89438'; % Color => Yellow
                else % if letters are not a part of guess
                    rects(L,g).FaceColor = '#404040'; % Color => Gray
                end
            end
            log_array = []; final_txt = '';
            guess = guess(1:5); % enter key is not incorporated in the guess
            correct = strcmp(guess,word); % check if guess and word are the same
            if g == 6 && correct == 0
                g = g + 1;
            end
        end
    end
end

if g == 1 % condition for text displayed when win on 1 guess
    final_txt = 'Genius';
elseif g == 2 % condition for text displayed when win on 2 guesses
    final_txt = 'Magnificent';
elseif g == 3 % condition for text displayed when win on 3 guesses
    final_txt = 'Impressive';
elseif g == 4 % condition for text displayed when win on 4 guesses
    final_txt = 'Splendid';
elseif g == 5 % condition for text displayed when win on 5 guesses
    final_txt = 'Great';
elseif g == 6 % condition for text displayed when win on 6 guesses
    final_txt = 'Phew';
elseif g == 7 % condition for word displayed after loss
    final_txt = word;
end

win_fig = figure('NumberTitle','off','ToolBar','None','ToolBar','None','MenuBar','None'); axis off;
win_txt = text(0.265,0.6,final_txt,'color','white'); win_txt.FontName = 'Helvetica';
win_txt.FontSize = 20; win_txt.FontWeight = 'bold'; win_txt.Color = 'Black';
set(gcf,'Position',[685 800 300 60],'color','White'); pause(2); close(win_fig);

end_fig = figure('NumberTitle','off','ToolBar','None','ToolBar','None','MenuBar','None',...
    'Position',[30 400 530 180],'color','white'); axis off; % [left bottom width height]
xlim([0 0.5]); ylim([0 1.25]);
if g == 1
    conclude_txt = ['Congratulations! You solved the ',newline,'     Wordle in ',num2str(g),' round '...
        'and the ',newline,'      correct word was ',word,'.',newline,'        Thank you for playing!'];
elseif g > 1 && g < 7
    conclude_txt = ['Congratulations! You solved the ',newline,'     Wordle in ',num2str(g),' rounds '...
        'and the ',newline,'      correct word was ',word,'.',newline,'        Thank you for playing!'];
else
    conclude_txt = ['  Not this time! Play again soon and ',newline,'see if you can solve the next Wordle!'];
end
end_txt = text(-0.05,0.75,conclude_txt,'color','white'); end_txt.FontName = 'Helvetica';
end_txt.FontSize = 20; end_txt.FontWeight = 'bold'; end_txt.Color = 'Black';
end_txt.HorizontalAlignment = 'left'; end_txt.VerticalAlignment = 'middle'; pause(2)

% call screenshot function to take screenshot and text file to users inputted phone number
screenshot
close all