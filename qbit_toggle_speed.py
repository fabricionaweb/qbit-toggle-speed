import sys
from argparse import ArgumentParser
from urllib import request, parse

# -------------------------
# qbittorrent credentials
username = "admin"
password = "adminadmin"
# qbittorrent web api
endpoint = "http://tower.lan:9090/api/v2"
# -------------------------


# get the cookie after login
def get_cookie():
    data = {'username': username, 'password': password}
    req = request.Request(f"{endpoint}/auth/login",
                          data=parse.urlencode(data).encode(),
                          )
    return request.urlopen(req).info().get('Set-Cookie').split(';')[0]


# get the current speed limit mode
def get_state(cookie):
    req = request.Request(f"{endpoint}/transfer/speedLimitsMode",
                          headers={'Cookie': cookie},
                          )
    return request.urlopen(req).read().decode() == '1'


# toggle speed limit mode
def toggle(cookie):
    req = request.Request(f"{endpoint}/transfer/toggleSpeedLimitsMode",
                          headers={'Cookie': cookie},
                          )
    return request.urlopen(req)


def main():
    parser = ArgumentParser()
    parser.add_argument("--action",
                        choices=["enable", "disable"],
                        required=True,
                        help="Enable or Disable the speed limit mode",
                        )
    action = parser.parse_args().action

    cookie = get_cookie()
    state = get_state(cookie)

    if action == "enable" and state is True:
        sys.exit("Already enabled")
    if action == "disable" and state is False:
        sys.exit("Already disabled")

    toggle(cookie)


if __name__ == "__main__":
    main()
