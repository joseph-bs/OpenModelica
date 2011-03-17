// This file defines templates for transforming Modelica/MetaModelica code to FMU 
// code. They are used in the code generator phase of the compiler to write
// target code.
//
// There are one root template intended to be called from the code generator:
// translateModel. These template do not return any
// result but instead write the result to files. All other templates return
// text and are used by the root templates (most of them indirectly).
//
// To future maintainers of this file:
//
// - A line like this
//     # var = "" /*BUFD*/
//   declares a text buffer that you can later append text to. It can also be
//   passed to other templates that in turn can append text to it. In the new
//   version of Susan it should be written like this instead:
//     let &var = buffer ""
//
// - A line like this
//     ..., Text var /*BUFP*/, ...
//   declares that a template takes a text buffer as input parameter. In the
//   new version of Susan it should be written like this instead:
//     ..., Text &var, ...
//
// - A line like this:
//     ..., var /*BUFC*/, ...
//   passes a text buffer to a template. In the new version of Susan it should
//   be written like this instead:
//     ..., &var, ...
//
// - Style guidelines:
//
//   - Try (hard) to limit each row to 80 characters
//
//   - Code for a template should be indented with 2 spaces
//
//     - Exception to this rule is if you have only a single case, then that
//       single case can be written using no indentation
//
//       This single case can be seen as a clarification of the input to the
//       template
//
//   - Code after a case should be indented with 2 spaces if not written on the
//     same line

package SimCodeFMU

import interface SimCodeTV;
import SimCodeC.*; //unqualified import, no need the SimCodeC is optional when calling a template; or mandatory when the same named template exists in this package (name hiding) 


template translateModel(SimCode simCode) 
 "Generates C code and Makefile for compiling a FMU of a
  Modelica model."
::=
match simCode
case SIMCODE(__) then
  let guid = getUUIDStr()
  let()= textFile(fmuModelDescriptionFile(simCode,guid), 'modelDescription.xml')
  let()= textFile(fmumodel_identifierFile(simCode,guid), '<%fileNamePrefix%>_FMU.cpp')
  let()= textFile(fmuMakefile(simCode), '<%fileNamePrefix%>_FMU.makefile')
  "" // Return empty result since result written to files directly
end translateModel;


template fmuModelDescriptionFile(SimCode simCode, String guid)
 "Generates code for ModelDescription file for FMU target."
::=
match simCode
case SIMCODE(__) then
  <<
  <?xml version="1.0" encoding="UTF-8"?>
  <%fmiModelDescription(simCode,guid)%>
  
  >>
end fmuModelDescriptionFile;

template fmiModelDescription(SimCode simCode, String guid)
 "Generates code for ModelDescription file for FMU target."
::=
//  <%UnitDefinitions(simCode)%>
//  <%TypeDefinitions(simCode)%>
//  <%VendorAnnotations(simCode)%>
match simCode
case SIMCODE(__) then
  <<
  <fmiModelDescription 
    <%fmiModelDescriptionAttributes(simCode,guid)%>>
    <%DefaultExperiment(simulationSettingsOpt)%>
    <%ModelVariables(modelInfo)%>  
  </fmiModelDescription>  
  >>
end fmiModelDescription;

template fmiModelDescriptionAttributes(SimCode simCode, String guid)
 "Generates code for ModelDescription file for FMU target."
::=
match simCode
case SIMCODE(modelInfo = MODELINFO(varInfo = vi as VARINFO(__))) then
  let fmiVersion = '1.0' 
  let modelName = dotPath(modelInfo.name)
  let modelIdentifier = fileNamePrefix
  let description = ''
  let author = ''
  let version= '' 
  let generationTool= 'OpenModelica Compiler <%getVersionNr()%>'
  let generationDateAndTime = xsdateTime(getCurrentDateTime())
  let variableNamingConvention= 'structured'
  let numberOfContinuousStates = vi.numStateVars //the same as modelInfo.varInfo.numStateVars without the vi binding; but longer
  let numberOfEventIndicators = vi.numZeroCrossings 
//  description="<%description%>" 
//    author="<%author%>" 
//    version="<%version%>" 
  << 
  fmiVersion="<%fmiVersion%>" 
  modelName="<%modelName%>"
  modelIdentifier="<%modelIdentifier%>" 
  guid="{<%guid%>}" 
  generationTool="<%generationTool%>" 
  generationDateAndTime="<%generationDateAndTime%>"
  variableNamingConvention="<%variableNamingConvention%>" 
  numberOfContinuousStates="<%numberOfContinuousStates%>" 
  numberOfEventIndicators="<%numberOfEventIndicators%>" 
  >>
