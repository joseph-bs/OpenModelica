#-------------------------------------------------
#
# Project created by QtCreator 2010-09-23T18:14:43
#
#-------------------------------------------------

QT += core gui

TARGET = OMEdit
TEMPLATE = app

SOURCES += main.cpp\
        mainwindow.cpp \
    ProjectTabWidget.cpp \
    LibraryWidget.cpp \
    MessageWidget.cpp \
    omc_communication.cpp \
    OMCThread.cpp \
    OMCProxy.cpp \
    StringHandler.cpp \
    ModelWidget.cpp \
    Helper.cpp \
    SplashScreen.cpp \
    ShapeAnnotation.cpp \
    LineAnnotation.cpp \
    PolygonAnnotation.cpp \
    RectangleAnnotation.cpp \
    EllipseAnnotation.cpp \
    TextAnnotation.cpp \
    IconAnnotation.cpp \
    InheritanceAnnotation.cpp \
    ComponentAnnotation.cpp \
    ComponentsProperties.cpp \
    CornerItem.cpp \
    ConnectorWidget.cpp

HEADERS  += mainwindow.h \
    ProjectTabWidget.h \
    LibraryWidget.h \
    MessageWidget.h \
    omc_communication.h \
    OMCThread.h \
    OMCProxy.h \
    StringHandler.h \
    ModelWidget.h \
    Helper.h \
    SplashScreen.h \
    ShapeAnnotation.h \
    LineAnnotation.h \
    PolygonAnnotation.h \
    RectangleAnnotation.h \
    EllipseAnnotation.h \
    TextAnnotation.h \
    IconAnnotation.h \
    InheritanceAnnotation.h \
    ComponentAnnotation.h \
    ComponentsProperties.h \
    CornerItem.h \
    ConnectorWidget.h \

# -------For OMNIorb
win32 {
DEFINES += __x86__ \
    __NT__ \
    __OSVERSION__=4 \
    __WIN32__
LIBS += -L. \
    -lomniORB414_rtd \
    -lomnithread34_rtd

INCLUDEPATH += C:\\Thesis\\omniORB-4.1.4\\include
} else {
LIBS += -L/usr/lib/ -lomniORB4 -lomnithread
INCLUDEPATH += /usr/include/omniORB4
}
#---------End OMNIorb

OTHER_FILES += \
    Resources/css/stylesheet.qss
