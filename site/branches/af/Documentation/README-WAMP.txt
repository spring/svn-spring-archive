How to get a development copy of this site running using WAMP
=============================================================

1) Install WAMP server [0] (Apache + MySQL + PHP on Windows) and start
   it.  This should give you a nice speed-o-meter like taskbar icon
   showing whether the services are running (white) or not (red/yellow).

2) Test your WAMP install by pointing your browser at http://localhost/
   You should see a WampServer test page.

3) Make a checkout of the site, if you have not already done so.
   The Spring site's subversion repository is located at:

	https://spring.clan-sy.com/svn/spring/site/trunk/

   You can use TortoiseSVN [1] for this.  Install it, right click on a
   folder in the windows explorer and choose "SVN Checkout".  Copy paste
   the above URL to the "URL of repository" field and enter the path to
   a new/empty directory (where you want to store the development copy
   of the site) in the checkout directory field.  Then press OK to start
   the checkout.

4) Click on the WAMP server icon -> Apache -> httpd.conf

5) Search for "DocumentRoot" and modify the path to point to the
   checkout directory from step 3:

	DocumentRoot "C:\dev\spring-site\www-root"

6) Search for "<Directory", pick the one with a path just behind it and
   modify this path too:

	<Directory "C:\dev\spring-site\www-root">

7) Click on the WAMP server icon -> Restart all services.

8) Point your browser at http://localhost/ again.
   You should now see the Spring wiki startpage.

[0] http://www.en.wampserver.com/
[1] http://tortoisesvn.tigris.org/
