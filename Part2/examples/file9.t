proc Main() { 

    func foo(q : real; d : int) return int { 
        
        return 3;
    }

    var check : int;
    var check2 : int;
    var check3 : bool ;

    check = foo(2.0,88);
    
    func goo(q : real) return int { 
        
        return 31;
    };

    func roo() return bool { 
        
        return false;
    };

    check2 = goo(2.0);
    
    check3 = roo();

}