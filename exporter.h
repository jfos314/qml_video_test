#ifndef EXPORTER_H
#define EXPORTER_H

#include <QObject>

class Exporter : public QObject
{
    Q_OBJECT
public:
    explicit Exporter(QObject *parent = nullptr);

signals:
    void sendToQml(double progress);

public slots:
    void export_video(QString video_path, bool o1, int oX1, int oY1, bool o2, int oX2, int oY2, bool o3, int oX3, int oY3);

private:
    double progress;

};

#endif // EXPORTER_H
