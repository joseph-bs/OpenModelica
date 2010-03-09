package SimCodeC

protected constant Tpl.Text emptyTxt = Tpl.MEM_TEXT({}, {});

public import Tpl;

public import SimCode;
public import DAELow;
public import System;
public import Absyn;
public import DAE;
public import ClassInf;
public import Util;

public function translateModel
  input Tpl.Text in_txt;
  input SimCode.SimCode in_i_simCode;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_simCode)
    local
      Tpl.Text txt;

    case ( txt,
           (i_simCode as SimCode.SIMCODE(modelInfo = SimCode.MODELINFO(name = i_modelInfo_name), functions = i_functions)) )
      local
        list<SimCode.Function> i_functions;
        String i_modelInfo_name;
        SimCode.SimCode i_simCode;
        Tpl.Text txt_5;
        Tpl.Text i_makefileContent;
        Tpl.Text txt_3;
        Tpl.Text i_functionsFileContent;
        Tpl.Text txt_1;
        Tpl.Text i_simulationFileContent;
      equation
        i_simulationFileContent = simulationFile(emptyTxt, i_simCode);
        txt_1 = Tpl.writeStr(emptyTxt, i_modelInfo_name);
        txt_1 = Tpl.writeTok(txt_1, Tpl.ST_STRING(".cpp"));
        Tpl.textFile(i_simulationFileContent, Tpl.textString(txt_1));
        i_functionsFileContent = functionsFile(emptyTxt, i_functions);
        txt_3 = Tpl.writeStr(emptyTxt, i_modelInfo_name);
        txt_3 = Tpl.writeTok(txt_3, Tpl.ST_STRING("_functions.cpp"));
        Tpl.textFile(i_functionsFileContent, Tpl.textString(txt_3));
        i_makefileContent = makefile(emptyTxt, i_simCode);
        txt_5 = Tpl.writeStr(emptyTxt, i_modelInfo_name);
        txt_5 = Tpl.writeTok(txt_5, Tpl.ST_STRING(".makefile"));
        Tpl.textFile(i_makefileContent, Tpl.textString(txt_5));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end translateModel;

public function translateFunctions
  input Tpl.Text in_txt;
  input SimCode.FunctionCode in_i_functionCode;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_functionCode)
    local
      Tpl.Text txt;

    case ( txt,
           (i_functionCode as SimCode.FUNCTIONCODE(functions = i_functions, name = i_name)) )
      local
        String i_name;
        list<SimCode.Function> i_functions;
        SimCode.FunctionCode i_functionCode;
        Tpl.Text txt_3;
        Tpl.Text i_makefileContent;
        Tpl.Text txt_1;
        Tpl.Text i_functionsFileContent;
      equation
        i_functionsFileContent = functionsFile2(emptyTxt, i_functions);
        txt_1 = Tpl.writeStr(emptyTxt, i_name);
        txt_1 = Tpl.writeTok(txt_1, Tpl.ST_STRING(".c"));
        Tpl.textFile(i_functionsFileContent, Tpl.textString(txt_1));
        i_makefileContent = makefileFunction(emptyTxt, i_functionCode);
        txt_3 = Tpl.writeStr(emptyTxt, i_name);
        txt_3 = Tpl.writeTok(txt_3, Tpl.ST_STRING(".makefile"));
        Tpl.textFile(i_makefileContent, Tpl.textString(txt_3));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end translateFunctions;

protected function lm_11
  input Tpl.Text in_txt;
  input list<String> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<String> rest;
        String i_it;
      equation
        txt = Tpl.writeStr(txt, i_it);
        txt = Tpl.nextIter(txt);
        txt = lm_11(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<String> rest;
      equation
        txt = lm_11(txt, rest);
      then txt;
  end matchcontinue;
end lm_11;

public function simulationFile
  input Tpl.Text in_txt;
  input SimCode.SimCode in_i_simCode;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_simCode)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.SIMCODE(modelInfo = (i_modelInfo as SimCode.MODELINFO(name = i_modelInfo_name)), extObjInfo = (i_extObjInfo as SimCode.EXTOBJINFO(includes = i_extObjInfo_includes)), allEquations = i_allEquations, nonStateContEquations = i_nonStateContEquations, removedEquations = i_removedEquations, algorithmAndEquationAsserts = i_algorithmAndEquationAsserts, nonStateDiscEquations = i_nonStateDiscEquations, zeroCrossings = i_zeroCrossings, zeroCrossingsNeedSave = i_zeroCrossingsNeedSave, helpVarInfo = i_helpVarInfo, allEquationsPlusWhen = i_allEquationsPlusWhen, discreteModelVars = i_discreteModelVars, delayedExps = i_delayedExps, whenClauses = i_whenClauses, stateContEquations = i_stateContEquations, initialEquations = i_initialEquations, residualEquations = i_residualEquations, parameterEquations = i_parameterEquations) )
      local
        list<SimCode.SimEqSystem> i_parameterEquations;
        list<SimCode.SimEqSystem> i_residualEquations;
        list<SimCode.SimEqSystem> i_initialEquations;
        list<SimCode.SimEqSystem> i_stateContEquations;
        list<SimCode.SimWhenClause> i_whenClauses;
        list<tuple<DAE.Exp, DAE.Exp>> i_delayedExps;
        list<DAE.ComponentRef> i_discreteModelVars;
        list<SimCode.SimEqSystem> i_allEquationsPlusWhen;
        list<SimCode.HelpVarInfo> i_helpVarInfo;
        list<list<SimCode.SimVar>> i_zeroCrossingsNeedSave;
        list<DAELow.ZeroCrossing> i_zeroCrossings;
        list<SimCode.SimEqSystem> i_nonStateDiscEquations;
        list<DAE.Statement> i_algorithmAndEquationAsserts;
        list<SimCode.SimEqSystem> i_removedEquations;
        list<SimCode.SimEqSystem> i_nonStateContEquations;
        list<SimCode.SimEqSystem> i_allEquations;
        list<String> i_extObjInfo_includes;
        SimCode.ExtObjInfo i_extObjInfo;
        String i_modelInfo_name;
        SimCode.ModelInfo i_modelInfo;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("// Simulation code for "));
        txt = Tpl.writeStr(txt, i_modelInfo_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    " generated by the OpenModelica Compiler.\n",
                                    "\n",
                                    "#include \"modelica.h\"\n",
                                    "#include \"assert.h\"\n",
                                    "#include \"string.h\"\n",
                                    "#include \"simulation_runtime.h\"\n",
                                    "\n",
                                    "#if defined(_MSC_VER) && !defined(_SIMULATION_RUNTIME_H)\n",
                                    "  #define DLLExport   __declspec( dllexport )\n",
                                    "#else\n",
                                    "  #define DLLExport /* nothing */\n",
                                    "#endif\n",
                                    "\n",
                                    "#include \""
                                }, false));
        txt = Tpl.writeStr(txt, i_modelInfo_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "_functions.cpp\"\n",
                                    "\n",
                                    "extern \"C\" {\n"
                                }, true));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_11(txt, i_extObjInfo_includes);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "}\n",
                                    "\n"
                                }, true));
        txt = globalData(txt, i_modelInfo);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionGetName(txt, i_modelInfo);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionDivisionError(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionSetLocalData(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionInitializeDataStruc(txt, i_extObjInfo);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionDeInitializeDataStruc(txt, i_extObjInfo);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionExtraResudials(txt, i_allEquations);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionDaeOutput(txt, i_nonStateContEquations, i_removedEquations, i_algorithmAndEquationAsserts);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionDaeOutput2(txt, i_nonStateDiscEquations, i_removedEquations);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionInput(txt, i_modelInfo);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionOutput(txt, i_modelInfo);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionDaeRes(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionZeroCrossing(txt, i_zeroCrossings);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionHandleZeroCrossing(txt, i_zeroCrossingsNeedSave);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionUpdateDependents(txt, i_allEquations, i_helpVarInfo);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionUpdateDepend(txt, i_allEquationsPlusWhen);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionOnlyZeroCrossing(txt, i_zeroCrossings);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionCheckForDiscreteChanges(txt, i_discreteModelVars);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionStoreDelayed(txt, i_delayedExps);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionWhen(txt, i_whenClauses);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionOde(txt, i_stateContEquations);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionInitial(txt, i_initialEquations);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionInitialResidual(txt, i_residualEquations);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionBoundParameters(txt, i_parameterEquations);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = functionCheckForDiscreteVarChanges(txt, i_helpVarInfo, i_discreteModelVars);
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end simulationFile;

protected function lm_13
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<SimCode.SimVar> rest;
        SimCode.SimVar i_it;
      equation
        txt = globalDataVarDefine(txt, i_it, "states");
        txt = Tpl.nextIter(txt);
        txt = lm_13(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_13(txt, rest);
      then txt;
  end matchcontinue;
end lm_13;

protected function lm_14
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<SimCode.SimVar> rest;
        SimCode.SimVar i_it;
      equation
        txt = globalDataVarDefine(txt, i_it, "statesDerivatives");
        txt = Tpl.nextIter(txt);
        txt = lm_14(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_14(txt, rest);
      then txt;
  end matchcontinue;
end lm_14;

protected function lm_15
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<SimCode.SimVar> rest;
        SimCode.SimVar i_it;
      equation
        txt = globalDataVarDefine(txt, i_it, "algebraics");
        txt = Tpl.nextIter(txt);
        txt = lm_15(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_15(txt, rest);
      then txt;
  end matchcontinue;
end lm_15;

protected function lm_16
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<SimCode.SimVar> rest;
        SimCode.SimVar i_it;
      equation
        txt = globalDataVarDefine(txt, i_it, "parameters");
        txt = Tpl.nextIter(txt);
        txt = lm_16(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_16(txt, rest);
      then txt;
  end matchcontinue;
end lm_16;

protected function lm_17
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<SimCode.SimVar> rest;
        SimCode.SimVar i_it;
      equation
        txt = globalDataVarDefine(txt, i_it, "extObjs");
        txt = Tpl.nextIter(txt);
        txt = lm_17(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_17(txt, rest);
      then txt;
  end matchcontinue;
end lm_17;

protected function lm_18
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<SimCode.SimVar> rest;
        SimCode.SimVar i_it;
      equation
        txt = globalDataVarDefine(txt, i_it, "stringVariables.algebraics");
        txt = Tpl.nextIter(txt);
        txt = lm_18(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_18(txt, rest);
      then txt;
  end matchcontinue;
end lm_18;

protected function lm_19
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(isFixed = i_isFixed, origName = i_origName) :: rest )
      local
        list<SimCode.SimVar> rest;
        DAE.ComponentRef i_origName;
        Boolean i_isFixed;
      equation
        txt = globalDataBoolInt(txt, i_isFixed);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" /* "));
        txt = cref(txt, i_origName);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" */"));
        txt = Tpl.nextIter(txt);
        txt = lm_19(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_19(txt, rest);
      then txt;
  end matchcontinue;
end lm_19;

protected function lm_20
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(isFixed = i_isFixed, origName = i_origName) :: rest )
      local
        list<SimCode.SimVar> rest;
        DAE.ComponentRef i_origName;
        Boolean i_isFixed;
      equation
        txt = globalDataBoolInt(txt, i_isFixed);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" /* "));
        txt = cref(txt, i_origName);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" */"));
        txt = Tpl.nextIter(txt);
        txt = lm_20(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_20(txt, rest);
      then txt;
  end matchcontinue;
end lm_20;

protected function lm_21
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(isFixed = i_isFixed, origName = i_origName) :: rest )
      local
        list<SimCode.SimVar> rest;
        DAE.ComponentRef i_origName;
        Boolean i_isFixed;
      equation
        txt = globalDataBoolInt(txt, i_isFixed);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" /* "));
        txt = cref(txt, i_origName);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" */"));
        txt = Tpl.nextIter(txt);
        txt = lm_21(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_21(txt, rest);
      then txt;
  end matchcontinue;
end lm_21;

protected function lm_22
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(isFixed = i_isFixed, origName = i_origName) :: rest )
      local
        list<SimCode.SimVar> rest;
        DAE.ComponentRef i_origName;
        Boolean i_isFixed;
      equation
        txt = globalDataBoolInt(txt, i_isFixed);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" /* "));
        txt = cref(txt, i_origName);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" */"));
        txt = Tpl.nextIter(txt);
        txt = lm_22(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_22(txt, rest);
      then txt;
  end matchcontinue;
end lm_22;

protected function smf_23
  input Tpl.Text in_txt;
  input Tpl.Text in_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_it)
    local
      Tpl.Text txt;

    case ( txt,
           i_it )
      local
        Tpl.Text i_it;
      equation
        txt = Tpl.writeText(txt, i_it);
        txt = Tpl.nextIter(txt);
      then txt;
  end matchcontinue;
end smf_23;

protected function smf_24
  input Tpl.Text in_txt;
  input Tpl.Text in_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_it)
    local
      Tpl.Text txt;

    case ( txt,
           i_it )
      local
        Tpl.Text i_it;
      equation
        txt = Tpl.writeText(txt, i_it);
        txt = Tpl.nextIter(txt);
      then txt;
  end matchcontinue;
end smf_24;

protected function smf_25
  input Tpl.Text in_txt;
  input Tpl.Text in_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_it)
    local
      Tpl.Text txt;

    case ( txt,
           i_it )
      local
        Tpl.Text i_it;
      equation
        txt = Tpl.writeText(txt, i_it);
        txt = Tpl.nextIter(txt);
      then txt;
  end matchcontinue;
end smf_25;

protected function smf_26
  input Tpl.Text in_txt;
  input Tpl.Text in_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_it)
    local
      Tpl.Text txt;

    case ( txt,
           i_it )
      local
        Tpl.Text i_it;
      equation
        txt = Tpl.writeText(txt, i_it);
        txt = Tpl.nextIter(txt);
      then txt;
  end matchcontinue;
end smf_26;

protected function lm_27
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(type_ = i_type__, isDiscrete = i_isDiscrete, origName = i_origName) :: rest )
      local
        list<SimCode.SimVar> rest;
        DAE.ComponentRef i_origName;
        Boolean i_isDiscrete;
        DAE.ExpType i_type__;
      equation
        txt = globalDataAttrInt(txt, i_type__);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("+"));
        txt = globalDataDiscAttrInt(txt, i_isDiscrete);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" /* "));
        txt = cref(txt, i_origName);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" */"));
        txt = Tpl.nextIter(txt);
        txt = lm_27(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_27(txt, rest);
      then txt;
  end matchcontinue;
end lm_27;

protected function lm_28
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(type_ = i_type__, isDiscrete = i_isDiscrete, origName = i_origName) :: rest )
      local
        list<SimCode.SimVar> rest;
        DAE.ComponentRef i_origName;
        Boolean i_isDiscrete;
        DAE.ExpType i_type__;
      equation
        txt = globalDataAttrInt(txt, i_type__);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("+"));
        txt = globalDataDiscAttrInt(txt, i_isDiscrete);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" /* "));
        txt = cref(txt, i_origName);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" */"));
        txt = Tpl.nextIter(txt);
        txt = lm_28(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_28(txt, rest);
      then txt;
  end matchcontinue;
end lm_28;

protected function lm_29
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(type_ = i_type__, isDiscrete = i_isDiscrete, origName = i_origName) :: rest )
      local
        list<SimCode.SimVar> rest;
        DAE.ComponentRef i_origName;
        Boolean i_isDiscrete;
        DAE.ExpType i_type__;
      equation
        txt = globalDataAttrInt(txt, i_type__);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("+"));
        txt = globalDataDiscAttrInt(txt, i_isDiscrete);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" /* "));
        txt = cref(txt, i_origName);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" */"));
        txt = Tpl.nextIter(txt);
        txt = lm_29(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_29(txt, rest);
      then txt;
  end matchcontinue;
end lm_29;

protected function smf_30
  input Tpl.Text in_txt;
  input Tpl.Text in_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_it)
    local
      Tpl.Text txt;

    case ( txt,
           i_it )
      local
        Tpl.Text i_it;
      equation
        txt = Tpl.writeText(txt, i_it);
        txt = Tpl.nextIter(txt);
      then txt;
  end matchcontinue;
end smf_30;

protected function smf_31
  input Tpl.Text in_txt;
  input Tpl.Text in_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_it)
    local
      Tpl.Text txt;

    case ( txt,
           i_it )
      local
        Tpl.Text i_it;
      equation
        txt = Tpl.writeText(txt, i_it);
        txt = Tpl.nextIter(txt);
      then txt;
  end matchcontinue;
end smf_31;

protected function smf_32
  input Tpl.Text in_txt;
  input Tpl.Text in_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_it)
    local
      Tpl.Text txt;

    case ( txt,
           i_it )
      local
        Tpl.Text i_it;
      equation
        txt = Tpl.writeText(txt, i_it);
        txt = Tpl.nextIter(txt);
      then txt;
  end matchcontinue;
end smf_32;

public function globalData
  input Tpl.Text in_txt;
  input SimCode.ModelInfo in_i_modelInfo;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_modelInfo)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.MODELINFO(varInfo = SimCode.VARINFO(numHelpVars = i_varInfo_numHelpVars, numZeroCrossings = i_varInfo_numZeroCrossings, numStateVars = i_varInfo_numStateVars, numAlgVars = i_varInfo_numAlgVars, numParams = i_varInfo_numParams, numOutVars = i_varInfo_numOutVars, numInVars = i_varInfo_numInVars, numResiduals = i_varInfo_numResiduals, numExternalObjects = i_varInfo_numExternalObjects, numStringAlgVars = i_varInfo_numStringAlgVars, numStringParamVars = i_varInfo_numStringParamVars), vars = SimCode.SIMVARS(stateVars = i_vars_stateVars, derivativeVars = i_vars_derivativeVars, algVars = i_vars_algVars, inputVars = i_vars_inputVars, outputVars = i_vars_outputVars, paramVars = i_vars_paramVars, stringAlgVars = i_vars_stringAlgVars, stringParamVars = i_vars_stringParamVars, extObjVars = i_vars_extObjVars), name = i_name, directory = i_directory) )
      local
        String i_directory;
        String i_name;
        list<SimCode.SimVar> i_vars_extObjVars;
        list<SimCode.SimVar> i_vars_stringParamVars;
        list<SimCode.SimVar> i_vars_stringAlgVars;
        list<SimCode.SimVar> i_vars_paramVars;
        list<SimCode.SimVar> i_vars_outputVars;
        list<SimCode.SimVar> i_vars_inputVars;
        list<SimCode.SimVar> i_vars_algVars;
        list<SimCode.SimVar> i_vars_derivativeVars;
        list<SimCode.SimVar> i_vars_stateVars;
        Integer i_varInfo_numStringParamVars;
        Integer i_varInfo_numStringAlgVars;
        Integer i_varInfo_numExternalObjects;
        Integer i_varInfo_numResiduals;
        Integer i_varInfo_numInVars;
        Integer i_varInfo_numOutVars;
        Integer i_varInfo_numParams;
        Integer i_varInfo_numAlgVars;
        Integer i_varInfo_numStateVars;
        Integer i_varInfo_numZeroCrossings;
        Integer i_varInfo_numHelpVars;
        Tpl.Text txt_6;
        Tpl.Text txt_5;
        Tpl.Text txt_4;
        Tpl.Text txt_3;
        Tpl.Text txt_2;
        Tpl.Text txt_1;
        Tpl.Text txt_0;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("#define NHELP "));
        txt = Tpl.writeStr(txt, intString(i_varInfo_numHelpVars));
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("#define NG "));
        txt = Tpl.writeStr(txt, intString(i_varInfo_numZeroCrossings));
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("#define NX "));
        txt = Tpl.writeStr(txt, intString(i_varInfo_numStateVars));
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("#define NY "));
        txt = Tpl.writeStr(txt, intString(i_varInfo_numAlgVars));
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("#define NP "));
        txt = Tpl.writeStr(txt, intString(i_varInfo_numParams));
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("#define NO "));
        txt = Tpl.writeStr(txt, intString(i_varInfo_numOutVars));
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("#define NI "));
        txt = Tpl.writeStr(txt, intString(i_varInfo_numInVars));
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("#define NR "));
        txt = Tpl.writeStr(txt, intString(i_varInfo_numResiduals));
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("#define NEXT "));
        txt = Tpl.writeStr(txt, intString(i_varInfo_numExternalObjects));
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "#define MAXORD 5\n",
                                    "#define NYSTR "
                                }, false));
        txt = Tpl.writeStr(txt, intString(i_varInfo_numStringAlgVars));
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("#define NPSTR "));
        txt = Tpl.writeStr(txt, intString(i_varInfo_numStringParamVars));
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "\n",
                                    "static DATA* localData = 0;\n",
                                    "#define time localData->timeValue\n",
                                    "extern \"C\" { /* adrpo: this is needed for Visual C++ compilation to work! */\n"
                                }, true));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("char *model_name=\""));
        txt = Tpl.writeStr(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "\";\n",
                                    "char *model_dir=\""
                                }, false));
        txt = Tpl.writeStr(txt, i_directory);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("\";\n"));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "}\n",
                                    "\n"
                                }, true));
        txt = globalDataVarNamesArray(txt, "state_names", i_vars_stateVars);
        txt = Tpl.softNewLine(txt);
        txt = globalDataVarNamesArray(txt, "derivative_names", i_vars_derivativeVars);
        txt = Tpl.softNewLine(txt);
        txt = globalDataVarNamesArray(txt, "algvars_names", i_vars_algVars);
        txt = Tpl.softNewLine(txt);
        txt = globalDataVarNamesArray(txt, "input_names", i_vars_inputVars);
        txt = Tpl.softNewLine(txt);
        txt = globalDataVarNamesArray(txt, "output_names", i_vars_outputVars);
        txt = Tpl.softNewLine(txt);
        txt = globalDataVarNamesArray(txt, "param_names", i_vars_paramVars);
        txt = Tpl.softNewLine(txt);
        txt = globalDataVarNamesArray(txt, "string_alg_names", i_vars_stringAlgVars);
        txt = Tpl.softNewLine(txt);
        txt = globalDataVarNamesArray(txt, "string_param_names", i_vars_stringParamVars);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = globalDataVarCommentsArray(txt, "state_comments", i_vars_stateVars);
        txt = Tpl.softNewLine(txt);
        txt = globalDataVarCommentsArray(txt, "derivative_comments", i_vars_derivativeVars);
        txt = Tpl.softNewLine(txt);
        txt = globalDataVarCommentsArray(txt, "algvars_comments", i_vars_algVars);
        txt = Tpl.softNewLine(txt);
        txt = globalDataVarCommentsArray(txt, "input_comments", i_vars_inputVars);
        txt = Tpl.softNewLine(txt);
        txt = globalDataVarCommentsArray(txt, "output_comments", i_vars_outputVars);
        txt = Tpl.softNewLine(txt);
        txt = globalDataVarCommentsArray(txt, "param_comments", i_vars_paramVars);
        txt = Tpl.softNewLine(txt);
        txt = globalDataVarCommentsArray(txt, "string_alg_comments", i_vars_stringAlgVars);
        txt = Tpl.softNewLine(txt);
        txt = globalDataVarCommentsArray(txt, "string_param_comments", i_vars_stringParamVars);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_13(txt, i_vars_stateVars);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_14(txt, i_vars_derivativeVars);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_15(txt, i_vars_algVars);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_16(txt, i_vars_paramVars);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_17(txt, i_vars_extObjVars);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_18(txt, i_vars_stringAlgVars);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "\n",
                                    "static char init_fixed[NX+NX+NY+NP] = {\n"
                                }, true));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt_0 = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_LINE(",\n")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt_0 = lm_19(txt_0, i_vars_stateVars);
        txt_0 = Tpl.popIter(txt_0);
        txt_1 = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_LINE(",\n")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt_1 = lm_20(txt_1, i_vars_derivativeVars);
        txt_1 = Tpl.popIter(txt_1);
        txt_2 = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_LINE(",\n")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt_2 = lm_21(txt_2, i_vars_algVars);
        txt_2 = Tpl.popIter(txt_2);
        txt_3 = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_LINE(",\n")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt_3 = lm_22(txt_3, i_vars_paramVars);
        txt_3 = Tpl.popIter(txt_3);
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_LINE(",\n")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = smf_23(txt, txt_0);
        txt = smf_24(txt, txt_1);
        txt = smf_25(txt, txt_2);
        txt = smf_26(txt, txt_3);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "};\n",
                                    "\n",
                                    "char var_attr[NX+NY+NP] = {\n"
                                }, true));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt_4 = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_LINE(",\n")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt_4 = lm_27(txt_4, i_vars_stateVars);
        txt_4 = Tpl.popIter(txt_4);
        txt_5 = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_LINE(",\n")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt_5 = lm_28(txt_5, i_vars_algVars);
        txt_5 = Tpl.popIter(txt_5);
        txt_6 = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_LINE(",\n")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt_6 = lm_29(txt_6, i_vars_paramVars);
        txt_6 = Tpl.popIter(txt_6);
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_LINE(",\n")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = smf_30(txt, txt_4);
        txt = smf_31(txt, txt_5);
        txt = smf_32(txt, txt_6);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("};"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end globalData;

protected function lm_34
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(origName = i_origName) :: rest )
      local
        list<SimCode.SimVar> rest;
        DAE.ComponentRef i_origName;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("\""));
        txt = crefSubscript(txt, i_origName);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("\""));
        txt = Tpl.nextIter(txt);
        txt = lm_34(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_34(txt, rest);
      then txt;
  end matchcontinue;
end lm_34;

protected function fun_35
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_i_items;
  input String in_i_name;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_items, in_i_name)
    local
      Tpl.Text txt;
      String i_name;

    case ( txt,
           {},
           i_name )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("char* "));
        txt = Tpl.writeStr(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("[1] = {\"\"};"));
      then txt;

    case ( txt,
           i_items,
           i_name )
      local
        list<SimCode.SimVar> i_items;
        Integer ret_0;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("char* "));
        txt = Tpl.writeStr(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("["));
        ret_0 = listLength(i_items);
        txt = Tpl.writeStr(txt, intString(ret_0));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("] = {"));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_34(txt, i_items);
        txt = Tpl.popIter(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("};"));
      then txt;
  end matchcontinue;
end fun_35;

public function globalDataVarNamesArray
  input Tpl.Text txt;
  input String i_name;
  input list<SimCode.SimVar> i_items;

  output Tpl.Text out_txt;
algorithm
  out_txt := fun_35(txt, i_items, i_name);
end globalDataVarNamesArray;

protected function lm_37
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(comment = i_comment) :: rest )
      local
        list<SimCode.SimVar> rest;
        String i_comment;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("\""));
        txt = Tpl.writeStr(txt, i_comment);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("\""));
        txt = Tpl.nextIter(txt);
        txt = lm_37(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_37(txt, rest);
      then txt;
  end matchcontinue;
end lm_37;

protected function fun_38
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_i_items;
  input String in_i_name;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_items, in_i_name)
    local
      Tpl.Text txt;
      String i_name;

    case ( txt,
           {},
           i_name )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("char* "));
        txt = Tpl.writeStr(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("[1] = {\"\"};"));
      then txt;

    case ( txt,
           i_items,
           i_name )
      local
        list<SimCode.SimVar> i_items;
        Integer ret_0;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("char* "));
        txt = Tpl.writeStr(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("["));
        ret_0 = listLength(i_items);
        txt = Tpl.writeStr(txt, intString(ret_0));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("] = {"));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_37(txt, i_items);
        txt = Tpl.popIter(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("};"));
      then txt;
  end matchcontinue;
end fun_38;

public function globalDataVarCommentsArray
  input Tpl.Text txt;
  input String i_name;
  input list<SimCode.SimVar> i_items;

  output Tpl.Text out_txt;
algorithm
  out_txt := fun_38(txt, i_items, i_name);
end globalDataVarCommentsArray;

public function globalDataVarDefine
  input Tpl.Text in_txt;
  input SimCode.SimVar in_i_it;
  input String in_i_arrayName;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it, in_i_arrayName)
    local
      Tpl.Text txt;
      String i_arrayName;

    case ( txt,
           SimCode.SIMVAR(arrayCref = SOME(i_c), index = i_index, name = i_name),
           i_arrayName )
      local
        DAE.ComponentRef i_name;
        Integer i_index;
        DAE.ComponentRef i_c;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("#define "));
        txt = cref(txt, i_c);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" localData->"));
        txt = Tpl.writeStr(txt, i_arrayName);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("["));
        txt = Tpl.writeStr(txt, intString(i_index));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "]\n",
                                    "#define "
                                }, false));
        txt = cref(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" localData->"));
        txt = Tpl.writeStr(txt, i_arrayName);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("["));
        txt = Tpl.writeStr(txt, intString(i_index));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("]"));
      then txt;

    case ( txt,
           SimCode.SIMVAR(name = i_name, index = i_index),
           i_arrayName )
      local
        Integer i_index;
        DAE.ComponentRef i_name;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("#define "));
        txt = cref(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" localData->"));
        txt = Tpl.writeStr(txt, i_arrayName);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("["));
        txt = Tpl.writeStr(txt, intString(i_index));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("]"));
      then txt;

    case ( txt,
           _,
           _ )
      then txt;
  end matchcontinue;
end globalDataVarDefine;

public function globalDataBoolInt
  input Tpl.Text in_txt;
  input Boolean in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           true )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("1"));
      then txt;

    case ( txt,
           false )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("0"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end globalDataBoolInt;

public function globalDataAttrInt
  input Tpl.Text in_txt;
  input DAE.ExpType in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.ET_REAL() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("1"));
      then txt;

    case ( txt,
           DAE.ET_STRING() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("2"));
      then txt;

    case ( txt,
           DAE.ET_INT() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("4"));
      then txt;

    case ( txt,
           DAE.ET_BOOL() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("8"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end globalDataAttrInt;

public function globalDataDiscAttrInt
  input Tpl.Text in_txt;
  input Boolean in_i_isDiscrete;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_isDiscrete)
    local
      Tpl.Text txt;

    case ( txt,
           true )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("16"));
      then txt;

    case ( txt,
           false )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("0"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end globalDataDiscAttrInt;

protected function lm_44
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(name = i_name, index = i_index) :: rest )
      local
        list<SimCode.SimVar> rest;
        Integer i_index;
        DAE.ComponentRef i_name;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("if (&"));
        txt = cref(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" == ptr) return state_names["));
        txt = Tpl.writeStr(txt, intString(i_index));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("];"));
        txt = Tpl.nextIter(txt);
        txt = lm_44(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_44(txt, rest);
      then txt;
  end matchcontinue;
end lm_44;

protected function lm_45
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(name = i_name, index = i_index) :: rest )
      local
        list<SimCode.SimVar> rest;
        Integer i_index;
        DAE.ComponentRef i_name;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("if (&"));
        txt = cref(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" == ptr) return derivative_names["));
        txt = Tpl.writeStr(txt, intString(i_index));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("];"));
        txt = Tpl.nextIter(txt);
        txt = lm_45(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_45(txt, rest);
      then txt;
  end matchcontinue;
end lm_45;

protected function lm_46
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(name = i_name, index = i_index) :: rest )
      local
        list<SimCode.SimVar> rest;
        Integer i_index;
        DAE.ComponentRef i_name;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("if (&"));
        txt = cref(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" == ptr) return algvars_names["));
        txt = Tpl.writeStr(txt, intString(i_index));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("];"));
        txt = Tpl.nextIter(txt);
        txt = lm_46(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_46(txt, rest);
      then txt;
  end matchcontinue;
end lm_46;

protected function lm_47
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(name = i_name, index = i_index) :: rest )
      local
        list<SimCode.SimVar> rest;
        Integer i_index;
        DAE.ComponentRef i_name;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("if (&"));
        txt = cref(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" == ptr) return param_names["));
        txt = Tpl.writeStr(txt, intString(i_index));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("];"));
        txt = Tpl.nextIter(txt);
        txt = lm_47(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_47(txt, rest);
      then txt;
  end matchcontinue;
end lm_47;

public function functionGetName
  input Tpl.Text in_txt;
  input SimCode.ModelInfo in_i_modelInfo;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_modelInfo)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.MODELINFO(vars = SimCode.SIMVARS(stateVars = i_vars_stateVars, derivativeVars = i_vars_derivativeVars, algVars = i_vars_algVars, paramVars = i_vars_paramVars)) )
      local
        list<SimCode.SimVar> i_vars_paramVars;
        list<SimCode.SimVar> i_vars_algVars;
        list<SimCode.SimVar> i_vars_derivativeVars;
        list<SimCode.SimVar> i_vars_stateVars;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "char* getName(double* ptr)\n",
                                    "{\n"
                                }, true));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_44(txt, i_vars_stateVars);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_45(txt, i_vars_derivativeVars);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_46(txt, i_vars_algVars);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_47(txt, i_vars_paramVars);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("return \"\";\n"));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("}"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end functionGetName;

public function functionDivisionError
  input Tpl.Text txt;

  output Tpl.Text out_txt;
algorithm
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "#define DIVISION(a,b,c) ((b != 0) ? a / b : a / division_error(b,c))\n",
                                   "\n",
                                   "int encounteredDivisionByZero = 0;\n",
                                   "\n",
                                   "double division_error(double b, const char* division_str)\n",
                                   "{\n",
                                   "  if(!encounteredDivisionByZero) {\n",
                                   "    fprintf(stderr, \"ERROR: Division by zero in partial equation: %s.\\n\",division_str);\n",
                                   "    encounteredDivisionByZero = 1;\n",
                                   "  }\n",
                                   "  return b;\n",
                                   "}"
                               }, false));
end functionDivisionError;

public function functionSetLocalData
  input Tpl.Text txt;

  output Tpl.Text out_txt;
algorithm
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "void setLocalData(DATA* data)\n",
                                   "{\n",
                                   "  localData = data;\n",
                                   "}"
                               }, false));
end functionSetLocalData;

protected function lm_51
  input Tpl.Text in_txt;
  input list<DAE.Exp> in_items;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_preExp)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;

    case ( txt,
           {},
           i_varDecls,
           i_preExp )
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           i_it :: rest,
           i_varDecls,
           i_preExp )
      local
        list<DAE.Exp> rest;
        DAE.Exp i_it;
      equation
        (txt, i_preExp, i_varDecls) = daeExp(txt, i_it, SimCode.contextOther, i_preExp, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls, i_preExp) = lm_51(txt, rest, i_varDecls, i_preExp);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_preExp )
      local
        list<DAE.Exp> rest;
      equation
        (txt, i_varDecls, i_preExp) = lm_51(txt, rest, i_varDecls, i_preExp);
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end lm_51;

protected function lm_52
  input Tpl.Text in_txt;
  input list<SimCode.ExtConstructor> in_items;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_preExp)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;

    case ( txt,
           {},
           i_varDecls,
           i_preExp )
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           (i_var, i_fn, i_exps) :: rest,
           i_varDecls,
           i_preExp )
      local
        list<SimCode.ExtConstructor> rest;
        list<DAE.Exp> i_exps;
        String i_fn;
        DAE.ComponentRef i_var;
        Tpl.Text i_expsStr;
      equation
        i_expsStr = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_expsStr, i_varDecls, i_preExp) = lm_51(i_expsStr, i_exps, i_varDecls, i_preExp);
        i_expsStr = Tpl.popIter(i_expsStr);
        txt = cref(txt, i_var);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = "));
        txt = Tpl.writeStr(txt, i_fn);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_expsStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls, i_preExp) = lm_52(txt, rest, i_varDecls, i_preExp);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_preExp )
      local
        list<SimCode.ExtConstructor> rest;
      equation
        (txt, i_varDecls, i_preExp) = lm_52(txt, rest, i_varDecls, i_preExp);
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end lm_52;

protected function lm_53
  input Tpl.Text in_txt;
  input list<SimCode.ExtAlias> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           (i_var1, i_var2) :: rest )
      local
        list<SimCode.ExtAlias> rest;
        DAE.ComponentRef i_var2;
        DAE.ComponentRef i_var1;
      equation
        txt = cref(txt, i_var1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = "));
        txt = cref(txt, i_var2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
        txt = Tpl.nextIter(txt);
        txt = lm_53(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.ExtAlias> rest;
      equation
        txt = lm_53(txt, rest);
      then txt;
  end matchcontinue;
end lm_53;

public function functionInitializeDataStruc
  input Tpl.Text in_txt;
  input SimCode.ExtObjInfo in_i_extObjInfo;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_extObjInfo)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.EXTOBJINFO(constructors = i_constructors, aliases = i_aliases) )
      local
        list<SimCode.ExtAlias> i_aliases;
        list<SimCode.ExtConstructor> i_constructors;
        Tpl.Text i_ctorCalls;
        Tpl.Text i_preExp;
        Tpl.Text i_varDecls;
      equation
        i_varDecls = emptyTxt;
        i_preExp = emptyTxt;
        i_ctorCalls = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_ctorCalls, i_varDecls, i_preExp) = lm_52(i_ctorCalls, i_constructors, i_varDecls, i_preExp);
        i_ctorCalls = Tpl.popIter(i_ctorCalls);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "DATA* initializeDataStruc(DATA_FLAGS flags)\n",
                                    "{\n"
                                }, true));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.writeText(txt, i_varDecls);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "\n",
                                    "DATA* returnData = (DATA*)malloc(sizeof(DATA));\n",
                                    "\n",
                                    "if(!returnData) //error check\n",
                                    "  return 0;\n",
                                    "\n",
                                    "memset(returnData,0,sizeof(DATA));\n",
                                    "returnData->nStates = NX;\n",
                                    "returnData->nAlgebraic = NY;\n",
                                    "returnData->nParameters = NP;\n",
                                    "returnData->nInputVars = NI;\n",
                                    "returnData->nOutputVars = NO;\n",
                                    "returnData->nZeroCrossing = NG;\n",
                                    "returnData->nInitialResiduals = NR;\n",
                                    "returnData->nHelpVars = NHELP;\n",
                                    "returnData->stringVariables.nParameters = NPSTR;\n",
                                    "returnData->stringVariables.nAlgebraic = NYSTR;\n",
                                    "\n",
                                    "if(flags & STATES && returnData->nStates) {\n",
                                    "  returnData->states = (double*) malloc(sizeof(double)*returnData->nStates);\n",
                                    "  returnData->oldStates = (double*) malloc(sizeof(double)*returnData->nStates);\n",
                                    "  returnData->oldStates2 = (double*) malloc(sizeof(double)*returnData->nStates);\n",
                                    "  assert(returnData->states&&returnData->oldStates&&returnData->oldStates2);\n",
                                    "  memset(returnData->states,0,sizeof(double)*returnData->nStates);\n",
                                    "  memset(returnData->oldStates,0,sizeof(double)*returnData->nStates);\n",
                                    "  memset(returnData->oldStates2,0,sizeof(double)*returnData->nStates);\n",
                                    "} else {\n",
                                    "  returnData->states = 0;\n",
                                    "  returnData->oldStates = 0;\n",
                                    "  returnData->oldStates2 = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & STATESDERIVATIVES && returnData->nStates) {\n",
                                    "  returnData->statesDerivatives = (double*) malloc(sizeof(double)*returnData->nStates);\n",
                                    "  returnData->oldStatesDerivatives = (double*) malloc(sizeof(double)*returnData->nStates);\n",
                                    "  returnData->oldStatesDerivatives2 = (double*) malloc(sizeof(double)*returnData->nStates);\n",
                                    "  assert(returnData->statesDerivatives&&returnData->oldStatesDerivatives&&returnData->oldStatesDerivatives2);\n",
                                    "  memset(returnData->statesDerivatives,0,sizeof(double)*returnData->nStates);\n",
                                    "  memset(returnData->oldStatesDerivatives,0,sizeof(double)*returnData->nStates);\n",
                                    "  memset(returnData->oldStatesDerivatives2,0,sizeof(double)*returnData->nStates);\n",
                                    "} else {\n",
                                    "  returnData->statesDerivatives = 0;\n",
                                    "  returnData->oldStatesDerivatives = 0;\n",
                                    "  returnData->oldStatesDerivatives2 = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & HELPVARS && returnData->nHelpVars) {\n",
                                    "  returnData->helpVars = (double*) malloc(sizeof(double)*returnData->nHelpVars);\n",
                                    "  assert(returnData->helpVars);\n",
                                    "  memset(returnData->helpVars,0,sizeof(double)*returnData->nHelpVars);\n",
                                    "} else {\n",
                                    "  returnData->helpVars = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & ALGEBRAICS && returnData->nAlgebraic) {\n",
                                    "  returnData->algebraics = (double*) malloc(sizeof(double)*returnData->nAlgebraic);\n",
                                    "  returnData->oldAlgebraics = (double*) malloc(sizeof(double)*returnData->nAlgebraic);\n",
                                    "  returnData->oldAlgebraics2 = (double*) malloc(sizeof(double)*returnData->nAlgebraic);\n",
                                    "  assert(returnData->algebraics&&returnData->oldAlgebraics&&returnData->oldAlgebraics2);\n",
                                    "  memset(returnData->algebraics,0,sizeof(double)*returnData->nAlgebraic);\n",
                                    "  memset(returnData->oldAlgebraics,0,sizeof(double)*returnData->nAlgebraic);\n",
                                    "  memset(returnData->oldAlgebraics2,0,sizeof(double)*returnData->nAlgebraic);\n",
                                    "} else {\n",
                                    "  returnData->algebraics = 0;\n",
                                    "  returnData->oldAlgebraics = 0;\n",
                                    "  returnData->oldAlgebraics2 = 0;\n",
                                    "  returnData->stringVariables.algebraics = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if (flags & ALGEBRAICS && returnData->stringVariables.nAlgebraic) {\n",
                                    "  returnData->stringVariables.algebraics = (char**)malloc(sizeof(char*)*returnData->stringVariables.nAlgebraic);\n",
                                    "  assert(returnData->stringVariables.algebraics);\n",
                                    "  memset(returnData->stringVariables.algebraics,0,sizeof(char*)*returnData->stringVariables.nAlgebraic);\n",
                                    "} else {\n",
                                    "  returnData->stringVariables.algebraics=0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & PARAMETERS && returnData->nParameters) {\n",
                                    "  returnData->parameters = (double*) malloc(sizeof(double)*returnData->nParameters);\n",
                                    "  assert(returnData->parameters);\n",
                                    "  memset(returnData->parameters,0,sizeof(double)*returnData->nParameters);\n",
                                    "} else {\n",
                                    "  returnData->parameters = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if (flags & PARAMETERS && returnData->stringVariables.nParameters) {\n",
                                    "      returnData->stringVariables.parameters = (char**)malloc(sizeof(char*)*returnData->stringVariables.nParameters);\n",
                                    "    assert(returnData->stringVariables.parameters);\n",
                                    "    memset(returnData->stringVariables.parameters,0,sizeof(char*)*returnData->stringVariables.nParameters);\n",
                                    "} else {\n",
                                    "    returnData->stringVariables.parameters=0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & OUTPUTVARS && returnData->nOutputVars) {\n",
                                    "  returnData->outputVars = (double*) malloc(sizeof(double)*returnData->nOutputVars);\n",
                                    "  assert(returnData->outputVars);\n",
                                    "  memset(returnData->outputVars,0,sizeof(double)*returnData->nOutputVars);\n",
                                    "} else {\n",
                                    "  returnData->outputVars = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & INPUTVARS && returnData->nInputVars) {\n",
                                    "  returnData->inputVars = (double*) malloc(sizeof(double)*returnData->nInputVars);\n",
                                    "  assert(returnData->inputVars);\n",
                                    "  memset(returnData->inputVars,0,sizeof(double)*returnData->nInputVars);\n",
                                    "} else {\n",
                                    "  returnData->inputVars = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & INITIALRESIDUALS && returnData->nInitialResiduals) {\n",
                                    "  returnData->initialResiduals = (double*) malloc(sizeof(double)*returnData->nInitialResiduals);\n",
                                    "  assert(returnData->initialResiduals);\n",
                                    "  memset(returnData->initialResiduals,0,sizeof(double)*returnData->nInitialResiduals);\n",
                                    "} else {\n",
                                    "  returnData->initialResiduals = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & INITFIXED) {\n",
                                    "  returnData->initFixed = init_fixed;\n",
                                    "} else {\n",
                                    "  returnData->initFixed = 0;\n",
                                    "}\n",
                                    "\n",
                                    "/*   names   */\n",
                                    "if(flags & MODELNAME) {\n",
                                    "  returnData->modelName = model_name;\n",
                                    "} else {\n",
                                    "  returnData->modelName = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & STATESNAMES) {\n",
                                    "  returnData->statesNames = state_names;\n",
                                    "} else {\n",
                                    "  returnData->statesNames = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & STATESDERIVATIVESNAMES) {\n",
                                    "  returnData->stateDerivativesNames = derivative_names;\n",
                                    "} else {\n",
                                    "  returnData->stateDerivativesNames = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & ALGEBRAICSNAMES) {\n",
                                    "  returnData->algebraicsNames = algvars_names;\n",
                                    "} else {\n",
                                    "  returnData->algebraicsNames = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & PARAMETERSNAMES) {\n",
                                    "  returnData->parametersNames = param_names;\n",
                                    "} else {\n",
                                    "  returnData->parametersNames = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & INPUTNAMES) {\n",
                                    "  returnData->inputNames = input_names;\n",
                                    "} else {\n",
                                    "  returnData->inputNames = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & OUTPUTNAMES) {\n",
                                    "  returnData->outputNames = output_names;\n",
                                    "} else {\n",
                                    "  returnData->outputNames = 0;\n",
                                    "}\n",
                                    "\n",
                                    "/*   comments  */\n",
                                    "if(flags & STATESCOMMENTS) {\n",
                                    "  returnData->statesComments = state_comments;\n",
                                    "} else {\n",
                                    "  returnData->statesComments = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & STATESDERIVATIVESCOMMENTS) {\n",
                                    "  returnData->stateDerivativesComments = derivative_comments;\n",
                                    "} else {\n",
                                    "  returnData->stateDerivativesComments = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & ALGEBRAICSCOMMENTS) {\n",
                                    "  returnData->algebraicsComments = algvars_comments;\n",
                                    "} else {\n",
                                    "  returnData->algebraicsComments = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & PARAMETERSCOMMENTS) {\n",
                                    "  returnData->parametersComments = param_comments;\n",
                                    "} else {\n",
                                    "  returnData->parametersComments = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & INPUTCOMMENTS) {\n",
                                    "  returnData->inputComments = input_comments;\n",
                                    "} else {\n",
                                    "  returnData->inputComments = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if(flags & OUTPUTCOMMENTS) {\n",
                                    "  returnData->outputComments = output_comments;\n",
                                    "} else {\n",
                                    "  returnData->outputComments = 0;\n",
                                    "}\n",
                                    "\n",
                                    "if (flags & EXTERNALVARS) {\n",
                                    "  returnData->extObjs = (void**)malloc(sizeof(void*)*NEXT);\n",
                                    "  if (!returnData->extObjs) {\n",
                                    "    printf(\"error allocating external objects\\n\");\n",
                                    "    exit(-2);\n",
                                    "  }\n",
                                    "  memset(returnData->extObjs,0,sizeof(void*)*NEXT);\n",
                                    "  setLocalData(returnData); /* must be set since used by constructors*/\n"
                                }, true));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeText(txt, i_ctorCalls);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_53(txt, i_aliases);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "}\n",
                                    "return returnData;\n"
                                }, true));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("}"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end functionInitializeDataStruc;

protected function lm_55
  input Tpl.Text in_txt;
  input list<SimCode.ExtDestructor> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           (i_fn, i_var) :: rest )
      local
        list<SimCode.ExtDestructor> rest;
        DAE.ComponentRef i_var;
        String i_fn;
      equation
        txt = Tpl.writeStr(txt, i_fn);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = cref(txt, i_var);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
        txt = Tpl.nextIter(txt);
        txt = lm_55(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.ExtDestructor> rest;
      equation
        txt = lm_55(txt, rest);
      then txt;
  end matchcontinue;
end lm_55;

public function functionDeInitializeDataStruc
  input Tpl.Text in_txt;
  input SimCode.ExtObjInfo in_i_extObjInfo;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_extObjInfo)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.EXTOBJINFO(destructors = i_destructors) )
      local
        list<SimCode.ExtDestructor> i_destructors;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "void deInitializeDataStruc(DATA* data, DATA_FLAGS flags)\n",
                                    "{\n",
                                    "  if(!data)\n",
                                    "    return;\n",
                                    "\n",
                                    "  if(flags & STATES && data->states) {\n",
                                    "    free(data->states);\n",
                                    "    data->states = 0;\n",
                                    "  }\n",
                                    "\n",
                                    "  if(flags & STATESDERIVATIVES && data->statesDerivatives) {\n",
                                    "    free(data->statesDerivatives);\n",
                                    "    data->statesDerivatives = 0;\n",
                                    "  }\n",
                                    "\n",
                                    "  if(flags & ALGEBRAICS && data->algebraics) {\n",
                                    "    free(data->algebraics);\n",
                                    "    data->algebraics = 0;\n",
                                    "  }\n",
                                    "\n",
                                    "  if(flags & PARAMETERS && data->parameters) {\n",
                                    "    free(data->parameters);\n",
                                    "    data->parameters = 0;\n",
                                    "  }\n",
                                    "\n",
                                    "  if(flags & OUTPUTVARS && data->inputVars) {\n",
                                    "    free(data->inputVars);\n",
                                    "    data->inputVars = 0;\n",
                                    "  }\n",
                                    "\n",
                                    "  if(flags & INPUTVARS && data->outputVars) {\n",
                                    "    free(data->outputVars);\n",
                                    "    data->outputVars = 0;\n",
                                    "  }\n",
                                    "\n",
                                    "  if(flags & INITIALRESIDUALS && data->initialResiduals){\n",
                                    "    free(data->initialResiduals);\n",
                                    "    data->initialResiduals = 0;\n",
                                    "  }\n",
                                    "  if (flags & EXTERNALVARS && data->extObjs) {\n"
                                }, true));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(4));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_55(txt, i_destructors);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "free(data->extObjs);\n",
                                    "data->extObjs = 0;\n"
                                }, true));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "  }\n",
                                    "}"
                                }, false));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end functionDeInitializeDataStruc;

protected function lm_57
  input Tpl.Text in_txt;
  input list<SimCode.SimEqSystem> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
        SimCode.SimEqSystem i_it;
      equation
        (txt, i_varDecls) = equation_(txt, i_it, SimCode.contextSimulationNonDescrete, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_57(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
      equation
        (txt, i_varDecls) = lm_57(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_57;

protected function lm_58
  input Tpl.Text in_txt;
  input list<DAE.Statement> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls )
      local
        list<DAE.Statement> rest;
        DAE.Statement i_it;
      equation
        (txt, i_varDecls) = algStatement(txt, i_it, SimCode.contextSimulationNonDescrete, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_58(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<DAE.Statement> rest;
      equation
        (txt, i_varDecls) = lm_58(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_58;

protected function lm_59
  input Tpl.Text in_txt;
  input list<SimCode.SimEqSystem> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
        SimCode.SimEqSystem i_it;
      equation
        (txt, i_varDecls) = equation_(txt, i_it, SimCode.contextSimulationNonDescrete, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_59(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
      equation
        (txt, i_varDecls) = lm_59(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_59;

public function functionDaeOutput
  input Tpl.Text txt;
  input list<SimCode.SimEqSystem> i_nonStateContEquations;
  input list<SimCode.SimEqSystem> i_removedEquations;
  input list<DAE.Statement> i_algorithmAndEquationAsserts;

  output Tpl.Text out_txt;
protected
  Tpl.Text i_removedPart;
  Tpl.Text i_algAndEqAssertsPart;
  Tpl.Text i_nonStateContPart;
  Tpl.Text i_varDecls;
algorithm
  i_varDecls := emptyTxt;
  i_nonStateContPart := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_nonStateContPart, i_varDecls) := lm_57(i_nonStateContPart, i_nonStateContEquations, i_varDecls);
  i_nonStateContPart := Tpl.popIter(i_nonStateContPart);
  i_algAndEqAssertsPart := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_algAndEqAssertsPart, i_varDecls) := lm_58(i_algAndEqAssertsPart, i_algorithmAndEquationAsserts, i_varDecls);
  i_algAndEqAssertsPart := Tpl.popIter(i_algAndEqAssertsPart);
  i_removedPart := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_removedPart, i_varDecls) := lm_59(i_removedPart, i_removedEquations, i_varDecls);
  i_removedPart := Tpl.popIter(i_removedPart);
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "/* for continuous time variables */\n",
                                   "int functionDAE_output()\n",
                                   "{\n",
                                   "  state mem_state;\n"
                               }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.writeText(out_txt, i_varDecls);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "mem_state = get_memory_state();\n"
                                   }, true));
  out_txt := Tpl.writeText(out_txt, i_nonStateContPart);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeText(out_txt, i_algAndEqAssertsPart);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeText(out_txt, i_removedPart);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "restore_memory_state(mem_state);\n",
                                       "\n",
                                       "return 0;\n"
                                   }, true));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("}"));
end functionDaeOutput;

protected function lm_61
  input Tpl.Text in_txt;
  input list<SimCode.SimEqSystem> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
        SimCode.SimEqSystem i_it;
      equation
        (txt, i_varDecls) = equation_(txt, i_it, SimCode.contextSimulationDescrete, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_61(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
      equation
        (txt, i_varDecls) = lm_61(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_61;

protected function lm_62
  input Tpl.Text in_txt;
  input list<SimCode.SimEqSystem> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
        SimCode.SimEqSystem i_it;
      equation
        (txt, i_varDecls) = equation_(txt, i_it, SimCode.contextSimulationDescrete, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_62(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
      equation
        (txt, i_varDecls) = lm_62(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_62;

public function functionDaeOutput2
  input Tpl.Text txt;
  input list<SimCode.SimEqSystem> i_nonStateDiscEquations;
  input list<SimCode.SimEqSystem> i_removedEquations;

  output Tpl.Text out_txt;
protected
  Tpl.Text i_removedPart;
  Tpl.Text i_nonSateDiscPart;
  Tpl.Text i_varDecls;
algorithm
  i_varDecls := emptyTxt;
  i_nonSateDiscPart := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_nonSateDiscPart, i_varDecls) := lm_61(i_nonSateDiscPart, i_nonStateDiscEquations, i_varDecls);
  i_nonSateDiscPart := Tpl.popIter(i_nonSateDiscPart);
  i_removedPart := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_removedPart, i_varDecls) := lm_62(i_removedPart, i_removedEquations, i_varDecls);
  i_removedPart := Tpl.popIter(i_removedPart);
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "/* for discrete time variables */\n",
                                   "int functionDAE_output2()\n",
                                   "{\n",
                                   "  state mem_state;\n"
                               }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.writeText(out_txt, i_varDecls);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "mem_state = get_memory_state();\n"
                                   }, true));
  out_txt := Tpl.writeText(out_txt, i_nonSateDiscPart);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeText(out_txt, i_removedPart);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "restore_memory_state(mem_state);\n",
                                       "\n",
                                       "return 0;\n"
                                   }, true));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("}"));
end functionDaeOutput2;

protected function lm_64
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(name = i_name) :: rest )
      local
        list<SimCode.SimVar> rest;
        DAE.ComponentRef i_name;
        Integer i_i0;
      equation
        i_i0 = Tpl.getIteri_i0(txt);
        txt = cref(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = localData->inputVars["));
        txt = Tpl.writeStr(txt, intString(i_i0));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("];"));
        txt = Tpl.nextIter(txt);
        txt = lm_64(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_64(txt, rest);
      then txt;
  end matchcontinue;
end lm_64;

public function functionInput
  input Tpl.Text in_txt;
  input SimCode.ModelInfo in_i_modelInfo;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_modelInfo)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.MODELINFO(vars = SimCode.SIMVARS(inputVars = i_vars_inputVars)) )
      local
        list<SimCode.SimVar> i_vars_inputVars;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "int input_function()\n",
                                    "{\n"
                                }, true));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_64(txt, i_vars_inputVars);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("return 0;\n"));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("}"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end functionInput;

protected function lm_66
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(name = i_name) :: rest )
      local
        list<SimCode.SimVar> rest;
        DAE.ComponentRef i_name;
        Integer i_i0;
      equation
        i_i0 = Tpl.getIteri_i0(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("localData->outputVars["));
        txt = Tpl.writeStr(txt, intString(i_i0));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("] = "));
        txt = cref(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
        txt = Tpl.nextIter(txt);
        txt = lm_66(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_66(txt, rest);
      then txt;
  end matchcontinue;
end lm_66;

public function functionOutput
  input Tpl.Text in_txt;
  input SimCode.ModelInfo in_i_modelInfo;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_modelInfo)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.MODELINFO(vars = SimCode.SIMVARS(outputVars = i_vars_outputVars)) )
      local
        list<SimCode.SimVar> i_vars_outputVars;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "int output_function()\n",
                                    "{\n"
                                }, true));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_66(txt, i_vars_outputVars);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("return 0;\n"));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("}"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end functionOutput;

public function functionDaeRes
  input Tpl.Text txt;

  output Tpl.Text out_txt;
algorithm
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "int functionDAE_res(double *t, double *x, double *xd, double *delta,\n",
                                   "                    long int *ires, double *rpar, long int* ipar)\n",
                                   "{\n",
                                   "  int i;\n",
                                   "  double temp_xd[NX];\n",
                                   "  double* statesBackup;\n",
                                   "  double* statesDerivativesBackup;\n",
                                   "  double timeBackup;\n",
                                   "\n",
                                   "  statesBackup = localData->states;\n",
                                   "  statesDerivativesBackup = localData->statesDerivatives;\n",
                                   "  timeBackup = localData->timeValue;\n",
                                   "  localData->states = x;\n",
                                   "\n",
                                   "  for (i=0; i<localData->nStates; i++) {\n",
                                   "    temp_xd[i] = localData->statesDerivatives[i];\n",
                                   "  }\n",
                                   "\n",
                                   "  localData->statesDerivatives = temp_xd;\n",
                                   "  localData->timeValue = *t;\n",
                                   "\n",
                                   "  functionODE();\n",
                                   "\n",
                                   "  /* get the difference between the temp_xd(=localData->statesDerivatives)\n",
                                   "     and xd(=statesDerivativesBackup) */\n",
                                   "  for (i=0; i < localData->nStates; i++) {\n",
                                   "    delta[i] = localData->statesDerivatives[i] - statesDerivativesBackup[i];\n",
                                   "  }\n",
                                   "\n",
                                   "  localData->states = statesBackup;\n",
                                   "  localData->statesDerivatives = statesDerivativesBackup;\n",
                                   "  localData->timeValue = timeBackup;\n",
                                   "\n",
                                   "  if (modelErrorCode) {\n",
                                   "    if (ires) {\n",
                                   "      *ires = -1;\n",
                                   "    }\n",
                                   "    modelErrorCode =0;\n",
                                   "  }\n",
                                   "\n",
                                   "  return 0;\n",
                                   "}"
                               }, false));
end functionDaeRes;

public function functionZeroCrossing
  input Tpl.Text txt;
  input list<DAELow.ZeroCrossing> i_zeroCrossings;

  output Tpl.Text out_txt;
protected
  Tpl.Text i_zeroCrossingCode;
  Tpl.Text i_varDecls;
algorithm
  i_varDecls := emptyTxt;
  (i_zeroCrossingCode, i_varDecls) := zeroCrossingsTpl(emptyTxt, i_zeroCrossings, i_varDecls);
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "int function_zeroCrossing(long *neqm, double *t, double *x, long *ng,\n",
                                   "                          double *gout, double *rpar, long* ipar)\n",
                                   "{\n",
                                   "  double timeBackup;\n",
                                   "  state mem_state;\n",
                                   "\n",
                                   "  mem_state = get_memory_state();\n",
                                   "\n",
                                   "  timeBackup = localData->timeValue;\n",
                                   "  localData->timeValue = *t;\n"
                               }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.writeText(out_txt, i_varDecls);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "functionODE();\n",
                                       "functionDAE_output();\n",
                                       "\n"
                                   }, true));
  out_txt := Tpl.writeText(out_txt, i_zeroCrossingCode);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "restore_memory_state(mem_state);\n",
                                       "localData->timeValue = timeBackup;\n",
                                       "\n",
                                       "return 0;\n"
                                   }, true));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("}"));
end functionZeroCrossing;

protected function lm_70
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(name = i_name) :: rest )
      local
        list<SimCode.SimVar> rest;
        DAE.ComponentRef i_name;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("save("));
        txt = cref(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
        txt = Tpl.nextIter(txt);
        txt = lm_70(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_70(txt, rest);
      then txt;
  end matchcontinue;
end lm_70;

protected function lm_71
  input Tpl.Text in_txt;
  input list<list<SimCode.SimVar>> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_vars :: rest )
      local
        list<list<SimCode.SimVar>> rest;
        list<SimCode.SimVar> i_vars;
        Integer i_i0;
      equation
        i_i0 = Tpl.getIteri_i0(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("case "));
        txt = Tpl.writeStr(txt, intString(i_i0));
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(":\n"));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_70(txt, i_vars);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("break;"));
        txt = Tpl.popBlock(txt);
        txt = Tpl.nextIter(txt);
        txt = lm_71(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<list<SimCode.SimVar>> rest;
      equation
        txt = lm_71(txt, rest);
      then txt;
  end matchcontinue;
end lm_71;

public function functionHandleZeroCrossing
  input Tpl.Text txt;
  input list<list<SimCode.SimVar>> i_zeroCrossingsNeedSave;

  output Tpl.Text out_txt;
algorithm
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "int handleZeroCrossing(long index)\n",
                                   "{\n",
                                   "  state mem_state;\n",
                                   "\n",
                                   "  mem_state = get_memory_state();\n",
                                   "\n",
                                   "  switch(index) {\n"
                               }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(4));
  out_txt := Tpl.pushIter(out_txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  out_txt := lm_71(out_txt, i_zeroCrossingsNeedSave);
  out_txt := Tpl.popIter(out_txt);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "default:\n",
                                       "  break;\n"
                                   }, true));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "  }\n",
                                       "\n",
                                       "  restore_memory_state(mem_state);\n",
                                       "\n",
                                       "  return 0;\n",
                                       "}"
                                   }, false));
end functionHandleZeroCrossing;

protected function lm_73
  input Tpl.Text in_txt;
  input list<SimCode.SimEqSystem> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
        SimCode.SimEqSystem i_it;
      equation
        (txt, i_varDecls) = equation_(txt, i_it, SimCode.contextSimulationDescrete, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_73(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
      equation
        (txt, i_varDecls) = lm_73(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_73;

protected function lm_74
  input Tpl.Text in_txt;
  input list<SimCode.HelpVarInfo> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           (i_hindex, i_exp, _) :: rest,
           i_varDecls )
      local
        list<SimCode.HelpVarInfo> rest;
        DAE.Exp i_exp;
        Integer i_hindex;
        Tpl.Text i_expPart;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_expPart, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, SimCode.contextSimulationDescrete, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("localData->helpVars["));
        txt = Tpl.writeStr(txt, intString(i_hindex));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("] = "));
        txt = Tpl.writeText(txt, i_expPart);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_74(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.HelpVarInfo> rest;
      equation
        (txt, i_varDecls) = lm_74(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_74;

public function functionUpdateDependents
  input Tpl.Text txt;
  input list<SimCode.SimEqSystem> i_allEquations;
  input list<SimCode.HelpVarInfo> i_helpVarInfo;

  output Tpl.Text out_txt;
protected
  Tpl.Text i_hvars;
  Tpl.Text i_eqs;
  Tpl.Text i_varDecls;
algorithm
  i_varDecls := emptyTxt;
  i_eqs := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_eqs, i_varDecls) := lm_73(i_eqs, i_allEquations, i_varDecls);
  i_eqs := Tpl.popIter(i_eqs);
  i_hvars := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_hvars, i_varDecls) := lm_74(i_hvars, i_helpVarInfo, i_varDecls);
  i_hvars := Tpl.popIter(i_hvars);
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "int function_updateDependents()\n",
                                   "{\n",
                                   "  state mem_state;\n"
                               }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.writeText(out_txt, i_varDecls);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "inUpdate=initial()?0:1;\n",
                                       "\n",
                                       "mem_state = get_memory_state();\n",
                                       "\n"
                                   }, true));
  out_txt := Tpl.writeText(out_txt, i_eqs);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeText(out_txt, i_hvars);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "restore_memory_state(mem_state);\n",
                                       "\n",
                                       "inUpdate=0;\n",
                                       "\n",
                                       "return 0;\n"
                                   }, true));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("}"));
end functionUpdateDependents;

protected function lm_76
  input Tpl.Text in_txt;
  input list<SimCode.SimEqSystem> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
        SimCode.SimEqSystem i_it;
      equation
        (txt, i_varDecls) = equation_(txt, i_it, SimCode.contextSimulationDescrete, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_76(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
      equation
        (txt, i_varDecls) = lm_76(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_76;

public function functionUpdateDepend
  input Tpl.Text txt;
  input list<SimCode.SimEqSystem> i_allEquationsPlusWhen;

  output Tpl.Text out_txt;
protected
  Tpl.Text i_eqs;
  Tpl.Text i_varDecls;
algorithm
  i_varDecls := emptyTxt;
  i_eqs := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_eqs, i_varDecls) := lm_76(i_eqs, i_allEquationsPlusWhen, i_varDecls);
  i_eqs := Tpl.popIter(i_eqs);
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "int function_updateDepend()\n",
                                   "{\n",
                                   "  state mem_state;\n"
                               }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.writeText(out_txt, i_varDecls);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "inUpdate=initial()?0:1;\n",
                                       "\n",
                                       "mem_state = get_memory_state();\n"
                                   }, true));
  out_txt := Tpl.writeText(out_txt, i_eqs);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "restore_memory_state(mem_state);\n",
                                       "\n",
                                       "inUpdate=0;\n",
                                       "\n",
                                       "return 0;\n"
                                   }, true));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("}"));
end functionUpdateDepend;

public function functionOnlyZeroCrossing
  input Tpl.Text txt;
  input list<DAELow.ZeroCrossing> i_zeroCrossings;

  output Tpl.Text out_txt;
protected
  Tpl.Text i_zeroCrossingCode;
  Tpl.Text i_varDecls;
algorithm
  i_varDecls := emptyTxt;
  (i_zeroCrossingCode, i_varDecls) := zeroCrossingsTpl(emptyTxt, i_zeroCrossings, i_varDecls);
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "int function_onlyZeroCrossings(double *gout,double *t)\n",
                                   "{\n",
                                   "  state mem_state;\n"
                               }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.writeText(out_txt, i_varDecls);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "mem_state = get_memory_state();\n",
                                       "\n"
                                   }, true));
  out_txt := Tpl.writeText(out_txt, i_zeroCrossingCode);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "restore_memory_state(mem_state);\n",
                                       "\n",
                                       "return 0;\n"
                                   }, true));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("}"));
end functionOnlyZeroCrossing;

protected function lm_79
  input Tpl.Text in_txt;
  input list<DAE.ComponentRef> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_var :: rest )
      local
        list<DAE.ComponentRef> rest;
        DAE.ComponentRef i_var;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("if (change("));
        txt = cref(txt, i_var);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")) { needToIterate=1; }"));
        txt = Tpl.nextIter(txt);
        txt = lm_79(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<DAE.ComponentRef> rest;
      equation
        txt = lm_79(txt, rest);
      then txt;
  end matchcontinue;
end lm_79;

public function functionCheckForDiscreteChanges
  input Tpl.Text txt;
  input list<DAE.ComponentRef> i_discreteModelVars;

  output Tpl.Text out_txt;
algorithm
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "int checkForDiscreteChanges()\n",
                                   "{\n",
                                   "  int needToIterate = 0;\n",
                                   "\n"
                               }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.pushIter(out_txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  out_txt := lm_79(out_txt, i_discreteModelVars);
  out_txt := Tpl.popIter(out_txt);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "return needToIterate;\n"
                                   }, true));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("}"));
end functionCheckForDiscreteChanges;

protected function lm_81
  input Tpl.Text in_txt;
  input list<tuple<DAE.Exp, DAE.Exp>> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           (i_id, i_e) :: rest,
           i_varDecls )
      local
        list<tuple<DAE.Exp, DAE.Exp>> rest;
        DAE.Exp i_e;
        DAE.Exp i_id;
        Tpl.Text i_eRes;
        Tpl.Text i_idRes;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_idRes, i_preExp, i_varDecls) = daeExp(emptyTxt, i_id, SimCode.contextSimulationNonDescrete, i_preExp, i_varDecls);
        (i_eRes, i_preExp, i_varDecls) = daeExp(emptyTxt, i_e, SimCode.contextSimulationNonDescrete, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("storeDelayedExpression("));
        txt = Tpl.writeText(txt, i_idRes);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_eRes);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
        (txt, i_varDecls) = lm_81(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<tuple<DAE.Exp, DAE.Exp>> rest;
      equation
        (txt, i_varDecls) = lm_81(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_81;

public function functionStoreDelayed
  input Tpl.Text txt;
  input list<tuple<DAE.Exp, DAE.Exp>> i_delayedExps;

  output Tpl.Text out_txt;
protected
  Tpl.Text i_storePart;
  Tpl.Text i_varDecls;
algorithm
  i_varDecls := emptyTxt;
  (i_storePart, i_varDecls) := lm_81(emptyTxt, i_delayedExps, i_varDecls);
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "int function_storeDelayed()\n",
                                   "{\n",
                                   "  state mem_state;\n"
                               }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.writeText(out_txt, i_varDecls);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_LINE("mem_state = get_memory_state();\n"));
  out_txt := Tpl.writeText(out_txt, i_storePart);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "restore_memory_state(mem_state);\n",
                                       "return 0;\n"
                                   }, true));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("}"));
end functionStoreDelayed;

protected function lm_83
  input Tpl.Text in_txt;
  input list<DAELow.ReinitStatement> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           i_reinit :: rest,
           i_varDecls )
      local
        list<DAELow.ReinitStatement> rest;
        DAELow.ReinitStatement i_reinit;
        Tpl.Text i_body;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_body, i_preExp, i_varDecls) = functionWhenReinitStatement(emptyTxt, i_reinit, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_body);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_83(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<DAELow.ReinitStatement> rest;
      equation
        (txt, i_varDecls) = lm_83(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_83;

protected function lm_84
  input Tpl.Text in_txt;
  input list<SimCode.SimWhenClause> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           SimCode.SIM_WHEN_CLAUSE(whenEq = i_whenEq, reinits = i_reinits) :: rest,
           i_varDecls )
      local
        list<SimCode.SimWhenClause> rest;
        list<DAELow.ReinitStatement> i_reinits;
        Option<DAELow.WhenEquation> i_whenEq;
        Integer i_i0;
      equation
        i_i0 = Tpl.getIteri_i0(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("case "));
        txt = Tpl.writeStr(txt, intString(i_i0));
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(":\n"));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        (txt, i_varDecls) = functionWhenCaseEquation(txt, i_whenEq, i_varDecls);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (txt, i_varDecls) = lm_83(txt, i_reinits, i_varDecls);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("break;"));
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = Tpl.popBlock(txt);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_84(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.SimWhenClause> rest;
      equation
        (txt, i_varDecls) = lm_84(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_84;

public function functionWhen
  input Tpl.Text txt;
  input list<SimCode.SimWhenClause> i_whenClauses;

  output Tpl.Text out_txt;
protected
  Tpl.Text i_cases;
  Tpl.Text i_varDecls;
algorithm
  i_varDecls := emptyTxt;
  i_cases := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, NONE, 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_cases, i_varDecls) := lm_84(i_cases, i_whenClauses, i_varDecls);
  i_cases := Tpl.popIter(i_cases);
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "int function_when(int i)\n",
                                   "{\n",
                                   "  state mem_state;\n"
                               }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.writeText(out_txt, i_varDecls);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "mem_state = get_memory_state();\n",
                                       "\n",
                                       "switch(i) {\n"
                                   }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.writeText(out_txt, i_cases);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "default:\n",
                                       "  break;\n"
                                   }, true));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "}\n",
                                       "\n",
                                       "restore_memory_state(mem_state);\n",
                                       "\n",
                                       "return 0;\n"
                                   }, true));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("}"));
end functionWhen;

public function functionWhenCaseEquation
  input Tpl.Text in_txt;
  input Option<DAELow.WhenEquation> in_i_it;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_it, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           SOME((i_weq as DAELow.WHEN_EQ(right = i_weq_right, left = i_weq_left))),
           i_varDecls )
      local
        DAE.ComponentRef i_weq_left;
        DAE.Exp i_weq_right;
        DAELow.WhenEquation i_weq;
        Tpl.Text i_expPart;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_expPart, i_preExp, i_varDecls) = daeExp(emptyTxt, i_weq_right, SimCode.contextSimulationDescrete, i_preExp, i_varDecls);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("save("));
        txt = cref(txt, i_weq_left);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    ");\n",
                                    "\n"
                                }, true));
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = cref(txt, i_weq_left);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = "));
        txt = Tpl.writeText(txt, i_expPart);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
      then (txt, i_varDecls);

    case ( txt,
           _,
           i_varDecls )
      then (txt, i_varDecls);
  end matchcontinue;
end functionWhenCaseEquation;

public function functionWhenReinitStatement
  input Tpl.Text in_txt;
  input DAELow.ReinitStatement in_i_it;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_it, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           DAELow.REINIT(value = i_value, stateVar = i_stateVar),
           i_preExp,
           i_varDecls )
      local
        DAE.ComponentRef i_stateVar;
        DAE.Exp i_value;
        Tpl.Text i_val;
      equation
        (i_val, i_preExp, i_varDecls) = daeExp(emptyTxt, i_value, SimCode.contextSimulationDescrete, i_preExp, i_varDecls);
        txt = cref(txt, i_stateVar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = "));
        txt = Tpl.writeText(txt, i_val);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end functionWhenReinitStatement;

protected function lm_88
  input Tpl.Text in_txt;
  input list<SimCode.SimEqSystem> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           i_eq :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
        SimCode.SimEqSystem i_eq;
      equation
        (txt, i_varDecls) = equation_(txt, i_eq, SimCode.contextOther, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_88(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
      equation
        (txt, i_varDecls) = lm_88(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_88;

public function functionOde
  input Tpl.Text txt;
  input list<SimCode.SimEqSystem> i_stateContEquations;

  output Tpl.Text out_txt;
protected
  Tpl.Text i_stateContPart;
  Tpl.Text i_varDecls;
algorithm
  i_varDecls := emptyTxt;
  i_stateContPart := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_stateContPart, i_varDecls) := lm_88(i_stateContPart, i_stateContEquations, i_varDecls);
  i_stateContPart := Tpl.popIter(i_stateContPart);
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "int functionODE()\n",
                                   "{\n",
                                   "  state mem_state;\n"
                               }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.writeText(out_txt, i_varDecls);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "mem_state = get_memory_state();\n",
                                       "\n"
                                   }, true));
  out_txt := Tpl.writeText(out_txt, i_stateContPart);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "restore_memory_state(mem_state);\n",
                                       "\n",
                                       "return 0;\n"
                                   }, true));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("}"));
end functionOde;

protected function lm_90
  input Tpl.Text in_txt;
  input list<SimCode.SimEqSystem> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           (it as SimCode.SES_SIMPLE_ASSIGN(componentRef = _)) :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
        SimCode.SimEqSystem it;
      equation
        (txt, i_varDecls) = equation_(txt, it, SimCode.contextOther, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_90(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
      equation
        (txt, i_varDecls) = lm_90(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_90;

protected function lm_91
  input Tpl.Text in_txt;
  input list<SimCode.SimEqSystem> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SES_SIMPLE_ASSIGN(componentRef = i_componentRef) :: rest )
      local
        list<SimCode.SimEqSystem> rest;
        DAE.ComponentRef i_componentRef;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("if (sim_verbose) { printf(\"Setting variable start value: %s(start=%f)\\n\", \""));
        txt = cref(txt, i_componentRef);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("\", "));
        txt = cref(txt, i_componentRef);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("); }"));
        txt = Tpl.nextIter(txt);
        txt = lm_91(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimEqSystem> rest;
      equation
        txt = lm_91(txt, rest);
      then txt;
  end matchcontinue;
end lm_91;

public function functionInitial
  input Tpl.Text txt;
  input list<SimCode.SimEqSystem> i_initialEquations;

  output Tpl.Text out_txt;
protected
  Tpl.Text i_eqPart;
  Tpl.Text i_varDecls;
algorithm
  i_varDecls := emptyTxt;
  i_eqPart := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_eqPart, i_varDecls) := lm_90(i_eqPart, i_initialEquations, i_varDecls);
  i_eqPart := Tpl.popIter(i_eqPart);
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "int initial_function()\n",
                                   "{\n"
                               }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.writeText(out_txt, i_varDecls);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_NEW_LINE());
  out_txt := Tpl.writeText(out_txt, i_eqPart);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_NEW_LINE());
  out_txt := Tpl.pushIter(out_txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  out_txt := lm_91(out_txt, i_initialEquations);
  out_txt := Tpl.popIter(out_txt);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "return 0;\n"
                                   }, true));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("}"));
end functionInitial;

protected function fun_93
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.SCONST(string = _),
           i_varDecls )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("localData->initialResiduals[i++] = 0;"));
      then (txt, i_varDecls);

    case ( txt,
           i_exp,
           i_varDecls )
      local
        DAE.Exp i_exp;
        Tpl.Text i_expPart;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_expPart, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, SimCode.contextOther, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("localData->initialResiduals[i++] = "));
        txt = Tpl.writeText(txt, i_expPart);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
      then (txt, i_varDecls);
  end matchcontinue;
end fun_93;

protected function lm_94
  input Tpl.Text in_txt;
  input list<SimCode.SimEqSystem> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           SimCode.SES_RESIDUAL(exp = i_exp) :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
        DAE.Exp i_exp;
      equation
        (txt, i_varDecls) = fun_93(txt, i_exp, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_94(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
      equation
        (txt, i_varDecls) = lm_94(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_94;

public function functionInitialResidual
  input Tpl.Text txt;
  input list<SimCode.SimEqSystem> i_residualEquations;

  output Tpl.Text out_txt;
protected
  Tpl.Text i_body;
  Tpl.Text i_varDecls;
algorithm
  i_varDecls := emptyTxt;
  i_body := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_body, i_varDecls) := lm_94(i_body, i_residualEquations, i_varDecls);
  i_body := Tpl.popIter(i_body);
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "int initial_residual()\n",
                                   "{\n",
                                   "  int i = 0;\n",
                                   "  state mem_state;\n"
                               }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.writeText(out_txt, i_varDecls);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "mem_state = get_memory_state();\n",
                                       "\n"
                                   }, true));
  out_txt := Tpl.writeText(out_txt, i_body);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "restore_memory_state(mem_state);\n",
                                       "\n",
                                       "return 0;\n"
                                   }, true));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("}"));
end functionInitialResidual;

protected function lm_96
  input Tpl.Text in_txt;
  input list<SimCode.SimEqSystem> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           (i_eq2 as SimCode.SES_SIMPLE_ASSIGN(componentRef = _)) :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
        SimCode.SimEqSystem i_eq2;
      equation
        (txt, i_varDecls) = equation_(txt, i_eq2, SimCode.contextOther, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_96(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
      equation
        (txt, i_varDecls) = lm_96(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_96;

protected function lm_97
  input Tpl.Text in_txt;
  input list<SimCode.SimEqSystem> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           (i_eq2 as SimCode.SES_RESIDUAL(exp = i_eq2_exp)) :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
        DAE.Exp i_eq2_exp;
        SimCode.SimEqSystem i_eq2;
        Integer i_i0;
        Tpl.Text i_expPart;
        Tpl.Text i_preExp;
      equation
        i_i0 = Tpl.getIteri_i0(txt);
        i_preExp = emptyTxt;
        (i_expPart, i_preExp, i_varDecls) = daeExp(emptyTxt, i_eq2_exp, SimCode.contextSimulationDescrete, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("res["));
        txt = Tpl.writeStr(txt, intString(i_i0));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("] = "));
        txt = Tpl.writeText(txt, i_expPart);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_97(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
      equation
        (txt, i_varDecls) = lm_97(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_97;

protected function lm_98
  input Tpl.Text in_txt;
  input list<SimCode.SimEqSystem> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           (i_eq as SimCode.SES_NONLINEAR(eqs = i_eq_eqs, index = i_index)) :: rest )
      local
        list<SimCode.SimEqSystem> rest;
        Integer i_index;
        list<SimCode.SimEqSystem> i_eq_eqs;
        SimCode.SimEqSystem i_eq;
        Tpl.Text i_body;
        Tpl.Text i_prebody;
        Tpl.Text i_varDecls;
      equation
        i_varDecls = emptyTxt;
        i_prebody = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_prebody, i_varDecls) = lm_96(i_prebody, i_eq_eqs, i_varDecls);
        i_prebody = Tpl.popIter(i_prebody);
        i_body = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_body, i_varDecls) = lm_97(i_body, i_eq_eqs, i_varDecls);
        i_body = Tpl.popIter(i_body);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("void residualFunc"));
        txt = Tpl.writeStr(txt, intString(i_index));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "(int *n, double* xloc, double* res, int* iflag)\n",
                                    "{\n",
                                    "  state mem_state;\n"
                                }, true));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.writeText(txt, i_varDecls);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("mem_state = get_memory_state();\n"));
        txt = Tpl.writeText(txt, i_prebody);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeText(txt, i_body);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("restore_memory_state(mem_state);\n"));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("}"));
        txt = Tpl.nextIter(txt);
        txt = lm_98(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimEqSystem> rest;
      equation
        txt = lm_98(txt, rest);
      then txt;
  end matchcontinue;
end lm_98;

public function functionExtraResudials
  input Tpl.Text txt;
  input list<SimCode.SimEqSystem> i_allEquations;

  output Tpl.Text out_txt;
algorithm
  out_txt := Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING_LIST({
                                                                  "\n",
                                                                  "\n"
                                                              }, true)), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  out_txt := lm_98(out_txt, i_allEquations);
  out_txt := Tpl.popIter(out_txt);
end functionExtraResudials;

protected function lm_100
  input Tpl.Text in_txt;
  input list<SimCode.SimEqSystem> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           (it as SimCode.SES_SIMPLE_ASSIGN(componentRef = _)) :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
        SimCode.SimEqSystem it;
      equation
        (txt, i_varDecls) = equation_(txt, it, SimCode.contextOther, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_100(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.SimEqSystem> rest;
      equation
        (txt, i_varDecls) = lm_100(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_100;

public function functionBoundParameters
  input Tpl.Text txt;
  input list<SimCode.SimEqSystem> i_parameterEquations;

  output Tpl.Text out_txt;
protected
  Tpl.Text i_body;
  Tpl.Text i_varDecls;
algorithm
  i_varDecls := emptyTxt;
  i_body := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_body, i_varDecls) := lm_100(i_body, i_parameterEquations, i_varDecls);
  i_body := Tpl.popIter(i_body);
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "int bound_parameters()\n",
                                   "{\n",
                                   "  state mem_state;\n"
                               }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.writeText(out_txt, i_varDecls);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "mem_state = get_memory_state();\n",
                                       "\n"
                                   }, true));
  out_txt := Tpl.writeText(out_txt, i_body);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "restore_memory_state(mem_state);\n",
                                       "\n",
                                       "return 0;\n"
                                   }, true));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("}"));
end functionBoundParameters;

protected function fun_102
  input Tpl.Text in_txt;
  input Integer in_i_windex;
  input Integer in_i_hindex;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_windex, in_i_hindex)
    local
      Tpl.Text txt;
      Integer i_hindex;

    case ( txt,
           -1,
           _ )
      then txt;

    case ( txt,
           i_windex,
           i_hindex )
      local
        Integer i_windex;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("if (edge(localData->helpVars["));
        txt = Tpl.writeStr(txt, intString(i_hindex));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("])) AddEvent("));
        txt = Tpl.writeStr(txt, intString(i_windex));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" + localData->nZeroCrossing);"));
      then txt;
  end matchcontinue;
end fun_102;

protected function lm_103
  input Tpl.Text in_txt;
  input list<SimCode.HelpVarInfo> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           (i_hindex, i_exp, i_windex) :: rest )
      local
        list<SimCode.HelpVarInfo> rest;
        Integer i_windex;
        DAE.Exp i_exp;
        Integer i_hindex;
      equation
        txt = fun_102(txt, i_windex, i_hindex);
        txt = Tpl.nextIter(txt);
        txt = lm_103(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.HelpVarInfo> rest;
      equation
        txt = lm_103(txt, rest);
      then txt;
  end matchcontinue;
end lm_103;

protected function lm_104
  input Tpl.Text in_txt;
  input list<DAE.ComponentRef> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_var :: rest )
      local
        list<DAE.ComponentRef> rest;
        DAE.ComponentRef i_var;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("if (change("));
        txt = cref(txt, i_var);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")) { needToIterate=1; }"));
        txt = Tpl.nextIter(txt);
        txt = lm_104(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<DAE.ComponentRef> rest;
      equation
        txt = lm_104(txt, rest);
      then txt;
  end matchcontinue;
end lm_104;

public function functionCheckForDiscreteVarChanges
  input Tpl.Text txt;
  input list<SimCode.HelpVarInfo> i_helpVarInfo;
  input list<DAE.ComponentRef> i_discreteModelVars;

  output Tpl.Text out_txt;
algorithm
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "int checkForDiscreteVarChanges()\n",
                                   "{\n",
                                   "  int needToIterate = 0;\n",
                                   "\n"
                               }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.pushIter(out_txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  out_txt := lm_103(out_txt, i_helpVarInfo);
  out_txt := Tpl.popIter(out_txt);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_NEW_LINE());
  out_txt := Tpl.pushIter(out_txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  out_txt := lm_104(out_txt, i_discreteModelVars);
  out_txt := Tpl.popIter(out_txt);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\n",
                                       "for (long i = 0; i < localData->nHelpVars; i++) {\n",
                                       "  if (change(localData->helpVars[i])) {\n",
                                       "    needToIterate=1;\n",
                                       "  }\n",
                                       "}\n",
                                       "\n",
                                       "return needToIterate;\n"
                                   }, true));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("}"));
end functionCheckForDiscreteVarChanges;

protected function lm_106
  input Tpl.Text in_txt;
  input list<DAELow.ZeroCrossing> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           DAELow.ZERO_CROSSING(relation_ = i_relation__) :: rest,
           i_varDecls )
      local
        list<DAELow.ZeroCrossing> rest;
        DAE.Exp i_relation__;
        Integer i_i0;
      equation
        i_i0 = Tpl.getIteri_i0(txt);
        (txt, i_varDecls) = zeroCrossingTpl(txt, i_i0, i_relation__, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_106(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<DAELow.ZeroCrossing> rest;
      equation
        (txt, i_varDecls) = lm_106(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_106;

public function zeroCrossingsTpl
  input Tpl.Text txt;
  input list<DAELow.ZeroCrossing> i_zeroCrossings;
  input Tpl.Text i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  out_txt := Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (out_txt, out_i_varDecls) := lm_106(out_txt, i_zeroCrossings, i_varDecls);
  out_txt := Tpl.popIter(out_txt);
end zeroCrossingsTpl;

protected function fun_108
  input Tpl.Text in_txt;
  input DAE.Exp in_i_relation;
  input Integer in_i_index;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_relation, in_i_index, in_i_varDecls)
    local
      Tpl.Text txt;
      Integer i_index;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.RELATION(exp1 = i_exp1, operator = i_operator, exp2 = i_exp2),
           i_index,
           i_varDecls )
      local
        DAE.Exp i_exp2;
        DAE.Operator i_operator;
        DAE.Exp i_exp1;
        Tpl.Text i_e2;
        Tpl.Text i_op;
        Tpl.Text i_e1;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_e1, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp1, SimCode.contextOther, i_preExp, i_varDecls);
        i_op = zeroCrossingOpFunc(emptyTxt, i_operator);
        (i_e2, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp2, SimCode.contextOther, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("ZEROCROSSING("));
        txt = Tpl.writeStr(txt, intString(i_index));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_op);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("));"));
      then (txt, i_varDecls);

    case ( txt,
           DAE.CALL(path = Absyn.IDENT(name = "sample"), expLst = {i_start, i_interval}),
           i_index,
           i_varDecls )
      local
        DAE.Exp i_interval;
        DAE.Exp i_start;
        Tpl.Text i_e2;
        Tpl.Text i_e1;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_e1, i_preExp, i_varDecls) = daeExp(emptyTxt, i_start, SimCode.contextOther, i_preExp, i_varDecls);
        (i_e2, i_preExp, i_varDecls) = daeExp(emptyTxt, i_interval, SimCode.contextOther, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("ZEROCROSSING("));
        txt = Tpl.writeStr(txt, intString(i_index));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", Sample(*t, "));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("));"));
      then (txt, i_varDecls);

    case ( txt,
           _,
           _,
           i_varDecls )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("ZERO CROSSING ERROR"));
      then (txt, i_varDecls);
  end matchcontinue;
end fun_108;

public function zeroCrossingTpl
  input Tpl.Text txt;
  input Integer i_index;
  input DAE.Exp i_relation;
  input Tpl.Text i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) := fun_108(txt, i_relation, i_index, i_varDecls);
end zeroCrossingTpl;

public function zeroCrossingOpFunc
  input Tpl.Text in_txt;
  input DAE.Operator in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.LESS(ty = _) )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("Less"));
      then txt;

    case ( txt,
           DAE.GREATER(ty = _) )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("Greater"));
      then txt;

    case ( txt,
           DAE.LESSEQ(ty = _) )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("LessEq"));
      then txt;

    case ( txt,
           DAE.GREATEREQ(ty = _) )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("GreaterEq"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end zeroCrossingOpFunc;

protected function lm_111
  input Tpl.Text in_txt;
  input list<DAE.Statement> in_items;
  input Tpl.Text in_i_varDecls;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDecls,
           _ )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls,
           i_context )
      local
        list<DAE.Statement> rest;
        DAE.Statement i_it;
      equation
        (txt, i_varDecls) = algStatement(txt, i_it, i_context, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_111(txt, rest, i_varDecls, i_context);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_context )
      local
        list<DAE.Statement> rest;
      equation
        (txt, i_varDecls) = lm_111(txt, rest, i_varDecls, i_context);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_111;

protected function fun_112
  input Tpl.Text in_txt;
  input Boolean in_i_partOfMixed;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_partOfMixed)
    local
      Tpl.Text txt;

    case ( txt,
           false )
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_mixed"));
      then txt;
  end matchcontinue;
end fun_112;

protected function lm_113
  input Tpl.Text in_txt;
  input list<tuple<Integer, Integer, SimCode.SimEqSystem>> in_items;
  input Tpl.Text in_i_size;
  input Tpl.Text in_i_aname;
  input Tpl.Text in_i_varDecls;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_size, in_i_aname, in_i_varDecls, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_size;
      Tpl.Text i_aname;
      Tpl.Text i_varDecls;
      SimCode.Context i_context;

    case ( txt,
           {},
           _,
           _,
           i_varDecls,
           _ )
      then (txt, i_varDecls);

    case ( txt,
           (i_row, i_col, (i_eq as SimCode.SES_RESIDUAL(exp = i_eq_exp))) :: rest,
           i_size,
           i_aname,
           i_varDecls,
           i_context )
      local
        list<tuple<Integer, Integer, SimCode.SimEqSystem>> rest;
        DAE.Exp i_eq_exp;
        SimCode.SimEqSystem i_eq;
        Integer i_col;
        Integer i_row;
        Tpl.Text i_expPart;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_expPart, i_preExp, i_varDecls) = daeExp(emptyTxt, i_eq_exp, i_context, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("set_matrix_elt("));
        txt = Tpl.writeText(txt, i_aname);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeStr(txt, intString(i_row));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeStr(txt, intString(i_col));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_size);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_expPart);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_113(txt, rest, i_size, i_aname, i_varDecls, i_context);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_size,
           i_aname,
           i_varDecls,
           i_context )
      local
        list<tuple<Integer, Integer, SimCode.SimEqSystem>> rest;
      equation
        (txt, i_varDecls) = lm_113(txt, rest, i_size, i_aname, i_varDecls, i_context);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_113;

protected function lm_114
  input Tpl.Text in_txt;
  input list<DAE.Exp> in_items;
  input Tpl.Text in_i_bname;
  input Tpl.Text in_i_varDecls;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_bname, in_i_varDecls, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_bname;
      Tpl.Text i_varDecls;
      SimCode.Context i_context;

    case ( txt,
           {},
           _,
           i_varDecls,
           _ )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_bname,
           i_varDecls,
           i_context )
      local
        list<DAE.Exp> rest;
        DAE.Exp i_it;
        Integer i_i0;
        Tpl.Text i_expPart;
        Tpl.Text i_preExp;
      equation
        i_i0 = Tpl.getIteri_i0(txt);
        i_preExp = emptyTxt;
        (i_expPart, i_preExp, i_varDecls) = daeExp(emptyTxt, i_it, i_context, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("set_vector_elt("));
        txt = Tpl.writeText(txt, i_bname);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeStr(txt, intString(i_i0));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_expPart);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_114(txt, rest, i_bname, i_varDecls, i_context);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_bname,
           i_varDecls,
           i_context )
      local
        list<DAE.Exp> rest;
      equation
        (txt, i_varDecls) = lm_114(txt, rest, i_bname, i_varDecls, i_context);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_114;

protected function lm_115
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;
  input Tpl.Text in_i_bname;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items, in_i_bname)
    local
      Tpl.Text txt;
      Tpl.Text i_bname;

    case ( txt,
           {},
           _ )
      then txt;

    case ( txt,
           SimCode.SIMVAR(name = it_it_name) :: rest,
           i_bname )
      local
        list<SimCode.SimVar> rest;
        DAE.ComponentRef it_it_name;
        Integer i_i0;
      equation
        i_i0 = Tpl.getIteri_i0(txt);
        txt = cref(txt, it_it_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = get_vector_elt("));
        txt = Tpl.writeText(txt, i_bname);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeStr(txt, intString(i_i0));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
        txt = Tpl.nextIter(txt);
        txt = lm_115(txt, rest, i_bname);
      then txt;

    case ( txt,
           _ :: rest,
           i_bname )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_115(txt, rest, i_bname);
      then txt;
  end matchcontinue;
end lm_115;

protected function lm_116
  input Tpl.Text in_txt;
  input list<SimCode.SimEqSystem> in_items;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preDisc;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preDisc;
algorithm
  (out_txt, out_i_varDecls, out_i_preDisc) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_preDisc, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_preDisc;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDecls,
           i_preDisc,
           _ )
      then (txt, i_varDecls, i_preDisc);

    case ( txt,
           SimCode.SES_SIMPLE_ASSIGN(exp = i_exp, componentRef = i_componentRef) :: rest,
           i_varDecls,
           i_preDisc,
           i_context )
      local
        list<SimCode.SimEqSystem> rest;
        DAE.ComponentRef i_componentRef;
        DAE.Exp i_exp;
        Integer i_i0;
        Tpl.Text i_expPart;
      equation
        i_i0 = Tpl.getIteri_i0(txt);
        (i_expPart, i_preDisc, i_varDecls) = daeExp(emptyTxt, i_exp, i_context, i_preDisc, i_varDecls);
        txt = cref(txt, i_componentRef);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = "));
        txt = Tpl.writeText(txt, i_expPart);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    ";\n",
                                    "discrete_loc2["
                                }, false));
        txt = Tpl.writeStr(txt, intString(i_i0));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("] = "));
        txt = cref(txt, i_componentRef);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls, i_preDisc) = lm_116(txt, rest, i_varDecls, i_preDisc, i_context);
      then (txt, i_varDecls, i_preDisc);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_preDisc,
           i_context )
      local
        list<SimCode.SimEqSystem> rest;
      equation
        (txt, i_varDecls, i_preDisc) = lm_116(txt, rest, i_varDecls, i_preDisc, i_context);
      then (txt, i_varDecls, i_preDisc);
  end matchcontinue;
end lm_116;

protected function lm_117
  input Tpl.Text in_txt;
  input list<String> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<String> rest;
        String i_it;
      equation
        txt = Tpl.writeStr(txt, i_it);
        txt = Tpl.nextIter(txt);
        txt = lm_117(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<String> rest;
      equation
        txt = lm_117(txt, rest);
      then txt;
  end matchcontinue;
end lm_117;

protected function lm_118
  input Tpl.Text in_txt;
  input list<Integer> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<Integer> rest;
        Integer i_it;
      equation
        txt = Tpl.writeStr(txt, intString(i_it));
        txt = Tpl.nextIter(txt);
        txt = lm_118(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<Integer> rest;
      equation
        txt = lm_118(txt, rest);
      then txt;
  end matchcontinue;
end lm_118;

protected function lm_119
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(name = it_it_name) :: rest )
      local
        list<SimCode.SimVar> rest;
        DAE.ComponentRef it_it_name;
        Integer i_i0;
      equation
        i_i0 = Tpl.getIteri_i0(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("discrete_loc["));
        txt = Tpl.writeStr(txt, intString(i_i0));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("] = "));
        txt = cref(txt, it_it_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
        txt = Tpl.nextIter(txt);
        txt = lm_119(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_119(txt, rest);
      then txt;
  end matchcontinue;
end lm_119;

protected function lm_120
  input Tpl.Text in_txt;
  input list<SimCode.SimVar> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.SIMVAR(name = i_name) :: rest )
      local
        list<SimCode.SimVar> rest;
        DAE.ComponentRef i_name;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("&"));
        txt = cref(txt, i_name);
        txt = Tpl.nextIter(txt);
        txt = lm_120(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimVar> rest;
      equation
        txt = lm_120(txt, rest);
      then txt;
  end matchcontinue;
end lm_120;

protected function lm_121
  input Tpl.Text in_txt;
  input list<DAE.ComponentRef> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<DAE.ComponentRef> rest;
        DAE.ComponentRef i_it;
        Integer i_i0;
      equation
        i_i0 = Tpl.getIteri_i0(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("nls_x["));
        txt = Tpl.writeStr(txt, intString(i_i0));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("] = extraPolate("));
        txt = cref(txt, i_it);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("nls_xold["));
        txt = Tpl.writeStr(txt, intString(i_i0));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("] = old(&"));
        txt = cref(txt, i_it);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
        txt = Tpl.nextIter(txt);
        txt = lm_121(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<DAE.ComponentRef> rest;
      equation
        txt = lm_121(txt, rest);
      then txt;
  end matchcontinue;
end lm_121;

protected function lm_122
  input Tpl.Text in_txt;
  input list<DAE.ComponentRef> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<DAE.ComponentRef> rest;
        DAE.ComponentRef i_it;
        Integer i_i0;
      equation
        i_i0 = Tpl.getIteri_i0(txt);
        txt = cref(txt, i_it);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = nls_x["));
        txt = Tpl.writeStr(txt, intString(i_i0));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("];"));
        txt = Tpl.nextIter(txt);
        txt = lm_122(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<DAE.ComponentRef> rest;
      equation
        txt = lm_122(txt, rest);
      then txt;
  end matchcontinue;
end lm_122;

protected function lm_123
  input Tpl.Text in_txt;
  input list<tuple<DAE.Exp, Integer>> in_items;
  input Tpl.Text in_i_helpInits;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_helpInits;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_helpInits, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_items, in_i_helpInits, in_i_varDecls, in_i_preExp, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_helpInits;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_helpInits,
           i_varDecls,
           i_preExp,
           _ )
      then (txt, i_helpInits, i_varDecls, i_preExp);

    case ( txt,
           (i_e, i_hidx) :: rest,
           i_helpInits,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<tuple<DAE.Exp, Integer>> rest;
        Integer i_hidx;
        DAE.Exp i_e;
        Tpl.Text i_helpInit;
      equation
        (i_helpInit, i_preExp, i_varDecls) = daeExp(emptyTxt, i_e, i_context, i_preExp, i_varDecls);
        i_helpInits = Tpl.writeTok(i_helpInits, Tpl.ST_STRING("localData->helpVars["));
        i_helpInits = Tpl.writeStr(i_helpInits, intString(i_hidx));
        i_helpInits = Tpl.writeTok(i_helpInits, Tpl.ST_STRING("] = "));
        i_helpInits = Tpl.writeText(i_helpInits, i_helpInit);
        i_helpInits = Tpl.writeTok(i_helpInits, Tpl.ST_STRING(";"));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("edge(localData->helpVars["));
        txt = Tpl.writeStr(txt, intString(i_hidx));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("])"));
        txt = Tpl.nextIter(txt);
        (txt, i_helpInits, i_varDecls, i_preExp) = lm_123(txt, rest, i_helpInits, i_varDecls, i_preExp, i_context);
      then (txt, i_helpInits, i_varDecls, i_preExp);

    case ( txt,
           _ :: rest,
           i_helpInits,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<tuple<DAE.Exp, Integer>> rest;
      equation
        (txt, i_helpInits, i_varDecls, i_preExp) = lm_123(txt, rest, i_helpInits, i_varDecls, i_preExp, i_context);
      then (txt, i_helpInits, i_varDecls, i_preExp);
  end matchcontinue;
end lm_123;

public function equation_
  input Tpl.Text in_txt;
  input SimCode.SimEqSystem in_i_eq;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_eq, in_i_context, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_varDecls;

    case ( txt,
           SimCode.SES_SIMPLE_ASSIGN(exp = i_exp, componentRef = i_componentRef),
           i_context,
           i_varDecls )
      local
        DAE.ComponentRef i_componentRef;
        DAE.Exp i_exp;
        Tpl.Text i_expPart;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_expPart, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, i_context, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = cref(txt, i_componentRef);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = "));
        txt = Tpl.writeText(txt, i_expPart);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
      then (txt, i_varDecls);

    case ( txt,
           SimCode.SES_ARRAY_CALL_ASSIGN(exp = i_exp, componentRef = i_componentRef),
           i_context,
           i_varDecls )
      local
        DAE.ComponentRef i_componentRef;
        DAE.Exp i_exp;
        Tpl.Text i_expPart;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_expPart, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, i_context, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("copy_real_array_data_mem(&"));
        txt = Tpl.writeText(txt, i_expPart);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", &"));
        txt = cref(txt, i_componentRef);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
      then (txt, i_varDecls);

    case ( txt,
           SimCode.SES_ALGORITHM(statements = i_statements),
           i_context,
           i_varDecls )
      local
        list<DAE.Statement> i_statements;
        Tpl.Text i_stmts;
      equation
        i_stmts = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_stmts, i_varDecls) = lm_111(i_stmts, i_statements, i_varDecls, i_context);
        i_stmts = Tpl.popIter(i_stmts);
        txt = Tpl.writeText(txt, i_stmts);
      then (txt, i_varDecls);

    case ( txt,
           SimCode.SES_LINEAR(vars = i_vars, partOfMixed = i_partOfMixed, simJac = i_simJac, beqs = i_beqs),
           i_context,
           i_varDecls )
      local
        list<DAE.Exp> i_beqs;
        list<tuple<Integer, Integer, SimCode.SimEqSystem>> i_simJac;
        Boolean i_partOfMixed;
        list<SimCode.SimVar> i_vars;
        Tpl.Text i_mixedPostfix;
        Tpl.Text i_bname;
        Tpl.Text i_aname;
        Integer ret_3;
        Tpl.Text i_size;
        Integer ret_1;
        Tpl.Text i_uid;
      equation
        ret_1 = System.tmpTick();
        i_uid = Tpl.writeStr(emptyTxt, intString(ret_1));
        ret_3 = listLength(i_vars);
        i_size = Tpl.writeStr(emptyTxt, intString(ret_3));
        i_aname = Tpl.writeTok(emptyTxt, Tpl.ST_STRING("A"));
        i_aname = Tpl.writeText(i_aname, i_uid);
        i_bname = Tpl.writeTok(emptyTxt, Tpl.ST_STRING("b"));
        i_bname = Tpl.writeText(i_bname, i_uid);
        i_mixedPostfix = fun_112(emptyTxt, i_partOfMixed);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("declare_matrix("));
        txt = Tpl.writeText(txt, i_aname);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_size);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_size);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    ");\n",
                                    "declare_vector("
                                }, false));
        txt = Tpl.writeText(txt, i_bname);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_size);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(");\n"));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (txt, i_varDecls) = lm_113(txt, i_simJac, i_size, i_aname, i_varDecls, i_context);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (txt, i_varDecls) = lm_114(txt, i_beqs, i_bname, i_varDecls, i_context);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("solve_linear_equation_system"));
        txt = Tpl.writeText(txt, i_mixedPostfix);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_aname);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_bname);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_size);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_uid);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(");\n"));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_115(txt, i_vars, i_bname);
        txt = Tpl.popIter(txt);
      then (txt, i_varDecls);

    case ( txt,
           SimCode.SES_MIXED(cont = i_cont, discVars = i_discVars, values = i_values, discEqs = i_discEqs, value_dims = i_value__dims),
           i_context,
           i_varDecls )
      local
        list<Integer> i_value__dims;
        list<SimCode.SimEqSystem> i_discEqs;
        list<String> i_values;
        list<SimCode.SimVar> i_discVars;
        SimCode.SimEqSystem i_cont;
        Tpl.Text i_discLoc2;
        Tpl.Text i_preDisc;
        Integer ret_4;
        Tpl.Text i_valuesLenStr;
        Integer ret_2;
        Tpl.Text i_numDiscVarsStr;
        Tpl.Text i_contEqs;
      equation
        (i_contEqs, i_varDecls) = equation_(emptyTxt, i_cont, i_context, i_varDecls);
        ret_2 = listLength(i_discVars);
        i_numDiscVarsStr = Tpl.writeStr(emptyTxt, intString(ret_2));
        ret_4 = listLength(i_values);
        i_valuesLenStr = Tpl.writeStr(emptyTxt, intString(ret_4));
        i_preDisc = emptyTxt;
        i_discLoc2 = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_discLoc2, i_varDecls, i_preDisc) = lm_116(i_discLoc2, i_discEqs, i_varDecls, i_preDisc, i_context);
        i_discLoc2 = Tpl.popIter(i_discLoc2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("mixed_equation_system("));
        txt = Tpl.writeText(txt, i_numDiscVarsStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    ");\n",
                                    "double values["
                                }, false));
        txt = Tpl.writeText(txt, i_valuesLenStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("] = {"));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_117(txt, i_values);
        txt = Tpl.popIter(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "};\n",
                                    "int value_dims["
                                }, false));
        txt = Tpl.writeText(txt, i_numDiscVarsStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("] = {"));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_118(txt, i_value__dims);
        txt = Tpl.popIter(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("};\n"));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_119(txt, i_discVars);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("{\n"));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.writeText(txt, i_contEqs);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("}\n"));
        txt = Tpl.writeText(txt, i_preDisc);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeText(txt, i_discLoc2);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("{\n"));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("double *loc_ptrs["));
        txt = Tpl.writeText(txt, i_numDiscVarsStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("] = {"));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_120(txt, i_discVars);
        txt = Tpl.popIter(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "};\n",
                                    "check_discrete_values("
                                }, false));
        txt = Tpl.writeText(txt, i_numDiscVarsStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_valuesLenStr);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(");\n"));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "}\n",
                                    "mixed_equation_system_end("
                                }, false));
        txt = Tpl.writeText(txt, i_numDiscVarsStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
      then (txt, i_varDecls);

    case ( txt,
           SimCode.SES_NONLINEAR(crefs = i_crefs, index = i_index),
           _,
           i_varDecls )
      local
        Integer i_index;
        list<DAE.ComponentRef> i_crefs;
        Integer ret_1;
        Tpl.Text i_size;
      equation
        ret_1 = listLength(i_crefs);
        i_size = Tpl.writeStr(emptyTxt, intString(ret_1));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("start_nonlinear_system("));
        txt = Tpl.writeText(txt, i_size);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(");\n"));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_121(txt, i_crefs);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("solve_nonlinear_system(residualFunc"));
        txt = Tpl.writeStr(txt, intString(i_index));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeStr(txt, intString(i_index));
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(");\n"));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_122(txt, i_crefs);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("end_nonlinear_system();"));
      then (txt, i_varDecls);

    case ( txt,
           SimCode.SES_WHEN(conditions = i_conditions, right = i_right, left = i_left),
           i_context,
           i_varDecls )
      local
        DAE.ComponentRef i_left;
        DAE.Exp i_right;
        list<tuple<DAE.Exp, Integer>> i_conditions;
        Tpl.Text i_exp;
        Tpl.Text i_preExp2;
        Tpl.Text i_helpIf;
        Tpl.Text i_helpInits;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        i_helpInits = emptyTxt;
        i_helpIf = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(" || ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_helpIf, i_helpInits, i_varDecls, i_preExp) = lm_123(i_helpIf, i_conditions, i_helpInits, i_varDecls, i_preExp, i_context);
        i_helpIf = Tpl.popIter(i_helpIf);
        i_preExp2 = emptyTxt;
        (i_exp, i_preExp2, i_varDecls) = daeExp(emptyTxt, i_right, i_context, i_preExp2, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeText(txt, i_helpInits);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("if ("));
        txt = Tpl.writeText(txt, i_helpIf);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(") {\n"));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.writeText(txt, i_preExp2);
        txt = Tpl.softNewLine(txt);
        txt = cref(txt, i_left);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = "));
        txt = Tpl.writeText(txt, i_exp);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(";\n"));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("} else {\n"));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = cref(txt, i_left);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = pre("));
        txt = cref(txt, i_left);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(");\n"));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("}"));
      then (txt, i_varDecls);

    case ( txt,
           _,
           _,
           i_varDecls )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("notimplemented = notimplemented;"));
      then (txt, i_varDecls);
  end matchcontinue;
end equation_;

public function functionsFile2
  input Tpl.Text txt;
  input list<SimCode.Function> i_functions;

  output Tpl.Text out_txt;
algorithm
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "#include \"modelica.h\"\n",
                                   "#include <stdio.h>\n",
                                   "#include <stdlib.h>\n",
                                   "#include <errno.h>\n",
                                   "\n",
                                   "#if defined(_MSC_VER)\n",
                                   "  #define DLLExport   __declspec( dllexport )\n",
                                   "#else\n",
                                   "  #define DLLExport /* nothing */\n",
                                   "#endif\n",
                                   "\n",
                                   "#if !defined(MODELICA_ASSERT)\n",
                                   "  #define MODELICA_ASSERT(cond,msg) { if (!(cond)) fprintf(stderr,\"Modelica Assert: %s!\\n\", msg); }\n",
                                   "#endif\n",
                                   "#if !defined(MODELICA_TERMINATE)\n",
                                   "  #define MODELICA_TERMINATE(msg) { fprintf(stderr,\"Modelica Terminate: %s!\\n\", msg); fflush(stderr); }\n",
                                   "#endif\n",
                                   "\n",
                                   "\n",
                                   "#ifdef __cplusplus\n",
                                   "extern \"C\" {\n",
                                   "#endif\n",
                                   "\n",
                                   "/* Header */\n"
                               }, true));
  out_txt := externalFunctionIncludes(out_txt, i_functions);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := functionHeaders(out_txt, i_functions);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "/* End Header */\n",
                                       "\n",
                                       "/* Body */\n"
                                   }, true));
  out_txt := functionBodies(out_txt, i_functions);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "/* End Body */\n",
                                       "\n",
                                       "#ifdef __cplusplus\n",
                                       "}\n",
                                       "#endif"
                                   }, false));
end functionsFile2;

public function functionsFile
  input Tpl.Text txt;
  input list<SimCode.Function> i_functions;

  output Tpl.Text out_txt;
algorithm
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "#ifdef __cplusplus\n",
                                   "extern \"C\" {\n",
                                   "#endif\n",
                                   "\n",
                                   "/* Header */\n"
                               }, true));
  out_txt := externalFunctionIncludes(out_txt, i_functions);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := functionHeaders(out_txt, i_functions);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "/* End Header */\n",
                                       "\n",
                                       "/* Body */\n"
                                   }, true));
  out_txt := functionBodies(out_txt, i_functions);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "/* End Body */\n",
                                       "\n",
                                       "#ifdef __cplusplus\n",
                                       "}\n",
                                       "#endif"
                                   }, false));
end functionsFile;

protected function lm_127
  input Tpl.Text in_txt;
  input list<String> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<String> rest;
        String i_it;
      equation
        txt = Tpl.writeStr(txt, i_it);
        txt = Tpl.nextIter(txt);
        txt = lm_127(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<String> rest;
      equation
        txt = lm_127(txt, rest);
      then txt;
  end matchcontinue;
end lm_127;

public function makefileFunction
  input Tpl.Text in_txt;
  input SimCode.FunctionCode in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.FUNCTIONCODE(makefileParams = SimCode.MAKEFILE_PARAMS(libs = i_makefileParams_libs, ccompiler = i_makefileParams_ccompiler, cxxcompiler = i_makefileParams_cxxcompiler, linker = i_makefileParams_linker, exeext = i_makefileParams_exeext, dllext = i_makefileParams_dllext, omhome = i_makefileParams_omhome, cflags = i_makefileParams_cflags, ldflags = i_makefileParams_ldflags), name = i_name) )
      local
        String i_name;
        String i_makefileParams_ldflags;
        String i_makefileParams_cflags;
        String i_makefileParams_omhome;
        String i_makefileParams_dllext;
        String i_makefileParams_exeext;
        String i_makefileParams_linker;
        String i_makefileParams_cxxcompiler;
        String i_makefileParams_ccompiler;
        list<String> i_makefileParams_libs;
        Tpl.Text i_libsStr;
      equation
        i_libsStr = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(" ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        i_libsStr = lm_127(i_libsStr, i_makefileParams_libs);
        i_libsStr = Tpl.popIter(i_libsStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "# Makefile generated by OpenModelica\n",
                                    "\n",
                                    "CC="
                                }, false));
        txt = Tpl.writeStr(txt, i_makefileParams_ccompiler);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("CXX="));
        txt = Tpl.writeStr(txt, i_makefileParams_cxxcompiler);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("LINK="));
        txt = Tpl.writeStr(txt, i_makefileParams_linker);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("EXEEXT="));
        txt = Tpl.writeStr(txt, i_makefileParams_exeext);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("DLLEXT="));
        txt = Tpl.writeStr(txt, i_makefileParams_dllext);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("CFLAGS= -I\""));
        txt = Tpl.writeStr(txt, i_makefileParams_omhome);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("/include\" "));
        txt = Tpl.writeStr(txt, i_makefileParams_cflags);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("LDFLAGS= -L\""));
        txt = Tpl.writeStr(txt, i_makefileParams_omhome);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("/lib\" "));
        txt = Tpl.writeStr(txt, i_makefileParams_ldflags);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "\n",
                                    ".PHONY: "
                                }, false));
        txt = Tpl.writeStr(txt, i_name);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeStr(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(": "));
        txt = Tpl.writeStr(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(".c\n"));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("\t"));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" $(LINK) $(CFLAGS) -o "));
        txt = Tpl.writeStr(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("$(DLLEXT) "));
        txt = Tpl.writeStr(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(".c $(LDFLAGS) "));
        txt = Tpl.writeText(txt, i_libsStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" -lm"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end makefileFunction;

protected function fun_129
  input Tpl.Text in_txt;
  input String in_i_modelInfo_directory;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_modelInfo_directory)
    local
      Tpl.Text txt;

    case ( txt,
           "" )
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("-L\"<modelInfo.directory>\""));
      then txt;
  end matchcontinue;
end fun_129;

protected function lm_130
  input Tpl.Text in_txt;
  input list<String> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<String> rest;
        String i_it;
      equation
        txt = Tpl.writeStr(txt, i_it);
        txt = Tpl.nextIter(txt);
        txt = lm_130(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<String> rest;
      equation
        txt = lm_130(txt, rest);
      then txt;
  end matchcontinue;
end lm_130;

public function makefile
  input Tpl.Text in_txt;
  input SimCode.SimCode in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.SIMCODE(modelInfo = SimCode.MODELINFO(directory = i_modelInfo_directory, name = i_modelInfo_name), makefileParams = SimCode.MAKEFILE_PARAMS(libs = i_makefileParams_libs, ccompiler = i_makefileParams_ccompiler, cxxcompiler = i_makefileParams_cxxcompiler, linker = i_makefileParams_linker, exeext = i_makefileParams_exeext, dllext = i_makefileParams_dllext, omhome = i_makefileParams_omhome, cflags = i_makefileParams_cflags, ldflags = i_makefileParams_ldflags)) )
      local
        String i_makefileParams_ldflags;
        String i_makefileParams_cflags;
        String i_makefileParams_omhome;
        String i_makefileParams_dllext;
        String i_makefileParams_exeext;
        String i_makefileParams_linker;
        String i_makefileParams_cxxcompiler;
        String i_makefileParams_ccompiler;
        list<String> i_makefileParams_libs;
        String i_modelInfo_name;
        String i_modelInfo_directory;
        Tpl.Text i_libsStr;
        Tpl.Text i_dirExtra;
      equation
        i_dirExtra = fun_129(emptyTxt, i_modelInfo_directory);
        i_libsStr = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(" ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        i_libsStr = lm_130(i_libsStr, i_makefileParams_libs);
        i_libsStr = Tpl.popIter(i_libsStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "# Makefile generated by OpenModelica\n",
                                    "\n",
                                    "CC="
                                }, false));
        txt = Tpl.writeStr(txt, i_makefileParams_ccompiler);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("CXX="));
        txt = Tpl.writeStr(txt, i_makefileParams_cxxcompiler);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("LINK="));
        txt = Tpl.writeStr(txt, i_makefileParams_linker);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("EXEEXT="));
        txt = Tpl.writeStr(txt, i_makefileParams_exeext);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("DLLEXT="));
        txt = Tpl.writeStr(txt, i_makefileParams_dllext);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("CFLAGS= -I\""));
        txt = Tpl.writeStr(txt, i_makefileParams_omhome);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("/include\" "));
        txt = Tpl.writeStr(txt, i_makefileParams_cflags);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("LDFLAGS= -L\""));
        txt = Tpl.writeStr(txt, i_makefileParams_omhome);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("/lib\" "));
        txt = Tpl.writeStr(txt, i_makefileParams_ldflags);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "\n",
                                    ".PHONY: "
                                }, false));
        txt = Tpl.writeStr(txt, i_modelInfo_name);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeStr(txt, i_modelInfo_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(": "));
        txt = Tpl.writeStr(txt, i_modelInfo_name);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(".cpp\n"));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("\t"));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" $(CXX) $(CFLAGS) -I. -o "));
        txt = Tpl.writeStr(txt, i_modelInfo_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("$(EXEEXT) "));
        txt = Tpl.writeStr(txt, i_modelInfo_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(".cpp "));
        txt = Tpl.writeText(txt, i_dirExtra);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" -lsim $(LDFLAGS) -lf2c ${SENDDATALIBS} "));
        txt = Tpl.writeText(txt, i_libsStr);
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end makefile;

public function cref
  input Tpl.Text in_txt;
  input DAE.ComponentRef in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.CREF_IDENT(ident = i_ident) )
      local
        DAE.Ident i_ident;
      equation
        txt = Tpl.writeStr(txt, i_ident);
      then txt;

    case ( txt,
           DAE.CREF_QUAL(ident = i_ident, componentRef = i_componentRef) )
      local
        DAE.ComponentRef i_componentRef;
        DAE.Ident i_ident;
      equation
        txt = Tpl.writeStr(txt, i_ident);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("."));
        txt = cref(txt, i_componentRef);
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("CREF_NOT_IDENT_OR_QUAL"));
      then txt;
  end matchcontinue;
end cref;

public function crefSubscript
  input Tpl.Text in_txt;
  input DAE.ComponentRef in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.CREF_IDENT(ident = i_ident, subscriptLst = i_subscriptLst) )
      local
        list<DAE.Subscript> i_subscriptLst;
        DAE.Ident i_ident;
      equation
        txt = Tpl.writeStr(txt, i_ident);
        txt = subscriptsTpl(txt, i_subscriptLst);
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("CREF_NOT_IDENT"));
      then txt;
  end matchcontinue;
end crefSubscript;

protected function lm_134
  input Tpl.Text in_txt;
  input list<DAE.Subscript> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_s :: rest )
      local
        list<DAE.Subscript> rest;
        DAE.Subscript i_s;
      equation
        txt = subscriptTpl(txt, i_s);
        txt = Tpl.nextIter(txt);
        txt = lm_134(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<DAE.Subscript> rest;
      equation
        txt = lm_134(txt, rest);
      then txt;
  end matchcontinue;
end lm_134;

public function subscriptsTpl
  input Tpl.Text in_txt;
  input list<DAE.Subscript> in_i_subscripts;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_subscripts)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_subscripts )
      local
        list<DAE.Subscript> i_subscripts;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("["));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(",")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_134(txt, i_subscripts);
        txt = Tpl.popIter(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("]"));
      then txt;
  end matchcontinue;
end subscriptsTpl;

protected function fun_136
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_exp)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.ICONST(integer = i_integer) )
      local
        Integer i_integer;
      equation
        txt = Tpl.writeStr(txt, intString(i_integer));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("SUBSCRIPT_NOT_CONSTANT"));
      then txt;
  end matchcontinue;
end fun_136;

public function subscriptTpl
  input Tpl.Text in_txt;
  input DAE.Subscript in_i_subscript;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_subscript)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.INDEX(exp = i_exp) )
      local
        DAE.Exp i_exp;
      equation
        txt = fun_136(txt, i_exp);
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("SUBSCRIPT_NOT_CONSTANT"));
      then txt;
  end matchcontinue;
end subscriptTpl;

public function dotPath
  input Tpl.Text in_txt;
  input Absyn.Path in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           Absyn.QUALIFIED(name = i_name, path = i_path) )
      local
        Absyn.Path i_path;
        Absyn.Ident i_name;
      equation
        txt = Tpl.writeStr(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("."));
        txt = dotPath(txt, i_path);
      then txt;

    case ( txt,
           Absyn.IDENT(name = i_name) )
      local
        Absyn.Ident i_name;
      equation
        txt = Tpl.writeStr(txt, i_name);
      then txt;

    case ( txt,
           Absyn.FULLYQUALIFIED(path = i_path) )
      local
        Absyn.Path i_path;
      equation
        txt = dotPath(txt, i_path);
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end dotPath;

public function underscorePath
  input Tpl.Text in_txt;
  input Absyn.Path in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           Absyn.QUALIFIED(name = i_name, path = i_path) )
      local
        Absyn.Path i_path;
        Absyn.Ident i_name;
        String ret_0;
      equation
        ret_0 = System.stringReplace(i_name, "_", "__");
        txt = Tpl.writeStr(txt, ret_0);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_"));
        txt = underscorePath(txt, i_path);
      then txt;

    case ( txt,
           Absyn.IDENT(name = i_name) )
      local
        Absyn.Ident i_name;
        String ret_0;
      equation
        ret_0 = System.stringReplace(i_name, "_", "__");
        txt = Tpl.writeStr(txt, ret_0);
      then txt;

    case ( txt,
           Absyn.FULLYQUALIFIED(path = i_path) )
      local
        Absyn.Path i_path;
      equation
        txt = underscorePath(txt, i_path);
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end underscorePath;

protected function lm_140
  input Tpl.Text in_txt;
  input list<String> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<String> rest;
        String i_it;
      equation
        txt = Tpl.writeStr(txt, i_it);
        txt = Tpl.nextIter(txt);
        txt = lm_140(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<String> rest;
      equation
        txt = lm_140(txt, rest);
      then txt;
  end matchcontinue;
end lm_140;

protected function lm_141
  input Tpl.Text in_txt;
  input list<SimCode.Function> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.EXTERNAL_FUNCTION(includes = i_includes) :: rest )
      local
        list<SimCode.Function> rest;
        list<String> i_includes;
      equation
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_140(txt, i_includes);
        txt = Tpl.popIter(txt);
        txt = Tpl.nextIter(txt);
        txt = lm_141(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.Function> rest;
      equation
        txt = lm_141(txt, rest);
      then txt;
  end matchcontinue;
end lm_141;

public function externalFunctionIncludes
  input Tpl.Text txt;
  input list<SimCode.Function> i_functions;

  output Tpl.Text out_txt;
algorithm
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                   "#ifdef __cplusplus\n",
                                   "extern \"C\" {\n",
                                   "#endif\n"
                               }, true));
  out_txt := Tpl.pushIter(out_txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  out_txt := lm_141(out_txt, i_functions);
  out_txt := Tpl.popIter(out_txt);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "#ifdef __cplusplus\n",
                                       "}\n",
                                       "#endif"
                                   }, false));
end externalFunctionIncludes;

protected function lm_143
  input Tpl.Text in_txt;
  input list<SimCode.RecordDeclaration> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<SimCode.RecordDeclaration> rest;
        SimCode.RecordDeclaration i_it;
      equation
        txt = recordDeclaration(txt, i_it);
        txt = Tpl.nextIter(txt);
        txt = lm_143(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.RecordDeclaration> rest;
      equation
        txt = lm_143(txt, rest);
      then txt;
  end matchcontinue;
end lm_143;

protected function fun_144
  input Tpl.Text in_txt;
  input SimCode.Function in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.FUNCTION(recordDecls = i_recordDecls, name = i_name, functionArguments = i_functionArguments, outVars = i_outVars) )
      local
        SimCode.Variables i_outVars;
        list<SimCode.Variable> i_functionArguments;
        Absyn.Path i_name;
        list<SimCode.RecordDeclaration> i_recordDecls;
        Tpl.Text txt_0;
      equation
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_143(txt, i_recordDecls);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt_0 = underscorePath(emptyTxt, i_name);
        txt = functionHeader(txt, Tpl.textString(txt_0), i_functionArguments, i_outVars);
      then txt;

    case ( txt,
           (i_it as SimCode.EXTERNAL_FUNCTION(name = i_name, funArgs = i_funArgs, outVars = i_outVars)) )
      local
        list<SimCode.Variable> i_outVars;
        list<SimCode.Variable> i_funArgs;
        Absyn.Path i_name;
        SimCode.Function i_it;
        Tpl.Text txt_0;
      equation
        txt_0 = underscorePath(emptyTxt, i_name);
        txt = functionHeader(txt, Tpl.textString(txt_0), i_funArgs, i_outVars);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = extFunDef(txt, i_it);
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end fun_144;

protected function lm_145
  input Tpl.Text in_txt;
  input list<SimCode.Function> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<SimCode.Function> rest;
        SimCode.Function i_it;
      equation
        txt = fun_144(txt, i_it);
        txt = Tpl.nextIter(txt);
        txt = lm_145(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.Function> rest;
      equation
        txt = lm_145(txt, rest);
      then txt;
  end matchcontinue;
end lm_145;

public function functionHeaders
  input Tpl.Text txt;
  input list<SimCode.Function> i_functions;

  output Tpl.Text out_txt;
algorithm
  out_txt := Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  out_txt := lm_145(out_txt, i_functions);
  out_txt := Tpl.popIter(out_txt);
end functionHeaders;

protected function lm_147
  input Tpl.Text in_txt;
  input SimCode.Variables in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           (i_var as SimCode.VARIABLE(name = i_var_name)) :: rest )
      local
        SimCode.Variables rest;
        DAE.ComponentRef i_var_name;
        SimCode.Variable i_var;
      equation
        txt = varType(txt, i_var);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" "));
        txt = cref(txt, i_var_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
        txt = Tpl.nextIter(txt);
        txt = lm_147(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        SimCode.Variables rest;
      equation
        txt = lm_147(txt, rest);
      then txt;
  end matchcontinue;
end lm_147;

protected function lm_148
  input Tpl.Text in_txt;
  input SimCode.Variables in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.VARIABLE(name = i_name) :: rest )
      local
        SimCode.Variables rest;
        DAE.ComponentRef i_name;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("\""));
        txt = cref(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("\""));
        txt = Tpl.nextIter(txt);
        txt = lm_148(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        SimCode.Variables rest;
      equation
        txt = lm_148(txt, rest);
      then txt;
  end matchcontinue;
end lm_148;

public function recordDeclaration
  input Tpl.Text in_txt;
  input SimCode.RecordDeclaration in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.RECORD_DECL_FULL(name = i_name, variables = i_variables, defPath = i_defPath) )
      local
        Absyn.Path i_defPath;
        SimCode.Variables i_variables;
        SimCode.Ident i_name;
        Tpl.Text txt_2;
        Tpl.Text txt_1;
        Tpl.Text txt_0;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("struct "));
        txt = Tpl.writeStr(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(" {\n"));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_147(txt, i_variables);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("};\n"));
        txt_0 = dotPath(emptyTxt, i_defPath);
        txt_1 = underscorePath(emptyTxt, i_defPath);
        txt_2 = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(",")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt_2 = lm_148(txt_2, i_variables);
        txt_2 = Tpl.popIter(txt_2);
        txt = recordDefinition(txt, Tpl.textString(txt_0), Tpl.textString(txt_1), Tpl.textString(txt_2));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end recordDeclaration;

public function recordDefinition
  input Tpl.Text txt;
  input String i_origName;
  input String i_encName;
  input String i_fieldNames;

  output Tpl.Text out_txt;
algorithm
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING("const char* "));
  out_txt := Tpl.writeStr(out_txt, i_encName);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("__desc__fields[] = {"));
  out_txt := Tpl.writeStr(out_txt, i_fieldNames);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "};\n",
                                       "struct record_description "
                                   }, false));
  out_txt := Tpl.writeStr(out_txt, i_encName);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_LINE("__desc = {\n"));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("\""));
  out_txt := Tpl.writeStr(out_txt, i_encName);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "\", /* package_record__X */\n",
                                       "\""
                                   }, false));
  out_txt := Tpl.writeStr(out_txt, i_origName);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_LINE("\", /* package.record_X */\n"));
  out_txt := Tpl.writeStr(out_txt, i_encName);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_LINE("__desc__fields\n"));
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("};"));
end recordDefinition;

protected function lm_151
  input Tpl.Text in_txt;
  input SimCode.Variables in_items;
  input String in_i_fname;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items, in_i_fname)
    local
      Tpl.Text txt;
      String i_fname;

    case ( txt,
           {},
           _ )
      then txt;

    case ( txt,
           SimCode.VARIABLE(name = _) :: rest,
           i_fname )
      local
        SimCode.Variables rest;
        Integer i_i1;
      equation
        i_i1 = Tpl.getIteri_i1(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("#define "));
        txt = Tpl.writeStr(txt, i_fname);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_rettype_"));
        txt = Tpl.writeStr(txt, intString(i_i1));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" targ"));
        txt = Tpl.writeStr(txt, intString(i_i1));
        txt = Tpl.nextIter(txt);
        txt = lm_151(txt, rest, i_fname);
      then txt;

    case ( txt,
           _ :: rest,
           i_fname )
      local
        SimCode.Variables rest;
      equation
        txt = lm_151(txt, rest, i_fname);
      then txt;
  end matchcontinue;
end lm_151;

protected function fun_152
  input Tpl.Text in_txt;
  input Option<Integer> in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           SOME(i_d) )
      local
        Integer i_d;
      equation
        txt = Tpl.writeStr(txt, intString(i_d));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(":"));
      then txt;
  end matchcontinue;
end fun_152;

protected function lm_153
  input Tpl.Text in_txt;
  input list<Option<Integer>> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<Option<Integer>> rest;
        Option<Integer> i_it;
      equation
        txt = fun_152(txt, i_it);
        txt = Tpl.nextIter(txt);
        txt = lm_153(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<Option<Integer>> rest;
      equation
        txt = lm_153(txt, rest);
      then txt;
  end matchcontinue;
end lm_153;

protected function fun_154
  input Tpl.Text in_txt;
  input SimCode.Type in_i_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_ty)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.ET_ARRAY(arrayDimensions = i_arrayDimensions) )
      local
        list<Option<Integer>> i_arrayDimensions;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("["));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_153(txt, i_arrayDimensions);
        txt = Tpl.popIter(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("]"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end fun_154;

protected function lm_155
  input Tpl.Text in_txt;
  input SimCode.Variables in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           (it as SimCode.VARIABLE(name = i_name, ty = i_ty)) :: rest )
      local
        SimCode.Variables rest;
        SimCode.Type i_ty;
        DAE.ComponentRef i_name;
        SimCode.Variable it;
        Integer i_i1;
      equation
        i_i1 = Tpl.getIteri_i1(txt);
        txt = varType(txt, it);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" targ"));
        txt = Tpl.writeStr(txt, intString(i_i1));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("; /* "));
        txt = cref(txt, i_name);
        txt = fun_154(txt, i_ty);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" */"));
        txt = Tpl.nextIter(txt);
        txt = lm_155(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        SimCode.Variables rest;
      equation
        txt = lm_155(txt, rest);
      then txt;
  end matchcontinue;
end lm_155;

protected function lm_156
  input Tpl.Text in_txt;
  input SimCode.Variables in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           (it as SimCode.VARIABLE(name = i_name)) :: rest )
      local
        SimCode.Variables rest;
        DAE.ComponentRef i_name;
        SimCode.Variable it;
      equation
        txt = varType(txt, it);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" "));
        txt = cref(txt, i_name);
        txt = Tpl.nextIter(txt);
        txt = lm_156(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        SimCode.Variables rest;
      equation
        txt = lm_156(txt, rest);
      then txt;
  end matchcontinue;
end lm_156;

public function functionHeader
  input Tpl.Text txt;
  input String i_fname;
  input SimCode.Variables i_fargs;
  input SimCode.Variables i_outVars;

  output Tpl.Text out_txt;
algorithm
  out_txt := Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  out_txt := lm_151(out_txt, i_outVars, i_fname);
  out_txt := Tpl.popIter(out_txt);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("typedef struct "));
  out_txt := Tpl.writeStr(out_txt, i_fname);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "_rettype_s\n",
                                       "{\n"
                                   }, true));
  out_txt := Tpl.pushBlock(out_txt, Tpl.BT_INDENT(2));
  out_txt := Tpl.pushIter(out_txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  out_txt := lm_155(out_txt, i_outVars);
  out_txt := Tpl.popIter(out_txt);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.popBlock(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("} "));
  out_txt := Tpl.writeStr(out_txt, i_fname);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "_rettype;\n",
                                       "\n",
                                       "DLLExport\n",
                                       "int in_"
                                   }, false));
  out_txt := Tpl.writeStr(out_txt, i_fname);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING_LIST({
                                       "(type_description * inArgs, type_description * outVar);\n",
                                       "\n",
                                       "DLLExport\n"
                                   }, true));
  out_txt := Tpl.writeStr(out_txt, i_fname);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("_rettype _"));
  out_txt := Tpl.writeStr(out_txt, i_fname);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("("));
  out_txt := Tpl.pushIter(out_txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  out_txt := lm_156(out_txt, i_fargs);
  out_txt := Tpl.popIter(out_txt);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING(");"));
end functionHeader;

protected function lm_158
  input Tpl.Text in_txt;
  input list<SimCode.SimExtArg> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<SimCode.SimExtArg> rest;
        SimCode.SimExtArg i_it;
      equation
        txt = extFunDefArg(txt, i_it);
        txt = Tpl.nextIter(txt);
        txt = lm_158(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimExtArg> rest;
      equation
        txt = lm_158(txt, rest);
      then txt;
  end matchcontinue;
end lm_158;

public function extFunDef
  input Tpl.Text in_txt;
  input SimCode.Function in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.EXTERNAL_FUNCTION(extReturn = i_extReturn, extName = i_extName, extArgs = i_extArgs) )
      local
        list<SimCode.SimExtArg> i_extArgs;
        SimCode.Ident i_extName;
        SimCode.SimExtArg i_extReturn;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("extern "));
        txt = extReturnType(txt, i_extReturn);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" "));
        txt = Tpl.writeStr(txt, i_extName);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_158(txt, i_extArgs);
        txt = Tpl.popIter(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end extFunDef;

public function extReturnType
  input Tpl.Text in_txt;
  input SimCode.SimExtArg in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.SIMEXTARG(type_ = i_type__) )
      local
        DAE.ExpType i_type__;
      equation
        txt = extType(txt, i_type__);
      then txt;

    case ( txt,
           SimCode.SIMNOEXTARG() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("void"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end extReturnType;

public function extType
  input Tpl.Text in_txt;
  input SimCode.Type in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.ET_INT() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("int"));
      then txt;

    case ( txt,
           DAE.ET_REAL() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("double"));
      then txt;

    case ( txt,
           DAE.ET_STRING() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("const char*"));
      then txt;

    case ( txt,
           DAE.ET_BOOL() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("int"));
      then txt;

    case ( txt,
           DAE.ET_ARRAY(ty = i_ty) )
      local
        DAE.ExpType i_ty;
      equation
        txt = extType(txt, i_ty);
      then txt;

    case ( txt,
           DAE.ET_COMPLEX(complexClassType = ClassInf.EXTERNAL_OBJ(path = _)) )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("void *"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("OTHER_EXT_TYPE"));
      then txt;
  end matchcontinue;
end extType;

protected function fun_162
  input Tpl.Text in_txt;
  input DAE.ExpType in_i_t;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_t)
    local
      Tpl.Text txt;

    case ( txt,
           (i_t as DAE.ET_STRING()) )
      local
        DAE.ExpType i_t;
      equation
        txt = extType(txt, i_t);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" const *"));
      then txt;

    case ( txt,
           i_t )
      local
        DAE.ExpType i_t;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("const "));
        txt = extType(txt, i_t);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" *"));
      then txt;
  end matchcontinue;
end fun_162;

protected function fun_163
  input Tpl.Text in_txt;
  input Boolean in_i_ia;
  input DAE.ExpType in_i_t;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_ia, in_i_t)
    local
      Tpl.Text txt;
      DAE.ExpType i_t;

    case ( txt,
           false,
           i_t )
      equation
        txt = extType(txt, i_t);
      then txt;

    case ( txt,
           _,
           i_t )
      equation
        txt = fun_162(txt, i_t);
      then txt;
  end matchcontinue;
end fun_163;

protected function fun_164
  input Tpl.Text in_txt;
  input Boolean in_i_ii;
  input Boolean in_i_ia;
  input DAE.ExpType in_i_t;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_ii, in_i_ia, in_i_t)
    local
      Tpl.Text txt;
      Boolean i_ia;
      DAE.ExpType i_t;

    case ( txt,
           false,
           _,
           i_t )
      equation
        txt = extType(txt, i_t);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("*"));
      then txt;

    case ( txt,
           _,
           i_ia,
           i_t )
      equation
        txt = fun_163(txt, i_ia, i_t);
      then txt;
  end matchcontinue;
end fun_164;

public function extFunDefArg
  input Tpl.Text in_txt;
  input SimCode.SimExtArg in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.SIMEXTARG(cref = i_c, isInput = i_ii, isArray = i_ia, type_ = i_t) )
      local
        DAE.ExpType i_t;
        Boolean i_ia;
        Boolean i_ii;
        DAE.ComponentRef i_c;
        Tpl.Text i_typeStr;
        Tpl.Text i_name;
      equation
        i_name = cref(emptyTxt, i_c);
        i_typeStr = fun_164(emptyTxt, i_ii, i_ia, i_t);
        txt = Tpl.writeText(txt, i_typeStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" "));
        txt = Tpl.writeText(txt, i_name);
      then txt;

    case ( txt,
           SimCode.SIMEXTARGEXP(type_ = i_type__) )
      local
        DAE.ExpType i_type__;
        Tpl.Text i_typeStr;
      equation
        i_typeStr = extType(emptyTxt, i_type__);
        txt = Tpl.writeText(txt, i_typeStr);
      then txt;

    case ( txt,
           SimCode.SIMEXTARGSIZE(cref = i_c, exp = i_exp) )
      local
        DAE.Exp i_exp;
        DAE.ComponentRef i_c;
        Tpl.Text i_eStr;
        Tpl.Text i_name;
      equation
        i_name = cref(emptyTxt, i_c);
        i_eStr = daeExpToString(emptyTxt, i_exp);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("size_t "));
        txt = Tpl.writeText(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_"));
        txt = Tpl.writeText(txt, i_eStr);
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end extFunDefArg;

public function daeExpToString
  input Tpl.Text txt;
  input DAE.Exp i_exp;

  output Tpl.Text out_txt;
protected
  Tpl.Text i_varDecls;
  Tpl.Text i_preExp;
algorithm
  i_preExp := emptyTxt;
  i_varDecls := emptyTxt;
  (out_txt, i_preExp, i_varDecls) := daeExp(txt, i_exp, SimCode.contextOther, i_preExp, i_varDecls);
end daeExpToString;

protected function lm_167
  input Tpl.Text in_txt;
  input list<SimCode.Function> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<SimCode.Function> rest;
        SimCode.Function i_it;
      equation
        txt = functionBody(txt, i_it);
        txt = Tpl.nextIter(txt);
        txt = lm_167(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.Function> rest;
      equation
        txt = lm_167(txt, rest);
      then txt;
  end matchcontinue;
end lm_167;

public function functionBodies
  input Tpl.Text txt;
  input list<SimCode.Function> i_functions;

  output Tpl.Text out_txt;
algorithm
  out_txt := Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  out_txt := lm_167(out_txt, i_functions);
  out_txt := Tpl.popIter(out_txt);
end functionBodies;

protected function lm_169
  input Tpl.Text in_txt;
  input list<SimCode.Variable> in_items;
  input Tpl.Text in_i_varInits;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varInits;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varInits, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varInits, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varInits;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varInits,
           i_varDecls )
      then (txt, i_varInits, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varInits,
           i_varDecls )
      local
        list<SimCode.Variable> rest;
        SimCode.Variable i_it;
        Integer i_i1;
      equation
        i_i1 = Tpl.getIteri_i1(txt);
        (txt, i_varDecls, i_varInits) = varInit(txt, i_it, "", i_i1, i_varDecls, i_varInits);
        txt = Tpl.nextIter(txt);
        (txt, i_varInits, i_varDecls) = lm_169(txt, rest, i_varInits, i_varDecls);
      then (txt, i_varInits, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varInits,
           i_varDecls )
      local
        list<SimCode.Variable> rest;
      equation
        (txt, i_varInits, i_varDecls) = lm_169(txt, rest, i_varInits, i_varDecls);
      then (txt, i_varInits, i_varDecls);
  end matchcontinue;
end lm_169;

protected function lm_170
  input Tpl.Text in_txt;
  input list<SimCode.Statement> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           i_stmt :: rest,
           i_varDecls )
      local
        list<SimCode.Statement> rest;
        SimCode.Statement i_stmt;
      equation
        (txt, i_varDecls) = funStatement(txt, i_stmt, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_170(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.Statement> rest;
      equation
        (txt, i_varDecls) = lm_170(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_170;

protected function lm_171
  input Tpl.Text in_txt;
  input SimCode.Variables in_items;
  input Tpl.Text in_i_varInits;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_retVar;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varInits;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varInits, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varInits, in_i_varDecls, in_i_retVar)
    local
      Tpl.Text txt;
      Tpl.Text i_varInits;
      Tpl.Text i_varDecls;
      Tpl.Text i_retVar;

    case ( txt,
           {},
           i_varInits,
           i_varDecls,
           _ )
      then (txt, i_varInits, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varInits,
           i_varDecls,
           i_retVar )
      local
        SimCode.Variables rest;
        SimCode.Variable i_it;
        Integer i_i1;
      equation
        i_i1 = Tpl.getIteri_i1(txt);
        (txt, i_varDecls, i_varInits) = varOutput(txt, i_it, Tpl.textString(i_retVar), i_i1, i_varDecls, i_varInits);
        txt = Tpl.nextIter(txt);
        (txt, i_varInits, i_varDecls) = lm_171(txt, rest, i_varInits, i_varDecls, i_retVar);
      then (txt, i_varInits, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varInits,
           i_varDecls,
           i_retVar )
      local
        SimCode.Variables rest;
      equation
        (txt, i_varInits, i_varDecls) = lm_171(txt, rest, i_varInits, i_varDecls, i_retVar);
      then (txt, i_varInits, i_varDecls);
  end matchcontinue;
end lm_171;

protected function lm_172
  input Tpl.Text in_txt;
  input list<SimCode.Variable> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.VARIABLE(ty = i_ty, name = i_name) :: rest )
      local
        list<SimCode.Variable> rest;
        DAE.ComponentRef i_name;
        SimCode.Type i_ty;
      equation
        txt = expTypeArrayIf(txt, i_ty);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" "));
        txt = cref(txt, i_name);
        txt = Tpl.nextIter(txt);
        txt = lm_172(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.Variable> rest;
      equation
        txt = lm_172(txt, rest);
      then txt;
  end matchcontinue;
end lm_172;

protected function lm_173
  input Tpl.Text in_txt;
  input list<SimCode.Variable> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.VARIABLE(ty = i_ty, name = i_name) :: rest )
      local
        list<SimCode.Variable> rest;
        DAE.ComponentRef i_name;
        SimCode.Type i_ty;
      equation
        txt = expTypeArrayIf(txt, i_ty);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" "));
        txt = cref(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
        txt = Tpl.nextIter(txt);
        txt = lm_173(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.Variable> rest;
      equation
        txt = lm_173(txt, rest);
      then txt;
  end matchcontinue;
end lm_173;

protected function lm_174
  input Tpl.Text in_txt;
  input list<SimCode.Variable> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.VARIABLE(ty = i_ty, name = i_name) :: rest )
      local
        list<SimCode.Variable> rest;
        DAE.ComponentRef i_name;
        SimCode.Type i_ty;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("if (read_"));
        txt = expTypeArrayIf(txt, i_ty);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(&inArgs, &"));
        txt = cref(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")) return 1;"));
        txt = Tpl.nextIter(txt);
        txt = lm_174(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.Variable> rest;
      equation
        txt = lm_174(txt, rest);
      then txt;
  end matchcontinue;
end lm_174;

protected function lm_175
  input Tpl.Text in_txt;
  input list<SimCode.Variable> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.VARIABLE(name = i_name) :: rest )
      local
        list<SimCode.Variable> rest;
        DAE.ComponentRef i_name;
      equation
        txt = cref(txt, i_name);
        txt = Tpl.nextIter(txt);
        txt = lm_175(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.Variable> rest;
      equation
        txt = lm_175(txt, rest);
      then txt;
  end matchcontinue;
end lm_175;

protected function lm_176
  input Tpl.Text in_txt;
  input SimCode.Variables in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           (it as SimCode.VARIABLE(name = _)) :: rest )
      local
        SimCode.Variables rest;
        SimCode.Variable it;
        Integer i_i1;
      equation
        i_i1 = Tpl.getIteri_i1(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("write_"));
        txt = varType(txt, it);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(outVar, &out.targ"));
        txt = Tpl.writeStr(txt, intString(i_i1));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
        txt = Tpl.nextIter(txt);
        txt = lm_176(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        SimCode.Variables rest;
      equation
        txt = lm_176(txt, rest);
      then txt;
  end matchcontinue;
end lm_176;

protected function lm_177
  input Tpl.Text in_txt;
  input list<SimCode.Variable> in_items;
  input Tpl.Text in_i_outputAlloc;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_outputAlloc;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_outputAlloc, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_outputAlloc, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_outputAlloc;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_outputAlloc,
           i_varDecls )
      then (txt, i_outputAlloc, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_outputAlloc,
           i_varDecls )
      local
        list<SimCode.Variable> rest;
        SimCode.Variable i_it;
        Integer i_i1;
      equation
        i_i1 = Tpl.getIteri_i1(txt);
        (txt, i_varDecls, i_outputAlloc) = varInit(txt, i_it, "out", i_i1, i_varDecls, i_outputAlloc);
        txt = Tpl.nextIter(txt);
        (txt, i_outputAlloc, i_varDecls) = lm_177(txt, rest, i_outputAlloc, i_varDecls);
      then (txt, i_outputAlloc, i_varDecls);

    case ( txt,
           _ :: rest,
           i_outputAlloc,
           i_varDecls )
      local
        list<SimCode.Variable> rest;
      equation
        (txt, i_outputAlloc, i_varDecls) = lm_177(txt, rest, i_outputAlloc, i_varDecls);
      then (txt, i_outputAlloc, i_varDecls);
  end matchcontinue;
end lm_177;

protected function lm_178
  input Tpl.Text in_txt;
  input list<SimCode.Variable> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           SimCode.VARIABLE(ty = i_ty, name = i_name) :: rest )
      local
        list<SimCode.Variable> rest;
        DAE.ComponentRef i_name;
        SimCode.Type i_ty;
      equation
        txt = expTypeArrayIf(txt, i_ty);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" "));
        txt = cref(txt, i_name);
        txt = Tpl.nextIter(txt);
        txt = lm_178(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.Variable> rest;
      equation
        txt = lm_178(txt, rest);
      then txt;
  end matchcontinue;
end lm_178;

public function functionBody
  input Tpl.Text in_txt;
  input SimCode.Function in_i_fn;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_fn)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.FUNCTION(name = i_name, variableDeclarations = i_variableDeclarations, body = i_body, outVars = i_outVars, functionArguments = i_functionArguments) )
      local
        list<SimCode.Variable> i_functionArguments;
        SimCode.Variables i_outVars;
        list<SimCode.Statement> i_body;
        list<SimCode.Variable> i_variableDeclarations;
        Absyn.Path i_name;
        Tpl.Text i_outVarsStr;
        Tpl.Text i_bodyPart;
        Tpl.Text i_0__;
        Tpl.Text i_stateVar;
        Tpl.Text i_retVar;
        Tpl.Text i_varInits;
        Tpl.Text i_varDecls;
        Tpl.Text i_retType;
        Tpl.Text i_fname;
      equation
        System.tmpTickReset(1);
        i_fname = underscorePath(emptyTxt, i_name);
        i_retType = Tpl.writeText(emptyTxt, i_fname);
        i_retType = Tpl.writeTok(i_retType, Tpl.ST_STRING("_rettype"));
        i_varDecls = emptyTxt;
        i_varInits = emptyTxt;
        (i_retVar, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_retType), i_varDecls);
        (i_stateVar, i_varDecls) = tempDecl(emptyTxt, "state", i_varDecls);
        i_0__ = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, NONE, 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_0__, i_varInits, i_varDecls) = lm_169(i_0__, i_variableDeclarations, i_varInits, i_varDecls);
        i_0__ = Tpl.popIter(i_0__);
        i_bodyPart = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_bodyPart, i_varDecls) = lm_170(i_bodyPart, i_body, i_varDecls);
        i_bodyPart = Tpl.popIter(i_bodyPart);
        i_outVarsStr = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, NONE, 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_outVarsStr, i_varInits, i_varDecls) = lm_171(i_outVarsStr, i_outVars, i_varInits, i_varDecls, i_retVar);
        i_outVarsStr = Tpl.popIter(i_outVarsStr);
        txt = Tpl.writeText(txt, i_retType);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" _"));
        txt = Tpl.writeText(txt, i_fname);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_172(txt, i_functionArguments);
        txt = Tpl.popIter(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    ")\n",
                                    "{\n"
                                }, true));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.writeText(txt, i_varDecls);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeText(txt, i_stateVar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    " = get_memory_state();\n",
                                    "\n"
                                }, true));
        txt = Tpl.writeText(txt, i_varInits);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_bodyPart);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "\n",
                                    "_return:\n"
                                }, true));
        txt = Tpl.writeText(txt, i_outVarsStr);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("restore_memory_state("));
        txt = Tpl.writeText(txt, i_stateVar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    ");\n",
                                    "return "
                                }, false));
        txt = Tpl.writeText(txt, i_retVar);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(";\n"));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "}\n",
                                    "\n",
                                    "int in_"
                                }, false));
        txt = Tpl.writeText(txt, i_fname);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    "(type_description * inArgs, type_description * outVar)\n",
                                    "{\n"
                                }, true));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_173(txt, i_functionArguments);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeText(txt, i_retType);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(" out;\n"));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_174(txt, i_functionArguments);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("out = _"));
        txt = Tpl.writeText(txt, i_fname);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_175(txt, i_functionArguments);
        txt = Tpl.popIter(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(");\n"));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_176(txt, i_outVars);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("return 0;\n"));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("}"));
      then txt;

    case ( txt,
           (i_fn as SimCode.EXTERNAL_FUNCTION(name = i_name, outVars = i_outVars, funArgs = i_funArgs)) )
      local
        list<SimCode.Variable> i_funArgs;
        list<SimCode.Variable> i_outVars;
        Absyn.Path i_name;
        SimCode.Function i_fn;
        Tpl.Text i_0__;
        Tpl.Text i_callPart;
        Tpl.Text i_outputAlloc;
        Tpl.Text i_varDecls;
        Tpl.Text i_preExp;
        Tpl.Text i_retType;
        Tpl.Text i_fname;
      equation
        System.tmpTickReset(1);
        i_fname = underscorePath(emptyTxt, i_name);
        i_retType = Tpl.writeText(emptyTxt, i_fname);
        i_retType = Tpl.writeTok(i_retType, Tpl.ST_STRING("_rettype"));
        i_preExp = emptyTxt;
        i_varDecls = emptyTxt;
        i_outputAlloc = emptyTxt;
        (i_callPart, i_preExp, i_varDecls) = extFunCall(emptyTxt, i_fn, i_preExp, i_varDecls);
        i_0__ = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, NONE, 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_0__, i_outputAlloc, i_varDecls) = lm_177(i_0__, i_outVars, i_outputAlloc, i_varDecls);
        i_0__ = Tpl.popIter(i_0__);
        txt = Tpl.writeText(txt, i_retType);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" _"));
        txt = Tpl.writeText(txt, i_fname);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_178(txt, i_funArgs);
        txt = Tpl.popIter(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    ")\n",
                                    "{\n"
                                }, true));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.writeText(txt, i_varDecls);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeText(txt, i_retType);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(" out;\n"));
        txt = Tpl.writeText(txt, i_outputAlloc);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeText(txt, i_callPart);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("return out;\n"));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("}"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end functionBody;

protected function fun_180
  input Tpl.Text in_txt;
  input String in_i_outStruct;
  input Integer in_i_i;
  input DAE.ComponentRef in_i_var_name;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_outStruct, in_i_i, in_i_var_name)
    local
      Tpl.Text txt;
      Integer i_i;
      DAE.ComponentRef i_var_name;

    case ( txt,
           "",
           _,
           i_var_name )
      equation
        txt = cref(txt, i_var_name);
      then txt;

    case ( txt,
           i_outStruct,
           i_i,
           _ )
      local
        String i_outStruct;
      equation
        txt = Tpl.writeStr(txt, i_outStruct);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(".targ"));
        txt = Tpl.writeStr(txt, intString(i_i));
      then txt;
  end matchcontinue;
end fun_180;

protected function lm_181
  input Tpl.Text in_txt;
  input list<DAE.Exp> in_items;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_varInits;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_varInits;
algorithm
  (out_txt, out_i_varDecls, out_i_varInits) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_varInits)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_varInits;

    case ( txt,
           {},
           i_varDecls,
           i_varInits )
      then (txt, i_varDecls, i_varInits);

    case ( txt,
           i_exp :: rest,
           i_varDecls,
           i_varInits )
      local
        list<DAE.Exp> rest;
        DAE.Exp i_exp;
      equation
        (txt, i_varInits, i_varDecls) = daeExp(txt, i_exp, SimCode.contextOther, i_varInits, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls, i_varInits) = lm_181(txt, rest, i_varDecls, i_varInits);
      then (txt, i_varDecls, i_varInits);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_varInits )
      local
        list<DAE.Exp> rest;
      equation
        (txt, i_varDecls, i_varInits) = lm_181(txt, rest, i_varDecls, i_varInits);
      then (txt, i_varDecls, i_varInits);
  end matchcontinue;
end lm_181;

protected function fun_182
  input Tpl.Text in_txt;
  input list<DAE.Exp> in_i_instDims;
  input Tpl.Text in_i_instDimsInit;
  input Tpl.Text in_i_varName;
  input SimCode.Type in_i_var_ty;
  input Tpl.Text in_i_varInits;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varInits;
algorithm
  (out_txt, out_i_varInits) :=
  matchcontinue(in_txt, in_i_instDims, in_i_instDimsInit, in_i_varName, in_i_var_ty, in_i_varInits)
    local
      Tpl.Text txt;
      Tpl.Text i_instDimsInit;
      Tpl.Text i_varName;
      SimCode.Type i_var_ty;
      Tpl.Text i_varInits;

    case ( txt,
           {},
           _,
           _,
           _,
           i_varInits )
      then (txt, i_varInits);

    case ( txt,
           i_instDims,
           i_instDimsInit,
           i_varName,
           i_var_ty,
           i_varInits )
      local
        list<DAE.Exp> i_instDims;
        Integer ret_0;
      equation
        i_varInits = Tpl.writeTok(i_varInits, Tpl.ST_STRING("alloc_"));
        i_varInits = expTypeShort(i_varInits, i_var_ty);
        i_varInits = Tpl.writeTok(i_varInits, Tpl.ST_STRING("_array(&"));
        i_varInits = Tpl.writeText(i_varInits, i_varName);
        i_varInits = Tpl.writeTok(i_varInits, Tpl.ST_STRING(", "));
        ret_0 = listLength(i_instDims);
        i_varInits = Tpl.writeStr(i_varInits, intString(ret_0));
        i_varInits = Tpl.writeTok(i_varInits, Tpl.ST_STRING(", "));
        i_varInits = Tpl.writeText(i_varInits, i_instDimsInit);
        i_varInits = Tpl.writeTok(i_varInits, Tpl.ST_STRING(");"));
        i_varInits = Tpl.writeTok(i_varInits, Tpl.ST_NEW_LINE());
      then (txt, i_varInits);
  end matchcontinue;
end fun_182;

public function varInit
  input Tpl.Text in_txt;
  input SimCode.Variable in_i_it;
  input String in_i_outStruct;
  input Integer in_i_i;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_varInits;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_varInits;
algorithm
  (out_txt, out_i_varDecls, out_i_varInits) :=
  matchcontinue(in_txt, in_i_it, in_i_outStruct, in_i_i, in_i_varDecls, in_i_varInits)
    local
      Tpl.Text txt;
      String i_outStruct;
      Integer i_i;
      Tpl.Text i_varDecls;
      Tpl.Text i_varInits;

    case ( txt,
           (i_var as SimCode.VARIABLE(name = i_var_name, instDims = i_instDims, ty = i_var_ty)),
           i_outStruct,
           i_i,
           i_varDecls,
           i_varInits )
      local
        SimCode.Type i_var_ty;
        list<DAE.Exp> i_instDims;
        DAE.ComponentRef i_var_name;
        SimCode.Variable i_var;
        Tpl.Text i_instDimsInit;
        Tpl.Text i_varName;
      equation
        i_varDecls = varType(i_varDecls, i_var);
        i_varDecls = Tpl.writeTok(i_varDecls, Tpl.ST_STRING(" "));
        i_varDecls = cref(i_varDecls, i_var_name);
        i_varDecls = Tpl.writeTok(i_varDecls, Tpl.ST_STRING(";"));
        i_varDecls = Tpl.writeTok(i_varDecls, Tpl.ST_NEW_LINE());
        i_varName = fun_180(emptyTxt, i_outStruct, i_i, i_var_name);
        i_instDimsInit = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_instDimsInit, i_varDecls, i_varInits) = lm_181(i_instDimsInit, i_instDims, i_varDecls, i_varInits);
        i_instDimsInit = Tpl.popIter(i_instDimsInit);
        (txt, i_varInits) = fun_182(txt, i_instDims, i_instDimsInit, i_varName, i_var_ty, i_varInits);
      then (txt, i_varDecls, i_varInits);

    case ( txt,
           _,
           _,
           _,
           i_varDecls,
           i_varInits )
      then (txt, i_varDecls, i_varInits);
  end matchcontinue;
end varInit;

protected function lm_184
  input Tpl.Text in_txt;
  input list<DAE.Exp> in_items;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_varInits;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_varInits;
algorithm
  (out_txt, out_i_varDecls, out_i_varInits) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_varInits)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_varInits;

    case ( txt,
           {},
           i_varDecls,
           i_varInits )
      then (txt, i_varDecls, i_varInits);

    case ( txt,
           i_exp :: rest,
           i_varDecls,
           i_varInits )
      local
        list<DAE.Exp> rest;
        DAE.Exp i_exp;
      equation
        (txt, i_varInits, i_varDecls) = daeExp(txt, i_exp, SimCode.contextOther, i_varInits, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls, i_varInits) = lm_184(txt, rest, i_varDecls, i_varInits);
      then (txt, i_varDecls, i_varInits);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_varInits )
      local
        list<DAE.Exp> rest;
      equation
        (txt, i_varDecls, i_varInits) = lm_184(txt, rest, i_varDecls, i_varInits);
      then (txt, i_varDecls, i_varInits);
  end matchcontinue;
end lm_184;

protected function fun_185
  input Tpl.Text in_txt;
  input list<DAE.Exp> in_i_instDims;
  input Tpl.Text in_i_instDimsInit;
  input SimCode.Type in_i_var_ty;
  input Tpl.Text in_i_varInits;
  input DAE.ComponentRef in_i_var_name;
  input Integer in_i_i;
  input String in_i_dest;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varInits;
algorithm
  (out_txt, out_i_varInits) :=
  matchcontinue(in_txt, in_i_instDims, in_i_instDimsInit, in_i_var_ty, in_i_varInits, in_i_var_name, in_i_i, in_i_dest)
    local
      Tpl.Text txt;
      Tpl.Text i_instDimsInit;
      SimCode.Type i_var_ty;
      Tpl.Text i_varInits;
      DAE.ComponentRef i_var_name;
      Integer i_i;
      String i_dest;

    case ( txt,
           {},
           _,
           _,
           i_varInits,
           i_var_name,
           i_i,
           i_dest )
      equation
        txt = Tpl.writeStr(txt, i_dest);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(".targ"));
        txt = Tpl.writeStr(txt, intString(i_i));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = "));
        txt = cref(txt, i_var_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
      then (txt, i_varInits);

    case ( txt,
           i_instDims,
           i_instDimsInit,
           i_var_ty,
           i_varInits,
           i_var_name,
           i_i,
           i_dest )
      local
        list<DAE.Exp> i_instDims;
        Integer ret_0;
      equation
        i_varInits = Tpl.writeTok(i_varInits, Tpl.ST_STRING("alloc_"));
        i_varInits = expTypeShort(i_varInits, i_var_ty);
        i_varInits = Tpl.writeTok(i_varInits, Tpl.ST_STRING("_array(&"));
        i_varInits = Tpl.writeStr(i_varInits, i_dest);
        i_varInits = Tpl.writeTok(i_varInits, Tpl.ST_STRING(".targ"));
        i_varInits = Tpl.writeStr(i_varInits, intString(i_i));
        i_varInits = Tpl.writeTok(i_varInits, Tpl.ST_STRING(", "));
        ret_0 = listLength(i_instDims);
        i_varInits = Tpl.writeStr(i_varInits, intString(ret_0));
        i_varInits = Tpl.writeTok(i_varInits, Tpl.ST_STRING(", "));
        i_varInits = Tpl.writeText(i_varInits, i_instDimsInit);
        i_varInits = Tpl.writeTok(i_varInits, Tpl.ST_STRING(");"));
        i_varInits = Tpl.writeTok(i_varInits, Tpl.ST_NEW_LINE());
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("copy_"));
        txt = expTypeShort(txt, i_var_ty);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_array_data(&"));
        txt = cref(txt, i_var_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", &"));
        txt = Tpl.writeStr(txt, i_dest);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(".targ"));
        txt = Tpl.writeStr(txt, intString(i_i));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
      then (txt, i_varInits);
  end matchcontinue;
end fun_185;

public function varOutput
  input Tpl.Text in_txt;
  input SimCode.Variable in_i_source;
  input String in_i_dest;
  input Integer in_i_i;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_varInits;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_varInits;
algorithm
  (out_txt, out_i_varDecls, out_i_varInits) :=
  matchcontinue(in_txt, in_i_source, in_i_dest, in_i_i, in_i_varDecls, in_i_varInits)
    local
      Tpl.Text txt;
      String i_dest;
      Integer i_i;
      Tpl.Text i_varDecls;
      Tpl.Text i_varInits;

    case ( txt,
           (i_var as SimCode.VARIABLE(instDims = i_instDims, name = i_var_name, ty = i_var_ty)),
           i_dest,
           i_i,
           i_varDecls,
           i_varInits )
      local
        SimCode.Type i_var_ty;
        DAE.ComponentRef i_var_name;
        list<DAE.Exp> i_instDims;
        SimCode.Variable i_var;
        Tpl.Text i_instDimsInit;
      equation
        i_instDimsInit = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_instDimsInit, i_varDecls, i_varInits) = lm_184(i_instDimsInit, i_instDims, i_varDecls, i_varInits);
        i_instDimsInit = Tpl.popIter(i_instDimsInit);
        (txt, i_varInits) = fun_185(txt, i_instDims, i_instDimsInit, i_var_ty, i_varInits, i_var_name, i_i, i_dest);
      then (txt, i_varDecls, i_varInits);

    case ( txt,
           _,
           _,
           _,
           i_varDecls,
           i_varInits )
      then (txt, i_varDecls, i_varInits);
  end matchcontinue;
end varOutput;

protected function lm_187
  input Tpl.Text in_txt;
  input list<SimCode.SimExtArg> in_items;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_preExp)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;

    case ( txt,
           {},
           i_varDecls,
           i_preExp )
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           i_it :: rest,
           i_varDecls,
           i_preExp )
      local
        list<SimCode.SimExtArg> rest;
        SimCode.SimExtArg i_it;
      equation
        (txt, i_preExp, i_varDecls) = extArg(txt, i_it, i_preExp, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls, i_preExp) = lm_187(txt, rest, i_varDecls, i_preExp);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_preExp )
      local
        list<SimCode.SimExtArg> rest;
      equation
        (txt, i_varDecls, i_preExp) = lm_187(txt, rest, i_varDecls, i_preExp);
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end lm_187;

protected function fun_188
  input Tpl.Text in_txt;
  input SimCode.SimExtArg in_i_extReturn;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_extReturn)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.SIMEXTARG(cref = i_c) )
      local
        DAE.ComponentRef i_c;
      equation
        txt = cref(txt, i_c);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_ext = "));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end fun_188;

protected function lm_189
  input Tpl.Text in_txt;
  input list<SimCode.SimExtArg> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls )
      local
        list<SimCode.SimExtArg> rest;
        SimCode.SimExtArg i_it;
      equation
        (txt, i_varDecls) = extFunCallVardecl(txt, i_it, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_189(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.SimExtArg> rest;
      equation
        (txt, i_varDecls) = lm_189(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_189;

protected function fun_190
  input Tpl.Text in_txt;
  input SimCode.SimExtArg in_i_extReturn;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_extReturn, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           (i_extReturn as SimCode.SIMEXTARG(cref = _)),
           i_varDecls )
      local
        SimCode.SimExtArg i_extReturn;
      equation
        (txt, i_varDecls) = extFunCallVardecl(txt, i_extReturn, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _,
           i_varDecls )
      then (txt, i_varDecls);
  end matchcontinue;
end fun_190;

protected function lm_191
  input Tpl.Text in_txt;
  input list<SimCode.SimExtArg> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<SimCode.SimExtArg> rest;
        SimCode.SimExtArg i_it;
      equation
        txt = extFunCallVarcopy(txt, i_it);
        txt = Tpl.nextIter(txt);
        txt = lm_191(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<SimCode.SimExtArg> rest;
      equation
        txt = lm_191(txt, rest);
      then txt;
  end matchcontinue;
end lm_191;

protected function fun_192
  input Tpl.Text in_txt;
  input SimCode.SimExtArg in_i_extReturn;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_extReturn)
    local
      Tpl.Text txt;

    case ( txt,
           (i_extReturn as SimCode.SIMEXTARG(cref = _)) )
      local
        SimCode.SimExtArg i_extReturn;
      equation
        txt = extFunCallVarcopy(txt, i_extReturn);
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end fun_192;

public function extFunCall
  input Tpl.Text in_txt;
  input SimCode.Function in_i_fun;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_fun, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           SimCode.EXTERNAL_FUNCTION(name = i_name, extArgs = i_extArgs, extReturn = i_extReturn, extName = i_extName),
           i_preExp,
           i_varDecls )
      local
        SimCode.Ident i_extName;
        SimCode.SimExtArg i_extReturn;
        list<SimCode.SimExtArg> i_extArgs;
        Absyn.Path i_name;
        Tpl.Text i_returnAssign;
        Tpl.Text i_args;
        Tpl.Text i_fname;
      equation
        i_fname = underscorePath(emptyTxt, i_name);
        i_args = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_args, i_varDecls, i_preExp) = lm_187(i_args, i_extArgs, i_varDecls, i_preExp);
        i_args = Tpl.popIter(i_args);
        i_returnAssign = fun_188(emptyTxt, i_extReturn);
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (txt, i_varDecls) = lm_189(txt, i_extArgs, i_varDecls);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        (txt, i_varDecls) = fun_190(txt, i_extReturn, i_varDecls);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeText(txt, i_returnAssign);
        txt = Tpl.writeStr(txt, i_extName);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_args);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(");\n"));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_191(txt, i_extArgs);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = fun_192(txt, i_extReturn);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end extFunCall;

protected function fun_194
  input Tpl.Text in_txt;
  input DAE.ExpType in_i_ty;
  input DAE.ComponentRef in_i_c;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_ty, in_i_c, in_i_varDecls)
    local
      Tpl.Text txt;
      DAE.ComponentRef i_c;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.ET_STRING(),
           _,
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           i_ty,
           i_c,
           i_varDecls )
      local
        DAE.ExpType i_ty;
      equation
        i_varDecls = extType(i_varDecls, i_ty);
        i_varDecls = Tpl.writeTok(i_varDecls, Tpl.ST_STRING(" "));
        i_varDecls = cref(i_varDecls, i_c);
        i_varDecls = Tpl.writeTok(i_varDecls, Tpl.ST_STRING("_ext;"));
        i_varDecls = Tpl.writeTok(i_varDecls, Tpl.ST_NEW_LINE());
        txt = cref(txt, i_c);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_ext = ("));
        txt = extType(txt, i_ty);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
        txt = cref(txt, i_c);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
      then (txt, i_varDecls);
  end matchcontinue;
end fun_194;

protected function fun_195
  input Tpl.Text in_txt;
  input Integer in_i_oi;
  input DAE.ComponentRef in_i_c;
  input DAE.ExpType in_i_ty;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_oi, in_i_c, in_i_ty, in_i_varDecls)
    local
      Tpl.Text txt;
      DAE.ComponentRef i_c;
      DAE.ExpType i_ty;
      Tpl.Text i_varDecls;

    case ( txt,
           0,
           _,
           _,
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           _,
           i_c,
           i_ty,
           i_varDecls )
      equation
        i_varDecls = extType(i_varDecls, i_ty);
        i_varDecls = Tpl.writeTok(i_varDecls, Tpl.ST_STRING(" "));
        i_varDecls = cref(i_varDecls, i_c);
        i_varDecls = Tpl.writeTok(i_varDecls, Tpl.ST_STRING("_ext;"));
        i_varDecls = Tpl.writeTok(i_varDecls, Tpl.ST_NEW_LINE());
      then (txt, i_varDecls);
  end matchcontinue;
end fun_195;

public function extFunCallVardecl
  input Tpl.Text in_txt;
  input SimCode.SimExtArg in_i_arg;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_arg, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           SimCode.SIMEXTARG(isInput = true, isArray = false, type_ = i_ty, cref = i_c),
           i_varDecls )
      local
        DAE.ComponentRef i_c;
        DAE.ExpType i_ty;
      equation
        (txt, i_varDecls) = fun_194(txt, i_ty, i_c, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           SimCode.SIMEXTARG(outputIndex = i_oi, isArray = false, type_ = i_ty, cref = i_c),
           i_varDecls )
      local
        DAE.ComponentRef i_c;
        DAE.ExpType i_ty;
        Integer i_oi;
      equation
        (txt, i_varDecls) = fun_195(txt, i_oi, i_c, i_ty, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _,
           i_varDecls )
      then (txt, i_varDecls);
  end matchcontinue;
end extFunCallVardecl;

protected function fun_197
  input Tpl.Text in_txt;
  input Integer in_i_oi;
  input DAE.ComponentRef in_i_c;
  input DAE.ExpType in_i_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_oi, in_i_c, in_i_ty)
    local
      Tpl.Text txt;
      DAE.ComponentRef i_c;
      DAE.ExpType i_ty;

    case ( txt,
           0,
           _,
           _ )
      then txt;

    case ( txt,
           i_oi,
           i_c,
           i_ty )
      local
        Integer i_oi;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("out.targ"));
        txt = Tpl.writeStr(txt, intString(i_oi));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = ("));
        txt = expTypeModelica(txt, i_ty);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
        txt = cref(txt, i_c);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_ext;"));
      then txt;
  end matchcontinue;
end fun_197;

public function extFunCallVarcopy
  input Tpl.Text in_txt;
  input SimCode.SimExtArg in_i_arg;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_arg)
    local
      Tpl.Text txt;

    case ( txt,
           SimCode.SIMEXTARG(outputIndex = i_oi, isArray = false, type_ = i_ty, cref = i_c) )
      local
        DAE.ComponentRef i_c;
        DAE.ExpType i_ty;
        Integer i_oi;
      equation
        txt = fun_197(txt, i_oi, i_c, i_ty);
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end extFunCallVarcopy;

protected function fun_199
  input Tpl.Text in_txt;
  input Integer in_i_oi;
  input DAE.ComponentRef in_i_c;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_oi, in_i_c)
    local
      Tpl.Text txt;
      DAE.ComponentRef i_c;

    case ( txt,
           0,
           i_c )
      equation
        txt = cref(txt, i_c);
      then txt;

    case ( txt,
           i_oi,
           _ )
      local
        Integer i_oi;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("out.targ"));
        txt = Tpl.writeStr(txt, intString(i_oi));
      then txt;
  end matchcontinue;
end fun_199;

protected function fun_200
  input Tpl.Text in_txt;
  input Integer in_i_oi;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_oi)
    local
      Tpl.Text txt;

    case ( txt,
           0 )
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("&"));
      then txt;
  end matchcontinue;
end fun_200;

protected function fun_201
  input Tpl.Text in_txt;
  input DAE.ExpType in_i_t;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_t)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.ET_STRING() )
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_ext"));
      then txt;
  end matchcontinue;
end fun_201;

protected function fun_202
  input Tpl.Text in_txt;
  input Integer in_i_oi;
  input DAE.ExpType in_i_t;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_oi, in_i_t)
    local
      Tpl.Text txt;
      DAE.ExpType i_t;

    case ( txt,
           0,
           i_t )
      equation
        txt = fun_201(txt, i_t);
      then txt;

    case ( txt,
           _,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_ext"));
      then txt;
  end matchcontinue;
end fun_202;

protected function fun_203
  input Tpl.Text in_txt;
  input Integer in_i_outputIndex;
  input DAE.ComponentRef in_i_c;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_outputIndex, in_i_c)
    local
      Tpl.Text txt;
      DAE.ComponentRef i_c;

    case ( txt,
           0,
           i_c )
      equation
        txt = cref(txt, i_c);
      then txt;

    case ( txt,
           i_outputIndex,
           _ )
      local
        Integer i_outputIndex;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("out.targ"));
        txt = Tpl.writeStr(txt, intString(i_outputIndex));
      then txt;
  end matchcontinue;
end fun_203;

public function extArg
  input Tpl.Text in_txt;
  input SimCode.SimExtArg in_i_it;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_it, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           SimCode.SIMEXTARG(cref = i_c, outputIndex = i_oi, isArray = true, type_ = i_t),
           i_preExp,
           i_varDecls )
      local
        DAE.ExpType i_t;
        Integer i_oi;
        DAE.ComponentRef i_c;
        Tpl.Text i_shortTypeStr;
        Tpl.Text i_name;
      equation
        i_name = fun_199(emptyTxt, i_oi, i_c);
        i_shortTypeStr = expTypeShort(emptyTxt, i_t);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("data_of_"));
        txt = Tpl.writeText(txt, i_shortTypeStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_array(&("));
        txt = Tpl.writeText(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("))"));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           SimCode.SIMEXTARG(cref = i_c, isInput = i_ii, outputIndex = i_oi, type_ = i_t),
           i_preExp,
           i_varDecls )
      local
        DAE.ExpType i_t;
        Integer i_oi;
        Boolean i_ii;
        DAE.ComponentRef i_c;
        Tpl.Text i_suffix;
        Tpl.Text i_prefix;
      equation
        i_prefix = fun_200(emptyTxt, i_oi);
        i_suffix = fun_202(emptyTxt, i_oi, i_t);
        txt = Tpl.writeText(txt, i_prefix);
        txt = cref(txt, i_c);
        txt = Tpl.writeText(txt, i_suffix);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           SimCode.SIMEXTARGEXP(exp = i_exp),
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExp(txt, i_exp, SimCode.contextOther, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           SimCode.SIMEXTARGSIZE(cref = i_c, type_ = i_type__, outputIndex = i_outputIndex, exp = i_exp),
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
        Integer i_outputIndex;
        DAE.ExpType i_type__;
        DAE.ComponentRef i_c;
        Tpl.Text i_dim;
        Tpl.Text i_name;
        Tpl.Text i_typeStr;
      equation
        i_typeStr = expTypeShort(emptyTxt, i_type__);
        i_name = fun_203(emptyTxt, i_outputIndex, i_c);
        (i_dim, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, SimCode.contextOther, i_preExp, i_varDecls);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("size_of_dimension_"));
        txt = Tpl.writeText(txt, i_typeStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_array("));
        txt = Tpl.writeText(txt, i_name);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_dim);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end extArg;

protected function lm_205
  input Tpl.Text in_txt;
  input list<SimCode.Statement> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           i_stmt :: rest,
           i_varDecls )
      local
        list<SimCode.Statement> rest;
        SimCode.Statement i_stmt;
      equation
        (txt, i_varDecls) = funStatement(txt, i_stmt, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_205(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<SimCode.Statement> rest;
      equation
        (txt, i_varDecls) = lm_205(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_205;

public function funBody
  input Tpl.Text txt;
  input list<SimCode.Statement> i_body;

  output Tpl.Text out_txt;
protected
  Tpl.Text i_bodyPart;
  Tpl.Text i_varDecls;
algorithm
  i_varDecls := emptyTxt;
  i_bodyPart := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_bodyPart, i_varDecls) := lm_205(i_bodyPart, i_body, i_varDecls);
  i_bodyPart := Tpl.popIter(i_bodyPart);
  out_txt := Tpl.writeText(txt, i_varDecls);
  out_txt := Tpl.softNewLine(out_txt);
  out_txt := Tpl.writeText(out_txt, i_bodyPart);
end funBody;

protected function lm_207
  input Tpl.Text in_txt;
  input list<DAE.Statement> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls )
      local
        list<DAE.Statement> rest;
        DAE.Statement i_it;
      equation
        (txt, i_varDecls) = algStatement(txt, i_it, SimCode.contextOther, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_207(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<DAE.Statement> rest;
      equation
        (txt, i_varDecls) = lm_207(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_207;

public function funStatement
  input Tpl.Text in_txt;
  input SimCode.Statement in_i_it;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_it, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           SimCode.ALGORITHM(statementLst = i_statementLst),
           i_varDecls )
      local
        list<DAE.Statement> i_statementLst;
      equation
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (txt, i_varDecls) = lm_207(txt, i_statementLst, i_varDecls);
        txt = Tpl.popIter(txt);
      then (txt, i_varDecls);

    case ( txt,
           _,
           i_varDecls )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("/* not implemented fun statement */"));
      then (txt, i_varDecls);
  end matchcontinue;
end funStatement;

protected function fun_209
  input Tpl.Text in_txt;
  input String in_it;
  input DAE.ComponentRef in_i_cref;
  input Tpl.Text in_i_expPart;
  input DAE.ExpType in_i_t;
  input Tpl.Text in_i_preExp;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_it, in_i_cref, in_i_expPart, in_i_t, in_i_preExp)
    local
      Tpl.Text txt;
      DAE.ComponentRef i_cref;
      Tpl.Text i_expPart;
      DAE.ExpType i_t;
      Tpl.Text i_preExp;

    case ( txt,
           "",
           i_cref,
           i_expPart,
           i_t,
           i_preExp )
      equation
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("copy_"));
        txt = expTypeArray(txt, i_t);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_data(&"));
        txt = Tpl.writeText(txt, i_expPart);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", &"));
        txt = cref(txt, i_cref);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
      then txt;

    case ( txt,
           str_3,
           i_cref,
           i_expPart,
           i_t,
           i_preExp )
      local
        String str_3;
      equation
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("indexed_assign_"));
        txt = expTypeArray(txt, i_t);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(&"));
        txt = Tpl.writeText(txt, i_expPart);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", &"));
        txt = cref(txt, i_cref);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", &"));
        txt = Tpl.writeStr(txt, str_3);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
      then txt;
  end matchcontinue;
end fun_209;

protected function lm_210
  input Tpl.Text in_txt;
  input list<DAE.Exp> in_items;
  input Tpl.Text in_i_retStruct;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_items, in_i_retStruct, in_i_varDecls, in_i_preExp, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_retStruct;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      SimCode.Context i_context;

    case ( txt,
           {},
           _,
           i_varDecls,
           i_preExp,
           _ )
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           (it as DAE.CREF(componentRef = _)) :: rest,
           i_retStruct,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<DAE.Exp> rest;
        DAE.Exp it;
        Integer i_i1;
      equation
        i_i1 = Tpl.getIteri_i1(txt);
        (txt, i_preExp, i_varDecls) = scalarLhsCref(txt, it, i_context, i_preExp, i_varDecls);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = "));
        txt = Tpl.writeText(txt, i_retStruct);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(".targ"));
        txt = Tpl.writeStr(txt, intString(i_i1));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls, i_preExp) = lm_210(txt, rest, i_retStruct, i_varDecls, i_preExp, i_context);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _ :: rest,
           i_retStruct,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<DAE.Exp> rest;
      equation
        (txt, i_varDecls, i_preExp) = lm_210(txt, rest, i_retStruct, i_varDecls, i_preExp, i_context);
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end lm_210;

protected function lm_211
  input Tpl.Text in_txt;
  input list<DAE.Statement> in_items;
  input Tpl.Text in_i_varDecls;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDecls,
           _ )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls,
           i_context )
      local
        list<DAE.Statement> rest;
        DAE.Statement i_it;
      equation
        (txt, i_varDecls) = algStatement(txt, i_it, i_context, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_211(txt, rest, i_varDecls, i_context);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_context )
      local
        list<DAE.Statement> rest;
      equation
        (txt, i_varDecls) = lm_211(txt, rest, i_varDecls, i_context);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_211;

protected function fun_212
  input Tpl.Text in_txt;
  input Option<DAE.Exp> in_i_rng_expOption;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_i_rng_expOption, in_i_varDecls, in_i_preExp, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      SimCode.Context i_context;

    case ( txt,
           SOME(i_eo),
           i_varDecls,
           i_preExp,
           i_context )
      local
        DAE.Exp i_eo;
      equation
        (txt, i_preExp, i_varDecls) = daeExp(txt, i_eo, i_context, i_preExp, i_varDecls);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _,
           i_varDecls,
           i_preExp,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(1)"));
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end fun_212;

protected function lm_213
  input Tpl.Text in_txt;
  input list<DAE.Statement> in_items;
  input Tpl.Text in_i_varDecls;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDecls,
           _ )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls,
           i_context )
      local
        list<DAE.Statement> rest;
        DAE.Statement i_it;
      equation
        (txt, i_varDecls) = algStatement(txt, i_it, i_context, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_213(txt, rest, i_varDecls, i_context);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_context )
      local
        list<DAE.Statement> rest;
      equation
        (txt, i_varDecls) = lm_213(txt, rest, i_varDecls, i_context);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_213;

protected function lm_214
  input Tpl.Text in_txt;
  input list<DAE.Statement> in_items;
  input Tpl.Text in_i_varDecls;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDecls,
           _ )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls,
           i_context )
      local
        list<DAE.Statement> rest;
        DAE.Statement i_it;
      equation
        (txt, i_varDecls) = algStatement(txt, i_it, i_context, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_214(txt, rest, i_varDecls, i_context);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_context )
      local
        list<DAE.Statement> rest;
      equation
        (txt, i_varDecls) = lm_214(txt, rest, i_varDecls, i_context);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_214;

protected function fun_215
  input Tpl.Text in_txt;
  input Boolean in_i_boolean;
  input Tpl.Text in_i_ivar;
  input Tpl.Text in_i_identType;
  input Tpl.Text in_i_tvar;
  input Tpl.Text in_i_evar;
  input Tpl.Text in_i_arrayType;
  input Tpl.Text in_i_id;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_boolean, in_i_ivar, in_i_identType, in_i_tvar, in_i_evar, in_i_arrayType, in_i_id)
    local
      Tpl.Text txt;
      Tpl.Text i_ivar;
      Tpl.Text i_identType;
      Tpl.Text i_tvar;
      Tpl.Text i_evar;
      Tpl.Text i_arrayType;
      Tpl.Text i_id;

    case ( txt,
           false,
           _,
           _,
           i_tvar,
           i_evar,
           i_arrayType,
           i_id )
      equation
        txt = Tpl.writeText(txt, i_id);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = *("));
        txt = Tpl.writeText(txt, i_arrayType);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_element_addr1(&"));
        txt = Tpl.writeText(txt, i_evar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", 1, "));
        txt = Tpl.writeText(txt, i_tvar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("));"));
      then txt;

    case ( txt,
           _,
           i_ivar,
           i_identType,
           i_tvar,
           i_evar,
           _,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("simple_index_alloc_"));
        txt = Tpl.writeText(txt, i_identType);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("1(&"));
        txt = Tpl.writeText(txt, i_evar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_tvar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", &"));
        txt = Tpl.writeText(txt, i_ivar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
      then txt;
  end matchcontinue;
end fun_215;

protected function lm_216
  input Tpl.Text in_txt;
  input list<DAE.Statement> in_items;
  input Tpl.Text in_i_varDecls;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDecls,
           _ )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls,
           i_context )
      local
        list<DAE.Statement> rest;
        DAE.Statement i_it;
      equation
        (txt, i_varDecls) = algStatement(txt, i_it, i_context, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_216(txt, rest, i_varDecls, i_context);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_context )
      local
        list<DAE.Statement> rest;
      equation
        (txt, i_varDecls) = lm_216(txt, rest, i_varDecls, i_context);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_216;

protected function fun_217
  input Tpl.Text in_txt;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_varDecls;
  input DAE.Statement in_i_when;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_context, in_i_varDecls, in_i_when)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      DAE.Statement i_when;

    case ( txt,
           (i_context as SimCode.SIMULATION(genDiscrete = true)),
           i_varDecls,
           i_when )
      local
        SimCode.Context i_context;
      equation
        (txt, i_varDecls) = algStatementWhen(txt, i_when, i_context, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _,
           i_varDecls,
           _ )
      then (txt, i_varDecls);
  end matchcontinue;
end fun_217;

public function algStatement
  input Tpl.Text in_txt;
  input DAE.Statement in_i_it;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_it, in_i_context, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.STMT_ASSIGN(exp1 = DAE.CREF(componentRef = DAE.WILD()), exp = i_e),
           i_context,
           i_varDecls )
      local
        DAE.Exp i_e;
        Tpl.Text i_expPart;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_expPart, i_preExp, i_varDecls) = daeExp(emptyTxt, i_e, i_context, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
      then (txt, i_varDecls);

    case ( txt,
           DAE.STMT_ASSIGN(exp1 = (i_exp1 as DAE.CREF(componentRef = _)), exp = i_exp),
           i_context,
           i_varDecls )
      local
        DAE.Exp i_exp;
        DAE.Exp i_exp1;
        Tpl.Text i_expPart;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_expPart, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, i_context, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        (txt, i_preExp, i_varDecls) = scalarLhsCref(txt, i_exp1, i_context, i_preExp, i_varDecls);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = "));
        txt = Tpl.writeText(txt, i_expPart);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
      then (txt, i_varDecls);

    case ( txt,
           DAE.STMT_ASSIGN(exp1 = i_exp1, exp = i_exp),
           i_context,
           i_varDecls )
      local
        DAE.Exp i_exp;
        DAE.Exp i_exp1;
        Tpl.Text i_expPart2;
        Tpl.Text i_expPart1;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_expPart1, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp1, i_context, i_preExp, i_varDecls);
        (i_expPart2, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, i_context, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeText(txt, i_expPart1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = "));
        txt = Tpl.writeText(txt, i_expPart2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(";"));
      then (txt, i_varDecls);

    case ( txt,
           DAE.STMT_ASSIGN_ARR(exp = i_e, componentRef = i_cref, type_ = i_t),
           i_context,
           i_varDecls )
      local
        DAE.ExpType i_t;
        DAE.ComponentRef i_cref;
        DAE.Exp i_e;
        String str_3;
        Tpl.Text txt_2;
        Tpl.Text i_expPart;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_expPart, i_preExp, i_varDecls) = daeExp(emptyTxt, i_e, i_context, i_preExp, i_varDecls);
        (txt_2, i_preExp, i_varDecls) = indexSpecFromCref(emptyTxt, i_cref, i_context, i_preExp, i_varDecls);
        str_3 = Tpl.textString(txt_2);
        txt = fun_209(txt, str_3, i_cref, i_expPart, i_t, i_preExp);
      then (txt, i_varDecls);

    case ( txt,
           DAE.STMT_TUPLE_ASSIGN(exp = (i_exp as DAE.CALL(path = _)), expExpLst = i_expExpLst),
           i_context,
           i_varDecls )
      local
        list<DAE.Exp> i_expExpLst;
        DAE.Exp i_exp;
        Tpl.Text i_retStruct;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_retStruct, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, i_context, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (txt, i_varDecls, i_preExp) = lm_210(txt, i_expExpLst, i_retStruct, i_varDecls, i_preExp, i_context);
        txt = Tpl.popIter(txt);
      then (txt, i_varDecls);

    case ( txt,
           DAE.STMT_IF(exp = i_exp, statementLst = i_statementLst, else_ = i_else__),
           i_context,
           i_varDecls )
      local
        DAE.Else i_else__;
        list<DAE.Statement> i_statementLst;
        DAE.Exp i_exp;
        Tpl.Text i_condExp;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_condExp, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, i_context, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("if ("));
        txt = Tpl.writeText(txt, i_condExp);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(") {\n"));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (txt, i_varDecls) = lm_211(txt, i_statementLst, i_varDecls, i_context);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("}\n"));
        (txt, i_varDecls) = elseExpr(txt, i_else__, i_context, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           DAE.STMT_FOR(exp = (i_rng as DAE.RANGE(exp = i_rng_exp, expOption = i_rng_expOption, range = i_rng_range)), type_ = i_type__, boolean = i_boolean, ident = i_ident, statementLst = i_statementLst),
           i_context,
           i_varDecls )
      local
        list<DAE.Statement> i_statementLst;
        DAE.Ident i_ident;
        Boolean i_boolean;
        DAE.ExpType i_type__;
        DAE.Exp i_rng_range;
        Option<DAE.Exp> i_rng_expOption;
        DAE.Exp i_rng_exp;
        DAE.Exp i_rng;
        Tpl.Text i_er3;
        Tpl.Text i_er2;
        Tpl.Text i_er1;
        Tpl.Text i_preExp;
        Tpl.Text i_r3;
        Tpl.Text i_r2;
        Tpl.Text i_r1;
        Tpl.Text i_identType;
        Integer ret_2;
        Tpl.Text i_dvar;
        Tpl.Text i_stateVar;
      equation
        (i_stateVar, i_varDecls) = tempDecl(emptyTxt, "state", i_varDecls);
        ret_2 = System.tmpTick();
        i_dvar = Tpl.writeStr(emptyTxt, intString(ret_2));
        i_identType = expType(emptyTxt, i_type__, i_boolean);
        (i_r1, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_identType), i_varDecls);
        (i_r2, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_identType), i_varDecls);
        (i_r3, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_identType), i_varDecls);
        i_preExp = emptyTxt;
        (i_er1, i_preExp, i_varDecls) = daeExp(emptyTxt, i_rng_exp, i_context, i_preExp, i_varDecls);
        (i_er2, i_varDecls, i_preExp) = fun_212(emptyTxt, i_rng_expOption, i_varDecls, i_preExp, i_context);
        (i_er3, i_preExp, i_varDecls) = daeExp(emptyTxt, i_rng_range, i_context, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeText(txt, i_r1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = "));
        txt = Tpl.writeText(txt, i_er1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("; "));
        txt = Tpl.writeText(txt, i_r2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = "));
        txt = Tpl.writeText(txt, i_er2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("; "));
        txt = Tpl.writeText(txt, i_r3);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = "));
        txt = Tpl.writeText(txt, i_er3);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    ";\n",
                                    "{\n"
                                }, true));
        txt = Tpl.writeText(txt, i_identType);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" "));
        txt = Tpl.writeStr(txt, i_ident);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    ";\n",
                                    "\n"
                                }, true));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("for ("));
        txt = Tpl.writeStr(txt, i_ident);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = "));
        txt = Tpl.writeText(txt, i_r1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("; in_range_"));
        txt = expTypeShort(txt, i_type__);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeStr(txt, i_ident);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_r1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_r3);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("); "));
        txt = Tpl.writeStr(txt, i_ident);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" += "));
        txt = Tpl.writeText(txt, i_r2);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(") {\n"));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.writeText(txt, i_stateVar);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(" = get_memory_state();\n"));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (txt, i_varDecls) = lm_213(txt, i_statementLst, i_varDecls, i_context);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("restore_memory_state("));
        txt = Tpl.writeText(txt, i_stateVar);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(");\n"));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("}\n"));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("} /*end for*/"));
      then (txt, i_varDecls);

    case ( txt,
           DAE.STMT_FOR(type_ = i_type__, boolean = i_boolean, exp = i_exp, statementLst = i_statementLst, ident = i_ident),
           i_context,
           i_varDecls )
      local
        DAE.Ident i_ident;
        list<DAE.Statement> i_statementLst;
        DAE.Exp i_exp;
        Boolean i_boolean;
        DAE.ExpType i_type__;
        Tpl.Text i_stmtStuff;
        Tpl.Text i_id;
        Tpl.Text i_statements;
        Tpl.Text i_evar;
        Tpl.Text i_preExp;
        Tpl.Text i_ivar;
        Tpl.Text i_identType;
        Tpl.Text i_tvar;
        Integer ret_3;
        Tpl.Text i_dvar;
        Tpl.Text i_arrayType;
        Tpl.Text i_stateVar;
      equation
        (i_stateVar, i_varDecls) = tempDecl(emptyTxt, "state", i_varDecls);
        i_arrayType = expTypeArray(emptyTxt, i_type__);
        ret_3 = System.tmpTick();
        i_dvar = Tpl.writeStr(emptyTxt, intString(ret_3));
        (i_tvar, i_varDecls) = tempDecl(emptyTxt, "int", i_varDecls);
        i_identType = expType(emptyTxt, i_type__, i_boolean);
        (i_ivar, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_identType), i_varDecls);
        i_preExp = emptyTxt;
        (i_evar, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, i_context, i_preExp, i_varDecls);
        i_statements = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_statements, i_varDecls) = lm_214(i_statements, i_statementLst, i_varDecls, i_context);
        i_statements = Tpl.popIter(i_statements);
        i_id = Tpl.writeStr(emptyTxt, i_ident);
        i_stmtStuff = fun_215(emptyTxt, i_boolean, i_ivar, i_identType, i_tvar, i_evar, i_arrayType, i_id);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("{\n"));
        txt = Tpl.writeText(txt, i_identType);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" "));
        txt = Tpl.writeStr(txt, i_ident);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING_LIST({
                                    ";\n",
                                    "\n"
                                }, true));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("for ("));
        txt = Tpl.writeText(txt, i_tvar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" = 1; "));
        txt = Tpl.writeText(txt, i_tvar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" <= size_of_dimension_"));
        txt = Tpl.writeText(txt, i_arrayType);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_evar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", 1); ++"));
        txt = Tpl.writeText(txt, i_tvar);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(") {\n"));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.writeText(txt, i_stateVar);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(" = get_memory_state();\n"));
        txt = Tpl.writeText(txt, i_stmtStuff);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeText(txt, i_statements);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("restore_memory_state("));
        txt = Tpl.writeText(txt, i_stateVar);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(");\n"));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("}\n"));
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("} /* end for*/"));
      then (txt, i_varDecls);

    case ( txt,
           DAE.STMT_WHILE(exp = i_exp, statementLst = i_statementLst),
           i_context,
           i_varDecls )
      local
        list<DAE.Statement> i_statementLst;
        DAE.Exp i_exp;
        Tpl.Text i_var;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_var, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, i_context, i_preExp, i_varDecls);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("while (1) {\n"));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("if (!"));
        txt = Tpl.writeText(txt, i_var);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(") break;\n"));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (txt, i_varDecls) = lm_216(txt, i_statementLst, i_varDecls, i_context);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("}"));
      then (txt, i_varDecls);

    case ( txt,
           DAE.STMT_ASSERT(cond = i_cond, msg = i_msg),
           i_context,
           i_varDecls )
      local
        DAE.Exp i_msg;
        DAE.Exp i_cond;
        Tpl.Text i_msgVar;
        Tpl.Text i_condVar;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_condVar, i_preExp, i_varDecls) = daeExp(emptyTxt, i_cond, i_context, i_preExp, i_varDecls);
        (i_msgVar, i_preExp, i_varDecls) = daeExp(emptyTxt, i_msg, i_context, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("MODELICA_ASSERT("));
        txt = Tpl.writeText(txt, i_condVar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_msgVar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
      then (txt, i_varDecls);

    case ( txt,
           (i_when as DAE.STMT_WHEN(exp = _)),
           i_context,
           i_varDecls )
      local
        DAE.Statement i_when;
      equation
        (txt, i_varDecls) = fun_217(txt, i_context, i_varDecls, i_when);
      then (txt, i_varDecls);

    case ( txt,
           _,
           _,
           i_varDecls )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("/* not implemented alg statement*/"));
      then (txt, i_varDecls);
  end matchcontinue;
end algStatement;

protected function lm_219
  input Tpl.Text in_txt;
  input list<DAE.Statement> in_items;
  input Tpl.Text in_i_varDecls;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDecls,
           _ )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls,
           i_context )
      local
        list<DAE.Statement> rest;
        DAE.Statement i_it;
      equation
        (txt, i_varDecls) = algStatement(txt, i_it, i_context, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_219(txt, rest, i_varDecls, i_context);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_context )
      local
        list<DAE.Statement> rest;
      equation
        (txt, i_varDecls) = lm_219(txt, rest, i_varDecls, i_context);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_219;

protected function lm_220
  input Tpl.Text in_txt;
  input list<Integer> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<Integer> rest;
        Integer i_it;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("edge(localData->helpVars["));
        txt = Tpl.writeStr(txt, intString(i_it));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("])"));
        txt = Tpl.nextIter(txt);
        txt = lm_220(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<Integer> rest;
      equation
        txt = lm_220(txt, rest);
      then txt;
  end matchcontinue;
end lm_220;

public function algStatementWhen
  input Tpl.Text in_txt;
  input DAE.Statement in_i_it;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_it, in_i_context, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_varDecls;

    case ( txt,
           (i_it as DAE.STMT_WHEN(statementLst = i_statementLst, elseWhen = i_elseWhen, helpVarIndices = i_helpVarIndices)),
           i_context,
           i_varDecls )
      local
        list<Integer> i_helpVarIndices;
        Option<DAE.Statement> i_elseWhen;
        list<DAE.Statement> i_statementLst;
        DAE.Statement i_it;
        Tpl.Text i_else;
        Tpl.Text i_statements;
        Tpl.Text i_preIf;
      equation
        (i_preIf, i_varDecls) = algStatementWhenPre(emptyTxt, i_it, i_varDecls);
        i_statements = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_statements, i_varDecls) = lm_219(i_statements, i_statementLst, i_varDecls, i_context);
        i_statements = Tpl.popIter(i_statements);
        (i_else, i_varDecls) = algStatementWhenElse(emptyTxt, i_elseWhen, i_varDecls);
        txt = Tpl.writeText(txt, i_preIf);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("if ("));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(" || ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_220(txt, i_helpVarIndices);
        txt = Tpl.popIter(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(") {\n"));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.writeText(txt, i_statements);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("}\n"));
        txt = Tpl.writeText(txt, i_else);
      then (txt, i_varDecls);

    case ( txt,
           _,
           _,
           i_varDecls )
      then (txt, i_varDecls);
  end matchcontinue;
end algStatementWhen;

protected function fun_222
  input Tpl.Text in_txt;
  input Option<DAE.Statement> in_i_elseWhen;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_elseWhen, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           SOME(i_ew),
           i_varDecls )
      local
        DAE.Statement i_ew;
      equation
        (txt, i_varDecls) = algStatementWhenPre(txt, i_ew, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _,
           i_varDecls )
      then (txt, i_varDecls);
  end matchcontinue;
end fun_222;

protected function fun_223
  input Tpl.Text in_txt;
  input Option<DAE.Statement> in_i_when_elseWhen;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_when_elseWhen, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           SOME(i_ew),
           i_varDecls )
      local
        DAE.Statement i_ew;
      equation
        (txt, i_varDecls) = algStatementWhenPre(txt, i_ew, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _,
           i_varDecls )
      then (txt, i_varDecls);
  end matchcontinue;
end fun_223;

protected function fun_224
  input Tpl.Text in_txt;
  input list<Integer> in_i_helpVarIndices;
  input DAE.Exp in_i_when_exp;
  input Tpl.Text in_i_varDecls;
  input Option<DAE.Statement> in_i_when_elseWhen;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_helpVarIndices, in_i_when_exp, in_i_varDecls, in_i_when_elseWhen)
    local
      Tpl.Text txt;
      DAE.Exp i_when_exp;
      Tpl.Text i_varDecls;
      Option<DAE.Statement> i_when_elseWhen;

    case ( txt,
           {i_i},
           i_when_exp,
           i_varDecls,
           i_when_elseWhen )
      local
        Integer i_i;
        Tpl.Text i_res;
        Tpl.Text i_preExp;
        Tpl.Text i_restPre;
      equation
        (i_restPre, i_varDecls) = fun_223(emptyTxt, i_when_elseWhen, i_varDecls);
        i_preExp = emptyTxt;
        (i_res, i_preExp, i_varDecls) = daeExp(emptyTxt, i_when_exp, SimCode.contextSimulationDescrete, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("localData->helpVars["));
        txt = Tpl.writeStr(txt, intString(i_i));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("] = "));
        txt = Tpl.writeText(txt, i_res);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(";\n"));
        txt = Tpl.writeText(txt, i_restPre);
      then (txt, i_varDecls);

    case ( txt,
           _,
           _,
           i_varDecls,
           _ )
      then (txt, i_varDecls);
  end matchcontinue;
end fun_224;

public function algStatementWhenPre
  input Tpl.Text in_txt;
  input DAE.Statement in_i_it;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_it, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.STMT_WHEN(exp = DAE.ARRAY(array = i_el), elseWhen = i_elseWhen, helpVarIndices = i_helpVarIndices),
           i_varDecls )
      local
        list<Integer> i_helpVarIndices;
        Option<DAE.Statement> i_elseWhen;
        list<DAE.Exp> i_el;
        Tpl.Text i_assignments;
        Tpl.Text i_preExp;
        Tpl.Text i_restPre;
      equation
        (i_restPre, i_varDecls) = fun_222(emptyTxt, i_elseWhen, i_varDecls);
        i_preExp = emptyTxt;
        (i_assignments, i_preExp, i_varDecls) = algStatementWhenPreAssigns(emptyTxt, i_el, i_helpVarIndices, i_preExp, i_varDecls);
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeText(txt, i_assignments);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeText(txt, i_restPre);
      then (txt, i_varDecls);

    case ( txt,
           (i_when as DAE.STMT_WHEN(helpVarIndices = i_helpVarIndices, elseWhen = i_when_elseWhen, exp = i_when_exp)),
           i_varDecls )
      local
        DAE.Exp i_when_exp;
        Option<DAE.Statement> i_when_elseWhen;
        list<Integer> i_helpVarIndices;
        DAE.Statement i_when;
      equation
        (txt, i_varDecls) = fun_224(txt, i_helpVarIndices, i_when_exp, i_varDecls, i_when_elseWhen);
      then (txt, i_varDecls);

    case ( txt,
           _,
           i_varDecls )
      then (txt, i_varDecls);
  end matchcontinue;
end algStatementWhenPre;

protected function lm_226
  input Tpl.Text in_txt;
  input list<DAE.Statement> in_items;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls )
      local
        list<DAE.Statement> rest;
        DAE.Statement i_it;
      equation
        (txt, i_varDecls) = algStatement(txt, i_it, SimCode.contextSimulationDescrete, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_226(txt, rest, i_varDecls);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls )
      local
        list<DAE.Statement> rest;
      equation
        (txt, i_varDecls) = lm_226(txt, rest, i_varDecls);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_226;

protected function lm_227
  input Tpl.Text in_txt;
  input list<Integer> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           i_it :: rest )
      local
        list<Integer> rest;
        Integer i_it;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("edge(localData->helpVars["));
        txt = Tpl.writeStr(txt, intString(i_it));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("])"));
        txt = Tpl.nextIter(txt);
        txt = lm_227(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<Integer> rest;
      equation
        txt = lm_227(txt, rest);
      then txt;
  end matchcontinue;
end lm_227;

public function algStatementWhenElse
  input Tpl.Text in_txt;
  input Option<DAE.Statement> in_i_it;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_it, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;

    case ( txt,
           SOME((i_when as DAE.STMT_WHEN(statementLst = i_when_statementLst, elseWhen = i_when_elseWhen, helpVarIndices = i_when_helpVarIndices))),
           i_varDecls )
      local
        list<Integer> i_when_helpVarIndices;
        Option<DAE.Statement> i_when_elseWhen;
        list<DAE.Statement> i_when_statementLst;
        DAE.Statement i_when;
        Tpl.Text i_else;
        Tpl.Text i_statements;
      equation
        i_statements = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_statements, i_varDecls) = lm_226(i_statements, i_when_statementLst, i_varDecls);
        i_statements = Tpl.popIter(i_statements);
        (i_else, i_varDecls) = algStatementWhenElse(emptyTxt, i_when_elseWhen, i_varDecls);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("else if ("));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(" || ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        txt = lm_227(txt, i_when_helpVarIndices);
        txt = Tpl.popIter(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(") {\n"));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.writeText(txt, i_statements);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("}\n"));
        txt = Tpl.writeText(txt, i_else);
      then (txt, i_varDecls);

    case ( txt,
           _,
           i_varDecls )
      then (txt, i_varDecls);
  end matchcontinue;
end algStatementWhenElse;

protected function fun_229
  input Tpl.Text in_txt;
  input list<Integer> in_i_ints;
  input DAE.Exp in_i_firstExp;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input list<DAE.Exp> in_i_restExps;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_i_ints, in_i_firstExp, in_i_varDecls, in_i_preExp, in_i_restExps)
    local
      Tpl.Text txt;
      DAE.Exp i_firstExp;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      list<DAE.Exp> i_restExps;

    case ( txt,
           i_firstInt :: i_restInts,
           i_firstExp,
           i_varDecls,
           i_preExp,
           i_restExps )
      local
        list<Integer> i_restInts;
        Integer i_firstInt;
        Tpl.Text i_rest;
      equation
        (i_rest, i_preExp, i_varDecls) = algStatementWhenPreAssigns(emptyTxt, i_restExps, i_restInts, i_preExp, i_varDecls);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("localData->helpVars["));
        txt = Tpl.writeStr(txt, intString(i_firstInt));
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("] = "));
        (txt, i_preExp, i_varDecls) = daeExp(txt, i_firstExp, SimCode.contextSimulationDescrete, i_preExp, i_varDecls);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(";\n"));
        txt = Tpl.writeText(txt, i_rest);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _,
           _,
           i_varDecls,
           i_preExp,
           _ )
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end fun_229;

public function algStatementWhenPreAssigns
  input Tpl.Text in_txt;
  input list<DAE.Exp> in_i_exps;
  input list<Integer> in_i_ints;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exps, in_i_ints, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      list<Integer> i_ints;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           {},
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           i_firstExp :: i_restExps,
           i_ints,
           i_preExp,
           i_varDecls )
      local
        list<DAE.Exp> i_restExps;
        DAE.Exp i_firstExp;
      equation
        (txt, i_varDecls, i_preExp) = fun_229(txt, i_ints, i_firstExp, i_varDecls, i_preExp, i_restExps);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end algStatementWhenPreAssigns;

protected function lm_231
  input Tpl.Text in_txt;
  input list<DAE.Statement> in_items;
  input Tpl.Text in_i_varDecls;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDecls,
           _ )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls,
           i_context )
      local
        list<DAE.Statement> rest;
        DAE.Statement i_it;
      equation
        (txt, i_varDecls) = algStatement(txt, i_it, i_context, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_231(txt, rest, i_varDecls, i_context);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_context )
      local
        list<DAE.Statement> rest;
      equation
        (txt, i_varDecls) = lm_231(txt, rest, i_varDecls, i_context);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_231;

protected function lm_232
  input Tpl.Text in_txt;
  input list<DAE.Statement> in_items;
  input Tpl.Text in_i_varDecls;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDecls,
           _ )
      then (txt, i_varDecls);

    case ( txt,
           i_it :: rest,
           i_varDecls,
           i_context )
      local
        list<DAE.Statement> rest;
        DAE.Statement i_it;
      equation
        (txt, i_varDecls) = algStatement(txt, i_it, i_context, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls) = lm_232(txt, rest, i_varDecls, i_context);
      then (txt, i_varDecls);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_context )
      local
        list<DAE.Statement> rest;
      equation
        (txt, i_varDecls) = lm_232(txt, rest, i_varDecls, i_context);
      then (txt, i_varDecls);
  end matchcontinue;
end lm_232;

public function elseExpr
  input Tpl.Text in_txt;
  input DAE.Else in_i_it;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_it, in_i_context, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.NOELSE(),
           _,
           i_varDecls )
      then (txt, i_varDecls);

    case ( txt,
           DAE.ELSEIF(exp = i_exp, statementLst = i_statementLst, else_ = i_else__),
           i_context,
           i_varDecls )
      local
        DAE.Else i_else__;
        list<DAE.Statement> i_statementLst;
        DAE.Exp i_exp;
        Tpl.Text i_condExp;
        Tpl.Text i_preExp;
      equation
        i_preExp = emptyTxt;
        (i_condExp, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, i_context, i_preExp, i_varDecls);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("else {\n"));
        txt = Tpl.writeText(txt, i_preExp);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("if ("));
        txt = Tpl.writeText(txt, i_condExp);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE(") {\n"));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (txt, i_varDecls) = lm_231(txt, i_statementLst, i_varDecls, i_context);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("}\n"));
        (txt, i_varDecls) = elseExpr(txt, i_else__, i_context, i_varDecls);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("}"));
      then (txt, i_varDecls);

    case ( txt,
           DAE.ELSE(statementLst = i_statementLst),
           i_context,
           i_varDecls )
      local
        list<DAE.Statement> i_statementLst;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("else {\n"));
        txt = Tpl.pushBlock(txt, Tpl.BT_INDENT(2));
        txt = Tpl.pushIter(txt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (txt, i_varDecls) = lm_232(txt, i_statementLst, i_varDecls, i_context);
        txt = Tpl.popIter(txt);
        txt = Tpl.softNewLine(txt);
        txt = Tpl.popBlock(txt);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("}"));
      then (txt, i_varDecls);

    case ( txt,
           _,
           _,
           i_varDecls )
      then (txt, i_varDecls);
  end matchcontinue;
end elseExpr;

protected function fun_234
  input Tpl.Text in_txt;
  input Boolean in_it;
  input DAE.ComponentRef in_i_cref_componentRef;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;
  input DAE.Exp in_i_cref;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_it, in_i_cref_componentRef, in_i_varDecls, in_i_preExp, in_i_context, in_i_cref)
    local
      Tpl.Text txt;
      DAE.ComponentRef i_cref_componentRef;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      SimCode.Context i_context;
      DAE.Exp i_cref;

    case ( txt,
           false,
           _,
           i_varDecls,
           i_preExp,
           i_context,
           i_cref )
      equation
        (txt, i_preExp, i_varDecls) = daeExpCrefRhs(txt, i_cref, i_context, i_preExp, i_varDecls);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _,
           i_cref_componentRef,
           i_varDecls,
           i_preExp,
           _,
           _ )
      equation
        txt = cref(txt, i_cref_componentRef);
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end fun_234;

public function scalarLhsCref
  input Tpl.Text in_txt;
  input DAE.Exp in_i_cref;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_cref, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           (i_cref as DAE.CREF(componentRef = (i_cref_componentRef as DAE.CREF_IDENT(subscriptLst = i_subs)))),
           i_context,
           i_preExp,
           i_varDecls )
      local
        list<DAE.Subscript> i_subs;
        DAE.ComponentRef i_cref_componentRef;
        DAE.Exp i_cref;
        Boolean ret_0;
      equation
        ret_0 = SimCode.crefNoSub(i_cref_componentRef);
        (txt, i_varDecls, i_preExp) = fun_234(txt, ret_0, i_cref_componentRef, i_varDecls, i_preExp, i_context, i_cref);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_cref as DAE.CREF(componentRef = (i_cref_componentRef as DAE.CREF_QUAL(subscriptLst = i_subs)))),
           _,
           i_preExp,
           i_varDecls )
      local
        list<DAE.Subscript> i_subs;
        DAE.ComponentRef i_cref_componentRef;
        DAE.Exp i_cref;
      equation
        txt = cref(txt, i_cref_componentRef);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("ONLY IDENT SUPPORTED"));
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end scalarLhsCref;

public function rhsCref
  input Tpl.Text in_txt;
  input DAE.ComponentRef in_i_it;
  input DAE.ExpType in_i_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it, in_i_ty)
    local
      Tpl.Text txt;
      DAE.ExpType i_ty;

    case ( txt,
           DAE.CREF_IDENT(ident = i_ident),
           i_ty )
      local
        DAE.Ident i_ident;
      equation
        txt = rhsCrefType(txt, i_ty);
        txt = Tpl.writeStr(txt, i_ident);
      then txt;

    case ( txt,
           DAE.CREF_QUAL(ident = i_ident, componentRef = i_componentRef),
           i_ty )
      local
        DAE.ComponentRef i_componentRef;
        DAE.Ident i_ident;
      equation
        txt = rhsCrefType(txt, i_ty);
        txt = Tpl.writeStr(txt, i_ident);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("."));
        txt = rhsCref(txt, i_componentRef, i_ty);
      then txt;

    case ( txt,
           _,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("rhsCref:ERROR"));
      then txt;
  end matchcontinue;
end rhsCref;

public function rhsCrefType
  input Tpl.Text in_txt;
  input DAE.ExpType in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.ET_INT() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(modelica_integer)"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end rhsCrefType;

protected function fun_238
  input Tpl.Text in_txt;
  input Boolean in_i_bool;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_bool)
    local
      Tpl.Text txt;

    case ( txt,
           false )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(0)"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(1)"));
      then txt;
  end matchcontinue;
end fun_238;

public function daeExp
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.ICONST(integer = i_integer),
           _,
           i_preExp,
           i_varDecls )
      local
        Integer i_integer;
      equation
        txt = Tpl.writeStr(txt, intString(i_integer));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.RCONST(real = i_real),
           _,
           i_preExp,
           i_varDecls )
      local
        Real i_real;
      equation
        txt = Tpl.writeStr(txt, realString(i_real));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.SCONST(string = i_string),
           _,
           i_preExp,
           i_varDecls )
      local
        String i_string;
      equation
        (txt, i_preExp, i_varDecls) = daeExpSconst(txt, i_string, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.BCONST(bool = i_bool),
           _,
           i_preExp,
           i_varDecls )
      local
        Boolean i_bool;
      equation
        txt = fun_238(txt, i_bool);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_exp as DAE.CREF(componentRef = _)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExpCrefRhs(txt, i_exp, i_context, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_exp as DAE.BINARY(exp1 = _)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExpBinary(txt, i_exp, i_context, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_exp as DAE.UNARY(operator = _)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExpUnary(txt, i_exp, i_context, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_exp as DAE.LBINARY(exp1 = _)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExpLbinary(txt, i_exp, i_context, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_exp as DAE.LUNARY(operator = _)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExpLunary(txt, i_exp, i_context, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_exp as DAE.RELATION(exp1 = _)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExpRelation(txt, i_exp, i_context, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_exp as DAE.IFEXP(expCond = _)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExpIf(txt, i_exp, i_context, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_exp as DAE.CALL(path = _)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExpCall(txt, i_exp, i_context, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_exp as DAE.ARRAY(ty = _)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExpArray(txt, i_exp, i_context, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_exp as DAE.MATRIX(ty = _)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExpMatrix(txt, i_exp, i_context, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_exp as DAE.CAST(ty = _)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExpCast(txt, i_exp, i_context, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_exp as DAE.ASUB(exp = _)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExpAsub(txt, i_exp, i_context, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_exp as DAE.SIZE(exp = _)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExpSize(txt, i_exp, i_context, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_exp as DAE.REDUCTION(path = _)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExpReduction(txt, i_exp, i_context, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_exp as DAE.VALUEBLOCK(ty = _)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExpValueblock(txt, i_exp, i_context, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("UNKNOWN_EXP"));
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExp;

public function daeExpSconst
  input Tpl.Text txt;
  input String i_string;
  input Tpl.Text i_preExp;
  input Tpl.Text i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
protected
  String ret_1;
  Tpl.Text i_strVar;
algorithm
  (i_strVar, out_i_varDecls) := tempDecl(emptyTxt, "modelica_string", i_varDecls);
  out_i_preExp := Tpl.writeTok(i_preExp, Tpl.ST_STRING("init_modelica_string(&"));
  out_i_preExp := Tpl.writeText(out_i_preExp, i_strVar);
  out_i_preExp := Tpl.writeTok(out_i_preExp, Tpl.ST_STRING(",\""));
  ret_1 := Util.escapeModelicaStringToCString(i_string);
  out_i_preExp := Tpl.writeStr(out_i_preExp, ret_1);
  out_i_preExp := Tpl.writeTok(out_i_preExp, Tpl.ST_STRING("\");"));
  out_i_preExp := Tpl.writeTok(out_i_preExp, Tpl.ST_NEW_LINE());
  out_txt := Tpl.writeText(txt, i_strVar);
end daeExpSconst;

protected function lm_241
  input Tpl.Text in_txt;
  input list<DAE.Subscript> in_items;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_preExp, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDecls,
           i_preExp,
           _ )
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           DAE.INDEX(exp = i_exp) :: rest,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<DAE.Subscript> rest;
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExp(txt, i_exp, i_context, i_preExp, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls, i_preExp) = lm_241(txt, rest, i_varDecls, i_preExp, i_context);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<DAE.Subscript> rest;
      equation
        (txt, i_varDecls, i_preExp) = lm_241(txt, rest, i_varDecls, i_preExp, i_context);
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end lm_241;

protected function fun_242
  input Tpl.Text in_txt;
  input Boolean in_it;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;
  input list<DAE.Subscript> in_i_subs;
  input Tpl.Text in_i_varDecls;
  input DAE.ExpType in_i_cref_ty;
  input DAE.ComponentRef in_i_cref_componentRef;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_it, in_i_preExp, in_i_context, in_i_subs, in_i_varDecls, in_i_cref_ty, in_i_cref_componentRef)
    local
      Tpl.Text txt;
      Tpl.Text i_preExp;
      SimCode.Context i_context;
      list<DAE.Subscript> i_subs;
      Tpl.Text i_varDecls;
      DAE.ExpType i_cref_ty;
      DAE.ComponentRef i_cref_componentRef;

    case ( txt,
           false,
           i_preExp,
           i_context,
           i_subs,
           i_varDecls,
           i_cref_ty,
           i_cref_componentRef )
      local
        Tpl.Text i_spec1;
        Tpl.Text i_tmp;
        Tpl.Text i_arrayType;
        Tpl.Text i_arrName;
      equation
        i_arrName = cref(emptyTxt, i_cref_componentRef);
        i_arrayType = expTypeArray(emptyTxt, i_cref_ty);
        (i_tmp, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_arrayType), i_varDecls);
        (i_spec1, i_preExp, i_varDecls) = daeExpCrefRhsIndexSpec(emptyTxt, i_subs, i_context, i_preExp, i_varDecls);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("index_alloc_"));
        i_preExp = Tpl.writeText(i_preExp, i_arrayType);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("(&"));
        i_preExp = Tpl.writeText(i_preExp, i_arrName);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", &"));
        i_preExp = Tpl.writeText(i_preExp, i_spec1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", &"));
        i_preExp = Tpl.writeText(i_preExp, i_tmp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_tmp);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           i_preExp,
           i_context,
           i_subs,
           i_varDecls,
           i_cref_ty,
           i_cref_componentRef )
      local
        Tpl.Text i_dimsValuesStr;
        Integer ret_3;
        Tpl.Text i_dimsLenStr;
        Tpl.Text i_arrayType;
        Tpl.Text i_arrName;
      equation
        i_arrName = cref(emptyTxt, i_cref_componentRef);
        i_arrayType = expTypeArray(emptyTxt, i_cref_ty);
        ret_3 = listLength(i_subs);
        i_dimsLenStr = Tpl.writeStr(emptyTxt, intString(ret_3));
        i_dimsValuesStr = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_dimsValuesStr, i_varDecls, i_preExp) = lm_241(i_dimsValuesStr, i_subs, i_varDecls, i_preExp, i_context);
        i_dimsValuesStr = Tpl.popIter(i_dimsValuesStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(*"));
        txt = Tpl.writeText(txt, i_arrayType);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_element_addr(&"));
        txt = Tpl.writeText(txt, i_arrName);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_dimsLenStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_dimsValuesStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("))"));
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end fun_242;

protected function fun_243
  input Tpl.Text in_txt;
  input DAE.ExpType in_i_cref_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_cref_ty)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.ET_INT() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(modelica_integer)"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end fun_243;

protected function fun_244
  input Tpl.Text in_txt;
  input Boolean in_it;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;
  input list<DAE.Subscript> in_i_subs;
  input Tpl.Text in_i_varDecls;
  input DAE.ExpType in_i_cref_ty;
  input DAE.ComponentRef in_i_cref_componentRef;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_it, in_i_preExp, in_i_context, in_i_subs, in_i_varDecls, in_i_cref_ty, in_i_cref_componentRef)
    local
      Tpl.Text txt;
      Tpl.Text i_preExp;
      SimCode.Context i_context;
      list<DAE.Subscript> i_subs;
      Tpl.Text i_varDecls;
      DAE.ExpType i_cref_ty;
      DAE.ComponentRef i_cref_componentRef;

    case ( txt,
           false,
           i_preExp,
           i_context,
           i_subs,
           i_varDecls,
           i_cref_ty,
           i_cref_componentRef )
      local
        Boolean ret_0;
      equation
        ret_0 = SimCode.crefSubIsScalar(i_cref_componentRef);
        (txt, i_preExp, i_varDecls) = fun_242(txt, ret_0, i_preExp, i_context, i_subs, i_varDecls, i_cref_ty, i_cref_componentRef);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           i_preExp,
           _,
           _,
           i_varDecls,
           i_cref_ty,
           i_cref_componentRef )
      local
        Tpl.Text i_cast;
      equation
        i_cast = fun_243(emptyTxt, i_cref_ty);
        txt = Tpl.writeText(txt, i_cast);
        txt = cref(txt, i_cref_componentRef);
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end fun_244;

protected function fun_245
  input Tpl.Text in_txt;
  input String in_it;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;
  input list<DAE.Subscript> in_i_subs;
  input Tpl.Text in_i_varDecls;
  input DAE.ExpType in_i_cref_ty;
  input DAE.ComponentRef in_i_cref_componentRef;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_it, in_i_preExp, in_i_context, in_i_subs, in_i_varDecls, in_i_cref_ty, in_i_cref_componentRef)
    local
      Tpl.Text txt;
      Tpl.Text i_preExp;
      SimCode.Context i_context;
      list<DAE.Subscript> i_subs;
      Tpl.Text i_varDecls;
      DAE.ExpType i_cref_ty;
      DAE.ComponentRef i_cref_componentRef;

    case ( txt,
           "",
           i_preExp,
           i_context,
           i_subs,
           i_varDecls,
           i_cref_ty,
           i_cref_componentRef )
      local
        Boolean ret_0;
      equation
        ret_0 = SimCode.crefNoSub(i_cref_componentRef);
        (txt, i_preExp, i_varDecls) = fun_244(txt, ret_0, i_preExp, i_context, i_subs, i_varDecls, i_cref_ty, i_cref_componentRef);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           str_1,
           i_preExp,
           _,
           _,
           i_varDecls,
           _,
           _ )
      local
        String str_1;
      equation
        txt = Tpl.writeStr(txt, str_1);
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end fun_245;

public function daeExpCrefRhs
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           (i_cref as DAE.CREF(componentRef = (i_cref_componentRef as DAE.CREF_IDENT(subscriptLst = i_subs)), ty = i_cref_ty)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.ExpType i_cref_ty;
        list<DAE.Subscript> i_subs;
        DAE.ComponentRef i_cref_componentRef;
        DAE.Exp i_cref;
        String str_1;
        Tpl.Text txt_0;
      equation
        (txt_0, i_preExp, i_varDecls) = daeExpCrefRhsArrayBox(emptyTxt, i_cref, i_context, i_preExp, i_varDecls);
        str_1 = Tpl.textString(txt_0);
        (txt, i_preExp, i_varDecls) = fun_245(txt, str_1, i_preExp, i_context, i_subs, i_varDecls, i_cref_ty, i_cref_componentRef);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_cref as DAE.CREF(componentRef = (i_cref_componentRef as DAE.CREF_QUAL(subscriptLst = i_subs)))),
           _,
           i_preExp,
           i_varDecls )
      local
        list<DAE.Subscript> i_subs;
        DAE.ComponentRef i_cref_componentRef;
        DAE.Exp i_cref;
      equation
        txt = cref(txt, i_cref_componentRef);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("UNKNOWN RHS CREF: ONLY IDENT SUPPORTED"));
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExpCrefRhs;

protected function fun_247
  input Tpl.Text in_txt;
  input DAE.Subscript in_i_sub;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_i_sub, in_i_varDecls, in_i_preExp, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      SimCode.Context i_context;

    case ( txt,
           DAE.INDEX(exp = i_exp),
           i_varDecls,
           i_preExp,
           i_context )
      local
        DAE.Exp i_exp;
        Tpl.Text i_expPart;
      equation
        (i_expPart, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, i_context, i_preExp, i_varDecls);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(1), make_index_array(1, "));
        txt = Tpl.writeText(txt, i_expPart);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("), \'S\'"));
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           DAE.WHOLEDIM(),
           i_varDecls,
           i_preExp,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(1), (0), \'W\'"));
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           DAE.SLICE(exp = i_exp),
           i_varDecls,
           i_preExp,
           i_context )
      local
        DAE.Exp i_exp;
        Tpl.Text i_tmp;
        Tpl.Text i_expPart;
      equation
        (i_expPart, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, i_context, i_preExp, i_varDecls);
        (i_tmp, i_varDecls) = tempDecl(emptyTxt, "modelica_integer", i_varDecls);
        i_preExp = Tpl.writeText(i_preExp, i_tmp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = size_of_dimension_integer_array("));
        i_preExp = Tpl.writeText(i_preExp, i_expPart);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", 1);"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_tmp);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", integer_array_make_index_array(&"));
        txt = Tpl.writeText(txt, i_expPart);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("), \'A\'"));
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _,
           i_varDecls,
           i_preExp,
           _ )
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end fun_247;

protected function lm_248
  input Tpl.Text in_txt;
  input list<DAE.Subscript> in_items;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_preExp, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDecls,
           i_preExp,
           _ )
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           i_sub :: rest,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<DAE.Subscript> rest;
        DAE.Subscript i_sub;
      equation
        (txt, i_varDecls, i_preExp) = fun_247(txt, i_sub, i_varDecls, i_preExp, i_context);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls, i_preExp) = lm_248(txt, rest, i_varDecls, i_preExp, i_context);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<DAE.Subscript> rest;
      equation
        (txt, i_varDecls, i_preExp) = lm_248(txt, rest, i_varDecls, i_preExp, i_context);
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end lm_248;

public function daeExpCrefRhsIndexSpec
  input Tpl.Text txt;
  input list<DAE.Subscript> i_subs;
  input SimCode.Context i_context;
  input Tpl.Text i_preExp;
  input Tpl.Text i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
protected
  Tpl.Text i_tmp;
  Tpl.Text i_idx__str;
  Integer ret_1;
  Tpl.Text i_nridx__str;
algorithm
  ret_1 := listLength(i_subs);
  i_nridx__str := Tpl.writeStr(emptyTxt, intString(ret_1));
  i_idx__str := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_idx__str, out_i_varDecls, out_i_preExp) := lm_248(i_idx__str, i_subs, i_varDecls, i_preExp, i_context);
  i_idx__str := Tpl.popIter(i_idx__str);
  (i_tmp, out_i_varDecls) := tempDecl(emptyTxt, "index_spec_t", out_i_varDecls);
  out_i_preExp := Tpl.writeTok(out_i_preExp, Tpl.ST_STRING("create_index_spec(&"));
  out_i_preExp := Tpl.writeText(out_i_preExp, i_tmp);
  out_i_preExp := Tpl.writeTok(out_i_preExp, Tpl.ST_STRING(", "));
  out_i_preExp := Tpl.writeText(out_i_preExp, i_nridx__str);
  out_i_preExp := Tpl.writeTok(out_i_preExp, Tpl.ST_STRING(", "));
  out_i_preExp := Tpl.writeText(out_i_preExp, i_idx__str);
  out_i_preExp := Tpl.writeTok(out_i_preExp, Tpl.ST_STRING(");"));
  out_i_preExp := Tpl.writeTok(out_i_preExp, Tpl.ST_NEW_LINE());
  out_txt := Tpl.writeText(txt, i_tmp);
end daeExpCrefRhsIndexSpec;

protected function lm_250
  input Tpl.Text in_txt;
  input list<Option<Integer>> in_items;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_items)
    local
      Tpl.Text txt;

    case ( txt,
           {} )
      then txt;

    case ( txt,
           (i_dim as SOME(i_i)) :: rest )
      local
        list<Option<Integer>> rest;
        Integer i_i;
        Option<Integer> i_dim;
      equation
        txt = Tpl.writeStr(txt, intString(i_i));
        txt = Tpl.nextIter(txt);
        txt = lm_250(txt, rest);
      then txt;

    case ( txt,
           _ :: rest )
      local
        list<Option<Integer>> rest;
      equation
        txt = lm_250(txt, rest);
      then txt;
  end matchcontinue;
end lm_250;

protected function fun_251
  input Tpl.Text in_txt;
  input SimCode.Context in_i_context;
  input DAE.ComponentRef in_i_cref_componentRef;
  input Tpl.Text in_i_preExp;
  input list<Option<Integer>> in_i_dims;
  input Tpl.Text in_i_varDecls;
  input DAE.ExpType in_i_aty;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_context, in_i_cref_componentRef, in_i_preExp, in_i_dims, in_i_varDecls, in_i_aty)
    local
      Tpl.Text txt;
      DAE.ComponentRef i_cref_componentRef;
      Tpl.Text i_preExp;
      list<Option<Integer>> i_dims;
      Tpl.Text i_varDecls;
      DAE.ExpType i_aty;

    case ( txt,
           SimCode.SIMULATION(genDiscrete = _),
           i_cref_componentRef,
           i_preExp,
           i_dims,
           i_varDecls,
           i_aty )
      local
        Tpl.Text i_dimsValuesStr;
        Integer ret_3;
        Tpl.Text i_dimsLenStr;
        Tpl.Text txt_1;
        Tpl.Text i_tmpArr;
      equation
        txt_1 = expTypeArray(emptyTxt, i_aty);
        (i_tmpArr, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(txt_1), i_varDecls);
        ret_3 = listLength(i_dims);
        i_dimsLenStr = Tpl.writeStr(emptyTxt, intString(ret_3));
        i_dimsValuesStr = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        i_dimsValuesStr = lm_250(i_dimsValuesStr, i_dims);
        i_dimsValuesStr = Tpl.popIter(i_dimsValuesStr);
        i_preExp = expTypeShort(i_preExp, i_aty);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("_array_create(&"));
        i_preExp = Tpl.writeText(i_preExp, i_tmpArr);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", &"));
        i_preExp = cref(i_preExp, i_cref_componentRef);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_dimsLenStr);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_dimsValuesStr);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_tmpArr);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           _,
           i_varDecls,
           _ )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end fun_251;

public function daeExpCrefRhsArrayBox
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           (i_cref as DAE.CREF(ty = DAE.ET_ARRAY(ty = i_aty, arrayDimensions = i_dims), componentRef = i_cref_componentRef)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.ComponentRef i_cref_componentRef;
        list<Option<Integer>> i_dims;
        DAE.ExpType i_aty;
        DAE.Exp i_cref;
      equation
        (txt, i_preExp, i_varDecls) = fun_251(txt, i_context, i_cref_componentRef, i_preExp, i_dims, i_varDecls, i_aty);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExpCrefRhsArrayBox;

protected function fun_253
  input Tpl.Text in_txt;
  input DAE.ExpType in_i_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_ty)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.ET_ARRAY(ty = DAE.ET_INT()) )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("integer_array"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("real_array"));
      then txt;
  end matchcontinue;
end fun_253;

protected function fun_254
  input Tpl.Text in_txt;
  input DAE.ExpType in_i_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_ty)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.ET_ARRAY(ty = DAE.ET_INT()) )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("integer_array"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("real_array"));
      then txt;
  end matchcontinue;
end fun_254;

protected function fun_255
  input Tpl.Text in_txt;
  input DAE.ExpType in_i_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_ty)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.ET_ARRAY(ty = DAE.ET_INT()) )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("integer_array"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("real_array"));
      then txt;
  end matchcontinue;
end fun_255;

protected function fun_256
  input Tpl.Text in_txt;
  input DAE.ExpType in_i_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_ty)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.ET_ARRAY(ty = DAE.ET_INT()) )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("integer_array"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("real_array"));
      then txt;
  end matchcontinue;
end fun_256;

protected function fun_257
  input Tpl.Text in_txt;
  input DAE.Operator in_i_operator;
  input Tpl.Text in_i_e2;
  input Tpl.Text in_i_e1;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_operator, in_i_e2, in_i_e1, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      Tpl.Text i_e2;
      Tpl.Text i_e1;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.ADD(ty = DAE.ET_STRING()),
           i_e2,
           i_e1,
           i_preExp,
           i_varDecls )
      local
        Tpl.Text i_tmpStr;
      equation
        (i_tmpStr, i_varDecls) = tempDecl(emptyTxt, "modelica_string", i_varDecls);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("cat_modelica_string(&"));
        i_preExp = Tpl.writeText(i_preExp, i_tmpStr);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(",&"));
        i_preExp = Tpl.writeText(i_preExp, i_e1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(",&"));
        i_preExp = Tpl.writeText(i_preExp, i_e2);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_tmpStr);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.ADD(ty = _),
           i_e2,
           i_e1,
           i_preExp,
           i_varDecls )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" + "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.SUB(ty = _),
           i_e2,
           i_e1,
           i_preExp,
           i_varDecls )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" - "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.MUL(ty = _),
           i_e2,
           i_e1,
           i_preExp,
           i_varDecls )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" * "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.DIV(ty = _),
           i_e2,
           i_e1,
           i_preExp,
           i_varDecls )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" / "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.POW(ty = _),
           i_e2,
           i_e1,
           i_preExp,
           i_varDecls )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("pow((modelica_real)"));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", (modelica_real)"));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.ADD_ARR(ty = i_ty),
           i_e2,
           i_e1,
           i_preExp,
           i_varDecls )
      local
        DAE.ExpType i_ty;
        Tpl.Text i_var;
        Tpl.Text i_type;
      equation
        i_type = fun_253(emptyTxt, i_ty);
        (i_var, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_type), i_varDecls);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("add_alloc_"));
        i_preExp = Tpl.writeText(i_preExp, i_type);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("(&"));
        i_preExp = Tpl.writeText(i_preExp, i_e1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", &"));
        i_preExp = Tpl.writeText(i_preExp, i_e2);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", &"));
        i_preExp = Tpl.writeText(i_preExp, i_var);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_var);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.SUB_ARR(ty = i_ty),
           i_e2,
           i_e1,
           i_preExp,
           i_varDecls )
      local
        DAE.ExpType i_ty;
        Tpl.Text i_var;
        Tpl.Text i_type;
      equation
        i_type = fun_254(emptyTxt, i_ty);
        (i_var, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_type), i_varDecls);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("sub_alloc_"));
        i_preExp = Tpl.writeText(i_preExp, i_type);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("(&"));
        i_preExp = Tpl.writeText(i_preExp, i_e1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", &"));
        i_preExp = Tpl.writeText(i_preExp, i_e2);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", &"));
        i_preExp = Tpl.writeText(i_preExp, i_var);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_var);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.MUL_ARRAY_SCALAR(ty = i_ty),
           i_e2,
           i_e1,
           i_preExp,
           i_varDecls )
      local
        DAE.ExpType i_ty;
        Tpl.Text i_var;
        Tpl.Text i_type;
      equation
        i_type = fun_255(emptyTxt, i_ty);
        (i_var, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_type), i_varDecls);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("mul_alloc_"));
        i_preExp = Tpl.writeText(i_preExp, i_type);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("_scalar(&"));
        i_preExp = Tpl.writeText(i_preExp, i_e1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_e2);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", &"));
        i_preExp = Tpl.writeText(i_preExp, i_var);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_var);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.DIV_ARRAY_SCALAR(ty = i_ty),
           i_e2,
           i_e1,
           i_preExp,
           i_varDecls )
      local
        DAE.ExpType i_ty;
        Tpl.Text i_var;
        Tpl.Text i_type;
      equation
        i_type = fun_256(emptyTxt, i_ty);
        (i_var, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_type), i_varDecls);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("div_alloc_"));
        i_preExp = Tpl.writeText(i_preExp, i_type);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("_scalar(&"));
        i_preExp = Tpl.writeText(i_preExp, i_e1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_e2);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", &"));
        i_preExp = Tpl.writeText(i_preExp, i_var);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_var);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           _,
           i_preExp,
           i_varDecls )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("daeExpBinary:ERR"));
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end fun_257;

public function daeExpBinary
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.BINARY(exp1 = i_exp1, exp2 = i_exp2, operator = i_operator),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Operator i_operator;
        DAE.Exp i_exp2;
        DAE.Exp i_exp1;
        Tpl.Text i_e2;
        Tpl.Text i_e1;
      equation
        (i_e1, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp1, i_context, i_preExp, i_varDecls);
        (i_e2, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp2, i_context, i_preExp, i_varDecls);
        (txt, i_preExp, i_varDecls) = fun_257(txt, i_operator, i_e2, i_e1, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExpBinary;

protected function fun_259
  input Tpl.Text in_txt;
  input DAE.Operator in_i_operator;
  input Tpl.Text in_i_e;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_operator, in_i_e)
    local
      Tpl.Text txt;
      Tpl.Text i_e;

    case ( txt,
           DAE.UMINUS(ty = _),
           i_e )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(-"));
        txt = Tpl.writeText(txt, i_e);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.UPLUS(ty = _),
           i_e )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.UMINUS_ARR(ty = _),
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("UMINUS_ARR_NOT_IMPLEMENTED"));
      then txt;

    case ( txt,
           DAE.UPLUS_ARR(ty = _),
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("UPLUS_ARR_NOT_IMPLEMENTED"));
      then txt;

    case ( txt,
           _,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("daeExpUnary:ERR"));
      then txt;
  end matchcontinue;
end fun_259;

public function daeExpUnary
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.UNARY(exp = i_exp, operator = i_operator),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Operator i_operator;
        DAE.Exp i_exp;
        Tpl.Text i_e;
      equation
        (i_e, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, i_context, i_preExp, i_varDecls);
        txt = fun_259(txt, i_operator, i_e);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExpUnary;

protected function fun_261
  input Tpl.Text in_txt;
  input DAE.Operator in_i_operator;
  input Tpl.Text in_i_e2;
  input Tpl.Text in_i_e1;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_operator, in_i_e2, in_i_e1)
    local
      Tpl.Text txt;
      Tpl.Text i_e2;
      Tpl.Text i_e1;

    case ( txt,
           DAE.AND(),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" && "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.OR(),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" || "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           _,
           _,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("daeExpLbinary:ERR"));
      then txt;
  end matchcontinue;
end fun_261;

public function daeExpLbinary
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.LBINARY(exp1 = i_exp1, exp2 = i_exp2, operator = i_operator),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Operator i_operator;
        DAE.Exp i_exp2;
        DAE.Exp i_exp1;
        Tpl.Text i_e2;
        Tpl.Text i_e1;
      equation
        (i_e1, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp1, i_context, i_preExp, i_varDecls);
        (i_e2, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp2, i_context, i_preExp, i_varDecls);
        txt = fun_261(txt, i_operator, i_e2, i_e1);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExpLbinary;

protected function fun_263
  input Tpl.Text in_txt;
  input DAE.Operator in_i_operator;
  input Tpl.Text in_i_e;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_operator, in_i_e)
    local
      Tpl.Text txt;
      Tpl.Text i_e;

    case ( txt,
           DAE.NOT(),
           i_e )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(!"));
        txt = Tpl.writeText(txt, i_e);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           _,
           _ )
      then txt;
  end matchcontinue;
end fun_263;

public function daeExpLunary
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.LUNARY(exp = i_exp, operator = i_operator),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Operator i_operator;
        DAE.Exp i_exp;
        Tpl.Text i_e;
      equation
        (i_e, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, i_context, i_preExp, i_varDecls);
        txt = fun_263(txt, i_operator, i_e);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExpLunary;

protected function fun_265
  input Tpl.Text in_txt;
  input DAE.Operator in_i_rel_operator;
  input Tpl.Text in_i_e2;
  input Tpl.Text in_i_e1;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_rel_operator, in_i_e2, in_i_e1)
    local
      Tpl.Text txt;
      Tpl.Text i_e2;
      Tpl.Text i_e1;

    case ( txt,
           DAE.LESS(ty = DAE.ET_BOOL()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(!"));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" && "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.LESS(ty = DAE.ET_STRING()),
           _,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("# string comparison not supported\n"));
      then txt;

    case ( txt,
           DAE.LESS(ty = DAE.ET_INT()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" < "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.LESS(ty = DAE.ET_REAL()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" < "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.GREATER(ty = DAE.ET_BOOL()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" && !"));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.GREATER(ty = DAE.ET_STRING()),
           _,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("# string comparison not supported\n"));
      then txt;

    case ( txt,
           DAE.GREATER(ty = DAE.ET_INT()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" > "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.GREATER(ty = DAE.ET_REAL()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" > "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.LESSEQ(ty = DAE.ET_BOOL()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(!"));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" || "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.LESSEQ(ty = DAE.ET_STRING()),
           _,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("# string comparison not supported\n"));
      then txt;

    case ( txt,
           DAE.LESSEQ(ty = DAE.ET_INT()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" <= "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.LESSEQ(ty = DAE.ET_REAL()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" <= "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.GREATEREQ(ty = DAE.ET_BOOL()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" || !"));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.GREATEREQ(ty = DAE.ET_STRING()),
           _,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_LINE("# string comparison not supported\n"));
      then txt;

    case ( txt,
           DAE.GREATEREQ(ty = DAE.ET_INT()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" >= "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.GREATEREQ(ty = DAE.ET_REAL()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" >= "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.EQUAL(ty = DAE.ET_BOOL()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("((!"));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" && !"));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(") || ("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" && "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("))"));
      then txt;

    case ( txt,
           DAE.EQUAL(ty = DAE.ET_STRING()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(!strcmp("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("))"));
      then txt;

    case ( txt,
           DAE.EQUAL(ty = DAE.ET_INT()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" == "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.EQUAL(ty = DAE.ET_REAL()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" == "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.NEQUAL(ty = DAE.ET_BOOL()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("((!"));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" && "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(") || ("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" && !"));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("))"));
      then txt;

    case ( txt,
           DAE.NEQUAL(ty = DAE.ET_STRING()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(strcmp("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("))"));
      then txt;

    case ( txt,
           DAE.NEQUAL(ty = DAE.ET_INT()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" != "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           DAE.NEQUAL(ty = DAE.ET_REAL()),
           i_e2,
           i_e1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_e1);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(" != "));
        txt = Tpl.writeText(txt, i_e2);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then txt;

    case ( txt,
           _,
           _,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("daeExpRelation:ERR"));
      then txt;
  end matchcontinue;
end fun_265;

protected function fun_266
  input Tpl.Text in_txt;
  input String in_it;
  input DAE.Operator in_i_rel_operator;
  input DAE.Exp in_i_rel_exp2;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;
  input DAE.Exp in_i_rel_exp1;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_it, in_i_rel_operator, in_i_rel_exp2, in_i_varDecls, in_i_preExp, in_i_context, in_i_rel_exp1)
    local
      Tpl.Text txt;
      DAE.Operator i_rel_operator;
      DAE.Exp i_rel_exp2;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      SimCode.Context i_context;
      DAE.Exp i_rel_exp1;

    case ( txt,
           "",
           i_rel_operator,
           i_rel_exp2,
           i_varDecls,
           i_preExp,
           i_context,
           i_rel_exp1 )
      local
        Tpl.Text i_e2;
        Tpl.Text i_e1;
      equation
        (i_e1, i_preExp, i_varDecls) = daeExp(emptyTxt, i_rel_exp1, i_context, i_preExp, i_varDecls);
        (i_e2, i_preExp, i_varDecls) = daeExp(emptyTxt, i_rel_exp2, i_context, i_preExp, i_varDecls);
        txt = fun_265(txt, i_rel_operator, i_e2, i_e1);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           str_1,
           _,
           _,
           i_varDecls,
           i_preExp,
           _,
           _ )
      local
        String str_1;
      equation
        txt = Tpl.writeStr(txt, str_1);
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end fun_266;

public function daeExpRelation
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           (i_rel as DAE.RELATION(exp1 = i_rel_exp1, exp2 = i_rel_exp2, operator = i_rel_operator)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Operator i_rel_operator;
        DAE.Exp i_rel_exp2;
        DAE.Exp i_rel_exp1;
        DAE.Exp i_rel;
        String str_1;
        Tpl.Text txt_0;
      equation
        (txt_0, i_preExp, i_varDecls) = daeExpRelationSim(emptyTxt, i_rel, i_context, i_preExp, i_varDecls);
        str_1 = Tpl.textString(txt_0);
        (txt, i_varDecls, i_preExp) = fun_266(txt, str_1, i_rel_operator, i_rel_exp2, i_varDecls, i_preExp, i_context, i_rel_exp1);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExpRelation;

protected function fun_268
  input Tpl.Text in_txt;
  input DAE.Operator in_i_rel_operator;
  input Tpl.Text in_i_e2;
  input Tpl.Text in_i_e1;
  input Tpl.Text in_i_res;
  input Tpl.Text in_i_preExp;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_preExp) :=
  matchcontinue(in_txt, in_i_rel_operator, in_i_e2, in_i_e1, in_i_res, in_i_preExp)
    local
      Tpl.Text txt;
      Tpl.Text i_e2;
      Tpl.Text i_e1;
      Tpl.Text i_res;
      Tpl.Text i_preExp;

    case ( txt,
           DAE.LESS(ty = _),
           i_e2,
           i_e1,
           i_res,
           i_preExp )
      equation
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("RELATIONLESS("));
        i_preExp = Tpl.writeText(i_preExp, i_res);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_e1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_e2);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_res);
      then (txt, i_preExp);

    case ( txt,
           DAE.LESSEQ(ty = _),
           i_e2,
           i_e1,
           i_res,
           i_preExp )
      equation
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("RELATIONLESSEQ("));
        i_preExp = Tpl.writeText(i_preExp, i_res);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_e1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_e2);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_res);
      then (txt, i_preExp);

    case ( txt,
           DAE.GREATER(ty = _),
           i_e2,
           i_e1,
           i_res,
           i_preExp )
      equation
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("RELATIONGREATER("));
        i_preExp = Tpl.writeText(i_preExp, i_res);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_e1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_e2);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_res);
      then (txt, i_preExp);

    case ( txt,
           DAE.GREATEREQ(ty = _),
           i_e2,
           i_e1,
           i_res,
           i_preExp )
      equation
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("RELATIONGREATEREQ("));
        i_preExp = Tpl.writeText(i_preExp, i_res);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_e1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_e2);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_res);
      then (txt, i_preExp);

    case ( txt,
           _,
           _,
           _,
           _,
           i_preExp )
      then (txt, i_preExp);
  end matchcontinue;
end fun_268;

protected function fun_269
  input Tpl.Text in_txt;
  input SimCode.Context in_i_context;
  input DAE.Operator in_i_rel_operator;
  input DAE.Exp in_i_rel_exp2;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input DAE.Exp in_i_rel_exp1;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_i_context, in_i_rel_operator, in_i_rel_exp2, in_i_varDecls, in_i_preExp, in_i_rel_exp1)
    local
      Tpl.Text txt;
      DAE.Operator i_rel_operator;
      DAE.Exp i_rel_exp2;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      DAE.Exp i_rel_exp1;

    case ( txt,
           (i_context as SimCode.SIMULATION(genDiscrete = _)),
           i_rel_operator,
           i_rel_exp2,
           i_varDecls,
           i_preExp,
           i_rel_exp1 )
      local
        SimCode.Context i_context;
        Tpl.Text i_res;
        Tpl.Text i_e2;
        Tpl.Text i_e1;
      equation
        (i_e1, i_preExp, i_varDecls) = daeExp(emptyTxt, i_rel_exp1, i_context, i_preExp, i_varDecls);
        (i_e2, i_preExp, i_varDecls) = daeExp(emptyTxt, i_rel_exp2, i_context, i_preExp, i_varDecls);
        (i_res, i_varDecls) = tempDecl(emptyTxt, "modelica_boolean", i_varDecls);
        (txt, i_preExp) = fun_268(txt, i_rel_operator, i_e2, i_e1, i_res, i_preExp);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _,
           _,
           _,
           i_varDecls,
           i_preExp,
           _ )
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end fun_269;

public function daeExpRelationSim
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           (i_rel as DAE.RELATION(exp1 = i_rel_exp1, exp2 = i_rel_exp2, operator = i_rel_operator)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Operator i_rel_operator;
        DAE.Exp i_rel_exp2;
        DAE.Exp i_rel_exp1;
        DAE.Exp i_rel;
      equation
        (txt, i_varDecls, i_preExp) = fun_269(txt, i_context, i_rel_operator, i_rel_exp2, i_varDecls, i_preExp, i_rel_exp1);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExpRelationSim;

public function daeExpIf
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.IFEXP(expCond = i_expCond, expThen = i_expThen, expElse = i_expElse),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_expElse;
        DAE.Exp i_expThen;
        DAE.Exp i_expCond;
        Tpl.Text i_eElse;
        Tpl.Text i_preExpElse;
        Tpl.Text i_eThen;
        Tpl.Text i_preExpThen;
        Tpl.Text i_resVar;
        Tpl.Text i_resVarType;
        Tpl.Text i_condVar;
        Tpl.Text i_condExp;
      equation
        (i_condExp, i_preExp, i_varDecls) = daeExp(emptyTxt, i_expCond, i_context, i_preExp, i_varDecls);
        (i_condVar, i_varDecls) = tempDecl(emptyTxt, "modelica_boolean", i_varDecls);
        i_resVarType = expTypeFromExpArrayIf(emptyTxt, i_expThen);
        (i_resVar, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_resVarType), i_varDecls);
        i_preExpThen = emptyTxt;
        (i_eThen, i_preExpThen, i_varDecls) = daeExp(emptyTxt, i_expThen, i_context, i_preExpThen, i_varDecls);
        i_preExpElse = emptyTxt;
        (i_eElse, i_preExpElse, i_varDecls) = daeExp(emptyTxt, i_expElse, i_context, i_preExpElse, i_varDecls);
        i_preExp = Tpl.writeText(i_preExp, i_condVar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = "));
        i_preExp = Tpl.writeText(i_preExp, i_condExp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING_LIST({
                                              ";\n",
                                              "if ("
                                          }, false));
        i_preExp = Tpl.writeText(i_preExp, i_condVar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_LINE(") {\n"));
        i_preExp = Tpl.pushBlock(i_preExp, Tpl.BT_INDENT(2));
        i_preExp = Tpl.writeText(i_preExp, i_preExpThen);
        i_preExp = Tpl.softNewLine(i_preExp);
        i_preExp = Tpl.writeText(i_preExp, i_resVar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = "));
        i_preExp = Tpl.writeText(i_preExp, i_eThen);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_LINE(";\n"));
        i_preExp = Tpl.popBlock(i_preExp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_LINE("} else {\n"));
        i_preExp = Tpl.pushBlock(i_preExp, Tpl.BT_INDENT(2));
        i_preExp = Tpl.writeText(i_preExp, i_preExpElse);
        i_preExp = Tpl.softNewLine(i_preExp);
        i_preExp = Tpl.writeText(i_preExp, i_resVar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = "));
        i_preExp = Tpl.writeText(i_preExp, i_eElse);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_LINE(";\n"));
        i_preExp = Tpl.popBlock(i_preExp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("}"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_resVar);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExpIf;

protected function fun_272
  input Tpl.Text in_txt;
  input DAE.ExpType in_i_arg_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_arg_ty)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.ET_INT() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(modelica_integer)"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end fun_272;

protected function lm_273
  input Tpl.Text in_txt;
  input list<DAE.Exp> in_items;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_preExp, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDecls,
           i_preExp,
           _ )
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           i_exp :: rest,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<DAE.Exp> rest;
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExp(txt, i_exp, i_context, i_preExp, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls, i_preExp) = lm_273(txt, rest, i_varDecls, i_preExp, i_context);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<DAE.Exp> rest;
      equation
        (txt, i_varDecls, i_preExp) = lm_273(txt, rest, i_varDecls, i_preExp, i_context);
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end lm_273;

protected function lm_274
  input Tpl.Text in_txt;
  input list<DAE.Exp> in_items;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_preExp, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDecls,
           i_preExp,
           _ )
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           i_exp :: rest,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<DAE.Exp> rest;
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExp(txt, i_exp, i_context, i_preExp, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls, i_preExp) = lm_274(txt, rest, i_varDecls, i_preExp, i_context);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<DAE.Exp> rest;
      equation
        (txt, i_varDecls, i_preExp) = lm_274(txt, rest, i_varDecls, i_preExp, i_context);
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end lm_274;

protected function fun_275
  input Tpl.Text in_txt;
  input Boolean in_i_builtin;
  input Tpl.Text in_i_retType;
  input Tpl.Text in_i_retVar;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_builtin, in_i_retType, in_i_retVar)
    local
      Tpl.Text txt;
      Tpl.Text i_retType;
      Tpl.Text i_retVar;

    case ( txt,
           false,
           i_retType,
           i_retVar )
      equation
        txt = Tpl.writeText(txt, i_retVar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("."));
        txt = Tpl.writeText(txt, i_retType);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_1"));
      then txt;

    case ( txt,
           _,
           _,
           i_retVar )
      equation
        txt = Tpl.writeText(txt, i_retVar);
      then txt;
  end matchcontinue;
end fun_275;

protected function lm_276
  input Tpl.Text in_txt;
  input list<DAE.Exp> in_items;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_preExp, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDecls,
           i_preExp,
           _ )
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           i_exp :: rest,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<DAE.Exp> rest;
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExp(txt, i_exp, i_context, i_preExp, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls, i_preExp) = lm_276(txt, rest, i_varDecls, i_preExp, i_context);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<DAE.Exp> rest;
      equation
        (txt, i_varDecls, i_preExp) = lm_276(txt, rest, i_varDecls, i_preExp, i_context);
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end lm_276;

public function daeExpCall
  input Tpl.Text in_txt;
  input DAE.Exp in_i_call;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_call, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.CALL(tuple_ = false, builtin = true, path = Absyn.IDENT(name = "pre"), expLst = {(i_arg as DAE.CREF(ty = i_arg_ty, componentRef = i_arg_componentRef))}),
           _,
           i_preExp,
           i_varDecls )
      local
        DAE.ComponentRef i_arg_componentRef;
        DAE.ExpType i_arg_ty;
        DAE.Exp i_arg;
        Tpl.Text i_cast;
        Tpl.Text i_retVar;
        Tpl.Text i_retType;
      equation
        i_retType = expTypeArrayIf(emptyTxt, i_arg_ty);
        (i_retVar, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_retType), i_varDecls);
        i_cast = fun_272(emptyTxt, i_arg_ty);
        i_preExp = Tpl.writeText(i_preExp, i_retVar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = "));
        i_preExp = Tpl.writeText(i_preExp, i_cast);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("pre("));
        i_preExp = cref(i_preExp, i_arg_componentRef);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_retVar);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.CALL(tuple_ = false, builtin = true, path = Absyn.IDENT(name = "max"), expLst = {i_array}),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_array;
        Tpl.Text txt_3;
        Tpl.Text i_tvar;
        Tpl.Text i_arr__tp__str;
        Tpl.Text i_expVar;
      equation
        (i_expVar, i_preExp, i_varDecls) = daeExp(emptyTxt, i_array, i_context, i_preExp, i_varDecls);
        i_arr__tp__str = expTypeFromExpArray(emptyTxt, i_array);
        txt_3 = expTypeFromExpModelica(emptyTxt, i_array);
        (i_tvar, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(txt_3), i_varDecls);
        i_preExp = Tpl.writeText(i_preExp, i_tvar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = max_"));
        i_preExp = Tpl.writeText(i_preExp, i_arr__tp__str);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("(&"));
        i_preExp = Tpl.writeText(i_preExp, i_expVar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_tvar);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.CALL(tuple_ = false, builtin = true, path = Absyn.IDENT(name = "promote"), expLst = {i_A, i_n}),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_n;
        DAE.Exp i_A;
        Tpl.Text i_tvar;
        Tpl.Text i_arr__tp__str;
        Tpl.Text i_var2;
        Tpl.Text i_var1;
      equation
        (i_var1, i_preExp, i_varDecls) = daeExp(emptyTxt, i_A, i_context, i_preExp, i_varDecls);
        (i_var2, i_preExp, i_varDecls) = daeExp(emptyTxt, i_n, i_context, i_preExp, i_varDecls);
        i_arr__tp__str = expTypeFromExpArray(emptyTxt, i_A);
        (i_tvar, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_arr__tp__str), i_varDecls);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("promote_alloc_"));
        i_preExp = Tpl.writeText(i_preExp, i_arr__tp__str);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("(&"));
        i_preExp = Tpl.writeText(i_preExp, i_var1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_var2);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", &"));
        i_preExp = Tpl.writeText(i_preExp, i_tvar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_tvar);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.CALL(tuple_ = false, builtin = true, path = Absyn.IDENT(name = "transpose"), expLst = {i_A}),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_A;
        Tpl.Text i_tvar;
        Tpl.Text i_arr__tp__str;
        Tpl.Text i_var1;
      equation
        (i_var1, i_preExp, i_varDecls) = daeExp(emptyTxt, i_A, i_context, i_preExp, i_varDecls);
        i_arr__tp__str = expTypeFromExpArray(emptyTxt, i_A);
        (i_tvar, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_arr__tp__str), i_varDecls);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("transpose_alloc_"));
        i_preExp = Tpl.writeText(i_preExp, i_arr__tp__str);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("(&"));
        i_preExp = Tpl.writeText(i_preExp, i_var1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", &"));
        i_preExp = Tpl.writeText(i_preExp, i_tvar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_tvar);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.CALL(tuple_ = false, builtin = true, path = Absyn.IDENT(name = "identity"), expLst = {i_A}),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_A;
        Tpl.Text i_tvar;
        Tpl.Text i_arr__tp__str;
        Tpl.Text i_var1;
      equation
        (i_var1, i_preExp, i_varDecls) = daeExp(emptyTxt, i_A, i_context, i_preExp, i_varDecls);
        i_arr__tp__str = expTypeFromExpArray(emptyTxt, i_A);
        (i_tvar, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_arr__tp__str), i_varDecls);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("identity_alloc_"));
        i_preExp = Tpl.writeText(i_preExp, i_arr__tp__str);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("("));
        i_preExp = Tpl.writeText(i_preExp, i_var1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", &"));
        i_preExp = Tpl.writeText(i_preExp, i_tvar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_tvar);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.CALL(tuple_ = false, builtin = true, path = Absyn.IDENT(name = "abs"), expLst = {i_s1}),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_s1;
        Tpl.Text i_s1Exp;
        Tpl.Text txt_1;
        Tpl.Text i_tvar;
      equation
        txt_1 = expTypeFromExpModelica(emptyTxt, i_s1);
        (i_tvar, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(txt_1), i_varDecls);
        (i_s1Exp, i_preExp, i_varDecls) = daeExp(emptyTxt, i_s1, i_context, i_preExp, i_varDecls);
        i_preExp = Tpl.writeText(i_preExp, i_tvar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = fabs("));
        i_preExp = Tpl.writeText(i_preExp, i_s1Exp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_tvar);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.CALL(tuple_ = false, builtin = true, path = Absyn.IDENT(name = "String"), expLst = {i_s, i_minlen, i_leftjust, i_signdig}),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_signdig;
        DAE.Exp i_leftjust;
        DAE.Exp i_minlen;
        DAE.Exp i_s;
        Tpl.Text i_typeStr;
        Tpl.Text i_signdigExp;
        Tpl.Text i_leftjustExp;
        Tpl.Text i_minlenExp;
        Tpl.Text i_sExp;
        Tpl.Text i_tvar;
      equation
        (i_tvar, i_varDecls) = tempDecl(emptyTxt, "modelica_string", i_varDecls);
        (i_sExp, i_preExp, i_varDecls) = daeExp(emptyTxt, i_s, i_context, i_preExp, i_varDecls);
        (i_minlenExp, i_preExp, i_varDecls) = daeExp(emptyTxt, i_minlen, i_context, i_preExp, i_varDecls);
        (i_leftjustExp, i_preExp, i_varDecls) = daeExp(emptyTxt, i_leftjust, i_context, i_preExp, i_varDecls);
        (i_signdigExp, i_preExp, i_varDecls) = daeExp(emptyTxt, i_signdig, i_context, i_preExp, i_varDecls);
        i_typeStr = expTypeFromExpModelica(emptyTxt, i_s);
        i_preExp = Tpl.writeText(i_preExp, i_typeStr);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("_to_modelica_string(&"));
        i_preExp = Tpl.writeText(i_preExp, i_tvar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_sExp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_minlenExp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_leftjustExp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_signdigExp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_tvar);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.CALL(tuple_ = false, builtin = true, path = Absyn.IDENT(name = "delay"), expLst = {DAE.ICONST(integer = i_index), i_e, i_d, i_delayMax}),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_delayMax;
        DAE.Exp i_d;
        DAE.Exp i_e;
        Integer i_index;
        Tpl.Text i_var2;
        Tpl.Text i_var1;
        Tpl.Text i_tvar;
      equation
        (i_tvar, i_varDecls) = tempDecl(emptyTxt, "modelica_real", i_varDecls);
        (i_var1, i_preExp, i_varDecls) = daeExp(emptyTxt, i_e, i_context, i_preExp, i_varDecls);
        (i_var2, i_preExp, i_varDecls) = daeExp(emptyTxt, i_d, i_context, i_preExp, i_varDecls);
        i_preExp = Tpl.writeText(i_preExp, i_tvar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = delayImpl("));
        i_preExp = Tpl.writeStr(i_preExp, intString(i_index));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_var1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", time, "));
        i_preExp = Tpl.writeText(i_preExp, i_var2);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_tvar);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.CALL(tuple_ = false, ty = DAE.ET_NORETCALL(), expLst = i_expLst, path = i_path, builtin = i_builtin),
           i_context,
           i_preExp,
           i_varDecls )
      local
        Boolean i_builtin;
        Absyn.Path i_path;
        list<DAE.Exp> i_expLst;
        Tpl.Text i_funName;
        Tpl.Text i_argStr;
      equation
        i_argStr = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_argStr, i_varDecls, i_preExp) = lm_273(i_argStr, i_expLst, i_varDecls, i_preExp, i_context);
        i_argStr = Tpl.popIter(i_argStr);
        i_funName = underscorePath(emptyTxt, i_path);
        i_preExp = daeExpCallBuiltinPrefix(i_preExp, i_builtin);
        i_preExp = Tpl.writeText(i_preExp, i_funName);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("("));
        i_preExp = Tpl.writeText(i_preExp, i_argStr);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("/* NORETCALL */"));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.CALL(tuple_ = false, expLst = i_expLst, path = i_path, builtin = i_builtin),
           i_context,
           i_preExp,
           i_varDecls )
      local
        Boolean i_builtin;
        Absyn.Path i_path;
        list<DAE.Exp> i_expLst;
        Tpl.Text i_retVar;
        Tpl.Text i_retType;
        Tpl.Text i_funName;
        Tpl.Text i_argStr;
      equation
        i_argStr = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_argStr, i_varDecls, i_preExp) = lm_274(i_argStr, i_expLst, i_varDecls, i_preExp, i_context);
        i_argStr = Tpl.popIter(i_argStr);
        i_funName = underscorePath(emptyTxt, i_path);
        i_retType = Tpl.writeText(emptyTxt, i_funName);
        i_retType = Tpl.writeTok(i_retType, Tpl.ST_STRING("_rettype"));
        (i_retVar, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_retType), i_varDecls);
        i_preExp = Tpl.writeText(i_preExp, i_retVar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = "));
        i_preExp = daeExpCallBuiltinPrefix(i_preExp, i_builtin);
        i_preExp = Tpl.writeText(i_preExp, i_funName);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("("));
        i_preExp = Tpl.writeText(i_preExp, i_argStr);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = fun_275(txt, i_builtin, i_retType, i_retVar);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.CALL(tuple_ = true, expLst = i_expLst, path = i_path, builtin = i_builtin),
           i_context,
           i_preExp,
           i_varDecls )
      local
        Boolean i_builtin;
        Absyn.Path i_path;
        list<DAE.Exp> i_expLst;
        Tpl.Text i_retVar;
        Tpl.Text i_retType;
        Tpl.Text i_funName;
        Tpl.Text i_argStr;
      equation
        i_argStr = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_argStr, i_varDecls, i_preExp) = lm_276(i_argStr, i_expLst, i_varDecls, i_preExp, i_context);
        i_argStr = Tpl.popIter(i_argStr);
        i_funName = underscorePath(emptyTxt, i_path);
        i_retType = Tpl.writeText(emptyTxt, i_funName);
        i_retType = Tpl.writeTok(i_retType, Tpl.ST_STRING("_rettype"));
        (i_retVar, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_retType), i_varDecls);
        i_preExp = Tpl.writeText(i_preExp, i_retVar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = "));
        i_preExp = daeExpCallBuiltinPrefix(i_preExp, i_builtin);
        i_preExp = Tpl.writeText(i_preExp, i_funName);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("("));
        i_preExp = Tpl.writeText(i_preExp, i_argStr);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_retVar);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExpCall;

public function daeExpCallBuiltinPrefix
  input Tpl.Text in_txt;
  input Boolean in_i_builtin;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_builtin)
    local
      Tpl.Text txt;

    case ( txt,
           true )
      then txt;

    case ( txt,
           false )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end daeExpCallBuiltinPrefix;

protected function fun_279
  input Tpl.Text in_txt;
  input Boolean in_i_scalar;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_scalar)
    local
      Tpl.Text txt;

    case ( txt,
           false )
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("scalar_"));
      then txt;
  end matchcontinue;
end fun_279;

protected function fun_280
  input Tpl.Text in_txt;
  input Boolean in_i_scalar;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_scalar)
    local
      Tpl.Text txt;

    case ( txt,
           false )
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("&"));
      then txt;
  end matchcontinue;
end fun_280;

protected function lm_281
  input Tpl.Text in_txt;
  input list<DAE.Exp> in_items;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_preExp, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDecls,
           i_preExp,
           _ )
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           i_e :: rest,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<DAE.Exp> rest;
        DAE.Exp i_e;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = expTypeFromExpModelica(txt, i_e);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
        (txt, i_preExp, i_varDecls) = daeExp(txt, i_e, i_context, i_preExp, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls, i_preExp) = lm_281(txt, rest, i_varDecls, i_preExp, i_context);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<DAE.Exp> rest;
      equation
        (txt, i_varDecls, i_preExp) = lm_281(txt, rest, i_varDecls, i_preExp, i_context);
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end lm_281;

public function daeExpArray
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.ARRAY(ty = i_ty, scalar = i_scalar, array = i_array),
           i_context,
           i_preExp,
           i_varDecls )
      local
        list<DAE.Exp> i_array;
        Boolean i_scalar;
        DAE.ExpType i_ty;
        Integer ret_5;
        Tpl.Text i_params;
        Tpl.Text i_scalarRef;
        Tpl.Text i_scalarPrefix;
        Tpl.Text i_arrayVar;
        Tpl.Text i_arrayTypeStr;
      equation
        i_arrayTypeStr = expTypeArray(emptyTxt, i_ty);
        (i_arrayVar, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_arrayTypeStr), i_varDecls);
        i_scalarPrefix = fun_279(emptyTxt, i_scalar);
        i_scalarRef = fun_280(emptyTxt, i_scalar);
        i_params = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_params, i_varDecls, i_preExp) = lm_281(i_params, i_array, i_varDecls, i_preExp, i_context);
        i_params = Tpl.popIter(i_params);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("array_alloc_"));
        i_preExp = Tpl.writeText(i_preExp, i_scalarPrefix);
        i_preExp = Tpl.writeText(i_preExp, i_arrayTypeStr);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("(&"));
        i_preExp = Tpl.writeText(i_preExp, i_arrayVar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        ret_5 = listLength(i_array);
        i_preExp = Tpl.writeStr(i_preExp, intString(ret_5));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_params);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_arrayVar);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExpArray;

protected function lm_283
  input Tpl.Text in_txt;
  input list<list<tuple<DAE.Exp, Boolean>>> in_items;
  input Tpl.Text in_i_vars2;
  input Tpl.Text in_i_promote;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_arrayTypeStr;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_vars2;
  output Tpl.Text out_i_promote;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_vars2, out_i_promote, out_i_varDecls) :=
  matchcontinue(in_txt, in_items, in_i_vars2, in_i_promote, in_i_context, in_i_varDecls, in_i_arrayTypeStr)
    local
      Tpl.Text txt;
      Tpl.Text i_vars2;
      Tpl.Text i_promote;
      SimCode.Context i_context;
      Tpl.Text i_varDecls;
      Tpl.Text i_arrayTypeStr;

    case ( txt,
           {},
           i_vars2,
           i_promote,
           _,
           i_varDecls,
           _ )
      then (txt, i_vars2, i_promote, i_varDecls);

    case ( txt,
           i_row :: rest,
           i_vars2,
           i_promote,
           i_context,
           i_varDecls,
           i_arrayTypeStr )
      local
        list<list<tuple<DAE.Exp, Boolean>>> rest;
        list<tuple<DAE.Exp, Boolean>> i_row;
        Integer ret_2;
        Tpl.Text i_vars;
        Tpl.Text i_tmp;
      equation
        (i_tmp, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_arrayTypeStr), i_varDecls);
        (i_vars, i_promote, i_varDecls) = daeExpMatrixRow(emptyTxt, i_row, Tpl.textString(i_arrayTypeStr), i_context, i_promote, i_varDecls);
        i_vars2 = Tpl.writeTok(i_vars2, Tpl.ST_STRING(", &"));
        i_vars2 = Tpl.writeText(i_vars2, i_tmp);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("cat_alloc_"));
        txt = Tpl.writeText(txt, i_arrayTypeStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(2, &"));
        txt = Tpl.writeText(txt, i_tmp);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", "));
        ret_2 = listLength(i_row);
        txt = Tpl.writeStr(txt, intString(ret_2));
        txt = Tpl.writeText(txt, i_vars);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
        txt = Tpl.nextIter(txt);
        (txt, i_vars2, i_promote, i_varDecls) = lm_283(txt, rest, i_vars2, i_promote, i_context, i_varDecls, i_arrayTypeStr);
      then (txt, i_vars2, i_promote, i_varDecls);

    case ( txt,
           _ :: rest,
           i_vars2,
           i_promote,
           i_context,
           i_varDecls,
           i_arrayTypeStr )
      local
        list<list<tuple<DAE.Exp, Boolean>>> rest;
      equation
        (txt, i_vars2, i_promote, i_varDecls) = lm_283(txt, rest, i_vars2, i_promote, i_context, i_varDecls, i_arrayTypeStr);
      then (txt, i_vars2, i_promote, i_varDecls);
  end matchcontinue;
end lm_283;

public function daeExpMatrix
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.MATRIX(scalar = {{}}, ty = i_ty),
           _,
           i_preExp,
           i_varDecls )
      local
        DAE.ExpType i_ty;
        Tpl.Text i_tmp;
        Tpl.Text i_arrayTypeStr;
      equation
        i_arrayTypeStr = expTypeArray(emptyTxt, i_ty);
        (i_tmp, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_arrayTypeStr), i_varDecls);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("alloc_"));
        i_preExp = Tpl.writeText(i_preExp, i_arrayTypeStr);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("(&"));
        i_preExp = Tpl.writeText(i_preExp, i_tmp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", 2, 0, 1);"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_tmp);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.MATRIX(scalar = {}, ty = i_ty),
           _,
           i_preExp,
           i_varDecls )
      local
        DAE.ExpType i_ty;
        Tpl.Text i_tmp;
        Tpl.Text i_arrayTypeStr;
      equation
        i_arrayTypeStr = expTypeArray(emptyTxt, i_ty);
        (i_tmp, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_arrayTypeStr), i_varDecls);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("alloc_"));
        i_preExp = Tpl.writeText(i_preExp, i_arrayTypeStr);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("(&"));
        i_preExp = Tpl.writeText(i_preExp, i_tmp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", 2, 0, 1);"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_tmp);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           (i_m as DAE.MATRIX(ty = i_m_ty, scalar = i_m_scalar)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        list<list<tuple<DAE.Exp, Boolean>>> i_m_scalar;
        DAE.ExpType i_m_ty;
        DAE.Exp i_m;
        Integer ret_5;
        Tpl.Text i_tmp;
        Tpl.Text i_catAlloc;
        Tpl.Text i_promote;
        Tpl.Text i_vars2;
        Tpl.Text i_arrayTypeStr;
      equation
        i_arrayTypeStr = expTypeArray(emptyTxt, i_m_ty);
        i_vars2 = emptyTxt;
        i_promote = emptyTxt;
        i_catAlloc = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_catAlloc, i_vars2, i_promote, i_varDecls) = lm_283(i_catAlloc, i_m_scalar, i_vars2, i_promote, i_context, i_varDecls, i_arrayTypeStr);
        i_catAlloc = Tpl.popIter(i_catAlloc);
        i_preExp = Tpl.writeText(i_preExp, i_promote);
        i_preExp = Tpl.writeText(i_preExp, i_catAlloc);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        (i_tmp, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_arrayTypeStr), i_varDecls);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("cat_alloc_"));
        i_preExp = Tpl.writeText(i_preExp, i_arrayTypeStr);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("(1, &"));
        i_preExp = Tpl.writeText(i_preExp, i_tmp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        ret_5 = listLength(i_m_scalar);
        i_preExp = Tpl.writeStr(i_preExp, intString(ret_5));
        i_preExp = Tpl.writeText(i_preExp, i_vars2);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_tmp);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExpMatrix;

protected function fun_285
  input Tpl.Text in_txt;
  input Boolean in_i_b;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_b)
    local
      Tpl.Text txt;

    case ( txt,
           false )
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("scalar_"));
      then txt;
  end matchcontinue;
end fun_285;

protected function fun_286
  input Tpl.Text in_txt;
  input Boolean in_i_b;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_b)
    local
      Tpl.Text txt;

    case ( txt,
           false )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("&"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end fun_286;

protected function lm_287
  input Tpl.Text in_txt;
  input list<tuple<DAE.Exp, Boolean>> in_items;
  input Tpl.Text in_i_varLstStr;
  input String in_i_arrayTypeStr;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varLstStr;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varLstStr, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_items, in_i_varLstStr, in_i_arrayTypeStr, in_i_varDecls, in_i_preExp, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varLstStr;
      String i_arrayTypeStr;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varLstStr,
           _,
           i_varDecls,
           i_preExp,
           _ )
      then (txt, i_varLstStr, i_varDecls, i_preExp);

    case ( txt,
           (i_col as (i_e, i_b)) :: rest,
           i_varLstStr,
           i_arrayTypeStr,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<tuple<DAE.Exp, Boolean>> rest;
        Boolean i_b;
        DAE.Exp i_e;
        tuple<DAE.Exp, Boolean> i_col;
        Tpl.Text i_tmp;
        Tpl.Text i_expVar;
        Tpl.Text i_scalarRefStr;
        Tpl.Text i_scalarStr;
      equation
        i_scalarStr = fun_285(emptyTxt, i_b);
        i_scalarRefStr = fun_286(emptyTxt, i_b);
        (i_expVar, i_preExp, i_varDecls) = daeExp(emptyTxt, i_e, i_context, i_preExp, i_varDecls);
        (i_tmp, i_varDecls) = tempDecl(emptyTxt, i_arrayTypeStr, i_varDecls);
        i_varLstStr = Tpl.writeTok(i_varLstStr, Tpl.ST_STRING(", &"));
        i_varLstStr = Tpl.writeText(i_varLstStr, i_tmp);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("promote_"));
        txt = Tpl.writeText(txt, i_scalarStr);
        txt = Tpl.writeStr(txt, i_arrayTypeStr);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("("));
        txt = Tpl.writeText(txt, i_scalarRefStr);
        txt = Tpl.writeText(txt, i_expVar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(", 2, &"));
        txt = Tpl.writeText(txt, i_tmp);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(");"));
        txt = Tpl.nextIter(txt);
        (txt, i_varLstStr, i_varDecls, i_preExp) = lm_287(txt, rest, i_varLstStr, i_arrayTypeStr, i_varDecls, i_preExp, i_context);
      then (txt, i_varLstStr, i_varDecls, i_preExp);

    case ( txt,
           _ :: rest,
           i_varLstStr,
           i_arrayTypeStr,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<tuple<DAE.Exp, Boolean>> rest;
      equation
        (txt, i_varLstStr, i_varDecls, i_preExp) = lm_287(txt, rest, i_varLstStr, i_arrayTypeStr, i_varDecls, i_preExp, i_context);
      then (txt, i_varLstStr, i_varDecls, i_preExp);
  end matchcontinue;
end lm_287;

public function daeExpMatrixRow
  input Tpl.Text txt;
  input list<tuple<DAE.Exp, Boolean>> i_row;
  input String i_arrayTypeStr;
  input SimCode.Context i_context;
  input Tpl.Text i_preExp;
  input Tpl.Text i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
protected
  Tpl.Text i_preExp2;
  Tpl.Text i_varLstStr;
algorithm
  i_varLstStr := emptyTxt;
  i_preExp2 := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_preExp2, i_varLstStr, out_i_varDecls, out_i_preExp) := lm_287(i_preExp2, i_row, i_varLstStr, i_arrayTypeStr, i_varDecls, i_preExp, i_context);
  i_preExp2 := Tpl.popIter(i_preExp2);
  i_preExp2 := Tpl.writeTok(i_preExp2, Tpl.ST_NEW_LINE());
  out_i_preExp := Tpl.writeText(out_i_preExp, i_preExp2);
  out_txt := Tpl.writeText(txt, i_varLstStr);
end daeExpMatrixRow;

protected function fun_289
  input Tpl.Text in_txt;
  input DAE.ExpType in_i_ty;
  input Tpl.Text in_i_preExp;
  input DAE.Exp in_i_exp;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_expVar;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_ty, in_i_preExp, in_i_exp, in_i_varDecls, in_i_expVar)
    local
      Tpl.Text txt;
      Tpl.Text i_preExp;
      DAE.Exp i_exp;
      Tpl.Text i_varDecls;
      Tpl.Text i_expVar;

    case ( txt,
           DAE.ET_INT(),
           i_preExp,
           _,
           i_varDecls,
           i_expVar )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("((modelica_int)"));
        txt = Tpl.writeText(txt, i_expVar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.ET_REAL(),
           i_preExp,
           _,
           i_varDecls,
           i_expVar )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("((modelica_real)"));
        txt = Tpl.writeText(txt, i_expVar);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING(")"));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.ET_ARRAY(ty = i_ty),
           i_preExp,
           i_exp,
           i_varDecls,
           i_expVar )
      local
        DAE.ExpType i_ty;
        Tpl.Text i_from;
        Tpl.Text i_to;
        Tpl.Text i_tvar;
        Tpl.Text i_arrayTypeStr;
      equation
        i_arrayTypeStr = expTypeArray(emptyTxt, i_ty);
        (i_tvar, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_arrayTypeStr), i_varDecls);
        i_to = expTypeShort(emptyTxt, i_ty);
        i_from = expTypeFromExpShort(emptyTxt, i_exp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("cast_"));
        i_preExp = Tpl.writeText(i_preExp, i_from);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("_array_to_"));
        i_preExp = Tpl.writeText(i_preExp, i_to);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("(&"));
        i_preExp = Tpl.writeText(i_preExp, i_expVar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", &"));
        i_preExp = Tpl.writeText(i_preExp, i_tvar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_tvar);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           i_preExp,
           _,
           i_varDecls,
           _ )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end fun_289;

public function daeExpCast
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.CAST(exp = i_exp, ty = i_ty),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.ExpType i_ty;
        DAE.Exp i_exp;
        Tpl.Text i_expVar;
      equation
        (i_expVar, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, i_context, i_preExp, i_varDecls);
        (txt, i_preExp, i_varDecls) = fun_289(txt, i_ty, i_preExp, i_exp, i_varDecls, i_expVar);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExpCast;

protected function fun_291
  input Tpl.Text in_txt;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_arrName;
  input list<DAE.Exp> in_i_subs;
  input DAE.ExpType in_i_cref_ty;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_i_context, in_i_varDecls, in_i_preExp, in_i_arrName, in_i_subs, in_i_cref_ty)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      Tpl.Text i_arrName;
      list<DAE.Exp> i_subs;
      DAE.ExpType i_cref_ty;

    case ( txt,
           (i_context as SimCode.SIMULATION(genDiscrete = _)),
           i_varDecls,
           i_preExp,
           i_arrName,
           i_subs,
           i_cref_ty )
      local
        SimCode.Context i_context;
      equation
        (txt, i_preExp, i_varDecls) = arrayScalarRhs(txt, i_cref_ty, i_subs, Tpl.textString(i_arrName), i_context, i_preExp, i_varDecls);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _,
           i_varDecls,
           i_preExp,
           i_arrName,
           _,
           _ )
      equation
        txt = Tpl.writeText(txt, i_arrName);
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end fun_291;

public function daeExpAsub
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.ASUB(exp = DAE.RANGE(ty = i_t), sub = {i_idx}),
           _,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_idx;
        DAE.ExpType i_t;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("ASUB_EASY_CASE"));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.ASUB(exp = DAE.ASUB(exp = DAE.ASUB(exp = DAE.ASUB(exp = i_e, sub = {DAE.ICONST(integer = i_i)}), sub = {DAE.ICONST(integer = i_j)}), sub = {DAE.ICONST(integer = i_k)}), sub = {DAE.ICONST(integer = i_l)}),
           _,
           i_preExp,
           i_varDecls )
      local
        Integer i_l;
        Integer i_k;
        Integer i_j;
        Integer i_i;
        DAE.Exp i_e;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("ASUB_4D"));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.ASUB(exp = DAE.ASUB(exp = DAE.ASUB(exp = i_e, sub = {DAE.ICONST(integer = i_i)}), sub = {DAE.ICONST(integer = i_j)}), sub = {DAE.ICONST(integer = i_k)}),
           _,
           i_preExp,
           i_varDecls )
      local
        Integer i_k;
        Integer i_j;
        Integer i_i;
        DAE.Exp i_e;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("ASUB_3D"));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.ASUB(exp = DAE.ASUB(exp = i_e, sub = {DAE.ICONST(integer = i_i)}), sub = {DAE.ICONST(integer = i_j)}),
           _,
           i_preExp,
           i_varDecls )
      local
        Integer i_j;
        Integer i_i;
        DAE.Exp i_e;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("ASUB_2D"));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.ASUB(exp = i_e, sub = {DAE.ICONST(integer = i_i)}),
           _,
           i_preExp,
           i_varDecls )
      local
        Integer i_i;
        DAE.Exp i_e;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("ASUB_ARRAY"));
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           DAE.ASUB(exp = (i_cref as DAE.CREF(ty = i_cref_ty)), sub = i_subs),
           i_context,
           i_preExp,
           i_varDecls )
      local
        list<DAE.Exp> i_subs;
        DAE.ExpType i_cref_ty;
        DAE.Exp i_cref;
        DAE.Exp ret_1;
        Tpl.Text i_arrName;
      equation
        ret_1 = SimCode.buildCrefExpFromAsub(i_cref, i_subs);
        (i_arrName, i_preExp, i_varDecls) = daeExpCrefRhs(emptyTxt, ret_1, i_context, i_preExp, i_varDecls);
        (txt, i_varDecls, i_preExp) = fun_291(txt, i_context, i_varDecls, i_preExp, i_arrName, i_subs, i_cref_ty);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("OTHER_ASUB"));
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExpAsub;

public function daeExpSize
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.SIZE(exp = (i_exp as DAE.CREF(ty = i_exp_ty)), sz = SOME(i_dim)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Exp i_dim;
        DAE.ExpType i_exp_ty;
        DAE.Exp i_exp;
        Tpl.Text i_typeStr;
        Tpl.Text i_resVar;
        Tpl.Text i_dimPart;
        Tpl.Text i_expPart;
      equation
        (i_expPart, i_preExp, i_varDecls) = daeExp(emptyTxt, i_exp, i_context, i_preExp, i_varDecls);
        (i_dimPart, i_preExp, i_varDecls) = daeExp(emptyTxt, i_dim, i_context, i_preExp, i_varDecls);
        (i_resVar, i_varDecls) = tempDecl(emptyTxt, "size_t", i_varDecls);
        i_typeStr = expTypeArray(emptyTxt, i_exp_ty);
        i_preExp = Tpl.writeText(i_preExp, i_resVar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = size_of_dimension_"));
        i_preExp = Tpl.writeText(i_preExp, i_typeStr);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("("));
        i_preExp = Tpl.writeText(i_preExp, i_expPart);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_dimPart);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(");"));
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_NEW_LINE());
        txt = Tpl.writeText(txt, i_resVar);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("size(X) not implemented"));
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExpSize;

protected function fun_294
  input Tpl.Text in_txt;
  input String in_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_it)
    local
      Tpl.Text txt;

    case ( txt,
           "min" )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(modelica_real)"));
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end fun_294;

protected function fun_295
  input Tpl.Text in_txt;
  input String in_it;
  input Tpl.Text in_i_accFun;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_it, in_i_accFun)
    local
      Tpl.Text txt;
      Tpl.Text i_accFun;

    case ( txt,
           "max",
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(modelica_real)"));
      then txt;

    case ( txt,
           _,
           i_accFun )
      local
        String str_0;
      equation
        str_0 = Tpl.textString(i_accFun);
        txt = fun_294(txt, str_0);
      then txt;
  end matchcontinue;
end fun_295;

protected function fun_296
  input Tpl.Text in_txt;
  input Option<DAE.Exp> in_i_range_expOption;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_i_range_expOption, in_i_varDecls, in_i_preExp, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      SimCode.Context i_context;

    case ( txt,
           SOME(i_eo),
           i_varDecls,
           i_preExp,
           i_context )
      local
        DAE.Exp i_eo;
      equation
        (txt, i_preExp, i_varDecls) = daeExp(txt, i_eo, i_context, i_preExp, i_varDecls);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _,
           i_varDecls,
           i_preExp,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("(1)"));
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end fun_296;

public function daeExpReduction
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.REDUCTION(path = Absyn.IDENT(name = i_op), range = DAE.RANGE(ty = i_range_ty, exp = i_range_exp, expOption = i_range_expOption, range = i_range_range), expr = i_expr, ident = i_ident),
           i_context,
           i_preExp,
           i_varDecls )
      local
        DAE.Ident i_ident;
        DAE.Exp i_expr;
        DAE.Exp i_range_range;
        Option<DAE.Exp> i_range_expOption;
        DAE.Exp i_range_exp;
        DAE.ExpType i_range_ty;
        Absyn.Ident i_op;
        Tpl.Text i_er3;
        Tpl.Text i_er2;
        Tpl.Text i_er1;
        Tpl.Text i_r3;
        Tpl.Text i_r2;
        Tpl.Text i_r1;
        String str_8;
        Tpl.Text i_cast;
        Tpl.Text i_tmpExpVar;
        Tpl.Text i_tmpExpPre;
        Tpl.Text i_res;
        Tpl.Text i_startValue;
        Tpl.Text i_accFun;
        Tpl.Text i_identType;
        Tpl.Text i_stateVar;
      equation
        (i_stateVar, i_varDecls) = tempDecl(emptyTxt, "state", i_varDecls);
        i_identType = expTypeModelica(emptyTxt, i_range_ty);
        i_accFun = daeExpReductionFnName(emptyTxt, i_op, Tpl.textString(i_identType));
        i_startValue = daeExpReductionStartValue(emptyTxt, i_op, Tpl.textString(i_identType));
        (i_res, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_identType), i_varDecls);
        i_tmpExpPre = emptyTxt;
        (i_tmpExpVar, i_tmpExpPre, i_varDecls) = daeExp(emptyTxt, i_expr, i_context, i_tmpExpPre, i_varDecls);
        str_8 = Tpl.textString(i_accFun);
        i_cast = fun_295(emptyTxt, str_8, i_accFun);
        (i_r1, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_identType), i_varDecls);
        (i_r2, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_identType), i_varDecls);
        (i_r3, i_varDecls) = tempDecl(emptyTxt, Tpl.textString(i_identType), i_varDecls);
        (i_er1, i_preExp, i_varDecls) = daeExp(emptyTxt, i_range_exp, i_context, i_preExp, i_varDecls);
        (i_er2, i_varDecls, i_preExp) = fun_296(emptyTxt, i_range_expOption, i_varDecls, i_preExp, i_context);
        (i_er3, i_preExp, i_varDecls) = daeExp(emptyTxt, i_range_range, i_context, i_preExp, i_varDecls);
        i_preExp = Tpl.writeText(i_preExp, i_res);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = "));
        i_preExp = Tpl.writeText(i_preExp, i_startValue);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_LINE(";\n"));
        i_preExp = Tpl.writeText(i_preExp, i_r1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = "));
        i_preExp = Tpl.writeText(i_preExp, i_er1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("; "));
        i_preExp = Tpl.writeText(i_preExp, i_r2);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = "));
        i_preExp = Tpl.writeText(i_preExp, i_er2);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("; "));
        i_preExp = Tpl.writeText(i_preExp, i_r3);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = "));
        i_preExp = Tpl.writeText(i_preExp, i_er3);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING_LIST({
                                              ";\n",
                                              "{\n"
                                          }, true));
        i_preExp = Tpl.pushBlock(i_preExp, Tpl.BT_INDENT(2));
        i_preExp = Tpl.writeText(i_preExp, i_identType);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" "));
        i_preExp = Tpl.writeStr(i_preExp, i_ident);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING_LIST({
                                              ";\n",
                                              "\n",
                                              "for ("
                                          }, false));
        i_preExp = Tpl.writeStr(i_preExp, i_ident);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = "));
        i_preExp = Tpl.writeText(i_preExp, i_r1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("; in_range_"));
        i_preExp = expTypeFromExpShort(i_preExp, i_expr);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("("));
        i_preExp = Tpl.writeStr(i_preExp, i_ident);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_r1);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(", "));
        i_preExp = Tpl.writeText(i_preExp, i_r3);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("); "));
        i_preExp = Tpl.writeStr(i_preExp, i_ident);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" += "));
        i_preExp = Tpl.writeText(i_preExp, i_r2);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_LINE(") {\n"));
        i_preExp = Tpl.pushBlock(i_preExp, Tpl.BT_INDENT(2));
        i_preExp = Tpl.writeText(i_preExp, i_stateVar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_LINE(" = get_memory_state();\n"));
        i_preExp = Tpl.writeText(i_preExp, i_tmpExpPre);
        i_preExp = Tpl.softNewLine(i_preExp);
        i_preExp = Tpl.writeText(i_preExp, i_res);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = "));
        i_preExp = Tpl.writeText(i_preExp, i_accFun);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("("));
        i_preExp = Tpl.writeText(i_preExp, i_cast);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("("));
        i_preExp = Tpl.writeText(i_preExp, i_res);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("), "));
        i_preExp = Tpl.writeText(i_preExp, i_cast);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("("));
        i_preExp = Tpl.writeText(i_preExp, i_tmpExpVar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING_LIST({
                                              "));\n",
                                              "restore_memory_state("
                                          }, false));
        i_preExp = Tpl.writeText(i_preExp, i_stateVar);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_LINE(");\n"));
        i_preExp = Tpl.popBlock(i_preExp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_LINE("}\n"));
        i_preExp = Tpl.popBlock(i_preExp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("}"));
        txt = Tpl.writeText(txt, i_res);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end daeExpReduction;

protected function fun_298
  input Tpl.Text in_txt;
  input String in_i_type;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_type)
    local
      Tpl.Text txt;

    case ( txt,
           "modelica_integer" )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("intAdd"));
      then txt;

    case ( txt,
           "modelica_real" )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("realAdd"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("INVALID_TYPE"));
      then txt;
  end matchcontinue;
end fun_298;

protected function fun_299
  input Tpl.Text in_txt;
  input String in_i_type;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_type)
    local
      Tpl.Text txt;

    case ( txt,
           "modelica_integer" )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("intMul"));
      then txt;

    case ( txt,
           "modelica_real" )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("realMul"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("INVALID_TYPE"));
      then txt;
  end matchcontinue;
end fun_299;

public function daeExpReductionFnName
  input Tpl.Text in_txt;
  input String in_i_reduction__op;
  input String in_i_type;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_reduction__op, in_i_type)
    local
      Tpl.Text txt;
      String i_type;

    case ( txt,
           "sum",
           i_type )
      equation
        txt = fun_298(txt, i_type);
      then txt;

    case ( txt,
           "product",
           i_type )
      equation
        txt = fun_299(txt, i_type);
      then txt;

    case ( txt,
           i_reduction__op,
           _ )
      local
        String i_reduction__op;
      equation
        txt = Tpl.writeStr(txt, i_reduction__op);
      then txt;
  end matchcontinue;
end daeExpReductionFnName;

protected function fun_301
  input Tpl.Text in_txt;
  input String in_i_type;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_type)
    local
      Tpl.Text txt;

    case ( txt,
           "modelica_integer" )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("1073741823"));
      then txt;

    case ( txt,
           "modelica_real" )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("1.e60"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("INVALID_TYPE"));
      then txt;
  end matchcontinue;
end fun_301;

protected function fun_302
  input Tpl.Text in_txt;
  input String in_i_type;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_type)
    local
      Tpl.Text txt;

    case ( txt,
           "modelica_integer" )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("-1073741823"));
      then txt;

    case ( txt,
           "modelica_real" )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("-1.e60"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("INVALID_TYPE"));
      then txt;
  end matchcontinue;
end fun_302;

public function daeExpReductionStartValue
  input Tpl.Text in_txt;
  input String in_i_reduction__op;
  input String in_i_type;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_reduction__op, in_i_type)
    local
      Tpl.Text txt;
      String i_type;

    case ( txt,
           "min",
           i_type )
      equation
        txt = fun_301(txt, i_type);
      then txt;

    case ( txt,
           "max",
           i_type )
      equation
        txt = fun_302(txt, i_type);
      then txt;

    case ( txt,
           "sum",
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("0"));
      then txt;

    case ( txt,
           "product",
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("1"));
      then txt;

    case ( txt,
           _,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("UNKNOWN_REDUCTION"));
      then txt;
  end matchcontinue;
end daeExpReductionStartValue;

protected function lm_304
  input Tpl.Text in_txt;
  input SimCode.Variables in_items;
  input Tpl.Text in_i_preExpInner;
  input Tpl.Text in_i_varDeclsInner;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExpInner;
  output Tpl.Text out_i_varDeclsInner;
algorithm
  (out_txt, out_i_preExpInner, out_i_varDeclsInner) :=
  matchcontinue(in_txt, in_items, in_i_preExpInner, in_i_varDeclsInner)
    local
      Tpl.Text txt;
      Tpl.Text i_preExpInner;
      Tpl.Text i_varDeclsInner;

    case ( txt,
           {},
           i_preExpInner,
           i_varDeclsInner )
      then (txt, i_preExpInner, i_varDeclsInner);

    case ( txt,
           i_it :: rest,
           i_preExpInner,
           i_varDeclsInner )
      local
        SimCode.Variables rest;
        SimCode.Variable i_it;
      equation
        (txt, i_varDeclsInner, i_preExpInner) = varInit(txt, i_it, "", 0, i_varDeclsInner, i_preExpInner);
        txt = Tpl.nextIter(txt);
        (txt, i_preExpInner, i_varDeclsInner) = lm_304(txt, rest, i_preExpInner, i_varDeclsInner);
      then (txt, i_preExpInner, i_varDeclsInner);

    case ( txt,
           _ :: rest,
           i_preExpInner,
           i_varDeclsInner )
      local
        SimCode.Variables rest;
      equation
        (txt, i_preExpInner, i_varDeclsInner) = lm_304(txt, rest, i_preExpInner, i_varDeclsInner);
      then (txt, i_preExpInner, i_varDeclsInner);
  end matchcontinue;
end lm_304;

protected function lm_305
  input Tpl.Text in_txt;
  input list<DAE.Statement> in_items;
  input Tpl.Text in_i_varDeclsInner;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDeclsInner;
algorithm
  (out_txt, out_i_varDeclsInner) :=
  matchcontinue(in_txt, in_items, in_i_varDeclsInner, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDeclsInner;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDeclsInner,
           _ )
      then (txt, i_varDeclsInner);

    case ( txt,
           i_it :: rest,
           i_varDeclsInner,
           i_context )
      local
        list<DAE.Statement> rest;
        DAE.Statement i_it;
      equation
        (txt, i_varDeclsInner) = algStatement(txt, i_it, i_context, i_varDeclsInner);
        txt = Tpl.nextIter(txt);
        (txt, i_varDeclsInner) = lm_305(txt, rest, i_varDeclsInner, i_context);
      then (txt, i_varDeclsInner);

    case ( txt,
           _ :: rest,
           i_varDeclsInner,
           i_context )
      local
        list<DAE.Statement> rest;
      equation
        (txt, i_varDeclsInner) = lm_305(txt, rest, i_varDeclsInner, i_context);
      then (txt, i_varDeclsInner);
  end matchcontinue;
end lm_305;

protected function fun_306
  input Tpl.Text in_txt;
  input DAE.Exp in_i_exp;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_preExp) :=
  matchcontinue(in_txt, in_i_exp, in_i_context, in_i_preExp)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;

    case ( txt,
           (i_exp as DAE.VALUEBLOCK(ty = i_ty, body = i_body, result = i_result)),
           i_context,
           i_preExp )
      local
        DAE.Exp i_result;
        list<DAE.Statement> i_body;
        DAE.ExpType i_ty;
        DAE.Exp i_exp;
        Tpl.Text i_expPart;
        Tpl.Text i_stmts;
        Tpl.Text txt_7;
        Tpl.Text i_res;
        Tpl.Text i_resType;
        SimCode.Variables ret_4;
        Tpl.Text i_0__;
        Tpl.Text i_varDeclsInner;
        Tpl.Text i_preExpRes;
        Tpl.Text i_preExpInner;
      equation
        i_preExpInner = emptyTxt;
        i_preExpRes = emptyTxt;
        i_varDeclsInner = emptyTxt;
        ret_4 = SimCode.valueblockVars(i_exp);
        i_0__ = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_0__, i_preExpInner, i_varDeclsInner) = lm_304(i_0__, ret_4, i_preExpInner, i_varDeclsInner);
        i_0__ = Tpl.popIter(i_0__);
        i_resType = expTypeModelica(emptyTxt, i_ty);
        txt_7 = expTypeModelica(emptyTxt, i_ty);
        (i_res, i_preExp) = tempDecl(emptyTxt, Tpl.textString(txt_7), i_preExp);
        i_stmts = Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_NEW_LINE()), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
        (i_stmts, i_varDeclsInner) = lm_305(i_stmts, i_body, i_varDeclsInner, i_context);
        i_stmts = Tpl.popIter(i_stmts);
        (i_expPart, i_preExpRes, i_varDeclsInner) = daeExp(emptyTxt, i_result, i_context, i_preExpRes, i_varDeclsInner);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_LINE("{\n"));
        i_preExp = Tpl.pushBlock(i_preExp, Tpl.BT_INDENT(2));
        i_preExp = Tpl.writeText(i_preExp, i_varDeclsInner);
        i_preExp = Tpl.softNewLine(i_preExp);
        i_preExp = Tpl.writeText(i_preExp, i_preExpInner);
        i_preExp = Tpl.softNewLine(i_preExp);
        i_preExp = Tpl.writeText(i_preExp, i_stmts);
        i_preExp = Tpl.softNewLine(i_preExp);
        i_preExp = Tpl.writeText(i_preExp, i_preExpRes);
        i_preExp = Tpl.softNewLine(i_preExp);
        i_preExp = Tpl.writeText(i_preExp, i_res);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING(" = "));
        i_preExp = Tpl.writeText(i_preExp, i_expPart);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_LINE(";\n"));
        i_preExp = Tpl.popBlock(i_preExp);
        i_preExp = Tpl.writeTok(i_preExp, Tpl.ST_STRING("}"));
        txt = Tpl.writeText(txt, i_res);
      then (txt, i_preExp);

    case ( txt,
           _,
           _,
           i_preExp )
      then (txt, i_preExp);
  end matchcontinue;
end fun_306;

public function daeExpValueblock
  input Tpl.Text txt;
  input DAE.Exp i_exp;
  input SimCode.Context i_context;
  input Tpl.Text i_preExp;
  input Tpl.Text i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp) := fun_306(txt, i_exp, i_context, i_preExp);
  out_i_varDecls := i_varDecls;
end daeExpValueblock;

protected function lm_308
  input Tpl.Text in_txt;
  input list<DAE.Exp> in_items;
  input Tpl.Text in_i_varDecls;
  input Tpl.Text in_i_preExp;
  input SimCode.Context in_i_context;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
  output Tpl.Text out_i_preExp;
algorithm
  (out_txt, out_i_varDecls, out_i_preExp) :=
  matchcontinue(in_txt, in_items, in_i_varDecls, in_i_preExp, in_i_context)
    local
      Tpl.Text txt;
      Tpl.Text i_varDecls;
      Tpl.Text i_preExp;
      SimCode.Context i_context;

    case ( txt,
           {},
           i_varDecls,
           i_preExp,
           _ )
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           i_exp :: rest,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<DAE.Exp> rest;
        DAE.Exp i_exp;
      equation
        (txt, i_preExp, i_varDecls) = daeExp(txt, i_exp, i_context, i_preExp, i_varDecls);
        txt = Tpl.nextIter(txt);
        (txt, i_varDecls, i_preExp) = lm_308(txt, rest, i_varDecls, i_preExp, i_context);
      then (txt, i_varDecls, i_preExp);

    case ( txt,
           _ :: rest,
           i_varDecls,
           i_preExp,
           i_context )
      local
        list<DAE.Exp> rest;
      equation
        (txt, i_varDecls, i_preExp) = lm_308(txt, rest, i_varDecls, i_preExp, i_context);
      then (txt, i_varDecls, i_preExp);
  end matchcontinue;
end lm_308;

public function arrayScalarRhs
  input Tpl.Text txt;
  input DAE.ExpType i_ty;
  input list<DAE.Exp> i_subs;
  input String i_arrName;
  input SimCode.Context i_context;
  input Tpl.Text i_preExp;
  input Tpl.Text i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
protected
  Tpl.Text i_dimsValuesStr;
  Integer ret_2;
  Tpl.Text i_dimsLenStr;
  Tpl.Text i_arrayType;
algorithm
  i_arrayType := expTypeArray(emptyTxt, i_ty);
  ret_2 := listLength(i_subs);
  i_dimsLenStr := Tpl.writeStr(emptyTxt, intString(ret_2));
  i_dimsValuesStr := Tpl.pushIter(emptyTxt, Tpl.ITER_OPTIONS(0, NONE, SOME(Tpl.ST_STRING(", ")), 0, 0, Tpl.ST_NEW_LINE(), 0, Tpl.ST_NEW_LINE()));
  (i_dimsValuesStr, out_i_varDecls, out_i_preExp) := lm_308(i_dimsValuesStr, i_subs, i_varDecls, i_preExp, i_context);
  i_dimsValuesStr := Tpl.popIter(i_dimsValuesStr);
  out_txt := Tpl.writeTok(txt, Tpl.ST_STRING("(*"));
  out_txt := Tpl.writeText(out_txt, i_arrayType);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("_element_addr(&"));
  out_txt := Tpl.writeStr(out_txt, i_arrName);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING(", "));
  out_txt := Tpl.writeText(out_txt, i_dimsLenStr);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING(", "));
  out_txt := Tpl.writeText(out_txt, i_dimsValuesStr);
  out_txt := Tpl.writeTok(out_txt, Tpl.ST_STRING("))"));
end arrayScalarRhs;

public function tempDecl
  input Tpl.Text txt;
  input String i_ty;
  input Tpl.Text i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_varDecls;
protected
  Integer ret_1;
  Tpl.Text i_newVar;
algorithm
  i_newVar := Tpl.writeTok(emptyTxt, Tpl.ST_STRING("tmp"));
  ret_1 := System.tmpTick();
  i_newVar := Tpl.writeStr(i_newVar, intString(ret_1));
  out_i_varDecls := Tpl.writeStr(i_varDecls, i_ty);
  out_i_varDecls := Tpl.writeTok(out_i_varDecls, Tpl.ST_STRING(" "));
  out_i_varDecls := Tpl.writeText(out_i_varDecls, i_newVar);
  out_i_varDecls := Tpl.writeTok(out_i_varDecls, Tpl.ST_STRING(";"));
  out_i_varDecls := Tpl.writeTok(out_i_varDecls, Tpl.ST_NEW_LINE());
  out_txt := Tpl.writeText(txt, i_newVar);
end tempDecl;

protected function fun_311
  input Tpl.Text in_txt;
  input list<DAE.Exp> in_i_instDims;
  input SimCode.Type in_i_var_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_instDims, in_i_var_ty)
    local
      Tpl.Text txt;
      SimCode.Type i_var_ty;

    case ( txt,
           {},
           i_var_ty )
      equation
        txt = expTypeArrayIf(txt, i_var_ty);
      then txt;

    case ( txt,
           _,
           i_var_ty )
      equation
        txt = expTypeArray(txt, i_var_ty);
      then txt;
  end matchcontinue;
end fun_311;

public function varType
  input Tpl.Text in_txt;
  input SimCode.Variable in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           (i_var as SimCode.VARIABLE(instDims = i_instDims, ty = i_var_ty)) )
      local
        SimCode.Type i_var_ty;
        list<DAE.Exp> i_instDims;
        SimCode.Variable i_var;
      equation
        txt = fun_311(txt, i_instDims, i_var_ty);
      then txt;

    case ( txt,
           _ )
      then txt;
  end matchcontinue;
end varType;

public function expTypeShort
  input Tpl.Text in_txt;
  input DAE.ExpType in_i_it;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.ET_INT() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("integer"));
      then txt;

    case ( txt,
           DAE.ET_REAL() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("real"));
      then txt;

    case ( txt,
           DAE.ET_STRING() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("string"));
      then txt;

    case ( txt,
           DAE.ET_BOOL() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("boolean"));
      then txt;

    case ( txt,
           DAE.ET_OTHER() )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("complex"));
      then txt;

    case ( txt,
           DAE.ET_ARRAY(ty = i_ty) )
      local
        DAE.ExpType i_ty;
      equation
        txt = expTypeShort(txt, i_ty);
      then txt;

    case ( txt,
           DAE.ET_COMPLEX(complexClassType = ClassInf.EXTERNAL_OBJ(path = _)) )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("complex"));
      then txt;

    case ( txt,
           DAE.ET_COMPLEX(name = i_name) )
      local
        Absyn.Path i_name;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("struct "));
        txt = underscorePath(txt, i_name);
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("expTypeShort:ERROR"));
      then txt;
  end matchcontinue;
end expTypeShort;

protected function fun_314
  input Tpl.Text in_txt;
  input Boolean in_i_array;
  input DAE.ExpType in_i_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_array, in_i_ty)
    local
      Tpl.Text txt;
      DAE.ExpType i_ty;

    case ( txt,
           true,
           i_ty )
      equation
        txt = expTypeArray(txt, i_ty);
      then txt;

    case ( txt,
           false,
           i_ty )
      equation
        txt = expTypeModelica(txt, i_ty);
      then txt;

    case ( txt,
           _,
           _ )
      then txt;
  end matchcontinue;
end fun_314;

public function expType
  input Tpl.Text txt;
  input DAE.ExpType i_ty;
  input Boolean i_array;

  output Tpl.Text out_txt;
algorithm
  out_txt := fun_314(txt, i_array, i_ty);
end expType;

public function expTypeModelica
  input Tpl.Text txt;
  input DAE.ExpType i_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt := expTypeFlag(txt, i_ty, 2);
end expTypeModelica;

public function expTypeArray
  input Tpl.Text txt;
  input DAE.ExpType i_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt := expTypeFlag(txt, i_ty, 3);
end expTypeArray;

public function expTypeArrayIf
  input Tpl.Text txt;
  input DAE.ExpType i_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt := expTypeFlag(txt, i_ty, 4);
end expTypeArrayIf;

public function expTypeFromExpShort
  input Tpl.Text txt;
  input DAE.Exp i_exp;

  output Tpl.Text out_txt;
algorithm
  out_txt := expTypeFromExpFlag(txt, i_exp, 1);
end expTypeFromExpShort;

public function expTypeFromExpModelica
  input Tpl.Text txt;
  input DAE.Exp i_exp;

  output Tpl.Text out_txt;
algorithm
  out_txt := expTypeFromExpFlag(txt, i_exp, 2);
end expTypeFromExpModelica;

public function expTypeFromExpArray
  input Tpl.Text txt;
  input DAE.Exp i_exp;

  output Tpl.Text out_txt;
algorithm
  out_txt := expTypeFromExpFlag(txt, i_exp, 3);
end expTypeFromExpArray;

public function expTypeFromExpArrayIf
  input Tpl.Text txt;
  input DAE.Exp i_exp;

  output Tpl.Text out_txt;
algorithm
  out_txt := expTypeFromExpFlag(txt, i_exp, 4);
end expTypeFromExpArrayIf;

protected function fun_323
  input Tpl.Text in_txt;
  input DAE.ExpType in_i_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_ty)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.ET_COMPLEX(name = i_name) )
      local
        Absyn.Path i_name;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("struct "));
        txt = underscorePath(txt, i_name);
      then txt;

    case ( txt,
           i_ty )
      local
        DAE.ExpType i_ty;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("modelica_"));
        txt = expTypeShort(txt, i_ty);
      then txt;
  end matchcontinue;
end fun_323;

protected function fun_324
  input Tpl.Text in_txt;
  input DAE.ExpType in_i_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_ty)
    local
      Tpl.Text txt;

    case ( txt,
           (i_ty as DAE.ET_COMPLEX(complexClassType = ClassInf.EXTERNAL_OBJ(path = _))) )
      local
        DAE.ExpType i_ty;
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("modelica_"));
        txt = expTypeShort(txt, i_ty);
      then txt;

    case ( txt,
           i_ty )
      local
        DAE.ExpType i_ty;
      equation
        txt = fun_323(txt, i_ty);
      then txt;
  end matchcontinue;
end fun_324;

protected function fun_325
  input Tpl.Text in_txt;
  input DAE.ExpType in_i_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_ty)
    local
      Tpl.Text txt;

    case ( txt,
           DAE.ET_ARRAY(ty = i_ty) )
      local
        DAE.ExpType i_ty;
      equation
        txt = expTypeShort(txt, i_ty);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_array"));
      then txt;

    case ( txt,
           i_ty )
      local
        DAE.ExpType i_ty;
      equation
        txt = expTypeFlag(txt, i_ty, 2);
      then txt;
  end matchcontinue;
end fun_325;

protected function fun_326
  input Tpl.Text in_txt;
  input Integer in_i_flag;
  input DAE.ExpType in_i_ty;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_flag, in_i_ty)
    local
      Tpl.Text txt;
      DAE.ExpType i_ty;

    case ( txt,
           1,
           i_ty )
      equation
        txt = expTypeShort(txt, i_ty);
      then txt;

    case ( txt,
           2,
           i_ty )
      equation
        txt = fun_324(txt, i_ty);
      then txt;

    case ( txt,
           3,
           i_ty )
      equation
        txt = expTypeShort(txt, i_ty);
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("_array"));
      then txt;

    case ( txt,
           4,
           i_ty )
      equation
        txt = fun_325(txt, i_ty);
      then txt;

    case ( txt,
           _,
           _ )
      then txt;
  end matchcontinue;
end fun_326;

public function expTypeFlag
  input Tpl.Text txt;
  input DAE.ExpType i_ty;
  input Integer i_flag;

  output Tpl.Text out_txt;
algorithm
  out_txt := fun_326(txt, i_flag, i_ty);
end expTypeFlag;

protected function fun_328
  input Tpl.Text in_txt;
  input Integer in_i_flag;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_flag)
    local
      Tpl.Text txt;

    case ( txt,
           1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("integer"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("modelica_integer"));
      then txt;
  end matchcontinue;
end fun_328;

protected function fun_329
  input Tpl.Text in_txt;
  input Integer in_i_flag;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_flag)
    local
      Tpl.Text txt;

    case ( txt,
           1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("real"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("modelica_real"));
      then txt;
  end matchcontinue;
end fun_329;

protected function fun_330
  input Tpl.Text in_txt;
  input Integer in_i_flag;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_flag)
    local
      Tpl.Text txt;

    case ( txt,
           1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("string"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("modelica_string"));
      then txt;
  end matchcontinue;
end fun_330;

protected function fun_331
  input Tpl.Text in_txt;
  input Integer in_i_flag;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_flag)
    local
      Tpl.Text txt;

    case ( txt,
           1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("boolean"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("modelica_boolean"));
      then txt;
  end matchcontinue;
end fun_331;

public function expTypeFromExpFlag
  input Tpl.Text in_txt;
  input DAE.Exp in_i_it;
  input Integer in_i_flag;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it, in_i_flag)
    local
      Tpl.Text txt;
      Integer i_flag;

    case ( txt,
           DAE.ICONST(integer = _),
           i_flag )
      equation
        txt = fun_328(txt, i_flag);
      then txt;

    case ( txt,
           DAE.RCONST(real = _),
           i_flag )
      equation
        txt = fun_329(txt, i_flag);
      then txt;

    case ( txt,
           DAE.SCONST(string = _),
           i_flag )
      equation
        txt = fun_330(txt, i_flag);
      then txt;

    case ( txt,
           DAE.BCONST(bool = _),
           i_flag )
      equation
        txt = fun_331(txt, i_flag);
      then txt;

    case ( txt,
           (i_e as DAE.BINARY(operator = i_e_operator)),
           i_flag )
      local
        DAE.Operator i_e_operator;
        DAE.Exp i_e;
      equation
        txt = expTypeFromOpFlag(txt, i_e_operator, i_flag);
      then txt;

    case ( txt,
           (i_e as DAE.UNARY(operator = i_e_operator)),
           i_flag )
      local
        DAE.Operator i_e_operator;
        DAE.Exp i_e;
      equation
        txt = expTypeFromOpFlag(txt, i_e_operator, i_flag);
      then txt;

    case ( txt,
           (i_e as DAE.LBINARY(operator = i_e_operator)),
           i_flag )
      local
        DAE.Operator i_e_operator;
        DAE.Exp i_e;
      equation
        txt = expTypeFromOpFlag(txt, i_e_operator, i_flag);
      then txt;

    case ( txt,
           (i_e as DAE.LUNARY(operator = i_e_operator)),
           i_flag )
      local
        DAE.Operator i_e_operator;
        DAE.Exp i_e;
      equation
        txt = expTypeFromOpFlag(txt, i_e_operator, i_flag);
      then txt;

    case ( txt,
           (i_e as DAE.RELATION(operator = i_e_operator)),
           i_flag )
      local
        DAE.Operator i_e_operator;
        DAE.Exp i_e;
      equation
        txt = expTypeFromOpFlag(txt, i_e_operator, i_flag);
      then txt;

    case ( txt,
           DAE.IFEXP(expThen = i_expThen),
           i_flag )
      local
        DAE.Exp i_expThen;
      equation
        txt = expTypeFromExpFlag(txt, i_expThen, i_flag);
      then txt;

    case ( txt,
           DAE.CALL(ty = i_ty),
           i_flag )
      local
        DAE.ExpType i_ty;
      equation
        txt = expTypeFlag(txt, i_ty, i_flag);
      then txt;

    case ( txt,
           (i_c as DAE.ARRAY(ty = i_c_ty)),
           i_flag )
      local
        DAE.ExpType i_c_ty;
        DAE.Exp i_c;
      equation
        txt = expTypeFlag(txt, i_c_ty, i_flag);
      then txt;

    case ( txt,
           (i_c as DAE.MATRIX(ty = i_c_ty)),
           i_flag )
      local
        DAE.ExpType i_c_ty;
        DAE.Exp i_c;
      equation
        txt = expTypeFlag(txt, i_c_ty, i_flag);
      then txt;

    case ( txt,
           (i_c as DAE.RANGE(ty = i_c_ty)),
           i_flag )
      local
        DAE.ExpType i_c_ty;
        DAE.Exp i_c;
      equation
        txt = expTypeFlag(txt, i_c_ty, i_flag);
      then txt;

    case ( txt,
           (i_c as DAE.CAST(ty = i_c_ty)),
           i_flag )
      local
        DAE.ExpType i_c_ty;
        DAE.Exp i_c;
      equation
        txt = expTypeFlag(txt, i_c_ty, i_flag);
      then txt;

    case ( txt,
           (i_c as DAE.CREF(ty = i_c_ty)),
           i_flag )
      local
        DAE.ExpType i_c_ty;
        DAE.Exp i_c;
      equation
        txt = expTypeFlag(txt, i_c_ty, i_flag);
      then txt;

    case ( txt,
           (i_c as DAE.CODE(ty = i_c_ty)),
           i_flag )
      local
        DAE.ExpType i_c_ty;
        DAE.Exp i_c;
      equation
        txt = expTypeFlag(txt, i_c_ty, i_flag);
      then txt;

    case ( txt,
           DAE.ASUB(exp = i_exp),
           i_flag )
      local
        DAE.Exp i_exp;
      equation
        txt = expTypeFromExpFlag(txt, i_exp, i_flag);
      then txt;

    case ( txt,
           DAE.REDUCTION(expr = i_expr),
           i_flag )
      local
        DAE.Exp i_expr;
      equation
        txt = expTypeFromExpFlag(txt, i_expr, i_flag);
      then txt;

    case ( txt,
           _,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("expTypeFromExpFlag:ERROR"));
      then txt;
  end matchcontinue;
end expTypeFromExpFlag;

protected function fun_333
  input Tpl.Text in_txt;
  input Integer in_i_flag;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_flag)
    local
      Tpl.Text txt;

    case ( txt,
           1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("boolean"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("modelica_boolean"));
      then txt;
  end matchcontinue;
end fun_333;

protected function fun_334
  input Tpl.Text in_txt;
  input Integer in_i_flag;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_flag)
    local
      Tpl.Text txt;

    case ( txt,
           1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("boolean"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("modelica_boolean"));
      then txt;
  end matchcontinue;
end fun_334;

protected function fun_335
  input Tpl.Text in_txt;
  input Integer in_i_flag;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_flag)
    local
      Tpl.Text txt;

    case ( txt,
           1 )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("boolean"));
      then txt;

    case ( txt,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("modelica_boolean"));
      then txt;
  end matchcontinue;
end fun_335;

public function expTypeFromOpFlag
  input Tpl.Text in_txt;
  input DAE.Operator in_i_it;
  input Integer in_i_flag;

  output Tpl.Text out_txt;
algorithm
  out_txt :=
  matchcontinue(in_txt, in_i_it, in_i_flag)
    local
      Tpl.Text txt;
      Integer i_flag;

    case ( txt,
           (i_o as DAE.ADD(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.SUB(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.MUL(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.DIV(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.POW(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.UMINUS(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.UPLUS(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.UMINUS_ARR(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.UPLUS_ARR(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.ADD_ARR(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.SUB_ARR(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.MUL_ARR(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.DIV_ARR(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.MUL_SCALAR_ARRAY(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.MUL_ARRAY_SCALAR(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.ADD_SCALAR_ARRAY(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.ADD_ARRAY_SCALAR(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.SUB_SCALAR_ARRAY(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.SUB_ARRAY_SCALAR(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.MUL_SCALAR_PRODUCT(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.MUL_MATRIX_PRODUCT(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.DIV_ARRAY_SCALAR(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.DIV_SCALAR_ARRAY(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.POW_ARRAY_SCALAR(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.POW_SCALAR_ARRAY(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.POW_ARR(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.POW_ARR2(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.LESS(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.LESSEQ(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.GREATER(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.GREATEREQ(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.EQUAL(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.NEQUAL(ty = i_o_ty)),
           i_flag )
      local
        DAE.ExpType i_o_ty;
        DAE.Operator i_o;
      equation
        txt = expTypeFlag(txt, i_o_ty, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.AND()),
           i_flag )
      local
        DAE.Operator i_o;
      equation
        txt = fun_333(txt, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.OR()),
           i_flag )
      local
        DAE.Operator i_o;
      equation
        txt = fun_334(txt, i_flag);
      then txt;

    case ( txt,
           (i_o as DAE.NOT()),
           i_flag )
      local
        DAE.Operator i_o;
      equation
        txt = fun_335(txt, i_flag);
      then txt;

    case ( txt,
           _,
           _ )
      equation
        txt = Tpl.writeTok(txt, Tpl.ST_STRING("expTypeFromOpFlag:ERROR"));
      then txt;
  end matchcontinue;
end expTypeFromOpFlag;

public function indexSpecFromCref
  input Tpl.Text in_txt;
  input DAE.ComponentRef in_i_cref;
  input SimCode.Context in_i_context;
  input Tpl.Text in_i_preExp;
  input Tpl.Text in_i_varDecls;

  output Tpl.Text out_txt;
  output Tpl.Text out_i_preExp;
  output Tpl.Text out_i_varDecls;
algorithm
  (out_txt, out_i_preExp, out_i_varDecls) :=
  matchcontinue(in_txt, in_i_cref, in_i_context, in_i_preExp, in_i_varDecls)
    local
      Tpl.Text txt;
      SimCode.Context i_context;
      Tpl.Text i_preExp;
      Tpl.Text i_varDecls;

    case ( txt,
           DAE.CREF_IDENT(subscriptLst = (i_subs as _ :: _)),
           i_context,
           i_preExp,
           i_varDecls )
      local
        list<DAE.Subscript> i_subs;
      equation
        (txt, i_preExp, i_varDecls) = daeExpCrefRhsIndexSpec(txt, i_subs, i_context, i_preExp, i_varDecls);
      then (txt, i_preExp, i_varDecls);

    case ( txt,
           _,
           _,
           i_preExp,
           i_varDecls )
      then (txt, i_preExp, i_varDecls);
  end matchcontinue;
end indexSpecFromCref;

end SimCodeC;