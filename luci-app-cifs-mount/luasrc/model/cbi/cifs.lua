local fs = require "nixio.fs"
local m,s,o
local util = require "luci.util"
local rclone_version = util.trim(util.exec("/etc/init.d/cifs rclone_installed"))
local rclone_installed = (string.len(rclone_version) > 0)

m = Map("cifs", translate("Mount NetShare"), translate("Mount NetShare for OpenWrt"))

s = m:section(TypedSection, "cifs")
s.anonymous = true

s:tab("global", translate("Global Settings"))
s:tab("davfs", translate("WebDAV"), translate("Advance WebDAV mounting settings"))

switch = s:taboption("global", Flag, "enabled", translate("Enable"))
switch.rmempty = false

delay = s:taboption("global", Value, "delay", translate("Delay"), translate("Boot delay (in seconds), skip if 0 or empty"))
delay.datatype = "uinteger"

o = s:taboption("davfs", Value, "cache_dir", translate("Cache Path"), translate("You don't want to use FAT/exFAT"))
o.placeholder = "/tmp/cache/davfs"

o = s:taboption("davfs", ListValue, "rclone_cache_mode", translate("Rclone Cache Mode"), translate("Refer to '--vfs-cache-mode' in <a href=\"https://rclone.org/commands/rclone_mount/#vfs-file-caching\" target=\"_blank\">official documentation</a>. " ..
        "If you want to upload a file that exceeds the available memory, you need to at least select \"writes\" here and make sure the cache folder is large enough"))
o:value("", "off")
o:value("minimal")
o:value("writes")
o:value("full")

o = s:taboption("davfs", Value, "rclone_extras", translate("Rclone Custom"), translate("Extra parameters for \"rclone mount\""))

s = m:section(TypedSection, "natshare", translate("Mount CIFS/SMB"))
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"

o = s:option(Flag, "enabled", translate("Enable"))
o.default = 1
o.rmempty = false

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

s = m:section(TypedSection, "davfs", translate("Mount WebDAV"), translate("Regarding the choice of engine: <br>" ..
        "<b>davfs2</b>: It is installed by default, but its random read and write performance is very poor. Reading and writing files at any location will cause the entire file to be downloaded. <br>" ..
        "<a href=\"https://rclone.org/\" target=\"_blank\"><b>Rclone</b></a>: Good reading and writing performance, but not installed by default. (No configuration required after installation)<br>" ..
        "<b>Auto</b>: Use Rclone if it is installed, otherwise fall back to davfs2. (Recommend) <br>") ..
        translatef("Rclone status: %s <br>", rclone_installed and translatef("%s installed", rclone_version) or translate("Not installed")))
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"

o = s:option(Flag, "enabled", translate("Enable"))
o.default = 1
o.rmempty = false

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

o = s:option(ListValue, "engine", translate("Engine"))
o:value("auto", translate("Auto"))
o:value("davfs2")
-- o:value("webdavfs")
o:value("rclone", "Rclone")
o.default = "auto"
o.rmempty = false

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
