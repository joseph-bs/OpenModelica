// name: ModifierTypeError
// keywords: abs
// status: incorrect
//
// Tests that type errors are caught.
//

package X
  constant Integer x = 1.0;
end X;

model A
   Integer k = X.x;
end A;

// Result:
// Error processing file: ModifierTypeError.mo
// [ModifierTypeError.mo:9:3-9:27:writable] Error: Type mismatch in binding x = 1.0, expected subtype of Integer, got type Real.
// [ModifierTypeError.mo:13:4-13:19:writable] Error: Found a component with same name when looking for type x
// [ModifierTypeError.mo:9:3-9:27:writable] Error: Type mismatch in binding x = 1.0, expected subtype of Integer, got type Real.
// [ModifierTypeError.mo:13:4-13:19:writable] Error: Variable X.x not found in scope A
// 
// # Error encountered! Exiting...
// # Please check the error message and the flags.
// 
// Execution failed!
// endResult
