<?php
session_start();
require '/home/ubuntu/vendor/autoload.php';

//use Aws\Rds\RdsClient;
use Aws\S3\S3Client;
use Aws\Exception\AwsException;
use Aws\DynamoDb\DynamoDbClient;

$email = $_POST['useremail'];

//echo "$email";
// $result = $client->getItem([
//     'TableName' => 'RecordsXYZ',
//     'Key' => [
//                     'Receipt' => ['S' => '5dd31c34bdd98'],
//                     'Email' => ['S' => 'hajek@iit.edu'],
//             ],
// ]);

// print_r($result);

// echo "Results: " . "\n";
// print_r($result['Item']['S3rawurl']['S']);





// $rdsclient = new Aws\Rds\RdsClient([
//     'version' => '2014-10-31',
//     'region' => 'us-east-1'
// ]);
// try {
//     $result = $rdsclient->describeDBInstances([
//         ]);

//     foreach ($result['DBInstances'] as $instance) {
//         print('<p>DB Identifier: ' . $instance['DBInstanceIdentifier']);
//         print('<br />Endpoint: ' . $instance['Endpoint']["Address"]);
//         print('<br />Current Status: ' . $instance["DBInstanceStatus"]);
//         print('</p>');
//                                                     }
//         print(" Raw Result ");

// } catch (AwsException $e) {
//     // output error message if fails
//      echo $e->getMessage();
//          echo "\n";
// }
// $endpoint = $instance['Endpoint']["Address"];
// //echo $endpoint;
// //echo 'it should come pjain24-instance.cvs4vczdbufc.us-east-1.rds.amazonaws.com';
// //$endpoint = "pjain24-instance.cvs4vczdbufc.us-east-1.rds.amazonaws.com";
// //echo $endpoint;
// $s3 = new S3Client([
//     'region' => 'us-east-1',
//         'version' => '2006-03-01'
// ]);

// $useremail = 'palashjain2801@gmail.com';
//   $sql = "SELECT *  FROM items";
//   //echo $sql;

//   $connection = mysqli_connect($endpoint, "master", "p4ssw0rd");

//     if (mysqli_connect_errno()) echo "Failed to connect to MySQL: " . mysqli_connect_error();

//     $database = mysqli_select_db($connection, "records");
//     $result = mysqli_query($connection, "SELECT * FROM items where email = '$email'");

//     while($query_data = mysqli_fetch_row($result)) {
//                           echo "<tr>
//                                     <td><img src=$query_data[4] ></td>
//                                     <td><img src=$query_data[5] ></td>
//                                 </tr>";
//                             }

# https://docs.aws.amazon.com/aws-sdk-php/v3/api/api-dynamodb-2012-08-10.html#getitem
# https://docs.aws.amazon.com/aws-sdk-php/v3/api/api-dynamodb-2012-08-10.html#getitem-example-1



$client = new DynamoDbClient([
    'profile' => 'default',
    'region'  => 'us-east-1',
    'version' => 'latest'
]);

$result = $client->getItem([
    'TableName' => 'RecordsPal',
    'Key' => [
                    //'Receipt' => ['S' => '5dd31c34bdd98'],
                    'Email' => ['S' => email],
            ],
    'ProjectionExpression' => "S3finishedurl", "S3rawurl"
]);

print_r($result);

echo "Results: " . "\n";
echo "S3finished URL: " . "\n";
//print_r($result['S3finishedurl']['S']);

?>