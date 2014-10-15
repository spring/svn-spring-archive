BODY
{
margin: 0px;
}

#header
{
height: 150px;
font-family: "trebuchet ms", "ae_Nice", "verdana", sans-serif;
margin: 0px;
color: #1C4069;
background-color: #303c4f; //#42413f; //EBEBEB;
}

#banner IMG
{
//background-image: url(../img/banner.png);
border: 0;
}

#banner_img_left
{
position: absolute;
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/banner/banner-left.jpg);
top: 0px;
left: 0px;
z-index: 5;
height: 120px;
width: 1280px;
}

#banner_img_right
{
position: absolute;
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/banner/banner-right.jpg);
top: 0px;
right: 0px;
z-index: 5;
height: 120px;
width: 400px;
}

#project_logo
{
position: absolute;
top: 0px;
left: 0px;
height: 120px;
width: 170px;
z-index: 6;
}

/*
#download_button
{
position: absolute;
top: 30px;
left: 190px;
z-index: 6;
}
*/

#project_text
{

}

#project_mission_cel
{
position: absolute;
top: 10px;
right: 50px;
z-index: 7;
font-size: 22px;
color: white;

}

#logo_text
{
position: absolute;
top: 84px;
left: 75px;
z-index: 7;
font-size: 22px;
color: red;
}

.project_name, #project_mission
{
margin: 8px;
text-align: center;
font-size: 20px;
font-weight: bold;
text-decoration: overline underline;
}

#mission_tekst
{
text-align: center;
font-size: 15px;
font-style: italic;
font-weight: bold;
}

#menu
{
position: absolute;
top: 120px;
height: 30px;
//background-image: url(../img/header-background.png);
background-repeat: repeat-x;
//z-index: 7;
}

#menu_left, #menu_right
{
width: 30px;
height: 30px;
float: left;
}

#menu_left
{
float: left;
}

#menu_right
{
float: right;
}

#menu A
{
color: #E0E0F0;
text-decoration: none;
}

#menu A DIV
{

}

.l_separator, .r_separator
{
width: 9px;
height: 30px;
float: left;
}

.l_separator
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/button-left.png);
}

.r_separator
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/button-right.png);
}

#language, #theme
{
position: absolute;
width: 115px;
color: #FFF;
background-color: #334;
z-index: 1;

filter:alpha(opacity=80);
-moz-opacity:.80;
opacity:.80;
}

#language
{
right: 150px;
}

#theme
{
right: 30px;
}

#news_text, #wiki_text, #messageboard_text, #about_text, #development_text, #language_text, #theme_text
{
float: left;
padding: 3px 5px;
height: 24px;
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/button-back.png);
text-align: center;
}

#development_text
{
color: #d3a35c;
}

#language_text, #theme_text
{
width: 87px;
}
