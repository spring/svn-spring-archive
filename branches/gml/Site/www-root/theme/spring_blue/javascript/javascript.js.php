function pageHeight() {return  window.innerHeight != null? window.innerHeight : document.documentElement && document.documentElement.clientHeight ?  document.documentElement.clientHeight : document.body != null? document.body.clientHeight : null;}
if(navigator.appName.indexOf("Microsoft")!= -1){var ms = true; if(window.XMLHttpRequest){var ie7 = true;}else{var ie6 = true;}}

function GivePixel()
{
	var x=document.createElement('img');
	x.id="pixel";
	x.src="theme/<?= $site_theme ?>/img/pixel.png";
	x.style.height=document.body.scrollHeight + "px";
	x.style.width=document.body.scrollWidth + "px";
	x.style.zIndex="10";
	x.style.position="absolute";
	x.style.top="0px";
	x.style.left="0px";
	document.body.appendChild(x);
}

function ResizePixel()
{
	x=document.getElementById('pixel');
	if(x)
	{
		x.style.height=document.body.scrollHeight + "px";
		x.style.width=document.body.scrollWidth + "px";
	}
}

function KillPixel()
{
	document.body.removeChild(document.getElementById('pixel'));
}

function FeatureVideo()
{
	document.getElementById('features_list').style.display = "none";

	var VideoID,VideoElement,VideoButtonBack,VideoButtonLarge,URL;

	if(this.nr == 0)
	{
		VideoID = "2438554672848287632";
	}
	if(this.nr == 1)
	{
		VideoID = "6403587752406480908";
	}
	if(this.nr == 2)
	{
		VideoID = "-9114508052317194322";
	}
	if(this.nr == 3)
	{
		VideoID = "-4890415872792714294";
	}
	if(this.nr == 4)
	{
		VideoID = "1298812193179674710";
	}
	if(this.nr == 5)
	{
		VideoID = "-2102711383712578417";
	}

	if(ms) /* IE can't handle objects correctly */
	{
		VideoElement=document.createElement('embed');
		var URL = "src";
	}
	else
	{
		VideoElement=document.createElement('object');
		var URL = "data";
	}
	VideoElement.style.width=document.getElementById('features_list').parentNode.offsetWidth + "px";
	VideoElement.style.height=document.getElementById('features_list').parentNode.offsetWidth * .75 + "px";
	VideoElement.id='VideoPlayback';
	VideoElement.type='application/x-shockwave-flash';
	VideoElement[URL]="http://video.google.com/googleplayer.swf?docId=" + VideoID + "&loop=false&playerMode=mini&autoPlay=true&hl=en";

	VideoButtonBack=document.createElement('input');
	VideoButtonBack.type="button";
	VideoButtonBack.id='VideoButtonBack';
	VideoButtonBack.style.width=document.getElementById('features_list').parentNode.offsetWidth / 2 + "px";
	VideoButtonBack.value="Back to feature list";
	VideoButtonBack.onclick=KillFeatureVideo;

	if(ms && ie6){/* IE6 and lower can't do 'video.style.position="fixed";' */} else {
	VideoButtonLarge=document.createElement('input');
	VideoButtonLarge.type="button";
	VideoButtonLarge.id='VideoButtonLarge';
	VideoButtonLarge.style.width=document.getElementById('features_list').parentNode.offsetWidth / 2 + "px";
	VideoButtonLarge.value="Enlarge this video";
	VideoButtonLarge.onclick=LargeFeatureVideo;}

	document.getElementById('features_list').parentNode.appendChild(VideoButtonBack);
	if(ms && ie6){/* IE6 and lower can't do 'video.style.position="fixed";' */} else {
	document.getElementById('features_list').parentNode.appendChild(VideoButtonLarge);}
	document.getElementById('features_list').parentNode.appendChild(VideoElement);
}

