<?php

  /* Connect to MySQL and select the database. */
  $connection = mysqli_connect("pjain24-instance.cvs4vczdbufc.us-east-1.rds.amazonaws.com", "master", "p4ssw0rd");

  if (mysqli_connect_errno()) echo "Failed to connect to MySQL: " . mysqli_connect_error();

  $database = mysqli_select_db($connection, "records");
 $result = mysqli_query($connection, "SELECT * FROM items");

  while($query_data = mysqli_fetch_row($result)) {
            echo "<tr>";
              echo "<td>",$query_data[0], "</td>",
                             "<td>",$query_data[1], "</td>",
                             "<td>",$query_data[2], "</td>";
              echo "</tr>";
  }
  if (!($stmt = $connection->prepare("INSERT INTO items (id, email,phone,filename,s3rawurl,s3finishedurl,status,issubscribed) VALUES (NULL,?,?,?,?,?,?,?)"))) {
              echo "Prepare failed: (" . $link->errno . ") " . $link->error;
  }

  $email = "useremail";
  $phone = "userphone";
  $s3rawurl = "s3rawurl";
  $filename = "key";
  $s3finishedurl = "s3finishedurl";
  $status =1;
  $issubscribed=0;

  $stmt->bind_param("sssssii",$email,$phone,$filename,$s3rawurl,$s3finishedurl,$status,$issubscribed);

  if (!$stmt->execute()) {
              echo "Execute failed: (" . $stmt->errno . ") " . $stmt->error;
  }else{

  printf("%d Row inserted.\n", $stmt->affected_rows);
  }

  $stmt -> close();
  $connection -> close();
?>