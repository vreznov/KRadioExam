#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "kexercises.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    KExercises loader;

    QQmlApplicationEngine engine;

    //加载自定义C++类
    engine.rootContext()->setContextProperty(QObject::tr("KL"), &loader);
//    qmlRegisterType<KExercises>("Kare.Utility", 1, 0, "KExercises");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