end fmiModelDescriptionAttributes;

template xsdateTime(DateTime dt)
 "YYYY-MM-DDThh:mm:ssZ"
::=
  match dt
  case DATETIME(__) then '<%year%>-<%twodigit(mon)%>-<%twodigit(mday)%>T<%twodigit(hour)%>:<%twodigit(min)%>:<%twodigit(sec)%>Z'
end xsdateTime;

template UnitDefinitions(SimCode simCode)
 "Generates code for UnitDefinitions file for FMU target."
::=
match simCode
case SIMCODE(__) then
  <<
  <UnitDefinitions>
  </UnitDefinitions>  
  >>
end UnitDefinitions;

template TypeDefinitions(SimCode simCode)
 "Generates code for TypeDefinitions file for FMU target."
::=
match simCode
case SIMCODE(__) then
  <<
  <TypeDefinitions>
  </TypeDefinitions>  
  >>
end TypeDefinitions;

template DefaultExperiment(Option<SimulationSettings> simulationSettingsOpt)
 "Generates code for DefaultExperiment file for FMU target."
::=
match simulationSettingsOpt
  case SOME(v) then 
	<<
	<DefaultExperiment <%DefaultExperimentAttribute(v)%>/>
  	>>
end DefaultExperiment;

template DefaultExperimentAttribute(SimulationSettings simulationSettings)
 "Generates code for DefaultExperiment Attribute file for FMU target."
::=
match simulationSettings
  case SIMULATION_SETTINGS(__) then 
	<<
	startTime="<%startTime%>" stopTime="<%stopTime%>" tolerance="<%tolerance%>"
  	>>
end DefaultExperimentAttribute;

template VendorAnnotations(SimCode simCode)
 "Generates code for VendorAnnotations file for FMU target."
::=
match simCode
case SIMCODE(__) then
  <<
  <VendorAnnotations>
  </VendorAnnotations>  
  >>
end VendorAnnotations;

template ModelVariables(ModelInfo modelInfo)
 "Generates code for ModelVariables file for FMU target."
::=
match modelInfo
case MODELINFO(vars=SIMVARS(__)) then
  <<
  <ModelVariables>
  <%System.tmpTickReset(0)%>
  <%vars.stateVars |> var =>
    ScalarVariable(var)
  ;separator="\n"%>  
  <%vars.derivativeVars |> var =>
    ScalarVariable(var)
  ;separator="\n"%>
  <%vars.algVars |> var =>
    ScalarVariable(var)
  ;separator="\n"%>
  <%vars.paramVars |> var =>
    ScalarVariable(var)
  ;separator="\n"%>
  <%vars.aliasVars |> var =>
    ScalarVariable(var)
  ;separator="\n"%>
  <%System.tmpTickReset(0)%>
  <%vars.intAlgVars |> var =>
	ScalarVariable(var)
  ;separator="\n"%>
  <%vars.intParamVars |> var =>
    ScalarVariable(var)
  ;separator="\n"%>
  <%vars.intAliasVars |> var =>
    ScalarVariable(var)
  ;separator="\n"%>
  <%System.tmpTickReset(0)%>
  <%vars.boolAlgVars |> var =>
    ScalarVariable(var)
  ;separator="\n"%>
  <%vars.boolParamVars |> var =>
    ScalarVariable(var)
  ;separator="\n"%>  
  <%vars.boolAliasVars |> var =>
    ScalarVariable(var)
  ;separator="\n"%>  
  <%System.tmpTickReset(0)%>
  <%vars.stringAlgVars |> var =>
    ScalarVariable(var)
  ;separator="\n"%>
  <%vars.stringParamVars |> var =>
    ScalarVariable(var)
  ;separator="\n"%> 
  <%vars.stringAliasVars |> var =>
    ScalarVariable(var)
  ;separator="\n"%> 
  </ModelVariables>  
  >>
end ModelVariables;

template ScalarVariable(SimVar simVar)
 "Generates code for ScalarVariable file for FMU target."
::=
match simVar
case SIMVAR(__) then
  <<
  <ScalarVariable 
    <%ScalarVariableAttribute(simVar)%>>
    <%ScalarVariableType(type_,unit,displayUnit,initialValue,isFixed)%>
  </ScalarVariable>  
  >>
end ScalarVariable;

template ScalarVariableAttribute(SimVar simVar)
 "Generates code for ScalarVariable Attribute file for FMU target."
