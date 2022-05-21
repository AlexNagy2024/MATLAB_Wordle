function screenshot
choice = questdlg('Would you like to save the results of your game?','Screenshot Results');
pause(2); % give time to close dialog box
if strcmp(choice,'Yes') % condition for screenshot and 
    % Take screen capture
    robot = java.awt.Robot(); % access java libraries
    pos = [0 0 2560 1500]; % [left top width height]; set screen size for image
    rect = java.awt.Rectangle(pos(1),pos(2),pos(3),pos(4)); % create rectangle
    cap = robot.createScreenCapture(rect); % java libraries screen capture w/ set size
    
    % Convert to RGB image type
    rgb = typecast(cap.getRGB(0,0,cap.getWidth,cap.getHeight,[],0,cap.getWidth),'uint8');
    imgData = zeros(cap.getHeight,cap.getWidth,3,'uint8');
    imgData(:,:,1) = reshape(rgb(3:4:end),cap.getWidth,[])';
    imgData(:,:,2) = reshape(rgb(2:4:end),cap.getWidth,[])';
    imgData(:,:,3) = reshape(rgb(1:4:end),cap.getWidth,[])';
    
    % Show or save to file
    % imshow(imgData); % show image of screenshot
    imwrite(imgData,'WordleResults.png') % store screenshot with respective filename
    
    % TEXT THROUGH EMAIL CODE
    % prompt user for email and send screenshot to user via email
    NumberPrompt = ['Please enter the phone number and the associated carrier/provider you would like the results to be sent to.',newline...
        '*PLEASE NOTE: Results can only be sent to a U.S. phone number.',newline,newline,'Phone Number'];
    ProviderPrompt = ['Accepted phone carriers/providers are as follows: ',newline,newline...
        'AT&T, Boost, Cricket, Sprint, T-Mobile, Trafcone, Verizon, or Virgin.',newline,...
        'Please enter carrier as written above.',newline,newline,'Phone Carrier'];
    dims = [1 110; 1 70]; dlgtitle = 'Phone Information';
    
    Input = inputdlg({NumberPrompt,ProviderPrompt},dlgtitle,dims); % input GUI
    
    % grabs properties necessary to send text; attaches screenshot file and sends to user input
    recipients = Input(1); 
    subject = 'Wordle Results'; message = 'Thanks for playing! Here are your results!';
    attachment = {'C:\Users\nagya\Desktop\MATLAB\ME260\Projects\Project 3\WordleResults.png'};
    carrier = cell2mat(Input(2)); 
    
    send_mms(recipients, carrier, subject, message, attachment);
else
    close all
end
