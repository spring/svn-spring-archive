html
{
min-height: 100%;
margin-bottom: 0.01em;
}

BUTTON, INPUT, SELECT
{
color: #1C4069;
font-family: "trebuchet ms", "ae_Nice", "verdana", sans-serif;
font-size: 90%;
font-weight: bold;
background-color: #EEE;
border: 2px solid;
border-top-color: #9999CC;
border-left-color: #9999CC;
border-right-color: #666699;
border-bottom-color: #666699;
}

BODY
{
background-color: #c8d2da;
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/verloop.png);
background-position: 0px 150px;
background-repeat: repeat-x;
}

#site
{
font-size: 15px;
font-family: "trebuchet ms", "ae_Nice", "verdana", sans-serif;
padding: 0px 60px;
color: #002050;
}

.container
{
padding: 0px 30px 0px 30px;
}

#cont1
{
padding:10px 216px 0px 30px;
}

.edge
{
padding: 1px;
}

.back
{
padding: 10px 10px 0px 10px;
}

.row
{
border: 1px solid #777;
border-bottom-color: #A8B2BA;
border-right-color: #A8B2BA;
background-color: #B4BEC6;
background-repeat: no-repeat;
margin: 0px 0px 10px 0px;
padding: 15px;
}

.col
{
width: 50%;
float: left;
}

.cel
{
margin: 0px 0px 10px 0px;
}

.l_cel
{
margin: 0px 5px 10px 0px;
}

.r_cel
{
margin: 0px 0px 10px 5px;
}

.cel A:link, .l_cel A:link, .r_cel A:link
{
text-decoration: underline;
color: #000080;
}

.cel A:visited, .l_cel A:visited, .r_cel A:visited
{
text-decoration: underline;
color: #000080;
}

.cel A:active, .l_cel A:active, .r_cel A:active
{
text-decoration: none;
color: #000080;
}

.cel A:hover, .l_cel A:hover, .r_cel A:hover
{
text-decoration: underline;
color: #0000FF;
}

#feat_cel A:hover
{
text-decoration: none;
color: #0000DD;
}

#download_title, #highlight_title
{
font-size: 22px;
font-weight: bold;
border-bottom: 2px groove #1C4069;
margin-bottom: 15px;
padding-left: 28px;
background-repeat: no-repeat;
}

#highlight_in_english, #com_news_in_english, #pro_news_in_english
{
font-size: 12px;
}

#download_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/download.png);
}

#highlight_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/highlight.png);
}

#introduction_title, #com_news_title, #pro_news_title, #participate_title, #translation_title, #string_table_title
{
font-size: 18px;
font-weight: bold;
border-bottom: 1px groove #1C4069;
margin-bottom: 15px;
padding-left: 30px;
padding-top: 5px;
background-repeat: no-repeat;
}

#introduction_title, #translation_title, #string_table_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/text.png);
}

#com_news_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/community-news.png);
}

#pro_news_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/project-news.png);
}

#participate_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/participate.png);
}

#features_title, #info_title, #content_title, #code_title
{
font-size: 16px;
font-weight: bold;
padding-left: 30px;
padding-top: 7px;
background-repeat: no-repeat;
}

#features_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/text.png);
}

#features_text
{
font-size: larger;
font-style: italic;
}

#info_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/info.png);
}

#content_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/content.png);
}

#code_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/code.png);
}

#download_text, #highlight_text
{
font-size: larger;
margin: 5px;
}

.clear
{
clear: both;
}

.screenshot
{
border: 1px solid black;
margin: 3px 0px;
}

#row1
{
background-color: #D8E2EA;
}

#row3
{
background-color: #E8F2FA;
}


/*
#down_cel, #high_cel
{
background-color: #D8E2EA;
}

#feat_cel
{
background-color: #E8F2FA;
}
*/

#scsh_col
{
position: absolute;
right: 90px;
top: 160px;
width: 194px;
}

#scsh_cel
{
border: 1px solid #777;
border-bottom-color: #A8B2BA;
border-right-color: #A8B2BA;
background-color: #B4BEC6;
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/hoek.png);
background-repeat: no-repeat;
margin: 0px 0px 10px 0px;
padding: 10px;
}

#more_cel
{
border: 1px solid #777;
border-bottom-color: #A8B2BA;
border-right-color: #A8B2BA;
background-color: #B4BEC6;
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/hoek.png);
background-repeat: no-repeat;
margin: 0px 0px 10px 0px;
padding: 10px;
text-align: center
}

#features_list IMG
{
position: relative;
top: 4px;
}

#features_list A
{
cursor: pointer;
}

.feature_item
{

}

#pixel
{
filter:alpha(opacity=50);
-moz-opacity:0.5;
opacity:.50;
}

#picture
{
filter:alpha(opacity=90);
-moz-opacity:.9;
opacity:.90;
}