::=
match simVar
  case SIMVAR(__) then
  let valueReference = '<%System.tmpTick()%>'
  let variability = getVariablity(varKind)
  let description = if comment then 'description="<%comment%>"' 
  let alias = getAliasVar(aliasvar)
  let caus = getCausality(causality)
  <<
  name="<%crefStr(name)%>" 
  valueReference="<%valueReference%>" 
  <%description%>
  variability="<%variability%>" 
  causality="<%caus%>" 
  alias="<%alias%>"
  >>  
end ScalarVariableAttribute;

template getCausality(Causality c)
 "Returns the Causality Attribute of ScalarVariable."
::=
match c
  case NONECAUS(__) then "none"
  case INTERNAL(__) then "internal"
  case OUTPUT(__) then "output"
  case INPUT(__) then "input"
end getCausality;

template getVariablity(VarKind varKind)
 "Returns the variablity Attribute of ScalarVariable."
::=
match varKind
  case DISCRETE(__) then "discrete"
  case PARAM(__) then "parameter"
  case CONST(__) then "constant"
  else "continuous"
end getVariablity;

template getAliasVar(AliasVariable aliasvar)
 "Returns the alias Attribute of ScalarVariable."
::=
match aliasvar
  case NOALIAS(__) then "noAlias"
  case ALIAS(__) then "alias"
  case NEGATEDALIAS(__) then "negatedAlias"
  else "noAlias"
end getAliasVar;

template ScalarVariableType(DAE.ExpType type_, String unit, String displayUnit, Option<DAE.Exp> initialValue, Boolean isFixed)
 "Generates code for ScalarVariable Type file for FMU target."
::=
match type_
  case ET_INT(__) then '<Integer/>' 
  case ET_REAL(__) then '<Real <%ScalarVariableTypeCommonAttribute(initialValue,isFixed)%> <%ScalarVariableTypeRealAttribute(unit,displayUnit)%>/>' 
  case ET_BOOL(__) then '<Boolean/>' 
  case ET_STRING(__) then '<String/>' 
  case ET_ENUMERATION(__) then '<Integer/>' 
  else 'UNKOWN_TYPE'
end ScalarVariableType;

template ScalarVariableTypeCommonAttribute(Option<DAE.Exp> initialValue, Boolean isFixed)
 "Generates code for ScalarVariable Type file for FMU target."
::=
match initialValue
  case SOME(exp) then 'start="<%SimCodeC.initVal(exp)%>" fixed="<%isFixed%>"'
end ScalarVariableTypeCommonAttribute;

template ScalarVariableTypeRealAttribute(String unit, String displayUnit)
 "Generates code for ScalarVariable Type Real file for FMU target."
::=
  let unit_ = if unit then 'unit="<%unit%>"'   
  let displayUnit_ = if displayUnit then 'displayUnit="<%displayUnit%>"'   
  <<
  <%unit_%> <%displayUnit_%>
  >>
end ScalarVariableTypeRealAttribute;


template fmumodel_identifierFile(SimCode simCode, String guid)
 "Generates code for ModelDescription file for FMU target."
::=
match simCode
case SIMCODE(__) then
  <<
  
  // define class name and unique id
  #define MODEL_IDENTIFIER <%fileNamePrefix%>
  #define MODEL_GUID "{<%guid%>}"
  
  // include fmu header files, typedefs and macros
  #include "fmiModelFunctions.h"
  #include "fmu_model_interface.h"
  #include "<%fileNamePrefix%>_functions.h"

  void setStartValues(ModelInstance *comp);
  fmiStatus getEventIndicator(ModelInstance* comp, fmiReal eventIndicators[]);
  void eventUpdate(ModelInstance* comp, fmiEventInfo* eventInfo);
  fmiReal getReal(ModelInstance* comp, const fmiValueReference vr);  
  fmiStatus setReal(ModelInstance* comp, const fmiValueReference vr, const fmiReal value);  
  fmiInteger getInteger(ModelInstance* comp, const fmiValueReference vr);  
  fmiStatus setInteger(ModelInstance* comp, const fmiValueReference vr, const fmiInteger value);  
  fmiBoolean getBoolean(ModelInstance* comp, const fmiValueReference vr);  
  fmiStatus setBoolean(ModelInstance* comp, const fmiValueReference vr, const fmiBoolean value);  
  fmiString getString(ModelInstance* comp, const fmiValueReference vr);  
  fmiStatus setString(ModelInstance* comp, const fmiValueReference vr, const fmiString value);  
  fmiStatus setExternalFunction(ModelInstance* c, const fmiValueReference vr, const void* value);
  
  <%ModelDefineData(modelInfo)%>
  
  // implementation of the Model Exchange functions
  #include "fmu_model_interface.c"
 
  <%setStartValues(modelInfo)%>
  <%getEventIndicatorFunction(simCode)%>
  <%eventUpdateFunction(simCode)%>
  <%getRealFunction(modelInfo)%>
  <%setRealFunction(modelInfo)%>
  <%getIntegerFunction(modelInfo)%>
  <%setIntegerFunction(modelInfo)%>
  <%getBooleanFunction(modelInfo)%>
  <%setBooleanFunction(modelInfo)%>
  <%getStringFunction(modelInfo)%>
  <%setStringFunction(modelInfo)%>
  <%setExternalFunction(modelInfo)%>  
  
  >>
