<?php
// Start the session
session_start();
// In PHP versions earlier than 4.1.0, $HTTP_POST_FILES should be used instead
// of $_FILES.
require '/home/ubuntu/vendor/autoload.php';
/////////////////////////////////////////////////////// RDS Client///////////////////////////////////////////////////
use Aws\DynamoDb\DynamoDbClient;
use Aws\S3\S3Client;

$useremail = $_POST['useremail'];
$phone = $_POST['phone'];

$uploaddir = '/tmp/';
$uploadfile = $uploaddir . basename($_FILES['userfile']['tmp_name']);

if (move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadfile)) {
             echo "File is valid, and was successfully uploaded.\n";
 } else {
             echo "Possible file upload attack!\n";
 }

$s3 = new S3Client([
                'region' => 'us-east-1',
                'version' => '2006-03-01'
            ]);

$receipt = uniqid();
echo $receipt;

$bucket="pal-544-raw-bucket";
$newkey = $_FILES['userfile']['name'];

echo ".....................................................\n";
echo $newkey, $uploadfile;

$result = $s3->putObject([
                'Bucket' => $bucket,
                    'Key' => $receipt.'-'.$newkey,
                    'SourceFile' => $uploadfile,
                    'ACL' => 'public-read'
                ]);
echo result;
$url = $result['ObjectURL'];
echo $url;

echo "------------------------------------WORKS TILL HERE-------------------------------";

$client = new DynamoDbClient([
                'region'  => 'us-east-1',
                'version' => 'latest'
            ]);

            $result = $client->putItem([
                'Item' => [ // REQUIRED
                    'Receipt' => ['S' => $receipt],
                    'Email' => ['S' => $useremail],
                    'Phone' => ['S' => $phone],
                    'Filename' => ['S' => $uploadfile],
                    'S3rawurl' => ['S' => $url],
                    'S3finishedurl' => ['S' => 'NA'],
                    'Status' => ['BOOL' => false],
                    'Issubscribed' => ['BOOL' => True]
                    ],
                    'TableName' => 'RecordsPal', // REQUIRED
                    ]);
print_r($result);

?>