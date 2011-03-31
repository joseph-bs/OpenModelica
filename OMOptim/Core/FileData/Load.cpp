﻿// $Id$
/**
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-CurrentYear, Open Source Modelica Consortium (OSMC),
 * c/o Linköpings universitet, Department of Computer and Information Science,
 * SE-58183 Linköping, Sweden.
 *
 * All rights reserved.
 *
 * THIS PROGRAM IS PROVIDED UNDER THE TERMS OF GPL VERSION 3 LICENSE OR 
 * THIS OSMC PUBLIC LICENSE (OSMC-PL). 
 * ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES RECIPIENT'S ACCEPTANCE
 * OF THE OSMC PUBLIC LICENSE OR THE GPL VERSION 3, ACCORDING TO RECIPIENTS CHOICE. 
 *
 * The OpenModelica software and the Open Source Modelica
 * Consortium (OSMC) Public License (OSMC-PL) are obtained
 * from OSMC, either from the above address,
 * from the URLs: http://www.ida.liu.se/projects/OpenModelica or  
 * http://www.openmodelica.org, and in the OpenModelica distribution. 
 * GNU version 3 is obtained from: http://www.gnu.org/copyleft/gpl.html.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without
 * even the implied warranty of  MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE, EXCEPT AS EXPRESSLY SET FORTH
 * IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE CONDITIONS OF OSMC-PL.
 *
 * See the full OSMC Public License conditions for more details.
 *
 * Main contributor 2010, Hubert Thierot, CEP - ARMINES (France)
 * Main contributor 2010, Hubert Thierot, CEP - ARMINES (France)

 	@file Load.cpp
 	@brief Comments for file documentation.
 	@author Hubert Thieriot, hubert.thieriot@mines-paristech.fr
 	Company : CEP - ARMINES (France)
 	http://www-cep.ensmp.fr/english/
 	@version 0.9 

  */
#include "Load.h"

Load::Load(void)
{
}

Load::~Load(void)
{
}

