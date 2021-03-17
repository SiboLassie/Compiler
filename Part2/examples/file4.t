proc Main() { 


    proc aoo(x, y, z: int; f: real) { 

        var a, b : string[1000];

    }
    
    aoo(1,2,3,4.0);

    proc foo() { 
        
        aoo(1,2,3,4.0); 
    };
    
    foo();
    proc goo() { 
        proc joo() { 
        
            aoo(1,2,3,4.0); 
        }  
      
    };
    aoo(1,2,3,4.0);
    
}