end fmumodel_identifierFile;

template ModelDefineData(ModelInfo modelInfo)
 "Generates global data in simulation file."
::=
match modelInfo
case MODELINFO(varInfo=VARINFO(__), vars=SIMVARS(__)) then
let numberOfReals = intAdd(varInfo.numStateVars,intAdd(varInfo.numAlgVars,intAdd(varInfo.numParams,varInfo.numAlgAliasVars)))
let numberOfIntegers = intAdd(varInfo.numIntAlgVars,intAdd(varInfo.numIntParams,varInfo.numIntAliasVars))
let numberOfStrings = intAdd(varInfo.numStringAlgVars,intAdd(varInfo.numStringParamVars,varInfo.numStringAliasVars))
let numberOfBooleans = intAdd(varInfo.numBoolAlgVars,intAdd(varInfo.numBoolParams,varInfo.numBoolAliasVars))
  <<
  // define model size
  #define NUMBER_OF_STATES <%varInfo.numStateVars%>
  #define NUMBER_OF_EVENT_INDICATORS <%varInfo.numZeroCrossings%>
  #define NUMBER_OF_REALS <%numberOfReals%>
  #define NUMBER_OF_INTEGERS <%numberOfIntegers%>
  #define NUMBER_OF_STRINGS <%numberOfStrings%>
  #define NUMBER_OF_BOOLEANS <%numberOfBooleans%>
  #define NUMBER_OF_EXTERNALFUNCTIONS 0
  
  // define variable data for model
  <%System.tmpTickReset(0)%>
  <%vars.stateVars |> var => DefineVariables(var) ;separator="\n"%>
  <%vars.derivativeVars |> var => DefineVariables(var) ;separator="\n"%>
  <%vars.algVars |> var => DefineVariables(var) ;separator="\n"%>
  <%vars.paramVars |> var => DefineVariables(var) ;separator="\n"%>
  <%vars.aliasVars |> var => DefineVariables(var) ;separator="\n"%>
  <%System.tmpTickReset(0)%>
  <%vars.intAlgVars |> var => DefineVariables(var) ;separator="\n"%>
  <%vars.intParamVars |> var => DefineVariables(var) ;separator="\n"%>
  <%vars.intAliasVars |> var => DefineVariables(var) ;separator="\n"%>
  <%System.tmpTickReset(0)%>
  <%vars.boolAlgVars |> var => DefineVariables(var) ;separator="\n"%>
  <%vars.boolParamVars |> var => DefineVariables(var) ;separator="\n"%>
  <%vars.boolAliasVars |> var => DefineVariables(var) ;separator="\n"%>
  <%System.tmpTickReset(0)%>
  <%vars.stringAlgVars |> var => DefineVariables(var) ;separator="\n"%>
  <%vars.stringParamVars |> var => DefineVariables(var) ;separator="\n"%>
  <%vars.stringAliasVars |> var => DefineVariables(var) ;separator="\n"%>
  
  
  // define initial state vector as vector of value references
  #define STATES { <%vars.stateVars |> SIMVAR(__) => '<%cref(name)%>_'  ;separator=", "%> }
  #define STATESDERIVATIVES { <%vars.derivativeVars |> SIMVAR(__) => '<%cref(name)%>_'  ;separator=", "%> }
  
  >>
end ModelDefineData;

template dervativeNameCStyle(ComponentRef cr)
 "Generates the name of a derivative in c style, replaces ( with _"
::=
  match cr
  case CREF_QUAL(ident = "$DER") then 'der_<%crefStr(componentRef)%>_'
end dervativeNameCStyle;

template DefineVariables(SimVar simVar)
 "Generates code for defining variables in c file for FMU target. "