bool Load::loadProject(QString filePath,Project* _project)
{

	infoSender.send(Info(ListInfo::LOADINGPROJECT,filePath));
	_project->clear();
	_project->setFilePath(filePath);
	QDir projectDir(_project->folder());

	QString tmpPath;
	
	// Open and read file
	QDomDocument doc( "MOProjectXML" );
	QFile file(filePath);
	if( !file.open( QIODevice::ReadOnly ) )
	{
		infoSender.send( Info(ListInfo::PROJECTFILENOTEXISTS,filePath));
		return false;
	}
	if( !doc.setContent( &file ) )
	{
		file.close();
		infoSender.send( Info(ListInfo::PROJECTFILECORRUPTED,filePath));
		return false;
	}
	file.close();
	QDomElement root = doc.documentElement();
	if( root.tagName() != "MOProject" )
	{
		infoSender.send( Info(ListInfo::PROJECTFILECORRUPTED,filePath));
		return false;
	}

	//**************************************
	// Reading XML file
	//**************************************
	// name
	QDomElement domBasic = root.firstChildElement("Basic");
	_project->setName(domBasic.attribute("name", "" ));

	// Mo files
	QStringList modelMoFilePaths;
	QDomElement domMoFiles = root.firstChildElement("MoFiles");
	QDomNodeList listMoFiles = domMoFiles.elementsByTagName("MoFile");
	for(int i=0;i<listMoFiles.size();i++)
	{
		tmpPath = listMoFiles.at(i).toElement().attribute("path", "" );
		QFileInfo modelFileInfo(tmpPath);
		if(!modelFileInfo.exists())
		{
			modelFileInfo=QFileInfo(projectDir,tmpPath); //stored in relative path
			tmpPath = modelFileInfo.canonicalFilePath();
		}
		modelMoFilePaths.push_back(tmpPath);
	}

	// Mmo files
	QStringList modelMmoFilePaths;
	QDomElement domMmoFiles = root.firstChildElement("MmoFiles");
	QDomNodeList listMmoFiles = domMmoFiles.elementsByTagName("MmoFile");
	for(int i=0;i<listMmoFiles.size();i++)
	{
		tmpPath = listMmoFiles.at(i).toElement().attribute("path", "" );
		QFileInfo modelFileInfo(projectDir,tmpPath);
		tmpPath = modelFileInfo.canonicalFilePath();
		modelMmoFilePaths.push_back(tmpPath);
	}

	// Problems to load
	QStringList problemsPaths;
	QDomElement domProblems = root.firstChildElement("Problems");
	QDomNodeList listProblems = domProblems.elementsByTagName("Problem");
	for(int i=0;i<listProblems.size();i++)
	{
		tmpPath = listProblems.at(i).toElement().attribute("path", "" );
		QFileInfo problemFileInfo(projectDir,tmpPath);
		problemsPaths.push_back(problemFileInfo.canonicalFilePath());
	}

	// Solved Problems to load
	QStringList solvedProblemsPaths;
	QDomElement domSolvedProblems = root.firstChildElement("SolvedProblems");
	QDomNodeList listSolvedProblems = domSolvedProblems.elementsByTagName("SolvedProblem");
	for(int i=0;i<listSolvedProblems.size();i++)
	{
		tmpPath = listSolvedProblems.at(i).toElement().attribute("path", "" );
		QFileInfo solvedFileInfo(projectDir,tmpPath);
		solvedProblemsPaths.push_back(solvedFileInfo.canonicalFilePath());
	}
			

	//**************************************
	// Reading Mo Files
	//**************************************
	QSettings settings("MO", "Settings");


	for(int i=0;i<modelMoFilePaths.size();i++)
	{
		QFileInfo fileinfo = QFileInfo(modelMoFilePaths.at(i));
		if (!fileinfo.exists())
			infoSender.send(Info(ListInfo::MODELFILENOTEXISTS,modelMoFilePaths.at(i)));
	}
	_project->loadMoFiles(modelMoFilePaths);

	//**************************************
	// Reading Mmo Files
	//**************************************
	for(int i=0;i<modelMmoFilePaths.size();i++)
	{
		QFileInfo fileinfo = QFileInfo(modelMmoFilePaths.at(i));
		if (!fileinfo.exists())
			infoSender.send(Info(ListInfo::MODELFILENOTEXISTS,modelMmoFilePaths.at(i)));
		else
			_project->loadModModelPlus(modelMmoFilePaths.at(i));
	}

	//**************************************
	// Reading Problems
	//**************************************
	for(int i=0;i<problemsPaths.size();i++)
		_project->addProblem(problemsPaths.at(i));

	//**************************************
	// Reading Solved Problems
	//**************************************
	for(int i=0;i<solvedProblemsPaths.size();i++)
		_project->addSolvedProblem(solvedProblemsPaths.at(i));

	_project->setIsDefined(true);

	return true;
}
//Result* Load::newResultFromFile(QString filePath,Project* _project)
//{
//	QDomDocument doc( "MOResult" );
//	QFile file(filePath);
//	if( !file.open( QIODevice::ReadOnly ) )
//	{
//		infoSender.send( Info(ListInfo::RESULTFILENOTEXISTS,filePath));
//		return NULL;
//	}
//
//	QString erreur;
//	if( !doc.setContent( &file,false,&erreur ) )
//	{
//		file.close();
//		infoSender.send( Info(ListInfo::RESULTFILECORRUPTED,filePath));
//		return NULL;
//	}
//	file.close();
//
//	QDomElement root = doc.documentElement();
//	QString resultType = root.tagName();
//
//
//
//
//	if (resultType=="OneSimulationResult")
//	{
//		return newOneSimResultFromFile(filePath,_project);
//	}
//	else
//	{
//		if (resultType=="OptimResult")
//		{
//			return newOptimResultFromFile(filePath,_project);
//		}
//		else
//		{
//			return NULL;
//		}
//	}
//}
//
//Result* Load::newOneSimResultFromFile(QString filePath, Project* _project)
//{
//	OneSimResult * result = new OneSimResult();
//	result->setSavePath(filePath);
//	result->setModel(_project->getModel());
//	result->setProject(_project);
//
//	QDomDocument doc( "MOResult" );
//	QFile file(filePath);
//	if( !file.open( QIODevice::ReadOnly ) )
//	{
//		infoSender.send( Info(ListInfo::RESULTFILENOTEXISTS,filePath));
//		return NULL;
//	}
//
//	if( !doc.setContent( &file ) )
//	{
//		file.close();
//		infoSender.send( Info(ListInfo::RESULTFILECORRUPTED,filePath));
//		return NULL;
//	}
//	file.close();
//
//	QDomElement root = doc.documentElement();
//
//	QDomNode n = root.firstChild();
//	while( !n.isNull() )
//	{
//		QDomElement e = n.toElement();
//		if( !e.isNull() )
//		{
//			if( e.tagName() == "Result" )
//			{
//				result->setName(e.attribute("name", "" ));
//			}
//			if( e.tagName() == "InputVariables" )
//			{
//				QString varsString = e.text();
//				CSV::LinesToVariables(result->inputVariables,varsString);
//			}
//
//			if( e.tagName() == "FinalVariables" )
//			{
//				QString varsString = e.text();
//				CSV::LinesToVariables(result->finalVariables,varsString);
//			}
//		}
//		n = n.nextSibling();
//	}
//
//	//cloning eiStreams in results
//	result->eiStreams->cloneFromOtherVector(_project->getModel()->eiStreams);
//	result->updateEiStreams();
//
//	return result;
//}
//
//
//
////Result* Load::newOptimResultFromFile(QString filePath,Project* _project)
////{
////	OptimResult * result = new OptimResult();
////	result->setSavePath(filePath);
////	result->setModel(_project->getModel());
////	result->setProject(_project);
////
////	QDomDocument doc( "MOResult" );
////	QFile file(filePath);
////	if( !file.open( QIODevice::ReadOnly ) )
////	{
////		infoSender.send( Info(ListInfo::RESULTFILENOTEXISTS,filePath));
////		return NULL;
////	}
////
////	if( !doc.setContent( &file ) )
////	{
////		file.close();
////		infoSender.send( Info(ListInfo::RESULTFILECORRUPTED,filePath));
////		return NULL;
////	}
////	file.close();
////
////	QDomElement root = doc.documentElement();
////
////	QDomNode n = root.firstChild();
////	while( !n.isNull() )
////	{
////		QDomElement e = n.toElement();
////		if( !e.isNull() )
////		{
////			if( e.tagName() == "Result" )
////			{
////				result->setName(e.attribute("name", "" ));
////			}
////			if( e.tagName() == "OptObjectives" )
////			{
////				QString varsString = e.text();
////				CSV::LinesToOptObjectives(result->optObjectivesResults(),varsString);
////			}
////
////			if( e.tagName() == "OptVariables" )
////			{
////				QString varsString = e.text();
////				CSV::LinesToOptVariables(result->optVariablesResults,varsString);
////			}
////
////
////			if( e.tagName() == "AlgoParameters" )
////			{
////				QString paramString = e.text();
////				result->eaConfig->parameters = new MOVector<AlgoParameter>(paramString);
////			}
////
////
////			
////			if( e.tagName() == "FrontFile" )
////			{
////				result->frontFileName = e.attribute("path","");
////			}
////
////
////		}
////		n = n.nextSibling();
////	}
////
////	// Filling and Sizing recomputed variables (without values)
////	for (int i=0;i<	_project->getModel()->variables->items.size();i++)
////	{
////		result->recomputedVariables()->addItem(new VariableResult(_project->getModel()->variables->items.at(i)));
////		//result->recomputedVariables()->items.at(i)->finalValues.resize(nbPoints);
////	}
////
////	// Filling final values from frontFile (csv)
////	QFileInfo tempInfo = QFileInfo(result->getSavePath());
////	QString folder = tempInfo.absoluteDir().absolutePath();
////	QString frontFilePath = folder + QDir::separator() + result->frontFileName;
////	loadOptimValuesFromFrontFile(result,frontFilePath);
////
////
////
////	// Looking for recomputed points
////	result->updateRecPointsFromFolder();
////	
////
////	return result;
////}

