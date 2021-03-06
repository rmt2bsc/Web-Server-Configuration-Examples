/**
 * This common SQl script is specifically design to generate a backup archive of any 
 * SQL Anywhere database. It is best used as the SQL source of a SQL Anywhere Event 
 * Schedule. The destination root path where the archive will be persisted is 
 * /rmt2/db_archives/.  The format of the generated DB backup archive is:
 *     <DB Name>-<yyyyMMdd>-<hhmmss>.1
 * 
 * For example, accounting-20200726-131322.1
 */

BEGIN 
	DECLARE @db_name VARCHAR(50);
    DECLARE @filename VARCHAR(50);
    DECLARE @filepath VARCHAR(50);
    DECLARE @dest VARCHAR(100);
    DECLARE @bkup_comment VARCHAR(50);

    SET @db_name = db_name(db_id());
    SET @filepath = '/rmt2/db_archives/';
    SET @filename = @db_name + '-' + CONVERT( VARCHAR, getdate(), 112 ) + '-' + REPLACE(CONVERT( VARCHAR, getdate(), 108 ), ':', '');
    SET @dest = @filepath + @filename;
    SET @bkup_comment = CONVERT( VARCHAR, today(*), 107 ) + ' backup';

    BACKUP DATABASE TO @dest
        ATTENDED OFF
        WITH COMMENT 'Full back up of Accounting db file and transaction log performed'
        HISTORY ON;
    
        /**
         * I have not gotten the SMTP functions to work gmail as of yet.
         */
    call xp_startsmtp(smtp_sender='royterrell2@gmail.com', smtp_server='smtp.gmail.com', smtp_port=587, smtp_sender_name='Database Admin', smtp_auth_username='rmt2bsc@gmail.com', smtp_auth_password='610hoover');
    call xp_sendmail(recipient='rmt2bsc@gmail.com', subject='DB Name', "message"='Test email sent from Sybase', content_type='text/html');
    call xp_stopsmtp();        
END