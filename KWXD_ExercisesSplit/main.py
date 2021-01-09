# This Python file uses the following encoding: utf-8
import sys
import os.path
from PySide2.QtWidgets import QApplication, QMainWindow
import json


# 将指定的文本习题分割为单个的json对象，用于手机端APP调用显示
#
# 注意所有的问题格式必须有一个问题及4个选项
#
# 读取到的每一题存为一个 列表， 下标
#   0 习题编号
#   1 问题
#   2～5 选项A～D
#
# json格式
# {
#   习题编号
#   问题
#   [答案]*4
# }


# 分割处理文件，将给定的文本转换为json格式
# 文件必须放在当前程序同文件夹下
def splitTxt(file_name):
    cur_file = sys.argv[0]
    # 获取文件夹位置
    cur_path = os.path.abspath(cur_file + '/../')

    ffn = '%s/%s' % (cur_path, file_name)
    print('full file name is %s' % ffn)

    if not os.path.isfile(ffn):
        print('file %s not exist, split failed' % ffn)
        return False

    print('start split')

    # 所有问题
    allquestions = []
    # 当前的一个问题
    cur_ques = []

    i = 0
    detect_err = False
    fo = open(ffn, 'r')
    for line in fo.readlines():

        i = i + 1

        # 忽略注释行
        if line[0] == '#' or len(line) == 0 or line == '\n':
            continue

        # 移除首尾空格
        line = line.strip()

        if '[编号]' in line:
            if len(cur_ques) == 0:
                cur_ques.append(line[4:])
            else:
                print('%d行编号错误，上一语句未完全解析完毕，检查文本是否正确' % i)
                break

        elif '[Q]' in line:
            if len(cur_ques) == 1:
                cur_ques.append(line[3:])
            else:
                print('%d行问题错误，上一语句未完全解析完毕，检查文本是否正确' % i)
                break

        elif ('[A]' in line and len(cur_ques) == 2) or ('[B]' in line and len(cur_ques) == 3)\
        or ('[C]' in line and len(cur_ques) == 4) or ('[D]' in line and len(cur_ques) == 5):
            cur_ques.append(line[3:])
        else:
            print('%d行答案错误，上一语句未完全解析完毕，检查文本是否正确' % i)
            print('当前内容：%s' % cur_ques)
            break

        if len(cur_ques) == 6:
            allquestions.append(cur_ques)
            cur_ques = []

    fo.close()

    # 存入json
    jstr = json.dumps(allquestions, ensure_ascii=False)
    # 写入 JSON 数据
    ffn_js = cur_path +'/ques.json'
    with open(ffn_js, 'w', encoding='utf-8') as f:
        json.dump(jstr, f, ensure_ascii=False)

    return allquestions

# 将问题文件存储为json文件
def ques2json(ques):
    jstr = json.dumps(ques, ensure_ascii=False)
    # 写入 JSON 数据
    with open('data.json', 'w', encoding='utf-8') as f:
        json.dump(jstr, f, ensure_ascii=False)
    return jstr

if __name__ == "__main__":
#    app = QApplication([])
#    sys.exit(app.exec_())

    v = splitTxt('exercises.txt')

