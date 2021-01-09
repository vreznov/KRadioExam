#ifndef KLOAD_H
#define KLOAD_H

/***************************************************************
 * @file: kload.h
 * @brief: 载入json文件到内存对象，可提供随机访问和顺序访问
 *
 *
 *
 *
 *
 *
 * *************************************************************/

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QString>
#include <QByteArray>
#include <QJsonObject>
#include <QJsonParseError>
#include <QJsonDocument>
#include <QJsonArray>
#include <QDebug>
#include <QList>
#include <QVector>
#include <QScopedPointer>
#include <random>
#include <QRandomGenerator>

/*******************************************************
 * @file: kload.h
 * @brief: 载入json习题，并提供顺序访问和随机访问模式
 * 使用方法
 *  1.载入json
 *  2.  顺序访问模式：
 *          setSequenceMode()
 *          setIndex()
 *
 *      随机访问模式:
 *          setRandomMode()
 *          setRandomIndex()
 *  3. 获取问题 readQuestion（）
 *     获取选项 readAns()
 *
 * 关于随机模式的说明：
 *  setRandomIndex()会在没有使用的索引编号中随机挑选一个编号
 *
 *
 * *****************************************************/

class KExercises : public QObject
{
    Q_OBJECT
public:
    explicit KExercises(QObject *parent = nullptr);

    //! 载入固定的json文件并解析
    Q_INVOKABLE bool loadJson();

    //! 存储习题的json对象
    QJsonDocument m_jdoc;

    //! 一条习题
    struct KExercises_item{
        QString m_sindex;  //字符编号
        int m_index = 0;  //数字编号
        QString m_question;  //问题
        QStringList m_ans;  //答案
        int m_rightAns = 0;  //正确答案编号
    };


    //! 获取当前的问题
    Q_INVOKABLE QString readQuestion();

    //! 获取当前习题第index个答案
    Q_INVOKABLE QString readAns(int a_index);

    //! 设置随机模式
    Q_INVOKABLE void setRandomMode();

    //! 设置顺序模式
    //! @param a_index: 将当前习题索引设置为a_index，用于从任意条目开始启动
    Q_INVOKABLE void setSequenceMode(int a_index);

    //! 返回下一道习题，在顺序模式则将索引+1,随机模式设置为一个没有使用过的随机值
    //! @return: 如果未使用列表已经为空，则返回false，否则返回true
    Q_INVOKABLE bool nextItem();

    //! 返回上一道习题，从已使用列表中删除最后一个元素，将这个元素放到未使用列表，并此时的最后一个元素设置为当前索引
    Q_INVOKABLE bool lastItem();

    //! 获取当前的编号
    Q_INVOKABLE int curIndex();

    //! 将当前的索引设置为指定编号，如果不在有效范围，则返回错误
    Q_INVOKABLE bool setCurIndex(int a_index);

private:
    QList<KExercises_item> m_items;  //习题们
    int m_curSel = 0;  //当前选择的习题
    bool m_randomMode = false;
    QList<int> m_randomSelected;  //随机模式下已经使用过的习题
    QList<int> m_randomUnSelected;  //随机模式下未使用过的习题

signals:

public slots:
};

#endif // KLOAD_H
