// $Id$
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
 * Main contributor 2011, Hubert Thierot, CEP - ARMINES (France)

        @file EIConns.h
        @brief Comments for file documentation.
        @author Hubert Thieriot, hubert.thieriot@mines-paristech.fr
        Company : CEP - ARMINES (France)
        http://www-cep.ensmp.fr/english/
        @version

  */
#ifndef EICONNS_H
#define EICONNS_H

#include "MOVector.h"
#include "EIConn.h"
#include "LowTools.h"

namespace EI
{
class EIConns : public MOVector<EIConn>
{
public:
    EIConns(void);
    ~EIConns(void);

    void setItems(QDomElement & domEl,const EITree &);

    QStringList allStreams() const;


    QList<METemperature> TList(QString stream) const;

    QList<EIConn> filter(QString stream) const;
    QList<EIConn> filterT(QString stream,METemperature T) const;
    QList<EIConn> filterTin(QString stream,METemperature Tin) const;
    QList<EIConn> filterTout(QString stream,METemperature Tout) const;

private :
    //MEQflow::Units _qflowUnit;
    //METemperature::Units _TUnit;


};
}
#endif
