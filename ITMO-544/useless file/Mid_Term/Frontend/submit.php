<?php
// Start the session
session_start();
// In PHP versions earlier than 4.1.0, $HTTP_POST_FILES should be used instead
// of $_FILES.
require '/home/ubuntu/vendor/autoload.php';

use Aws\Rds\RdsClient;
use Aws\S3\S3Client;
use Aws\Exception\AwsException;


$rdsclient = new Aws\Rds\RdsClient([
            'version' => '2014-10-31',
            'region' => 'us-east-1'
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

$endpoint = $result['DBInstances'][0]['Endpoint']['Address'];
//$endpoint = "pjain24-instance.cvs4vczdbufc.us-east-1.rds.amazonaws.com";i
echo $endpoint;

echo $_POST['useremail'];
$uploaddir = '/tmp/';
$uploadfile = $uploaddir . basename($_FILES['userfile']['tmp_name']);

echo $uploadfile;
echo '<pre>';
if (move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadfile)) {
            echo "File is valid, and was successfully uploaded.\n";
} else {
            echo "Possible file upload attack!\n";
}

echo 'Here is some more debugging info:';
print_r($_FILES);


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
echo $result;
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
$result = $s3->putObject([
                'Bucket' => $bucket2,
                    'Key' => $newkey,
                    'SourceFile' => $downloadfilepath,
                    'ACL' => 'public-read'
                ]);
echo $result;
$url2 = $result['ObjectURL'];
echo $url2;
/////////////////////////////////////////////////////////////////////////////////////////////


$connection = mysqli_connect($endpoint, "master", "p4ssw0rd");

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

$email = $_POST['useremail'];
$phone = $_POST['phone'];
  $s3rawurl = $url;
  $filename = $key;
    $s3finishedurl = $url2;
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