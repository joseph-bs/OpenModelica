// name: InStreamInvalidArgument
// keywords: inStream invalid argument
// status: incorrect
//
// Checks that an error message is generated if the argument to inStream is not
// a stream connector.
//

model InStreamInvalidArgument
  Real r;
  Real instream;
equation
  instream = inStream(r);
end InStreamInvalidArgument;

// Result:
// Error processing file: InStreamInvalidArgument.mo
// [InStreamInvalidArgument.mo:13:3-13:25:writable] Error: Operand r to operator inStream is not a stream variable.
// [InStreamInvalidArgument.mo:13:3-13:25:writable] Error: Wrong type or wrong number of arguments to inStream(r)'.
//  (in component <NO COMPONENT>)
// 
// # Error encountered! Exiting...
// # Please check the error message and the flags.
// 
// Execution failed!
// endResult
