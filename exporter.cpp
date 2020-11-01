#include "exporter.h"

#include <iostream>
#include <string>
#include <cmath>

#include <opencv2/core.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/opencv.hpp>

#include <QThread>
#include <QtConcurrent>
#include <QFutureWatcher>
#include <QRandomGenerator>

using namespace std;
using namespace cv;
using namespace QtConcurrent;

Exporter::Exporter(QObject *parent) : QObject(parent)
{
    progress = 0;
}

int find_frame_interval(int ms, int fps){
    int i = ceil(ms / (1000.0 / fps));
    if (i < 1) return 1;
    return i;
}
class itemOverlay{
public:
    bool used; Point pt;
    itemOverlay(bool u, Point p){ used = u; pt = p; }
};

void task(QString video_path, itemOverlay itm1, itemOverlay itm2, itemOverlay itm3)
{
    string source = video_path.toStdString();
    VideoCapture inputVideo(source);
    if (!inputVideo.isOpened())
        qDebug() << "Could not open the input video: " << source.c_str();
    else
        qDebug() << "video opened";

    string::size_type pAt = source.find_last_of('.');
    const string name = source.substr(0, pAt) + "_edt" + ".avi";
    int ex = static_cast<int>(inputVideo.get(CAP_PROP_FOURCC));

    char ext[] = {(char)(ex & 0XFF) , (char)((ex & 0XFF00) >> 8),(char)((ex & 0XFF0000) >> 16),(char)((ex & 0XFF000000) >> 24), 0};

    Size S = Size((int) inputVideo.get(CAP_PROP_FRAME_WIDTH),
                  (int) inputVideo.get(CAP_PROP_FRAME_HEIGHT));

    VideoWriter outputVideo;
    auto fps = inputVideo.get(CAP_PROP_FPS);
    qDebug() << "fps: " << fps;
    outputVideo.open(name, ex, fps, S, true);

    if (!outputVideo.isOpened())
        qDebug() << "Could not open the output video for write: " << source.c_str();

    qDebug() << "Input frame resolution: Width=" << S.width << "  Height=" << S.height
         << " of nr#: " << inputVideo.get(CAP_PROP_FRAME_COUNT);
    qDebug() << "Input codec type: " << ext;

    Mat src, res;
    vector<Mat> spl;

    int rndTextInterval = find_frame_interval(300, fps);
    int rndProgressInterval = find_frame_interval(500, fps);
    int rndRecInterval = find_frame_interval(1000, fps);

    int pWidth = 60;
    int pHeight = 4;
    int pCurrWidth = 0;
    int pStep = pWidth / 10;
    bool pIncrementing = true;

    Point recUpperLeft = itm3.pt;
    int recDim = 40;

    Mat rec(recDim,recDim,CV_8UC3);
    for(int y = 0; y < recDim; y++){
       Vec3b val;
       val[0] = 0; val[1] = (y*255)/recDim; val[2] = (recDim-y)*255/recDim;
       for(int x = 0; x < recDim; x++)
          rec.at<Vec3b>(y,x) = val;
    }

    int currFrame = 0;
    uniform_int_distribution<int> distribution(0, 100);

    string num = to_string(distribution(*QRandomGenerator::global()));

    for(;;) {
        inputVideo >> src;
        if (src.empty()) break;

        currFrame++;
        if (itm1.used) {
            if(currFrame % rndTextInterval == 0) {
                num = to_string(distribution(*QRandomGenerator::global()));
            }
            putText(src,num, itm1.pt, FONT_HERSHEY_COMPLEX_SMALL, 1.0, Scalar(255,255,255),1, LINE_AA);
        }
        if (itm2.used) {
            if (currFrame % rndProgressInterval) {
                if (pCurrWidth == pWidth)
                    pIncrementing = false;
                else if (pCurrWidth == 0)
                    pIncrementing = true;
                pCurrWidth = pIncrementing == true ? pCurrWidth + pStep : pCurrWidth - pStep;
            }
            rectangle(src, itm2.pt, Point(itm2.pt.x + pWidth, itm2.pt.y + pHeight), Scalar(220, 220, 220), -1, LINE_AA);
            rectangle(src, itm2.pt, Point(itm2.pt.x + pCurrWidth, itm2.pt.y + pHeight), Scalar(0, 0, 0), -1, LINE_AA);
        }
        if (itm3.used) {
            if (currFrame % rndRecInterval == 0){
                int b = distribution(*QRandomGenerator::global());
                recUpperLeft.x = recUpperLeft.x < S.width * 0.5 ? recUpperLeft.x + distribution(*QRandomGenerator::global()) : recUpperLeft.x - distribution(*QRandomGenerator::global());
                recUpperLeft.y = recUpperLeft.y < S.height * 0.5 ? recUpperLeft.y + distribution(*QRandomGenerator::global()) : recUpperLeft.y - distribution(*QRandomGenerator::global());
                rec = Mat(recDim,recDim,CV_8UC3);
                    for(int y = 0; y < recDim; y++){
                       Vec3b val;
                       val[0] = b; val[1] = (y*255)/recDim; val[2] = (recDim-y)*255/recDim;
                       for(int x = 0; x < recDim; x++)
                          rec.at<Vec3b>(y,x) = val;
                    }
            }
            qDebug() << "UpperLeft: " << recUpperLeft.x << ", " << recUpperLeft.y;
            Rect roi(recUpperLeft, Size(recDim, recDim));
            rec.copyTo(src(roi));
       }
       outputVideo << src;
    }
}

void Exporter::export_video(QString video_path, bool o1, int oX1, int oY1, bool o2, int oX2, int oY2, bool o3, int oX3, int oY3)
{
    itemOverlay itm1(o1, Point(oX1, oY1));
    itemOverlay itm2(o2, Point(oX2, oY2));
    itemOverlay itm3(o3, Point(oX3, oY3));
    emit sendToQml(-10);

    QFutureWatcher<void> *watcher = new QFutureWatcher<void>(this);
    QFuture<void> f = QtConcurrent::run(task, video_path, itm1, itm2, itm3);
    watcher->setFuture(f);
    f.waitForFinished(); //if wait removed, GUI unblocked, but no signal to GUI that process finished

    //connect(watcher, SIGNAL(finished()), watcher, SLOT(printFinished())); //TODO: srediti na neki način
}
