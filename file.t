proc foo(x, y, z: int, f: real){ 
    if (x>y) { 
         x = x + f;
    } else { 
        y = x + y + z;
        x = f*2;  z = f;
    }
} 
  
func goo() return char{ 
    return ‘a’;
}