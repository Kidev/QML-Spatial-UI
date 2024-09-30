#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app {argc, argv};

    QQmlApplicationEngine engine;

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [&engine](QObject *obj, const QUrl &) {
            if (!obj && engine.rootObjects().isEmpty())
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    engine.loadFromModule("example", "MainScene");

    return app.exec();
}
