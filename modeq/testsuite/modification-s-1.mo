// Modifications

// This file tests simple modifications of variables)

// Expected equations:
//
//  m.j   == 3.0
//  m.f.q == 2.0
//  n.j   == 1.0
//  n.f.q == 5.0
//  o.j   == 1.0
//  o.f.q == 3.0 eller 4.0 ?

type Real = RealType;

model Motor

  model Foo
    parameter Real q;
  end Foo;
  
  parameter Real j = 1;
  Foo f(q=2);

end motor;

model World
  Motor m(j = 3);
  Motor n(f(q=5));
  Motor o(Foo(q=3), f(q=4));
end World;
