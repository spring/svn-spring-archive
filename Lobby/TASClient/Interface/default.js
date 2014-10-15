function sendData(str)
{
	document.location.href="lobby:"+str;
}
function saveParam(str)
{
	sendData("saveParam:"+str);
}
function saveParamByIndex(str)
{
	sendData("saveParamByIndex:"+str);
}
function saveSettings(str)
{
	sendData("saveSettings:"+str);
}

function getSelectedValue(selectId){
	return document.getElementById(selectId).options[document.getElementById(selectId).selectedIndex].value;
}

function getPixelValue(str)
{
	return str.substr(0,str.length-2)*1;
}

function getPercentValue(str)
{
	return str.substr(0,str.length-1)*1;
}

function selectOption(selectId,val){
	x = document.getElementById(selectId);
	if(x != null)
	{
		x.selectedIndex = 0;
		for(k=0;k<x.options.length;k++)
		{
			if(x.options[k].value == val)
			{
				x.selectedIndex = k;
				return;
			}
		}
	}
}