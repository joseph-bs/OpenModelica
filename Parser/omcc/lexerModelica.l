%{
  
%}

%x c_comment
%x c_linecomment
%x c_string

whitespace   [ \t\n]+
letter       [a-zA-Z]
ident        {letter}({letter}|{digit})*
digit        [0-9]
digits       {digit}+
/* Lex style lexical syntax of tokens in the MODELICA language */

%%

{whitespace} ;
"algorithm" return T_ALGORITHM;
"and" return T_AND;
"annotation" return T_ANNOTATION;
"block" return BLOCK;
"class" return CLASS;
"connect" return CONNECT;
"connector" return CONNECTOR;
"constant" return CONSTANT;
"discrete" return DISCRETE;
"der" return DER;
"defineunit" return DEFINEUNIT;
"each" return EACH;
"else" return ELSE;
"elseif" return ELSEIF;
"elsewhen" return ELSEWHEN;
"end" return T_END;
"enumeration" return ENUMERATION;
"equation" return EQUATION;
"encapsulated" return ENCAPSULATED;
"expandable" return EXPANDABLE;
"extends" return EXTENDS;
"constrainedby" return CONSTRAINEDBY;
"external" return EXTERNAL;
"false" return T_FALSE;
"final" return FINAL;
"flow" return FLOW;
"for" return FOR;
"function" return FUNCTION;
"if" return IF;
"import" return IMPORT;
"in" return T_IN;
"initial" return INITIAL;
"inner" return INNER;
"input" return T_INPUT;
"loop" return LOOP;
"model" return MODEL;
"not" return T_NOT;
"outer" return T_OUTER;
"operator" return OPERATOR;
"overload" return OVERLOAD;
"or" return T_OR;
"output" return T_OUTPUT;
"package" return T_PACKAGE;
"parameter" return PARAMETER;
"partial" return PARTIAL;
"protected" return PROTECTED;
"public" return PUBLIC;
"record" return RECORD;
"redeclare" return REDECLARE;
"replaceable" return REPLACEABLE;
"results" return RESULTS;
"then" return THEN;
"true" return T_TRUE;
"type" return TYPE;
"unsigned_real" return UNSIGNED_REAL;
"when" return WHEN;
"while" return WHILE;
"within" return WITHIN;
"return" return RETURN;
"break" return BREAK;

"(" return LPAR;
")" return RPAR;
"[" return LBRACK;
"]" return RBRACK;
"{" return LBRACE;
"}" return RBRACE;
"=" return EQUALS;
":=" return ASSIGN;
"," return COMMA;
":" return COLON;
";" return SEMICOLON;

"Code" return CODE;
"$Code" return CODE;
"$TypeName" return CODE_NAME;
"$Exp" return CODE_EXP;
"$Var" return CODE_VAR;

"pure" return PURE;
"impure" return IMPURE;

".+" return PLUS_EW;
".-" return MINUS_EW; 
".*" return STAR_EW;
"./" return SLASH_EW; 
".^" return POWER_EW;

"*"  return STAR;
"-"  return MINUS;
"+"  return PLUS;
"<=" return LESSEQ;
"<>"  return LESSGT;
"<"  return LESS;
">"  return GREATER;
">="  return GREATEREQ;
"==" return EQEQ;
"^" return POWER;
"/" return SLASH;

"stream" return STREAM;

"\." return DOT;

%"[\"][^\"]*[\"]"	return STRING;

{ident}      return IDENT;
{digits}     return DIGIT;

"\""	     {
		BEGIN(c_string) keepBuffer;
             }
<c_string>
{
    "\""    { BEGIN(INITIAL) return STRING; }
    [^\n]   {keepBuffer;};
    \n       {yyerror("Unterminated string in line")
              yyterminate();};
    <<EOF>>  {
         yyerror("Unterminated string");
	       yyterminate();
	     }
}

"/\*"	     {
		BEGIN(c_comment);
             }
<c_comment>
{
    "\*/"    { BEGIN(INITIAL); }
    "/\*"    { yyerror("Suspicious comment"); }
    [^\n]    ;
    \n       ;
    <<EOF>>  {
         yyerror("Unterminated comment");
	       yyterminate();
	     }
}

"//"	     {
		BEGIN(c_linecomment) keepBuffer;
             }
             
<c_linecomment>
{
    \n    { BEGIN(INITIAL); }
    [^\n]  ;
}

 

%%