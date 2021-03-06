function send_mms(number,carrier,subject,message,attachment)
% Function Adopted and manipulated from link below (MMS DOMAINS)
% https://www.mathworks.com/matlabcentral/fileexchange/16649-send-text-message-to-cell-phone

% SEND_TEXT_MESSAGE send text message to cell phone or other mobile device.
%    SEND_TEXT_MESSAGE(NUMBER,CARRIER,SUBJECT,MESSAGE) sends a text message
%    to mobile devices in USA. NUMBER is your 10-digit cell phone number.
%    CARRIER is your cell phone service provider, which can be one of the
%    following: 'AT&T', 'Boost', 'Cricket', 'Sprint', 'T-Mobile', 'Trafcone', 'Verizon', or 'Virgin'. 
%    SUBJECT is the subject of the message, and MESSAGE is the content of the message to send.
%
%    Example:
%      send_text_message('234-567-8910','Cingular', ...
%         'Calculation Done','Don't forget to retrieve your result file')
%      send_text_message('234-567-8910','Cingular', ...
%         'This is a text message without subject')
%
%    See also SENDMAIL.
% =========================================================================
% YOU NEED TO TYPE IN YOUR OWN EMAIL AND PASSWORDS: (Email Sender) => Burner
mail = 'wordleburner@gmail.com';    % Your GMail email address
password = 'rjyr7369';              % Your GMail password
% =========================================================================
if nargin == 3
    message = subject;
    subject = '';
end
% Format the phone number to 10 digit without dashes
number = strrep(number, '-', '');
if length(number) == 11 && number(1) == '1'
    number = number(2:11);
end
% Email to SMS Gateways
% Accepted Carriers
switch strrep(strrep(lower(carrier),'-',''),'&','')
    case 'att';       emailto = strcat(number,'@mms.att.net');             % 'AT&T'
    case 'boost';     emailto = strcat(number,'@myboostmobile.com');       % 'Boost'
    case 'cricket';   emailto = strcat(number,'@mms.cricketwireless.net'); % 'Cricket'
    case 'sprint';    emailto = strcat(number,'@pm.sprint.com');           % 'Sprint'
    case 'tmobile';   emailto = strcat(number,'@tmomail.net');             % 'T-Mobile'
    case 'trafcone';  emailto = strcat(number,'@mmst5.tracfone.com');      % 'Tracfone' 
    case 'verizon';   emailto = strcat(number,'@vzwpix.com');              % 'Verizon'
    case 'virgin';    emailto = strcat(number,'@vmpix.com');               % 'Virgin'
end
%% Set up Gmail SMTP service.
% Note: following code found from
% http://www.mathworks.com/support/solutions/data/1-3PRRDV.html
% If you have your own SMTP server, replace it with yours.
% Then this code will set up the preferences properly:
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
% The following four lines are necessary only if you are using GMail as
% your SMTP server. Delete these lines wif you are using your own SMTP
% server.
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
%% Send the email
sendmail(emailto,subject,message,attachment)
if strcmp(mail,'matlabsendtextmessage@gmail.com')
    disp('Please provide your own gmail for security reasons.')
    disp('You can do that by modifying the first two lines of the code')
    disp('after the bulky comments.')
end