<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<meta http-equiv="Content-Style-Type" content="text/css">
<meta name="viewport" content="width=device-width">
<title>Mabinogi Character Simulator</title>
<script type="text/javascript">
<!--
function request_full_execute()
{
	contol.request_full_execute();
}
function execute( script )
{
	main.execute( script );
}
function full_execute( script )
{
	main.full_execute( script );
}
function softreset( script )
{
	main.softreset( script );
}
function config_load()
{
	//jsinitvals
		contol.sLanguageIndex = "1";	//1@1
	contol.sAvatarSize = "1";	//1@2
	contol.sAvatarAA = "2";	//1@3
	contol.sBgColorp = "FFFFFF";	//1@4
	contol.sBgColor = contol.convertColor(contol.sBgColorp);
	contol.sFramework = "3";	//2@1
	contol.sHeightScalep = "0.4";	//3@1
	contol.sFatnessScalep = "0.9";	//3@2
	contol.sTopScalep = "0.6";	//3@3
	contol.sBottomScalep = "0.6";	//3@4
	contol.sSkinColorp = "9C5D42";	//4@1
	contol.sSkinColor = contol.convertColor(contol.sSkinColorp);
	contol.sSkinColorIndex = "9";	//4@2
	contol.sEyeColorp = "424563";	//5@1
	contol.sEyeColor = contol.convertColor(contol.sEyeColorp);
	contol.sHairIndex = "110";	//6@1
	contol.sHairColorIndex = "11";	//6@2
	contol.sHairColorp = "7B2C10";	//7@1
	contol.sHairColor = contol.convertColor(contol.sHairColorp);
	contol.sHeadIndex = "4";	//8@1
	contol.sHeadWearState = "0";	//8@2
	contol.sHeadColor1p = "00687F";	//9@1
	contol.sHeadColor1 = contol.convertColor(contol.sHeadColor1p);
	contol.sHeadColor2p = "08619F";	//9@2
	contol.sHeadColor2 = contol.convertColor(contol.sHeadColor2p);
	contol.sHeadColor3p = "E9B454";	//9@3
	contol.sHeadColor3 = contol.convertColor(contol.sHeadColor3p);
	contol.sFaceIndex = "16";	//10@1
	contol.sFaceColor1p = "000000";	//11@1
	contol.sFaceColor1 = contol.convertColor(contol.sFaceColor1p);
	contol.sFaceColor2p = "000000";	//11@2
	contol.sFaceColor2 = contol.convertColor(contol.sFaceColor2p);
	contol.sFaceColor3p = "000000";	//11@3
	contol.sFaceColor3 = contol.convertColor(contol.sFaceColor3p);
	contol.sBodyIndex = "-2";	//12@1
	contol.sBodyColor1p = "516E7B";	//13@1
	contol.sBodyColor1 = contol.convertColor(contol.sBodyColor1p);
	contol.sBodyColor2p = "1F4C56";	//13@2
	contol.sBodyColor2 = contol.convertColor(contol.sBodyColor2p);
	contol.sBodyColor3p = "656C79";	//13@3
	contol.sBodyColor3 = contol.convertColor(contol.sBodyColor3p);
	contol.sHandColor1p = "1676e1";	//15@1
	contol.sHandColor1 = contol.convertColor(contol.sHandColor1p);
	contol.sHandColor2p = "3cc8d5";	//15@2
	contol.sHandColor2 = contol.convertColor(contol.sHandColor2p);
	contol.sHandColor3p = "4a76a1";	//15@3
	contol.sHandColor3 = contol.convertColor(contol.sHandColor3p);
	contol.sFootIndex = "16";	//16@1
	contol.sFootColor1p = "183532";	//17@1
	contol.sFootColor1 = contol.convertColor(contol.sFootColor1p);
	contol.sFootColor2p = "4E7070";	//17@2
	contol.sFootColor2 = contol.convertColor(contol.sFootColor2p);
	contol.sFootColor3p = "2A4F61";	//17@3
	contol.sFootColor3 = contol.convertColor(contol.sFootColor3p);
	contol.sWeaponFirstIndex = "82";	//18@1
	contol.sWeaponFirstWearState = "0";	//18@2
	contol.sWeaponFirstColor1p = "4AD7D1";	//19@1
	contol.sWeaponFirstColor1 = contol.convertColor(contol.sWeaponFirstColor1p);
	contol.sWeaponFirstColor2p = "5F6068";	//19@2
	contol.sWeaponFirstColor2 = contol.convertColor(contol.sWeaponFirstColor2p);
	contol.sWeaponFirstColor3p = "13609B";	//19@3
	contol.sWeaponFirstColor3 = contol.convertColor(contol.sWeaponFirstColor3p);
	contol.sWeaponSecondIndex = "12";	//20@1
	contol.sWeaponSecondWearState = "1";	//20@2
	contol.sWeaponSecondColor1p = "808080";	//21@1
	contol.sWeaponSecondColor1 = contol.convertColor(contol.sWeaponSecondColor1p);
	contol.sWeaponSecondColor2p = "D2BC95";	//21@2
	contol.sWeaponSecondColor2 = contol.convertColor(contol.sWeaponSecondColor2p);
	contol.sWeaponSecondColor3p = "707070";	//21@3
	contol.sWeaponSecondColor3 = contol.convertColor(contol.sWeaponSecondColor3p);
	contol.sShieldFirstColor1p = "1676e1";	//23@1
	contol.sShieldFirstColor1 = contol.convertColor(contol.sShieldFirstColor1p);
	contol.sShieldFirstColor2p = "3cc8d5";	//23@2
	contol.sShieldFirstColor2 = contol.convertColor(contol.sShieldFirstColor2p);
	contol.sShieldFirstColor3p = "4a76a1";	//23@3
	contol.sShieldFirstColor3 = contol.convertColor(contol.sShieldFirstColor3p);
	contol.sShieldSecondColor1p = "1676e1";	//25@1
	contol.sShieldSecondColor1 = contol.convertColor(contol.sShieldSecondColor1p);
	contol.sShieldSecondColor2p = "3cc8d5";	//25@2
	contol.sShieldSecondColor2 = contol.convertColor(contol.sShieldSecondColor2p);
	contol.sShieldSecondColor3p = "4a76a1";	//25@3
	contol.sShieldSecondColor3 = contol.convertColor(contol.sShieldSecondColor3p);
	contol.sRobeColor1p = "1676e1";	//27@1
	contol.sRobeColor1 = contol.convertColor(contol.sRobeColor1p);
	contol.sRobeColor2p = "3cc8d5";	//27@2
	contol.sRobeColor2 = contol.convertColor(contol.sRobeColor2p);
	contol.sRobeColor3p = "4a76a1";	//27@3
	contol.sRobeColor3 = contol.convertColor(contol.sRobeColor3p);
	contol.sEyeEmotionIndex = "107";	//28@1
	contol.sEyeColorIndex = "11";	//28@2
	contol.sMouthEmotionIndex = "29";	//29@1
	contol.sReactionIndex = "0";	//30@1
	contol.sAnimationIndex = "1904";	//31@1
	contol.sAnimationFramep = "12398";	//32@1
	contol.sAnimatorPlayingState = "0";	//32@2
}
function shortURL2()
{
	contol.shortURL2();
}


	function iPhone_ScrollNow() {
		window.scrollTo(0,1);
	}
	setTimeout(iPhone_ScrollNow, 500);

//-->
</script>
</head>



	<frameset cols="*,450,0" bordercolor="#ffffff" border="0" frameborder="1">
		
		<frame name="main" id="maind" src="main">

		<frame style="border-left-width : 2px;border-left-style : solid;border-left-color : silver;" name="contol" src="control">
	  
					<frame name="launcher" src="about:blank">
						
	</frameset>


<style type="text/css"></style></html>