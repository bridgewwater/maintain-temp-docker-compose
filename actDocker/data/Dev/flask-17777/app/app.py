# -*- coding: utf-8 -*-
import json
import socket
from flask import Flask
from flask import request
from flask import jsonify
from flask import redirect
from flask import render_template

app = Flask(__name__)

update_data = """
{
  "msg":"update info",
  "pn":"",
  "vc":"1000000",
  "vn":"1.0.0-SNAPSHOT",
  "download_url":"",
  "channel":"dakehu",
  "extra":"",
  "force": 0
}"""


def get_host_ip():
    """
    查询本机ip地址
    :return: ip
    """
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(('114.114.114.114', 80))
        ip = s.getsockname()[0]
    finally:
        s.close()
    return ip


@app.route('/band/v1/app/update', methods=['GET', 'POST'])
def band_app_update():
    if request.method == 'GET':
        update_json_obj = json.loads(update_data)
        return jsonify(update_json_obj)
    else:
        return '<h1>only support method GET！</h1>'


@app.route('/', methods=['GET'])
def index():
    user_ip = request.remote_addr
    host_ip = get_host_ip()
    return render_template('index.html', user_ip=user_ip, host_ip=host_ip)


if __name__ == '__main__':
    app.run(
        host='0.0.0.0',
        port=17777,
        # debug=True
    )
