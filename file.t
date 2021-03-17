/% long
comment long
comment %/

func foo1(a, b, y : int; c: char) return bool
{
	var res : bool;
	{
		var x, b : char;
		var y: int;

		b = '&';
		/% a = x; %/ 
		/% b = 8; %/
		a = (y * 7)/a-y;
		/% a = (y * 7)/b-y; %/
		/% a = (y * 7)/a-c; %/

		res = (b == c) && (y > a);
		/% res = (b == c) && (y + a); %/
		/% 3 + 6 = 9; %/
		/% ^x = 6; %/
	}
    	return res ;
}


proc fee1(i, j, k, x : int)
{
    func fee2(l, m, n : int) return bool
    {
	var x, j: bool;
	/% var n: bool; %/
	var k: char;
	k = '@';
	i = l + l;
	/% i = j + 1; %/
	/% i = k + 1; %/
	if ((k == '*') || (x != false) && (l + m < i)){
		x = l < m;
	}
        return x;
    }
    {
	var x : char;
	var k: bool;
	k = fee2(5,i,j);
	/% x = fee2(5,i,j); %/
	/% k = fee2(5,i); %/
	/% k = fee2(5,x,j); %/
     }
    /% n = false; %/
    /% x = '#';	%/
    x = k;
}


func foo3(i, j, k : int) return int
{
    func square(t : int) /% function declarations %/ return int
    {
        var temp : int;
        temp = t * t;
        return temp;
    }

    var total : int;                       /% variable declarations %/
    var bo : bool;
    bo = foo1(i,j,k,'^');
    /% j = foo2(); %/
    total = square(i+j+k);                    /% statements %/
    return total;
}


func foo2() return int
{
    var s1, s2: string[100];
    var i, j, cnt: int;
    i=0;
    j=0;
    cnt = 1;
    while(i<|s1|){
	while(j<|s2|/2){
	    if (s1[i] == s2[j]){
		cnt = cnt*2;
	    }
	    j=j+1;
	}
	i=i+1;
    }
    return cnt;
}


func foo4() return int
{
    {   
	var x : int;
	var y : int*;
	x = 5;
	y = &x;
	x = 6;
	if (&x == y && ^y == x){
		^y = 9;
	}
     	{
		var x : char*;
		var y : string[10];
		var z : char;
		y = "foobar";
		x = &y[5];         
		z = ^(x - 5);       
		y = "barfoo"; 
   		{
			var x : char;
			var y : int*;
			var z : char*;
			var g : char;
			/% y = &(1+3);
			y = &x;             
			z = &(&g); %/
    		}
	}
     }
    return 0;
}



proc Main()
{
    var a : int;
    a = foo2();
}
