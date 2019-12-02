<?php session_start(); ?>
<html>
<head><title>pjain24@hawk.iit.edu</title>
</head>
<hr/>
<body style="background-color:powderblue;">
<h1 align="center"> Midterm Project </h1>
<h3 align="center">Done by: Palash Jain </h3>
<h5 align="center">A20430557</h5>
<hr/>
<!-- The data encoding type, enctype, MUST be specified as below -->
<form enctype="multipart/form-data" action="submit.php" method="POST" align="center">

    <!-- MAX_FILE_SIZE must precede the file input field -->
    <input type="hidden" name="MAX_FILE_SIZE" value="3000000" />
    <!-- Name of input element determines name in $_FILES array -->
Send this file : <input  name="userfile" type="file" /><br />
Enter Name of user: <input type="name" name="username"><br />
Enter Email of user: <input type="email" name="useremail"><br />
Enter Phone of user: <input type="phone" name="phone"><br/>


</br><input type="submit" value="Submit" />
</form>
<hr/>
<hr/>
<form enctype="multipart/form-data" action="gallery.php" method="POST" align="center"></br>

Enter Email of user: <input type="email" name="useremail"><br />
</br><input type="submit" value="gallery" />
<hr/>
</form>


</body>
,</html>