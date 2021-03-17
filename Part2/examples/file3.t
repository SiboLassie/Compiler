func foo(i, j, k : int) return int {
    var x : int;
    
    x = 0;
    for(int i=0; i<10; i+1) {
        for (int j=0; j<5; j+1) {
            x = x+i+j;
            if (j==i) {
                i = 0;
                j = 0;
            }
        }
        while(j<4) {
            if(false) {
                if (true) {
                    i = i+1;
                    j = j*1; 
                }
                else {
                    j = 0;
                }
                var y : int;

            }
        }
    }
    while (true) {
        while(true) {
            if(true) {
                x = 1;
            }
        }
    }
    return x;
}

proc Main() {
    var z : real;
}