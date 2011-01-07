/*
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-CurrentYear, Link�ping University,
 * Department of Computer and Information Science,
 * SE-58183 Link�ping, Sweden.
 *
 * All rights reserved.
 *
 * THIS PROGRAM IS PROVIDED UNDER THE TERMS OF GPL VERSION 3 
 * AND THIS OSMC PUBLIC LICENSE (OSMC-PL). 
 * ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES RECIPIENT'S  
 * ACCEPTANCE OF THE OSMC PUBLIC LICENSE.
 *
 * The OpenModelica software and the Open Source Modelica
 * Consortium (OSMC) Public License (OSMC-PL) are obtained
 * from Link�ping University, either from the above address,
 * from the URLs: http://www.ida.liu.se/projects/OpenModelica or  
 * http://www.openmodelica.org, and in the OpenModelica distribution. 
 * GNU version 3 is obtained from: http://www.gnu.org/copyleft/gpl.html.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without
 * even the implied warranty of  MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE, EXCEPT AS EXPRESSLY SET FORTH
 * IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE CONDITIONS
 * OF OSMC-PL.
 *
 * See the full OSMC Public License conditions for more details.
 *
 */

/* File: simulation_runtime.h
 *
 * Description: This file is a C++ header file for the simulation runtime.
 * It contains solver functions and other simulation runtime specific functions
 */

#ifndef _SIMULATION_EVENTS_H
#define _SIMULATION_EVENTS_H

#include "integer_array.h"
#include "boolean_array.h"
#include "fortran_types.h"

int initializeEventData();
void deinitializeEventData();

int checkForDiscreteVarChanges();
void calcEnabledZeroCrossings();
void CheckForNewEvents(double *t);
void CheckForInitialEvents(double *t);
void checkForInitialZeroCrossings(fortran_integer* jroot);
void StartEventIteration(double *t);
void StateEventHandler(fortran_integer jroot[], double *t);
void AddEvent(long);

void saveall();

void save(double & var);
void save(modelica_integer & var);
void save(modelica_boolean & var);
void save(const char* & var);

double pre(double & var);
modelica_integer pre(modelica_integer & var);
signed char pre(signed char & var);
const char* pre(const char* & var);

bool edge(double& var);
bool edge(modelica_integer& var);
bool edge(modelica_boolean& var);

bool change(double& var);
bool change(modelica_integer& var);
bool change(modelica_boolean& var);
bool change(const char*& var);

double Sample(double t, double start ,double interval);
double sample(double start ,double interval, int hindex);
void initSample(double start,double stop);

double Less(double a,double b);
double LessEq(double a,double b);
double Greater(double a,double b);
double GreaterEq(double a,double b);

void checkTermination();
int checkForSampleEvent();

extern long inUpdate;
extern int euler_in_use;
const int IterationMax = 200;

#define ZEROCROSSING(ind,exp) { \
  if (euler_in_use){ \
  	gout[ind] = exp; \
  } \
  else {\
  	gout[ind] = (zeroCrossingEnabled[ind])?double(zeroCrossingEnabled[ind])*exp:1.0; \
  } \
}

#define RELATION(res,x,y,op1,op2)  { \
  if (euler_in_use){ \
  	res = (x) op1 (y); \
  } \
  else { \
  	double res1,res2,*statesBackup,*statesDerivativesBackup,*algebraicsBackup,timeBackup;\
  	modelica_integer* algebraicsIntBackup; \
  	modelica_boolean* algebraicsBoolBackup; \
  	if (!inUpdate) { \
  		res = (x) op1 (y); \
  	}\
  	else {\
  		res = (x) op2 (y); \
  		if (!res && ((x) op2##= (y))) { \
  			timeBackup = localData->timeValue;\
  			localData->timeValue = localData->oldTime;\
  			statesBackup = localData->states; \
  			localData->states = localData->states_old; \
  			statesDerivativesBackup = localData->statesDerivatives; \
  			localData->statesDerivatives = localData->statesDerivatives_old; \
  			algebraicsBackup = localData->algebraics; \
  			localData->algebraics = localData->algebraics_old; \
  			algebraicsIntBackup = localData->intVariables.algebraics; \
  			localData->intVariables.algebraics = localData->intVariables.algebraics_old; \
  			algebraicsBoolBackup = localData->boolVariables.algebraics; \
  			localData->boolVariables.algebraics = localData->boolVariables.algebraics_old; \
  			res1 = (x)-(y);\
  			localData->timeValue = localData->oldTime2;\
  			localData->states = localData->states_old2; \
  			localData->statesDerivatives = localData->statesDerivatives_old2; \
  			localData->algebraics = localData->algebraics_old2; \
  			localData->intVariables.algebraics = localData->intVariables.algebraics_old2; \
  			localData->boolVariables.algebraics = localData->boolVariables.algebraics_old2; \
  			res2 = (x)-(y);\
  			localData->timeValue = timeBackup;\
  			localData->states = statesBackup; \
  			localData->statesDerivatives = statesDerivativesBackup; \
  			localData->algebraics = algebraicsBackup; \
  			localData->intVariables.algebraics = algebraicsIntBackup; \
  			localData->boolVariables.algebraics = algebraicsBoolBackup; \
  			res = res1 op2##= res2; \
  		}\
  	}\
  } \
}

#define RELATIONGREATER(res,x,y)    RELATION(res,x,y,>,>)
#define RELATIONLESS(res,x,y)       RELATION(res,x,y,<,<)
#define RELATIONGREATEREQ(res,x,y)  RELATION(res,x,y,>=,>)
#define RELATIONLESSEQ(res,x,y)     RELATION(res,x,y,<=,<)

#define initial() localData->init

int
function_zeroCrossing(fortran_integer *neqm, double *t, double *x, fortran_integer *ng, double *gout, double *rpar, fortran_integer* ipar);

int
handleZeroCrossing(long index);

int
function_when(int i);

extern long* zeroCrossingEnabled;

int
function_onlyZeroCrossings(double* gout ,double* t);

int CheckForNewEvent(int *sampleactived);

int EventHandle(int);

void FindRoot(double*);

int checkForDiscreteChanges();

void SaveZeroCrossings();

void activateSampleEvents();

double BiSection(double*, double*, double*, double*, long int*);

int CheckZeroCrossings(long int*);

int function_updateSample();

#define INTERVAL 1
#define NOINTERVAL 0

extern double TOL;

void debugPrintHelpVars();
void deactivateSampleEvent();
void deactivateSampleEventsandEquations();
void debugSampleEvents();

#endif
