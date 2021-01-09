import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import "KExercises.js" as Ke

Window {
    id: window
    visible: true
    width: 720
    height: 800
    title: qsTr("无线电A证考试习题")

    //初始化
    Component.onCompleted: {
        console.log('start')

        Ke.init();
    }

    //属性对象
    property int exer_index: 0

    //方法
    function showLog(){
        console.log('hello')
    }

    //显示当前习题编号
    function showindex() {
        exer_index = KL.curIndex();
        ti_index.text = exer_index.toString();
    }

    //刷新问题和答案
    function refreshQuesAns() {
        tx_ques.text = KL.readQuestion();

        txa.text = KL.readAns(0);
        txb.text = KL.readAns(1);
        txc.text = KL.readAns(2);
        txd.text = KL.readAns(3);

        //刷新显示的答案背景
        reca.color = 'white'
        recb.color = 'white'
        recc.color = 'white'
        recd.color = 'white'
    }

    Text {
        id: name
        x: 10; y: 10
        text: qsTr("无线电A证考试习题")
        font.pointSize: 15
    }

    Rectangle {
        id: rectangle
        color: "#ffffff"
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        anchors.top: parent.top
        anchors.topMargin: 50

        Rectangle{
            id: rec_header
            anchors.bottom: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.bottomMargin: -60
            anchors.topMargin: 20

            Text {
                id: element1
                text: qsTr("习题编号")
                font.pixelSize: 15
            }

            Rectangle {
                id: rectangle1
                width: 80
                height: 30
                anchors.left: parent.left
                anchors.leftMargin: 80
                border.width: 2

                TextInput {
                    id: ti_index
                    width: 80
                    text: qsTr("0")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.left: parent.left
                    leftPadding: 10
                    cursorVisible: false
                    font.pixelSize: 18

                    onEditingFinished: {
                        //将当前索引切换为设置的索引
                        var index = parseInt(ti_index.text)
                        if(!isNaN(index)) {
                            var ret = KL.setCurIndex(index);
                            if(!ret) {
                                console.log('设置的习题编号超出范围')
                            }
                            else {
                                KL.setCurIndex(index)
                                refreshQuesAns()
                            }
                        }
                        else {
                            console.log('设置的习题编号不是有效的数字类型')
                        }
                    }
                }
            }

            Switch {
                id: sb
                text: qsTr("顺序模式")
                anchors.right: parent.right
                anchors.rightMargin: 10

                onCheckedChanged: {
                    if(sb.checked) {
                        sb.text = qsTr('随机模式')
                        KL.setRandomMode()
                    }
                    else {
                        sb.text = qsTr('顺序模式')
                        KL.setSequenceMode(0)
                    }
                }
            }
        }

        Text {
            id: tx_ques
            y: 71
            height: { contentHeight < 100 ? 100 : contentHeight }
            text: qsTr("问题")
            font.bold: false
            wrapMode: Text.WordWrap
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            font.pixelSize: 15
        }

        Column{
            spacing: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 260
            anchors.top: tx_ques.bottom
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 20


            Rectangle{
                id: reca
                y: 109
                height: { txa.contentHeight < 30 ? 30 : txa.contentHeight }
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                Text {
                    id: txa
                    anchors.fill: parent
                    text: qsTr("选项A")
                    wrapMode: Text.WordWrap
                    font.pixelSize: 15
                }

            }

            Rectangle{
                id: recb
                y: 109
                height:  { txb.contentHeight < 30 ? 30 : txa.contentHeight }
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                Text {
                    id: txb
                    anchors.fill: parent
                    text: qsTr("选项B")
                    wrapMode: Text.WordWrap
                    font.pixelSize: 15
                }

            }

            Rectangle{
                id: recc
                y: 109
                height:  { txc.contentHeight < 30 ? 30 : txa.contentHeight }
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                Text {
                    id: txc
                    anchors.fill: parent
                    text: qsTr("选项C")
                    wrapMode: Text.WordWrap
                    font.pixelSize: 15
                }

            }

            Rectangle{
                id: recd
                y: 109
                height:  { txd.contentHeight < 30 ? 30 : txa.contentHeight }
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                Text {
                    id: txd
                    anchors.fill: parent
                    text: qsTr("选项D")
                    wrapMode: Text.WordWrap
                    font.pixelSize: 15
                }

            }
        }

        Row{
            y: 324
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            spacing: 10

            Button {
                id: button
                text: qsTr("上一题")

                onClicked: {
                    //生成习题编号
                    KL.lastItem();
                    showindex();
                    refreshQuesAns();
                }
            }

            Button {
                id: button1
                text: qsTr("查看答案")

                onClicked: {
                    reca.color = 'lightgreen'
                }
            }

            Button {
                id: button2
                text: qsTr("下一题")

                onClicked: {
                    //生成习题编号
                    KL.nextItem();
                    showindex();
                    refreshQuesAns();
                }
            }
        }
    }

}

/*##^##
Designer {
    D{i:2;anchors_height:198;anchors_width:523;anchors_x:60;anchors_y:112}
}
##^##*/