function LargeFeatureVideo()
{
	GivePixel();

	var x=document.getElementById('VideoPlayback');
	x.style.position="fixed";
	x.style.top="60px";
	x.style.left="60px";
	x.style.height=pageHeight() - 120 + "px";
	//x.style.width=pageHeight() / 3 * 4 - 120 + "px"; // For if you want ro preserve the 4:3 aspect ratio.
	x.style.width=document.body.scrollWidth - 120 + "px";

	var z=document.createElement('input');
	z.type="button";
	z.id="VideoButtonLargeBack";
	z.style.position="fixed";
	z.style.top="30px";
	z.style.right="60px";
	z.style.zIndex="20";
	z.style.width="350px";
	z.onclick=KillLargeFeatureVideo;
	if(ie7){z.value="Back to feature list"; /* IE7 can't seem to return from this normaly. */}else{
	z.value="Return video to normal size";}
	document.body.appendChild(z);
}

function KillLargeFeatureVideo()
{
	KillPixel();
	var VideoElement=document.getElementById('VideoPlayback');
	VideoElement.style.position="static";
	VideoElement.style.top=null;
	VideoElement.style.left=null;
	VideoElement.style.width=document.getElementById('features_list').parentNode.offsetWidth + "px";
	VideoElement.style.height=document.getElementById('features_list').parentNode.offsetWidth * .75 + "px";

	document.body.removeChild(document.getElementById('VideoButtonLargeBack'));

	if(ie7){KillFeatureVideo();} /* IE7 can't seem to return from this normaly. */
}

function KillFeatureVideo()
{
	document.getElementById('VideoPlayback').parentNode.removeChild(document.getElementById('VideoPlayback'));
	document.getElementById('VideoButtonBack').parentNode.removeChild(document.getElementById('VideoButtonBack'));
	if(ie6){/* IE6 and lower can't do 'video.style.position="fixed";' */}else{
	document.getElementById('VideoButtonLarge').parentNode.removeChild(document.getElementById('VideoButtonLarge'));}
	document.getElementById('features_list').style.display = "block";
}

function ShowScreenShot()
{
	GivePixel();

	var picture=document.createElement('img');
	var closehead=document.createElement('h3');
	var closetext=document.createTextNode('Click on the picture to close it.');

	x=document.getElementById('VideoPlayback');
	if(x)
	{
		document.getElementById('VideoPlayback').style.visibility = "hidden";
	}

	picture.id="picture";
	picture.src= this.href;
	picture.style.zIndex="20";
	picture.style.position="absolute";
	picture.style.top="35px";
	picture.style.left="50px";
	picture.style.height="525px";
	picture.style.width="700px";
	picture.onclick=KillScreenShot;

	closehead.id="closehead";
	closehead.style.zIndex="30";
	closehead.style.position="absolute";
	closehead.style.top="565px";
	closehead.style.left="250px";
	closehead.style.margin="0px";
	closehead.appendChild(closetext);

	document.getElementById('site').appendChild(picture);
	document.getElementById('site').appendChild(closehead);

	return false;
}

function KillScreenShot()
{
	KillPixel();
	document.getElementById('site').removeChild(document.getElementById('picture'));
	document.getElementById('site').removeChild(document.getElementById('closehead'));

	x=document.getElementById('VideoPlayback');
	if(x)
	{
		document.getElementById('VideoPlayback').style.visibility = "visible";
	}
}

function ScreenResize()
{
	// Feature Video Resize
	x=document.getElementById('VideoPlayback');
	if(x)
	{
		y=document.getElementById('VideoButtonBack');
		z=document.getElementById('VideoButtonLarge');
		if(document.getElementById('pixel')) // Large video mode
		{
			x.style.width=document.body.scrollWidth - 120 + "px";
			x.style.height=pageHeight() - 120 + "px";
			y.style.width=document.getElementById('features_list').parentNode.offsetWidth / 2 + "px";
		}
		else // Normal video mode
		{
			if(ms && ie6){x.style.display = "none";} //IE6 resize problem hack
			x.style.width=document.getElementById('features_list').parentNode.offsetWidth + "px";
			x.style.height=document.getElementById('features_list').parentNode.offsetWidth * .75 + "px";
			y.style.width=document.getElementById('features_list').parentNode.offsetWidth / 2 + "px";
			if(ms && ie6){/*Not lage mode for IE6*/}else{
			z.style.width=document.getElementById('features_list').parentNode.offsetWidth / 2 + "px";}
			if(ms && ie6){x.style.display = "block";} //IE6 resize problem hack
		}
	}

	// Screen Shot Resize
	ResizePixel();
}

