<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<?php 
	$jsonString = htmlspecialchars("[{\"client_ID\":1,\"skeleton_ID\":21,\"xPos\":0.184943289,\"zPos\":-0.1895751,\"orientation\":0.0}]");
?>


<form action="http://9ifvp.w4yserver.at/uni/sharedSpace/postSkeletons.php" method="post">

	<input type="text" name="jsonString" value="<?php echo $jsonString; ?>" />

	<input type="submit" value="TEST" />
</form>


</body>
</html>