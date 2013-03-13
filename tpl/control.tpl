<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja-JP" style="-webkit-text-size-adjust:none;">
<head>
<title>Mabinogi Character Simulator 2</title>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META http-equiv="Content-Script-Type" content="text/javascript">
<META http-equiv="Content-Style-Type" content="text/css">
<link rel="stylesheet" href="main.css" type="text/css">
<link rel="stylesheet" href="pmcs2.css" type="text/css">
<script type="text/javascript">
<!--

/* pmcs.js.php */
//JavaScriptコード

function execute_mcode( script )
{
	if (script.indexOf(".") != -1 || script.indexOf("_") != -1) {
		//ScriptなのでAPIを使ってMCODEに変換
		document.formMCODEAPIRequest.mode.value = "execute";
		document.formMCODEAPIRequest.action.value = "encode";
		document.formMCODEAPIRequest.script.value = ""+script;
		document.formMCODEAPIRequest.submit();
	} else {
		//MCODEなのでそのまま実行
		execute( script );
	}
}
function encode_mcode( script )
{
	document.formMCODEAPIRequest.mode.value = "encode";
	if (script.indexOf(".") != -1 || script.indexOf("_") != -1) {
		//APIを使ってMCODEに変換
		document.formMCODEAPIRequest.action.value = "encode";
	} else {
		//APIを使ってScriptに変換
		document.formMCODEAPIRequest.action.value = "decode";
	}
	document.formMCODEAPIRequest.script.value = ""+script;
	document.formMCODEAPIRequest.submit();
}
	function return_mcode_api(mode, res, type)
	{
		if (mode == "execute") {
			if (type == "encode") {
				execute( res );
			}
		}
		if (mode == "encode") {
			if (type == "decode") {
				res = res.replace(/<br>/g, "\r\n");
			}
			document.getElementById('excute_cmd').value = ""+res;
		}
	}
	
function encode_TrueMabiColor()
{
	document.formTrueMabiColorRequest.gcolor.value = controller.colorPickerHEX.value;
	document.formTrueMabiColorRequest.palette.value = controller.paletteTrueColorMenu.value;
	document.formTrueMabiColorRequest.submit();
}
	function return_truemabicolor(result, gcolor)
	{
		if (result == 1) {
			status = "現在の選択色 ("+gcolor+") は染色できる色です。";
		} else {
			setPickerColor(gcolor);
			status = "変換しました。("+gcolor+")";
		}
	}

var sBgColorp = "fcfee3";
var sBgColor = "";
function changeBgColorCustom( color )
{
	if (color.length != 6) {
		alert("背景色は6桁の16進数 (#FFFFFF) 形式で入力してください♪\n\nPlease input a color cord by the '#FFFFFF' (hex-color) format.");
	} else {
		sBgColorp = color;
		changeBgColor();
	}
}
function changeBgColor()
{
	updateLinks();
	parent.location.href = "?q="+sCurConfig;
}
function runSearch( )
{
	var searchStr = controller.searchText.value;
	if (!searchStr) return;
	
	searchStr = searchStr.replace(/　/g, " ");
	searchStr = searchStr.replace(/  /g, " ");
	
	var searchArray = searchStr.split(" ");
	var searchStrKana = encodeHiraToKata( searchStr );
	var searchKanaArray = searchStrKana.split(" ");
	
	var target = controller.searchPartsMenu.value;
	
	if (target == "_equip") {
		var resultBuffer = "";
		var searchTargetArray = new Array("head", "body", "foot", "hand", "robe", "weaponFirst", "shieldFirst", "weaponSecond", "shieldSecond");
		for (var i=0; i<searchTargetArray.length; i++) {
			resultBuffer += ""+runSearchCategory( searchTargetArray[i], searchArray, searchStrKana, searchKanaArray );
			if (resultBuffer.length >= 5000) {
				resultBuffer += "<br>* <i>Search results was too much...</i>";
				break;
			}
		}
	} else {
		var resultBuffer = runSearchCategory( target, searchArray, searchStrKana, searchKanaArray );
	}
	
	if (resultBuffer == "") {
		resultBuffer = "* <i>"+searchStr+" not found.</i>";
	}
	
	searchResult.innerHTML = resultBuffer;
}
function runSearchCategory( target, searchArray, searchStrKana, searchKanaArray )
{
	var resultBuffer = "";
	var i=0, n=0;
	for (i=0; i<controller[target+"Menu"].options.length; i++) {
		if (
			searchArray[0] != "" && 
			controller[target+"Menu"].options[i].value != -1 && 
			( 
				controller[target+"Menu"].options[i].text.indexOf(searchArray[0]) != -1 || 
				encodeHiraToKata(controller[target+"Menu"].options[i].text).indexOf(searchKanaArray[0]) != -1 
				
			)
		) {
			var hit = true;
			for (n=1; n<searchArray.length; n++) {
				if (
					controller[target+"Menu"].options[i].text.indexOf(searchArray[n]) == -1 || 
					encodeHiraToKata(controller[target+"Menu"].options[i].text).indexOf(searchKanaArray[n]) == -1 
				) {
					hit = false;
					break;
				}
			}
			
			if (hit) {
				var entryBuffer = "◆<a href='javascript:void(0);' onclick='selectList(\""+target+"\", \""+controller[target+"Menu"].options[i].value+"\");'>"+controller[target+"Menu"].options[i].text+"</a> ";
				resultBuffer = resultBuffer+entryBuffer;
			}
		}
	}
	
	if (resultBuffer) {
		resultBuffer = "<b style='color:green;'>【"+equip_table[""+target].name+"】</b>"+resultBuffer+"<br>";
	}
	
	return resultBuffer;
}
var equip_table = new Array();

equip_table["head"] = { type: "Equip", name : "Head" };
equip_table["body"] = { type: "Equip", name : "Body" };
equip_table["foot"] = { type: "Equip", name : "Foot" };
equip_table["hand"] = { type: "Equip", name : "Hand" };
equip_table["robe"] = { type: "Equip", name : "Robe" };
equip_table["weaponFirst"] = { type: "Equip", name : "Weapon Main (Left Hand)" };
equip_table["shieldFirst"] = { type: "Equip", name : "Weapon Main (Right Hand)" };
equip_table["weaponSecond"] = { type: "Equip", name : "Weapon Sub (Left Hand)" };
equip_table["shieldSecond"] = { type: "Equip", name : "Weapon Sub (Right Hand)" };

equip_table["animation"] = { type: "Char", name : "Motion" };
equip_table["hair"] = { type: "Char", name : "Hair Style" };
equip_table["hairColor"] = { type: "Char", name : "Hair Color" };
equip_table["eyeEmotion"] = { type: "Char", name : "Eye Style" };
equip_table["eyeColor"] = { type: "Char", name : "Eye Color" };
equip_table["face"] = { type: "Char", name : "Face" };
equip_table["mouthEmotion"] = { type: "Char", name : "Mouth" };
equip_table["reaction"] = { type: "Char", name : "Face Reaction" };
equip_table["skinColor"] = { type: "Char", name : "Skin Color" };

var last_history = "";
var history_master = new Array();
var history_master_pos = 0;
var history_master_pos_first = 0;
var history_data = new Array();
		history_data["head"] = new Array();
		history_data["head"]["pos"] = 0;
		history_data["head"]["data"] = new Array();
				history_data["body"] = new Array();
		history_data["body"]["pos"] = 0;
		history_data["body"]["data"] = new Array();
				history_data["foot"] = new Array();
		history_data["foot"]["pos"] = 0;
		history_data["foot"]["data"] = new Array();
				history_data["hand"] = new Array();
		history_data["hand"]["pos"] = 0;
		history_data["hand"]["data"] = new Array();
				history_data["robe"] = new Array();
		history_data["robe"]["pos"] = 0;
		history_data["robe"]["data"] = new Array();
				history_data["weaponFirst"] = new Array();
		history_data["weaponFirst"]["pos"] = 0;
		history_data["weaponFirst"]["data"] = new Array();
				history_data["shieldFirst"] = new Array();
		history_data["shieldFirst"]["pos"] = 0;
		history_data["shieldFirst"]["data"] = new Array();
				history_data["weaponSecond"] = new Array();
		history_data["weaponSecond"]["pos"] = 0;
		history_data["weaponSecond"]["data"] = new Array();
				history_data["shieldSecond"] = new Array();
		history_data["shieldSecond"]["pos"] = 0;
		history_data["shieldSecond"]["data"] = new Array();
				history_data["animation"] = new Array();
		history_data["animation"]["pos"] = 0;
		history_data["animation"]["data"] = new Array();
				history_data["hair"] = new Array();
		history_data["hair"]["pos"] = 0;
		history_data["hair"]["data"] = new Array();
				history_data["hairColor"] = new Array();
		history_data["hairColor"]["pos"] = 0;
		history_data["hairColor"]["data"] = new Array();
				history_data["eyeEmotion"] = new Array();
		history_data["eyeEmotion"]["pos"] = 0;
		history_data["eyeEmotion"]["data"] = new Array();
				history_data["eyeColor"] = new Array();
		history_data["eyeColor"]["pos"] = 0;
		history_data["eyeColor"]["data"] = new Array();
				history_data["face"] = new Array();
		history_data["face"]["pos"] = 0;
		history_data["face"]["data"] = new Array();
				history_data["mouthEmotion"] = new Array();
		history_data["mouthEmotion"]["pos"] = 0;
		history_data["mouthEmotion"]["data"] = new Array();
				history_data["reaction"] = new Array();
		history_data["reaction"]["pos"] = 0;
		history_data["reaction"]["data"] = new Array();
				history_data["skinColor"] = new Array();
		history_data["skinColor"]["pos"] = 0;
		history_data["skinColor"]["data"] = new Array();
				history_data["scale"] = new Array();
		history_data["scale"]["pos"] = 0;
		history_data["scale"]["data"] = new Array();
				history_data["headColor"] = new Array();
		history_data["headColor"]["pos"] = 0;
		history_data["headColor"]["data"] = new Array();
				history_data["bodyColor"] = new Array();
		history_data["bodyColor"]["pos"] = 0;
		history_data["bodyColor"]["data"] = new Array();
				history_data["footColor"] = new Array();
		history_data["footColor"]["pos"] = 0;
		history_data["footColor"]["data"] = new Array();
				history_data["handColor"] = new Array();
		history_data["handColor"]["pos"] = 0;
		history_data["handColor"]["data"] = new Array();
				history_data["robeColor"] = new Array();
		history_data["robeColor"]["pos"] = 0;
		history_data["robeColor"]["data"] = new Array();
				history_data["weaponFirstColor"] = new Array();
		history_data["weaponFirstColor"]["pos"] = 0;
		history_data["weaponFirstColor"]["data"] = new Array();
				history_data["weaponSecondColor"] = new Array();
		history_data["weaponSecondColor"]["pos"] = 0;
		history_data["weaponSecondColor"]["data"] = new Array();
				history_data["shieldFirstColor"] = new Array();
		history_data["shieldFirstColor"]["pos"] = 0;
		history_data["shieldFirstColor"]["data"] = new Array();
				history_data["shieldSecondColor"] = new Array();
		history_data["shieldSecondColor"]["pos"] = 0;
		history_data["shieldSecondColor"]["data"] = new Array();
		var skip_history = false;
function addHistoryEquip(target, _value)
{
			
	if (skip_history) return;
	
	if (!_value) {
		if (controller[target+"Menu"].selectedIndex == -1) { return; }
		_value = controller[target+"Menu"].options[controller[target+"Menu"].selectedIndex].value;
	}
	
	if (history_data[""+target][history_data[""+target]["pos"]] == _value) {
		return;
	}
	
	history_master_pos ++;
	history_master[history_master_pos] = ""+target;
	history_master_max = history_master_pos;
		
	history_data[""+target]["pos"] ++;
	history_data[""+target][history_data[""+target]["pos"]] = ""+_value;
	history_data[""+target]["max"] = history_data[""+target]["pos"];
	
	//alert(""+history_master_pos+"\n"+history_data[""+target]["pos"]+"\n"+target+"\n"+history_data[""+target][history_data[""+target]["pos"]]+"\n"+_value);
	
	checkHistoryButtonStatus();
}
function backHistory()
{
	if (history_master_pos <= 1) return;
	
	var _target = history_master[history_master_pos];
	history_master_pos --;
	
	if (history_data[""+_target]["pos"] <= 1) {
		history_master_pos ++;
		return;
	}
	history_data[""+_target]["pos"] --;
	var _data = history_data[""+_target][history_data[""+_target]["pos"]];
	
	skip_history = true;
	
	//alert("["+history_master_pos+"/"+history_data[""+_target]["pos"]+"]"+_target+"\n"+_data);
	selectList(_target, _data);
	
	skip_history = false;
	
	checkHistoryButtonStatus();
}
function nextHistory()
{
	if (history_master_max <= history_master_pos) return;
	
	history_master_pos ++;
	var _target = history_master[history_master_pos];
	
	if (history_data[""+_target]["max"] <= history_data[""+_target]["pos"]) {
		history_master_pos --;
		return;
	}
	history_data[""+_target]["pos"] ++;
	var _data = history_data[""+_target][history_data[""+_target]["pos"]];
	
	skip_history = true;
	
	//alert("["+history_master_pos+"/"+history_data[""+_target]["pos"]+"]"+_target+"\n"+_data);
	selectList(_target, _data);
	
	skip_history = false;
	
	checkHistoryButtonStatus();
}

function checkHistoryButtonStatus() {
	if (history_master_max > history_master_pos) {
		document.getElementById("nextHistoryButton").disabled = "";
		document.getElementById("nextHistoryButton").value = "Next ->";
	} else {
		document.getElementById("nextHistoryButton").disabled = "disabled";
		document.getElementById("nextHistoryButton").value = "---";
	}
	
	if (history_master_pos > history_master_pos_first) {
		document.getElementById("backHistoryButton").disabled = "";
		document.getElementById("backHistoryButton").value = "<- Back";
	} else {
		document.getElementById("backHistoryButton").disabled = "disabled";
		document.getElementById("backHistoryButton").value = "---";
	}
}

function selectList( target, value )
{
	if (target == "body") {
		sBodyIndex = value;
		controller[target+"Menu"].value = sBodyIndex;
		changeBody(sBodyIndex);
	}
	if (target == "head") {
		sHeadIndex = value;
		controller[target+"Menu"].value = sHeadIndex;
		changeHead(sHeadIndex);
	}
	if (target == "foot") {
		sFootIndex = value;
		controller[target+"Menu"].value = sFootIndex;
		changeFoot(sFootIndex);
	}
	if (target == "hand") {
		sHandIndex = value;
		controller[target+"Menu"].value = sHandIndex;
		changeHand(sHandIndex);
	}
	if (target == "robe") {
		sRobeIndex = value;
		controller[target+"Menu"].value = sRobeIndex;
		changeRobe(sRobeIndex);
	}
	if (target == "weaponFirst") {
		sWeaponFirstIndex = value;
		controller[target+"Menu"].value = sWeaponFirstIndex;
		changeWeaponFirst(sWeaponFirstIndex);
	}
	if (target == "weaponSecond") {
		sWeaponSecondIndex = value;
		controller[target+"Menu"].value = sWeaponSecondIndex;
		changeWeaponSecond(sWeaponSecondIndex);
	}
	if (target == "shieldFirst") {
		sShieldFirstIndex = value;
		controller[target+"Menu"].value = sShieldFirstIndex;
		changeShieldFirst(sShieldFirstIndex);
	}
	if (target == "shieldSecond") {
		sShieldSecondIndex = value;
		controller[target+"Menu"].value = sShieldSecondIndex;
		changeShieldSecond(sShieldSecondIndex);
	}
	
	if (target == "animation") {
		sAnimationIndex = value;
		controller[target+"Menu"].value = sAnimationIndex;
		changeAnimation(sAnimationIndex);
	}
	if (target == "hair") {
		sHairIndex = value;
		controller[target+"Menu"].value = sHairIndex;
		changeHair(sHairIndex);
	}
	if (target == "hairColor") {
		sHairColorIndex = value;
		controller[target+"Menu"].value = sHairColorIndex;
		changeHairColor(sHairColorIndex);
	}
	if (target == "eyeEmotion") {
		sEyeEmotionIndex = value;
		controller[target+"Menu"].value = sEyeEmotionIndex;
		changeEyeEmotion(sEyeEmotionIndex);
	}
	if (target == "eyeColor") {
		sEyeColorIndex = value;
		controller[target+"Menu"].value = sEyeColorIndex;
		changeEyeColor(sEyeColorIndex);
	}
	if (target == "face") {
		sFaceIndex = value;
		controller[target+"Menu"].value = sFaceIndex;
		changeFace(sFaceIndex);
	}
	if (target == "mouthEmotion") {
		sMouthEmotionIndex = value;
		controller[target+"Menu"].value = sMouthEmotionIndex;
		changeMouthEmotion(sMouthEmotionIndex);
	}
	if (target == "reaction") {
		sReactionIndex = value;
		controller[target+"Menu"].value = sReactionIndex;
		changeReaction(sReactionIndex);
	}
	if (target == "skinColor") {
		sSkinColorIndex = value;
		controller[target+"Menu"].value = sSkinColorIndex;
		changeSkinColor(sSkinColorIndex);
	}
	
				
			if (target == "headColor") {
				var ent = value.split(",");
				controller["headColor1"].value = ent[0];
				controller["headColor2"].value = ent[1];
				controller["headColor3"].value = ent[2];
				dyeHead(controller["headColor1"].value,controller["headColor2"].value,controller["headColor3"].value);
			}
			
						
			if (target == "bodyColor") {
				var ent = value.split(",");
				controller["bodyColor1"].value = ent[0];
				controller["bodyColor2"].value = ent[1];
				controller["bodyColor3"].value = ent[2];
				dyeBody(controller["bodyColor1"].value,controller["bodyColor2"].value,controller["bodyColor3"].value);
			}
			
						
			if (target == "footColor") {
				var ent = value.split(",");
				controller["footColor1"].value = ent[0];
				controller["footColor2"].value = ent[1];
				controller["footColor3"].value = ent[2];
				dyeFoot(controller["footColor1"].value,controller["footColor2"].value,controller["footColor3"].value);
			}
			
						
			if (target == "handColor") {
				var ent = value.split(",");
				controller["handColor1"].value = ent[0];
				controller["handColor2"].value = ent[1];
				controller["handColor3"].value = ent[2];
				dyeHand(controller["handColor1"].value,controller["handColor2"].value,controller["handColor3"].value);
			}
			
						
			if (target == "robeColor") {
				var ent = value.split(",");
				controller["robeColor1"].value = ent[0];
				controller["robeColor2"].value = ent[1];
				controller["robeColor3"].value = ent[2];
				dyeRobe(controller["robeColor1"].value,controller["robeColor2"].value,controller["robeColor3"].value);
			}
			
						
			if (target == "weaponFirstColor") {
				var ent = value.split(",");
				controller["weaponFirstColor1"].value = ent[0];
				controller["weaponFirstColor2"].value = ent[1];
				controller["weaponFirstColor3"].value = ent[2];
				dyeWeaponFirst(controller["weaponFirstColor1"].value,controller["weaponFirstColor2"].value,controller["weaponFirstColor3"].value);
			}
			
						
			if (target == "weaponSecondColor") {
				var ent = value.split(",");
				controller["weaponSecondColor1"].value = ent[0];
				controller["weaponSecondColor2"].value = ent[1];
				controller["weaponSecondColor3"].value = ent[2];
				dyeWeaponSecond(controller["weaponSecondColor1"].value,controller["weaponSecondColor2"].value,controller["weaponSecondColor3"].value);
			}
			
						
			if (target == "shieldFirstColor") {
				var ent = value.split(",");
				controller["shieldFirstColor1"].value = ent[0];
				controller["shieldFirstColor2"].value = ent[1];
				controller["shieldFirstColor3"].value = ent[2];
				dyeShieldFirst(controller["shieldFirstColor1"].value,controller["shieldFirstColor2"].value,controller["shieldFirstColor3"].value);
			}
			
						
			if (target == "shieldSecondColor") {
				var ent = value.split(",");
				controller["shieldSecondColor1"].value = ent[0];
				controller["shieldSecondColor2"].value = ent[1];
				controller["shieldSecondColor3"].value = ent[2];
				dyeShieldSecond(controller["shieldSecondColor1"].value,controller["shieldSecondColor2"].value,controller["shieldSecondColor3"].value);
			}
			
				
	if (target == "scale") {
		var ent = value.split(",");
		controller["heightSelector"].value = ent[0];
		controller["fatnessSelector"].value = ent[1];
		controller["topSelector"].value = ent[2];
		controller["bottomSelector"].value = ent[3];
		changeScaleByMenu();
	}
	
}
function searchList( target )
{
	var searchStr = "";
	searchStr = window.prompt("","");
	if (!searchStr) return;

	var searchStrKana = encodeHiraToKata( searchStr );

	var i=0;
	for (i=0; i<controller[target+"Menu"].options.length; i++) {
		if (controller[target+"Menu"].options[i].text.indexOf(searchStr) != -1 || controller[target+"Menu"].options[i].text.indexOf(searchStrKana) != -1) {
			if (target == "body") {
				sBodyIndex = controller[target+"Menu"].options[i].value;
				controller[target+"Menu"].value = sBodyIndex;
				changeBody(sBodyIndex);
			}
			if (target == "head") {
				sHeadIndex = controller[target+"Menu"].options[i].value;
				controller[target+"Menu"].value = sHeadIndex;
				changeHead(sHeadIndex);
			}
			if (target == "foot") {
				sFootIndex = controller[target+"Menu"].options[i].value;
				controller[target+"Menu"].value = sFootIndex;
				changeFoot(sFootIndex);
			}
			if (target == "hand") {
				sHandIndex = controller[target+"Menu"].options[i].value;
				controller[target+"Menu"].value = sHandIndex;
				changeHand(sHandIndex);
			}
			if (target == "robe") {
				sRobeIndex = controller[target+"Menu"].options[i].value;
				controller[target+"Menu"].value = sRobeIndex;
				changeRobe(sRobeIndex);
			}
			if (target == "weaponFirst") {
				sWeaponFirstIndex = controller[target+"Menu"].options[i].value;
				controller[target+"Menu"].value = sWeaponFirstIndex;
				changeWeaponFirst(sWeaponFirstIndex);
			}
			if (target == "weaponSecond") {
				sWeaponSecondIndex = controller[target+"Menu"].options[i].value;
				controller[target+"Menu"].value = sWeaponSecondIndex;
				changeWeaponSecond(sWeaponSecondIndex);
			}
			if (target == "shieldFirst") {
				sShieldFirstIndex = controller[target+"Menu"].options[i].value;
				controller[target+"Menu"].value = sShieldFirstIndex;
				changeShieldFirst(sShieldFirstIndex);
			}
			if (target == "shieldSecond") {
				sShieldSecondIndex = controller[target+"Menu"].options[i].value;
				controller[target+"Menu"].value = sShieldSecondIndex;
				changeShieldSecond(sShieldSecondIndex);
			}
			return;
		}
	}

	alert("not found.");
}
function encodeHiraToKata( text )
{
	var after = "";
	var i;
	for (i=0; i<text.length; i++) {
		c = text.charCodeAt(i);
		if (c>=12353 && c<=12435) {
		c = c + 96;
	}
	after += String.fromCharCode(c);
	}
	return (after.toLowerCase()).replace(/[Ａ-Ｚａ-ｚ０-９]/g,function(s){return String.fromCharCode(s.charCodeAt(0)-0xFEE0)});
}

function openNewWindow()
{
	updateLinks();
	window.open("?q="+sCurConfig);
}

function captureSnapshot()
{
	var script = csScript();
	document.formCaptureSnapshot.code.value = ""+script;
	document.formCaptureSnapshot.q.value = ""+sCurConfig;
	document.formCaptureSnapshot.submit();
}
function captureDressroom()
{
	var script = csScript();
	document.formCaptureDressroom.code.value = ""+script;
	document.formCaptureDressroom.q.value = ""+sCurConfig;
	document.formCaptureDressroom.submit();
}
function captureBlogparts()
{
	var script = csScript();
	document.formCaptureBlogparts.code.value = ""+script;
	document.formCaptureBlogparts.q.value = ""+sCurConfig;
	document.formCaptureBlogparts.submit();
}

function changeFramework()
{
	//if (confirm('')){
		sFramework = controller.csFramework.value;
		parent.location.href="?action=changeFramework&framework="+sFramework;
	//} else {
	//	controller.csFramework.value = sFramework;
	//}
}

var reset_cnt = 0;
function checkResetCount()
{
	reset_cnt ++;
	if (reset_cnt >= 15) {
		csSoftReset();
		reset_cnt = 0;
	}
}

function go()
{
	//checkMWFRE();
	//controller.csLang.value = sLanguageIndex;
	controller.csFramework.value = sFramework;
	controller.csSize.value = sAvatarSize;
	controller.csAA.value = sAvatarAA;
	controller.bgColor.value = sBgColorp;
	controller.hairMenu.value = sHairIndex;
		addHistoryEquip("hair");
	controller.hairColorMenu.value = sHairColorIndex;
		addHistoryEquip("hairColor");
	controller.eyeEmotionMenu.value = sEyeEmotionIndex;
		addHistoryEquip("eyeEmotion");
	controller.eyeColorMenu.value = sEyeColorIndex;
		addHistoryEquip("eyeColor");
	controller.mouthEmotionMenu.value = sMouthEmotionIndex;
		addHistoryEquip("mouthEmotion");
	controller.skinColorMenu.value = sSkinColorIndex;
		addHistoryEquip("skinColor");
	controller.faceMenu.value = sFaceIndex;
		addHistoryEquip("face");
	controller.headMenu.value = sHeadIndex;
		addHistoryEquip("head");
	controller.bodyMenu.value = sBodyIndex;
		addHistoryEquip("body");
	controller.handMenu.value = sHandIndex;
		addHistoryEquip("hand");
	controller.footMenu.value = sFootIndex;
		addHistoryEquip("foot");
	controller.robeMenu.value = sRobeIndex;
		addHistoryEquip("robe");
		
	controller.weaponFirstMenu.value = sWeaponFirstIndex;
		addHistoryEquip("weaponFirst");
	controller.weaponSecondMenu.value = sWeaponSecondIndex;
		addHistoryEquip("weaponSecond");
	controller.shieldFirstMenu.value = sShieldFirstIndex;
		addHistoryEquip("shieldFirst");
	controller.shieldSecondMenu.value = sShieldSecondIndex;
		addHistoryEquip("shieldSecond");
		
	controller.animationMenu.value = sAnimationIndex;
		addHistoryEquip("animation");
	controller.reactionMenu.value = sReactionIndex;
		addHistoryEquip("reaction");
	controller.heightSelector.value = Math.round(sHeightScalep*10);
	controller.fatnessSelector.value = Math.round(sFatnessScalep*10);
	controller.topSelector.value = Math.round(sTopScalep*10);
	controller.bottomSelector.value = Math.round(sBottomScalep*10);
		addHistoryEquip("scale", controller.heightSelector.value+","+controller.fatnessSelector.value+","+controller.topSelector.value+","+controller.bottomSelector.value);
	controller.headColor1.value = sHeadColor1p;
	controller.headColor2.value = sHeadColor2p;
	controller.headColor3.value = sHeadColor3p;
		addHistoryEquip("headColor", sHeadColor1p+","+sHeadColor2p+","+sHeadColor3p);
	controller.bodyColor1.value = sBodyColor1p;
	controller.bodyColor2.value = sBodyColor2p;
	controller.bodyColor3.value = sBodyColor3p;
		addHistoryEquip("bodyColor", sBodyColor1p+","+sBodyColor2p+","+sBodyColor3p);
	controller.footColor1.value = sFootColor1p;
	controller.footColor2.value = sFootColor2p;
	controller.footColor3.value = sFootColor3p;
		addHistoryEquip("footColor", sFootColor1p+","+sFootColor2p+","+sFootColor3p);
	controller.handColor1.value = sHandColor1p;
	controller.handColor2.value = sHandColor2p;
	controller.handColor3.value = sHandColor3p;
		addHistoryEquip("handColor", sHandColor1p+","+sHandColor2p+","+sHandColor3p);
	controller.robeColor1.value = sRobeColor1p;
	controller.robeColor2.value = sRobeColor2p;
	controller.robeColor3.value = sRobeColor3p;
		addHistoryEquip("robeColor", sRobeColor1p+","+sRobeColor2p+","+sRobeColor3p);
	controller.weaponFirstColor1.value = sWeaponFirstColor1p;
	controller.weaponFirstColor2.value = sWeaponFirstColor2p;
	controller.weaponFirstColor3.value = sWeaponFirstColor3p;
		addHistoryEquip("weaponFirstColor", sWeaponFirstColor1p+","+sWeaponFirstColor2p+","+sWeaponFirstColor3p);
	controller.weaponSecondColor1.value = sWeaponSecondColor1p;
	controller.weaponSecondColor2.value = sWeaponSecondColor2p;
	controller.weaponSecondColor3.value = sWeaponSecondColor3p;
		addHistoryEquip("weaponSecondColor", sWeaponSecondColor1p+","+sWeaponSecondColor2p+","+sWeaponSecondColor3p);
	controller.shieldFirstColor1.value = sShieldFirstColor1p;
	controller.shieldFirstColor2.value = sShieldFirstColor2p;
	controller.shieldFirstColor3.value = sShieldFirstColor3p;
		addHistoryEquip("shieldFirstColor", sShieldFirstColor1p+","+sShieldFirstColor2p+","+sShieldFirstColor3p);
	controller.shieldSecondColor1.value = sShieldSecondColor1p;
	controller.shieldSecondColor2.value = sShieldSecondColor2p;
	controller.shieldSecondColor3.value = sShieldSecondColor3p;
		addHistoryEquip("shieldSecondColor", sShieldSecondColor1p+","+sShieldSecondColor2p+","+sShieldSecondColor3p);
	controller.hairColor.value = sHairColorp;
	controller.eyeColor.value = sEyeColorp;
	controller.skinColor.value = sSkinColorp;
	controller.headState.value = sHeadWearState;
	controller.bodyState.value = sBodyWearState;
	controller.robeState.value = sRobeWearType;
	controller.weaponFirstState.value = sWeaponFirstWearState;
	controller.weaponSecondState.value = sWeaponSecondWearState;
	controller.shieldFirstState.value = sShieldFirstWearState;
	controller.shieldSecondState.value = sShieldSecondWearState;
	initColorPicker();
	initAnimator();
	csReset();
	
	history_master_pos_first = history_master_pos;
	checkHistoryButtonStatus();
}
function getCookie(key)
{
	var tmp1, tmp2, xx1, xx2, xx3;
	tmp1 = " " + document.cookie + ";";
	xx1 = xx2 = 0;
	len = tmp1.length;
	while (xx1 < len)
	{
		xx2 = tmp1.indexOf(";", xx1);
		tmp2 = tmp1.substring(xx1 + 1, xx2);
		xx3 = tmp2.indexOf("=");
		if (tmp2.substring(0, xx3) == key)
		{
			return(unescape(tmp2.substring(xx3 + 1, xx2 - xx1 - 1)));
		}
		xx1 = xx2 + 1;
	}
	return("");
}
function checkMWFRE()
{
	if(getCookie("mwfre")==2)
	mwfreNotice.innerHTML = "about mwfre (installed)";
}
function csExecute( script )
{
	var cmd = document.getElementById("excute_cmd").value;
	var flg = document.getElementById("append_cmd").checked;
	if (flg == false){
		cmd = script;
	}else{
		cmd += "O1W2U428" + script;
	}
	document.getElementById("excute_cmd").value = cmd
    script = csScript();
	execute( script );
	updateLinks();
}
function request_full_execute() {
	parent.full_execute( csScript() );
}
//http://sub.labo.erinn.biz/cs_server/sv_sub.php/
//var sBase = "gTqIXBaE0BGNET7RzvWCuPrQFoa;ykaM15LNSpaPedaM;8q;R6rLpLbQXnWQ3nZR66KRkj6Qmlk;n9aMeEqOKMrPEB2NhBLMl7aQJUqMpMZ2t3bQMpqPsyGAOmUAnJaELwqPKDWQpHYBJInEk1W2";


//http://labo.erinn.biz/cs_server/sv.php/
var sBase = "gTqIXBaE0BGNET7RzvWC3k6PUxKMA0rP;8q;R8r;pLbQTZb;l8a2zVqMZnaQERaPk;6Q:5LNX1KMpMZ2t3bQMpqPsyGAWj0BL1qNGk6PqQ48fRIFmikB";

var sFrameworkArray = new Array(
//	"gTqIF1bFTMKPH4rPZR6848KPClJNx;aQ7FLNyWaQR5bN8dE3",
//	"gTqIF1bFTMKPH4rPVl68zM6PF5bNTMKPH4rP2Qa;WtEP",
//	"gTqIF1bFTMKPH4rPdN48wpKMRGqL48KPClJNx;aQ7FLNyWaQR5bN8dE3",
//	"gTqIF1bFTMKPH4rPdN48wpKMNyqLzM6PF5bNTMKPH4rP2Qa;WtEP"

"gTqIF1bFTMKPH4rPZR6848KPClJNx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPVl68zM6PF5bNTMKPH4rP2Qa;8ZEP", 
"gTqIF1bFTMKPH4rPdN48wpKMRGqL48KPClJNx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPdN48wpKMNyqLzM6PF5bNTMKPH4rP2Qa;8ZEP", 
"gTqIF1bFTMKPH4rPbF68SkpP9tKNzM6PK;qR6l5Nx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPbF68SkpP9tKNzM6PrHrQDTaQF5bNTMKPH4rP2Qa;8ZEP", 
"gTqIF1bFTMKPH4rPbF68SkpP9tKNzM6PblaM:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPbF68SkpP9tKNzM6PZxaMjQbPF5bNTMKPH4rP2Qa;8ZEP", 
"gTqIF1bFTMKPH4rPbF68JkpPhxKMNKrLjQaPF5bNTMKPH4rP2Qa;8ZEP", 
"gTqIF1bFTMKPH4rPbF68JkpPhxKMD6rLQ4rP:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPbF68JkpPhxKML2qLSnpRx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPbF68JkpPhxKMI2qLQrKR:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPbF68SkpP9tKNzM6PodrMgoKOr5LNF5bNTMKPH4rP2Qa;8ZEP", 
"gTqIF1bFTMKPH4rPbF68SkpP9tKNzM6PodrMgoKOr5LNF5bNTMKPH4rP2Qa;8ZEP", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"gTqIF1bFTMKPH4rPVx68SkpPx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPVx68SkpPx;aQ7FLNDXaQ7RnMtjqQfMqOVP6QyOaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPVx68SkpPx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPVx68SkpPx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPVx68SkpPx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPVx68SkpPx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPVx68SkpPx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPVx68SkpPx;aQ7FLNDXaQU8aOgpKMXPaQyrmQOuaQ", 
"gTqIF1bFTMKPH4rPVx68SkpPx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPVx68SkpPx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPVx68SkpPx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPVx68SkpPx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPVx68SkpPx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPVx68SkpPx;aQ7FLNyWaQR5bNk1W2", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"gTqIF1bFTMKPH4rPjl68t7bQNhqNKkZPx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPjl68t7bQNhqNj4XPF5bNTMKPH4rP2Qa;8ZEP", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"gTqIF1bFTMKPH4rPd968rhqM6k5Px;aQ7FLNyWaQR5bNk1W2", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"gTqIF1bFTMKPH4rPZx68UtKMadKM:GqLhtKM:nqRyomOOuaQ", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"gTqIF1bFTMKPH4rPZR6848KPClJNx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPZR6848KPClJNx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPZR6848KPClJNx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPZR6848KPClJNx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPZR6848KPClJNx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPZR6848KPClJNx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPZR6848KPClJNx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPZR6848KPClJNx;aQ7FLNyWaQR5bNk1W2", 
"gTqIF1bFTMKPH4rPVl68zM6PF5bNTMKPH4rP2Qa;8ZEP", 
"gTqIF1bFTMKPH4rPVl68zM6PF5bNTMKPH4rP2Qa;8ZEP", 
"gTqIF1bFTMKPH4rPVl68zM6PF5bNTMKPH4rP2Qa;8ZEP", 
"gTqIF1bFTMKPH4rPVl68zM6PF5bNTMKPH4rP2Qa;8ZEP", 
"gTqIF1bFTMKPH4rPVl68zM6PF5bNTMKPH4rP2Qa;8ZEP", 
"gTqIF1bFTMKPH4rPVl68zM6PF5bNTMKPH4rP2Qa;8ZEP", 
"gTqIF1bFTMKPH4rPVl68zM6PF5bNTMKPH4rP2Qa;8ZEP", 
"gTqIF1bFTMKPH4rPVl68zM6PF5bNTMKPH4rP2Qa;8ZEP", 
"", 
"", 
"", 
"", 
"gTqIF1bFTMKPH4rPgF68GlZNP5LN35LN:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPgF68GlZNP5LN35LN:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPgF68GlZNP5LN35LN:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPgF68GlZNP5LN35LN:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPgF68GlZNP5LN35LN:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPgF68GlZNP5LN35LN:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPgF68GlZNP5LN35LN:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPgF68GlZNP5LN35LN:GqLhtKM:nqRyomOOuaQ", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"gTqIF1bFTMKPH4rPdN68wpKMRGqL48KP:lJNP5LN35LN:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPdN68wpKMRGqL48KP:lJNP5LN35LN:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPdN68wpKMRGqL48KP:lJNP5LN35LN:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPdN68wpKMRGqL48KP:lJNP5LN35LN:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPdN68wpKMRGqL48KP:lJNP5LN35LN:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPdN68wpKMRGqL48KP:lJNP5LN35LN:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPdN68wpKMRGqL48KP:lJNP5LN35LN:GqLhtKM:nqRyomOOuaQ", 
"gTqIF1bFTMKPH4rPdN68wpKMRGqL48KP:lJNP5LN35LN:GqLhtKM:nqRyomOOuaQ", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
"", 
""
);

var sFramework = 0;

function csScript()
{
	var script = sBase;
	script += ""+sFrameworkArray[sFramework];
	script += "pAZ2AH4RN4qPD04PGk6Pf978cpKO"+sSkinColor;
	script += "pAZ2AH4RN4qPD04PGk6PUE68"+sEyeColor;
	script += "O1W2U428"+getScaleScript( sHeightScale, sFatnessScale, sTopScale, sBottomScale );
	
			script += "O1W2U428"+getFaceScript(sFaceIndex);
		script += "O1W2U428"+getRobeScript(sRobeIndex);
		script += "O1W2U428"+getRobeStateScript(sRobeWearType);
		script += "O1W2U428"+getBodyScript(sBodyIndex);
		script += "O1W2U428"+getHandScript(sHandIndex);
		script += "O1W2U428"+getFootScript(sFootIndex);
		script += "O1W2U428"+getHairScript(sHairIndex);
		
		script += "O1W2U428"+getHeadScript(sHeadIndex);
		script += "O1W2U428"+getHeadStateScript(sHeadIndex);
		script += "O1W2U428"+getEyeGrid();
		script += "O1W2U428"+getEyeEmotionScript(sEyeEmotionIndex);
		script += "O1W2U428"+getMouthGrid();
		script += "O1W2U428"+getMouthEmotionScript(sMouthEmotionIndex);
		script += "O1W2U428"+getWeaponFirstScript(sWeaponFirstIndex);
		script += "O1W2U428"+getWeaponFirstStateScript(sWeaponFirstWearState);
		script += "O1W2U428"+getWeaponSecondScript(sWeaponSecondIndex);
		script += "O1W2U428"+getWeaponSecondStateScript(sWeaponSecondWearState);
		script += "O1W2U428"+getShieldFirstScript(sShieldFirstIndex);
		script += "O1W2U428"+getShieldFirstStateScript(sShieldFirstWearState);
		script += "O1W2U428"+getShieldSecondScript(sShieldSecondIndex);
		script += "O1W2U428"+getShieldSecondStateScript(sShieldSecondWearState);
		script += "O1W2U428"+getAnimationScript(sAnimationIndex);
		script += "O1W2U428"+getReactionScript(sReactionIndex);
		script += "O1W2U428"+getBodyStateScript();
		script += "O1W2U428"+getHandStateScript();
		script += "O1W2U428"+getBodyNormScript();
	
	return script;
}
function csReset()
{
	changeScaleByMenu();

	var script = csScript();

	csExecute(script);
}
var sHeadWearTypeArray = new Array(
	new Array("PQKHmE4O8MrPtPrI0O6RdA6GMDWQc6GA","PQKHmE4O8MrPtPrI0O6RHBaFiBGNc6GA","PQKHmE4O8MrPtPrI0O6RVQ6GsB2Nc6GA"),
	new Array("PQKHmE4O8MrPtPrI0O6RdA6GMDWQk6WA","PQKHmE4O8MrPtPrI0O6RHBaFiBGNc6GA","PQKHmE4O8MrPtPrI0O6RVQ6GsB2Nc6GA"),
	new Array("PQKHmE4O8MrPtPrI0O6RdA6GMDWQs6mA","PQKHmE4O8MrPtPrI0O6RHBaFiBGNk6WA","PQKHmE4O8MrPtPrI0O6RVQ6GsB2Nc6GA"),
	new Array("PQKHmE4O8MrPtPrI0O6RdA6GMDWQ86GB","PQKHmE4O8MrPtPrI0O6RHBaFiBGN062B","PQKHmE4O8MrPtPrI0O6RVQ6GsB2Nc6GA"),
	new Array("PQKHmE4O8MrPtPrI0O6RdA6GMDWQE6WB","PQKHmE4O8MrPtPrI0O6RHBaFiBGNc6GA","PQKHmE4O8MrPtPrI0O6RVQ6GsB2Nc6GA"),
	new Array("PQKHmE4O8MrPtPrI0O6RdA6GMDWQM6mB","PQKHmE4O8MrPtPrI0O6RHBaFiBGNk6WA","PQKHmE4O8MrPtPrI0O6RVQ6GsB2Nc6GA"),
	new Array("PQKHmE4O8MrPtPrI0O6RdA6GMDWQ8KHB","PQKHmE4O8MrPtPrI0O6RHBaFiBGNk6WA","PQKHmE4O8MrPtPrI0O6RVQ6GtB2Nc6GA"),
	new Array("PQKHmE4O8MrPtPrI0O6RdA6GMDWQ8GHB","PQKHmE4O8MrPtPrI0O6RHBaFiBGNk6WA",""),
	new Array("PQKHmE4O8MrPtPrI0O6RdA6GMDWQs6mA","PQKHmE4O8MrPtPrI0O6RHBaFiBGNk6WA","PQKHmE4O8MrPtPrI0O6RVQ6GtB2Nk6WA"),
	new Array("PQKHmE4O8MrPtPrI0O6RdA6GMDWQs6mA","PQKHmE4O8MrPtPrI0O6RHBaFiBGNk6WA","PQKHmE4O8MrPtPrI0O6RVQ6GtB2Nk6WA")
);
var sHeadWearType = 0;
var sHeadWearState = 0;
var sHeadColor1 = "zSHA1GaB";
var sHeadColor1p = "1676e1";
var sHeadColor2 = "v;qApL6C";
var sHeadColor2p = "3cc8d5";
var sHeadColor3 = "L26B12aB";
var sHeadColor3p = "4a76a1";
var sHeadIndex = -1;
function getHeadScript( index )
{
	var script="";
	if(index>=0 && index<sHeadArray.length && sHeadArray[index][0])
	{
		sHeadIndex = index;
		if( sRobeIndex==-1 || sRobeWearType!=0 )
		{

			script = 'Y1485t4NsiqQZZ48cQKM'+sHeadArray[index][1]+'U428'+sHeadColor1+'VbaCU428'+sHeadColor2+'WbaCU428'+sHeadColor3+'XbaCkY38s73Ccj3A062BU438';

		}
	}
	return script;
}
function getHeadStateScript( index )
{
	var script="";
	if(index>=0 && index<sHeadArray.length && sHeadArray[index][0])
	{
		sHeadWearType = sHeadArray[index][2];
		if(sHeadWearType>5)
		{
			controller.headState.style.visibility = "visible";
			if(sHeadWearState!=0) {
				sHeadWearType = Number(sHeadWearType);
				sHeadWearType += 2;
			}
		}
		else
		controller.headState.style.visibility = "hidden";
		if( sRobeIndex==-1 || sRobeWearType!=0 ) {
			if (sBodyNorm3 == "UB2O" && sBodyWearState == 0) {
				script += 'Zl48TjqQZnaQo35QhRLMVZ48c5LOB53GpoY2TjqQZnaQo35QhRLMZZ48cQKMB33KpoY2TjqQZnaQo35QhRLMVR48sMqMEAXF';
			} else {
				script += "k1W2"+sHeadWearTypeArray[sHeadWearType][0]+"k1W2"+sHeadWearTypeArray[sHeadWearType][1]+"k1W2"+sHeadWearTypeArray[sHeadWearType][2];
			}
		} else {
			script = 'gNKEPQKHUB2OVQ6G6B2N9tKNzM6P2laN48KP8fqL0zWB8FKPa528KJaN:IaNU93Or428KFXNm4KMU53OX528:SqBmDHCU13OU428U62A'+'O1W2';
			script += 'Zl48TjqQZnaQo35QhRLMVZ48c5LO:53GPQKHmE4O8MrPtPrI0O6RVQ6GsB2NRjUA01LNL1rFvDLRI;6RiBGNh1KMmQ48';
		}
	}
	else if(index == -1)
	{
		sHeadIndex = -1;
		controller.headState.style.visibility = "hidden";
		script = 'gNKEPQKHUB2OVQ6G6B2N9tKNzM6P2laN48KP8fqL0zWB8FKPa528KJaN:IaNU93Or428KFXNm4KMU53OX528:SqBmDHCU13OU428U62A'+'O1W2';
		if( sRobeIndex==-1 || sRobeWearType!=0 ) {
			if (sBodyNorm3 == "UB2O" && sBodyWearState == 0) {
				script += 'Zl48TjqQZnaQo35QhRLMVZ48c5LOB53GpoY2TjqQZnaQo35QhRLMZZ48cQKMB33KpoY2TjqQZnaQo35QhRLMVR48sMqMEAXF';
			} else {
				script += 'Zl48TjqQZnaQo35QhRLMVZ48c5LO:B3GPQKHmE4O8MrPtPrI0O6RVQ6GsB2NRjUA01LNL1rFvDLRI;6RiBGNh1KMlQ48';
			}
		} else {
			script += 'Zl48TjqQZnaQo35QhRLMVZ48c5LO:53GPQKHmE4O8MrPtPrI0O6RVQ6GsB2NRjUA01LNL1rFvDLRI;6RiBGNh1KMmQ48';
		}
	}
	return script;
}
function changeHead( index )
{
	var script = getHeadScript(index);
	script += "O1W2"+getHeadStateScript(index);
	csExecute(script);
	
	checkResetCount();
	
	addHistoryEquip("head");
}
function changeHeadState( index )
{
	sHeadWearState = index;
	changeHead(sHeadIndex);
}
function changeBodyState( index )
{
	sBodyWearState = index;
	changeBody(sBodyIndex);
}
function changeHeadColor( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	sHeadColor1p = color1;
	sHeadColor2p = color2;
	sHeadColor3p = color3;
	sHeadColor1 = convertColor(color1);
	sHeadColor2 = convertColor(color2);
	sHeadColor3 = convertColor(color3);
	changeHead(sHeadIndex);
	
	addHistoryEquip("headColor", ""+color1+","+color2+","+color3);
}
var kBodyOffset=2;
var sBodyNorm1 = "sCmQ";
var sBodyNorm2 = "sCmQ";
var sBodyNorm3 = "";
var sBodyWearState = 0;
var sBodyColor1 = "zSHA1GaB";
var sBodyColor1p = "1676e1";
var sBodyColor2 = "v;qApL6C";
var sBodyColor2p = "3cc8d5";
var sBodyColor3 = "L26B12aB";
var sBodyColor3p = "4a76a1";
var sBodyIndex = 157;
function getBodyScript( index )
{
	var script="";
	index = parseInt(index);
	index+=kBodyOffset;
	if(index>=0)
	{
		if(index<sBodyArray.length && sBodyArray[index][0])
		{
			sBodyIndex = index-kBodyOffset;
			sBodyNorm1 = sBodyArray[index][2];
			sBodyNorm2 = sBodyArray[index][3];
			sBodyNorm3 = sBodyArray[index][4];
			if (sBodyNorm3 == "UB2O") {
				controller.bodyState.style.visibility = "visible";
			} else {
				controller.bodyState.style.visibility = "hidden";
			}
			if( sRobeIndex==-1 )
			{
				script = "gNKEPQKH2A2O1QqPU428"+sBodyArray[index][1]+"U428"+sBodyColor1+"V;aCU428"+sBodyColor2+"W;aCU428"+sBodyColor3+"X;aCU428"+"kY38s73CXj3A062B"+"U438";
			}
		}
	}
	index-=kBodyOffset;
	return script;
}
function getBodyStateScript()
{
	var script = "";
	
	if (sBodyNorm3 == "UB2O") {
		script = "PQKHmE4O8MrPtPrI0O6RopaEcDGS"
		if (sBodyWearState == 1) {
			script += ";rKRRIrPUzbQZxKMEw7PZxKMkCWQ";
		} else {
			script += "ilqMI5LNg;6QIwKPg;6Q85LP";
		}
	} else {
		script = "PQKHmE4O8MrPtPrI0O6RopaEcDGS"+sWeaponHandStateArray[sWeaponHandState];
	}
	
	//if (sFramework == 0 || sFramework == 1) {
	//	script = "PQKHmE4O8MrPtPrI0O6RopaEcDGS"+sWeaponHandStateArray[sWeaponHandState];
	//} else {
	//	script = "PQKHmE4O8MrPtPrI0O6RopaEcDGS"+sWeaponHandStateArray[0];
	//}
	
	return script;
}
function getBodyNormScript()
{
	if(sRobeIndex == -1) {
		script = "PQKHmE4O8MrP2oaHUAGPgpKMU428"+sBodyNorm1;
	} else {
		script = "PQKHmE4O8MrP2oaHUAGPgpKMU428"+"0B2P";
	}
	script += "k1W2"+"PQKHmE4O8MrP2oaHiAGPAkqPU428"+sBodyNorm2;
	return script;
}
function changeBody( index )
{
	var script = getBodyScript(index);
	script += "O1W2"+getFootScript(sFootIndex);
	script += "O1W2"+getHandScript(sHandIndex);
	script += "O1W2"+getHandStateScript();
	script += "O1W2"+getHeadStateScript(sHeadIndex);
	script += "O1W2"+getBodyNormScript();
	script += "O1W2"+getBodyStateScript();
	csExecute(script);
	
	checkResetCount();
	
	addHistoryEquip("body");
}
function changeBodyColor( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	sBodyColor1p = color1;
	sBodyColor2p = color2;
	sBodyColor3p = color3;
	sBodyColor1 = convertColor(color1);
	sBodyColor2 = convertColor(color2);
	sBodyColor3 = convertColor(color3);
	changeBody(sBodyIndex);
	
	addHistoryEquip("bodyColor", ""+color1+","+color2+","+color3);
}
var sFootWearType = 0;
var sFootColor1 = "zSHA1GaB";
var sFootColor1p = "1676e1";
var sFootColor2 = "v;qApL6C";
var sFootColor2p = "3cc8d5";
var sFootColor3 = "L26B12aB";
var sFootColor3p = "4a76a1";
var sFootIndex = 13;
function getFootScript( index )
{
	var script="";
	if(index>=0 && index<sFootArray.length && sFootArray[index][0])
	{
		sFootIndex = index;
		script = "gNKEPQKH6A2OAkqPU428"+sFootArray[index][1]+"U428"+sFootColor1+"V;bCU428"+sFootColor2+"W;bCU428"+sFootColor3+"X;bCU428"+"kY38s73Cnj3A062B"+"U838";
		if (sRobeIndex == -1) { //ローブで靴が飛び出る対策(ローブがあるときは MeshGroupNorm Foot を l に)
			script += "k1W2"+"PQKHmE4O8MrP2oaHiAGPAkqPU428"+sBodyNorm2;
		} else {
			sBodyNorm2 = "0B2P8dE3";
			script += "k1W2"+"PQKHmE4O8MrP2oaHiAGPAkqPU428"+sBodyNorm2;
		}
	}
	else if(index == -1)
	{
	}
	return script;
}
function changeFoot( index )
{
	sFootIndex = index;
	csReset();

	checkResetCount();

	//var script = getFootScript(index);
	//script += "O1W2"+getFootScript(sFootIndex);
	//csExecute(script);
	
	addHistoryEquip("foot");
}
function changeFootColor( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	sFootColor1p = color1;
	sFootColor2p = color2;
	sFootColor3p = color3;
	sFootColor1 = convertColor(color1);
	sFootColor2 = convertColor(color2);
	sFootColor3 = convertColor(color3);
	script = getFootScript(sFootIndex);
	csExecute(script);
	
	addHistoryEquip("footColor", ""+color1+","+color2+","+color3);
}
var sHandWearType = 0;
var sHandColor1 = "zSHA1GaB";
var sHandColor1p = "1676e1";
var sHandColor2 = "v;qApL6C";
var sHandColor2p = "3cc8d5";
var sHandColor3 = "L26B12aB";
var sHandColor3p = "4a76a1";
var sHandIndex = -1;
function getHandScript( index )
{
	var script="";
	if(index>=0 && index<sHandArray.length && sHandArray[index][0])
	{
		sHandIndex = index;
		script = "gNKEPQKH8A2OgpKMU428"+sHandArray[index][1]+"U428"+sHandColor1+"V;bCU428"+sHandColor2+"W;bCU428"+sHandColor3+"X;bCU428"+"kY38s73Cnj3A062B"+"UA38";
	}
	else if(index == -1)
	{
		sHandIndex = -1;
	}
	return script;
}
function getHandStateScript()
{
	var script = "";
	//script = "PQKHmE4O8MrPtPrI0O6RiA6G0A2N"+sWeaponHandStateArray[sWeaponHandState];
	
	//if (sFramework == 0 || sFramework == 1) {
		script = "PQKHmE4O8MrPtPrI0O6RiA6G0A2N"+sWeaponHandStateArray[sWeaponHandState];
	//} else {
	//	script = "PQKHmE4O8MrPtPrI0O6RiA6G0A2N"+sWeaponHandStateArray[0];
	//}
	
	return script;
}
function changeHand( index )
{
	if(index>=0 && index<sHandArray.length && sHandArray[index][0])
	{
		var script = getHandScript(index);
		script += "k1W2"+getHandStateScript();
		script += "k1W2"+getBodyNormScript();
		script += "k1W2"+getRobeStateScript(sRobeWearType);
		csExecute(script);
		
		checkResetCount();
	}
	else if (index == -1)
	{
		sHandIndex = -1;
		csReset();
	}
	
	addHistoryEquip("hand");
}
function changeHandColor( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	sHandColor1p = color1;
	sHandColor2p = color2;
	sHandColor3p = color3;
	sHandColor1 = convertColor(color1);
	sHandColor2 = convertColor(color2);
	sHandColor3 = convertColor(color3);
	script = getHandScript(sHandIndex);
	script += "k1W2"+getHandStateScript();
	script += "k1W2"+getBodyNormScript();
	csExecute(script);
	
	addHistoryEquip("handColor", ""+color1+","+color2+","+color3);
}
var sRobeWearTypeArray = new Array(new Array("j9682PaR"),new Array("p528T0aP2PaR"),new Array(""));
var sRobeWearType = 0;
var sRobeColor1 = "zSHA1GaB";
var sRobeColor1p = "1676e1";
var sRobeColor2 = "v;qApL6C";
var sRobeColor2p = "3cc8d5";
var sRobeColor3 = "L26B12aB";
var sRobeColor3p = "4a76a1";
var sRobeIndex = -1;
function getRobeScript( index )
{
	var script="";
	if(index>=0 && index<sRobeArray.length && sRobeArray[index][0])
	{
		sRobeIndex = index;
		controller.robeState.style.visibility = "visible";
		script = "gNKEPQKHBA2OwpKM0N6P"+sRobeArray[index][1]+"U428"+sRobeColor1+"V;aCU428"+sRobeColor2+"W;aCU428"+sRobeColor3+"X;aCU428"+"kY38s73CXj3A062B"+"UA38";
		//script = "gNKEPQKHBA2OwpKM0N6P"+sRobeArray[index][1]+"U428"+sRobeColor1+"V;aCU428"+sRobeColor2+"W;aCU428"+sRobeColor3+"X;aCU428"+"kY38s73CXj3A062BU838";
	}
	else if(index == -1)
	{
		controller.robeState.style.visibility = "hidden";
		sRobeIndex = -1;
	}
	return script;
}
function changeRobe( index )
{
	if(index>=0 && index<sRobeArray.length && sRobeArray[index][0])
	{
		sRobeIndex = index;
		//var script="";
		//script = getRobeScript(index);
		//csExecute(script);
		csReset();
		
		checkResetCount();
	}
	else if( index == -1 )
	{
		sRobeIndex = -1;
		//var script="";
		//script = getRobeScript(index);
		//csExecute(script);
		csReset();
		
		checkResetCount();
	}
	
	addHistoryEquip("robe");
}
function getRobeStateScript( index )
{
	var script="";
	if((index<0) || (index>=sRobeWearTypeArray.length))
	index = 0;
	if(sRobeIndex != -1)
	{
		sRobeWearType = index;
		//script = "PQKHmE4O8MrPtPrI0O6R6AKH5z6RU428"+sRobeWearTypeArray[sRobeWearType][0];
		script = "PQKHmE4O8MrPtPrI0O6R6AKH5z6R"+sRobeWearTypeArray[sRobeWearType][0];
		var handStateIndex = 0;
		if(sHandIndex == -1)
		handStateIndex = sWeaponHandState;
		else
		{
			handStateIndex = sWeaponHandState+(sHandArray[sHandIndex][2]*4)
		}
		//script += sWeaponHandStateArray[handStateIndex]+":k08";
		script += sWeaponHandStateArray[0]+":k08";
	}
	return script;
}
function changeRobeState( index )
{
	if(index>=0 && index<sRobeWearTypeArray.length)
	{
		var script="";
		sRobeWearType = index;
		if(sRobeIndex != -1)
		{
			script = getRobeStateScript(index);
			if (index==0) {
				changeHead(-2);
			} else {
				changeHead(sHeadIndex);
			}
			changeHair(sHairIndex);
			csExecute(script);
		}
	}
}
function changeRobeColor( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	sRobeColor1p = color1;
	sRobeColor2p = color2;
	sRobeColor3p = color3;
	sRobeColor1 = convertColor(color1);
	sRobeColor2 = convertColor(color2);
	sRobeColor3 = convertColor(color3);
	script = getRobeScript(sRobeIndex);
	script += "O1W2U428"+getRobeStateScript(sRobeWearType);
	csExecute(script);
	
	addHistoryEquip("robeColor", ""+color1+","+color2+","+color3);
}
var sWeaponWearTypeArray = new Array("kCWQ","8AGN","sCmQ","057P","0N6P");
var sWeaponHandStateArray = new Array(
	"1C7TAs6P1C7TGs6P",
	"1C7TAs6P9K6TeTrQ",
	"9K6ToTrQ1C7TGs6P",
	"9K6ToTrQ9K6TeTrQ",
	"1C7TAs6P",
	"1C7TAs6P",
	"9K6ToTrQ",
	"9K6ToTrQ",
	"1C7TGs6P",
	"9K6TeTrQ",
	"1C7TGs6P",
	"9K6TeTrQ",
	"ilqMI5LNg;6QIwKPg;6Q85LP",
	"",
	"",
""
);
var sWeaponHandState = 0;
var sWeaponFirstColor1 = "zSHA1GaB";
var sWeaponFirstColor1p = "1676e1";
var sWeaponFirstColor2 = "v;qApL6C";
var sWeaponFirstColor2p = "3cc8d5";
var sWeaponFirstColor3 = "L26B12aB";
var sWeaponFirstColor3p = "4a76a1";
var sWeaponSecondColor1 = "zSHA1GaB";
var sWeaponSecondColor1p = "1676e1";
var sWeaponSecondColor2 = "v;qApL6C";
var sWeaponSecondColor2p = "3cc8d5";
var sWeaponSecondColor3 = "L26B12aB";
var sWeaponSecondColor3p = "4a76a1";
var sWeaponFirstIndex = -1;
var sWeaponFirstWearState = 0;
var sWeaponSecondIndex = -1;
var sWeaponSecondWearState = 0;
function getWeaponFirstScript( index )
{
	var script="";
	if(index>=0 && index<sWeaponArray.length && sWeaponArray[index][0])
	{
		sWeaponFirstIndex = index;
		script = "gNKEPQKHLA2OM9KNyoqPv4LO0C2R"+sWeaponArray[index][1]+"U428"+sWeaponFirstColor1+"V;bCU428"+sWeaponFirstColor2+"W;bCU428"+sWeaponFirstColor3+"X;bCU428"+"kY38s73Cnj3A062B"+"UA38";
		controller.weaponFirstState.style.visibility = "visible";
	}
	else if (index == -1)
	{
		sWeaponFirstIndex = -1;
		sWeaponHandState = 0;
		controller.weaponFirstState.style.visibility = "hidden";
	}
	return script;
}
function getWeaponFirstStateScript( index )
{
	var script = "";
	if(index<0 || index>=sWeaponWearTypeArray.length)
	index = 0;
	if( sWeaponFirstIndex != -1 )
	{
		script = "PQKHmE4O8MrPtPrI0O6RNTqJin6Q2haFsSrQ"+sWeaponWearTypeArray[index];
	}
	else if(sWeaponFirstIndex == -1)
	{
		script = "PQKHmE4O8MrPtPrI0O6RNTqJin6Q2haFsSrQsCmQ";
	}
	return script;
}
function changeWeaponFirst( index )
{
	var script = "";
	script = getWeaponFirstScript(index);
	script += "k1W2"+getWeaponFirstStateScript(sWeaponFirstWearState);
	script += "k1W2"+getBodyStateScript();
	csExecute(script);
	
	checkResetCount();
	
	addHistoryEquip("weaponFirst");
}
function changeWeaponFirstState( index )
{
	sWeaponFirstWearState = index;
	changeWeaponFirst(sWeaponFirstIndex);
}
function changeWeaponFirstColor( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	sWeaponFirstColor1p = color1;
	sWeaponFirstColor2p = color2;
	sWeaponFirstColor3p = color3;
	sWeaponFirstColor1 = convertColor(color1);
	sWeaponFirstColor2 = convertColor(color2);
	sWeaponFirstColor3 = convertColor(color3);
	changeWeaponFirst(sWeaponFirstIndex);
	
	addHistoryEquip("weaponFirstColor", ""+color1+","+color2+","+color3);
}
function getWeaponSecondScript( index )
{
	var script="";
	if(index>=0 && index<sWeaponArray.length && sWeaponArray[index][0])
	{
		sWeaponSecondIndex = index;
		script = "gNKEPQKHLA2OM9KNfoqP71KNERaP"+sWeaponArray[index][1]+"U428"+sWeaponSecondColor1+"V;bCU428"+sWeaponSecondColor2+"W;bCU428"+sWeaponSecondColor3+"X;bCU428"+"kY38s73Cnj3A062B"+"UA38";
		controller.weaponSecondState.style.visibility = "visible";
	}
	else if (index == -1)
	{
		sWeaponSecondIndex = -1;
		controller.weaponSecondState.style.visibility = "hidden";
	}
	return script;
}
function getWeaponSecondStateScript( index )
{
	var script = "";
	if(index<0 || index>=sWeaponWearTypeArray.length)
	index = 0;
	if( sWeaponSecondIndex != -1 )
	{
		//script = "PQKHmE4O8MrPtPrI0O6RNTqJin6QvTqIQoqPU428"+sWeaponWearTypeArray[index];
		//script = "PQKHmE4O8MrPtPrI0O6RNTqJin6QvTqIQoqPU428"+sWeaponWearTypeArray[1];
		script = "PQKHmE4O8MrPtPrI0O6RNTqJin6QvTqIQoqPU428"+sWeaponWearTypeArray[1];
	}
	else if(sWeaponSecondIndex == -1)
	{
		script = "PQKHmE4O8MrPtPrI0O6RNTqJin6QvTqIQoqPU878";
	}
	return script;
}
function changeWeaponSecond( index )
{
	var script = "";
	script = getWeaponSecondScript(index);
	script += "k1W2"+getWeaponSecondStateScript(sWeaponSecondWearState);
	csExecute(script);
	
	checkResetCount();
	
	addHistoryEquip("weaponSecond");
}
function changeWeaponSecondState( index )
{
	sWeaponSecondWearState = index;
	changeWeaponSecond(sWeaponSecondIndex);
}
function changeWeaponSecondColor( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	sWeaponSecondColor1p = color1;
	sWeaponSecondColor2p = color2;
	sWeaponSecondColor3p = color3;
	sWeaponSecondColor1 = convertColor(color1);
	sWeaponSecondColor2 = convertColor(color2);
	sWeaponSecondColor3 = convertColor(color3);
	changeWeaponSecond(sWeaponSecondIndex);
	
	addHistoryEquip("weaponSecondColor", ""+color1+","+color2+","+color3);
}
var sShieldWearTypeArray = new Array("kCWQ","8AGN","sCmQ","057P","0N6P");
var sShieldFirstColor1 = "zSHA1GaB";
var sShieldFirstColor1p = "1676e1";
var sShieldFirstColor2 = "v;qApL6C";
var sShieldFirstColor2p = "3cc8d5";
var sShieldFirstColor3 = "L26B12aB";
var sShieldFirstColor3p = "4a76a1";
var sShieldSecondColor1 = "zSHA1GaB";
var sShieldSecondColor1p = "1676e1";
var sShieldSecondColor2 = "v;qApL6C";
var sShieldSecondColor2p = "3cc8d5";
var sShieldSecondColor3 = "L26B12aB";
var sShieldSecondColor3p = "4a76a1";
var sShieldFirstIndex = -1;
var sShieldFirstWearState = 1;
var sShieldSecondIndex = -1;
var sShieldSecondWearState = 1;
function getShieldFirstScript( index )
{
	var script="";
	if(index>=0 && index<sShieldArray.length && sShieldArray[index][0])
	{
		sShieldFirstIndex = index;
		script = "gNKEPQKHHA2OZc6OaQ6Pv4LO0C2R"+sShieldArray[index][1]+"U428"+sShieldFirstColor1+"V;bCU428"+sShieldFirstColor2+"W;bCU428"+sShieldFirstColor3+"X;bCU428"+"kY38s73Cnj3A062B"+"UA38";
		controller.shieldFirstState.style.visibility = "visible";
	}
	else if (index == -1)
	{
		sShieldFirstIndex = -1;
		controller.shieldFirstState.style.visibility = "hidden";
	}
	return script;
}
function getShieldFirstStateScript( index )
{
	var script="";
	if(index<0 || index>=sShieldWearTypeArray.length)
	index = 0;
	if( sShieldFirstIndex != -1 )
	{
		script = "PQKHmE4O8MrPtPrI0O6RlfqIAxKN2haFsSrQ"+sShieldWearTypeArray[index];
		//script = "PQKHmE4O8MrPtPrI0O6RlfqIAxKN2haFsSrQ"+sShieldWearTypeArray[sShieldArray[sShieldFirstIndex][2]];
	}
	else if(sShieldFirstIndex == -1)
	{
		script = "PQKHmE4O8MrPtPrI0O6RlfqIAxKN2haFsSrQsCmQ";
	}
	return script;
}
function changeShieldFirst( index )
{
	var script = "";
	script = getShieldFirstScript(index);
	script += "k1W2"+getShieldFirstStateScript(sShieldFirstWearState);
	csExecute(script);
	
	checkResetCount();
	
	addHistoryEquip("shieldFirst");
}
function changeShieldFirstState( index )
{
	sShieldFirstWearState = index;
	changeShieldFirst(sShieldFirstIndex);
}
function changeShieldFirstColor( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	sShieldFirstColor1p = color1;
	sShieldFirstColor2p = color2;
	sShieldFirstColor3p = color3;
	sShieldFirstColor1 = convertColor(color1);
	sShieldFirstColor2 = convertColor(color2);
	sShieldFirstColor3 = convertColor(color3);
	changeShieldFirst(sShieldFirstIndex);
	
	addHistoryEquip("shieldFirstColor", ""+color1+","+color2+","+color3);
}
function getShieldSecondScript( index )
{
	var script="";
	if(index>=0 && index<sShieldArray.length && sShieldArray[index][0])
	{
		sShieldSecondIndex = index;
		script = "gNKEPQKHHA2OZc6OnQ6P71KNERaP"+sShieldArray[index][1]+"U428"+sShieldSecondColor1+"V;bCU428"+sShieldSecondColor2+"W;bCU428"+sShieldSecondColor3+"X;bCU428"+"kY38s73Cnj3A062B"+"UA38";
		controller.shieldSecondState.style.visibility = "visible";
	}
	else if (index == -1)
	{
		sShieldSecondIndex = -1;
		controller.shieldSecondState.style.visibility = "hidden";
	}
	return script;
}
function getShieldSecondStateScript( index )
{
	var script="";
	if(index<0 || index>=sShieldWearTypeArray.length)
	index = 0;
	if( sShieldSecondIndex != -1 )
	{
		//script = "PQKHmE4O8MrPtPrI0O6RlfqIAxKNvTqIQoqPU428"+sShieldWearTypeArray[index];
		//script = "PQKHmE4O8MrPtPrI0O6RlfqIAxKNvTqIQoqPU428"+sShieldWearTypeArray[sShieldArray[sShieldSecondIndex][2]+1];
		script = "PQKHmE4O8MrPtPrI0O6RlfqIAxKNvTqIQoqPU428"+sShieldWearTypeArray[1];
	}
	else if(sShieldSecondIndex == -1)
	{
		script = "PQKHmE4O8MrPtPrI0O6RlfqIAxKNvTqIQoqPU878";
	}
	return script;
}
function changeShieldSecond( index )
{
	var script = "";
	script = getShieldSecondScript(index);
	script += "k1W2"+getShieldSecondStateScript(sShieldSecondWearState);
	csExecute(script);
	
	checkResetCount();
	
	addHistoryEquip("shieldSecond");
}
function changeShieldSecondState( index )
{
	sShieldSecondWearState = index;
	changeShieldSecond(sShieldSecondIndex);
}
function changeShieldSecondColor( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	sShieldSecondColor1p = color1;
	sShieldSecondColor2p = color2;
	sShieldSecondColor3p = color3;
	sShieldSecondColor1 = convertColor(color1);
	sShieldSecondColor2 = convertColor(color2);
	sShieldSecondColor3 = convertColor(color3);
	changeShieldSecond(sShieldSecondIndex);
	
	addHistoryEquip("shieldSecondColor", ""+color1+","+color2+","+color3);
}
var sHairColor = "V2XAV4nE";
var sHairColorp = "211C39";
var sHairIndex = 4;
var sHairColorIndex = 1;
function getHairScript( index )
{
	var script = "";
	if(index>=0 && index<sHairArray.length && sHairArray[index][0])
	{
		sHairIndex = index;
		script = "gNKEPQKH8A2OudKMU428"+sHairArray[index][1]+"U428"+sHairColor+"laaCc5LOk63Ak63Ak438k63As62Aka3AU73C"+"U62A";
	}
	return script;
}
function changeHair( index )
{
	if(index>=0 && index<sHairArray.length && sHairArray[index][0])
	{
		var script = "";
		script = getHairScript( index );
		script += "k1W2"+getHeadStateScript( sHeadIndex );
		csExecute(script);
		
		//checkResetCount();
		
		addHistoryEquip("hair");
	}
}
function changeHairColor( index )
{
	if(index>=0 && index<sHairColorArray.length && sHairColorArray[index][0])
	{
		sHairColor = sHairColorArray[index][1];
		sHairColorp = sHairColorArray[index][2];
		setPaletteColor(hairPalette,sHairColorp);
		controller.hairColor.value = sHairColorp;
		sHairColorIndex = index;
		changeHair(sHairIndex);
		
		addHistoryEquip("hairColor");
	}
}
function changeHairColorCustom( color )
{
	sHairColorp = color;
	sHairColor = convertColor(color);
	controller.hairColorMenu.value = -1;
	changeHair(sHairIndex);
}
var sEyeColor = "V2XAV4nE";
var sEyeColorp = "211C39";
var sEyeEmotionIndex = 3;
var sEyeColorIndex = 2;
function getEyeGrid()
{
	script = "BhLFF1rFFA2N36WBk6WA";
	
	//script = "BhLFF1rFIA2Nm838";
	//script = "BhLFF1rFMA2Nm838";
	return script;
}
function getEyeEmotionScript( index )
{
	var script = "";
	if(index>=0 && index<sEyeEmotionArray.length && sEyeEmotionArray[index][0])
	{
		sEyeEmotionIndex = index;
		script += "k1W2"+sEyeEmotionArray[index][1];
	}
	return script;
}
function changeEyeEmotion( index )
{
	var script = "";
	script = getEyeEmotionScript(index);
	script += "k1W2"+getReactionScript(sReactionIndex);
	csExecute(script);
	
	addHistoryEquip("eyeEmotion");
}
function getEyeColorScript( )
{
	var script = "";
	{
		script = "gTqILtqFw9aMopqEM5rP8AGN"+sEyeColor;
	}
	return script;
}
function changeEyeColor( index )
{
	if(index>=0 && index<sEyeColorArray.length && sEyeColorArray[index][0])
	{
		var script = "";
		sEyeColor = sEyeColorArray[index][1];
		sEyeColorp = sEyeColorArray[index][2];
		script = getEyeColorScript();
		setPaletteColor(eyePalette,sEyeColorp);
		controller.eyeColor.value = sEyeColorp;
		script += "k1W2"+getFaceScript(sFaceIndex);
		script += "k1W2"+getReactionScript(sReactionIndex);
		sEyeColorIndex = index;
		csExecute(script);
		
		addHistoryEquip("eyeColor");
	}
}
function changeEyeColorCustom( color )
{
	var script = "";
	sEyeColorp = color;
	sEyeColor = convertColor(color);
	controller.eyeColorMenu.value = -1;
	script = getEyeColorScript();
	script += "k1W2"+getFaceScript(sFaceIndex);
	script += "k1W2"+getReactionScript(sReactionIndex);
	csExecute(script);
}
var sMouthEmotionIndex = 1;
function getMouthGrid()
{
	script = "RoKHbj6RofaQUY385SHAk1W2";
	return script;
}
function getMouthEmotionScript( index )
{
	var script = "";
	if(index>=0 && index<sMouthEmotionArray.length && sMouthEmotionArray[index][0])
	{
		sMouthEmotionIndex = index;
		script = sMouthEmotionArray[index][1]+'sAa2jpKM5NKNFQrPMpqPk62A';
	}
	return script;
}
function changeMouthEmotion( index )
{
	if(index>=0 && index<sMouthEmotionArray.length && sMouthEmotionArray[index][0])
	{
		var script = "";
		script = getMouthEmotionScript(index);
		script += "k1W2"+getReactionScript(sReactionIndex);
		csExecute(script);
		
		addHistoryEquip("mouthEmotion");
	}
}
var sSkinColor = "qJXFRLoA";
var sSkinColorp = "F7F3DE";
var sSkinColorIndex = 1;
function getSkinColorScript( index )
{
	var script = "";
	//{
		script = "gTqILtqFw9aMopqEM5rPlXqQEBWP"+sSkinColorArray[index][1];
	//}
	return script;
}
function changeSkinColor( index )
{
	if(index>=0 && index<sSkinColorArray.length && sSkinColorArray[index][0])
	{
		var script = "";
		sSkinColor = sSkinColorArray[index][1];
		sSkinColorp = sSkinColorArray[index][2];
		setPaletteColor(skinPalette,sSkinColorp);
		controller.skinColor.value = sSkinColorp;
		csReset();
		sSkinColorIndex = index;
		//script = getSkinColorScript( index );
		//csExecute(script);
		
		addHistoryEquip("skinColor");
	}
}
function changeSkinColorCustom( color )
{
	sSkinColorp = color;
	sSkinColor = convertColor(color);
	controller.skinColorMenu.value = -1;
	csReset();

	//var script = "";
	//script = getSkinColorScript( index );
	//script = "pAZ2AH4RN4qPD04PGk6Pf978cpKO"+sSkinColor;
	//csExecute(script);
}
var sFaceIndex = 0;
var sFaceColor1 = "k63Ak63A";
var sFaceColor2 = "k63Ak63A";
var sFaceColor3 = "k63Ak63A";
var sFaceColor1p = "000000";
var sFaceColor2p = "000000";
var sFaceColor3p = "000000";
function getFaceScript( index )
{
	var script = "";
	if(index>=0 && index<sFaceArray.length && sFaceArray[index][0])
	{
		script = "gNKEPQKH6A2Oh1KMU428"+sFaceArray[index][1]+"U428"+sFaceColor1+"laaCc5LO"+sFaceColor2+"U428"+sFaceColor3+"U838";
	}
	return script;
}
function changeFace( index )
{
	if(index>=0 && index<sFaceArray.length && sFaceArray[index][0])
	{
		var script = "";
		sFaceIndex = index;
		script = getFaceScript(index);
		script += "k1W2"+getHeadStateScript(sHeadIndex);
		script += "k1W2"+getEyeEmotionScript(sEyeEmotionIndex);
		script += "k1W2"+getMouthEmotionScript(sMouthEmotionIndex);
		script += "k1W2"+getReactionScript(sReactionIndex);
		csExecute(script);
		
		checkResetCount();
		
		addHistoryEquip("face");
	}
}
var sReactionIndex = 0;
function getReactionScript( index )
{
	var script="";
	if (index >= 0) {
		if (sReactionArray[index][0]) {
			sReactionIndex = index;
			script = sReactionArray[index][1];
		}
	}
	return script;
}
function changeReaction( index )
{
	if(index>=0 && index<sReactionArray.length && sReactionArray[index][0])
	{
		var script = "";
		script = getReactionScript(index);
		csExecute(script);
		
		addHistoryEquip("reaction");
	}
}
var sScaleArray = new Array(new Array("ky2A","0.0"),new Array("ly2A","0.1"),new Array("my2A","0.2"),new Array("ny2A","0.3"),new Array("oy2A","0.4"),new Array("py2A","0.5"),new Array("qy2A","0.6"),new Array("ry2A","0.7"),new Array("sy2A","0.8"),new Array("ty2A","0.9"),new Array("syGAc6GA","1.01"),new Array("tyGA","1.1"),new Array("uyGA","1.2"),new Array("vyGA","1.3"),new Array("wyGA","1.4"),new Array("xyGA","1.5"),new Array("yyGA","1.6"),new Array("zyGA","1.7"),new Array("kyGA","1.8"),new Array("lyGA","1.9"),new Array("UyWA","2.0"));
var sHeightScale = "syGA";
var sFatnessScale = "syGA";
var sTopScale = "syGA";
var sBottomScale = "syGA";
var sHeightScalep = "1";
var sFatnessScalep = "1";
var sTopScalep = "1";
var sBottomScalep = "1";
function getScaleScript( height, fatness, top, bottom )
{
	script = 'gPqQt3qQ0N6P'+height+"U428"+fatness+"U428"+top+"U428"+bottom;
	return script;
}
function changeScale( height, fatness, top, bottom )
{
	var script = getScaleScript( height, fatness, top, bottom );
	csExecute(script);
}
function changeScaleByMenu()
{
	sHeightScale = sScaleArray[controller.heightSelector.value][0];
	sHeightScalep = sScaleArray[controller.heightSelector.value][1];
	sFatnessScale = sScaleArray[controller.fatnessSelector.value][0];
	sFatnessScalep = sScaleArray[controller.fatnessSelector.value][1];
	sTopScale = sScaleArray[controller.topSelector.value][0];
	sTopScalep = sScaleArray[controller.topSelector.value][1];
	sBottomScale = sScaleArray[controller.bottomSelector.value][0];
	sBottomScalep = sScaleArray[controller.bottomSelector.value][1];
	changeScale( sHeightScale, sFatnessScale, sTopScale, sBottomScale );
	
	addHistoryEquip("scale", controller.heightSelector.value+","+controller.fatnessSelector.value+","+controller.topSelector.value+","+controller.bottomSelector.value);
}
var sAnimationIndex = 0;
var sAnimationFrame = "81H;";
var sAnimationFramep = -1;
var sAnimationAnimateState = 0;
var sAnimationCurFrame = 0;
var sAnimationUIFrame = 0;
var sAnimationUISubFrame = 0;
var sAnimationUISuperSubFrame = 0;
function initAnimator()
{
	if(sAnimationFramep!=-1)
	{
		sAnimationCurFrame = sAnimationFramep;
		if(sAnimatorPlayingState==0)
		{
			setAnimateState(1);
			setAnimatorSliders(sAnimationFramep);
		}
		else if (sAnimatorPlayingState==1)
		{
			sAnimatorPlayingState = 0;
			slowmotionBackward();
		}
		else if (sAnimatorPlayingState==2)
		{
			sAnimatorPlayingState = 0;
			slowmotionForward();
		}
		else if (sAnimatorPlayingState==3)
		{
			sAnimatorPlayingState = 0;
			scanBackward();
		}
		else if (sAnimatorPlayingState==4)
		{
			sAnimatorPlayingState = 0;
			scanForward();
		}
	}
}
function setAnimatorSliders( frameIndex )
{
	if((kFrameSliderRange*kMainFrameSliderScale)>=frameIndex && frameIndex >= 0)
	{
		curFrame = frameIndex;
		subFrameSliderFillValue = kSubFrameSliderScale;
		mainFrameSliderFillValue = kMainFrameSliderScale;
		mainFrameSliderValue = Math.floor(curFrame/mainFrameSliderFillValue);
		curFrame -= mainFrameSliderValue*mainFrameSliderFillValue;
		subFrameSliderValue = Math.floor(curFrame/subFrameSliderFillValue);
		curFrame -= subFrameSliderValue*subFrameSliderFillValue;
		superSubFrameSliderValue = curFrame;
		sAnimationUIFrame = mainFrameSliderValue*kMainFrameSliderScale;
		sAnimationUISubFrame = subFrameSliderValue*kSubFrameSliderScale;
		sAnimationUISuperSubFrame = superSubFrameSliderValue;
		controller.mainFrameSliderTip.style.left = mainFrameSliderValue;
		controller.subFrameSliderTip.style.left = subFrameSliderValue;
		controller.superSubFrameSliderTip.style.left = superSubFrameSliderValue;
	}
}
function getAnimationScript( index )
{
	var script = "";
	if(index>=0 && index<sAnimationArray.length && sAnimationArray[index][0])
	{
		sAnimationIndex = index;
		sWeaponHandState = sAnimationArray[sAnimationIndex][2];
		script = "gNKEVlKEQ8KPakKOU428"+sAnimationArray[index][1]+"U428i168PYEOdRLNRcaPVRLMMpqPVpKM"+"U428"+sAnimationFrame;
	}
	return script;
}
function changeAnimation( index )
{
	var script = "";
	script = getAnimationScript(index);
	script += "k1W2"+getHandStateScript();
	script += "k1W2"+getBodyStateScript();
	script += "k1W2"+getRobeStateScript(sRobeWearType);
	script += "k1W2"+getBodyNormScript();
	csExecute(script);
	
	addHistoryEquip("animation");
}
function toggleAnimate()
{
	if(sAnimationAnimateState==0)
	setAnimateState(1);
	else if(sAnimationAnimateState==1)
	setAnimateState(0);
	else if(sAnimationAnimateState==2)
	setAnimateState(1);
}
function resetFrame()
{
	if(sAnimationAnimateState==0)
	setAnimateState(1);
	sAnimationCurFrame = 0;
	changeAnimationFrame(0);
	setAnimatorSliders(sAnimationCurFrame);
	updateLinks();
}
function stepBackward()
{
	if(sAnimationAnimateState!=1)
	setAnimateState(1);
	if(sAnimationCurFrame==0)
	return;
	changeAnimationFrame(sAnimationCurFrame-1);
	setAnimatorSliders(sAnimationCurFrame);
}
function stepForward()
{
	if(sAnimationAnimateState!=1)
	setAnimateState(1);
	changeAnimationFrame(sAnimationCurFrame+1);
	setAnimatorSliders(sAnimationCurFrame);
}
var sAnimatorTimer;
var sAnimatorPlayingState = 0;
function slowmotionBackward()
{
	if(sAnimatorPlayingState==1)
	{
		sAnimatorPlayingState = 0;
		setAnimateState(1);
		return;
	}
	setAnimateState(2);
	controller.slowmotionBackwardButton.src = " slowmotionbackwardactive.png";
	sAnimatorPlayingState = 1;
	updateLinks();
	sAnimatorTimer = setInterval("backwardPlayer()",1);
}
function backwardPlayer()
{
	if(sAnimationCurFrame<kSubFrameSliderScale)
	{
		setAnimateState(1);
		return;
	}
	changeAnimationFrame(sAnimationCurFrame-2);
	setAnimatorSliders(sAnimationCurFrame);
}
function scanBackward()
{
	if(sAnimatorPlayingState==3)
	{
		sAnimatorPlayingState = 0;
		setAnimateState(1);
		return;
	}
	setAnimateState(2);
	controller.scanBackwardButton.src = " scanbackwardactive.png";
	sAnimatorPlayingState = 3;
	updateLinks();
	sAnimatorTimer = setInterval("backwardScanPlayer()",1);
}
function backwardScanPlayer()
{
	if(sAnimationCurFrame<kSubFrameSliderScale)
	{
		setAnimateState(1);
		return;
	}
	changeAnimationFrame(sAnimationCurFrame-kMainFrameSliderScale);
	setAnimatorSliders(sAnimationCurFrame);
}
function slowmotionForward()
{
	if(sAnimatorPlayingState==2)
	{
		sAnimatorPlayingState = 0;
		setAnimateState(1);
		return;
	}
	setAnimateState(2);
	controller.slowmotionForwardButton.src = " slowmotionforwardactive.png";
	sAnimatorPlayingState = 2;
	updateLinks();
	sAnimatorTimer = setInterval("forwardPlayer()",1);
}
function forwardPlayer()
{
	if(sAnimationCurFrame>kFrameSliderRange*kMainFrameSliderScale)
	{
		setAnimateState(1);
		return;
	}
	changeAnimationFrame(sAnimationCurFrame+2);
	setAnimatorSliders(sAnimationCurFrame);
}
function scanForward()
{
	if(sAnimatorPlayingState==4)
	{
		sAnimatorPlayingState = 0;
		setAnimateState(1);
		return;
	}
	setAnimateState(2);
	controller.scanForwardButton.src = " scanforwardactive.png";
	sAnimatorPlayingState = 4;
	updateLinks();
	sAnimatorTimer = setInterval("forwardScanPlayer()",1);
}
function forwardScanPlayer()
{
	if(sAnimationCurFrame>kFrameSliderRange*kMainFrameSliderScale)
	{
		setAnimateState(1);
		return;
	}
	changeAnimationFrame(sAnimationCurFrame+kMainFrameSliderScale);
	setAnimatorSliders(sAnimationCurFrame);
}
function setAnimateState( state )
{
	if(sAnimationAnimateState==2)
	{
		controller.slowmotionBackwardButton.src = " slowmotionbackward.png";
		controller.scanBackwardButton.src = " scanbackward.png";
		controller.slowmotionForwardButton.src = " slowmotionforward.png";
		controller.scanForwardButton.src = " scanforward.png";
		clearInterval(sAnimatorTimer);
		setAnimatorSliders(sAnimationCurFrame);
		sAnimatorPlayingState = 0;
	}
	if(state==0)	//animator disabled, normal motion
	{
		controller.playButton.src = " stop.png";
		sAnimationFrame = "81H;";
		csExecute("gTqIVlKEQ8KPakKOi168ZBGOc6GA");
	}
	else if(state==1)	//animator enabled, user controlling
	{
		controller.playButton.src = " play.png";
		changeAnimationFrame(sAnimationCurFrame);
	}
	else if(state==2)	//animator enabled, animator controlling
	{
		controller.playButton.src = " pause.png";
		changeAnimationFrame(sAnimationCurFrame);
	}
	sAnimationAnimateState = state;
	updateLinks();
}
var sAnimationFrameArray0 = new Array("k63A","l63A","m63A","n63A","o63A","p63A","q63A","r63A","s63A","t63A","k23A","l23A","m23A","n23A","o23A","p23A","q23A","r23A","s23A","t23A","kC3A","lC3A","mC3A","nC3A","oC3A","pC3A","qC3A","rC3A","sC3A","tC3A","k:3A","l:3A","m:3A","n:3A","o:3A","p:3A","q:3A","r:3A","s:3A","t:3A","kK3A","lK3A","mK3A","nK3A","oK3A","pK3A","qK3A","rK3A","sK3A","tK3A","kG3A","lG3A","mG3A","nG3A","oG3A","pG3A","qG3A","rG3A","sG3A","tG3A","kS3A","lS3A","mS3A","nS3A","oS3A","pS3A","qS3A","rS3A","sS3A","tS3A","kO3A","lO3A","mO3A","nO3A","oO3A","pO3A","qO3A","rO3A","sO3A","tO3A","ka3A","la3A","ma3A","na3A","oa3A","pa3A","qa3A","ra3A","sa3A","ta3A","kW3A","lW3A","mW3A","nW3A","oW3A","pW3A","qW3A","rW3A","sW3A","tW3A","s6HA","t6HA","u6HA","v6HA","w6HA","x6HA","y6HA","z6HA","k6HA","l6HA","s2HA","t2HA","u2HA","v2HA","w2HA","x2HA","y2HA","z2HA","k2HA","l2HA","sCHA","tCHA","uCHA","vCHA","wCHA","xCHA","yCHA","zCHA","kCHA","lCHA","s:HA","t:HA","u:HA","v:HA","w:HA","x:HA","y:HA","z:HA","k:HA","l:HA","sKHA","tKHA","uKHA","vKHA","wKHA","xKHA","yKHA","zKHA","kKHA","lKHA","sGHA","tGHA","uGHA","vGHA","wGHA","xGHA","yGHA","zGHA","kGHA","lGHA","sSHA","tSHA","uSHA","vSHA","wSHA","xSHA","ySHA","zSHA","kSHA","lSHA","sOHA","tOHA","uOHA","vOHA","wOHA","xOHA","yOHA","zOHA","kOHA","lOHA","saHA","taHA","uaHA","vaHA","waHA","xaHA","yaHA","zaHA","kaHA","laHA","sWHA","tWHA","uWHA","vWHA","wWHA","xWHA","yWHA","zWHA","kWHA","lWHA","U6XA","V6XA","W6XA","X6XA","Y6XA","Z6XA","a6XA","b6XA","c6XA","d6XA","U2XA","V2XA","W2XA","X2XA","Y2XA","Z2XA","a2XA","b2XA","c2XA","d2XA","UCXA","VCXA","WCXA","XCXA","YCXA","ZCXA","aCXA","bCXA","cCXA","dCXA","U:XA","V:XA","W:XA","X:XA","Y:XA","Z:XA","a:XA","b:XA","c:XA","d:XA","UKXA","VKXA","WKXA","XKXA","YKXA","ZKXA","aKXA","bKXA","cKXA","dKXA","UGXA","VGXA","WGXA","XGXA","YGXA","ZGXA","aGXA","bGXA","cGXA","dGXA","USXA","VSXA","WSXA","XSXA","YSXA","ZSXA","aSXA","bSXA","cSXA","dSXA","UOXA","VOXA","WOXA","XOXA","YOXA","ZOXA","aOXA","bOXA","cOXA","dOXA","UaXA","VaXA","WaXA","XaXA","YaXA","ZaXA","aaXA","baXA","caXA","daXA","UWXA","VWXA","WWXA","XWXA","YWXA","ZWXA","aWXA","bWXA","cWXA","dWXA","c6nA","d6nA","e6nA","f6nA","g6nA","h6nA","i6nA","j6nA","U6nA","V6nA","c2nA","d2nA","e2nA","f2nA","g2nA","h2nA","i2nA","j2nA","U2nA","V2nA","cCnA","dCnA","eCnA","fCnA","gCnA","hCnA","iCnA","jCnA","UCnA","VCnA","c:nA","d:nA","e:nA","f:nA","g:nA","h:nA","i:nA","j:nA","U:nA","V:nA","cKnA","dKnA","eKnA","fKnA","gKnA","hKnA","iKnA","jKnA","UKnA","VKnA","cGnA","dGnA","eGnA","fGnA","gGnA","hGnA","iGnA","jGnA","UGnA","VGnA","cSnA","dSnA","eSnA","fSnA","gSnA","hSnA","iSnA","jSnA","USnA","VSnA","cOnA","dOnA","eOnA","fOnA","gOnA","hOnA","iOnA","jOnA","UOnA","VOnA","canA","danA","eanA","fanA","ganA","hanA","ianA","janA","UanA","VanA","cWnA","dWnA","eWnA","fWnA","gWnA","hWnA","iWnA","jWnA","UWnA","VWnA","E63B","F63B","G63B","H63B","I63B","J63B","K63B","L63B","M63B","N63B","E23B","F23B","G23B","H23B","I23B","J23B","K23B","L23B","M23B","N23B","EC3B","FC3B","GC3B","HC3B","IC3B","JC3B","KC3B","LC3B","MC3B","NC3B","E:3B","F:3B","G:3B","H:3B","I:3B","J:3B","K:3B","L:3B","M:3B","N:3B","EK3B","FK3B","GK3B","HK3B","IK3B","JK3B","KK3B","LK3B","MK3B","NK3B","EG3B","FG3B","GG3B","HG3B","IG3B","JG3B","KG3B","LG3B","MG3B","NG3B","ES3B","FS3B","GS3B","HS3B","IS3B","JS3B","KS3B","LS3B","MS3B","NS3B","EO3B","FO3B","GO3B","HO3B","IO3B","JO3B","KO3B","LO3B","MO3B","NO3B","Ea3B","Fa3B","Ga3B","Ha3B","Ia3B","Ja3B","Ka3B","La3B","Ma3B","Na3B","EW3B","FW3B","GW3B","HW3B","IW3B","JW3B","KW3B","LW3B","MW3B","NW3B","M6HB","N6HB","O6HB","P6HB","Q6HB","R6HB","S6HB","T6HB","E6HB","F6HB","M2HB","N2HB","O2HB","P2HB","Q2HB","R2HB","S2HB","T2HB","E2HB","F2HB","MCHB","NCHB","OCHB","PCHB","QCHB","RCHB","SCHB","TCHB","ECHB","FCHB","M:HB","N:HB","O:HB","P:HB","Q:HB","R:HB","S:HB","T:HB","E:HB","F:HB","MKHB","NKHB","OKHB","PKHB","QKHB","RKHB","SKHB","TKHB","EKHB","FKHB","MGHB","NGHB","OGHB","PGHB","QGHB","RGHB","SGHB","TGHB","EGHB","FGHB","MSHB","NSHB","OSHB","PSHB","QSHB","RSHB","SSHB","TSHB","ESHB","FSHB","MOHB","NOHB","OOHB","POHB","QOHB","ROHB","SOHB","TOHB","EOHB","FOHB","MaHB","NaHB","OaHB","PaHB","QaHB","RaHB","SaHB","TaHB","EaHB","FaHB","MWHB","NWHB","OWHB","PWHB","QWHB","RWHB","SWHB","TWHB","EWHB","FWHB","06XB","16XB","26XB","36XB","46XB","56XB","66XB","76XB","86XB","96XB","02XB","12XB","22XB","32XB","42XB","52XB","62XB","72XB","82XB","92XB","0CXB","1CXB","2CXB","3CXB","4CXB","5CXB","6CXB","7CXB","8CXB","9CXB","0:XB","1:XB","2:XB","3:XB","4:XB","5:XB","6:XB","7:XB","8:XB","9:XB","0KXB","1KXB","2KXB","3KXB","4KXB","5KXB","6KXB","7KXB","8KXB","9KXB","0GXB","1GXB","2GXB","3GXB","4GXB","5GXB","6GXB","7GXB","8GXB","9GXB","0SXB","1SXB","2SXB","3SXB","4SXB","5SXB","6SXB","7SXB","8SXB","9SXB","0OXB","1OXB","2OXB","3OXB","4OXB","5OXB","6OXB","7OXB","8OXB","9OXB","0aXB","1aXB","2aXB","3aXB","4aXB","5aXB","6aXB","7aXB","8aXB","9aXB","0WXB","1WXB","2WXB","3WXB","4WXB","5WXB","6WXB","7WXB","8WXB","9WXB","86nB","96nB",":6nB",";6nB","A6nB","B6nB","C6nB","D6nB","06nB","16nB","82nB","92nB",":2nB",";2nB","A2nB","B2nB","C2nB","D2nB","02nB","12nB","8CnB","9CnB",":CnB",";CnB","ACnB","BCnB","CCnB","DCnB","0CnB","1CnB","8:nB","9:nB","::nB",";:nB","A:nB","B:nB","C:nB","D:nB","0:nB","1:nB","8KnB","9KnB",":KnB",";KnB","AKnB","BKnB","CKnB","DKnB","0KnB","1KnB","8GnB","9GnB",":GnB",";GnB","AGnB","BGnB","CGnB","DGnB","0GnB","1GnB","8SnB","9SnB",":SnB",";SnB","ASnB","BSnB","CSnB","DSnB","0SnB","1SnB","8OnB","9OnB",":OnB",";OnB","AOnB","BOnB","COnB","DOnB","0OnB","1OnB","8anB","9anB",":anB",";anB","AanB","BanB","CanB","DanB","0anB","1anB","8WnB","9WnB",":WnB",";WnB","AWnB","BWnB","CWnB","DWnB","0WnB","1WnB","k73C","l73C","m73C","n73C","o73C","p73C","q73C","r73C","s73C","t73C","k33C","l33C","m33C","n33C","o33C","p33C","q33C","r33C","s33C","t33C","kD3C","lD3C","mD3C","nD3C","oD3C","pD3C","qD3C","rD3C","sD3C","tD3C","k;3C","l;3C","m;3C","n;3C","o;3C","p;3C","q;3C","r;3C","s;3C","t;3C","kL3C","lL3C","mL3C","nL3C","oL3C","pL3C","qL3C","rL3C","sL3C","tL3C","kH3C","lH3C","mH3C","nH3C","oH3C","pH3C","qH3C","rH3C","sH3C","tH3C","kT3C","lT3C","mT3C","nT3C","oT3C","pT3C","qT3C","rT3C","sT3C","tT3C","kP3C","lP3C","mP3C","nP3C","oP3C","pP3C","qP3C","rP3C","sP3C","tP3C","kb3C","lb3C","mb3C","nb3C","ob3C","pb3C","qb3C","rb3C","sb3C","tb3C","kX3C","lX3C","mX3C","nX3C","oX3C","pX3C","qX3C","rX3C","sX3C","tX3C","s7HC","t7HC","u7HC","v7HC","w7HC","x7HC","y7HC","z7HC","k7HC","l7HC","s3HC","t3HC","u3HC","v3HC","w3HC","x3HC","y3HC","z3HC","k3HC","l3HC","sDHC","tDHC","uDHC","vDHC","wDHC","xDHC","yDHC","zDHC","kDHC","lDHC","s;HC","t;HC","u;HC","v;HC","w;HC","x;HC","y;HC","z;HC","k;HC","l;HC","sLHC","tLHC","uLHC","vLHC","wLHC","xLHC","yLHC","zLHC","kLHC","lLHC","sHHC","tHHC","uHHC","vHHC","wHHC","xHHC","yHHC","zHHC","kHHC","lHHC","sTHC","tTHC","uTHC","vTHC","wTHC","xTHC","yTHC","zTHC","kTHC","lTHC","sPHC","tPHC","uPHC","vPHC","wPHC","xPHC","yPHC","zPHC","kPHC","lPHC","sbHC","tbHC","ubHC","vbHC","wbHC","xbHC","ybHC","zbHC","kbHC","lbHC","sXHC","tXHC","uXHC","vXHC","wXHC","xXHC","yXHC","zXHC","kXHC","lXHC");
var sAnimationFrameArray1 = new Array("k63A","l63A","m63A","n63A","o63A","p63A","q63A","r63A","s63A","t63A","k23A","l23A","m23A","n23A","o23A","p23A","q23A","r23A","s23A","t23A","kC3A","lC3A","mC3A","nC3A","oC3A","pC3A","qC3A","rC3A","sC3A","tC3A","k:3A","l:3A","m:3A","n:3A","o:3A","p:3A","q:3A","r:3A","s:3A","t:3A","kK3A","lK3A","mK3A","nK3A","oK3A","pK3A","qK3A","rK3A","sK3A","tK3A","kG3A","lG3A","mG3A","nG3A","oG3A","pG3A","qG3A","rG3A","sG3A","tG3A","kS3A","lS3A","mS3A","nS3A","oS3A","pS3A","qS3A","rS3A","sS3A","tS3A","kO3A","lO3A","mO3A","nO3A","oO3A","pO3A","qO3A","rO3A","sO3A","tO3A","ka3A","la3A","ma3A","na3A","oa3A","pa3A","qa3A","ra3A","sa3A","ta3A","kW3A","lW3A","mW3A","nW3A","oW3A","pW3A","qW3A","rW3A","sW3A","tW3A","s6HA","t6HA","u6HA","v6HA","w6HA","x6HA","y6HA","z6HA","k6HA","l6HA","s2HA","t2HA","u2HA","v2HA","w2HA","x2HA","y2HA","z2HA","k2HA","l2HA","sCHA","tCHA","uCHA","vCHA","wCHA","xCHA","yCHA","zCHA","kCHA","lCHA","s:HA","t:HA","u:HA","v:HA","w:HA","x:HA","y:HA","z:HA","k:HA","l:HA","sKHA","tKHA","uKHA","vKHA","wKHA","xKHA","yKHA","zKHA","kKHA","lKHA","sGHA","tGHA","uGHA","vGHA","wGHA","xGHA","yGHA","zGHA","kGHA","lGHA","sSHA","tSHA","uSHA","vSHA","wSHA","xSHA","ySHA","zSHA","kSHA","lSHA","sOHA","tOHA","uOHA","vOHA","wOHA","xOHA","yOHA","zOHA","kOHA","lOHA","saHA","taHA","uaHA","vaHA","waHA","xaHA","yaHA","zaHA","kaHA","laHA","sWHA","tWHA","uWHA","vWHA","wWHA","xWHA","yWHA","zWHA","kWHA","lWHA","U6XA","V6XA","W6XA","X6XA","Y6XA","Z6XA","a6XA","b6XA","c6XA","d6XA","U2XA","V2XA","W2XA","X2XA","Y2XA","Z2XA","a2XA","b2XA","c2XA","d2XA","UCXA","VCXA","WCXA","XCXA","YCXA","ZCXA","aCXA","bCXA","cCXA","dCXA","U:XA","V:XA","W:XA","X:XA","Y:XA","Z:XA","a:XA","b:XA","c:XA","d:XA","UKXA","VKXA","WKXA","XKXA","YKXA","ZKXA","aKXA","bKXA","cKXA","dKXA","UGXA","VGXA","WGXA","XGXA","YGXA","ZGXA","aGXA","bGXA","cGXA","dGXA","USXA","VSXA","WSXA","XSXA","YSXA","ZSXA","aSXA","bSXA","cSXA","dSXA","UOXA","VOXA","WOXA","XOXA","YOXA","ZOXA","aOXA","bOXA","cOXA","dOXA","UaXA","VaXA","WaXA","XaXA","YaXA","ZaXA","aaXA","baXA","caXA","daXA","UWXA","VWXA","WWXA","XWXA","YWXA","ZWXA","aWXA","bWXA","cWXA","dWXA","c6nA","d6nA","e6nA","f6nA","g6nA","h6nA","i6nA","j6nA","U6nA","V6nA","c2nA","d2nA","e2nA","f2nA","g2nA","h2nA","i2nA","j2nA","U2nA","V2nA","cCnA","dCnA","eCnA","fCnA","gCnA","hCnA","iCnA","jCnA","UCnA","VCnA","c:nA","d:nA","e:nA","f:nA","g:nA","h:nA","i:nA","j:nA","U:nA","V:nA","cKnA","dKnA","eKnA","fKnA","gKnA","hKnA","iKnA","jKnA","UKnA","VKnA","cGnA","dGnA","eGnA","fGnA","gGnA","hGnA","iGnA","jGnA","UGnA","VGnA","cSnA","dSnA","eSnA","fSnA","gSnA","hSnA","iSnA","jSnA","USnA","VSnA","cOnA","dOnA","eOnA","fOnA","gOnA","hOnA","iOnA","jOnA","UOnA","VOnA","canA","danA","eanA","fanA","ganA","hanA","ianA","janA","UanA","VanA","cWnA","dWnA","eWnA","fWnA","gWnA","hWnA","iWnA","jWnA","UWnA","VWnA","E63B","F63B","G63B","H63B","I63B","J63B","K63B","L63B","M63B","N63B","E23B","F23B","G23B","H23B","I23B","J23B","K23B","L23B","M23B","N23B","EC3B","FC3B","GC3B","HC3B","IC3B","JC3B","KC3B","LC3B","MC3B","NC3B","E:3B","F:3B","G:3B","H:3B","I:3B","J:3B","K:3B","L:3B","M:3B","N:3B","EK3B","FK3B","GK3B","HK3B","IK3B","JK3B","KK3B","LK3B","MK3B","NK3B","EG3B","FG3B","GG3B","HG3B","IG3B","JG3B","KG3B","LG3B","MG3B","NG3B","ES3B","FS3B","GS3B","HS3B","IS3B","JS3B","KS3B","LS3B","MS3B","NS3B","EO3B","FO3B","GO3B","HO3B","IO3B","JO3B","KO3B","LO3B","MO3B","NO3B","Ea3B","Fa3B","Ga3B","Ha3B","Ia3B","Ja3B","Ka3B","La3B","Ma3B","Na3B","EW3B","FW3B","GW3B","HW3B","IW3B","JW3B","KW3B","LW3B","MW3B","NW3B","M6HB","N6HB","O6HB","P6HB","Q6HB","R6HB","S6HB","T6HB","E6HB","F6HB","M2HB","N2HB","O2HB","P2HB","Q2HB","R2HB","S2HB","T2HB","E2HB","F2HB","MCHB","NCHB","OCHB","PCHB","QCHB","RCHB","SCHB","TCHB","ECHB","FCHB","M:HB","N:HB","O:HB","P:HB","Q:HB","R:HB","S:HB","T:HB","E:HB","F:HB","MKHB","NKHB","OKHB","PKHB","QKHB","RKHB","SKHB","TKHB","EKHB","FKHB","MGHB","NGHB","OGHB","PGHB","QGHB","RGHB","SGHB","TGHB","EGHB","FGHB","MSHB","NSHB","OSHB","PSHB","QSHB","RSHB","SSHB","TSHB","ESHB","FSHB","MOHB","NOHB","OOHB","POHB","QOHB","ROHB","SOHB","TOHB","EOHB","FOHB","MaHB","NaHB","OaHB","PaHB","QaHB","RaHB","SaHB","TaHB","EaHB","FaHB","MWHB","NWHB","OWHB","PWHB","QWHB","RWHB","SWHB","TWHB","EWHB","FWHB","06XB","16XB","26XB","36XB","46XB","56XB","66XB","76XB","86XB","96XB","02XB","12XB","22XB","32XB","42XB","52XB","62XB","72XB","82XB","92XB","0CXB","1CXB","2CXB","3CXB","4CXB","5CXB","6CXB","7CXB","8CXB","9CXB","0:XB","1:XB","2:XB","3:XB","4:XB","5:XB","6:XB","7:XB","8:XB","9:XB","0KXB","1KXB","2KXB","3KXB","4KXB","5KXB","6KXB","7KXB","8KXB","9KXB","0GXB","1GXB","2GXB","3GXB","4GXB","5GXB","6GXB","7GXB","8GXB","9GXB","0SXB","1SXB","2SXB","3SXB","4SXB","5SXB","6SXB","7SXB","8SXB","9SXB","0OXB","1OXB","2OXB","3OXB","4OXB","5OXB","6OXB","7OXB","8OXB","9OXB","0aXB","1aXB","2aXB","3aXB","4aXB","5aXB","6aXB","7aXB","8aXB","9aXB","0WXB","1WXB","2WXB","3WXB","4WXB","5WXB","6WXB","7WXB","8WXB","9WXB","86nB","96nB",":6nB",";6nB","A6nB","B6nB","C6nB","D6nB","06nB","16nB","82nB","92nB",":2nB",";2nB","A2nB","B2nB","C2nB","D2nB","02nB","12nB","8CnB","9CnB",":CnB",";CnB","ACnB","BCnB","CCnB","DCnB","0CnB","1CnB","8:nB","9:nB","::nB",";:nB","A:nB","B:nB","C:nB","D:nB","0:nB","1:nB","8KnB","9KnB",":KnB",";KnB","AKnB","BKnB","CKnB","DKnB","0KnB","1KnB","8GnB","9GnB",":GnB",";GnB","AGnB","BGnB","CGnB","DGnB","0GnB","1GnB","8SnB","9SnB",":SnB",";SnB","ASnB","BSnB","CSnB","DSnB","0SnB","1SnB","8OnB","9OnB",":OnB",";OnB","AOnB","BOnB","COnB","DOnB","0OnB","1OnB","8anB","9anB",":anB",";anB","AanB","BanB","CanB","DanB","0anB","1anB","8WnB","9WnB",":WnB",";WnB","AWnB","BWnB","CWnB","DWnB","0WnB","1WnB","k73C","l73C","m73C","n73C","o73C","p73C","q73C","r73C","s73C","t73C","k33C","l33C","m33C","n33C","o33C","p33C","q33C","r33C","s33C","t33C","kD3C","lD3C","mD3C","nD3C","oD3C","pD3C","qD3C","rD3C","sD3C","tD3C","k;3C","l;3C","m;3C","n;3C","o;3C","p;3C","q;3C","r;3C","s;3C","t;3C","kL3C","lL3C","mL3C","nL3C","oL3C","pL3C","qL3C","rL3C","sL3C","tL3C","kH3C","lH3C","mH3C","nH3C","oH3C","pH3C","qH3C","rH3C","sH3C","tH3C","kT3C","lT3C","mT3C","nT3C","oT3C","pT3C","qT3C","rT3C","sT3C","tT3C","kP3C","lP3C","mP3C","nP3C","oP3C","pP3C","qP3C","rP3C","sP3C","tP3C","kb3C","lb3C","mb3C","nb3C","ob3C","pb3C","qb3C","rb3C","sb3C","tb3C","kX3C","lX3C","mX3C","nX3C","oX3C","pX3C","qX3C","rX3C","sX3C","tX3C","s7HC","t7HC","u7HC","v7HC","w7HC","x7HC","y7HC","z7HC","k7HC","l7HC","s3HC","t3HC","u3HC","v3HC","w3HC","x3HC","y3HC","z3HC","k3HC","l3HC","sDHC","tDHC","uDHC","vDHC","wDHC","xDHC","yDHC","zDHC","kDHC","lDHC","s;HC","t;HC","u;HC","v;HC","w;HC","x;HC","y;HC","z;HC","k;HC","l;HC","sLHC","tLHC","uLHC","vLHC","wLHC","xLHC","yLHC","zLHC","kLHC","lLHC","sHHC","tHHC","uHHC","vHHC","wHHC","xHHC","yHHC","zHHC","kHHC","lHHC","sTHC","tTHC","uTHC","vTHC","wTHC","xTHC","yTHC","zTHC","kTHC","lTHC","sPHC","tPHC","uPHC","vPHC","wPHC","xPHC","yPHC","zPHC","kPHC","lPHC","sbHC","tbHC","ubHC","vbHC","wbHC","xbHC","ybHC","zbHC","kbHC","lbHC","sXHC","tXHC","uXHC","vXHC","wXHC","xXHC","yXHC","zXHC","kXHC","lXHC");
function getAnimationFrame( index )
{
	resFrame = "U62A";
	index0 = 0;
	index1 = 0;
	index2 = 0;
	index3 = 0;
	if(index<0)
	return resFrame;
	if(index<100000)//9.9999
	{
		index1 = Math.floor(index/1000);
		index0 = index%1000;
		resFrame = sAnimationFrameArray1[index1]+sAnimationFrameArray0[index0];
	}
	else if(index<100000000)//9999.9999
	{
		index2 = Math.floor(index/100000);
		index -= index2*100000;
		index1 = Math.floor(index/1000);
		index0 = index%1000;
		resFrame = sAnimationFrameArray0[index2]+sAnimationFrameArray1[index1]+sAnimationFrameArray0[index0];
	}
	else if(index<100000000000)//9999999.9999
	{
		index3 = Math.floor(index/100000000);
		index -= index3*100000000;
		index2 = Math.floor(index/100000);
		index -= index2*100000;
		index1 = Math.floor(index/1000);
		index0 = index%1000;
		resFrame = sAnimationFrameArray0[index3]+sAnimationFrameArray0[index2]+sAnimationFrameArray1[index1]+sAnimationFrameArray0[index0];
	}
	return resFrame;
}
function changeAnimationFrame( index )
{
	if(index<0)return;
	sAnimationFramep = sAnimationCurFrame = index;
	sAnimationFrame = getAnimationFrame(index);
	script = "gTqIVlKEQ8KPakKOi168cBGO"+sAnimationFrame;
	//cs.execute = script;
	execute( script );
}
var kFrameSliderRange = 384;
var kFrameSliderMargin = 3;
var kFrameSliderWidth = kFrameSliderRange+kFrameSliderMargin*2;
var kMainFrameSliderScale = 25;
var kSubFrameSliderScale = 5;
function changeAnimationMainFrame()
{
	if(sAnimationAnimateState==0)
	setAnimateState(1);
	controller.subFrameSliderTip.style.left = 0;
	controller.superSubFrameSliderTip.style.left = 0;
	if(event.offsetX<kFrameSliderMargin)
	{
		controller.mainFrameSliderTip.style.left = 0;
		curPos = 0;
	}
	else if(event.offsetX>kFrameSliderWidth-kFrameSliderMargin)
	{
		controller.mainFrameSliderTip.style.left = (kFrameSliderWidth-kFrameSliderMargin*2)-1;
		curPos = (kFrameSliderWidth-kFrameSliderMargin*2)-1;
	}
	else
	{
		controller.mainFrameSliderTip.style.left = event.offsetX-kFrameSliderMargin;
		curPos = event.offsetX-kFrameSliderMargin;
	}
	sAnimationUIFrame = curPos*kMainFrameSliderScale;
	sAnimationUISubFrame = 0;
	sAnimationUISuperSubFrame = 0;
	changeAnimationFrame(sAnimationUIFrame+sAnimationUISubFrame+sAnimationUISuperSubFrame);
}
function changeAnimationMainFrameW()
{
	delta = ((event.wheelDelta>0)?-1:1);
	if(sAnimationAnimateState==0)
	setAnimateState(1);
	changeAnimationFrame(sAnimationCurFrame+(kMainFrameSliderScale*delta));
	setAnimatorSliders(sAnimationCurFrame);
}
function changeAnimationSubFrame()
{
	if(sAnimationAnimateState==0)
	setAnimateState(1);
	if(event.offsetX<kFrameSliderMargin)
	{
		controller.subFrameSliderTip.style.left = 0;
		curPos = 0;
	}
	else if(event.offsetX>kFrameSliderWidth-kFrameSliderMargin)
	{
		controller.subFrameSliderTip.style.left = (kFrameSliderWidth-kFrameSliderMargin*2)-1;
		curPos = (kFrameSliderWidth-kFrameSliderMargin*2)-1;
	}
	else
	{
		controller.subFrameSliderTip.style.left = event.offsetX-kFrameSliderMargin;
		curPos = event.offsetX-kFrameSliderMargin;
	}
	sAnimationUISubFrame = curPos*kSubFrameSliderScale;
	changeAnimationFrame(sAnimationUIFrame+sAnimationUISubFrame+sAnimationUISuperSubFrame);
}
function changeAnimationSubFrameW()
{
	delta = ((event.wheelDelta>0)?-1:1);
	if(sAnimationAnimateState==0)
	setAnimateState(1);
	changeAnimationFrame(sAnimationCurFrame+(kSubFrameSliderScale*delta));
	setAnimatorSliders(sAnimationCurFrame);
}
function changeAnimationSuperSubFrame()
{
	if(sAnimationAnimateState==0)
	setAnimateState(1);
	if(event.offsetX<kFrameSliderMargin)
	{
		controller.superSubFrameSliderTip.style.left = 0;
		curPos = 0;
	}
	else if(event.offsetX>kFrameSliderWidth-kFrameSliderMargin)
	{
		controller.superSubFrameSliderTip.style.left = (kFrameSliderWidth-kFrameSliderMargin*2)-1;
		curPos = (kFrameSliderWidth-kFrameSliderMargin*2)-1;
	}
	else
	{
		controller.superSubFrameSliderTip.style.left = event.offsetX-kFrameSliderMargin;
		curPos = event.offsetX-kFrameSliderMargin;
	}
	sAnimationUISuperSubFrame = curPos;
	changeAnimationFrame(sAnimationUIFrame+sAnimationUISubFrame+sAnimationUISuperSubFrame);
}
function changeAnimationSuperSubFrameW()
{
	delta = ((event.wheelDelta>0)?-1:1);
	if(sAnimationAnimateState==0)
	setAnimateState(1);
	changeAnimationFrame(sAnimationCurFrame+(delta));
	setAnimatorSliders(sAnimationCurFrame);
}
var sColorsArray = new Array("k63A","l63A","m63A","n63A","o63A","p63A","q63A","r63A","s63A","t63A","V73A","W73A","X73A","Y73A","Z73A","a73A","k23A","l23A","m23A","n23A","o23A","p23A","q23A","r23A","s23A","t23A","V33A","W33A","X33A","Y33A","Z33A","a33A","kC3A","lC3A","mC3A","nC3A","oC3A","pC3A","qC3A","rC3A","sC3A","tC3A","VD3A","WD3A","XD3A","YD3A","ZD3A","aD3A","k:3A","l:3A","m:3A","n:3A","o:3A","p:3A","q:3A","r:3A","s:3A","t:3A","V;3A","W;3A","X;3A","Y;3A","Z;3A","a;3A","kK3A","lK3A","mK3A","nK3A","oK3A","pK3A","qK3A","rK3A","sK3A","tK3A","VL3A","WL3A","XL3A","YL3A","ZL3A","aL3A","kG3A","lG3A","mG3A","nG3A","oG3A","pG3A","qG3A","rG3A","sG3A","tG3A","VH3A","WH3A","XH3A","YH3A","ZH3A","aH3A","kS3A","lS3A","mS3A","nS3A","oS3A","pS3A","qS3A","rS3A","sS3A","tS3A","VT3A","WT3A","XT3A","YT3A","ZT3A","aT3A","kO3A","lO3A","mO3A","nO3A","oO3A","pO3A","qO3A","rO3A","sO3A","tO3A","VP3A","WP3A","XP3A","YP3A","ZP3A","aP3A","ka3A","la3A","ma3A","na3A","oa3A","pa3A","qa3A","ra3A","sa3A","ta3A","Vb3A","Wb3A","Xb3A","Yb3A","Zb3A","ab3A","kW3A","lW3A","mW3A","nW3A","oW3A","pW3A","qW3A","rW3A","sW3A","tW3A","VX3A","WX3A","XX3A","YX3A","ZX3A","aX3A","k26A","l26A","m26A","n26A","o26A","p26A","q26A","r26A","s26A","t26A","V36A","W36A","X36A","Y36A","Z36A","a36A","kC6A","lC6A","mC6A","nC6A","oC6A","pC6A","qC6A","rC6A","sC6A","tC6A","VD6A","WD6A","XD6A","YD6A","ZD6A","aD6A","k:6A","l:6A","m:6A","n:6A","o:6A","p:6A","q:6A","r:6A","s:6A","t:6A","V;6A","W;6A","X;6A","Y;6A","Z;6A","a;6A","kK6A","lK6A","mK6A","nK6A","oK6A","pK6A","qK6A","rK6A","sK6A","tK6A","VL6A","WL6A","XL6A","YL6A","ZL6A","aL6A","kG6A","lG6A","mG6A","nG6A","oG6A","pG6A","qG6A","rG6A","sG6A","tG6A","VH6A","WH6A","XH6A","YH6A","ZH6A","aH6A","kS6A","lS6A","mS6A","nS6A","oS6A","pS6A","qS6A","rS6A","sS6A","tS6A","VT6A","WT6A","XT6A","YT6A","ZT6A","aT6A","s6HA","t6HA","u6HA","v6HA","w6HA","x6HA","y6HA","z6HA","k6HA","l6HA","d7HA","e7HA","f7HA","g7HA","h7HA","i7HA","s2HA","t2HA","u2HA","v2HA","w2HA","x2HA","y2HA","z2HA","k2HA","l2HA","d3HA","e3HA","f3HA","g3HA","h3HA","i3HA","sCHA","tCHA","uCHA","vCHA","wCHA","xCHA","yCHA","zCHA","kCHA","lCHA","dDHA","eDHA","fDHA","gDHA","hDHA","iDHA","s:HA","t:HA","u:HA","v:HA","w:HA","x:HA","y:HA","z:HA","k:HA","l:HA","d;HA","e;HA","f;HA","g;HA","h;HA","i;HA","sKHA","tKHA","uKHA","vKHA","wKHA","xKHA","yKHA","zKHA","kKHA","lKHA","dLHA","eLHA","fLHA","gLHA","hLHA","iLHA","sGHA","tGHA","uGHA","vGHA","wGHA","xGHA","yGHA","zGHA","kGHA","lGHA","dHHA","eHHA","fHHA","gHHA","hHHA","iHHA","sSHA","tSHA","uSHA","vSHA","wSHA","xSHA","ySHA","zSHA","kSHA","lSHA","dTHA","eTHA","fTHA","gTHA","hTHA","iTHA","sOHA","tOHA","uOHA","vOHA","wOHA","xOHA","yOHA","zOHA","kOHA","lOHA","dPHA","ePHA","fPHA","gPHA","hPHA","iPHA","saHA","taHA","uaHA","vaHA","waHA","xaHA","yaHA","zaHA","kaHA","laHA","dbHA","ebHA","fbHA","gbHA","hbHA","ibHA","sWHA","tWHA","uWHA","vWHA","wWHA","xWHA","yWHA","zWHA","kWHA","lWHA","dXHA","eXHA","fXHA","gXHA","hXHA","iXHA","s2KA","t2KA","u2KA","v2KA","w2KA","x2KA","y2KA","z2KA","k2KA","l2KA","d3KA","e3KA","f3KA","g3KA","h3KA","i3KA","sCKA","tCKA","uCKA","vCKA","wCKA","xCKA","yCKA","zCKA","kCKA","lCKA","dDKA","eDKA","fDKA","gDKA","hDKA","iDKA","s:KA","t:KA","u:KA","v:KA","w:KA","x:KA","y:KA","z:KA","k:KA","l:KA","d;KA","e;KA","f;KA","g;KA","h;KA","i;KA","sKKA","tKKA","uKKA","vKKA","wKKA","xKKA","yKKA","zKKA","kKKA","lKKA","dLKA","eLKA","fLKA","gLKA","hLKA","iLKA","sGKA","tGKA","uGKA","vGKA","wGKA","xGKA","yGKA","zGKA","kGKA","lGKA","dHKA","eHKA","fHKA","gHKA","hHKA","iHKA","sSKA","tSKA","uSKA","vSKA","wSKA","xSKA","ySKA","zSKA","kSKA","lSKA","dTKA","eTKA","fTKA","gTKA","hTKA","iTKA","U6XA","V6XA","W6XA","X6XA","Y6XA","Z6XA","a6XA","b6XA","c6XA","d6XA","l7XA","m7XA","n7XA","o7XA","p7XA","q7XA","U2XA","V2XA","W2XA","X2XA","Y2XA","Z2XA","a2XA","b2XA","c2XA","d2XA","l3XA","m3XA","n3XA","o3XA","p3XA","q3XA","UCXA","VCXA","WCXA","XCXA","YCXA","ZCXA","aCXA","bCXA","cCXA","dCXA","lDXA","mDXA","nDXA","oDXA","pDXA","qDXA","U:XA","V:XA","W:XA","X:XA","Y:XA","Z:XA","a:XA","b:XA","c:XA","d:XA","l;XA","m;XA","n;XA","o;XA","p;XA","q;XA","UKXA","VKXA","WKXA","XKXA","YKXA","ZKXA","aKXA","bKXA","cKXA","dKXA","lLXA","mLXA","nLXA","oLXA","pLXA","qLXA","UGXA","VGXA","WGXA","XGXA","YGXA","ZGXA","aGXA","bGXA","cGXA","dGXA","lHXA","mHXA","nHXA","oHXA","pHXA","qHXA","USXA","VSXA","WSXA","XSXA","YSXA","ZSXA","aSXA","bSXA","cSXA","dSXA","lTXA","mTXA","nTXA","oTXA","pTXA","qTXA","UOXA","VOXA","WOXA","XOXA","YOXA","ZOXA","aOXA","bOXA","cOXA","dOXA","lPXA","mPXA","nPXA","oPXA","pPXA","qPXA","UaXA","VaXA","WaXA","XaXA","YaXA","ZaXA","aaXA","baXA","caXA","daXA","lbXA","mbXA","nbXA","obXA","pbXA","qbXA","UWXA","VWXA","WWXA","XWXA","YWXA","ZWXA","aWXA","bWXA","cWXA","dWXA","lXXA","mXXA","nXXA","oXXA","pXXA","qXXA","U2aA","V2aA","W2aA","X2aA","Y2aA","Z2aA","a2aA","b2aA","c2aA","d2aA","l3aA","m3aA","n3aA","o3aA","p3aA","q3aA","UCaA","VCaA","WCaA","XCaA","YCaA","ZCaA","aCaA","bCaA","cCaA","dCaA","lDaA","mDaA","nDaA","oDaA","pDaA","qDaA","U:aA","V:aA","W:aA","X:aA","Y:aA","Z:aA","a:aA","b:aA","c:aA","d:aA","l;aA","m;aA","n;aA","o;aA","p;aA","q;aA","UKaA","VKaA","WKaA","XKaA","YKaA","ZKaA","aKaA","bKaA","cKaA","dKaA","lLaA","mLaA","nLaA","oLaA","pLaA","qLaA","UGaA","VGaA","WGaA","XGaA","YGaA","ZGaA","aGaA","bGaA","cGaA","dGaA","lHaA","mHaA","nHaA","oHaA","pHaA","qHaA","USaA","VSaA","WSaA","XSaA","YSaA","ZSaA","aSaA","bSaA","cSaA","dSaA","lTaA","mTaA","nTaA","oTaA","pTaA","qTaA","c6nA","d6nA","e6nA","f6nA","g6nA","h6nA","i6nA","j6nA","U6nA","V6nA","t7nA","u7nA","v7nA","w7nA","x7nA","y7nA","c2nA","d2nA","e2nA","f2nA","g2nA","h2nA","i2nA","j2nA","U2nA","V2nA","t3nA","u3nA","v3nA","w3nA","x3nA","y3nA","cCnA","dCnA","eCnA","fCnA","gCnA","hCnA","iCnA","jCnA","UCnA","VCnA","tDnA","uDnA","vDnA","wDnA","xDnA","yDnA","c:nA","d:nA","e:nA","f:nA","g:nA","h:nA","i:nA","j:nA","U:nA","V:nA","t;nA","u;nA","v;nA","w;nA","x;nA","y;nA","cKnA","dKnA","eKnA","fKnA","gKnA","hKnA","iKnA","jKnA","UKnA","VKnA","tLnA","uLnA","vLnA","wLnA","xLnA","yLnA","cGnA","dGnA","eGnA","fGnA","gGnA","hGnA","iGnA","jGnA","UGnA","VGnA","tHnA","uHnA","vHnA","wHnA","xHnA","yHnA","cSnA","dSnA","eSnA","fSnA","gSnA","hSnA","iSnA","jSnA","USnA","VSnA","tTnA","uTnA","vTnA","wTnA","xTnA","yTnA","cOnA","dOnA","eOnA","fOnA","gOnA","hOnA","iOnA","jOnA","UOnA","VOnA","tPnA","uPnA","vPnA","wPnA","xPnA","yPnA","canA","danA","eanA","fanA","ganA","hanA","ianA","janA","UanA","VanA","tbnA","ubnA","vbnA","wbnA","xbnA","ybnA","cWnA","dWnA","eWnA","fWnA","gWnA","hWnA","iWnA","jWnA","UWnA","VWnA","tXnA","uXnA","vXnA","wXnA","xXnA","yXnA","c2qA","d2qA","e2qA","f2qA","g2qA","h2qA","i2qA","j2qA","U2qA","V2qA","t3qA","u3qA","v3qA","w3qA","x3qA","y3qA","cCqA","dCqA","eCqA","fCqA","gCqA","hCqA","iCqA","jCqA","UCqA","VCqA","tDqA","uDqA","vDqA","wDqA","xDqA","yDqA","c:qA","d:qA","e:qA","f:qA","g:qA","h:qA","i:qA","j:qA","U:qA","V:qA","t;qA","u;qA","v;qA","w;qA","x;qA","y;qA","cKqA","dKqA","eKqA","fKqA","gKqA","hKqA","iKqA","jKqA","UKqA","VKqA","tLqA","uLqA","vLqA","wLqA","xLqA","yLqA","cGqA","dGqA","eGqA","fGqA","gGqA","hGqA","iGqA","jGqA","UGqA","VGqA","tHqA","uHqA","vHqA","wHqA","xHqA","yHqA","cSqA","dSqA","eSqA","fSqA","gSqA","hSqA","iSqA","jSqA","USqA","VSqA","tTqA","uTqA","vTqA","wTqA","xTqA","yTqA","E63B","F63B","G63B","H63B","I63B","J63B","K63B","L63B","M63B","N63B","173B","273B","373B","473B","573B","673B","E23B","F23B","G23B","H23B","I23B","J23B","K23B","L23B","M23B","N23B","133B","233B","333B","433B","533B","633B","EC3B","FC3B","GC3B","HC3B","IC3B","JC3B","KC3B","LC3B","MC3B","NC3B","1D3B","2D3B","3D3B","4D3B","5D3B","6D3B","E:3B","F:3B","G:3B","H:3B","I:3B","J:3B","K:3B","L:3B","M:3B","N:3B","1;3B","2;3B","3;3B","4;3B","5;3B","6;3B","EK3B","FK3B","GK3B","HK3B","IK3B","JK3B","KK3B","LK3B","MK3B","NK3B","1L3B","2L3B","3L3B","4L3B","5L3B","6L3B","EG3B","FG3B","GG3B","HG3B","IG3B","JG3B","KG3B","LG3B","MG3B","NG3B","1H3B","2H3B","3H3B","4H3B","5H3B","6H3B","ES3B","FS3B","GS3B","HS3B","IS3B","JS3B","KS3B","LS3B","MS3B","NS3B","1T3B","2T3B","3T3B","4T3B","5T3B","6T3B","EO3B","FO3B","GO3B","HO3B","IO3B","JO3B","KO3B","LO3B","MO3B","NO3B","1P3B","2P3B","3P3B","4P3B","5P3B","6P3B","Ea3B","Fa3B","Ga3B","Ha3B","Ia3B","Ja3B","Ka3B","La3B","Ma3B","Na3B","1b3B","2b3B","3b3B","4b3B","5b3B","6b3B","EW3B","FW3B","GW3B","HW3B","IW3B","JW3B","KW3B","LW3B","MW3B","NW3B","1X3B","2X3B","3X3B","4X3B","5X3B","6X3B","E26B","F26B","G26B","H26B","I26B","J26B","K26B","L26B","M26B","N26B","136B","236B","336B","436B","536B","636B","EC6B","FC6B","GC6B","HC6B","IC6B","JC6B","KC6B","LC6B","MC6B","NC6B","1D6B","2D6B","3D6B","4D6B","5D6B","6D6B","E:6B","F:6B","G:6B","H:6B","I:6B","J:6B","K:6B","L:6B","M:6B","N:6B","1;6B","2;6B","3;6B","4;6B","5;6B","6;6B","EK6B","FK6B","GK6B","HK6B","IK6B","JK6B","KK6B","LK6B","MK6B","NK6B","1L6B","2L6B","3L6B","4L6B","5L6B","6L6B","EG6B","FG6B","GG6B","HG6B","IG6B","JG6B","KG6B","LG6B","MG6B","NG6B","1H6B","2H6B","3H6B","4H6B","5H6B","6H6B","ES6B","FS6B","GS6B","HS6B","IS6B","JS6B","KS6B","LS6B","MS6B","NS6B","1T6B","2T6B","3T6B","4T6B","5T6B","6T6B","M6HB","N6HB","O6HB","P6HB","Q6HB","R6HB","S6HB","T6HB","E6HB","F6HB","97HB",":7HB",";7HB","A7HB","B7HB","C7HB","M2HB","N2HB","O2HB","P2HB","Q2HB","R2HB","S2HB","T2HB","E2HB","F2HB","93HB",":3HB",";3HB","A3HB","B3HB","C3HB","MCHB","NCHB","OCHB","PCHB","QCHB","RCHB","SCHB","TCHB","ECHB","FCHB","9DHB",":DHB",";DHB","ADHB","BDHB","CDHB","M:HB","N:HB","O:HB","P:HB","Q:HB","R:HB","S:HB","T:HB","E:HB","F:HB","9;HB",":;HB",";;HB","A;HB","B;HB","C;HB","MKHB","NKHB","OKHB","PKHB","QKHB","RKHB","SKHB","TKHB","EKHB","FKHB","9LHB",":LHB",";LHB","ALHB","BLHB","CLHB","MGHB","NGHB","OGHB","PGHB","QGHB","RGHB","SGHB","TGHB","EGHB","FGHB","9HHB",":HHB",";HHB","AHHB","BHHB","CHHB","MSHB","NSHB","OSHB","PSHB","QSHB","RSHB","SSHB","TSHB","ESHB","FSHB","9THB",":THB",";THB","ATHB","BTHB","CTHB","MOHB","NOHB","OOHB","POHB","QOHB","ROHB","SOHB","TOHB","EOHB","FOHB","9PHB",":PHB",";PHB","APHB","BPHB","CPHB","MaHB","NaHB","OaHB","PaHB","QaHB","RaHB","SaHB","TaHB","EaHB","FaHB","9bHB",":bHB",";bHB","AbHB","BbHB","CbHB","MWHB","NWHB","OWHB","PWHB","QWHB","RWHB","SWHB","TWHB","EWHB","FWHB","9XHB",":XHB",";XHB","AXHB","BXHB","CXHB","M2KB","N2KB","O2KB","P2KB","Q2KB","R2KB","S2KB","T2KB","E2KB","F2KB","93KB",":3KB",";3KB","A3KB","B3KB","C3KB","MCKB","NCKB","OCKB","PCKB","QCKB","RCKB","SCKB","TCKB","ECKB","FCKB","9DKB",":DKB",";DKB","ADKB","BDKB","CDKB","M:KB","N:KB","O:KB","P:KB","Q:KB","R:KB","S:KB","T:KB","E:KB","F:KB","9;KB",":;KB",";;KB","A;KB","B;KB","C;KB","MKKB","NKKB","OKKB","PKKB","QKKB","RKKB","SKKB","TKKB","EKKB","FKKB","9LKB",":LKB",";LKB","ALKB","BLKB","CLKB","MGKB","NGKB","OGKB","PGKB","QGKB","RGKB","SGKB","TGKB","EGKB","FGKB","9HKB",":HKB",";HKB","AHKB","BHKB","CHKB","MSKB","NSKB","OSKB","PSKB","QSKB","RSKB","SSKB","TSKB","ESKB","FSKB","9TKB",":TKB",";TKB","ATKB","BTKB","CTKB","06XB","16XB","26XB","36XB","46XB","56XB","66XB","76XB","86XB","96XB","F7XB","G7XB","H7XB","I7XB","J7XB","K7XB","02XB","12XB","22XB","32XB","42XB","52XB","62XB","72XB","82XB","92XB","F3XB","G3XB","H3XB","I3XB","J3XB","K3XB","0CXB","1CXB","2CXB","3CXB","4CXB","5CXB","6CXB","7CXB","8CXB","9CXB","FDXB","GDXB","HDXB","IDXB","JDXB","KDXB","0:XB","1:XB","2:XB","3:XB","4:XB","5:XB","6:XB","7:XB","8:XB","9:XB","F;XB","G;XB","H;XB","I;XB","J;XB","K;XB","0KXB","1KXB","2KXB","3KXB","4KXB","5KXB","6KXB","7KXB","8KXB","9KXB","FLXB","GLXB","HLXB","ILXB","JLXB","KLXB","0GXB","1GXB","2GXB","3GXB","4GXB","5GXB","6GXB","7GXB","8GXB","9GXB","FHXB","GHXB","HHXB","IHXB","JHXB","KHXB","0SXB","1SXB","2SXB","3SXB","4SXB","5SXB","6SXB","7SXB","8SXB","9SXB","FTXB","GTXB","HTXB","ITXB","JTXB","KTXB","0OXB","1OXB","2OXB","3OXB","4OXB","5OXB","6OXB","7OXB","8OXB","9OXB","FPXB","GPXB","HPXB","IPXB","JPXB","KPXB","0aXB","1aXB","2aXB","3aXB","4aXB","5aXB","6aXB","7aXB","8aXB","9aXB","FbXB","GbXB","HbXB","IbXB","JbXB","KbXB","0WXB","1WXB","2WXB","3WXB","4WXB","5WXB","6WXB","7WXB","8WXB","9WXB","FXXB","GXXB","HXXB","IXXB","JXXB","KXXB","02aB","12aB","22aB","32aB","42aB","52aB","62aB","72aB","82aB","92aB","F3aB","G3aB","H3aB","I3aB","J3aB","K3aB","0CaB","1CaB","2CaB","3CaB","4CaB","5CaB","6CaB","7CaB","8CaB","9CaB","FDaB","GDaB","HDaB","IDaB","JDaB","KDaB","0:aB","1:aB","2:aB","3:aB","4:aB","5:aB","6:aB","7:aB","8:aB","9:aB","F;aB","G;aB","H;aB","I;aB","J;aB","K;aB","0KaB","1KaB","2KaB","3KaB","4KaB","5KaB","6KaB","7KaB","8KaB","9KaB","FLaB","GLaB","HLaB","ILaB","JLaB","KLaB","0GaB","1GaB","2GaB","3GaB","4GaB","5GaB","6GaB","7GaB","8GaB","9GaB","FHaB","GHaB","HHaB","IHaB","JHaB","KHaB","0SaB","1SaB","2SaB","3SaB","4SaB","5SaB","6SaB","7SaB","8SaB","9SaB","FTaB","GTaB","HTaB","ITaB","JTaB","KTaB","86nB","96nB",":6nB",";6nB","A6nB","B6nB","C6nB","D6nB","06nB","16nB","N7nB","O7nB","P7nB","Q7nB","R7nB","S7nB","82nB","92nB",":2nB",";2nB","A2nB","B2nB","C2nB","D2nB","02nB","12nB","N3nB","O3nB","P3nB","Q3nB","R3nB","S3nB","8CnB","9CnB",":CnB",";CnB","ACnB","BCnB","CCnB","DCnB","0CnB","1CnB","NDnB","ODnB","PDnB","QDnB","RDnB","SDnB","8:nB","9:nB","::nB",";:nB","A:nB","B:nB","C:nB","D:nB","0:nB","1:nB","N;nB","O;nB","P;nB","Q;nB","R;nB","S;nB","8KnB","9KnB",":KnB",";KnB","AKnB","BKnB","CKnB","DKnB","0KnB","1KnB","NLnB","OLnB","PLnB","QLnB","RLnB","SLnB","8GnB","9GnB",":GnB",";GnB","AGnB","BGnB","CGnB","DGnB","0GnB","1GnB","NHnB","OHnB","PHnB","QHnB","RHnB","SHnB","8SnB","9SnB",":SnB",";SnB","ASnB","BSnB","CSnB","DSnB","0SnB","1SnB","NTnB","OTnB","PTnB","QTnB","RTnB","STnB","8OnB","9OnB",":OnB",";OnB","AOnB","BOnB","COnB","DOnB","0OnB","1OnB","NPnB","OPnB","PPnB","QPnB","RPnB","SPnB","8anB","9anB",":anB",";anB","AanB","BanB","CanB","DanB","0anB","1anB","NbnB","ObnB","PbnB","QbnB","RbnB","SbnB","8WnB","9WnB",":WnB",";WnB","AWnB","BWnB","CWnB","DWnB","0WnB","1WnB","NXnB","OXnB","PXnB","QXnB","RXnB","SXnB","82qB","92qB",":2qB",";2qB","A2qB","B2qB","C2qB","D2qB","02qB","12qB","N3qB","O3qB","P3qB","Q3qB","R3qB","S3qB","8CqB","9CqB",":CqB",";CqB","ACqB","BCqB","CCqB","DCqB","0CqB","1CqB","NDqB","ODqB","PDqB","QDqB","RDqB","SDqB","8:qB","9:qB","::qB",";:qB","A:qB","B:qB","C:qB","D:qB","0:qB","1:qB","N;qB","O;qB","P;qB","Q;qB","R;qB","S;qB","8KqB","9KqB",":KqB",";KqB","AKqB","BKqB","CKqB","DKqB","0KqB","1KqB","NLqB","OLqB","PLqB","QLqB","RLqB","SLqB","8GqB","9GqB",":GqB",";GqB","AGqB","BGqB","CGqB","DGqB","0GqB","1GqB","NHqB","OHqB","PHqB","QHqB","RHqB","SHqB","8SqB","9SqB",":SqB",";SqB","ASqB","BSqB","CSqB","DSqB","0SqB","1SqB","NTqB","OTqB","PTqB","QTqB","RTqB","STqB","k73C","l73C","m73C","n73C","o73C","p73C","q73C","r73C","s73C","t73C","V63C","W63C","X63C","Y63C","Z63C","a63C","k33C","l33C","m33C","n33C","o33C","p33C","q33C","r33C","s33C","t33C","V23C","W23C","X23C","Y23C","Z23C","a23C","kD3C","lD3C","mD3C","nD3C","oD3C","pD3C","qD3C","rD3C","sD3C","tD3C","VC3C","WC3C","XC3C","YC3C","ZC3C","aC3C","k;3C","l;3C","m;3C","n;3C","o;3C","p;3C","q;3C","r;3C","s;3C","t;3C","V:3C","W:3C","X:3C","Y:3C","Z:3C","a:3C","kL3C","lL3C","mL3C","nL3C","oL3C","pL3C","qL3C","rL3C","sL3C","tL3C","VK3C","WK3C","XK3C","YK3C","ZK3C","aK3C","kH3C","lH3C","mH3C","nH3C","oH3C","pH3C","qH3C","rH3C","sH3C","tH3C","VG3C","WG3C","XG3C","YG3C","ZG3C","aG3C","kT3C","lT3C","mT3C","nT3C","oT3C","pT3C","qT3C","rT3C","sT3C","tT3C","VS3C","WS3C","XS3C","YS3C","ZS3C","aS3C","kP3C","lP3C","mP3C","nP3C","oP3C","pP3C","qP3C","rP3C","sP3C","tP3C","VO3C","WO3C","XO3C","YO3C","ZO3C","aO3C","kb3C","lb3C","mb3C","nb3C","ob3C","pb3C","qb3C","rb3C","sb3C","tb3C","Va3C","Wa3C","Xa3C","Ya3C","Za3C","aa3C","kX3C","lX3C","mX3C","nX3C","oX3C","pX3C","qX3C","rX3C","sX3C","tX3C","VW3C","WW3C","XW3C","YW3C","ZW3C","aW3C","k36C","l36C","m36C","n36C","o36C","p36C","q36C","r36C","s36C","t36C","V26C","W26C","X26C","Y26C","Z26C","a26C","kD6C","lD6C","mD6C","nD6C","oD6C","pD6C","qD6C","rD6C","sD6C","tD6C","VC6C","WC6C","XC6C","YC6C","ZC6C","aC6C","k;6C","l;6C","m;6C","n;6C","o;6C","p;6C","q;6C","r;6C","s;6C","t;6C","V:6C","W:6C","X:6C","Y:6C","Z:6C","a:6C","kL6C","lL6C","mL6C","nL6C","oL6C","pL6C","qL6C","rL6C","sL6C","tL6C","VK6C","WK6C","XK6C","YK6C","ZK6C","aK6C","kH6C","lH6C","mH6C","nH6C","oH6C","pH6C","qH6C","rH6C","sH6C","tH6C","VG6C","WG6C","XG6C","YG6C","ZG6C","aG6C","kT6C","lT6C","mT6C","nT6C","oT6C","pT6C","qT6C","rT6C","sT6C","tT6C","VS6C","WS6C","XS6C","YS6C","ZS6C","aS6C","s7HC","t7HC","u7HC","v7HC","w7HC","x7HC","y7HC","z7HC","k7HC","l7HC","d6HC","e6HC","f6HC","g6HC","h6HC","i6HC","s3HC","t3HC","u3HC","v3HC","w3HC","x3HC","y3HC","z3HC","k3HC","l3HC","d2HC","e2HC","f2HC","g2HC","h2HC","i2HC","sDHC","tDHC","uDHC","vDHC","wDHC","xDHC","yDHC","zDHC","kDHC","lDHC","dCHC","eCHC","fCHC","gCHC","hCHC","iCHC","s;HC","t;HC","u;HC","v;HC","w;HC","x;HC","y;HC","z;HC","k;HC","l;HC","d:HC","e:HC","f:HC","g:HC","h:HC","i:HC","sLHC","tLHC","uLHC","vLHC","wLHC","xLHC","yLHC","zLHC","kLHC","lLHC","dKHC","eKHC","fKHC","gKHC","hKHC","iKHC","sHHC","tHHC","uHHC","vHHC","wHHC","xHHC","yHHC","zHHC","kHHC","lHHC","dGHC","eGHC","fGHC","gGHC","hGHC","iGHC","sTHC","tTHC","uTHC","vTHC","wTHC","xTHC","yTHC","zTHC","kTHC","lTHC","dSHC","eSHC","fSHC","gSHC","hSHC","iSHC","sPHC","tPHC","uPHC","vPHC","wPHC","xPHC","yPHC","zPHC","kPHC","lPHC","dOHC","eOHC","fOHC","gOHC","hOHC","iOHC","sbHC","tbHC","ubHC","vbHC","wbHC","xbHC","ybHC","zbHC","kbHC","lbHC","daHC","eaHC","faHC","gaHC","haHC","iaHC","sXHC","tXHC","uXHC","vXHC","wXHC","xXHC","yXHC","zXHC","kXHC","lXHC","dWHC","eWHC","fWHC","gWHC","hWHC","iWHC","s3KC","t3KC","u3KC","v3KC","w3KC","x3KC","y3KC","z3KC","k3KC","l3KC","d2KC","e2KC","f2KC","g2KC","h2KC","i2KC","sDKC","tDKC","uDKC","vDKC","wDKC","xDKC","yDKC","zDKC","kDKC","lDKC","dCKC","eCKC","fCKC","gCKC","hCKC","iCKC","s;KC","t;KC","u;KC","v;KC","w;KC","x;KC","y;KC","z;KC","k;KC","l;KC","d:KC","e:KC","f:KC","g:KC","h:KC","i:KC","sLKC","tLKC","uLKC","vLKC","wLKC","xLKC","yLKC","zLKC","kLKC","lLKC","dKKC","eKKC","fKKC","gKKC","hKKC","iKKC","sHKC","tHKC","uHKC","vHKC","wHKC","xHKC","yHKC","zHKC","kHKC","lHKC","dGKC","eGKC","fGKC","gGKC","hGKC","iGKC","sTKC","tTKC","uTKC","vTKC","wTKC","xTKC","yTKC","zTKC","kTKC","lTKC","dSKC","eSKC","fSKC","gSKC","hSKC","iSKC","sAHM","tAHM","uAHM","vAHM","wAHM","xAHM","yAHM","zAHM","kAHM","lAHM","dBHM","eBHM","fBHM","gBHM","hBHM","iBHM","s8HM","t8HM","u8HM","v8HM","w8HM","x8HM","y8HM","z8HM","k8HM","l8HM","d9HM","e9HM","f9HM","g9HM","h9HM","i9HM","s4HM","t4HM","u4HM","v4HM","w4HM","x4HM","y4HM","z4HM","k4HM","l4HM","d5HM","e5HM","f5HM","g5HM","h5HM","i5HM","s0HM","t0HM","u0HM","v0HM","w0HM","x0HM","y0HM","z0HM","k0HM","l0HM","d1HM","e1HM","f1HM","g1HM","h1HM","i1HM","sQHM","tQHM","uQHM","vQHM","wQHM","xQHM","yQHM","zQHM","kQHM","lQHM","dRHM","eRHM","fRHM","gRHM","hRHM","iRHM","sMHM","tMHM","uMHM","vMHM","wMHM","xMHM","yMHM","zMHM","kMHM","lMHM","dNHM","eNHM","fNHM","gNHM","hNHM","iNHM","sIHM","tIHM","uIHM","vIHM","wIHM","xIHM","yIHM","zIHM","kIHM","lIHM","dJHM","eJHM","fJHM","gJHM","hJHM","iJHM","sEHM","tEHM","uEHM","vEHM","wEHM","xEHM","yEHM","zEHM","kEHM","lEHM","dFHM","eFHM","fFHM","gFHM","hFHM","iFHM","sgHM","tgHM","ugHM","vgHM","wgHM","xgHM","ygHM","zgHM","kgHM","lgHM","dhHM","ehHM","fhHM","ghHM","hhHM","ihHM","scHM","tcHM","ucHM","vcHM","wcHM","xcHM","ycHM","zcHM","kcHM","lcHM","ddHM","edHM","fdHM","gdHM","hdHM","idHM","s8KM","t8KM","u8KM","v8KM","w8KM","x8KM","y8KM","z8KM","k8KM","l8KM","d9KM","e9KM","f9KM","g9KM","h9KM","i9KM","s4KM","t4KM","u4KM","v4KM","w4KM","x4KM","y4KM","z4KM","k4KM","l4KM","d5KM","e5KM","f5KM","g5KM","h5KM","i5KM","s0KM","t0KM","u0KM","v0KM","w0KM","x0KM","y0KM","z0KM","k0KM","l0KM","d1KM","e1KM","f1KM","g1KM","h1KM","i1KM","sQKM","tQKM","uQKM","vQKM","wQKM","xQKM","yQKM","zQKM","kQKM","lQKM","dRKM","eRKM","fRKM","gRKM","hRKM","iRKM","sMKM","tMKM","uMKM","vMKM","wMKM","xMKM","yMKM","zMKM","kMKM","lMKM","dNKM","eNKM","fNKM","gNKM","hNKM","iNKM","sIKM","tIKM","uIKM","vIKM","wIKM","xIKM","yIKM","zIKM","kIKM","lIKM","dJKM","eJKM","fJKM","gJKM","hJKM","iJKM","UAXM","VAXM","WAXM","XAXM","YAXM","ZAXM","aAXM","bAXM","cAXM","dAXM","lBXM","mBXM","nBXM","oBXM","pBXM","qBXM","U8XM","V8XM","W8XM","X8XM","Y8XM","Z8XM","a8XM","b8XM","c8XM","d8XM","l9XM","m9XM","n9XM","o9XM","p9XM","q9XM","U4XM","V4XM","W4XM","X4XM","Y4XM","Z4XM","a4XM","b4XM","c4XM","d4XM","l5XM","m5XM","n5XM","o5XM","p5XM","q5XM","U0XM","V0XM","W0XM","X0XM","Y0XM","Z0XM","a0XM","b0XM","c0XM","d0XM","l1XM","m1XM","n1XM","o1XM","p1XM","q1XM","UQXM","VQXM","WQXM","XQXM","YQXM","ZQXM","aQXM","bQXM","cQXM","dQXM","lRXM","mRXM","nRXM","oRXM","pRXM","qRXM","UMXM","VMXM","WMXM","XMXM","YMXM","ZMXM","aMXM","bMXM","cMXM","dMXM","lNXM","mNXM","nNXM","oNXM","pNXM","qNXM","UIXM","VIXM","WIXM","XIXM","YIXM","ZIXM","aIXM","bIXM","cIXM","dIXM","lJXM","mJXM","nJXM","oJXM","pJXM","qJXM","UEXM","VEXM","WEXM","XEXM","YEXM","ZEXM","aEXM","bEXM","cEXM","dEXM","lFXM","mFXM","nFXM","oFXM","pFXM","qFXM","UgXM","VgXM","WgXM","XgXM","YgXM","ZgXM","agXM","bgXM","cgXM","dgXM","lhXM","mhXM","nhXM","ohXM","phXM","qhXM","UcXM","VcXM","WcXM","XcXM","YcXM","ZcXM","acXM","bcXM","ccXM","dcXM","ldXM","mdXM","ndXM","odXM","pdXM","qdXM","U8aM","V8aM","W8aM","X8aM","Y8aM","Z8aM","a8aM","b8aM","c8aM","d8aM","l9aM","m9aM","n9aM","o9aM","p9aM","q9aM","U4aM","V4aM","W4aM","X4aM","Y4aM","Z4aM","a4aM","b4aM","c4aM","d4aM","l5aM","m5aM","n5aM","o5aM","p5aM","q5aM","U0aM","V0aM","W0aM","X0aM","Y0aM","Z0aM","a0aM","b0aM","c0aM","d0aM","l1aM","m1aM","n1aM","o1aM","p1aM","q1aM","UQaM","VQaM","WQaM","XQaM","YQaM","ZQaM","aQaM","bQaM","cQaM","dQaM","lRaM","mRaM","nRaM","oRaM","pRaM","qRaM","UMaM","VMaM","WMaM","XMaM","YMaM","ZMaM","aMaM","bMaM","cMaM","dMaM","lNaM","mNaM","nNaM","oNaM","pNaM","qNaM","UIaM","VIaM","WIaM","XIaM","YIaM","ZIaM","aIaM","bIaM","cIaM","dIaM","lJaM","mJaM","nJaM","oJaM","pJaM","qJaM","cAnM","dAnM","eAnM","fAnM","gAnM","hAnM","iAnM","jAnM","UAnM","VAnM","tBnM","uBnM","vBnM","wBnM","xBnM","yBnM","c8nM","d8nM","e8nM","f8nM","g8nM","h8nM","i8nM","j8nM","U8nM","V8nM","t9nM","u9nM","v9nM","w9nM","x9nM","y9nM","c4nM","d4nM","e4nM","f4nM","g4nM","h4nM","i4nM","j4nM","U4nM","V4nM","t5nM","u5nM","v5nM","w5nM","x5nM","y5nM","c0nM","d0nM","e0nM","f0nM","g0nM","h0nM","i0nM","j0nM","U0nM","V0nM","t1nM","u1nM","v1nM","w1nM","x1nM","y1nM","cQnM","dQnM","eQnM","fQnM","gQnM","hQnM","iQnM","jQnM","UQnM","VQnM","tRnM","uRnM","vRnM","wRnM","xRnM","yRnM","cMnM","dMnM","eMnM","fMnM","gMnM","hMnM","iMnM","jMnM","UMnM","VMnM","tNnM","uNnM","vNnM","wNnM","xNnM","yNnM","cInM","dInM","eInM","fInM","gInM","hInM","iInM","jInM","UInM","VInM","tJnM","uJnM","vJnM","wJnM","xJnM","yJnM","cEnM","dEnM","eEnM","fEnM","gEnM","hEnM","iEnM","jEnM","UEnM","VEnM","tFnM","uFnM","vFnM","wFnM","xFnM","yFnM","cgnM","dgnM","egnM","fgnM","ggnM","hgnM","ignM","jgnM","UgnM","VgnM","thnM","uhnM","vhnM","whnM","xhnM","yhnM","ccnM","dcnM","ecnM","fcnM","gcnM","hcnM","icnM","jcnM","UcnM","VcnM","tdnM","udnM","vdnM","wdnM","xdnM","ydnM","c8qM","d8qM","e8qM","f8qM","g8qM","h8qM","i8qM","j8qM","U8qM","V8qM","t9qM","u9qM","v9qM","w9qM","x9qM","y9qM","c4qM","d4qM","e4qM","f4qM","g4qM","h4qM","i4qM","j4qM","U4qM","V4qM","t5qM","u5qM","v5qM","w5qM","x5qM","y5qM","c0qM","d0qM","e0qM","f0qM","g0qM","h0qM","i0qM","j0qM","U0qM","V0qM","t1qM","u1qM","v1qM","w1qM","x1qM","y1qM","cQqM","dQqM","eQqM","fQqM","gQqM","hQqM","iQqM","jQqM","UQqM","VQqM","tRqM","uRqM","vRqM","wRqM","xRqM","yRqM","cMqM","dMqM","eMqM","fMqM","gMqM","hMqM","iMqM","jMqM","UMqM","VMqM","tNqM","uNqM","vNqM","wNqM","xNqM","yNqM","cIqM","dIqM","eIqM","fIqM","gIqM","hIqM","iIqM","jIqM","UIqM","VIqM","tJqM","uJqM","vJqM","wJqM","xJqM","yJqM","EA3N","FA3N","GA3N","HA3N","IA3N","JA3N","KA3N","LA3N","MA3N","NA3N","1B3N","2B3N","3B3N","4B3N","5B3N","6B3N","E83N","F83N","G83N","H83N","I83N","J83N","K83N","L83N","M83N","N83N","193N","293N","393N","493N","593N","693N","E43N","F43N","G43N","H43N","I43N","J43N","K43N","L43N","M43N","N43N","153N","253N","353N","453N","553N","653N","E03N","F03N","G03N","H03N","I03N","J03N","K03N","L03N","M03N","N03N","113N","213N","313N","413N","513N","613N","EQ3N","FQ3N","GQ3N","HQ3N","IQ3N","JQ3N","KQ3N","LQ3N","MQ3N","NQ3N","1R3N","2R3N","3R3N","4R3N","5R3N","6R3N","EM3N","FM3N","GM3N","HM3N","IM3N","JM3N","KM3N","LM3N","MM3N","NM3N","1N3N","2N3N","3N3N","4N3N","5N3N","6N3N","EI3N","FI3N","GI3N","HI3N","II3N","JI3N","KI3N","LI3N","MI3N","NI3N","1J3N","2J3N","3J3N","4J3N","5J3N","6J3N","EE3N","FE3N","GE3N","HE3N","IE3N","JE3N","KE3N","LE3N","ME3N","NE3N","1F3N","2F3N","3F3N","4F3N","5F3N","6F3N","Eg3N","Fg3N","Gg3N","Hg3N","Ig3N","Jg3N","Kg3N","Lg3N","Mg3N","Ng3N","1h3N","2h3N","3h3N","4h3N","5h3N","6h3N","Ec3N","Fc3N","Gc3N","Hc3N","Ic3N","Jc3N","Kc3N","Lc3N","Mc3N","Nc3N","1d3N","2d3N","3d3N","4d3N","5d3N","6d3N","E86N","F86N","G86N","H86N","I86N","J86N","K86N","L86N","M86N","N86N","196N","296N","396N","496N","596N","696N","E46N","F46N","G46N","H46N","I46N","J46N","K46N","L46N","M46N","N46N","156N","256N","356N","456N","556N","656N","E06N","F06N","G06N","H06N","I06N","J06N","K06N","L06N","M06N","N06N","116N","216N","316N","416N","516N","616N","EQ6N","FQ6N","GQ6N","HQ6N","IQ6N","JQ6N","KQ6N","LQ6N","MQ6N","NQ6N","1R6N","2R6N","3R6N","4R6N","5R6N","6R6N","EM6N","FM6N","GM6N","HM6N","IM6N","JM6N","KM6N","LM6N","MM6N","NM6N","1N6N","2N6N","3N6N","4N6N","5N6N","6N6N","EI6N","FI6N","GI6N","HI6N","II6N","JI6N","KI6N","LI6N","MI6N","NI6N","1J6N","2J6N","3J6N","4J6N","5J6N","6J6N","MAHN","NAHN","OAHN","PAHN","QAHN","RAHN","SAHN","TAHN","EAHN","FAHN","9BHN",":BHN",";BHN","ABHN","BBHN","CBHN","M8HN","N8HN","O8HN","P8HN","Q8HN","R8HN","S8HN","T8HN","E8HN","F8HN","99HN",":9HN",";9HN","A9HN","B9HN","C9HN","M4HN","N4HN","O4HN","P4HN","Q4HN","R4HN","S4HN","T4HN","E4HN","F4HN","95HN",":5HN",";5HN","A5HN","B5HN","C5HN","M0HN","N0HN","O0HN","P0HN","Q0HN","R0HN","S0HN","T0HN","E0HN","F0HN","91HN",":1HN",";1HN","A1HN","B1HN","C1HN","MQHN","NQHN","OQHN","PQHN","QQHN","RQHN","SQHN","TQHN","EQHN","FQHN","9RHN",":RHN",";RHN","ARHN","BRHN","CRHN","MMHN","NMHN","OMHN","PMHN","QMHN","RMHN","SMHN","TMHN","EMHN","FMHN","9NHN",":NHN",";NHN","ANHN","BNHN","CNHN","MIHN","NIHN","OIHN","PIHN","QIHN","RIHN","SIHN","TIHN","EIHN","FIHN","9JHN",":JHN",";JHN","AJHN","BJHN","CJHN","MEHN","NEHN","OEHN","PEHN","QEHN","REHN","SEHN","TEHN","EEHN","FEHN","9FHN",":FHN",";FHN","AFHN","BFHN","CFHN","MgHN","NgHN","OgHN","PgHN","QgHN","RgHN","SgHN","TgHN","EgHN","FgHN","9hHN",":hHN",";hHN","AhHN","BhHN","ChHN","McHN","NcHN","OcHN","PcHN","QcHN","RcHN","ScHN","TcHN","EcHN","FcHN","9dHN",":dHN",";dHN","AdHN","BdHN","CdHN","M8KN","N8KN","O8KN","P8KN","Q8KN","R8KN","S8KN","T8KN","E8KN","F8KN","99KN",":9KN",";9KN","A9KN","B9KN","C9KN","M4KN","N4KN","O4KN","P4KN","Q4KN","R4KN","S4KN","T4KN","E4KN","F4KN","95KN",":5KN",";5KN","A5KN","B5KN","C5KN","M0KN","N0KN","O0KN","P0KN","Q0KN","R0KN","S0KN","T0KN","E0KN","F0KN","91KN",":1KN",";1KN","A1KN","B1KN","C1KN","MQKN","NQKN","OQKN","PQKN","QQKN","RQKN","SQKN","TQKN","EQKN","FQKN","9RKN",":RKN",";RKN","ARKN","BRKN","CRKN","MMKN","NMKN","OMKN","PMKN","QMKN","RMKN","SMKN","TMKN","EMKN","FMKN","9NKN",":NKN",";NKN","ANKN","BNKN","CNKN","MIKN","NIKN","OIKN","PIKN","QIKN","RIKN","SIKN","TIKN","EIKN","FIKN","9JKN",":JKN",";JKN","AJKN","BJKN","CJKN","0AXN","1AXN","2AXN","3AXN","4AXN","5AXN","6AXN","7AXN","8AXN","9AXN","FBXN","GBXN","HBXN","IBXN","JBXN","KBXN","08XN","18XN","28XN","38XN","48XN","58XN","68XN","78XN","88XN","98XN","F9XN","G9XN","H9XN","I9XN","J9XN","K9XN","04XN","14XN","24XN","34XN","44XN","54XN","64XN","74XN","84XN","94XN","F5XN","G5XN","H5XN","I5XN","J5XN","K5XN","00XN","10XN","20XN","30XN","40XN","50XN","60XN","70XN","80XN","90XN","F1XN","G1XN","H1XN","I1XN","J1XN","K1XN","0QXN","1QXN","2QXN","3QXN","4QXN","5QXN","6QXN","7QXN","8QXN","9QXN","FRXN","GRXN","HRXN","IRXN","JRXN","KRXN","0MXN","1MXN","2MXN","3MXN","4MXN","5MXN","6MXN","7MXN","8MXN","9MXN","FNXN","GNXN","HNXN","INXN","JNXN","KNXN","0IXN","1IXN","2IXN","3IXN","4IXN","5IXN","6IXN","7IXN","8IXN","9IXN","FJXN","GJXN","HJXN","IJXN","JJXN","KJXN","0EXN","1EXN","2EXN","3EXN","4EXN","5EXN","6EXN","7EXN","8EXN","9EXN","FFXN","GFXN","HFXN","IFXN","JFXN","KFXN","0gXN","1gXN","2gXN","3gXN","4gXN","5gXN","6gXN","7gXN","8gXN","9gXN","FhXN","GhXN","HhXN","IhXN","JhXN","KhXN","0cXN","1cXN","2cXN","3cXN","4cXN","5cXN","6cXN","7cXN","8cXN","9cXN","FdXN","GdXN","HdXN","IdXN","JdXN","KdXN","08aN","18aN","28aN","38aN","48aN","58aN","68aN","78aN","88aN","98aN","F9aN","G9aN","H9aN","I9aN","J9aN","K9aN","04aN","14aN","24aN","34aN","44aN","54aN","64aN","74aN","84aN","94aN","F5aN","G5aN","H5aN","I5aN","J5aN","K5aN","00aN","10aN","20aN","30aN","40aN","50aN","60aN","70aN","80aN","90aN","F1aN","G1aN","H1aN","I1aN","J1aN","K1aN","0QaN","1QaN","2QaN","3QaN","4QaN","5QaN","6QaN","7QaN","8QaN","9QaN","FRaN","GRaN","HRaN","IRaN","JRaN","KRaN","0MaN","1MaN","2MaN","3MaN","4MaN","5MaN","6MaN","7MaN","8MaN","9MaN","FNaN","GNaN","HNaN","INaN","JNaN","KNaN","0IaN","1IaN","2IaN","3IaN","4IaN","5IaN","6IaN","7IaN","8IaN","9IaN","FJaN","GJaN","HJaN","IJaN","JJaN","KJaN");
function isValidColor( str )
{
	if(str.length!=6 && str.length!=7)
	return false;
	if(str.length==7)
	return false;
	if(!isHex(str))
	return false;
	return true;
}
function convertColor( color )
{
	if(color.charAt(0)=="#")
	color = color.substr(1,6);
	result = sColorsArray[parseInt(color.substr(0,3),16)]+sColorsArray[parseInt(color.substr(3,3),16)];
	return result;
}
function isHex( str )
{
	hexChar = "0123456789ABCDEFabcdef";
	for (var i=0; i < str.length; i++)
	if (hexChar.indexOf(str.charAt(i),0) == -1)
	return false;
	return true;
}
var sLanguageIndex = "1";
var sAvatarSize = "1";
var sAvatarAA = "1";
//var sBaseURL = "/pcms/v4";
//var sBaseHost = "http://mabinogi.or.tp";
var sCurConfig = "";
var sChangeFramework = "";
function updateLinks()
{
	//クラッシュ対策のため、1つ前のデータを保存する
	if (sCurConfig != "") {
		cookie.set("cs_autosave", sCurConfig);
		cookie.set("cs_autosave_date", varDate.getTime());
	}
	
	uri = "";
	uri += "/1,"+sLanguageIndex+","+sAvatarSize+","+sAvatarAA+","+sBgColorp;
	uri += "/2,"+sFramework;
	sChangeFramework = uri;
	uri += "/3,"+sHeightScalep+","+sFatnessScalep+","+sTopScalep+","+sBottomScalep;
	uri += "/4,"+sSkinColorp+","+sSkinColorIndex;
	uri += "/5,"+sEyeColorp;
	uri += "/6,"+sHairIndex+","+sHairColorIndex;
	uri += "/7,"+sHairColorp;
	if(sHeadIndex != -1)
	{
		uri += "/8,"+sHeadIndex+","+sHeadWearState;
		//uri += "/9,"+sHeadColor1p+","+sHeadColor2p+","+sHeadColor3p;
	}
	uri += "/9,"+sHeadColor1p+","+sHeadColor2p+","+sHeadColor3p;
	uri += "/10,"+sFaceIndex;
	uri += "/11,"+sFaceColor1p+","+sFaceColor2p+","+sFaceColor3p;
	uri += "/12,"+sBodyIndex+","+sBodyWearState;
	uri += "/13,"+sBodyColor1p+","+sBodyColor2p+","+sBodyColor3p;
	if(sHandIndex != -1)
	{
		uri += "/14,"+sHandIndex;
		//uri += "/15,"+sHandColor1p+","+sHandColor2p+","+sHandColor3p;
	}
	uri += "/15,"+sHandColor1p+","+sHandColor2p+","+sHandColor3p;
	uri += "/16,"+sFootIndex;
	uri += "/17,"+sFootColor1p+","+sFootColor2p+","+sFootColor3p;
	if(sWeaponFirstIndex != -1)
	{
		uri += "/18,"+sWeaponFirstIndex+","+sWeaponFirstWearState;
		//uri += "/19,"+sWeaponFirstColor1p+","+sWeaponFirstColor2p+","+sWeaponFirstColor3p;
	}
	uri += "/19,"+sWeaponFirstColor1p+","+sWeaponFirstColor2p+","+sWeaponFirstColor3p;
	if(sWeaponSecondIndex != -1)
	{
		uri += "/20,"+sWeaponSecondIndex+","+sWeaponSecondWearState;
		//uri += "/21,"+sWeaponSecondColor1p+","+sWeaponSecondColor2p+","+sWeaponSecondColor3p;
	}
	uri += "/21,"+sWeaponSecondColor1p+","+sWeaponSecondColor2p+","+sWeaponSecondColor3p;
	if(sShieldFirstIndex != -1)
	{
		uri += "/22,"+sShieldFirstIndex+","+sShieldFirstWearState;
		//uri += "/22,"+sShieldFirstIndex+","+sWeaponSecondWearState;
		//uri += "/23,"+sShieldFirstColor1p+","+sShieldFirstColor2p+","+sShieldFirstColor3p;
	}
	uri += "/23,"+sShieldFirstColor1p+","+sShieldFirstColor2p+","+sShieldFirstColor3p;
	if(sShieldSecondIndex != -1)
	{
		uri += "/24,"+sShieldSecondIndex+","+sShieldSecondWearState;
		//uri += "/25,"+sShieldSecondColor1p+","+sShieldSecondColor2p+","+sShieldSecondColor3p;
	}
	uri += "/25,"+sShieldSecondColor1p+","+sShieldSecondColor2p+","+sShieldSecondColor3p;
	if(sRobeIndex != -1)
	{
		uri += "/26,"+sRobeIndex+","+sRobeWearType;
		//uri += "/27,"+sRobeColor1p+","+sRobeColor2p+","+sRobeColor3p;
	}
	uri += "/27,"+sRobeColor1p+","+sRobeColor2p+","+sRobeColor3p;
	uri += "/28,"+sEyeEmotionIndex+","+sEyeColorIndex;
	uri += "/29,"+sMouthEmotionIndex;
	uri += "/30,"+sReactionIndex;
	uri += "/31,"+sAnimationIndex;
	if(sAnimationAnimateState!=0) {
		uri += "/32,"+sAnimationFramep+","+sAnimatorPlayingState;
	}
	//uri += "/33,"+sInitColorp[0]+","+sInitColorp[1]+","+sInitColorp[2]+","+sInitColorp[3]+","+sInitColorp[4]+","+sInitColorp[5]+","+sInitColorp[6]+","+sInitColorp[7]+","+sInitColorp[8];



	sCurConfig = uri;

	varDate = new Date();
}

var cookie = {};

cookie.get = function(name) {
    var regexp = new RegExp('; ' + name + '=(.*?);');
    var match  = ('; ' + document.cookie + ';').match(regexp);
    return match ? decodeURIComponent(match[1]) : '';
}

cookie.set = function(name, value) {
    var buf = name + '=' + encodeURIComponent(value);
    document.cookie = buf + '; expires=Mon, 31-Dec-2029 23:59:59 GMT';
}


function reloadURL()
{
	updateLinks();
	parent.location.href = "?q="+sCurConfig;
}
function shortURL()
{
	updateLinks();
	parent.location.href = "action.php?q="+sCurConfig+"&action=createShorturl";
}
function shortURL2()
{
	updateLinks();
	parent.location.href = "action.php?q="+sCurConfig+"&action=createShorturl2";
}
function tweetURL()
{
	updateLinks();
	window.open("action.php?q="+sCurConfig+"&action=createShorturlTwitter");
}
function entryMyList()
{
	var mylistNameStr = "";
	mylistNameStr = window.prompt("Please input list name.","My Character");
	if (mylistNameStr) {
		updateLinks();
		window.open("mylist.php?q="+sCurConfig+"&action=addMyList&name="+encodeURI(mylistNameStr), "mylistif");
		myListBlock.style.display = "block";
	}
}
function entryMyList2()
{
	var mylistNameStr = "";
	mylistNameStr = window.prompt("Please input list name.","My Character");
	if (mylistNameStr) {
		updateLinks();
		var script = csScript();
		document.formEntryMylist2.code.value = ""+script;
		document.formEntryMylist2.q.value = ""+sCurConfig;
		document.formEntryMylist2.name.value = ""+mylistNameStr;
		document.formEntryMylist2.submit();
		myList2Block.style.display = "block";
	}
}
function searchPublist(str)
{
	if (str != "" && str != undefined && str != "(無し)") {
		document.formPublistSearch.word.value = ""+str;
		document.formPublistSearch.submit();
	}
}
function entryPublicList()
{
	var script = csScript();
	document.formEntryPublist.code.value = ""+script;
	document.formEntryPublist.q.value = ""+sCurConfig;
	document.formEntryPublist.submit();
}
function clearSettings()
{
	//if (confirm('')) {
		//window.open("index.php?action=changeFramework&framework=", "_top");
		parent.location.href="?action=changeFramework&framework="+sFramework;
	//}
}
function csSoftReset()
{
	var script = csScript();
	parent.softreset( script );
	
	//var script = csScript();
	//execute( script );
}
function updateCSConfig()
{
	//sLanguageIndex = controller.csLang.value;
	sAvatarSize = controller.csSize.value;
	sAvatarAA = controller.csAA.value;
	//updateLinks();
	reloadURL();
}
var redDepth = "ff";
var greenDepth = "ff";
var blueDepth = "ff";
var dragging = false;
function decHex( inNum )
{
	var hex=inNum.toString(16);
	if(hex.length==1)
	hex = "0"+hex;
	return hex;
}
var kRGBSliderRange = 256;
var kRGBSliderMargin = 3
var kRGBSliderWidth = kRGBSliderRange+kRGBSliderMargin*2;
function changeRInput( inObj )
{
	if (inObj.value > 255) { inObj.value = 255; }
	if (inObj.value < 0) { inObj.value = 0; }

	redDepth = decHex(Number(inObj.value));
	changeSwatch();
}
function changeGInput( inObj )
{
	if (inObj.value > 255) { inObj.value = 255; }
	if (inObj.value < 0) { inObj.value = 0; }

	greenDepth = decHex(Number(inObj.value));
	changeSwatch();
}
function changeBInput( inObj )
{
	if (inObj.value > 255) { inObj.value = 255; }
	if (inObj.value < 0) { inObj.value = 0; }

	blueDepth = decHex(Number(inObj.value));
	changeSwatch();
}
function changeR()
{
	if(event.offsetX<kRGBSliderMargin)
	{
		controller.rTip.style.left = 0;
		curPos = 0;
	}
	else if(event.offsetX>kRGBSliderWidth-kRGBSliderMargin-1)
	{
		controller.rTip.style.left = (kRGBSliderWidth-kRGBSliderMargin*2)-1;
		curPos = (kRGBSliderWidth-kRGBSliderMargin*2)-1;
	}
	else
	{
		controller.rTip.style.left = event.offsetX-kRGBSliderMargin;
		curPos = event.offsetX-kRGBSliderMargin;
	}
	redDepth = decHex(curPos);
	changeSwatch();
}
function changeG()
{
	if(event.offsetX<kRGBSliderMargin)
	{
		controller.gTip.style.left = 0;
		curPos = 0;
	}
	else if(event.offsetX>kRGBSliderWidth-kRGBSliderMargin-1)
	{
		controller.gTip.style.left = (kRGBSliderWidth-kRGBSliderMargin*2)-1;
		curPos = (kRGBSliderWidth-kRGBSliderMargin*2)-1;
	}
	else
	{
		controller.gTip.style.left = event.offsetX-kRGBSliderMargin;
		curPos = event.offsetX-kRGBSliderMargin;
	}
	greenDepth = decHex(curPos);
	changeSwatch();
}
function changeB()
{
	if(event.offsetX<kRGBSliderMargin)
	{
		controller.bTip.style.left = 0;
		curPos = 0;
	}
	else if(event.offsetX>kRGBSliderWidth-kRGBSliderMargin-1)
	{
		controller.bTip.style.left = (kRGBSliderWidth-kRGBSliderMargin*2)-1;
		curPos = (kRGBSliderWidth-kRGBSliderMargin*2)-1;
	}
	else
	{
		controller.bTip.style.left = event.offsetX-kRGBSliderMargin;
		curPos = event.offsetX-kRGBSliderMargin;
	}
	blueDepth = decHex(curPos);
	changeSwatch();
}
function changeRw()
{
	delta = ((event.wheelDelta>0)?-1:1);
	curDepth = parseInt(redDepth,16);
	if(curDepth+delta<0||curDepth+delta>255)
	return;
	redDepth = decHex(curDepth+delta);
	controller.rTip.style.left = curDepth+delta;
	changeSwatch();
}
function changeGw()
{
	delta = ((event.wheelDelta>0)?-1:1);
	curDepth = parseInt(greenDepth,16);
	if(curDepth+delta<0||curDepth+delta>255)
	return;
	greenDepth = decHex(curDepth+delta);
	controller.gTip.style.left = curDepth+delta;
	changeSwatch();
}
function changeBw()
{
	delta = ((event.wheelDelta>0)?-1:1);
	curDepth = parseInt(blueDepth,16);
	if(curDepth+delta<0||curDepth+delta>255)
	return;
	blueDepth = decHex(curDepth+delta);
	controller.bTip.style.left = curDepth+delta;
	changeSwatch();
}
function setColorPalette( index, inObj )
{
	sInitColorp[index] = redDepth+greenDepth+blueDepth;
	
	cookie.set("cookie_colorpal", ""+sInitColorp[0]+","+sInitColorp[1]+","+sInitColorp[2]+","+sInitColorp[3]+","+sInitColorp[4]+","+sInitColorp[5]+","+sInitColorp[6]+","+sInitColorp[7]+","+sInitColorp[8]);
}
function changeSwatch()
{
	colorSwatch.style.background = "#"+redDepth+greenDepth+blueDepth;
	colorSwatch.title = redDepth+greenDepth+blueDepth;

	controller.colorPickerR.value = parseInt(redDepth,16);
	controller.colorPickerG.value = parseInt(greenDepth,16);
	controller.colorPickerB.value = parseInt(blueDepth,16);
	controller.colorPickerHEX.value = "#"+redDepth+greenDepth+blueDepth;
}
function setPickerColor( inColor )
{
	redDepth = inColor.substr(1,2);
	greenDepth = inColor.substr(3,2);
	blueDepth = inColor.substr(5,2);
	controller.rTip.style.left = parseInt(redDepth,16);
	controller.gTip.style.left = parseInt(greenDepth,16);
	controller.bTip.style.left = parseInt(blueDepth,16);
	controller.colorPickerR.value = parseInt(redDepth,16);
	controller.colorPickerG.value = parseInt(greenDepth,16);
	controller.colorPickerB.value = parseInt(blueDepth,16);
	controller.colorPickerHEX.value = ""+inColor;
	changeSwatch();
}
function dyeColor( inObj )
{
	setPaletteColor(inObj,redDepth+greenDepth+blueDepth);
}
function setPaletteColor( palette, color )
{
	palette.style.background = "#"+color;
	palette.title = color;
}
function pickColor( inObj )
{
	setPickerColor("#"+getColorRGBbyStyle(inObj.style.backgroundColor));
	for (var i=20; i>0; i--) {
		document.getElementById('paletteLog'+i).style.backgroundColor = "#"+getColorRGBbyStyle(document.getElementById('paletteLog'+(i-1)).style.backgroundColor);
	}
	document.getElementById('paletteLog0').style.backgroundColor = "#"+getColorRGBbyStyle(inObj.style.backgroundColor);
	
	var cookie_colorlog = "";
	for (var i=0; i<=20; i++) {
		cookie_colorlog += "#"+getColorRGBbyStyle(document.getElementById('paletteLog'+i).style.backgroundColor)+",";
	}
	cookie.set("cookie_colorlog", cookie_colorlog);
}
function pickColorNoLog( inObj )
{
	setPickerColor("#"+getColorRGBbyStyle(inObj.style.backgroundColor));
}
var sInitColorp = new Array( "fad029", "5ad251", "6ab3fb", "000000", "7f7f7f", "ffffff", "fdb3ec", "ff0000", "d1fbfe" );
function initColorPicker()
{
	setPickerColor("#000000");
	setPaletteColor(palette1,sInitColorp[0]);
	setPaletteColor(palette2,sInitColorp[1]);
	setPaletteColor(palette3,sInitColorp[2]);
	setPaletteColor(palette4,sInitColorp[3]);
	setPaletteColor(palette5,sInitColorp[4]);
	setPaletteColor(palette6,sInitColorp[5]);
	setPaletteColor(palette7,sInitColorp[6]);
	setPaletteColor(palette8,sInitColorp[7]);
	setPaletteColor(palette9,sInitColorp[8]);
	//setPaletteColor(palette4,"000000");
	//setPaletteColor(palette5,"7f7f7f");
	//setPaletteColor(palette6,"ffffff");
	//setPaletteColor(palette7,"bb9955");
	//setPaletteColor(palette8,"aaaaaa");
	//setPaletteColor(palette9,"773333");
	setPaletteColor(headPalette1,sHeadColor1p);
	setPaletteColor(headPalette2,sHeadColor2p);
	setPaletteColor(headPalette3,sHeadColor3p);
	setPaletteColor(bodyPalette1,sBodyColor1p);
	setPaletteColor(bodyPalette2,sBodyColor2p);
	setPaletteColor(bodyPalette3,sBodyColor3p);
	setPaletteColor(footPalette1,sFootColor1p);
	setPaletteColor(footPalette2,sFootColor2p);
	setPaletteColor(footPalette3,sFootColor3p);
	setPaletteColor(handPalette1,sHandColor1p);
	setPaletteColor(handPalette2,sHandColor2p);
	setPaletteColor(handPalette3,sHandColor3p);
	setPaletteColor(robePalette1,sRobeColor1p);
	setPaletteColor(robePalette2,sRobeColor2p);
	setPaletteColor(robePalette3,sRobeColor3p);
	setPaletteColor(weaponFirstPalette1,sWeaponFirstColor1p);
	setPaletteColor(weaponFirstPalette2,sWeaponFirstColor2p);
	setPaletteColor(weaponFirstPalette3,sWeaponFirstColor3p);
	setPaletteColor(weaponSecondPalette1,sWeaponSecondColor1p);
	setPaletteColor(weaponSecondPalette2,sWeaponSecondColor2p);
	setPaletteColor(weaponSecondPalette3,sWeaponSecondColor3p);
	setPaletteColor(shieldFirstPalette1,sShieldFirstColor1p);
	setPaletteColor(shieldFirstPalette2,sShieldFirstColor2p);
	setPaletteColor(shieldFirstPalette3,sShieldFirstColor3p);
	setPaletteColor(shieldSecondPalette1,sShieldSecondColor1p);
	setPaletteColor(shieldSecondPalette2,sShieldSecondColor2p);
	setPaletteColor(shieldSecondPalette3,sShieldSecondColor3p);
	setPaletteColor(hairPalette,sHairColorp);
	setPaletteColor(eyePalette,sEyeColorp);
	setPaletteColor(bgPalette,sBgColorp);
	setPaletteColor(skinPalette,sSkinColorp);
}
function changeHeadColorByPalette( index )
{
	changeColorByPalette(changeHeadColor,
	controller.headColor1,controller.headColor2,controller.headColor3,
	headPalette1,headPalette2,headPalette3,
	index);
	
	
}
function changeBodyColorByPalette( index )
{
	changeColorByPalette(changeBodyColor,
	controller.bodyColor1,controller.bodyColor2,controller.bodyColor3,
	bodyPalette1,bodyPalette2,bodyPalette3,
	index);
}
function changeFootColorByPalette( index )
{
	changeColorByPalette(changeFootColor,
	controller.footColor1,controller.footColor2,controller.footColor3,
	footPalette1,footPalette2,footPalette3,
	index);
}
function changeHandColorByPalette( index )
{
	changeColorByPalette(changeHandColor,
	controller.handColor1,controller.handColor2,controller.handColor3,
	handPalette1,handPalette2,handPalette3,
	index);
}
function changeRobeColorByPalette( index )
{
	changeColorByPalette(changeRobeColor,
	controller.robeColor1,controller.robeColor2,controller.robeColor3,
	robePalette1,robePalette2,robePalette3,
	index);
}
function changeWeaponFirstColorByPalette( index )
{
	changeColorByPalette(changeWeaponFirstColor,
	controller.weaponFirstColor1,controller.weaponFirstColor2,controller.weaponFirstColor3,
	weaponFirstPalette1,weaponFirstPalette2,weaponFirstPalette3,
	index);
}
function changeWeaponSecondColorByPalette( index )
{
	changeColorByPalette(changeWeaponSecondColor,
	controller.weaponSecondColor1,controller.weaponSecondColor2,controller.weaponSecondColor3,
	weaponSecondPalette1,weaponSecondPalette2,weaponSecondPalette3,
	index);
}
function changeShieldFirstColorByPalette( index )
{
	changeColorByPalette(changeShieldFirstColor,
	controller.shieldFirstColor1,controller.shieldFirstColor2,controller.shieldFirstColor3,
	shieldFirstPalette1,shieldFirstPalette2,shieldFirstPalette3,
	index);
}
function changeShieldSecondColorByPalette( index )
{
	changeColorByPalette(changeShieldSecondColor,
	controller.shieldSecondColor1,controller.shieldSecondColor2,controller.shieldSecondColor3,
	shieldSecondPalette1,shieldSecondPalette2,shieldSecondPalette3,
	index);
}
function changeColorByPalette( changeFunc, colorForm1, colorForm2, colorForm3, colorPalette1, colorPalette2, colorPalette3, index )
{
	var color1,color2,color3;
	color1 = colorForm1.value;
	color2 = colorForm2.value;
	color3 = colorForm3.value;
	if(index==1)
	{
		//color1 = colorForm1.value = colorPalette1.style.background.substr(1,6);
		color1 = colorForm1.value = getColorRGBbyStyle(colorPalette1.style.background);
	}
	else if(index==2)
	{
		//color2 = colorForm2.value = colorPalette2.style.background.substr(1,6);
		color2 = colorForm2.value = getColorRGBbyStyle(colorPalette2.style.background);
	}
	else if(index==3)
	{
		//color3 = colorForm3.value = colorPalette3.style.background.substr(1,6);
		color3 = colorForm3.value = getColorRGBbyStyle(colorPalette3.style.background);
	}
	changeFunc(color1,color2,color3);
}
function getColorRGBbyStyle(_value) {
	if (_value.indexOf("#") == 0) {
		return _value.substr(1,6);
	} else if (_value.indexOf("rgb") != -1) {
	    var digits = /(.*?)rgb\((\d+), (\d+), (\d+)\)/.exec(_value);
	    
	    var red = parseInt(digits[2]);
	    var green = parseInt(digits[3]);
	    var blue = parseInt(digits[4]);
	    
	    var rgb = blue | (green << 8) | (red << 16);
	    return ""+formatNum(6, rgb.toString(16));
	} else {
		return "ffffff";
	}
}
function formatNum(keta, num) {
  var src = new String(num);
  var cnt = keta - src.length;
  if (cnt <= 0) return src;
  while (cnt-- > 0) {
  	src = "0" + src;
  }
  return src;
}
function changeBgColorByPalette()
{
	var color = getColorRGBbyStyle(bgPalette.style.background);
	if(!isValidColor(color))
	return;
	controller.bgColor.value = color;
	changeBgColorCustom(color);
}
function changeHairColorByPalette()
{
	var color = getColorRGBbyStyle(hairPalette.style.background);
	if(!isValidColor(color))
	return;
	controller.hairColor.value = color;
	changeHairColorCustom(color);
}
function changeEyeColorByPalette()
{
	var color = getColorRGBbyStyle(eyePalette.style.background);
	if(!isValidColor(color))
	return;
	controller.eyeColor.value = color;
	changeEyeColorCustom(color);
}
function changeSkinColorByPalette()
{
	var color = getColorRGBbyStyle(skinPalette.style.background);
	if(!isValidColor(color))
	return;
	controller.skinColor.value = color;
	changeSkinColorCustom(color);
}
function dyeHead( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	setPaletteColor(headPalette1,color1);
	setPaletteColor(headPalette2,color2);
	setPaletteColor(headPalette3,color3);
	changeHeadColor(color1,color2,color3);
}
function dyeBody( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	setPaletteColor(bodyPalette1,color1);
	setPaletteColor(bodyPalette2,color2);
	setPaletteColor(bodyPalette3,color3);
	changeBodyColor(color1,color2,color3);
}
function dyeFoot( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	setPaletteColor(footPalette1,color1);
	setPaletteColor(footPalette2,color2);
	setPaletteColor(footPalette3,color3);
	changeFootColor(color1,color2,color3);
}
function dyeHand( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	setPaletteColor(handPalette1,color1);
	setPaletteColor(handPalette2,color2);
	setPaletteColor(handPalette3,color3);
	changeHandColor(color1,color2,color3);
}
function dyeRobe( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	setPaletteColor(robePalette1,color1);
	setPaletteColor(robePalette2,color2);
	setPaletteColor(robePalette3,color3);
	changeRobeColor(color1,color2,color3);
}
function dyeWeaponFirst( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	setPaletteColor(weaponFirstPalette1,color1);
	setPaletteColor(weaponFirstPalette2,color2);
	setPaletteColor(weaponFirstPalette3,color3);
	changeWeaponFirstColor(color1,color2,color3);
}
function dyeWeaponSecond( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	setPaletteColor(weaponSecondPalette1,color1);
	setPaletteColor(weaponSecondPalette2,color2);
	setPaletteColor(weaponSecondPalette3,color3);
	changeWeaponSecondColor(color1,color2,color3);
}
function dyeShieldFirst( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	setPaletteColor(shieldFirstPalette1,color1);
	setPaletteColor(shieldFirstPalette2,color2);
	setPaletteColor(shieldFirstPalette3,color3);
	changeShieldFirstColor(color1,color2,color3);
}
function dyeShieldSecond( color1, color2, color3 )
{
	if(!isValidColor(color1)||!isValidColor(color2)||!isValidColor(color3))
	return;
	setPaletteColor(shieldSecondPalette1,color1);
	setPaletteColor(shieldSecondPalette2,color2);
	setPaletteColor(shieldSecondPalette3,color3);
	changeShieldSecondColor(color1,color2,color3);
}
function dyeHair( color1 )
{
	if(!isValidColor(color1))
	return;
	setPaletteColor(hairPalette,color1);
	changeHairColorCustom(color1);
}
function dyeEye( color1 )
{
	if(!isValidColor(color1))
	return;
	setPaletteColor(eyePalette,color1);
	changeEyeColorCustom(color1);
}
function dyeSkin( color1 )
{
	if(!isValidColor(color1))
	return;
	setPaletteColor(skinPalette,color1);
	changeSkinColorCustom(color1);
}
var sConfigControllerVisible = true;
function toggleConfigController()
{
	if(sConfigControllerVisible)
	newVisibility = "none";
	else
	newVisibility = "block";
	configBlock.style.display = newVisibility;
	configBlock2.style.display = newVisibility;
	//configBlock3.style.display = newVisibility;
	sConfigControllerVisible = !sConfigControllerVisible;
}
var sCharacterControllerVisible = true;
function toggleCharacterController()
{
	if(sCharacterControllerVisible)
	newVisibility = "none";
	else
	newVisibility = "block";
	animationBlock.style.display = newVisibility;
	physicalBlock.style.display = newVisibility;
	hairBlock.style.display = newVisibility;
	eyeBlock.style.display = newVisibility;
	faceBlock.style.display = newVisibility;
	sCharacterControllerVisible = !sCharacterControllerVisible;
}
var sEquipmentsControllerVisible = true;
function toggleEquipmentsController()
{
	if(sEquipmentsControllerVisible)
	newVisibility = "none";
	else
	newVisibility = "block";
	headBlock.style.display = newVisibility;
	bodyBlock.style.display = newVisibility;
	footBlock.style.display = newVisibility;
	handBlock.style.display = newVisibility;
	robeBlock.style.display = newVisibility;
	weapon1Block.style.display = newVisibility;
	weapon2Block.style.display = newVisibility;
	shield1Block.style.display = newVisibility;
	shield2Block.style.display = newVisibility;
	sEquipmentsControllerVisible = !sEquipmentsControllerVisible;
}
var sColorPickerVisible = true;
function toggleColorPicker()
{
	if(sColorPickerVisible)
	newVisibility = "none";
	else
	newVisibility = "block";
	colorPickerLocalBlock.style.display = newVisibility;
	sColorPickerVisible = !sColorPickerVisible;
}
var sColorLogVisible = true;
function toggleColorLog()
{
	if(sColorLogVisible)
	newVisibility = "none";
	else
	newVisibility = "block";
	colorLogBlock.style.display = newVisibility;
	sColorLogVisible = !sColorLogVisible;
}
var sSearchControllerVisible = true;
function toggleSearchController()
{
	if(sSearchControllerVisible)
	newVisibility = "none";
	else
	newVisibility = "block";
	searchBlock.style.display = newVisibility;
	sSearchControllerVisible = !sSearchControllerVisible;
}
var sHistoryControllerVisible = false;
function toggleHistoryController()
{
	if(sHistoryControllerVisible)
	newVisibility = "none";
	else
	newVisibility = "block";
	historyBlock.style.display = newVisibility;
	sHistoryControllerVisible = !sHistoryControllerVisible;
}
var sMotionControllerVisible = false;
function toggleMotionController()
{
	if(sMotionControllerVisible)
	newVisibility = "none";
	else
	newVisibility = "block";
	motionControllerBlock.style.display = newVisibility;
	sMotionControllerVisible = !sMotionControllerVisible;
}
var sScriptEditorVisible = false;
function toggleScriptEditor()
{
	if(sScriptEditorVisible)
	newVisibility = "none";
	else
	newVisibility = "block";
	scriptEditorBlock.style.display = newVisibility;
	sScriptEditorVisible = !sScriptEditorVisible;
}
var sMyListVisible = false;
function toggleMyList()
{
	if(sMyListVisible)
	newVisibility = "none";
	else
	newVisibility = "block";
	myListBlock.style.display = newVisibility;
	sMyListVisible = !sMyListVisible;
}
var sMyList2Visible = false;
function toggleMyList2()
{
	if (sMyList2Visible) {
		newVisibility = "none";
	} else {
		var tmp = new Date();
		document.getElementById('mylist2ifid').src = "http://kukulu.erinn.biz/mcs2.mylist.php?t="+tmp.getTime();
		newVisibility = "block";
	}
	myList2Block.style.display = newVisibility;
	sMyList2Visible = !sMyList2Visible;
}
function mouseDown( target )
{
	dragging = true;
}
function mouseUp( target )
{
	dragging = false;
	updateLinks();
}
/* ./data/ja/Giant_common/_Commons.js */
/* mergefile */
/* 0: ../data/ja/Giant_common/Animation.js */
/* 1: ../data/ja/Giant_common/EyeEmotion.js */
/* 2: ../data/ja/Giant_common/MouthEmotion.js */
/* 3: ../data/ja/Giant_common/Reaction.js */
/* 4: ../data/ja/Giant_common/EyeColor.js */
/* 5: ../data/ja/Giant_common/HairColor.js */
/* 6: ../data/ja/Giant_common/SkinColor.js */
/* 7: ../data/ja/Giant_common/WeaponAndShield.js */
/* 8: ../data/ja/Giant_common/Weapon.js */

/* ../data/ja/Giant_common/Animation.js */
var sAnimationArray = new Array(
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMtTrQjQaPiC3AVpKM",3), //0
	new Array(1,"NdqNjQbPH96Nmk5O6qKRVpKM",3), //1
	new Array(1,"NdqNjQbP3d6NNAHNS0a;cBGO",3), //2
	new Array(1,"NdqNjQbP3d6NOAHNS0a;cBGO",3), //3
	new Array(1,"NdqNjQbP3d6N:lJN8hrPdzGAEdaP",3), //4
	new Array(1,"NdqNjQbP3d6N:lJN8hrPlzWAEdaP",3), //5
	new Array(1,"NdqNjQbP3d6N:lJNbgrPDk6PVr2QEdaP",3), //6
	new Array(1,"NdqNjQbP3d6N4lJN8kqPS0a;cBGO",3), //7
	new Array(1,"NdqNjQbP157NNrmREdaP",3), //8
	new Array(1,"NdqNjQbPRNaNhxKMACqL3;6RclpOdzGAEdaP",3), //9
	new Array(1,"NdqNjQbPRNaNhxKMACqL3;6RclpOlzWAEdaP",3), //10
	new Array(1,"NdqNjQbPRNaNhxKMACqL3;6RclpOtzmAEdaP",3), //11
	new Array(1,"NdqNjQbPRNaNhxKMN2qLDw6PboqPllaMEm5RfvpAC;6R6l5NpfaQQQaPdqGSEdaP",3), //12
	new Array(1,"NdqNjQbPRNaNhxKMI2qLNErP1;qRS0a;cBGO",3), //13
	new Array(1,"NdqNjQbPRNaNhxKMI2qLNErP1;qRL2qLCc7NVpKM",3), //14
	new Array(1,"NdqNjQbPRNaNhxKMI2qLNErP1;qRKSqLGN7N9pGNEdaP",3), //15
	new Array(1,"NdqNjQbPRNaNhxKMI2qLNErP1;qR:KqLKMrP1p2NEdaP",3), //16
	new Array(1,"NdqNjQbPRNaNhxKMI2qLNErP1;qRBOrLyqaQVpKM",3), //17
	new Array(1,"NdqNjQbPRNaNhxKML6qL94KP3n5RKMrPGP6RS0a;cBGO",3), //18
	new Array(1,"NdqNjQbPRNaNhxKML6qL94KP7n5RO;KR1p2NEdaP",3), //19
	new Array(1,"NdqNjQbPRNaNhxKML6qL94KPHn5RP8KPkl5OdzGAEdaP",3), //20
	new Array(1,"NdqNjQbPRNaNhxKMNOqL7jqQwRLMX1KMS0a;cBGO",3), //21
	new Array(1,"NdqNjQbPRNaNhxKMNOqL7jqQyPbQS0a;cBGO",3), //22
	new Array(1,"NdqNjQbPRNaNhxKMFOqLcMqMdzGAEdaP",3), //23
	new Array(1,"NdqNjQbPRNaNhxKMFOqLcMqMlzWAEdaP",3), //24
	new Array(1,"NdqNjQbPRNaNhxKMFOqL7NqMclaMi23AVpKM",3), //25
	new Array(1,"NdqNjQbPRNaNhxKMFOqL7NqMclaMiC3AVpKM",3), //26
	new Array(1,"NdqNjQbPRNaNhxKMFOqL7NqMclaMLuqLKBrPVpKM",3), //27
	new Array(1,"NdqNjQbPRNaNhxKMFOqL7NqMDk6PVr2QEdaP",3), //28
	new Array(1,"NdqNjQbPRNaNhxKMLOqLNrqR1T7RqUqMVpKM",3), //29
	new Array(1,"NdqNjQbPRNaNhxKMLOqLOrqRS0a;cBGO",3), //30
	new Array(1,"NdqNjQbPRNaNhxKMLOqLOrqRFeqL1r2REdaP",3), //31
	new Array(1,"NdqNjQbPRNaNhxKM:OqLaELMVpKM",3), //32
	new Array(1,"NdqNjQbPRNaNhxKM:KqLTEqPdqGSEdaP",3), //33
	new Array(1,"NdqNjQbPRNaNhxKMFeqLC:6RVpKM",3), //34
	new Array(1,"NdqNjQbPRNaNhxKMFeqLC66RVpKM",3), //35
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMA9qNmM6OjoKOTSqLK0rNVpKM",3), //36
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMA9qNmM6OjoKONKrLGP6R:GqL;sqP577RasKMVpKM",3), //37
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMA9qNmM6OjoKONKrLGP6R:GqLDsqP4xKNS0a;cBGO",3), //38
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMA9qNmM6OjoKONKrLGP6R:OrL6MKNVpKM",3), //39
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMi86O3d7Nq;aQ1r2REdaP",3), //40
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMHk5PLQLObnaQjoKOS0a;cBGO",3), //41
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMZ77Qm;6QjoKONyqLpXaQ1r2REdaP",3), //42
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMXnZQLQLObnaQjoKOS0a;cBGO",3), //43
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nLS0a;cBGO",3), //44
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nLLOrLFKrLHN6N177RUEKO1r2REdaP",3), //45
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMtTrQjQaPi23AVpKM",3), //46
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RdzGAEdaP",3), //47
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMKfqR9t6Nzw6PtTrQNQaPSFaPVpKM",3), //48
	new Array(1,"NdqNjQbPRNaNhxKMN:rLmP6QudKMVz6QSNaPVpKM",3), //49
	new Array(1,"NdqNjQbPRNaNhxKML2rLKfqRNpmNEdaP",3), //50
	new Array(1,"NdqNjQbPRNaNhxKMB2rL1lZPlzWAEdaP",3), //51
	new Array(1,"NdqNjQbPRNaNhxKMB2rLTkZPJJaNN0bPSOaRVpKM",3), //52
	new Array(1,"NdqNjQbPRNaNhxKMR6rL91LNRnpRSRaPVpKM",3), //53
	new Array(1,"NdqNjQbPRNaNhxKMR6rL91LNRnpRjQaP3daN1r2REdaP",3), //54
	new Array(1,"NdqNjQbPRNaNhxKMR6rL91LNGnpRMvKRDk6PVr2QEdaP",3), //55
	new Array(1,"NdqNjQbPRNaNhxKMR6rL91LNGnpRMvKRDk6Pan5Qw0LOS0a;cBGO",3), //56
	new Array(1,"NdqNjQbPRNaNhxKMR6rL91LN8npRUPaQh5LMS0a;cBGO",3), //57
	new Array(1,"NdqNjQbPRNaNhxKMR6rL91LN8npRUPaQh5LMFGqLqSrQVpKM",3), //58
	new Array(1,"NdqNjQbPRNaNhxKMF6rL3n5Rd86OUmZQdzGAEdaP",3), //59
	new Array(1,"NdqNjQbPRNaNhxKMF6rL3n5Rd86OUmZQwvJADkpPhQKOeTrQjdKMiR7OVpKM",3), //60
	new Array(1,"NdqNjQbPRNaNhxKMH6rLYwKONyqLPdqNmNbMpxaM:OqLKBrPVpKM",3), //61
	new Array(1,"NdqNjQbPRNaNhxKMH6rLYwKONyqLPdqNmNbMpxaMNuqLNQaPSFaPVpKM",3), //62
	new Array(1,"NdqNjQbPRNaNhxKMH6rLYwKONyqLPdqNmNbMpxaMA6rLacLMVpKM",3), //63
	new Array(1,"NdqNjQbPRNaNhxKMH6rLYkJOBOrLyqaQVpKM",3), //64
	new Array(1,"NdqNjQbPRNaNhxKMH6rLukJO6qKRVpKM",3), //65
	new Array(1,"NdqNjQbPRNaNhxKMH6rLukJOBOrLyqaQVpKM",3), //66
	new Array(1,"NdqNjQbPRNaNhxKMH6rLvkJOEn6RS0a;cBGO",3), //67
	new Array(1,"NdqNjQbPRNaNhxKMA6rLgpKM:GqLaMKONx6NbuqLgfqQL2rLKfqRNpmNEdaP",3), //68
	new Array(1,"NdqNjQbPRNaNhxKMA6rLgpKM:GqLaMKONx6NL2rLKfqRNpmNEdaP",3), //69
	new Array(1,"NdqNjQbPRNaNhxKMA6rLgpKM:GqLaMKONx6Nb2rLgfqQL2rLKfqRNpmNEdaP",3), //70
	new Array(1,"NdqNjQbPRNaNhxKMA6rLgpKMSqqLSNaNifqQ9pGNEdaP",3), //71
	new Array(1,"NdqNjQbPRNaNhxKMA6rL8sqPPCqLDf6RFoWPEdaP",3), //72
	new Array(1,"NdqNjQbPRNaNhxKMA6rL8sqPR2rLlRKMS0a;cBGO",3), //73
	new Array(1,"NdqNjQbPRNaNhxKMNOrLQrKRS0a;cBGO",3), //74
	new Array(1,"NdqNjQbPRNaNhxKMEOrLbnaQN6qLqSrQVpKM",3), //75
	new Array(1,"NdqNjQbPRNaNhxKMEOrLbnaQF:rLqUqMVpKM",3), //76
	new Array(1,"NdqNjQbPRNaNhxKMEOrLbnaQNKrLVQLOSFaPVpKM",3), //77
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPw9aMHc6Pz;6RT33AZdKMS0a;cBGO",3), //78
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPw9aMHc6Pz;6RT33AthqMpHaQS0a;cBGO",3), //79
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPw9aMHc6Pz;6RT33ArjqQKRrPVpKM",3), //80
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPw9aMHc6Pz;6RT33AtTrQjQaPN5bNApKNCd7PVpKM",3), //81
	new Array(1,"NdqNjQbPRNaNhxKMNKrLzU6PaCHAVpKM",3), //82
	new Array(1,"NdqNjQbPRNaNhxKMNKrLzU6PSIqPPpKNhILOS0a;cBGO",3), //83
	new Array(1,"NdqNjQbPRNaNhxKMFKrLHN6N177RUEKOIn5R;kpPLQLOthqML4LOi23AVpKM",3), //84
	new Array(1,"NdqNjQbP48KP:lJNYxKMKkqPL2qLLRLMT;3AtTrQjQaPN5bNApKNCd7PVpKM",3), //85
	new Array(1,"NdqNjQbP48KPPlJNocqOBk5PVFKMh5qMw5aMAlJNUnaQS0a;cBGO",3), //86
	new Array(1,"NdqNjQbP48KPPlJNocqOBk5PVFKMh5qMw5aM4lJNgpKMjoKOS0a;cBGO",3), //87
	new Array(1,"NdqNjQbP48KPPlJNocqOBk5PVFKMh5qMw5aMPlJNN;6RS0a;cBGO",3), //88
	new Array(1,"NdqNjQbP48KPQlJNIkqPN2qL9w6PtTrQ9;nLFCqL9oGPEdaP",3), //89
	new Array(1,"NdqNjQbP48KPQlJNIkqPN2qL9w6PtTrQ9;nLE6qLj5LM9pGNEdaP",3), //90
	new Array(1,"NdqNjQbP48KPQlJNIkqPN2qL9w6PtTrQ9;nLE6rLAkqPS0a;cBGO",3), //91
	new Array(1,"NdqNjQbP48KPQlJNIkqPN2qL9w6PtTrQ9;nLA6rLgpKM:GqLaMKONx6NS0a;cBGO",3), //92
	new Array(1,"NdqNjQbP48aP97LR1k5P1T7R7VqMi23AVpKM",3), //93
	new Array(1,"NdqNjQbP48aP97LR1k5P1T7R7VqMiC3AVpKM",3), //94
	new Array(1,"NdqNjQbP48aP97LR4k5Ph0KOi23AVpKM",3), //95
	new Array(1,"NdqNjQbP48aP97LR4k5Ph0KOiC3AVpKM",3), //96
	new Array(1,"NdqNjQbP48aP97LR4k5Ph0KOL2qLlD3SS0a;cBGO",3), //97
	new Array(1,"NdqNjQbP48aP97LR4k5Ph0KOL2qLmD3SS0a;cBGO",3), //98
	new Array(1,"NdqNjQbP48aP97LR4k5Ph0KOL2qLgm5S8kqPS0a;cBGO",3), //99
	new Array(1,"NdqNjQbP48aP97LR4k5Ph0KOLuqLKBrPVpKM",3), //100
	new Array(1,"NdqNjQbP48aP97LR4k5Pb;aQS0a;cBGO",3), //101
	new Array(1,"NdqNjQbP48aP97LR5k5PM0aPwpKMS0a;cBGO",3), //102
	new Array(1,"NdqNjQbP48aP97LR7k5PURLM15LNjEaPDFKNtrmQEdaP",3), //103
	new Array(1,"NdqNjQbP48aP97LR7k5PURLM15LNjEaPmM6OlpWMEdaP",3), //104
	new Array(1,"NdqNjQbP48aP97LR7k5PURLM15LNjEaPA;qRr5LNT5bNQ0LPlPaQ9oGPEdaP",3), //105
	new Array(1,"NdqNjQbP48aP97LR7k5PURLM15LNjEaPA;qRr5LNT5bNBELPCx6PVpKM",3), //106
	new Array(1,"NdqNjQbP48aP97LR7k5PURLM15LNjEaPA;qRr5LN577R9pGNEdaP",3), //107
	new Array(1,"NdqNjQbP48aP97LR8k5PgpKMu2KSwJKMS0a;cBGO",3), //108
	new Array(1,"NdqNjQbP48aP97LRAk5PF6rLGn5RFErPSFaPVpKM",3), //109
	new Array(1,"NdqNjQbP48aP97LREk5PFQrPJoqPVVKMSFaPVpKM",3), //110
	new Array(1,"NdqNjQbP48aP97LREk5PUPaQV5LMjEaPO8KPgMqOS0a;cBGO",3), //111
	new Array(1,"NdqNjQbP48aP97LRGk5PrrKRaCHAVpKM",3), //112
	new Array(1,"NdqNjQbP48aP97LRGk5PrrKRSIqPPpKNhILOS0a;cBGO",3), //113
	new Array(1,"NdqNjQbP48aP97LRGk5PF6rLGn5RFErPSFaPVpKM",3), //114
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOi23AVpKM",3), //115
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOT33Azn6RQfqRQ1LNt;aQAhqNS0a;cBGO",3), //116
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOiC3AVpKM",3), //117
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOTD3Azn6RQfqRQ1LNt;aQAhqNS0a;cBGO",3), //118
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOi:3AVpKM",3), //119
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOT;3Azn6RQfqRQ1LNt;aQAhqNS0a;cBGO",3), //120
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOiK3AVpKM",3), //121
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOTL3Azn6RQfqRQ1LNt;aQAhqNS0a;cBGO",3), //122
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOiG3AVpKM",3), //123
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOTH3Azn6RQfqRQ1LNt;aQAhqNS0a;cBGO",3), //124
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOthqML4LOi23AVpKM",3), //125
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOthqML4LOT33Azn6RQfqRQ1LNt;aQAhqNS0a;cBGO",3), //126
	new Array(1,"NdqNjQbP48aP97LRHk5PC;6REk5NdzGAEdaP",3), //127
	new Array(1,"NdqNjQbP48aP97LRHk5PC;6RAl5NQJKNhhKMaQKMVpKM",3), //128
	new Array(1,"NdqNjQbP48aP97LRHk5PC;6RDl5NJJaNN0bPSOaRVpKM",3), //129
	new Array(1,"NdqNjQbP48aP97LRHk5PC;6RDl5NCR6PVpKM",3), //130
	new Array(1,"NdqNjQbP48aP97LRHk5PC;6RHl5N177RUEKO1r2REdaP",3), //131
	new Array(1,"NdqNjQbP48aP97LRHk5PC;6RLl5NhQKOeTrQjdKMiR7OVpKM",3), //132
	new Array(1,"NdqNjQbP48aP97LRIk5Pj47OPnpRw1LMS0a;cBGO",3), //133
	new Array(1,"NdqNjQbP48aP97LRIk5Pj47O8npRX0KOS0a;cBGO",3), //134
	new Array(1,"NdqNjQbP48aP97LRIk5Pj47ODnpRwdKMjoKOS0a;cBGO",3), //135
	new Array(1,"NdqNjQbP48aP97LRLk5PXxKM:DnLS0a;cBGO",3), //136
	new Array(1,"NdqNjQbP48aP97LRLk5PXxKMSqqLSNaNifqQ9pGNEdaP",3), //137
	new Array(1,"NdqNjQbP48aP97LRLk5PS9KNjoKOS0a;cBGO",3), //138
	new Array(1,"NdqNjQbP48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQ9;nLS0a;cBGO",3), //139
	new Array(1,"NdqNjQbP48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQ:;nLS0a;cBGO",3), //140
	new Array(1,"NdqNjQbP48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQ;;nLS0a;cBGO",3), //141
	new Array(1,"NdqNjQbP48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQA;nLS0a;cBGO",3), //142
	new Array(1,"NdqNjQbP48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQB;nLS0a;cBGO",3), //143
	new Array(1,"NdqNjQbP48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQE6qLudKM9;nLS0a;cBGO",3), //144
	new Array(1,"NdqNjQbPHAbPNOrLBrKRjnpQKMrP1p2NEdaP",3), //145
	new Array(1,"NdqNjQbPk;6Q95LNs4LOC86P9pGNEdaP",3), //146
	new Array(1,"NdqNjQbPZ77Qm;6QjoKONyqLpXaQ1r2REdaP",3), //147
	new Array(1,"NdqNjQbPbnaQjoKOS0a;cBGO",3), //148
	new Array(1,"NdqNjQbPyPbQ:DnLS0a;cBGO",3), //149
	new Array(1,"NdqNjQbPyPbQSqqLSNaNifqQ9pGNEdaP",3), //150
	new Array(1,"NdqNjQbPxPqQj;qQKSqL1p2NEdaP",3), //151
	new Array(1,"NdqNjQbPxPqQj;qQKSqL6l5Nw0LOS0a;cBGO",3), //152
	new Array(1,"NdqNjQbPxPqQj;qQBWqL4ALP8kqPS0a;cBGO",3), //153
	new Array(1,"NdqNjQbPxPqQj;qQBWqL4ALP8kqPFGqLqSrQVpKM",3), //154
	new Array(1,"NdqNjQbPxPqQj;qQ::rL9BLNyOaQVpKM",3), //155
	new Array(1,"NdqNjQbPxPqQj;qQ::rL9BLNDPaQ3daN1r2REdaP",3), //156
	new Array(1,"NdqNjQbPgfqQ9;nLS0a;cBGO",3), //157
	new Array(1,"NdqNjQbPgfqQ9;nLLOrLFKrLHN6N177RUEKO1r2REdaP",3), //158
	new Array(1,"NdqNjQbPgfqQE6qLudKM9;nLS0a;cBGO",3), //159
	new Array(1,"NdqNjQbPgfqQE6qLudKM9;nLLOrLFKrLHN6N177RUEKO1r2REdaP",3), //160
	new Array(1,"NdqNjQbPlXqQbuqLGP7RFoWPEdaP",3), //161
	new Array(1,"NdqNjQbPlXqQB2rLFoWPEdaP",3), //162
	new Array(1,"NdqNjQbPlXqQb2rLGP7RFoWPEdaP",3), //163
	new Array(1,"NdqNjQbPlXqQA6rLKBrPVpKM",3), //164
	new Array(1,"NdqNjQbPtTrQjQaPN5bNApKNzc7PHk5PLQLObnaQjoKOS0a;cBGO",3), //165
	new Array(1,"NdqNjQbPtTrQjQaPN5bNApKNzc7PbnaQjoKOS0a;cBGO",3), //166
	new Array(1,"NdqNjQbPtTrQjQaPN5bNApKNzc7PXnZQLQLObnaQjoKOS0a;cBGO",3), //167
	new Array(1,"NdqNjQbPtTrQjQaPSIqPPpKNhILOS0a;cBGO",3), //168
	new Array(1,"NdqNjQbPrTrQrALPw1KMakKOS0a;cBGO",3), //169
	new Array(1,"NdqNjQbPrTrQrALPlPaQCc7NVpKM",3), //170
	new Array(1,"NdqNjQbPJ;6RSRbPVpKM",3), //171
	new Array(1,"NdqNjQbPGj6RbErPf9qM1r2REdaP",3), //172
	new Array(1,"NdqNjQbPGj6RbErPXf6QtomOEdaP",3), //173
	new Array(1,"NdqNjQbPGj6RbErPF;qRCf6RNpmNEdaP",3), //174
	new Array(1,"NdqNjQbPI;qRdlpOlzWAEdaP",3), //175
	new Array(1,"NdqNjQbPI;qRrkpOJJaNN0bPSOaRVpKM",3), //176
	new Array(1,"NdqNjQbPQfqRQ1LNt;aQAhqNLOrLF6rLEm5RdzGAEdaP",3), //177
	new Array(1,"NdqNjQbPQfqRQ1LNt;aQAhqNLOrLF6rL3n5Rd86OUmZQdzGAEdaP",3), //178
	new Array(1,"NdqNKkZP9tKNzM6P3d6N:lJNbgrPDk6PVr2QEdaP",3), //179
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RFkZP2EaPdqGSEdaP",0), //180
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RFkZPt3rQQzKRk16:aWGAVpKM",0), //181
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RFkZPt3rQQzKRkJ7:aWGAVpKM",0), //182
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RFkZPt3rQQzKRS0a;cBGO",0), //183
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RGkZP1QqPS0a;cBGO",0), //184
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RHkZPZM6OlrWQEdaP",0), //185
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RHkZPIk6PnM6OS0a;cBGO",0), //186
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RHkZPyebQVpKM",0), //187
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RIkZPf0LO:MrPhFKMS0a;cBGO",0), //188
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RKkZPIwqPJErP9pGNEdaP",0), //189
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RLkZPpPaQCf6RNpmNEdaP",0), //190
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RMkZPgpKMtxqMVr2QEdaP",0), //191
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RMkZPDrKRyebQVpKM",0), //192
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RQkZPjNLMVo2OEdaP",0), //193
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RRkZP9pGNEdaP",0), //194
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RRkZP13LRtpmMEdaP",0), //195
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RRkZP13LRqNqM1p2NEdaP",0), //196
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RRkZP13LRg1rMw5LMS0a;cBGO",0), //197
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RSkZPNomPEdaP",0), //198
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R0kZPN86PS0a;cBGO",0), //199
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R0kZP1M6PqOqQVpKM",0), //200
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R1kZPPPKRDf6RFoWPEdaP",0), //201
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R2kZPBTKRS0a;cBGO",0), //202
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R3kZP4MKP1o2PEdaP",0), //203
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R3kZPM7LRXfaQ9pGNEdaP",0), //204
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R9kZP90LNS0a;cBGO",0), //205
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R9kZP60LNVpKM",0), //206
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPjpKMyebQVpKM",0), //207
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPv1LMYNLM1j2Rd23AS0a;cBGO",0), //208
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPv1LMYNLMIj2Rd23AS0a;cBGO",0), //209
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPv1LMYNLM1r2REdaP",0), //210
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPxhqM64LNVpKM",0), //211
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPrxqM5j6RtrmQEdaP",0), //212
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPV5rMS0a;cBGO",0), //213
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPHd6NhlqMr;aQ9pGNEdaP",0), //214
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPJxaNVq2SEdaP",0), //215
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPQlaNLk6P6NKPVpKM",0), //216
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPR5rN1RLNSFaPVpKM",0), //217
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPi86OA16NaALMVpKM",0), //218
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPiM7O15rNS0a;cBGO",0), //219
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPJ86PKgqNVpKM",0), //220
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqP6NKPVpKM",0), //221
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPPMLPa1KOVpKM",0), //222
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPSlaPVpKM",0), //223
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPVz6QdqGSEdaP",0), //224
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPZz6Qh1LMS0a;cBGO",0), //225
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPhPLQlTrQKpqPVpKM",0), //226
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPoPbQ9pGNEdaP",0), //227
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPxvqQCx6PVpKM",0), //228
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPePrQd77QqOqQVpKM",0), //229
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPvOKSdxG8EdaP",0), //230
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPvOKSS0a;cBGO",0), //231
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaP7TrQtTrQjQaPN5bNApKNCd7PVpKM",0), //232
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaP7TrQD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //233
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaP7TrQD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //234
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NBn5RVFKMvlpMw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //235
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NBn5RVFKMvlpMw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //236
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NHn5RC;6R6l5NpfaQQQaPdqGSEdaP",0), //237
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NLn5RXxKM:GqLaMKONx6NS0a;cBGO",0), //238
	new Array(1,"NdqNjQbPDn6RHk5P6;6RGlZNOc6PW:aSI17NvfaQMlJNnnaQP1LNjoKOi23AVpKM",0), //239
	new Array(1,"NdqNjQbPDn6RHk5P6;6RGlZNOc6PW:aSI17NvfaQMlJNnnaQP1LNjoKOiC3AVpKM",0), //240
	new Array(1,"NdqNjQbPDn6RAk5PfpKM9lJN1T7RcUqMdzGAEdaP",0), //241
	new Array(1,"NdqNjQbPDn6RAk5PfpKM9lJN1T7RcUqMlzWAEdaP",0), //242
	new Array(1,"NdqNjQbPDn6RAk5PfpKM9lJN1T7RcUqMtzmAEdaP",0), //243
	new Array(1,"NdqNjQbPDn6RAk5PfpKMClJNpfaQQQaPumJS6qKRVpKM",0), //244
	new Array(1,"NdqNjQbPDn6RAk5PfpKMClJNpfaQQQaPzmJSXxKMS0a;cBGO",0), //245
	new Array(1,"NdqNjQbPDn6RAk5PfpKM7lJNJJaNN0bPjPaRyPbQS0a;cBGO",0), //246
	new Array(1,"NdqNjQbPDn6RAk5PfpKM7lJNJJaNN0bPjPaRI;qRtomOEdaP",0), //247
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNC;6R6l5NpfaQQQaPdqGSEdaP",0), //248
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNC;6RDl5NJJaNN0bPSOaRVpKM",0), //249
	new Array(1,"NdqNjQbPRNaNhxKMICqLxhqMPcKPz37RtTrQjQaPN5bNApKNCd7PVpKM",0), //250
	new Array(1,"NdqNjQbPRNaNhxKMICqLxhqMPcKPz37RtTrQjQaPYQKONAHNS0a;cBGO",0), //251
	new Array(1,"NdqNjQbPRNaNhxKMICqLxhqMrcLPlPaQCd6NL5qNKVqPVpKM",0), //252
	new Array(1,"NdqNjQbPRNaNhxKM0CqL0CqLjoKOS0a;cBGO",0), //253
	new Array(1,"NdqNjQbPRNaNhxKM:2qLakKOv1KM:nqR1p2NEdaP",0), //254
	new Array(1,"NdqNjQbPRNaNhxKM:2qLakKOv1KM:nqR5l5NNQaPSFaPVpKM",0), //255
	new Array(1,"NdqNjQbPRNaNhxKMB6qLlTbQLoKOo9qMFB3PS0a;cBGO",0), //256
	new Array(1,"NdqNjQbPRNaNhxKMB6qLlTbQLoKOo9qMGB3PS0a;cBGO",0), //257
	new Array(1,"NdqNjQbPRNaNhxKM16qL94KPC17PVpKM",0), //258
	new Array(1,"NdqNjQbPRNaNhxKM16qL94KPz07P48aP97LRHk5PC;6R6l5NpfaQQQaPdqGSEdaP",0), //259
	new Array(1,"NdqNjQbPRNaNhxKM16qL94KPz07PyPbQS0a;cBGO",0), //260
	new Array(1,"NdqNjQbPRNaNhxKM16qL94KPz07PtTrQjQaPN5bNApKNCd7PVpKM",0), //261
	new Array(1,"NdqNjQbPRNaNhxKM16qL94KPz07PI;qRtomOEdaP",0), //262
	new Array(1,"NdqNjQbPRNaNhxKMNOqLrTbQhtKMEOrLbnaQS0a;cBGO",0), //263
	new Array(1,"NdqNjQbPRNaNhxKMNOqLrTbQhtKMNKrLaRLOVpKM",0), //264
	new Array(1,"NdqNjQbPRNaNhxKMROqLDcKPbQqP177RS1bPVpKM",0), //265
	new Array(1,"NdqNjQbPRNaNhxKMROqLrcKP7c6PnQ7OVP6QnnZQw1LMjoKOS0a;cBGO",0), //266
	new Array(1,"NdqNjQbPRNaNhxKMROqLrcKP7c6PnQ7OVP6QUnZQnnaQP1LNjoKOS0a;cBGO",0), //267
	new Array(1,"NdqNjQbPRNaNhxKMROqLrcKP7c6PnQ7OGn6R9oGPEdaP",0), //268
	new Array(1,"NdqNjQbPRNaNhxKMLOqLI1rNrRKNyPbQS0a;cBGO",0), //269
	new Array(1,"NdqNjQbPRNaNhxKMLOqLI1rNrRKNtTrQSRaPVpKM",0), //270
	new Array(1,"NdqNjQbPRNaNhxKMLOqLOrqRLOrLA6rLgpKMS0a;cBGO",0), //271
	new Array(1,"NdqNjQbPRNaNhxKM:OqLbFKMTgaPyqaQVpKM",0), //272
	new Array(1,"NdqNjQbPRNaNhxKM:OqLrvKRLk6PS0a;cBGO",0), //273
	new Array(1,"NdqNjQbPRNaNhxKM:OqLrvKRLk6PA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //274
	new Array(1,"NdqNjQbPRNaNhxKM:OqLrvKRtvqQCx6PVpKM",0), //275
	new Array(1,"NdqNjQbPRNaNhxKM:OqLrvKRtvqQzw6PtTrQjQaPN5bNApKNCd7PVpKM",0), //276
	new Array(1,"NdqNjQbPRNaNhxKMTSqLD0rPQ4rPKvqLVpKM",0), //277
	new Array(1,"NdqNjQbPRNaNhxKMTSqLD0rPQ4rPK3rLVpKM",0), //278
	new Array(1,"NdqNjQbPRNaNhxKMJSqLFQrPboqPd;6Q5IaP1o2PEdaP",0), //279
	new Array(1,"NdqNjQbPRNaNhxKMCSqLV1LMKpqPVpKM",0), //280
	new Array(1,"NdqNjQbPRNaNhxKMNGqLljqQboqPPcKP;;6R9pGNEdaP",0), //281
	new Array(1,"NdqNjQbPRNaNhxKMNGqLljqQboqPI;qRtomOEdaP",0), //282
	new Array(1,"NdqNjQbPRNaNhxKM:LqLB2rLudKMekJOApKNnc6OxoqO60LNVpKM",0), //283
	new Array(1,"NdqNjQbPRNaNhxKM1KqLt37QA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //284
	new Array(1,"NdqNjQbPRNaNhxKMNeqLBsKPsnZQZtKM15LNSFaPVpKM",0), //285
	new Array(1,"NdqNjQbPRNaNhxKMNeqLBsKPbnZQwdKMS0a;cBGO",0), //286
	new Array(1,"NdqNjQbPRNaNhxKMNeqLGQaP4xKNS0a;cBGO",0), //287
	new Array(1,"NdqNjQbPRNaNhxKMNeqLGQaP4xKNA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //288
	new Array(1,"NdqNjQbPRNaNhxKMNeqLjQaPFA3NNmqLGP7RLxKMI;qRtomOEdaP",0), //289
	new Array(1,"NdqNjQbPRNaNhxKMNeqLjQaPNAHNNmqLGP7RLxKMtTrQjQaPi23AVpKM",0), //290
	new Array(1,"NdqNjQbPRNaNhxKMNeqLjQaPlB3ONmqLGP7RLxKMI;qRtomOEdaP",0), //291
	new Array(1,"NdqNjQbPRNaNhxKMNeqLjQaPFC3RNmqLGP7RLxKMI;qRtomOEdaP",0), //292
	new Array(1,"NdqNjQbPRNaNhxKMPiqL1tKNSNaPVpKM",0), //293
	new Array(1,"NdqNjQbPRNaNhxKMPiqL1tKNjMaPDk6PVr2QEdaP",0), //294
	new Array(1,"NdqNjQbPRNaNhxKMKiqLvPqQ1r2REdaP",0), //295
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQwRLMX1KMT33AB96NhFKMS0a;cBGO",0), //296
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQwRLMX1KMT33A2kaP48KPS0a;cBGO",0), //297
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQwRLMX1KMTD3AB96NhFKMS0a;cBGO",0), //298
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQwRLMX1KMTD3A2kaP48KPS0a;cBGO",0), //299
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQwRLMX1KMT;3AB96NhFKMS0a;cBGO",0), //300
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQwRLMX1KMT;3A2kaP48KPS0a;cBGO",0), //301
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQwRLMX1KMTL3AB96NhFKMS0a;cBGO",0), //302
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQwRLMX1KMTL3A2kaP48KPS0a;cBGO",0), //303
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQB96NhFKMS0a;cBGO",0), //304
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQRkKPSRbPVpKM",0), //305
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQtTrQKQaPpfaQQQaPdqGSEdaP",0), //306
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQGP7RFoWPEdaP",0), //307
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQKfqRS0a;cBGO",0), //308
	new Array(1,"NdqNjQbPRNaNhxKMKaqLUEKOHn5RC;6R6l5NpfaQQQaPdqGSEdaP",0), //309
	new Array(1,"NdqNjQbPRNaNhxKMRuqLQPaR6CLRVpKM",0), //310
	new Array(1,"NdqNjQbPRNaNhxKMNyqLPdqNN6qLlTrQjEaPN5bNApKNCd7PVpKM",0), //311
	new Array(1,"NdqNjQbPRNaNhxKMNyqLPdqNN6qLlTrQjEaPSIqPPpKNhILOS0a;cBGO",0), //312
	new Array(1,"NdqNjQbPRNaNhxKMNyqLPdqNReqLVxKMjEaPj77QfNqMqfqQAlpNRsqPS0a;cBGO",0), //313
	new Array(1,"NdqNjQbPRNaNhxKMNyqLPdqNReqLVxKMjEaPj77QfNqMqfqQAlpNPArPS0a;cBGO",0), //314
	new Array(1,"NdqNjQbPRNaNhxKMNyqLPdqN::rLR0qPl3rQjEaPEn6RrlpMJJaNN0bPSOaRVpKM",0), //315
	new Array(1,"NdqNjQbPRNaNhxKMNyqL2MbP9pGNEdaP",0), //316
	new Array(1,"NdqNjQbPRNaNhxKMRyqLs3aQwpKMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //317
	new Array(1,"NdqNjQbPRNaNhxKMFyqLGcaPYxKMKkqPIGqLaeKSNpmNEdaP",0), //318
	new Array(1,"NdqNjQbPRNaNhxKMFyqLGcaPYxKMKkqPIGqLaeKS:AnNS0a;cBGO",0), //319
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RHkZPQ7LRVPqQS0a;cBGO",0), //320
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RIkZPfpKMQlJNhCLSdpGMEdaP",0), //321
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RIkZPfpKMQlJNhCLSlpWMEdaP",0), //322
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RIkZPfpKMQlJNhCLStpmMEdaP",0), //323
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RIkZPfpKMQlJNhCLS1p2NEdaP",0), //324
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RLkZPMQLNdzGAEdaP",0), //325
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RLkZPMQLNlzWAEdaP",0), //326
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RLkZPMQLNtzmAEdaP",0), //327
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R2kZPBTKRi23AVpKM",0), //328
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R3kZPxxKMCO6RVpKM",0), //329
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R3kZPocqO6k5PYdKME6rLA4rPS0a;cBGO",0), //330
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R3kZPocqOHk5P;3KRP1LNS0a;cBGO",0), //331
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R4kZPKdrPVpKM",0), //332
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R9kZPr1LN2laNB6qL337RBpKNS0a;cBGO",0), //333
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQPlJNd77QCO6RVpKM",0), //334
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMD8KPL0KOljqQAxKNS0a;cBGO",0), //335
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nL8DqLdzGAEdaP",0), //336
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nL8PqLdzGAEdaP",0), //337
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nL8fqLdzGAEdaP",0), //338
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nLKPrLVpKM",0), //339
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nLLOrLFKrLHN6N177RUEKO1n5Ri23AVpKM",0), //340
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nLLOrLFKrLHN6N177RUEKO4n5Ri23AVpKM",0), //341
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nLLOrLFKrLHN6N177RUEKO5n5Ri23AVpKM",0), //342
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nLLOrLFKrLHN6N177RUEKO8n5Ri23AVpKM",0), //343
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nLLOrLFKrLHN6N177RUEKOIn5RS0a;cBGO",0), //344
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nLS0a;cBGO",0), //345
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nL8DqLdzGAEdaP",0), //346
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nLKPrLVpKM",0), //347
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nLLOrLFKrLHN6N177RUEKO1r2REdaP",0), //348
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nLLOrLFKrLHN6N177RUEKOEm5RpvZAi23AVpKM",0), //349
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nLLOrLFKrLHN6N177RUEKOEm5RsvZAi23AVpKM",0), //350
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nLLOrLFKrLHN6N177RUEKO1n5Ri23AVpKM",0), //351
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nLLOrLFKrLHN6N177RUEKO4n5Ri23AVpKM",0), //352
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nLLOrLFKrLHN6N177RUEKOIn5RS0a;cBGO",0), //353
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ;;nLS0a;cBGO",0), //354
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ;;nLLOrLFKrLHN6N177RUEKO1r2REdaP",0), //355
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQB;nLS0a;cBGO",0), //356
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQB;nLLOrLFKrLHN6N177RUEKO1r2REdaP",0), //357
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQE6qLudKM9;nLKLqLVpKM",0), //358
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQE6qLudKM9;nLLOrLFKrLHN6N177RUEKO7n5RS0a;cBGO",0), //359
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQE6qLudKM:;nLS0a;cBGO",0), //360
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQE6qLudKM:;nLLOrLFKrLHN6N177RUEKO1r2REdaP",0), //361
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQE6qLudKM;;nLS0a;cBGO",0), //362
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQE6qLudKM;;nLLOrLFKrLHN6N177RUEKO1r2REdaP",0), //363
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQLyqLKpqPVpKM",0), //364
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMtTrQjQaPi:3AVpKM",0), //365
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMtTrQjQaPiK3AVpKM",0), //366
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RdvJAi23AVpKM",0), //367
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RgvJAi23AVpKM",0), //368
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RhvJAi23AVpKM",0), //369
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RUvJAi23AVpKM",0), //370
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RwvJAS0a;cBGO",0), //371
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RlzWAEdaP",0), //372
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RlvZAi23AVpKM",0), //373
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RpvZAi23AVpKM",0), //374
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RsvZAi23AVpKM",0), //375
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RYvZAS0a;cBGO",0), //376
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RtzmAEdaP",0), //377
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5R9zGBEdaP",0), //378
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rL3n5Rd86OUmZQjvJAS0a;cBGO",0), //379
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rL3n5Rd86OUmZQlzWAEdaP",0), //380
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rL3n5Rd86OUmZQtzmAEdaP",0), //381
	new Array(1,"NdqNjQbPRNaNhxKM8mqLjlpMARKNjoKO557Ne3rQQpKNS0a;cBGO",0), //382
	new Array(1,"NdqNjQbPRNaNhxKM8mqLjlpMARKNjoKO557Ne3rQQpKNNOrLCV6PVpKM",0), //383
	new Array(1,"NdqNjQbPRNaNhxKMI:rLhpKMS0a;cBGO",0), //384
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QDn5RMMaPgpKM:KqLQNKNjoKOS0a;cBGO",0), //385
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QDn5RMMaPgpKMLeqLp3bQF2rLCd6NKlpNxRLMw;aQ9;nLA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //386
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QDn5RMMaPgpKMLeqLp3bQF2rLCd6NKlpNxRLMw;aQ:;nLA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //387
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QDn5RMMaPgpKMNuqL0HKRS0a;cBGO",0), //388
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QDn5RMMaPgpKMF6rL1r2REdaP",0), //389
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QDn5RMMaPgpKMF6rLIn5RDkpPhQKOeTrQjdKMiR7OVpKM",0), //390
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QDn5RMMaPgpKMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //391
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QDn5RMMaPgpKMFKrLHN6N177RUEKOIn5R;kpPaRLOVpKM",0), //392
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QIn5REnqRgpKM:KqLQNKNjoKOS0a;cBGO",0), //393
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QIn5REnqRgpKMLeqLp3bQF2rLCd6NKlpNxRLMw;aQ9;nLA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //394
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QIn5REnqRgpKMLeqLp3bQF2rLCd6NKlpNxRLMw;aQ:;nLA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //395
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QIn5REnqRgpKMNuqL0HKRS0a;cBGO",0), //396
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QIn5REnqRgpKMF6rL1r2REdaP",0), //397
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QIn5REnqRgpKMF6rLIn5RDkpPhQKOeTrQjdKMiR7OVpKM",0), //398
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QIn5REnqRgpKMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //399
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QIn5REnqRgpKMFKrLHN6N177RUEKOIn5R;kpPaRLOVpKM",0), //400
	new Array(1,"NdqNjQbPRNaNhxKML2rLY:KSfxKMhM6Ow0LOA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //401
	new Array(1,"NdqNjQbPRNaNhxKMF6rL5n5RaQLMVpKM",0), //402
	new Array(1,"NdqNjQbPRNaNhxKMA6rLgpKM:GqLaMKONx6N9;nLS0a;cBGO",0), //403
	new Array(1,"NdqNjQbPRNaNhxKMA6rLgpKM:GqLaMKONx6N:;nLS0a;cBGO",0), //404
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPNAHNACqL3;6RclpOXvZAd77QCO6RVpKM",0), //405
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPNAHNFGqLljqQjEaPg9qMlhqMSFaPVpKM",0), //406
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPNAHNFGqLljqQjEaPg9qMlhqMjEaPN9aNGM7P9pGNEdaP",0), //407
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPNAHNFGqLljqQjEaPGj6RFErPjEaPTxaNaQLMVpKM",0), //408
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPNAHNFGqLljqQjEaPF;qRCf6R8kpNdzGAEdaP",0), //409
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPNAHNFGqLljqQjEaPF;qRCf6R8kpNqvZA9tKNCN6PVpKM",0), //410
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPOBHPI:rLVdLMjEaPdD7QAc6PdoGOEdaP",0), //411
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPOBHPI:rLVdLMjEaPdD7QAc6PzkJOXxKMS0a;cBGO",0), //412
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPOBHPA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //413
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPEBHPI:rLVdLMjEaPhnqQc;qQik6O9pGNEdaP",0), //414
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPEBHPA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //415
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaP7TrQ157NOnpRX1KM1o2PEdaP",0), //416
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPVDXSB2rLKkZPpfaQQQaPdqGSEdaP",0), //417
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPVDXSB2rLTkZPJJaNN0bPSOaRVpKM",0), //418
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPVDXSA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //419
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPVDXSA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //420
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPVDXSNKrLzU6PN5bNApKNCd7PVpKM",0), //421
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPVDXSNKrLzU6PSIqPPpKNhILOS0a;cBGO",0), //422
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPWDXSB2rLKkZPpfaQQQaPdqGSEdaP",0), //423
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPWDXSA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //424
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPWDXSNKrLzU6PN5bNApKNCd7PVpKM",0), //425
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPXDXSF6rL3n5Rd86OUmZQuvJAvdKM9hKNSRaPVpKM",0), //426
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPXDXSF6rLGn5RvdKM9hKNSRaPVpKM",0), //427
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPXDXSA6rLgpKMN2rLh0LOi86O1p2NEdaP",0), //428
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPYDXSB2rLKkZPpfaQQQaPdqGSEdaP",0), //429
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPYDXSA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //430
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPYDXSA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //431
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPYDXS;SrLjoKO:uqLKRqPVpKM",0), //432
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPYDXSNKrLzU6PN5bNApKNCd7PVpKM",0), //433
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPZDXSB2rLKkZPpfaQQQaPdqGSEdaP",0), //434
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPZDXSA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //435
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPZDXSNKrLzU6PN5bNApKNCd7PVpKM",0), //436
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPgNrMCf6R:FqNhBLMS0a;cBGO",0), //437
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AwRLMX1KM9;nLS0a;cBGO",0), //438
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AwRLMX1KM:;nLS0a;cBGO",0), //439
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AwRLMX1KM;;nLS0a;cBGO",0), //440
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AplqMY9aML6qLQrKR64LNVpKM",0), //441
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AplqMY9aMJ6rLU1LMS0a;cBGO",0), //442
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AplqMY9aMFKrLRQaPYwKOA6rLgpKMjoKOS0a;cBGO",0), //443
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33A157NNrmREdaP",0), //444
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //445
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //446
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //447
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //448
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //449
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33A48aP97LRGk5P6qKRVpKM",0), //450
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33A48aP97LRLk5PXxKMS0a;cBGO",0), //451
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33ASIqPPpKNhILOB2rLFoWPEdaP",0), //452
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33ASIqPPpKNhILONKrLCV6PVpKM",0), //453
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //454
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AJ;6RSRbPVpKM",0), //455
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTD3AwRLMX1KM9;nLS0a;cBGO",0), //456
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTD3AwRLMX1KM:;nLS0a;cBGO",0), //457
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTD3AwRLMX1KM;;nLS0a;cBGO",0), //458
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTD3AplqMY9aML6qLQrKR64LNVpKM",0), //459
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTD3AplqMY9aMJ6rLU1LMS0a;cBGO",0), //460
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTD3A157NNrmREdaP",0), //461
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTD3AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //462
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTD3AJ;6RSRbPVpKM",0), //463
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //464
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //465
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KO2daN95KNzw6Pf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //466
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KO2daN95KNzw6Pf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //467
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KO2daN95KNzw6Pj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //468
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //469
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //470
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOh0KOxDrQL5LMf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //471
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOh0KOxDrQL5LMf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //472
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOh0KOxDrQL5LMj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //473
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //474
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOJj6RJQaPnnZQw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //475
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOJj6RJQaPnnZQw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //476
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOJj6RJQaPUnZQnnaQP1LNjoKOLOrLT36QSIqPPpKNhILOS0a;cBGO",0), //477
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTH3AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //478
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTH3AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //479
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTH3AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //480
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTH3AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //481
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTH3AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //482
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NT33AwRLMX1KM9;nLS0a;cBGO",0), //483
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NT33AwRLMX1KM:;nLS0a;cBGO",0), //484
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NT33AwRLMX1KM;;nLS0a;cBGO",0), //485
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NT33AplqMY9aML6qLQrKR64LNVpKM",0), //486
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NT33AplqMY9aMJ6rLU1LMS0a;cBGO",0), //487
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NT33A157NNrmREdaP",0), //488
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //489
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NTD3AwRLMX1KM9;nLS0a;cBGO",0), //490
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NTD3AwRLMX1KM:;nLS0a;cBGO",0), //491
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NTD3AwRLMX1KM;;nLS0a;cBGO",0), //492
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NTD3AplqMY9aML6qLQrKR64LNVpKM",0), //493
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NTD3AplqMY9aMJ6rLU1LMS0a;cBGO",0), //494
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NTD3A157NNrmREdaP",0), //495
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NTD3AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //496
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5ND3XAwRLMX1KM9;nLS0a;cBGO",0), //497
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5ND3XAwRLMX1KM:;nLS0a;cBGO",0), //498
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5ND3XAwRLMX1KM;;nLS0a;cBGO",0), //499
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5ND3XAplqMY9aML6qLQrKR64LNVpKM",0), //500
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5ND3XAplqMY9aMJ6rLU1LMS0a;cBGO",0), //501
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5ND3XAtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //502
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NDDXAwRLMX1KM9;nLS0a;cBGO",0), //503
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NDDXAwRLMX1KM:;nLS0a;cBGO",0), //504
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NDDXAwRLMX1KM;;nLS0a;cBGO",0), //505
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NDDXAplqMY9aML6qLQrKR64LNVpKM",0), //506
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NDDXAplqMY9aMJ6rLU1LMS0a;cBGO",0), //507
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NDDXAtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //508
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33AwRLMX1KMi23AVpKM",0), //509
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33AwRLMX1KMiC3AVpKM",0), //510
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33AwRLMX1KMi:3AVpKM",0), //511
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33AplqMY9aML6qLQrKR64LNVpKM",0), //512
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33AplqMY9aMJ6rLU1LMS0a;cBGO",0), //513
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33AplqMY9aMFKrLRQaPYwKOA6rLgpKMjoKOS0a;cBGO",0), //514
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33A157NNrmREdaP",0), //515
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33A48aP97LRGk5P6qKRVpKM",0), //516
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33ASIqPPpKNhILOB2rLFoWPEdaP",0), //517
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33ASIqPPpKNhILONKrLCV6PVpKM",0), //518
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //519
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33AJ;6RSRbPVpKM",0), //520
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NT33AwRLMX1KM9;nLS0a;cBGO",0), //521
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NT33AwRLMX1KM:;nLS0a;cBGO",0), //522
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NT33AwRLMX1KM;;nLS0a;cBGO",0), //523
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NT33AplqMY9aML6qLQrKR64LNVpKM",0), //524
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NT33AplqMY9aMJ6rLU1LMS0a;cBGO",0), //525
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NT33A157NNrmREdaP",0), //526
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //527
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NTD3AwRLMX1KM9;nLS0a;cBGO",0), //528
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NTD3AwRLMX1KM:;nLS0a;cBGO",0), //529
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NTD3AwRLMX1KM;;nLS0a;cBGO",0), //530
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NTD3AplqMY9aML6qLQrKR64LNVpKM",0), //531
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NTD3AplqMY9aMJ6rLU1LMS0a;cBGO",0), //532
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NTD3AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //533
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O7l5NQwqPFyqLScaPNpmNEdaP",0), //534
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AwRLMX1KMi23AVpKM",0), //535
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AwRLMX1KMi:3AVpKM",0), //536
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AplqMY9aML6qLQrKR64LNVpKM",0), //537
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AplqMY9aMJ6rLU1LMS0a;cBGO",0), //538
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AplqMY9aMFKrLRQaPYwKOA6rLgpKMjoKOS0a;cBGO",0), //539
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33A157NNrmREdaP",0), //540
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //541
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //542
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //543
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //544
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //545
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33A48aP97LRGk5P6qKRVpKM",0), //546
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33A48aP97LRHk5PC;6REk5NdzGAEdaP",0), //547
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33ASIqPPpKNhILOB2rLFoWPEdaP",0), //548
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33ASIqPPpKNhILONKrLCV6PVpKM",0), //549
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //550
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AJ;6RSRbPVpKM",0), //551
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OCl5NT33AwRLMX1KMi23AVpKM",0), //552
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OCl5NT33AwRLMX1KMiC3AVpKM",0), //553
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OCl5NT33AwRLMX1KMi:3AVpKM",0), //554
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OCl5NT33AplqMY9aML6qLQrKR64LNVpKM",0), //555
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OCl5NT33AplqMY9aMJ6rLU1LMS0a;cBGO",0), //556
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33AwRLMX1KMi23AVpKM",0), //557
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //558
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //559
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //560
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //561
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //562
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33A48aP97LRGk5P6qKRVpKM",0), //563
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33A48aP97LRHk5PC;6REk5NdzGAEdaP",0), //564
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33A48aP97LRLk5PXxKMS0a;cBGO",0), //565
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33ASIqPPpKNhILONKrLCV6PVpKM",0), //566
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33ArjqQFQrPjEaPy;aQbNqNi23AVpKM",0), //567
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //568
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AwRLMX1KMi23AVpKM",0), //569
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AwRLMX1KMi:3AVpKM",0), //570
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AplqMY9aML6qLQrKR64LNVpKM",0), //571
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AplqMY9aMJ6rLU1LMS0a;cBGO",0), //572
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AplqMY9aMFKrLRQaPYwKOA6rLgpKMjoKOS0a;cBGO",0), //573
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33A157NNrmREdaP",0), //574
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //575
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //576
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //577
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //578
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //579
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33A48aP97LRGk5P6qKRVpKM",0), //580
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33A48aP97LRHk5PC;6REk5NdzGAEdaP",0), //581
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33ASIqPPpKNhILONKrLCV6PVpKM",0), //582
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //583
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AJ;6RSRbPVpKM",0), //584
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMACqL3;6RclpOdzGAEdaP",0), //585
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMACqL3;6RclpOlzWAEdaP",0), //586
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMACqL3;6RclpOtzmAEdaP",0), //587
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXML6qL94KP3n5RKMrPGP6RS0a;cBGO",0), //588
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXML6qL94KPHn5RP8KPVo2OEdaP",0), //589
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMNOqL7jqQwRLMX1KMS0a;cBGO",0), //590
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMNOqL7jqQyPbQS0a;cBGO",0), //591
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMBKqLg5LMS0a;cBGO",0), //592
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMFeqL1n5RS0a;cBGO",0), //593
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMFeqL2n5RS0a;cBGO",0), //594
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMB2rLKkZPpfaQQQaPdqGSEdaP",0), //595
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMB2rLTkZPJJaNN0bPSOaRVpKM",0), //596
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //597
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //598
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMNOrLQrKRS0a;cBGO",0), //599
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMNKrLzU6PN5bNApKNCd7PVpKM",0), //600
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMNKrLzU6PSIqPPpKNhILOS0a;cBGO",0), //601
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMFKrLGQaPlPaQeMqO::rL9BLNyOaQVpKM",0), //602
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMFKrLGQaPlPaQeMqONKrLaRLOVpKM",0), //603
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMACqL3;6RclpOdzGAEdaP",0), //604
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMACqL3;6RclpOlzWAEdaP",0), //605
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMACqL3;6RclpOtzmAEdaP",0), //606
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXML6qL94KP3n5RKMrPGP6RS0a;cBGO",0), //607
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXML6qL94KPHn5RP8KPVo2OEdaP",0), //608
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMNOqL7jqQwRLMX1KMS0a;cBGO",0), //609
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMNOqL7jqQyPbQS0a;cBGO",0), //610
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMBKqLg5LMS0a;cBGO",0), //611
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMFeqL1n5RS0a;cBGO",0), //612
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMFeqL2n5RS0a;cBGO",0), //613
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMB2rLKkZPpfaQQQaPdqGSEdaP",0), //614
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMB2rLTkZPJJaNN0bPSOaRVpKM",0), //615
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //616
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //617
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMNOrLQrKRS0a;cBGO",0), //618
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMNKrLzU6PN5bNApKNCd7PVpKM",0), //619
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMNKrLzU6PSIqPPpKNhILOS0a;cBGO",0), //620
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMFKrLGQaPlPaQeMqO::rL9BLNyOaQVpKM",0), //621
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMFKrLGQaPlPaQeMqONKrLaRLOVpKM",0), //622
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaP157NOnpRX1KMS0a;cBGO",0), //623
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNdvJA806PFtKN:6qLVQLOo9qM0SqLjz6QrfqQFoWPEdaP",0), //624
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNdvJA806PFtKN:OqLaELMVpKM",0), //625
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNdvJA806PFtKN0SqLjz6QrfqQFoWPEdaP",0), //626
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNdvJA806PFtKNH6rLYwKON6qLlTrQSFaPVpKM",0), //627
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNdvJA806PFtKNH6rLYwKO::rLR0qPl3rQSFaPVpKM",0), //628
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNdvJA806PFtKNH6rLYwKO::rLR0qPl3rQ0FaPlzWAEdaP",0), //629
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNdvJA806PFtKNH6rLYwKO::rLR0qPl3rQ0FaPtzmAEdaP",0), //630
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNdvJA806PFtKNH6rLYwKO::rLR0qPl3rQ0FaP1z2BEdaP",0), //631
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNevJATD3AfxKMhM6OvmJSocqO3k5Pw1LMjoKOS0a;cBGO",0), //632
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPtAHMACqL3;6RclpOfvpAd77QCO6RVpKM",0), //633
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPtAHMB6qL9T7R4EaPpPaQS0a;cBGO",0), //634
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPtAHMNeqLpLbQlTrQjEaPN5rNapKOVpKM",0), //635
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPtAHMNeqLpLbQlTrQjEaPon6QbRLMS0a;cBGO",0), //636
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPtAHMLKrL;wqPq86OjoKOS0a;cBGO",0), //637
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPtAHMLKrL;wqPq86OjoKOReqLUEKO1r2REdaP",0), //638
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPuAHMNeqLBsKPyfaQNpmNEdaP",0), //639
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPuAHMFyqLScaPNpmNEdaP",0), //640
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPvAHML2qLzQ7PplqMydaMClJNpfaQQQaPbmJSjMaPi86O3l5Nw1LMjoKOS0a;cBGO",0), //641
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPvAHML2qLzQ7PplqMydaM7lJNJJaNN0bPjPaRRoqPNeqLjQaPf9qMCf6RNpmNEdaP",0), //642
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPvAHML2qLzQ7PplqMydaMQlJNbnqRi86O3l5Nw1LMjoKOS0a;cBGO",0), //643
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPvAHMI6rLU1LMN6qLlTrQSFaPVpKM",0), //644
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPvAHMI6rLU1LM::rLR0qPl3rQSFaPVpKM",0), //645
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLfvJAHkqPjoKO9;nLS0a;cBGO",0), //646
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLfvJAHkqPjoKO:;nLS0a;cBGO",0), //647
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLfvJAHkqPjoKO;;nLS0a;cBGO",0), //648
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLfvJAHkqPjoKOA;nLS0a;cBGO",0), //649
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLZvJAVFKMvlpMw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //650
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLZvJAVFKMvlpMw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //651
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLZvJAVFKMklpM49KNjoKO::rLR0qPl3rQjEaPBn6R9pGNEdaP",0), //652
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLZvJAVFKMklpM49KNjoKO::rLR0qPl3rQjEaPEn6RtpmMEdaP",0), //653
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLZvJAVFKMclpMnnaQP1LNjoKOLOrLT36QSIqPPpKNhILOS0a;cBGO",0), //654
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR17qLZuJCVFKMvlpMw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //655
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR17qLZuJCVFKMvlpMw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //656
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR17qLZuJCVFKMklpM49KNjoKO::rLR0qPl3rQjEaPBn6R9pGNEdaP",0), //657
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR17qLZuJCVFKMklpM49KNjoKO::rLR0qPl3rQjEaPEn6RtpmMEdaP",0), //658
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR17qLZuJCVFKMclpMnnaQP1LNjoKOLOrLT36QSIqPPpKNhILOS0a;cBGO",0), //659
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR:OqLLFLMG9aNi23AVpKM",0), //660
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQ:OqLaELMVpKM",0), //661
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQ0SqLjz6QrfqQFoWPEdaP",0), //662
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQ:GqLaMKONx6NS0a;cBGO",0), //663
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQFeqLC:6RVpKM",0), //664
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQKiqLtTrQCx6PVpKM",0), //665
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQKiqLtTrQEx6PlzWAEdaP",0), //666
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQSqqLSNaNifqQ9pGNEdaP",0), //667
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQE6rLAkqPS0a;cBGO",0), //668
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQE6rLAkqPR2rLlRKMS0a;cBGO",0), //669
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQKSrLvoKOA;6R1o2PEdaP",0), //670
	new Array(1,"NdqNjQbPRNaNhxKMLOrLVf6QyebQVpKM",0), //671
	new Array(1,"NdqNjQbPRNaNhxKMNKrLGP6RjoKOon6QS0a;cBGO",0), //672
	new Array(1,"NdqNjQbPRNaNhxKMNKrLGP6R4MKPKpqPVpKM",0), //673
	new Array(1,"NdqNjQbPRNaNhxKMRKrL9R6NjEaPTxaN:PqRNKrLCV6PVpKM",0), //674
	new Array(1,"NdqNjQbPRNaNhxKMRKrL9R6NjEaPQMLP4;KRL2qLKfqRNpmNEdaP",0), //675
	new Array(1,"NdqNjQbPRNaNhxKMRKrL9R6NjEaPI;qRtomOEdaP",0), //676
	new Array(1,"NdqNjQbPRNaNhxKMFKrLW:aSHl5NC;6R6l5NpfaQQQaPdqGSEdaP",0), //677
	new Array(1,"NdqNjQbP48aP97LR2k5PLk6PdFLMjmJSZnaQjQaPRNaNhxKMS0a;cBGO",0), //678
	new Array(1,"NdqNjQbP48aP97LR4k5PKErPqlZM9tKNCN6PVpKM",0), //679
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33A3daNic6ODlpNwdKMjoKO:;nLRGqL48KP9pGNEdaP",0), //680
	new Array(1,"f3KA333Rbk5Oa8KOGn5RFsqPGkpP1zKRrRLN2daN7TrQC96NqdqMGhmN1zKR1QLNS0a;cBGO",0), //681
	new Array(1,"f3KA333Rbk5Oa8KOGn5RFsqPGkpP1zKRrRLN2daN7TrQC96NqdqM:hmNFsqPKdmPVpKM",0), //682
	new Array(1,"f3KA3T3Rbk5Oa8KOEn5RN86Pr5LNzxaMqUqMVpKM",0), //683
	new Array(1,"f3KA3T3Rbk5Oa8KOEn5RN86Pr5LNzxaMcUqMlzWAEdaP",0), //684
	new Array(1,"f3KA3T3Rbk5Oa8KOEn5RN86Pr5LNzxaMlVqMSFaPVpKM",0), //685
	new Array(1,"f3KA3T3Rbk5Oa8KOEn5RN86Pr5LNzxaMgVqMA0rPgpKMS0a;cBGO",0), //686
	new Array(1,"f3KA3P3Rbk5Oa8KOEn5RN86Pr5LNA;6RdBnOS0a;cBGO",0), //687
	new Array(1,"f3KA3P3Rbk5Oa8KOEn5RN86Pr5LNA;6ReBnOS0a;cBGO",0), //688
	new Array(1,"v3qA373Rbk5Oa8KOEn5RN86Pr5LNA;6RdBnOS0a;cBGO",0), //689
	new Array(1,"336B3;3Rbk5Oa8KOHn5Rh4LO0kZPX0KO6CLRVpKM",0), //690
	new Array(1,"NdqNjQbPfxKMhM6Ow0LOfnpQC;6R6l5NpfaQQQaPdqGSEdaP",0), //691
	new Array(1,"NdqNjQbPfxKMhM6Ow0LOfnpQC;6R9l5N5x6Ni23AVpKM",0), //692
	new Array(1,"NdqNjQbPfxKMhM6OumJSA9KNjoKOzlaMtomOEdaP",0), //693
	new Array(1,"NdqNjQbPwRLMX1KM9;nLS0a;cBGO",0), //694
	new Array(1,"NdqNjQbPwRLMX1KM:;nLS0a;cBGO",0), //695
	new Array(1,"NdqNjQbPwRLMX1KM;;nLS0a;cBGO",0), //696
	new Array(1,"NdqNjQbPbJLMMkZPYtKMrRLNrHrQDTaQT33AVpKMS0a;cBGO",0), //697
	new Array(1,"NdqNjQbPLhLMVhLMSFaPVpKM",0), //698
	new Array(1,"NdqNjQbPWdaMGl5NVQKOjEaPT33AzxaMD;qRLdLMApKNB7LRS0a;cBGO",0), //699
	new Array(1,"NdqNjQbPWdaMGl5NVQKOjEaPT33AL5rN1FqNS0a;cBGO",0), //700
	new Array(1,"NdqNjQbPWdaMGl5NVQKOjEaPT33A48aP97LR8k5PdQLOS0a;cBGO",0), //701
	new Array(1,"NdqNjQbPWdaMGl5NVQKOjEaPT33A48aP97LR8k5PeQLOS0a;cBGO",0), //702
	new Array(1,"NdqNjQbPWdaMGl5NVQKOjEaP48aP97LREl5PivJAzc7PC86PCd6NNpmNEdaP",0), //703
	new Array(1,"NdqNjQbPWdaMGl5NVQKOjEaP48aP97LREl5PivJAzc7PyPbQS0a;cBGO",0), //704
	new Array(1,"NdqNjQbPWdaMGl5NVQKOjEaP48aP97LREl5PivJAzc7PtTrQjQaPN5bNApKNCd7PVpKM",0), //705
	new Array(1,"NdqNjQbPWdaMGl5NVQKOjEaP48aP97LREl5PivJAzc7P;;6RClKNFpWNEdaP",0), //706
	new Array(1,"NdqNjQbPWdaMGl5NVQKOjEaP48aP97LREl5PZvJAKMrP1r2REdaP",0), //707
	new Array(1,"NdqNjQbPWdaMGl5NVQKOjEaP48aP97LREl5PuvJA6qKRVpKM",0), //708
	new Array(1,"NdqNjQbPWdaMGl5NVQKOjEaP48aP97LREl5PvvJAC;6R6l5NpfaQQQaPdqGSEdaP",0), //709
	new Array(1,"NdqNjQbPWdaMGl5NVQKOjEaP48aP97LREl5PvvJAC;6RDl5NJJaNN0bPSOaRVpKM",0), //710
	new Array(1,"NdqNjQbPWdaMGl5NVQKOjEaP48aP97LREl5PzvJAXxKMS0a;cBGO",0), //711
	new Array(1,"NdqNjQbPzxaMD;qRacLMVpKM",0), //712
	new Array(1,"NdqNjQbPzxaMD;qRLdLMolaMdqGSEdaP",0), //713
	new Array(1,"NdqNjQbPzxaMD;qRLdLMApKNB7LRS0a;cBGO",0), //714
	new Array(1,"NdqNjQbPzxaMD;qRLdLML5rNArKRS0a;cBGO",0), //715
	new Array(1,"NdqNjQbPzxaMD;qRLdLMGP7RFoWPEdaP",0), //716
	new Array(1,"NdqNjQbPt5bMNoqPj1rMQ4rPS0a;cBGO",0), //717
	new Array(1,"NdqNjQbPt5bMNoqPj1rMQ4rPKSqLCd6NNpmNEdaP",0), //718
	new Array(1,"NdqNjQbPz5bMbsqPofaQjoKONmqLGP7RLxKMT33AHd6NRkKPSRbPVpKM",0), //719
	new Array(1,"NdqNjQbPz5bMbsqPofaQjoKONmqLGP7RLxKMT33AApKNB7LRS0a;cBGO",0), //720
	new Array(1,"NdqNjQbPz5bMbsqPofaQjoKONmqLGP7RLxKMT33A9xaNB2rLFoWPEdaP",0), //721
	new Array(1,"NdqNjQbPz5bMbsqPofaQjoKONmqLGP7RLxKMT33A9xaNA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //722
	new Array(1,"NdqNjQbPz5bMbsqPofaQjoKONmqLGP7RLxKMT33AL5rN1FqNS0a;cBGO",0), //723
	new Array(1,"NdqNjQbPz5bMbsqPofaQjoKONmqLGP7RLxKMT33Aoc6OdpGMEdaP",0), //724
	new Array(1,"NdqNjQbPz5bMbsqPofaQjoKONmqLGP7RLxKMT33Aoc6OlpWMEdaP",0), //725
	new Array(1,"NdqNjQbPz5bMbsqPofaQjoKONmqLGP7RLxKMT33ARkKPSRbPVpKM",0), //726
	new Array(1,"NdqNjQbPp9qMdL6QDPaQgfqQ9;nLS0a;cBGO",0), //727
	new Array(1,"NdqNjQbPp9qMdL6QDPaQgfqQ9;nLLOrLA6rLgpKMS0a;cBGO",0), //728
	new Array(1,"NdqNjQbPp9qMdL6QDPaQtTrQjQaPzn6RgfqQ9;nLS0a;cBGO",0), //729
	new Array(1,"NdqNjQbPe9qMoP6QT33A9xaNFOqLrvqQQrKRS0a;cBGO",0), //730
	new Array(1,"NdqNjQbPe9qMoP6QT33A9xaNKSqLGN7N9pGNEdaP",0), //731
	new Array(1,"NdqNjQbPe9qMoP6QT33A9xaN:KqLTEqPdqGSEdaP",0), //732
	new Array(1,"NdqNjQbPe9qMoP6QT33A9xaNFeqLC:6RVpKM",0), //733
	new Array(1,"NdqNjQbPe9qMoP6QT33A9xaNFeqLC66RVpKM",0), //734
	new Array(1,"NdqNjQbPe9qMoP6QT33A9xaNNuqLNQaPSFaPVpKM",0), //735
	new Array(1,"NdqNjQbPe9qMoP6QT33A9xaNLyqLQrKRS0a;cBGO",0), //736
	new Array(1,"NdqNjQbPe9qMoP6QT33A9xaNB2rLFoWPEdaP",0), //737
	new Array(1,"NdqNjQbPe9qMoP6QT33A9xaNA6rLgpKMN5bNApKNCd7PVpKM",0), //738
	new Array(1,"NdqNjQbPe9qMoP6QT33A9xaNNOrLrMqOSIaNVpKM",0), //739
	new Array(1,"NdqNjQbPe9qMoP6QT33A9xaNNKrLCV6PVpKM",0), //740
	new Array(1,"NdqNjQbPplqMY9aML6qLQrKR64LNVpKM",0), //741
	new Array(1,"NdqNjQbPplqMY9aMBKqLg5LMS0a;cBGO",0), //742
	new Array(1,"NdqNjQbPplqMY9aMJ6rLU1LM9;nLS0a;cBGO",0), //743
	new Array(1,"NdqNjQbPplqMY9aMFKrLRQaPYwKOA6rLgpKMjoKOS0a;cBGO",0), //744
	new Array(1,"NdqNjQbPV5rMtTrQGk5P7TKRzI6P9xaNB2rLFoWPEdaP",0), //745
	new Array(1,"NdqNjQbPV5rMtTrQGk5P7TKRzI6P9xaNA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //746
	new Array(1,"NdqNjQbPV5rMtTrQGk5P7TKRzI6P486PjoKOS0a;cBGO",0), //747
	new Array(1,"NdqNjQbPV5rMtTrQGk5P7TKRzI6P;;6R7lJNSIaNVpKM",0), //748
	new Array(1,"NdqNjQbPeNrM9;6RHkZPYxKMi23AVpKM",0), //749
	new Array(1,"NdqNjQbPgNrMx3qQjMaPHk6PtrmQEdaP",0), //750
	new Array(1,"NdqNjQbPpdrMw9aMtrmQEdaP",0), //751
	new Array(1,"NdqNjQbPpdrMw9aMqnpQxRLMw;aQA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //752
	new Array(1,"NdqNjQbPpdrMw9aMenpQ6qKRVpKM",0), //753
	new Array(1,"NdqNjQbPpdrMw9aMfnpQC;6R6l5NpfaQQQaPdqGSEdaP",0), //754
	new Array(1,"NdqNjQbPpdrMw9aMjnpQXxKMS0a;cBGO",0), //755
	new Array(1,"NdqNjQbPG96N1H6RrMKPGj6RKFrPVpKM",0), //756
	new Array(1,"NdqNjQbPG96N1H6RrMKPF;qR1r2REdaP",0), //757
	new Array(1,"NdqNjQbPH96NVk5O1T7RqUqMVpKM",0), //758
	new Array(1,"NdqNjQbPH96Nmk5O6qKRVpKM",0), //759
	new Array(1,"NdqNjQbPBN6NbEKOIl5Ny;aQtrmQEdaP",0), //760
	new Array(1,"NdqNjQbPBN6NYkJOUEKOE37RO9KNN6qLlTrQSFaPVpKM",0), //761
	new Array(1,"NdqNjQbPBN6NYkJOUEKOE37RO9KN::rLR0qPl3rQSFaPVpKM",0), //762
	new Array(1,"NdqNjQbPBN6NYkJOUEKOI37RJ4rPS0a;cBGO",0), //763
	new Array(1,"NdqNjQbP3d6NNAHNS0a;cBGO",0), //764
	new Array(1,"NdqNjQbP3d6NOAHNS0a;cBGO",0), //765
	new Array(1,"NdqNjQbP3d6N:lJN8hrPdzGAEdaP",0), //766
	new Array(1,"NdqNjQbP3d6N:lJN8hrPlzWAEdaP",0), //767
	new Array(1,"NdqNjQbP3d6N:lJNbgrPDk6PVr2QEdaP",0), //768
	new Array(1,"NdqNjQbP3d6N4lJN8kqPS0a;cBGO",0), //769
	new Array(1,"NdqNjQbP7l6NxzqQGl5N6qKRVpKM",0), //770
	new Array(1,"NdqNjQbP7l6NxzqQHl5NC;6R1p2NEdaP",0), //771
	new Array(1,"NdqNjQbPLl6N48aP3;6RtomOEdaP",0), //772
	new Array(1,"NdqNjQbPLl6NS5aPVpKM",0), //773
	new Array(1,"NdqNjQbPLl6Nj4aPoc6OS0a;cBGO",0), //774
	new Array(1,"NdqNjQbPLl6Nj4aPzn6RtTrQSRaPVpKM",0), //775
	new Array(1,"NdqNjQbP157NNrmREdaP",0), //776
	new Array(1,"NdqNjQbPJ57N4kJPKFrPVpKM",0), //777
	new Array(1,"NdqNjQbPJ57N4kJPbErPtTrQjQaPN5bNApKNCd7PVpKM",0), //778
	new Array(1,"NdqNjQbPJ57NPkJP48KP1o2PEdaP",0), //779
	new Array(1,"NdqNjQbPJ57NPkJP48KPHk5PC;6R6l5NpfaQQQaPdqGSEdaP",0), //780
	new Array(1,"NdqNjQbP7RKNH6rLYwKON6qLlTrQSFaPVpKM",0), //781
	new Array(1,"NdqNjQbP7RKNH6rLYwKO::rLR0qPl3rQSFaPVpKM",0), //782
	new Array(1,"NdqNjQbP7FKNrHrQDTaQ1o2PEdaP",0), //783
	new Array(1,"NdqNjQbP7FKNrHrQDTaQlrWQEdaP",0), //784
	new Array(1,"NdqNjQbP7tKNDf6R0kZPadKMQNbNS0a;cBGO",0), //785
	new Array(1,"NdqNjQbP7tKNDf6R3kZPocqO6k5PYdKME6rLA4rPS0a;cBGO",0), //786
	new Array(1,"NdqNjQbP7tKNDf6R3kZPocqOHk5P;3KRP1LNS0a;cBGO",0), //787
	new Array(1,"NdqNjQbP9JLNrfqQFoWPEdaP",0), //788
	new Array(1,"NdqNjQbP29aN1kJPNQaPg9qM9pGNEdaP",0), //789
	new Array(1,"NdqNjQbP29aNMkJPadKMBn5RahLOVpKM",0), //790
	new Array(1,"NdqNjQbP39aNjc6ORkZPw0LOhVKMS0a;cBGO",0), //791
	new Array(1,"NdqNjQbP39aNjc6O7kZPXxKMS0a;cBGO",0), //792
	new Array(1,"NdqNjQbPRNaNhxKMICqLxhqMPcKPz37RtTrQjQaPN5bNApKNCd7PVpKM",0), //793
	new Array(1,"NdqNjQbPRNaNhxKMICqLxhqMPcKPz37RtTrQjQaPYQKONAHNS0a;cBGO",0), //794
	new Array(1,"NdqNjQbPRNaNhxKMICqLxhqMrcLPlPaQCd6NL5qNKVqPVpKM",0), //795
	new Array(1,"NdqNjQbPRNaNhxKMACqL3;6RclpOdzGAEdaP",0), //796
	new Array(1,"NdqNjQbPRNaNhxKMACqL3;6RclpOlzWAEdaP",0), //797
	new Array(1,"NdqNjQbPRNaNhxKMACqL3;6RclpOtzmAEdaP",0), //798
	new Array(1,"NdqNjQbPRNaNhxKM0CqL0CqLjoKOS0a;cBGO",0), //799
	new Array(1,"NdqNjQbPRNaNhxKMN2qLDw6PboqPllaMEm5RfvpAC;6R6l5NpfaQQQaPdqGSEdaP",0), //800
	new Array(1,"NdqNjQbPRNaNhxKMI2qLNErP1;qRS0a;cBGO",0), //801
	new Array(1,"NdqNjQbPRNaNhxKMI2qLNErP1;qRL2qLCc7NVpKM",0), //802
	new Array(1,"NdqNjQbPRNaNhxKMI2qLNErP1;qRKSqLGN7N9pGNEdaP",0), //803
	new Array(1,"NdqNjQbPRNaNhxKMI2qLNErP1;qR:KqLKMrP1p2NEdaP",0), //804
	new Array(1,"NdqNjQbPRNaNhxKMI2qLNErP1;qRBOrLyqaQVpKM",0), //805
	new Array(1,"NdqNjQbPRNaNhxKM:2qLakKOv1KM:nqR1p2NEdaP",0), //806
	new Array(1,"NdqNjQbPRNaNhxKM:2qLakKOv1KM:nqR5l5NNQaPSFaPVpKM",0), //807
	new Array(1,"NdqNjQbPRNaNhxKML6qL94KP3n5RKMrPGP6RS0a;cBGO",0), //808
	new Array(1,"NdqNjQbPRNaNhxKML6qL94KP7n5RO;KR1p2NEdaP",0), //809
	new Array(1,"NdqNjQbPRNaNhxKML6qL94KPHn5RP8KPkl5OdzGAEdaP",0), //810
	new Array(1,"NdqNjQbPRNaNhxKMB6qLlTbQLoKOo9qMFB3PS0a;cBGO",0), //811
	new Array(1,"NdqNjQbPRNaNhxKMB6qLlTbQLoKOo9qMGB3PS0a;cBGO",0), //812
	new Array(1,"NdqNjQbPRNaNhxKM16qL94KPC17PVpKM",0), //813
	new Array(1,"NdqNjQbPRNaNhxKM16qL94KPz07P48aP97LRHk5PC;6R6l5NpfaQQQaPdqGSEdaP",0), //814
	new Array(1,"NdqNjQbPRNaNhxKM16qL94KPz07PyPbQS0a;cBGO",0), //815
	new Array(1,"NdqNjQbPRNaNhxKM16qL94KPz07PtTrQjQaPN5bNApKNCd7PVpKM",0), //816
	new Array(1,"NdqNjQbPRNaNhxKM16qL94KPz07PI;qRtomOEdaP",0), //817
	new Array(1,"NdqNjQbPRNaNhxKMNOqLrTbQhtKMEOrLbnaQS0a;cBGO",0), //818
	new Array(1,"NdqNjQbPRNaNhxKMNOqLrTbQhtKMNKrLaRLOVpKM",0), //819
	new Array(1,"NdqNjQbPRNaNhxKMNOqL7jqQwRLMX1KMS0a;cBGO",0), //820
	new Array(1,"NdqNjQbPRNaNhxKMNOqL7jqQyPbQS0a;cBGO",0), //821
	new Array(1,"NdqNjQbPRNaNhxKMROqLDcKPbQqP177RS1bPVpKM",0), //822
	new Array(1,"NdqNjQbPRNaNhxKMROqLrcKP7c6PnQ7OVP6QnnZQw1LMjoKOS0a;cBGO",0), //823
	new Array(1,"NdqNjQbPRNaNhxKMROqLrcKP7c6PnQ7OVP6QUnZQnnaQP1LNjoKOS0a;cBGO",0), //824
	new Array(1,"NdqNjQbPRNaNhxKMROqLrcKP7c6PnQ7OGn6R9oGPEdaP",0), //825
	new Array(1,"NdqNjQbPRNaNhxKMFOqLcMqMdzGAEdaP",0), //826
	new Array(1,"NdqNjQbPRNaNhxKMFOqLcMqMlzWAEdaP",0), //827
	new Array(1,"NdqNjQbPRNaNhxKMFOqL7NqMclaMi23AVpKM",0), //828
	new Array(1,"NdqNjQbPRNaNhxKMFOqL7NqMclaMiC3AVpKM",0), //829
	new Array(1,"NdqNjQbPRNaNhxKMFOqL7NqMclaMLuqLKBrPVpKM",0), //830
	new Array(1,"NdqNjQbPRNaNhxKMFOqL7NqMDk6PVr2QEdaP",0), //831
	new Array(1,"NdqNjQbPRNaNhxKMLOqLI1rNrRKNyPbQS0a;cBGO",0), //832
	new Array(1,"NdqNjQbPRNaNhxKMLOqLI1rNrRKNtTrQSRaPVpKM",0), //833
	new Array(1,"NdqNjQbPRNaNhxKMLOqLNrqR1T7RqUqMVpKM",0), //834
	new Array(1,"NdqNjQbPRNaNhxKMLOqLOrqRS0a;cBGO",0), //835
	new Array(1,"NdqNjQbPRNaNhxKMLOqLOrqRFeqL1r2REdaP",0), //836
	new Array(1,"NdqNjQbPRNaNhxKMLOqLOrqRLOrLA6rLgpKMS0a;cBGO",0), //837
	new Array(1,"NdqNjQbPRNaNhxKM:OqLbFKMTgaPyqaQVpKM",0), //838
	new Array(1,"NdqNjQbPRNaNhxKM:OqLaELMVpKM",0), //839
	new Array(1,"NdqNjQbPRNaNhxKM:OqLrvKRLk6PS0a;cBGO",0), //840
	new Array(1,"NdqNjQbPRNaNhxKM:OqLrvKRLk6PA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //841
	new Array(1,"NdqNjQbPRNaNhxKM:OqLrvKRtvqQCx6PVpKM",0), //842
	new Array(1,"NdqNjQbPRNaNhxKM:OqLrvKRtvqQzw6PtTrQjQaPN5bNApKNCd7PVpKM",0), //843
	new Array(1,"NdqNjQbPRNaNhxKMTSqLD0rPQ4rPKvqLVpKM",0), //844
	new Array(1,"NdqNjQbPRNaNhxKMTSqLD0rPQ4rPK3rLVpKM",0), //845
	new Array(1,"NdqNjQbPRNaNhxKMJSqLFQrPboqPd;6Q5IaP1o2PEdaP",0), //846
	new Array(1,"NdqNjQbPRNaNhxKMCSqLV1LMKpqPVpKM",0), //847
	new Array(1,"NdqNjQbPRNaNhxKMNGqLljqQboqPPcKP;;6R9pGNEdaP",0), //848
	new Array(1,"NdqNjQbPRNaNhxKMNGqLljqQboqPI;qRtomOEdaP",0), //849
	new Array(1,"NdqNjQbPRNaNhxKM:LqLB2rLudKMekJOApKNnc6OxoqO60LNVpKM",0), //850
	new Array(1,"NdqNjQbPRNaNhxKM:KqLTEqPdqGSEdaP",0), //851
	new Array(1,"NdqNjQbPRNaNhxKM1KqLt37QA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //852
	new Array(1,"NdqNjQbPRNaNhxKMNeqLBsKPsnZQZtKM15LNSFaPVpKM",0), //853
	new Array(1,"NdqNjQbPRNaNhxKMNeqLBsKPbnZQwdKMS0a;cBGO",0), //854
	new Array(1,"NdqNjQbPRNaNhxKMNeqLGQaP4xKNS0a;cBGO",0), //855
	new Array(1,"NdqNjQbPRNaNhxKMNeqLGQaP4xKNA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //856
	new Array(1,"NdqNjQbPRNaNhxKMNeqLjQaPFA3NNmqLGP7RLxKMI;qRtomOEdaP",0), //857
	new Array(1,"NdqNjQbPRNaNhxKMNeqLjQaPNAHNNmqLGP7RLxKMtTrQjQaPi23AVpKM",0), //858
	new Array(1,"NdqNjQbPRNaNhxKMNeqLjQaPlB3ONmqLGP7RLxKMI;qRtomOEdaP",0), //859
	new Array(1,"NdqNjQbPRNaNhxKMNeqLjQaPFC3RNmqLGP7RLxKMI;qRtomOEdaP",0), //860
	new Array(1,"NdqNjQbPRNaNhxKMFeqLC:6RVpKM",0), //861
	new Array(1,"NdqNjQbPRNaNhxKMFeqLC66RVpKM",0), //862
	new Array(1,"NdqNjQbPRNaNhxKMPiqL1tKNSNaPVpKM",0), //863
	new Array(1,"NdqNjQbPRNaNhxKMPiqL1tKNjMaPDk6PVr2QEdaP",0), //864
	new Array(1,"NdqNjQbPRNaNhxKMKiqLvPqQ1r2REdaP",0), //865
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQwRLMX1KMT33AB96NhFKMS0a;cBGO",0), //866
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQwRLMX1KMT33A2kaP48KPS0a;cBGO",0), //867
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQwRLMX1KMTD3AB96NhFKMS0a;cBGO",0), //868
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQwRLMX1KMTD3A2kaP48KPS0a;cBGO",0), //869
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQwRLMX1KMT;3AB96NhFKMS0a;cBGO",0), //870
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQwRLMX1KMT;3A2kaP48KPS0a;cBGO",0), //871
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQwRLMX1KMTL3AB96NhFKMS0a;cBGO",0), //872
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQwRLMX1KMTL3A2kaP48KPS0a;cBGO",0), //873
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQB96NhFKMS0a;cBGO",0), //874
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQRkKPSRbPVpKM",0), //875
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQtTrQKQaPpfaQQQaPdqGSEdaP",0), //876
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQGP7RFoWPEdaP",0), //877
	new Array(1,"NdqNjQbPRNaNhxKMLWqLQ3LRmk6O7PqQKfqRS0a;cBGO",0), //878
	new Array(1,"NdqNjQbPRNaNhxKMKaqLUEKOHn5RC;6R6l5NpfaQQQaPdqGSEdaP",0), //879
	new Array(1,"NdqNjQbPRNaNhxKMRuqLQPaR6CLRVpKM",0), //880
	new Array(1,"NdqNjQbPRNaNhxKMNyqLPdqNN6qLlTrQjEaPN5bNApKNCd7PVpKM",0), //881
	new Array(1,"NdqNjQbPRNaNhxKMNyqLPdqNN6qLlTrQjEaPSIqPPpKNhILOS0a;cBGO",0), //882
	new Array(1,"NdqNjQbPRNaNhxKMNyqLPdqNReqLVxKMjEaPj77QfNqMqfqQAlpNRsqPS0a;cBGO",0), //883
	new Array(1,"NdqNjQbPRNaNhxKMNyqLPdqNReqLVxKMjEaPj77QfNqMqfqQAlpNPArPS0a;cBGO",0), //884
	new Array(1,"NdqNjQbPRNaNhxKMNyqLPdqN::rLR0qPl3rQjEaPEn6RrlpMJJaNN0bPSOaRVpKM",0), //885
	new Array(1,"NdqNjQbPRNaNhxKMNyqL2MbP9pGNEdaP",0), //886
	new Array(1,"NdqNjQbPRNaNhxKMRyqLs3aQwpKMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //887
	new Array(1,"NdqNjQbPRNaNhxKMFyqLGcaPYxKMKkqPIGqLaeKSNpmNEdaP",0), //888
	new Array(1,"NdqNjQbPRNaNhxKMFyqLGcaPYxKMKkqPIGqLaeKS:AnNS0a;cBGO",0), //889
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RFkZP2EaPdqGSEdaP",0), //890
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RFkZPt3rQQzKRk16:aWGAVpKM",0), //891
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RFkZPt3rQQzKRkJ7:aWGAVpKM",0), //892
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RFkZPt3rQQzKRS0a;cBGO",0), //893
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RGkZP1QqPS0a;cBGO",0), //894
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RHkZPZM6OlrWQEdaP",0), //895
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RHkZPIk6PnM6OS0a;cBGO",0), //896
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RHkZPyebQVpKM",0), //897
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RHkZPQ7LRVPqQS0a;cBGO",0), //898
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RIkZPfpKMQlJNhCLSdpGMEdaP",0), //899
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RIkZPfpKMQlJNhCLSlpWMEdaP",0), //900
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RIkZPfpKMQlJNhCLStpmMEdaP",0), //901
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RIkZPfpKMQlJNhCLS1p2NEdaP",0), //902
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RIkZPf0LO:MrPhFKMS0a;cBGO",0), //903
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RKkZPIwqPJErP9pGNEdaP",0), //904
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RLkZPMQLNdzGAEdaP",0), //905
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RLkZPMQLNlzWAEdaP",0), //906
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RLkZPMQLNtzmAEdaP",0), //907
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RLkZPpPaQCf6RNpmNEdaP",0), //908
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RMkZPgpKMtxqMVr2QEdaP",0), //909
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RMkZPDrKRyebQVpKM",0), //910
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RQkZPjNLMVo2OEdaP",0), //911
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RRkZP9pGNEdaP",0), //912
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RRkZP13LRtpmMEdaP",0), //913
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RRkZP13LRqNqM1p2NEdaP",0), //914
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RRkZP13LRg1rMw5LMS0a;cBGO",0), //915
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6RSkZPNomPEdaP",0), //916
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R0kZPN86PS0a;cBGO",0), //917
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R0kZP1M6PqOqQVpKM",0), //918
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R1kZPPPKRDf6RFoWPEdaP",0), //919
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R2kZPBTKRS0a;cBGO",0), //920
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R2kZPBTKRi23AVpKM",0), //921
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R3kZPxxKMCO6RVpKM",0), //922
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R3kZPocqO6k5PYdKME6rLA4rPS0a;cBGO",0), //923
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R3kZPocqOHk5P;3KRP1LNS0a;cBGO",0), //924
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R3kZP4MKP1o2PEdaP",0), //925
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R3kZPM7LRXfaQ9pGNEdaP",0), //926
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R4kZPKdrPVpKM",0), //927
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R9kZP90LNS0a;cBGO",0), //928
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R9kZP60LNVpKM",0), //929
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKM7tKNDf6R9kZPr1LN2laNB6qL337RBpKNS0a;cBGO",0), //930
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMA9qNmM6OjoKOTSqLK0rNVpKM",0), //931
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMA9qNmM6OjoKONKrLGP6R:GqL;sqP577RasKMVpKM",0), //932
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMA9qNmM6OjoKONKrLGP6R:GqLDsqP4xKNS0a;cBGO",0), //933
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMA9qNmM6OjoKONKrLGP6R:OrL6MKNVpKM",0), //934
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMi86O3d7Nq;aQ1r2REdaP",0), //935
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMHk5PLQLObnaQjoKOS0a;cBGO",0), //936
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQPlJNd77QCO6RVpKM",0), //937
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMD8KPL0KOljqQAxKNS0a;cBGO",0), //938
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMZ77Qm;6QjoKONyqLpXaQ1r2REdaP",0), //939
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMXnZQLQLObnaQjoKOS0a;cBGO",0), //940
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nLS0a;cBGO",0), //941
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nL8DqLdzGAEdaP",0), //942
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nL8PqLdzGAEdaP",0), //943
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nL8fqLdzGAEdaP",0), //944
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nLKPrLVpKM",0), //945
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nLLOrLFKrLHN6N177RUEKO1r2REdaP",0), //946
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nLLOrLFKrLHN6N177RUEKO1n5Ri23AVpKM",0), //947
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nLLOrLFKrLHN6N177RUEKO4n5Ri23AVpKM",0), //948
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nLLOrLFKrLHN6N177RUEKO5n5Ri23AVpKM",0), //949
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nLLOrLFKrLHN6N177RUEKO8n5Ri23AVpKM",0), //950
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ9;nLLOrLFKrLHN6N177RUEKOIn5RS0a;cBGO",0), //951
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nLS0a;cBGO",0), //952
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nL8DqLdzGAEdaP",0), //953
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nLKPrLVpKM",0), //954
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nLLOrLFKrLHN6N177RUEKO1r2REdaP",0), //955
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nLLOrLFKrLHN6N177RUEKOEm5RpvZAi23AVpKM",0), //956
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nLLOrLFKrLHN6N177RUEKOEm5RsvZAi23AVpKM",0), //957
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nLLOrLFKrLHN6N177RUEKO1n5Ri23AVpKM",0), //958
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nLLOrLFKrLHN6N177RUEKO4n5Ri23AVpKM",0), //959
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ:;nLLOrLFKrLHN6N177RUEKOIn5RS0a;cBGO",0), //960
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ;;nLS0a;cBGO",0), //961
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQ;;nLLOrLFKrLHN6N177RUEKO1r2REdaP",0), //962
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQB;nLS0a;cBGO",0), //963
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQB;nLLOrLFKrLHN6N177RUEKO1r2REdaP",0), //964
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQE6qLudKM9;nLKLqLVpKM",0), //965
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQE6qLudKM9;nLLOrLFKrLHN6N177RUEKO7n5RS0a;cBGO",0), //966
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQE6qLudKM:;nLS0a;cBGO",0), //967
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQE6qLudKM:;nLLOrLFKrLHN6N177RUEKO1r2REdaP",0), //968
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQE6qLudKM;;nLS0a;cBGO",0), //969
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQE6qLudKM;;nLLOrLFKrLHN6N177RUEKO1r2REdaP",0), //970
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMgfqQLyqLKpqPVpKM",0), //971
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMtTrQjQaPi23AVpKM",0), //972
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMtTrQjQaPiC3AVpKM",0), //973
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMtTrQjQaPi:3AVpKM",0), //974
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMtTrQjQaPiK3AVpKM",0), //975
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RdzGAEdaP",0), //976
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RdvJAi23AVpKM",0), //977
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RgvJAi23AVpKM",0), //978
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RhvJAi23AVpKM",0), //979
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RUvJAi23AVpKM",0), //980
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RwvJAS0a;cBGO",0), //981
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RlzWAEdaP",0), //982
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RlvZAi23AVpKM",0), //983
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RpvZAi23AVpKM",0), //984
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RsvZAi23AVpKM",0), //985
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RYvZAS0a;cBGO",0), //986
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5RtzmAEdaP",0), //987
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rLEm5R9zGBEdaP",0), //988
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rL3n5Rd86OUmZQjvJAS0a;cBGO",0), //989
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rL3n5Rd86OUmZQlzWAEdaP",0), //990
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMQfqRQ1LNt;aQAhqNLOrLF6rL3n5Rd86OUmZQtzmAEdaP",0), //991
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMKfqR9t6Nzw6PtTrQNQaPSFaPVpKM",0), //992
	new Array(1,"NdqNjQbPRNaNhxKM8mqLjlpMARKNjoKO557Ne3rQQpKNS0a;cBGO",0), //993
	new Array(1,"NdqNjQbPRNaNhxKM8mqLjlpMARKNjoKO557Ne3rQQpKNNOrLCV6PVpKM",0), //994
	new Array(1,"NdqNjQbPRNaNhxKMN:rLmP6QudKMVz6QSNaPVpKM",0), //995
	new Array(1,"NdqNjQbPRNaNhxKMI:rLhpKMS0a;cBGO",0), //996
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QDn5RMMaPgpKM:KqLQNKNjoKOS0a;cBGO",0), //997
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QDn5RMMaPgpKMLeqLp3bQF2rLCd6NKlpNxRLMw;aQ9;nLA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //998
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QDn5RMMaPgpKMLeqLp3bQF2rLCd6NKlpNxRLMw;aQ:;nLA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //999
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QDn5RMMaPgpKMNuqL0HKRS0a;cBGO",0), //1000
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QDn5RMMaPgpKMF6rL1r2REdaP",0), //1001
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QDn5RMMaPgpKMF6rLIn5RDkpPhQKOeTrQjdKMiR7OVpKM",0), //1002
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QDn5RMMaPgpKMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //1003
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QDn5RMMaPgpKMFKrLHN6N177RUEKOIn5R;kpPaRLOVpKM",0), //1004
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QIn5REnqRgpKM:KqLQNKNjoKOS0a;cBGO",0), //1005
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QIn5REnqRgpKMLeqLp3bQF2rLCd6NKlpNxRLMw;aQ9;nLA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //1006
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QIn5REnqRgpKMLeqLp3bQF2rLCd6NKlpNxRLMw;aQ:;nLA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //1007
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QIn5REnqRgpKMNuqL0HKRS0a;cBGO",0), //1008
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QIn5REnqRgpKMF6rL1r2REdaP",0), //1009
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QIn5REnqRgpKMF6rLIn5RDkpPhQKOeTrQjdKMiR7OVpKM",0), //1010
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QIn5REnqRgpKMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //1011
	new Array(1,"NdqNjQbPRNaNhxKMB:rLZD7QIn5REnqRgpKMFKrLHN6N177RUEKOIn5R;kpPaRLOVpKM",0), //1012
	new Array(1,"NdqNjQbPRNaNhxKML2rLKfqRNpmNEdaP",0), //1013
	new Array(1,"NdqNjQbPRNaNhxKML2rLY:KSfxKMhM6Ow0LOA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //1014
	new Array(1,"NdqNjQbPRNaNhxKMB2rL1lZPlzWAEdaP",0), //1015
	new Array(1,"NdqNjQbPRNaNhxKMB2rLTkZPJJaNN0bPSOaRVpKM",0), //1016
	new Array(1,"NdqNjQbPRNaNhxKMR6rL91LNRnpRSRaPVpKM",0), //1017
	new Array(1,"NdqNjQbPRNaNhxKMR6rL91LNRnpRjQaP3daN1r2REdaP",0), //1018
	new Array(1,"NdqNjQbPRNaNhxKMR6rL91LNGnpRMvKRDk6PVr2QEdaP",0), //1019
	new Array(1,"NdqNjQbPRNaNhxKMR6rL91LNGnpRMvKRDk6Pan5Qw0LOS0a;cBGO",0), //1020
	new Array(1,"NdqNjQbPRNaNhxKMR6rL91LN8npRUPaQh5LMS0a;cBGO",0), //1021
	new Array(1,"NdqNjQbPRNaNhxKMR6rL91LN8npRUPaQh5LMFGqLqSrQVpKM",0), //1022
	new Array(1,"NdqNjQbPRNaNhxKMF6rL3n5Rd86OUmZQdzGAEdaP",0), //1023
	new Array(1,"NdqNjQbPRNaNhxKMF6rL3n5Rd86OUmZQwvJADkpPhQKOeTrQjdKMiR7OVpKM",0), //1024
	new Array(1,"NdqNjQbPRNaNhxKMF6rL5n5RaQLMVpKM",0), //1025
	new Array(1,"NdqNjQbPRNaNhxKMA6rLgpKM:GqLaMKONx6N9;nLS0a;cBGO",0), //1026
	new Array(1,"NdqNjQbPRNaNhxKMA6rLgpKM:GqLaMKONx6N:;nLS0a;cBGO",0), //1027
	new Array(1,"NdqNjQbPRNaNhxKMA6rLgpKM:GqLaMKONx6NbuqLgfqQL2rLKfqRNpmNEdaP",0), //1028
	new Array(1,"NdqNjQbPRNaNhxKMA6rLgpKM:GqLaMKONx6NL2rLKfqRNpmNEdaP",0), //1029
	new Array(1,"NdqNjQbPRNaNhxKMA6rLgpKM:GqLaMKONx6Nb2rLgfqQL2rLKfqRNpmNEdaP",0), //1030
	new Array(1,"NdqNjQbPRNaNhxKMA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //1031
	new Array(1,"NdqNjQbPRNaNhxKMA6rL8sqPPCqLDf6RFoWPEdaP",0), //1032
	new Array(1,"NdqNjQbPRNaNhxKMA6rL8sqPR2rLlRKMS0a;cBGO",0), //1033
	new Array(1,"NdqNjQbPRNaNhxKMNOrLQrKRS0a;cBGO",0), //1034
	new Array(1,"NdqNjQbPRNaNhxKMEOrLbnaQN6qLqSrQVpKM",0), //1035
	new Array(1,"NdqNjQbPRNaNhxKMEOrLbnaQF:rLqUqMVpKM",0), //1036
	new Array(1,"NdqNjQbPRNaNhxKMEOrLbnaQNKrLVQLOSFaPVpKM",0), //1037
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPw9aMHc6Pz;6RT33AZdKMS0a;cBGO",0), //1038
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPw9aMHc6Pz;6RT33AthqMpHaQS0a;cBGO",0), //1039
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPw9aMHc6Pz;6RT33ArjqQKRrPVpKM",0), //1040
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPw9aMHc6Pz;6RT33AtTrQjQaPN5bNApKNCd7PVpKM",0), //1041
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPNAHNACqL3;6RclpOXvZAd77QCO6RVpKM",0), //1042
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPNAHNFGqLljqQjEaPg9qMlhqMSFaPVpKM",0), //1043
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPNAHNFGqLljqQjEaPg9qMlhqMjEaPN9aNGM7P9pGNEdaP",0), //1044
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPNAHNFGqLljqQjEaPGj6RFErPjEaPTxaNaQLMVpKM",0), //1045
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPNAHNFGqLljqQjEaPF;qRCf6R8kpNdzGAEdaP",0), //1046
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPNAHNFGqLljqQjEaPF;qRCf6R8kpNqvZA9tKNCN6PVpKM",0), //1047
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPOBHPI:rLVdLMjEaPdD7QAc6PdoGOEdaP",0), //1048
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPOBHPI:rLVdLMjEaPdD7QAc6PzkJOXxKMS0a;cBGO",0), //1049
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPOBHPA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //1050
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPEBHPI:rLVdLMjEaPhnqQc;qQik6O9pGNEdaP",0), //1051
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPEBHPA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //1052
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaP7TrQ157NOnpRX1KM1o2PEdaP",0), //1053
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaP7TrQD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //1054
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaP7TrQD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //1055
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaP7TrQtTrQjQaPN5bNApKNCd7PVpKM",0), //1056
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPVDXSB2rLKkZPpfaQQQaPdqGSEdaP",0), //1057
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPVDXSB2rLTkZPJJaNN0bPSOaRVpKM",0), //1058
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPVDXSA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //1059
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPVDXSA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //1060
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPVDXSNKrLzU6PN5bNApKNCd7PVpKM",0), //1061
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPVDXSNKrLzU6PSIqPPpKNhILOS0a;cBGO",0), //1062
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPWDXSB2rLKkZPpfaQQQaPdqGSEdaP",0), //1063
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPWDXSA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //1064
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPWDXSNKrLzU6PN5bNApKNCd7PVpKM",0), //1065
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPXDXSF6rL3n5Rd86OUmZQuvJAvdKM9hKNSRaPVpKM",0), //1066
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPXDXSF6rLGn5RvdKM9hKNSRaPVpKM",0), //1067
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPXDXSA6rLgpKMN2rLh0LOi86O1p2NEdaP",0), //1068
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPYDXSB2rLKkZPpfaQQQaPdqGSEdaP",0), //1069
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPYDXSA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //1070
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPYDXSA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //1071
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPYDXS;SrLjoKO:uqLKRqPVpKM",0), //1072
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPYDXSNKrLzU6PN5bNApKNCd7PVpKM",0), //1073
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPZDXSB2rLKkZPpfaQQQaPdqGSEdaP",0), //1074
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPZDXSA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //1075
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlhaMjQaPZDXSNKrLzU6PN5bNApKNCd7PVpKM",0), //1076
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPgNrMCf6R:FqNhBLMS0a;cBGO",0), //1077
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AwRLMX1KM9;nLS0a;cBGO",0), //1078
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AwRLMX1KM:;nLS0a;cBGO",0), //1079
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AwRLMX1KM;;nLS0a;cBGO",0), //1080
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AplqMY9aML6qLQrKR64LNVpKM",0), //1081
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AplqMY9aMJ6rLU1LMS0a;cBGO",0), //1082
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AplqMY9aMFKrLRQaPYwKOA6rLgpKMjoKOS0a;cBGO",0), //1083
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33A157NNrmREdaP",0), //1084
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //1085
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //1086
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //1087
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //1088
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //1089
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33A48aP97LRGk5P6qKRVpKM",0), //1090
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33A48aP97LRLk5PXxKMS0a;cBGO",0), //1091
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33ASIqPPpKNhILOB2rLFoWPEdaP",0), //1092
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33ASIqPPpKNhILONKrLCV6PVpKM",0), //1093
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1094
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT33AJ;6RSRbPVpKM",0), //1095
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTD3AwRLMX1KM9;nLS0a;cBGO",0), //1096
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTD3AwRLMX1KM:;nLS0a;cBGO",0), //1097
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTD3AwRLMX1KM;;nLS0a;cBGO",0), //1098
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTD3AplqMY9aML6qLQrKR64LNVpKM",0), //1099
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTD3AplqMY9aMJ6rLU1LMS0a;cBGO",0), //1100
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTD3A157NNrmREdaP",0), //1101
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTD3AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1102
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTD3AJ;6RSRbPVpKM",0), //1103
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //1104
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //1105
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KO2daN95KNzw6Pf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //1106
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KO2daN95KNzw6Pf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //1107
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KO2daN95KNzw6Pj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //1108
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //1109
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //1110
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOh0KOxDrQL5LMf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //1111
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOh0KOxDrQL5LMf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //1112
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOh0KOxDrQL5LMj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //1113
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //1114
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOJj6RJQaPnnZQw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //1115
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOJj6RJQaPnnZQw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //1116
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NT;3AD8KPL0KOJj6RJQaPUnZQnnaQP1LNjoKOLOrLT36QSIqPPpKNhILOS0a;cBGO",0), //1117
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTH3AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //1118
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTH3AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //1119
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTH3AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //1120
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTH3AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //1121
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O1l5NTH3AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //1122
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NT33AwRLMX1KM9;nLS0a;cBGO",0), //1123
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NT33AwRLMX1KM:;nLS0a;cBGO",0), //1124
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NT33AwRLMX1KM;;nLS0a;cBGO",0), //1125
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NT33AplqMY9aML6qLQrKR64LNVpKM",0), //1126
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NT33AplqMY9aMJ6rLU1LMS0a;cBGO",0), //1127
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NT33A157NNrmREdaP",0), //1128
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1129
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NTD3AwRLMX1KM9;nLS0a;cBGO",0), //1130
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NTD3AwRLMX1KM:;nLS0a;cBGO",0), //1131
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NTD3AwRLMX1KM;;nLS0a;cBGO",0), //1132
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NTD3AplqMY9aML6qLQrKR64LNVpKM",0), //1133
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NTD3AplqMY9aMJ6rLU1LMS0a;cBGO",0), //1134
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NTD3A157NNrmREdaP",0), //1135
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NTD3AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1136
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5ND3XAwRLMX1KM9;nLS0a;cBGO",0), //1137
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5ND3XAwRLMX1KM:;nLS0a;cBGO",0), //1138
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5ND3XAwRLMX1KM;;nLS0a;cBGO",0), //1139
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5ND3XAplqMY9aML6qLQrKR64LNVpKM",0), //1140
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5ND3XAplqMY9aMJ6rLU1LMS0a;cBGO",0), //1141
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5ND3XAtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1142
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NDDXAwRLMX1KM9;nLS0a;cBGO",0), //1143
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NDDXAwRLMX1KM:;nLS0a;cBGO",0), //1144
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NDDXAwRLMX1KM;;nLS0a;cBGO",0), //1145
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NDDXAplqMY9aML6qLQrKR64LNVpKM",0), //1146
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NDDXAplqMY9aMJ6rLU1LMS0a;cBGO",0), //1147
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NDDXAtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1148
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33AwRLMX1KMi23AVpKM",0), //1149
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33AwRLMX1KMiC3AVpKM",0), //1150
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33AwRLMX1KMi:3AVpKM",0), //1151
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33AplqMY9aML6qLQrKR64LNVpKM",0), //1152
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33AplqMY9aMJ6rLU1LMS0a;cBGO",0), //1153
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33AplqMY9aMFKrLRQaPYwKOA6rLgpKMjoKOS0a;cBGO",0), //1154
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33A157NNrmREdaP",0), //1155
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33A48aP97LRGk5P6qKRVpKM",0), //1156
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33ASIqPPpKNhILOB2rLFoWPEdaP",0), //1157
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33ASIqPPpKNhILONKrLCV6PVpKM",0), //1158
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1159
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O4l5NT33AJ;6RSRbPVpKM",0), //1160
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NT33AwRLMX1KM9;nLS0a;cBGO",0), //1161
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NT33AwRLMX1KM:;nLS0a;cBGO",0), //1162
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NT33AwRLMX1KM;;nLS0a;cBGO",0), //1163
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NT33AplqMY9aML6qLQrKR64LNVpKM",0), //1164
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NT33AplqMY9aMJ6rLU1LMS0a;cBGO",0), //1165
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NT33A157NNrmREdaP",0), //1166
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1167
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NTD3AwRLMX1KM9;nLS0a;cBGO",0), //1168
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NTD3AwRLMX1KM:;nLS0a;cBGO",0), //1169
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NTD3AwRLMX1KM;;nLS0a;cBGO",0), //1170
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NTD3AplqMY9aML6qLQrKR64LNVpKM",0), //1171
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NTD3AplqMY9aMJ6rLU1LMS0a;cBGO",0), //1172
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O6l5NTD3AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1173
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O7l5NQwqPFyqLScaPNpmNEdaP",0), //1174
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AwRLMX1KMi23AVpKM",0), //1175
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AwRLMX1KMi:3AVpKM",0), //1176
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AplqMY9aML6qLQrKR64LNVpKM",0), //1177
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AplqMY9aMJ6rLU1LMS0a;cBGO",0), //1178
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AplqMY9aMFKrLRQaPYwKOA6rLgpKMjoKOS0a;cBGO",0), //1179
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33A157NNrmREdaP",0), //1180
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //1181
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //1182
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //1183
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //1184
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //1185
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33A48aP97LRGk5P6qKRVpKM",0), //1186
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33A48aP97LRHk5PC;6REk5NdzGAEdaP",0), //1187
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33ASIqPPpKNhILOB2rLFoWPEdaP",0), //1188
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33ASIqPPpKNhILONKrLCV6PVpKM",0), //1189
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1190
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O8l5NT33AJ;6RSRbPVpKM",0), //1191
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OCl5NT33AwRLMX1KMi23AVpKM",0), //1192
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OCl5NT33AwRLMX1KMiC3AVpKM",0), //1193
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OCl5NT33AwRLMX1KMi:3AVpKM",0), //1194
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OCl5NT33AplqMY9aML6qLQrKR64LNVpKM",0), //1195
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OCl5NT33AplqMY9aMJ6rLU1LMS0a;cBGO",0), //1196
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33AwRLMX1KMi23AVpKM",0), //1197
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //1198
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //1199
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //1200
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //1201
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //1202
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33A48aP97LRGk5P6qKRVpKM",0), //1203
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33A48aP97LRHk5PC;6REk5NdzGAEdaP",0), //1204
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33A48aP97LRLk5PXxKMS0a;cBGO",0), //1205
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33ASIqPPpKNhILONKrLCV6PVpKM",0), //1206
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33ArjqQFQrPjEaPy;aQbNqNi23AVpKM",0), //1207
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OHl5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1208
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AwRLMX1KMi23AVpKM",0), //1209
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AwRLMX1KMi:3AVpKM",0), //1210
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AplqMY9aML6qLQrKR64LNVpKM",0), //1211
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AplqMY9aMJ6rLU1LMS0a;cBGO",0), //1212
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AplqMY9aMFKrLRQaPYwKOA6rLgpKMjoKOS0a;cBGO",0), //1213
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33A157NNrmREdaP",0), //1214
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //1215
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //1216
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //1217
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //1218
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //1219
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33A48aP97LRGk5P6qKRVpKM",0), //1220
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33A48aP97LRHk5PC;6REk5NdzGAEdaP",0), //1221
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33ASIqPPpKNhILONKrLCV6PVpKM",0), //1222
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1223
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86OIl5NT33AJ;6RSRbPVpKM",0), //1224
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMACqL3;6RclpOdzGAEdaP",0), //1225
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMACqL3;6RclpOlzWAEdaP",0), //1226
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMACqL3;6RclpOtzmAEdaP",0), //1227
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXML6qL94KP3n5RKMrPGP6RS0a;cBGO",0), //1228
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXML6qL94KPHn5RP8KPVo2OEdaP",0), //1229
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMNOqL7jqQwRLMX1KMS0a;cBGO",0), //1230
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMNOqL7jqQyPbQS0a;cBGO",0), //1231
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMBKqLg5LMS0a;cBGO",0), //1232
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMFeqL1n5RS0a;cBGO",0), //1233
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMFeqL2n5RS0a;cBGO",0), //1234
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMB2rLKkZPpfaQQQaPdqGSEdaP",0), //1235
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMB2rLTkZPJJaNN0bPSOaRVpKM",0), //1236
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //1237
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //1238
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMNOrLQrKRS0a;cBGO",0), //1239
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMNKrLzU6PN5bNApKNCd7PVpKM",0), //1240
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMNKrLzU6PSIqPPpKNhILOS0a;cBGO",0), //1241
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMFKrLGQaPlPaQeMqO::rL9BLNyOaQVpKM",0), //1242
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPVAXMFKrLGQaPlPaQeMqONKrLaRLOVpKM",0), //1243
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMACqL3;6RclpOdzGAEdaP",0), //1244
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMACqL3;6RclpOlzWAEdaP",0), //1245
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMACqL3;6RclpOtzmAEdaP",0), //1246
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXML6qL94KP3n5RKMrPGP6RS0a;cBGO",0), //1247
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXML6qL94KPHn5RP8KPVo2OEdaP",0), //1248
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMNOqL7jqQwRLMX1KMS0a;cBGO",0), //1249
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMNOqL7jqQyPbQS0a;cBGO",0), //1250
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMBKqLg5LMS0a;cBGO",0), //1251
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMFeqL1n5RS0a;cBGO",0), //1252
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMFeqL2n5RS0a;cBGO",0), //1253
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMB2rLKkZPpfaQQQaPdqGSEdaP",0), //1254
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMB2rLTkZPJJaNN0bPSOaRVpKM",0), //1255
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //1256
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //1257
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMNOrLQrKRS0a;cBGO",0), //1258
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMNKrLzU6PN5bNApKNCd7PVpKM",0), //1259
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMNKrLzU6PSIqPPpKNhILOS0a;cBGO",0), //1260
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMFKrLGQaPlPaQeMqO::rL9BLNyOaQVpKM",0), //1261
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaPWAXMFKrLGQaPlPaQeMqONKrLaRLOVpKM",0), //1262
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP1g6PjQaP157NOnpRX1KMS0a;cBGO",0), //1263
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNdvJA806PFtKN:6qLVQLOo9qM0SqLjz6QrfqQFoWPEdaP",0), //1264
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNdvJA806PFtKN:OqLaELMVpKM",0), //1265
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNdvJA806PFtKN0SqLjz6QrfqQFoWPEdaP",0), //1266
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNdvJA806PFtKNH6rLYwKON6qLlTrQSFaPVpKM",0), //1267
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNdvJA806PFtKNH6rLYwKO::rLR0qPl3rQSFaPVpKM",0), //1268
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNdvJA806PFtKNH6rLYwKO::rLR0qPl3rQ0FaPlzWAEdaP",0), //1269
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNdvJA806PFtKNH6rLYwKO::rLR0qPl3rQ0FaPtzmAEdaP",0), //1270
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNdvJA806PFtKNH6rLYwKO::rLR0qPl3rQ0FaP1z2BEdaP",0), //1271
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPlLaQDvaQ08aNevJATD3AfxKMhM6OvmJSocqO3k5Pw1LMjoKOS0a;cBGO",0), //1272
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPtAHMACqL3;6RclpOfvpAd77QCO6RVpKM",0), //1273
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPtAHMB6qL9T7R4EaPpPaQS0a;cBGO",0), //1274
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPtAHMNeqLpLbQlTrQjEaPN5rNapKOVpKM",0), //1275
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPtAHMNeqLpLbQlTrQjEaPon6QbRLMS0a;cBGO",0), //1276
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPtAHMLKrL;wqPq86OjoKOS0a;cBGO",0), //1277
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPtAHMLKrL;wqPq86OjoKOReqLUEKO1r2REdaP",0), //1278
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPuAHMNeqLBsKPyfaQNpmNEdaP",0), //1279
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPuAHMFyqLScaPNpmNEdaP",0), //1280
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPvAHML2qLzQ7PplqMydaMClJNpfaQQQaPbmJSjMaPi86O3l5Nw1LMjoKOS0a;cBGO",0), //1281
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPvAHML2qLzQ7PplqMydaM7lJNJJaNN0bPjPaRRoqPNeqLjQaPf9qMCf6RNpmNEdaP",0), //1282
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPvAHML2qLzQ7PplqMydaMQlJNbnqRi86O3l5Nw1LMjoKOS0a;cBGO",0), //1283
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPvAHMI6rLU1LMN6qLlTrQSFaPVpKM",0), //1284
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPljaQjQaPvAHMI6rLU1LM::rLR0qPl3rQSFaPVpKM",0), //1285
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLfvJAHkqPjoKO9;nLS0a;cBGO",0), //1286
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLfvJAHkqPjoKO:;nLS0a;cBGO",0), //1287
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLfvJAHkqPjoKO;;nLS0a;cBGO",0), //1288
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLfvJAHkqPjoKOA;nLS0a;cBGO",0), //1289
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLZvJAVFKMvlpMw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //1290
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLZvJAVFKMvlpMw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //1291
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLZvJAVFKMklpM49KNjoKO::rLR0qPl3rQjEaPBn6R9pGNEdaP",0), //1292
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLZvJAVFKMklpM49KNjoKO::rLR0qPl3rQjEaPEn6RtpmMEdaP",0), //1293
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR87qLZvJAVFKMclpMnnaQP1LNjoKOLOrLT36QSIqPPpKNhILOS0a;cBGO",0), //1294
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR17qLZuJCVFKMvlpMw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //1295
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR17qLZuJCVFKMvlpMw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //1296
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR17qLZuJCVFKMklpM49KNjoKO::rLR0qPl3rQjEaPBn6R9pGNEdaP",0), //1297
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR17qLZuJCVFKMklpM49KNjoKO::rLR0qPl3rQjEaPEn6RtpmMEdaP",0), //1298
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR17qLZuJCVFKMclpMnnaQP1LNjoKOLOrLT36QSIqPPpKNhILOS0a;cBGO",0), //1299
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPFP6RMfKR:OqLLFLMG9aNi23AVpKM",0), //1300
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQ:OqLaELMVpKM",0), //1301
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQ0SqLjz6QrfqQFoWPEdaP",0), //1302
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQ:GqLaMKONx6NS0a;cBGO",0), //1303
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQFeqLC:6RVpKM",0), //1304
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQKiqLtTrQCx6PVpKM",0), //1305
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQKiqLtTrQEx6PlzWAEdaP",0), //1306
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQSqqLSNaNifqQ9pGNEdaP",0), //1307
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQE6rLAkqPS0a;cBGO",0), //1308
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQE6rLAkqPR2rLlRKMS0a;cBGO",0), //1309
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPGP7RYPaQKSrLvoKOA;6R1o2PEdaP",0), //1310
	new Array(1,"NdqNjQbPRNaNhxKMLOrLVf6QyebQVpKM",0), //1311
	new Array(1,"NdqNjQbPRNaNhxKMNKrLzU6PaCHAVpKM",0), //1312
	new Array(1,"NdqNjQbPRNaNhxKMNKrLzU6PSIqPPpKNhILOS0a;cBGO",0), //1313
	new Array(1,"NdqNjQbPRNaNhxKMNKrLGP6RjoKOon6QS0a;cBGO",0), //1314
	new Array(1,"NdqNjQbPRNaNhxKMNKrLGP6R4MKPKpqPVpKM",0), //1315
	new Array(1,"NdqNjQbPRNaNhxKMRKrL9R6NjEaPTxaN:PqRNKrLCV6PVpKM",0), //1316
	new Array(1,"NdqNjQbPRNaNhxKMRKrL9R6NjEaPQMLP4;KRL2qLKfqRNpmNEdaP",0), //1317
	new Array(1,"NdqNjQbPRNaNhxKMRKrL9R6NjEaPI;qRtomOEdaP",0), //1318
	new Array(1,"NdqNjQbPRNaNhxKMFKrLHN6N177RUEKOIn5R;kpPLQLOthqML4LOi23AVpKM",0), //1319
	new Array(1,"NdqNjQbPRNaNhxKMFKrLW:aSHl5NC;6R6l5NpfaQQQaPdqGSEdaP",0), //1320
	new Array(1,"NdqNjQbPi86O556NCx6PVpKM",0), //1321
	new Array(1,"NdqNjQbPi86O556Nzw6PtTrQjQaPN5bNApKNCd7PVpKM",0), //1322
	new Array(1,"NdqNjQbPoc6OdpGMEdaP",0), //1323
	new Array(1,"NdqNjQbPoc6OlpWMEdaP",0), //1324
	new Array(1,"NdqNjQbPbM7Oi23AVpKM",0), //1325
	new Array(1,"NdqNjQbPh0KO6cKP9pGNEdaP",0), //1326
	new Array(1,"NdqNjQbPh0KO6cKP4lJN8kqPS0a;cBGO",0), //1327
	new Array(1,"NdqNjQbPvoKOQ1KNS0a;cBGO",0), //1328
	new Array(1,"NdqNjQbPloqOAhqNE6qLjpKM7ZKNU0bMdzGAEdaP",0), //1329
	new Array(1,"NdqNjQbPloqOAhqNA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //1330
	new Array(1,"NdqNjQbPloqOAhqNA6rLgpKMQiqLEN6PdzGAEdaP",0), //1331
	new Array(1,"NdqNjQbPKM6PRxKNVr2QEdaP",0), //1332
	new Array(1,"NdqNjQbPD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //1333
	new Array(1,"NdqNjQbPD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //1334
	new Array(1,"NdqNjQbPD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //1335
	new Array(1,"NdqNjQbPD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //1336
	new Array(1,"NdqNjQbPD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //1337
	new Array(1,"NdqNjQbP48KP:lJNYxKMKkqPL2qLLRLMT;3AtTrQjQaPN5bNApKNCd7PVpKM",0), //1338
	new Array(1,"NdqNjQbP48KP;lJNQ7LRadKMN6qLEx6PdzGAEdaP",0), //1339
	new Array(1,"NdqNjQbP48KP;lJNQ7LRadKMN6qLEx6PlzWAEdaP",0), //1340
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPjpKMyebQVpKM",0), //1341
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPv1LMYNLM1j2Rd23AS0a;cBGO",0), //1342
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPv1LMYNLMIj2Rd23AS0a;cBGO",0), //1343
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPv1LMYNLM1r2REdaP",0), //1344
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPxhqM64LNVpKM",0), //1345
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPrxqM5j6RtrmQEdaP",0), //1346
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPV5rMS0a;cBGO",0), //1347
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPHd6NhlqMr;aQ9pGNEdaP",0), //1348
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPJxaNVq2SEdaP",0), //1349
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPQlaNLk6P6NKPVpKM",0), //1350
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPANqNi23AVpKM",0), //1351
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPANqNiC3AVpKM",0), //1352
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPANqNi:3AVpKM",0), //1353
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPR5rN1RLNSFaPVpKM",0), //1354
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPi86OA16NaALMVpKM",0), //1355
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPiM7O15rNS0a;cBGO",0), //1356
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPJ86PKgqNVpKM",0), //1357
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqP6NKPVpKM",0), //1358
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPPMLPa1KOVpKM",0), //1359
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPSlaPVpKM",0), //1360
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPVz6QdqGSEdaP",0), //1361
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPZz6Qh1LMS0a;cBGO",0), //1362
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPhPLQlTrQKpqPVpKM",0), //1363
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPoPbQ9pGNEdaP",0), //1364
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPxvqQCx6PVpKM",0), //1365
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPePrQd77QqOqQVpKM",0), //1366
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPNn6RS0a;cBGO",0), //1367
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPvOKSdxG8EdaP",0), //1368
	new Array(1,"NdqNjQbP48KP6lJNxRLMw;aQJSqLFQrPboqPvOKSS0a;cBGO",0), //1369
	new Array(1,"NdqNjQbP48KPPlJNocqOBk5PVFKMh5qMw5aMAlJNUnaQS0a;cBGO",0), //1370
	new Array(1,"NdqNjQbP48KPPlJNocqOBk5PVFKMh5qMw5aM4lJNgpKMjoKOS0a;cBGO",0), //1371
	new Array(1,"NdqNjQbP48KPPlJNocqOBk5PVFKMh5qMw5aMPlJNN;6RS0a;cBGO",0), //1372
	new Array(1,"NdqNjQbP48KPQlJNIkqPN2qL9w6PtTrQ9;nLFCqL9oGPEdaP",0), //1373
	new Array(1,"NdqNjQbP48KPQlJNIkqPN2qL9w6PtTrQ9;nLE6qLj5LM9pGNEdaP",0), //1374
	new Array(1,"NdqNjQbP48KPQlJNIkqPN2qL9w6PtTrQ9;nLE6rLAkqPS0a;cBGO",0), //1375
	new Array(1,"NdqNjQbP48KPQlJNIkqPN2qL9w6PtTrQ9;nLA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //1376
	new Array(1,"NdqNjQbP48KPTlJNARKNjoKOByqL1P7R2k5PFErPSFaPVpKM",0), //1377
	new Array(1,"NdqNjQbP68KPB7LRS0a;cBGO",0), //1378
	new Array(1,"NdqNjQbPOMKPthqMjQbPtTrQjQaPN5bNApKNCd7PVpKM",0), //1379
	new Array(1,"NdqNjQbPOMKPthqMjQbPtTrQjQaPYQKONAHNS0a;cBGO",0), //1380
	new Array(1,"NdqNjQbP6cKPd4KODw6PboqP9xaNjoKOS0a;cBGO",0), //1381
	new Array(1,"NdqNjQbP6cKPd4KODw6PboqP9xaNjoKOiC3AVpKM",0), //1382
	new Array(1,"NdqNjQbP48aP97LR1k5P1T7R7VqMtvqQ7jqQi23AVpKM",0), //1383
	new Array(1,"NdqNjQbP48aP97LR1k5P1T7R7VqMtvqQ7jqQiC3AVpKM",0), //1384
	new Array(1,"NdqNjQbP48aP97LR2k5PLk6PdFLMdqGSEdaP",0), //1385
	new Array(1,"NdqNjQbP48aP97LR2k5PLk6PdFLMemJS1QqPS0a;cBGO",0), //1386
	new Array(1,"NdqNjQbP48aP97LR2k5PLk6PdFLMhmJS5QaPyOaQVpKM",0), //1387
	new Array(1,"NdqNjQbP48aP97LR2k5PLk6PdFLMhmJS5QaPDPaQiC3AVpKM",0), //1388
	new Array(1,"NdqNjQbP48aP97LR2k5PLk6PdFLMhmJS5QaPDPaQi:3AVpKM",0), //1389
	new Array(1,"NdqNjQbP48aP97LR2k5PLk6PdFLMhmJS5QaPDPaQiK3AVpKM",0), //1390
	new Array(1,"NdqNjQbP48aP97LR2k5PLk6PdFLMhmJS5QaPDPaQiG3AVpKM",0), //1391
	new Array(1,"NdqNjQbP48aP97LR2k5PLk6PdFLMjmJSZnaQSRaPVpKM",0), //1392
	new Array(1,"NdqNjQbP48aP97LR2k5PLk6PdFLMjmJSZnaQjQaPRNaNhxKMS0a;cBGO",0), //1393
	new Array(1,"NdqNjQbP48aP97LR2k5PLk6PdFLMwmJS67LRS0a;cBGO",0), //1394
	new Array(1,"NdqNjQbP48aP97LR3k5PKMrPGP6RS0a;cBGO",0), //1395
	new Array(1,"NdqNjQbP48aP97LR4k5Ph0KOi23AVpKM",0), //1396
	new Array(1,"NdqNjQbP48aP97LR4k5Ph0KOiC3AVpKM",0), //1397
	new Array(1,"NdqNjQbP48aP97LR4k5Ph0KOL2qLlD3SS0a;cBGO",0), //1398
	new Array(1,"NdqNjQbP48aP97LR4k5Ph0KOL2qLmD3SS0a;cBGO",0), //1399
	new Array(1,"NdqNjQbP48aP97LR4k5Ph0KOL2qLgm5S8kqPS0a;cBGO",0), //1400
	new Array(1,"NdqNjQbP48aP97LR4k5Ph0KOLuqLKBrPVpKM",0), //1401
	new Array(1,"NdqNjQbP48aP97LR4k5PKErPwRLMX1KMS0a;cBGO",0), //1402
	new Array(1,"NdqNjQbP48aP97LR4k5PKErPlpWMEdaP",0), //1403
	new Array(1,"NdqNjQbP48aP97LR4k5PKErPqlZM9tKNCN6PVpKM",0), //1404
	new Array(1,"NdqNjQbP48aP97LR4k5PKErPslZMaRLOVpKM",0), //1405
	new Array(1,"NdqNjQbP48aP97LR4k5Pb;aQS0a;cBGO",0), //1406
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOB6qLXTbQ6cLNVpKM",0), //1407
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKONOqLJ0aPi23AVpKM",0), //1408
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKONOqLJ0aP1OrLVP6QS0a;cBGO",0), //1409
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKONOqLJ0aP1OrLWP6QS0a;cBGO",0), //1410
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKONOqLJ0aP1OrLXP6QS0a;cBGO",0), //1411
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKONOqLJ0aP1OrLYP6QS0a;cBGO",0), //1412
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOLKqLBM6PNKrLCV6PVpKM",0), //1413
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKONeqLHQaPE86PS0a;cBGO",0), //1414
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOLuqLQPaRdqGSEdaP",0), //1415
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOByqL1P7R2k5PFErPSFaPVpKM",0), //1416
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKO0qqL9rqLS0a;cBGO",0), //1417
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKO0qqL:rqLS0a;cBGO",0), //1418
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKO0qqL;rqLS0a;cBGO",0), //1419
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKO0qqL9frLS0a;cBGO",0), //1420
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKO0qqL:frLS0a;cBGO",0), //1421
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKO0qqL;frLS0a;cBGO",0), //1422
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKON6rLIM7P9pGNEdaP",0), //1423
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOH6rLYwKONGqLLwKOrjqQySbQVpKM",0), //1424
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOH6rLYwKONGqLLwKOrjqQUSbQlzWAEdaP",0), //1425
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOH6rLYwKOB6rLx1qMq2rQVpKM",0), //1426
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOH6rLYwKOB6rLx1qMc2rQlzWAEdaP",0), //1427
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOROrLcSrQdzGAEdaP",0), //1428
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOROrLcSrQlzWAEdaP",0), //1429
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOROrLcSrQtzmAEdaP",0), //1430
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOROrLcSrQ9zGBEdaP",0), //1431
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOROrLcSrQFzWBEdaP",0), //1432
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOROrLcSrQNzmBEdaP",0), //1433
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOROrLcSrQVy2CEdaP",0), //1434
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOROrLcSrQdyGCEdaP",0), //1435
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOROrLdSrQVz2AEdaP",0), //1436
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOROrLdSrQdzGAEdaP",0), //1437
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOROrL7TrQadKMNpmNEdaP",0), //1438
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOROrL7TrQwpKMd5KMq9qOVpKM",0), //1439
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOROrL7TrQtM6OS0a;cBGO",0), //1440
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOROrL7TrQnP7QkM7OS0a;cBGO",0), //1441
	new Array(1,"NdqNjQbP48aP97LR5k5PQkKPakKOROrL7TrQCS7RVpKM",0), //1442
	new Array(1,"NdqNjQbP48aP97LR5k5PM0aPwpKMS0a;cBGO",0), //1443
	new Array(1,"NdqNjQbP48aP97LR7k5PURLM15LNjEaPDFKNtrmQEdaP",0), //1444
	new Array(1,"NdqNjQbP48aP97LR7k5PURLM15LNjEaPmM6OlpWMEdaP",0), //1445
	new Array(1,"NdqNjQbP48aP97LR7k5PURLM15LNjEaPA;qRr5LNT5bNQ0LPlPaQ9oGPEdaP",0), //1446
	new Array(1,"NdqNjQbP48aP97LR7k5PURLM15LNjEaPA;qRr5LNT5bNBELPCx6PVpKM",0), //1447
	new Array(1,"NdqNjQbP48aP97LR7k5PURLM15LNjEaPA;qRr5LN577R9pGNEdaP",0), //1448
	new Array(1,"NdqNjQbP48aP97LR7k5PrnaQKcrNVpKM",0), //1449
	new Array(1,"NdqNjQbP48aP97LR7k5PO;KR1p2NEdaP",0), //1450
	new Array(1,"NdqNjQbP48aP97LR8k5PgpKMu2KSwJKMS0a;cBGO",0), //1451
	new Array(1,"NdqNjQbP48aP97LR8k5PdQLOS0a;cBGO",0), //1452
	new Array(1,"NdqNjQbP48aP97LR8k5PeQLOS0a;cBGO",0), //1453
	new Array(1,"NdqNjQbP48aP97LRAk5PF6rLGn5RFErPSFaPVpKM",0), //1454
	new Array(1,"NdqNjQbP48aP97LRBk5PVFKMvlpMw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //1455
	new Array(1,"NdqNjQbP48aP97LRBk5PVFKMvlpMw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //1456
	new Array(1,"NdqNjQbP48aP97LRBk5PVFKMklpM49KNjoKO::rLR0qPl3rQjEaPBn6R9pGNEdaP",0), //1457
	new Array(1,"NdqNjQbP48aP97LRBk5PVFKMklpM49KNjoKO::rLR0qPl3rQjEaPEn6RtpmMEdaP",0), //1458
	new Array(1,"NdqNjQbP48aP97LRBk5PVFKMclpMnnaQP1LNjoKOLOrLT36QSIqPPpKNhILOS0a;cBGO",0), //1459
	new Array(1,"NdqNjQbP48aP97LRBk5PVFKMclpMnnaQP1LNjoKOLOrLT36QSIqPPpKNhILO86rLYfaQ9pGNEdaP",0), //1460
	new Array(1,"NdqNjQbP48aP97LRBk5PVFKMflpMZc6OCR6PVpKM",0), //1461
	new Array(1,"NdqNjQbP48aP97LREk5PFQrPJoqPVVKMSFaPVpKM",0), //1462
	new Array(1,"NdqNjQbP48aP97LREk5PUPaQV5LMjEaPO8KPgMqOS0a;cBGO",0), //1463
	new Array(1,"NdqNjQbP48aP97LRGk5PrrKRaCHAVpKM",0), //1464
	new Array(1,"NdqNjQbP48aP97LRGk5PrrKRSIqPPpKNhILOS0a;cBGO",0), //1465
	new Array(1,"NdqNjQbP48aP97LRGk5PF6rLGn5RFErPSFaPVpKM",0), //1466
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOi23AVpKM",0), //1467
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOT33AFA3NS0a;cBGO",0), //1468
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOT33Azn6RQfqRQ1LNt;aQAhqNS0a;cBGO",0), //1469
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOT33Azn6RQfqRQ1LNt;aQAhqN8PqLdzGAEdaP",0), //1470
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOiC3AVpKM",0), //1471
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOTD3Azn6RQfqRQ1LNt;aQAhqNS0a;cBGO",0), //1472
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOi:3AVpKM",0), //1473
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOT;3Azn6RQfqRQ1LNt;aQAhqNS0a;cBGO",0), //1474
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOiK3AVpKM",0), //1475
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOTL3Azn6RQfqRQ1LNt;aQAhqNS0a;cBGO",0), //1476
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOiG3AVpKM",0), //1477
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOTH3Azn6RQfqRQ1LNt;aQAhqNS0a;cBGO",0), //1478
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOthqML4LOi23AVpKM",0), //1479
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOthqML4LOT33ANpmNEdaP",0), //1480
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOthqML4LOT33Azn6RQfqRQ1LNt;aQAhqNS0a;cBGO",0), //1481
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOthqML4LOT33Azn6RQfqRQ1LNt;aQAhqNKLqLVpKM",0), //1482
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOthqML4LOiC3AVpKM",0), //1483
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOthqML4LOTD3Azn6RQfqRQ1LNt;aQAhqNS0a;cBGO",0), //1484
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOthqML4LOi:3AVpKM",0), //1485
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLOthqML4LOT;3Azn6RQfqRQ1LNt;aQAhqNS0a;cBGO",0), //1486
	new Array(1,"NdqNjQbP48aP97LRHk5PLQLO7kKPFoWPEdaP",0), //1487
	new Array(1,"NdqNjQbP48aP97LRHk5PC;6REk5NdzGAEdaP",0), //1488
	new Array(1,"NdqNjQbP48aP97LRHk5PC;6REk5NlzWAEdaP",0), //1489
	new Array(1,"NdqNjQbP48aP97LRHk5PC;6REk5NtzmAEdaP",0), //1490
	new Array(1,"NdqNjQbP48aP97LRHk5PC;6REk5N1z2BEdaP",0), //1491
	new Array(1,"NdqNjQbP48aP97LRHk5PC;6RAl5NQJKNhhKMaQKMVpKM",0), //1492
	new Array(1,"NdqNjQbP48aP97LRHk5PC;6RDl5NJJaNN0bPSOaRVpKM",0), //1493
	new Array(1,"NdqNjQbP48aP97LRHk5PC;6RDl5NCR6PVpKM",0), //1494
	new Array(1,"NdqNjQbP48aP97LRHk5PC;6RHl5N177RUEKO1r2REdaP",0), //1495
	new Array(1,"NdqNjQbP48aP97LRHk5PC;6RLl5NhQKOeTrQjdKMiR7OVpKM",0), //1496
	new Array(1,"NdqNjQbP48aP97LRIk5Pj47OPnpRw1LMS0a;cBGO",0), //1497
	new Array(1,"NdqNjQbP48aP97LRIk5Pj47O8npRX0KOS0a;cBGO",0), //1498
	new Array(1,"NdqNjQbP48aP97LRIk5Pj47ODnpRwdKMjoKOS0a;cBGO",0), //1499
	new Array(1,"NdqNjQbP48aP97LRLk5PXxKM:DnLS0a;cBGO",0), //1500
	new Array(1,"NdqNjQbP48aP97LRLk5PXxKMSqqLSNaNifqQ9pGNEdaP",0), //1501
	new Array(1,"NdqNjQbP48aP97LRLk5PS9KNjoKOS0a;cBGO",0), //1502
	new Array(1,"NdqNjQbP48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQ9;nLS0a;cBGO",0), //1503
	new Array(1,"NdqNjQbP48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQ9;nL8PqLdzGAEdaP",0), //1504
	new Array(1,"NdqNjQbP48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQ:;nLS0a;cBGO",0), //1505
	new Array(1,"NdqNjQbP48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQ;;nLS0a;cBGO",0), //1506
	new Array(1,"NdqNjQbP48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQA;nLS0a;cBGO",0), //1507
	new Array(1,"NdqNjQbP48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQB;nLS0a;cBGO",0), //1508
	new Array(1,"NdqNjQbP48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQE6qLudKM9;nLS0a;cBGO",0), //1509
	new Array(1,"NdqNjQbP48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQE6qLudKM9;nLKLqLVpKM",0), //1510
	new Array(1,"NdqNjQbP48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQE6qLudKM:;nLS0a;cBGO",0), //1511
	new Array(1,"NdqNjQbP48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQE6qLudKM;;nLS0a;cBGO",0), //1512
	new Array(1,"NdqNjQbP48aP97LRLk5PgoKO4cKPGk5PV0LOSFaPVpKM",0), //1513
	new Array(1,"NdqNjQbP48aP97LRLk5PgoKO4cKPHk5PC;6RCd6NNpmNEdaP",0), //1514
	new Array(1,"NdqNjQbPScaPD8aOwxKMB5LNblqNf9qMCf6RNpmNEdaP",0), //1515
	new Array(1,"NdqNjQbPScaPD8aOwxKMB5LNblqNj77QfNqMqfqQNpmNEdaP",0), //1516
	new Array(1,"NdqNjQbPk;6Q95LNs4LOC86P9pGNEdaP",0), //1517
	new Array(1,"NdqNjQbPVz6QSNaPVpKM",0), //1518
	new Array(1,"NdqNjQbPVz6QuOKSD6rLQ4rPRKqLFC3RS0a;cBGO",0), //1519
	new Array(1,"NdqNjQbPVz6QuOKSD6rLQ4rPRKqLGC3RS0a;cBGO",0), //1520
	new Array(1,"NdqNjQbPVz6QXmJSjoKONOrLEV6PdzGAEdaP",0), //1521
	new Array(1,"NdqNjQbPVz6QXmJSjoKONOrLEV6PlzWAEdaP",0), //1522
	new Array(1,"NdqNjQbPVz6QXmJSjoKONOrLEV6PtzmAEdaP",0), //1523
	new Array(1,"NdqNjQbPZ77Qm;6QjoKONyqLpXaQ1r2REdaP",0), //1524
	new Array(1,"NdqNjQbPkP7QoP6QKqqL9hKNjQaPR5rN1RLNSFaPVpKM",0), //1525
	new Array(1,"NdqNjQbPkP7QoP6QKqqL9hKNjQaPmk6O7PqQofaQjoKONmqLGP7RLxKMT33AtTrQjQaPN5bNApKNCd7PVpKM",0), //1526
	new Array(1,"NdqNjQbPkP7QoP6QKqqL9hKNjQaPmk6O7PqQofaQjoKONmqLGP7RLxKMTD3AtTrQjQaPN5bNApKNCd7PVpKM",0), //1527
	new Array(1,"NdqNjQbPkP7QoP6QKqqL9hKNjQaPJ86PKgqNVpKM",0), //1528
	new Array(1,"NdqNjQbPkP7QoP6QKqqL9hKNjQaPgfqQS0a;cBGO",0), //1529
	new Array(1,"NdqNjQbPkP7QoP6QKqqL9hKNjQaPgfqQLOrLFKrLHN6N177RUEKO1r2REdaP",0), //1530
	new Array(1,"NdqNjQbPkP7QoP6QKqqL9hKNjQaPtTrQjQaPN5bNApKNCd7PVpKM",0), //1531
	new Array(1,"NdqNjQbPkP7QoP6QKqqL9hKNjQaPQfqRQ1LNt;aQAhqNLOrLF6rL1r2REdaP",0), //1532
	new Array(1,"NdqNjQbPkP7QoP6QDOrLNgqPjQaPR5rN1RLNSFaPVpKM",0), //1533
	new Array(1,"NdqNjQbPkP7QoP6QDOrLNgqPjQaPmk6O7PqQofaQjoKONmqLGP7RLxKMT33AtTrQjQaPN5bNApKNCd7PVpKM",0), //1534
	new Array(1,"NdqNjQbPkP7QoP6QDOrLNgqPjQaPmk6O7PqQofaQjoKONmqLGP7RLxKMTD3AtTrQjQaPN5bNApKNCd7PVpKM",0), //1535
	new Array(1,"NdqNjQbPkP7QoP6QDOrLNgqPjQaPJ86PKgqNVpKM",0), //1536
	new Array(1,"NdqNjQbPkP7QoP6QDOrLNgqPjQaPgfqQS0a;cBGO",0), //1537
	new Array(1,"NdqNjQbPkP7QoP6QDOrLNgqPjQaPgfqQLOrLFKrLHN6N177RUEKO1r2REdaP",0), //1538
	new Array(1,"NdqNjQbPkP7QoP6QDOrLNgqPjQaPtTrQjQaPN5bNApKNCd7PVpKM",0), //1539
	new Array(1,"NdqNjQbPkP7QoP6QDOrLNgqPjQaPQfqRQ1LNt;aQAhqNLOrLF6rL1r2REdaP",0), //1540
	new Array(1,"NdqNjQbPdnaQdxKM806P1tKN7TrQtTrQjQaPN5bNApKNCd7PVpKM",0), //1541
	new Array(1,"NdqNjQbPyPbQ:DnLS0a;cBGO",0), //1542
	new Array(1,"NdqNjQbPyPbQSqqLSNaNifqQ9pGNEdaP",0), //1543
	new Array(1,"NdqNjQbPgfqQ9;nLS0a;cBGO",0), //1544
	new Array(1,"NdqNjQbPgfqQ9;nL8DqLdzGAEdaP",0), //1545
	new Array(1,"NdqNjQbPgfqQ9;nL83qLlzWAEdaP",0), //1546
	new Array(1,"NdqNjQbPgfqQ9;nL:7qLdzGAEdaP",0), //1547
	new Array(1,"NdqNjQbPgfqQ9;nL8TqLdzGAEdaP",0), //1548
	new Array(1,"NdqNjQbPgfqQ9;nL8fqLdzGAEdaP",0), //1549
	new Array(1,"NdqNjQbPgfqQ9;nL8PrLdzGAEdaP",0), //1550
	new Array(1,"NdqNjQbPgfqQ9;nLLOrLFKrLHN6N177RUEKO1r2REdaP",0), //1551
	new Array(1,"NdqNjQbPgfqQ9;nLLOrLFKrLHN6N177RUEKO1n5Ri23AVpKM",0), //1552
	new Array(1,"NdqNjQbPgfqQ9;nLLOrLFKrLHN6N177RUEKO2n5RiC3AVpKM",0), //1553
	new Array(1,"NdqNjQbPgfqQ9;nLLOrLFKrLHN6N177RUEKO3n5Ry2XAVpKM",0), //1554
	new Array(1,"NdqNjQbPgfqQ9;nLLOrLFKrLHN6N177RUEKO5n5Ri23AVpKM",0), //1555
	new Array(1,"NdqNjQbPgfqQ9;nLLOrLFKrLHN6N177RUEKO8n5Ri23AVpKM",0), //1556
	new Array(1,"NdqNjQbPgfqQ9;nLLOrLFKrLHN6N177RUEKOIn5Ri23AVpKM",0), //1557
	new Array(1,"NdqNjQbPgfqQ:;nLS0a;cBGO",0), //1558
	new Array(1,"NdqNjQbPgfqQE6qLudKM9;nLS0a;cBGO",0), //1559
	new Array(1,"NdqNjQbPgfqQE6qLudKM9;nLLOrLFKrLHN6N177RUEKO1r2REdaP",0), //1560
	new Array(1,"NdqNjQbPgfqQE6qLudKMNSqL1r2REdaP",0), //1561
	new Array(1,"NdqNjQbPgfqQNSqL1r2REdaP",0), //1562
	new Array(1,"NdqNjQbPgfqQLOrLFKrLHN6N177RUEKOGC3RS0a;cBGO",0), //1563
	new Array(1,"NdqNjQbPgfqQLOrLFKrLHN6N177RUEKOGC3RK3qLVpKM",0), //1564
	new Array(1,"NdqNjQbPlXqQbuqLGP7RFoWPEdaP",0), //1565
	new Array(1,"NdqNjQbPlXqQB2rLFoWPEdaP",0), //1566
	new Array(1,"NdqNjQbPlXqQb2rLGP7RFoWPEdaP",0), //1567
	new Array(1,"NdqNjQbPlXqQA6rLKBrPVpKM",0), //1568
	new Array(1,"NdqNjQbPlDrQYfaQSqqLE6rLbRKMNrmREdaP",0), //1569
	new Array(1,"NdqNjQbPlDrQYfaQSqqLE6rLbRKMInpR8kqPS0a;cBGO",0), //1570
	new Array(1,"NdqNjQbPtTrQjQaPN5bNApKNzc7PHk5PLQLObnaQjoKOS0a;cBGO",0), //1571
	new Array(1,"NdqNjQbPtTrQjQaPN5bNApKNzc7PbnaQjoKOS0a;cBGO",0), //1572
	new Array(1,"NdqNjQbPtTrQjQaPN5bNApKNzc7PXnZQLQLObnaQjoKOS0a;cBGO",0), //1573
	new Array(1,"NdqNjQbPtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1574
	new Array(1,"NdqNjQbPxTrQwxKMgc6OzmJSXxKMi23AVpKM",0), //1575
	new Array(1,"NdqNjQbPrTrQrALPw1KMakKOS0a;cBGO",0), //1576
	new Array(1,"NdqNjQbPrTrQrALPlPaQCc7NVpKM",0), //1577
	new Array(1,"NdqNjQbPJ;6RSRbPVpKM",0), //1578
	new Array(1,"NdqNjQbPHP6R1n5R1T7R7VqMi23AVpKM",0), //1579
	new Array(1,"NdqNjQbPHP6R1n5R1T7R7VqMiC3AVpKM",0), //1580
	new Array(1,"NdqNjQbPGj6RbErPf9qM1r2REdaP",0), //1581
	new Array(1,"NdqNjQbPGj6RbErPXf6QtomOEdaP",0), //1582
	new Array(1,"NdqNjQbPGj6RbErPF;qRCf6RNpmNEdaP",0), //1583
	new Array(1,"NdqNjQbPDn6R2k5Pi86O4l5Nb;aQN2qLqUqMVpKM",0), //1584
	new Array(1,"NdqNjQbPDn6R2k5Pi86O4l5Nb;aQN2qLoVqMBuqLCO6RVpKM",0), //1585
	new Array(1,"NdqNjQbPDn6R2k5Pi86O4l5Nb;aQN2qL7VqMblaMS0a;cBGO",0), //1586
	new Array(1,"NdqNjQbPDn6R2k5Pi86O4l5Nb;aQN2qL7VqMr5rMu3rQKFrPVpKM",0), //1587
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AwRLMX1KM9;nLS0a;cBGO",0), //1588
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AwRLMX1KM:;nLS0a;cBGO",0), //1589
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AwRLMX1KM:;nL86rLYfaQ9pGNEdaP",0), //1590
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AwRLMX1KM;;nLS0a;cBGO",0), //1591
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AwRLMX1KML6qLQrKRr5LNi23AVpKM",0), //1592
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AwRLMX1KMJ6rLU1LM9;nLS0a;cBGO",0), //1593
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AzxaMD;qRLdLMApKNB7LRS0a;cBGO",0), //1594
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AzxaMD;qRLdLML5rNArKRS0a;cBGO",0), //1595
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33ALl6NS5aPVpKM",0), //1596
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33A3daNic6OPlpNfRLMic6ONpmNEdaP",0), //1597
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33A3daNic6OPlpNfRLMic6OSlpNYdKMB7LRS0a;cBGO",0), //1598
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33A3daNic6OAlpNj47OKfqRSlpN1k6P1r2REdaP",0), //1599
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33A3daNic6ODlpNwdKMjoKO9;nLS0a;cBGO",0), //1600
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33A3daNic6ODlpNwdKMjoKO:;nLS0a;cBGO",0), //1601
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33A3daNic6ODlpNwdKMjoKO:;nLRGqL48KP9pGNEdaP",0), //1602
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33A3daNic6ODlpNwdKMjoKO:;nLFKqLwpKMS0a;cBGO",0), //1603
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33A3daNic6ODlpNwdKMjoKO;;nLS0a;cBGO",0), //1604
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33ANNrNySaQVpKM",0), //1605
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //1606
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //1607
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //1608
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //1609
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AyPbQ:GqLaMKONx6NS0a;cBGO",0), //1610
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AyPbQSqqLSNaNifqQ9pGNEdaP",0), //1611
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AtTrQjQaPN5bNApKNCd7PVpKM",0), //1612
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1613
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AI;qRykpOpfaQQQaPdqGSEdaP",0), //1614
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AI;qRrkpOJJaNN0bPSOaRVpKM",0), //1615
	new Array(1,"NdqNjQbPDn6R2k5Pi86O5l5NT33AKfqR9t6Nzw6PtTrQNQaPSFaPVpKM",0), //1616
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33AZdKMjoKOL:rL:PqR9;nLS0a;cBGO",0), //1617
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33AZdKMjoKOL:rL:PqR9;nL86rLYfaQ9pGNEdaP",0), //1618
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33AZdKMjoKON2rLJEaP9;nLS0a;cBGO",0), //1619
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //1620
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //1621
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //1622
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //1623
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //1624
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33AyPbQ:GqLaMKONx6NS0a;cBGO",0), //1625
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33AyPbQSqqLSNaNifqQ9pGNEdaP",0), //1626
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33ArjqQFQrPjEaPrn6Qr5LNi23AVpKM",0), //1627
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33ArjqQFQrPjEaPrn6Qr5LNT33AeDrQhQLOS0a;cBGO",0), //1628
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33ArjqQFQrPjEaPy;aQbNqNi23AVpKM",0), //1629
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33AtTrQjQaPN5bNApKNCd7PVpKM",0), //1630
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1631
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33AI;qRykpOpfaQQQaPdqGSEdaP",0), //1632
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NT33AI;qRrkpOJJaNN0bPSOaRVpKM",0), //1633
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NTD3AZdKMjoKOL:rL:PqR9;nLS0a;cBGO",0), //1634
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NTD3AZdKMjoKOL:rL:PqR9;nL86rLYfaQ9pGNEdaP",0), //1635
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NTD3AZdKMjoKON2rLJEaP9;nLS0a;cBGO",0), //1636
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NTD3AyPbQ:GqLaMKONx6NS0a;cBGO",0), //1637
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NTD3AyPbQSqqLSNaNifqQ9pGNEdaP",0), //1638
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NTD3ArjqQFQrPjEaPrn6Qr5LNi23AVpKM",0), //1639
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NTD3ArjqQFQrPjEaPrn6Qr5LNT33AeDrQhQLOS0a;cBGO",0), //1640
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NTD3ArjqQFQrPjEaPy;aQbNqNi23AVpKM",0), //1641
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NTD3AtTrQjQaPN5bNApKNCd7PVpKM",0), //1642
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NTD3AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1643
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NTD3AI;qRykpOpfaQQQaPdqGSEdaP",0), //1644
	new Array(1,"NdqNjQbPDn6R2k5Pi86O7l5NTD3AI;qRrkpOJJaNN0bPSOaRVpKM",0), //1645
	new Array(1,"NdqNjQbPDn6R2k5Pi86O8l5NgpKMwNaMLk5PXxKMS0a;cBGO",0), //1646
	new Array(1,"NdqNjQbPDn6R2k5Pi86O;l5NLcaPTQ7OrHrQDTaQtTrQjQaPN5bNApKNCd7PVpKM",0), //1647
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT33AwRLMX1KM9;nLS0a;cBGO",0), //1648
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT33AwRLMX1KM:;nLS0a;cBGO",0), //1649
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT33AwRLMX1KM;;nLS0a;cBGO",0), //1650
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT33AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //1651
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT33AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //1652
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //1653
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //1654
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT33AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //1655
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT33AVz6QaeKSIlpNBTLR9;nLS0a;cBGO",0), //1656
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT33AVz6QaeKSIlpNBTLR9;nLNKrLCV6PVpKM",0), //1657
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT33AyPbQ:GqLaMKONx6NS0a;cBGO",0), //1658
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT33AyPbQSqqLSNaNifqQ9pGNEdaP",0), //1659
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT33AtTrQjQaPN5bNApKNCd7PVpKM",0), //1660
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1661
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT33AI;qRykpOpfaQQQaPdqGSEdaP",0), //1662
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT33AI;qRrkpOJJaNN0bPSOaRVpKM",0), //1663
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NTD3AVz6QaeKS8lpNgf6QVwKOS0a;cBGO",0), //1664
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NTD3AVz6QaeKS8lpNgf6QVwKONKrLCV6PVpKM",0), //1665
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NTD3AtTrQjQaPN5bNApKNCd7PVpKM",0), //1666
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT;3AVz6QaeKSElpN4fKRAc6PdoGOEdaP",0), //1667
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT;3AVz6QaeKSElpN4fKRAc6PzkJOXxKMS0a;cBGO",0), //1668
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NT;3AtTrQjQaPN5bNApKNCd7PVpKM",0), //1669
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NTb3AVz6QaeKS;lpN;MrPUBLMRoqPS0a;cBGO",0), //1670
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NTb3AtTrQjQaPN5bNApKNCd7PVpKM",0), //1671
	new Array(1,"NdqNjQbPDn6R2k5Pi86OEl5NN86PjoKO16qL94KPz07PI;qRtomOEdaP",0), //1672
	new Array(1,"NdqNjQbPDn6R2k5Pi86OEl5NN86PjoKO:OqLrvKRtvqQzw6PI;qRtomOEdaP",0), //1673
	new Array(1,"NdqNjQbPDn6R2k5Pi86OEl5NN86PjoKOL6rL93LRjj6QjMaPI;qRtomOEdaP",0), //1674
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5N1n5R1T7RcUqMdzGAEdaP",0), //1675
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5N1n5R1T7RcUqMlzWAEdaP",0), //1676
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5N1n5R1T7RcUqMtzmAEdaP",0), //1677
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5N2n5RLk6PdFLMhmJS5QaPyOaQVpKM",0), //1678
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5N4n5Rb;aQN2qLoVqMS0a;cBGO",0), //1679
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5N7n5RO;KR1p2NEdaP",0), //1680
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NBn5RVFKMvlpMw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //1681
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NBn5RVFKMvlpMw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //1682
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NBn5RVFKMklpM49KNjoKO::rLR0qPl3rQjEaPBn6R9pGNEdaP",0), //1683
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NBn5RVFKMklpM49KNjoKO::rLR0qPl3rQjEaPEn6RtpmMEdaP",0), //1684
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NBn5RVFKMclpMnnaQP1LNjoKOLOrLT36QSIqPPpKNhILOS0a;cBGO",0), //1685
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NGn5RrrKRN5bNApKNCd7PVpKM",0), //1686
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NGn5RrrKRSIqPPpKNhILOS0a;cBGO",0), //1687
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NHn5RC;6R6l5NpfaQQQaPdqGSEdaP",0), //1688
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NHn5RC;6R7l5NrnaQKcrNVpKM",0), //1689
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NHn5RC;6R8l5NdQLOS0a;cBGO",0), //1690
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NHn5RC;6R8l5NeQLOS0a;cBGO",0), //1691
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NHn5RC;6RDl5NJJaNN0bPSOaRVpKM",0), //1692
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NLn5RXxKM:GqLaMKONx6NS0a;cBGO",0), //1693
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NLn5RXxKMSqqLSNaNifqQ9pGNEdaP",0), //1694
	new Array(1,"NdqNjQbPDn6R2k5Pi86OHl5NLn5RgoKO4cKP1o2PEdaP",0), //1695
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NT33AyPbQ:GqLaMKONx6NS0a;cBGO",0), //1696
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NT33AyPbQSqqLSNaNifqQ9pGNEdaP",0), //1697
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NT33AgfqQ:;nLS0a;cBGO",0), //1698
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NT33AtTrQjQaPN5bNApKNCd7PVpKM",0), //1699
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1700
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NT33AI;qRykpOpfaQQQaPdqGSEdaP",0), //1701
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NT33AI;qRrkpOJJaNN0bPSOaRVpKM",0), //1702
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NTD3AyPbQ:GqLaMKONx6NS0a;cBGO",0), //1703
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NTD3AtTrQjQaPN5bNApKNCd7PVpKM",0), //1704
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NTD3AI;qRykpOpfaQQQaPdqGSEdaP",0), //1705
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NT;3AgfqQE6qLudKM9;nLN2rLh0LOi86O1p2NEdaP",0), //1706
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NT;3AgfqQN2rLh0LOi86O1p2NEdaP",0), //1707
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NT;3AtTrQjQaPt;aQkPqQgpKMS0a;cBGO",0), //1708
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NTL3AyPbQ:GqLaMKONx6NS0a;cBGO",0), //1709
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NTL3AtTrQjQaPN5bNApKNCd7PVpKM",0), //1710
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NTL3AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1711
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NTL3A13LRjEaPD47P1p2NEdaP",0), //1712
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NTL3AI;qRykpOpfaQQQaPdqGSEdaP",0), //1713
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NTH3AyPbQ:GqLaMKONx6NS0a;cBGO",0), //1714
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NTH3AtTrQjQaPN5bNApKNCd7PVpKM",0), //1715
	new Array(1,"NdqNjQbPDn6R2k5Pi86OOl5NTH3AI;qRykpOpfaQQQaPdqGSEdaP",0), //1716
	new Array(1,"NdqNjQbPDn6R3k5PQTLRjoKON5rNiO6QVpKM",0), //1717
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLdvJA1T7RcUqMdzGAEdaP",0), //1718
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLdvJA1T7RcUqMlzWAEdaP",0), //1719
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLdvJA1T7RcUqMtzmAEdaP",0), //1720
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLfvJAOsqPLRLMhlqMJQbPlrWQEdaP",0), //1721
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLfvJAOsqPLRLMtvqQqiqQVpKM",0), //1722
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLfvJAOsqPLRLMKfqR9t6Nzw6PtTrQNQaPSFaPVpKM",0), //1723
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLgvJAb;aQS0a;cBGO",0), //1724
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLZvJAVFKMvlpMw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //1725
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLZvJAVFKMvlpMw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //1726
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLZvJAVFKMklpM49KNjoKO::rLR0qPl3rQjEaPBn6R9pGNEdaP",0), //1727
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLZvJAVFKMklpM49KNjoKO::rLR0qPl3rQjEaPEn6RtpmMEdaP",0), //1728
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLZvJAVFKMclpMnnaQP1LNjoKOLOrLT36QSIqPPpKNhILOS0a;cBGO",0), //1729
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLavJAxRLMw;aQB2rLFoWPEdaP",0), //1730
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLavJAxRLMw;aQNKrLCV6PVpKM",0), //1731
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLbvJAJJaNN0bPjPaRyPbQS0a;cBGO",0), //1732
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLbvJAJJaNN0bPjPaRI;qRtomOEdaP",0), //1733
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLvvJAC;6RDl5NJJaNN0bPSOaRVpKM",0), //1734
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLwvJAaNLM1r2REdaP",0), //1735
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLlvZA1T7RcUqMdzGAEdaP",0), //1736
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLlvZA1T7RcUqMlzWAEdaP",0), //1737
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLlvZA1T7RcUqMtzmAEdaP",0), //1738
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLnvZAOsqPLRLMhlqMJQbPlrWQEdaP",0), //1739
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLnvZAOsqPLRLMtvqQqiqQVpKM",0), //1740
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLovZAb;aQS0a;cBGO",0), //1741
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLXvZAC;6RDl5NJJaNN0bPSOaRVpKM",0), //1742
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLYvZAaNLM1r2REdaP",0), //1743
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLpvpAVFKMvlpMw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //1744
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLpvpAVFKMvlpMw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //1745
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLpvpAVFKMylpMh4LOw9aM3k5Pw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //1746
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLpvpAVFKMylpMh4LOw9aM3k5Pw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //1747
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLpvpAVFKMylpMh4LOw9aMEk5PnnaQP1LNjoKOLOrLT36QSIqPPpKNaJLOVpKM",0), //1748
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLpvpAVFKMklpM49KNjoKO::rLR0qPl3rQjEaPBn6R9pGNEdaP",0), //1749
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLpvpAVFKMklpM49KNjoKO::rLR0qPl3rQjEaPEn6RtpmMEdaP",0), //1750
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLpvpAVFKMllpMfNqMVP6QnnZQw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //1751
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLpvpAVFKMllpMfNqMVP6QnnZQw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //1752
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLpvpAVFKMllpMfNqMVP6QUnZQnnaQP1LNjoKOLOrLT36QSIqPPpKNhILOS0a;cBGO",0), //1753
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLpvpAVFKMclpMnnaQP1LNjoKOLOrLT36QSIqPPpKNhILOS0a;cBGO",0), //1754
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLpvpAVFKMglpMiM7OGN6NN6qLlTrQjEaPN5bNApKNCd7PVpKM",0), //1755
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLpvpAVFKMglpMiM7OGN6NN6qLlTrQjEaPSIqPPpKNhILOS0a;cBGO",0), //1756
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqLpvpAVFKMglpMiM7OGN6N::rLR0qPl3rQjEaPEn6RrlpMJJaNN0bPSOaRVpKM",0), //1757
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqL5vJBVFKMvlpMw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //1758
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqL5vJBVFKMvlpMw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //1759
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqL5vJBVFKMklpM49KNjoKO::rLR0qPl3rQjEaPBn6R9pGNEdaP",0), //1760
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqL5vJBVFKMklpM49KNjoKO::rLR0qPl3rQjEaPEn6RtpmMEdaP",0), //1761
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8DqL5vJBVFKMclpMnnaQP1LNjoKOLOrLT36QSIqPPpKNhILOS0a;cBGO",0), //1762
	new Array(1,"NdqNjQbPDn6R8k5PgpKM83qLdvJA1T7RcUqMdzGAEdaP",0), //1763
	new Array(1,"NdqNjQbPDn6R8k5PgpKM83qLdvJA1T7RcUqMlzWAEdaP",0), //1764
	new Array(1,"NdqNjQbPDn6R8k5PgpKM83qLdvJA1T7RcUqMtzmAEdaP",0), //1765
	new Array(1,"NdqNjQbPDn6R8k5PgpKM83qLfvJAOsqPLRLMhlqMJQbPlrWQEdaP",0), //1766
	new Array(1,"NdqNjQbPDn6R8k5PgpKM83qLfvJAOsqPLRLMtvqQqiqQVpKM",0), //1767
	new Array(1,"NdqNjQbPDn6R8k5PgpKM83qLfvJAOsqPLRLMKfqR9t6Nzw6PtTrQNQaPSFaPVpKM",0), //1768
	new Array(1,"NdqNjQbPDn6R8k5PgpKM83qLgvJAb;aQS0a;cBGO",0), //1769
	new Array(1,"NdqNjQbPDn6R8k5PgpKM83qLvvJAC;6RDl5NJJaNN0bPSOaRVpKM",0), //1770
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87qLdvJA1T7RcUqMdzGAEdaP",0), //1771
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87qLdvJA1T7RcUqMlzWAEdaP",0), //1772
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87qLdvJA1T7RcUqMtzmAEdaP",0), //1773
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87qLfvJAOsqPLRLMhlqMJQbPlrWQEdaP",0), //1774
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87qLfvJAOsqPLRLMtvqQqiqQVpKM",0), //1775
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87qLgvJAb;aQS0a;cBGO",0), //1776
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87qLvvJAC;6RDl5NJJaNN0bPSOaRVpKM",0), //1777
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87qLlvZA1T7RcUqMdzGAEdaP",0), //1778
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87qLlvZA1T7RcUqMlzWAEdaP",0), //1779
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87qLlvZA1T7RcUqMtzmAEdaP",0), //1780
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87qLnvZAOsqPLRLMhlqMJQbPlrWQEdaP",0), //1781
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87qLnvZAOsqPLRLMtvqQqiqQVpKM",0), //1782
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87qLovZAb;aQS0a;cBGO",0), //1783
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87qLXvZAC;6RDl5NJJaNN0bPSOaRVpKM",0), //1784
	new Array(1,"NdqNjQbPDn6R8k5PgpKM:7qLdvJA1T7RcUqMdzGAEdaP",0), //1785
	new Array(1,"NdqNjQbPDn6R8k5PgpKM:7qLdvJA1T7RcUqMlzWAEdaP",0), //1786
	new Array(1,"NdqNjQbPDn6R8k5PgpKM:7qLdvJA1T7RcUqMtzmAEdaP",0), //1787
	new Array(1,"NdqNjQbPDn6R8k5PgpKM:7qLfvJAOsqPLRLMhlqMJQbPlrWQEdaP",0), //1788
	new Array(1,"NdqNjQbPDn6R8k5PgpKM:7qLfvJAOsqPLRLMtvqQqiqQVpKM",0), //1789
	new Array(1,"NdqNjQbPDn6R8k5PgpKM:7qLvvJAC;6RDl5NJJaNN0bPSOaRVpKM",0), //1790
	new Array(1,"NdqNjQbPDn6R8k5PgpKM:7qLlvZA1T7RcUqMdzGAEdaP",0), //1791
	new Array(1,"NdqNjQbPDn6R8k5PgpKM:7qLlvZA1T7RcUqMlzWAEdaP",0), //1792
	new Array(1,"NdqNjQbPDn6R8k5PgpKM:7qLlvZA1T7RcUqMtzmAEdaP",0), //1793
	new Array(1,"NdqNjQbPDn6R8k5PgpKM:7qLnvZAOsqPLRLMhlqMJQbPlrWQEdaP",0), //1794
	new Array(1,"NdqNjQbPDn6R8k5PgpKM:7qLnvZAOsqPLRLMtvqQqiqQVpKM",0), //1795
	new Array(1,"NdqNjQbPDn6R8k5PgpKM:7qLXvZAC;6RDl5NJJaNN0bPSOaRVpKM",0), //1796
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PqLdvJA1T7RcUqMdzGAEdaP",0), //1797
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PqLdvJA1T7RcUqMlzWAEdaP",0), //1798
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PqLdvJA1T7RcUqMtzmAEdaP",0), //1799
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PqLfvJAOsqPLRLMhlqMJQbPlrWQEdaP",0), //1800
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PqLfvJAOsqPLRLMtvqQqiqQVpKM",0), //1801
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PqLfvJAOsqPLRLMKfqR9t6Nzw6PtTrQNQaPSFaPVpKM",0), //1802
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PqLgvJAb;aQS0a;cBGO",0), //1803
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PqLavJAxRLMw;aQB2rLFoWPEdaP",0), //1804
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PqLavJAxRLMw;aQNKrLCV6PVpKM",0), //1805
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PqLbvJAJJaNN0bPjPaRyPbQS0a;cBGO",0), //1806
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PqLbvJAJJaNN0bPjPaRI;qRtomOEdaP",0), //1807
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PqLvvJAC;6RDl5NJJaNN0bPSOaRVpKM",0), //1808
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PqLwvJAaNLM1r2REdaP",0), //1809
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLdvJA1T7RcUqMdzGAEdaP",0), //1810
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLdvJA1T7RcUqMlzWAEdaP",0), //1811
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLdvJA1T7RcUqMtzmAEdaP",0), //1812
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLfvJAOsqPLRLMhlqMJQbPlrWQEdaP",0), //1813
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLfvJAOsqPLRLMtvqQqiqQVpKM",0), //1814
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLfvJAOsqPLRLMKfqR9t6Nzw6PtTrQNQaPSFaPVpKM",0), //1815
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLgvJAb;aQS0a;cBGO",0), //1816
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLZvJAVFKMvlpMw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //1817
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLZvJAVFKMvlpMw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //1818
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLZvJAVFKMklpM49KNjoKO::rLR0qPl3rQjEaPBn6R9pGNEdaP",0), //1819
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLZvJAVFKMklpM49KNjoKO::rLR0qPl3rQjEaPEn6RtpmMEdaP",0), //1820
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLavJAxRLMw;aQB2rLFoWPEdaP",0), //1821
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLavJAxRLMw;aQA6rLgpKM9;nLS0a;cBGO",0), //1822
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLavJAxRLMw;aQNKrLCV6PVpKM",0), //1823
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLbvJAJJaNN0bPjPaRyPbQS0a;cBGO",0), //1824
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLbvJAJJaNN0bPjPaRI;qRtomOEdaP",0), //1825
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8TqLvvJAC;6RDl5NJJaNN0bPSOaRVpKM",0), //1826
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8HqLdvJA1T7RcUqMdzGAEdaP",0), //1827
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8HqLdvJA1T7RcUqMlzWAEdaP",0), //1828
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8HqLdvJA1T7RcUqMtzmAEdaP",0), //1829
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8HqLfvJAOsqPLRLMhlqMJQbPlrWQEdaP",0), //1830
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8HqLfvJAOsqPLRLMtvqQqiqQVpKM",0), //1831
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8HqLfvJAOsqPLRLMKfqR9t6Nzw6PtTrQNQaPSFaPVpKM",0), //1832
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8HqLgvJAb;aQS0a;cBGO",0), //1833
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8HqLvvJAC;6RDl5NJJaNN0bPSOaRVpKM",0), //1834
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8HqLlvZA1T7RcUqMdzGAEdaP",0), //1835
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8HqLlvZA1T7RcUqMlzWAEdaP",0), //1836
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8HqLlvZA1T7RcUqMtzmAEdaP",0), //1837
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8HqLnvZAOsqPLRLMhlqMJQbPlrWQEdaP",0), //1838
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8HqLnvZAOsqPLRLMtvqQqiqQVpKM",0), //1839
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8HqLnvZAOsqPLRLMKfqR9t6Nzw6PtTrQNQaPSFaPVpKM",0), //1840
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8HqLXvZAC;6RDl5NJJaNN0bPSOaRVpKM",0), //1841
	new Array(1,"NdqNjQbPDn6R8k5PgpKMLKqLzQ6P6cKPjoKOS0a;cBGO",0), //1842
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLdvJA1T7RcUqMdzGAEdaP",0), //1843
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLdvJA1T7RcUqMlzWAEdaP",0), //1844
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLdvJA1T7RcUqMtzmAEdaP",0), //1845
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLfvJAOsqPLRLMhlqMJQbPlrWQEdaP",0), //1846
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLfvJAOsqPLRLMtvqQqiqQVpKM",0), //1847
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLfvJAOsqPLRLMKfqR9t6Nzw6PtTrQNQaPSFaPVpKM",0), //1848
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLgvJAb;aQS0a;cBGO",0), //1849
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLZvJAVFKMvlpMw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //1850
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLZvJAVFKMvlpMw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //1851
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLZvJAVFKMklpM49KNjoKO::rLR0qPl3rQjEaPBn6R9pGNEdaP",0), //1852
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLZvJAVFKMklpM49KNjoKO::rLR0qPl3rQjEaPEn6RtpmMEdaP",0), //1853
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLZvJAVFKMclpMnnaQP1LNjoKOLOrLT36QSIqPPpKNhILOS0a;cBGO",0), //1854
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLavJAxRLMw;aQB2rLFoWPEdaP",0), //1855
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLavJAxRLMw;aQB2rL0lZPdzGAEdaP",0), //1856
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLavJAxRLMw;aQA6rLgpKM9;nLS0a;cBGO",0), //1857
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLavJAxRLMw;aQNKrLCV6PVpKM",0), //1858
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLavJAxRLMw;aQNKrLzU6Pi23AVpKM",0), //1859
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLbvJAJJaNN0bPjPaRyPbQS0a;cBGO",0), //1860
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLbvJAJJaNN0bPjPaRI;qRtomOEdaP",0), //1861
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLvvJAC;6RDl5NJJaNN0bPSOaRVpKM",0), //1862
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8fqLwvJAaNLM1r2REdaP",0), //1863
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8nqLdvJA1T7RcUqMdzGAEdaP",0), //1864
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8nqLdvJA1T7RcUqMlzWAEdaP",0), //1865
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8nqLdvJA1T7RcUqMtzmAEdaP",0), //1866
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8nqLfvJAOsqPLRLMhlqMJQbPlrWQEdaP",0), //1867
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8nqLfvJAOsqPLRLMtvqQqiqQVpKM",0), //1868
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8nqLbvJAJJaNN0bPSOaRVpKM",0), //1869
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8nqLuvJA6qKRVpKM",0), //1870
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8nqLvvJAC;6REk5NdzGAEdaP",0), //1871
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8nqLzvJAXxKMS0a;cBGO",0), //1872
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87rLdvJA1T7RcUqMdzGAEdaP",0), //1873
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87rLZvJAVFKMvlpMw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //1874
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87rLZvJAVFKMvlpMw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //1875
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87rLZvJAVFKMklpM49KNjoKO::rLR0qPl3rQjEaPBn6R9pGNEdaP",0), //1876
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87rLZvJAVFKMklpM49KNjoKO::rLR0qPl3rQjEaPEn6RtpmMEdaP",0), //1877
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87rLZvJAVFKMclpMnnaQP1LNjoKOLOrLT36QSIqPPpKNhILOS0a;cBGO",0), //1878
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87rLavJAxRLMw;aQB2rLFoWPEdaP",0), //1879
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87rLavJAxRLMw;aQA6rLgpKM9;nLS0a;cBGO",0), //1880
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87rLavJAxRLMw;aQNKrLCV6PVpKM",0), //1881
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87rLbvJAJJaNN0bPjPaRyPbQS0a;cBGO",0), //1882
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87rLbvJAJJaNN0bPjPaRI;qRtomOEdaP",0), //1883
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87rLvvJAjk6OCf6R:lpNjpKMMkJNdzGAEdaP",0), //1884
	new Array(1,"NdqNjQbPDn6R8k5PgpKM87rLvvJAC;6RDl5NJJaNN0bPSOaRVpKM",0), //1885
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLdvJA1T7RcUqMdzGAEdaP",0), //1886
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLdvJA1T7RcUqMtzmAEdaP",0), //1887
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLfvJAOsqPLRLMhlqMJQbPlrWQEdaP",0), //1888
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLfvJAOsqPLRLMtvqQqiqQVpKM",0), //1889
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLfvJAOsqPLRLMKfqR9t6Nzw6PtTrQNQaPSFaPVpKM",0), //1890
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLgvJAb;aQS0a;cBGO",0), //1891
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLZvJAVFKMvlpMw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //1892
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLZvJAVFKMvlpMw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //1893
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLZvJAVFKMklpM49KNjoKO::rLR0qPl3rQjEaPBn6R9pGNEdaP",0), //1894
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLZvJAVFKMklpM49KNjoKO::rLR0qPl3rQjEaPEn6RtpmMEdaP",0), //1895
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLZvJAVFKMclpMnnaQP1LNjoKOLOrLT36QSIqPPpKNhILOS0a;cBGO",0), //1896
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLavJAxRLMw;aQB2rLFoWPEdaP",0), //1897
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLavJAxRLMw;aQB2rL0lZPdzGAEdaP",0), //1898
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLavJAxRLMw;aQA6rLgpKM9;nLS0a;cBGO",0), //1899
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLavJAxRLMw;aQNKrLCV6PVpKM",0), //1900
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLavJAxRLMw;aQNKrLzU6Pi23AVpKM",0), //1901
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLbvJAJJaNN0bPjPaRyPbQS0a;cBGO",0), //1902
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLbvJAJJaNifqQTlJNXxKMS0a;cBGO",0), //1903
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLvvJAC;6RDl5NJJaNN0bPSOaRVpKM",0), //1904
	new Array(1,"NdqNjQbPDn6R8k5PgpKM8PrLwvJAaNLM1r2REdaP",0), //1905
	new Array(1,"NdqNjQbPDn6RAk5PfpKM9lJNt3rQQzKRI6rLU1LMN6qLlTrQSFaPVpKM",0), //1906
	new Array(1,"NdqNjQbPDn6RAk5PfpKM9lJNt3rQQzKRI6rLU1LM::rLR0qPl3rQSFaPVpKM",0), //1907
	new Array(1,"NdqNjQbPDn6RAk5PfpKM9lJN1T7RcUqMdzGAEdaP",0), //1908
	new Array(1,"NdqNjQbPDn6RAk5PfpKM9lJN1T7RcUqMlzWAEdaP",0), //1909
	new Array(1,"NdqNjQbPDn6RAk5PfpKM9lJN1T7RcUqMtzmAEdaP",0), //1910
	new Array(1,"NdqNjQbPDn6RAk5PfpKM:lJNTD3AtTrQJ0aPACqL3;6RtomOEdaP",0), //1911
	new Array(1,"NdqNjQbPDn6RAk5PfpKM:lJNTD3AtTrQJ0aPFGqL3caPVo2OEdaP",0), //1912
	new Array(1,"NdqNjQbPDn6RAk5PfpKM:lJNTD3AtTrQJ0aP::rL9BLNyOaQVpKM",0), //1913
	new Array(1,"NdqNjQbPDn6RAk5PfpKM:lJNLk6PdFLMdqGSEdaP",0), //1914
	new Array(1,"NdqNjQbPDn6RAk5PfpKM:lJNLk6PdFLMemJS1QqPS0a;cBGO",0), //1915
	new Array(1,"NdqNjQbPDn6RAk5PfpKM:lJNLk6PdFLMhmJS5QaPyOaQVpKM",0), //1916
	new Array(1,"NdqNjQbPDn6RAk5PfpKM:lJNLk6PdFLMjmJSZnaQSRaPVpKM",0), //1917
	new Array(1,"NdqNjQbPDn6RAk5PfpKM:lJNLk6PdFLMwmJS67LRS0a;cBGO",0), //1918
	new Array(1,"NdqNjQbPDn6RAk5PfpKM;lJNOsqPLRLMtvqQqiqQVpKM",0), //1919
	new Array(1,"NdqNjQbPDn6RAk5PfpKM;lJNOsqPLRLMtvqQ7jqQWAXMS0a;cBGO",0), //1920
	new Array(1,"NdqNjQbPDn6RAk5PfpKM;lJNOsqPLRLMKfqR9t6Nzw6PtTrQNQaPSFaPVpKM",0), //1921
	new Array(1,"NdqNjQbPDn6RAk5PfpKM;lJNOsqPLRLMKfqR9t6Nzw6PtTrQNQaPjEaPWAXMS0a;cBGO",0), //1922
	new Array(1,"NdqNjQbPDn6RAk5PfpKMAlJNU1LMACqL3;6RdBnOS0a;cBGO",0), //1923
	new Array(1,"NdqNjQbPDn6RAk5PfpKMAlJNU1LMACqL3;6RdBnO83qLlzWAEdaP",0), //1924
	new Array(1,"NdqNjQbPDn6RAk5PfpKMAlJNU1LMACqL3;6ReBnOS0a;cBGO",0), //1925
	new Array(1,"NdqNjQbPDn6RAk5PfpKMAlJNU1LMB2rLFoWPEdaP",0), //1926
	new Array(1,"NdqNjQbPDn6RAk5PfpKMAlJNU1LMB2rLGkZPiC3AVpKM",0), //1927
	new Array(1,"NdqNjQbPDn6RAk5PfpKMAlJNKErPlpWMEdaP",0), //1928
	new Array(1,"NdqNjQbPDn6RAk5PfpKMAlJNb;aQN2qLqUqMVpKM",0), //1929
	new Array(1,"NdqNjQbPDn6RAk5PfpKMClJNpfaQQQaPumJS6qKRVpKM",0), //1930
	new Array(1,"NdqNjQbPDn6RAk5PfpKMClJNpfaQQQaPzmJSXxKMS0a;cBGO",0), //1931
	new Array(1,"NdqNjQbPDn6RAk5PfpKMDlJNrnaQKcrNVpKM",0), //1932
	new Array(1,"NdqNjQbPDn6RAk5PfpKM0lJNdQLOS0a;cBGO",0), //1933
	new Array(1,"NdqNjQbPDn6RAk5PfpKM0lJNeQLOS0a;cBGO",0), //1934
	new Array(1,"NdqNjQbPDn6RAk5PfpKM5lJNVFKMvlpMw1LMjoKO:GqLaMKONx6NS0a;cBGO",0), //1935
	new Array(1,"NdqNjQbPDn6RAk5PfpKM5lJNVFKMvlpMw1LMjoKOSqqLSNaNifqQ9pGNEdaP",0), //1936
	new Array(1,"NdqNjQbPDn6RAk5PfpKM5lJNVFKMklpM49KNjoKO::rLR0qPl3rQjEaPBn6R9pGNEdaP",0), //1937
	new Array(1,"NdqNjQbPDn6RAk5PfpKM5lJNVFKMklpM49KNjoKO::rLR0qPl3rQjEaPEn6RtpmMEdaP",0), //1938
	new Array(1,"NdqNjQbPDn6RAk5PfpKM5lJNVFKMclpMnnaQP1LNjoKOLOrLT36QSIqPPpKNhILOi23AVpKM",0), //1939
	new Array(1,"NdqNjQbPDn6RAk5PfpKM7lJNJJaNN0bPjPaRyPbQS0a;cBGO",0), //1940
	new Array(1,"NdqNjQbPDn6RAk5PfpKM7lJNJJaNN0bPjPaRyPbQ83qLlzWAEdaP",0), //1941
	new Array(1,"NdqNjQbPDn6RAk5PfpKM7lJNJJaNN0bPjPaRI;qRtomOEdaP",0), //1942
	new Array(1,"NdqNjQbPDn6RAk5PfpKM7lJNJJaNN0bPjPaRI;qRukpOiC3AVpKM",0), //1943
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNocqOLk5PgoKOp5bMhVKMUnZQUPaQh5LMS0a;cBGO",0), //1944
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNocqOLk5PgoKOp5bMhVKMbnZQwdKMS0a;cBGO",0), //1945
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNC;6R7NqMwRLMX1KMS0a;cBGO",0), //1946
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNC;6R7NqMwRLMX1KMi23AVpKM",0), //1947
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNC;6R7NqMwRLMX1KMiC3AVpKM",0), //1948
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNC;6R7NqMSdaNU0LOS0a;cBGO",0), //1949
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNC;6R7NqMSdaNU0LOi23AVpKM",0), //1950
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNC;6R7NqMSdaNU0LOiC3AVpKM",0), //1951
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNC;6R7NqMSIqPPpKNhILOi23AVpKM",0), //1952
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNC;6R7NqMSIqPPpKNhILOiC3AVpKM",0), //1953
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNC;6R7NqMZ77Qm;6Q9pGNEdaP",0), //1954
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNC;6R7NqMZ77Qm;6QNAHNS0a;cBGO",0), //1955
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNC;6R7NqMZ77Qm;6QOAHNS0a;cBGO",0), //1956
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNC;6R6l5NpfaQQQaPdqGSEdaP",0), //1957
	new Array(1,"NdqNjQbPDn6RAk5PfpKMPlJNC;6RDl5NJJaNN0bPSOaRVpKM",0), //1958
	new Array(1,"NdqNjQbPDn6RAk5PfpKMQlJNaNLM1r2REdaP",0), //1959
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AwRLMX1KM9;nLS0a;cBGO",0), //1960
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AwRLMX1KM:;nLS0a;cBGO",0), //1961
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AwRLMX1KM;;nLS0a;cBGO",0), //1962
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AplqMY9aML6qLQrKR64LNVpKM",0), //1963
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AplqMY9aMJ6rLU1LMS0a;cBGO",0), //1964
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AH96NVk5O1T7RqUqMVpKM",0), //1965
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AH96Nmk5O6qKRVpKM",0), //1966
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33ANNrNySaQVpKM",0), //1967
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33Aoc6OKDqLVpKM",0), //1968
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33Aoc6OK3qLVpKM",0), //1969
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //1970
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //1971
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //1972
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //1973
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AD8KPL0KOXn6QP1LNjoKOLOrLT36QSIqPPpKNhILOS0a;cBGO",0), //1974
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AyPbQ:GqLaMKONx6NS0a;cBGO",0), //1975
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AyPbQSqqLSNaNifqQ9pGNEdaP",0), //1976
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AtTrQjQaPN5bNApKNCd7PVpKM",0), //1977
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1978
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AJ;6RSRbPVpKM",0), //1979
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AI;qRykpOpfaQQQaPdqGSEdaP",0), //1980
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AI;qRrkpOJJaNN0bPSOaRVpKM",0), //1981
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AKfqRG56N39KNr5LNZ77Qm;6Q9pGNEdaP",0), //1982
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NT33AKfqRG56N39KNr5LNF;qR1r2REdaP",0), //1983
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3AwRLMX1KM9;nLS0a;cBGO",0), //1984
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3AwRLMX1KM:;nLS0a;cBGO",0), //1985
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3AwRLMX1KM;;nLS0a;cBGO",0), //1986
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3AplqMY9aML6qLQrKR64LNVpKM",0), //1987
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3AplqMY9aMJ6rLU1LMS0a;cBGO",0), //1988
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3AH96NVk5O1T7RqUqMVpKM",0), //1989
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3AH96Nmk5O6qKRVpKM",0), //1990
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3ANNrNySaQVpKM",0), //1991
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3Aoc6OKDqLVpKM",0), //1992
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3Aoc6OK3qLVpKM",0), //1993
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3AyPbQ:GqLaMKONx6NS0a;cBGO",0), //1994
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3AyPbQSqqLSNaNifqQ9pGNEdaP",0), //1995
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3AtTrQjQaPN5bNApKNCd7PVpKM",0), //1996
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //1997
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3AJ;6RSRbPVpKM",0), //1998
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3AI;qRykpOpfaQQQaPdqGSEdaP",0), //1999
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3AI;qRrkpOJJaNN0bPSOaRVpKM",0), //2000
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3AKfqRG56N39KNr5LNZ77Qm;6Q9pGNEdaP",0), //2001
	new Array(1,"NdqNjQbPDn6RAk5Pi86O2l5NTD3AKfqRG56N39KNr5LNF;qR1r2REdaP",0), //2002
	new Array(1,"NdqNjQbPDn6RAk5Pi86O4l5Nb;aQN2qLqUqMVpKM",0), //2003
	new Array(1,"NdqNjQbPDn6RGk5P29aNCkJPtAHMICqLxhqMrcLPl5rM3f6RLxKMMhLNHk6PakKOS0a;cBGO",0), //2004
	new Array(1,"NdqNjQbPDn6RGk5P29aNCkJPtAHMICqLxhqMrcLP157NNrmREdaP",0), //2005
	new Array(1,"NdqNjQbPDn6RGk5P29aNCkJPtAHMICqLxhqMrcLPMhLNHk6PakKOS0a;cBGO",0), //2006
	new Array(1,"NdqNjQbPDn6RGk5P29aNCkJPtAHMICqLxhqMrcLPlXqQzw6Pf9qMCf6RNpmNEdaP",0), //2007
	new Array(1,"NdqNjQbPDn6RGk5P29aNCkJPtAHMICqLxhqMrcLPlXqQzw6Pj77QfNqMqfqQNpmNEdaP",0), //2008
	new Array(1,"NdqNjQbPDn6RGk5P29aNCkJPtAHMICqLxhqMrcLPlXqQzw6Pj77QfNqMqfqQ:AnNS0a;cBGO",0), //2009
	new Array(1,"NdqNjQbPDn6RGk5P29aNCkJPtAHMICqLxhqMrcLPlXqQzw6Pj77QfNqMqfqQ;AnNS0a;cBGO",0), //2010
	new Array(1,"NdqNjQbPDn6RGk5P29aNCkJPtAHMICqLxhqMrcLPlXqQzw6Pj77QfNqMqfqQAAnNS0a;cBGO",0), //2011
	new Array(1,"NdqNjQbPDn6RGk5P29aNCkJPtAHM83qLlvZA806PFtKNH6rLYwKON6qLlTrQSFaPVpKM",0), //2012
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33Av1LMYNLMHn5RH86PXk5Ow1LMjoKOS0a;cBGO",0), //2013
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33Av1LMYNLMHn5RH86Pkk5OnnaQP1LNjoKOS0a;cBGO",0), //2014
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AwRLMX1KM9;nLS0a;cBGO",0), //2015
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AwRLMX1KM:;nLS0a;cBGO",0), //2016
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AwRLMX1KM;;nLS0a;cBGO",0), //2017
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AwRLMX1KM;;nL86rLYfaQ9pGNEdaP",0), //2018
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AwRLMX1KMJ6rLU1LM9;nLS0a;cBGO",0), //2019
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AzxaMD;qRLdLMApKNB7LRS0a;cBGO",0), //2020
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AgNrMCf6R:RrN6MKNVpKM",0), //2021
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33Am86O3PaRCf6RTlpNt;aQFoWPEdaP",0), //2022
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33Am86O3PaRCf6R8lpNNQrPCm6RVpKM",0), //2023
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //2024
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //2025
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //2026
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //2027
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //2028
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AyPbQ:GqLaMKONx6NS0a;cBGO",0), //2029
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AyPbQSqqLSNaNifqQ9pGNEdaP",0), //2030
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AtTrQjQaPN5bNApKNCd7PVpKM",0), //2031
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //2032
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AI;qRykpOpfaQQQaPdqGSEdaP",0), //2033
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33AI;qRrkpOJJaNN0bPSOaRVpKM",0), //2034
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33ALnqR807PVJLMSFaPVpKM",0), //2035
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT33ALnqR807PVJLMjEaPdM6OAhqNS0a;cBGO",0), //2036
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3AwRLMX1KM9;nLS0a;cBGO",0), //2037
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3AwRLMX1KM:;nLS0a;cBGO",0), //2038
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3AwRLMX1KM;;nLS0a;cBGO",0), //2039
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3AwRLMX1KMJ6rLU1LM9;nLS0a;cBGO",0), //2040
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3Ah86OOMKPjoKOS0a;cBGO",0), //2041
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //2042
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //2043
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //2044
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //2045
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //2046
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3A6cKPjoKOS0a;cBGO",0), //2047
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3AyPbQ:GqLaMKONx6NS0a;cBGO",0), //2048
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3AyPbQSqqLSNaNifqQ9pGNEdaP",0), //2049
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3AtTrQjQaPN5bNApKNCd7PVpKM",0), //2050
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //2051
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3AI;qRykpOpfaQQQaPdqGSEdaP",0), //2052
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTD3AI;qRrkpOJJaNN0bPSOaRVpKM",0), //2053
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT;3AwRLMX1KM9;nLS0a;cBGO",0), //2054
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT;3AwRLMX1KM:;nLS0a;cBGO",0), //2055
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT;3AwlaM3n5ROsqPhoKO:GqLaMKONx6NKqqL0lJNgpKMN6qLlTrQSFaPVpKM",0), //2056
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT;3AwlaM3n5ROsqPhoKOSqqLSNaNifqQ7lJNjMaPi86O3l5Nw1LMjoKOS0a;cBGO",0), //2057
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT;3AwlaM3n5ROsqPhoKODOrLEkpPgpKMN6qLlTrQSFaPVpKM",0), //2058
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT;3AwlaM3n5ROsqPhoKODOrLEkpPgpKM::rLR0qPl3rQSFaPVpKM",0), //2059
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT;3AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //2060
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT;3AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //2061
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT;3AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //2062
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT;3AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //2063
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT;3AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //2064
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT;3AtzqQ7jqQf9qMCf6RNpmNEdaP",0), //2065
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT;3AtzqQ7jqQj77QfNqMqfqQNpmNEdaP",0), //2066
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT;3AtTrQjQaPN5bNApKNCd7PVpKM",0), //2067
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NT;3AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //2068
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTH3AwRLMX1KM9;nLS0a;cBGO",0), //2069
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTH3AwRLMX1KM:;nLS0a;cBGO",0), //2070
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTH3AwRLMX1KM;;nLS0a;cBGO",0), //2071
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTH3AwRLMX1KML6qLQrKRr5LNi23AVpKM",0), //2072
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTH3AwRLMX1KMJ6rLU1LM9;nLS0a;cBGO",0), //2073
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTH3A157NNrmREdaP",0), //2074
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTH3AD8KPL0KOf9qMCf6RSlpNpfaQQQaPdqGSEdaP",0), //2075
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTH3AD8KPL0KOf9qMCf6RLlpNJJaNN0bPSOaRVpKM",0), //2076
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTH3AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrL6NKPVpKM",0), //2077
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTH3AD8KPL0KOVM6OCc6P8lpNnnaQP1LNjoKOLOrLi26QVpKM",0), //2078
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTH3AD8KPL0KOj77QfNqMqfqQAlpNPArPSqqLSNaNifqQ9pGNEdaP",0), //2079
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTH3AtTrQjQaPN5bNApKNCd7PVpKM",0), //2080
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTH3AtTrQjQaPSIqPPpKNhILOS0a;cBGO",0), //2081
	new Array(1,"NdqNjQbPDn6RGk5Pi86O1l5NTH3AKfqR9t6Nzw6PtTrQNQaPSFaPVpKM",0), //2082
	new Array(1,"NdqNjQbPDn6RGk5Pi86O3l5NLWHCv1LMYNLMHn5RH86Pkk5OnnaQP1LNjoKOS0a;cBGO",0), //2083
	new Array(1,"NdqNjQbPDn6RGk5Pi86O4l5Nb;aQN2qLeVqMS0a;cBGO",0), //2084
	new Array(1,"NdqNjQbPDn6RGk5Pi86O4l5Nb;aQL2qLAd7NS0a;cBGO",0), //2085
	new Array(1,"NdqNjQbPDn6RHk5P6;6RGlZNOc6PW:aSI17NvfaQ;lJNw1LMjoKOS0a;cBGO",0), //2086
	new Array(1,"NdqNjQbPDn6RHk5P6;6RGlZNOc6PW:aSI17NvfaQ;lJNm86OKdqNNpmNEdaP",0), //2087
	new Array(1,"NdqNjQbPDn6RHk5P6;6RGlZNOc6PW:aSI17NvfaQMlJNnnaQP1LNjoKOi23AVpKM",0), //2088
	new Array(1,"NdqNjQbPDn6RHk5P6;6RGlZNOc6PW:aSI17NvfaQMlJNnnaQP1LNjoKOiC3AVpKM",0), //2089
	new Array(1,"NdqNjQbPDn6RHk5P6;6RHlZNKMrPGP6RS0a;cBGO",0), //2090
	new Array(1,"NdqNjQbPDn6RHk5P6;6R3lZNP8KPVo2OEdaP",0), //2091
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnMACqL3;6RclpOdzGAEdaP",0), //2092
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnMACqL3;6RclpOlzWAEdaP",0), //2093
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnMACqL3;6RclpOtzmAEdaP",0), //2094
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnML6qLFUqPjEaPi23AVpKM",0), //2095
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnML6qLFUqPjEaPiC3AVpKM",0), //2096
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnML6qLFUqPjEaPi:3AVpKM",0), //2097
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnML6qLFUqPjEaPiK3AVpKM",0), //2098
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnMBKqLg5LMS0a;cBGO",0), //2099
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnMNyqLPdqNN6qLlTrQjEaPN5bNApKNCd7PVpKM",0), //2100
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnMNyqLPdqNN6qLlTrQjEaPSIqPPpKNhILOS0a;cBGO",0), //2101
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnMNyqLPdqNReqLVxKMjEaPj77QfNqMqfqQAlpNRsqPS0a;cBGO",0), //2102
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnMNyqLPdqNReqLVxKMjEaPj77QfNqMqfqQAlpNPArPS0a;cBGO",0), //2103
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnMNyqLPdqN::rLR0qPl3rQjEaPEn6RrlpMJJaNN0bPSOaRVpKM",0), //2104
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnMB2rLKkZPpfaQQQaPdqGSEdaP",0), //2105
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnMB2rLTkZPJJaNN0bPSOaRVpKM",0), //2106
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //2107
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnMA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //2108
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnMNKrLzU6PN5bNApKNCd7PVpKM",0), //2109
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOdAnMNKrLzU6PSIqPPpKNhILOS0a;cBGO",0), //2110
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOeAnMACqL3;6RclpOdzGAEdaP",0), //2111
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOeAnMACqL3;6RclpOlzWAEdaP",0), //2112
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOeAnMACqL3;6RclpOtzmAEdaP",0), //2113
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOeAnML6qLFUqPjEaPiK3AVpKM",0), //2114
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOeAnMBKqLg5LMS0a;cBGO",0), //2115
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOeAnMB2rLKkZPpfaQQQaPdqGSEdaP",0), //2116
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOeAnMB2rLTkZPJJaNN0bPSOaRVpKM",0), //2117
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOeAnMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //2118
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOeAnMA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //2119
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOeAnMNKrLzU6PN5bNApKNCd7PVpKM",0), //2120
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOeAnMNKrLzU6PSIqPPpKNhILOS0a;cBGO",0), //2121
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOfAnMACqL3;6RclpOdzGAEdaP",0), //2122
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOfAnMACqL3;6RclpOlzWAEdaP",0), //2123
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOfAnMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //2124
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOfAnMA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //2125
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOhAnMACqL3;6RclpOdzGAEdaP",0), //2126
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOhAnMACqL3;6RclpOlzWAEdaP",0), //2127
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOhAnMACqL3;6RclpOtzmAEdaP",0), //2128
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOhAnMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //2129
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOhAnMA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //2130
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOd4nMACqL3;6RclpOdzGAEdaP",0), //2131
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOd4nMACqL3;6RclpOlzWAEdaP",0), //2132
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOd4nMACqL3;6RclpOtzmAEdaP",0), //2133
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOd4nMBKqLg5LMS0a;cBGO",0), //2134
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOd4nMB2rLKkZPpfaQQQaPdqGSEdaP",0), //2135
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOd4nMB2rLTkZPJJaNN0bPSOaRVpKM",0), //2136
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOd4nMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //2137
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOd4nMA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //2138
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOd4nMNKrLzU6PN5bNApKNCd7PVpKM",0), //2139
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOd4nMNKrLzU6PSIqPPpKNhILOS0a;cBGO",0), //2140
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOe4nMACqL3;6RclpOdzGAEdaP",0), //2141
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOe4nMACqL3;6RclpOlzWAEdaP",0), //2142
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOe4nMACqL3;6RclpOtzmAEdaP",0), //2143
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOe4nMB2rLTkZPJJaNN0bPSOaRVpKM",0), //2144
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOe4nMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //2145
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOe4nMA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //2146
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOe4nMNKrLzU6PN5bNApKNCd7PVpKM",0), //2147
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOe4nMNKrLzU6PSIqPPpKNhILOS0a;cBGO",0), //2148
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOf4nMACqL3;6RclpOdzGAEdaP",0), //2149
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOf4nMACqL3;6RclpOlzWAEdaP",0), //2150
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOf4nMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //2151
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOf4nMA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //2152
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOh4nMACqL3;6RclpOdzGAEdaP",0), //2153
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOh4nMACqL3;6RclpOlzWAEdaP",0), //2154
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOh4nMACqL3;6RclpOtzmAEdaP",0), //2155
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOh4nMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //2156
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOh4nMA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //2157
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMACqL3;6RclpOdzGAEdaP",0), //2158
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMACqL3;6RclpOlzWAEdaP",0), //2159
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMACqL3;6RclpOtzmAEdaP",0), //2160
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMACqL3;6RclpO1z2BEdaP",0), //2161
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMACqL3;6RvkpOKMrPGP6R9;nLS0a;cBGO",0), //2162
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMACqL3;6RfkpOP8KPkl5OdzGAEdaP",0), //2163
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnM:OqLaELMVpKM",0), //2164
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMBKqLg5LMS0a;cBGO",0), //2165
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMNyqLPdqNN6qLlTrQjEaPN5bNApKNCd7PVpKM",0), //2166
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMNyqLPdqNN6qLlTrQjEaPSIqPPpKNhILOS0a;cBGO",0), //2167
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMNyqLPdqNReqLVxKMjEaPj77QfNqMqfqQAlpNRsqPS0a;cBGO",0), //2168
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMNyqLPdqNReqLVxKMjEaPj77QfNqMqfqQAlpNPArPS0a;cBGO",0), //2169
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMNyqLPdqN::rLR0qPl3rQjEaPEn6RrlpMJJaNN0bPSOaRVpKM",0), //2170
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMB2rLKkZPpfaQQQaPdqGSEdaP",0), //2171
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMB2rLTkZPJJaNN0bPSOaRVpKM",0), //2172
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //2173
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //2174
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMNKrLzU6PN5bNApKNCd7PVpKM",0), //2175
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMNKrLzU6PSIqPPpKNhILOS0a;cBGO",0), //2176
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALOVcnMFKrLRQaPYwKOA6rLgpKMjoKOS0a;cBGO",0), //2177
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALO157NOnpRX1KMS0a;cBGO",0), //2178
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALO157NOnpR1QqP146PqUqMVpKM",0), //2179
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALO157NPnpRiG3AVpKM",0), //2180
	new Array(1,"NdqNjQbPDn6RIk5PR9LNLALO157NSnpRs4KMdzGAEdaP",0), //2181
	new Array(1,"NdqNjQbPDn6RIk5PO7LRrRLN157NNrmREdaP",0), //2182
	new Array(1,"NdqNjQbPDn6RIk5PO7LRrRLNMhLNHk6PakKOS0a;cBGO",0), //2183
	new Array(1,"NdqNjQbPDn6RIk5PO7LRrRLNN5bNApKNCd7PVpKM",0), //2184
	new Array(1,"NdqNjQbPDn6RIk5PO7LRrRLNoc6OdpGMEdaP",0), //2185
	new Array(1,"NdqNjQbPDn6RIk5PO7LRrRLNvoKOA;6R1o2PEdaP",0), //2186
	new Array(1,"NdqNjQbPDn6RIk5PO7LRrRLNvoKOA;6RGB3PS0a;cBGO",0), //2187
	new Array(1,"NdqNjQbPDn6RIk5PO7LRrRLNSIqPPpKNhILOS0a;cBGO",0), //2188
	new Array(1,"NdqNjQbPDn6RIk5PO7LRrRLNrjqQKRrPVpKM",0), //2189
	new Array(1,"NdqNjQbPDn6RIk5PO7LRrRLNrjqQbQrPlPaQCc7NVpKM",0), //2190
	new Array(1,"NdqNjQbPDn6RIk5PO7LRrRLN1rKR40bPYxKMS0a;cBGO",0), //2191
	new Array(1,"NdqNjQbPEn6Ru8KOdqGSEdaP",0), //2192
	new Array(1,"NdqNjQbPI;qRdlpOlzWAEdaP",0), //2193
	new Array(1,"NdqNjQbPI;qRrkpOJJaNN0bPSOaRVpKM",0), //2194
	new Array(1,"NdqNjQbPA;qR15LN0EaPKRrPVpKM",0), //2195
	new Array(1,"NdqNjQbPA;qR55LN7xKNFoWPEdaP",0), //2196
	new Array(1,"NdqNjQbPQPqRCd6NDlpNXxKMS0a;cBGO",0), //2197
	new Array(1,"NdqNjQbPQfqRQ1LNt;aQAhqNLOrLF6rLEm5RdzGAEdaP",0), //2198
	new Array(1,"NdqNjQbPQfqRQ1LNt;aQAhqNLOrLF6rLEm5RdvJAi23AVpKM",0), //2199
	new Array(1,"NdqNjQbPQfqRQ1LNt;aQAhqNLOrLF6rLEm5RevJAiC3AVpKM",0), //2200
	new Array(1,"NdqNjQbPQfqRQ1LNt;aQAhqNLOrLF6rLEm5RfvJAy2XAVpKM",0), //2201
	new Array(1,"NdqNjQbPQfqRQ1LNt;aQAhqNLOrLF6rLEm5RhvJAi23AVpKM",0), //2202
	new Array(1,"NdqNjQbPQfqRQ1LNt;aQAhqNLOrLF6rLEm5RUvJAi23AVpKM",0), //2203
	new Array(1,"NdqNjQbPQfqRQ1LNt;aQAhqNLOrLF6rLEm5RwvJAi23AVpKM",0), //2204
	new Array(1,"NdqNjQbPQfqRQ1LNt;aQAhqNLOrLF6rLEm5RlzWAEdaP",0), //2205
	new Array(1,"NdqNjQbPQfqRQ1LNt;aQAhqNLOrLF6rL3n5Rd86OUmZQdzGAEdaP",0), //2206
	new Array(1,"NdqNjQbPKfqR9t6Nzw6PXfaQjoKOS0a;cBGO",0), //2207
	new Array(1,"NdqNjQbPKfqR9t6Nzw6PtTrQNQaPSFaPVpKM",0), //2208
	new Array(1,"NdqNjQbPHAbPFaqLyfaQ9pGNEdaP",0), //2209
	new Array(1,"NdqNjQbPHAbPFaqLyfaQQlJNXxKMS0a;cBGO",0), //2210
	new Array(1,"NdqNjQbPHAbP:aqL6GKRVpKM",0), //2211
	new Array(1,"NdqNjQbPHAbP:aqLrHKRA;6RtomOEdaP",0), //2212
	new Array(1,"NdqNjQbPHAbPNOrLBrKRtrmQEdaP",0), //2213
	new Array(1,"NdqNjQbPHAbPNOrLBrKRnnpQYwKOi23AVpKM",0), //2214
	new Array(1,"NdqNjQbPHAbPNOrLBrKRgnpQXxKMS0a;cBGO",0), //2215
	new Array(1,"NdqNjQbPHAbPNKrL40bPS0a;cBGO",0), //2216
	new Array(1,"NdqNjQbPHAbPNKrL40bPNOrLCV6PVpKM",0), //2217
	new Array(1,"NdqNjQbPHAbPRKrL9R6NSFaPVpKM",0), //2218
	new Array(1,"NdqNjQbPHAbPRKrL9R6NjEaPA;6RtomOEdaP",0), //2219
	new Array(1,"NdqNjQbPHAbPRKrLhQKOS0a;cBGO",0), //2220
	new Array(1,"NdqNjQbPHAbPRKrLhQKONOrLCV6PVpKM",0), //2221
	new Array(1,"NdqNjQbPHAbPRKrLhQKORKrL9R6NSFaPVpKM",0), //2222
	new Array(1,"NdqNjQbPHAbPRWrLGN6NS0a;cBGO",0), //2223
	new Array(1,"NdqNjQbPHAbPRWrLGN6NNOrLCV6PVpKM",0), //2224
	new Array(1,"NdqNjQbPRNaNhxKMJSrLp5bM1w6PB2rLKkZPpfaQQQaPtDHSS0a;cBGO",0), //2225
	new Array(1,"NdqNjQbPRNaNhxKMJSrLp5bM1w6PB2rLKkZPpfaQQQaPuDHSS0a;cBGO",0), //2226
	new Array(1,"NdqNjQbPRNaNhxKMJSrLp5bM1w6PB2rLKkZPpfaQQQaPvDHSS0a;cBGO",0), //2227
	new Array(1,"NdqNjQbPRNaNhxKMJSrLp5bM1w6PF6rL1r2REdaP",0), //2228
	new Array(1,"NdqNjQbPRNaNhxKMJSrLp5bM1w6PF6rLIn5RDkpPhQKOeTrQjdKMiR7OVpKM",0), //2229
	new Array(1,"NdqNjQbPRNaNhxKMJSrLp5bM1w6PA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //2230
	new Array(1,"NdqNjQbPRNaNhxKMJSrLp5bM1w6PNKrLCV6PVpKM",0), //2231
	new Array(1,"NdqNjQbPRNaNhxKMJSrLp5bM1w6PFKrLHN6N177RUEKOIn5R;kpPaRLOVpKM",0), //2232
	new Array(1,"NdqNjQbP:vKRwPaQz86PyPbQ:GqLaMKONx6Ni23AVpKM",0), //2233
	new Array(1,"NdqNjQbP:vKRwPaQz86PyPbQ:GqLaMKONx6NiC3AVpKM",0), //2234
	new Array(1,"NdqNjQbP:vKRwPaQz86PyPbQ:GqLaMKONx6Ni:3AVpKM",0), //2235
	new Array(1,"NdqNjQbP:vKRwPaQz86PgfqQS0a;cBGO",0), //2236
	new Array(1,"NdqNjQbP:vKRwPaQz86PgfqQLOrLFKrLHN6N177RUEKO1r2REdaP",0), //2237
	new Array(1,"NdqNjQbP:vKRwPaQz86PtTrQjQaPN5bNApKNCd7PVpKM",0), //2238
	new Array(1,"NdqNjQbP:vKRwPaQz86PI;qRtomOEdaP",0), //2239
	new Array(1,"NdqNjQbP:vKRwPaQz86PQfqRQ1LNt;aQAhqNLOrLF6rL1r2REdaP",0), //2240
	new Array(1,"NdqNjQbPbpKMi86OslJM8ArP;kpPC;6R1p2NEdaP",0), //2241
	new Array(1,"NdqNjQbPRNaNhxKMKCqLNgqPj8aPGP7R7XKRA6rLgpKMS0a;cBGO",0), //2242
	new Array(1,"NdqNjQbPRNaNhxKMF:rLDw6POnpRLk6PdFLMhmJS5QaPyOaQVpKM",0), //2243
	new Array(1,"NdqNjQbPRNaNhxKMF:rLDw6PSnpRpfaQQQaPumJS6qKRVpKM",0), //2244
	new Array(1,"NdqNjQbPRNaNhxKMF:rLDw6PSnpRpfaQQQaPzmJSXxKMS0a;cBGO",0), //2245
	new Array(1,"NdqNjQbPRNaNhxKMF:rLDw6PLnpRJJaNN0bPjPaRyPbQS0a;cBGO",0), //2246
	new Array(1,"NdqNjQbPRNaNhxKMF:rLDw6P:npRrrKRSIqPPpKNhILOS0a;cBGO",0), //2247
	new Array(1,"NdqNjQbPRNaNhxKMF:rLDw6P;npRZRLOBm6RtTrQSRaPVpKM",0), //2248
	new Array(1,"NdqNjQbPRNaNhxKMF:rLDw6P;npRaRLOVpKM",0), //2249
	new Array(1,"NdqNjQbPRNaNhxKMF:rLDw6P;npRC;6RIt2N;smPaRLOVpKM",0), //2250
	new Array(1,"NdqNjQbPRNaNhxKMF:rLDw6P;npRC;6R6l5NpfaQQQaPdqGSEdaP",0), //2251
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5ND3XA157NNrmREdaP",0), //2252
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPi86O3l5NDDXA157NNrmREdaP",0), //2253
	new Array(1,"NdqNjQbPgf6QLk6PACqL3;6RdBnOS0a;cBGO",0), //2254
	new Array(1,"NdqNjQbPgf6QLk6PACqL3;6ReBnOS0a;cBGO",0), //2255
	new Array(1,"NdqNjQbPgf6QLk6PACqL3;6RfBnOS0a;cBGO",0), //2256
	new Array(1,"NdqNjQbPgf6QLk6PI2qLNErP1;qRL2qLCc7NVpKM",0), //2257
	new Array(1,"NdqNjQbPgf6QLk6PI2qLNErP1;qR:KqLKMrP1p2NEdaP",0), //2258
	new Array(1,"NdqNjQbPgf6QLk6PI2qLNErP1;qRReqLLRKM6CLRVpKM",0), //2259
	new Array(1,"NdqNjQbPgf6QLk6PI2qLNErP1;qR86rLapKOVpKM",0), //2260
	new Array(1,"NdqNjQbPgf6QLk6PL6qLQrKR64LNVpKM",0), //2261
	new Array(1,"NdqNjQbPgf6QLk6PROqLSNaNqMqMVpKM",0), //2262
	new Array(1,"NdqNjQbPgf6QLk6PLOqLOrqR7IL;Q8L;gpKMS0a;cBGO",0), //2263
	new Array(1,"NdqNjQbPgf6QLk6PLOqLOrqRS0a;cBGO",0), //2264
	new Array(1,"NdqNjQbPgf6QLk6P:GqLaMKONx6NB2rLFoWPEdaP",0), //2265
	new Array(1,"NdqNjQbPgf6QLk6P:GqLaMKONx6NNKrLCV6PVpKM",0), //2266
	new Array(1,"NdqNjQbPgf6QLk6P:KqLTEqPdqGSEdaP",0), //2267
	new Array(1,"NdqNjQbPgf6QLk6PFeqLC:6RVpKM",0), //2268
	new Array(1,"NdqNjQbPgf6QLk6PFeqLC66RVpKM",0), //2269
	new Array(1,"NdqNjQbPgf6QLk6PSqqLSNaNifqQ9pGNEdaP",0), //2270
	new Array(1,"NdqNjQbPgf6QLk6PSqqLSNaNifqQOlJN6qKRVpKM",0), //2271
	new Array(1,"NdqNjQbPgf6QLk6PSqqLSNaNifqQTlJNXxKMS0a;cBGO",0), //2272
	new Array(1,"NdqNjQbPgf6QLk6PF6rLIv2R;smPC;6R1p2NEdaP",0), //2273
	new Array(1,"NdqNjQbPgf6QLk6PF6rL1r2REdaP",0), //2274
	new Array(1,"NdqNjQbPgf6QLk6PJ6rLU1LMS0a;cBGO",0), //2275
	new Array(1,"NdqNjQbPgf6QLk6PA6rLgpKM7IL;18L;1r2REdaP",0), //2276
	new Array(1,"NdqNjQbPgf6QLk6PA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //2277
	new Array(1,"NdqNjQbPRNaNhxKMNyqLzfaQ4MaPzP6R48aP97LRHk5PLQLOi:3AVpKM",0), //2278
	new Array(1,"NdqNjQbPRNaNhxKMNyqLzfaQ4MaPzP6R48aP97LRHk5PLQLOT;3Azn6RQfqRQ1LNt;aQAhqNS0a;cBGO",0), //2279
	new Array(1,"NdqNjQbPRNaNhxKMNyqLzfaQ4MaPzP6R48aP97LRLk5PhQKOeTrQjdKMTQ7Ozn6RgfqQ;;nLS0a;cBGO",0), //2280
	new Array(1,"NdqNjQbPRNaNhxKMNyqLzfaQ4MaPzP6RyPbQ:GqLaMKONx6NS0a;cBGO",0), //2281
	new Array(1,"NdqNjQbPRNaNhxKMNyqLzfaQ4MaPzP6RtTrQjQaPN5bNApKNCd7PVpKM",0), //2282
	new Array(1,"NdqNjQbPRNaNhxKMNyqLzfaQ4MaPzP6RI;qRykpOpfaQQQaPdqGSEdaP",0), //2283
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJN1T7RcUqMdzGAEdaP",0), //2284
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJN1T7RcUqMlzWAEdaP",0), //2285
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJN1T7RcUqMtzmAEdaP",0), //2286
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJNACqL3;6RdBnOS0a;cBGO",0), //2287
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJNACqL3;6ReBnOS0a;cBGO",0), //2288
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJNACqL3;6RfBnOS0a;cBGO",0), //2289
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJNN6qLH;6RD77RZj6QN6qLlTrQSFaPVpKM",0), //2290
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJNN6qLH;6RD77RZj6Q::rLR0qPl3rQSFaPVpKM",0), //2291
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJNNOqL7jqQf9qMCf6RNpmNEdaP",0), //2292
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJNNOqL7jqQj77QfNqMqfqQNpmNEdaP",0), //2293
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJNFeqLC:6RVpKM",0), //2294
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJNFeqLC66RVpKM",0), //2295
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJN8qqL95LNDf6RFoWPEdaP",0), //2296
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJNR6rLm;6QVRLMKpqPVpKM",0), //2297
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJNJ6rLU1LMS0a;cBGO",0), //2298
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJN86rLd4LO3k5Pw1LMjoKOS0a;cBGO",0), //2299
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJN86rLd4LOEk5PnnaQP1LNjoKOS0a;cBGO",0), //2300
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJNA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //2301
	new Array(1,"NdqNjQbPO8KPakKOQRLN9lJNFKrLRQaPYwKOS0a;cBGO",0), //2302
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJNACqL3;6RdBnOS0a;cBGO",0), //2303
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJNACqL3;6ReBnOS0a;cBGO",0), //2304
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJNACqL3;6RfBnOS0a;cBGO",0), //2305
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJNN6qLH;6RD77RZj6QN6qLlTrQSFaPVpKM",0), //2306
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJNN6qLH;6RD77RZj6Q::rLR0qPl3rQSFaPVpKM",0), //2307
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJNNOqL7jqQf9qMCf6RNpmNEdaP",0), //2308
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJNNOqL7jqQj77QfNqMqfqQNpmNEdaP",0), //2309
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJNFeqLC:6RVpKM",0), //2310
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJNFeqLC66RVpKM",0), //2311
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJN8qqL95LNDf6RFoWPEdaP",0), //2312
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJNR2rLd;6QlrWQEdaP",0), //2313
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJNR6rLm;6QVRLMKpqPVpKM",0), //2314
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJNJ6rLU1LMS0a;cBGO",0), //2315
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJN86rLd4LO3k5Pw1LMjoKOS0a;cBGO",0), //2316
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJN86rLd4LOEk5PnnaQP1LNjoKOS0a;cBGO",0), //2317
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJNA6rLgpKMSqqLSNaNifqQ9pGNEdaP",0), //2318
	new Array(1,"NdqNjQbPO8KPakKOQRLN:lJNFKrLRQaPYwKOS0a;cBGO",0), //2319
	new Array(1,"NdqNjQbPO8KPakKOQRLNAlJNBJKNJ0aPS0a;cBGO",0), //2320
	new Array(1,"NdqNjQbPO8KPakKOQRLNAlJNb;aQS0a;cBGO",0), //2321
	new Array(1,"NdqNjQbPO8KPakKOQRLNOlJN6qKRVpKM",0), //2322
	new Array(1,"NdqNjQbPO8KPakKOQRLNOlJNrrKRN5bNApKNCd7PVpKM",0), //2323
	new Array(1,"NdqNjQbPO8KPakKOQRLNPlJNLQLOi23AVpKM",0), //2324
	new Array(1,"NdqNjQbPO8KPakKOQRLNPlJNLQLOT33Azn6RQfqRQ1LNt;aQAhqNS0a;cBGO",0), //2325
	new Array(1,"NdqNjQbPO8KPakKOQRLNPlJNP8KPVo2OEdaP",0), //2326
	new Array(1,"NdqNjQbPO8KPakKOQRLNPlJNC;6R6l5NpfaQQQaPdqGSEdaP",0), //2327
	new Array(1,"NdqNjQbPO8KPakKOQRLNTlJNXxKMS0a;cBGO",0), //2328
	new Array(1,"NdqNjQbPO8KPakKOQRLNTlJNXxKM:GqLaMKONx6NS0a;cBGO",0), //2329
	new Array(1,"NdqNjQbPO8KPakKOQRLNTlJNhQKOeTrQjdKMTQ7Ozn6RgfqQ9;nLS0a;cBGO",0), //2330
	new Array(1,"NdqNjQbPO8KPakKOQRLNTlJNh4LOydaMCd6NNpmNEdaP",0), //2331
	new Array(1,"NdqNjQbPO8KPakKOQRLNTlJNh4LOgP7QCc6PNpmNEdaP",0), //2332
	new Array(1,"NdqNjQbP8drN7frQtTrQjQaPN5bNApKNCd7PVpKM",0), //2333
	new Array(1,"NdqNjQbP71nMHAbPNGqLDw6PFoWPEdaP",0), //2334
	new Array(1,"NdqNjQbPRNaNhxKM;7qL8mqLtlpM2QaPa0LMVpKM",0), //2335
	new Array(1,"NdqNjQbPRNaNhxKM;7qL8mqLxlpMCM7P6QKNVpKM",0), //2336
	new Array(1,"NdqNjQbPRNaNhxKMNmqLGP7RLxKMtTrQjQaPHAbPRmqLXfbQS0a;cBGO",0), //2337
	new Array(1,"NdqNjQbPb86OrxKNtTrQjQaPN5bNApKNCd7PVpKM",0), //2338
	new Array(1,"NdqNjQbP48aP97LRHk5PC;6RCl5NT36Q577R2laNS0a;cBGO",0), //2339
	new Array(1,"NdqNjQbPV6XAUvZA3vKReoKOLRLMBJLNSRbPVpKM",0), //2340
	new Array(1,"NdqNjQbPrxqMzj6R8daNA6rLgpKM:GqLaMKONx6NS0a;cBGO",0), //2341
	new Array(1,"NdqNjQbPolqMGA3NS0a;cBGO",0), //2342
	new Array(1,"NdqNjQbPgNrMaNKOVpKM",0), //2343
	new Array(1,"NdqNjQbPRNaNhxKM83nLLDHAhP7QqcqOY9aMCSqLQpKNS0a;cBGO",0), //2344
	new Array(1,"NdqNjQbPRNaNhxKML6qLER6PlzWAEdaP",0), //2345
	new Array(1,"NdqNjQbPRNaNhxKMB6qLzP6RtTrQjQaPN5bNApKNCd7PVpKM",0), //2346
	new Array(1,"NdqNjQbPRNaNhxKMB6qL5f6RS0a;cBGO",0), //2347
	new Array(1,"NdqNjQbPRNaNhxKMLGqL5Q6PlnZQyuaQVpKM",0), //2348
	new Array(1,"NdqNjQbPRNaNhxKMLGqLju6S40bPr5LN9;6R1o2PEdaP",0), //2349
	new Array(1,"NdqNjQbPRNaNhxKMNKqLDOaSb5LMArKRS0a;cBGO",0), //2350
	new Array(1,"NdqNjQbPRNaNhxKMBWqL6BLPVpKM",0), //2351
	new Array(1,"NdqNjQbPRNaNhxKML:rLIc6PFxKN:KqLQNKNjoKOS0a;cBGO",0), //2352
	new Array(1,"NdqNjQbPRNaNhxKMR2rLQnaR1TLR8pqPlzWAEdaP",0), //2353
	new Array(1,"NdqNjQbPRNaNhxKME6rLdtKMFoWPEdaP",0), //2354
	new Array(1,"NdqNjQbPRNaNhxKMF6rLzN6N5d6NS0a;cBGO",0), //2355
	new Array(1,"NdqNjQbPRNaNhxKMA6rLgpKM:GqLaMKONx6Ni23AVpKM",0), //2356
	new Array(1,"NdqNjQbPQlaNGN6N:CqL9oGPEdaP",0), //2357
	new Array(1,"NdqNjQbP8laN6kKPxTrQYnZQYdKMS0a;cBGO",0), //2358
	new Array(1,"NdqNjQbP29qN9lJNZnaQSRaPVpKM",0), //2359
	new Array(1,"NdqNjQbPVM6OHl5Nf86O9pGNEdaP",0), //2360
	new Array(1,"NdqNjQbPxMbOVr2QEdaP",0), //2361
	new Array(1,"NdqNjQbP58KPDlaMC96NqMqMVpKM",0), //2362
	new Array(1,"NdqNjQbPSIqP64LNVpKM",0), //2363
	new Array(1,"NdqNjQbPgn6QhQLOzc7PR5rN1RLNSFaPVpKM",0), //2364
	new Array(1,"NdqNjQbPaPaQBwqPDf6R2BXPS0a;cBGO",0), //2365
	new Array(1,"NdqNjQbPtjqQ68KPS0a;cBGO",0), //2366
	new Array(1,"NdqNjQbPwfqQAlJNaNKOVpKM",0), //2367
	new Array(1,"NdqNjQbPtTrQjQaPN5bNApKNEd7PdzGAEdaP",0), //2368
	new Array(1,"NdqNjQbPePrQd77QcOqQlzWAEdaP",0), //2369
	new Array(1,"NdqNjQbPG;6Ry:aSS0a;cBGO",0), //2370
	new Array(1,"NdqNjQbP977RVr2QEdaP",0), //2371
	new Array(1,"NdqNjQbP7RnMl8qOCm6RVpKM",0), //2372
	new Array(1,"NdqNjQbPRNaNhxKMA7qLFyqLqNrOVpKM",0), //2373
	new Array(1,"NdqNjQbPRNaNhxKMNeqLqhqM4lJNapKOVpKM",0), //2374
	new Array(1,"NdqNjQbPX86OZo6OR2rLFoWPEdaP",0), //2375
	new Array(1,"NdqNjQbP48aP97LRIk5PIkqPE2qLgpKM9zqLsvJAN86PjoKOBKqLdQLObnZQXxKMS0a;cBGO",0), //2376
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NL3HAVz6QaeKSTlpNQfKRa4LMVpKM",0), //2377
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NL3HAyPbQ:GqLaMKONx6NS0a;cBGO",0), //2378
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NL3HAtTrQjQaPN5bNApKNCd7PVpKM",0), //2379
	new Array(1,"NdqNjQbPDn6R2k5Pi86OBl5NL3HAI;qRykpOpfaQQQaPdqGSEdaP",0), //2380

	new Array(0) //Footer
);

// rebuild 2013-02-20 14:21:45.


/* ../data/ja/Giant_common/EyeEmotion.js */
var sEyeEmotionArray = new Array(
	new Array(1,"BhLF7xKFDf6R0BWPsA38qA38r038mA38k038tA38sA38UQ38kaXAcSHAW6WAX6WAt6GAt6GAm72Cd6mAt7GCN6GBf6mAl62Au7GCV6WAy6GAs038tA38rA38n038qA38t038mA38rA38rA38p038l038U838cGHAkWXAcaHAc2HAc6HAcKHAM6mB",0), //0
	new Array(1,"BhLF7xKFDf6R4BWPsA38qA38r038mA38k038tA38sA38UQ38kaXAcSHAW6WAX6WAt6GAt6GAm72Cd6mAt7GCN6GBf6mAl62Au7GCV6WAy6GAs038tA38rA38n038qA38t038mA38rA38rA38p038l038U838cGHAkWXAcaHAc2HAc6HAcKHAM6mB",0), //1
	new Array(1,"BhLF7xKFDf6R8BWPsA38qA38r038mA38k038tA38sA38UQ38kaXAcSHAW6WAX6WAt6GAt6GAm72Cd6mAt7GCN6GBf6mAl62Au7GCd6mAy6GAs038tA38rA38n038qA38t038mA38rA38rA38p038l038U838cGHAkWXAcaHAc2HAc6HAcKHAM6mB",0), //2
	new Array(1,"BhLF7xKFDf6R1BWPW6WAm72C16WB26WBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAc2HAcaHAk:XAcWHAcGHAc:HAs6nAcWHAk:XAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //3
	new Array(1,"BhLF7xKFDf6R1BWP26WBm72C16WB26WBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAc2HAcaHAk:XAcWHAcGHAc:HAs6nAcWHAk:XAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //4
	new Array(1,"BhLF7xKFDf6R2BWPm62Am72C26WBm62AV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAc2HAs6nAk:XAcWHAcGHAc:HAs6nAcWHAk:XAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //5
	new Array(1,"BhLF7xKFDf6R2BWPG62Bm72C16WB26WBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAc2HAcaHAk:XAcWHAcGHAc:HAs6nAcWHAk:XAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //6
	new Array(1,"BhLF7xKFDf6R2BWPm72Cm72Cm72Cm72CV6WAm62Au7GCq72CsA38q038UA38kCXAkWXAc2HAcaHAk:XAcWHAcGHAc:HAs6nAcWHAk:XAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //7
	new Array(1,"BhLF7xKFDf6R1BWPsA38qA38pA38mA38k038tA38sA38UQ38kaXAcSHAW6WAX6WAt6GAt6GAm72Cd6mAt7GCN6GBf6mAl62Au7GCd6mAy6GAs038tA38rA38n038qA38t038mA38rA38rA38p038l038U838cGHAkWXAcaHAc2HAc6HAcKHAM6mB",0), //8
	new Array(1,"BhLF7xKFDf6R5BWPsA38qA38UE38kCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038nA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //9
	new Array(1,"BhLF7xKFDf6R9BWPsA38qA38r038mA38k038tA38sA38UQ38kaXAcSHAW6WAX6WAt6GAt6GAm72Cd6mAt7GCN6GBf6mAl62Au7GCd6mAy6GAs038tA38rA38n038qA38t038mA38rA38rA38p038l038U838cGHAkWXAcaHAc2HAc6HAcKHAM6mB",0), //10
	new Array(1,"BhLF7xKFDf6R1BWPe6mAm72C36WBmA38k038tA38U83816WBl72Cu7GCmA38tA38l038s038nA38t038p038n038k838t038nA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //11
	new Array(1,"BhLF7xKFDf6R1BWP:6mBm72C16WB:6mBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAc2HAcaHAk:XAcWHAcGHAc:HAs6nAcWHAk:XAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //12
	new Array(1,"BhLF7xKFDf6R2BWPu6GAm72C26WBu6GAV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAc2HAcaHAk:XAcWHAcGHAc:HAs6nAcWHAk:XAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //13
	new Array(1,"BhLF7xKFDf6R2BWPO6GBm72C26WBO6GBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAc2HAcaHAk:XAcWHAcGHAc:HAs6nAcWHAk:XAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //14
	new Array(1,"BhLF7xKFDf6R2BWPmA38qA38U838kCXAc6HAkWXAi6mAs038t038UA38kCXAkWXAc2HAcaHAk:XAcWHAcGHAc:HAs6nAcWHAk:XAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //15
	new Array(1,"BhLF7xKFDf6R6BWPmA38qA38U838kCXAc6HAkWXAi6mAs038t038UA38kCXAkWXAc2HAcaHAk:XAcWHAcGHAc:HAs6nAcWHAk:XAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //16
	new Array(1,"BhLF7xKFDf6R1BWPF62BF62BF62BG62BV6WAm62Av7GCUQ38caHAcWHAW6WAW6WAt7GCt6GAm72Cd6mAt7GCN6GBf6mAl62Au7GCd6mAy6GAs038tA38rA38n038qA38t038mA38rA38rA38p038l038U838cGHAkWXAcaHAc2HAc6HAcKHAM6mB",0), //17
	new Array(1,"BhLF7xKFDf6R3BWPmA38qA38n038mA38k038tA38U83816WBl72Cu7GCmA38tA38l038s038nA38t038p038n038k838t038nA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //18
	new Array(1,"BhLF7xKFDf6R7BWPmA38qA38n038mA38k038tA38U83816WBl72Cu7GCmA38tA38l038s038nA38t038p038n038k838t038nA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //19
	new Array(1,"BhLF7xKFDf6R3BWPW6WAm72C46WBG62BV6WAm62Au7GCq72CsA38m838UA38kCXAd6mAt6GAm72Cd6mAt7GCN6GBf6mAl62Au7GCV6WAy6GAs038tA38rA38n038qA38t038mA38rA38rA38p038l038U838cGHAkWXAcaHAc2HAc6HAcKHAM6mB",0), //20
	new Array(1,"BhLF7xKFDf6R3BWP26WBm72C46WBG62BV6WAm62Au7GCq72CsA38q838UA38kCXAd6mAt6GAm72Cd6mAt7GCN6GBf6mAl62Au7GCV6WAy6GAs038tA38rA38n038qA38t038mA38rA38rA38p038l038U838cGHAkWXAcaHAc2HAc6HAcKHAM6mB",0), //21
	new Array(1,"BhLF7xKFDf6R4BWPm62Am72C16WB26WBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAc2HAcaHAk:XAcWHAcGHAc:HAs6nAcWHAk:XAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //22
	new Array(1,"BhLF7xKFDf6R4BWPG62Bm72C46WBG62BV6WAm62Au7GCq72CsA38oI38UA38kCXAd6mAt6GAm72Cd6mAt7GCN6GBf6mAl62Au7GCd6mAy6GAs038tA38rA38n038qA38t038mA38rA38rA38p038l038U838cGHAkWXAcaHAc2HAc6HAcKHAM6mB",0), //23
	new Array(1,"BhLF7xKFDf6R3BWPe6mAm72C16WB:6mBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAE6XBcaHAk:XAcWHAcGHAc:HAs6nAcWHAk:XA0W3B16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038kQ38k038o038UM38",0), //24
	new Array(1,"BhLF7xKFDf6R3BWP:6mBm72C16WB:6mBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAE6XBcaHAk:XAcWHAcGHAc:HAs6nAcWHAk:XA0W3B16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038kQ38k038o038UM38",0), //25
	new Array(1,"BhLF7xKFDf6R4BWPu6GAm72C16WB:6mBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAE6XBcaHAk:XAcWHAcGHAc:HAs6nAcWHAk:XA0W3B66WBm62Au7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38kQ38kQ38k038o038UM38",0), //26
	new Array(1,"BhLF7xKFDf6R4BWPO6GBm72C56WBe6mAV6WAm62Au7GCp72C:6mBV6WAu7GCmA38l838kQ38s038nA38t038p038n038qE38t038tI38kQ38UQ38E6XBkWXA0W3B8:HBkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBw7GCy7GCl62Al62AL62B",0), //27
	new Array(1,"BhLF7xKFDf6R5BWP:6mBm72C46WBm72CV6WAm62Ax7GCh6mA:6mBV6WAu7GCmA38l838kQ38s038sI38t038p038sI38qE38t038tI38kQ38UQ38E6XBkWXA0W3B0a3BkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBw7GCy7GCl62Al62AL62B",0), //28
	new Array(1,"BhLF7xKFDf6R6BWPu6GAm72C16WB:6mBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAE6XBcaHAk:XAcWHAcGHA0a3Bs6nAcWHA0W3BE6XB16WBm72Cw7GCw7GCm72C16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38tI38kQ38k038o038UM38",0), //29
	new Array(1,"BhLF7xKFDf6R3BWPG62Bm72C16WB:6mBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAE6XBcaHAk:XAcWHAcGHA0a3Bs6nAcWHA0W3BE6XB16WBm72Cw7GCw7GCm72C16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38tI38kQ38k038o038UM38",0), //30
	new Array(1,"BhLF7xKFDf6R3BWPm72Cm72C16WB26WBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAE6XBcaHAk:XAcWHAcGHA0a3Bs6nAcWHA0W3BE6XB16WBm72Cw7GCw7GCm72C16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38tI38kQ38k038o038UM38",0), //31
	new Array(1,"BhLF7xKFDf6R4BWPW6WAm72C16WB:6mBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAE6XBcaHAk:XAcWHAcGHA0a3Bs6nAcWHA0W3BE6XB16WBm72Cw7GCw7GCm72C16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38tI38kQ38k038o038UM38",0), //32
	new Array(1,"BhLF7xKFDf6R4BWP26WBm72C16WB26WBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAE6XBcaHAk:XAcWHAcGHA0a3Bs6nAcWHA0W3BE6XB16WBm72Cw7GCw7GCm72C16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38tI38kQ38k038o038UM38",0), //33
	new Array(1,"BhLF7xKFDf6R3BWPu7GCm72C16WB26WBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAE6XBcaHAk:XAcWHAcGHA0a3Bs6nAcWHA0W3BE6XB16WBm72Cw7GCw7GCm72C16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38tI38kQ38k038o038UM38",0), //34
	new Array(1,"BhLF7xKFDf6R4BWPe6mAm72C46WBe6mAV6WAm62Au7GCp72C:6mBo72Ce6mAmA38l838kQ38s038nA38t038p038sI38qE38t038tI38kQ38rE38s038tA38rA38nE38qA38t038mA38rA38rA38sA38kQ38U838cGHAkWXA0W3BE6XBc6HAcKHAM6mB",0), //35
	new Array(1,"BhLF7xKFDf6R5BWPm72Cm72C56WBm72CV6WAm62Au7GCp72C:6mBp72Cm72CmA38l838kQ38s038nA38t038p038sI38qE38t038tI38kQ38rE38s038tA38sE38nE38qA38t038mA38rA38rA38sA38kQ38U838cGHAkWXA0W3BE6XBc6HAcKHAM6mB",0), //36
	new Array(1,"BhLF7xKFDf6R5BWPG62Bm72C56WBG62BV6WAm62Au7GCp72C:6mBp72CG62BmA38l838kQ38s038nA38t038p038sI38qE38t038tI38kQ38rE38s038tA38rA38nE38qA38t038mA38rA38rA38sA38kQ38U838cGHAkWXA0W3BE6XBc6HAcKHAM6mB",0), //37
	new Array(1,"BhLF7xKFDf6R5BWPm62Am72C56WBm62AV6WAm62Au7GCp72C:6mBm72Cm62AmA38l838kQ38s038nA38t038p038sI38qE38t038tI38kQ38rE38s038tA38rA38nE38qA38t038mA38rA38rA38sA38kQ38U838cGHAkWXA0W3BE6XBc6HAcKHAM6mB",0), //38
	new Array(1,"BhLF7xKFDf6R3BWPO6GBm72C36WBO6GBV6WAm62Au7GCp72C:6mBm72Cm62AmA38l838kQ38s038nA38t038p038sI38qE38t038tI38kQ38rE38s038tA38rA38nE38qA38t038mA38rA38rA38sA38kQ38U838cGHAkWXA0W3BE6XBc6HAcKHAM6mB",0), //39
	new Array(1,"BhLF7xKFDf6R4BWP:6mBm72C46WB:6mBV6WAm62Au7GCp72C:6mBm72Cm62AmA38l838kQ38s038nA38t038p038sI38qE38t038tI38kQ38rE38s038tA38rA38nE38qA38t038mA38rA38rA38sA38kQ38U838cGHAkWXA0W3BE6XBc6HAcKHAM6mB",0), //40
	new Array(1,"BhLF7xKFDf6R5BWPu6GAm72C46WB:6mBV6WAm62Au7GCp72C:6mBm72Cm62AmA38l838kQ38s038nA38t038p038sI38qE38t038tI38kQ38rE38s038tA38rA38nE38qA38t038mA38rA38rA38sA38kQ38U838cGHAkWXA0W3BE6XBc6HAcKHAM6mB",0), //41
	new Array(1,"BhLF7xKFDf6R5BWPO6GBm72C46WB:6mBV6WAm62Au7GCp72C:6mBm72Cm62AmA38l838kQ38s038nA38t038p038sI38qE38t038tI38kQ38rE38s038tA38rA38nE38qA38t038mA38rA38rA38sA38kQ38U838cGHAkWXA0W3BE6XBc6HAcKHAM6mB",0), //42
	new Array(1,"BhLF7xKFDf6R5BWPu7GCm72C46WB:6mBV6WAm62Au7GCp72C:6mBm72Cm62AmA38l838kQ38s038nA38t038p038sI38qE38t038tI38kQ38rE38s038tA38rA38nE38qA38t038mA38rA38rA38sA38kQ38U838cGHAkWXA0W3BE6XBc6HAcKHAM6mB",0), //43
	new Array(1,"BhLF7xKFDf6R6BWPe6mAm72C46WB:6mBV6WAm62Au7GCp72C:6mBm72Cm62AmA38l838kQ38s038nA38t038p038sI38qE38t038tI38kQ38rE38s038tA38rA38nE38qA38t038mA38rA38rA38sA38kQ38U838cGHAkWXA0W3BE6XBc6HAcKHAM6mB",0), //44
	new Array(1,"BhLF7xKFDf6R1BWP8SHBwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //45
	new Array(1,"BhLF7xKFDf6R1BWP8OHBwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //46
	new Array(1,"BhLF7xKFDf6R1BWP8aHBwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //47
	new Array(1,"BhLF7xKFDf6R1BWP8WHBwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //48
	new Array(1,"BhLF7xKFDf6R1BWPE6XBwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //49
	new Array(1,"BhLF7xKFDf6R1BWPE2XBwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //50
	new Array(1,"BhLF7xKFDf6R1BWPECXBwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //51
	new Array(1,"BhLF7xKFDf6R1BWPE:XBwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //52
	new Array(1,"BhLF7xKFDf6R1BWPMSnBwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //53
	new Array(1,"BhLF7xKFDf6R1BWPMOnBwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //54
	new Array(1,"BhLF7xKFDf6R1BWPManBwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //55
	new Array(1,"BhLF7xKFDf6R1BWPMWnBwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //56
	new Array(1,"BhLF7xKFDf6R9BWPW6WAm72C16WB:6mBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAc2HAcaHAk:XAcWHAcGHAc:HAs6nAcWHAkCXAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //57
	new Array(1,"BhLF7xKFDf6R9BWPe6mAm72C16WB:6mBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAc2HAcaHAk:XAcWHAcGHAc:HAs6nAcWHAkCXAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //58
	new Array(1,"BhLF7xKFDf6R9BWPG62Bm72C16WB:6mBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAc2HAcaHAk:XAcWHAcGHAc:HAs6nAcWHAkCXAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //59
	new Array(1,"BhLF7xKFDf6R9BWPO6GBm72C16WB:6mBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAc2HAcaHAk:XAcWHAcGHAc:HAs6nAcWHAkCXAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //60
	new Array(1,"BhLF7xKFDf6R9BWP26WBm72C16WB:6mBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAc2HAcaHAk:XAcWHAcGHAc:HAs6nAcWHAkCXAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //61
	new Array(1,"BhLF7xKFDf6R9BWP:6mBm72C16WB:6mBV6WAm62Au7GCq72CsA38q038UA38kCXAs2nAc2HAcaHAk:XAcWHAcGHAc:HAs6nAcWHAkCXAc2HA16WBm72Cu7GC96mBe6mA16WBu7GCW6WA:6mB96mBN6GBv6GAp038tA38s038l038k038o038UM38",0), //62
	new Array(1,"BhLF7xKFDf6R1BWPUT3CvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //63
	new Array(1,"BhLF7xKFDf6R1BWPUP3CvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //64
	new Array(1,"BhLF7xKFDf6R1BWPUb3CvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //65
	new Array(1,"BhLF7xKFDf6R1BWPUX3CvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //66
	new Array(1,"BhLF7xKFDf6R1BWPc7HCvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //67
	new Array(1,"BhLF7xKFDf6R1BWPc3HCvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //68
	new Array(1,"BhLF7xKFDf6R2BWPUK3AvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //69
	new Array(1,"BhLF7xKFDf6R2BWPUG3AvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //70
	new Array(1,"BhLF7xKFDf6R2BWPUS3AvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //71
	new Array(1,"BhLF7xKFDf6R2BWPUO3AvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //72
	new Array(1,"BhLF7xKFDf6R1BWPUL3CvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //73
	new Array(1,"BhLF7xKFDf6R1BWPUH3CvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //74
	new Array(1,"BhLF7xKFDf6R1BWPkCXAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //75
	new Array(1,"BhLF7xKFDf6R1BWPk:XAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //76
	new Array(1,"BhLF7xKFDf6R1BWPkKXAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //77
	new Array(1,"BhLF7xKFDf6R1BWPkGXAkaXAkSXAxCHAmA38k038tA38sA38UQ38kaXAcSHAW6WAX6WAt6GAt6GAm72Cd6mAt7GCN6GBf6mAl62Au7GCV6WAy6GAs038tA38rA38n038qA38t038mA38rA38rA38p038l038U838cGHAkWXAcaHAc2HAc6HAcKHAM6mB",0), //78
	new Array(1,"BhLF7xKFDf6R1BWPkSXAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //79
	new Array(1,"BhLF7xKFDf6R1BWPkOXAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //80
	new Array(1,"BhLF7xKFDf6R1BWPkaXAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //81
	new Array(1,"BhLF7xKFDf6R1BWPkWXAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //82
	new Array(1,"BhLF7xKFDf6R1BWPs6nAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //83
	new Array(1,"BhLF7xKFDf6R1BWPs2nAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //84
	new Array(1,"BhLF7xKFDf6R1BWPsCnAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //85
	new Array(1,"BhLF7xKFDf6R1BWPs:nAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //86
	new Array(1,"BhLF7xKFDf6R1BWPsKnAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //87
	new Array(1,"BhLF7xKFDf6R1BWPsGnAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //88
	new Array(1,"BhLF7xKFDf6R1BWPsWnAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //89
	new Array(1,"BhLF7xKFDf6R1BWP063BMCnBUD3CMOnBMCnBU33CMWnBMOnBMGnBMCnBMCnBU;3CMCnBMWnBMSnBMKnBMGnBM:nBM:nBMOnBManBMCnBMSnBMSnBU73CM6nBMGnBMOnBU;3CU73CMCnBU33CMGnBMGnBU73CU73CU73CMCnBMCnBMKnBMSnBU33CManBU;3C",0), //90
	new Array(1,"BhLF7xKFDf6R2BWPc2HAvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //91
	new Array(1,"BhLF7xKFDf6R2BWPUa3AvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //92
	new Array(1,"BhLF7xKFDf6R2BWPUW3AvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //93
	new Array(1,"BhLF7xKFDf6R2BWPc6HAvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //94
	new Array(1,"BhLF7xKFDf6R1BWPU33CwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //95
	new Array(1,"BhLF7xKFDf6R1BWPUD3CwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //96
	new Array(1,"BhLF7xKFDf6R1BWPU;3CwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //97
	new Array(1,"BhLF7xKFDf6R1BWP0G3BkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //98
	new Array(1,"BhLF7xKFDf6R1BWP0S3BkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //99
	new Array(1,"BhLF7xKFDf6R1BWP0O3BkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //100
	new Array(1,"BhLF7xKFDf6R1BWP0a3BkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //101
	new Array(1,"BhLF7xKFDf6R1BWP0W3BkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //102
	new Array(1,"BhLF7xKFDf6R1BWP86HBkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //103
	new Array(1,"BhLF7xKFDf6R1BWP82HBkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //104
	new Array(1,"BhLF7xKFDf6R1BWP8CHBkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //105
	new Array(1,"BhLF7xKFDf6R1BWP8:HBkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //106
	new Array(1,"BhLF7xKFDf6R1BWP8KHBwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //107
	new Array(1,"BhLF7xKFDf6R2BWPcCHAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //108
	new Array(1,"BhLF7xKFDf6R2BWPc:HAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //109
	new Array(1,"BhLF7xKFDf6R2BWPcKHAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //110
	new Array(1,"BhLF7xKFDf6R2BWPcGHAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //111
	new Array(1,"BhLF7xKFDf6R2BWPcSHAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //112
	new Array(1,"BhLF7xKFDf6R2BWPcaHAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //113
	new Array(1,"BhLF7xKFDf6R2BWPcOHAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //114
	new Array(1,"BhLF7xKFDf6R2BWPcWHAkaXAkSXAcOHAkCXAc6HAkWXAkaXA26WBl72C26WBmA38l838l038s038nA38t038p038n038k838t038mA38l038UQ38caHAkWXAkOXAc:HAkSXAcWHAkCXAkOXAkOXAcGHAc2HAd6mAO6GBt7GCl72Ct6GAl62AL62B",0), //115
	new Array(1,"BhLF7xKFDf6R2BWPkaXAwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //116
	new Array(1,"BhLF7xKFDf6R2BWPkGXAvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //117
	new Array(1,"BhLF7xKFDf6R2BWPkOXAvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //118
	new Array(1,"BhLF7xKFDf6R2BWP0K3BwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //119
	new Array(1,"BhLF7xKFDf6R2BWP0:3BvWHAt038N6GBcXHCV6XAt03826WBU23AwWHAt038t7GCc;HCX6XAt038V6WAc;HCU6XAt038F62BcbHCxWHAkA38d6mAcDHCW6XAt038d6mAc;HCvWHAt038F62Bc;HCkWHAkA38u6GAU:3AzWHAt038O6GBU:3AV6XAkA38e6mAU:3AW6XAt038:6mBU:3AuWHAkA38l62AcbHCyWHAt03816WBcPHCW6XA",0), //120
	new Array(1,"BhLF7xKFDf6R2BWPEWXBwSHAr038F62BEWXBwSHAr038d6mAM2nBlSHAq03896mBEKXBxSHAr038N6GBEKXBtOHAq038l72CESXBzSHAq038N6GBEGXBlSHAr038l62AEKXBkSHAq038l72CMCnBuSHAq03896mBEWXBxOHAtM38q038F62BM:nBzSHAq03896mBMCnBuOHAr038V6WAEKXBwSHAq03816WBEaXBvOHAr038l62AMGnB",0), //121
	new Array(1,"BhLF7xKFDf6R1BWPcWHAx6HAk03896mBcKHAv2HAk038l72Cc:HAy6HAl038t6GAUG3Ax2HAk038F62BUG3Au2HAk03816WBc6HAz6HAl038N6GBUK3Aw2HAk038N6GBUG3Ax6HAk03816WBUG3As2HAl038d6mAcGHAl6HAk03896mBcGHAv2HAl038N6GBcGHAw2HAk038t7GCcGHAw6HAl038V6WAc6HAk6HAk038l72CUW3Aw2HA",0), //122
	new Array(1,"BhLF7xKFDf6R1BWP0C3BMCnBUD3CMOnBMCnBU33CMWnBMOnBMGnBMCnBMCnBU;3CMCnBMWnBMSnBMKnBMGnBM:nBM:nBMOnBManBMCnBMSnBMSnBU73CM6nBMGnBMOnBU;3CU73CMCnBU33CMGnBMGnBU73CU73CU73CMCnBMCnBMKnBMSnBU33CManBU;3C",0), //123
	new Array(1,"BhLF7xKFDf6R1BWPsOnAx6HAk03896mBcKHAv2HAk038l72Cc:HAy6HAl038t6GAUG3Ax2HAk038F62BUG3Au2HAk03816WBc6HAz6HAl038N6GBUK3Aw2HAk038N6GBUG3Ax6HAk03816WBUG3As2HAl038d6mAcGHAl6HAk03896mBcGHAv2HAl038N6GBcGHAw2HAk038t7GCcGHAw6HAl038V6WAc6HAk6HAk038l72CUW3Aw2HA",0), //124
	new Array(1,"BhLF7xKFDf6R1BWPsanAx6HAk03896mBcKHAv2HAk038l72Cc:HAy6HAl038t6GAUG3Ax2HAk038F62BUG3Au2HAk03816WBc6HAz6HAl038N6GBUK3Aw2HAk038N6GBUG3Ax6HAk03816WBUG3As2HAl038d6mAcGHAl6HAk03896mBcGHAv2HAl038N6GBcGHAw2HAk038t7GCcGHAw6HAl038V6WAc6HAk6HAk038l72CUW3Aw2HA",0), //125

	new Array(0) //Footer
);

// rebuild 2013-02-20 14:21:45.


/* ../data/ja/Giant_common/MouthEmotion.js */
var sMouthEmotionArray = new Array(
	new Array(1,"RoKHZj6RQkKPakKOU438l72CM6GBm038l038U438l62Am62Al038n038UY38V6WAW6WAp038l038UM38k2XAcKHAt72CUY38k6XAcaHAcWHAt6GAnA38kA38k838k838l838mA38rA38p038kA38U838u7GCY6WAW6WA:6mBU72C",0), //0
	new Array(1,"RoKHZj6RQkKPakKOUA38l72CM6GBm038l038U438o62AUA38c2HAc:HAm72Cm038UA38cGHAc2HA:6mBt6GAM62BUU38m72Cl62Al72Ct7GCU038k:XAk6XAs6nAs6nAs2nAkCXAkOXAs6nAk6XAV6mAmA38n038rA38sA38",0), //1
	new Array(1,"RoKHZj6RQkKPakKOUQ38l72CM6GBm038l038U438o62AUA38c2HAc:HAm72Cm038UA38cGHAc2HA:6mBt6GAM62BUU38m72Cl62Al72Ct7GCU038k:XAk6XAs6nAs6nAs2nAkCXAkOXAs6nAk6XAV6mAmA38n038rA38sA38",0), //2
	new Array(1,"RoKHZj6RQkKPakKOlA38UY38cGHAl62AV6WAs6GAU438G62Bl038n038UY38V6WAW6WAp038l038UM38k2XAcKHAt72CUY38k6XAcaHAcWHAt6GAnA38kA38k838k838l838mA38rA38k838kA38U838u7GCV6WAe6mA:6mBU72C",0), //3
	new Array(1,"RoKHZj6RQkKPakKOsA38UY38cWHAm62Am72Cm72Cm72Co72CsA38sA38n038UY38kaXAcCHAkaXAcGHAc2HA:6mBl72CM62BUU38m72Cl62Al72Ct7GCU038k:XAk6XAs6nAs6nAs2nAkCXAkOXAs6nAk6XAV6mAmA38n038rA38sA38",0), //4
	new Array(1,"RoKHZj6RQkKPakKOqA38UY38cGHAkSXAcCHAc2HAkSXAkSXAG62B16WBt6GAU6mAqA38m038UA38cGHAc2HA:6mB16WBM62BUU38m72Cl62Al72Ct7GCU038k:XAk6XAs6nAs6nAs2nAkCXAkOXAs6nAk6XAV6mAmA38n038rA38sA38",0), //5
	new Array(1,"RoKHZj6RQkKPakKOm038UY38cGHAcCHAcCHAc2HAcGHAcCHAF62BV6WAd6mAU6mAm038m038m038p038m038UM38cCHAcKHAt72CUY38k6XAcaHAcWHAt6GAnA38kA38k838k838l838mA38rA38k838kA38U838u7GCV6WAe6mA:6mBU72C",0), //6
	new Array(1,"RoKHZj6RQkKPakKOoA38UY38cWHAkKXAcCHAc2HAkKXAkKXAG62Bl038n038UY38kKXAcCHAkKXAcGHAc2HA:6mBF62BM62BUU38m72Cl62Al72Ct7GCU038k:XAk6XAs6nAs6nAs2nAkCXAkOXAs6nAk6XAV6mAmA38n038rA38sA38",0), //7
	new Array(1,"RoKHZj6RQkKPakKOr038UY38cGHAl62AV6WAt6GA96mBA6mBr038l038n038UY38cOHAcCHAcOHAcGHAcOHA96mB96mBM62BUU38m72Cl62Al72Ct7GCU038k:XAk6XAs6nAs6nAs2nAkCXAkOXAs6nAk6XAV6mAmA38n038rA38sA38",0), //8
	new Array(1,"RoKHZj6RQkKPakKOo038UU38cGHAt6GAV6WAF62BF62BF62Bl62AF62Bd6mAU6mAo038m038o038p038l038UM38cKHAcKHAt72CUY38k6XAcaHAcWHAt6GAnA38kA38k838k838l838mA38rA38k838kA38U838u7GCV6WAe6mA:6mBU72C",0), //9
	new Array(1,"RoKHZj6RQkKPakKOpA38UY38cGHAkGXAcCHAc2HAkGXAkGXAG62BN6GBt6GAU6mApA38m038pA38p038pA38UM38kGXAcKHAt72CUY38k6XAcaHAcWHAt6GAnA38kA38k838k838l838mA38rA38k838kA38U838u7GCV6WAe6mA:6mBU72C",0), //10
	new Array(1,"RoKHZj6RQkKPakKOn038UY38cGHAc:HAcCHAc:HAc:HAc:HAF62Bd6mAd6mAU6mAn038m038m038p038n038UM38c:HAcKHAt72CUY38k6XAcaHAcWHAt6GAnA38kA38k838k838l838mA38rA38k838kA38U838u7GCV6WAe6mA:6mBU72C",0), //11
	new Array(1,"RoKHZj6RQkKPakKOm838UY38cGHAsCnAcCHAc2HAsCnAsCnAH62BV6WAt6GAU6mAUA38cCHAV6WAN6GBz6GAlA38o038UY38k7GCkA38s038t038U038u6GAe6mAn62An62An62Au6GAW6WA;6mBm62An62AUU38kCXAc:HAkOXAkaXA",0), //12
	new Array(1,"RoKHZj6RQkKPakKOn838UY38cGHAs:nAcCHAc2HAs:nAs:nAH62Bd6mAt6GAU6mAUA38cCHAV6WAN6GBz6GAlA38o038UY38k7GCkA38s038t038U038u6GAe6mAn62An62An62Au6GAW6WA;6mBm62An62AUU38kCXAc:HAkOXAkaXA",0), //13
	new Array(1,"RoKHZj6RQkKPakKOo838UY38cGHAsKnAcCHAc2HAsKnAsKnAH62BF62Bt6GAU6mAUA38cCHAV6WAN6GBz6GAlA38o038UY38k7GCkA38s038t038U038u6GAe6mAn62An62An62Au6GAW6WA;6mBm62An62AUU38kCXAc:HAkOXAkaXA",0), //14
	new Array(1,"RoKHZj6RQkKPakKOp838UY38cGHAsGnAcCHAc2HAsGnAsGnAH62BN6GBt6GAU6mAUA38cCHAV6WAN6GBz6GAlA38o038UY38k7GCkA38s038t038U038u6GAe6mAn62An62An62Au6GAW6WA;6mBm62An62AUU38kCXAc:HAkOXAkaXA",0), //15
	new Array(1,"RoKHZj6RQkKPakKOq838UY38cWHAsSnAkaXAkaXAcGHAsSnAH62B26WBl72CU6mAsA38m038sA38p038l038UM38kaXAcKHAt72CUY38k6XAcaHAcWHAt6GAnA38kA38k838k838l838mA38rA38k838kA38U838u7GCV6WAe6mA:6mBU72C",0), //16
	new Array(1,"RoKHZj6RQkKPakKOr838UY38cGHAsOnAcCHAc2HAcGHAsOnAH62B96mBt6GAU6mApA38m038UA38cGHAc2HA:6mBN6GBM62BUU38m72Cl62Al72Ct7GCU038k:XAk6XAs6nAs6nAs2nAkCXAkOXAs6nAk6XAV6mAmA38n038rA38sA38",0), //17
	new Array(1,"RoKHZj6RQkKPakKOs838UY38cGHAsanAcCHAc2HAcGHAsanAH62Bl72Cd6mAU6mAs838m038m038p038s838UM38sanAcKHAt72CUY38k6XAcaHAcWHAt6GAnA38kA38k838k838l838mA38rA38k838kA38U838u7GCV6WAe6mA:6mBU72C",0), //18
	new Array(1,"RoKHZj6RQkKPakKOt838UY38cWHAsWnAcCHAc2HAcGHAsWnAH62Bt7GCt6GAU6mAt838m038t838p038l038UM38sWnAcKHAt72CUY38k6XAcaHAcWHAt6GAnA38kA38k838k838l838mA38rA38k838kA38U838u7GCV6WAe6mA:6mBU72C",0), //19
	new Array(1,"RoKHZj6RQkKPakKOkI38UY38cGHAo62AV6WAs6GAU438G62BUQ38c:HAm72Cm038UA38cGHAc2HA:6mBt6GAM62BUU38u7GCo62At6GAt7GCU038k:XAk6XAs6nAs6nAs2nAkCXAkOXAs6nAk6XAV6mAmA38n038rA38lI38",0), //20
	new Array(1,"RoKHZj6RQkKPakKOlI38lI38p038U438cCHAc2HAk62AUI38V6WAt6GAU6mAUA38cCHAV6WAN6GBz6GAlA38o038UY38k7GCkA38lI38t038lI38U038k:XAk6XAs6nAs6nAs2nAkCXAkOXAs6nAk6XAV6mAmA38n038rA38lI38",0), //21
	new Array(1,"RoKHZj6RQkKPakKOmI38mI38p038U4380C3Bc2HAk62Ak038mI38l038n038UY38Y6WAY6WAV6WAN6GBz6GAk038r038UY380C3B0C3BcOHA023Bo72Cw6GAu6GAe6mAX6WAn62An62Au6GAW6WA96mBO6GBn62AUU38sOnAc:HAkOXA023B",0), //22
	new Array(1,"RoKHZj6RQkKPakKOnI38UY38cGHAo62AV6WAs6GAUA38u6GAl038k038UY38Y6WAG62BUI38s6nAe6mAl72CH62Bg6mAY6WAI62BN6GBl62AQ6GBt6GAnA38kA38oI38k838l838pI38rA38UI38k6XAg6mAX6WA96mBe6mA:6mBU72C",0), //23
	new Array(1,"RoKHZj6RQkKPakKOoI38UY38cGHAo62AV6WAs6GAUA38u6GAl038k038UY38Y6WAG62BUI38s6nAe6mAl72CH62Bg6mAY6WAI62BN6GBl62AQ6GBt6GAnA38kA38oI38k838l838pI38rA38UI38k6XAg6mAX6WA96mBe6mA:6mBU72C",0), //24
	new Array(1,"RoKHZj6RQkKPakKOpI38UY38cGHAo62AV6WAs6GAUA38u6GAl038k038UY38Y6WAG62BUI38s6nAe6mAl72CH62Bg6mAY6WAI62BN6GBl62AQ6GBt6GAnA38kA38oI38k838l838pI38rA38UI38k6XAg6mAX6WA96mBe6mA:6mBU72C",0), //25
	new Array(1,"RoKHZj6RQkKPakKOpM38nY38oE38qY38rY38qY38qY38qY38oE38pE38qY38rE38nY38qY38qY38rY38oE38qY38qY38oE38pE38nY38rY38pE38pE38tM38oE38oE38oE38pE38pE38pE38oY38pE38oY38nY38sE38rY38qY38rY38rY38oY38kM38qY38",0), //26
	new Array(1,"RoKHZj6RQkKPakKOqM38nY38oE38qY38rY38qY38qY38qY38oE38pE38qY38rE38nY38qY38qY38rY38oE38qY38qY38oE38pE38nY38rY38pE38pE38tM38oE38oE38oE38pE38pE38pE38oY38pE38oY38nY38sE38rY38qY38rY38rY38oY38kM38qY38",0), //27
	new Array(1,"RoKHZj6RQkKPakKOrM38nY38oE38qY38rY38qY38qY38qY38oE38pE38qY38rE38nY38qY38qY38rY38oE38qY38qY38oE38pE38nY38rY38pE38pE38tM38oE38oE38oE38pE38pE38pE38oY38pE38oY38nY38sE38rY38qY38rY38rY38oY38kM38qY38",0), //28
	new Array(1,"RoKHZj6RQkKPakKOsM38nY38oE38qY38rY38qY38qY38qY38oE38pE38qY38rE38nY38qY38qY38rY38oE38qY38qY38oE38pE38nY38rY38pE38pE38tM38oE38oE38oE38pE38pE38pE38oY38pE38oY38nY38sE38rY38qY38rY38rY38oY38kM38qY38",0), //29
	new Array(1,"RoKHZj6RQkKPakKOtM38nY38oE38qY38rY38qY38qY38qY38oE38pE38qY38rE38nY38qY38qY38rY38oE38qY38qY38oE38pE38nY38rY38pE38pE38tM38oE38oE38oE38pE38pE38pE38oY38pE38oY38nY38sE38rY38qY38rY38rY38oY38kM38qY38",0), //30
	new Array(1,"RoKHZj6RQkKPakKOoQ38sQ38nM38rQ38sQ38oM38oQ38qQ38nM38lM38oQ38oM38sQ38sQ38qQ38qQ38nM38nM38oM38nM38tQ38oQ38tQ38lM38sQ38oM38mM38oM38nM38kM38nM38nM38oM38oQ38lM38qQ38nM38qQ38oM38qQ38lM38pQ38kM38rQ38",0), //31
	new Array(1,"RoKHZj6RQkKPakKOpQ38sQ38nM38rQ38sQ38oM38oQ38qQ38nM38lM38oQ38oM38sQ38sQ38qQ38qQ38nM38nM38oM38nM38tQ38oQ38tQ38lM38sQ38oM38mM38oM38nM38kM38nM38nM38oM38oQ38lM38qQ38nM38qQ38oM38qQ38lM38pQ38kM38rQ38",0), //32
	new Array(1,"RoKHZj6RQkKPakKOqQ38sQ38nM38rQ38sQ38oM38oQ38qQ38nM38lM38oQ38oM38sQ38sQ38qQ38qQ38nM38nM38oM38nM38tQ38oQ38tQ38lM38sQ38oM38mM38oM38nM38kM38nM38nM38oM38oQ38lM38qQ38nM38qQ38oM38qQ38lM38pQ38kM38rQ38",0), //33
	new Array(1,"RoKHZj6RQkKPakKOrQ38sQ38nM38rQ38sQ38oM38oQ38qQ38nM38lM38oQ38oM38sQ38sQ38qQ38qQ38nM38nM38oM38nM38tQ38oQ38tQ38lM38sQ38oM38mM38oM38nM38kM38nM38nM38oM38oQ38lM38qQ38nM38qQ38oM38qQ38lM38pQ38kM38rQ38",0), //34
	new Array(1,"RoKHZj6RQkKPakKOqI38UY38cGHAl62AV6WAs6GAU438c6HAV6WAt6GAU6mAUA38cCHAV6WAN6GBz6GAlA38o038UY38k7GCkA38s038t038U038u6GAe6mAn62An62An62Au6GAW6WA96mBO6GBn62AUU38kCXA0C3BkOXAkaXA",0), //35
	new Array(1,"RoKHZj6RQkKPakKOrI38UY38cGHAl62AV6WAs6GAU438c6HAV6WAt6GAU6mAUA38cCHAV6WAN6GBz6GAlA38o038UY38k7GCkA38s038t038U038u6GAe6mAn62An62An62Au6GAW6WA96mBO6GBn62AUU38kCXA0C3BkOXAkaXA",0), //36
	new Array(1,"RoKHZj6RQkKPakKOkY38UY38cGHAl62AV6WAs6GAU438c6HAV6WAt6GAU6mAUA38cCHAV6WAN6GBz6GAlA38o038UY38k7GCkA38s038t038U038u6GAe6mAn62An62An62Au6GAW6WA96mBO6GBn62AUU38kCXA0C3BkOXAkaXA",0), //37
	new Array(1,"RoKHZj6RQkKPakKOlY38UY38cGHAl62AV6WAs6GAU438c6HAV6WAt6GAU6mAUA38cCHAV6WAN6GBz6GAlA38o038UY38k7GCkA38s038t038U038u6GAe6mAn62An62An62Au6GAW6WA96mBO6GBn62AUU38kCXA0C3BkOXAkaXA",0), //38
	new Array(1,"RoKHZj6RQkKPakKOmY38UY38cGHAl62AV6WAs6GAU438c6HAV6WAt6GAU6mAUA38cCHAV6WAN6GBz6GAlA38o038UY38k7GCkA38s038t038U038u6GAe6mAn62An62An62Au6GAW6WA96mBO6GBn62AUU38kCXA0C3BkOXAkaXA",0), //39
	new Array(1,"RoKHZj6RQkKPakKOsY38UY38cGHAl62AV6WAs6GAU438c6HAV6WAt6GAU6mAUA38cCHAV6WAN6GBz6GAlA38o038UY38k7GCkA38s038t038U038u6GAe6mAn62An62An62Au6GAW6WA96mBO6GBn62AUU38kCXA0C3BkOXAkaXA",0), //40
	new Array(1,"RoKHZj6RQkKPakKOoU38UY38cGHAl62AV6WAs6GAU438c6HAV6WAt6GAU6mAUA38cCHAV6WAN6GBz6GAlA38o038UY38k7GCkA38s038t038U038u6GAe6mAn62An62An62Au6GAW6WA96mBO6GBn62AUU38kCXA0C3BkOXAkaXA",0), //41
	new Array(1,"RoKHZj6RQkKPakKOqU38sQ38nM38rQ38sQ38oM38oQ38qQ38nM38lM38oQ38oM38sQ38sQ38qQ38qQ38nM38nM38oM38nM38tQ38oQ38tQ38lM38sQ38oM38mM38oM38nM38kM38nM38nM38oM38oQ38lM38qQ38nM38qQ38oM38qQ38lM38pQ38kM38rQ38",0), //42

	new Array(0) //Footer
);

// rebuild 2013-02-20 14:21:45.


/* ../data/ja/Giant_common/Reaction.js */
var sReactionArray = new Array(
	new Array(1,"tdqEJEaP7xKFDf6R0BWPU438"), //0
	new Array(1,"tdqEJEaP7xKFDf6R1BWPU038"), //1
	new Array(1,"tdqEJEaP7xKFDf6R2BWPUA38"), //2
	new Array(1,"tdqEJEaP7xKFDf6R3BWPU838"), //3
	new Array(1,"tdqEJEaP7xKFDf6R4BWPUI38"), //4
	new Array(1,"tdqEJEaP7xKFDf6R5BWPUE38"), //5
	new Array(1,"tdqEJEaP7xKFDf6R6BWPUQ38"), //6
	new Array(1,"tdqEJEaP7xKFDf6R7BWPUM38"), //7
	new Array(1,"tdqEJEaP7xKFDf6R8BWPUY38"), //8
	new Array(1,"tdqEJEaP7xKFDf6R9BWPUU38"), //9
	new Array(1,"tdqEJEaP7xKFDf6R1BWPl62AU62A"), //10
	new Array(1,"tdqEJEaP7xKFDf6R1BWPt6GAc6GA"), //11
	new Array(1,"tdqEJEaP7xKFDf6R1BWPV6WAk6WA"), //12
	new Array(1,"tdqEJEaP7xKFDf6R1BWPd6mAs6mA"), //13
	new Array(1,"tdqEJEaP7xKFDf6R1BWPF62B062B"), //14
	new Array(1,"tdqEJEaP7xKFDf6R1BWPN6GB86GB"), //15
	new Array(1,"tdqEJEaP7xKFDf6R1BWP16WBE6WB"), //16
	new Array(1,"tdqEJEaP7xKFDf6R1BWP96mBM6mB"), //17
	new Array(1,"tdqEJEaP7xKFDf6R1BWPl72CU72C"), //18
	new Array(1,"tdqEJEaP7xKFDf6R1BWPt7GCc7GC"), //19
	new Array(1,"tdqEJEaP7xKFDf6R2BWPm62AU62A"), //20
	new Array(1,"tdqEJEaP7xKFDf6R2BWPu6GAc6GA"), //21
	new Array(1,"tdqEJEaP7xKFDf6R2BWPW6WAk6WA"), //22
	new Array(1,"tdqEJEaP7xKFDf6R2BWPe6mAs6mA"), //23
	new Array(1,"tdqEJEaP7xKFDf6R2BWPG62B062B"), //24
	new Array(1,"tdqEJEaP7xKFDf6R2BWPO6GB86GB"), //25
	new Array(1,"tdqEJEaP7xKFDf6R2BWP26WBE6WB"), //26
	new Array(1,"tdqEJEaP7xKFDf6R2BWP:6mBM6mB"), //27
	new Array(1,"tdqEJEaP7xKFDf6R2BWPm72CU72C"), //28
	new Array(1,"tdqEJEaP7xKFDf6R2BWPu7GCc7GC"), //29
	new Array(1,"tdqEJEaP7xKFDf6R3BWPn62AU62A"), //30
	new Array(1,"tdqEJEaP7xKFDf6R3BWPv6GAc6GA"), //31
	new Array(1,"tdqEJEaP7xKFDf6R3BWPX6WAk6WA"), //32
	new Array(1,"tdqEJEaP7xKFDf6R3BWPf6mAs6mA"), //33
	new Array(1,"tdqEJEaP7xKFDf6R3BWPH62B062B"), //34
	new Array(1,"tdqEJEaP7xKFDf6R3BWPP6GB86GB"), //35
	new Array(1,"tdqEJEaP7xKFDf6R3BWP36WBE6WB"), //36
	new Array(1,"tdqEJEaP7xKFDf6R3BWP;6mBM6mB"), //37
	new Array(1,"tdqEJEaP7xKFDf6R3BWPn72CU72C"), //38
	new Array(1,"tdqEJEaP7xKFDf6R3BWPv7GCc7GC"), //39
	new Array(1,"tdqEJEaP7xKFDf6R4BWPo62AU62A"), //40
	new Array(1,"tdqEJEaP7xKFDf6R4BWPw6GAc6GA"), //41
	new Array(1,"tdqEJEaP7xKFDf6R4BWPY6WAk6WA"), //42
	new Array(1,"tdqEJEaP7xKFDf6R4BWPg6mAs6mA"), //43

	new Array(0) //Footer
);
/* ../data/ja/Giant_common/EyeColor.js */
var sEyeColorArray = new Array(
	new Array("1","3:XBd4nE","633C31"), //0
	new Array("1","n63AVWnA","003399"), //1
	new Array("1","V2XAV4nE","211C39"), //2
	new Array("1","k63AtW3A","000099"), //3
	new Array("1","c:nAk63A","330000"), //4
	new Array("1","0SXBqS3A","660066"), //5
	new Array("1","Q2IBXd3F","5A4D8C"), //6
	new Array("1","dEnEE63B","C61400"), //7
	new Array("1","k63Ak63A","000000"), //8
	new Array("1","q63A06XB","006600"), //9
	new Array("1","jEnEl:HA","C67139"), //10
	new Array("1","IC3BPSHB","424563"), //11
	new Array("1","fWnAt;3C","393839"), //12
	new Array("1","f:nAc6nA","333300"), //13
	new Array("1","sXHCk63A","990000"), //14
	new Array("1","n63Af:nA","003333"), //15
	new Array("1","yXHC6SXB","996666"), //16
	new Array("1","lXHCyTHC","999966"), //17
	new Array("1","q63A6SXB","006666"), //18
	new Array("1","6SXB6SXB","666666"), //19
	new Array("1","9EYFs7HC","FF9900"), //20
	new Array("1","0CoBABIE","7B8AAD"), //21
	new Array("1",";WHCP5oE","99CCCC"), //22
	new Array("1","NRoEABIE","CEAAAD"), //23
	new Array("1","jEnE9KHC","C6794A"), //24
	new Array("1","lXHC;:IC","9999CC"), //25
	new Array("1","i4oE06XB","CC6600"), //26
	new Array("1","9SXB;:IC","6699CC"), //27
	new Array("1","t63AyTHC","009966"), //28
	new Array("1","V:nA;:IC","3399CC"), //29
	new Array("1","nTXBVgnE","66CC99"), //30
	new Array("1","f4oEiSnA","CC3366"), //31
	new Array("1","t63ACSIC","0099FF"), //32
	new Array("1","x;ICGM3F","9C5D42"), //33
	new Array("1","cQXE:JHE","B58A7B"), //34

	new Array("0") //Footer
);
/* ../data/ja/Giant_common/HairColor.js */
var sHairColorArray = new Array(
	new Array("1","k63Ak63A","000000"), //0
	new Array("1","V2XAV4nE","211C39"), //1
	new Array("1","IC3BPSHB","424563"), //2
	new Array("1","Q2IBXd3F","5A4D8C"), //3
	new Array("1","0CoBABIE","7B8AAD"), //4
	new Array("1","9NIES4IF","ADAEC6"), //5
	new Array("1","hJHFSToA","E7E3FF"), //6
	new Array("1","qFYFPbnA","FFF38C"), //7
	new Array("1","FEIFWGXA","EF9252"), //8
	new Array("1","jEnEl:HA","C67139"), //9
	new Array("1","dEnEE63B","C61400"), //10
	new Array("1",":CoBcAnE","7B2C10"), //11
	new Array("1","fWnAt;3C","393839"), //12
	new Array("1","c:nAk63A","330000"), //13
	new Array("1","3SXBc6nA","663300"), //14
	new Array("1","V4oEv;HC","CC9933"), //15
	new Array("1","lXHClXHC","999999"), //16
	new Array("1","yXHC6SXB","996666"), //17
	new Array("1","x;ICGM3F","9C5D42"), //18
	new Array("1","f:nAc6nA","333300"), //19
	new Array("1","i:nA6SXB","336666"), //20
	new Array("1","yXHC06XB","996600"), //21
	new Array("1","qFYFn5YF","FFFFCC"), //22
	new Array("1","nFYFiEnE","FFCC66"), //23
	new Array("1","sXHCn:3A","990033"), //24
	new Array("1","6SXB6SXB","666666"), //25
	new Array("1","n63Ac6nA","003300"), //26
	new Array("1","P5oEiEnE","CCCC66"), //27
	new Array("1","qFYF6EXF","FFFF66"), //28
	new Array("1","nFYFf4nE","FFCC33"), //29
	new Array("1","P5oEVgnE","CCCC99"), //30
	new Array("1","lXHClXHC","999999"), //31
	new Array("1","bMYEF03F","BD7D21"), //32
	new Array("1","oFYFBCoB","FFD7B5"), //33
	new Array("1","9SXBCSIC","6699FF"), //34
	new Array("1","c4oEk63A","CC0000"), //35
	new Array("1","S5oEn5YF","CCFFCC"), //36
	new Array("1",";WHCSFoE","99CCFF"), //37
	new Array("1","9EYFlXHC","FF9999"), //38
	new Array("1","9EYFv;HC","FF9933"), //39
	new Array("1","CWHC9gXF","99FF99"), //40
	new Array("1","P5oESFoE","CCCCFF"), //41
	new Array("1","qFYFqFYF","FFFFFF"), //42
	new Array("1","6EYFn;YB","FF66CC"), //43
	new Array("1","3SXBf:nA","663333"), //44
	new Array("1","V4oElXHC","CC9999"), //45

	new Array(0) //Footer
);

// rebuild 2013-02-20 14:21:45.


/* ../data/ja/Giant_common/SkinColor.js */
var sSkinColorArray = new Array(
	new Array("1","pJXFqFYF","F7EFFF"), //0
	new Array("1","qJXFRLoA","F7F3DE"), //1
	new Array("1","hFIFhCoA","EFE3B5"), //2
	new Array("1","pFYFhCoA","FFE3B5"), //3
	new Array("1","oFYFBCoB","FFD7B5"), //4
	new Array("1","nFYFC:oB","FFC7C6"), //5
	new Array("1","NRoEABIE","CEAAAD"), //6
	new Array("1","cQXE:JHE","B58A7B"), //7
	new Array("1","9NIExAIE","ADAAA5"), //8
	new Array("1","x;ICGM3F","9C5D42"), //9
	new Array("1","jEnE9KHC","C6794A"), //10
	new Array("1","3:XBd4nE","633C31"), //11

	new Array("0") //Footer
);
/* ../data/ja/Giant_common/WeaponAndShield.js */
var sShieldArray = new Array(
	new Array(1,"Dn6R9k5PlfaQxzqQPBLNZc6OCR6Pbv6Q","0"), //0
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLM3kZPZc6O1Q6Pi23Abv6Q","0"), //1
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLM3kZPZc6O2Q6Pi23Abv6Q","0"), //2
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPfvpAwqKSoM6Ov0KOZc6OER6PszGA8FKP","0"), //3
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMLkZPU1KMkAHML7HAi:3Abv6Q","0"), //4
	new Array(1,"NhqFjQbPRNaNhxKMLOrLbwqPi86O3d7NLtKMnlqMMpGN8FKP","0"), //5
	new Array(1,"NdqNjQbPNPqRin6QD6rLQ4rPi23Abv6Q","0"), //6
	new Array(1,"NdqNjQbPNPqRin6QD6rLQ4rPiC3Abv6Q","0"), //7
	new Array(1,"NdqNjQbPNPqRin6QLyqLtraQ3EaPG;6Ri23Abv6Q","0"), //8
	new Array(1,"NdqNjQbPNPqRin6QNeqLBsKPVCXQR4b;MAmN","0"), //9
	new Array(1,"NdqNjQbPNPqRin6QNeqLBsKPWCXQR4b;MAmN","0"), //10
	new Array(1,"NdqNjQbPNPqRin6Q0CqLNAHNR4b;MAmN","0"), //11
	new Array(1,"NdqNjQbPNPqRin6Q0CqLOAHNR4b;MAmN","0"), //12
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMvkZPHMbPxwqOi23Abv6Q","0"), //13
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMvkZPHMbPxwqOiC3Abv6Q","0"), //14
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMFkZP1z6REy6RszGA8FKP","0"), //15
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMFkZP1z6REy6RUzWA8FKP","0"), //16
	new Array(1,"NdqNjQbPNPqRin6Q:OrLMMKNszGA8FKP","0"), //17
	new Array(1,"NPqRin6QPiqLT1LNQ4rPiC3Abv6Q","0"), //18
	new Array(1,"NPqRin6QPiqLT1LNQ4rPi23Abv6Q","0"), //19
	new Array(1,"NdqNjQbPNPqRin6QPiqL71KNBM7P1BXPR4b;MAmN","0"), //20
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMGkZPCM7PFC3RR4b;MAmN","0"), //21
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMRkZPZtKMEQrPrLrIUSaQszGA8FKP","0"), //22
	new Array(1,"NdqNjQbPNPqRin6QN6qL1D7RCt6Pbv6Q","0"), //23
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPkP6Q75LNi23Abv6Q","0"), //24
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPkP6Q75LNiC3Abv6Q","0"), //25
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPkP6Q75LNi:3Abv6Q","0"), //26
	new Array(1,"NdqNjQbPDn6R2k5PYxKMw0LOskJMszGA8FKP","0"), //27
	new Array(1,"NPqRin6Q:2qL2oqPT1LNQ4rPi23Abv6Q","0"), //28
	new Array(1,"NPqRin6QL6qLJQbP7TrQi23Abv6Q","0"), //29
	new Array(1,"NPqRin6QL6qLJQbP7TrQiC3Abv6Q","0"), //30
	new Array(1,"NPqRin6QL6qLJQbP7TrQi:3Abv6Q","0"), //31
	new Array(1,"NPqRin6QL6qLJQbP7TrQiK3Abv6Q","0"), //32
	new Array(1,"NdqNjQbPNPqRin6QBOqLt3rQcUqMszGA8FKP","0"), //33
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMFkZP1z6REy6RczmA8FKP","0"), //34
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMRkZPh1KMiC3Abv6Q","0"), //35
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMKkZPB86PWNaM8MqNszGA8FKP","0"), //36
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMPkZPHMbPxwqOi:3Abv6Q","0"), //37
	new Array(1,"NPqRin6Q:6nL1l5NNoaP2PaRe;qQtDHSR4b;MAmN","0"), //38
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMFkZP806PFtKNrjqQFC3RR4b;MAmN","0"), //39
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPfvpAwqKSoM6Ov0KO:nqRFA3NR4b;MAmN","0"), //40
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPfvpAwqKSoM6Ov0KO:nqRGA3NR4b;MAmN","0"), //41
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPpvpAKkqPrHrQySaQbv6Q","0"), //42
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMFkZP806PFtKNrjqQGC3RR4b;MAmN","0"), //43
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMFkZP806PFtKNrjqQHC3RR4b;MAmN","0"), //44
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMFkZP806PFtKNrjqQIC3RR4b;MAmN","0"), //45
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMFkZP806PFtKNrjqQJC3RR4b;MAmN","0"), //46
	new Array(1,"Dn6R3k5PovpAfpKMNAHNR4b;MAmN","0"), //47
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMLkZPU1KMkAHMLDHAhoqOoVqMMpGN8FKP","0"), //48
	new Array(1,"NdqNjQbPNPqRin6QD6rLQ4rPT33A7FKNR4b;MAmN","0"), //49
	new Array(1,"NdqNjQbPNPqRin6QD6rLQ4rPTD3A7FKNR4b;MAmN","0"), //50
	new Array(1,"NdqNjQbPNPqRin6QLyqLtraQ3EaPG;6RT33A7FKNR4b;MAmN","0"), //51
	new Array(1,"NdqNjQbPNPqRin6QNeqLBsKPVCXQTSqL8omP8FKP","0"), //52
	new Array(1,"NdqNjQbPNPqRin6QNeqLBsKPWCXQTSqL8omP8FKP","0"), //53
	new Array(1,"NdqNjQbPNPqRin6Q0CqLNAHNTSqL8omP8FKP","0"), //54
	new Array(1,"NdqNjQbPNPqRin6Q0CqLOAHNTSqL8omP8FKP","0"), //55
	new Array(1,"NPqRin6QL6qLJQbP7TrQT33A7FKNR4b;MAmN","0"), //56
	new Array(1,"NPqRin6QL6qLJQbP7TrQTD3A7FKNR4b;MAmN","0"), //57
	new Array(1,"NPqRin6QL6qLJQbP7TrQT;3A7FKNR4b;MAmN","0"), //58
	new Array(1,"NPqRin6QL6qLJQbP7TrQTL3A7FKNR4b;MAmN","0"), //59
	new Array(1,"NdqNjQbPDn6RGk5PKFrPbv6Q","0"), //60
	new Array(1,"NdqNjQbPDn6R4k5Pr;aQboqPljqQmn5QKFrPbv6Q","0"), //61
	new Array(1,"Dn6RHk5P7cqOgn6QNAHNR4b;MAmN","0"), //62
	new Array(1,"NPqRin6QNKqLthqMla3AZvZAO4KP4xKNspGM8FKP","0"), //63
	new Array(1,"NPqRin6QNKqLthqMla3AovZAQ3LR64LNbv6Q","0"), //64
	new Array(1,"NPqRin6QNKqLthqMla3AYvZAKdrPbv6Q","0"), //65
	new Array(1,"NPqRin6QNKqLthqMkW3AuuJCe5KMaRLObv6Q","-1"), //66
	new Array(1,"NPqRin6Q:KqLQ9KNDOrLNgqP3QaP:nqREp2N8FKP","-1"), //67
	new Array(1,"Dn6R3k5P:vpAIwqPjoKOij6Ii23Abv6Q","-1"), //68
	new Array(1,"Dn6RCk5PApKNtnaQ7l5NwIKOi23Abv6Q","-1"), //69
	new Array(1,"NPqRin6QN6qL9QaPq9qMMpGN8FKP","0"), //70
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP71nM2daN7FLNNQqPkq2S8FKP","0"), //71
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP71nMi86OAB7NhpKMUrWQ8FKP","0"), //72
	new Array(1,"Dn6R7k5Pa8KO6n5R9tKNzM6P71nM2P7RspGM8FKP","0"), //73
	new Array(1,"NhqFjQbPRNaNhxKMLOrLbwqPkP7QoP6QK3oLbv6Q","0"), //74
	new Array(1,"NhqFjQbPRNaNhxKMLOrLbwqPkP7QoP6QKDoLbv6Q","0"), //75
	new Array(1,"NPqRin6QLKqL5R6Nc2rQszGA8FKP","0"), //76
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPh0KOx5rMssKMszGA8FKP","0"), //77
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPBN7Ndz6Q0FaPszGA8FKP","0"), //78
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPt5rMxVqMVCXQR4b;MAmN","0"), //79
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPtTrQl3aQ9QaPi23Abv6Q","0"), //80
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPwnaQ106PcNqOszGA8FKP","0"), //81
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPrlqMxcqOi23Abv6Q","0"), //82
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPgvpARErPd3aQCc6PGN6Ni23Abv6Q","0"), //83
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPyvpAfxKMdRLMi23Abv6Q","0"), //84
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP71nMF5bNN0aPt3qQR4b;MAmN","0"), //85
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPkvpAUEKOC86PGN6NtxqMbuKSUOaQszGA8FKP","0"), //86
	new Array(1,"NdqNjQbPNPqRin6QA7qLNeqLBwKP6n5Rh4LOrHrQUSaQUzWA8FKP","0"), //87
	new Array(1,"NdqNjQbPDn6R3k5P2v5BwRLMBM6PgpKMFwqP1BXPR4b;MAmN","0"), //88
	new Array(1,"NdqNjQbPNPqRin6QA7qLD6rLQ4rPi23Abv6Q","0"), //89
	new Array(1,"NdqNjQbPNPqRin6QA7qLD6rLQ4rPi23Abv6Q","0"), //90
	new Array(1,"NdqNjQbPNPqRin6QA7qLD6rLQ4rPiC3Abv6Q","0"), //91
	new Array(1,"NdqNjQbPNPqRin6QA7qLA6rLiJKMi23Abv6Q","0"), //92
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPtvpA806PFtKNrjqQ6n5Rh4LOi23Abv6Q","0"), //93
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPtvpA806PFtKNrjqQ5n5Rw5LMlB3OR4b;MAmN","0"), //94
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPtvpA806PFtKNrjqQLn5RgoKOi23Abv6Q","0"), //95
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPtvpA806PFtKNrjqQLn5RhRLMVCXQR4b;MAmN","0"), //96
	new Array(1,"NdqNjQbPDAbOfxKMhM6Ow0LOIqqLVILOr5LNrHrQUSaQszGA8FKP","0"), //97
	new Array(1,"NdqNjQbPDn6R1k5P806P1tKN7TrQtDrQJoaPVCXQR4b;MAmN","0"), //98
	new Array(1,"NdqNjQbPDn6REk5PMDLRrRLNynaQtAHMR4b;MAmN","0"), //99
	new Array(1,"NdqNjQbPDn6REk5PMDLRrRLNi;6QR4b;MAmN","0"), //100
	new Array(1,"NdqNjQbPNPqRin6QA7qLLOrLh6KSs4LMszGA8FKP","0"), //101
	new Array(1,"NdqNjQbPNPqRin6QNWqLi;6QBCrLYwKOiP6Qi23Abv6Q","0"), //102
	new Array(1,"NdqNjQbPDn6R3k5P6v5Bh4LOK;qR:l5Nkr2Q8FKP","0"), //103
	new Array(1,"NdqNjQbPDn6R:k5PdBLMNkZPcMqMszGA8FKP","0"), //104
	new Array(1,"NdqNjQbPDn6R:k5PdBLMQkZPUEKO9r6R0FaPszGA8FKP","0"), //105
	new Array(1,"NdqNjQbPNPqRin6QA7qLE6rLYMKOFA3NR4b;MAmN","0"), //106
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP7RnMn9aMtArOcUqMszGA8FKP","0"), //107
	new Array(1,"NdqNjQbPDn6R3k5PEv5BMDLRrRLNOkKPrfaQi86OR4b;MAmN","0"), //108
	new Array(1,"NdqNjQbPDn6R3k5PEv5BMDLRrRLNvdqMgk6OR4b;MAmN","0"), //109
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPgvpAj5LM01LNgwKOi23Abv6Q","0"), //110
	new Array(1,"NdqNjQbPNPqRin6QA7qLA6rLiJKMi:3Abv6Q","0"), //111
	new Array(1,"NdqNjQbPNPqRin6QA7qLE6rLYMKOIA3NR4b;MAmN","3"), //112
	new Array(1,"NdqNjQbPNPqRin6QA7qLF6rLoVqMNAHNR4b;MAmN","0"), //113
	new Array(1,"NdqNjQbPNPqRin6QA7qLF6rLoVqMOAHNR4b;MAmN","0"), //114
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZP;v5BHMbPxwqOi23Abv6Q","0"), //115
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZP;v5BHMbPxwqOiC3Abv6Q","0"), //116
	new Array(1,"NdqNjQbPDn6R3k5PEv5BYwKO8FrPszGA8FKP","0"), //117
	new Array(1,"NdqNjQbPDn6R3k5PEv5BYwKO8FrPUzWA8FKP","0"), //118
	new Array(1,"NdqNjQbP6kKPA7qL:OrLIwqPR6rLzlJMM9KNKpqPbv6Q","0"), //119
	new Array(1,"NdqNjQbP6kKPA7qL:OrLIwqPLGqLXPaQLn5RM9KNKpqPbv6Q","0"), //120
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNtAHMI6qLR0rPR4b;MAmN","0"), //121
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNvAHMI6qLR0rPR4b;MAmN","0"), //122
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNuAHMI6qLR0rPR4b;MAmN","0"), //123
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNwlJMzdKMLpKMrxqMqOqQbv6Q","0"), //124
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNxlJM7;qQrxqMqOqQbv6Q","0"), //125
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNWlJMdBLMHkZPHk6PMpGN8FKP","0"), //126
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNslJMgpKMflJMHk6PMpGN8FKP","0"), //127
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNwAHMI6qLR0rPR4b;MAmN","0"), //128
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNxAHMI6qLR0rPR4b;MAmN","0"), //129
	new Array(1,"NdqNjQbPNPqRin6QA7qLE6qLQNKNihKMAkqPR4b;MAmN","0"), //130
	new Array(1,"NdqNjQbPDn6R3k5P4v5BlPaQ90KP836Rr5LNi:3Abv6Q","0"), //131
	new Array(1,"NdqNjQbPDn6R3k5P4v5BlPaQ90KP836Rr5LNiC3Abv6Q","0"), //132
	new Array(1,"NdqNjQbPDn6R3k5P4v5BlPaQ90KP836R64LNbv6Q","0"), //133
	new Array(1,"NdqNjQbPNPqRin6QA7qLN:rLD6rLQ4rPR4b;MAmN","0"), //134
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPIv5BLpKMhoqOoVqMMpGN8FKP","0"), //135
	new Array(1,"NdqNjQbPNPqRin6QA7qLNeqLbTaQgpKMiC3Abv6Q","0"), //136
	new Array(1,"NdqNjQbPNPqRin6QA7qLNeqLbTaQgpKMi23Abv6Q","0"), //137
	new Array(1,"NdqNjQbPNPqRin6QA7qLNeqLbTaQgpKMR4b;MAmN","0"), //138
	new Array(1,"NdqNjQbPDn6R3k5P5v5B3M6PFNrNG;6RR4b;MAmN","0"), //139

	new Array(0) //Footer
);

// rebuild 2013-02-20 14:21:46.


/* ../data/ja/Giant_common/Weapon.js */
var sWeaponArray = new Array(
	new Array(1,"NhqFjQbPRNaNhxKMLOrLbwqPi86O3d7NLtKMnlqMMpGN8FKP","0"), //0
	new Array(1,"NdqNjQbPNPqRin6QD6rLQ4rPi23Abv6Q","0"), //1
	new Array(1,"NdqNjQbPNPqRin6QD6rLQ4rPiC3Abv6Q","0"), //2
	new Array(1,"NdqNjQbPNPqRin6QLyqLtraQ3EaPG;6Ri23Abv6Q","0"), //3
	new Array(1,"NdqNjQbPNPqRin6QNeqLBsKPVCXQR4b;MAmN","0"), //4
	new Array(1,"NdqNjQbPNPqRin6QNeqLBsKPWCXQR4b;MAmN","0"), //5
	new Array(1,"NdqNjQbPNPqRin6Q0CqLNAHNR4b;MAmN","0"), //6
	new Array(1,"NdqNjQbPNPqRin6Q0CqLOAHNR4b;MAmN","0"), //7
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMvkZPHMbPxwqOi23Abv6Q","0"), //8
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMvkZPHMbPxwqOiC3Abv6Q","0"), //9
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMFkZP1z6REy6RszGA8FKP","0"), //10
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMFkZP1z6REy6RUzWA8FKP","0"), //11
	new Array(1,"NdqNjQbPNPqRin6Q:OrLMMKNszGA8FKP","0"), //12
	new Array(1,"NPqRin6QPiqLT1LNQ4rPiC3Abv6Q","0"), //13
	new Array(1,"NPqRin6QPiqLT1LNQ4rPi23Abv6Q","0"), //14
	new Array(1,"NdqNjQbPNPqRin6QPiqL71KNBM7P1BXPR4b;MAmN","0"), //15
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMGkZPCM7PFC3RR4b;MAmN","0"), //16
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMRkZPZtKMEQrPrLrIUSaQszGA8FKP","0"), //17
	new Array(1,"NdqNjQbPNPqRin6QN6qL1D7RCt6Pbv6Q","0"), //18
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPkP6Q75LNi23Abv6Q","0"), //19
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPkP6Q75LNiC3Abv6Q","0"), //20
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPkP6Q75LNi:3Abv6Q","0"), //21
	new Array(1,"NdqNjQbPDn6R2k5PYxKMw0LOskJMszGA8FKP","0"), //22
	new Array(1,"NPqRin6Q:2qL2oqPT1LNQ4rPi23Abv6Q","0"), //23
	new Array(1,"NPqRin6QL6qLJQbP7TrQi23Abv6Q","0"), //24
	new Array(1,"NPqRin6QL6qLJQbP7TrQiC3Abv6Q","0"), //25
	new Array(1,"NPqRin6QL6qLJQbP7TrQi:3Abv6Q","0"), //26
	new Array(1,"NPqRin6QL6qLJQbP7TrQiK3Abv6Q","0"), //27
	new Array(1,"NdqNjQbPNPqRin6QBOqLt3rQcUqMszGA8FKP","0"), //28
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMFkZP1z6REy6RczmA8FKP","0"), //29
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMRkZPh1KMiC3Abv6Q","0"), //30
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMKkZPB86PWNaM8MqNszGA8FKP","0"), //31
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMPkZPHMbPxwqOi:3Abv6Q","0"), //32
	new Array(1,"NPqRin6Q:6nL1l5NNoaP2PaRe;qQtDHSR4b;MAmN","0"), //33
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMFkZP806PFtKNrjqQFC3RR4b;MAmN","0"), //34
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPfvpAwqKSoM6Ov0KO:nqRFA3NR4b;MAmN","0"), //35
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPfvpAwqKSoM6Ov0KO:nqRGA3NR4b;MAmN","0"), //36
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPpvpAKkqPrHrQySaQbv6Q","0"), //37
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMFkZP806PFtKNrjqQGC3RR4b;MAmN","0"), //38
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMFkZP806PFtKNrjqQHC3RR4b;MAmN","0"), //39
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMFkZP806PFtKNrjqQIC3RR4b;MAmN","0"), //40
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMFkZP806PFtKNrjqQJC3RR4b;MAmN","0"), //41
	new Array(1,"Dn6R3k5PovpAfpKMNAHNR4b;MAmN","0"), //42
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMLkZPU1KMkAHMLDHAhoqOoVqMMpGN8FKP","0"), //43
	new Array(1,"NdqNjQbPNPqRin6QD6rLQ4rPT33A7FKNR4b;MAmN","0"), //44
	new Array(1,"NdqNjQbPNPqRin6QD6rLQ4rPTD3A7FKNR4b;MAmN","0"), //45
	new Array(1,"NdqNjQbPNPqRin6QLyqLtraQ3EaPG;6RT33A7FKNR4b;MAmN","0"), //46
	new Array(1,"NdqNjQbPNPqRin6QNeqLBsKPVCXQTSqL8omP8FKP","0"), //47
	new Array(1,"NdqNjQbPNPqRin6QNeqLBsKPWCXQTSqL8omP8FKP","0"), //48
	new Array(1,"NdqNjQbPNPqRin6Q0CqLNAHNTSqL8omP8FKP","0"), //49
	new Array(1,"NdqNjQbPNPqRin6Q0CqLOAHNTSqL8omP8FKP","0"), //50
	new Array(1,"NPqRin6QL6qLJQbP7TrQT33A7FKNR4b;MAmN","0"), //51
	new Array(1,"NPqRin6QL6qLJQbP7TrQTD3A7FKNR4b;MAmN","0"), //52
	new Array(1,"NPqRin6QL6qLJQbP7TrQT;3A7FKNR4b;MAmN","0"), //53
	new Array(1,"NPqRin6QL6qLJQbP7TrQTL3A7FKNR4b;MAmN","0"), //54
	new Array(1,"NdqNjQbPDn6RGk5PKFrPbv6Q","0"), //55
	new Array(1,"NdqNjQbPDn6R4k5Pr;aQboqPljqQmn5QKFrPbv6Q","0"), //56
	new Array(1,"Dn6RHk5P7cqOgn6QNAHNR4b;MAmN","0"), //57
	new Array(1,"NPqRin6QNKqLthqMla3AZvZAO4KP4xKNspGM8FKP","0"), //58
	new Array(1,"NPqRin6QNKqLthqMla3AovZAQ3LR64LNbv6Q","0"), //59
	new Array(1,"NPqRin6QNKqLthqMla3AYvZAKdrPbv6Q","0"), //60
	new Array(1,"NPqRin6QNKqLthqMkW3AuuJCe5KMaRLObv6Q","-1"), //61
	new Array(1,"NPqRin6Q:KqLQ9KNDOrLNgqP3QaP:nqREp2N8FKP","-1"), //62
	new Array(1,"Dn6R3k5P:vpAIwqPjoKOij6Ii23Abv6Q","-1"), //63
	new Array(1,"Dn6RCk5PApKNtnaQ7l5NwIKOi23Abv6Q","-1"), //64
	new Array(1,"NPqRin6QN6qL9QaPq9qMMpGN8FKP","0"), //65
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP71nM2daN7FLNNQqPkq2S8FKP","0"), //66
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP71nMi86OAB7NhpKMUrWQ8FKP","0"), //67
	new Array(1,"Dn6R7k5Pa8KO6n5R9tKNzM6P71nM2P7RspGM8FKP","0"), //68
	new Array(1,"NhqFjQbPRNaNhxKMLOrLbwqPkP7QoP6QK3oLbv6Q","0"), //69
	new Array(1,"NhqFjQbPRNaNhxKMLOrLbwqPkP7QoP6QKDoLbv6Q","0"), //70
	new Array(1,"NPqRin6QLKqL5R6Nc2rQszGA8FKP","0"), //71
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPh0KOx5rMssKMszGA8FKP","0"), //72
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPBN7Ndz6Q0FaPszGA8FKP","0"), //73
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPt5rMxVqMVCXQR4b;MAmN","0"), //74
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPtTrQl3aQ9QaPi23Abv6Q","0"), //75
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqPwnaQ106PcNqOszGA8FKP","0"), //76
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPgvpARErPd3aQCc6PGN6Ni23Abv6Q","0"), //77
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPyvpAfxKMdRLMi23Abv6Q","0"), //78
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP71nMF5bNN0aPt3qQR4b;MAmN","0"), //79
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPkvpAUEKOC86PGN6NtxqMbuKSUOaQszGA8FKP","0"), //80
	new Array(1,"NdqNjQbPNPqRin6QA7qLNeqLBwKP6n5Rh4LOrHrQUSaQUzWA8FKP","0"), //81
	new Array(1,"NdqNjQbPDn6R3k5P2v5BwRLMBM6PgpKMFwqP1BXPR4b;MAmN","0"), //82
	new Array(1,"NdqNjQbPNPqRin6QA7qLD6rLQ4rPi23Abv6Q","0"), //83
	new Array(1,"NdqNjQbPNPqRin6QA7qLD6rLQ4rPiC3Abv6Q","0"), //84
	new Array(1,"NdqNjQbPNPqRin6QA7qLA6rLiJKMi23Abv6Q","0"), //85
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPtvpA806PFtKNrjqQ6n5Rh4LOi23Abv6Q","0"), //86
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPtvpA806PFtKNrjqQ5n5Rw5LMlB3OR4b;MAmN","0"), //87
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPtvpA806PFtKNrjqQLn5RgoKOi23Abv6Q","0"), //88
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPtvpA806PFtKNrjqQLn5RhRLMVCXQR4b;MAmN","0"), //89
	new Array(1,"NdqNjQbPDAbOfxKMhM6Ow0LOIqqLVILOr5LNrHrQUSaQszGA8FKP","0"), //90
	new Array(1,"NdqNjQbPDn6R1k5P806P1tKN7TrQtDrQJoaPVCXQR4b;MAmN","0"), //91
	new Array(1,"NdqNjQbPDn6REk5PMDLRrRLNynaQtAHMR4b;MAmN","0"), //92
	new Array(1,"NdqNjQbPDn6REk5PMDLRrRLNi;6QR4b;MAmN","0"), //93
	new Array(1,"NdqNjQbPNPqRin6QA7qLLOrLh6KSs4LMszGA8FKP","0"), //94
	new Array(1,"NdqNjQbPNPqRin6QNWqLi;6QBCrLYwKOiP6Qi23Abv6Q","0"), //95
	new Array(1,"NdqNjQbPDn6R3k5P6v5Bh4LOK;qR:l5Nkr2Q8FKP","0"), //96
	new Array(1,"NdqNjQbPDn6R:k5PdBLMNkZPcMqMszGA8FKP","0"), //97
	new Array(1,"NdqNjQbPDn6R:k5PdBLMQkZPUEKO9r6R0FaPszGA8FKP","0"), //98
	new Array(1,"NdqNjQbPNPqRin6QA7qLNuqLJ0aP9;nLR4b;MAmN","0"), //99
	new Array(1,"NdqNjQbPNPqRin6QA7qLNuqLJ0aP:;nLR4b;MAmN","0"), //100
	new Array(1,"NdqNjQbPNPqRin6QA7qLNuqLJ0aP;;nLR4b;MAmN","0"), //101
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP7RnMn9aMtArOcUqMszGA8FKP","0"), //102
	new Array(1,"NPqRin6QLaqLlPaQ70bPQ4rPi23Abv6Q","0"), //103
	new Array(1,"NdqNjQbPDn6R3k5P3v5Bu5LM8RrPszGA8FKP","0"), //104
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNtAHMI6qLR0rPR4b;MAmN","0"), //105
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNvAHMI6qLR0rPR4b;MAmN","0"), //106
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNuAHMI6qLR0rPR4b;MAmN","0"), //107
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNtAHMR4b;MAmN","0"), //108
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNvAHMR4b;MAmN","0"), //109
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNuAHMR4b;MAmN","0"), //110
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNwlJMzdKMLpKMrxqMqOqQbv6Q","0"), //111
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNxlJM7;qQrxqMqOqQbv6Q","0"), //112
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNWlJMdBLMHkZPHk6PMpGN8FKP","0"), //113
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNwlJMzdKMaoKMbv6Q","0"), //114
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNxlJMq:qQbv6Q","0"), //115
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNWlJMdBLM0oWP8FKP","0"), //116
	new Array(1,"NdqNjQbPDn6R3k5PEv5BMDLRrRLNOkKPrfaQi86OR4b;MAmN","0"), //117
	new Array(1,"NdqNjQbPDn6R3k5PEv5BMDLRrRLNvdqMgk6OR4b;MAmN","0"), //118
	new Array(1,"NPqRin6QDOpLNgqPJQaPL15NQ4rPT33A7FKNR4b;MAmN","0"), //119
	new Array(1,"NPqRin6QI6oLZdLMR4rPT33A7FKNR4b;MAmN","0"), //120
	new Array(1,"NPqRin6QDOpLNgqPJQaPL15NQ4rPTD3A7FKNR4b;MAmN","0"), //121
	new Array(1,"NPqRin6QNWqLi;6QB1LNrHrQUSaQpvZAKkqNbv6Q","0"), //122
	new Array(1,"NPqRin6QNyqLp;qQBrKRT33A7FKNR4b;MAmN","0"), //123
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMRkZPh1KMTD3A7FKNR4b;MAmN","0"), //124
	new Array(1,"NdqNjQbPNPqRin6QBOqLt3rQcUqMhvJAKkqNbv6Q","0"), //125
	new Array(1,"NdqNjQbPNPqRin6QIGqLetKMD5LNNAHNTSqL8omP8FKP","0"), //126
	new Array(1,"NdqNjQbPNPqRin6QA7qLD6rLQ4rPT33A7FKNR4b;MAmN","0"), //127
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP71nMF5bNN0aPt3qQTSqL8omP8FKP","0"), //128
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPkvpAUEKOC86PGN6NtxqMbuKSUOaQhvJAKkqNbv6Q","0"), //129
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPfvpAwqKSoM6Ov0KO:nqRGA3NTSqL8omP8FKP","0"), //130
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPfvpAwqKSoM6Ov0KO:nqRFA3NTSqL8omP8FKP","0"), //131
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPyvpAfxKMdRLMT33A7FKNR4b;MAmN","0"), //132
	new Array(1,"NPqRin6Q8WqLL6qLJQbPcSrQBvJBKkqNbv6Q","0"), //133
	new Array(1,"NdqNjQbPNPqRin6QA7qLD6rLQ4rPTD3A7FKNR4b;MAmN","0"), //134
	new Array(1,"Dn6R7k5Pa8KO6n5R9tKNzM6PJ57N4kJPKFrPbv6Q","0"), //135
	new Array(1,"Dn6R7k5Pa8KO6n5R9tKNzM6PJ57NPkJP48KPEo2P8FKP","0"), //136
	new Array(1,"Dn6R7k5Pa8KO6n5R9tKNzM6PpdrMw9aMcmpQszGA8FKP","0"), //137
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPuvpAzfaQH8aPrHrQUSaQszGA8FKP","0"), //138
	new Array(1,"NdqNjQbPNPqRin6QA7qLA6rLiJKMi:3Abv6Q","0"), //139
	new Array(1,"NdqNjQbPNPqRin6QA7qLF6rLoVqMNAHNR4b;MAmN","0"), //140
	new Array(1,"NdqNjQbPNPqRin6QA7qLF6rLoVqMOAHNR4b;MAmN","0"), //141
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZP;v5BHMbPxwqOi23Abv6Q","0"), //142
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZP;v5BHMbPxwqOiC3Abv6Q","0"), //143
	new Array(1,"NdqNjQbPDn6R3k5PEv5BYwKO8FrPszGA8FKP","0"), //144
	new Array(1,"NdqNjQbPDn6R3k5PEv5BYwKO8FrPUzWA8FKP","0"), //145
	new Array(1,"NdqNjQbP6kKPA7qL:OrLIwqPR6rLzlJMM9KNKpqPbv6Q","0"), //146
	new Array(1,"NdqNjQbP6kKPA7qL:OrLIwqPLGqLXPaQLn5RM9KNKpqPbv6Q","0"), //147
	new Array(1,"Dn6R7k5Pa8KO6n5R9tKNzM6P7RnMN9aNYfbQhxKMi23Abv6Q","0"), //148
	new Array(1,"NdqNjQbPNPqRin6QA7qL:HrLN6qLXTaQQwqPuMKOiK3Abv6Q","0"), //149
	new Array(1,"NdqNjQbPNPqRin6QA7qL:HrLN6qLXTaQQwqPuMKOi:3Abv6Q","0"), //150
	new Array(1,"NdqNjQbPNPqRin6QA7qL:HrLN6qLXTaQQwqPuMKOi23Abv6Q","0"), //151
	new Array(1,"NdqNjQbPNPqRin6QA7qL:HrLN6qLXTaQQwqPuMKOiC3Abv6Q","0"), //152
	new Array(1,"NdqNjQbPDn6R3k5PGv5BgFKMIwqPTD3An9aMtArOqUqMbv6Q","0"), //153
	new Array(1,"NdqNjQbPDn6R3k5PGv5BgFKMIwqPT33An9aMtArOqUqMbv6Q","0"), //154
	new Array(1,"NdqNjQbPDn6R3k5P7v5BQsqPIwqPN2qLcVqMX1KMR4b;MAmN","0"), //155
	new Array(1,"NdqNjQbPDn6R3k5PIv5BhEKOzTaQzw6Pn9aMtArOqUqMbv6Q","0"), //156
	new Array(1,"NdqNjQbPDn6R3k5PGv5Be5KMgQLOIwqPN2qLcVqMX1KMR4b;MAmN","0"), //157
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP7RnMO8KPakKOQRLN;lJNAoqPwnaQGM6PR4b;MAmN","0"), //158
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP7RnMO8KPakKOQRLN;lJNAoqPwnaQGM6PiC3Abv6Q","0"), //159
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP7RnMO8KPakKOQRLN;lJNAoqPwnaQGM6Pi:3Abv6Q","0"), //160
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNslJMgpKMflJMHk6PMpGN8FKP","0"), //161
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNwAHMI6qLR0rPR4b;MAmN","0"), //162
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNwAHMR4b;MAmN","0"), //163
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNslJMgpKMspGM8FKP","0"), //164
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNxAHMI6qLR0rPR4b;MAmN","0"), //165
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNxAHMR4b;MAmN","0"), //166
	new Array(1,"NdqNjQbPNPqRin6QA7qLE6qLQNKNihKMAkqPR4b;MAmN","0"), //167
	new Array(1,"NdqNjQbPDn6R3k5PJv5BO4KP4xKNslJM3vKReoKOLRLMrxqMqOqQbv6Q","0"), //168
	new Array(1,"NdqNjQbPDn6R3k5P8v5BUEKOICqLxhqMPcLPok6OiC3Abv6Q","0"), //169
	new Array(1,"NdqNjQbPDn6R3k5P8v5BUEKOICqLxhqMPcLPok6Oi23Abv6Q","0"), //170
	new Array(1,"NdqNjQbPNPqRin6QA7qLFeqLbhqNC86PqMqMbv6Q","0"), //171
	new Array(1,"NdqNjQbPDn6R3k5P8v5BUEKODOrLNgqP3QaP:nqREp2N8FKP","0"), //172
	new Array(1,"NdqNjQbP48KPQlJNIkqPA7qLFeqLbhqNrHrQySaQbv6Q","0"), //173
	new Array(1,"NdqNjQbPDn6R3k5P8v5BUEKOA6rLiJKMi23Abv6Q","0"), //174
	new Array(1,"NdqNjQbPRNaNhxKMLOrLbwqP7RnMbc6OXk5OAoqPwnaQGM6PR4b;MAmN","0"), //175
	new Array(1,"NdqNjQbPDn6R3k5P8v5BUEKONyqLTQaPCc6PR4b;MAmN","0"), //176
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZP8v5BUEKOKaoL33KRCN6Pbv6Q","0"), //177
	new Array(1,"NdqNjQbPDn6R3k5P4v5BlPaQ90KP836Rr5LNi:3Abv6Q","0"), //178
	new Array(1,"NdqNjQbPDn6R3k5P4v5BlPaQ90KP836Rr5LNiC3Abv6Q","0"), //179
	new Array(1,"NdqNjQbPDn6R3k5P4v5BlPaQ90KP836R64LNbv6Q","0"), //180
	new Array(1,"NdqNjQbPNPqRin6QA7qLN:rLD6rLQ4rPR4b;MAmN","0"), //181
	new Array(1,"NdqNjQbPRNaNhxKMRKrLbBLMHkZPIv5BLpKMhoqOoVqMMpGN8FKP","0"), //182
	new Array(1,"NdqNjQbPNPqRin6QA7qLNeqLbTaQgpKMiC3Abv6Q","0"), //183
	new Array(1,"NdqNjQbPNPqRin6QA7qLNeqLbTaQgpKMi23Abv6Q","0"), //184
	new Array(1,"NdqNjQbPNPqRin6QA7qLNeqLbTaQgpKMR4b;MAmN","0"), //185
	new Array(1,"NdqNjQbPDn6R3k5P5v5B3M6PFNrNG;6RR4b;MAmN","0"), //186

	new Array(0) //Footer
);

// rebuild 2013-02-20 14:21:46.



// merge 2013-02-20 14:21:46.

/* ./data/ja/Giant_male/_Parts.js */
/* mergefile */
/* 0: ../data/ja/Giant_male/Face.js */
/* 1: ../data/ja/Giant_male/Hair.js */

/* ../data/ja/Giant_male/Face.js */
var sFaceArray = new Array(
	new Array(1,"48KPAlJN9JKNQzKR8HqLkz2A8FKP","0"), //0
	new Array(1,"48KPAlJN9JKNQzKR9HqLszGA8FKP","0"), //1
	new Array(1,"48KPAlJN9JKNQzKR:HqLszGA8FKP","0"), //2
	new Array(1,"48KPAlJN9JKNQzKR;HqLszGA8FKP","0"), //3
	new Array(1,"CxKNNyqLzM6P6N6NYNLM6n5Ri23Abv6Q","0"), //4
	new Array(1,"CxKNNyqLzM6P6N6NYNLM6n5Ry6XAbv6Q","0"), //5
	new Array(1,"CxKNNyqLzM6P6N6NYNLM6n5Ry2XAbv6Q","0"), //6
	new Array(1,"CxKNNyqLzM6P6N6NYNLM6n5RyCXAbv6Q","0"), //7
	new Array(1,"CxKNNyqLzM6P6N6NYNLM6n5RC63Bbv6Q","0"), //8
	new Array(1,"CxKNNyqLzM6P6N6NYNLM6n5RC23Bbv6Q","0"), //9
	new Array(1,"CxKNNyqLzM6P6N6NYNLM6n5RCC3Bbv6Q","0"), //10
	new Array(1,"CxKNNyqLzM6P6N6NYNLM6n5R66HBbv6Q","0"), //11
	new Array(1,"CxKNNyqLzM6P6N6NYNLM6n5R62HBbv6Q","0"), //12
	new Array(1,"CxKNNyqLzM6P6N6NYNLM6n5R6CHBbv6Q","0"), //13
	new Array(1,"NhqFjQbP48KPAlJN9JKNQzKR8HqLkz2A8FKP","0"), //14
	new Array(1,"NdqNjQbP48KP;lJN6v5Bi23Abv6Q","0"), //15
	new Array(1,"NdqNjQbP48KP;lJN6v5BiC3Abv6Q","0"), //16
	new Array(1,"NdqNjQbP48KP;lJN6v5Bi:3Abv6Q","0"), //17
	new Array(1,"NdqNjQbP48KP;lJN6v5BiK3Abv6Q","0"), //18

	new Array(0) //Footer
);

// rebuild 2013-02-20 14:21:44.


/* ../data/ja/Giant_male/Hair.js */
var sHairArray = new Array(
	new Array(1,"48KP0lJNudKMT33AFC3RR4b;MAmN","0"), //0
	new Array(1,"48KP0lJNudKMTD3AGC3RR4b;MAmN","0"), //1
	new Array(1,"48KP0lJNudKMT;3AHC3RR4b;MAmN","0"), //2
	new Array(1,"48KP0lJNudKMTL3AIC3RR4b;MAmN","0"), //3
	new Array(1,"48KP0lJNudKMTH3AJC3RR4b;MAmN","0"), //4
	new Array(1,"48KP0lJNudKMTT3AKC3RR4b;MAmN","0"), //5
	new Array(1,"48KP0lJNudKMTP3ALC3RR4b;MAmN","0"), //6
	new Array(1,"48KP0lJNudKMTb3AMC3RR4b;MAmN","0"), //7
	new Array(1,"48KP0lJNudKMTX3ANC3RR4b;MAmN","0"), //8
	new Array(1,"48KP0lJNudKML7HAE:3RR4b;MAmN","0"), //9
	new Array(1,"48KP0lJNudKML3HAF:3RR4b;MAmN","0"), //10
	new Array(1,"48KP0lJNudKMLDHAG:3RR4b;MAmN","0"), //11
	new Array(1,"48KP0lJNudKML;HAH:3RR4b;MAmN","0"), //12
	new Array(1,"48KP0lJNudKMLLHAI:3RR4b;MAmN","0"), //13
	new Array(1,"48KP0lJNudKMLHHAJ:3RR4b;MAmN","0"), //14
	new Array(1,"48KP0lJNudKMLTHAK:3RR4b;MAmN","0"), //15
	new Array(1,"48KP0lJNudKMLPHAL:3RR4b;MAmN","0"), //16
	new Array(1,"48KP0lJNudKMLbHAM:3RR4b;MAmN","0"), //17
	new Array(1,"48KP0lJNudKMLXHAN:3RR4b;MAmN","0"), //18
	new Array(1,"48KP0lJNudKMD3XAF63RR4b;MAmN","0"), //19
	new Array(1,"48KP0lJNudKMDDXAG63RR4b;MAmN","0"), //20
	new Array(1,"48KP0lJNudKMD;XAH63RR4b;MAmN","0"), //21
	new Array(1,"48KP0lJNudKMDLXAI63RR4b;MAmN","0"), //22
	new Array(1,"48KP0lJNudKMDHXAJ63RR4b;MAmN","0"), //23
	new Array(1,"48KP0lJNudKMDTXAK63RR4b;MAmN","0"), //24
	new Array(1,"48KP0lJNudKM77nAE23RR4b;MAmN","0"), //25
	new Array(1,"48KP0lJNudKM73nAF23RR4b;MAmN","0"), //26
	new Array(1,"48KP0lJNudKM7DnAG23RR4b;MAmN","0"), //27
	new Array(1,"48KP0lJNudKM7;nAH23RR4b;MAmN","0"), //28
	new Array(1,"48KP0lJNudKM7LnAI23RR4b;MAmN","0"), //29
	new Array(1,"48KP0lJNudKM7HnAJ23RR4b;MAmN","0"), //30
	new Array(1,"48KP0lJNudKM7TnAK23RR4b;MAmN","0"), //31
	new Array(1,"48KP0lJNudKM7PnAL23RR4b;MAmN","0"), //32
	new Array(1,"48KP0lJNudKM7bnAM23RR4b;MAmN","0"), //33
	new Array(1,"48KP0lJNudKM7XnAN23RR4b;MAmN","0"), //34
	new Array(1,"48KP0lJNudKMz73BES3RR4b;MAmN","0"), //35
	new Array(1,"48KP0lJNudKMz33BFS3RR4b;MAmN","0"), //36
	new Array(1,"48KP0lJNudKMzD3BGS3RR4b;MAmN","0"), //37
	new Array(1,"48KP0lJNudKMz;3BHS3RR4b;MAmN","0"), //38
	new Array(1,"48KP0lJNudKMzX3BNS3RR4b;MAmN","0"), //39
	new Array(1,"48KP0lJNudKMT:3CHi3RR4b;MAmN","0"), //40
	new Array(1,"48KP0lJNudKMzP3BLS3RR4b;MAmN","0"), //41
	new Array(1,"48KP0lJNudKMzb3BMS3RR4b;MAmN","0"), //42
	new Array(1,"48KP0lJNudKMr7HBEO3RR4b;MAmN","0"), //43
	new Array(1,"48KP0lJNudKMr3HBFO3RR4b;MAmN","0"), //44
	new Array(1,"48KP0lJNudKMrDHBGO3RR4b;MAmN","0"), //45
	new Array(1,"48KP0lJNudKMr;HBHO3RR4b;MAmN","0"), //46
	new Array(1,"48KP0lJNudKMrLHBIO3RR4b;MAmN","0"), //47
	new Array(1,"48KP;lJNkvpAudKMTP3ALC3RR4b;MAmN","0"), //48
	new Array(1,"48KP0lJNudKMzH3BJS3RR4b;MAmN","0"), //49
	new Array(1,"48KP0lJNudKMzT3BKS3RR4b;MAmN","0"), //50
	new Array(1,"CxKNNyqLzM6Pd86OVCXQ8PrLszGA8FKP","0"), //51
	new Array(1,"CxKNNyqLzM6Pd86OWCXQ8PrLUzWA8FKP","0"), //52
	new Array(1,"CxKNNyqLzM6Pd86OXCXQ8PrLczmA8FKP","0"), //53
	new Array(1,"CxKNNyqLzM6Pd86OYCXQ8PrLEz2B8FKP","0"), //54
	new Array(1,"CxKNNyqLzM6Pd86OZCXQ8PrLMzGB8FKP","0"), //55
	new Array(1,"CxKNNyqLzM6Pd86OaCXQ8PrL0zWB8FKP","0"), //56
	new Array(1,"CxKNNyqLzM6Pd86ObCXQ8PrL8zmB8FKP","0"), //57
	new Array(1,"CxKNNyqLzM6P71nMd86OWCXQ8PrLUzWA8FKP","0"), //58
	new Array(1,"NhqFjQbP48KP0lJNudKMT33AFC3RR4b;MAmN","0"), //59
	new Array(1,"NhqFjQbP48KP0lJNudKMT33AFC3RR4b;MAmN","0"), //60
	new Array(1,"NhqFjQbP48KP0lJNudKMT33AFC3RR4b;MAmN","0"), //61
	new Array(1,"NhqFjQbP48KP0lJNudKMT33AFC3RR4b;MAmN","0"), //62
	new Array(1,"NhqFjQbP48KP0lJNudKMTD3AGC3RR4b;MAmN","0"), //63
	new Array(1,"NhqFjQbP48KP0lJNudKMTD3AGC3RR4b;MAmN","0"), //64
	new Array(1,"NhqFjQbP48KP0lJNudKMTD3AGC3RR4b;MAmN","0"), //65
	new Array(1,"NhqFjQbP48KP0lJNudKMTD3AGC3RR4b;MAmN","0"), //66
	new Array(1,"NhqFjQbP48KP0lJNudKMT;3AHC3RR4b;MAmN","0"), //67
	new Array(1,"NhqFjQbP48KP0lJNudKMT;3AHC3RR4b;MAmN","0"), //68
	new Array(1,"NhqFjQbP48KP0lJNudKMT;3AHC3RR4b;MAmN","0"), //69
	new Array(1,"NhqFjQbP48KP0lJNudKMT;3AHC3RR4b;MAmN","0"), //70
	new Array(1,"NhqFjQbP48KP0lJNudKMTL3AIC3RR4b;MAmN","0"), //71
	new Array(1,"NhqFjQbP48KP0lJNudKMTL3AIC3RR4b;MAmN","0"), //72
	new Array(1,"NhqFjQbP48KP0lJNudKMTL3AIC3RR4b;MAmN","0"), //73
	new Array(1,"NhqFjQbP48KP0lJNudKMTL3AIC3RR4b;MAmN","0"), //74
	new Array(1,"NhqFjQbP48KP0lJNudKMTH3AJC3RR4b;MAmN","0"), //75
	new Array(1,"NhqFjQbP48KP0lJNudKMTH3AJC3RR4b;MAmN","0"), //76
	new Array(1,"NhqFjQbP48KP0lJNudKMTH3AJC3RR4b;MAmN","0"), //77
	new Array(1,"NhqFjQbP48KP0lJNudKMTH3AJC3RR4b;MAmN","0"), //78
	new Array(1,"NhqFjQbP48KP0lJNudKMTT3AKC3RR4b;MAmN","0"), //79
	new Array(1,"NhqFjQbP48KP0lJNudKMTT3AKC3RR4b;MAmN","0"), //80
	new Array(1,"NhqFjQbP48KP0lJNudKMTT3AKC3RR4b;MAmN","0"), //81
	new Array(1,"NhqFjQbP48KP0lJNudKMTT3AKC3RR4b;MAmN","0"), //82
	new Array(1,"NhqFjQbP48KP0lJNudKMTP3ALC3RR4b;MAmN","0"), //83
	new Array(1,"NhqFjQbP48KP0lJNudKMTP3ALC3RR4b;MAmN","0"), //84
	new Array(1,"NhqFjQbP48KP0lJNudKMTP3ALC3RR4b;MAmN","0"), //85
	new Array(1,"NhqFjQbP48KP0lJNudKMTP3ALC3RR4b;MAmN","0"), //86
	new Array(1,"NhqFjQbP48KP0lJNudKMTb3AMC3RR4b;MAmN","0"), //87
	new Array(1,"NhqFjQbP48KP0lJNudKMTb3AMC3RR4b;MAmN","0"), //88
	new Array(1,"NhqFjQbP48KP0lJNudKMTb3AMC3RR4b;MAmN","0"), //89
	new Array(1,"NhqFjQbP48KP0lJNudKMTb3AMC3RR4b;MAmN","0"), //90
	new Array(1,"NhqFjQbP48KP0lJNudKMTX3ANC3RR4b;MAmN","0"), //91
	new Array(1,"NhqFjQbP48KP0lJNudKMTX3ANC3RR4b;MAmN","0"), //92
	new Array(1,"NhqFjQbP48KP0lJNudKMTX3ANC3RR4b;MAmN","0"), //93
	new Array(1,"NhqFjQbP48KP0lJNudKMTX3ANC3RR4b;MAmN","0"), //94
	new Array(1,"NhqFjQbP48KP0lJNudKML7HAE:3RR4b;MAmN","0"), //95
	new Array(1,"NhqFjQbP48KP0lJNudKML7HAE:3RR4b;MAmN","0"), //96
	new Array(1,"NhqFjQbP48KP0lJNudKML7HAE:3RR4b;MAmN","0"), //97
	new Array(1,"NhqFjQbP48KP0lJNudKML7HAE:3RR4b;MAmN","0"), //98
	new Array(1,"NdqNjQbP48KP;lJNkvpAudKMT33AFC3RR4b;MAmN","0"), //99
	new Array(1,"NdqNjQbP48KP;lJNkvpAudKMT33AFC3RR4b;MAmN","0"), //100
	new Array(1,"NdqNjQbP48KP;lJNkvpAudKMT33AFC3RR4b;MAmN","0"), //101
	new Array(1,"NdqNjQbP48KP;lJNkvpAudKMT33AFC3RR4b;MAmN","0"), //102
	new Array(1,"NdqNjQbP48KP;lJNkvpAudKMTD3AGC3RR4b;MAmN","0"), //103
	new Array(1,"NdqNjQbP48KP;lJNkvpAudKMTD3AGC3RR4b;MAmN","0"), //104
	new Array(1,"NdqNjQbP48KP;lJNkvpAudKMTD3AGC3RR4b;MAmN","0"), //105
	new Array(1,"NdqNjQbP48KP;lJNkvpAudKMTD3AGC3RR4b;MAmN","0"), //106
	new Array(1,"NdqNjQbP48KP;lJN8v5BudKMT33AFC3RR4b;MAmN","0"), //107
	new Array(1,"NhqFjQbP48KP2lJNVn5QMM6PNeqLs5LOszGA8FKP","0"), //108
	new Array(1,"NdqNjQbP48KP;lJN8v5BudKMTH3AJC3RR4b;MAmN","0"), //109
	new Array(1,"NdqNjQbP48KP;lJN8v5BudKMTT3AKC3RR4b;MAmN","0"), //110
	new Array(1,"NdqNjQbP48KP9lJNMkaPdpKML:rLjD7QT33Ad86OUrWQ8FKP","0"), //111

	new Array(0) //Footer
);

// rebuild 2013-02-20 14:21:44.



// merge 2013-02-20 14:21:44.

/* ./data/ja/Giant_male/_Equips.js */
/* mergefile */
/* 0: ../data/ja/Giant_male/Body.js */
/* 1: ../data/ja/Giant_male/Foot.js */
/* 2: ../data/ja/Giant_male/Hand.js */
/* 3: ../data/ja/Giant_male/Head.js */
/* 4: ../data/ja/Giant_male/Robe.js */

/* ../data/ja/Giant_male/Body.js */
var sBodyArray = new Array(
    new Array(1,"NhqFjQbP48KPRlJNJQaPpHbQL5LMX1bMR4b;MAmN","s:mI","s:mI",""), //0
    new Array(1,"NhqFjQbP48KP;lJNHk6PoDrQhRLMT33AXtaMR4b;MAmN","s:mI","s:mI",""), //1
    %for i in body:
	new Array(1,"{{i['fname']}}","{{i['t1']}}","{{i['t2']}}","{{i['t3']}}"),
	%end
	new Array(0) //Footer
);

// rebuild 2013-02-20 14:21:44.


/* ../data/ja/Giant_male/Foot.js */
var sFootArray = new Array(
	new Array(1,"NdqNjQbP48KP4lJNQ9KNmM6OrjqQXTbQZk6OfnpQa6HAbv6Q","9"), //0
    %for i in foot:
    new Array(1,"{{i['fname']}}","{{i['t1']}}"),
    %end
	new Array(0) //Footer
);

// rebuild 2013-02-20 14:21:44.


/* ../data/ja/Giant_male/Hand.js */
var sHandArray = new Array(
	new Array(1,"NdqNjQbP48KP4lJNQ9KNmM6OlTrQ7w6PKk6PDlJNiC3Abv6Q","1"), //0
    %for i in hand:
    new Array(1,"{{i['fname']}}","{{i['t1']}}"),
    %end

	new Array(0) //Footer
);

// rebuild 2013-02-20 14:21:44.


/* ../data/ja/Giant_male/Head.js */
var sHeadArray = new Array(
	new Array(1,"NdqNjQbP48KP;lJNx1LMswKMTb3AmB3OR4b;MAmN","1"), //0
    %for i in head:
    new Array(1,"{{i['fname']}}","{{i['t1']}}"),
    %end

	new Array(0) //Footer
);

// rebuild 2013-02-20 14:21:44.


/* ../data/ja/Giant_male/Robe.js */
var sRobeArray = new Array(
	new Array(1,"NhqFjQbP48KPOlJNR4qPR2qLs4LMUzWA8FKP","0"), //0
    %for i in robe:
    new Array(1,"{{i['fname']}}","{{i['t1']}}"),
    %end

	new Array(0) //Footer
);

// rebuild 2013-02-20 14:21:44.



// merge 2013-02-20 14:21:44.

/* ./lib/simplepicker.js */

var simplePicker=
{
	inited:0,
	mode:'hex',
	chartFrame:null,
	chartImage:null,
	chartString:null,
	windowOnLoad:window.onload,
	documentOnMouseMove:window.onmousemove,
	mouseX:0,
	mouseY:0,
	textH:null,
	textR:null,
	textG:null,
	textB:null,
	HEX:'',
	RGB:[0,0,0]
};

simplePicker.run=function()
{
	if (this.inited==0) this.init();
	this.chartFrame.style.left=this.mouseX+'px';
	this.chartFrame.style.top=this.mouseY+'px';
	this.chartFrame.style.visibility=this.chartFrame.style.visibility=='visible' ? 'hidden' : 'visible';

	//document.getElementById("colorpicksp").style.display='block';
};

simplePicker.getColor=function(e,event)
{
	var x=e ? e.pageX-this.chartFrame.offsetLeft : event.offsetX;
	var y=e ? e.pageY-this.chartFrame.offsetTop : event.offsetY;
	this.pickColor(x,y);
	var r=this.RGB[0].toString(16);
	r=r.length==1 ? '0'+r : r;
	var g=this.RGB[1].toString(16);
	g=g.length==1 ? '0'+g : g;
	var b=this.RGB[2].toString(16);
	b=b.length==1 ? '0'+b : b;
	this.HEX="#"+r+g+b;
	//this.chartString.value='#'+this.HEX+' : RGB('+this.RGB[0]+','+this.RGB[1]+','+this.RGB[2]+')';
	//this.chartString.style.backgroundColor='#'+this.HEX;
	//this.chartString.style.color=parseInt(this.RGB[0])+parseInt(this.RGB[1])+parseInt(this.RGB[2])<382 ? '#fff' : '#000';
}

simplePicker.pickColor=function(x,y)
{
	var a=
	[
		[255,-1,0,0,1,255],
		[1,255,255,-1,0,0],
		[0,0,1,255,255,-1]
	];
	var u=Math.round(255/6);
	var s=Math.floor(x/u);
	this.RGB=[0,0,0];
	for(var i=0; i<3; i++)
	{
		if(a[i][s]===1)
		{
			this.RGB[i]=x%u*6;
		}
		else if(a[i][s]===-1)
		{
			this.RGB[i]=255-x%u*6;
		}
		else
		{
			this.RGB[i]=a[i][s];
		}
		if(y<128)
		{
			this.RGB[i]=255-Math.sin(Math.PI/255*y)*(255-this.RGB[i]);
		}
		else
		{
			this.RGB[i]=Math.sin(Math.PI/255*y)*this.RGB[i];
		}
		this.RGB[i]=Math.round(this.RGB[i]);
	}
}

//window.onload=function()
simplePicker.init=function()
{
	simplePicker.chartFrame=document.createElement('div');
	document.body.appendChild(simplePicker.chartFrame);
	simplePicker.chartImage=document.createElement('div');
	simplePicker.chartFrame.appendChild(simplePicker.chartImage);
	simplePicker.chartFrame.style.left='0px';
	simplePicker.chartFrame.style.top='0px';
	simplePicker.chartFrame.style.backgroundColor='#fff';
	simplePicker.chartFrame.style.border='#888 1px solid';
	simplePicker.chartFrame.style.position='absolute';
	simplePicker.chartFrame.style.visibility='hidden';
	simplePicker.chartFrame.style.zIndex='100';
	simplePicker.chartImage.style.backgroundImage='url("./lib/colorchart.png")';
	simplePicker.chartImage.style.cursor='crosshair';
	simplePicker.chartImage.style.width='255px';
	simplePicker.chartImage.style.height='255px';
	simplePicker.chartFrame.onclick=function(e)
	{
		simplePicker.chartFrame.style.visibility='hidden';
		document.getElementById("colorpicksp").style.display='none';
	};
	simplePicker.chartImage.onmousemove=function(e)
	{
		simplePicker.getColor(e,e || event);
		setPickerColor( simplePicker.HEX );
	};
	simplePicker.chartImage.onclick=function(e)
	{

	};
	this.inited = 1;
};

document.onmousemove=function(e)
{
	if(simplePicker.documentOnMouseMove)
	{
		simplePicker.documentOnMouseMove();
	}
	simplePicker.mouseX=e ? e.pageX : event.x+document.body.scrollLeft;
	simplePicker.mouseY=e ? e.pageY : event.y+document.body.scrollTop;
}

function execute( script )
{
	parent.execute( script );
}
function init()
{
	parent.config_load();
	
	startLoading();
	search_timer();
	
	//jsinitvals
		
	setTimeout("init_timer()", 500);
}
function init_timer()
{
	finishLoading();
	go();
}
function startLoading()
{
	controller.style.display = "none";
	loading.style.display = "block";
	loadingFlipflop = "hidden";
	loadingTimer = setInterval("nowLoading()",700);
}
function nowLoading()
{
	tmp = loadingInnerBox.style.visibility;
	loadingInnerBox.style.visibility = loadingFlipflop;
	loadingFlipflop = tmp;
}
function finishLoading()
{
	clearInterval(loadingTimer);
	loading.style.display = "none";
	controller.style.display = "block";
}
var oldSearchStr = "";
function search_timer()
{
	if (controller.searchText.value != 'search example) Vanalen' && oldSearchStr != controller.searchText.value) {
		oldSearchStr = controller.searchText.value;
		runSearch();
	}
	setTimeout("search_timer()", 250);
}
//-->
</script>

<script type='text/javascript'>
var googletag = googletag || {};
googletag.cmd = googletag.cmd || [];
(function() {
var gads = document.createElement('script');
gads.async = true;
gads.type = 'text/javascript';
var useSSL = 'https:' == document.location.protocol;
gads.src = (useSSL ? 'https:' : 'http:') + 
'//www.googletagservices.com/tag/js/gpt.js';
var node = document.getElementsByTagName('script')[0];
node.parentNode.insertBefore(gads, node);
})();
</script>

<script type='text/javascript'>
googletag.cmd.push(function() {
googletag.defineSlot('/3563141/MCS2_Control_Bottom2', [336, 280], 'div-gpt-ad-1333659646944-0').addService(googletag.pubads());
googletag.defineSlot('/3563141/MCS2_Control_Top', [234, 60], 'div-gpt-ad-1333659646944-1').addService(googletag.pubads());
googletag.pubads().enableSingleRequest();
googletag.enableServices();
});
</script>

</head>

<body onLoad="init();" onClick="mouseUp(this);" style="padding : 0px;margin : 0px;">
	
<TABLE style="height : 47px;" border="0" width="100%" cellpadding="0" cellspacing="0">
  <TBODY>
    <TR>
      <TD width="168"><a href="http://labo.erinn.biz/cs/" target="_blank"><img src="titlem.png" border="0"></a></TD>
      <TD style="background-image : url(bgm.png);background-repeat : repeat-x;">&nbsp;</TD>
      <TD width="75" align="right"><a href="http://labo.erinn.biz/" target="_blank"><img src="powm.png" border="0"></a></TD>
    </TR>
  </TBODY>
</TABLE>
	
<table border="0" cellpadding="0" cellspacing="0">
<tbody>
<tr>
<td class="innerBorder" id="content">

	<center>
	<div style="padding:5px;">
				<!-- MCS2_Control_Top -->
		<div id='div-gpt-ad-1333659646944-1' style='width:234px; height:60px;'>
		<script type='text/javascript'>
		googletag.cmd.push(function() { googletag.display('div-gpt-ad-1333659646944-1'); });
		</script>
		</div>
			</div>
	</center>
	
<!-- form table -->
<div id="form">

<span id="loading" class="loadingBox">
<span id="loadingInnerBox" class="loadingInnerBox">
Now Loading
</span>
</span>

<form name="controller" action="/control?framework=3#" style="display: block;">
<table width="430" border="0" cellpadding="0" cellspacing="2">
<tbody>

<tr id="configBlock">
<td class="controllerBlock" style="padding:2px;">

<TABLE border="0" cellpadding="0" cellspacing="1" style="line-height: 100%;">
  <TBODY>
    <TR>
      <TD class="menu_but" onclick="reloadURL();" style="cursor:pointer;" onMouseover="this.style.backgroundImage='url(pbg.png)';" onMouseout="this.style.backgroundImage='url(pbg2.png)';">Reload</TD>
      <TD class="menu_but" onclick="shortURL();" style="cursor:pointer;" onMouseover="this.style.backgroundImage='url(pbg.png)';" onMouseout="this.style.backgroundImage='url(pbg2.png)';">Make<br>ShortURL</TD>
      <TD class="menu_but" onclick="captureSnapshot();" style="cursor:pointer;" onMouseover="this.style.backgroundImage='url(pbg.png)';" onMouseout="this.style.backgroundImage='url(pbg2.png)';">Capture<br>Image</TD>
            <TD class="menu_but" onclick="window.open('?q=/1,1,1,2,FFFFFF/2,3/3,0.4,0.9,0.6,0.6/4,9C5D42,9/5,424563/6,110,11/7,7B2C10/8,4,0/9,00687F,08619F,E9B454/10,16/11,000000,000000,000000/12,42,0/13,516E7B,1F4C56,656C79/15,1676e1,3cc8d5,4a76a1/16,16/17,183532,4E7070,2A4F61/18,82,0/19,4AD7D1,5F6068,13609B/20,12,1/21,808080,D2BC95,707070/23,1676e1,3cc8d5,4a76a1/25,1676e1,3cc8d5,4a76a1/27,1676e1,3cc8d5,4a76a1/28,107,11/29,29/30,0/31,1904/32,12398,0', '_top');" style="cursor:pointer;" onMouseover="this.style.backgroundImage='url(pbg.png)';" onMouseout="this.style.backgroundImage='url(pbg2.png)';">Restore</TD>
            <TD class="menu_but" onclick="openNewWindow();" style="cursor:pointer;" onMouseover="this.style.backgroundImage='url(pbg.png)';" onMouseout="this.style.backgroundImage='url(pbg2.png)';">NewWindow</TD>
    </TR>
  </TBODY>
</TABLE>


		<table class="scriptEditorFrame" style="width:100%;" border="0" cellpadding="0" cellspacing="0">
			<tbody>
				<tr>
					<td class="secondaryControllerHeader">
						<a href="javascript:void(0);" onClick="toggleScriptEditor();" id="scriptEditorController" class="secondaryControllerHeader">+ Edir Avatar Script</a>
					</td>
				</tr>
				<tr id="scriptEditorBlock" style="display:none;">
					<td class="secondaryControllerBlock">
						<span style="padding-left:0px;margin-left:2px;margin-bottom:3px;">
<textarea id="excute_cmd" style="width:400px;height:300px;font-family:monotype;"></textarea><br />

<!--
<input type="button" onclick="execute( document.getElementById('excute_cmd').value );" value="Draw MCODE/Script" />
-->


<input type="button" onclick="execute_mcode( document.getElementById('excute_cmd').value );" value="Draw MCODE/Script" />
<input type="button" onclick="encode_mcode( document.getElementById('excute_cmd').value );" value="MCODE <=> Script Encode" />

<!--
<input type="button" onclick="clipboardData.setData('TEXT',document.getElementById('excute_cmd').value);" value="Copy" />
-->
<input type="checkbox" name="append_cmd" id="append_cmd" style="display:none;" /><!--Append Execute-->
						</span>
					</td>
				</tr>
			</tbody>
		</table>

</td>
</tr>
<tr id="configBlock3">
<td class="controllerBlock" style="padding:2px;">

<TABLE border="0" cellpadding="0" cellspacing="1" style="line-height: 100%;">
  <TBODY>
    <TR>
      <TD class="menu_but" onclick="entryMyList2();" style="cursor:pointer;" onMouseover="this.style.backgroundImage='url(pbg.png)';" onMouseout="this.style.backgroundImage='url(pbg2.png)';">Add to<br>MyList</TD>
      <TD class="menu_but" onclick="entryPublicList();" style="cursor:pointer;" onMouseover="this.style.backgroundImage='url(pbg.png)';" onMouseout="this.style.backgroundImage='url(pbg2.png)';">Add to<br>PublicList</TD>
      <TD class="menu_but" onclick="tweetURL();" style="cursor:pointer;" onMouseover="this.style.backgroundImage='url(pbg.png)';" onMouseout="this.style.backgroundImage='url(pbg2.png)';">Tweet</TD>
      <TD class="menu_but" onclick="captureBlogparts();" style="cursor:pointer;" onMouseover="this.style.backgroundImage='url(pbg.png)';" onMouseout="this.style.backgroundImage='url(pbg2.png)';">Make<br>Blogparts</TD>
      <TD class="menu_but" onclick="captureDressroom();" style="cursor:pointer;" onMouseover="this.style.backgroundImage='url(pbg.png)';" onMouseout="this.style.backgroundImage='url(pbg2.png)';">Add to<br>Dressroom</TD>
    </TR>
  </TBODY>
</TABLE>

<div style="padding-bottom:3px;">
		<table class="myList2Frame" style="width:100%;" border="0" cellpadding="0" cellspacing="0">
			<tbody>
				<tr>
					<td class="secondaryControllerHeader">
						<a href="javascript:void(0);" onClick="toggleMyList2();" id="myList2Controller" class="secondaryControllerHeader">+ kukuluID MyList</a>
					</td>
				</tr>
				<tr id="myList2Block" style="display:none;">
					<td class="secondaryControllerBlock">
					<IFRAME name="mylist2if" id="mylist2ifid" frameborder="0" scrolling="AUTO" src="about:blank" width="412" height="500"></IFRAME>
					</td>
				</tr>
			</tbody>
		</table>
</div>

		
</td>
</tr>


<tr id="configBlock2">
<td class="controllerBlock">
	<table border="0" cellpadding="0" cellspacing="0">
	<tbody>
	<tr>
	<td>
		<span class="controllerHeader">Sex/Race:</span><br>
		<select name="csFramework" onChange="changeFramework()">
		<option value="0" style="background-color : #fed8d9;">Human, Elf / Girl</option>
		<option value="1" style="background-color : #b5e3fd;">Human, Elf / Boy</option>
		
		<option value="2" style="background-color : #fed8d9;">Giant / Girl</option>
		<option value="3" style="background-color : #b5e3fd;">Giant / Boy</option>
		
		<option value="4" style="background-color : #ffffff;">Ego, Wand / Girl</option>
		<option value="5" style="background-color : #ffffff;">Ego, Sword / Girl</option>
		<option value="6" style="background-color : #ffffff;">Ego, Bow / Girl</option>
		<option value="7" style="background-color : #ffffff;">Ego, Blunt / Girl</option>
		
		<option value="8" style="background-color : #ffffff;">Ego, Wand / Boy</option>
		<option value="9" style="background-color : #ffffff;">Ego, Sword / Boy</option>
		<option value="10" style="background-color : #ffffff;">Ego, Bow / Boy</option>
		<option value="11" style="background-color : #ffffff;">Ego, Blunt / Boy</option>
			
						<option value="100" style="background-color : #ffffff;">ナオ</option>
								<option value="101" style="background-color : #ffffff;">ナオ (シェイクスピア服)</option>
								<option value="102" style="background-color : #ffffff;">ナオ (探検服1)</option>
								<option value="103" style="background-color : #ffffff;">ナオ (探検服2)</option>
								<option value="104" style="background-color : #ffffff;">ナオ (黄ドレス)</option>
								<option value="105" style="background-color : #ffffff;">ナオ (白ドレス)</option>
								<option value="106" style="background-color : #ffffff;">ナオ (桃ドレス)</option>
								<option value="107" style="background-color : #ffffff;">ナオ (浴衣)</option>
								<option value="108" style="background-color : #ffffff;">ナオ (ルアドレス)</option>
								<option value="109" style="background-color : #ffffff;">ナオ (サンタ服)</option>
								<option value="110" style="background-color : #ffffff;">ナオ (サッカー服)</option>
								<option value="111" style="background-color : #ffffff;">ナオ (黒コート)</option>
								<option value="112" style="background-color : #ffffff;">ナオ (桃コート)</option>
								<option value="113" style="background-color : #ffffff;">サキュバス</option>
								<option value="200" style="background-color : #ffffff;">モリアン</option>
								<option value="201" style="background-color : #ffffff;">モリアン (ブチギレ)</option>
								<option value="210" style="background-color : #ffffff;">キホール</option>
								<option value="220" style="background-color : #ffffff;">ネヴァン</option>
								<option value="300" style="background-color : #ffffff;">パラディン (♀1)</option>
								<option value="301" style="background-color : #ffffff;">パラディン (♀2)</option>
								<option value="302" style="background-color : #ffffff;">パラディン (♀3)</option>
								<option value="303" style="background-color : #ffffff;">パラディン (♀4)</option>
								<option value="304" style="background-color : #ffffff;">ダークナイト (♀1)</option>
								<option value="305" style="background-color : #ffffff;">ダークナイト (♀2)</option>
								<option value="306" style="background-color : #ffffff;">ダークナイト (♀3)</option>
								<option value="307" style="background-color : #ffffff;">ダークナイト (♀4)</option>
								<option value="308" style="background-color : #ffffff;">パラディン (♂1)</option>
								<option value="309" style="background-color : #ffffff;">パラディン (♂2)</option>
								<option value="310" style="background-color : #ffffff;">パラディン (♂3)</option>
								<option value="311" style="background-color : #ffffff;">パラディン (♂4)</option>
								<option value="312" style="background-color : #ffffff;">ダークナイト (♂1)</option>
								<option value="313" style="background-color : #ffffff;">ダークナイト (♂2)</option>
								<option value="314" style="background-color : #ffffff;">ダークナイト (♂3)</option>
								<option value="315" style="background-color : #ffffff;">ダークナイト (♂4)</option>
								<option value="320" style="background-color : #ffffff;">野獣エルフ (♀1)</option>
								<option value="321" style="background-color : #ffffff;">野獣エルフ (♀2)</option>
								<option value="322" style="background-color : #ffffff;">野獣エルフ (♀3)</option>
								<option value="323" style="background-color : #ffffff;">野獣エルフ (♀4)</option>
								<option value="324" style="background-color : #ffffff;">野獣エルフ (♂1)</option>
								<option value="325" style="background-color : #ffffff;">野獣エルフ (♂2)</option>
								<option value="326" style="background-color : #ffffff;">野獣エルフ (♂3)</option>
								<option value="327" style="background-color : #ffffff;">野獣エルフ (♂4)</option>
								<option value="340" style="background-color : #ffffff;">野獣ジャイアント (♀1)</option>
								<option value="341" style="background-color : #ffffff;">野獣ジャイアント (♀2)</option>
								<option value="342" style="background-color : #ffffff;">野獣ジャイアント (♀3)</option>
								<option value="343" style="background-color : #ffffff;">野獣ジャイアント (♀4)</option>
								<option value="344" style="background-color : #ffffff;">野獣ジャイアント (♂1)</option>
								<option value="345" style="background-color : #ffffff;">野獣ジャイアント (♂2)</option>
								<option value="346" style="background-color : #ffffff;">野獣ジャイアント (♂3)</option>
								<option value="347" style="background-color : #ffffff;">野獣ジャイアント (♂4)</option>
						</select>
	</td>
	
		<td width="1"></td>
	
	<td>
				<span class="controllerHeader">Avatar Size:</span><br>
		<select name="csSize" onChange="updateCSConfig()">
		<option value="0">Small (0.5X)</option>
		<option value="1">Normal (0.8X)</option>
		<option value="2">Big (1X)</option>
		<option value="3">Very Big (1.2X)</option>
		<option value="4">Ultra Big (1.5X)</option>
		</select>
			</td>
	
		<input type="hidden" name="csAA" value="2">
	
	<td width="3"></td>
	<td>
		<span class="controllerHeader">Background Color:</span><br>
		<span class="colorPaletteMini" id="bgPalette" onClick="dyeColor(this);changeBgColorByPalette( );" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
		<input type="text" value="ffffff" size="6" name="bgColor">
		<a class="controllerLink" href="javascript:void(0);" onClick="changeBgColorCustom(bgColor.value);">&nbsp;Dye</a>
	</td>
	</tr>
	</tbody>
	</table>
</td>
</tr>


<tr>
<td class="controllerTitle" >
<a href="javascript:void(0);" onClick="toggleCharacterController();" id="characterController" class="configLink">+ Character</a>
</td>
</tr>
<tr id="animationBlock" >
<td class="controllerBlock">
<table class="animationControllerFrame" border="0" cellpadding="0" cellspacing="0">
<tbody>
<tr>
<td>
	<span class="controllerHeader">Motion:</span><br>

<select name="animationMenu" onChange = "changeAnimation(this.value)">
<OPTION value="127">male::natural::stand</OPTION>
<OPTION value='681'>1act3ch::romio::juliet::first::dancing(juliet)</OPTION> 
<OPTION value='682'>1act3ch::romio::juliet::first::dancing(romio)</OPTION> 
<OPTION value='683'>1act4ch::player::block</OPTION> 
<OPTION value='684'>1act4ch::player::block02</OPTION> 
<OPTION value='685'>1act4ch::player::blocking</OPTION> 
<OPTION value='686'>1act4ch::player::blocktostand</OPTION> 
<OPTION value='687'>1act5ch::player::talk01</OPTION> 
<OPTION value='688'>1act5ch::player::talk02</OPTION> 
<OPTION value='689'>3act2ch::player::talk01</OPTION> 
<OPTION value='690'>4act1ch::siren::pickup</OPTION> 
<OPTION value='691'>alchemists::stand::friendly</OPTION> 
<OPTION value='692'>alchemists::stand::idle01</OPTION> 
<OPTION value='693'>alchemy::readingbook</OPTION> 
<OPTION value='694'>attack::01</OPTION> 
<OPTION value='695'>attack::02</OPTION> 
<OPTION value='696'>attack::03</OPTION> 
<OPTION value='697'>avon::hamlet::sword::01::ani</OPTION> 
<OPTION value='698'>ax::axing</OPTION> 
<OPTION value='699'>bird::riding::01::blowaway::endure</OPTION> 
<OPTION value='700'>bird::riding::01::groggy</OPTION> 
<OPTION value='701'>bird::riding::01::natural::hita</OPTION> 
<OPTION value='702'>bird::riding::01::natural::hitb</OPTION> 
<OPTION value='703'>bird::riding::natural::01::fly::landing</OPTION> 
<OPTION value='704'>bird::riding::natural::01::fly::run</OPTION> 
<OPTION value='705'>bird::riding::natural::01::fly::stand::friendly</OPTION> 
<OPTION value='706'>bird::riding::natural::01::fly::takeoff</OPTION> 
<OPTION value='707'>bird::riding::natural::01::mount</OPTION> 
<OPTION value='708'>bird::riding::natural::01::run</OPTION> 
<OPTION value='709'>bird::riding::natural::01::stand::friendly</OPTION> 
<OPTION value='710'>bird::riding::natural::01::stand::offensive</OPTION> 
<OPTION value='711'>bird::riding::natural::01::walk</OPTION> 
<OPTION value='712'>blowaway</OPTION> 
<OPTION value='713'>blowaway::body</OPTION> 
<OPTION value='714'>blowaway::endure</OPTION> 
<OPTION value='715'>blowaway::ground</OPTION> 
<OPTION value='716'>blowaway::turn</OPTION> 
<OPTION value='717'>brionacsword</OPTION> 
<OPTION value='718'>brionacsword::ending</OPTION> 
<OPTION value='719'>broom::riding::natural::01::dismount</OPTION> 
<OPTION value='720'>broom::riding::natural::01::endure</OPTION> 
<OPTION value='721'>broom::riding::natural::01::fly::run</OPTION> 
<OPTION value='722'>broom::riding::natural::01::fly::stand::friendly</OPTION> 
<OPTION value='723'>broom::riding::natural::01::groggy</OPTION> 
<OPTION value='724'>broom::riding::natural::01::hita</OPTION> 
<OPTION value='725'>broom::riding::natural::01::hitb</OPTION> 
<OPTION value='726'>broom::riding::natural::01::mount</OPTION> 
<OPTION value='730'>carpet01::fly::dismount</OPTION> 
<OPTION value='731'>carpet01::fly::endure</OPTION> 
<OPTION value='732'>carpet01::fly::groggy</OPTION> 
<OPTION value='733'>carpet01::fly::hita</OPTION> 
<OPTION value='734'>carpet01::fly::hitb</OPTION> 
<OPTION value='735'>carpet01::fly::landing</OPTION> 
<OPTION value='736'>carpet01::fly::mount</OPTION> 
<OPTION value='737'>carpet01::fly::run</OPTION> 
<OPTION value='738'>carpet01::fly::standfriendly</OPTION> 
<OPTION value='739'>carpet01::fly::takeoff</OPTION> 
<OPTION value='740'>carpet01::fly::walk</OPTION> 
<OPTION value='741'>combat::counter</OPTION> 
<OPTION value='742'>combat::guard</OPTION> 
<OPTION value='743'>combat::smash::01</OPTION> 
<OPTION value='744'>combat::windmill::standing</OPTION> 
<OPTION value='745'>crystal::rudolf::fly::run</OPTION> 
<OPTION value='746'>crystal::rudolf::fly::stand::friendly</OPTION> 
<OPTION value='747'>crystal::rudolf::lading</OPTION> 
<OPTION value='748'>crystal::rudolf::take::off</OPTION> 
<OPTION value='749'>curtain::call01</OPTION> 
<OPTION value='750'>cutscene::loss</OPTION> 
<OPTION value='751'>cymbals</OPTION> 
<OPTION value='752'>cymbals::natural::stand::friendly</OPTION> 
<OPTION value='753'>cymbals::run</OPTION> 
<OPTION value='754'>cymbals::stand::friendly</OPTION> 
<OPTION value='755'>cymbals::walk</OPTION> 
<OPTION value='756'>dartgame::throw</OPTION> 
<OPTION value='757'>dartgame::wait</OPTION> 
<OPTION value='758'>dash::attack</OPTION> 
<OPTION value='759'>dash::run</OPTION> 
<OPTION value='760'>demigod::trans</OPTION> 
<OPTION value='761'>demi::lightspear::casting</OPTION> 
<OPTION value='762'>demi::lightspear::processing</OPTION> 
<OPTION value='763'>demi::lightstorm</OPTION> 
<OPTION value='764'>dice01</OPTION> 
<OPTION value='765'>dice02</OPTION> 
<OPTION value='766'>dice::box01</OPTION> 
<OPTION value='767'>dice::box02</OPTION> 
<OPTION value='768'>dice::box::loop</OPTION> 
<OPTION value='769'>dice::loop</OPTION> 
<OPTION value='770'>dogsled::run</OPTION> 
<OPTION value='771'>dogsled::stand</OPTION> 
<OPTION value='772'>downattack</OPTION> 
<OPTION value='773'>downb</OPTION> 
<OPTION value='774'>downb::hit</OPTION> 
<OPTION value='775'>downb::to::stand</OPTION> 
<OPTION value='776'>draw</OPTION> 
<OPTION value='777'>drum::low</OPTION> 
<OPTION value='778'>drum::low::stand::friendly</OPTION> 
<OPTION value='779'>drum::small</OPTION> 
<OPTION value='780'>drum::small::stand::friendly</OPTION> 
<OPTION value='781'>edo::skill::casting</OPTION> 
<OPTION value='782'>edo::skill::processing</OPTION> 
<OPTION value='783'>egosword::l</OPTION> 
<OPTION value='784'>egosword::r</OPTION> 
<OPTION value='785'>emotion::painful</OPTION> 
<OPTION value='786'>emotion::skill::fail::short</OPTION> 
<OPTION value='787'>emotion::skill::success</OPTION> 
<OPTION value='788'>evasion</OPTION> 
<OPTION value='789'>farm::indicate</OPTION> 
<OPTION value='790'>farm::paint::mix</OPTION> 
<OPTION value='791'>fashion::mistake</OPTION> 
<OPTION value='792'>fashion::walk</OPTION> 
<OPTION value='793'>alchemists::stand::friendly</OPTION> 
<OPTION value='794'>alchemists::stand::idle01</OPTION> 
<OPTION value='795'>alchemy::readingbook</OPTION> 
<OPTION value='796'>attack::01</OPTION> 
<OPTION value='797'>attack::02</OPTION> 
<OPTION value='798'>attack::03</OPTION> 
<OPTION value='799'>ax::axing</OPTION> 
<OPTION value='800'>balloon::boat::03::stand::friendly</OPTION> 
<OPTION value='801'>blowaway</OPTION> 
<OPTION value='802'>blowaway::body</OPTION> 
<OPTION value='803'>blowaway::endure</OPTION> 
<OPTION value='804'>blowaway::ground</OPTION> 
<OPTION value='805'>blowaway::turn</OPTION> 
<OPTION value='806'>brionacsword</OPTION> 
<OPTION value='807'>brionacsword::ending</OPTION> 
<OPTION value='808'>combat::counter</OPTION> 
<OPTION value='809'>combat::guard</OPTION> 
<OPTION value='810'>combat::smash::01</OPTION> 
<OPTION value='811'>curtain::call01</OPTION> 
<OPTION value='812'>curtain::call02</OPTION> 
<OPTION value='813'>cymbals</OPTION> 
<OPTION value='814'>cymbals::natural::stand::friendly</OPTION> 
<OPTION value='815'>cymbals::run</OPTION> 
<OPTION value='816'>cymbals::stand::friendly</OPTION> 
<OPTION value='817'>cymbals::walk</OPTION> 
<OPTION value='818'>dartgame::throw</OPTION> 
<OPTION value='819'>dartgame::wait</OPTION> 
<OPTION value='820'>dash::attack</OPTION> 
<OPTION value='821'>dash::run</OPTION> 
<OPTION value='822'>demigod::trans</OPTION> 
<OPTION value='823'>demi::lightspear::casting</OPTION> 
<OPTION value='824'>demi::lightspear::processing</OPTION> 
<OPTION value='825'>demi::lightstorm</OPTION> 
<OPTION value='826'>dice01</OPTION> 
<OPTION value='827'>dice02</OPTION> 
<OPTION value='828'>dice::box01</OPTION> 
<OPTION value='829'>dice::box02</OPTION> 
<OPTION value='830'>dice::box::loop</OPTION> 
<OPTION value='831'>dice::loop</OPTION> 
<OPTION value='832'>dogsled::run</OPTION> 
<OPTION value='833'>dogsled::stand</OPTION> 
<OPTION value='834'>downattack</OPTION> 
<OPTION value='835'>downb</OPTION> 
<OPTION value='836'>downb::hit</OPTION> 
<OPTION value='837'>downb::to::stand</OPTION> 
<OPTION value='838'>dragonhorn</OPTION> 
<OPTION value='839'>draw</OPTION> 
<OPTION value='840'>drum::low</OPTION> 
<OPTION value='841'>drum::low::stand::friendly</OPTION> 
<OPTION value='842'>drum::small</OPTION> 
<OPTION value='843'>drum::small::stand::friendly</OPTION> 
<OPTION value='844'>egosword::l</OPTION> 
<OPTION value='845'>egosword::r</OPTION> 
<OPTION value='846'>emotion::painful</OPTION> 
<OPTION value='847'>evasion</OPTION> 
<OPTION value='848'>fashion::mistake</OPTION> 
<OPTION value='849'>fashion::walk</OPTION> 
<OPTION value='850'>g2::ruairi::bendhisknees</OPTION> 
<OPTION value='851'>groggy</OPTION> 
<OPTION value='852'>gypsy::stand::friendly</OPTION> 
<OPTION value='853'>hammer::hammering</OPTION> 
<OPTION value='854'>hammer::wait</OPTION> 
<OPTION value='855'>handbell</OPTION> 
<OPTION value='856'>handbell::stand::friendly</OPTION> 
<OPTION value='857'>hand::d01::natural::walk</OPTION> 
<OPTION value='858'>hand::e01::natural::stand::01</OPTION> 
<OPTION value='859'>hand::h01::natural::walk</OPTION> 
<OPTION value='860'>hand::t01::natural::walk</OPTION> 
<OPTION value='861'>hita</OPTION> 
<OPTION value='862'>hitb</OPTION> 
<OPTION value='863'>icemine</OPTION> 
<OPTION value='864'>icemine::loop</OPTION> 
<OPTION value='865'>insect</OPTION> 
<OPTION value='866'>jousthorse::attack01::damage</OPTION> 
<OPTION value='867'>jousthorse::attack01::normal</OPTION> 
<OPTION value='868'>jousthorse::attack02::damage</OPTION> 
<OPTION value='869'>jousthorse::attack02::normal</OPTION> 
<OPTION value='870'>jousthorse::attack03::damage</OPTION> 
<OPTION value='871'>jousthorse::attack03::normal</OPTION> 
<OPTION value='872'>jousthorse::attack04::damage</OPTION> 
<OPTION value='873'>jousthorse::attack04::normal</OPTION> 
<OPTION value='874'>jousthorse::damage</OPTION> 
<OPTION value='875'>jousthorse::mount</OPTION> 
<OPTION value='876'>jousthorse::standfriendly</OPTION> 
<OPTION value='877'>jousthorse::turn</OPTION> 
<OPTION value='878'>jousthorse::win</OPTION> 
<OPTION value='879'>knight::stand::friendly</OPTION> 
<OPTION value='880'>levelup</OPTION> 
<OPTION value='881'>magic::casting::friendly</OPTION> 
<OPTION value='882'>magic::casting::offensive</OPTION> 
<OPTION value='883'>magic::healing::processing::tome</OPTION> 
<OPTION value='884'>magic::healing::processing::topc</OPTION> 
<OPTION value='885'>magic::processing::topc::offensive</OPTION> 
<OPTION value='886'>manure</OPTION> 
<OPTION value='887'>merchant::stand::friendly</OPTION> 
<OPTION value='888'>miniballoon::flying</OPTION> 
<OPTION value='889'>miniballoon::flying02</OPTION> 
<OPTION value='890'>natural::emotion::angry</OPTION> 
<OPTION value='891'>natural::emotion::assault(a01)</OPTION> 
<OPTION value='892'>natural::emotion::assault(t01)</OPTION> 
<OPTION value='893'>natural::emotion::assault</OPTION> 
<OPTION value='894'>natural::emotion::body</OPTION> 
<OPTION value='895'>natural::emotion::cheer</OPTION> 
<OPTION value='896'>natural::emotion::clothes</OPTION> 
<OPTION value='897'>natural::emotion::cry</OPTION> 
<OPTION value='898'>natural::emotion::curtsey</OPTION> 
<OPTION value='899'>natural::emotion::dance::typea</OPTION> 
<OPTION value='900'>natural::emotion::dance::typeb</OPTION> 
<OPTION value='901'>natural::emotion::dance::typec</OPTION> 
<OPTION value='902'>natural::emotion::dance::typed</OPTION> 
<OPTION value='903'>natural::emotion::discourage</OPTION> 
<OPTION value='904'>natural::emotion::followme</OPTION> 
<OPTION value='905'>natural::emotion::get01</OPTION> 
<OPTION value='906'>natural::emotion::get02</OPTION> 
<OPTION value='907'>natural::emotion::get03</OPTION> 
<OPTION value='908'>natural::emotion::greeting</OPTION> 
<OPTION value='909'>natural::emotion::handclap</OPTION> 
<OPTION value='910'>natural::emotion::hungry</OPTION> 
<OPTION value='911'>natural::emotion::laugh</OPTION> 
<OPTION value='912'>natural::emotion::me</OPTION> 
<OPTION value='913'>natural::emotion::music</OPTION> 
<OPTION value='914'>natural::emotion::musicend</OPTION> 
<OPTION value='915'>natural::emotion::musicstart</OPTION> 
<OPTION value='916'>natural::emotion::no</OPTION> 
<OPTION value='917'>natural::emotion::play</OPTION> 
<OPTION value='918'>natural::emotion::please</OPTION> 
<OPTION value='919'>natural::emotion::question</OPTION> 
<OPTION value='920'>natural::emotion::rude</OPTION> 
<OPTION value='921'>natural::emotion::rude01</OPTION> 
<OPTION value='922'>natural::emotion::salute</OPTION> 
<OPTION value='923'>natural::emotion::skill::fail::short</OPTION> 
<OPTION value='924'>natural::emotion::skill::success</OPTION> 
<OPTION value='925'>natural::emotion::smell</OPTION> 
<OPTION value='926'>natural::emotion::surprise</OPTION> 
<OPTION value='927'>natural::emotion::toy</OPTION> 
<OPTION value='928'>natural::emotion::yes!</OPTION> 
<OPTION value='929'>natural::emotion::yes</OPTION> 
<OPTION value='930'>natural::emotion::yes::for::cutscene</OPTION> 
<OPTION value='931'>natural::gathering::eggs</OPTION> 
<OPTION value='932'>natural::gathering::water::fromstream</OPTION> 
<OPTION value='933'>natural::gathering::water::fromwell</OPTION> 
<OPTION value='934'>natural::gathering::water::tree</OPTION> 
<OPTION value='935'>natural::handycraft</OPTION> 
<OPTION value='936'>natural::l::sit::rowing</OPTION> 
<OPTION value='937'>natural::magic::processing::topc::offensive::sprite</OPTION> 
<OPTION value='938'>natural::magic::shield</OPTION> 
<OPTION value='939'>natural::preparing::market</OPTION> 
<OPTION value='940'>natural::r::sit::rowing</OPTION> 
<OPTION value='941'>natural::sit::01</OPTION> 
<OPTION value='942'>natural::sit::01::a01</OPTION> 
<OPTION value='943'>natural::sit::01::d01</OPTION> 
<OPTION value='944'>natural::sit::01::h01</OPTION> 
<OPTION value='945'>natural::sit::01::t</OPTION> 
<OPTION value='946'>natural::sit::01::to::widestraight</OPTION> 
<OPTION value='947'>natural::sit::01::to::widestraight::a01</OPTION> 
<OPTION value='948'>natural::sit::01::to::widestraight::d01</OPTION> 
<OPTION value='949'>natural::sit::01::to::widestraight::e01</OPTION> 
<OPTION value='950'>natural::sit::01::to::widestraight::h01</OPTION> 
<OPTION value='951'>natural::sit::01::to::widestraight::t</OPTION> 
<OPTION value='952'>natural::sit::02</OPTION> 
<OPTION value='953'>natural::sit::02::a01</OPTION> 
<OPTION value='954'>natural::sit::02::t</OPTION> 
<OPTION value='955'>natural::sit::02::to::widestraight</OPTION> 
<OPTION value='956'>natural::sit::02::to::widestraight::02::e01</OPTION> 
<OPTION value='957'>natural::sit::02::to::widestraight::02::h01</OPTION> 
<OPTION value='958'>natural::sit::02::to::widestraight::a01</OPTION> 
<OPTION value='959'>natural::sit::02::to::widestraight::d01</OPTION> 
<OPTION value='960'>natural::sit::02::to::widestraight::t</OPTION> 
<OPTION value='961'>natural::sit::03</OPTION> 
<OPTION value='962'>natural::sit::03::to::widestraight</OPTION> 
<OPTION value='963'>natural::sit::05</OPTION> 
<OPTION value='964'>natural::sit::05::to::widestraight</OPTION> 
<OPTION value='965'>natural::sit::chair::01::g</OPTION> 
<OPTION value='966'>natural::sit::chair::01::to::widestraight::g</OPTION> 
<OPTION value='967'>natural::sit::chair::02</OPTION> 
<OPTION value='968'>natural::sit::chair::02::to::widestraight</OPTION> 
<OPTION value='969'>natural::sit::chair::03</OPTION> 
<OPTION value='970'>natural::sit::chair::03::to::widestraight</OPTION> 
<OPTION value='971'>natural::sit::moon</OPTION> 
<OPTION value='972'>natural::stand::01</OPTION> 
<OPTION value='973'>natural::stand::02</OPTION> 
<OPTION value='974'>natural::stand::03</OPTION> 
<OPTION value='975'>natural::stand::04</OPTION> 
<OPTION value='976'>natural::widestraight::to::sit::01</OPTION> 
<OPTION value='977'>natural::widestraight::to::sit::01::a01</OPTION> 
<OPTION value='978'>natural::widestraight::to::sit::01::d01</OPTION> 
<OPTION value='979'>natural::widestraight::to::sit::01::e01</OPTION> 
<OPTION value='980'>natural::widestraight::to::sit::01::h01</OPTION> 
<OPTION value='981'>natural::widestraight::to::sit::01::t</OPTION> 
<OPTION value='982'>natural::widestraight::to::sit::02</OPTION> 
<OPTION value='983'>natural::widestraight::to::sit::02::a01</OPTION> 
<OPTION value='984'>natural::widestraight::to::sit::02::e01</OPTION> 
<OPTION value='985'>natural::widestraight::to::sit::02::h01</OPTION> 
<OPTION value='986'>natural::widestraight::to::sit::02::t</OPTION> 
<OPTION value='987'>natural::widestraight::to::sit::03</OPTION> 
<OPTION value='988'>natural::widestraight::to::sit::05</OPTION> 
<OPTION value='989'>natural::widestraight::to::sit::chair::01::g</OPTION> 
<OPTION value='990'>natural::widestraight::to::sit::chair::02</OPTION> 
<OPTION value='991'>natural::widestraight::to::sit::chair::03</OPTION> 
<OPTION value='992'>natural::windmill::standing</OPTION> 
<OPTION value='993'>npc::weddingdressrent</OPTION> 
<OPTION value='994'>npc::weddingdressrent::talk</OPTION> 
<OPTION value='995'>paperairplane</OPTION> 
<OPTION value='996'>plane</OPTION> 
<OPTION value='997'>puppet::onehand::greeting</OPTION> 
<OPTION value='998'>puppet::onehand::horse::riding::natural::01::stand::friendly</OPTION> 
<OPTION value='999'>puppet::onehand::horse::riding::natural::02::stand::friendly</OPTION> 
<OPTION value='1000'>puppet::onehand::laugh</OPTION> 
<OPTION value='1001'>puppet::onehand::sit</OPTION> 
<OPTION value='1002'>puppet::onehand::sit::to::widestraight</OPTION> 
<OPTION value='1003'>puppet::onehand::stand::friendly</OPTION> 
<OPTION value='1004'>puppet::onehand::widestraight::to::sit</OPTION> 
<OPTION value='1005'>puppet::twohand::greeting</OPTION> 
<OPTION value='1006'>puppet::twohand::horse::riding::natural::01::stand::friendly</OPTION> 
<OPTION value='1007'>puppet::twohand::horse::riding::natural::02::stand::friendly</OPTION> 
<OPTION value='1008'>puppet::twohand::laugh</OPTION> 
<OPTION value='1009'>puppet::twohand::sit</OPTION> 
<OPTION value='1010'>puppet::twohand::sit::to::widestraight</OPTION> 
<OPTION value='1011'>puppet::twohand::stand::friendly</OPTION> 
<OPTION value='1012'>puppet::twohand::widestraight::to::sit</OPTION> 
<OPTION value='1013'>rowing</OPTION> 
<OPTION value='1014'>royalalchemist::stand::friendly</OPTION> 
<OPTION value='1015'>run::12</OPTION> 
<OPTION value='1016'>run::offensive</OPTION> 
<OPTION value='1017'>seesaw::end</OPTION> 
<OPTION value='1018'>seesaw::end::fist</OPTION> 
<OPTION value='1019'>seesaw::jumploop</OPTION> 
<OPTION value='1020'>seesaw::jumploop::fist</OPTION> 
<OPTION value='1021'>seesaw::prepare</OPTION> 
<OPTION value='1022'>seesaw::prepare::fist</OPTION> 
<OPTION value='1023'>sit::chair::01</OPTION> 
<OPTION value='1024'>sit::chair::01::to::widestraight</OPTION> 
<OPTION value='1025'>sit::eat</OPTION> 
<OPTION value='1026'>stand::friendly::01</OPTION> 
<OPTION value='1027'>stand::friendly::02</OPTION> 
<OPTION value='1028'>stand::friendly::l::sit::rowing</OPTION> 
<OPTION value='1029'>stand::friendly::rowing</OPTION> 
<OPTION value='1030'>stand::friendly::r::sit::rowing</OPTION> 
<OPTION value='1031'>stand::offensive</OPTION> 
<OPTION value='1032'>stomp::action</OPTION> 
<OPTION value='1033'>stomp::ready</OPTION> 
<OPTION value='1034'>taunt</OPTION> 
<OPTION value='1035'>throw::cast</OPTION> 
<OPTION value='1036'>throw::pick</OPTION> 
<OPTION value='1037'>throw::waiting</OPTION> 
<OPTION value='1038'>tool::ballista::01::aim</OPTION> 
<OPTION value='1039'>tool::ballista::01::charge</OPTION> 
<OPTION value='1040'>tool::ballista::01::shoot</OPTION> 
<OPTION value='1041'>tool::ballista::01::stand::friendly</OPTION> 
<OPTION value='1042'>tool::bhand::e01::attack::02::sprite</OPTION> 
<OPTION value='1043'>tool::bhand::e01::fishing::catching</OPTION> 
<OPTION value='1044'>tool::bhand::e01::fishing::catching::failure</OPTION> 
<OPTION value='1045'>tool::bhand::e01::fishing::throwing::float</OPTION> 
<OPTION value='1046'>tool::bhand::e01::fishing::waiting::01</OPTION> 
<OPTION value='1047'>tool::bhand::e01::fishing::waiting::02::female</OPTION> 
<OPTION value='1048'>tool::bhand::m02::playing::ppilili</OPTION> 
<OPTION value='1049'>tool::bhand::m02::playing::ppilili::walk</OPTION> 
<OPTION value='1050'>tool::bhand::m02::stand::friendly</OPTION> 
<OPTION value='1051'>tool::bhand::m08::playing::sousaphone</OPTION> 
<OPTION value='1052'>tool::bhand::m08::stand::friendly</OPTION> 
<OPTION value='1053'>tool::bhand::st::draw::backl</OPTION> 
<OPTION value='1054'>tool::bhand::st::magic::healing::processing::tome</OPTION> 
<OPTION value='1055'>tool::bhand::st::magic::healing::processing::topc</OPTION> 
<OPTION value='1056'>tool::bhand::st::stand::friendly</OPTION> 
<OPTION value='1057'>tool::bhand::z01::run::friendly</OPTION> 
<OPTION value='1058'>tool::bhand::z01::run::offensive</OPTION> 
<OPTION value='1059'>tool::bhand::z01::stand::friendly</OPTION> 
<OPTION value='1060'>tool::bhand::z01::stand::offensive</OPTION> 
<OPTION value='1061'>tool::bhand::z01::walk::friendly</OPTION> 
<OPTION value='1062'>tool::bhand::z01::walk::offensive</OPTION> 
<OPTION value='1063'>tool::bhand::z02::run::friendly</OPTION> 
<OPTION value='1064'>tool::bhand::z02::stand::friendly</OPTION> 
<OPTION value='1065'>tool::bhand::z02::walk::friendly</OPTION> 
<OPTION value='1066'>tool::bhand::z03::sit::chair::01::raisehand</OPTION> 
<OPTION value='1067'>tool::bhand::z03::sit::raisehand</OPTION> 
<OPTION value='1068'>tool::bhand::z03::stand::raisehand</OPTION> 
<OPTION value='1069'>tool::bhand::z04::run::friendly</OPTION> 
<OPTION value='1070'>tool::bhand::z04::stand::friendly</OPTION> 
<OPTION value='1071'>tool::bhand::z04::stand::offensive</OPTION> 
<OPTION value='1072'>tool::bhand::z04::using::lrod</OPTION> 
<OPTION value='1073'>tool::bhand::z04::walk::friendly</OPTION> 
<OPTION value='1074'>tool::bhand::z05::run::friendly</OPTION> 
<OPTION value='1075'>tool::bhand::z05::stand::friendly</OPTION> 
<OPTION value='1076'>tool::bhand::z05::walk::friendly</OPTION> 
<OPTION value='1077'>tool::cuttinggrape</OPTION> 
<OPTION value='1078'>tool::hand::a01::attack::01</OPTION> 
<OPTION value='1079'>tool::hand::a01::attack::02</OPTION> 
<OPTION value='1080'>tool::hand::a01::attack::03</OPTION> 
<OPTION value='1081'>tool::hand::a01::combat::counter</OPTION> 
<OPTION value='1082'>tool::hand::a01::combat::smash</OPTION> 
<OPTION value='1083'>tool::hand::a01::combat::windmill::standing</OPTION> 
<OPTION value='1084'>tool::hand::a01::draw</OPTION> 
<OPTION value='1085'>tool::hand::a01::magic::casting::friendly</OPTION> 
<OPTION value='1086'>tool::hand::a01::magic::casting::offensive</OPTION> 
<OPTION value='1087'>tool::hand::a01::magic::healing::processing::tome</OPTION> 
<OPTION value='1088'>tool::hand::a01::magic::healing::processing::topc</OPTION> 
<OPTION value='1089'>tool::hand::a01::magic::processing::topc::offensive</OPTION> 
<OPTION value='1090'>tool::hand::a01::natural::run</OPTION> 
<OPTION value='1091'>tool::hand::a01::natural::walk</OPTION> 
<OPTION value='1092'>tool::hand::a01::offensive::run</OPTION> 
<OPTION value='1093'>tool::hand::a01::offensive::walk</OPTION> 
<OPTION value='1094'>tool::hand::a01::stand::offensive</OPTION> 
<OPTION value='1095'>tool::hand::a01::taunt</OPTION> 
<OPTION value='1104'>tool::hand::a03::magic::casting::friendly</OPTION> 
<OPTION value='1105'>tool::hand::a03::magic::casting::offensive</OPTION> 
<OPTION value='1106'>tool::hand::a03::magic::fireball::casting::friendly</OPTION> 
<OPTION value='1107'>tool::hand::a03::magic::fireball::casting::offensive</OPTION> 
<OPTION value='1108'>tool::hand::a03::magic::fireball::processing::topc::offensive</OPTION> 
<OPTION value='1109'>tool::hand::a03::magic::healing::processing::tome</OPTION> 
<OPTION value='1110'>tool::hand::a03::magic::healing::processing::topc</OPTION> 
<OPTION value='1111'>tool::hand::a03::magic::icespear::casting::friendly</OPTION> 
<OPTION value='1112'>tool::hand::a03::magic::icespear::casting::offensive</OPTION> 
<OPTION value='1113'>tool::hand::a03::magic::icespear::processing::topc::offensive</OPTION> 
<OPTION value='1114'>tool::hand::a03::magic::processing::topc::offensive</OPTION> 
<OPTION value='1115'>tool::hand::a03::magic::thunder::casting::friendly</OPTION> 
<OPTION value='1116'>tool::hand::a03::magic::thunder::casting::offensive</OPTION> 
<OPTION value='1117'>tool::hand::a03::magic::thunder::processing::topc::offensive</OPTION> 
<OPTION value='1118'>tool::hand::a05::magic::casting::friendly</OPTION> 
<OPTION value='1119'>tool::hand::a05::magic::casting::offensive</OPTION> 
<OPTION value='1120'>tool::hand::a05::magic::healing::processing::tome</OPTION> 
<OPTION value='1121'>tool::hand::a05::magic::healing::processing::topc</OPTION> 
<OPTION value='1122'>tool::hand::a05::magic::processing::topc::offensive</OPTION> 
<OPTION value='1123'>tool::hand::c01::attack::01</OPTION> 
<OPTION value='1124'>tool::hand::c01::attack::02</OPTION> 
<OPTION value='1125'>tool::hand::c01::attack::03</OPTION> 
<OPTION value='1126'>tool::hand::c01::combat::counter</OPTION> 
<OPTION value='1127'>tool::hand::c01::combat::smash</OPTION> 
<OPTION value='1128'>tool::hand::c01::draw</OPTION> 
<OPTION value='1129'>tool::hand::c01::stand::offensive</OPTION> 
<OPTION value='1130'>tool::hand::c02::attack::01</OPTION> 
<OPTION value='1131'>tool::hand::c02::attack::02</OPTION> 
<OPTION value='1132'>tool::hand::c02::attack::03</OPTION> 
<OPTION value='1133'>tool::hand::c02::combat::counter</OPTION> 
<OPTION value='1134'>tool::hand::c02::combat::smash</OPTION> 
<OPTION value='1135'>tool::hand::c02::draw</OPTION> 
<OPTION value='1136'>tool::hand::c02::stand::offensive</OPTION> 
<OPTION value='1137'>tool::hand::c21::attack::01</OPTION> 
<OPTION value='1138'>tool::hand::c21::attack::02</OPTION> 
<OPTION value='1139'>tool::hand::c21::attack::03</OPTION> 
<OPTION value='1140'>tool::hand::c21::combat::counter</OPTION> 
<OPTION value='1141'>tool::hand::c21::combat::smash</OPTION> 
<OPTION value='1142'>tool::hand::c21::stand::offensive</OPTION> 
<OPTION value='1143'>tool::hand::c22::attack::01</OPTION> 
<OPTION value='1144'>tool::hand::c22::attack::02</OPTION> 
<OPTION value='1145'>tool::hand::c22::attack::03</OPTION> 
<OPTION value='1146'>tool::hand::c22::combat::counter</OPTION> 
<OPTION value='1147'>tool::hand::c22::combat::smash</OPTION> 
<OPTION value='1148'>tool::hand::c22::stand::offensive</OPTION> 
<OPTION value='1149'>tool::hand::d01::attack01</OPTION> 
<OPTION value='1150'>tool::hand::d01::attack02</OPTION> 
<OPTION value='1151'>tool::hand::d01::attack03</OPTION> 
<OPTION value='1152'>tool::hand::d01::combat::counter</OPTION> 
<OPTION value='1153'>tool::hand::d01::combat::smash</OPTION> 
<OPTION value='1154'>tool::hand::d01::combat::windmill::standing</OPTION> 
<OPTION value='1155'>tool::hand::d01::draw</OPTION> 
<OPTION value='1156'>tool::hand::d01::natural::run</OPTION> 
<OPTION value='1157'>tool::hand::d01::offensive::run</OPTION> 
<OPTION value='1158'>tool::hand::d01::offensive::walk</OPTION> 
<OPTION value='1159'>tool::hand::d01::stand::offensive</OPTION> 
<OPTION value='1160'>tool::hand::d01::taunt</OPTION> 
<OPTION value='1161'>tool::hand::f01::attack::01</OPTION> 
<OPTION value='1162'>tool::hand::f01::attack::02</OPTION> 
<OPTION value='1163'>tool::hand::f01::attack::03</OPTION> 
<OPTION value='1164'>tool::hand::f01::combat::counter</OPTION> 
<OPTION value='1165'>tool::hand::f01::combat::smash</OPTION> 
<OPTION value='1166'>tool::hand::f01::draw</OPTION> 
<OPTION value='1167'>tool::hand::f01::stand::offensive</OPTION> 
<OPTION value='1168'>tool::hand::f02::attack::01</OPTION> 
<OPTION value='1169'>tool::hand::f02::attack::02</OPTION> 
<OPTION value='1170'>tool::hand::f02::attack::03</OPTION> 
<OPTION value='1171'>tool::hand::f02::combat::counter</OPTION> 
<OPTION value='1172'>tool::hand::f02::combat::smash</OPTION> 
<OPTION value='1173'>tool::hand::f02::stand::offensive</OPTION> 
<OPTION value='1174'>tool::hand::gold::mining</OPTION> 
<OPTION value='1175'>tool::hand::h01::attack01</OPTION> 
<OPTION value='1176'>tool::hand::h01::attack03</OPTION> 
<OPTION value='1177'>tool::hand::h01::combat::counter</OPTION> 
<OPTION value='1178'>tool::hand::h01::combat::smash</OPTION> 
<OPTION value='1179'>tool::hand::h01::combat::windmill::standing</OPTION> 
<OPTION value='1180'>tool::hand::h01::draw</OPTION> 
<OPTION value='1181'>tool::hand::h01::magic::casting::friendly</OPTION> 
<OPTION value='1182'>tool::hand::h01::magic::casting::offensive</OPTION> 
<OPTION value='1183'>tool::hand::h01::magic::healing::processing::tome</OPTION> 
<OPTION value='1184'>tool::hand::h01::magic::healing::processing::topc</OPTION> 
<OPTION value='1185'>tool::hand::h01::magic::processing::topc::offensive</OPTION> 
<OPTION value='1186'>tool::hand::h01::natural::run</OPTION> 
<OPTION value='1187'>tool::hand::h01::natural::stand::01</OPTION> 
<OPTION value='1188'>tool::hand::h01::offensive::run</OPTION> 
<OPTION value='1189'>tool::hand::h01::offensive::walk</OPTION> 
<OPTION value='1190'>tool::hand::h01::stand::offensive</OPTION> 
<OPTION value='1191'>tool::hand::h01::taunt</OPTION> 
<OPTION value='1192'>tool::hand::n01::attack01</OPTION> 
<OPTION value='1193'>tool::hand::n01::attack02</OPTION> 
<OPTION value='1194'>tool::hand::n01::attack03</OPTION> 
<OPTION value='1195'>tool::hand::n01::combat::counter</OPTION> 
<OPTION value='1196'>tool::hand::n01::combat::smash</OPTION> 
<OPTION value='1197'>tool::hand::s01::attack01</OPTION> 
<OPTION value='1198'>tool::hand::s01::magic::casting::friendly</OPTION> 
<OPTION value='1199'>tool::hand::s01::magic::casting::offensive</OPTION> 
<OPTION value='1200'>tool::hand::s01::magic::healing::processing::tome</OPTION> 
<OPTION value='1201'>tool::hand::s01::magic::healing::processing::topc</OPTION> 
<OPTION value='1202'>tool::hand::s01::magic::processing::topc::offensive</OPTION> 
<OPTION value='1203'>tool::hand::s01::natural::run</OPTION> 
<OPTION value='1204'>tool::hand::s01::natural::stand::01</OPTION> 
<OPTION value='1205'>tool::hand::s01::natural::walk</OPTION> 
<OPTION value='1206'>tool::hand::s01::offensive::walk</OPTION> 
<OPTION value='1207'>tool::hand::s01::shooting::range::01</OPTION> 
<OPTION value='1208'>tool::hand::s01::stand::offensive</OPTION> 
<OPTION value='1209'>tool::hand::t01::attack01</OPTION> 
<OPTION value='1210'>tool::hand::t01::attack03</OPTION> 
<OPTION value='1211'>tool::hand::t01::combat::counter</OPTION> 
<OPTION value='1212'>tool::hand::t01::combat::smash</OPTION> 
<OPTION value='1213'>tool::hand::t01::combat::windmill::standing</OPTION> 
<OPTION value='1214'>tool::hand::t01::draw</OPTION> 
<OPTION value='1215'>tool::hand::t01::magic::casting::friendly</OPTION> 
<OPTION value='1216'>tool::hand::t01::magic::casting::offensive</OPTION> 
<OPTION value='1217'>tool::hand::t01::magic::healing::processing::tome</OPTION> 
<OPTION value='1218'>tool::hand::t01::magic::healing::processing::topc</OPTION> 
<OPTION value='1219'>tool::hand::t01::magic::processing::topc::offensive</OPTION> 
<OPTION value='1220'>tool::hand::t01::natural::run</OPTION> 
<OPTION value='1221'>tool::hand::t01::natural::stand::01</OPTION> 
<OPTION value='1222'>tool::hand::t01::offensive::walk</OPTION> 
<OPTION value='1223'>tool::hand::t01::stand::offensive</OPTION> 
<OPTION value='1224'>tool::hand::t01::taunt</OPTION>
<OPTION value='1244'>tool::lhand::b02::attack::01</OPTION> 
<OPTION value='1245'>tool::lhand::b02::attack::02</OPTION> 
<OPTION value='1246'>tool::lhand::b02::attack::03</OPTION> 
<OPTION value='1247'>tool::lhand::b02::combat::counter</OPTION> 
<OPTION value='1248'>tool::lhand::b02::combat::smash</OPTION> 
<OPTION value='1249'>tool::lhand::b02::dash::attack</OPTION> 
<OPTION value='1250'>tool::lhand::b02::dash::run</OPTION> 
<OPTION value='1251'>tool::lhand::b02::guard</OPTION> 
<OPTION value='1252'>tool::lhand::b02::hit::a</OPTION> 
<OPTION value='1253'>tool::lhand::b02::hit::b</OPTION> 
<OPTION value='1254'>tool::lhand::b02::run::friendly</OPTION> 
<OPTION value='1255'>tool::lhand::b02::run::offensive</OPTION> 
<OPTION value='1256'>tool::lhand::b02::stand::friendly</OPTION> 
<OPTION value='1257'>tool::lhand::b02::stand::offensive</OPTION> 
<OPTION value='1258'>tool::lhand::b02::taunt</OPTION> 
<OPTION value='1259'>tool::lhand::b02::walk::friendly</OPTION> 
<OPTION value='1260'>tool::lhand::b02::walk::offensive</OPTION> 
<OPTION value='1261'>tool::lhand::b02::windbreaker::prepare</OPTION> 
<OPTION value='1262'>tool::lhand::b02::windbreaker::wait</OPTION> 
<OPTION value='1263'>tool::lhand::draw::back</OPTION> 
<OPTION value='1281'>tool::rhand::a03::bolt::combine::friendly::one::hand::casting</OPTION> 
<OPTION value='1282'>tool::rhand::a03::bolt::combine::offensive::one::hand::casting</OPTION> 
<OPTION value='1283'>tool::rhand::a03::bolt::combine::two::hand::casting</OPTION> 
<OPTION value='1284'>tool::rhand::a03::slash::casting</OPTION> 
<OPTION value='1285'>tool::rhand::a03::slash::processing</OPTION> 
<OPTION value='1286'>tool::tequip::c01::cooking::01</OPTION> 
<OPTION value='1287'>tool::tequip::c01::cooking::02</OPTION> 
<OPTION value='1288'>tool::tequip::c01::cooking::03</OPTION> 
<OPTION value='1289'>tool::tequip::c01::cooking::04</OPTION> 
<OPTION value='1290'>tool::tequip::c01::magic::casting::friendly</OPTION> 
<OPTION value='1291'>tool::tequip::c01::magic::casting::offensive</OPTION> 
<OPTION value='1292'>tool::tequip::c01::magic::healing::processing::tome</OPTION> 
<OPTION value='1293'>tool::tequip::c01::magic::healing::processing::topc</OPTION> 
<OPTION value='1294'>tool::tequip::c01::magic::processing::topc::offensive</OPTION> 
<OPTION value='1295'>tool::tequip::c99::magic::casting::friendly</OPTION> 
<OPTION value='1296'>tool::tequip::c99::magic::casting::offensive</OPTION> 
<OPTION value='1297'>tool::tequip::c99::magic::healing::processing::tome</OPTION> 
<OPTION value='1298'>tool::tequip::c99::magic::healing::processing::topc</OPTION> 
<OPTION value='1299'>tool::tequip::c99::magic::processing::topc::offensive</OPTION> 
<OPTION value='1300'>tool::tequip::draw::fab01</OPTION> 
<OPTION value='1301'>tool::turret::draw</OPTION> 
<OPTION value='1302'>tool::turret::explosion</OPTION> 
<OPTION value='1303'>tool::turret::friendly</OPTION> 
<OPTION value='1304'>tool::turret::hita</OPTION> 
<OPTION value='1305'>tool::turret::install</OPTION> 
<OPTION value='1306'>tool::turret::install02</OPTION> 
<OPTION value='1307'>tool::turret::offensive</OPTION> 
<OPTION value='1308'>tool::turret::shoot</OPTION> 
<OPTION value='1309'>tool::turret::shoot::ready</OPTION> 
<OPTION value='1310'>tool::turret::uninstall</OPTION> 
<OPTION value='1311'>topiary</OPTION> 
<OPTION value='1312'>walk::12</OPTION> 
<OPTION value='1313'>walk::offensive</OPTION> 
<OPTION value='1314'>wateringpot</OPTION> 
<OPTION value='1315'>watermelon</OPTION> 
<OPTION value='1316'>wedding::flower::walk</OPTION> 
<OPTION value='1317'>wedding::mutual::bowing</OPTION> 
<OPTION value='1318'>wedding::walk</OPTION> 
<OPTION value='1319'>widestraight::to::sit::chair::01</OPTION> 
<OPTION value='1320'>wizard::stand::friendly</OPTION> 
<OPTION value='1321'>handbell</OPTION> 
<OPTION value='1322'>handbell::stand::friendly</OPTION> 
<OPTION value='1323'>hita</OPTION> 
<OPTION value='1324'>hitb</OPTION> 
<OPTION value='1325'>hug01</OPTION> 
<OPTION value='1326'>icemine</OPTION> 
<OPTION value='1327'>icemine::loop</OPTION> 
<OPTION value='1328'>insect</OPTION> 
<OPTION value='1329'>knight::changejobs01</OPTION> 
<OPTION value='1330'>knight::stand::friendly</OPTION> 
<OPTION value='1331'>knight::stand::idle01</OPTION> 
<OPTION value='1332'>levelup</OPTION> 
<OPTION value='1333'>magic::casting::friendly</OPTION> 
<OPTION value='1334'>magic::casting::offensive</OPTION> 
<OPTION value='1335'>magic::healing::processing::tome</OPTION> 
<OPTION value='1336'>magic::healing::processing::topc</OPTION> 
<OPTION value='1337'>magic::processing::topc::offensive</OPTION> 
<OPTION value='1338'>balloon::boat::03::stand::friendly</OPTION> 
<OPTION value='1339'>curtain::call01</OPTION> 
<OPTION value='1340'>curtain::call02</OPTION> 
<OPTION value='1341'>natural::emotion::angry</OPTION> 
<OPTION value='1342'>natural::emotion::assault(a01)</OPTION> 
<OPTION value='1343'>natural::emotion::assault(t01)</OPTION> 
<OPTION value='1344'>natural::emotion::assault</OPTION> 
<OPTION value='1345'>natural::emotion::cheer</OPTION> 
<OPTION value='1346'>natural::emotion::clothes</OPTION> 
<OPTION value='1347'>natural::emotion::cry</OPTION> 
<OPTION value='1348'>natural::emotion::discourage</OPTION> 
<OPTION value='1349'>natural::emotion::flex</OPTION> 
<OPTION value='1350'>natural::emotion::followme</OPTION> 
<OPTION value='1354'>natural::emotion::greeting</OPTION> 
<OPTION value='1355'>natural::emotion::handclap</OPTION> 
<OPTION value='1356'>natural::emotion::hungry</OPTION> 
<OPTION value='1357'>natural::emotion::laugh</OPTION> 
<OPTION value='1358'>natural::emotion::me</OPTION> 
<OPTION value='1359'>natural::emotion::music</OPTION> 
<OPTION value='1360'>natural::emotion::no</OPTION> 
<OPTION value='1361'>natural::emotion::play</OPTION> 
<OPTION value='1362'>natural::emotion::please</OPTION> 
<OPTION value='1363'>natural::emotion::question</OPTION> 
<OPTION value='1364'>natural::emotion::rude</OPTION> 
<OPTION value='1365'>natural::emotion::smell</OPTION> 
<OPTION value='1366'>natural::emotion::surprise</OPTION> 
<OPTION value='1367'>natural::emotion::toy</OPTION> 
<OPTION value='1368'>natural::emotion::yes!</OPTION> 
<OPTION value='1369'>natural::emotion::yes</OPTION> 
<OPTION value='1370'>skill::magicbubble::drop</OPTION> 
<OPTION value='1371'>skill::magicbubble::landing</OPTION> 
<OPTION value='1372'>skill::magicbubble::stay</OPTION> 
<OPTION value='1377'>wedding::mutual::bowing</OPTION> 
<OPTION value='1378'>manure</OPTION> 
<OPTION value='1379'>merchant::stand::friendly</OPTION> 
<OPTION value='1380'>merchant::stand::idle01</OPTION> 
<OPTION value='1381'>miniballoon::flying</OPTION> 
<OPTION value='1382'>miniballoon::flying02</OPTION> 
<OPTION value='1407'>natural::emotion::curtsey</OPTION> 
<OPTION value='1409'>natural::emotion::dance::typea</OPTION> 
<OPTION value='1410'>natural::emotion::dance::typeb</OPTION> 
<OPTION value='1411'>natural::emotion::dance::typec</OPTION> 
<OPTION value='1412'>natural::emotion::dance::typed</OPTION> 
<OPTION value='1444'>natural::gathering::eggs</OPTION> 
<OPTION value='1445'>natural::gathering::herb</OPTION> 
<OPTION value='1446'>natural::gathering::water::fromstream</OPTION> 
<OPTION value='1447'>natural::gathering::water::fromwell</OPTION> 
<OPTION value='1448'>natural::gathering::water::tree</OPTION> 
<OPTION value='1451'>natural::handycraft</OPTION> 
<OPTION value='1487'>natural::sit::moon</OPTION> 
<OPTION value='1488'>natural::stand::01</OPTION> 
<OPTION value='1489'>natural::stand::02</OPTION> 
<OPTION value='1490'>natural::stand::03</OPTION> 
<OPTION value='1491'>natural::stand::04</OPTION> 
<OPTION value='1515'>ninja::alterego::casting</OPTION> 
<OPTION value='1516'>ninja::alterego::processing</OPTION> 
<OPTION value='1517'>paperairplane</OPTION> 
<OPTION value='1518'>plane</OPTION> 
<OPTION value='1519'>player::sword::get01</OPTION> 
<OPTION value='1520'>player::sword::get02</OPTION> 
<OPTION value='1521'>play::king::talk01</OPTION> 
<OPTION value='1522'>play::king::talk02</OPTION> 
<OPTION value='1523'>play::king::talk03</OPTION> 
<OPTION value='1524'>preparing::market</OPTION> 
<OPTION value='1525'>puppet::onehand::greeting</OPTION> 
<OPTION value='1528'>puppet::onehand::laugh</OPTION> 
<OPTION value='1529'>puppet::onehand::sit</OPTION> 
<OPTION value='1530'>puppet::onehand::sit::to::widestraight</OPTION> 
<OPTION value='1531'>puppet::onehand::stand::friendly</OPTION> 
<OPTION value='1532'>puppet::onehand::widestraight::to::sit</OPTION> 
<OPTION value='1533'>puppet::twohand::greeting</OPTION> 
<OPTION value='1536'>puppet::twohand::laugh</OPTION> 
<OPTION value='1537'>puppet::twohand::sit</OPTION> 
<OPTION value='1538'>puppet::twohand::sit::to::widestraight</OPTION> 
<OPTION value='1539'>puppet::twohand::stand::friendly</OPTION> 
<OPTION value='1540'>puppet::twohand::widestraight::to::sit</OPTION> 
<OPTION value='1541'>royalalchemist::stand::friendly</OPTION> 
<OPTION value='1542'>run::12</OPTION> 
<OPTION value='1543'>run::offensive</OPTION> 
<OPTION value='1544'>sit::01</OPTION> 
<OPTION value='1571'>stand::friendly::l::sit::rowing</OPTION> 
<OPTION value='1572'>stand::friendly::rowing</OPTION> 
<OPTION value='1573'>stand::friendly::r::sit::rowing</OPTION> 
<OPTION value='1574'>stand::offensive</OPTION> 
<OPTION value='1575'>stealthily::walk01</OPTION> 
<OPTION value='1576'>stomp::action</OPTION> 
<OPTION value='1577'>stomp::ready</OPTION> 
<OPTION value='1578'>taunt</OPTION> 
<OPTION value='1581'>throw::cast</OPTION> 
<OPTION value='1582'>throw::pick</OPTION> 
<OPTION value='1583'>throw::waiting</OPTION> 
<OPTION value='1718'>tool::hand::a01::attack01</OPTION> 
<OPTION value='1719'>tool::hand::a01::attack02</OPTION> 
<OPTION value='1720'>tool::hand::a01::attack03</OPTION> 
<OPTION value='1721'>tool::hand::a01::combat::counter</OPTION> 
<OPTION value='1722'>tool::hand::a01::combat::smash</OPTION> 
<OPTION value='1723'>tool::hand::a01::combat::windmill::standing</OPTION> 
<OPTION value='1724'>tool::hand::a01::draw</OPTION> 
<OPTION value='1725'>tool::hand::a01::magic::casting::friendly</OPTION> 
<OPTION value='1726'>tool::hand::a01::magic::casting::offensive</OPTION> 
<OPTION value='1727'>tool::hand::a01::magic::healing::processing::tome</OPTION> 
<OPTION value='1728'>tool::hand::a01::magic::healing::processing::topc</OPTION> 
<OPTION value='1729'>tool::hand::a01::magic::processing::topc::offensive</OPTION> 
<OPTION value='1730'>tool::hand::a01::natural::run</OPTION> 
<OPTION value='1731'>tool::hand::a01::natural::walk</OPTION> 
<OPTION value='1732'>tool::hand::a01::offensive::run</OPTION> 
<OPTION value='1733'>tool::hand::a01::offensive::walk</OPTION> 
<OPTION value='1734'>tool::hand::a01::stand::offensive</OPTION> 
<OPTION value='1735'>tool::hand::a01::taunt</OPTION> 
<OPTION value='1736'>tool::hand::a02::attack01</OPTION> 
<OPTION value='1737'>tool::hand::a02::attack02</OPTION> 
<OPTION value='1738'>tool::hand::a02::attack03</OPTION> 
<OPTION value='1739'>tool::hand::a02::combat::counter</OPTION> 
<OPTION value='1740'>tool::hand::a02::combat::smash</OPTION> 
<OPTION value='1741'>tool::hand::a02::draw</OPTION> 
<OPTION value='1742'>tool::hand::a02::stand::offensive</OPTION> 
<OPTION value='1743'>tool::hand::a02::taunt</OPTION> 
<OPTION value='1744'>tool::hand::a03::magic::casting::friendly</OPTION> 
<OPTION value='1745'>tool::hand::a03::magic::casting::offensive</OPTION> 
<OPTION value='1746'>tool::hand::a03::magic::fireball::casting::friendly</OPTION> 
<OPTION value='1747'>tool::hand::a03::magic::fireball::casting::offensive</OPTION> 
<OPTION value='1748'>tool::hand::a03::magic::fireball::processing::topc::offensiv</OPTION> 
<OPTION value='1749'>tool::hand::a03::magic::healing::processing::tome</OPTION> 
<OPTION value='1750'>tool::hand::a03::magic::healing::processing::topc</OPTION> 
<OPTION value='1751'>tool::hand::a03::magic::icespear::casting::friendly</OPTION> 
<OPTION value='1752'>tool::hand::a03::magic::icespear::casting::offensive</OPTION> 
<OPTION value='1753'>tool::hand::a03::magic::icespear::processing::topc::offensive</OPTION> 
<OPTION value='1754'>tool::hand::a03::magic::processing::topc::offensive</OPTION> 
<OPTION value='1755'>tool::hand::a03::magic::thunder::casting::friendly</OPTION> 
<OPTION value='1756'>tool::hand::a03::magic::thunder::casting::offensive</OPTION> 
<OPTION value='1757'>tool::hand::a03::magic::thunder::processing::topc::offensive</OPTION> 
<OPTION value='1758'>tool::hand::a05::magic::casting::friendly</OPTION> 
<OPTION value='1759'>tool::hand::a05::magic::casting::offensive</OPTION> 
<OPTION value='1760'>tool::hand::a05::magic::healing::processing::tome</OPTION> 
<OPTION value='1761'>tool::hand::a05::magic::healing::processing::topc</OPTION> 
<OPTION value='1762'>tool::hand::a05::magic::processing::topc::offensive</OPTION> 
<OPTION value='1771'>tool::hand::c01::attack01</OPTION> 
<OPTION value='1772'>tool::hand::c01::attack02</OPTION> 
<OPTION value='1773'>tool::hand::c01::attack03</OPTION> 
<OPTION value='1774'>tool::hand::c01::combat::counter</OPTION> 
<OPTION value='1775'>tool::hand::c01::combat::smash</OPTION> 
<OPTION value='1776'>tool::hand::c01::draw</OPTION> 
<OPTION value='1777'>tool::hand::c01::stand::offensive</OPTION> 
<OPTION value='1778'>tool::hand::c02::attack01</OPTION> 
<OPTION value='1779'>tool::hand::c02::attack02</OPTION> 
<OPTION value='1780'>tool::hand::c02::attack03</OPTION> 
<OPTION value='1781'>tool::hand::c02::combat::counter</OPTION> 
<OPTION value='1782'>tool::hand::c02::combat::smash</OPTION> 
<OPTION value='1783'>tool::hand::c02::draw</OPTION> 
<OPTION value='1784'>tool::hand::c02::stand::offensive</OPTION> 
<OPTION value='1785'>tool::hand::c21::attack01</OPTION> 
<OPTION value='1786'>tool::hand::c21::attack02</OPTION> 
<OPTION value='1787'>tool::hand::c21::attack03</OPTION> 
<OPTION value='1788'>tool::hand::c21::combat::counter</OPTION> 
<OPTION value='1789'>tool::hand::c21::combat::smash</OPTION> 
<OPTION value='1790'>tool::hand::c21::stand::offensive</OPTION> 
<OPTION value='1791'>tool::hand::c22::attack01</OPTION> 
<OPTION value='1792'>tool::hand::c22::attack02</OPTION> 
<OPTION value='1793'>tool::hand::c22::attack03</OPTION> 
<OPTION value='1794'>tool::hand::c22::combat::counter</OPTION> 
<OPTION value='1795'>tool::hand::c22::combat::smash</OPTION> 
<OPTION value='1796'>tool::hand::c22::stand::offensive</OPTION> 
<OPTION value='1797'>tool::hand::d01::attack01</OPTION> 
<OPTION value='1798'>tool::hand::d01::attack02</OPTION> 
<OPTION value='1799'>tool::hand::d01::attack03</OPTION> 
<OPTION value='1800'>tool::hand::d01::combat::counter</OPTION> 
<OPTION value='1801'>tool::hand::d01::combat::smash</OPTION> 
<OPTION value='1802'>tool::hand::d01::combat::windmill::standing</OPTION> 
<OPTION value='1803'>tool::hand::d01::draw</OPTION> 
<OPTION value='1804'>tool::hand::d01::natural::run</OPTION> 
<OPTION value='1805'>tool::hand::d01::natural::walk</OPTION> 
<OPTION value='1806'>tool::hand::d01::offensive::run</OPTION> 
<OPTION value='1807'>tool::hand::d01::offensive::walk</OPTION> 
<OPTION value='1808'>tool::hand::d01::stand::offensive</OPTION> 
<OPTION value='1809'>tool::hand::d01::taunt</OPTION> 
<OPTION value='1842'>tool::hand::gold::mining</OPTION> 
<OPTION value='1843'>tool::hand::h01::attack01</OPTION> 
<OPTION value='1844'>tool::hand::h01::attack02</OPTION> 
<OPTION value='1845'>tool::hand::h01::attack03</OPTION> 
<OPTION value='1846'>tool::hand::h01::combat::counter</OPTION> 
<OPTION value='1847'>tool::hand::h01::combat::smash</OPTION> 
<OPTION value='1848'>tool::hand::h01::combat::windmill::standing</OPTION> 
<OPTION value='1849'>tool::hand::h01::draw</OPTION> 
<OPTION value='1850'>tool::hand::h01::magic::casting::friendly</OPTION> 
<OPTION value='1851'>tool::hand::h01::magic::casting::offensive</OPTION> 
<OPTION value='1852'>tool::hand::h01::magic::healing::processing::tome</OPTION> 
<OPTION value='1853'>tool::hand::h01::magic::healing::processing::topc</OPTION> 
<OPTION value='1854'>tool::hand::h01::magic::processing::topc::offensive</OPTION> 
<OPTION value='1860'>tool::hand::h01::offensive::run</OPTION> 
<OPTION value='1861'>tool::hand::h01::offensive::walk</OPTION> 
<OPTION value='1862'>tool::hand::h01::stand::offensive</OPTION> 
<OPTION value='1863'>tool::hand::h01::taunt</OPTION> 
<OPTION value='1873'>tool::hand::s01::attack01</OPTION> 
<OPTION value='1874'>tool::hand::s01::magic::casting::friendly</OPTION> 
<OPTION value='1875'>tool::hand::s01::magic::casting::offensive</OPTION> 
<OPTION value='1876'>tool::hand::s01::magic::healing::processing::tome</OPTION> 
<OPTION value='1877'>tool::hand::s01::magic::healing::processing::topc</OPTION> 
<OPTION value='1878'>tool::hand::s01::magic::processing::topc::offensive</OPTION> 
<OPTION value='1879'>tool::hand::s01::natural::run</OPTION> 
<OPTION value='1880'>tool::hand::s01::natural::stand::01</OPTION> 
<OPTION value='1881'>tool::hand::s01::natural::walk</OPTION> 
<OPTION value='1882'>tool::hand::s01::offensive::run</OPTION> 
<OPTION value='1883'>tool::hand::s01::offensive::walk</OPTION> 
<OPTION value='1884'>tool::hand::s01::shooting::range::01</OPTION> 
<OPTION value='1885'>tool::hand::s01::stand::offensive</OPTION> 
<OPTION value='1886'>tool::hand::t01::attack01</OPTION> 
<OPTION value='1887'>tool::hand::t01::attack03</OPTION> 
<OPTION value='1888'>tool::hand::t01::combat::counter</OPTION> 
<OPTION value='1889'>tool::hand::t01::combat::smash</OPTION> 
<OPTION value='1890'>tool::hand::t01::combat::windmill::standing</OPTION> 
<OPTION value='1891'>tool::hand::t01::draw</OPTION> 
<OPTION value='1892'>tool::hand::t01::magic::casting::friendly</OPTION> 
<OPTION value='1893'>tool::hand::t01::magic::casting::offensive</OPTION> 
<OPTION value='1894'>tool::hand::t01::magic::healing::processing::tome</OPTION> 
<OPTION value='1895'>tool::hand::t01::magic::healing::processing::topc</OPTION> 
<OPTION value='1896'>tool::hand::t01::magic::processing::topc::offensive</OPTION> 
<OPTION value='1897'>tool::hand::t01::natural::run</OPTION> 
<OPTION value='1898'>tool::hand::t01::natural::run::01</OPTION> 
<OPTION value='1899'>tool::hand::t01::natural::stand::01</OPTION> 
<OPTION value='1900'>tool::hand::t01::natural::walk</OPTION> 
<OPTION value='1901'>tool::hand::t01::natural::walk::01</OPTION> 
<OPTION value='1902'>tool::hand::t01::offensive::run</OPTION> 
<OPTION value='1903'>tool::hand::t01::offesive::walk</OPTION> 
<OPTION value='1904'>tool::hand::t01::stand::offensive</OPTION> 
<OPTION value='1905'>tool::hand::t01::taunt</OPTION> 
<OPTION value='1906'>tool::lance::assault::slash::casting</OPTION> 
<OPTION value='1907'>tool::lance::assault::slash::processing</OPTION> 
<OPTION value='1908'>tool::lance::attack01</OPTION> 
<OPTION value='1909'>tool::lance::attack02</OPTION> 
<OPTION value='1910'>tool::lance::attack03</OPTION> 
<OPTION value='1911'>tool::lance::b02::stance::attack</OPTION> 
<OPTION value='1912'>tool::lance::b02::stance::finish</OPTION> 
<OPTION value='1913'>tool::lance::b02::stance::prepare</OPTION> 
<OPTION value='1914'>tool::lance::blowaway</OPTION> 
<OPTION value='1915'>tool::lance::blowaway::body</OPTION> 
<OPTION value='1916'>tool::lance::blowaway::endure</OPTION> 
<OPTION value='1917'>tool::lance::blowaway::ground</OPTION> 
<OPTION value='1918'>tool::lance::blowaway::turn</OPTION> 
<OPTION value='1919'>tool::lance::combat::smash</OPTION> 
<OPTION value='1920'>tool::lance::combat::smash::b02</OPTION> 
<OPTION value='1921'>tool::lance::combat::windmill::standing</OPTION> 
<OPTION value='1922'>tool::lance::combat::windmill::standing::b02</OPTION> 
<OPTION value='1923'>tool::lance::dash::attack01</OPTION> 
<OPTION value='1924'>tool::lance::dash::attack01::b02</OPTION> 
<OPTION value='1925'>tool::lance::dash::attack02</OPTION> 
<OPTION value='1926'>tool::lance::dash::run</OPTION> 
<OPTION value='1927'>tool::lance::dash::run::b02</OPTION> 
<OPTION value='1928'>tool::lance::downb</OPTION> 
<OPTION value='1929'>tool::lance::draw::back</OPTION> 
<OPTION value='1930'>tool::lance::friendly::run</OPTION> 
<OPTION value='1931'>tool::lance::friendly::walk</OPTION> 
<OPTION value='1932'>tool::lance::groggy</OPTION> 
<OPTION value='1933'>tool::lance::hita</OPTION> 
<OPTION value='1934'>tool::lance::hitb</OPTION> 
<OPTION value='1935'>tool::lance::magic::casting::friendly</OPTION> 
<OPTION value='1936'>tool::lance::magic::casting::offensive</OPTION> 
<OPTION value='1937'>tool::lance::magic::healing::processing::tome</OPTION> 
<OPTION value='1938'>tool::lance::magic::healing::processing::topc</OPTION> 
<OPTION value='1939'>tool::lance::magic::processing::topc::offensive01</OPTION> 
<OPTION value='1940'>tool::lance::offensive::run</OPTION> 
<OPTION value='1941'>tool::lance::offensive::run::b02</OPTION> 
<OPTION value='1942'>tool::lance::offensive::walk</OPTION> 
<OPTION value='1943'>tool::lance::offensive::walk::b02</OPTION> 
<OPTION value='1944'>tool::lance::skill::windbreaker::prepare</OPTION> 
<OPTION value='1945'>tool::lance::skill::windbreaker::wait</OPTION> 
<OPTION value='1946'>tool::lance::stance::attack</OPTION> 
<OPTION value='1947'>tool::lance::stance::attack01</OPTION> 
<OPTION value='1948'>tool::lance::stance::attack02</OPTION> 
<OPTION value='1949'>tool::lance::stance::finish</OPTION> 
<OPTION value='1950'>tool::lance::stance::finish01</OPTION> 
<OPTION value='1951'>tool::lance::stance::finish02</OPTION> 
<OPTION value='1952'>tool::lance::stance::offensive01</OPTION> 
<OPTION value='1953'>tool::lance::stance::offensive02</OPTION> 
<OPTION value='1954'>tool::lance::stance::prepare</OPTION> 
<OPTION value='1955'>tool::lance::stance::prepare01</OPTION> 
<OPTION value='1956'>tool::lance::stance::prepare02</OPTION> 
<OPTION value='1957'>tool::lance::stand::friendly</OPTION> 
<OPTION value='1958'>tool::lance::stand::offensive</OPTION> 
<OPTION value='1959'>tool::lance::taunt</OPTION> 
<OPTION value='1960'>tool::lhand::b01::attack::01</OPTION> 
<OPTION value='1961'>tool::lhand::b01::attack::02</OPTION> 
<OPTION value='1962'>tool::lhand::b01::attack::03</OPTION> 
<OPTION value='1963'>tool::lhand::b01::combat::counter</OPTION> 
<OPTION value='1964'>tool::lhand::b01::combat::smash</OPTION> 
<OPTION value='1965'>tool::lhand::b01::dash::attack</OPTION> 
<OPTION value='1966'>tool::lhand::b01::dash::run</OPTION> 
<OPTION value='1967'>tool::lhand::b01::guard</OPTION> 
<OPTION value='1968'>tool::lhand::b01::hit::a</OPTION> 
<OPTION value='1969'>tool::lhand::b01::hit::b</OPTION> 
<OPTION value='1975'>tool::lhand::b01::run::friendly</OPTION> 
<OPTION value='1976'>tool::lhand::b01::run::offensive</OPTION> 
<OPTION value='1977'>tool::lhand::b01::stand::friendly</OPTION> 
<OPTION value='1978'>tool::lhand::b01::stand::offensive</OPTION> 
<OPTION value='1979'>tool::lhand::b01::taunt</OPTION> 
<OPTION value='1980'>tool::lhand::b01::walk::friendly</OPTION> 
<OPTION value='1981'>tool::lhand::b01::walk::offensive</OPTION> 
<OPTION value='1982'>tool::lhand::b01::windbreaker::prepare</OPTION> 
<OPTION value='1983'>tool::lhand::b01::windbreaker::wait</OPTION> 
<OPTION value='1984'>tool::lhand::b02::attack::01</OPTION> 
<OPTION value='1985'>tool::lhand::b02::attack::02</OPTION> 
<OPTION value='1986'>tool::lhand::b02::attack::03</OPTION> 
<OPTION value='1987'>tool::lhand::b02::combat::counter</OPTION> 
<OPTION value='1988'>tool::lhand::b02::combat::smash</OPTION> 
<OPTION value='1989'>tool::lhand::b02::dash::attack</OPTION> 
<OPTION value='1990'>tool::lhand::b02::dash::run</OPTION> 
<OPTION value='1991'>tool::lhand::b02::guard</OPTION> 
<OPTION value='1992'>tool::lhand::b02::hit::a</OPTION> 
<OPTION value='1993'>tool::lhand::b02::hit::b</OPTION> 
<OPTION value='1994'>tool::lhand::b02::run::friendly</OPTION> 
<OPTION value='1995'>tool::lhand::b02::run::offensive</OPTION> 
<OPTION value='1996'>tool::lhand::b02::stand::friendly</OPTION> 
<OPTION value='1997'>tool::lhand::b02::stand::offensive</OPTION> 
<OPTION value='1998'>tool::lhand::b02::taunt</OPTION> 
<OPTION value='1999'>tool::lhand::b02::walk::friendly</OPTION> 
<OPTION value='2000'>tool::lhand::b02::walk::offensive</OPTION> 
<OPTION value='2001'>tool::lhand::b02::windbreaker::prepare</OPTION> 
<OPTION value='2002'>tool::lhand::b02::windbreaker::wait</OPTION> 
<OPTION value='2003'>tool::lhand::draw::back</OPTION> 
<OPTION value='2004'>tool::rfarm::fa01::alchemy::critical::explosion</OPTION> 
<OPTION value='2005'>tool::rfarm::fa01::alchemy::draw</OPTION> 
<OPTION value='2006'>tool::rfarm::fa01::alchemy::explosion</OPTION> 
<OPTION value='2007'>tool::rfarm::fa01::alchemy::skill::casting</OPTION> 
<OPTION value='2008'>tool::rfarm::fa01::alchemy::skill::processing</OPTION> 
<OPTION value='2009'>tool::rfarm::fa01::alchemy::skill::processing02</OPTION> 
<OPTION value='2010'>tool::rfarm::fa01::alchemy::skill::processing03</OPTION> 
<OPTION value='2011'>tool::rfarm::fa01::alchemy::skill::processing04</OPTION> 
<OPTION value='2012'>tool::rfarm::fa01::b02::alchemy::skill::casting</OPTION> 
<OPTION value='2086'>tool::staff::blizzardstrike::casting</OPTION> 
<OPTION value='2087'>tool::staff::blizzardstrike::charging</OPTION> 
<OPTION value='2088'>tool::staff::blizzardstrike::processing01</OPTION> 
<OPTION value='2089'>tool::staff::blizzardstrike::processing02</OPTION> 
<OPTION value='2090'>tool::staff::counter</OPTION> 
<OPTION value='2091'>tool::staff::smash</OPTION> 
<OPTION value='2182'>tool::turret::draw</OPTION> 
<OPTION value='2183'>tool::turret::explosion</OPTION> 
<OPTION value='2184'>tool::turret::friendly</OPTION> 
<OPTION value='2185'>tool::turret::hita</OPTION> 
<OPTION value='2186'>tool::turret::install</OPTION> 
<OPTION value='2188'>tool::turret::offensive</OPTION> 
<OPTION value='2189'>tool::turret::shoot</OPTION> 
<OPTION value='2190'>tool::turret::shoot::ready</OPTION> 
<OPTION value='2191'>tool::turret::uninstall</OPTION> 
<OPTION value='2192'>topiary</OPTION> 
<OPTION value='2193'>walk::12</OPTION> 
<OPTION value='2194'>walk::offensive</OPTION> 
<OPTION value='2195'>wateringpot</OPTION> 
<OPTION value='2196'>watermelon</OPTION> 
<OPTION value='2197'>wedding::walk</OPTION> 

<OPTION value='2206'>widestraight::to::sit::chair::01</OPTION> 

<OPTION value='2213'>npc::taunes</OPTION> 
<OPTION value='2215'>npc::taunes::talk</OPTION> 

<OPTION value='2218'>npc::wedding</OPTION> 
<OPTION value='2219'>npc::wedding::talk</OPTION> 
<OPTION value='2223'>npc::zeder</OPTION> 
<OPTION value='2224'>npc::zeder::talk</OPTION> 

<OPTION value='2233'>umbrella::run::friendly01</OPTION> 
<OPTION value='2234'>umbrella::run::friendly02</OPTION> 
<OPTION value='2235'>umbrella::run::friendly03</OPTION> 
<OPTION value='2236'>umbrella::sit</OPTION> 
<OPTION value='2237'>umbrella::sit::to::widestraight</OPTION> 
<OPTION value='2238'>umbrella::stand::friendly</OPTION> 
<OPTION value='2239'>umbrella::walk</OPTION> 
<OPTION value='2240'>umbrella::widestraight::to::sit</OPTION> 

<OPTION value='2241'>anohana::poppo::stand</OPTION> 

<OPTION value='2254'>pillow::attack01</OPTION>
<OPTION value='2255'>pillow::attack02</OPTION>
<OPTION value='2256'>pillow::attack03</OPTION>
<OPTION value='2257'>pillow::blowaway::body</OPTION>
<OPTION value='2258'>pillow::blowaway::ground</OPTION>
<OPTION value='2259'>pillow::blowaway::head::up</OPTION>
<OPTION value='2260'>pillow::blowaway::spin</OPTION>
<OPTION value='2261'>pillow::counter</OPTION>
<OPTION value='2262'>pillow::defence</OPTION>
<OPTION value='2263'>pillow::downb-to-stand</OPTION>
<OPTION value='2264'>pillow::downb</OPTION>
<OPTION value='2265'>pillow::friendly::run</OPTION>
<OPTION value='2266'>pillow::friendly::walk</OPTION>
<OPTION value='2267'>pillow::groggy</OPTION>
<OPTION value='2268'>pillow::hita</OPTION>
<OPTION value='2269'>pillow::hitb</OPTION>
<OPTION value='2270'>pillow::offensive</OPTION>
<OPTION value='2271'>pillow::offensive::run</OPTION>
<OPTION value='2272'>pillow::offensive::walk</OPTION>
<OPTION value='2273'>pillow::sit-to-stand</OPTION>
<OPTION value='2274'>pillow::sit</OPTION>
<OPTION value='2275'>pillow::smash</OPTION>
<OPTION value='2276'>pillow::stand-to-sit</OPTION>
<OPTION value='2277'>pillow::stand::friendly</OPTION>


<OPTION value='2278'>marionette::natural::sit::03</OPTION>
<OPTION value='2279'>marionette::natural::sit::03::to::widestraight</OPTION>
<OPTION value='2280'>marionette::natural::widestraight::to::sit::03</OPTION>
<OPTION value='2281'>marionette::run::friendly</OPTION>
<OPTION value='2282'>marionette::stand::friendly</OPTION>
<OPTION value='2283'>marionette::walk::friendly</OPTION>
<OPTION value='2284'>marionette::attack01</OPTION>
<OPTION value='2285'>marionette::attack02</OPTION>
<OPTION value='2286'>marionette::attack03</OPTION>
<OPTION value='2287'>marionette::a::attack01</OPTION>
<OPTION value='2288'>marionette::a::attack02</OPTION>
<OPTION value='2289'>marionette::a::attack03</OPTION>
<OPTION value='2290'>marionette::a::catastrophe::casting</OPTION>
<OPTION value='2291'>marionette::a::catastrophe::processing</OPTION>
<OPTION value='2292'>marionette::a::dash::casting</OPTION>
<OPTION value='2293'>marionette::a::dash::processing</OPTION>
<OPTION value='2294'>marionette::a::hita</OPTION>
<OPTION value='2295'>marionette::a::hitb</OPTION>
<OPTION value='2296'>marionette::a::operation</OPTION>
<OPTION value='2297'>marionette::a::separation</OPTION>
<OPTION value='2298'>marionette::a::smash</OPTION>
<OPTION value='2299'>marionette::a::spiral::casting</OPTION>
<OPTION value='2300'>marionette::a::spiral::processing</OPTION>
<OPTION value='2301'>marionette::a::stand::offensive</OPTION>
<OPTION value='2302'>marionette::a::windmill</OPTION>
<OPTION value='2303'>marionette::b::attack01</OPTION>
<OPTION value='2304'>marionette::b::attack02</OPTION>
<OPTION value='2305'>marionette::b::attack03</OPTION>
<OPTION value='2306'>marionette::b::catastrophe::casting</OPTION>
<OPTION value='2307'>marionette::b::catastrophe::processing</OPTION>
<OPTION value='2308'>marionette::b::dash::casting</OPTION>
<OPTION value='2309'>marionette::b::dash::processing</OPTION>
<OPTION value='2310'>marionette::b::hita</OPTION>
<OPTION value='2311'>marionette::b::hitb</OPTION>
<OPTION value='2312'>marionette::b::operation</OPTION>
<OPTION value='2313'>marionette::b::repair</OPTION>
<OPTION value='2314'>marionette::b::separation</OPTION>
<OPTION value='2315'>marionette::b::smash</OPTION>
<OPTION value='2316'>marionette::b::spiral::casting</OPTION>
<OPTION value='2317'>marionette::b::spiral::processing</OPTION>
<OPTION value='2318'>marionette::b::stand::offensive</OPTION>
<OPTION value='2319'>marionette::b::windmill</OPTION>
<OPTION value='2320'>marionette::defence</OPTION>
<OPTION value='2321'>marionette::draw</OPTION>
<OPTION value='2322'>marionette::run</OPTION>
<OPTION value='2323'>marionette::run::friendly</OPTION>
<OPTION value='2324'>marionette::sit::01</OPTION>
<OPTION value='2325'>marionette::sit::01::to::widestraight</OPTION>
<OPTION value='2326'>marionette::smash</OPTION>
<OPTION value='2327'>marionette::stand::friendly</OPTION>
<OPTION value='2328'>marionette::walk</OPTION>
<OPTION value='2329'>marionette::walk::friendly</OPTION>
<OPTION value='2330'>marionette::widestraight::to::sit::01</OPTION>
<OPTION value='2331'>marionette::wirebinding</OPTION>
<OPTION value='2332'>marionette::wirepulling</OPTION>
<OPTION value='2333'>marionette::gypsy::stand::friendly</OPTION>

<OPTION value='2334'>npc::fallon</OPTION>
<OPTION value='2338'>npc::hagel::stand::friendly</OPTION>
<OPTION value='2339'>npc::trefor</OPTION>
<OPTION value='2241'>anohana::poppo::stand</OPTION>

<OPTION value='2340'>Emotion::pumkinbat::event</OPTION>
<OPTION value='2341'>Emotion::cloth::fix::stand::friendly</OPTION>
<OPTION value='2342'>Emotion::cold02</OPTION>
<OPTION value='2343'>Emotion::cutie</OPTION>
<OPTION value='2357'>Emotion::folder::arm</OPTION>
<OPTION value='2358'>Emotion::foxmonster::tail</OPTION>
<OPTION value='2359'>Emotion::gaze::around</OPTION>
<OPTION value='2360'>Emotion::head::shake</OPTION>
<OPTION value='2361'>Emotion::jump</OPTION>
<OPTION value='2362'>Emotion::mambo::dance</OPTION>
<OPTION value='2363'>Emotion::offer</OPTION>
<OPTION value='2364'>Emotion::politely::greeting</OPTION>
<OPTION value='2365'>Emotion::revolution02</OPTION>
<OPTION value='2366'>Emotion::shaman</OPTION>
<OPTION value='2367'>Emotion::side::die</OPTION>
<OPTION value='2368'>Emotion::stand::friendly01</OPTION>
<OPTION value='2369'>Emotion::surprise02</OPTION>
<OPTION value='2370'>Emotion::tarzan</OPTION>
<OPTION value='2371'>Emotion::trip</OPTION>

<OPTION value='2372'>Vocaloid::Kaito</OPTION>
<OPTION value='2375'>Vocaloid::Ren</OPTION>
<OPTION value='2376'>Vocaloid::EGuitar::playing::walk</OPTION>
<OPTION value='2377'>Vocaloid::EGuitar::playing</OPTION>
<OPTION value='2378'>Vocaloid::EGuitar::run::friendly</OPTION>
<OPTION value='2379'>Vocaloid::EGuitar::stand::friendly</OPTION>
<OPTION value='2380'>Vocaloid::EGuitar::walk::friendly</OPTION>
</select> 


			</td>
		</tr>
		<tr id="animationControllerBlock" >
			<td>
				<table class="animationControllerFrame" border="0" cellpadding="0" cellspacing="0">
					<tbody>
						<tr>
							<td class="secondaryControllerHeader">
								<a href="javascript:void(0);" onClick="toggleMotionController();" id="motionControllerController" class="secondaryControllerHeader">+ Motion Controller</a>
							</td>
						</tr>
						<tr id="motionControllerBlock" style="display:none;">
							<td class="secondaryControllerBlock">
								<span style="padding-left:0px;margin-left:2px;margin-bottom:3px;">
								<img id="playButton" alt="play/pause/stop" src=" stop.png" width="16" height="16" onClick="toggleAnimate();">
								<img id="resetFrameButton" alt="go to first frame" src=" resetframe.png" width="16" height="16" onClick="resetFrame();">
								<img id="scanBackwardButton" alt="scan backward" src=" scanbackward.png" width="16" height="16" onClick="scanBackward();"><!--
								--><img id="slowmotionBackwardButton" alt="backward slowmotion" src=" slowmotionbackward.png" width="16" height="16" onClick="slowmotionBackward();"><!--
								--><img id="stepbackButton" alt="previous frame" src=" stepbackward.png" width="16" height="16" onClick="stepBackward();"><!--
								--><img id="stepforwardButton" alt="next frane" src=" stepforward.png" width="16" height="16" onClick="stepForward();"><!--
								--><img id="slowmotionForwardButton" alt="forward slowmotion" src=" slowmotionforward.png" width="16" height="16" onClick="slowmotionForward();"><!--
								--><img id="scanForwardButton" alt="scan forward" src=" scanforward.png" width="16" height="16" onClick="scanForward();">
								</span>
								<br />
								
								<img src=" marker.png" alt="" style="position: relative;" id="mainFrameSliderTip"><br>
								<img src=" frame.png" alt="frame slider" width="390" height="16" onMouseMove="if(dragging)changeAnimationMainFrame();" onMouseDown="mouseDown(this);" onMouseUp="mouseUp(this);" onClick="changeAnimationMainFrame();mouseUp(this);" onDragStart="return false;" onMouseWheel="changeAnimationMainFrameW();return false;"><br>
								<img src=" marker.png" alt="" style="position: relative;" id="subFrameSliderTip"><br>
								<img src=" subframe.png" alt="subframe slider" width="390" height="16" onMouseMove="if(dragging)changeAnimationSubFrame();" onMouseDown="mouseDown(this);" onMouseUp="mouseUp(this);" onClick="changeAnimationSubFrame();mouseUp(this);" onDragStart="return false;" onMouseWheel="changeAnimationSubFrameW();return false;"><br>
								<img src=" marker.png" alt="" style="position: relative;" id="superSubFrameSliderTip"><br>
								<img src=" supersubframe.png" alt="supersubframe slider" width="390" height="16" onMouseMove="if(dragging)changeAnimationSuperSubFrame();" onMouseDown="mouseDown(this);" onMouseUp="mouseUp(this);" onClick="changeAnimationSuperSubFrame();mouseUp(this);" onDragStart="return false;" onMouseWheel="changeAnimationSuperSubFrameW();return false;">
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>
</td>
</tr>
<tr id="physicalBlock">
<td class="controllerBlock">
<div class="block" style="float:left;padding-right:1px;">
	<label for="heightSelector" class="controllerHeader">Height:</label><br>
	<select name="heightSelector" onChange="changeScaleByMenu();">
								<option value="0">10years old (130cm)</option>
								<option value="1">11years old (134cm)</option>
								<option value="2">11.5years old (137cm)</option>
								<option value="3">12years old (140cm)</option>
								<option value="4">13years old (144cm)</option>
								<option value="5">13.5years old (147cm)</option>
								<option value="6">14years old (150cm)</option>
								<option value="7">15years old (154cm)</option>
								<option value="8">15.5years old (157cm)</option>
								<option value="9">16years old (160cm)</option>
								<option value="10">17years old (164cm)</option>
								<option value="11">18years old (167cm)</option>
								<option value="12">19years old (170cm)</option>
								<option value="13">20years old (174cm)</option>
								<option value="14">21years old (177cm)</option>
								<option value="15">22years old (180cm)</option>
								<option value="16">23years old (184cm)</option>
								<option value="17">24years old (187cm)</option>
								<option value="18">25years old (190cm)</option>
								<option value="19">26years old (194cm)</option>
								<option value="20">27years old (197cm)</option>
			</select>
</div>
<div class="block" style="float:left;padding-right:1px;">
	<span class="controllerHeader">Fatness:</span><br />
	<select name="fatnessSelector" onChange="changeScaleByMenu();">
					<option value="4">20kg</option>
					<option value="5">25kg</option>
					<option value="6">30kg</option>
					<option value="7">35kg</option>
					<option value="8">40kg</option>
					<option value="9">45kg</option>
					<option value="10">50kg</option>
					<option value="11">55kg</option>
					<option value="12">60kg</option>
					<option value="13">65kg</option>
					<option value="14">70kg</option>
					<option value="15">75kg</option>
					<option value="16">80kg</option>
					<option value="17">85kg</option>
					<option value="18">90kg</option>
					<option value="19">95kg</option>
					<option value="20">100kg</option>
			</select>
</div>

<div class="block" style="float:left;padding-right:1px;">
	<span class="controllerHeader">Top:</span><br />
	<select name="topSelector" onChange="changeScaleByMenu();">
		<option value="3">- !......:....... +</option>
		<option value="4">- .!.....:....... +</option>
		<option value="5">- ..!....:....... +</option>
		<option value="6">- ...!...:....... +</option>
		<option value="7">- ....!..:....... +</option>
		<option value="8">- .....!.:....... +</option>
		<option value="9">- ......!:....... +</option>
   <option value="10" selected>- .......!....... +</option>
		<option value="11">- .......:!...... +</option>
		<option value="12">- .......:.!..... +</option>
		<option value="13">- .......:..!.... +</option>
		<option value="14">- .......:...!... +</option>
		<option value="15">- .......:....!.. +</option>
		<option value="16">- .......:.....!. +</option>
		<option value="17">- .......:......! +</option>
	</select>
</div>
			
<div class="block" style="float:left;padding-right:1px;">
	<span class="controllerHeader">Bottom:</span><br />
	<select name="bottomSelector" onChange="changeScaleByMenu();">
		<option value="3">- !......:....... +</option>
		<option value="4">- .!.....:....... +</option>
		<option value="5">- ..!....:....... +</option>
		<option value="6">- ...!...:....... +</option>
		<option value="7">- ....!..:....... +</option>
		<option value="8">- .....!.:....... +</option>
		<option value="9">- ......!:....... +</option>
   <option value="10" selected>- .......!....... +</option>
		<option value="11">- .......:!...... +</option>
		<option value="12">- .......:.!..... +</option>
		<option value="13">- .......:..!.... +</option>
		<option value="14">- .......:...!... +</option>
		<option value="15">- .......:....!.. +</option>
		<option value="16">- .......:.....!. +</option>
		<option value="17">- .......:......! +</option>
	</select>
</div>
</td>
</tr>


<tr id="hairBlock" >
<td class="controllerBlock">
<table border="0" cellpadding="0" cellspacing="0">
	<tbody>
		<tr>
			<td>
				<span class="controllerHeader">Hair Style:</span><br>
				<select name="hairMenu" onChange = "changeHair(this.value)" style="width:150px;">
<OPTION value="59">웨이브 파팅_턱수염</OPTION>
<OPTION value="63">웨이브 스웹백_턱수염</OPTION>
<OPTION value="67">숏 컬링 헤어_턱수염</OPTION>
<OPTION value="71">스마트 숀 헤어_턱수염</OPTION>
<OPTION value="75">드래드락_턱수염</OPTION>
<OPTION value="79">ﾚｰｻﾞｰｶｯﾄ 1</OPTION>
<OPTION value="83">ｽﾄｰﾑﾍｱ 1</OPTION>
<OPTION value="87">워터폴 헤어 스타일_턱수염</OPTION>
<OPTION value="91">내츄럴 셰이프 헤어_턱수염</OPTION>
<OPTION value="95">브레이디드 룩_턱수염</OPTION>
<OPTION value="99">스텐드 숏 컷_턱수염</OPTION>
<OPTION value="103">하드테일 웨이브_턱수염</OPTION>
<OPTION value="107">슈팅스타_턱수염</OPTION>
<OPTION value="108">アレックス・ルイ・アームストロングヘア</OPTION>
<OPTION value="109">Swept Cut_Beard</OPTION>
<OPTION value="110">Mid-Length Pullback_Beard</OPTION>
<OPTION value="111">폿포 헤어 스타일</OPTION>

</select>

			</td>
			<td width="1"></td>
			<td>
				<span class="controllerHeader">Hair Color:</span><br>
				<select name="hairColorMenu" onChange = "changeHairColor(this.value)" style="width:130px;">


<option style='background-color:#000000;' value="0" selected>ブラック</option>

<option style='background-color:#211C39;' value="1">ブルーブラック</option>

<option style='background-color:#424563;' value="2">ブルーグレー</option>

<option style='background-color:#5A4D8C;' value="3">バイオレット</option>

<option style='background-color:#7B8AAD;' value="4">ライトブルー</option>

<option style='background-color:#ADAEC6;' value="5">ﾗｲﾄﾊﾞｲｵﾚｯﾄ</option>

<option style='background-color:#E7E3FF;' value="6">ｼﾙﾊﾞｰﾊﾞｲｵﾚｯﾄ</option>

<option style='background-color:#FFF38C;' value="7">ブロンド</option>

<option style='background-color:#EF9252;' value="8">オレンジ</option>

<option style='background-color:#C67139;' value="9">ライトブラウン</option>

<option style='background-color:#C61400;' value="10">レッド</option>

<option style='background-color:#7B2C10;' value="11">ブラウン</option>

<option style='background-color:#393839;' value="12">ダークグレー</option>

<option style='background-color:#330000;' value="13">ﾀﾞｰｸﾌﾞﾗｳﾝﾚｯﾄﾞ</option>

<option style='background-color:#663300;' value="14">ｵｰｸﾛｰｽﾞﾚｯﾄﾞ</option>

<option style='background-color:#CC9933;' value="15">カーキー</option>

<option style='background-color:#999999;' value="16">ムースグレー</option>

<option style='background-color:#996666;' value="17">グレーチェリー</option>

<option style='background-color:#9C5D42;' value="18">ｶｯﾊﾟｰﾌﾞﾗｳﾝ</option>

<option style='background-color:#333300;' value="19">ﾙｰﾅｻｸﾞﾘｰﾝ</option>

<option style='background-color:#336666;' value="20">ｲﾒﾝﾏﾊﾌﾞﾙｰ</option>

<option style='background-color:#996600;' value="21">オクロス</option>

<option style='background-color:#FFFFCC;' value="22">ｼﾙﾊﾞｰﾌﾞﾛﾝﾄﾞ</option>

<option style='background-color:#FFCC66;' value="23">リッチブロンド</option>

<option style='background-color:#990033;' value="24">カレントレッド</option>

<option style='background-color:#666666;' value="25">ディムグレー</option>

<option style='background-color:#003300;' value="26">チークグリーン</option>

<option style='background-color:#CCCC66;' value="27">ライトオリーブ</option>

<option style='background-color:#FFFF66;' value="28">レモンイエロー</option>

<option style='background-color:#FFCC33;' value="29">ｶﾅﾘｱｲｴﾛｰ</option>

<option style='background-color:#CCCC99;' value="30">ワームグレー</option>

<option style='background-color:#999999;' value="31">レイングレー</option>

<option style='background-color:#BD7D21;' value="32">ダークオレンジ</option>

<option style='background-color:#FFD7B5;' value="33">サンドピンク</option>

<option style='background-color:#6699FF;' value="34">イウェカブルー</option>

<option style='background-color:#CC0000;' value="35">ﾌﾞﾗｯﾃﾞｨﾚｯﾄﾞ</option>

<option style='background-color:#CCFFCC;' value="36">ﾎﾜｲﾄｴﾒﾗﾙﾄﾞ</option>

<option style='background-color:#99CCFF;' value="37">アイスブルー</option>

<option style='background-color:#FF9999;' value="38">サーモンピンク</option>

<option style='background-color:#FF9933;' value="39">ﾒﾙﾀﾞｼｰﾄｲｴﾛｰ</option>

<option style='background-color:#99FF99;' value="40">イリアグリーン</option>

<option style='background-color:#CCCCFF;' value="41">ミスリルホワイト</option>
<option style='background-color:#FFFFFF;' value="42">セラフィムホワイト</option>
<option style='background-color:#FF66CC;' value="43">ホットピンク</option>
<option style='background-color:#663333;' value="44">チョコレートブラウン</option>
<option style='background-color:#CC9999;' value="45">ロージーブラウン</option></select>

				<span class="colorPaletteMini" id="hairPalette" onClick="dyeColor(this);changeHairColorByPalette();" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>

				<input type="text" value="7f7f7f" size="6" name="hairColor">
				<a class="controllerLink" href="javascript:void(0);" onClick="dyeHair(hairColor.value);">&nbsp;Dye</a>

			</td>
		</tr>
	</tbody>
</table>
</td>
</tr>
<tr id="eyeBlock" >
<td class="controllerBlock">
<table border="0" cellpadding="0" cellspacing="0">
	<tbody>
		<tr>
			<td>
				<span class="controllerHeader">Eye Style:</span><br>
				<select name="eyeEmotionMenu" onChange = "changeEyeEmotion(this.value)" style="width:150px;">
<OPTION value="45">Intense Eyes</OPTION>
<OPTION value="46">Heartfelt Eyes</OPTION>
<OPTION value="47">Powerful Eyes</OPTION>
<OPTION value="48">Sharp Eyes</OPTION>
<OPTION value="49">Solemn Eyes</OPTION>
<OPTION value="50">Focused Eyes</OPTION>
<OPTION value="51">Calm Eyes</OPTION>
<OPTION value="52">Gazing Eyes</OPTION>
<OPTION value="53">Hawk Eyes</OPTION>
<OPTION value="54">Confident Eyes</OPTION>
<OPTION value="55">Lion Eyes</OPTION>
<OPTION value="56">Dark Eyes</OPTION>
<OPTION value="95">怒った目</OPTION>
<OPTION value="97">Apathetic Eyes</OPTION>
<OPTION value="107">Righteous Eyes</OPTION>
<OPTION value="116">알렉스 루이 암스트롱의 눈빛</OPTION>
<OPTION value="119">Beastly Eyes</OPTION>
<OPTION value="121">남자자이언트 폿포눈</OPTION>

</select>

			</td>
			<td width="1"></td>
			<td>
				<span class="controllerHeader">Eye Color:</span><br>
				<select name="eyeColorMenu" onChange = "changeEyeColor(this.value)" style="width:130px;">

<option style='background-color:#633C31;' value="0" selected>暗褐色</option>

<option style='background-color:#003399;' value="1">ブルー</option>

<option style='background-color:#211C39;' value="2">ブルーブラック</option>

<option style='background-color:#000099;' value="3">ウルトラマリン</option>

<option style='background-color:#330000;' value="4">オークブラウン</option>

<option style='background-color:#660066;' value="5">ﾀﾞｰｸﾊﾞｲｵﾚｯﾄ</option>

<option style='background-color:#5A4D8C;' value="6">バイオレット</option>

<option style='background-color:#C61400;' value="7">レッド</option>

<option style='background-color:#000000;' value="8">ピュアブラック</option>

<option style='background-color:#006600;' value="9">グリーン</option>

<option style='background-color:#C67139;' value="10">ライトブラウン</option>

<option style='background-color:#424563;' value="11">ブルーグレー</option>

<option style='background-color:#393839;' value="12">ダークグレー</option>

<option style='background-color:#333300;' value="13">ｼｭﾘｰｳﾞｸﾞﾘｰﾝ</option>

<option style='background-color:#990000;' value="14">カーマイン</option>

<option style='background-color:#003333;' value="15">ｱｽﾞﾃﾞｨｰﾌﾟｸﾞﾘｰﾝ</option>

<option style='background-color:#996666;' value="16">ワームグレー</option>

<option style='background-color:#999966;' value="17">グリニッシュ</option>

<option style='background-color:#006666;' value="18">シアナグリーン</option>

<option style='background-color:#666666;' value="19">グレー</option>

<option style='background-color:#FF9900;' value="20">アンバー</option>

<option style='background-color:#7B8AAD;' value="21">ライトブルー</option>

<option style='background-color:#99CCCC;' value="22">ﾅﾙｼｻｽﾌﾞﾙｰ</option>

<option style='background-color:#CEAAAD;' value="23">グレーレッド</option>

<option style='background-color:#C6794A;' value="24">レッドブラウン</option>

<option style='background-color:#9999CC;' value="25">ﾗｲﾄﾊﾞｲｵﾚｯﾄ</option>

<option style='background-color:#CC6600;' value="26">ビビッドオレンジ</option>

<option style='background-color:#6699CC;' value="27">ｽﾁｰﾙﾌﾞﾙｰ</option>

<option style='background-color:#009966;' value="28">バジル</option>

<option style='background-color:#3399CC;' value="29">ﾌｪｱｷﾞｽﾌﾞﾙｰ</option>

<option style='background-color:#66CC99;' value="30">スカイグリーン</option>

<option style='background-color:#CC3366;' value="31">マリーローズ</option>

<option style='background-color:#0099FF;' value="32">サマースカイ</option>

<option style='background-color:#9C5D42;' value="33">カッパーブラウン</option>

<option style='background-color:#B58A7B;' value="34">コーヒー</option>
</select>

				<span class="colorPaletteMini" id="eyePalette" onClick="dyeColor(this);changeEyeColorByPalette();" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>


				<input type="text" value="7f7f7f" size="6" name="eyeColor">
				<a class="controllerLink" href="javascript:void(0);" onClick="dyeEye(eyeColor.value);">&nbsp;Dye</a>

			</td>
		</tr>
	</tbody>
</table>
</td>
</tr>
<tr id="faceBlock" >
<td class="controllerBlock">
<table border="0" cellpadding="0" cellspacing="0">
	<tbody>
		<tr>
			<td>
				<span class="controllerHeader">Face:</span><br>
				<select name="faceMenu" onChange = "changeFace(this.value)">
<OPTION value="14">자이언트 남자 얼굴</OPTION>
<OPTION value="15">크루크</OPTION>
<OPTION value="16">타우네스</OPTION>
<OPTION value="17">레우스</OPTION>
<OPTION value="18">바르바</OPTION>

</select>

			</td>
			<td width="1"></td>
			<td>
				<span class="controllerHeader">Mouth:</span><br>
				<select name="mouthEmotionMenu" onChange = "changeMouthEmotion(this.value)">
<OPTION value="26">Tightly Shut Mouth</OPTION>
<OPTION value="27">Firm Mouth</OPTION>
<OPTION value="28">Relaxed Mouth</OPTION>
<OPTION value="29">Warm Smile</OPTION>
<OPTION value="30">Whispering Mouth</OPTION>

</select>

			</td>
			<td width="1"></td>
			<td>
			
	<span class="controllerHeader">Face Reaction:</span><br />
	<select name="reactionMenu" onChange = "changeReaction(this.value)">
<option value="0" selected>(普)</option>
<option value="1">(笑)</option>
<option value="2">(怒)</option>
<option value="3">(真)</option>
<option value="4">(痒)</option>
<option value="5">(混)</option>
<option value="6">(辛)</option>
<option value="7">(優)</option>
<option value="8">(驚)</option>
<option value="9">(愛)</option>
<option value="10">(悲)</option>
<option value="11">(疑)</option>
<option value="12">(幸)</option>
<option value="13">(嫌)</option>
<option value="14">(恥)</option>
<option value="15">(輝)</option>
<option value="16">(衝)</option>
<option value="17">(泣)</option>
<option value="18">(怪)</option>
<option value="19">(緊)</option>
<option value="20">(静)</option>
<option value="21">(嬉)</option>
<option value="22">(喜)</option>
<option value="23">(暖)</option>
<option value="24">(奇)</option>
<option value="25">(情)</option>
<option value="26">(叫)</option>
<option value="27">(惨)</option>
<option value="28">(呆)</option>
<option value="29">(邪)</option>
<option value="30">(照)</option>
<option value="31">(酸)</option>
<option value="32">(苦)</option>
<option value="33">(恐)</option>
<option value="34">(睨)</option>
<option value="35">(疲)</option>
<option value="36">(黙)</option>
<option value="37">(悪)</option>
<option value="38">(痛)</option>
<option value="39">(萌)</option>
<option value="40">(感)</option>
<option value="41">(酔)</option>
<option value="42">(変)</option>
<option value="43">(正)</option>
</select>
			</td>
			
		</tr>
	</tbody>
</table>
<table border="0" cellpadding="0" cellspacing="0">
	<tbody>
		<tr>
			<td>
				<span class="controllerHeader">Skin Color:</span><br>
				<select name="skinColorMenu" onChange = "changeSkinColor(this.value)">


<option style='background-color:#F7EFFF;' value="0" selected>[HEG]美白色</option>

<option style='background-color:#F7F3DE;' value="1">[HEG]白黄色</option>

<option style='background-color:#EFE3B5;' value="2">[HEG]濃い黄色</option>

<option style='background-color:#FFE3B5;' value="3">[HEG]薄い黄色</option>

<option style='background-color:#FFD7B5;' value="4">[HEG]黄色</option>

<option style='background-color:#FFC7C6;' value="5">[HE]桃色</option>

<option style='background-color:#CEAAAD;' value="6">[HG]赤茶色</option>

<option style='background-color:#B58A7B;' value="7">[HG]コーヒー色</option>

<option style='background-color:#ADAAA5;' value="8">[HG]土色</option>

<option style='background-color:#9C5D42;' value="9">[HG]茶色</option>

<option style='background-color:#C6794A;' value="10">[HG]赤褐色</option>

<option style='background-color:#633C31;' value="11">[HG]暗褐色</option>


</select>

				<span class="colorPaletteMini" id="skinPalette" onClick="dyeColor(this);changeSkinColorByPalette();" onContextMenu="pickColor(this);return false;" ><img src="sp.gif"></span>
				<input type="text" value="7f7f7f" size="6" name="skinColor">
				<a class="controllerLink" href="javascript:void(0);" onClick="dyeSkin(skinColor.value);">&nbsp;Dye</a>
			</td>
		</tr>
	</tbody>
</table>
</td>
</tr>
</tbody>
</table>

<table width="430" border="0" cellpadding="0" cellspacing="0" >
<tbody>
<tr id="colorPickerBlock">
<td>
<table id="colorPickerFrame">

	<tbody>
		<tr>
			<td class="controllerTitle">
				<a href="javascript:void(0);" onClick="toggleColorPicker();" id="colorPickerController" class="configLink">+ Color Picker</a>
			</td>
		</tr>
		<tr id="colorPickerLocalBlock">
		
			<td class="controllerBlock">
			
							
				<span class="controllerHeader">RGB</span>
				<INPUT name="colorPickerR" onchange="changeRInput(this);" type="text" style="width:30px;">
				<INPUT name="colorPickerG" onchange="changeGInput(this);" type="text" style="width:30px;">
				<INPUT name="colorPickerB" onchange="changeBInput(this);" type="text" style="width:30px;">
				<span class="controllerHeader"></span>
				<INPUT name="colorPickerHEX" onchange="setPickerColor(this.value);" type="text" style="width:60px;">
				
				<input style="width:120px;" type="button" onclick="encode_TrueMabiColor();" value="GetDyeAmpleColor" title="" />
				
				<select name="paletteTrueColorMenu" style="width:70px;">
				<option value="normal1" selected>normal1</option>
				<option value="normal2">normal2</option>
				<option value="normal3">normal3</option>
				<option value="leather1">leather</option>
				<option value="metal1">metal1</option>
				<option value="metal2">metal2</option>
				<option value="metal3">metal3</option>
				</select> 
				<a class="controllerLink" href="usage.truecolor.php" target="_blank">？</a>
				
				<table class="colorPickerArea" onContextMenu="return false;">
					<tbody>
						<tr>
							<td rowspan="3">
								<div onclick="simplePicker.run('colorPickerHEX');" class="colorPaletteSelected" id="colorSwatch">&nbsp;</div>
							</td>
							<td class="paletteArea">
								<span class="colorPalettePicker" id="palette1" onClick="dyeColor(this);setColorPalette(0, this);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
								<span class="colorPalettePicker" id="palette2" onClick="dyeColor(this);setColorPalette(1, this);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
								<span class="colorPalettePicker" id="palette3" onClick="dyeColor(this);setColorPalette(2, this);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
							</td>
							<td style="padding-left:3px;" rowspan="3">
								<img src=" marker.png" alt="" style="position: relative;" id="rTip"><br>
								<img src=" red.png" alt="red slider" width="262" height="16" onMouseMove="if(dragging)changeR();" onMouseDown="mouseDown(this);" onMouseUp="mouseUp(this);" onClick="changeR();mouseUp(this);" onDragStart="return false;" onMouseWheel="changeRw();return false;"><br>
								<img src=" marker.png" alt="" style="position: relative;" id="gTip"><br>
								<img src=" green.png" alt="green slider" width="262" height="16" onMouseMove="if(dragging)changeG();" onMouseDown="mouseDown(this);" onMouseUp="mouseUp(this);" onClick="changeG();mouseUp(this);" onDragStart="return false;" onMouseWheel="changeGw();return false;"><br>
								<img src=" marker.png" alt="" style="position: relative;" id="bTip"><br>
								<img src=" blue.png" alt="blue slider" width="262" height="16" onMouseMove="if(dragging)changeB();" onMouseDown="mouseDown(this);" onMouseUp="mouseUp(this);" onClick="changeB();mouseUp(this);" onDragStart="return false;" onMouseWheel="changeBw();return false;"><br>
							</td>
						</tr>
						<tr>
							<td class="paletteArea">
								<span class="colorPalettePicker" id="palette4" onClick="dyeColor(this);setColorPalette(3, this);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
								<span class="colorPalettePicker" id="palette5" onClick="dyeColor(this);setColorPalette(4, this);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
								<span class="colorPalettePicker" id="palette6" onClick="dyeColor(this);setColorPalette(5, this);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
							</td>
						</tr>
						<tr>
							<td class="paletteArea">
								<span class="colorPalettePicker" id="palette7" onClick="dyeColor(this);setColorPalette(6, this);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
								<span class="colorPalettePicker" id="palette8" onClick="dyeColor(this);setColorPalette(7, this);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
								<span class="colorPalettePicker" id="palette9" onClick="dyeColor(this);setColorPalette(8, this);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
							</td>
						</tr>
						<tr>
							<td colspan="3" class="controllerHeader">
								<B>Please click the upper to open color picker.</B><BR>[Left click] Paste color [Right click] Copy color							</td>
						</tr>
					</tbody>
				</table>
				
				
				<table class="colorLogFrame" style="width:100%;" border="0" cellpadding="0" cellspacing="0" onContextMenu="return false;">
					<tbody>
						<tr>
							<td class="secondaryControllerHeader">
								<a href="javascript:void(0);" onClick="toggleColorLog();" id="colorLogController" class="secondaryControllerHeader">+ Color Logs (Cookie)</a>
							</td>
						</tr>
						<tr id="colorLogBlock">
							<td class="secondaryControllerBlock">
								<table class="colorPickerArea" style="cursor : default;">
									<tbody>
										<tr>
											<td class="paletteArea">
												<span class="colorPaletteLog" id="paletteLog0" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog1" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog2" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog3" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog4" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog5" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog6" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog7" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog8" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog9" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog10" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog11" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog12" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog13" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog14" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog15" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog16" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog17" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog18" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog19" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span><span class="colorPaletteLog" id="paletteLog20" style="padding-top:4px;padding-bottom:4px;margin-right:3px;" onClick="pickColorNoLog(this);return false;" onContextMenu="pickColorNoLog(this);return false;"><img src="sp.gif"></span>											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
				
								
			</td>
		</tr>
	</tbody>
</table>
</td>
</tr>
</tbody>
</table>

<div id="colorpicksp" style="display:none;height:256px;">&nbsp;</div>

<table width="430" border="0" cellpadding="0" cellspacing="2" >
<tbody>
	<tr>
		<td class="controllerTitle">
			<a href="javascript:void(0);" onClick="toggleSearchController();" id="searchController" class="configLink">+ Search</a>
		</td>
	</tr>
	<tr id="searchBlock">
		<td class="controllerBlock">
			<table border="0" cellpadding="0" cellspacing="0">
			<tbody>
			<tr>
				<td>
					<span class="controllerHeader">Search Word:</span><br>
					<input onfocus="if(this.value=='search example) Vanalen'){this.value='';this.style.color='#000000';}" name="searchText" type="text" value="search example) Vanalen" style="width:250px;font-size:14px;color : #b3b3b3;border-width : 1px;border-style : solid;border-color : red;padding:3px;">
				</td>
				<td width="3"></td>
				<td>
					<span class="controllerHeader">Search Target:</span><br>
					<select name="searchPartsMenu" onchange="runSearch();" style="font-size:14px;width:150px;">
										<option value="_equip">Equip: ALL</option>
					<option value="head">Equip: Head</option>
					<option value="body">Equip: Body</option>
					<option value="foot">Equip: Foot</option>
					<option value="hand">Equip: Hand</option>
					<option value="robe">Equip: Robe</option>
					<option value="weaponFirst">Equip: Weapon Main (Left Hand)</option>
					<option value="shieldFirst">Equip: Weapon Main (Right Hand)</option>
					<option value="weaponSecond">Equip: Weapon Sub (Left Hand)</option>
					<option value="shieldSecond">Equip: Weapon Sub (Right Hand)</option>
					<option value="animation">Character: Motion</option>
					<option value="hair">Character: Hair Style</option>
					<option value="hairColor">Character: Hair Color</option>
					<option value="eyeEmotion">Character: Eye Style</option>
					<option value="eyeColor">Character: Eye Color</option>
					<option value="face">Character: Face</option>
					<option value="mouthEmotion">Character: Mouth</option>
					<option value="reaction">Character: Face Reaction</option>
					<option value="skinColor">Character: Skin Color</option>
										
					</select>
				</td>
			</tr>
			</tbody>
			</table>
			
			<table border="0" cellpadding="0" cellspacing="0" width="90%">
			<tbody>
			<tr>
				<td>
					<span class="controllerHeader">Result:</span>
				</td>
			</tr>
			<tr>
				<td id="searchResult" style="line-height: 140%;">
				* <i>try search.</i>				</td>
			</tr>
			</tbody>
			</table>
		</td>
	</tr>
</tbody>
</table>

<table width="430" border="0" cellpadding="0" cellspacing="2" style="display:none;">
<tbody>
	<tr>
		<td class="controllerTitle">
		<a href="javascript:void(0);" onClick="toggleHistoryController();" id="historyController" class="configLink">+ History</a>
		</td>
	</tr>
	<tr id="historyBlock" style="display:none;">
		<td class="controllerBlock">
		<div id="historyArea" style="height:85px; width:100%; overflow-y:scroll;">
		* <a href="javascript:void(0);" onclick="if(confirm('開いたときの状態に戻しますがよろしいですか？')){parent.location.reload();}">Mabinogi Character Simulator 2 を開きました。</a><br>
		</div>
		</td>
	</tr>
</tbody>
</table>

<center>
<input id="backHistoryButton" type="button" value="---" disabled onclick="backHistory();" style="width:100px;"> 
<input id="nextHistoryButton" type="button" value="---" disabled onclick="nextHistory();" style="width:100px;"> 
</center>
	
<table width="430" border="0" cellpadding="0" cellspacing="2">
<tbody>																						
<tr>
<td class="controllerTitle" >
<a href="javascript:void(0);" onClick="toggleEquipmentsController();" id="equipmentController" class="configLink">+ Equip</a>
</td>
</tr>
<tr id="headBlock" >
<td class="controllerBlock">
<span class="controllerHeader">Head:</span><br>
<select name="headMenu" onChange = "changeHead(this.value);" style="width:300px;">
<OPTION value="-1">(none)</OPTION>
%n = 1
%for i in head:
<option value="{{n}}">{{i['name']}}</option>
%n += 1
%end

</select>

<select name="headState" onChange="changeHeadState(this.value);" style="width:80px;">
	<option value="0">put on</option>
	<option value="1">take off</option>
</select><br>
<span class="colorPaletteMini" id="headPalette1" onClick="dyeColor(this);changeHeadColorByPalette(1);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="headColor1">
<span class="colorPaletteMini" id="headPalette2" onClick="dyeColor(this);changeHeadColorByPalette(2);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="headColor2">
<span class="colorPaletteMini" id="headPalette3" onClick="dyeColor(this);changeHeadColorByPalette(3);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="headColor3">
<a class="controllerLink" href="javascript:void(0);" onClick="dyeHead(headColor1.value,headColor2.value,headColor3.value);">Dye</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="searchPublist(headMenu.options[headMenu.selectedIndex].text);">Search</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="controller.headMenu.value=-1;changeHead(controller.headMenu.value);">Purge</a>
</td>
</tr>
<tr id="bodyBlock" >
<td class="controllerBlock">
<span class="controllerHeader">Body:</span><br>
<select name="bodyMenu" onChange = "changeBody(this.value)" style="width:300px;">
    <option value="-2">(男性用下着／ジャイアント用)</option>
    <option value="-1">スパイカーシルバープレートアーマー(男性用)</option>
    %n = 0
    %for i in body:
    <option value="{{n}}">{{i['name']}}</option>
    %n += 1
    %end
</select>
<select name="bodyState" onChange="changeBodyState(this.value);" style="width:80px;">
	<option value="0">put on</option>
	<option value="1">take off</option>
</select><br>
<span class="colorPaletteMini" id="bodyPalette1" onClick="dyeColor(this);changeBodyColorByPalette(1);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="bodyColor1">
<span class="colorPaletteMini" id="bodyPalette2" onClick="dyeColor(this);changeBodyColorByPalette(2);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="bodyColor2">
<span class="colorPaletteMini" id="bodyPalette3" onClick="dyeColor(this);changeBodyColorByPalette(3);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="bodyColor3">
<a class="controllerLink" href="javascript:void(0);" onClick="dyeBody(bodyColor1.value,bodyColor2.value,bodyColor3.value);">Dye</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="searchPublist(bodyMenu.options[bodyMenu.selectedIndex].text);">Search</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="controller.bodyMenu.value=-1;changeBody(controller.bodyMenu.value);">Purge</a>
</td>
</tr>
<tr id="footBlock" >
<td class="controllerBlock">
<span class="controllerHeader">Foot:</span><br>
<select name="footMenu" onChange = "changeFoot(this.value)" style="width:300px;">
<OPTION value="-1">(none)</OPTION>
%n = 1
%for i in foot:
<option value="{{n}}">{{i['name']}}</option>
%n += 1
%end

</select>
<br>
<span class="colorPaletteMini" id="footPalette1" onClick="dyeColor(this);changeFootColorByPalette(1);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="footColor1">
<span class="colorPaletteMini" id="footPalette2" onClick="dyeColor(this);changeFootColorByPalette(2);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="footColor2">
<span class="colorPaletteMini" id="footPalette3" onClick="dyeColor(this);changeFootColorByPalette(3);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="footColor3">
<a class="controllerLink" href="javascript:void(0);" onClick="dyeFoot(footColor1.value,footColor2.value,footColor3.value);">Dye</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="searchPublist(footMenu.options[footMenu.selectedIndex].text);">Search</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="controller.footMenu.value=-1;changeFoot(controller.footMenu.value);">Purge</a>
</td>
</tr>
<tr id="handBlock" >
<td class="controllerBlock">
<span class="controllerHeader">Hand:</span><br>
<select name="handMenu" onChange = "changeHand(this.value)" style="width:300px;">
<OPTION value="-1">(none)</OPTION>
%n = 1
%for i in hand:
<option value="{{n}}">{{i['name']}}</option>
%n += 1
%end

</select>
<br>
<span class="colorPaletteMini" id="handPalette1" onClick="dyeColor(this);changeHandColorByPalette(1);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="handColor1">
<span class="colorPaletteMini" id="handPalette2" onClick="dyeColor(this);changeHandColorByPalette(2);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="handColor2">
<span class="colorPaletteMini" id="handPalette3" onClick="dyeColor(this);changeHandColorByPalette(3);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="handColor3">
<a class="controllerLink" href="javascript:void(0);" onClick="dyeHand(handColor1.value,handColor2.value,handColor3.value);">Dye</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="searchPublist(handMenu.options[handMenu.selectedIndex].text);">Search</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="controller.handMenu.value=-1;changeHand(controller.handMenu.value);">Purge</a>
</td>
</tr>
<tr id="robeBlock" >
<td class="controllerBlock">
<span class="controllerHeader">Robe:</span><br>
<select name="robeMenu" onChange = "changeRobe(this.value)" style="width:300px;">
<OPTION value="-1">(none)</OPTION>
%n = 1
%for i in robe:
<option value="{{n}}">{{i['name']}}</option>
%n += 1
%end

</select>

<select name="robeState" onChange="changeRobeState(this.value);" style="width:80px;">
	<option value="0">put on</option>
	<option value="1">take off</option>
</select><br>
<span class="colorPaletteMini" id="robePalette1" onClick="dyeColor(this);changeRobeColorByPalette(1);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="robeColor1">
<span class="colorPaletteMini" id="robePalette2" onClick="dyeColor(this);changeRobeColorByPalette(2);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="robeColor2">
<span class="colorPaletteMini" id="robePalette3" onClick="dyeColor(this);changeRobeColorByPalette(3);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="robeColor3">
<a class="controllerLink" href="javascript:void(0);" onClick="dyeRobe(robeColor1.value,robeColor2.value,robeColor3.value);">Dye</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="searchPublist(robeMenu.options[robeMenu.selectedIndex].text);">Search</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="controller.robeMenu.value=-1;changeRobe(controller.robeMenu.value);">Purge</a>
</td>
</tr>
<tr id="weapon1Block" >
<td class="controllerBlock">
<span class="controllerHeader">Weapon Main (Left Hand): </span><br>
<select name="weaponFirstMenu" onChange = "changeWeaponFirst(this.value)" style="width:300px;">
<OPTION value="-1">(none)</OPTION>
<OPTION value="1">Great Sword</OPTION>
<OPTION value="2">Cleaver</OPTION>
<OPTION value="3">Morningstar</OPTION>
<OPTION value="4">Great Mallet</OPTION>
<OPTION value="5">Battle Hammer</OPTION>
<OPTION value="6">Warrior Axe</OPTION>
<OPTION value="7">Broad Axe</OPTION>
<OPTION value="8">Spiked Knuckle</OPTION>
<OPTION value="9">Hobnail Knuckle</OPTION>
<OPTION value="10">Wood Atlatl</OPTION>
<OPTION value="11">Bone Atlatl</OPTION>
<OPTION value="12">Broken Log</OPTION>
<OPTION value="4">Great Mallet</OPTION>
<OPTION value="13">Ice Sword</OPTION>
<OPTION value="14">Shining Ice Sword</OPTION>
<OPTION value="15">Ice Pole</OPTION>
<OPTION value="16">Battle Mace</OPTION>
<OPTION value="17">Ivory Sword</OPTION>
<OPTION value="18">Cat Hand Club</OPTION>
<OPTION value="19">Chocolate Stick Wand</OPTION>
<OPTION value="20">Strawberry Stick Wand</OPTION>
<OPTION value="21">White Stick Wand</OPTION>
<OPTION value="22">Ballista</OPTION>
<OPTION value="13">Ice Sword</OPTION>
<OPTION value="14">Shining Ice Sword</OPTION>
<OPTION value="23">Sword of Beholder</OPTION>
<OPTION value="24">Ditis's Wand of Evil</OPTION>
<OPTION value="25">Reminia's Star And Moon Sword</OPTION>
<OPTION value="27">Ruyuefeixue's Amethyst Butterfly</OPTION>
<OPTION value="26">Shaoranen's Bow of Chivalry</OPTION>
<OPTION value="28">Vales Great Sword</OPTION>
<OPTION value="29">Feather Atlatl</OPTION>
<OPTION value="30">Iron Mace</OPTION>
<OPTION value="31">#31: giant_female_weapon_flamberge01.pmg</OPTION>
<OPTION value="32">Bear Knuckle</OPTION>
<OPTION value="33">Toy hammer</OPTION>
<OPTION value="34">Cylinder</OPTION>
<OPTION value="35">War Sword</OPTION>
<OPTION value="36">Executioner's sword</OPTION>
<OPTION value="37">Eweca Short Sword</OPTION>
<OPTION value="38">Fire Cylinder</OPTION>
<OPTION value="39">Earth Cylinder</OPTION>
<OPTION value="40">Wind Cylinder</OPTION>
<OPTION value="41">Water Cylinder</OPTION>
<OPTION value="42">Jousting Lance</OPTION>
<OPTION value="43">Iron Claw</OPTION>
<OPTION value="4">Great Mallet</OPTION>
<OPTION value="44">Ego Great Sword</OPTION>
<OPTION value="45">Ego Cleaver</OPTION>
<OPTION value="46">Ego Morningstar</OPTION>
<OPTION value="47">Ego Great Mallet</OPTION>
<OPTION value="48">Ego Battle Hammer</OPTION>
<OPTION value="49">Ego Warrior Axe</OPTION>
<OPTION value="50">Ego Broad Axe</OPTION>
<OPTION value="23">Sword of Beholder</OPTION>
<OPTION value="51">Ego Ditis's Wand of Evil</OPTION>
<OPTION value="52">Ego Reminia's Star And Moon Sword</OPTION>
<OPTION value="53">Ego Shaoranen's Bow of Chivalry</OPTION>
<OPTION value="54">Ego Ruyuefeixue's Amethyst Butterfly</OPTION>
<OPTION value="60">Bear Doll</OPTION>
<OPTION value="58">Sunshade</OPTION>
<OPTION value="59">Duster</OPTION>
<OPTION value="33">Toy hammer</OPTION>
<OPTION value="61">Rabbit Doll</OPTION>
<OPTION value="62">Dragon Killer`s Great Two-Handed Sword</OPTION>
<OPTION value="63">Big Cooking Kneader</OPTION>
<OPTION value="64">Valdorl School Bag</OPTION>
<OPTION value="65">Candy Cane</OPTION>
<OPTION value="66">Axe for Firewood</OPTION>
<OPTION value="67">Plane for Carpentry</OPTION>
<OPTION value="68">Physis Tuba</OPTION>
<OPTION value="69">Andras Puppet</OPTION>
<OPTION value="70">Elatha Puppet</OPTION>
<OPTION value="71">Eldra's Two Handed Sword devoted to Goddess</OPTION>
<OPTION value="72">Soft Ice Cream Short Sword</OPTION>
<OPTION value="73">Dumpling Sword</OPTION>
<OPTION value="74">Cracker Bow</OPTION>
<OPTION value="75">Confeito Mace</OPTION>
<OPTION value="76">Rollcake Cylinder</OPTION>
<OPTION value="77">Tower Cylinder</OPTION>
<OPTION value="78">Falcata</OPTION>
<OPTION value="79">Francisca</OPTION>
<OPTION value="80">Highlander Claymore</OPTION>
<OPTION value="81">Fire Sword of Elsinore</OPTION>
<OPTION value="82">Battle Mandolin</OPTION>
<OPTION value="83">Glory Sword</OPTION>
<OPTION value="83">Glory Sword</OPTION>
<OPTION value="84">Dragon Tooth</OPTION>
<OPTION value="85">Trinity Staff</OPTION>
<OPTION value="86">Volcano Cylinder</OPTION>
<OPTION value="87">Earthquake Cylinder</OPTION>
<OPTION value="88">Hurricane Cylinder</OPTION>
<OPTION value="89">Tidalwave Cylinder</OPTION>
<OPTION value="90">Olivier Mira Armstrong's Sword</OPTION>
<OPTION value="91">Winry Rockbell's Spanner</OPTION>
<OPTION value="92">Lorna Puppet</OPTION>
<OPTION value="93">Pan Puppet</OPTION>
<OPTION value="94">Cat Doll</OPTION>
<OPTION value="95">Quill Sword</OPTION>
<OPTION value="96">Fire Wand Of Fairy</OPTION>
<OPTION value="97">Ice Wand Of Fairy</OPTION>
<OPTION value="98">Lightning Wand Of Fairy</OPTION>
<OPTION value="99">Physis Wooden Lance</OPTION>
<OPTION value="101">Lion Claw Lance</OPTION>
<OPTION value="100">Knight Lance</OPTION>
<OPTION value="102">Ransel</OPTION>
<OPTION value="103">Korean Sword S</OPTION>
<OPTION value="103">Korean Sword S</OPTION>
<OPTION value="104">Special Carrot</OPTION>
<OPTION value="105">Umbrella</OPTION>
<OPTION value="106">Umbrella</OPTION>
<OPTION value="107">Umbrella</OPTION>
<OPTION value="108">Umbrella (open)</OPTION>
<OPTION value="109">Umbrella (open)</OPTION>
<OPTION value="110">Umbrella (open)</OPTION>
<OPTION value="111">Umbrella</OPTION>
<OPTION value="112">Umbrella</OPTION>
<OPTION value="113">Umbrella</OPTION>
<OPTION value="114">Umbrella (open)</OPTION>
<OPTION value="115">Umbrella (open)</OPTION>
<OPTION value="116">Umbrella (open)</OPTION>
<OPTION value="117">Morrighan Puppet</OPTION>
<OPTION value="118">Cichol Puppet</OPTION>
<OPTION value="119">Ego Two-Handed Sword</OPTION>
<OPTION value="120">Ego Claymore</OPTION>
<OPTION value="121">Ego Dragon Blade</OPTION>
<OPTION value="122">Ego Japanese Long Blade</OPTION>
<OPTION value="123">Ego Masamune</OPTION>
<OPTION value="124">Ego Iron Mace</OPTION>
<OPTION value="125">Ego Vales Great Sword</OPTION>
<OPTION value="126">Ego Dustin Silver Knight Sword</OPTION>
<OPTION value="127">Ego Glory Sword</OPTION>
<OPTION value="134">Ego Dragon Tooth</OPTION>
<OPTION value="128">Ego Francisca</OPTION>
<OPTION value="129">Ego Highlander Claymore</OPTION>
<OPTION value="130">Ego Executioner's sword</OPTION>
<OPTION value="131">Ego War Sword</OPTION>
<OPTION value="132">Ego Falcata</OPTION>
<OPTION value="133">Ego Viseo's Bronze Mirror Blade</OPTION>
<OPTION value="135">Bass Drum</OPTION>
<OPTION value="136">Drum</OPTION>
<OPTION value="137">Cymbals</OPTION>
<OPTION value="138">Brionac</OPTION>
<OPTION value="139">Endless Wing Staff</OPTION>
<OPTION value="140">Kill The Devil Scythe</OPTION>
<OPTION value="141">Barbarous Fox Scythe</OPTION>
<OPTION value="142">Brace Knuckle</OPTION>
<OPTION value="143">Champion Knuckle</OPTION>
<OPTION value="144">Bear's Paw Pillow</OPTION>
<OPTION value="145">Event Pillow</OPTION>
<OPTION value="146">Club of Sea Troll</OPTION>
<OPTION value="147">Club of Wild Troll</OPTION>
<OPTION value="148">Heart Sword</OPTION>
<OPTION value="149">Diamond Mini Spear</OPTION>
<OPTION value="150">Heart Mini Spear</OPTION>
<OPTION value="151">Clover Mini Spear</OPTION>
<OPTION value="152">Spade Mini Spear</OPTION>
<OPTION value="153">Squirrel Ragdoll</OPTION>
<OPTION value="154">Desert fox Ragdoll</OPTION>
<OPTION value="153">Squirrel Ragdoll</OPTION>
<OPTION value="155">Bear Ragdoll</OPTION>
<OPTION value="156">Tiger Ragdoll</OPTION>
<OPTION value="157">Rabbit Ragdoll</OPTION>
<OPTION value="159">Engraved Marionette Handle</OPTION>
<OPTION value="160">Jeweled Marionette Handle</OPTION>
<OPTION value="158">Basic Marionette Handle</OPTION>
<OPTION value="161">Panda Umbrella</OPTION>
<OPTION value="162">Twinkling Star Umbrella</OPTION>
<OPTION value="163">Twinkling Star Umbrella (open)</OPTION>
<OPTION value="164">Panda Umbrella (open)</OPTION>
<OPTION value="165">A lotus leaf Umbrella</OPTION>
<OPTION value="166">A lotus leaf Umbrella (open)</OPTION>
<OPTION value="167">Cheeta Hand Club</OPTION>
<OPTION value="168">Halloween Pumpkin Bet Umbrella</OPTION>
<OPTION value="169">Demonic Hell-Fire Cylinder</OPTION>
<OPTION value="170">Demonic Inner-Core Cylinder</OPTION>
<OPTION value="170">Demonic Inner-Core Cylinder</OPTION>
<OPTION value="171">Demonic Scales-Eye Lance</OPTION>
<OPTION value="172">Demonic Death Penalty Blade</OPTION>
<OPTION value="173">Demonic Death Knight Sword</OPTION>
<OPTION value="174">Demonic Infinity Staff</OPTION>
<OPTION value="175">Demonic Illusion Handle</OPTION>
<OPTION value="176">Demonic Gloomy Sunday</OPTION>
<OPTION value="177">Demonic Solitude Knuckle</OPTION>
<OPTION value="178">Demonic Nightmare Dreamcatcher</OPTION>
<OPTION value="179">Moonlight Dreamcatcher</OPTION>
<OPTION value="180">Ordinary Dreamcatcher</OPTION>
<OPTION value="181">Spring Onion Sword Basic</OPTION>
<OPTION value="182">Tangerine Knuckle Basic</OPTION>
<OPTION value="183">Ice Cream Lightning Wand</OPTION>
<OPTION value="184">Ice Cream Fire Wand</OPTION>
<OPTION value="185">Ice Cream Ice Wand</OPTION>
<OPTION value="186">Electric Guitar</OPTION>

</select>

<select name="weaponFirstState" onChange="changeWeaponFirstState(this.value);" style="width:80px;">
<option value="0">Useable</option>
<option value="3">Useable (Reverse)</option>
<option value="1">NotUseable</option>
<option value="4">NotUseable (Reverse)</option>
</select><br>
<span class="colorPaletteMini" id="weaponFirstPalette1" onClick="dyeColor(this);changeWeaponFirstColorByPalette(1);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="weaponFirstColor1">
<span class="colorPaletteMini" id="weaponFirstPalette2" onClick="dyeColor(this);changeWeaponFirstColorByPalette(2);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="weaponFirstColor2">
<span class="colorPaletteMini" id="weaponFirstPalette3" onClick="dyeColor(this);changeWeaponFirstColorByPalette(3);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="weaponFirstColor3">
<a class="controllerLink" href="javascript:void(0);" onClick="dyeWeaponFirst(weaponFirstColor1.value,weaponFirstColor2.value,weaponFirstColor3.value);">Dye</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="searchPublist(weaponFirstMenu.options[weaponFirstMenu.selectedIndex].text);">Search</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="controller.weaponFirstMenu.value=-1;changeWeaponFirst(controller.weaponFirstMenu.value);">Purge</a>
</td>
</tr>
<tr id="shield1Block" >
<td class="controllerBlock">
<span class="controllerHeader">Weapon Main (Right Hand):</span><br>
<select name="shieldFirstMenu" onChange = "changeShieldFirst(this.value)" style="width:300px;">
<OPTION value="-1">(none)</OPTION>
<OPTION value="0">Shield of Beholder</OPTION>
<OPTION value="1">Tikka Shield</OPTION>
<OPTION value="2">Vales Shield</OPTION>
<OPTION value="3">Composite Shield</OPTION>
<OPTION value="4">Buckler</OPTION>
<OPTION value="5">Coke Digital Camcorder</OPTION>
<OPTION value="6">Great Sword</OPTION>
<OPTION value="7">Cleaver</OPTION>
<OPTION value="8">Morningstar</OPTION>
<OPTION value="9">Great Mallet</OPTION>
<OPTION value="10">Battle Hammer</OPTION>
<OPTION value="11">Warrior Axe</OPTION>
<OPTION value="12">Broad Axe</OPTION>
<OPTION value="13">Spiked Knuckle</OPTION>
<OPTION value="14">Hobnail Knuckle</OPTION>
<OPTION value="15">Wood Atlatl</OPTION>
<OPTION value="16">Bone Atlatl</OPTION>
<OPTION value="17">Broken Log</OPTION>
<OPTION value="18">Ice Sword</OPTION>
<OPTION value="19">Shining Ice Sword</OPTION>
<OPTION value="20">Ice Pole</OPTION>
<OPTION value="21">Battle Mace</OPTION>
<OPTION value="22">Ivory Sword</OPTION>
<OPTION value="23">Cat Hand Club</OPTION>
<OPTION value="24">Chocolate Stick Wand</OPTION>
<OPTION value="25">Strawberry Stick Wand</OPTION>
<OPTION value="26">White Stick Wand</OPTION>
<OPTION value="27">Ballista</OPTION>
<OPTION value="28">Sword of Beholder</OPTION>
<OPTION value="29">Ditis's Wand of Evil</OPTION>
<OPTION value="30">Reminia's Star And Moon Sword</OPTION>
<OPTION value="31">Shaoranen's Bow of Chivalry</OPTION>
<OPTION value="32">Ruyuefeixue's Amethyst Butterfly</OPTION>
<OPTION value="33">Vales Great Sword</OPTION>
<OPTION value="34">Feather Atlatl</OPTION>
<OPTION value="35">Iron Mace</OPTION>
<OPTION value="36">#36: giant_female_weapon_flamberge01.pmg</OPTION>
<OPTION value="37">Bear Knuckle</OPTION>
<OPTION value="38">Toy hammer</OPTION>
<OPTION value="39">Cylinder</OPTION>
<OPTION value="40">War Sword</OPTION>
<OPTION value="41">Executioner's sword</OPTION>
<OPTION value="42">Eweca Short Sword</OPTION>
<OPTION value="43">Fire Cylinder</OPTION>
<OPTION value="44">Earth Cylinder</OPTION>
<OPTION value="45">Wind Cylinder</OPTION>
<OPTION value="46">Water Cylinder</OPTION>
<OPTION value="47">Jousting Lance</OPTION>
<OPTION value="48">Iron Claw</OPTION>
<OPTION value="49">Ego Great Sword</OPTION>
<OPTION value="50">Ego Cleaver</OPTION>
<OPTION value="51">Ego Morningstar</OPTION>
<OPTION value="52">Ego Great Mallet</OPTION>
<OPTION value="53">Ego Battle Hammer</OPTION>
<OPTION value="54">Ego Warrior Axe</OPTION>
<OPTION value="55">Ego Broad Axe</OPTION>
<OPTION value="56">Ego Ditis's Wand of Evil</OPTION>
<OPTION value="57">Ego Reminia's Star And Moon Sword</OPTION>
<OPTION value="58">Ego Shaoranen's Bow of Chivalry</OPTION>
<OPTION value="59">Ego Ruyuefeixue's Amethyst Butterfly</OPTION>
<OPTION value="60">(temp)tool_row</OPTION>
<OPTION value="61">(temp)dragon_ship_tool_row</OPTION>
<OPTION value="62">(temp)</OPTION>
<OPTION value="63">Sunshade</OPTION>
<OPTION value="64">Duster</OPTION>
<OPTION value="65">Bear Doll</OPTION>
<OPTION value="66">Rabbit Doll</OPTION>
<OPTION value="67">Dragon Killer`s Great Two-Handed Sword</OPTION>
<OPTION value="68">Big Cooking Kneader</OPTION>
<OPTION value="69">Valdorl School Bag</OPTION>
<OPTION value="70">Candy Cane</OPTION>
<OPTION value="71">Axe for Firewood</OPTION>
<OPTION value="72">Plane for Carpentry</OPTION>
<OPTION value="73">Physis Tuba</OPTION>
<OPTION value="74">Andras Puppet</OPTION>
<OPTION value="75">Elatha Puppet</OPTION>
<OPTION value="76">Eldra's Two Handed Sword devoted to Goddess</OPTION>
<OPTION value="77">Soft Ice Cream Short Sword</OPTION>
<OPTION value="78">Dumpling Sword</OPTION>
<OPTION value="79">Cracker Bow</OPTION>
<OPTION value="80">Confeito Mace</OPTION>
<OPTION value="82">Cookie Shield</OPTION>
<OPTION value="83">Tower Cylinder</OPTION>
<OPTION value="84">Falcata</OPTION>
<OPTION value="85">Francisca</OPTION>
<OPTION value="86">Highlander Claymore</OPTION>
<OPTION value="81">Rollcake Cylinder</OPTION>
<OPTION value="87">Fire Sword of Elsinore</OPTION>
<OPTION value="88">Battle Mandolin</OPTION>
<OPTION value="89">Glory Sword</OPTION>
<OPTION value="89">Glory Sword</OPTION>
<OPTION value="91">Dragon Tooth</OPTION>
<OPTION value="92">Trinity Staff</OPTION>
<OPTION value="93">Volcano Cylinder</OPTION>
<OPTION value="94">Earthquake Cylinder</OPTION>
<OPTION value="95">Hurricane Cylinder</OPTION>
<OPTION value="96">Tidalwave Cylinder</OPTION>
<OPTION value="97">Olivier Mira Armstrong's Sword</OPTION>
<OPTION value="98">Winry Rockbell's Spanner</OPTION>
<OPTION value="99">Lorna Puppet</OPTION>
<OPTION value="100">Pan Puppet</OPTION>
<OPTION value="101">Cat Doll</OPTION>
<OPTION value="102">Quill Sword</OPTION>
<OPTION value="103">Fire Wand Of Fairy</OPTION>
<OPTION value="104">Ice Wand Of Fairy</OPTION>
<OPTION value="105">Lightning Wand Of Fairy</OPTION>
<OPTION value="106">Shield of Avon</OPTION>
<OPTION value="107">Ransel</OPTION>
<OPTION value="0">Shield of Beholder</OPTION>
<OPTION value="0">Shield of Beholder</OPTION>
<OPTION value="0">Shield of Beholder</OPTION>
<OPTION value="108">Morrighan Puppet</OPTION>
<OPTION value="109">Cichol Puppet</OPTION>
<OPTION value="0">Shield of Beholder</OPTION>
<OPTION value="110">Targe Shield</OPTION>
<OPTION value="111">Endless Wing Staff</OPTION>
<OPTION value="112">Shield of Valkyrie</OPTION>
<OPTION value="113">Kill The Devil Scythe</OPTION>
<OPTION value="114">Barbarous Fox Scythe</OPTION>
<OPTION value="115">Brace Knuckle</OPTION>
<OPTION value="116">Champion Knuckle</OPTION>
<OPTION value="117">Bear's Paw Pillow</OPTION>
<OPTION value="118">Event Pillow</OPTION>
<OPTION value="119">Club of Sea Troll</OPTION>
<OPTION value="120">Club of Wild Troll</OPTION>
<OPTION value="0">Shield of Beholder</OPTION>
<OPTION value="63">Sunshade</OPTION>
<OPTION value="121">Umbrella</OPTION>
<OPTION value="122">Umbrella</OPTION>
<OPTION value="123">Umbrella</OPTION>
<OPTION value="124">Umbrella</OPTION>
<OPTION value="125">Umbrella</OPTION>
<OPTION value="126">Umbrella</OPTION>
<OPTION value="127">Panda Umbrella</OPTION>
<OPTION value="128">Twinkling Star Umbrella</OPTION>
<OPTION value="129">A lotus leaf Umbrella</OPTION>
<OPTION value="130">Cheeta Hand Club</OPTION>
<OPTION value="131">Demonic Nightmare Dreamcatcher</OPTION>
<OPTION value="132">Moonlight Dreamcatcher</OPTION>
<OPTION value="133">Ordinary Dreamcatcher</OPTION>
<OPTION value="134">Spring Onion Sword Basic</OPTION>
<OPTION value="135">Tangerine Knuckle Basic</OPTION>
<OPTION value="136">Ice Cream Lightning Wand</OPTION>
<OPTION value="137">Ice Cream Fire Wand</OPTION>
<OPTION value="138">Ice Cream Ice Wand</OPTION>
<OPTION value="139">Electric Guitar</OPTION>

</select>

<select name="shieldFirstState" onChange="changeShieldFirstState(this.value);" style="width:80px;">
<option value="0">Useable</option>
<option value="3">Useable (Reverse)</option>
<option value="1">NotUseable</option>
<option value="4">NotUseable (Reverse)</option>
</select><br>
<span class="colorPaletteMini" id="shieldFirstPalette1" onClick="dyeColor(this);changeShieldFirstColorByPalette(1);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="shieldFirstColor1">
<span class="colorPaletteMini" id="shieldFirstPalette2" onClick="dyeColor(this);changeShieldFirstColorByPalette(2);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="shieldFirstColor2">
<span class="colorPaletteMini" id="shieldFirstPalette3" onClick="dyeColor(this);changeShieldFirstColorByPalette(3);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="shieldFirstColor3">
<a class="controllerLink" href="javascript:void(0);" onClick="dyeShieldFirst(shieldFirstColor1.value,shieldFirstColor2.value,shieldFirstColor3.value);">Dye</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="searchPublist(shieldFirstMenu.options[shieldFirstMenu.selectedIndex].text);">Search</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="controller.shieldFirstMenu.value=-1;changeShieldFirst(controller.shieldFirstMenu.value);">Purge</a>
</td>
</tr>
<tr id="weapon2Block" >
<td class="controllerBlock">
<span class="controllerHeader">Weapon Sub (Left Hand):</span><br>
<select name="weaponSecondMenu" onChange = "changeWeaponSecond(this.value)" style="width:300px;">
<OPTION value="-1">(none)</OPTION>
<OPTION value="1">Great Sword</OPTION>
<OPTION value="2">Cleaver</OPTION>
<OPTION value="3">Morningstar</OPTION>
<OPTION value="4">Great Mallet</OPTION>
<OPTION value="5">Battle Hammer</OPTION>
<OPTION value="6">Warrior Axe</OPTION>
<OPTION value="7">Broad Axe</OPTION>
<OPTION value="8">Spiked Knuckle</OPTION>
<OPTION value="9">Hobnail Knuckle</OPTION>
<OPTION value="10">Wood Atlatl</OPTION>
<OPTION value="11">Bone Atlatl</OPTION>
<OPTION value="12">Broken Log</OPTION>
<OPTION value="4">Great Mallet</OPTION>
<OPTION value="13">Ice Sword</OPTION>
<OPTION value="14">Shining Ice Sword</OPTION>
<OPTION value="15">Ice Pole</OPTION>
<OPTION value="16">Battle Mace</OPTION>
<OPTION value="17">Ivory Sword</OPTION>
<OPTION value="18">Cat Hand Club</OPTION>
<OPTION value="19">Chocolate Stick Wand</OPTION>
<OPTION value="20">Strawberry Stick Wand</OPTION>
<OPTION value="21">White Stick Wand</OPTION>
<OPTION value="22">Ballista</OPTION>
<OPTION value="13">Ice Sword</OPTION>
<OPTION value="14">Shining Ice Sword</OPTION>
<OPTION value="23">Sword of Beholder</OPTION>
<OPTION value="24">Ditis's Wand of Evil</OPTION>
<OPTION value="25">Reminia's Star And Moon Sword</OPTION>
<OPTION value="27">Ruyuefeixue's Amethyst Butterfly</OPTION>
<OPTION value="26">Shaoranen's Bow of Chivalry</OPTION>
<OPTION value="28">Vales Great Sword</OPTION>
<OPTION value="29">Feather Atlatl</OPTION>
<OPTION value="30">Iron Mace</OPTION>
<OPTION value="31">#31: giant_female_weapon_flamberge01.pmg</OPTION>
<OPTION value="32">Bear Knuckle</OPTION>
<OPTION value="33">Toy hammer</OPTION>
<OPTION value="34">Cylinder</OPTION>
<OPTION value="35">War Sword</OPTION>
<OPTION value="36">Executioner's sword</OPTION>
<OPTION value="37">Eweca Short Sword</OPTION>
<OPTION value="38">Fire Cylinder</OPTION>
<OPTION value="39">Earth Cylinder</OPTION>
<OPTION value="40">Wind Cylinder</OPTION>
<OPTION value="41">Water Cylinder</OPTION>
<OPTION value="42">Jousting Lance</OPTION>
<OPTION value="43">Iron Claw</OPTION>
<OPTION value="4">Great Mallet</OPTION>
<OPTION value="44">Ego Great Sword</OPTION>
<OPTION value="45">Ego Cleaver</OPTION>
<OPTION value="46">Ego Morningstar</OPTION>
<OPTION value="47">Ego Great Mallet</OPTION>
<OPTION value="48">Ego Battle Hammer</OPTION>
<OPTION value="49">Ego Warrior Axe</OPTION>
<OPTION value="50">Ego Broad Axe</OPTION>
<OPTION value="23">Sword of Beholder</OPTION>
<OPTION value="51">Ego Ditis's Wand of Evil</OPTION>
<OPTION value="52">Ego Reminia's Star And Moon Sword</OPTION>
<OPTION value="53">Ego Shaoranen's Bow of Chivalry</OPTION>
<OPTION value="54">Ego Ruyuefeixue's Amethyst Butterfly</OPTION>
<OPTION value="60">Bear Doll</OPTION>
<OPTION value="58">Sunshade</OPTION>
<OPTION value="59">Duster</OPTION>
<OPTION value="33">Toy hammer</OPTION>
<OPTION value="61">Rabbit Doll</OPTION>
<OPTION value="62">Dragon Killer`s Great Two-Handed Sword</OPTION>
<OPTION value="63">Big Cooking Kneader</OPTION>
<OPTION value="64">Valdorl School Bag</OPTION>
<OPTION value="65">Candy Cane</OPTION>
<OPTION value="66">Axe for Firewood</OPTION>
<OPTION value="67">Plane for Carpentry</OPTION>
<OPTION value="68">Physis Tuba</OPTION>
<OPTION value="69">Andras Puppet</OPTION>
<OPTION value="70">Elatha Puppet</OPTION>
<OPTION value="71">Eldra's Two Handed Sword devoted to Goddess</OPTION>
<OPTION value="72">Soft Ice Cream Short Sword</OPTION>
<OPTION value="73">Dumpling Sword</OPTION>
<OPTION value="74">Cracker Bow</OPTION>
<OPTION value="75">Confeito Mace</OPTION>
<OPTION value="76">Rollcake Cylinder</OPTION>
<OPTION value="77">Tower Cylinder</OPTION>
<OPTION value="78">Falcata</OPTION>
<OPTION value="79">Francisca</OPTION>
<OPTION value="80">Highlander Claymore</OPTION>
<OPTION value="81">Fire Sword of Elsinore</OPTION>
<OPTION value="82">Battle Mandolin</OPTION>
<OPTION value="83">Glory Sword</OPTION>
<OPTION value="83">Glory Sword</OPTION>
<OPTION value="84">Dragon Tooth</OPTION>
<OPTION value="85">Trinity Staff</OPTION>
<OPTION value="86">Volcano Cylinder</OPTION>
<OPTION value="87">Earthquake Cylinder</OPTION>
<OPTION value="88">Hurricane Cylinder</OPTION>
<OPTION value="89">Tidalwave Cylinder</OPTION>
<OPTION value="90">Olivier Mira Armstrong's Sword</OPTION>
<OPTION value="91">Winry Rockbell's Spanner</OPTION>
<OPTION value="92">Lorna Puppet</OPTION>
<OPTION value="93">Pan Puppet</OPTION>
<OPTION value="94">Cat Doll</OPTION>
<OPTION value="95">Quill Sword</OPTION>
<OPTION value="96">Fire Wand Of Fairy</OPTION>
<OPTION value="97">Ice Wand Of Fairy</OPTION>
<OPTION value="98">Lightning Wand Of Fairy</OPTION>
<OPTION value="99">Physis Wooden Lance</OPTION>
<OPTION value="101">Lion Claw Lance</OPTION>
<OPTION value="100">Knight Lance</OPTION>
<OPTION value="102">Ransel</OPTION>
<OPTION value="103">Korean Sword S</OPTION>
<OPTION value="103">Korean Sword S</OPTION>
<OPTION value="104">Special Carrot</OPTION>
<OPTION value="105">Umbrella</OPTION>
<OPTION value="106">Umbrella</OPTION>
<OPTION value="107">Umbrella</OPTION>
<OPTION value="108">Umbrella (open)</OPTION>
<OPTION value="109">Umbrella (open)</OPTION>
<OPTION value="110">Umbrella (open)</OPTION>
<OPTION value="111">Umbrella</OPTION>
<OPTION value="112">Umbrella</OPTION>
<OPTION value="113">Umbrella</OPTION>
<OPTION value="114">Umbrella (open)</OPTION>
<OPTION value="115">Umbrella (open)</OPTION>
<OPTION value="116">Umbrella (open)</OPTION>
<OPTION value="117">Morrighan Puppet</OPTION>
<OPTION value="118">Cichol Puppet</OPTION>
<OPTION value="119">Ego Two-Handed Sword</OPTION>
<OPTION value="120">Ego Claymore</OPTION>
<OPTION value="121">Ego Dragon Blade</OPTION>
<OPTION value="122">Ego Japanese Long Blade</OPTION>
<OPTION value="123">Ego Masamune</OPTION>
<OPTION value="124">Ego Iron Mace</OPTION>
<OPTION value="125">Ego Vales Great Sword</OPTION>
<OPTION value="126">Ego Dustin Silver Knight Sword</OPTION>
<OPTION value="127">Ego Glory Sword</OPTION>
<OPTION value="134">Ego Dragon Tooth</OPTION>
<OPTION value="128">Ego Francisca</OPTION>
<OPTION value="129">Ego Highlander Claymore</OPTION>
<OPTION value="130">Ego Executioner's sword</OPTION>
<OPTION value="131">Ego War Sword</OPTION>
<OPTION value="132">Ego Falcata</OPTION>
<OPTION value="133">Ego Viseo's Bronze Mirror Blade</OPTION>
<OPTION value="135">Bass Drum</OPTION>
<OPTION value="136">Drum</OPTION>
<OPTION value="137">Cymbals</OPTION>
<OPTION value="138">Brionac</OPTION>
<OPTION value="139">Endless Wing Staff</OPTION>
<OPTION value="140">Kill The Devil Scythe</OPTION>
<OPTION value="141">Barbarous Fox Scythe</OPTION>
<OPTION value="142">Brace Knuckle</OPTION>
<OPTION value="143">Champion Knuckle</OPTION>
<OPTION value="144">Bear's Paw Pillow</OPTION>
<OPTION value="145">Event Pillow</OPTION>
<OPTION value="146">Club of Sea Troll</OPTION>
<OPTION value="147">Club of Wild Troll</OPTION>
<OPTION value="148">Heart Sword</OPTION>
<OPTION value="149">Diamond Mini Spear</OPTION>
<OPTION value="150">Heart Mini Spear</OPTION>
<OPTION value="151">Clover Mini Spear</OPTION>
<OPTION value="152">Spade Mini Spear</OPTION>
<OPTION value="153">Squirrel Ragdoll</OPTION>
<OPTION value="154">Desert fox Ragdoll</OPTION>
<OPTION value="153">Squirrel Ragdoll</OPTION>
<OPTION value="155">Bear Ragdoll</OPTION>
<OPTION value="156">Tiger Ragdoll</OPTION>
<OPTION value="157">Rabbit Ragdoll</OPTION>
<OPTION value="159">Engraved Marionette Handle</OPTION>
<OPTION value="160">Jeweled Marionette Handle</OPTION>
<OPTION value="158">Basic Marionette Handle</OPTION>
<OPTION value="161">Panda Umbrella</OPTION>
<OPTION value="162">Twinkling Star Umbrella</OPTION>
<OPTION value="163">Twinkling Star Umbrella (open)</OPTION>
<OPTION value="164">Panda Umbrella (open)</OPTION>
<OPTION value="165">A lotus leaf Umbrella</OPTION>
<OPTION value="166">A lotus leaf Umbrella (open)</OPTION>
<OPTION value="167">Cheeta Hand Club</OPTION>
<OPTION value="168">Halloween Pumpkin Bet Umbrella</OPTION>
<OPTION value="169">Demonic Hell-Fire Cylinder</OPTION>
<OPTION value="170">Demonic Inner-Core Cylinder</OPTION>
<OPTION value="170">Demonic Inner-Core Cylinder</OPTION>
<OPTION value="171">Demonic Scales-Eye Lance</OPTION>
<OPTION value="172">Demonic Death Penalty Blade</OPTION>
<OPTION value="173">Demonic Death Knight Sword</OPTION>
<OPTION value="174">Demonic Infinity Staff</OPTION>
<OPTION value="175">Demonic Illusion Handle</OPTION>
<OPTION value="176">Demonic Gloomy Sunday</OPTION>
<OPTION value="177">Demonic Solitude Knuckle</OPTION>
<OPTION value="178">Demonic Nightmare Dreamcatcher</OPTION>
<OPTION value="179">Moonlight Dreamcatcher</OPTION>
<OPTION value="180">Ordinary Dreamcatcher</OPTION>
<OPTION value="181">Spring Onion Sword Basic</OPTION>
<OPTION value="182">Tangerine Knuckle Basic</OPTION>
<OPTION value="183">Ice Cream Lightning Wand</OPTION>
<OPTION value="184">Ice Cream Fire Wand</OPTION>
<OPTION value="185">Ice Cream Ice Wand</OPTION>
<OPTION value="186">Electric Guitar</OPTION>

</select>

<select name="weaponSecondState" onChange="changeWeaponSecondState(this.value);" style="width:80px;">
<option value="0">Useable</option>
<option value="1">NotUseable</option>
</select><br>
<span class="colorPaletteMini" id="weaponSecondPalette1" onClick="dyeColor(this);changeWeaponSecondColorByPalette(1);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="weaponSecondColor1">
<span class="colorPaletteMini" id="weaponSecondPalette2" onClick="dyeColor(this);changeWeaponSecondColorByPalette(2);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="weaponSecondColor2">
<span class="colorPaletteMini" id="weaponSecondPalette3" onClick="dyeColor(this);changeWeaponSecondColorByPalette(3);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="weaponSecondColor3">
<a class="controllerLink" href="javascript:void(0);" onClick="dyeWeaponSecond(weaponSecondColor1.value,weaponSecondColor2.value,weaponSecondColor3.value);">Dye</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="searchPublist(weaponSecondMenu.options[weaponSecondMenu.selectedIndex].text);">Search</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="controller.weaponSecondMenu.value=-1;changeWeaponSecond(controller.weaponSecondMenu.value);">Purge</a>
</td>
</tr>
<tr id="shield2Block" >
<td class="controllerBlock">
<span class="controllerHeader">Weapon Sub (Right Hand):</span><br>
<select name="shieldSecondMenu" onChange = "changeShieldSecond(this.value)" style="width:300px;">
<OPTION value="-1">(none)</OPTION>
<OPTION value="0">Shield of Beholder</OPTION>
<OPTION value="1">Tikka Shield</OPTION>
<OPTION value="2">Vales Shield</OPTION>
<OPTION value="3">Composite Shield</OPTION>
<OPTION value="4">Buckler</OPTION>
<OPTION value="5">Coke Digital Camcorder</OPTION>
<OPTION value="6">Great Sword</OPTION>
<OPTION value="7">Cleaver</OPTION>
<OPTION value="8">Morningstar</OPTION>
<OPTION value="9">Great Mallet</OPTION>
<OPTION value="10">Battle Hammer</OPTION>
<OPTION value="11">Warrior Axe</OPTION>
<OPTION value="12">Broad Axe</OPTION>
<OPTION value="13">Spiked Knuckle</OPTION>
<OPTION value="14">Hobnail Knuckle</OPTION>
<OPTION value="15">Wood Atlatl</OPTION>
<OPTION value="16">Bone Atlatl</OPTION>
<OPTION value="17">Broken Log</OPTION>
<OPTION value="18">Ice Sword</OPTION>
<OPTION value="19">Shining Ice Sword</OPTION>
<OPTION value="20">Ice Pole</OPTION>
<OPTION value="21">Battle Mace</OPTION>
<OPTION value="22">Ivory Sword</OPTION>
<OPTION value="23">Cat Hand Club</OPTION>
<OPTION value="24">Chocolate Stick Wand</OPTION>
<OPTION value="25">Strawberry Stick Wand</OPTION>
<OPTION value="26">White Stick Wand</OPTION>
<OPTION value="27">Ballista</OPTION>
<OPTION value="28">Sword of Beholder</OPTION>
<OPTION value="29">Ditis's Wand of Evil</OPTION>
<OPTION value="30">Reminia's Star And Moon Sword</OPTION>
<OPTION value="31">Shaoranen's Bow of Chivalry</OPTION>
<OPTION value="32">Ruyuefeixue's Amethyst Butterfly</OPTION>
<OPTION value="33">Vales Great Sword</OPTION>
<OPTION value="34">Feather Atlatl</OPTION>
<OPTION value="35">Iron Mace</OPTION>
<OPTION value="36">#36: giant_female_weapon_flamberge01.pmg</OPTION>
<OPTION value="37">Bear Knuckle</OPTION>
<OPTION value="38">Toy hammer</OPTION>
<OPTION value="39">Cylinder</OPTION>
<OPTION value="40">War Sword</OPTION>
<OPTION value="41">Executioner's sword</OPTION>
<OPTION value="42">Eweca Short Sword</OPTION>
<OPTION value="43">Fire Cylinder</OPTION>
<OPTION value="44">Earth Cylinder</OPTION>
<OPTION value="45">Wind Cylinder</OPTION>
<OPTION value="46">Water Cylinder</OPTION>
<OPTION value="47">Jousting Lance</OPTION>
<OPTION value="48">Iron Claw</OPTION>
<OPTION value="49">Ego Great Sword</OPTION>
<OPTION value="50">Ego Cleaver</OPTION>
<OPTION value="51">Ego Morningstar</OPTION>
<OPTION value="52">Ego Great Mallet</OPTION>
<OPTION value="53">Ego Battle Hammer</OPTION>
<OPTION value="54">Ego Warrior Axe</OPTION>
<OPTION value="55">Ego Broad Axe</OPTION>
<OPTION value="56">Ego Ditis's Wand of Evil</OPTION>
<OPTION value="57">Ego Reminia's Star And Moon Sword</OPTION>
<OPTION value="58">Ego Shaoranen's Bow of Chivalry</OPTION>
<OPTION value="59">Ego Ruyuefeixue's Amethyst Butterfly</OPTION>
<OPTION value="60">(temp)tool_row</OPTION>
<OPTION value="61">(temp)dragon_ship_tool_row</OPTION>
<OPTION value="62">(temp)</OPTION>
<OPTION value="63">Sunshade</OPTION>
<OPTION value="64">Duster</OPTION>
<OPTION value="65">Bear Doll</OPTION>
<OPTION value="66">Rabbit Doll</OPTION>
<OPTION value="67">Dragon Killer`s Great Two-Handed Sword</OPTION>
<OPTION value="68">Big Cooking Kneader</OPTION>
<OPTION value="69">Valdorl School Bag</OPTION>
<OPTION value="70">Candy Cane</OPTION>
<OPTION value="71">Axe for Firewood</OPTION>
<OPTION value="72">Plane for Carpentry</OPTION>
<OPTION value="73">Physis Tuba</OPTION>
<OPTION value="74">Andras Puppet</OPTION>
<OPTION value="75">Elatha Puppet</OPTION>
<OPTION value="76">Eldra's Two Handed Sword devoted to Goddess</OPTION>
<OPTION value="77">Soft Ice Cream Short Sword</OPTION>
<OPTION value="78">Dumpling Sword</OPTION>
<OPTION value="79">Cracker Bow</OPTION>
<OPTION value="80">Confeito Mace</OPTION>
<OPTION value="82">Cookie Shield</OPTION>
<OPTION value="83">Tower Cylinder</OPTION>
<OPTION value="84">Falcata</OPTION>
<OPTION value="85">Francisca</OPTION>
<OPTION value="86">Highlander Claymore</OPTION>
<OPTION value="81">Rollcake Cylinder</OPTION>
<OPTION value="87">Fire Sword of Elsinore</OPTION>
<OPTION value="88">Battle Mandolin</OPTION>
<OPTION value="89">Glory Sword</OPTION>
<OPTION value="89">Glory Sword</OPTION>
<OPTION value="91">Dragon Tooth</OPTION>
<OPTION value="92">Trinity Staff</OPTION>
<OPTION value="93">Volcano Cylinder</OPTION>
<OPTION value="94">Earthquake Cylinder</OPTION>
<OPTION value="95">Hurricane Cylinder</OPTION>
<OPTION value="96">Tidalwave Cylinder</OPTION>
<OPTION value="97">Olivier Mira Armstrong's Sword</OPTION>
<OPTION value="98">Winry Rockbell's Spanner</OPTION>
<OPTION value="99">Lorna Puppet</OPTION>
<OPTION value="100">Pan Puppet</OPTION>
<OPTION value="101">Cat Doll</OPTION>
<OPTION value="102">Quill Sword</OPTION>
<OPTION value="103">Fire Wand Of Fairy</OPTION>
<OPTION value="104">Ice Wand Of Fairy</OPTION>
<OPTION value="105">Lightning Wand Of Fairy</OPTION>
<OPTION value="106">Shield of Avon</OPTION>
<OPTION value="107">Ransel</OPTION>
<OPTION value="0">Shield of Beholder</OPTION>
<OPTION value="0">Shield of Beholder</OPTION>
<OPTION value="0">Shield of Beholder</OPTION>
<OPTION value="108">Morrighan Puppet</OPTION>
<OPTION value="109">Cichol Puppet</OPTION>
<OPTION value="0">Shield of Beholder</OPTION>
<OPTION value="110">Targe Shield</OPTION>
<OPTION value="111">Endless Wing Staff</OPTION>
<OPTION value="112">Shield of Valkyrie</OPTION>
<OPTION value="113">Kill The Devil Scythe</OPTION>
<OPTION value="114">Barbarous Fox Scythe</OPTION>
<OPTION value="115">Brace Knuckle</OPTION>
<OPTION value="116">Champion Knuckle</OPTION>
<OPTION value="117">Bear's Paw Pillow</OPTION>
<OPTION value="118">Event Pillow</OPTION>
<OPTION value="119">Club of Sea Troll</OPTION>
<OPTION value="120">Club of Wild Troll</OPTION>
<OPTION value="0">Shield of Beholder</OPTION>
<OPTION value="63">Sunshade</OPTION>
<OPTION value="121">Umbrella</OPTION>
<OPTION value="122">Umbrella</OPTION>
<OPTION value="123">Umbrella</OPTION>
<OPTION value="124">Umbrella</OPTION>
<OPTION value="125">Umbrella</OPTION>
<OPTION value="126">Umbrella</OPTION>
<OPTION value="127">Panda Umbrella</OPTION>
<OPTION value="128">Twinkling Star Umbrella</OPTION>
<OPTION value="129">A lotus leaf Umbrella</OPTION>
<OPTION value="130">Cheeta Hand Club</OPTION>
<OPTION value="131">Demonic Nightmare Dreamcatcher</OPTION>
<OPTION value="132">Moonlight Dreamcatcher</OPTION>
<OPTION value="133">Ordinary Dreamcatcher</OPTION>
<OPTION value="134">Spring Onion Sword Basic</OPTION>
<OPTION value="135">Tangerine Knuckle Basic</OPTION>
<OPTION value="136">Ice Cream Lightning Wand</OPTION>
<OPTION value="137">Ice Cream Fire Wand</OPTION>
<OPTION value="138">Ice Cream Ice Wand</OPTION>
<OPTION value="139">Electric Guitar</OPTION>

</select>

<select name="shieldSecondState" onChange="changeShieldSecondState(this.value);" style="width:80px;">
<option value="0">Useable</option>
<option value="1">NotUseable</option>
</select><br>
<span class="colorPaletteMini" id="shieldSecondPalette1" onClick="dyeColor(this);changeShieldSecondColorByPalette(1);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="shieldSecondColor1">
<span class="colorPaletteMini" id="shieldSecondPalette2" onClick="dyeColor(this);changeShieldSecondColorByPalette(2);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="shieldSecondColor2">
<span class="colorPaletteMini" id="shieldSecondPalette3" onClick="dyeColor(this);changeShieldSecondColorByPalette(3);" onContextMenu="pickColor(this);return false;"><img src="sp.gif"></span>
<input type="text" value="7f7f7f" size="8" name="shieldSecondColor3">
<a class="controllerLink" href="javascript:void(0);" onClick="dyeShieldSecond(shieldSecondColor1.value,shieldSecondColor2.value,shieldSecondColor3.value);">Dye</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="searchPublist(shieldSecondMenu.options[shieldSecondMenu.selectedIndex].text);">Search</a> 
<a class="controllerLink" href="javascript:void(0);" onClick="controller.shieldSecondMenu.value=-1;changeShieldSecond(controller.shieldSecondMenu.value);">Purge</a>
</td>
</tr>
</tbody>
</table>
</form>
<!-- form table -->
</div>

<!-- contrgn -->
</td>
</tr>
</tbody>
</table>

<FORM name="formCaptureSnapshot" target="_blank" method="POST" action="snapshot.php">
	<INPUT type="hidden" name="action" value="captureSnapshot">
	<INPUT type="hidden" name="code" value="">
	<INPUT type="hidden" name="q" value="">
</FORM>

<FORM name="formCaptureDressroom" target="_blank" method="POST" action="dressroom.php">
	<INPUT type="hidden" name="action" value="captureDressroom">
	<INPUT type="hidden" name="code" value="">
	<INPUT type="hidden" name="q" value="">
</FORM>

<FORM name="formCaptureBlogparts" target="_blank" method="POST" action="blogparts.php">
	<INPUT type="hidden" name="action" value="captureSnapshot">
	<INPUT type="hidden" name="code" value="">
	<INPUT type="hidden" name="q" value="">
</FORM>

<FORM name="formEntryPublist" target="_blank" method="POST" action="http://kukulu.erinn.biz/login._mcs2.publist.php">
	<INPUT type="hidden" name="action" value="addPubList">
	<INPUT type="hidden" name="code" value="">
	<INPUT type="hidden" name="q" value="">
</FORM>

<FORM name="formEntryMylist2" target="mylist2if" method="POST" action="http://kukulu.erinn.biz/mcs2.mylist.php">
	<INPUT type="hidden" name="action" value="addMyList">
	<INPUT type="hidden" name="code" value="">
	<INPUT type="hidden" name="q" value="">
	<INPUT type="hidden" name="name" value="">
</FORM>

<div style="display:none;">
<IFRAME name="MCODEAPI" src="about:blank" border="0" width="0" height="0"></IFRAME>
</div>
<FORM name="formMCODEAPIRequest" target="MCODEAPI" method="POST" action="mcode_api.php">
	<INPUT type="hidden" name="mode" value="">
	<INPUT type="hidden" name="action" value="">
	<INPUT type="hidden" name="script" value="">
</FORM>

<div style="display:none;">
<IFRAME name="TrueMabiColor" src="about:blank" border="0" width="0" height="0"></IFRAME>
</div>
<FORM name="formTrueMabiColorRequest" target="TrueMabiColor" method="POST" action="mabitruecolor_api.php">
	<INPUT type="hidden" name="gcolor" value="">
	<INPUT type="hidden" name="palette" value="normal1">
</FORM>

<FORM name="formPublistSearch" target="_blank" method="GET" action="publist.php">
	<INPUT type="hidden" name="word" value="">
</FORM>

<center>
	<div style="padding:5px;">

			<!-- MCS2_Control_Bottom2 -->
			<div id='div-gpt-ad-1333659646944-0' style='width:336px; height:280px;'>
			<script type='text/javascript'>
			googletag.cmd.push(function() { googletag.display('div-gpt-ad-1333659646944-0'); });
			</script>
			</div>

	</div>
</center>

<center>

	<br>
	<A href="http://labo.erinn.biz/" target="_blank"><IMG src="../b/kl/b.png" alt="くくらぼ" width="81" height="31" border="0"></A> 

	<A href="http://eriwacs.erinn.biz/" target="_blank"><IMG src="../b/ew/b.png" alt="ERIWACS - キャラクターウォッチ" width="81" height="31" border="0"></A> 
	<A href="http://mari.erinn.biz/" target="_blank"><IMG src="../b/et/banner_mabijp1.png" alt="ErinnTrader ≪マリー≫ - マビノギ相場価格調査" width="81" height="31" border="0"></A> 
	<A href="http://mari.kt.erinn.biz/" target="_blank"><IMG src="../b/kt/banner_mabijp1.png" alt="KukuTimer ≪マリー≫ - マビノギイリアボスタイマー" width="81" height="31" border="0"></A> 
	<A href="http://mari.kukulu.erinn.biz/" target="_blank"><IMG src="../b/ku/banner_mabijp1.png" alt="KukuTimer ≪マリー≫" width="81" height="31" border="0"></A> 

	<br>
	<div><a href="http://aquapal.net/" target="_blank"><img src="aquapal.png" border="0"></a></div>
	<br>

	<font size="-2">
	Mabinogi Character Simulator 2 は、マビノギの3Dアバターを<br>
	自由に着せ替えできるシミュレータです。<br>
	キャラクターデータベース kukulu と連動して、<br>
	現在のあなたの容姿を読み込むこともできます。<BR>
	<br>
	(c) くくらぼ, aquapal/kuku.<br>
	(c) まびらぼ pseudo Mabinogi Character Simulator http://mabinogi.or.tp/<br>
	<br>
	「マビノギ」スクリーンショットおよび関連画像は <br>
	NEXON Corporation および NEXON Japan Co., の著作物です。<br>
	<br>
	<br>
	</font>
</center>

<br><br><br><br><br>

<img src="pbg.png" width="0" height="0">
<img src="pbg2.png" width="0" height="0">

</body>
</html>