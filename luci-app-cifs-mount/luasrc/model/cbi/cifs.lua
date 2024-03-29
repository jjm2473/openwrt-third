local fs = require "nixio.fs"

m = Map("cifs", translate("Mount NetShare"), translate("Mount NetShare for OpenWrt"))

s = m:section(TypedSection, "cifs")
s.anonymous = true

switch = s:option(Flag, "enabled", translate("Enable"))
switch.rmempty = false

delay = s:option(Value, "delay", translate("Delay"), translate("Boot delay (in seconds), skip if 0 or empty"))
delay.datatype = "uinteger"

s = m:section(TypedSection, "natshare", translate("Mount CIFS/SMB"))
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"

server = s:option(Value, "server", translate("Server IP"))
server.datatype = "host"
server.placeholder = "192.168.50.1"
server.size = 12
server.rmempty = false

name = s:option(Value, "name", translate("Share Folder"))
name.datatype = "minlength(1)"
name.placeholder = "Share"
name.rmempty = false
name.size = 8

pth = s:option(Value, "natpath", translate("Mount Path"))
if nixio.fs.access("/etc/config/fstab") then
        pth.titleref = luci.dispatcher.build_url("admin", "system", "fstab")
end
pth.datatype = "minlength(2)"
pth.placeholder = "/mnt/samba"
pth.rmempty = false
pth.size = 10

smbver = s:option(Value, "smbver", translate("SMB Version"))
smbver.rmempty = false
smbver:value("1.0","SMB v1")
smbver:value("2.0","SMB v2")
smbver:value("3.0","SMB v3")
smbver:value("nil","None")
smbver.default = "2.0"
smbver.size = 3

agm = s:option(Value, "agm", translate("Arguments"))
agm:value("ro", translate("Read Only"))
agm:value("rw", translate("Read/Write"))
agm.rmempty = true
agm.default = "ro"

iocharset = s:option(Value, "iocharset", translate("Charset"))
iocharset:value("utf8", "UTF8")
iocharset.default = "utf8"
iocharset.size = 2

users = s:option(Value, "users", translate("User"))
users:value("guest", "Guest")
users.rmempty = true
users.default = "guest"

pwd = s:option(Value, "pwd", translate("Password"))
pwd.rmempty = true
pwd.password = true
pwd.size = 8

s = m:section(TypedSection, "davfs", translate("Mount WebDAV"))
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"

server = s:option(Value, "url", translate("URL"))
server.datatype = "minlength(1)"
server.placeholder = "http://"
server.size = 16
server.rmempty = false

pth = s:option(Value, "mountpoint", translate("Mount Path"))
if nixio.fs.access("/etc/config/fstab") then
        pth.titleref = luci.dispatcher.build_url("admin", "system", "fstab")
end
pth.datatype = "minlength(2)"
pth.placeholder = "/mnt/webdav"
pth.rmempty = false
pth.size = 10

agm = s:option(Value, "arguments", translate("Arguments"))
agm:value("ro", translate("Read Only"))
agm:value("rw", translate("Read/Write"))
agm.rmempty = true
agm.default = "ro"

users = s:option(Value, "username", translate("User"))
users:value("none", "Guest")
users.rmempty = true
users.default = "none"

pwd = s:option(Value, "password", translate("Password"))
pwd.rmempty = true
pwd.password = true
pwd.size = 8

return m