Problem* Load::newSolvedProblemFromFile(QString filePath,Project* _project)
{
	Problem* newProblem = NULL;
	QString error;

	QDomDocument doc( "MOSolvedProblem" );
	QFile file(filePath);
	if( !file.open( QIODevice::ReadOnly ) )
	{
		infoSender.send( Info(ListInfo::PROBLEMFILENOTEXISTS,filePath));
		return NULL;
	}
	else if( !doc.setContent(&file,&error) )
	{
		file.close();
		infoSender.send( Info(ListInfo::PROBLEMFILECORRUPTED,error,filePath));
		return NULL;
	}
	file.close();

	QDomElement root = doc.documentElement();
	QString problemType = root.tagName();

	if (problemType=="OneSimulation")
		newProblem = newOneSimulationSolvedFromFile(filePath,_project);
	if (problemType=="Optimization")
		newProblem = newOptimizationSolvedFromFile(filePath,_project);

#ifdef USEEI
	if (problemType=="ProblemTarget")
		newProblem = newProblemTargetSolvedFromFile(filePath,_project);
#endif

	if(newProblem != NULL)
	{
		newProblem->setProject(_project);
	}

	return newProblem;
}

Problem* Load::newProblemFromFile(QString filePath,Project* _project)
{
	Problem* newProblem = NULL;
	QString error;

	QDomDocument doc( "MOProblem" );
	QFile file(filePath);
	if( !file.open( QIODevice::ReadOnly ) )
	{
		infoSender.send( Info(ListInfo::PROBLEMFILENOTEXISTS,filePath));
		return NULL;
	}
	else if( !doc.setContent(&file,&error) )
	{
		file.close();
		infoSender.send( Info(ListInfo::PROBLEMFILECORRUPTED,error,filePath));
		return NULL;
	}
	file.close();

	QDomElement root = doc.documentElement();
	QString problemType = root.tagName();

	if (problemType=="OneSimulation")
		newProblem = newOneSimulationFromFile(filePath,_project);

	if (problemType=="Optimization")
		newProblem = newOptimizationFromFile(filePath,_project);

#ifdef USEEI
	if (problemType=="ProblemTarget")
		newProblem = newProblemTargetFromFile(filePath,_project);
#endif

	if(newProblem != NULL)
	{
		newProblem->setProject(_project);
		newProblem->setEntireSavePath(filePath);
	}

	return newProblem;
}