::=
match simVar
  case SIMVAR(__) then
  let description = if comment then '// "<%comment%>"'
  <<
  #define <%cref(name)%>_ <%System.tmpTick()%> <%description%>
  >>
end DefineVariables;

template setStartValues(ModelInfo modelInfo)
 "Generates code in c file for function setStartValues() which will set start values for all variables." 
::=
match modelInfo
case MODELINFO(vars=SIMVARS(__)) then
  <<
  // Set values for all variables that define a start value
  void setStartValues(ModelInstance *comp) {
  
  <%initVals(vars.stateVars,"r","states")%>
  <%initDerivativeVals(vars.derivativeVars)%>
  <%initVals(vars.algVars,"r","algebraics")%>
  <%initVals(vars.paramVars,"r","parameters")%>
  <%initVals(vars.intParamVars,"i","intVariables.parameters")%>
  <%initVals(vars.intAlgVars,"i","intVariables.algebraics")%>
  <%initVals(vars.boolParamVars,"b","boolVariables.parameters")%>
  <%initVals(vars.boolAlgVars,"b","boolVariables.algebraics")%>
  <%initVals(vars.stringParamVars,"s","stringVariables.parameters")%>
  <%initVals(vars.stringAlgVars,"s","stringVariables.algebraics")%>  
  }
  >>
end setStartValues;

template initializeFunction(list<SimEqSystem> allEquations)
  "Generates initialize function for c file."
::=
  let &varDecls = buffer "" /*BUFD*/
  let eqPart = (allEquations |> eq as SES_SIMPLE_ASSIGN(__) =>
      equation_(eq, contextOther, &varDecls /*BUFC*/)
    ;separator="\n")
  <<
  // Used to set the first time event, if any.
  void initialize(ModelInstance* comp, fmiEventInfo* eventInfo) {

    <%varDecls%>
  
    <%eqPart%>
    <%allEquations |> SES_SIMPLE_ASSIGN(__) =>
      'if (sim_verbose) { printf("Setting variable start value: %s(start=%f)\n", "<%cref(cref)%>", <%cref(cref)%>); }'
    ;separator="\n"%>
  
  }
  >>
end initializeFunction;


template initVals(list<SimVar> varsLst, String prefix, String arrayName) ::=
  varsLst |> SIMVAR(__) =>
  <<
  globalData-><%arrayName%>[<%index%>] = <%match initialValue
    case SOME(v) then
     initVal(v)
    else 
     setDefaultVal(prefix)
    %>;
    >>  
  ;separator="\n"
end initVals;

template setDefaultVal(String prefix) 
::=
  match prefix 
  case "r" then "0.0; //default value for real"
  case "i" then "0; //default value for integer"
  case "b" then "false; //default value for bool"
  case "s" then "\"\"; //default value for string"
end setDefaultVal;

template initDerivativeVals(list<SimVar> varsLst) ::=
  varsLst |> SIMVAR(__) =>
  <<
  globalData->statesDerivatives[<%index%>] = <%match initialValue
    case SOME(v) then
     initVal(v)
    else 
     "0.0; //default"
    %>; 
    >>
  ;separator="\n"
end initDerivativeVals;

template initVal(Exp initialValue) 
::=
  match initialValue 
  case ICONST(__) then integer
  case RCONST(__) then real
  case SCONST(__) then '"<%Util.escapeModelicaStringToCString(string)%>"'
  case BCONST(__) then if bool then "true" else "false"
  case ENUM_LITERAL(__) then '<%index%>/*ENUM:<%dotPath(name)%>*/'
  else "*ERROR* initial value of unknown type"
end initVal;

template eventUpdateFunction(SimCode simCode)
 "Generates event update function for c file."
::=
match simCode
case SIMCODE(__) then
  <<
  // Used to set the next time event, if any.
  void eventUpdate(ModelInstance* comp, fmiEventInfo* eventInfo) {
  }
  
  >>
end eventUpdateFunction;

template getEventIndicatorFunction(SimCode simCode)
 "Generates get event indicator function for c file."
::=
match simCode
case SIMCODE(__) then
  let &varDecls = buffer "" /*BUFD*/
  let zeroCrossingsCode = zeroCrossingsTpl2_fmu(zeroCrossings, &varDecls /*BUFD*/)
  <<
  // Used to get event indicators
  fmiStatus getEventIndicator(ModelInstance* comp, fmiReal eventIndicators[]) {
  int res = function_onlyZeroCrossings(eventIndicators, &globalData->timeValue);
  if (res == 0) return fmiOK;
  return fmiError;
  }
  
  >>
