net user iphone /delete
net user /add iphone 12345 /expires:never /domain
WMIC USERACCOUNT WHERE "Name='iphone'" SET PasswordExpires=FALSE
