#include "kexercises.h"

KExercises::KExercises(QObject *parent) : QObject(parent)
{
    //初始化默认习题数量361

    loadJson();
}

bool KExercises::loadJson()
{
    //载入资源文件 qrc:/ques.json
    QString fileName = ":/ques.json";
    QFile file(fileName);
    if(file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QByteArray bary = file.readAll();
        bary.replace('\\', "");
        file.close();

        QJsonParseError perr;
        m_jdoc = QJsonDocument::fromJson(bary, &perr);
        if(perr.error != QJsonParseError::ParseError::NoError) {
            qDebug() << "error occured when load json: " << perr.errorString();
            return false;
        }

        //
        QJsonArray jary = m_jdoc.array();

        //初始化向量
//        m_pExercises.reset(new QVector<KExercises>(jary.count()));

        int i = 0;
        for(QJsonArray::const_iterator iter = jary.constBegin();
            iter != jary.constEnd(); ++iter) {

            //转换成一个条目，条目是一个列表
            QJsonArray jary_item = (*iter).toArray();

            //构造习题对象
            KExercises_item item;
            item.m_index = i;
            item.m_sindex = jary_item[0].toString();
            item.m_question = jary_item[1].toString();
            item.m_rightAns = 0;
            item.m_ans << jary_item[2].toString() << jary_item[3].toString()\
                                 <<jary_item[4].toString() << jary_item[5].toString();
            m_items.append(item);

            i++;
        }
    }
    else {
        return false;
    }

    qDebug() << "load json document sucess";
    return true;
}

QString KExercises::readQuestion()
{
    return m_items[m_curSel].m_question;
}

QString KExercises::readAns(int a_index)
{
    if(a_index >= 0 and a_index <= 3) {
        QStringList sl = {"A. ", "B. ", "C. ", "D. "};

        if(!m_randomMode) {  //答案为A
            return (sl[a_index] + m_items[m_curSel].m_ans[a_index]);
        }
        else {  //答案为随机选项，返回选择题目的随机答案
            int index = m_curRandomAns[a_index];
            return (sl[a_index] + m_items[m_curSel].m_ans[index]);
        }
    }
    else {
        return tr("invalid answer index");
    }
}

int KExercises::readCurAns()
{
    return m_curCorrecrAns[m_curSel];
}

void KExercises::setRandomMode()
{
    m_randomMode = true;
    m_randomSelected.clear();
    m_randomUnSelected.clear();
    for(int i=0; i<m_items.size(); i++) {
        m_randomUnSelected.append(i);
    }

    m_curCorrecrAns.clear();
    m_curCorrecrAns.resize(m_items.size());
}

void KExercises::setSequenceMode(int a_index)
{
    m_randomMode = false;
    if(a_index >= 0 and a_index < m_items.size()) {
        m_curSel = a_index;
    }
    else {
        m_curSel = 0;
    }

    //将正确答案全部标记为0-选项A
    m_curCorrecrAns.clear();
    m_curCorrecrAns.resize(m_items.size());
    m_curCorrecrAns.fill(0);
}

bool KExercises::nextItem()
{
    if(m_randomMode) {  //随机访问模式
        /* 随机模式访问逻辑
     * 1.生成一个 0～未使用数量直接的随机数
     * 2.将这个数设置为当前选择的索引
     * 3.将未使用中的这个编号删除，将这个编号存入已使用变化
     * */

        if(m_randomUnSelected.size() == 0) { return false; }

//        std::default_random_engine e;
//        std::uniform_int_distribution<int> u(0, m_randomUnSelected.size());
//        m_curSel = u(e);
//        m_curSel = rand() % m_randomUnSelected.size();
        QRandomGenerator* rg = QRandomGenerator::global();
        int index = rg->bounded(0, m_randomUnSelected.size());
        m_curSel = m_randomUnSelected.at(index);

        m_randomUnSelected.removeAt(index);
        m_randomSelected.append(m_curSel);

        //生成随机答案并记录正确的答案编号
        m_curRandomAns = randomABCD();
        m_curCorrecrAns[m_curSel] = m_curRandomAns.indexOf(0);

        return true;
    }
    else {  //顺序访问模式
        if(m_curSel < m_items.size() - 1)
        {
            m_curSel++;
            return true;
        }
        else {
            return false;
        }
    }
}

bool KExercises::lastItem()
{
    if(m_randomMode) {
        if(m_randomSelected.size() < 2) {
            return false;
        }
        else {
            int index = m_randomSelected.last();
            m_randomSelected.removeLast();
            m_randomUnSelected.append(index);
            m_curSel = m_randomSelected.last();
            return true;
        }
    }
    else {
        if(m_curSel < 1) { return false; }
        else {
            m_curSel--;
            return true;
        }
    }
}

int KExercises::curIndex()
{
    return m_curSel;
}

bool KExercises::setCurIndex(int a_index)
{
    if(a_index >= 0 and a_index < m_items.size()) {
        m_curSel = a_index;
        return true;
    }
    else {
        return false;
    }
}

QVector<int> KExercises::randomABCD()
{
    QVector<int> v = {0, 1, 2, 3};

    std::random_device rd;
    std::mt19937 g(rd());

    std::shuffle(v.begin(), v.end(), g);

    return v;
}