end getEventIndicatorFunction;


template zeroCrossingsTpl2_fmu(list<ZeroCrossing> zeroCrossings, Text &varDecls /*BUFP*/)
 "Generates code for zero crossings."
::=

  (zeroCrossings |> ZERO_CROSSING(__) hasindex i0 =>
    zeroCrossingTpl2_fmu(i0, relation_, &varDecls /*BUFD*/)
  ;separator="\n")
end zeroCrossingsTpl2_fmu;

template zeroCrossingTpl2_fmu(Integer index1, Exp relation, Text &varDecls /*BUFP*/)
 "Generates code for a zero crossing."
::=
  match relation
  case RELATION(__) then
    let &preExp = buffer "" /*BUFD*/
    let e1 = daeExp(exp1, contextOther, &preExp /*BUFC*/, &varDecls /*BUFD*/)
    let op = zeroCrossingOpFunc_fmu(operator)
    let e2 = daeExp(exp2, contextOther, &preExp /*BUFC*/, &varDecls /*BUFD*/)
    <<
    <%preExp%>
    FMIZEROCROSSING(<%index1%>, <%op%>(<%e1%>_, <%e2%>));
    >>
  case CALL(path=IDENT(name="sample"), expLst={start, interval}) then
  << >>
  else
    <<
    // UNKNOWN ZERO CROSSING for <%index1%>
    >>
end zeroCrossingTpl2_fmu;

template zeroCrossingOpFunc_fmu(Operator op)
 "Generates zero crossing function name for operator."
::=
  match op
  case LESS(__)      then "FmiLess"
  case GREATER(__)   then "FmiGreater"
  case LESSEQ(__)    then "FmiLessEq"
  case GREATEREQ(__) then "FmiGreaterEq"
  
end zeroCrossingOpFunc_fmu;

template getRealFunction(ModelInfo modelInfo)
 "Generates getReal function for c file."
::=
match modelInfo
case MODELINFO(vars=SIMVARS(__)) then
  <<
  fmiReal getReal(ModelInstance* comp, const fmiValueReference vr) {
    switch (vr) {
        <%vars.stateVars |> var => SwitchVars(var,"states") ;separator="\n"%>
        <%vars.derivativeVars |> var => SwitchVars(var,"statesDerivatives") ;separator="\n"%>
        <%vars.algVars |> var => SwitchVars(var,"algebraics") ;separator="\n"%>
        <%vars.paramVars |> var => SwitchVars(var,"parameters") ;separator="\n"%>
        <%vars.aliasVars |> var => SwitchAliasVars(var,"realAlias","-") ;separator="\n"%>
        default: 
        	return 0.0;
    }
  }
  
  >>
end getRealFunction;

template setRealFunction(ModelInfo modelInfo)
 "Generates setReal function for c file."
::=
match modelInfo
case MODELINFO(vars=SIMVARS(__)) then
  <<
  fmiStatus setReal(ModelInstance* comp, const fmiValueReference vr, const fmiReal value) {
    switch (vr) {
        <%vars.stateVars |> var => SwitchVarsSet(var,"states") ;separator="\n"%>
        <%vars.derivativeVars |> var => SwitchVarsSet(var,"statesDerivatives") ;separator="\n"%>
        <%vars.algVars |> var => SwitchVarsSet(var,"algebraics") ;separator="\n"%>
        <%vars.paramVars |> var => SwitchVarsSet(var,"parameters") ;separator="\n"%>
        <%vars.aliasVars |> var => SwitchAliasVarsSet(var,"realAlias") ;separator="\n"%>
        default: 
        	return fmiError;
    }
    return fmiOK;
  }
  
  >>
end setRealFunction;

template getIntegerFunction(ModelInfo modelInfo)
 "Generates setInteger function for c file."
::=
match modelInfo
case MODELINFO(vars=SIMVARS(__)) then
  <<
  fmiInteger getInteger(ModelInstance* comp, const fmiValueReference vr) {
    switch (vr) {
        <%vars.intAlgVars |> var => SwitchVars(var,"intVariables.algebraics") ;separator="\n"%>
        <%vars.intParamVars |> var => SwitchVars(var,"intVariables.parameters") ;separator="\n"%>
        <%vars.intAliasVars |> var => SwitchAliasVars(var,"intVariables.alias","-") ;separator="\n"%>
        default: 
        	return 0;
    }
  }
  
  >>
end getIntegerFunction;

