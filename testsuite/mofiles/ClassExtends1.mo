// name:     ClassExtends1
// keywords: class,extends
// status:   correct
// 
// 
class Y
  replaceable model X
    Integer x;
  end X;
end Y;

class ClassExtends1
 extends Y;

 redeclare replaceable model extends X(x=y)
   parameter Integer y;
 end X;
 
 X component;
initial equation
 component.y = 5;
end ClassExtends1;

// Result:
// fclass ClassExtends1
// Integer component.x = component.y;
// parameter Integer component.y;
// initial equation
//   component.y = 5;
// end ClassExtends1;
// endResult
