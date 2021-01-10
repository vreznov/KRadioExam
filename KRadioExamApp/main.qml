import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import "KExercises.js" as Ke

Window {
    id: window
    visible: true
    width: 500
    height: 800
    title: qsTr("无线电A证考试习题")

    //初始化
    Component.onCompleted: {
        console.log('start')

        Ke.init();
    }

    //属性对象
    property int exer_index: 0

    //测试方法
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

    //下一题
    function nextBtnClick() {
        //生成习题编号
        KL.nextItem();
        showindex();
        refreshQuesAns()
    }

    //上一题
    function lastBtnClick() {
        //生成习题编号
        KL.lastItem();
        showindex();
        refreshQuesAns()
    }

    //设置指定选项颜色为淡蓝色
    function setAnsColor( a_index, a_color = 'lightblue') {
        var recs = new Array(reca, recb, recc, recd)
        if(a_index >= 0 && a_index <= 3) {
            for(var i=0; i<4; i++) {
                var v1 = recs[1]
                if(a_index === i) { recs[i].color = a_color }
                else { recs[i].color = 'white' }
            }
        }
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
        anchors.bottomMargin: 80
        anchors.top: parent.top
        anchors.topMargin: 50

        MouseArea {
            anchors.fill: parent

            property var stX: 0
            property var stY: 0
            property bool mchanged: false //是否已经滑动过了，滑动过了就不再计算滑动，直到释放按钮

            onPressed: {
                stX = mouseX
                stY = mouseY
            }
            onReleased: {
                mchanged = false
            }
            onPositionChanged: {
                if( mchanged ) return

                var difv = mouseX - stX
                console.log(difv)
                if( difv > 100 ) {
                    //生成习题编号
                    lastBtnClick()
                    mchanged = true
                }
                else if( difv < -100) {
                    //生成习题编号
                    nextBtnClick()
                    mchanged = true
                }
            }
        }

        Rectangle{
            id: rec_header
            anchors.bottom: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            anchors.bottomMargin: -60
            anchors.topMargin: 20

            Text {
                id: element1
                text: qsTr("习题编号")
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 15
            }

            Rectangle {
                id: rectangle1
                width: 80
                height: 30
                anchors.verticalCenter: parent.verticalCenter
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
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 5

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

        Rectangle {
            id: rec_ques
            anchors.top: rec_header.bottom
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            border.width: 1
            height: 100
            Text {
                id: tx_ques
                text: qsTr("问题")
                font.bold: false
                wrapMode: Text.WordWrap
                font.pixelSize: 15
                anchors.fill: parent
                height: tx_ques.contentHeight

                onHeightChanged: {
                    parent.height = contentHeight < 100 ? 100 : contentHeight
                }
            }
        }

        Column{
            spacing: 10
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 260
            anchors.top: rec_ques.bottom
            anchors.topMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 0


            Rectangle{
                id: reca
                height: { txa.contentHeight < 30 ? 30 : txa.contentHeight }
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        setAnsColor(0)
                    }
                }

                Text {
                    id: txa
                    anchors.fill: parent
                    text: qsTr("选项A")
                    anchors.leftMargin: 5
                    wrapMode: Text.WordWrap
                    font.pixelSize: 15
                    height: contentHeight
                }

            }

            Rectangle{
                id: recb
                height:  { txb.contentHeight < 30 ? 30 : txb.contentHeight }
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        setAnsColor(1)
                    }
                }

                Text {
                    id: txb
                    anchors.fill: parent
                    text: qsTr("选项B")
                    anchors.leftMargin: 5
                    wrapMode: Text.WordWrap
                    font.pixelSize: 15
                    height: contentHeight
                }

            }

            Rectangle{
                id: recc
                height:  { txc.contentHeight < 30 ? 30 : txc.contentHeight }
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        setAnsColor(2)
                    }
                }

                Text {
                    id: txc
                    anchors.fill: parent
                    text: qsTr("选项C")
                    anchors.leftMargin: 5
                    wrapMode: Text.WordWrap
                    font.pixelSize: 15
                    height: contentHeight
                }

            }

            Rectangle{
                id: recd
                height:  { txd.contentHeight < 30 ? 30 : txd.contentHeight }
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        setAnsColor(3)
                    }
                }

                Text {
                    id: txd
                    anchors.fill: parent
                    text: qsTr("选项D")
                    anchors.leftMargin: 5
                    wrapMode: Text.WordWrap
                    font.pixelSize: 15
                    height: contentHeight
                }

            }
        }
    }

    Rectangle{
        id: rectangle2
        y: 324
        height: 60
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10

        Button {
            id: btn_next
            text: qsTr("下一题")
            anchors.right: btn_showAns.left
            anchors.rightMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter

            onClicked: {
                //生成习题编号
                nextBtnClick()
            }
        }

        Button {
            id: btn_showAns
            x: 250
            y: -1
            text: qsTr("查看答案")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            onClicked: {
                setAnsColor(0, 'lightgreen')
            }
        }

        Button {
            id: btn_last
            y: -4
            text: qsTr("上一题")
            anchors.left: btn_showAns.right
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter

            onClicked: {
                //生成习题编号
                lastBtnClick()
            }
        }
    }

}



/*##^##
Designer {
    D{i:9;anchors_y:71}D{i:2;anchors_height:198;anchors_width:523;anchors_x:60;anchors_y:112}
D{i:21;anchors_width:200;anchors_x:250}D{i:22;anchors_width:200;anchors_x:444}D{i:23;anchors_width:200;anchors_x:444}
D{i:20;anchors_width:200}
}
##^##*/