Problem* Load::newOneSimulationFromFile(QString filePath,Project* _project)
{

	//Open file
	QDomDocument doc( "MOProblem" );
	QFile file(filePath);
	if( !file.open( QIODevice::ReadOnly ) )
	{
		infoSender.send( Info(ListInfo::PROBLEMFILENOTEXISTS,filePath));
		return NULL;
	}
	if( !doc.setContent( &file ) )
	{
		file.close();
		infoSender.send( Info(ListInfo::PROBLEMFILENOTEXISTS,filePath));
		return NULL;
	}
	file.close();

	// Read model
	QDomElement domProblem = doc.firstChildElement("OneSimulation");
	QDomElement domInfos = domProblem.firstChildElement("Infos");
	QString modelName = domInfos.attribute("model");

	// Find model
	ModModel* _modModel = _project->findModModel(modelName);
	if(_modModel == NULL)
	{
		return NULL;
	}

	ModModelPlus* _modModelPlus = _project->modModelPlus(_modModel);
	OneSimulation* problem= new OneSimulation(_project,_project->rootModClass(),
		_project->modReader(),_project->modPlusCtrl(),_modModelPlus);

	// Infos
	problem->setType((Problem::ProblemType)domInfos.attribute("type", "" ).toInt());
	problem->setName(domInfos.attribute("name", "" ));

	// Scanned Variables
	QDomElement domScanVars = domProblem.firstChildElement("ScannedVariables");
	problem->scannedVariables()->setItems(domScanVars);

	// Overwrited Variables
	QDomElement domOverVars = domProblem.firstChildElement("OverwritedVariables");
	problem->overwritedVariables()->setItems(domOverVars);

	// addOverWritedCVariables
	// make their value editable
	for(int iV=0;iV<problem->overwritedVariables()->items.size();iV++)
		problem->overwritedVariables()->items.at(iV)->setIsEditableField(Variable::VALUE,true);

	return problem;
}

Problem* Load::newOneSimulationSolvedFromFile(QString filePath,Project* _project)
{

	//Open file
	QDomDocument doc( "MOSolvedProblem" );
	QFileInfo fileInfo(filePath);
	QFile file(filePath);
	if( !file.open( QIODevice::ReadOnly ) )
	{
		infoSender.send( Info(ListInfo::PROBLEMFILENOTEXISTS,filePath));
		return NULL;
	}
	if( !doc.setContent( &file ) )
	{
		file.close();
		infoSender.send( Info(ListInfo::PROBLEMFILENOTEXISTS,filePath));
		return NULL;
	}
	file.close();

	// Read model
	QDomElement domProblem = doc.firstChildElement("OneSimulation");
	QDomElement domInfos = domProblem.firstChildElement("Infos");
	QString modelName = domInfos.attribute("model");

	// Find model
	ModModel* _modModel = _project->findModModel(modelName);
	if(_modModel == NULL)
	{
		return NULL;
	}

	ModModelPlus* _modModelPlus = _project->modModelPlus(_modModel);
	OneSimulation* problem= new OneSimulation(_project,_project->rootModClass(),
	_project->modReader(),_project->modPlusCtrl(),_modModelPlus);

	OneSimResult *result = new OneSimResult(_project,_modModelPlus,problem,_project->modReader(),_project->modPlusCtrl());
	problem->setResult(result);

	problem->setEntireSavePath(filePath);

	// Infos
	problem->setType((Problem::ProblemType)domInfos.attribute("type", "" ).toInt());
	problem->setName(domInfos.attribute("name", "" ));

	// Overwrited Variables
	QDomElement domOverVars = domProblem.firstChildElement("OverwritedVariables");
	problem->overwritedVariables()->setItems(domOverVars);

	// Scanned Variables
	QDomElement domScanVars = domProblem.firstChildElement("ScannedVariables");
	problem->scannedVariables()->setItems(domScanVars);

	//**********
	// Result
	//**********
	QDomElement domResult = domProblem.firstChildElement("Result");

	//Infos
	QDomElement domResInfos = domResult.firstChildElement("Infos");
	result->setName(domResInfos.attribute("name", "" ));

	//FinalVariables
	QDomElement domFinalVars = domResult.firstChildElement("FinalVariables");
	result->finalVariables()->setItems(domFinalVars);



	//eventually load variables from dsin and dsres
	//if(result->inputVariables->items.size() == 0)
	//{
	//	QFileInfo dsinInfo = QFileInfo(fileInfo.absoluteDir(),"dsin.txt");
	//	if(dsinInfo.exists())
	//		Dymola::getVariablesFromDsFile(dsinInfo.absoluteFilePath(), result->inputVariables,modelName);
	//}
	//if(result->finalVariables->items.size() == 0)
	//{
	//	QFileInfo dsresInfo = QFileInfo(fileInfo.absoluteDir(),"dsres.txt");
	//	if(dsresInfo.exists())
	//	{
	//		MOVector<Variable> curVariables;
	//		Dymola::getFinalVariablesFromDsFile(dsresInfo.absoluteFilePath(),curVariables,modelName);
	//		
	//	}
	//}

	//cloning eiStreams in results
	//	result->eiStreams->cloneFromOtherTableEIStreams(_project->getModel()->getTableEIStreams());
//	result->updateEiStreams();

	return problem;
}





