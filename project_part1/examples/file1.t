func iche (f : int; g : string) return int
{
    var c : char;
    var a, b : string[1000];
    var x : int;
    proc nii ()
    {
        var y : real;
        var intptr : int*;
        var charptr : char*;
        var realptr : real*;
        x = 1;
        c = 'G';
        y = 2.35;
        charptr = &c;
        func san (g : int) return int
        {
            x = 2 + g;
            intptr = &x;
            a = "hey";
            return x;
        };
        y = 4.20;
        b = "bye";
        ^realptr = f;
    };
    return 0;
}
