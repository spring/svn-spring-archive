/*CRIOSSpinEdit 0.8 - advanced javascript SpinEdit visual control
Copyright (c) 2005-2008 Lucian SABO (luciansabo@gmail.com);
http://luci.criosweb.ro

Licensed under CreativeCommons LGPL http://creativecommons.org/licenses/LGPL/2.1/
For commercial use please contact me.
=================================
*/

function CriosSpinEdit(EditId)
{
//properties
this.EditId=EditId;//deprecated
this.ObjectRef=[];
this.ObjectId=[];
this.ObjectId['Edit']=EditId;
this.ObjectId['UpArrow']="up"+EditId;
this.ObjectId['DownArrow']="down"+EditId;
this.DefaultValue=0;
this.MinValue=0;
this.MaxValue=10;
this.Step=1;
this.Size=2; //no effect after WriteControl
this.BackgroundColor='white';
this.Style='vert'; //no effect after WriteControl
this.ReadOnly=false; //read-only property


//public methods
CriosSpinEdit.prototype.up=up;
CriosSpinEdit.prototype.down=down;
CriosSpinEdit.prototype.WriteControl=WriteControl;
CriosSpinEdit.prototype.GetValue=GetValue;
CriosSpinEdit.prototype.SetValue=SetValue;
CriosSpinEdit.prototype.Validate=Validate;
CriosSpinEdit.prototype.Disable=Disable;
CriosSpinEdit.prototype.Enable=Enable;
CriosSpinEdit.prototype.ResetValue=ResetValue;


//internal event handlers; there is not need to call them directly
CriosSpinEdit.prototype.HandleChange=HandleChange;

//private function members
var FixJSFloatBug=function FixJSFloatBug(n){return Math.round(n*100)/100;}

//events
CriosSpinEdit.prototype.OnChange=function OnChange(){};
CriosSpinEdit.prototype.OnValidateError=function OnValidateError(){};

//-----------------------------------------------------------------
function Validate(theValue)
{
if(theValue==='' || theValue==null || theValue>this.MaxValue || theValue<this.MinValue || isFinite(theValue)==0 || /*theValue%this.Step!=0*/ String(FixJSFloatBug(theValue/this.Step)).indexOf('.')!=-1) {this.OnValidateError();return false;}
else {
	//prevent bug when user enters '07' for example in the edit field
	this.ObjectRef['Edit'].value=FixJSFloatBug(theValue*1); //little trick to convert to numeric and prevent JS Floating point operation bugs
	return true;
	}
}
//-----------------------------------------------------------------
	function up()
	{
	if(this.n<this.MaxValue && !this.ObjectRef['Edit'].disabled)
		{
		this.n=FixJSFloatBug(this.n+this.Step);
		this.ObjectRef['Edit'].value=this.n;
		this.OnChange();
		}
	}
//-----------------------------------------------------------------	
	function down()
	{
	if(this.n>this.MinValue && !this.ObjectRef['Edit'].disabled)
		{
		this.n=FixJSFloatBug(this.n-this.Step);
		this.ObjectRef['Edit'].value=this.n;
		//trigger OnChange event
		this.OnChange();
		}
	}
//-----------------------------------------------------------------
	function WriteControl(SpinName)
	{
	this.n=this.DefaultValue;
	var readonly_str='';
	if(this.ReadOnly)	readonly_str='readonly="readonly"';
	document.write('<table border="0" summary="" cellspacing="0" cellpadding="0" style="display:inline;vertical-align:middle">');
	document.write('<tr>');
if(this.Style=="vert")
{
		document.write('<td style="width:10px;height:24px;" rowspan="2"><input size="'+this.Size+'" id="'+this.ObjectId['Edit']+'" name="'+this.ObjectId['Edit']+'" type="text" value="'+this.DefaultValue+'" onchange="'+SpinName+'.HandleChange()" '+readonly_str+' /></td>');
		document.write('<td><input type="button" style="font-size:8px;color:black;width:16px;height:14px;vertical-align:bottom;padding:0px;" id="'+this.ObjectId['UpArrow']+'" value="&#9650;" onclick="this.blur();'+SpinName+'.up()" /></td>');
	document.write('</tr>');
	document.write('<tr>');
		document.write('<td><input type="button" style="font-size:8px;color:black;width:16px;height:14px;vertical-align:top;padding:0px;" id="'+this.ObjectId['DownArrow']+'" value="&#9660;" onclick="this.blur();'+SpinName+'.down()" /></td>');
}
else	//horizontal
{
		document.write('<td style="width:10px;height:24px;" rowspan="2"><input size="'+this.Size+'" id="'+this.ObjectId['Edit']+'" name="'+this.ObjectId['Edit']+'" type="text" value="'+this.DefaultValue+'"  onchange="'+SpinName+'.HandleChange()" '+readonly_str+' /></td>');
		document.write('<td><input type="button" style="font-size:11px;color:black;width:18px;height:24px;padding:0px;" id="'+this.ObjectId['UpArrow']+'" value="&#9650;" onclick="this.blur();'+SpinName+'.up()" /></td>');
		document.write('<td><input type="button" style="font-size:11px;color:black;width:18px;height:24px;padding:0px;" id="'+this.ObjectId['DownArrow']+'" value="&#9660;" onclick="this.blur();'+SpinName+'.down()" /></td>');
}
	document.write('</tr>');
	document.write('</table>');

//store objects references for faster access 
this.ObjectRef['Edit']=document.getElementById(this.ObjectId['Edit']);
this.ObjectRef['UpArrow']=document.getElementById(this.ObjectId['UpArrow']);
this.ObjectRef['DownArrow']=document.getElementById(this.ObjectId['DownArrow']);	
	}
	
//-----------------------------------------------------------------
	//GetValue
	function GetValue()
	{
	return this.n;
	}
//-----------------------------------------------------------------
	//SetValue
	function SetValue(newValue)
	{
	//validation
	if(!this.Validate(newValue) || this.ObjectRef['Edit'].disabled) return false;
	
	this.n=newValue*1;
	this.ObjectRef['Edit'].value=this.n;
	//trigger OnChange event
	this.OnChange();
	}
//-----------------------------------------------------------------
	//ResetValue
	function ResetValue()
	{
	this.n=this.DefaultValue;
	this.ObjectRef['Edit'].value=this.n;
	//trigger OnChange event
	this.OnChange();
	}		

//-----------------------------------------------------------------
function HandleChange()
{
this.ObjectRef['Edit'].style.backgroundColor=this.BackgroundColor;
if(!this.Validate(this.ObjectRef['Edit'].value)) 
	{
	this.ObjectRef['Edit'].value=this.n;
	this.ObjectRef['Edit'].style.backgroundColor='yellow';
	this.ObjectRef['Edit'].focus();	//set focus warn user
	return false;
	}
	else
		this.n=FixJSFloatBug(this.ObjectRef['Edit'].value*1);	//little trick to convert to numeric and prevent JS Floating point operation bugs

this.OnChange();

	return true;
}
//-----------------------------------------------------------------
function Disable()
{
this.ObjectRef['Edit'].disabled=true;
this.ObjectRef['UpArrow'].disabled=true;
this.ObjectRef['DownArrow'].disabled=true;
}
//-----------------------------------------------------------------
function Enable()
{
this.ObjectRef['Edit'].disabled=false;
this.ObjectRef['UpArrow'].disabled=false;
this.ObjectRef['DownArrow'].disabled=false;
}

}