Problem* Load::newOptimizationFromFile(QString filePath,Project* project)
{
	//Open file
	QDomDocument doc( "MOProblem" );
	QFileInfo fileInfo(filePath);
	QFile file(filePath);
	if( !file.open( QIODevice::ReadOnly ) )
	{
		infoSender.send( Info(ListInfo::PROBLEMFILENOTEXISTS,filePath));
		return NULL;
	}
	if( !doc.setContent( &file ) )
	{
		file.close();
		infoSender.send( Info(ListInfo::PROBLEMFILENOTEXISTS,filePath));
		return NULL;
	}
	file.close();

	// Read model
	QDomElement domProblem = doc.firstChildElement("Optimization");
	QDomElement domInfos = domProblem.firstChildElement("Infos");
	QString modelName = domInfos.attribute("model");
	QString problemName = domInfos.attribute("name");

	// Find model
	ModModel* _modModel = project->findModModel(modelName);
	if(_modModel == NULL)
	{
		infoSender.send( Info(ListInfo::PROBLEMMODELNOTFOUND,modelName,problemName));
		return NULL;
	}

	// Create problem
	ModModelPlus* _modModelPlus = project->modModelPlus(_modModel);
	Optimization* problem= new Optimization(project,project->rootModClass(),
		project->modReader(),project->modPlusCtrl(),_modModelPlus);

	problem->setEntireSavePath(filePath);


	// Infos
	problem->setType((Problem::ProblemType)domInfos.attribute("type", "" ).toInt());
	problem->setName(problemName);

	// Optimized Variables
	QDomElement domOptVars = domProblem.firstChildElement("OptimizedVariables");
	problem->optimizedVariables()->setItems(domOptVars);

	// Objectives
	QDomElement domObj = domProblem.firstChildElement("Objectives");
	problem->objectives()->setItems(domObj);

	// Scanned Variables
	QDomElement domScann = domProblem.firstChildElement("ScannedVariables");
	problem->scannedVariables()->setItems(domScann);


	// BlockSubstitutions
	QDomElement domBlockSubs = domProblem.firstChildElement("BlockSubstitutions");
	problem->setBlockSubstitutions(new BlockSubstitutions(project,_modModelPlus,domBlockSubs,project->rootModClass(),project->modReader()));

	// EA
	QDomElement domEA = domProblem.firstChildElement("EA");
	QDomElement domEAInfos = domEA.firstChildElement("Infos");
	if(!domEAInfos.isNull())
	{
		problem->setiCurAlgo(domEAInfos.attribute("num", "" ).toInt());		
	}
	QDomElement domEAParameters = domEA.firstChildElement("Parameters");
	if(!domEAParameters.isNull())
	{
		problem->getCurAlgo()->_config->parameters->update(domEAParameters);
	}

	return problem;
}

#ifdef USEEI
Problem* Load::newProblemTargetFromFile(QString filePath,Project* project)
{
	//Open file
	QDomDocument doc( "MOProblem" );
	QFileInfo fileInfo(filePath);
	QFile file(filePath);
	if( !file.open( QIODevice::ReadOnly ) )
	{
		infoSender.send( Info(ListInfo::PROBLEMFILENOTEXISTS,filePath));
		return NULL;
	}
	if( !doc.setContent( &file ) )
	{
		file.close();
		infoSender.send( Info(ListInfo::PROBLEMFILENOTEXISTS,filePath));
		return NULL;
	}
	file.close();

	// Read model
	QDomElement domProblem = doc.firstChildElement("ProblemTarget");
	QDomElement domInfos = domProblem.firstChildElement("Infos");
	QString problemName = domInfos.attribute("name");

	ProblemTarget* problem= new ProblemTarget(project,project->eiReader());
	problem->setEntireSavePath(filePath);

	// Infos
	problem->setType((Problem::ProblemType)domInfos.attribute("type", "" ).toInt());
	problem->setName(problemName);

	// EI
	QDomElement domEI = domProblem.firstChildElement("EIItem");
	project->eiReader()->setItems(domEI,problem->rootEI);

	// InputVars
	QDomElement domInputVars = domProblem.firstChildElement("InputVars");
	problem->inputVars()->setItems(domInputVars);

	return problem;
}

