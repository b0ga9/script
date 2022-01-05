script_version(2.0)

require "lib.moonloader"
local inicfg = require 'inicfg'
local keys = require 'vkeys'
local encoding = require "encoding"
encoding.default = "CP1251"
u8 = encoding.UTF8
local imgui = require "imgui"

local tag = " Deed | {FFFFFF}�������."
local main_window_state = imgui.ImBool(false)
local two_window_state = imgui.ImBool(false)


function main()
   if not isSampLoaded() or not isSampfuncsLoaded() then return end
   while not isSampAvailable() do wait(100) end
   --"https://raw.githubusercontent.com/b0ga9/script/master/wadawdwad.lua"
   autoupdate("https://raw.githubusercontent.com/b0ga9/script/master/wadawdwad.lua", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/b0ga9/script/master/update.json")

   sampAddChatMessage(tag, -1)
   sampRegisterChatCommand("updat", cmd_updat)
   sampRegisterChatCommand("redak", function() main_window_state.v = not main_window_state.v end) -- ������� /cnn
   sampRegisterChatCommand("test", function() two_window_state.v = not two_window_state.v end)
   

   while true do 
      wait(0)
      imgui.Process = main_window_state.v or two_window_state.v --code
   end
end

--��� � main(), ����� while not isSampAvailable() do wait(100) end
--autoupdate("http://qrlk.me/dev/moonloader/getgun/stats.php", '['..string.upper(thisScript().name)..']: ', "http://vk.com/qrlk.mods")

function autoupdate(json_url, prefix, url)
   local dlstatus = require('moonloader').download_status
   local json = getWorkingDirectory() .. '\\' .. thisScript().name .. '-version.json'
   if doesFileExist(json) then os.remove(json) end
   downloadUrlToFile(json_url, json,
      function(id, status, p1, p2)
         if status == dlstatus.STATUSEX_ENDDOWNLOAD then
            if doesFileExist(json) then
               local f = io.open(json, 'r')
               if f then
                  local info = decodeJson(f:read('*a'))
                  updatelink = info.updateurl
                  updateversion = info.latest
                  f:close()
                  os.remove(json)
                  if updateversion ~= thisScript().version then
                     lua_thread.create(function(prefix)
                     local dlstatus = require('moonloader').download_status
                     local color = -1
                     sampAddChatMessage((prefix..'���������� ����������. ������� ���������� c ' .. thisScript().version .. ' �� '.. updateversion), color)
                     wait(250)
                     downloadUrlToFile(updatelink, thisScript().path,
                        function(id3, status1, p13, p23)
                           if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                              print(string.format('��������� %d �� %d.', p13, p23))
                           elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                              print('�������� ���������� ���������.')
                              sampAddChatMessage((prefix..'���������� ���������!'), color)
                              goupdatestatus = true
                              lua_thread.create(function() wait(500) thisScript():reload() end)
                           end
                           if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                              if goupdatestatus == nil then
                                 sampAddChatMessage((prefix..'���������� ������ ��������. �������� ���������� ������..'), color)
                                 update = false
                              end
                           end
                        end
                     )
                     end, prefix
                     )
                  else
                     update = false
                     print('v'..thisScript().version..': ���������� �� ���������.')
                  end
               end
            else
               print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..url)
               sampAddChatMessage(" �� ���� ��������� ����������.", -1)
               update = false
            end
         end
      end
   )
   while update ~= false do wait(100) end
end

function cmd_updat(arg)
   sampShowDialog(1000,'��������������','������� ������ �������: v1.0'.."\nNew ����������"..'\nNewwwwww11111','�������',"", 0)-- body
end

function imgui.OnDrawFrame()
   if main_window_state.v then
      local sw, sh = getScreenResolution()
      imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.SetNextWindowSize(imgui.ImVec2(500, 250), imgui.Cond.FirstUseEver)
      imgui.Begin(u8'Sabiny', main_window_state, imgui.WindowFlags.NoResize)
      if imgui.Button(u8'��� 51', imgui.ImVec2(-0.1, 20))then
         sampSendDialogResponse(557, 1, 1, "� ���� 51 �� ����� �����-����� �������� ����� �����.���� ����")
      end
      imgui.End()
   end
   if two_window_state.v then
      local sw, sh = getScreenResolution()
      imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.SetNextWindowSize(imgui.ImVec2(500, 250), imgui.Cond.FirstUseEver)
      imgui.Begin(u8'test', two_window_state, imgui.WindowFlags.NoResize)
      if imgui.Button(u8'��� 228', imgui.ImVec2(-0.1, 20))then
         -- ��� ����� ����������� ���� ����� ������ ������
      end
      imgui.End()
   end
end