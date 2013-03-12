<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja-JP"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Mabinogi Character Simulator</title>

<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Style-Type" content="text/css">

<style type="text/css">
<!--
BODY{
  padding : 5px;
  margin : 0px;
  font-family : "Meiryo UI";
}
-->
</style>

<script type="text/javascript">
<!--
function execute_success() {
}
var init_cs = false;
function execute( script ) {
	if (init_cs) {
		cs.execute = script;
	} else {
		parent.request_full_execute();
	}
}
function full_execute( script ) {
}
function softreset( script ) {
	document.srform.code.value = script;
	document.srform.submit();
}
function cookieset(name, value) {
    var buf = name + '=' + encodeURIComponent(value);
    document.cookie = buf + ';';
}
//-->
</script>

</head>
<body bgcolor="FFFFFF">
	


<table border="0" width="100%" height="100%" cellpadding="0" cellspacing="0">
<tbody>
<tr>
<td valign="middle" align="center">

	
	<object id="cs" classid="clsid:7623BE59-D4CF-4379-ABC4-B39E11854D66" codebase="http://localhost/mabiweb.2012.04.25.0.cab" width="512" height="512" >
	<param name="antialias" value="2" />
	<param name="bgcolor" value="FFFFFF" />
	<param name="camera" value="-190 15 0.7" />
	<param name="onactive" value="0" />
	<param name="usercode" value="4p6NgM4PsWKQk63A" />
	<param name="code" value="gTqIXBaE0BGNET7RzvWCuPrQFoa;ykaM15LNSpaPedaM;8q;R6rLpLbQXnWQ3nZR66KRkj6Qmlk;n9aMeEqOKMrPEB2NhBLMl7aQJUqMpMZ2t3bQMpqPsyGAOmUAnJaELwqPKDWQpHYBJInEk1W2" />
	<img src="error.png" alt="Can't load ActiveX plugin" />
	</object>
	<script>
		init_cs = true;
	</script>
	
	
</td>
</tr>
</tbody>
</table>

<form name="srform" method="POST" action="http://localhost/main">
<input type="hidden" name="code" value="">
<input type="hidden" name="width" value="576">
<input type="hidden" name="height" value="720">
<input type="hidden" name="antia" value="2">
<input type="hidden" name="bgcolor" value="FFFFFF">
</form>




</body><style type="text/css"></style></html>