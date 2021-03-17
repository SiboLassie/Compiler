proc Main() { 
   
    proc aoo(x, y, z: int; f : real) { 

    }
    
    aoo(1,2,3,4.0);

    func foo(q : real; d : int) return bool { 
        
        aoo(1,2,3,4.0); 
        return false;
    };
    
    foo(3,4);
    proc goo(a,b : int) {   
      
    };
    goo(1,2);
    
}