template setIntegerFunction(ModelInfo modelInfo)
 "Generates setInteger function for c file."
::=
match modelInfo
case MODELINFO(vars=SIMVARS(__)) then
  <<
  fmiStatus setInteger(ModelInstance* comp, const fmiValueReference vr, const fmiInteger value) {
    switch (vr) {
        <%vars.intAlgVars |> var => SwitchVarsSet(var,"intVariables.algebraics") ;separator="\n"%>
        <%vars.intParamVars |> var => SwitchVarsSet(var,"intVariables.parameters") ;separator="\n"%>
        <%vars.intAliasVars |> var => SwitchAliasVarsSet(var,"intVariables.alias") ;separator="\n"%>
        default: 
        	return fmiError;
    }
    return fmiOK;
  }
  
  >>
end setIntegerFunction;

template getBooleanFunction(ModelInfo modelInfo)
 "Generates setBoolean function for c file."
::=
match modelInfo
case MODELINFO(vars=SIMVARS(__)) then
  <<
  fmiBoolean getBoolean(ModelInstance* comp, const fmiValueReference vr) {
    switch (vr) {
        <%vars.boolAlgVars |> var => SwitchVars(var,"boolVariables.algebraics") ;separator="\n"%>
        <%vars.boolParamVars |> var => SwitchVars(var,"boolVariables.parameters") ;separator="\n"%>
        <%vars.boolAliasVars |> var => SwitchAliasVars(var,"boolVariables.alias","!") ;separator="\n"%>
        default: 
        	return 0;
    }
  }
  
  >>
end getBooleanFunction;

template setBooleanFunction(ModelInfo modelInfo)
 "Generates setBoolean function for c file."
::=
match modelInfo
case MODELINFO(vars=SIMVARS(__)) then
  <<
  fmiStatus setBoolean(ModelInstance* comp, const fmiValueReference vr, const fmiBoolean value) {
    switch (vr) {
        <%vars.boolAlgVars |> var => SwitchVarsSet(var,"boolVariables.algebraics") ;separator="\n"%>
        <%vars.boolParamVars |> var => SwitchVarsSet(var,"boolVariables.parameters") ;separator="\n"%>
        <%vars.boolAliasVars |> var => SwitchAliasVarsSet(var,"boolVariables.alias") ;separator="\n"%>
        default: 
        	return fmiError;
    }
    return fmiOK;
  }
  
  >>
end setBooleanFunction;

template getStringFunction(ModelInfo modelInfo)
 "Generates setString function for c file."
::=
match modelInfo
case MODELINFO(vars=SIMVARS(__)) then
  <<
  fmiString getString(ModelInstance* comp, const fmiValueReference vr) {
    switch (vr) {
        <%vars.stringAlgVars |> var => SwitchVars(var,"stringVariables.algebraics") ;separator="\n"%>
        <%vars.stringParamVars |> var => SwitchVars(var,"stringVariables.parameters") ;separator="\n"%>
        <%vars.stringAliasVars |> var => SwitchAliasVars(var,"stringVariables.alias","") ;separator="\n"%>
        default: 
        	return 0;
    }
  }
  
  >>
end getStringFunction;

template setStringFunction(ModelInfo modelInfo)
 "Generates setString function for c file."
::=
match modelInfo
case MODELINFO(vars=SIMVARS(__)) then
  <<
  fmiStatus setString(ModelInstance* comp, const fmiValueReference vr, const fmiString value) {
    switch (vr) {
        <%vars.stringAlgVars |> var => SwitchVarsSet(var,"stringVariables.algebraics") ;separator="\n"%>
        <%vars.stringParamVars |> var => SwitchVarsSet(var,"stringVariables.parameters") ;separator="\n"%>
        <%vars.stringAliasVars |> var => SwitchAliasVarsSet(var,"stringVariables.alias") ;separator="\n"%>
        default: 
        	return fmiError;
    }
    return fmiOK;
  }
  
  >>
end setStringFunction;

template setExternalFunction(ModelInfo modelInfo)
 "Generates setString function for c file."
::=
match modelInfo
case MODELINFO(vars=SIMVARS(__)) then
  <<
  fmiStatus setExternalFunction(ModelInstance* c, const fmiValueReference vr, const void* value){
    switch (vr) {
        default: 
        	return fmiError;
    }
    return fmiOK;
  }
  
  >>
end setExternalFunction;

template SwitchVars(SimVar simVar, String arrayName)
 "Generates code for defining variables in c file for FMU target. "