/*
html
{
min-height: 100%;
margin-bottom: 0.01em;
}

BUTTON, INPUT, SELECT
{
color: #1C4069;
font-family: "trebuchet ms", "ae_Nice", "verdana", sans-serif;
font-size: 90%;
font-weight: bold;
background-color: #EEE;
border: 2px solid;
border-top-color: #9999CC;
border-left-color: #9999CC;
border-right-color: #666699;
border-bottom-color: #666699;
}

BODY
{
background-color: #c8d2da;
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/verloop.png);
background-position: 0px 150px;
background-repeat: repeat-x;
}

#site
{
font-size: 15px;
font-family: "trebuchet ms", "ae_Nice", "verdana", sans-serif;
padding: 0px 60px;
color: #002050;
}

.container
{
padding: 0px 30px 0px 30px;
}

#cont1
{
padding:10px 216px 0px 30px;
}

.edge
{
padding: 1px;
}

.back
{
padding: 10px 10px 0px 10px;
}

.row
{
border: 1px solid #777;
border-bottom-color: #A8B2BA;
border-right-color: #A8B2BA;
background-color: #B4BEC6;
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/hoek.png);
background-repeat: no-repeat;
margin: 0px 0px 10px 0px;
padding: 15px;
}

.col
{
width: 50%;
float: left;
}

.cel
{
margin: 0px 0px 10px 0px;

}

.l_cel
{
margin: 0px 5px 10px 0px;
}

.r_cel
{
margin: 0px 0px 10px 5px;
}

.cel A:link, .l_cel A:link, .r_cel A:link
{
text-decoration: underline;
color: #000080;
}

.cel A:visited, .l_cel A:visited, .r_cel A:visited
{
text-decoration: underline;
color: #000080;
}

.cel A:active, .l_cel A:active, .r_cel A:active
{
text-decoration: none;
color: #000080;
}

.cel A:hover, .l_cel A:hover, .r_cel A:hover
{
text-decoration: underline;
color: #0000FF;
}

#feat_cel A:hover
{
text-decoration: none;
color: #0000DD;
}

#download_title, #highlight_title
{
font-size: 22px;
font-weight: bold;
border-bottom: 2px groove #1C4069;
margin-bottom: 15px;
padding-left: 28px;
background-repeat: no-repeat;
}

#highlight_in_english, #com_news_in_english, #pro_news_in_english
{
font-size: 12px;
}

#download_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/download.png);
}

#highlight_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/highlight.png);
}

#introduction_title, #com_news_title, #pro_news_title, #participate_title
{
font-size: 18px;
font-weight: bold;
border-bottom: 1px groove #1C4069;
margin-bottom: 15px;
padding-left: 30px;
padding-top: 5px;
background-repeat: no-repeat;
}

#introduction_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/text.png);
}

#com_news_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/community-news.png);
}

#pro_news_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/project-news.png);
}

#participate_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/participate.png);
}

#features_title, #info_title, #content_title, #code_title
{
font-size: 16px;
font-weight: bold;
padding-left: 30px;
padding-top: 7px;
background-repeat: no-repeat;
}

#features_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/text.png);
}

#features_text
{
font-size: larger;
font-style: italic;
}

#info_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/info.png);
}

#content_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/content.png);
}

#code_title
{
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/code.png);
}

#download_text, #highlight_text
{
font-size: larger;
margin: 5px;
}

.clear
{
clear: both;
}

.screenshot
{
border: 1px solid black;
margin: 3px 0px;
}

#row1
{
background-color: #D8E2EA;
}

#row3
{
background-color: #E8F2FA;
}


/*
#down_cel, #high_cel
{
background-color: #D8E2EA;
}

#feat_cel
{
background-color: #E8F2FA;
}
*/

#scsh_col
{
position: absolute;
right: 90px;
top: 160px;
width: 194px;
}

#scsh_cel
{
border: 1px solid #777;
border-bottom-color: #A8B2BA;
border-right-color: #A8B2BA;
background-color: #B4BEC6;
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/hoek.png);
background-repeat: no-repeat;
margin: 0px 0px 10px 0px;
padding: 10px;
}

#more_cel
{
border: 1px solid #777;
border-bottom-color: #A8B2BA;
border-right-color: #A8B2BA;
background-color: #B4BEC6;
background-image: url(<?= $cd ?>theme/<?= $site_theme ?>/img/hoek.png);
background-repeat: no-repeat;
margin: 0px 0px 10px 0px;
padding: 10px;
text-align: center
}

#features_list IMG
{
position: relative;
top: 4px;
}

#features_list A
{
cursor: pointer;
}

.feature_item
{

}

#pixel
{
filter:alpha(opacity=50);
-moz-opacity:0.5;
opacity:.50;
}

#picture
{
filter:alpha(opacity=90);
-moz-opacity:.9;
opacity:.90;
}

*/
