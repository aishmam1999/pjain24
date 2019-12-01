<?php
// Start the session
session_start();
// In PHP versions earlier than 4.1.0, $HTTP_POST_FILES should be used instead
// of $_FILES.
require '/home/ubuntu/vendor/autoload.php';
/////////////////////////////////////////////////////// RDS Client///////////////////////////////////////////////////
// use Aws\Rds\RdsClient;
use Aws\S3\S3Client;

 echo $_POST['useremail'];
 $uploaddir = '/tmp/';
 $uploadfile = $uploaddir . basename($_FILES['userfile']['tmp_name']);

// echo $uploadfile;
// echo '<pre>';
 if (move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadfile)) {
             echo "File is valid, and was successfully uploaded.\n";
 } else {
             echo "Possible file upload attack!\n";
 }

// echo 'Here is some more debugging info:';
// print_r($_FILES);
///////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////// Dynamodb /////////////////////////////////////////////

# https://docs.aws.amazon.com/aws-sdk-php/v3/api/api-dynamodb-2012-08-10.html#putitem
# PHP UUID generator for Receipt- https://www.php.net/manual/en/function.uniqid.php

////////////////////////////////////////////////Dynamodb end////////////////////////////////////////////////////////////

 $s3 = new S3Client([
                'region' => 'us-east-1',
                    'version' => '2006-03-01'
            ]);

$bucket="pal-544-raw-bucket";
$key = $_FILES['userfile']['name'];
echo ".....................................................";
echo $key, $uploadfile;
$result = $s3->putObject([
                'Bucket' => $bucket,
                    'Key' => $key,
                    'SourceFile' => $uploadfile,
                    'ACL' => 'public-read'
                ]);
echo result;
$url = $result['ObjectURL'];
echo $url;

echo "------------------------------------WORKS TILL HERE-------------------------------";


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

$downloaddir = '/tmp/';
$downloadfile = "$downloaddir$key";

echo "Attempting to download $key to $downloadfile";
try{
        $result = $s3->getObject(array(
              'Bucket' => $bucket,
              'Key' => $key,
              'SaveAs' => $downloadfile));
}       catch (AwsException $e) {
         // output error message if fails
             echo $e->getMessage();
                 echo "\n";
}
echo $result;
echo "------------------------------------DOWNLOADED RAW from S3-------------------------------";

$newkey = "processed".$key;
$downloadfilepath = $downloaddir.$newkey;
////////////////////////////////////////////////////////////////////////////////////
    $im = imagecreatefrompng($downloadfile);
        echo $im;
    if($im && imagefilter($im, IMG_FILTER_GRAYSCALE))
    {
                imagepng($im, $downloadfilepath);
                echo "Image converted to grayscale. Original Image: $im PRocessed Key: $newkey";
    }
    else
    {
                echo 'Conversion to grayscale failed.';
    }
    echo "------------------------------------Converted to GrayScale-------------------------------";

//////////////////////////////////////////////////////////////////////////////////////

$bucket2="pal-544-finalize-bucket";
echo "uploading $newkey from $downloadfile to $bucket2";
echo $newkey;
$receipt = uniqid();
echo $receipt;
$result = $s3->putObject([
                'Bucket' => $bucket2,
                    'Key' => $receipt.'-'.$newkey,
                    'SourceFile' => $downloadfilepath,
                    'ACL' => 'public-read'
                ]);
echo $result;
$url2 = $result['ObjectURL'];
echo $url2;
///////////////////////////////////////////////////////////////////////////////////////////// Dynamo DB //////////////////////////////////
echo "----------------------------------------------------------------Dynamo DB Working -----------------------------------------------------";
use Aws\DynamoDb\DynamoDbClient;

$client = new DynamoDbClient([
                'region'  => 'us-east-1',
                    'version' => 'latest'
            ]);


# https://docs.aws.amazon.com/aws-sdk-php/v3/api/api-dynamodb-2012-08-10.html#putitem
# # PHP UUID generator for Receipt- https://www.php.net/manual/en/function.uniqid.php
#


$useremail = $_POST['useremail'];
$phone = $_POST['phone'];
$file = $uploadfile;

$result = $client->putItem([
          'Item' => [ // REQUIRED
                       'Receipt' => ['S' => $receipt],
                       'Email' => ['S' => $useremail],
                       'Phone' => ['S' => $phone],
                       'Filename' => ['S' => $file],
                       'S3rawurl' => ['S' => $url],
                       'S3finishedurl' => ['S' => ' '],
                       'Status' => ['BOOL' => false],
                       'Issubscribed' => ['BOOL' => false] ],

                        'TableName' => 'RecordsPal', // REQUIRED

                        ]);

print_r($result);



?>