Problem* Load::newProblemTargetSolvedFromFile(QString filePath,Project* project)
{
	//Open file
	QDomDocument doc( "MOSolvedProblem" );
	QFileInfo fileInfo(filePath);
	QFile file(filePath);
	if( !file.open( QIODevice::ReadOnly ) )
	{
		infoSender.send( Info(ListInfo::PROBLEMFILENOTEXISTS,filePath));
		return NULL;
	}
	if( !doc.setContent( &file ) )
	{
		file.close();
		infoSender.send( Info(ListInfo::PROBLEMFILENOTEXISTS,filePath));
		return NULL;
	}
	file.close();

	// Read model
	QDomElement domProblem = doc.firstChildElement("ProblemTarget");
	QDomElement domInfos = domProblem.firstChildElement("Infos");
	QString problemName = domInfos.attribute("name");
		
	ProblemTarget* problem= new ProblemTarget(project,project->eiReader());
	problem->setEntireSavePath(filePath);

	// Infos
	problem->setType((Problem::ProblemType)domInfos.attribute("type", "" ).toInt());
	problem->setName(problemName);

	// EI
	QDomElement domEI = domProblem.firstChildElement("EIItem");
	project->eiReader()->setItems(domEI,problem->rootEI);

	// InputVars
	QDomElement domInputVars = domProblem.firstChildElement("InputVars");
	problem->inputVars()->setItems(domInputVars);

	//**************
	// Result
	//**************
	EITargetResult* result = new EITargetResult(project,problem);
	problem->setResult(result);
	result->setSuccess(true);
	
	return problem;
}

#endif

//Problem* Load::newVariableDetFromFile(QString filePath,Project* project)
//{
//	VariableDet* problem= new VariableDet(project,project->getModel());
//	problem->setEntireSavePath(filePath);
//
//	QDomDocument doc( "MOProblem" );
//	QFile file(filePath);
//	if( !file.open( QIODevice::ReadOnly ) )
//	{
//		//infoSender.send( Info(ListInfo::PROBLEMFILENOTEXISTS,filePath));
//		return NULL;
//	}
//
//
//	if( !doc.setContent( &file ) )
//	{
//		file.close();
//		//infoSender.send( Info(ListInfo::PROBLEMFILENOTEXISTS,filePath));
//		return NULL;
//	}
//	file.close();
//
//	QDomElement root = doc.documentElement();
//	QDomNode n1 = root.firstChild();
//	while( !n1.isNull() )
//	{
//		QDomElement e1 = n1.toElement();
//		if( !e1.isNull() )
//		{
//			//**********
//			// Problem
//			//**********
//			if( e1.tagName() == "Problem" )
//			{
//				QDomNode n2 = n1.firstChild();
//				
//				while( !n2.isNull() )
//				{
//					QDomElement e2 = n2.toElement();
//				
//					if( e2.tagName() == "Infos" )
//					{
//						problem->setName(e2.attribute("name", "" ));
//						problem->setType(e2.attribute("type", "" ).toInt());
//					}
//
//					if( e2.tagName() == "FuzzyVariables" )
//					{
//						QString varsString = e2.text();
//						CSV::linesToFuzzyVarsTable(project->getModel(),problem->fuzzyVars,varsString);
//					}
//				
//					if( e2.tagName() == "EA" )
//					{
//						QDomElement e3 = e2.firstChildElement();
//
//						while( !e3.isNull() )
//						{
//							qDebug(e3.tagName().toLatin1().data());
//
//							if( e3.tagName() == "Infos" )
//							{
//							problem->setiCurAlgo(e3.attribute("num", "" ).toInt());
//							}
//							if( e3.tagName() == "Parameters")
//							{
//								if(problem->getCurAlgo())
//								{
//									QString paramString = e3.text();
//									problem->getCurAlgo()->config->parameters = new MOVector<AlgoParameter>(paramString);
//								}
//							}
//							e3 = e3.nextSiblingElement();
//						}
//					}
//					n2 = n2.nextSibling();
//				}
//			}
//		}
//		n1 = n1.nextSibling();
//	}
//	return problem;
//}











