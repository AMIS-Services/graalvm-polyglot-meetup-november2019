#!/usr/bin/env node
var count = 0;
var maxCount = 100;
var primes = [];
var i = 2;

while(count<maxCount) {
    if( isPrime(i) ) {
        primes.push(i);
        count++;
    }
    i++;
}

function isPrime (n)
{
    if ( n%1 || n<2 ) return false;
    var q = Math.sqrt(n);
    for (var i = 2; i <= q; i++)  {
        if (n % i === 0) 
            return false;
    }
    return true;
}

console.log("Prime numbers from 1 to 100 are :");
var primeNumbers = primes.toString();
console.log(primeNumbers);
