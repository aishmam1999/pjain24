<?php
session_start();
require '/home/ubuntu/vendor/autoload.php';
use Aws\Rds\RdsClient;
use Aws\S3\S3Client;
use Aws\Exception\AwsException;
$email = $_POST['useremail'];
echo "$email";
$rdsclient = new Aws\Rds\RdsClient([
    'version' => '2014-10-31',
    'region' => 'us-east-2'
]);
try {
    $result = $rdsclient->describeDBInstances([
        ]);

    foreach ($result['DBInstances'] as $instance) {
        print('<p>DB Identifier: ' . $instance['DBInstanceIdentifier']);
        print('<br />Endpoint: ' . $instance['Endpoint']["Address"]);
        print('<br />Current Status: ' . $instance["DBInstanceStatus"]);
        print('</p>');
                                                    }
        print(" Raw Result ");

} catch (AwsException $e) {
    // output error message if fails
     echo $e->getMessage();
         echo "\n";
}

$endpoint = "pjain24-instance.cvs4vczdbufc.us-east-1.rds.amazonaws.com";
echo $endpoint;
$s3 = new S3Client([
    'region' => 'us-east-1',
        'version' => '2006-03-01'
]);

$useremail = 'palashjain2801@gmail.com';
  $sql = "SELECT *  FROM items";
  echo $sql;

  $connection = mysqli_connect($endpoint, "master", "p4ssw0rd");

    if (mysqli_connect_errno()) echo "Failed to connect to MySQL: " . mysqli_connect_error();

    $database = mysqli_select_db($connection, "records");
    $result = mysqli_query($connection, "SELECT * FROM items where email = '$email'");

    while($query_data = mysqli_fetch_row($result)) {
                          echo "<tr>
                                    <td><img src=$query_data[4] ></td>
                                    <td><img src=$query_data[5] ></td>
                                </tr>";
                            }


?>