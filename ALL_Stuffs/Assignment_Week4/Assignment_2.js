
function sumCongruentModulo(inputArray, divisor, remainder) {

    let sum = 0;
    for(i=0;i<=inputArray.length;i++)
    {
        if(inputArray[i]%divisor===remainder)
            sum = sum + inputArray[i];
    }
    return sum;

}
console.log(sumCongruentModulo([1,2,3,6], 3, 0));