/*
	// Cel Resize
	ResizeCel();
}
Above needs to go to ScreenResize()
Atempt to make the cels that are next to each other equal is size, running into scalling problems probebly need to do stuff with onbeforeresize and stuff.

function ResizeCel()
{
	if(document.getElementById('down_cel').offsetHeight < document.getElementById('high_cel').offsetHeight)
	{
		document.getElementById('down_cel').style.height = document.getElementById('high_cel').offsetHeight - 22 + "px";
	}
	else
	{
		document.getElementById('high_cel').style.height = document.getElementById('down_cel').offsetHeight - 22 + "px";
	}

nr1 = document.getElementById('feat_cel').offsetHeight;
nr2 = document.getElementById('info_cel').offsetHeight;
//alert(nr1);
//alert(nr2);
//alert(document.getElementById('info_cel').offsetHeight);

	if(nr1 < nr2)
	{
		document.getElementById('feat_cel').style.height = document.getElementById('info_cel').offsetHeight - 22 + "px";
	}
	else
	{
		document.getElementById('info_cel').style.height = document.getElementById('feat_cel').offsetHeight - 22 + "px";
	}

}

function CelResize(obj1, obj2)
{
	
}
*/

var nr_of_ss = 7;
var ssimgs=document.getElementById('scsh_cel').getElementsByTagName('img');
var were_at_ss = ssimgs.length;
var sslinks=document.getElementById('scsh_cel').getElementsByTagName('a');

function SsCycle(nr)
{
	if(nr==ssimgs.length) { nr = 0; }
	if(were_at_ss==nr_of_ss) { were_at_ss = 0; }
	ssimgs[nr].src="theme/<?= $site_theme ?>/img/screenshots/thumbnail_screen" + were_at_ss + ".jpg";
	sslinks[nr].href="theme/<?= $site_theme ?>/img/screenshots/screen" + were_at_ss + ".jpg";
	nr++;
	were_at_ss++;
	setTimeout('SsCycle(' + nr + ')', 5000);
}

if(document.getElementById && document.createTextNode)
{
	// JavaScrip is enabled, Pimp my page!

	//document.body.onresize=ScreenResize;

	// ScreenShot Timer
	setTimeout('SsCycle(0)', 10000);

	// Simple Flash Check
	var flashinstalled;
	if (navigator.mimeTypes && navigator.mimeTypes.length)
	{
		i = navigator.mimeTypes['application/x-shockwave-flash'];
		if (i && i.enabledPlugin){flashinstalled = true;}
	}
	else
	{
		function ieflash(){
			for(var i=12; i>6; i--)
			{
				try
				{
					var flash = new ActiveXObject("ShockwaveFlash.ShockwaveFlash." + i);
					flashinstalled = true;
					return;
				}
				catch(e){}
			}
		}
		ieflash();
	}

	// Feature video
	if (flashinstalled)
	{
/*		document.getElementById('features_title').backgroundImage='url(../img/video.gif)'; */
		var features,link,pic,text;
		features=document.getElementById('features_list').getElementsByTagName('div');
		for(i=0;i<features.length;i++)
		{
			pic=document.createElement('img');
			pic.src='theme/<?= $site_theme ?>/img/features.png';

			link=document.createElement('a');
			link.nr=i;
			link.onclick=FeatureVideo;
			link.appendChild(pic);
			link.appendChild(features[i].firstChild);
			features[i].appendChild(link)
		}
		text=document.getElementById('features_text');
		text.textContent='<?= $text[features_text_flash_enabled] ?>';
	}

	// Screenshots
	for(i=0;i<sslinks.length;i++)
	{
		sslinks[i].onclick=ShowScreenShot;
	}
}