Problem* Load::newOptimizationSolvedFromFile(QString filePath,Project* project)
{
	
	//Open file
	QDomDocument doc( "MOSolvedProblem" );
	QFileInfo fileInfo(filePath);
	QFile file(filePath);
	if( !file.open( QIODevice::ReadOnly ) )
	{
		infoSender.send( Info(ListInfo::PROBLEMFILENOTEXISTS,filePath));
		return NULL;
	}
	if( !doc.setContent( &file ) )
	{
		file.close();
		infoSender.send( Info(ListInfo::PROBLEMFILENOTEXISTS,filePath));
		return NULL;
	}
	file.close();

	// Read model
	QDomElement domProblem = doc.firstChildElement("Optimization");
	QDomElement domInfos = domProblem.firstChildElement("Infos");
	QString modelName = domInfos.attribute("model");
	QString problemName = domInfos.attribute("name");

	// Find model
	ModModel* _modModel = project->findModModel(modelName);
	if(_modModel == NULL)
	{
		infoSender.send( Info(ListInfo::PROBLEMMODELNOTFOUND,modelName,problemName));
		return NULL;
	}

	// Create problem
	ModModelPlus* _modModelPlus = project->modModelPlus(_modModel);
	Optimization* problem= new Optimization(project,project->rootModClass(),
		project->modReader(),project->modPlusCtrl(),_modModelPlus);

	OptimResult* result = new OptimResult(project,_modModelPlus,problem,project->modReader(),project->modPlusCtrl());
	problem->setResult(result);
	result->setSuccess(true);
	problem->setEntireSavePath(filePath);


	// Infos
	problem->setType((Problem::ProblemType)domInfos.attribute("type", "" ).toInt());
	problem->setName(problemName);

	// Optimized Variables
	QDomElement domOptVars = domProblem.firstChildElement("OptimizedVariables");
	problem->optimizedVariables()->setItems(domOptVars);

	// Objectives
	QDomElement domObj = domProblem.firstChildElement("Objectives");
	problem->objectives()->setItems(domObj);

	// Scanned Variables
	QDomElement domScann = domProblem.firstChildElement("ScannedVariables");
	problem->scannedVariables()->setItems(domScann);


	// BlockSubstitutions
	QDomElement domBlockSubs = domProblem.firstChildElement("BlockSubstitutions");
	problem->setBlockSubstitutions(new BlockSubstitutions(project,_modModelPlus,domBlockSubs,project->rootModClass(),project->modReader()));

	// EA
	QDomElement domEA = domProblem.firstChildElement("EA");
	QDomElement domEAInfos = domEA.firstChildElement("Infos");
	if(!domEAInfos.isNull())
	{
		problem->setiCurAlgo(domEAInfos.attribute("num", "" ).toInt());		
	}
	QDomElement domEAParameters = domEA.firstChildElement("Parameters");
	if(!domEAParameters.isNull())
	{
		problem->getCurAlgo()->_config->parameters->update(domEAParameters);
	}



	//**********
	// Result
	//**********
	// OptVarResult from optVar, OptObjResult from OptObj...
	result->optVariablesResults()->clear();
	for(int i=0;i<problem->optimizedVariables()->items.size();i++)
	{
		result->optVariablesResults()->addItem(new VariableResult(*problem->optimizedVariables()->items.at(i)));
	}

	result->optObjectivesResults()->clear();
	for(int i=0;i<problem->objectives()->items.size();i++)
	{
		result->optObjectivesResults()->addItem(new VariableResult(*problem->objectives()->items.at(i)));
	}
	
	
	QDomElement domResult = domProblem.firstChildElement("Result");
	if(!domResult.isNull())
	{
		//Infos
		QDomElement domResInfos = domResult.firstChildElement("Infos");
		result->setName(domResInfos.attribute("name", "" ));

		// Blocksubs
		QDomElement domBlocks = domResult.firstChildElement("AllBlockSubstitutions");
		QDomElement domBlock = domBlocks.firstChildElement();
		QRegExp regExp("BlockSubstitutions[\\d]+");

		while(!domBlock.isNull())
		{
			if(regExp.exactMatch(domBlock.tagName()))
			{
				QString number = domBlock.tagName();
				number.remove(QRegExp("[\\D]*"));
				domBlock.setTagName("BlockSubstitutions");

				result->_subBlocks.push_back(new BlockSubstitutions(project,_modModelPlus,domBlock,project->rootModClass(),project->modReader()));
			}
			domBlock = domBlock.nextSiblingElement();
		}

		// Filling and Sizing recomputed variables (without values)
		if(_modModelPlus->variables()->items.isEmpty())
			_modModelPlus->readVariables();

		for (int i=0;i<	_modModelPlus->variables()->items.size();i++)
		{
			result->recomputedVariables()->addItem(new VariableResult(*_modModelPlus->variables()->items.at(i)));
		}

		// Filling final values from frontFile (csv)
		QDir dir = fileInfo.absoluteDir();
		QFileInfo frontFileInfo(dir,result->_optVarsFrontFileName);
		if(frontFileInfo.exists())
			loadOptimValuesFromFrontFile(result,frontFileInfo.absoluteFilePath());

		// Filling recomputed values from folder point_ (csv)
                result->updateRecomputedPointsFromFolder();

	}
        return problem;
}






