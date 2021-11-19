CREATE OR REPLACE FUNCTION my_schema.send_email(
    receiver_name text,
    receiver text,
    subject text,
    send_message text)
  RETURNS integer AS
$BODY$

# -*- coding: utf-8 -*-
import smtplib
import email.utils
from email.mime.text import MIMEText     

# Create the message

msg =  MIMEText(send_message.encode('utf-8'), 'plain', 'utf-8') 
msg['To'] = email.utils.formataddr((receiver_name, receiver))
msg['From'] = email.utils.formataddr(('Kaido Kariste', 'kaido@mail.something'))
msg['Subject'] = subject

server = smtplib.SMTP('<smtp-ip>:<port>')
server.set_debuglevel(True) # show communication with the server
try:
            server.sendmail('kaido@mail.something', [receiver], msg.as_string())
finally:
            server.quit()

return 1

$BODY$
  LANGUAGE plpython3u VOLATILE
  COST 100;

COMMENT ON FUNCTION my_schema.send_email(text, text, text, text) IS 'Sends out email. Input parameters: 1. to_name, 2. to_email_adr 3. subjekt 4 body';

/*
select my_schema.send_email('Kaido Kariste','kaido@github.com','Testime saatmist','Tere');
*/