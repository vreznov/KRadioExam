//习题文件

var ques_json = ''

//读取json文件
//网上抄的 https://blog.csdn.net/clearloveq/article/details/90480207
function load(ffn)
{
    var json = ''
    var url = ffn /*json文件url，本地的就写本地的位置，如果是服务器的就写服务器的路径*/
    var request = new XMLHttpRequest();
    request.open("get", url);/*设置请求方法与路径*/
    request.send(null);/*不发送数据到服务器*/
    request.onload = function () {/*XHR对象获取到返回信息后执行*/
        if (request.status === 200) {/*返回状态为200，即为数据获取成功*/
            var json = JSON.parse(request.responseText);
            ques_json = json
        }
    }
}

function init()
{
    console.log('Init...')
//    var text = load("qrc:/ques.json")
//    console.log(ques_json)
}