void Load::loadOptimValuesFromFrontFile(OptimResult* _result,QString fileName)
{
	QFile frontFile(fileName);
	if(!frontFile.exists())
	{
		return;
	}
	frontFile.open(QIODevice::ReadOnly);
	QTextStream tsfront( &frontFile );
	QString text = tsfront.readAll();
	frontFile.close();

	// Clearing previous values
	for (int i=0; i<_result->optObjectivesResults()->items.size(); i++)
	{
		_result->optObjectivesResults()->items.at(i)->clearFinalValues();
	}
	for (int i=0; i<_result->optVariablesResults()->items.size(); i++)
	{
		_result->optVariablesResults()->items.at(i)->clearFinalValues();
	}
	for (int i=0; i<_result->recomputedVariables()->items.size(); i++)
	{
		_result->recomputedVariables()->items.at(i)->clearFinalValues();
	}

	QStringList lines = text.split("\n",QString::KeepEmptyParts);

	QStringList firstLine = lines[0].split("\t",QString::SkipEmptyParts);
	int nbCols = firstLine.size();

	int *objIndex = new int[nbCols];
	int *optVarIndex = new int[nbCols];
	int *recompVarIndex = new int[nbCols];

	bool useScan = (dynamic_cast<Optimization*>(_result->problem())->nbScans()>1);
	_result->recomputedVariables()->setUseScan(useScan);

	// Filling index tables
	for(int i=0; i<nbCols; i++)
	{
		objIndex[i] = _result->optObjectivesResults()->findItem(firstLine.at(i));
		optVarIndex[i] = _result->optVariablesResults()->findItem(firstLine.at(i));
		if(!useScan)
			recompVarIndex[i] = _result->recomputedVariables()->findItem(firstLine.at(i));
	}

	int iiSubBlock = firstLine.indexOf("subBlocksIndex");

	// Filling variables and objectives values
	QStringList curLine;
	int curIndex = 0; // to skip empty, partial or comment lines
	for (int iLine = 1; iLine<lines.size(); iLine++)
	{
		curLine = lines[iLine].split("\t",QString::SkipEmptyParts);

		if(curLine.size()==nbCols)
		{
			for (int iCol = 0; iCol < nbCols; iCol++)
			{
				if (objIndex[iCol]>-1)
				{
					_result->optObjectivesResults()->items.at(objIndex[iCol])->appendFinalValue(curLine[iCol].toDouble(),0);
				}
				if (optVarIndex[iCol]>-1)
				{
					_result->optVariablesResults()->items.at(optVarIndex[iCol])->appendFinalValue(curLine[iCol].toDouble(),0);
				}
				if ((recompVarIndex[iCol]>-1)&&(!useScan))
				{
					_result->recomputedVariables()->items.at(recompVarIndex[iCol])->appendFinalValue(curLine[iCol].toDouble(),0);
				}
			}

			if(iiSubBlock>-1)
				_result->_iSubModels.push_back(curLine[iiSubBlock].toInt());

			curIndex ++;
		}
	}
}





bool Load::loadModModelPlus(Project* project,QString mmoFilePath)
{
	infoSender.send( Info(ListInfo::LOADINGMODEL,mmoFilePath));

	// Open file
	QDomDocument doc( "MOModelXML" );
	QFileInfo mmoFileInfo(mmoFilePath);
	QDir mmoDir(mmoFileInfo.absolutePath());
	QFile file(mmoFilePath);
	if( !file.open( QIODevice::ReadOnly ) )
	{
		infoSender.send( Info(ListInfo::MODELFILENOTEXISTS,mmoFilePath));
		return false;
	}
	QString error;
	if( !doc.setContent( &file,&error ) )
	{
		file.close();
		infoSender.send( Info(ListInfo::MODMODELFILECORRUPTED,error,mmoFilePath));
		return false;
	}
	file.close();
	QDomElement root = doc.documentElement();
	if( root.tagName() != "MOModel" )
	{
		error = "Root tagname should be <MOModel>";
		infoSender.send( Info(ListInfo::MODMODELFILECORRUPTED,error,mmoFilePath));
		return false;
	}
	// Read file
	QDomElement domBasic = root.firstChildElement("Basic");
	QString name = domBasic.attribute("name");
	QString modelName = domBasic.attribute("modelName");
	
	// Check if model exist
	ModModel* _modModel = project->findModModel(modelName);
	if(_modModel==NULL)
		return false;
	else
	{
		ModModelPlus* newModelPlus = new ModModelPlus(project->moomc(),project,project->modReader(),
			_modModel,project->rootModClass());
		// Other files
		QDomElement domOtherFiles = root.firstChildElement("OtherFiles");
		QString allOtherFiles = domOtherFiles.attribute( "list", "" );
		newModelPlus->setOtherFiles(allOtherFiles.split(";"));			
		// Infos
		QDomElement domInfos = root.firstChildElement("Infos");
		newModelPlus->setInfos(domInfos.attribute("text",""));
		
		// FilePath
		newModelPlus->setMmoFilePath(mmoFilePath);

		// Variables
		QDomElement domVariables = root.firstChildElement("Variables");
		newModelPlus->variables()->setItems(domVariables);
		
		// Controler type
		QDomElement cControlers = root.firstChildElement("Controlers");
		if(!cControlers.isNull())
			newModelPlus->setCtrlType((ModPlusCtrl::Type)cControlers.attribute("curType","").toInt());
		
		// Controler parameters
		QDomNodeList domControlerList = cControlers.elementsByTagName("Controler");
		ModPlusCtrl::Type _type;
		
		QDomElement cParams;
		QDomElement cControler;
		ModPlusCtrl* curCtrl;
		for(int iC=0;iC<domControlerList.size();iC++)
		{
			cControler = domControlerList.at(iC).toElement();
			_type = (ModPlusCtrl::Type)cControler.attribute("type","-1").toInt();
			if(_type>-1)
			{
				cParams = cControler.firstChildElement("parameters");
				
				if(!cParams.isNull())
				{
					curCtrl = newModelPlus->ctrls()->value(_type);
					if(curCtrl)
						curCtrl->parameters()->update(cParams);
				}
			}
		}
		
		bool ok = project->addModModelPlus(newModelPlus);
		return ok;
	}
}

