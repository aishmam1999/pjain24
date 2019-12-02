<?php
session_start();

require '/home/ubuntu/vendor/autoload.php';
use Aws\Exception\AwsException;


use Aws\DynamoDb\DynamoDbClient;

$useremail = $_POST['useremail'];

//$useremail = "pjain24@hawk.iit.edu";
$client = new DynamoDbClient([
    'region'  => 'us-east-1',
    'version' => 'latest'
]);


$result = $client->scan([
    'ExpressionAttributeNames' => [
        '#S3R' => 'S3finishedurl',
        '#S3F' => 'S3rawurl',
    ],
    'ExpressionAttributeValues' => [
        ':e' => [
            'S' =>$useremail,
        ],
    ],
    'FilterExpression' => 'Email = :e',
    'ProjectionExpression' => '#S3F, #S3R',
    'TableName' => 'RecordsPal',
]);
print_r($result);
echo "------------------------------------WORKS TILL HERE-------------------------------";

# retrieve the number of elements being returned -- use this to control the for loop
$len = $result['Count'];
echo "Len: " . $len . "\n";
print_r($result['Items'][0]['S3rawurl']['S']);
echo "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ \n";
echo($result['Items'][0]['S3rawurl']['S']);

print_r($result['Items'][0]['S3finishedurl']['S']);
echo "//////////////////////////////////////////////////\n";
# for loop to iterate through all the elements of the returned matches
for ($i=0; $i <= $len; $i++) {
    echo "\n";
    //print_r($result['Items'][$i]['S3rawurl']['S']);
    echo "\n";
    print_r($result['Items'][$i]['S3finishedurl']['S']);
    $finalimage = $result['Items'][$i]['S3finishedurl']['S'];
    echo "<tr><td><img src= $finalimage ></td> </tr>";


}
?>