::=
match simVar
  case SIMVAR(__) then
  let description = if comment then '// "<%comment%>"'
  <<
  case <%cref(name)%>_ : return globalData-><%arrayName%>[<%index%>]; break;
  >>
end SwitchVars;

template SwitchAliasVars(SimVar simVar, String arrayName, String negator)
 "Generates code for defining variables in c file for FMU target. "
::=
match simVar
  case SIMVAR(__) then
  let description = if comment then '// "<%comment%>"'
  <<
  case <%cref(name)%>_ : return (globalData-><%arrayName%>[<%index%>].negate?<%negator%>*(globalData-><%arrayName%>[<%index%>].alias):*(globalData-><%arrayName%>[<%index%>].alias)); break;
  >>
end SwitchAliasVars;

template SwitchVarsSet(SimVar simVar, String arrayName)
 "Generates code for defining variables in c file for FMU target. "
::=
match simVar
  case SIMVAR(__) then
  let description = if comment then '// "<%comment%>"'
  <<
  case <%cref(name)%>_ : globalData-><%arrayName%>[<%index%>]=value; break;
  >>
end SwitchVarsSet;

template SwitchAliasVarsSet(SimVar simVar, String arrayName)
 "Generates code for defining variables in c file for FMU target. "
::=
match simVar
  case SIMVAR(__) then
  let description = if comment then '// "<%comment%>"'
  <<
  case <%cref(name)%>_ : *(globalData-><%arrayName%>[<%index%>].alias)=value; break;
  >>
end SwitchAliasVarsSet;

template fmuMakefile(SimCode simCode)
 "Generates the contents of the makefile for the simulation case."
::=
match simCode
case SIMCODE(modelInfo=MODELINFO(__), makefileParams=MAKEFILE_PARAMS(__)) then
  let dirExtra = if modelInfo.directory then '-L"<%modelInfo.directory%>"' //else ""
  let libsStr = (makefileParams.libs |> lib => lib ;separator=" ")
  let libsPos1 = if not dirExtra then libsStr //else ""
  let libsPos2 = if dirExtra then libsStr // else ""
  <<
  # Makefile generated by OpenModelica
  
  # Simulations use -O3 by default
  SIM_OR_DYNLOAD_OPT_LEVEL=-O3
  CC=<%makefileParams.ccompiler%>
  CXX=<%makefileParams.cxxcompiler%>
  LINK=<%makefileParams.linker%>
  EXEEXT=<%makefileParams.exeext%>
  DLLEXT=<%makefileParams.dllext%>
  CFLAGS=-I"<%makefileParams.omhome%>/include/omc" <%makefileParams.cflags%>
  LDFLAGS=-L"<%makefileParams.omhome%>/lib/omc" <%makefileParams.ldflags%>
  SENDDATALIBS=<%makefileParams.senddatalibs%>
  PERL=perl
  
  .PHONY: <%fileNamePrefix%>
  <%fileNamePrefix%>: <%fileNamePrefix%>.conv.cpp <%fileNamePrefix%>_functions.cpp <%fileNamePrefix%>_FMU.cpp <%fileNamePrefix%>_functions.h <%fileNamePrefix%>_records.c 
  <%\t%> $(CXX) -I. -o <%fileNamePrefix%>$(DLLEXT) <%fileNamePrefix%>.conv.cpp <%fileNamePrefix%>_functions.cpp <%fileNamePrefix%>_FMU.cpp <%dirExtra%> <%libsPos1%> <%libsPos2%> -shared -lsim -linteractive $(CFLAGS) $(SENDDATALIBS) $(LDFLAGS) -lf2c <%fileNamePrefix%>_records.c -Wl,--out-implib,lib<%fileNamePrefix%>.a
  <%\t%> mv lib<%fileNamePrefix%>.a <%fileNamePrefix%>.lib 
  
  <%\t%> mkdir -p binaries
  <%\t%> mkdir -p binaries/win32
  
  <%\t%> mv <%fileNamePrefix%>$(DLLEXT) binaries/win32/
  <%\t%> mv <%fileNamePrefix%>.lib binaries/win32/
  <%\t%> zip -r <%fileNamePrefix%>.fmu binaries modelDescription.xml
  
  <%fileNamePrefix%>.conv.cpp: <%fileNamePrefix%>.cpp
  <%\t%> $(PERL) <%makefileParams.omhome%>/share/omc/scripts/convert_lines.pl $< $@.tmp
  <%\t%> @mv $@.tmp $@
  >>
end fmuMakefile;

end SimCodeFMU;

// vim: filetype=susan sw=2 sts=2
