function [ ] = sentTheEmail( yourMail, password, toMail, host, port)
%sentTheEmail sent a email to a address
%   mail: your email address 'XXXX@uw.edu'
%   password: your password 'XXXXXX'
%   toMail, to this mail 'XXXX@gmail.com'
%   host: SMTP host server    'smtp.uw.edu'
%   port: SMTP port   '993'

%uw emial default set
if (~exist('host', 'var'))
    host = 'smtp.uw.edu';
end
if (~exist('port', 'var'))
    port = '993';
end
    
setpref('Internet','SMTP_Server', host);
setpref('Internet','E_mail',yourMail);
setpref('Internet','SMTP_Username',yourMail);
setpref('Internet','SMTP_Password',password);

props = java.lang.System.getProperties;
props.setProperty( 'mail.smtp.starttls.enable', 'true');
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port',port);
% Send the email

sendmail(toMail,'MATLAB Progrem Status','Hello! Your program has been completed!');


end

