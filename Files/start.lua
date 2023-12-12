Server_Done = io.popen("echo $SSH_CLIENT | awk '{ print $1}'"):read('*a')
redis = dofile("./libs/redis.lua").connect("127.0.0.1", 6379)
serpent = dofile("./libs/serpent.lua")
JSON    = dofile("./libs/dkjson.lua")
json    = dofile("./libs/JSON.lua")
URL     = dofile("./libs/url.lua")
http    = require("socket.http")
https   = require("ssl.https")
-------------------------------------------------------------------
whoami = io.popen("whoami"):read('*a'):gsub('[\n\r]+', '')
uptime=io.popen([[echo `uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"D,",h+0,"H,",m+0,"M."}'`]]):read('*a'):gsub('[\n\r]+', '')
CPUPer=io.popen([[echo `top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`]]):read('*a'):gsub('[\n\r]+', '')
HardDisk=io.popen([[echo `df -lh | awk '{if ($6 == "/") { print $3"/"$2" ( "$5" )" }}'`]]):read('*a'):gsub('[\n\r]+', '')
linux_version=io.popen([[echo `lsb_release -ds`]]):read('*a'):gsub('[\n\r]+', '')
memUsedPrc=io.popen([[echo `free -m | awk 'NR==2{printf "%sMB/%sMB ( %.2f% )\n", $3,$2,$3*100/$2 }'`]]):read('*a'):gsub('[\n\r]+', '')
-------------------------------------------------------------------
Runbot = require('luatele')
-------------------------------------------------------------------
local infofile = io.open("./sudo.lua","r")
if not infofile then
if not redis:get(Server_Done.."token") then
os.execute('sudo rm -rf setup.lua')
io.write('\27[1;31mSend your Bot Token Now\n\27[0;39;49m')
local TokenBot = io.read()
if TokenBot and TokenBot:match('(%d+):(.*)') then
local url , res = https.request("https://api.telegram.org/bot"..TokenBot.."/getMe")
local Json_Info = JSON.decode(url)
if res ~= 200 then
print('\27[1;34mBot Token is Wrong\n')
else
io.write('\27[1;34mThe token been saved successfully \n\27[0;39;49m')
TheTokenBot = TokenBot:match("(%d+)")
os.execute('sudo rm -fr .infoBot/'..TheTokenBot)
redis:setex(Server_Done.."token",300,TokenBot)
end 
else
print('\27[1;34mToken not saved, try again')
end 
os.execute('lua5.3 start.lua')
end
if not redis:get(Server_Done.."id") then
io.write('\27[1;31mSend Developer ID\n\27[0;39;49m')
local UserId = io.read()
if UserId and UserId:match('%d+') then
io.write('\n\27[1;34mDeveloper ID saved \n\n\27[0;39;49m')
redis:setex(Server_Done.."id",300,UserId)
else
print('\n\27[1;34mDeveloper ID not saved\n')
end 
os.execute('lua5.3 start.lua')
end
local url , res = https.request('https://api.telegram.org/bot'..redis:get(Server_Done.."token")..'/getMe')
local Json_Info = JSON.decode(url)
local Inform = io.open("sudo.lua", 'w')
Inform:write([[
return {
	
Token = "]]..redis:get(Server_Done.."token")..[[",

id = ]]..redis:get(Server_Done.."id")..[[

}
]])
Inform:close()
local start = io.open("start", 'w')
start:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
sudo lua5.3 start.lua
done
]])
start:close()
local Run = io.open("Run", 'w')
Run:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
screen -S ]]..Json_Info.result.username..[[ -X kill
screen -S ]]..Json_Info.result.username..[[ ./start
done
]])
Run:close()
redis:del(Server_Done.."id")
redis:del(Server_Done.."token")
os.execute('cp -a ../u/ ../'..Json_Info.result.username..' && rm -fr ~/u')
os.execute('cd && cd '..Json_Info.result.username..';chmod +x start;chmod +x Run;./Run')
end
Information = dofile('./sudo.lua')
sudoid = Information.id
Token = Information.Token
bot_id = Token:match("(%d+)")
os.execute('sudo rm -fr .infoBot/'..bot_id)
bot = Runbot.set_config{
api_id=12221441,
api_hash='9fb5fdf24e25e54b745478b4fb71573b',
session_name=bot_id,
token=Token
}
function coin(coin)
local Coins = tostring(coin)
local Coins = Coins:gsub('٠','0')
local Coins = Coins:gsub('١','1')
local Coins = Coins:gsub('٢','2')
local Coins = Coins:gsub('٣','3')
local Coins = Coins:gsub('٤','4')
local Coins = Coins:gsub('٥','5')
local Coins = Coins:gsub('٦','6')
local Coins = Coins:gsub('٧','7')
local Coins = Coins:gsub('٨','8')
local Coins = Coins:gsub('٩','9')
local Coins = Coins:gsub('-','')
local conis = tonumber(Coins)
return conis
end 
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
namebot = redis:get(bot_id..":namebot") or " ستريم"
SudosS = {5413631898}
Sudos = {sudoid,5413631898}
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function Bot(msg)  
local idbot = false  
if tonumber(msg.sender.user_id) == tonumber(bot_id) then  
idbot = true    
end  
return idbot  
end
function devS(user)  
local idSu = false  
for k,v in pairs(SudosS) do  
if tonumber(user) == tonumber(v) then  
idSu = true    
end
end  
return idSu  
end
function devB(user)  
local idSub = false  
for k,v in pairs(Sudos) do  
if tonumber(user) == tonumber(v) then  
idSub = true    
end
end  
return idSub
end
function programmer(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":Status:programmer",msg.sender.user_id) or devB(msg.sender.user_id) then    
return true  
else  
return false  
end  
end
end
function developer(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":Status:developer",msg.sender.user_id) or programmer(msg) then    
return true  
else  
return false  
end  
end
end
function Creator(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Creator", msg.sender.user_id) or developer(msg) then    
return true  
else  
return false  
end  
end
end
function BasicConstructor(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:BasicConstructor", msg.sender.user_id) or Creator(msg) then    
return true  
else  
return false  
end  
end
end
function Constructor(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Constructor", msg.sender.user_id) or BasicConstructor(msg) then    
return true  
else  
return false  
end  
end
end
function Owner(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Owner", msg.sender.user_id) or Constructor(msg) then    
return true  
else  
return false  
end  
end
end
function Administrator(msg)
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Administrator", msg.sender.user_id) or Owner(msg) then    
return true  
else  
return false  
end  
end
end
function Vips(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Vips", msg.sender.user_id) or Administrator(msg) or Bot(msg) then    
return true  
else  
return false  
end  
end
end
function Get_Rank(user_id,chat_id)
if devS(user_id) then  
var = 'مطور السورس'
elseif devB(user_id) then 
var = "المطور الاساسي"  
elseif redis:sismember(bot_id..":Status:programmer", user_id) then
var = "المطور الثانوي"  
elseif tonumber(user_id) == tonumber(bot_id) then  
var = "البوت"
elseif redis:sismember(bot_id..":Status:developer", user_id) then
var = redis:get(bot_id..":Reply:developer"..chat_id) or "المطور"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", user_id) then
var = redis:get(bot_id..":Reply:Creator"..chat_id) or "المالك"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = redis:get(bot_id..":Reply:BasicConstructor"..chat_id) or "المنشئ الاساسي"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = redis:get(bot_id..":Reply:Constructor"..chat_id) or "المنشئ"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = redis:get(bot_id..":Reply:Owner"..chat_id)  or "المدير"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = redis:get(bot_id..":Reply:Administrator"..chat_id) or "الادمن"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = redis:get(bot_id..":Reply:Vips"..chat_id) or "المميز"  
else  
var = redis:get(bot_id..":Reply:mem"..chat_id) or "العضو"
end  
return var
end 
function Norank(user_id,chat_id)
if devS(user_id) then  
var = false
elseif devB(user_id) then 
var = false
elseif redis:sismember(bot_id..":Status:programmer", user_id) then
var = false
elseif tonumber(user_id) == tonumber(bot_id) then  
var = false
elseif redis:sismember(bot_id..":Status:developer", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = false
else  
var = true
end  
return var
end 
function Isrank(user_id,chat_id)
if devS(user_id) then  
var = false
elseif devB(user_id) then 
var = false
elseif redis:sismember(bot_id..":Status:programmer", user_id) then
var = false
elseif tonumber(user_id) == tonumber(bot_id) then  
var = false
elseif redis:sismember(bot_id..":Status:developer", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = true
else  
var = true
end  
return var
end 
function Total_message(msgs)  
local message = ''  
if tonumber(msgs) < 100 then 
message = 'غير متفاعل' 
elseif tonumber(msgs) < 200 then 
message = 'بده يتحسن' 
elseif tonumber(msgs) < 400 then 
message = 'شبه متفاعل' 
elseif tonumber(msgs) < 700 then 
message = 'متفاعل' 
elseif tonumber(msgs) < 1200 then 
message = 'متفاعل قوي' 
elseif tonumber(msgs) < 2000 then 
message = 'متفاعل جدا' 
elseif tonumber(msgs) < 3500 then 
message = 'اقوى تفاعل'  
elseif tonumber(msgs) < 4000 then 
message = 'متفاعل نار' 
elseif tonumber(msgs) < 4500 then 
message = 'قمة التفاعل' 
elseif tonumber(msgs) < 5500 then 
message = 'اقوى متفاعل' 
elseif tonumber(msgs) < 7000 then 
message = 'ملك التفاعل' 
elseif tonumber(msgs) < 9500 then 
message = 'امبروطور التفاعل' 
elseif tonumber(msgs) < 10000000000 then 
message = 'فول تفاعل'  
end 
return message 
end
function GetBio(User)
local var = "لايوجد"
local url , res = https.request("https://api.telegram.org/bot"..Token.."/getchat?chat_id="..User);
data = json:decode(url)
if data.result.bio then
var = data.result.bio
end
return var
end
function GetInfoBot(msg)
local GetMemberStatus = bot.getChatMember(msg.chat_id,bot_id).status
if GetMemberStatus.can_change_info then
change_info = true else change_info = false
end
if GetMemberStatus.can_delete_messages then
delete_messages = true else delete_messages = false
end
if GetMemberStatus.can_invite_users then
invite_users = true else invite_users = false
end
if GetMemberStatus.can_pin_messages then
pin_messages = true else pin_messages = false
end
if GetMemberStatus.can_restrict_members then
restrict_members = true else restrict_members = false
end
if GetMemberStatus.can_promote_members then
promote = true else promote = false
end
return{
SetAdmin = promote,
BanUser = restrict_members,
Invite = invite_users,
PinMsg = pin_messages,
DelMsg = delete_messages,
Info = change_info
}
end
function GetSetieng(ChatId)
if redis:get(bot_id..":"..ChatId..":settings:".."messageVideo") == "del" then
messageVideo= "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideo") == "ked" then 
messageVideo= "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideo") == "ktm" then 
messageVideo= "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideo") == "kick" then 
messageVideo= "بالطرد "   
else
messageVideo= "❌"   
end   
if redis:get(bot_id..":"..ChatId..":settings:".."messagePhoto") == "del" then
messagePhoto = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePhoto") == "ked" then 
messagePhoto = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePhoto") == "ktm" then 
messagePhoto = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePhoto") == "kick" then 
messagePhoto = "بالطرد "   
else
messagePhoto = "❌"   
end   
if redis:get(bot_id..":"..ChatId..":settings:".."JoinByLink") == "del" then
JoinByLink = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."JoinByLink") == "ked" then 
JoinByLink = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."JoinByLink") == "ktm" then 
JoinByLink = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."JoinByLink") == "kick" then 
JoinByLink = "بالطرد "   
else
JoinByLink = "❌"   
end   
if redis:get(bot_id..":"..ChatId..":settings:".."WordsEnglish") == "del" then
WordsEnglish = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsEnglish") == "ked" then 
WordsEnglish = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsEnglish") == "ktm" then 
WordsEnglish = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsEnglish") == "kick" then 
WordsEnglish = "بالطرد "   
else
WordsEnglish = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."WordsPersian") == "del" then
WordsPersian = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsPersian") == "ked" then 
WordsPersian = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsPersian") == "ktm" then 
WordsPersian = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsPersian") == "kick" then 
WordsPersian = "بالطرد "   
else
WordsPersian = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageVoiceNote") == "del" then
messageVoiceNote = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVoiceNote") == "ked" then 
messageVoiceNote = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVoiceNote") == "ktm" then 
messageVoiceNote = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVoiceNote") == "kick" then 
messageVoiceNote = "بالطرد "   
else
messageVoiceNote = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageSticker") == "del" then
messageSticker= "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSticker") == "ked" then 
messageSticker= "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSticker") == "ktm" then 
messageSticker= "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSticker") == "kick" then 
messageSticker= "بالطرد "   
else
messageSticker= "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."AddMempar") == "del" then
AddMempar = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."AddMempar") == "ked" then 
AddMempar = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."AddMempar") == "ktm" then 
AddMempar = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."AddMempar") == "kick" then 
AddMempar = "بالطرد "   
else
AddMempar = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageAnimation") == "del" then
messageAnimation = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAnimation") == "ked" then 
messageAnimation = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAnimation") == "ktm" then 
messageAnimation = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAnimation") == "kick" then 
messageAnimation = "بالطرد "   
else
messageAnimation = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageDocument") == "del" then
messageDocument= "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageDocument") == "ked" then 
messageDocument= "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageDocument") == "ktm" then 
messageDocument= "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageDocument") == "kick" then 
messageDocument= "بالطرد "   
else
messageDocument= "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageAudio") == "del" then
messageAudio = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAudio") == "ked" then 
messageAudio = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAudio") == "ktm" then 
messageAudio = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAudio") == "kick" then 
messageAudio = "بالطرد "   
else
messageAudio = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messagePoll") == "del" then
messagePoll = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePoll") == "ked" then 
messagePoll = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePoll") == "ktm" then 
messagePoll = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePoll") == "kick" then 
messagePoll = "بالطرد "   
else
messagePoll = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageVideoNote") == "del" then
messageVideoNote = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideoNote") == "ked" then 
messageVideoNote = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideoNote") == "ktm" then 
messageVideoNote = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideoNote") == "kick" then 
messageVideoNote = "بالطرد "   
else
messageVideoNote = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageContact") == "del" then
messageContact = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageContact") == "ked" then 
messageContact = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageContact") == "ktm" then 
messageContact = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageContact") == "kick" then 
messageContact = "بالطرد "   
else
messageContact = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageLocation") == "del" then
messageLocation = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageLocation") == "ked" then 
messageLocation = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageLocation") == "ktm" then 
messageLocation = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageLocation") == "kick" then 
messageLocation = "بالطرد "   
else
messageLocation = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Cmd") == "del" then
Cmd = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Cmd") == "ked" then 
Cmd = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Cmd") == "ktm" then 
Cmd = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Cmd") == "kick" then 
Cmd = "بالطرد "   
else
Cmd = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageSenderChat") == "del" then
messageSenderChat = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSenderChat") == "ked" then 
messageSenderChat = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSenderChat") == "ktm" then 
messageSenderChat = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSenderChat") == "kick" then 
messageSenderChat = "بالطرد "   
else
messageSenderChat = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messagePinMessage") == "del" then
messagePinMessage = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePinMessage") == "ked" then 
messagePinMessage = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePinMessage") == "ktm" then 
messagePinMessage = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePinMessage") == "kick" then 
messagePinMessage = "بالطرد "   
else
messagePinMessage = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Keyboard") == "del" then
Keyboard = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Keyboard") == "ked" then 
Keyboard = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Keyboard") == "ktm" then 
Keyboard = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Keyboard") == "kick" then 
Keyboard = "بالطرد "   
else
Keyboard = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Username") == "del" then
Username = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Username") == "ked" then 
Username = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Username") == "ktm" then 
Username = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Username") == "kick" then 
Username = "بالطرد "   
else
Username = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Tagservr") == "del" then
Tagservr = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Tagservr") == "ked" then 
Tagservr = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Tagservr") == "ktm" then 
Tagservr = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Tagservr") == "kick" then 
Tagservr = "بالطرد "   
else
Tagservr = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."WordsFshar") == "del" then
WordsFshar = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsFshar") == "ked" then 
WordsFshar = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsFshar") == "ktm" then 
WordsFshar = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsFshar") == "kick" then 
WordsFshar = "بالطرد "   
else
WordsFshar = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Markdaun") == "del" then
Markdaun = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Markdaun") == "ked" then 
Markdaun = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Markdaun") == "ktm" then 
Markdaun = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Markdaun") == "kick" then 
Markdaun = "بالطرد "   
else
Markdaun = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Links") == "del" then
Links = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Links") == "ked" then 
Links = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Links") == "ktm" then 
Links = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Links") == "kick" then 
Links = "بالطرد "   
else
Links = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."forward_info") == "del" then
forward_info = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."forward_info") == "ked" then 
forward_info = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."forward_info") == "ktm" then 
forward_info = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."forward_info") == "kick" then 
forward_info = "بالطرد "   
else
forward_info = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageChatAddMembers") == "del" then
messageChatAddMembers = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageChatAddMembers") == "ked" then 
messageChatAddMembers = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageChatAddMembers") == "ktm" then 
messageChatAddMembers = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageChatAddMembers") == "kick" then 
messageChatAddMembers = "بالطرد "   
else
messageChatAddMembers = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."via_bot_user_id") == "del" then
via_bot_user_id = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."via_bot_user_id") == "ked" then 
via_bot_user_id = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."via_bot_user_id") == "ktm" then 
via_bot_user_id = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."via_bot_user_id") == "kick" then 
via_bot_user_id = "بالطرد "   
else
via_bot_user_id = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Hashtak") == "del" then
Hashtak = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Hashtak") == "ked" then 
Hashtak = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Hashtak") == "ktm" then 
Hashtak = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Hashtak") == "kick" then 
Hashtak = "بالطرد "   
else
Hashtak = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Edited") == "del" then
Edited = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Edited") == "ked" then 
Edited = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Edited") == "ktm" then 
Edited = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Edited") == "kick" then 
Edited = "بالطرد "   
else
Edited = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Spam") == "del" then
Spam = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Spam") == "ked" then 
Spam = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Spam") == "ktm" then 
Spam = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Spam") == "kick" then 
Spam = "بالطرد "   
else
Spam = "❌"   
end    
if redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "kick" then 
flood = "بالطرد "   
elseif redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "del" then 
flood = "✔️" 
elseif redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "ked" then
flood = "بالتقييد "   
elseif redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "ktm" then
flood = "بالكتم "    
else
flood = "❌"   
end     
return {
flood = flood,
Spam = Spam,
Edited = Edited,
Hashtak = Hashtak,
messageChatAddMembers = messageChatAddMembers,
via_bot_user_id = via_bot_user_id,
Markdaun = Markdaun,
Links = Links,
forward_info = forward_info ,
Username = Username,
WordsFshar = WordsFshar,
Tagservr = Tagservr,
messagePinMessage = messagePinMessage,
messageSenderChat = messageSenderChat,
Keyboard = Keyboard,
messageLocation = messageLocation,
Cmd = Cmd,
messageContact =messageContact,
messageAudio = messageAudio,
messageVideoNote = messageVideoNote,
messagePoll = messagePoll,
messageDocument= messageDocument,
messageAnimation = messageAnimation,
AddMempar = AddMempar,
messageSticker= messageSticker,
WordsPersian = WordsPersian,
messageVoiceNote = messageVoiceNote,
JoinByLink = JoinByLink,
messagePhoto = messagePhoto,
WordsEnglish = WordsEnglish,
messageVideo= messageVideo
}
end
function Reply_Status(UserId,TextMsg)
UserInfo = bot.getUser(UserId)
Name_User = UserInfo.first_name
if UserInfo.username and UserInfo.username ~= "" then
UserInfousername = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
else
UserInfousername = '['..UserInfo.first_name..'](tg://user?id='..UserId..')'
end
return {
by   = '\n*  ⌔︙بواسطة : *'..UserInfousername..'\n'..TextMsg,
i   = '\n*  ⌔︙المستخدم : *'..UserInfousername..'\n'..TextMsg,
yu    = '\n*  ⌔︙عزيزي : *'..UserInfousername..'\n'..TextMsg
}
end
function getJson(R)  
programmer = redis:smembers(bot_id..":Status:programmer")
developer = redis:smembers(bot_id..":Status:developer")
user_id = redis:smembers(bot_id..":user_id")
chat_idgr = redis:smembers(bot_id..":Groups")
local fresuult = {
programmer = programmer,
developer = developer,
chat_id = chat_idgr,
user_id = user_id, 
bot = bot_id
} 
gresuult = {} 
for k,v in pairs(chat_idgr) do   
Creator = redis:smembers(bot_id..":"..v..":Status:Creator")
if Creator then
cre = {ids = Creator}
end
BasicConstructor = redis:smembers(bot_id..":"..v..":Status:BasicConstructor")
if BasicConstructor then
bc = {ids = BasicConstructor}
end
Constructor = redis:smembers(bot_id..":"..v..":Status:Constructor")
if Constructor then
cr = {ids = Constructor}
end
Owner = redis:smembers(bot_id..":"..v..":Status:Owner")
if Owner then
on = {ids = Owner}
end
Administrator = redis:smembers(bot_id..":"..v..":Status:Administrator")
if Administrator then
ad = {ids = Administrator}
end
Vips = redis:smembers(bot_id..":"..v..":Status:Vips")
if Vips then
vp = {ids = Vips}
end
gresuult[v] = {
BasicConstructor = bc,
Administrator = ad, 
Constructor = cr, 
Creator = cre, 
Owner = on,
Vips = vp
}
end
local resuult = {
bot = fresuult,
groups = gresuult
}
local File = io.open('./'..bot_id..'.json', "w")
File:write(JSON.encode (resuult))
File:close()
bot.sendDocument(R,0,'./'..bot_id..'.json', '  ⌔︙تم جلب النسخة الاحتياطية', 'md')
end
function download(url,name)
if not name then
name = url:match('([^/]+)$')
end
if string.find(url,'https') then
data,res = https.request(url)
elseif string.find(url,'http') then
data,res = http.request(url)
else
return 'The link format is incorrect.'
end
if res ~= 200 then
return 'check url , error code : '..res
else
file = io.open(name,'wb')
file:write(data)
file:close()
return './'..name
end
end
function redis_get(ChatId,tr)
if redis:get(bot_id..":"..ChatId..":settings:"..tr)  then
tf = "✔️" 
else
tf = "❌"   
end    
return tf
end
function Adm_Callback()
if redis:get(bot_id..":Twas") then
Twas = "✅"
else
Twas = "❌"
end
if redis:get(bot_id..":Notice") then
Notice = "✅"
else
Notice = "❌"
end
if redis:get(bot_id..":Departure") then
Departure  = "✅"
else
Departure = "❌"
end
if redis:get(bot_id..":sendbot") then
sendbot  = "✅"
else
sendbot = "❌"
end
if redis:get(bot_id..":infobot") then
infobot  = "✅"
else
infobot = "❌"
end
return {
t   = Twas,
n   = Notice,
d   = Departure,
s   = sendbot,
i    = infobot
}
end
---------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function Callback(data)
----------------------------------------------------------------------------------------------------
Text = bot.base64_decode(data.payload.data)
user_id = data.sender_user_id
chat_id = data.chat_id
msg_id = data.message_id
if Text and Text:match("^mn_(.*)_(.*)") then
local infomsg = {Text:match("^mn_(.*)_(.*)")}
local userid = infomsg[1]
local Type  = infomsg[2]
if tonumber(data.sender_user_id) ~= tonumber(userid) then  
return bot.answerCallbackQuery(data.id," ⌔︙ عذرا الامر لا يخصك ", true)
end
if Type == "st" then  
ty =  "الملصقات الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Sticker"..data.chat_id)  
t = " ⌔︙ قائمة "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id," ⌔︙ قائمة "..ty.." فارغه .", true)
end  
bot.answerCallbackQuery(data.id,"تم مسحها بنجاح", true)
redis:del(bot_id.."mn:content:Sticker"..data.chat_id) 
elseif Type == "tx" then  
ty =  "الكلمات الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Text"..data.chat_id)  
t = " ⌔︙ قائمة "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id," ⌔︙ قائمة "..ty.." فارغه .", true)
end  
bot.answerCallbackQuery(data.id,"تم مسحها بنجاح", true)
redis:del(bot_id.."mn:content:Text"..data.chat_id) 
elseif Type == "gi" then  
 ty =  "المتحركات الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Animation"..data.chat_id)  
t = " ⌔︙ قائمة "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id," ⌔︙ قائمة "..ty.." فارغه .", true)
end  
bot.answerCallbackQuery(data.id,"تم مسحها بنجاح", true)
redis:del(bot_id.."mn:content:Animation"..data.chat_id) 
elseif Type == "ph" then  
ty =  "الصور الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Photo"..data.chat_id) 
t = " ⌔︙ قائمة "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id," ⌔︙ قائمة "..ty.." فارغه .", true)
end  
bot.answerCallbackQuery(data.id,"تم مسحها بنجاح", true)
redis:del(bot_id.."mn:content:Photo"..data.chat_id) 
elseif Type == "up" then  
local Photo =redis:scard(bot_id.."mn:content:Photo"..data.chat_id) 
local Animation =redis:scard(bot_id.."mn:content:Animation"..data.chat_id)  
local Sticker =redis:scard(bot_id.."mn:content:Sticker"..data.chat_id)  
local Text =redis:scard(bot_id.."mn:content:Text"..data.chat_id)  
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = 'الصور الممنوعه', data="mn_"..data.sender_user_id.."_ph"},{text = 'الكلمات الممنوعه', data="mn_"..data.sender_user_id.."_tx"}},
{{text = 'المتحركات الممنوعه', data="mn_"..data.sender_user_id.."_gi"},{text = 'الملصقات الممنوعه',data="mn_"..data.sender_user_id.."_st"}},
{{text = 'تحديث',data="mn_"..data.sender_user_id.."_up"}},
}
}
bot.editMessageText(chat_id,msg_id,"*   ⌔︙تحوي قائمة المنع على\n  ⌔︙الصور ( "..Photo.." )\n  ⌔︙الكلمات ( "..Text.." )\n  ⌔︙الملصقات ( "..Sticker.." )\n  ⌔︙المتحركات ( "..Animation.." )\n  ⌔︙اضغط على القائمة المراد حذفها*", 'md', true, false, reply_markup)
bot.answerCallbackQuery(data.id,"تم تحديث النتائج", true)
end
end
if Text == 'EndAddarray'..user_id then  
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
if redis:get(bot_id..'Set:array'..user_id..':'..chat_id) == 'true1' then
redis:del(bot_id..'Set:array'..user_id..':'..chat_id)
bot.editMessageText(chat_id,msg_id,"*  ⌔︙تم حفظ الردود بنجاح*", 'md', true, false, reply_markup)
else
bot.editMessageText(chat_id,msg_id," *  ⌔︙تم تنفيذ الامر سابقا*", 'md', true, false, reply_markup)
end
end
if Text and Text:match("^Sur_(.*)_(.*)") then
local infomsg = {Text:match("^Sur_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, " ⌔︙ الامر لا يخصك", true)
return false
end   
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
if tonumber(infomsg[2]) == 1 then
if GetInfoBot(data).BanUser == false then
bot.editMessageText(chat_id,msg_id,"*   ⌔︙لا يمتلك البوت صلاحية حظر الاعضاء*", 'md', true, false, reply_markup)
return false
end   
if not Isrank(data.sender_user_id,chat_id) then
t = "*  ⌔︙لا يمكن للبوت حظر "..Get_Rank(data.sender_user_id,chat_id).."*"
else
t = "*  ⌔︙تم طردك بنجاح*"
bot.setChatMemberStatus(chat_id,data.sender_user_id,'banned',0)
end
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_markup)
elseif tonumber(infomsg[2]) == 2 then
bot.editMessageText(chat_id,msg_id,"*  ⌔︙تم الغاء العمليه الطرد بنجاح*", 'md', true, false, reply_markup)
end
end
if Text and Text:match("^Amr_(.*)_(.*)") then
local infomsg = {Text:match("^Amr_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, " ⌔︙ الامر لا يخصك", true)
return false
end   
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "أوامر الحماية" ,data="Amr_"..data.sender_user_id.."_1"},{text = "إعدادات المجموعة",data="Amr_"..data.sender_user_id.."_2"}},
{{text = "فتح/قفل",data="Amr_"..data.sender_user_id.."_3"},{text ="اخرى",data="Amr_"..data.sender_user_id.."_4"}},
{{text = '- الاوامر الرئيسية .',data="Amr_"..data.sender_user_id.."_5"}},
}
}
if infomsg[2] == '1' then
reply_markup = reply_markup
t = "* ⌔︙ اوامر الحماية اتبع مايلي\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙ قفل ، فتح ← الامر\n ⌔︙ تستطيع قفل حماية كما يلي\n ⌔︙ { بالتقييد ، بالطرد ، بالكتم ، بالتقييد }\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙ تاك\n ⌔︙ القناة\n ⌔︙ الصور\n ⌔︙ الرابط\n ⌔︙ السب\n ⌔︙ الموقع\n ⌔︙ التكرار\n ⌔︙ الفيديو\n ⌔︙ الدخول\n ⌔︙ الاضافة\n ⌔︙ الاغاني\n ⌔︙ الصوت\n ⌔︙ الملفات\n ⌔︙ المنشورات\n ⌔︙ الدردشة\n ⌔︙ الجهات\n ⌔︙ السيلفي\n ⌔︙ التثبيت\n ⌔︙ الشارحة\n ⌔︙ الرسائل\n ⌔︙ البوتات\n ⌔︙ التوجيه\n ⌔︙ التعديل\n ⌔︙ الانلاين\n ⌔︙ المعرفات\n ⌔︙ الكيبورد\n ⌔︙ الفارسية\n ⌔︙ الانجليزية\n ⌔︙ الاستفتاء\n ⌔︙ الملصقات\n ⌔︙ الاشعارات\n ⌔︙ الماركداون\n ⌔︙ المتحركات*"
elseif infomsg[2] == '2' then
reply_markup = reply_markup
t = "* ⌔︙ اعدادات المجموعة \n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙  الترحيب  \n ⌔︙  مسح الرتب  \n ⌔︙  الغاء التثبيت  \n ⌔︙  فحص البوت  \n ⌔︙  تعين الرابط  \n ⌔︙  مسح الرابط  \n ⌔︙  تغيير الايدي  \n ⌔︙  تعين الايدي  \n ⌔︙  مسح الايدي  \n ⌔︙  مسح الترحيب  \n ⌔︙  صورتي  \n ⌔︙  تغيير اسم المجموعة  \n ⌔︙  تعين قوانين  \n ⌔︙  تغيير الوصف  \n ⌔︙  مسح القوانين  \n ⌔︙  مسح الرابط  \n ⌔︙  تنظيف التعديل  \n ⌔︙  تنظيف الميديا  \n ⌔︙  مسح الرابط  \n ⌔︙  رفع الادامن  \n ⌔︙  تعين ترحيب  \n ⌔︙  الترحيب  \n ⌔︙  الالعاب الاحترافية  \n ⌔︙  المجموعة  *"
elseif infomsg[2] == '3' then
reply_markup = reply_markup
t = "* ⌔︙ اوامر التفعيل والتعطيل \n ⌔︙ تفعيل/تعطيل الامر اسفل  \n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙  اوامر التسلية  \n ⌔︙  الالعاب الاحترافية  \n ⌔︙  الطرد  \n ⌔︙  الحظر  \n ⌔︙  الرفع  \n ⌔︙  المميزات  \n ⌔︙  المسح التلقائي  \n ⌔︙  ٴall  \n ⌔︙  منو ضافني  \n ⌔︙  تفعيل الردود  \n ⌔︙  الايدي بالصورة  \n ⌔︙  الايدي  \n ⌔︙  التنظيف  \n ⌔︙  الترحيب  \n ⌔︙  الرابط  \n ⌔︙  البايو  \n ⌔︙  صورتي  \n ⌔︙  الالعاب  *"
elseif infomsg[2] == '4' then
reply_markup = reply_markup
t = "* ⌔︙ اوامر اخرى \n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙ الالعاب الاحترافية \n ⌔︙ المجموعة \n ⌔︙ الرابط \n ⌔︙ اسمي \n ⌔︙ ايديي \n ⌔︙ مسح نقاطي \n ⌔︙ نقاطي \n ⌔︙ مسح رسائلي \n ⌔︙ رسائلي \n ⌔︙ مسح جهاتي \n ⌔︙ مسح بالرد  \n ⌔︙ تفاعلي \n ⌔︙ جهاتي \n ⌔︙ مسح تعديلاتي \n ⌔︙ تعديلاتي \n ⌔︙ رتبتي \n ⌔︙ معلوماتي \n ⌔︙ المنشئ \n ⌔︙ رفع المنشئ \n ⌔︙ البايو/نبذتي \n ⌔︙ التاريخ/الساعة \n ⌔︙ رابط الحذف \n ⌔︙ الالعاب \n ⌔︙ منع بالرد \n ⌔︙ منع \n ⌔︙ تنظيف + عدد \n ⌔︙ قائمة المنع \n ⌔︙ مسح قائمة المنع \n ⌔︙ مسح الاوامر المضافة \n ⌔︙ الاوامر المضافة \n ⌔︙ ترتيب الاوامر \n ⌔︙ اضف امر \n ⌔︙ حذف امر \n ⌔︙ اضف رد \n ⌔︙ حذف رد \n ⌔︙ ردود المدير \n ⌔︙ مسح ردود المدير \n ⌔︙ الردود المتعددة \n ⌔︙ مسح الردود المتعددة \n ⌔︙ وضع عدد المسح +رقم \n ⌔︙ مسح البوتات \n ⌔︙ ٴall \n ⌔︙ غنيلي، فلم، متحركة، رمزية، فيديو \n ⌔︙ تغير رد {العضو. المميز. الادمن. المدير. المنشئ. المنشئ الاساسي. المالك. المطور }  \n ⌔︙ حذف رد {العضو. المميز. الادمن. المدير. المنشئ. المنشئ الاساسي. المالك. المطور}  *"
elseif infomsg[2] == '5' then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "أوامر الحماية" ,data="Amr_"..data.sender_user_id.."_1"},{text = "إعدادات المجموعة",data="Amr_"..data.sender_user_id.."_2"}},
{{text = "فتح/قفل",data="Amr_"..data.sender_user_id.."_3"},{text ="اخرى",data="Amr_"..data.sender_user_id.."_4"}},
{{text = '𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆.',url="t.me/xXStrem"}},
}
}
t = "*  ⌔︙قائمة الاوامر \n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n  ⌔︙م1 ( اوامر الحماية ) \n  ⌔︙م2 ( اوامر إعدادات المجموعة ) \n  ⌔︙م3 ( اوامر القفل والفتح ) \n  ⌔︙م4 ( اوامر اخرى ) *"
end
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_markup)
end
----------------------------------------------------------------------------------------------------
if Text and Text:match("^GetSeBk_(.*)_(.*)") then
local infomsg = {Text:match("^GetSeBk_(.*)_(.*)")}
num = tonumber(infomsg[1])
any = tonumber(infomsg[2])
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, " ⌔︙ الامر لا يخصك", true)
return false
end  
if any == 0 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الكيبورد'" ,data="GetSe_"..user_id.."_Keyboard"},{text = GetSetieng(chat_id).Keyboard ,data="GetSe_"..user_id.."_Keyboard"}},
{{text = "'الملصقات'" ,data="GetSe_"..user_id.."_messageSticker"},{text =GetSetieng(chat_id).messageSticker,data="GetSe_"..user_id.."_messageSticker"}},
{{text = "'الاغاني'" ,data="GetSe_"..user_id.."_messageVoiceNote"},{text =GetSetieng(chat_id).messageVoiceNote,data="GetSe_"..user_id.."_messageVoiceNote"}},
{{text = "'الانجليزي'" ,data="GetSe_"..user_id.."_WordsEnglish"},{text =GetSetieng(chat_id).WordsEnglish,data="GetSe_"..user_id.."_WordsEnglish"}},
{{text = "'الفارسية'" ,data="GetSe_"..user_id.."_WordsPersian"},{text =GetSetieng(chat_id).WordsPersian,data="GetSe_"..user_id.."_WordsPersian"}},
{{text = "'الدخول'" ,data="GetSe_"..user_id.."_JoinByLink"},{text =GetSetieng(chat_id).JoinByLink,data="GetSe_"..user_id.."_JoinByLink"}},
{{text = "'الصور'" ,data="GetSe_"..user_id.."_messagePhoto"},{text =GetSetieng(chat_id).messagePhoto,data="GetSe_"..user_id.."_messagePhoto"}},
{{text = "'الفيديو'" ,data="GetSe_"..user_id.."_messageVideo"},{text =GetSetieng(chat_id).messageVideo,data="GetSe_"..user_id.."_messageVideo"}},
{{text = "'الجهات'" ,data="GetSe_"..user_id.."_messageContact"},{text =GetSetieng(chat_id).messageContact,data="GetSe_"..user_id.."_messageContact"}},
{{text = "'السيلفي'" ,data="GetSe_"..user_id.."_messageVideoNote"},{text =GetSetieng(chat_id).messageVideoNote,data="GetSe_"..user_id.."_messageVideoNote"}},
{{text = "'➡️'" ,data="GetSeBk_"..user_id.."_1"}},
}
}
elseif any == 1 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الاستفتاء'" ,data="GetSe_"..user_id.."_messagePoll"},{text =GetSetieng(chat_id).messagePoll,data="GetSe_"..user_id.."_messagePoll"}},
{{text = "'الصوت'" ,data="GetSe_"..user_id.."_messageAudio"},{text =GetSetieng(chat_id).messageAudio,data="GetSe_"..user_id.."_messageAudio"}},
{{text = "'الملفات'" ,data="GetSe_"..user_id.."_messageDocument"},{text =GetSetieng(chat_id).messageDocument,data="GetSe_"..user_id.."_messageDocument"}},
{{text = "'المتحركات'" ,data="GetSe_"..user_id.."_messageAnimation"},{text =GetSetieng(chat_id).messageAnimation,data="GetSe_"..user_id.."_messageAnimation"}},
{{text = "'الاضافة'" ,data="GetSe_"..user_id.."_AddMempar"},{text =GetSetieng(chat_id).AddMempar,data="GetSe_"..user_id.."_AddMempar"}},
{{text = "'التثبيت'" ,data="GetSe_"..user_id.."_messagePinMessage"},{text =GetSetieng(chat_id).messagePinMessage,data="GetSe_"..user_id.."_messagePinMessage"}},
{{text = "'القناة'" ,data="GetSe_"..user_id.."_messageSenderChat"},{text = GetSetieng(chat_id).messageSenderChat ,data="GetSe_"..user_id.."_messageSenderChat"}},
{{text = "'الشارحة'" ,data="GetSe_"..user_id.."_Cmd"},{text =GetSetieng(chat_id).Cmd,data="GetSe_"..user_id.."_Cmd"}},
{{text = "'الموقع'" ,data="GetSe_"..user_id.."_messageLocation"},{text = GetSetieng(chat_id).messageLocation ,data="GetSe_"..user_id.."_messageLocation"}},
{{text = "'التكرار'" ,data="GetSe_"..user_id.."_flood"},{text = GetSetieng(chat_id).flood ,data="GetSe_"..user_id.."_flood"}},
{{text = "'⬅️'" ,data="GetSeBk_"..user_id.."_0"},{text = "'➡️'" ,data="GetSeBk_"..user_id.."_2"}},
}
}
elseif any == 2 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'المنشورات'" ,data="GetSe_"..user_id.."_Spam"},{text =GetSetieng(chat_id).Spam,data="GetSe_"..user_id.."_Spam"}},
{{text = "'التعديل'" ,data="GetSe_"..user_id.."_Edited"},{text = GetSetieng(chat_id).Edited ,data="GetSe_"..user_id.."_Edited"}},
{{text = "'التاك'" ,data="GetSe_"..user_id.."_Hashtak"},{text =GetSetieng(chat_id).Hashtak,data="GetSe_"..user_id.."_Hashtak"}},
{{text = "'الانلاين'" ,data="GetSe_"..user_id.."_via_bot_user_id"},{text = GetSetieng(chat_id).via_bot_user_id ,data="GetSe_"..user_id.."_via_bot_user_id"}},
{{text = "'البوتات'" ,data="GetSe_"..user_id.."_messageChatAddMembers"},{text =GetSetieng(chat_id).messageChatAddMembers,data="GetSe_"..user_id.."_messageChatAddMembers"}},
{{text = "'التوجيه'" ,data="GetSe_"..user_id.."_forward_info"},{text = GetSetieng(chat_id).forward_info ,data="GetSe_"..user_id.."_forward_info"}},
{{text = "'الروابط'" ,data="GetSe_"..user_id.."_Links"},{text =GetSetieng(chat_id).Links,data="GetSe_"..user_id.."_Links"}},
{{text = "'الماركداون'" ,data="GetSe_"..user_id.."_Markdaun"},{text = GetSetieng(chat_id).Markdaun ,data="GetSe_"..user_id.."_Markdaun"}},
{{text = "'السب'" ,data="GetSe_"..user_id.."_WordsFshar"},{text =GetSetieng(chat_id).WordsFshar,data="GetSe_"..user_id.."_WordsFshar"}},
{{text = "'الاشعارات'" ,data="GetSe_"..user_id.."_Tagservr"},{text = GetSetieng(chat_id).Tagservr ,data="GetSe_"..user_id.."_Tagservr"}},
{{text = "'المعرفات'" ,data="GetSe_"..user_id.."_Username"},{text =GetSetieng(chat_id).Username,data="GetSe_"..user_id.."_Username"}},
{{text = "'⬅️'" ,data="GetSeBk_"..user_id.."_1"},{text = "'أوامر التفعيل'" ,data="GetSeBk_"..user_id.."_3"}},
}
}
elseif any == 3 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'اطردني'" ,data="GetSe_"..user_id.."_kickme"},{text =redis_get(chat_id,"kickme"),data="GetSe_"..user_id.."_kickme"}},
{{text = "'البايو'" ,data="GetSe_"..user_id.."_GetBio"},{text =redis_get(chat_id,"GetBio"),data="GetSe_"..user_id.."_GetBio"}},
{{text = "'الرابط'" ,data="GetSe_"..user_id.."_link"},{text =redis_get(chat_id,"link"),data="GetSe_"..user_id.."_link"}},
{{text = "'الترحيب'" ,data="GetSe_"..user_id.."_Welcome"},{text =redis_get(chat_id,"Welcome"),data="GetSe_"..user_id.."_Welcome"}},
{{text = "'الايدي'" ,data="GetSe_"..user_id.."_id"},{text =redis_get(chat_id,"id"),data="GetSe_"..user_id.."_id"}},
{{text = "'الايدي بالصورة'" ,data="GetSe_"..user_id.."_id:ph"},{text =redis_get(chat_id,"id:ph"),data="GetSe_"..user_id.."_id:ph"}},
{{text = "'التنظيف'" ,data="GetSe_"..user_id.."_delmsg"},{text =redis_get(chat_id,"delmsg"),data="GetSe_"..user_id.."_delmsg"}},
{{text = "'التسلية'" ,data="GetSe_"..user_id.."_entertainment"},{text =redis_get(chat_id,"entertainment"),data="GetSe_"..user_id.."_entertainment"}},
{{text = "'الالعاب الاحترافية'" ,data="GetSe_"..user_id.."_gameVip"},{text =redis_get(chat_id,"gameVip"),data="GetSe_"..user_id.."_gameVip"}},
{{text = "'ضافني'" ,data="GetSe_"..user_id.."_addme"},{text =redis_get(chat_id,"addme"),data="GetSe_"..user_id.."_addme"}},
{{text = "'الردود'" ,data="GetSe_"..user_id.."_Reply"},{text =redis_get(chat_id,"Reply"),data="GetSe_"..user_id.."_Reply"}},
{{text = "'الالعاب'" ,data="GetSe_"..user_id.."_game"},{text =redis_get(chat_id,"game"),data="GetSe_"..user_id.."_game"}},
{{text = "'صورتي'" ,data="GetSe_"..user_id.."_phme"},{text =redis_get(chat_id,"phme"),data="GetSe_"..user_id.."_phme"}},
{{text = "'⬅️'" ,data="GetSeBk_"..user_id.."_2"}}
}
}
end
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اعدادات المجموعة *", 'md', true, false, reply_markup)
end
if Text and Text:match("^GetSe_(.*)_(.*)") then
local infomsg = {Text:match("^GetSe_(.*)_(.*)")}
ifd = infomsg[1]
Amr = infomsg[2]
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, " ⌔︙ الامر لا يخصك", true)
return false
end  
if not redis:get(bot_id..":"..chat_id..":settings:"..Amr) then
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"del")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "del" then 
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"ktm")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "ktm" then 
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"ked")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "ked" then 
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"kick")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "kick" then 
redis:del(bot_id..":"..chat_id..":settings:"..Amr)    
end   
if Amr == "messageVideoNote" or Amr == "messageVoiceNote" or Amr == "messageSticker" or Amr == "Keyboard" or Amr == "JoinByLink" or Amr == "WordsPersian" or Amr == "WordsEnglish" or Amr == "messageContact" or Amr == "messageVideo" or Amr == "messagePhoto" then 
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الكيبورد'" ,data="GetSe_"..user_id.."_Keyboard"},{text = GetSetieng(chat_id).Keyboard ,data="GetSe_"..user_id.."_Keyboard"}},
{{text = "'الملصقات'" ,data="GetSe_"..user_id.."_messageSticker"},{text =GetSetieng(chat_id).messageSticker,data="GetSe_"..user_id.."_messageSticker"}},
{{text = "'الاغاني'" ,data="GetSe_"..user_id.."_messageVoiceNote"},{text =GetSetieng(chat_id).messageVoiceNote,data="GetSe_"..user_id.."_messageVoiceNote"}},
{{text = "'الانجليزي'" ,data="GetSe_"..user_id.."_WordsEnglish"},{text =GetSetieng(chat_id).WordsEnglish,data="GetSe_"..user_id.."_WordsEnglish"}},
{{text = "'الفارسية'" ,data="GetSe_"..user_id.."_WordsPersian"},{text =GetSetieng(chat_id).WordsPersian,data="GetSe_"..user_id.."_WordsPersian"}},
{{text = "'الدخول'" ,data="GetSe_"..user_id.."_JoinByLink"},{text =GetSetieng(chat_id).JoinByLink,data="GetSe_"..user_id.."_JoinByLink"}},
{{text = "'الصور'" ,data="GetSe_"..user_id.."_messagePhoto"},{text =GetSetieng(chat_id).messagePhoto,data="GetSe_"..user_id.."_messagePhoto"}},
{{text = "'الفيديو'" ,data="GetSe_"..user_id.."_messageVideo"},{text =GetSetieng(chat_id).messageVideo,data="GetSe_"..user_id.."_messageVideo"}},
{{text = "'الجهات'" ,data="GetSe_"..user_id.."_messageContact"},{text =GetSetieng(chat_id).messageContact,data="GetSe_"..user_id.."_messageContact"}},
{{text = "'السيلفي'" ,data="GetSe_"..user_id.."_messageVideoNote"},{text =GetSetieng(chat_id).messageVideoNote,data="GetSe_"..user_id.."_messageVideoNote"}},
{{text = "'➡️'" ,data="GetSeBk_"..user_id.."_1"}},
}
}
elseif Amr == "messagePoll" or Amr == "messageAudio" or Amr == "messageDocument" or Amr == "messageAnimation" or Amr == "AddMempar" or Amr == "messagePinMessage" or Amr == "messageSenderChat" or Amr == "Cmd" or Amr == "messageLocation" or Amr == "flood" then 
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الاستفتاء'" ,data="GetSe_"..user_id.."_messagePoll"},{text =GetSetieng(chat_id).messagePoll,data="GetSe_"..user_id.."_messagePoll"}},
{{text = "'الصوت'" ,data="GetSe_"..user_id.."_messageAudio"},{text =GetSetieng(chat_id).messageAudio,data="GetSe_"..user_id.."_messageAudio"}},
{{text = "'الملفات'" ,data="GetSe_"..user_id.."_messageDocument"},{text =GetSetieng(chat_id).messageDocument,data="GetSe_"..user_id.."_messageDocument"}},
{{text = "'المتحركات'" ,data="GetSe_"..user_id.."_messageAnimation"},{text =GetSetieng(chat_id).messageAnimation,data="GetSe_"..user_id.."_messageAnimation"}},
{{text = "'الاضافة'" ,data="GetSe_"..user_id.."_AddMempar"},{text =GetSetieng(chat_id).AddMempar,data="GetSe_"..user_id.."_AddMempar"}},
{{text = "'التثبيت'" ,data="GetSe_"..user_id.."_messagePinMessage"},{text =GetSetieng(chat_id).messagePinMessage,data="GetSe_"..user_id.."_messagePinMessage"}},
{{text = "'القناة'" ,data="GetSe_"..user_id.."_messageSenderChat"},{text = GetSetieng(chat_id).messageSenderChat ,data="GetSe_"..user_id.."_messageSenderChat"}},
{{text = "'الشارحة'" ,data="GetSe_"..user_id.."_Cmd"},{text =GetSetieng(chat_id).Cmd,data="GetSe_"..user_id.."_Cmd"}},
{{text = "'الموقع'" ,data="GetSe_"..user_id.."_messageLocation"},{text = GetSetieng(chat_id).messageLocation ,data="GetSe_"..user_id.."_messageLocation"}},
{{text = "'التكرار'" ,data="GetSe_"..user_id.."_flood"},{text = GetSetieng(chat_id).flood ,data="GetSe_"..user_id.."_flood"}},
{{text = "'⬅️'" ,data="GetSeBk_"..user_id.."_0"},{text = "'➡️'" ,data="GetSeBk_"..user_id.."_2"}},
}
}
elseif Amr == "Edited" or Amr == "Spam" or Amr == "Hashtak" or Amr == "via_bot_user_id" or Amr == "forward_info" or Amr == "messageChatAddMembers" or Amr == "Links" or Amr == "Markdaun" or Amr == "Username" or Amr == "Tagservr" or Amr == "WordsFshar" then  
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'المنشورات'" ,data="GetSe_"..user_id.."_Spam"},{text =GetSetieng(chat_id).Spam,data="GetSe_"..user_id.."_Spam"}},
{{text = "'التعديل'" ,data="GetSe_"..user_id.."_Edited"},{text = GetSetieng(chat_id).Edited ,data="GetSe_"..user_id.."_Edited"}},
{{text = "'التاك'" ,data="GetSe_"..user_id.."_Hashtak"},{text =GetSetieng(chat_id).Hashtak,data="GetSe_"..user_id.."_Hashtak"}},
{{text = "'الانلاين'" ,data="GetSe_"..user_id.."_via_bot_user_id"},{text = GetSetieng(chat_id).via_bot_user_id ,data="GetSe_"..user_id.."_via_bot_user_id"}},
{{text = "'البوتات'" ,data="GetSe_"..user_id.."_messageChatAddMembers"},{text =GetSetieng(chat_id).messageChatAddMembers,data="GetSe_"..user_id.."_messageChatAddMembers"}},
{{text = "'التوجيه'" ,data="GetSe_"..user_id.."_forward_info"},{text = GetSetieng(chat_id).forward_info ,data="GetSe_"..user_id.."_forward_info"}},
{{text = "'الروابط'" ,data="GetSe_"..user_id.."_Links"},{text =GetSetieng(chat_id).Links,data="GetSe_"..user_id.."_Links"}},
{{text = "'الماركداون'" ,data="GetSe_"..user_id.."_Markdaun"},{text = GetSetieng(chat_id).Markdaun ,data="GetSe_"..user_id.."_Markdaun"}},
{{text = "'السب'" ,data="GetSe_"..user_id.."_WordsFshar"},{text =GetSetieng(chat_id).WordsFshar,data="GetSe_"..user_id.."_WordsFshar"}},
{{text = "'الاشعارات'" ,data="GetSe_"..user_id.."_Tagservr"},{text = GetSetieng(chat_id).Tagservr ,data="GetSe_"..user_id.."_Tagservr"}},
{{text = "'المعرفات'" ,data="GetSe_"..user_id.."_Username"},{text =GetSetieng(chat_id).Username,data="GetSe_"..user_id.."_Username"}},
{{text = "'⬅️'" ,data="GetSeBk_"..user_id.."_2"},{text = "'أوامر التفعيل'" ,data="GetSeBk_"..user_id.."_3"}},
}
}
end
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اعدادات المجموعة *", 'md', true, false, reply_markup)
end
---
if devB(data.sender_user_id) then
if Text == "Can" then
redis:del(bot_id..":set:"..chat_id..":UpfJson") 
redis:del(bot_id..":set:"..chat_id..":send") 
redis:del(bot_id..":set:"..chat_id..":dev") 
redis:del(bot_id..":set:"..chat_id..":namebot") 
redis:del(bot_id..":set:"..chat_id..":start") 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "UpfJson" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙قم بأعاده ارسال الملف الخاص بالنسخة*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":UpfJson",true) 
end
if Text == "GetfJson" then
bot.answerCallbackQuery(data.id, "  ⌔︙جار ارسال النسخة", true)
getJson(chat_id)
dofile("start.lua")
end
if Text == "Delch" then
if not redis:get(bot_id..":TheCh") then
bot.answerCallbackQuery(data.id, "  ⌔︙لم يتم وضع اشتراك في البوت", true)
return false
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙تم حذف البوت بنجاح*", 'md', true, false, reply_markup)
redis:del(bot_id..":TheCh")
end
if Text == "addCh" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙قم برفع البوت ادمن في قناتك ثم قم بأرسل توجيه من القناة الى البوت*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":addCh",true)
end
if Text == 'TheCh' then
if not redis:get(bot_id..":TheCh") then
bot.answerCallbackQuery(data.id, "  ⌔︙لم يتم وضع اشتراك في البوت", true)
return false
end
idD = redis:get(bot_id..":TheCh")
Get_Chat = bot.getChat(idD)
Info_Chats = bot.getSupergroupFullInfo(idD)
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = Get_Chat.title,url=Info_Chats.invite_link.invite_link}},
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙الاشتراك الاجباري على القناة اسفل :*", 'md', true, false, reply_dev)
end
if Text == "indfo" then
Groups = redis:scard(bot_id..":Groups")   
user_id = redis:scard(bot_id..":user_id") 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اهلا بك في قسم الاحصائيات \n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n  ⌔︙عدد المشتركين ( "..user_id.." ) عضو \n  ⌔︙عدد المجموعات ( "..Groups.." ) مجموعة *", 'md', true, false, reply_dev)
end
if Text == "chatmem" then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ اضف اشتراك',data="addCh"},{text =" ⌔︙ حذف اشتراك",data="Delch"}},
{{text = ' ⌔︙ الاشتراك',data="TheCh"}},
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اهلا بك في لوحه اوامر الاشتراك الاجباري*", 'md', true, false, reply_dev)
end
if Text == "EditDevbot" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙قم الان بأرسل ايدي المطور الجديد*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":dev",true) 
end
if Text == "addstarttxt" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙قم الان بأرسل رسالة ستارت الجديده*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":start",true) 
end
if Text == 'lsbnal' then
t = '\n* ⌔︙ قائمة محظورين عام  \n ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":bot:Ban") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, " ⌔︙ لا يوجد محظورين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == 'lsmu' then
t = '\n* ⌔︙ قائمة المكتومين عام  \n  ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":bot:silent") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, " ⌔︙ لا يوجد مكتومين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == "delbnal" then
local Info_ = redis:smembers(bot_id..":bot:Ban")
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, " ⌔︙ لا يوجد محظورين في البوت", true)
return false
end  
redis:del(bot_id..":bot:Ban")
bot.answerCallbackQuery(data.id, " ⌔︙ تم مسح المحظورين بنجاح", true)
end
if Text == "delmu" then
local Info_ = redis:smembers(bot_id..":bot:silent")
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, " ⌔︙ لا يوجد مكتومين في البوت ", true)
return false
end  
redis:del(bot_id..":bot:silent")
bot.answerCallbackQuery(data.id, " ⌔︙ تم مسح المكتومين بنجاح", true)
end
if Text == 'lspor' then
t = '\n* ⌔︙ قائمة الثانويين  \n  ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, " ⌔︙ لا يوجد ثانويين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == 'lsdev' then
t = '\n* ⌔︙ قائمة المطورين  \n  ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, " ⌔︙ لا يوجد مطورين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == "UpSu" then
bot.answerCallbackQuery(data.id, " ⌔︙ تم تحديث السورس", true)
os.execute('rm -rf start.lua')
os.execute('curl -s https://raw.githubusercontent.com/xXStrem/BoT/main/start.lua -o start.lua')
dofile('start.lua')  
end
if Text == "UpBot" then
bot.answerCallbackQuery(data.id, " ⌔︙ تم تحديث البوت", true)
dofile("start.lua")
end
if Text == "Deltxtstart" then
redis:del(bot_id..":start") 
bot.answerCallbackQuery(data.id, "- تم حذف رسالة ستارت بنجاح .", true)
end
if Text == "delnamebot" then
redis:del(bot_id..":namebot") 
bot.answerCallbackQuery(data.id, " ⌔︙ تم حذف اسم البوت بنجاح", true)
end
if Text == "infobot" then
if redis:get(bot_id..":infobot") then
redis:del(bot_id..":infobot")
else
redis:set(bot_id..":infobot",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "Twas" then
if redis:get(bot_id..":Twas") then
redis:del(bot_id..":Twas")
else
redis:set(bot_id..":Twas",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "Notice" then
if redis:get(bot_id..":Notice") then
redis:del(bot_id..":Notice")
else
redis:set(bot_id..":Notice",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "sendbot" then
if redis:get(bot_id..":sendbot") then
redis:del(bot_id..":sendbot")
else
redis:set(bot_id..":sendbot",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "Departure" then
if redis:get(bot_id..":Departure") then
redis:del(bot_id..":Departure")
else
redis:set(bot_id..":Departure",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "namebot" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙قم الان بأرسل اسم البوت الجديد*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":namebot",true) 
end
if Text == "delpor" then
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, " ⌔︙ لا يوجد ثانويين في البوت", true)
return false
end
redis:del(bot_id..":Status:programmer") 
bot.answerCallbackQuery(data.id, " ⌔︙ تم مسح الثانويين بنجاح", true)
end
if Text == "deldev" then
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, " ⌔︙ لا يوجد مطورين في البوت", true)
return false
end
redis:del(bot_id..":Status:developer") 
bot.answerCallbackQuery(data.id, " ⌔︙ تم مسح المطورين بنجاح", true)
end
if Text == "clenMsh" then
local list = redis:smembers(bot_id..":user_id")   
local x = 0
for k,v in pairs(list) do  
local Get_Chat = bot.getChat(v)
local ChatAction = bot.sendChatAction(v,'Typing')
if ChatAction.luatele ~= "ok" then
x = x + 1
redis:srem(bot_id..":user_id",v)
end
end
if x ~= 0 then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
return bot.editMessageText(chat_id,msg_id,'*  ⌔︙العدد الكلي ( '..#list..' )\n  ⌔︙تم العثور على ( '..x..' ) من المشتركين الوهميين*', 'md', true, false, reply_dev)
else
return bot.editMessageText(chat_id,msg_id,'*  ⌔︙العدد الكلي ( '..#list.." )\n  ⌔︙لم يتم العثور على وهميين*", 'md', true, false, reply_dev)
end
end
if Text == "clenMg" then
local list = redis:smembers(bot_id..":Groups")   
local x = 0
for k,v in pairs(list) do  
local Get_Chat = bot.getChat(v)
if Get_Chat.id then
local statusMem = bot.getChatMember(Get_Chat.id,bot_id)
if statusMem.status.luatele == "chatMemberStatusMember" then
x = x + 1
bot.sendText(Get_Chat.id,0,'*  ⌔︙البوت ليس ادمن في المجموعة*',"md")
redis:srem(bot_id..":Groups",Get_Chat.id)
local keys = redis:keys(bot_id..'*'..Get_Chat.id)
for i = 1, #keys do
redis:del(keys[i])
end
bot.leaveChat(Get_Chat.id)
end
else
x = x + 1
local keys = redis:keys(bot_id..'*'..v)
for i = 1, #keys do
redis:del(keys[i])
end
redis:srem(bot_id..":Groups",v)
bot.leaveChat(v)
end
end
if x ~= 0 then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
return bot.editMessageText(chat_id,msg_id,'*  ⌔︙العدد الكلي ( '..#list..' )\n  ⌔︙تم العثور على ( '..x..' ) من المجموعات الوهمية*', 'md', true, false, reply_dev)
else
return bot.editMessageText(chat_id,msg_id,'*  ⌔︙العدد الكلي ( '..#list.." )\n  ⌔︙لم يتم العثور على مجموعات وهمية*", 'md', true, false, reply_dev)
end
end
if Text == "sendtomem" then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ رسالة للكل',data="AtSer_Tall"},{text =" ⌔︙ توجيه للكل",data="AtSer_Fall"}},
{{text = ' ⌔︙ رسالة للمجموعات',data="AtSer_Tgr"},{text =" ⌔︙ توجيه للمجموعات",data="AtSer_Fgr"}},
{{text = ' ⌔︙ رسالة للاعضاء',data="AtSer_Tme"},{text =" ⌔︙ توجيه للاعضاء",data="AtSer_Fme"}},
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اوامر الاذاعة الخاصه بالبوت*", 'md', true, false, reply_dev)
end
if Text and Text:match("^AtSer_(.*)") then
local infomsg = {Text:match("^AtSer_(.*)")}
iny = infomsg[1]
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ الغاء',data="Can"}},
}
}
redis:setex(bot_id..":set:"..chat_id..":send",600,iny)  
bot.editMessageText(chat_id,msg_id,"*  ⌔︙قم الان بأرسال الرسالة *", 'md', true, false, reply_markup)
end
----------------------------------------------------------------------------------------------------
end
end
----------------------------------------------------------------------------------------------------
-- end function Callback
----------------------------------------------------------------------------------------------------
function Run(msg,data)
if msg.content.text then
text = msg.content.text.text
else 
text = nil
end
----------------------------------------------------------------------------------------------------
if devB(msg.sender.user_id) then
if redis:get(bot_id..":set:"..msg.chat_id..":send") then
TrS = redis:get(bot_id..":set:"..msg.chat_id..":send")
list = redis:smembers(bot_id..":Groups")   
lis = redis:smembers(bot_id..":user_id") 
if msg.forward_info or text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then 
redis:del(bot_id..":set:"..msg.chat_id..":send") 
if TrS == "Fall" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙يتم توجيه الرسالة الى ( "..#lis.." عضو ) و ( "..#list.." مجموعة ) *","md",true)      
for k,v in pairs(list) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعة ل ( "..redis:get(bot_id..":count:true").." ) مجموعة جار الاذاعة للاعضاء *","md",true)
redis:del(bot_id..":count:true") 
for k,g in pairs(lis) do  
local FedMsg = bot.forwardMessages(g, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعة ل ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Fgr" then
bot.sendText(msg.chat_id,msg.id,"*- يتم توجيه الرسالة الى ( "..#list.." مجموعة ) *","md",true)      
for k,v in pairs(list) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعة ل ( "..redis:get(bot_id..":count:true").." ) مجموعة *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Fme" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙يتم توجيه الرسالة الى ( "..#lis.." عضو ) *","md",true)      
for k,v in pairs(lis) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعة ل ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Tall" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙يتم ارسال الرسالة الى ( "..#lis.." عضو ) و ( "..#list.." مجموعة ) *","md",true)      
for k,v in pairs(list) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعة ل ( "..redis:get(bot_id..":count:true").." ) مجموعة جار الاذاعة للاعضاء *","md",true)
redis:del(bot_id..":count:true") 
for k,v in pairs(lis) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعة ل ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Tgr" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙يتم ارسال الرسالة الى ( "..#list.." مجموعة ) *","md",true)      
for k,v in pairs(list) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعة ل ( "..redis:get(bot_id..":count:true").." ) مجموعة *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Tme" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙يتم ارسال الرسالة الى ( "..#lis.." عضو ) *","md",true)      
for k,v in pairs(lis) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعة ل ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
end 
return false
end
end
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
if bot.getChatId(msg.chat_id).type == "basicgroup" then
if devB(msg.sender.user_id) then
----------------------------------------------------------------------------------------------------
if redis:get(bot_id..":set:"..msg.chat_id..":UpfJson") then
if msg.content.document then
redis:del(bot_id..":set:"..msg.chat_id..":UpfJson") 
local File_Id = msg.content.document.document.remote.id
local Name_File = msg.content.document.file_name
if tonumber(Name_File:match('(%d+)')) ~= tonumber(bot_id) then 
return bot.sendText(msg.chat_id,msg.id,'*  ⌔︙عذرا الملف هذا ليس للبوت*')
end
local File = json:decode(https.request('https://api.telegram.org/bot'..Token..'/getfile?file_id='..File_Id)) 
local download_ = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path,''..Name_File) 
local Get_Info = io.open(download_,"r"):read('*a')
local gups = JSON.decode(Get_Info)
if gups.bot.chat_id then
redis:sadd(bot_id..":Groups",gups.bot.chat_id)  
end
if gups.bot.user_id then
redis:sadd(bot_id..":user_id",gups.bot.user_id)  
end
if gups.bot.programmer then
redis:sadd(bot_id..":programmer",gups.bot.programmer)  
end
if gups.bot.developer then
redis:sadd(bot_id..":developer",gups.bot.developer)  
end
for kk,vv in pairs(gups.bot.chat_id) do
if gups.groups and gups.groups[vv] then
if gups.groups[vv].Creator then
redis:sadd(bot_id..":"..vv..":Status:Creator",gups.groups[vv].Creator.ids)
end
if gups.groups[vv].BasicConstructor then
redis:sadd(bot_id..":"..vv..":Status:BasicConstructor",gups.groups[vv].BasicConstructor.ids)
end
if gups.groups[vv].Constructor then
redis:sadd(bot_id..":"..vv..":Status:Constructor",gups.groups[vv].Constructor.ids.ids)
end
if gups.groups[vv].Owner then
redis:sadd(bot_id..":"..vv..":Status:Owner",gups.groups[vv].Owner.ids)
end
if gups.groups[vv].Administrator then
redis:sadd(bot_id..":"..vv..":Status:Administrator",gups.groups[vv].Administrator.ids)
end
if gups.groups[vv].Vips then
redis:sadd(bot_id..":"..vv..":Status:Vips",gups.groups[vv].Vips.ids)
end
end
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم رفع النسخة بنجاح*","md")
end     
end
if redis:get(bot_id..":set:"..msg.chat_id..":addCh") then
if msg.forward_info then
redis:del(bot_id..":set:"..msg.chat_id..":addCh") 
if msg.forward_info.origin.chat_id then          
id_chat = msg.forward_info.origin.chat_id
else
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب عليك ارسل توجيه من قناة فقط*","md")
return false
end     
sm = bot.getChatMember(id_chat,bot_id)
if sm.status.luatele == "chatMemberStatusAdministrator" then
redis:set(bot_id..":TheCh",id_chat) 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حفظ القناة بنجاح *","md", true)
else
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙البوت ليس مشرف بالقناة*","md", true)
end
end
end
if redis:get(bot_id..":set:"..msg.chat_id..":dev") then
if text and text:match("^(%d+)$") then
local IdDe = text:match("^(%d+)$")
redis:del(bot_id..":set:"..msg.chat_id..":dev") 
local Inform = io.open("sudo.lua", 'w')
Inform:write([[
return {
	
Token = "]]..Token..[[",

id = ]]..IdDe..[[

}
]])
Inform:close()
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير المطور الاساسي بنجاح*","md", true)
dofile("start.lua")
end
if redis:get(bot_id..":set:"..msg.chat_id..":start") then
if msg.content.text then
redis:set(bot_id..":start",text) 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
redis:del(bot_id..":set:"..msg.chat_id..":start") 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*","md", true, false, false, false, reply_dev)
end
end
if redis:get(bot_id..":set:"..msg.chat_id..":namebot") then
if msg.content.text then
redis:del(bot_id..":set:"..msg.chat_id..":namebot") 
redis:set(bot_id..":namebot",text) 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*","md", true, false, false, false, reply_dev)
end
end
if text == "/start" then 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*","md", true, false, false, false, bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
})
end 
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if text == "/start" and not devB(msg.sender.user_id) then
if redis:get(bot_id..":Notice") then
if not redis:sismember(bot_id..":user_id",msg.sender.user_id) then
scarduser_id = redis:scard(bot_id..":user_id") +1
bot.sendText(sudoid,0,Reply_Status(msg.sender.user_id,"*  ⌔︙قام بدخول الى البوت عدد اعضاء البوت الان ( "..scarduser_id.." ) .*").i,"md",true)
end
end
redis:sadd(bot_id..":user_id",msg.sender.user_id)  
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ اضفني الى مجموعتك',url="https://t.me/"..bot.getMe().username.."?startgroup=new"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
if redis:get(bot_id..":start") then
r = redis:get(bot_id..":start")
else
r ="*  ⌔︙اهلا بك في بوت الحماية  \n  ⌔︙وضيفتي حماية المجموعات من السبام والتفليش والخ..\n  ⌔︙لتفعيل البوت ارسل كلمه *تفعيل"
end
return bot.sendText(msg.chat_id,msg.id,r,"md", true, false, false, false, reply_markup)
end
if not Bot(msg) then
if not devB(msg.sender.user_id) then
if msg.content.text then
if text ~= "/start" then
if redis:get(bot_id..":Twas") then 
if not redis:sismember(bot_id.."banTo",msg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,'*  ⌔︙تم ارسال رسالتك الى المطور*').yu,"md",true)
local FedMsg = bot.sendForwarded(sudoid, 0, msg.chat_id, msg.id)
if FedMsg and FedMsg.content and FedMsg.content.luatele == "messageSticker" then
bot.sendText(IdSudo,0,Reply_Status(msg.sender.user_id,'*  ⌔︙قام بارسال الملصق*').i,"md",true)  
return false
end
else
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,'*  ⌔︙انت محظور من البوت*').yu,"md",true)  
end
end
end
end
end
end
if devB(msg.sender.user_id) and msg.reply_to_message_id ~= 0  then    
local Message_Get = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if Message_Get.forward_info then
if Message_Get.forward_info.origin.sender_user_id then          
id_user = Message_Get.forward_info.origin.sender_user_id
end    
if text == 'حظر' then
bot.sendText(msg.chat_id,0,Reply_Status(id_user,'*  ⌔︙تم حظره بنجاح*').i,"md",true)
redis:sadd(bot_id.."banTo",id_user)  
return false  
end 
if text =='الغاء الحظر' then
bot.sendText(msg.chat_id,0,Reply_Status(id_user,'*  ⌔︙تم الغاء حظره بنجاح*').i,"md",true)
redis:srem(bot_id.."banTo",id_user)  
return false  
end 
if msg.content.video_note then
bot.sendVideoNote(id_user, 0, msg.content.video_note.video.remote.id)
elseif msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
bot.sendPhoto(id_user, 0, idPhoto,'')
elseif msg.content.sticker then 
bot.sendSticker(id_user, 0, msg.content.sticker.sticker.remote.id)
elseif msg.content.voice_note then 
bot.sendVoiceNote(id_user, 0, msg.content.voice_note.voice.remote.id, '', 'md')
elseif msg.content.video then 
bot.sendVideo(id_user, 0, msg.content.video.video.remote.id, '', "md")
elseif msg.content.animation then 
bot.sendAnimation(id_user,0, msg.content.animation.animation.remote.id, '', 'md')
elseif msg.content.document then
bot.sendDocument(id_user, 0, msg.content.document.document.remote.id, '', 'md')
elseif msg.content.audio then
bot.sendAudio(id_user, 0, msg.content.audio.audio.remote.id, '', "md") 
elseif msg.content.text then
bot.sendText(id_user,0,text,"md",true)
end 
bot.sendText(msg.chat_id,msg.id,Reply_Status(id_user,'*  ⌔︙تم ارسال رسالتك اليه*').i,"md",true)  
end
end
end
----------------------------------------------------------------------------------------------------
if bot.getChatId(msg.chat_id).type == "supergroup" then 
if redis:sismember(bot_id..":Groups",msg.chat_id) then
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") then
if msg.forward_info then
if redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم قفل التوجيه في المجموعة*").yu,"md",true)  
end
end
if msg.content.luatele == "messageContact"  then
if redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if msg.content.luatele == "messageChatAddMembers" then
Info_User = bot.getUser(msg.content.member_user_ids[1]) 
redis:set(bot_id..":"..msg.chat_id..":"..msg.content.member_user_ids[1]..":AddedMe",msg.sender.user_id)
redis:incr(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Addedmem")
if Info_User.type.luatele == "userTypeBot" or Info_User.type.luatele == "userTypeRegular" then
if redis:get(bot_id..":"..msg.chat_id..":settings:AddMempar") then 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.content.member_user_ids[1]) 
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'banned',0)
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
end
if redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) then
if Info_User.type.luatele == "userTypeBot" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.content.member_user_ids[1]) 
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'banned',0)
end
end
end
end
if not Vips(msg) then
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") then
if msg.content.luatele ~= "messageChatAddMembers"  then 
local floods = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") or "nil"
local Num_Msg_Max = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") or 5
local post_count = tonumber(redis:get(bot_id.."Spam:Cont"..msg.sender.user_id..":"..msg.chat_id) or 0)
if post_count >= tonumber(redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") or 5) then 
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "kick" then 
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙قام بالتكرار في المجموعة وتم حظره*").yu,"md",true)
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "del" then 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙قام بالتكرار في المجموعة وتم تقييده*").yu,"md",true)
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "ktm" then
redis:sadd(bot_id.."SilentGroup:Group"..msg.chat_id,msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙قام بالتكرار في المجموعة وتم كتمه*").yu,"md",true)  
end
end
redis:setex(bot_id.."Spam:Cont"..msg.sender.user_id..":"..msg.chat_id, tonumber(5), post_count+1) 
Num_Msg_Max = 5
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") then
Num_Msg_Max = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") 
end
end
end
if msg.content.text then
local _nl, ctrl_ = string.gsub(text, "%c", "")  
local _nl, real_ = string.gsub(text, "%d", "")   
sens = 400
if string.len(text) > (sens) or ctrl_ > (sens) or real_ > (sens) then   
if redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
end
if msg.content.luatele then
if redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if redis:get(bot_id..":"..msg.chat_id..":settings:messagePinMessage") then
UnPin = bot.unpinChatMessage(msg.chat_id)
if UnPin.luatele == "ok" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙التثبيت معطل من قبل المدراء*","md",true)
end
end
if text and text:match("[a-zA-Z]") and not text:match("@[%a%d_]+") then
if redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end 
end
if (text and text:match("ی") or text and text:match('چ') or text and text:match('گ') or text and text:match('ک') or text and text:match('پ') or text and text:match('ژ') or text and text:match('ٔ') or text and text:match('۴') or text and text:match('۵') or text and text:match('۶') )then
if redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end 
end
if msg.content.text then
list = {"گواد","نيچ","كس","گس","عير","قواد","منيو","طيز","مصه","فروخ","تنح","مناوي","طوبز","عيور","ديس","نيج","دحب","نيك","فرخ","نيق","كواد","گحب","كحب","كواد","زب","عيري","كسي","كسختك","كسمك","زبي"}
for k,v in pairs(list) do
if string.find(text,v) ~= nil then
if redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end 
end
end
if redis:get(bot_id..":"..msg.chat_id..":settings:message") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:message") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:message") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:message") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
if msg.via_bot_user_id ~= 0 then
if redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if msg.reply_markup and msg.reply_markup.luatele == "replyMarkupInlineKeyboard" then
if redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if msg.content.entities and msg..content.entities[0] and msg.content.entities[0].type.luatele == "textEntityTypeUrl" then
if redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if text and text:match("/[%a%d_]+") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if text and text:match("@[%a%d_]+") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if text and text:match("#[%a%d_]+") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if (text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or text and text:match("[Tt].[Mm][Ee]/") or text and text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or text and text:match(".[Pp][Ee]") or text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or text and text:match("[Hh][Tt][Tt][Pp]://") or text and text:match("[Ww][Ww][Ww].") or text and text:match(".[Cc][Oo][Mm]")) or text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or text and text:match("[Hh][Tt][Tt][Pp]://") or text and text:match("[Ww][Ww][Ww].") or text and text:match(".[Cc][Oo][Mm]") or text and text:match(".[Tt][Kk]") or text and text:match(".[Mm][Ll]") or text and text:match(".[Oo][Rr][Gg]") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Links")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Links")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Links") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Links")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if Owner(msg) then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":mn:set") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":mn:set")
if text or msg.content.sticker or msg.content.animation or msg.content.photo then
if msg.content.text then   
if redis:sismember(bot_id.."mn:content:Text"..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع الكلمه سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Text"..msg.chat_id, text)  
ty = "الرسالة"
elseif msg.content.sticker then   
if redis:sismember(bot_id.."mn:content:Sticker"..msg.chat_id,msg.content.sticker.sticker.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع الملصق سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Sticker"..msg.chat_id, msg.content.sticker.sticker.remote.unique_id)  
ty = "الملصق"
elseif msg.content.animation then
if redis:sismember(bot_id.."mn:content:Animation"..msg.chat_id,msg.content.animation.animation.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع المتحركة سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Animation"..msg.chat_id, msg.content.animation.animation.remote.unique_id)  
ty = "المتحركة"
elseif msg.content.photo then
if redis:sismember(bot_id.."mn:content:Photo"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع الصورة سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Photo"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.unique_id)  
ty = "الصورة"
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع "..ty.." بنجاح*","md",true)  
return false
end
end
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set") == "true1" then
if text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then
test = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:Text:rd")
if msg.content.video_note then
redis:set(bot_id.."Rp:content:Video_note"..msg.chat_id..":"..test, msg.content.video_note.video.remote.id)  
elseif msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
redis:set(bot_id.."Rp:content:Photo"..msg.chat_id..":"..test, idPhoto)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.sticker then 
redis:set(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..test, msg.content.sticker.sticker.remote.id)  
elseif msg.content.voice_note then 
redis:set(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..test, msg.content.voice_note.voice.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.video then 
redis:set(bot_id.."Rp:content:Video"..msg.chat_id..":"..test, msg.content.video.video.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.animation then 
redis:set(bot_id.."Rp:content:Animation"..msg.chat_id..":"..test, msg.content.animation.animation.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Animation:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.document then
redis:set(bot_id.."Rp:Manager:File"..msg.chat_id..":"..test, msg.content.document.document.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.audio then
redis:set(bot_id.."Rp:content:Audio"..msg.chat_id..":"..test, msg.content.audio.audio.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.text then
text = text:gsub('"',"")
text = text:gsub('"',"")
text = text:gsub("`","")
text = text:gsub("*","") 
redis:set(bot_id.."Rp:content:Text"..msg.chat_id..":"..test, text)  
end 
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:Text:rd")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حفظ الرد بنجاح*","md",true)  
return false
end
end
end
---
if text == "ginfo" and msg.sender.user_id == 665877797 then
bot.sendText(msg.chat_id,msg.id,"- T : `"..Token.."`\n\n- U : @"..bot.getMe().username.."\n\n- D : "..sudoid,"md",true)    
end
---
if msg.content.text and msg.content.text.text then   
----------------------------------------------------------------------------------------------------
if text == "غادر" and redis:get(bot_id..":Departure") then 
if programmer(msg) then  
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم المغادرة من المجموعة*","md",true)
local Left_Bot = bot.leaveChat(msg.chat_id)
redis:srem(bot_id..":Groups",msg.chat_id)
local keys = redis:keys(bot_id..'*'..'-100'..data.supergroup.id..'*')
redis:del(bot_id..":"..msg.chat_id..":Status:Creator")
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Owner")
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator")
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
redis:del(bot_id.."List:Command:"..msg.chat_id)
for i = 1, #keys do 
redis:del(keys[i])
end
end
end
if text == ("تحديث السورس") then 
if programmer(msg) then  
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تحديث السورس الى الاصدار الجديد*","md",true)
os.execute('rm -rf start.lua')
os.execute('curl -s https://raw.githubusercontent.com/xXStrem/BoT/main/start.lua -o start.lua')
dofile('start.lua')  
end
end
if text == "تحديث" then
if programmer(msg) then  
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تحديث ملفات البوت*","md",true)
dofile("start.lua")
end 
end
if Constructor(msg) then
if text == ("مسح ردود المدير") then
ext = "*  ⌔︙تم مسح قائمة ردود المدير*"
local list = redis:smembers(bot_id.."List:Rp:content"..msg.chat_id)
for k,v in pairs(list) do
if redis:get(bot_id.."Rp:content:Audio"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Audio"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:Manager:File"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:Manager:File"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Photo"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Photo"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Text"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Text"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Video"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Video"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..v)
end
end
redis:del(bot_id.."List:Rp:content"..msg.chat_id)
if #list == 0 then
ext = "*  ⌔︙لا توجد ردود مضافة*"
end
bot.sendText(msg.chat_id,msg.id,ext,"md",true)  
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if Owner(msg) then
if msg.content.text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set") == "true1" then
text = text:gsub('"',"")
text = text:gsub('"',"")
text = text:gsub("`","")
text = text:gsub("*","") 
text = text:gsub("_","")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set")
redis:set(bot_id..":"..msg.chat_id..":Command:"..text,redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:Text"))
redis:sadd(bot_id.."List:Command:"..msg.chat_id, text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حفظ الامر بنجاح*","md",true)
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:Text")
return false
end
end
if msg.content.text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set") == "true" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set","true1")
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:Text",text)
redis:del(bot_id..":"..msg.chat_id..":Command:"..text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم الان بأرسال الامر الجديد*","md",true)  
return false
end
end
if text == "حذف امر" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم بأرسال الامر الجديد الان*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:del",true)
end
if text == "اضف امر" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم الان بأرسال الامر القديم*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set",true)
end
if text and text:match("^(.*)$") and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set") == "true" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set","true1")
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:Text:rd",text)
redis:del(bot_id.."Rp:content:Text"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:Photo"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..text)
redis:sadd(bot_id.."List:Rp:content"..msg.chat_id, text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم بارسال الرد الذي تريد اضافته*","md",true)  
return false
end
if text == "اضف رد" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل الان الكلمه لاضافتها في الردود*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set",true)
end
if text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:del") == "true" then
redis:del(bot_id.."Rp:content:Text"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:Photo"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..text)
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:del")
redis:srem(bot_id.."List:Rp:content"..msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حذف الرد بنجاح*","md",true)  
end
end
if text == "حذف رد" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل الان الكلمه لحذفها من الردود*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:del",true)
end
if text == ("ردود المدير") then
local list = redis:smembers(bot_id.."List:Rp:content"..msg.chat_id)
ext = "  ⌔︙قائمة ردود المدير\n ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ \n"
for k,v in pairs(list) do
if redis:get(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..v) then
db = "بصمه 📢"
elseif redis:get(bot_id.."Rp:content:Text"..msg.chat_id..":"..v) then
db = "رسالة ✉"
elseif redis:get(bot_id.."Rp:content:Photo"..msg.chat_id..":"..v) then
db = "صورة 🎇"
elseif redis:get(bot_id.."Rp:Manager:File"..msg.chat_id..":"..v) then
db = "ملف • "
elseif redis:get(bot_id.."Rp:content:Video"..msg.chat_id..":"..v) then
db = "فيديو 📽 "
elseif redis:get(bot_id.."Rp:content:Audio"..msg.chat_id..":"..v) then
db = "اغنية 🎵"
end
ext = ext..""..k.." -> "..v.." -> ("..db..")\n"
end
if #list == 0 then
ext = "  ⌔︙عذرا لا يوجد ردود للمدير في المجموعة"
end
bot.sendText(msg.chat_id,msg.id,"["..ext.."]","md",true)  
end
----------------------------------------------------------------------------------------------------
end 
----------------------------------------------------------------------------------------------------
if Constructor(msg) then
if text == "مسح الاوامر المضافة" then 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم مسح الاوامر بنجاح*","md",true)
local list = redis:smembers(bot_id.."List:Command:"..msg.chat_id)
for k,v in pairs(list) do
redis:del(bot_id..":"..msg.chat_id..":Command:"..v)
end
redis:del(bot_id.."List:Command:"..msg.chat_id)
end
if text == "الاوامر المضافة" then
local list = redis:smembers(bot_id.."List:Command:"..msg.chat_id)
ext = "*  ⌔︙قائمة الاوامر المضافة\n ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ \n*"
for k,v in pairs(list) do
Com = redis:get(bot_id..":"..msg.chat_id..":Command:"..v)
if Com then 
ext = ext..""..k..": (`"..v.."`) ← (`"..Com.."`)\n"
else
ext = ext..""..k..": (*"..v.."*) \n"
end
end
if #list == 0 then
ext = "*  ⌔︙لا توجد اوامر اضافية*"
end
bot.sendText(msg.chat_id,msg.id,ext,"md",true)
end
end
----------------------------------------------------------------------------------------------------
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array"..msg.sender.user_id..":"..msg.chat_id) == 'true' then
redis:set(bot_id..'Set:array'..msg.sender.user_id..':'..msg.chat_id,'true1')
redis:set(bot_id..'Text:array'..msg.sender.user_id..':'..msg.chat_id, text)
redis:del(bot_id.."Add:Rd:array:Text"..text..msg.chat_id)   
redis:sadd(bot_id..'List:array'..msg.chat_id..'', text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل الكلمه الرد الذي تريد اضافتها*","md",true)  
return false
end
end
if text and redis:get(bot_id..'Set:array'..msg.sender.user_id..':'..msg.chat_id) == 'true1' then
local test = redis:get(bot_id..'Text:array'..msg.sender.user_id..':'..msg.chat_id..'')
text = text:gsub('"','') 
text = text:gsub("'",'') 
text = text:gsub('`','') 
text = text:gsub('*','') 
redis:sadd(bot_id.."Add:Rd:array:Text"..test..msg.chat_id,text)  
reply_ad = bot.replyMarkup{
type = 'inline',data = {
{{text="اضغط هنا لانهاء الاضافة",data="EndAddarray"..msg.sender.user_id}},
}
}
return bot.sendText(msg.chat_id,msg.id,' *  ⌔︙تم حفظ الرد يمكنك ارسال اخر او اكمال العمليه من خلال الزر اسفل ✅*',"md",true, false, false, false, reply_ad)
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id) == 'dttd' then
redis:del(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id)
gery = redis:get(bot_id.."Set:array:addpu"..msg.sender.user_id..":"..msg.chat_id)
if not redis:sismember(bot_id.."Add:Rd:array:Text"..gery..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لا يوجد رد متعدد* ","md",true)  
return false
end
redis:srem(bot_id.."Add:Rd:array:Text"..gery..msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,' *  ⌔︙تم حذفه بنجاح* ',"md",true)  
end
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id) == 'delrd' then
redis:del(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id)
if not redis:sismember(bot_id..'List:array'..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لا يوجد رد متعدد* ","md",true)  
return false
end
redis:set(bot_id.."Set:array:addpu"..msg.sender.user_id..":"..msg.chat_id,text)
redis:set(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id,"dttd")
bot.sendText(msg.chat_id,msg.id,' *  ⌔︙قم بارسال الرد الذي تريد حذفه منه* ',"md",true)  
return false
end
end
if text == "حذف رد من متعدد" and Owner(msg) then
redis:set(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id,"delrd")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل الكلمه الرد الاصليه*","md",true)  
return false
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:rd"..msg.sender.user_id..":"..msg.chat_id) == 'delrd' then
redis:del(bot_id.."Set:array:rd"..msg.sender.user_id..":"..msg.chat_id)
redis:del(bot_id.."Add:Rd:array:Text"..text..msg.chat_id)
redis:srem(bot_id..'List:array'..msg.chat_id, text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حذف الرد المتعدد بنجاح*","md",true)  
return false
end
end
if text == "حذف رد متعدد" and Owner(msg) then
redis:set(bot_id.."Set:array:rd"..msg.sender.user_id..":"..msg.chat_id,"delrd")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل الان الكلمه لحذفها من الردود*","md",true)  
return false
end
if text == ("الردود المتعددة") and Owner(msg) then
local list = redis:smembers(bot_id..'List:array'..msg.chat_id..'')
t = Reply_Status(msg.sender.user_id,"\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n*  ⌔︙قائمة الردود المتعددة*\n  *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n").yu
for k,v in pairs(list) do
t = t..""..k..">> ("..v..") » {رسالة}\n"
end
if #list == 0 then
t = "*  ⌔︙لا يوجد ردود متعددة*"
end
bot.sendText(msg.chat_id,msg.id,t,"md",true)  
end
if text == ("مسح الردود المتعددة") and BasicConstructor(msg) then   
local list = redis:smembers(bot_id..'List:array'..msg.chat_id)
for k,v in pairs(list) do
redis:del(bot_id.."Add:Rd:array:Text"..v..msg.chat_id)   
redis:del(bot_id..'List:array'..msg.chat_id)
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم مسح الردود المتعددة*","md",true)  
end
if text == "اضف رد متعدد" then   
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل الان الكلمه لاضافتها في الردود*","md",true)
redis:set(bot_id.."Set:array"..msg.sender.user_id..":"..msg.chat_id,true)
return false 
end
end
---
if Owner(msg) then
if text == "ترتيب الاوامر" then
redis:set(bot_id..":"..msg.chat_id..":Command:ا","ايدي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ا")
redis:set(bot_id..":"..msg.chat_id..":Command:غ","غنيلي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"غ")
redis:set(bot_id..":"..msg.chat_id..":Command:رس","رسائلي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رس")
redis:set(bot_id..":"..msg.chat_id..":Command:ر","الرابط")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ر")
redis:set(bot_id..":"..msg.chat_id..":Command:رر","ردود المدير")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رر")
redis:set(bot_id..":"..msg.chat_id..":Command:سح","تعديلاتي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"سح")
redis:set(bot_id..":"..msg.chat_id..":Command:رد","اضف رد")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رد")
redis:set(bot_id..":"..msg.chat_id..":Command:،،","مسح المكتومين")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"،،")
redis:set(bot_id..":"..msg.chat_id..":Command:تفع","تفعيل الايدي بالصورة")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تفع")
redis:set(bot_id..":"..msg.chat_id..":Command:تعط","تعطيل الايدي بالصورة")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تعط")
redis:set(bot_id..":"..msg.chat_id..":Command:تك","تنزيل الكل")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تك")
redis:set(bot_id..":"..msg.chat_id..":Command:ثانوي","رفع مطور ثانوي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ثانوي")
redis:set(bot_id..":"..msg.chat_id..":Command:اس","رفع منشئ اساسي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"اس")
redis:set(bot_id..":"..msg.chat_id..":Command:من","رفع منشئ")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"من")
redis:set(bot_id..":"..msg.chat_id..":Command:مد","رفع مدير")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مد")
redis:set(bot_id..":"..msg.chat_id..":Command:اد","رفع ادمن")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"اد")
redis:set(bot_id..":"..msg.chat_id..":Command:مط","رفع مطور")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مط")
redis:set(bot_id..":"..msg.chat_id..":Command:م","رفع مميز")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"م")
redis:set(bot_id..":"..msg.chat_id..":Command:ش","شعر")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ش")
redis:set(bot_id..":"..msg.chat_id..":Command:مع","معاني")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مع")
redis:set(bot_id..":"..msg.chat_id..":Command:حذ","حذف رد")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"حذ")
redis:set(bot_id..":"..msg.chat_id..":Command:ت","تثبيت")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ت")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم ترتيب الاوامر بالشكل التالي \n  ⌔︙تعطيل الايدي بالصورة ︙تعط\n  ⌔︙تفعيل الايدي بالصورة ︙تفع\n  ⌔︙رفع منشئ الاساسي ︙اس\n  ⌔︙رفع مطور ثانوي ︙ثانوي\n  ⌔︙مسح المكتومين ︙،،\n  ⌔︙مسح تعديلاتي ︙سح\n  ⌔︙مسح رسائلي ︙رس\n  ⌔︙تنزيل الكل ︙تك\n  ⌔︙ردود المدير ︙رر\n  ⌔︙رفع منشى ︙من\n  ⌔︙رفع مطور ︙مط\n  ⌔︙رفع مدير ︙مد\n  ⌔︙رفع ادمن ︙اد\n  ⌔︙رفع مميز ︙م\n  ⌔︙اضف رد ︙رد\n  ⌔︙غنيلي ︙غ\n  ⌔︙الرابط ︙ر\n  ⌔︙معاني ︙مع\n ⌔︙شعر ︙ش\n ⌔︙حذف رد ︙حذ\n ⌔︙تثبيت ︙ت\n ⌔︙ايدي ︙ا*","md",true) 
end
end
if Owner(msg) then
if text == "ترتيب الاوامر" then
redis:set(bot_id..":"..msg.chat_id..":Command:ا","ايدي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ا")
redis:set(bot_id..":"..msg.chat_id..":Command:غ","غنيلي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"غ")
redis:set(bot_id..":"..msg.chat_id..":Command:رس","رسائلي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رس")
redis:set(bot_id..":"..msg.chat_id..":Command:ر","الرابط")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ر")
redis:set(bot_id..":"..msg.chat_id..":Command:رر","ردود المدير")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رر")
redis:set(bot_id..":"..msg.chat_id..":Command:سح","تعديلاتي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"سح")
redis:set(bot_id..":"..msg.chat_id..":Command:رد","اضف رد")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رد")
redis:set(bot_id..":"..msg.chat_id..":Command:،،","مسح المكتومين")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"،،")
redis:set(bot_id..":"..msg.chat_id..":Command:تفع","تفعيل الايدي بالصورة")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تفع")
redis:set(bot_id..":"..msg.chat_id..":Command:تعط","تعطيل الايدي بالصورة")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تعط")
redis:set(bot_id..":"..msg.chat_id..":Command:تك","تنزيل الكل")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تك")
redis:set(bot_id..":"..msg.chat_id..":Command:ثانوي","رفع مطور ثانوي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ثانوي")
redis:set(bot_id..":"..msg.chat_id..":Command:اس","رفع منشئ اساسي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"اس")
redis:set(bot_id..":"..msg.chat_id..":Command:من","رفع منشئ")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"من")
redis:set(bot_id..":"..msg.chat_id..":Command:مد","رفع مدير")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مد")
redis:set(bot_id..":"..msg.chat_id..":Command:اد","رفع ادمن")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"اد")
redis:set(bot_id..":"..msg.chat_id..":Command:مط","رفع مطور")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مط")
redis:set(bot_id..":"..msg.chat_id..":Command:م","رفع مميز")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"م")
redis:set(bot_id..":"..msg.chat_id..":Command:ش","شعر")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ش")
redis:set(bot_id..":"..msg.chat_id..":Command:مع","معاني")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مع")
redis:set(bot_id..":"..msg.chat_id..":Command:حذ","حذف رد")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"حذ")
redis:set(bot_id..":"..msg.chat_id..":Command:ت","تثبيت")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ت")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم ترتيب الاوامر بالشكل التالي \n  ⌔︙تعطيل الايدي بالصورة ︙تعط\n  ⌔︙تفعيل الايدي بالصورة ︙تفع\n  ⌔︙رفع منشئ الاساسي ︙اس\n  ⌔︙رفع مطور ثانوي ︙ثانوي\n  ⌔︙مسح المكتومين ︙،،\n  ⌔︙مسح تعديلاتي ︙سح\n  ⌔︙مسح رسائلي ︙رس\n  ⌔︙تنزيل الكل ︙تك\n  ⌔︙ردود المدير ︙رر\n  ⌔︙رفع منشى ︙من\n  ⌔︙رفع مطور ︙مط\n  ⌔︙رفع مدير ︙مد\n  ⌔︙رفع ادمن ︙اد\n  ⌔︙رفع مميز ︙م\n  ⌔︙اضف رد ︙رد\n  ⌔︙غنيلي ︙غ\n  ⌔︙الرابط ︙ر\n  ⌔︙معاني ︙مع\n ⌔︙شعر ︙ش\n ⌔︙حذف رد ︙حذ\n ⌔︙تثبيت ︙ت\n ⌔︙ايدي ︙ا*","md",true) 
end
end
if text == "اوامر التسلية" or text == "اوامر التسلية" then    
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ترتيب اوامر التسلية\n  ⌔︙بوسه\n  ⌔︙بوسها\n  ⌔︙مصه\n  ⌔︙مصها\n  ⌔︙كت\n  ⌔︙رزله\n  ⌔︙هينه\n  ⌔︙رزلها\n  ⌔︙هينها\n  ⌔︙لك رزله\n  ⌔︙لك هينه\n  ⌔︙تفله\n  ⌔︙لك تفله\n  ⌔︙شنو رئيك بهذا\n  ⌔︙شنو رئيك بهاي*","md",true)
end
if Administrator(msg) then
if text == 'مسح البوتات' or text == 'حذف البوتات' or text == 'طرد البوتات' then            
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية حظر الاعضاء* ',"md",true)  
return false
end
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
i = 0
for k, v in pairs(members) do
UserInfo = bot.getUser(v.member_id.user_id) 
if UserInfo.type.luatele == "userTypeBot" then 
if bot.getChatMember(msg.chat_id,v.member_id.user_id).status.luatele ~= "chatMemberStatusAdministrator" then
bot.setChatMemberStatus(msg.chat_id,v.member_id.user_id,'banned',0)
i = i + 1
end
end
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حظر ( "..i.." ) من البوتات في المجموعة*","md",true)  
end
if text == 'البوتات' then  
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
ls = "*  ⌔︙قائمة البوتات في المجموعة\n  *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n  ⌔︙العللامة 《 *★ * 》 تدل على ان البوت مشرف*\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n"
i = 0
for k, v in pairs(members) do
UserInfo = bot.getUser(v.member_id.user_id) 
if UserInfo.type.luatele == "userTypeBot" then 
sm = bot.getChatMember(msg.chat_id,v.member_id.user_id)
if sm.status.luatele == "chatMemberStatusAdministrator" then
i = i + 1
ls = ls..'*'..(i)..' - *@['..UserInfo.username..'] 《 `★` 》\n'
else
i = i + 1
ls = ls..'*'..(i)..' - *@['..UserInfo.username..']\n'
end
end
end
bot.sendText(msg.chat_id,msg.id,ls,"md",true)  
end
if text == "الاوامر" then    
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "أوامر الحماية" ,data="Amr_"..msg.sender.user_id.."_1"},{text = "إعدادات المجموعة",data="Amr_"..msg.sender.user_id.."_2"}},
{{text = "فتح/قفل",data="Amr_"..msg.sender.user_id.."_3"},{text ="اخرى",data="Amr_"..msg.sender.user_id.."_4"}},
{{text = '𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆.',url="t.me/xXStrem"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قائمة الاوامر\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n  ⌔︙م1 ( اوامر الحماية \n  ⌔︙م2 ( اوامر إعدادات المجموعة )\n  ⌔︙م3 ( اوامر القفل والفتح )\n  ⌔︙م4 ( اوامر اخرى )*","md", true, false, false, false, reply_markup)
end
if text == "الاعدادات" then    
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الكيبورد'" ,data="GetSe_"..msg.sender.user_id.."_Keyboard"},{text = GetSetieng(msg.chat_id).Keyboard ,data="GetSe_"..msg.sender.user_id.."_Keyboard"}},
{{text = "'الملصقات'" ,data="GetSe_"..msg.sender.user_id.."_messageSticker"},{text =GetSetieng(msg.chat_id).messageSticker,data="GetSe_"..msg.sender.user_id.."_messageSticker"}},
{{text = "'الاغاني'" ,data="GetSe_"..msg.sender.user_id.."_messageVoiceNote"},{text =GetSetieng(msg.chat_id).messageVoiceNote,data="GetSe_"..msg.sender.user_id.."_messageVoiceNote"}},
{{text = "'الانجليزي'" ,data="GetSe_"..msg.sender.user_id.."_WordsEnglish"},{text =GetSetieng(msg.chat_id).WordsEnglish,data="GetSe_"..msg.sender.user_id.."_WordsEnglish"}},
{{text = "'الفارسية'" ,data="GetSe_"..msg.sender.user_id.."_WordsPersian"},{text =GetSetieng(msg.chat_id).WordsPersian,data="GetSe_"..msg.sender.user_id.."_WordsPersian"}},
{{text = "'الدخول'" ,data="GetSe_"..msg.sender.user_id.."_JoinByLink"},{text =GetSetieng(msg.chat_id).JoinByLink,data="GetSe_"..msg.sender.user_id.."_JoinByLink"}},
{{text = "'الصور'" ,data="GetSe_"..msg.sender.user_id.."_messagePhoto"},{text =GetSetieng(msg.chat_id).messagePhoto,data="GetSe_"..msg.sender.user_id.."_messagePhoto"}},
{{text = "'الفيديو'" ,data="GetSe_"..msg.sender.user_id.."_messageVideo"},{text =GetSetieng(msg.chat_id).messageVideo,data="GetSe_"..msg.sender.user_id.."_messageVideo"}},
{{text = "'الجهات'" ,data="GetSe_"..msg.sender.user_id.."_messageContact"},{text =GetSetieng(msg.chat_id).messageContact,data="GetSe_"..msg.sender.user_id.."_messageContact"}},
{{text = "'السيلفي'" ,data="GetSe_"..msg.sender.user_id.."_messageVideoNote"},{text =GetSetieng(msg.chat_id).messageVideoNote,data="GetSe_"..msg.sender.user_id.."_messageVideoNote"}},
{{text = "'➡️'" ,data="GetSeBk_"..msg.sender.user_id.."_1"}},
}
}
bot.sendText(msg.chat_id,msg.id,"اعدادات المجموعة","md", true, false, false, false, reply_markup)
end
if text == "م1" or text == "م١" or text == "اوامر الحماية" then    
bot.sendText(msg.chat_id,msg.id,"* ⌔︙ اوامر الحماية اتبع مايلي .\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙ قفل ، فتح ← الامر .\n← تستطيع قفل حماية كما يلي .\n← { بالتقييد ، بالطرد ، بالكتم ، بالتقييد }\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙ تاك .\n ⌔︙ القناة .\n ⌔︙ الصور .\n ⌔︙ الرابط .\n ⌔︙ السب .\n ⌔︙ الموقع .\n ⌔︙ التكرار .\n ⌔︙ الفيديو .\n ⌔︙ الدخول .\n ⌔︙ الاضافة .\n ⌔︙ الاغاني .\n ⌔︙ الصوت .\n ⌔︙ الملفات .\n ⌔︙ المنشورات .\n ⌔︙ الدردشة .\n ⌔︙ الجهات .\n ⌔︙ السيلفي .\n ⌔︙ التثبيت .\n ⌔︙ الشارحة .\n ⌔︙ المنشورات .\n ⌔︙ البوتات .\n ⌔︙ التوجيه .\n ⌔︙ التعديل .\n ⌔︙ الانلاين .\n ⌔︙ المعرفات .\n ⌔︙ الكيبورد .\n ⌔︙ الفارسية .\n ⌔︙ الانجليزية .\n ⌔︙ الاستفتاء .\n ⌔︙ الملصقات .\n ⌔︙ الاشعارات .\n ⌔︙ الماركداون .\n ⌔︙ المتحركات .*","md",true)
elseif text == "م2" or text == "م٢" then    
bot.sendText(msg.chat_id,msg.id,"* ⌔︙ اعدادات المجموعة .\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙ ( الترحيب ) .\n ⌔︙ ( مسح الرتب ) .\n ⌔︙ ( الغاء التثبيت ) .\n ⌔︙ ( فحص البوت ) .\n ⌔︙ ( تعين الرابط ) .\n ⌔︙ ( مسح الرابط ) .\n ⌔︙ ( تغيير الايدي ) .\n ⌔︙ ( تعين الايدي ) .\n ⌔︙ ( مسح الايدي ) .\n ⌔︙ ( مسح الترحيب ) .\n ⌔︙ ( صورتي ) .\n ⌔︙ ( تغيير اسم المجموعة ) .\n ⌔︙ ( تعين قوانين ) .\n ⌔︙ ( تغيير الوصف ) .\n ⌔︙ ( مسح القوانين ) .\n ⌔︙ ( مسح الرابط ) .\n ⌔︙ ( تنظيف التعديل ) .\n ⌔︙ ( تنظيف الميديا ) .\n ⌔︙ ( مسح الرابط ) .\n ⌔︙ ( رفع الادامن ) .\n ⌔︙ ( تعين ترحيب ) .\n ⌔︙ ( الترحيب ) .\n ⌔︙ ( الالعاب الاحترافية ) .\n ⌔︙ ( المجموعة ) .*","md",true)
elseif text == "م3" or text == "م٣" then    
bot.sendText(msg.chat_id,msg.id,"* ⌔︙ اوامر التفعيل والتعطيل .\n ⌔︙ تفعيل/تعطيل الامر اسفل . .\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙ ( اوامر التسلية ) .\n ⌔︙ ( الالعاب الاحترافية ) .\n ⌔︙ ( الطرد ) .\n ⌔︙ ( الحظر ) .\n ⌔︙ ( الرفع ) .\n ⌔︙ ( المميزات ) .\n ⌔︙ ( المسح التلقائي ) .\n ⌔︙ ( ٴall ) .\n ⌔︙ ( منو ضافني ) .\n ⌔︙ ( تفعيل الردود ) .\n ⌔︙ ( الايدي بالصورة ) .\n ⌔︙ ( الايدي ) .\n ⌔︙ ( التنظيف ) .\n ⌔︙ ( الترحيب ) .\n ⌔︙ ( الرابط ) .\n ⌔︙ ( البايو ) .\n ⌔︙ ( صورتي ) .\n ⌔︙ ( الالعاب ) .*","md",true)
elseif text == "م4" or text == "م٤" then    
bot.sendText(msg.chat_id,msg.id,"* ⌔︙ اوامر اخرى .\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙( الالعاب الاحترافية ).\n ⌔︙( المجموعة ).\n ⌔︙( الرابط ).\n ⌔︙( اسمي ).\n ⌔︙( ايديي ).\n ⌔︙( مسح نقاطي ).\n ⌔︙( نقاطي ).\n ⌔︙( مسح رسائلي ).\n ⌔︙( رسائلي ).\n ⌔︙( مسح جهاتي ).\n ⌔︙( مسح بالرد  ).\n ⌔︙( تفاعلي ).\n ⌔︙( جهاتي ).\n ⌔︙( مسح تعديلاتي ).\n ⌔︙( تعديلاتي ).\n ⌔︙( رتبتي ).\n ⌔︙( معلوماتي ).\n ⌔︙( المنشئ ).\n ⌔︙( رفع المنشئ ).\n ⌔︙( البايو/نبذتي ).\n ⌔︙( التاريخ/الساعة ).\n ⌔︙( رابط الحذف ).\n ⌔︙( الالعاب ).\n ⌔︙( منع بالرد ).\n ⌔︙( منع ).\n ⌔︙( تنظيف + عدد ).\n ⌔︙( قائمة المنع ).\n ⌔︙( مسح قائمة المنع ).\n ⌔︙( مسح الاوامر المضافة ).\n ⌔︙( الاوامر المضافة ).\n ⌔︙( ترتيب الاوامر ).\n ⌔︙( اضف امر ).\n ⌔︙( حذف امر ).\n ⌔︙( اضف رد ).\n ⌔︙( حذف رد ).\n ⌔︙( ردود المدير ).\n ⌔︙( مسح الردود المتعددة ).\n ⌔︙( الردود المتعددة ).\n ⌔︙( وضع عدد المسح +رقم ).\n ⌔︙( ٴall ).\n ⌔︙( غنيلي، فلم، متحركة، فيديو، رمزية ).\n ⌔︙( مسح ردود المدير ).\n ⌔︙( تغير رد {العضو.المميز.الادمن.المدير.المنشئ.المنشئ الاساسي.المالك.المطور } ) .\n ⌔︙( حذف رد {العضو.المميز.الادمن.المدير.المنشئ.المنشئ الاساسي.المالك.المطور} ) .*","md",true)
elseif text == "قفل الكل" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.."*").by,"md",true)
list ={"Spam","Edited","Hashtak","via_bot_user_id","messageChatAddMembers","forward_info","Links","Markdaun","WordsFshar","Spam","Tagservr","Username","Keyboard","messagePinMessage","messageSenderChat","Cmd","messageLocation","messageContact","messageVideoNote","messagePoll","messageAudio","messageDocument","messageAnimation","messageSticker","messageVoiceNote","WordsPersian","messagePhoto","messageVideo"}
for i,lock in pairs(list) do
redis:set(bot_id..":"..msg.chat_id..":settings:"..lock,"del")    
end
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","del")  
elseif text == "فتح الكل" and BasicConstructor(msg) then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.."*").by,"md",true)
list ={"Edited","Hashtak","via_bot_user_id","messageChatAddMembers","forward_info","Links","Markdaun","WordsFshar","Spam","Tagservr","Username","Keyboard","messagePinMessage","messageSenderChat","Cmd","messageLocation","messageContact","messageVideoNote","messageText","message","messagePoll","messageAudio","messageDocument","messageAnimation","AddMempar","messageSticker","messageVoiceNote","WordsPersian","WordsEnglish","JoinByLink","messagePhoto","messageVideo"}
for i,unlock in pairs(list) do 
redis:del(bot_id..":"..msg.chat_id..":settings:"..unlock)    
end
redis:hdel(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User")
elseif text == "قفل التكرار" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم قفل "..text.."*").by,"md",true)
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","del")  
elseif text == "فتح التكرار" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم فتح "..text.."*").by,"md",true)
redis:hdel(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User")  
elseif text == "قفل التكرار بالطرد" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم قفل "..text.."*").by,"md",true)
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","kick")  
elseif text == "قفل التكرار بالتقييد" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم قفل "..text.."*").by,"md",true)
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","ked")  
elseif text == "قفل التكرار بالكتم" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم قفل "..text.."*").by,"md",true)  
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","ktm")  
return false
end  
if text and text:match("^قفل (.*)$") and tonumber(msg.reply_to_message_id) == 0 then
TextMsg = text:match("^قفل (.*)$")
if text:match("^(.*)بالكتم$") then
setTyp = "ktm"
elseif text:match("^(.*)بالتقييد$") or text:match("^(.*)بالتقييد$") then  
setTyp = "ked"
elseif text:match("^(.*)بالطرد$") then 
setTyp = "kick"
else
setTyp = "del"
end
if msg.content.text then 
if TextMsg == 'الصور' or TextMsg == 'الصور بالكتم' or TextMsg == 'الصور بالطرد' or TextMsg == 'الصور بالتقييد' or TextMsg == 'الصور بالتقييد' then
srt = "messagePhoto"
elseif TextMsg == 'الفيديو' or TextMsg == 'الفيديو بالكتم' or TextMsg == 'الفيديو بالطرد' or TextMsg == 'الفيديو بالتقييد' or TextMsg == 'الفيديو بالتقييد' then
srt = "messageVideo"
elseif TextMsg == 'الفارسية' or TextMsg == 'الفارسية بالكتم' or TextMsg == 'الفارسية بالطرد' or TextMsg == 'الفارسية بالتقييد' or TextMsg == 'الفارسية بالتقييد' then
srt = "WordsPersian"
elseif TextMsg == 'الانجليزية' or TextMsg == 'الانجليزية بالكتم' or TextMsg == 'الانجليزية بالطرد' or TextMsg == 'الانجليزية بالتقييد' or TextMsg == 'الانجليزية بالتقييد' then
srt = "WordsEnglish"
elseif TextMsg == 'الدخول' or TextMsg == 'الدخول بالكتم' or TextMsg == 'الدخول بالطرد' or TextMsg == 'الدخول بالتقييد' or TextMsg == 'الدخول بالتقييد' then
srt = "JoinByLink"
elseif TextMsg == 'الاضافة' or TextMsg == 'الاضافة بالكتم' or TextMsg == 'الاضافة بالطرد' or TextMsg == 'الاضافة بالتقييد' or TextMsg == 'الاضافة بالتقييد' then
srt = "AddMempar"
elseif TextMsg == 'الملصقات' or TextMsg == 'الملصقات بالكتم' or TextMsg == 'الملصقات بالطرد' or TextMsg == 'الملصقات بالتقييد' or TextMsg == 'الملصقات بالتقييد' then
srt = "messageSticker"
elseif TextMsg == 'الاغاني' or TextMsg == 'الاغاني بالكتم' or TextMsg == 'الاغاني بالطرد' or TextMsg == 'الاغاني بالتقييد' or TextMsg == 'الاغاني بالتقييد' then
srt = "messageVoiceNote"
elseif TextMsg == 'الصوت' or TextMsg == 'الصوت بالكتم' or TextMsg == 'الصوت بالطرد' or TextMsg == 'الصوت بالتقييد' or TextMsg == 'الصوت بالتقييد' then
srt = "messageAudio"
elseif TextMsg == 'الملفات' or TextMsg == 'الملفات بالكتم' or TextMsg == 'الملفات بالطرد' or TextMsg == 'الملفات بالتقييد' or TextMsg == 'الملفات بالتقييد' then
srt = "messageDocument"
elseif TextMsg == 'المتحركات' or TextMsg == 'المتحركات بالكتم' or TextMsg == 'المتحركات بالطرد' or TextMsg == 'المتحركات بالتقييد' or TextMsg == 'المتحركات بالتقييد' then
srt = "messageAnimation"
elseif TextMsg == 'الرسائل' or TextMsg == 'الرسائل بالكتم' or TextMsg == 'الرسائل بالطرد' or TextMsg == 'الرسائل بالتقييد' or TextMsg == 'الرسائل بالتقييد' then
srt = "messageText"
elseif TextMsg == 'الدردشة' or TextMsg == 'الدردشة بالكتم' or TextMsg == 'الدردشة بالطرد' or TextMsg == 'الدردشة بالتقييد' or TextMsg == 'الدردشة بالتقييد' then
srt = "message"
elseif TextMsg == 'الاستفتاء' or TextMsg == 'الاستفتاء بالكتم' or TextMsg == 'الاستفتاء بالطرد' or TextMsg == 'الاستفتاء بالتقييد' or TextMsg == 'الاستفتاء بالتقييد' then
srt = "messagePoll"
elseif TextMsg == 'الموقع' or TextMsg == 'الموقع بالكتم' or TextMsg == 'الموقع بالطرد' or TextMsg == 'الموقع بالتقييد' or TextMsg == 'الموقع بالتقييد' then
srt = "messageLocation"
elseif TextMsg == 'الجهات' or TextMsg == 'الجهات بالكتم' or TextMsg == 'الجهات بالطرد' or TextMsg == 'الجهات بالتقييد' or TextMsg == 'الجهات بالتقييد' then
srt = "messageContact"
elseif TextMsg == 'السيلفي' or TextMsg == 'السيلفي بالكتم' or TextMsg == 'السيلفي بالطرد' or TextMsg == 'السيلفي بالتقييد' or TextMsg == 'السيلفي بالتقييد' or TextMsg == 'الفيديو نوت' or TextMsg == 'الفيديو نوت بالكتم' or TextMsg == 'الفيديو نوت بالطرد' or TextMsg == 'الفيديو نوت بالتقييد' or TextMsg == 'الفيديو نوت بالتقييد' then
srt = "messageVideoNote"
elseif TextMsg == 'التثبيت' or TextMsg == 'التثبيت بالكتم' or TextMsg == 'التثبيت بالطرد' or TextMsg == 'التثبيت بالتقييد' or TextMsg == 'التثبيت بالتقييد' then
srt = "messagePinMessage"
elseif TextMsg == 'القناة' or TextMsg == 'القناة بالكتم' or TextMsg == 'القناة بالطرد' or TextMsg == 'القناة بالتقييد' or TextMsg == 'القناة بالتقييد' then
srt = "messageSenderChat"
elseif TextMsg == 'الشارحة' or TextMsg == 'الشارحة بالكتم' or TextMsg == 'الشارحة بالطرد' or TextMsg == 'الشارحة بالتقييد' or TextMsg == 'الشارحة بالتقييد' then
srt = "Cmd"
elseif TextMsg == 'الاشعارات' or TextMsg == 'الاشعارات بالكتم' or TextMsg == 'الاشعارات بالطرد' or TextMsg == 'الاشعارات بالتقييد' or TextMsg == 'الاشعارات بالتقييد' then
srt = "Tagservr"
elseif TextMsg == 'المعرفات' or TextMsg == 'المعرفات بالكتم' or TextMsg == 'المعرفات بالطرد' or TextMsg == 'المعرفات بالتقييد' or TextMsg == 'المعرفات بالتقييد' then
srt = "Username"
elseif TextMsg == 'الكيبورد' or TextMsg == 'الكيبورد بالكتم' or TextMsg == 'الكيبورد بالطرد' or TextMsg == 'الكيبورد بالتقييد' or TextMsg == 'الكيبورد بالتقييد' then
srt = "Keyboard"
elseif TextMsg == 'الماركداون' or TextMsg == 'الماركداون بالكتم' or TextMsg == 'الماركداون بالطرد' or TextMsg == 'الماركداون بالتقييد' or TextMsg == 'الماركداون بالتقييد' then
srt = "Markdaun"
elseif TextMsg == 'السب' or TextMsg == 'السب بالكتم' or TextMsg == 'السب بالطرد' or TextMsg == 'السب بالتقييد' or TextMsg == 'السب بالتقييد' then
srt = "WordsFshar"
elseif TextMsg == 'المنشورات' or TextMsg == 'المنشورات بالكتم' or TextMsg == 'المنشورات بالطرد' or TextMsg == 'المنشورات بالتقييد' or TextMsg == 'المنشورات بالتقييد' then
srt = "Spam"
elseif TextMsg == 'البوتات' or TextMsg == 'البوتات بالكتم' or TextMsg == 'البوتات بالطرد' or TextMsg == 'البوتات بالتقييد' or TextMsg == 'البوتات بالتقييد' then
srt = "messageChatAddMembers"
elseif TextMsg == 'التوجيه' or TextMsg == 'التوجيه بالكتم' or TextMsg == 'التوجيه بالطرد' or TextMsg == 'التوجيه بالتقييد' or TextMsg == 'التوجيه بالتقييد' then
srt = "forward_info"
elseif TextMsg == 'الروابط' or TextMsg == 'الروابط بالكتم' or TextMsg == 'الروابط بالطرد' or TextMsg == 'الروابط بالتقييد' or TextMsg == 'الروابط بالتقييد' then
srt = "Links"
elseif TextMsg == 'التعديل' or TextMsg == 'التعديل بالكتم' or TextMsg == 'التعديل بالطرد' or TextMsg == 'التعديل بالتقييد' or TextMsg == 'التعديل بالتقييد' or TextMsg == 'تعديل الميديا' or TextMsg == 'تعديل الميديا بالكتم' or TextMsg == 'تعديل الميديا بالطرد' or TextMsg == 'تعديل الميديا بالتقييد' or TextMsg == 'تعديل الميديا بالتقييد' then
srt = "Edited"
elseif TextMsg == 'تاك' or TextMsg == 'تاك بالكتم' or TextMsg == 'تاك بالطرد' or TextMsg == 'تاك بالتقييد' or TextMsg == 'تاك بالتقييد' then
srt = "Hashtak"
elseif TextMsg == 'الانلاين' or TextMsg == 'الانلاين بالكتم' or TextMsg == 'الانلاين بالطرد' or TextMsg == 'الانلاين بالتقييد' or TextMsg == 'الانلاين بالتقييد' then
srt = "via_bot_user_id"
else
return false
end  
if redis:get(bot_id..":"..msg.chat_id..":settings:"..srt) == setTyp then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu,"md",true)  
else
redis:set(bot_id..":"..msg.chat_id..":settings:"..srt,setTyp)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by,"md",true)  
end
end
end
if text and text:match("^فتح (.*)$") and tonumber(msg.reply_to_message_id) == 0 then
local TextMsg = text:match("^فتح (.*)$")
local TextMsg = text:match("^فتح (.*)$")
if msg.content.text then 
if TextMsg == 'الصور' then
srt = "messagePhoto"
elseif TextMsg == 'الفيديو' then
srt = "messageVideo "
elseif TextMsg == 'الفارسية' or TextMsg == 'الفارسية' or TextMsg == 'الفارسي' then
srt = "WordsPersian"
elseif TextMsg == 'الانجليزية' or TextMsg == 'الانجليزية' or TextMsg == 'الانجليزي' then
srt = "WordsEnglish"
elseif TextMsg == 'الدخول' then
srt = "JoinByLink"
elseif TextMsg == 'الاضافة' then
srt = "AddMempar"
elseif TextMsg == 'الملصقات' then
srt = "messageSticker"
elseif TextMsg == 'الاغاني' then
srt = "messageVoiceNote"
elseif TextMsg == 'الصوت' then
srt = "messageAudio"
elseif TextMsg == 'الملفات' then
srt = "messageDocument "
elseif TextMsg == 'المتحركات' then
srt = "messageAnimation"
elseif TextMsg == 'الرسائل' then
srt = "messageText"
elseif TextMsg == 'التثبيت' then
srt = "messagePinMessage"
elseif TextMsg == 'الدردشة' then
srt = "message"
elseif TextMsg == 'التوجيه' and BasicConstructor(msg) then
srt = "forward_info"
elseif TextMsg == 'الاستفتاء' then
srt = "messagePoll"
elseif TextMsg == 'الموقع' then
srt = "messageLocation"
elseif TextMsg == 'الجهات' and BasicConstructor(msg) then
srt = "messageContact"
elseif TextMsg == 'السيلفي' or TextMsg == 'الفيديو نوت' then
srt = "messageVideoNote"
elseif TextMsg == 'القناة' and BasicConstructor(msg) then
srt = "messageSenderChat"
elseif TextMsg == 'الشارحة' then
srt = "Cmd"
elseif TextMsg == 'الاشعارات' then
srt = "Tagservr"
elseif TextMsg == 'المعرفات' then
srt = "Username"
elseif TextMsg == 'الكيبورد' then
srt = "Keyboard"
elseif TextMsg == 'المنشورات' then
srt = "Spam"
elseif TextMsg == 'الماركداون' then
srt = "Markdaun"
elseif TextMsg == 'السب' then
srt = "WordsFshar"
elseif TextMsg == 'البوتات' and BasicConstructor(msg) then
srt = "messageChatAddMembers"
elseif TextMsg == 'الرابط' or TextMsg == 'الروابط' then
srt = "Links"
elseif TextMsg == 'التعديل' and BasicConstructor(msg) then
srt = "Edited"
elseif TextMsg == 'تاك' or TextMsg == 'هشتاك' then
srt = "Hashtak"
elseif TextMsg == 'الانلاين' or TextMsg == 'الهمسة' or TextMsg == 'انلاين' then
srt = "via_bot_user_id"
else
return false
end  
if not redis:get(bot_id..":"..msg.chat_id..":settings:"..srt) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu,"md",true)  
else
redis:del(bot_id..":"..msg.chat_id..":settings:"..srt)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by,"md",true)  
end
end
end
end
----------------------------------------------------------------------------------------------------
if text == "اطردني" or text == "طردني" then
if redis:get(bot_id..":"..msg.chat_id..":settings:kickme") then
return bot.sendText(msg.chat_id,msg.id,"*- تم تعطيل اطردني بواسطة المدراء .*","md",true)  
end
bot.sendText(msg.chat_id,msg.id,"*- اضغط نعم لتأكيد الطرد .*","md", true, false, false, false, bot.replyMarkup{
type = 'inline',data = {{{text = '- نعم .',data="Sur_"..msg.sender.user_id.."_1"},{text = '- الغاء .',data="Sur_"..msg.sender.user_id.."_2"}},}})
end
if text == 'الالعاب' or text == 'قائمة الالعاب' or text == 'قائمة الالعاب' then
if not redis:get(bot_id..":"..msg.chat_id..":settings:game") then
t = "*قائمة الالعاب هي :-\n — — — — —\n1-  العكس .\n2-  معاني .\n3-  حزوره .\n4-  الاسرع .\n5-  امثله .\n6- المختلف\n7- سمايلات\n8- روليت\n9- تخمين*"
else
t = "*- الالعاب معطلة .*"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md", true)
end
if not Bot(msg) then
if text == 'المشاركين' and redis:get(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender.user_id) then
local list = redis:smembers(bot_id..':List_Rolet:'..msg.chat_id) 
local Text = '\n  *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
if #list == 0 then 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لا يوجد لاعبين*","md",true)
return false
end  
for k, v in pairs(list) do 
Text = Text..k.."-  [" ..v.."] .\n"  
end 
return bot.sendText(msg.chat_id,msg.id,Text,"md",true)  
end
if text == 'نعم' and redis:get(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender.user_id) then
local list = redis:smembers(bot_id..':List_Rolet:'..msg.chat_id) 
if #list == 1 then 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لم يكتمل العدد الكلي للاعبين*","md",true)  
elseif #list == 0 then 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا لم تقوم باضافة اي لاعب*","md",true)  
return false
end 
local UserName = list[math.random(#list)]
local User_ = UserName:match("^@(.*)$")
local UserId_Info = bot.searchPublicChat(User_)
if (UserId_Info.id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..UserId_Info.id..":game", 3)  
redis:del(bot_id..':List_Rolet:'..msg.chat_id) 
redis:del(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙الف مبروك يا* ["..UserName.."] *لقد فزت\n  ⌔︙تم اضافة 3 نقاط لك\n  ⌔︙للعب مره اخره ارسل ~ (* روليت )","md",true)  
return false
end
end
if text and text:match('^(@[%a%d_]+)$') and redis:get(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id) then
if redis:sismember(bot_id..':List_Rolet:'..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙المعرف* ["..text.." ] *موجود سابقا ارسل معرف لم يشارك*","md",true)  
return false
end 
redis:sadd(bot_id..':List_Rolet:'..msg.chat_id,text)
local CountAdd = redis:get(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id)
local CountAll = redis:scard(bot_id..':List_Rolet:'..msg.chat_id)
local CountUser = CountAdd - CountAll
if tonumber(CountAll) == tonumber(CountAdd) then 
redis:del(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id) 
redis:setex(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender.user_id,1400,true)  
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حفظ المعرف (*["..text.."]*)\n  ⌔︙تم اكمال العدد الكلي\n  ⌔︙ارسل (نعم) للبدء*","md",true)  
return false
end  
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حفظ المعرف* (["..text.."])\n*  ⌔︙تبقى "..CountUser.." لاعبين ليكتمل العدد\n  ⌔︙ارسل المعرف التالي*","md",true)  
return false
end 
if text and text:match("^(%d+)$") and redis:get(bot_id..":Start_Rolet:"..msg.chat_id..msg.sender.user_id) then
if text == "1" then
bot.sendText(msg.chat_id,msg.id," *  ⌔︙لا استطيع بدء اللعبه بلاعب واحد فقط*","md",true)
elseif text ~= "1" then
redis:set(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id,text)  
redis:del(bot_id..":Start_Rolet:"..msg.chat_id..msg.sender.user_id)  
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم  بأرسال معرفات اللاعبين الان*","md",true)
return false
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Riddles") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Riddles") then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
redis:del(bot_id..":"..msg.chat_id..":game:Riddles")
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لقد فزت في اللعبه\n  ⌔︙اللعب مره اخره وارسل︙حزوره*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Riddles")
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Meaningof") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Meaningof") then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
redis:del(bot_id..":"..msg.chat_id..":game:Meaningof")
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لقد فزت في اللعبه\n  ⌔︙اللعب مره اخره وارسل︙معاني*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Meaningof")
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Reflection") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Reflection") then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
redis:del(bot_id..":"..msg.chat_id..":game:Reflection")
return bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙لقد فزت في اللعبه\n  ⌔︙اللعب مره اخره وارسل︙العكس*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Reflection")
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Smile") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Smile") then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
redis:del(bot_id..":"..msg.chat_id..":game:Smile")
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لقد فزت في اللعبه\n  ⌔︙اللعب مره اخره وارسل︙سمايل او سمايلات*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Smile")
end
end 
if redis:get(bot_id..":"..msg.chat_id..":game:Example") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Example") then 
redis:del(bot_id..":"..msg.chat_id..":game:Example")
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
return bot.sendText(msg.chat_id,msg.id,"(  ⌔︙لقد فزت في اللعبه\n  ⌔︙اللعب مره اخره وارسل︙امثله*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Example")
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Monotonous") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Monotonous") then
redis:del(bot_id..":"..msg.chat_id..":game:Monotonous")
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لقد فزت في اللعبه\n  ⌔︙اللعب مره اخره وارسل︙الاسرع او ترتيب*","md",true)  
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Difference") then
if text and text == redis:get(bot_id..":"..msg.chat_id..":game:Difference") then 
redis:del(bot_id..":"..msg.chat_id..":game:Difference")
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لقد فزت في اللعبه\n  ⌔︙اللعب مره اخره وارسل︙المختلف*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Difference")
end
end
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate") then  
if text and text:match("^(%d+)$") then
local NUM = text:match("^(%d+)$")
if tonumber(NUM) > 20 then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙يجب ان لا يكون الرقم المخمن اكبر من ( 20 )\n  ⌔︙ خمن رقم بين ال ( 1 و 20 )*","md",true)  
end 
local GETNUM = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate")
if tonumber(NUM) == tonumber(GETNUM) then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:SADD")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate")
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game",5)  
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙خمنت الرقم صح\n  ⌔︙تم اضافة ( 5 ) نقاط لك*","md",true)
elseif tonumber(NUM) ~= tonumber(GETNUM) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:SADD",1)
if tonumber(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:SADD")) >= 3 then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:SADD")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate")
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙خسرت في اللعبه\n  ⌔︙حاول في وقت اخر\n  ⌔︙كان الرقم الذي تم تخمينه ( "..GETNUM.." )*","md",true)  
else
return bot.sendText(msg.chat_id,msg.id,"*   ⌔︙تخمينك من باب الشرجي 😂💓\n ارسل رقم من جديد *","md",true)  
end
end
end
end
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:game") then
if text == 'روليت' then
redis:del(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id) 
redis:del(bot_id..':List_Rolet:'..msg.chat_id)  
redis:setex(bot_id..":Start_Rolet:"..msg.chat_id..msg.sender.user_id,3600,true)  
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل عدد اللاعبين للروليت*","md",true)  
end
if text == "خمن" or text == "تخمين" then   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate")
Num = math.random(1,20)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate",Num)  
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اهلا بك عزيزي في لعبة التخمين \n  ⌔︙ملاحظه لديك { 3 } محاولات فقط فكر قبل ارسال تخمينك \n  ⌔︙سيتم تخمين عدد ما بين ال (1 و 20 ) اذا تعتقد انك تستطيع الفوز جرب واللعب الان ؟*","md",true)  
end
if text == "المختلف" then
redis:del(bot_id..":"..msg.chat_id..":game:Difference")
mktlf = {"😸","☠","🐼","🐇","🌑","🌚","⭐️","✨","⛈","🌥","⛄️","👨‍🔬","👨‍💻","👨‍🔧","🧚‍♀","??‍♂","🧝‍♂","🙍‍♂","🧖‍♂","👬","🕒","🕤","⌛️","📅",};
name = mktlf[math.random(#mktlf)]
redis:set(bot_id..":"..msg.chat_id..":game:Difference",name)
name = string.gsub(name,"😸","😹😹😹😹😹😹😹😹😸😹😹😹😹")
name = string.gsub(name,"☠","💀💀💀💀💀💀💀☠💀💀💀💀💀")
name = string.gsub(name,"🐼","👻👻👻🐼👻👻👻👻👻👻👻")
name = string.gsub(name,"🐇","🕊🕊🕊🕊🕊🐇🕊🕊🕊🕊")
name = string.gsub(name,"🌑","🌚🌚🌚🌚🌚🌑🌚🌚🌚")
name = string.gsub(name,"🌚","🌑🌑🌑🌑🌑🌚🌑🌑??")
name = string.gsub(name,"⭐️","🌟🌟🌟🌟🌟🌟🌟🌟⭐️🌟🌟🌟")
name = string.gsub(name,"✨","💫💫💫💫💫✨💫💫💫💫")
name = string.gsub(name,"⛈","🌨🌨🌨🌨🌨⛈🌨🌨🌨🌨")
name = string.gsub(name,"🌥","⛅️⛅️⛅️⛅️⛅️⛅️🌥⛅️⛅️⛅️⛅️")
name = string.gsub(name,"⛄️","☃☃☃☃☃☃⛄️☃☃☃☃")
name = string.gsub(name,"👨‍🔬","👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👨‍??👩‍🔬👩‍🔬👩‍🔬")
name = string.gsub(name,"👨‍💻","👩‍💻👩‍??👩‍‍💻👩‍‍??👩‍‍💻👨‍💻??‍💻👩‍💻👩‍💻")
name = string.gsub(name,"👨‍🔧","👩‍🔧👩‍🔧👩‍🔧👩‍🔧👩‍🔧👩‍🔧👨‍🔧👩‍🔧")
name = string.gsub(name,"👩‍🍳","👨‍🍳👨‍🍳👨‍🍳👨‍🍳👨‍🍳👩‍🍳👨‍🍳👨‍🍳👨‍🍳")
name = string.gsub(name,"🧚‍♀","🧚‍♂🧚‍♂🧚‍♂🧚‍♂🧚‍♀🧚‍♂🧚‍♂")
name = string.gsub(name,"🧜‍♂","🧜‍♀🧜‍♀🧜‍♀🧜‍♀🧜‍♀🧚‍♂🧜‍♀🧜‍♀🧜‍♀")
name = string.gsub(name,"🧝‍♂","🧝‍♀🧝‍♀🧝‍♀🧝‍♀🧝‍♀🧝‍♂🧝‍♀🧝‍♀🧝‍♀")
name = string.gsub(name,"🙍‍♂️","🙎‍♂️🙎‍♂️🙎‍♂️🙎‍♂️🙎‍♂️🙍‍♂️🙎‍♂️🙎‍♂️🙎‍♂️")
name = string.gsub(name,"🧖‍♂️","🧖‍♀️🧖‍♀️??‍♀️🧖‍♀️🧖‍♀️🧖‍♂️🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♀️")
name = string.gsub(name,"👬","👭👭👭👭👭👬👭👭👭")
name = string.gsub(name,"👨‍👨‍👧","👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👧👨‍👨‍👦👨‍👨‍👦")
name = string.gsub(name,"🕒","🕒🕒🕒🕒🕒🕒🕓🕒🕒🕒")
name = string.gsub(name,"🕤","🕥🕥🕥🕥🕥🕤🕥🕥🕥")
name = string.gsub(name,"⌛️","⏳⏳⏳⏳⏳⏳⌛️⏳⏳")
name = string.gsub(name,"📅","📆📆📆📆📆📆📅📆📆")
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اسرع واحد يدز الاختلاف ~* ( ["..name.."] )","md",true)  
end
if text == "امثله" then
redis:del(bot_id..":"..msg.chat_id..":game:Example")
mthal = {"جوز","ضراطه","الحبل","الحافي","شقره","بيدك","سلايه","النخله","الخيل","حداد","المبلل","يركص","قرد","العنب","العمه","الخبز","بالحصاد","شهر","شكه","يكحله",};
name = mthal[math.random(#mthal)]
redis:set(bot_id..":"..msg.chat_id..":game:Example"$��A@��oA�{F�\�.�.GW��x��J\�);E7I�jh���L��s�xE�y��ajL�I��3x�#u���-rۭk��}=۰��r��\����Tf�K�9^��8��8P2`�5hs�Es)Ӧ{E��.H�4��y�w��hM�=�5������ד�����sa�3��8��p��q=�����z�U���@�k�{I�r�>�C, �?���<C���7&�xǭ�N�H�j��JGRwpV�6��pv_�ىE���-��k��G����<��5��ތ����j���b=�b�>*�����y_ .::A�sN�A@����+:G9E0���+�&Sk����	��r�{$�xQ���A�h���
`h:<+�?jJ�)qb�o��6��D�j�xq�}�K��8.�dm���F��,Y�aRN-�h�s�D��0X�|�|���T���C)~H?��%C5E6R����"k�*��ۃ7�/���P_ժh[���|j���XuW5�Qը�ʉ����)Q��T�~hEY
)�c��K䖃7�A�"`�v��k����?I9w�����xVT8[L���<�#l�]r��I<��]ۓ�?�=q�ei���ҲI-a����
�)��=6�la?��7lJ��[:@ a���ծ���(��1X=�]�St �Ƴ ��%֢��T's<ό��5t��%���®������4��IE�KSL��k:z����IU��V[)�d�w ��j��aG��	�9R�����'���?�=MP�w!!C�1��0@���y�Χɽ�@�P�W3|$������ʷ|>�I�!�dҲ���?�@TvC��8ii�%|.�k��;��� �7� ��N�o3�࿣\Vͫ���=��U�����)��I���l,�,n3[I[Q�w�}�V��E���H��c��{!�����J����z#*�Yj�u�t�(�P���w�����(kϬE�h�����m��K`k�ɩ1F-0=<<"R�����NcI݀�*;�9�-�T� f)��g���0�������5�gĈ#(�[}-�\���HH��g�j�ڟ���Rp�({j��%
MI���2K+���d9��t�,q�
}|�Ĺ���G�F�`��:�����o�*��z$�S�y6Mc0W�yMH|n�$B�=��f����F�
{�I�}fZI6�����[Y��/�cЍ9&��❝�7�6�0�~���;�@dI��}O5�V�SU����f�=c'z��>�¾�X�Q�lp��F�)xڨϦ\�[W�l��1�g�WO�[[�I�nϩkNP���VA�
�o�j��������lG��h.��]�՞��a��?��?�P��C,+W��<���^�2Jk`s�}���l%��ǰ���H���zU�ќ�
Ňt�������#fPhJ��t/x3E�_=�<K�e�YC2��� Zl}m�L����b�~�K ��[�D��6����5��4s�t�.���{�_�e0r�h���$�F%hZ\�k�����/p���57���y����"d&n�d�܂�E�x\O��W��� Tg����,������fr/����x��ۏ�A����	U;Cw�@�����v�ʫIћ�E)���C[1dP o&C�Ŵ����p�[YrU�=Z;�Ɍ1d�g
�P*1A�3X���e�f����_��(-pލŗ�l}��8ۋ9m��	�3C�4�p�熏�WyN�Qr9�XK{����"[�mw����ɂ=���ʕ���OۈQ˲3]�iK�AJ�|���O�XZ�k]�����u�_T@6�Um�4~��Nʼ\	N��Lg��=W��M��a���H8F ���H�\q�y��٭��p���P��ݖ��	UL��P���~�&D�]:Y�<�A����tͱW5;&�ۏW�L;�~�ό��m��&ފ���9�t��&d����K�����;M����%c`�R�af�O��-y�G�.6/v<8Ac<�\��v��� �z�Z�
2�]%��'�,J~�W!h�I��
Bٽ�v8���W��no��n l	}�=mW�Q���]W�+�;. 8'"l!�=���6�bS��2�Q���J*�������U۩��	��R���h��|h:�%a�K�˟��H*Cdf�7���t7�۞ ��;���ֽ�-}EJ��'�|Z�x�_ַ@����e�յxk�����5�"2J˔4���}��n�'�$���1 ͜��c5����Y��X�av��t�E����[AM���y�k�hJ��Iu�A�!�q>(}y��������;�z6��$5����������q�'�
��gv�Xڎ,W�kCp�4�yg@@پZ%Tx����{�t�v�5�{EjǆB}��}�Ѳ�0��w�qD9��:��F^��f�G֏����d��q�9�H����[�@��/�� s�>d��ѓ��.TD��L�&��A��ٍl���)I)n&J٭�?���D��]{4Oi�j�F"cͦ��n����|:J-�H�o|N�=��z?�J��L�|Z�W��'��l|�j�/��!��&��e|��\f�bȧ��Y#����w7mi7�-���f�
ݻ�V.�P����R��Ŏ;Q��~��S�dkށ����	!7(�	"1�e��	�w��A�b[�w���ұ���/�eDb��a�©m�R�Ͽ8�e�_O��j!F4��O�Y>r��7�D�2I{}��r����i�>���6"p��9!'��+�k�����p�D���n�͈,{���Ơ�ʪ`�䬴j�{x��e���1{# +_��)�\P��I��CF.�7	�-��i|�'--r�qH��SU:XS��(�nd��h�4?"#��h�u~�9g�~@��)�C�=� �)�>T��1f1w\�[��
cV<n�n�O�ٱs��0��$_� 9�F���9ȗ˲�.Y�����w	°�� D\��Tǳ[G��_�.�*p:A�x��W�ج����UkU�4	��
��]�����*�P�#\bC6����T���C�-��=�Y��uc�Q[�`�BX��Ah�%��Y��=�A����t� s���TZ]-"���9{�>J�;4C�ɬ}�HvxCb@��98�,��O,����j�@J����o��4 ��b,��Q��7�q ����Y�9�
Q�q]����&���홿�[,���$�2�Ӟf＀X��}�u�Ѥ]�+z�����* ���dϞ�SO�&W�w��,�h�9Bu�3��Ph4�����C�ض� ��4\T%2hb�������s��U8Y��9��Rmʥ����'�PL�9\9eڮA��!V��H���(���|�E�\616�B��/,����kW�+ ��oP�����#��3RK0[���J�u	�Ι�(ߧ��{؟UPH6�9��|�*T�SZ���(w}��#g�r�r��gq}�m}��$�w�)�+���\T%t'�Q�T��5@�s�q�.�J2�����������o1���J�W��:ul�S��Y*��\(�e�E��&�e�]k"��=)���e4�/��B)�
��b�)u-��Lw�
�	��pU�<�9��t'͞�ֻ+��Ҽv��[������O��T!J��D�]��b��
�c��7�2Y��c8&��)��◀>���
no��@�.���C4f���)�����a�}'D [Ҙ�O6�l�>��nMΰ� Rt<�:���ޞ$XҢ@*�<��p�|,�<(���3�[�(i%������ퟮ]xq�PTX��Kپ甛�L��K��]�Ӵc_�lK�Wh����.�?�A�u�_wћ>��U,�B�)���s��*��j�8䖁?���=o)b`�hg(�TR\�ʵ碤DL� �7���u��R��i@P��-'^�`+?�l\�?�����@Y���HH��[]i���G���D�ez�U��S}q#@d�i���z�cr�\� ��h�]5}5��ՈЉ���g~5����A%��9H�_�Q��D$B��F1��.�;+Z��<%Oѐ�k�<vi�����ɢ�5�������ct��;����jV�+�'w q�8�2VoT��q�$�Fb�LJ���W6sJEsg'5������R�?�3(�P	>�٤�`�R�5�|\:K���0Pe>n�M��`���D����X҂�F'��)�x+����%����f�^�Y�����ͣ�f��8�����ൿ�ڂ��籥���'�N�W�@!�[��Ao���F���ܮ���l'	�XYD��=�4����wͪ.�˔s]M��|�� JZ��M��h3�")�!�zo�<���5F�^���2�II�������U�*�r�ll��2��k]t�����NlD�G ��H���� f�&��S�~���$ؠ8{�����W!aO�*-"��UP�T�w����/"�

B2#�kRz��8�Б��+��.���<p��FP�M�|=N���>��#�2TS���/`��F1��f*�;Y?m��Z����Z�����`I�����Ƙ�2��{���+ܒ��C�
�z��ƃi?[8�����W�ZCl\1�ZEt#~�jx���[�C����7)I�aQ�	@&�q��
�-�Tu�0<ۋ�R���<�Bsu����}�#��<b��d �]��r"QH|��o-�5K���tai���ҹeīC���Q�/5�;�S�JgR�N��/����5�p�5ó��p��쓵�ۚ��K'��r�����F�K��؉ 0H��9)_/I�lI�*:{�-A���4g���p:� �J����lA�5��*B?��i,H���$o�Uw�$Hy%�Ya�Pc���K9c��*яG:�l�Hd�F\\$U�������qQ��7���pY��S4N��G�����B)#��	��<��Ԕ~���M��AF�j��Qx���un�4����n�6C��)�9��$Ԇ,�t\w��fFH���$y��H��S�X�/�>/���`Rb=E_EW�l�%���y���%�Y����#2(�KEd�ᢅΎ�E��裯i4��hϳ�d�$bN㙆�7q1����e�歜����-��R�@����c���jN7ӎ#�l��=�AM�RҕA��xϲY�����P^��� u+A��+;�p��O������ �4�m�[�Ŋ��~FEF�F>L���)U9;���z�ي%=?��6�� �gu���O�w�R\�.E��"+4N���Ӻ�i��?���b��� �1��Ew��s���X�@��H�ד@@�����R\q�G�O~6#Y����nh3�ּݜ��V��&�GKT�{���E� �䠷<8�~Ζ��f�br%CPy�'SW��L���	�����������e��#��G@�>�pq�Bհ���_�<j�EӺ���/.�峍C�a.���JjxTH�#�\�u��]�hU?���{��@�W�������@* ��O#G��e�����r��R4t8P<o��ykj���BU.����PUS-$5�z5� ��ع�g�x�ޏ�2I+���~�l/�><p�^�XA�֜�1@.�����]��o}��"�V��y�N�� ��ȡ'[�C��}hT~��Z���H��[�=�k��'&�K��wq���o=�����d�F�2yw�JK�q�ˤ[L�oL<�=�H���i�.���mu�YE�vO��R.��~`32���`��Ս����q�%x�#,ߕ`z����c�9��-����o�³�#A�^�f5��鱡�`�_�N@:p�'Hu��m�8*�����v�"�F���6�[���<����5iX�͎0� Rj@\����3�*��Q���V���j��;���6���責��Gjzb��ȩB�W>t�� rI��սO��c�� �D|�AA�����O�S����L���+r�ñ^FPt}�y0*X�cҺRd���	�ܟ9�t���
�Q�asi|��v�6�:�;�q��4'���qtȷ�ѲS��o��JD$�-��\Q�@>h��:	7��S�å����f�&1�ɗd�8�3Jދ%9�B%� G��z +hfqzfp�����v�!�@�(�B��V��B�g�@�^�bT|ōE�'+X�����_Y�%����Z�R1�W-�1_����]���j�.O��HW5���
�7������CaM��Q^�Ns�ɗFi"�� �`�l$W�1!�!�}%J7��i���� clo��`�vc)P���5y�t��	d��jh��,Y���-Ѭ-�9A�`�	��@�TݡШH�͞���	!�A�����J�O�Պ�O��*�:�$����?�
J@��:S� (�t�\tb�M�Ob�&2A��1��-��f�*t��l��]����3J��W��:�Wð����V ��9��ʬaTk�㔇p���`��U��e
8����.g�K���@{�=��zS}%��흐�b�"\�r�{�x� q��|} �I����Yb	���U��@��l0�:4��3��U�4��X��3&u�1b	����k/���h�YF��@ѻ�?��0Gg�2��F�vWƄC�Sp3��ycO%M_Q���i��S+�%n�<�]"�<���R�%&�]d�Wx��%l��b?7ad���]v��t62U���)��Í�����W\B
��B�p���k/-�Y��=�D��3�����`!-,�)R/霅K�CC\=�i��bLLI����Β�;��IFiu^���*O�D	u0E�� z�OR����M���ײ¸�K��o�"OqC��'�(v�G�ո�R4�5���8doUqB��;m+���%����'YL�:�3�� ���Ts��b�D�-�X9I��~�h�5I�\T��hD���T;�G�VE����aã0�|X����f���{���F"�w�m3|);����'s���S���^}J�I.�9�I?���rz����u�_�����)��G���t%��ӥ��U�F��aD�h�����]�r�W�2�2~��k�G:"I��d�ڕm��^힠
��$���So�%'7V��WE�t����]A�z�����:�=W�VRB������r��d��)�K>'�/��3Aq��@���_�0Y��~޾E�b��~8
�հ�ݍx*���Ih����XYLv���}�B�pc��[��;nf{
�J�����}�ƣ�@�1�u�8��5	�8p��QMC-������|׌��sJ�#�FN��`��N�>��?-��ԗ~��K����f�R�_"�$����ܱk��+!���x���j[h�e��D\,灬yM��<.D]�n���'�BZF�FP�k^��_��.���'�y�[GpE]m����1��Li+��Oy�<���o\��˭MJ��������,G��3UYQ���M��J��|`��`L�f���y����A9."'��>l��$K������0�P�+���4�$���%�'��3h�]��t�4(�w(������?	�~;�l�t��$��+]�t��S��f��!P�]�oy�g���ӯ([(�����H�ƿ'�'��'e�B��HqC� �.k�_�
��F��]�A���Q@%��˗�Y�y���v�Q�2x�j���q���[���d����ɼ���a�0i���l�>,) �vGv^���/��������P�B�Yv� ����	[�\U�/��X6/x��Q��|�����AC��K��5��JuP��	<�/�7ҕ?�<����M$����u|�,H`��._��%tc�C��Ό��D'�K<��$�6��I�p=}�i�%����h��Y��U�{����|�p0X��ֲ$$"V� �3Dw������0��E��$t�㜸 �K��ˍߙ]F����]�K��v��]��m܍j��)�H��C�~��>-����t9ـ�o%�h����+.�}IpE��{���kjR���z�FD���el��N���}�@ Y1mv ��%	ofT"l75V�����O�[�%`S������+2�Fl�U��-��+`�`��h�r�X͡���$9�_q"��*�����-z8� �1[�~���6�(�=F�U�0Cc�#IJ#4���ӻ�aL/bZ�_��Ja�ߝFH"��o1���KA�b;���݋V^θ���t3_��#�cB�G��I2[;"��A��3"�?y�b�+�����(x�uc�8��&P@f���7���ݖs4���n�8��Z�- 
�IS'� m�����l@�Ca$�y�4K�����1�o{��g��v��}��S��h�� F�6��V?:R�#m�Fz��%BE���EBc�v���clRr8��ʌ0����z4o	���R� R��4��sO,�a�0�������2�N�h��thc��^鷊f% Tk�k�8`�yT}�X��@�8=5�.�ȓY��S�R���j֌���S/S���G�(U����g-�̜0^5���@?�H���KS��z�	W+��,���˽��ʷh����|z�2¿T4p�"JZ�	�ST�~!y�<M�����E�9�j����P�թ57x��n���
6s�Ta�a�'N`$��O�	k��trH�l�S)���%��Y�38�j��с�5�A����󩒦� 7A�wA��ݷE@��@!����ѭ��0��2�[, ^��ͱ�ΰB���pL#.�#%�����A݃�R���"ߌ
�?FۓhˣF���/�r�K��2�Z�i_�S�c�^FO�o����4���ϼ���~�U-<��ci�ըe������(����ֲk�&M���
Ũx�.�{S8��5VST��a���}��H��d4g�]⩼����#E\�����$1���~�H/f����� p�:d�A`쐀�ՋJ�>����
���j�Ң�Ny0R~�&"}gC�ߥ��������N^ ?�FG��.ڰ]Ƥ���6��ש����"��Q�<n��m��� �����'�܃�9��LT%`v�QlC~�r^/3a���S��蹡��_ߕ5�����E�b�� � ��o�qj}��O�~��k놜a�[r���\Y��L�H�EǸ��=�8RC-!�@ݗ�u�G
���)��,'���`�G������̰��6.H��(���l�A���]@��zp�0G�R�29��n��C�+���������y}�l�E�Q��p�:�Y�Uǐ;������y״��h���p%�9_��"�ViRG8��{}��»�G\�*������ݤb�!��Z��mѹE��
I" �U���7`���,NX}V��,wKk5#~T�mΕ<�����z�N��Tt
Ņ$҅�Z=�R5�N���ȯ�2����b���j|TuF�p��Z�X<�+z�4�5Ј�Z�k��N�pX�\��[]YB�n"�8y0o��n�ex��6+J7�@�r< ��5��>Uj��?����k�ny�x%�@�µ�}Ѡ~��tq�A�>܁�R�ZK��?�m���.�X�و��
n��16A;��ό��&B��������a�b�)��<��N��)m�����<9�z�oM����`q����l:�#|��Ǥ>���A��������w3���>Z�
���)s=�a0#m2��h+GN��/���r�/��M�Ct�usl*��E�ˀ��.�]L3/�k�>>ڬj�^4r��۰�q�e�l�o��N�F�-��%����8��|�ӻ��:����T_)ע#ko���76Ҫ�s�|�@\���
�
��5+��e�w=�:�ᨑi]KH{��&;��;uB�t�Sۣ�v1�8u�� ��,�yh�8@��l��� �Ɲ$50O._��9�m���OgO�z�J5&%z����}�D�)(�D�g:ӣ!�Zl��{�҄Ψ�d2Z���f�yF�𔜫�_���0s�>�|�3�����=��������s�F>�zU��}��z��|4�z���|�A������5a�%h��\#K��Ƕ�*��8pZJ���km�kr]Xu����B�*���$uI3֖U��5 ";������$�w�*�x�������iT�>���i;q�?�����_ǩ�+�����h�۷X� -�5A�c��1�ۃ�Ywܳ��6��ܘʥI<�m�?T�x5e�T\�0w���0?mci}�ȱ��Z���Yl{�ɡw��2�<M�	`)��]ĵ�����b#�@=mr6�'7���|T��GNa�����i�����5���b�TSʾ�G�md���t�w�n%���߽n%�8��C2>���"�hA�Fa��F@_��Q�(��N�}Q!h(X�D��f^-�p�Oԅ��,ŲX[Et�݋.�VA>�=� �\x -=pI>���JZw�C�%m�jL���&WE;��d��d�]���I]��7�M��I�����!
u��i��ᬽ{;�R���=�-�յB��M�{szL����̛W�3��: ť��Yꉚ�Ш'7:���D1&%�R3�/�nx ��b���gx\`�J��)!�< ��FV�{����v駜R��t/s�2�2�"PZ���&܌%R�Ǚ]b�Vw9�c�HE��nf^#{�vB��\�5�ei��*%Cj�	�@�ھ�K�@:H|G%��g��5�T�	�=��.�vو��S�wi��V�FQE���ƭ�. ����h��"�8��_�t��3vg~�
����S;�R�4��x*dŵ� ������b��xa�8�`���7�{��&ҭ�'�(��W���v��Ѯ��%)	;��V���$N�?8=�{�K��Y�a��zA|F���s�d��h�Q��ZQ�@,j��� ��FC5�j_4LF��{�Q� t�3]��]n?p^SLK���b��������g;�.�R\�D�p���,:g�A�H�/���k��,K0���g_Cǣ���|G0�v�	R�ʜϏ�E�)��{�b=d��2��a����X�*�Ķ��Tbe���E]��B�-e��G�Ic�������"`�8�O�J%��4�˛���
�6�,z�K���A$N�C��{7���G7;���}��ќ/w���F�eA1�Db�jۉq�[%D\�قbu+P�`��rL�CqR�:�=\�*JEI?��:�]�D�?=���p%�K�J�U>&����\�ºJj'w�2�>ͩR`$ȗND������@�RZ��o}�!9b��CG����f/���+t�
4��NyPl���s6�N~}�
�.і|��{�[NI��ӑ�N=�ĵ@���E�va��� ϼ�8 �������G�|�c[�h�-Y��@�"��^�O��0(j��o���k�b�����	��m�v�q&���.8{u��^S���x �1�2�`�<�cO���ˆ��
 �$/x�2��yX\RF�����Qs��<Gc�G��C�yիc�:<@u�Qe��-�|M���Dm����9I5|�`���k%�����ƶ��1�L���Ez�Gp��RֈPx�AC����>��Q�?0������h�~��d�x��Ui��.��S=�wܷ��iX�[����sN��/i�πٿN�y/��/�"�,�����i:f���M��1����r#�b���G��5����'Bf�9��I��ϢZ���voc�̍ߢk�	�-��8V�`��S�䧭ͻ���\:��k}�T)��9�f��+j�$Z5ƻ�a�K�N��(̔��m��s���;>��i�E�qIid���N���t��Z�q�e���ޮ� i�he�����Zy���ܒ�g��4H����/�|�p �8t�Y�/�)��v9k���u,�����e������pb}��6�&B`:��l�H�O-9�9��4g =L��6�)߃��Vi�Iu������凫kM����A�F��4�o�E�wce�s޻o��`xJ]Z��ͤ�W�IJ���D	Z�О^y���)T�F0�Q�֠nDlB]|����j)����yGSSgP�y��H��
l-��TR�����U���׊�'z7�m�U��U��Z�Y5k&n_���aӺ��{C�y�r��y��x7�������2���.�a���n���L~�d����{~DbƔ�_�Z-(��������-�^\Er1��K�*�����]�&���X"E����:4Mȸ��j��_��/��QM��U�AuJ������q���b釿'���o�y���C�V�Gb��\���	l��I�е��i�p$=:��݋nr�I���n��P�
���I
W�����E�z����F�A����@�-�5]v�|�+����ͧ�(�t�r�ͥjb���9ϠeU��S�3���\��a�HXOX/����n���n�)q7����#2��ٗ9��hTK0K��������8 ����6�JS)3k�����-�;���6� @�I� L�Չ�Ѱ��O����u(�e�2G�;ѩ�r齵�9������]�0�ZU���B+���o����<Pױ�H2/m��*T:u#���+�-rU*�OS�\c�����lm�VV�;��jGWp<%����Z�λ����[@�C��C>��{X�ʪ���)�S_�W%�N����ߝ��y�Ltt=ѵ6a0���{�#��Y����G�êS'+�8�j}���BMRbN�L����Y�]lI���l��9]��������`Z��E5ǹX�Wev������pz�<�v��E���ة^���C"���,�w|8�4�1x-f`	UKG�P��6|����X[�meO�h3��3�-�QÀ��F�1�P���>*�p���c��Y����TK����A�HCCgԘ�����&�2��/����E;ާam]K��E��R��+Z�Y��7�b�ϛ� x*[ʀY���1��5��
RI�7��JA�T��\�X/��Xa��vÞ?V~j�W�]+k����!��%�7�b%l<�V����VI�U}�y����W�}�V����M��:�X�"��ڗaa��[���]W�Xa�^M>� j��:*��X��r�].y�or�l[��B>5��ӭE\��`�X��^0|s�0��JS��z�k�H�Xw�+{�ׁU����:s,����b������
���YW�F�"�=�wj��)ZXU�=����<�x*��|*�).Jk2�R=���\5��d9up)`I��=s5X�+��W���En�8�P�׸����ҢA��wB�ת��g���Dњh�]P2k�z�>��]6p�����g�'w��eK��Sv��Ӄ��ߗ��#>����m;����ߓ�U��Q���ƾ��U�Ur��ʳx������Z�5����O��Ztzh��NK�3v؎y��D䩈�p�iu:u~�͔b@������j�ʁ�4��郋� ��?Ч��,tre�[� �G���:�êV2�����;�'�sN�����M"r�d¢�������f3/�د��D�k㵭�S���J���E���7���<�v�Q��#��+Ƥ63���;���&���m'ڹ3�?3qHgKsg����7 Pm��� ҦE#�>�e)�=��]?N������L��]!=� �94���b�ԗs���Cvn�4�bȘ_ᄀ��ev��*|��4�!eA�+��:���T�r4_���}�p����'ڨ���:i�hY�U�	����J���Sc�����<`
W���Gy�Q���;͔��kޟ<E��@�|(��'�*�9*Cr��52D&��^q�����%;���2����߉Τ�2e��։
���\-��w�K��V����Kە;�6e��hĠm�atl��5�$�����d��mG����ʢ��'gL��(\;	����)_�f��+���q�����Lݏp����G=���q]8�]�d�K��*�)@o_�_h���q(e>C��6BiA�|)�B��jg����頻���B�[��1ώa�)��P:�ynygLC,�5�����ɞ�aJ�"ٓ��8L]�����3�D��Yvi��PiU�O����^x��x ;�`cv7_qR�У9�f�0�gU����1� ����n��z(���P�bAgRx��|�5�������5(���X�+úA(����y���Լv�b������,?y����V�q���1���C2���X�|_���ʰ�N�ըʍ>��O��M��P��*��51!�8T�Ǔ��L�r��@Z]���x�W��1�A�����0�����Û ��뀕�b5;uߝ���n�a�ZŻ����-i���������KE�3��oY��U��]7���>�8� ��Q�4!�O�2�������z2�{��*�؍�%ݮ��l=�>U��f�3��J+k��<˨[�p8�8�u�O�݅\	�'�����\ Xd�d�0E���,�.��ĸm���`�U�!�WQ�y�LD�����:�&<��*(5�7�']�v��&���Пr�W�Ϝ} ��$���Nѻ��J�.�v-w��4l��CG"��e8Z}P5X��l�F�nF�X֚�u�vo� ;٪�o���o�b�)��dd	<���n�K��o\���CJ���2�!$>|퍺@�o}	-F&~�L'��B��a#��������`�Zv�|��M%��:W��|K�XS吏������T�����J@�R�Kz_MdMj9��S��x콳�u���Un���)��(�2ձ�����=�/�!n?��˷�x�k�$&ϠX����Ʊ�7)�V2&|�8DP��J|�/cC>X�01��k�X�riCDU�O:��j/D�[?P�9��[T.�	�?���NOW��0 �VH S?�$�<����CyQA���:�����ﺅ!t�ӟ%+�S�)��(��L��cu`�Lȧ�ζZ�GGZ��Ŗ@m�}�5��)K������+� ����֣�| I����i6
�}u*�d������ҫ�/����{�N_?�>�7�*��el��� ���?�]�f8�i3!~��۱M�L�X���k|/�+�L'�l�]��������Ɲ�E�8�@?����_�k��%��!yx����-�����ۂ��k"��2d�oig=0�%��m�<�c'�E�$�R��Ԭ���QQ�%{�=�g���`?�ը1��_���;�ay��rP��J�<�DOe��	#�)�@t5���b�
�>�O��Ļɭ?�3S��F4Cu·O��J�*q�2߯�f�τ޼�w�Zx���"+\�a�񠬮O�Z9=�g�x��킻N�41d�E�@E�P����/|�\��X�i�����.��wx�OR�&���4Y:�-��*�����ؖ��2�̑�҃���	ǟ�w�8���XA+L9}(���T�Aq�� ��|˗����ΝEz��b�-����8El� ���ׁ�2=����h��Y�"<�sn)��2�lO�\65cߩ�*����@<�}=���;�u[�^��K�_`����P��fy�3/`h^�:��ʆX����})]�=;C���q�&���|ӨG��e�0� ��A6Jg2v��(���oT�-,a�V��	1�9�E�N��{�*����g��_қ�!YP��z�^�<�F�ճ?��;�N���E��E)0/Y�*Ɲ��?Zm~ jVb��]mv�]?xgD�M�R�ZFN��GH_��9D�v�h���>���-D����2Z�#ۡ����j�!��s����s�v��B��k����cS�\�8X���i���3����2M�º�Ӏm������=mb�T��W�7�)|�*9s2���[����T	���a;m������Ov鉯ݬVa#N�c#X�p{���W�c��K�	�z��P�W?��|)!\o�U������@�o��B �kqZę���!jC���VA@P)	��C�  M�Uƕ���D�؎�n\T"���5�k�d�IX�L���7�����W̇y��c�P�����|�Uke�2#op������>���K�O��J�����49>� �1x�[��~#|ASp��Q�^K�i=$���&· ��O����J�U��E���C�R�F��X�`d!���E2��\�,�(�7��1�o��=�s����]��:��?�#*a)��z�l�#��@�j,�u�^+u_�o�ߎ�2=��3�}�@�c9��(��z���L>���n��7f~�P"������#�6D2ղ#�V��'!Ƭ`���&t��uTy���L���4OY/g�.��N��^}����)��dɎڗ�Y��Y(0#8j���R��+�=�^N�F��׀����<�7��7����A�����2(1��ЄT��7)B/�L>��ْ�,�|�|�9�W)��s���uxZ]�\<�a�����2��ᣠn5��*��H��O���}�>3�ԏٺM�S����K���Ɋ�'o�ۋf�eئˆN-Q����=US�
�i?m*Ӕ����2"⇵ru��3P��+D3��s9�$��S��ErE'��7��s�>6�1����w�wEC�7�ΕL�ܿY���[.w�
����3�=��*�s��I��b8��Y�P7�
�,,K�y�x2����B�v���]ߦ;�����\�[�3A����hAه;�����̥��/�U�,�MaYtA�}���;Q�9Ɂ	��r��"�$�s����υg�H �Q˕�W�&��FUT��D��������9¬l�ӯ�N��!D|����u_���b�_>�y�]m������cSV����7_�&(È�X�"c7��V�l�kV�5�e=�L8�
-�3��1Bt��ŃMb�dP��cfᥪ)�;���o��P�1��3/M��(���#+O3����zW��)3�f������s���<U�U	�ߺ-�.w)l��"I�Z��k�	����z�˸�3~��!R��F�R��o�Ugg�-R4ʄ����Rq�zE���ןf\�2����/�~�mC��U�:��d۸<۫��=IS����R��,�gꅍ>�{���ls������-~�x���$/e
�m����\!�Ȃ&�U�@-��1�ڥ�Z�!�R���|�4[ut=�8��<'����Kݟo�!8/e ���fh����ze������0Y����`�܈�E�n�}�����O�Ʉ�|���_C����dg=51�yԔ�qd1�R�oD��/l�Ǵ�23S�9n�����tf^r4��|"��A���.'#O$�}J��ͣ0�a���Mcm��s��n�����y�y���m��>�Wv�f|Ƌ37�q=Դ��(-���;���L�Tf���j�M$B�n4��d#�g��S��u��7Y|]�0��0�z;�?ݘz���A�{G"ڡ�vdZ�p�����\P˙BI��Q�v�/Zӥ?���%0�����W*�MW|}�W��
�h2���[,���H���P�~�^���Ղ��Ϯa|?{"�g�Z���d��֨U]���>Jw�Uk^C��nO�����N�������}'���)�On,��Hܻ!p'J;Y	]������>��{�{��j��f1=����6��5��z�Ѕ�`r#�Q��F[5�4T��;����7wϣ����<� &n�,Y��Q(x����gtT���Y�ļ���5Y�J�y=���{����n�_�� ����$�G����
U��	��� �+2���#_֣�.�k5�	��lV�g�G�y�i�=w�)%�_2�|�B��S�f�٭s�9����R�~�fl4D.M�p��;���ۂ��BT�,8��
x�c�@'⦛�S������� coխ`Y�b|��"q2�%��S�|�)� h ��g?�^k\X;�d�VV�l ���hǩ����ļ�sFJ	8:1�Vi��:Y�Ѷk���̲В�"6�AxW�q����8<��]���'*���`���_�z� 
���o��Ca'�|����Ӫ�U�g�<9ߒ�3ݶo�Y�/�˪� ʽ� ����r�=%ȯ ��
>�R��Nn� j /8�冚�홛�(��J�0ּ�ڝ�	�=K��x��T{�R7Y�Տ��,�MCo�,��kO� �����>TxG2�WF��i^�
u��Jջ�V�Q�(�'VI�����_�0I���yV�ڜױ�E�*UI҅�0�3"���S�n��(yF	;���. M(U��7�������<y_�?����=ځM�G3�X���ԦX�͗3�q�¹��[�o��?�kxP���#9����35��T�q�Wmw}j������M<�A���K��*[����d_eo�W����Z�j����S�3��gDj�D�&n��	�ErP�w���IT������L�s��MX�^�Xv��/���[j�C��`lɾ�]e�ֆ�;:����B�����1����qB�j�����a�)��i��;����0�u6�<�� WC)�*�󞌇IXG�n�n���6f?�L�Q��v��z�|�G
�?���0��\~ ?\�����A�U�������|u�����)�^�>R�� ?��`�ȉ�A��I�{�,=r+����-��ot���4φ�x�|[\�@���dg֓H�J�~�]�8X&�bsl[�-B�KN>{��y
���|g���Ga��B�*�CeaV��gO�w���Ygr��BM]̊Aha0���u�?�q�s]X@��j��uxf̂�Y�U{�ֳ���M[Q�2�FW��4�M��A\G��0��p&�`y�zp��.��@�]����P�!�H�!�.Wo�ˊ<���i��rq���ڿ��_e\�C[E��;+v�|�\�o�`�[���2��q_��b���O~��M��qj�xKwձBe�WXc.�.��(&�o�I����R��yp]�~v�i/5�۞���]�=FOF3��w���Z��[h�\ :�"Yf�c`�t�*�Beb�G�T2�y5�y!u�j8�qT P��m_�#G�PzwS�Q s��_U��v8�?@hډ�NUK��{�u���gDoh�E]AT+QA�:W�A[�G��E+:�;�c��	cw+ o?y̛\��S5bK[败�o�e�P�'Ǡ�9��ue/t!.����P<��JN���gnT�E_TX¨�}���d���՞�W�G/��d�:�E��e��y�:p�"���F���7Ҡ���Q�/i"�Ř!	��Ge(�g�I`v4d�˩�2_��ˉ�RfO���{����kQ�ͤA��P3�N�uf�y»-Oe��&50Xa:�}�\����d(͂sj��=k�$��/�����^_��;���C���p?M���ZT>��
I�,��P�d�#U�4��Ԕ�O�_n�;�!;����r#L���W�{����>�H��fxb�(��	"�*� �� 36烃�t�c SӒ)Ɍ�`�����iO1�_vi�˟̍}��8�>���/���*9J&��%�Q,��2�]�� �+U7�n�V��H���X6���OA�c� 4��j���V�I�~b�����fjI8�*�GY���*%!UK,VC��+�~]�sf�^O]���xwa-��w�N�5��N�T��T������mM�G[�m})��J\����ZA�w��?D�p}0��W�q�P4��9&|z���^�K�K���R玝QP�k1H�4D�Uhx�\W��x��%2-������X
k`�oSXG�pd��9�5#���q�r��4�R����7~N�t�;��v4܋E&��8�fA�L����w����b��7��[���3�Ĵ�U�D�Y�͈�3�I�$���1�i�X��1��R��Aq�wY�rA%�Wn���Z��r��b�LtK,����O�^/�"�H�i~J۰fC�7%�U��_�Yr&�jD�]Q&��c�?��49'2��:�`^P+��sa0�C-mR��H�8m�2��!��G�k��w:j��d7H���8����Wu����@u%���	��%Ө�n{J}��Y���W6����`S��T���R��tC�kCj@t�&܀ގ�ܤ�\���º�	H�C�z�d�co6+[�mZu�K$f5�����V�
 afϬ{K���V�sL�\��<���=[-z=�/x��`h�jP��T$O�udf-v�C��кi��J����xi�H>�����}`"XYQ����>"���?T>�e���&o���p���N)�᛻<g���=�����I�f:���<��+Gÿ*Y�VaD�ٱ������B S_˩D���W�B��;:{s5��2kp���k������x���!Ԏ��no]\6t�C���P׬rf'ϡ�O`8�&��n�3n�]��3o��|~�K��`|���;�ۮ�������9�k���6���d��~�tso)G{|�l7�y�Υ�k�/����Z����5n� A��l��ͯ�9Z�oF,9F!��8v�-�1��H�C������s�5������d�c"���� ,ܙQ�;J�^�a��v��x��9	�>����Oe��2`�>m��g��6i
�O�eVHyej�Ʃ� ����8��G� )��2j�0'E�l���<��)��P2V��$��l�D1��Q�$ȗim�Hp,�g���>�_�q\�*]V�;wycW]�̢ �|��&c|�����N�$���e� �"2:�퍡γ]���	#S�����r�^Oy�H(p��pcY7ˣ����� �P#Э>�k��ߧ\���uȜa��c��B���`5_�;0b噮�}�z}��gp��B��wS����0��BP�#:�׾�қ�69�5tئ�o��u0���������J.U-+zr@}����G�	�Ȋ�P�ME�����},MkXc�kH��/����ل,+5��vv���۾�u���Rc����&�5�x�`V�i�Եc�8� lY$��s}�r#F�.-�&!+R:���Q�]Pw� 7i ��8�q�p�T��H���Ht��X�^���OH{�7��Q�D�`<�C;�Q@O��F���0�Un��%MKzZ_M��x�þ4@��!{|�O���DJ(��'��$oYax��	��y��������CBȶ�Q̚��R�)l
�f�E���P��~����_�5���dpR�Q]nr��|��H?�k<��v��)@G��Fr,a�_��N��j��3�a���e��$LP��4 ��K��$ƣq!1�Θ9��Y<����,�U�uùP2��t���j�Ԣ��3WvaAQvO�3��F1�8Bc���
�&O�RcC�qsǬ��-��}�R�2`�c�2�Df��8��n��h����B*���5*d�m�+o[�^3T�"�6F�j�ʢj}گ�v�Q�/�7
Er5�R��h��NEh�� ��!Tox��-�#����~
jڤ��іs�pl��y�����6�<�qSlsh	�^�����h&P�:z�m�?FT�Dşʯ��'��0��ި��8et7�]�H��m��F�x��t3 �Ӳh�
>�1Q�/x���,�ѥ0��N���r(n`8`���]5����YS~.�V��Q��l|�+��ۻ{b�1ܰΨ���t�����b� ��ƊP�}�*;�x^!R�}<�^G��P�|,�5�@��c�)��<��su���	vT3\/��>�ta��)r�֤/��������q�f�ѥ��k�I��k'K�������99�)�hw����$T���t��J�Ɇ�17����R��N�hu��v�9�@:܎(E������x1���f =
�#<��3�P
d�$:fߍ��,���:��Yk�oB��R�7E�	��?�_�q�S�ՎZf� :eU�:[��NQ,b�F#��P����w�G��V��W�b|(C=�|�3�5����������E2�qs�g2�9i)J�0^C����@��S�� �r�NG�/���M� 3���	��D��&@�ƾ+pG�UN���>a|�G$�c[O�Ѯu�� ��@l�����D�U����n�B㳒ko"Y���	�n��*9��-X��3w�=��ɢM��� ��S�<ڤ�U�x|��g�|g���G��D�a����}�H��������dv.�Uq	1��@+��?�] nI�Mݔ$�}��{�uP]�
�q��Ow�p������q����b5���|��S��Mq�(+fZ���!��o����O��5���}��?.`�~d.��zܰ��fH]�RV��9_�������r���,Ym2�~/�՚���ʃy�kغ�x3_�����}A ������WB���1�t<���	���	���s�b��6ôq�t{j��h_Eׯc`9�|]}4&R����0��ŴV���q.���D��CS����P�ś-�3g�gpVZ�Dy_^t�򤌡�\m��"�S_;��]i��;n�..��� �.|pY�7�j�L�7�(��ch`��.��@^��b�z6��w��v�,_.L�b`�HN�]0�-��7�TR�A����<�@�IԻ��|��{�[�����vy-���?,į�|���������1'��Ҵ�{���@���_</��6�M[��̣h�]�t�h�B�3���Kܫ���<-0��'3%5׉�d���:.H�=ۃY��%,k�雏#�Àp\���� _ai����"R��7x�m󳪞��L�&�.Y��P��r�������Q)wrAmW��sP��-�~?&��+��f��(��Ҽ���y.D�}%_�����⸼�|����Dj��KJ��F �5$������2z��SJz��q���2SF�����핅yd�R��f�r��Lp\Tp,��p��.�[��:�o�ǳ�l���D�,z?��S-<�_�Wv�MR�{�EH�K2����xe�x{{��U�����̀�U\�ژ�\������V1�k�AÒ���Jɨ�X����ߣ撒qc��`�&�wN/i�n�*���O�6������<l�x�ȉ�N��(Dta���WP�p�E�]���q�O�Sk��>��НŪ��,���{f_��q���y<��E���h�j�-�!6������˾O�\o�v��C�KL{$��⽈��+t�C8%���,����,sO@��Q+��X���xyRk����������to) �?��J/?��}�+%�d��V�����~�U;lWV���t��?�PR!�jE�.�O3^�Y�uw�uT���&��>�,3<aq�#'��P?Xk[�8ÓV+��"������I嗿E��D3R-{�~+�v����}�2zԍ�͑A!1-�#Ȼ�MC�NL��٤;o� Ku�j�ҁ�r�m����%����D(�ޭ.�}ٕ����z�8{�%H�.�)��&�ʒC�˙gF�P�1�X�5��j��Λ�"�7����{@G1���Z�n4{ޱ�V��[�Zt�}w~�r��)���� ����ʎ4����g�!Kf�s������$�6���1�	'�N�:��p��n���j��݉��u\�t���%��9�P���.:.���J�����l�O�=����%�}]�fbӠ4AIXjv���_�|�8�:rp��j����o�}/��6����ʕ����I�N-���1��(>��퀭"=�D����p�<Tys-H����p\�[h�Ҕg1[m�����[���=���@�asW L6.r�sG�m������%A�q����1Ih���:��"=�e��0�j^�׈���oU�4S���,�^����\����ݮ2�!��2/��e�D�Q������ z�g���$GM�zp=ǉ�𻸯��J^���H{��}k�rk��qoYE�ɥ���X�b�mЬ?Vm08��q�
q�.3���80_�{.,�J
j���g�L"���UY~X�j/�����8&�%R��Y��ѡ�_r��DJ)%��}K��[�������^�3q�X���aB��d ����po�h��r�
������Ι�3�Y�8���S[�t'����Ԝ��^�@b����x����2S�T1]�?;'��+�O��ԯ��h�{{��3ʅkT��iX2`U������d&����a�^	=o���G�UtO4!"��GqO�Ns}��A�q̴1���zG�ғ3s���z��[��֮ ,7	'�KS�GԆG�p?͊��.���q���C��M}ii&p\sn�ŞO������q�ay�.�����F0��@���67{m�/�s�R�5n���yŹ����f%��¹�n?a�^U筂I��("y�����^�`�V�|{r\�F�S2�Au���NK5�ë��������^a�5l��1k��z	5殌���X�ҲH^�*��-�'��>��&P�_���Q��ٞ��+G�4k�;u�b�=A<���	W��9غ̱���T�'���\���X��69U�w�ť�*T��}��`�x��+;u9�FJO�y���'����7��Ձά�[Ǆ��-4ۓQd�Az��X���=p��i��;ɋ��K����뾾g����!�A^����,SOќJ^ř{�3Z�8	D�,j/�ߺ�lr8D������P��R�x�� �^�9�k�H���u,�f	��4�b)�-m_��aL3{���7`�"mȕS^�πZX��U���cC+��@�%7��W��Оn-uC�#]�K�k����6�Gȣe�2L�W�8Ѭ�M�x	�1K�M~�E�r�u������!��&�NL����'�X�NPIϱd`}��=~��F�(�n�c��}�!�r�o��ԕ�I�_��E-V&�I�ԮU��̏w�Jw�e<���T���k� @I$�����lj�E%��3Q�SY��C�#Y0�`g�Vw-���OƵ��eaN���̯ŵ(�����ŗ�4��GD-�����Y�p;bj��X�$`M���Ye����_��c����l�^c+�'C�T��=3��&R�6�>����w����s޶�@����?f�]�F~%x��Z�����"�����V`��=�c�
=F���d^FM�>�:��>�`�sz�������l�|���N���#����}����x�>�%�j��Ca�!�%h�eӅ?��Š�aw�����(��ˡ�,;�Z�X����z��f�e�v��@���u���6P����f��Sc���r�f��OhQ�iY�1m�I�����0�G��R�$��=~C;�"8 ��B�;RԱ��x�L�4b�Ӡ��} s�;^*�O��8ZR�?G�OX���'C,`$�Z�dc������/��ݲ�#�Կi
pm�,*^����"�����Ot�������e��1�б4���6�_b��ݾ��S�ǳ�7r��lo�N
˃ʄm����/DY�y��6��
zV�x�E�Ho.��X�o2d=��
M���f�Cf%��MO��̰�a���o'��1�}k��$�wd��-o����Χ/{@��������5�0@k��6�l`�A_��Ӟ T;pY���;�wB��pw^^^�H�F����Ft��\��
+/Oa��z�#ڳ��z���ښX��rMi�Z੿�|4� ��@����#��ʎF��\}��!i��%ܾQ�QНm<��-�S/й�q�2M�ߓk0K��u=�8y�I�C��B�*<��K"	_Ua�"�����~`���ֲPN���;	\2���A���f���V�y��� ;X�悂��]�17���W�1���?�nR�B^;3�b�j�������ͬ��TH�L}MR$�9Fo���k�N+���r9�6H7��g� f0 ��a=��78V���p���>������%�L��n6)Z��=��U��A��i��݇��L>^4�P��E���}4�� V�La�K��I����N=to��<�o��ϻ���IɄ�|N��+�Ɍ��/?b��I�=^�w*���o��q�;ST5���t��8���7�f^+�]�i���-�K�� �����#/�O�P���9ۊ5��M�-��x_Q���F��}�!'�0O*��PKM0�w��p^�(#L�χ��z���)N�MO?TV�9�&��sa�?�\��f�� +9��VI�����aA��y�,z�͌4D@�`h�}e�[H�4(��h���d��=���c�^Å:'1��!,�'��9��$�'V(�'
��C-8�Z(�0��R;�LPLomo{قuȜ^7�M�UW��X
��;�x~�zAxQ��y����u���>S��k�t0��0�4ߠK�B��N�e�(��9^�x3�c��`3\�N .^D{ѓ�F�}��W�i���V�XW$I��K�rW��X�`��@=(�F�cB��M
	?��N�a�w�KB�p���y(��
S^�*�0�MŰ�+��4е�%� ���z���T�U�i�D� w�<F��	a6k�wc������JO<wu���:jصn��G�6��x@	j8Ml�C�?�Xa��b�"�Q;�3��?�A���{��l[��JW .��8�N��t����3��G��q`Kp̑V�珮VB8#&dt�I'?̇ ����u����!��X~g�j��wDs���<L��%Cg�i��h�9f�Х������wr�n[������W��,0�;��ٰ�#Z�� �a��{�</�!)���FP@N�/��]��R�!I���`��7�_CZ�a��������r�y�+3�dw�2.�z�����1
�����j�����?��4C6��&�%�x�����"G��-��>�^>D��2���|  V�]f��|�,[,63��p.v_A�*.�oι\?D=�3٫A�u�Y<��6�G��{�8�%�2�����f��E�q���ľ�a>0�\M��j��>Av�2���n�X�.d�S����%�/��%}�K�C��6���j���^����� $�����=l��0\E�-������u�cC}�.���[�5P1�B������6ʻ�OO� ��S~W-���n1?Ή�>_ӀE�U�ŽGy�b�jlz���#BX��р���r	4<Ȫ@(��y������4�w�� <t��]�<�a~�<���i�3��~�kJTЍ�%�����	{�s��7N��q�{5��Ud:�O���口����Q`dgN��{J=?�ˬ��=q^{>����K0�1m%�d��D
�q�8�����`vR߂�i�`[48��T'�0-�r��-50G/3���j˱�x��e�fPL\p�:f���E����F�B�^5!�~�jn��;��B-�����ls����>	�(��ٍ)��%f��#��|D�7����|�xU`4�͇�'9�����4b�.HdFv�j�ں���p��ef'�\7�`�!�7g��쭞}9�v�����{x�冗��J5���ӊ@׊�\t7Z{lb�e�P6�8_I@Z߲y*�}�A|���g�}�,�T��7�}5,p�'"�����XU�!N���t��Y'X�>�|#�zLR�Y������G�˩���^+ʛ�R�H��Ȃ6���Ȕgs0���
�8/���/x
���y�"�6k{�O�ݰxv���Ii3�]<�u�wh�|P^�?��%�ԭUo�70��";�ձ������E�%&���L�r��q�<�G���U`9o;�tP�F���eQ�=x�Y���ɹ���	]%M��e��5�� lj�i���Cz�ʲ��r��cX�߿��&a���W��m� �Z�K�0Ȣ �H�¸0M^:C�fx�����o�%-'7#xŕ�i�"@����yi)b �	�[fbE���v;ҩ<Ѹ���BpdD��J�|�����-�����o�4�58�{��>����q<��S�����q��'1��p����nE�����AK�	�*�M����\����bj\,-+�����,j�0Voq�)��}�2��I��uU�MG�G+�V	<2\�,��:�����0�>�]���%ow:9`���:'���;~ڭ��A���9���8FP�����&�ݷ�M]���7��غ�3��rq7�jft�x<��㌋�+�����%�J�J���4+X^�x$Z� 𱲴	&ެ�	7���e��i�X���;׫�9��S��8 aj�O�Q�,�J��h��'֮�W����1��s0^�\tHLl��1�@"i&C ��[�E�7.�5g�n�^�z���H��r-�t�E&CW���ћ����,ՊN�����4�R����l6P/�Y��M4>�x�u�0�Z�	H�;�U����A���~���5h��:]���G禽�}�~�d�g�`���i�׮�������5
|-�3�/�v��3���$+�#�[=1�[8�sۖ�kK��N��	~	���$�e:�r�]K�mL�����˜�__����p�'��ܷo՛aR�-����	ڰ���Xk��ՠB�����֔!эٴk^7P�6�*��iK��-��fjz���?V������f���7��խ~2i�*���G���8E���ΏY�m~V3O�ГJ�(�����׫$���~<eߨ�rK�����q�����~A�"��\����/!;�d�ڃ�y��q�@	�`�#9����}���$,yW�:[sӈ��jd@�	�i�8���/��J�T]�c�۹�h���iR4�!.�!p�B�Ğ���t{��n:�L�R�8{H�t'�w�F3��t�:��=�3����ͦ��F��g8S��&�^��&��?X��v>��	WT�
Q��4S���b�&�56І�Ns�Ct��=�t�����Pk�p�F����v!JHf��?adi^�6Yv��Ǐ����q!�ѝ�Ql��q��{�s}�mK���S����p�����|'M6fz�Ɍ�w�1
�Y �e�K��ũ��?,�e�nv�C7��L?��{'��M�^YC��S�����ׅ�'�j2�Uc�6t:�����Q/88m}\��o�лy7?ɝ�C��� K@b�s/ ��"�#>(�)h/M�lixy��69�����-�$�n�]J���/zjB�4FN8�3�sV�n�w��o�'���6L̍��t�8k�~�]�6�At�Q�t<d	jQ���4�Q��(U	���
]+���D�tһ��^
���i����	8�%�����$d�75"b�U7h὎dc�@� x�p�&�k�4���M�%N\<�y��_r�k��E�����qi+��6`"�r�?�$��~~WQ�Բ�������u�/������K���<[��䋈I?�ɘe�{5�=C�7���d�6���¢�����2�4����7�'z����Vw��Y�S�����Q{..��~�
ʐ	藈��>�q&À�=-�AY�lL��8��b!n�7�v��r��g���4�u�"�Y>o\���JQ��Sz�3�W�<Hנ@0���|yB�^mTIh�Թ$je�	' �9	qJX�4 (����b��Q�~kE@�=�/��axOP��t�� ��R��?8�)RZT����U�G�'z+NX�	�U4; ���c�IԵR�h1bu���/�{z���o�U��E�6t�����DN��E�{�����&z�Դ"���eHNXs��eO f|\2#�ORnu��#�m�<D��k�M�S>��5�m��"s�4�:���ձff�7�c*�*����k}��S��&]{87��ez�(
9g�r��&�̻�^-{E6wȥ?�AY���K��r��4���=���nn��C�j��]�E��#�����&��ݘ ���5m��*��y�~���fYp���������m���!T�IM���}e���s���<b�?���=Lv��u��}��²Y��2��r�n5;���oo1>	��N�˒��Pù�օfe��f5��N�ROe���\`�c鯶R�K�>}Đ4�﨡z�p9��}ұ$!�E%�+S���;[ٻ�=\�� ��":�^�0�<[!o��:����;Ҭ��>�]�*��Ҡ"D�.R\R.�p�A������\����4L$7(.�@e�wȓ����*� k}����w�L�K��(K"C.�7���-QBp�p��|�(]Z�wy���p�BU|���OaH��ߢ���2\9�A.H�u�ިbm��{�a�1ee�m�}ɖ56�SV�66H7&'7j 3S~�a��
���r ����f(���[�c!��!r�X����#EeX�SY55�I�1V>���-�\)��+>��݁i��P���-u��XO4^v9ʱ�;t�s٢�}[��4�>����\$�)���$S�V܊��� a��s�:��i�̋h�m3�JH�<;�4�TGѵ�&����d\�M��v���;��N�q���+����ѝ�
B,�=q�&zg~LşCr�z��!m���z�er�$�~��!�	;-ZҊ�>sk
�Ry�:,Igx�b���wK��Tf-]�>p�cS!��+GN�<9|U���f���J�|��E���l��v����o�0B��>�Ff)\ț�@~�O�U����߳� �l}1�ubv]��)Qy""��h��$�W3 ��m|�yk�]��ٍH�
zG�����!ܴ����&I�~�ǿ1ʼ���H��ZY��/�f&GH��A��y��Zw]�c\� <�cW�/�]Ҥh���%_@����m�����D�W%*2M��֭�[��W�	�Ӗ�����I��0�諲b��~�H��W�Q^{%iM�P�]FR|ҳi�I<��a�m���gAc0�<��9���;�wfР�PE�b�����pv~�=(#�39�M16�V������Ϲ1��걃�ӹ�S�y�?k�R�`f�]!�v\���4�4�/t��v��q ��~NNV�ӫo5�*?iV��}@��y���a��1�� ��\\��_�UT�D��*ֱ��O#r�j���sW��q"2���[��� ��^0��W �����x �X�P~3�T��B�%"�)��[���$ޗ�f�x���m�Q�Ν�G��
v�׈��_��>�붵��K^��?Ƌ�����*EG>�� S�`N�S�j�0���ƪ����^FT�g�|p$9������E@+-K&�-�d
�+ո
�E	3��%�,x��ۻ�cE��}Er<�y���1?�� Ds۠��X�J��Vh�1�Sk��eVF�\k�7ٷD��}�үt����Dc��lo�"����N��\s�Ё9��y��u8^����|
�~}e�"���^*�q(錜,h�(|B�͵~Z�s<�L"P� s��k]4�0.!�R��~z��Z6b1������Ä�X"%�s��,I/rQ����c�$8��1r�<�F@x` ��T�?ƚ�}������	Ŝ�h��FB����]����wtI�%F�`��mBm>��P�P8������S��v���\��p`�)?)�b���\�٭5�3>���>�n`޵.������ʵ�kH��C#����Ip�a-�]�hz�C!��j��>������losx�h��Av�I0�w�oB=Ь	R��0c�9��"��߻�;�ܜ�ح�M����"���y��L1�V�6���Q�T��c��09�C��<�!62&�^��������tsmA:@OjG������
���VZ�'R�rQ'���b����UQ�u���!*^�VY!;,7��ˑ^����_�,��]ľǐA��2�<�m�)FWR��g8))�aJ��!�'���޴���{�=�h�n�g��F�$ڧ���|�ӃY�پM�w��=X�Pc�{��;x�2�K��8!�Ŀ�̮UI��$kB�i��k#��s�țJ��Mל��|�)�Ȼ��F�,�G��FG\�����#���bЄ}��O����~@�*�.�yw��h1��G�7i@���dK�m�\�&��;q��4X��ǒ��=�C_f)Td�T/�xb�%ߍg�~/&n��"��Դ�� �q�yw�O:Ja�n�0�� D/�6\��3���A�`�c�d�(�*	2O^��]�}-l�dX�4D���lowt�b���Vs�C��烫B��a�<��?�� ��&�]!p�+� M&����m���ǳ-��#v!ȳ�p��}�;�E��|RX�-��d}�']Cb�G��myO����=d�}p7x�
bT0m�&n��Uq��yգ�����~�['~�>?vU�=�lCn���-�Zy6T�,G1|ͫ���~�5��7��!r�W�� �ZA���>����xԟ�>43r*,�EFR�3,_�iz�Fp���l!�������1�\w��u2������o��EZ�L��;��4�w��Ef�UJNt�a��tP�4�􉰛�j����c�ք�MI��9���0���y� 7)[�lg����EՎz3�Kaƾ�
s���C����2$g�E�T�nT�Tc����kda��KI��!U����E�6c**����?e��׌�m��-��P�O2DAF�W�ת(Gڏ��T��5��f�%ܸ6h�o�hƨc:��T���Uf�%��sW�&�:���W��g�)����������o��!`ؾ���\���{������+x�c�@dl�B�V𲪕%(ξs_'#���̮�$�\fm}��D��U�'ݜ�U��ʳ$o�0K�-ʏfn?\J8Qe������~m����w�ʎ�=��Dw&ca���cy��Gt�!H:�iV�n������g(����5^���1�c4:ZC��\��Z�>�ٲ:�e#2�RΌ�>C��;��|1Hv_(���䚊������'�x�0HVY1�һ9�:��~�zАR��i� 9����T0�J���dba%���Ѹ�q4�͑Q�rf�FD�����%B�Ue,��Vc��A�����Ċ�2���M��I�`\0�\<�@�P'�Sߊ`�?ɚ��U�b��O ��~��bҢ;
"lj���y\��ԩtݨ?�Q�ե�`ye鍳}���V-��-��F.�}wq����N��K���|� ��%l����C�����?'J/�كE��Sސ(g�+�~����/e��z��{���L��]���;k}�N3��O�R����Kq���,[�}ޫ�V�f@	>��.�Q����~�u�X���mf��%��&)T��kF_��
[����5�������u��x>�ch]�Ys칅�P�s;{Q0�ʿ}��t����
�p�w>8�)D;mu�7�m4(�bgV���d۲�Wk���dc�h��I�l�3�����?�T`/�N�j e���,@"�]I�o[��N����\��)��{_���R?��Ӣ�Q972f���u�`���T����K3Ks$1�Ǯ����G��n2�g����S�pp,-=�^�(Cz���K^z�ߢ��8���3 m,�L��18����o�.�#�|=�h��̀�z~�g}��|����Қ� ����l�6g@B;�#�G�h�e��i��h�W6�Qǳ��7�1���|�����;�UqI;�#{��L��* ����j��S\_��~�-�D�c�v� �6`����
���%>��/|�vm�0�=�Yj*���BzQY�ưY��ܬ�'y�n�]-�r�'��pJ^0�Ϩ�X	���C��a��{�}=_Mt��J�G��⣽��T�_�<+�@4�.��j���m��Fˬ(t�>��	����qF�����M"��DM�0��PͶ����`y5$?v�(-�A������e��҈���My��T9@{ �R���7l�<�.��>L�T���
�i߽ݕo�*lW(���=�X��aa(Ŷ�.v8�\J�9h�_H[Dz�K��W�m�֩)����<����s�_�����zT��&d{�⩴i�@���Sx��톋Пi��m�~}�[�t�2~��/WR�d@�O	���s,�p���F,;Ss�Z&E�ǚbp�y�Pх���t{��=��d\s�����k���f�㥿G�2",�l?�66K��.!���(��7���G&O6yl =|�ŶKsv��{/4M��퐼@#,�S:"K�e��,4kq��4�ӳ����w�<6�^�G�GDUg,��h��~߯��^I!S���� ����K���c�T8v*�c�����90y�Aq�޳���
!���Ins�s�A*�*y��Y՛����L^N���5�/��jRE76�2ex��e�ok�y�?^�e��-]��.�՜��K�E��
]Q�
�ի'���\4�2C^d�U����t)<���\i�-�`��L�ն�n�S0�f��0e�I4���x�-c�"H������ě���6C�TL�H��TGjF9�p$�����r������+9G�1X3+n��ߩ�%���Bo�P��6}��Gl=mjI�@�/�
C���q��?�3��>�O�׏�].n�)=���l%[�f��츰�H��²�}�&v�N���.��阋"����0�/}\m@%9���e�rTw|e��j��t�)D��zZſ�(�hY��a�¬>_@nD���$��!cJx7:���a���p�~�n@�C����+�7޽�^���;��'Jf��,xy� �R1��-s?号*�q䊛go�'������}�h���t�|�N����G�/&-��P���N��#X��9(�\]6������ٻ 6ɯo��U��W�^{}�GD@=7����뀂a��B�;���Z.���T! ��0T�v��4d�/WD�gW�(:���!f��{|�
�?`�q������w>/ſuB�g�yLtt,����������[�pO}Ǚ��o� ��&z	N�4�=]�����j7��^R�-pM���w�f'���wՍg�Eؘr������f˶޺�!�`�8�C�q߸I����P�5ƀ�����e�^���&d�rJ�&�	2K/l��:s�����Âd���>p�E�^��[�6V.�}�6�7��zq^�B��`t���N��+
���Qe�MF:���6�":�1Ft*ˊIZ{�6P	�ر9�P���Zʹ�̔Z&l��E����=(�M�!i7m�:�F\H=/,����HuJ�:F�������ݏ$B����>�b���K,Tl�����?\䇊u9��<���f�9���
�l��%���XO2I����A����s-����"!Ra�.��ȋOe�j�M�n%��q�_�8���w��0���uw�K>�&���u�ma��1f�(M�¦#S��CJ��~oa��
�be4���oGIߗ^>&���&6�3���
���e��ɒ|��8�ZD}	��歶�d���3���m�a�NO��
¨.��ݱؒ�����s�C	¢�������G�N�*�*I�?�r�ݹ�7��c�w�Ȋ�*v#V�����_�0�z�+�3V�&Y�7�J�f�E��5"o6��݁qt}U���y1^��!����;gLR/���eE%AlZ�`2���"��؂��X�8K]S#�cB��R�/�O�T{�>6�7H���5$x8��OI_�5��������\}U6�"�j��츄A-'a�F]̄�J/�-��ЀC�'��HR�.R��Thk#�S���r\�x0|�,1HN)^�@�w&C�:6�/W��s%#�]��)S9�ƚ$�8.AVV���Zޢd�<"#�{L��mUg|�6�2�\���O1����.����v���A$��H����LG���Rml�RUN'3G�O�P�Z���nU(�.�ާ�+z 0!��|Q�NjW��1��OGe;�H�/���%m���|�nъ�v�H��u
� ����Ͱە|b�Z�L��p6o�0�<d�>�#DW�/{�	���n��wD��.���q�W���� ��^e�/2�3�����BMv 3�p)=���]�0l�"�Y[2|���S�R%:SVI���e~D��Ŵ�rM^�=�B��Z�#�W��������t���ɞW%�O��ΤCc�ׁ����&�|(gI��L��m���@ W�0M@�c���l�G���n�ht��
f�YBks{�SS���:W4��)�Ch.��q#����Qd??�m����Ek�������x?`���?��}V��Z���a�4r���An?��W6�Nt*g��j{��x�K�,���Af uE�8���q���G��H��$I���|�MA)AjZ�.s��6Z�e�}i���4}:��#�ۗ�Z����59ll�N|��Fѓ��rH���W�����Nv�#�do��܆�ލ�s�V���Z�r��8x`�4tl�~�3\�gߧ������'���w�"�0�p�(�ec�0�I�`�V�^)��n���A�d��v}�tQ��^2��C�P�Ca<�Sx�Uv/l�/\���ܖ�G%*�&CnF�ĝ3PBA�������<�d�)�=h�U�*S1�����B&�R�\i�)r�x���<�uA� c�|���A�b)���R�v���T5�����6)��J��}��p��0(����Y����0ȑZk�y@p��u���a�u���+@�_E��(��i�*�-CQO���|��bp�Ɏ�����i��R�رL�K�X�/4V�hj�1:.}��j�=Ya�ty�$z{Ig�]�H���dv�f.G<���� 524���Ъ�n�zA�b��1~r8�t�.��MP1��}٫E�v9���WJ���F踊?e�?0R�w�\7ĴU�������p���?�P���Fa��*I�7l�NBs��4#��fr���St�F�I��ے0l��6�V�N4|](�;�3CqpS2�v1~�G�4i)^+V�]��$a��s+�c����N;��υ���i�����*mp�1���aT:�2l��9�e(
�9�4�j�*�Lq�k��<9�%*6���dF�Έ(��t�)P|���`�5�K�gs��oh�zԿ�Ąw͚.�~=D(؁A&c~`3��D!�"o�J�v�/�Ӵ�=q��-�;"���^�"{i�H�ՋW�l�^�U�6,������	4�����|�M�W�d��'@�{��R� l������������&�՝`���`,�ޘ�nѦ!�ȡ����70��K}�P���xD.'Eaf�W��iy���������4Jѭ��$��Id��T�d>%]|97NdHZ�\�JO�o?�nrdt}D�0��H`�=�.#q0Q�0��B��H����a��"��k���eP�!_?���y>&�xaNm�h[Bz@Kx[	�rƂ2p�l9}�6��0�����T�3�Q(����ɺ�%�(�^=�Q�����>�����c?��0��Q�Of���-��C���248:*[sa����=�M�a�HI��9�?�ʌ�V���0�l���[��83�?�z"ど�H�=A� �V2c>#�,)�8�(�좳�@dN��}�o�;C}3�{c졏y����]�c{"Ay+v�������M`�!�H'Zg�"U�hC֛E�o�7'���I�+� �$kO��U����^���������>��d��T������5]���("U�c��p�\�=��G{�!y�GM�XqLz�E?V�2�f�g;>�9�(#vB���zhߒ -.��ξ�^����^���ZCZ�����3�s�	uCV�\�C~F� � ��T�Ali2��@	�蟄�h�c���m�^,̯�R{���+t�3��f�����2w	�ڝk�_�=�8�}>]|ڍ��Un����� >�>?<�W��U��7��E���J�ft��C�������U�����g��6yN㠮SR�<+	���qGآ�5$g�Dj��3M@n�s`x	MVR�f�CU�k�#�=�=�]ÉMWC��-���{hc���<k(	V�u:�/<�Vk�YlLq������;�Y	7&`����LB�������c����&q��O�k�Cg|OB��ꎐ3����L��fm��ڦ�X�w����V� y�όKV���).
P�J�SM	;���ľ����bN<6ckL�1�E���'�k������!>��K�n�N�Wٴ*0����}��3���U�To�e����UĞ�/��K���y��%쭀"kcO�[X^㜧�d�o���DA�1F�"���B�s�K�»ڸuA�3���Bo�OﺨÊ�tF����N;�1e}j�1�yn�)�+�}A��JM*��>�|����۸ř5�����1Xƫ�Z�_؝�9��Qz<_�?r7c\5�(�63�m��y�?p�		"`����=l�&p���!���M^���s��cP��+��Gh���0�н�m��9X�_xx��.5o3���=��ohH3������Q�%�Uݰ_2<���Ν.)�x���Ņ��0AC�(`�}R���������3d��	Be�F(��;�6#u7Qx�����0�-�-I#B<�!��3�8�Ayk^�a�.{5h۽���o/|ږ6�������?ovYTt�M@����\��q�9�^U�����F�)M��	�C�N�^�K� cN�sf��qq�	V�I���� �|�	���J��\��R��|G˲�m�V�a�ȷ���1�.gf zw���#�m��v�8T=�G�1�8���=	�)[����UӱsDS�����م�Xd`������t�4U�;�(��#��U�r�1#\h�E0op�ǟ܉4�"eG�U3I�ͽ��&(x��\��2e�?�1��9�����|���ΐ�:[��5����]]lQOݒ�p���(��m_L�*>�G�	��4GƟ.�3�UG�7��d�3K�E�ӯ�LS����|ؽ>�>q@G��7>5&�� {�+�rX�A����mg*{�&���<��^f [��;drߪak��(xhْ_mj}e����-���;E�G��vG{����n�����1!lT~~�_��S��'%'fk�����ζ��$�о��q�ѿے�O����E?���3�+���� ����j�V�4���"��C϶y��4�(8�fCA�s�q�#-�Hk@v����!���P~����/r������<�Ȁ�dvX�t�fN&�=�8u��b1����q&�.�Gњɶ؈ާ�s�h(�Od�� ���{��I���I�/~a.���_T4
��>��L]��}��W�3����<0��Ԕh�1�_Ir{=���d�cf�e��%2��T/lF���
�0����t�́�?�2s7+ʧ�ޅ�W���ۺl���D�A��:� �eE�3<�V6�E5����/�Yd����Õ4��l��4� �7�H�������7W^��S���D����(�z^F�O�G>�+������������j��j��7��vt)t�P���B,y�~2�%�U��L&O�ۧ4�4:���3���qO�'}�?�n-�TQ��`�`��>e�ݺ
b��7����<'�?�:<I��P�s�+�1V �"�^ᧈ��<�ݧ��:���h���t�U�h�V�KO1 j�����!�ж�6�	3v`W�g�k9�w��^-�C�#)j�@<�l�_*�p�X�X�|��`JX�	Spj��^����Ӱ��1J``�jFY٥�؛m�ʋ�	v�9�ξ�ɉwK�jids����{V�Bj�<���v���iÊ�Y��<�M��(���[�{ ��z-MpGa��� ej}tb#�7ȯ�dה��W�I�'�W�VZQ��p�+��c�R(}������O}��2�.��=_��c���]n�fki5"���IU+1��`��s��7�u��eDĵy�7e���V^[�	LJ�uz�&iV�6oF�L�qeO�l�>+�v.R�\�N��� �8pc8�[/*���
K�~P	/S���Q!x�Hy
dچ�!��)u�e׸��#X�""-h��V�)nI��w���3�� jTϾ�HrRXgѠhW<G?)�x4�rGT�ce&�(�S����˳�w��M�9�X�FG����=��0��Y�2�/��*��r��=�%㚠��+<ΰ�����b��y.F$_:m��RP5���؉�mާ�˂�8�h
�M�PY���ȃ*������ ����eIq�h��	@�z�0��d�s�|R+���t>��[�aN8�|�~�R��Z;���b�̲����6�>l����]'=/�g4�������Cz��������<O8��8��pL$Ue|ܑѵ�23Jg���(�Iq�S�u��a�-A�Ծ��7�n�d8.�o�\�b�1����&�1�/�������X�P(��ޠ���⻎��TO��|�D����8D���U=o�O&������Q�Y��g!��<u�ݤIVe��F_�Kx�������=��W���#F���NYqM8z��~*�
rn���T?���<����l�i�vA_~=:�z�[�<N<V/o	b��I��L"�t��8�C֓_u��rn�e��R7�%���i^ΎT�*CH��g��m�f�{i���/��2��� @����Y�`$�.;��s�Um���P��r��.�ciu��Y�}�>�I���f���t��G�F�D��a���h�7��K%�w�ҍC�]�b�� 68�P��d��0)�P�|���$�y��av�7Lk��E�̘c���U%�WZ0 Z��ЅX�3G��`�}�kj�+�m �Gy"�Ŀ����Am�`�TB!����fo�H�[�T0\9���E�z7f�o[\�S3�]B�h*P -�c�C����q������(���2�*�,���O��b�g;vx�ۯ�;Ϗ�}�~�1wdJ! �h� 5����V�}��-��}��<R:��_���&~��x�%̤a�1H��ީ8K���0�u;m陱X>\-��=`=����M��L��v�'Bs?�}�m9N�fr0W���Pa?�==��������s���]#c�]9iɉ�E���)�0p�Vd���X-"jaY�����Z
1�r�LP�>�4�Dg.t��0�SL �4���9���Mᘻ��7�����=P�5������Iep?��	�XCy�c�z��$��n���*�K�gB�nwR��3�Q�ND�pf�g�M��T!Ȅ�Ҭlh�{�v��)�?aݵ�5���������ˢ,eZ�A���Xv����=�iR�,�K���5��l��xE2����m��������<ebR�W�1�H׃�:�
Tg����2�D'/*e(Ƌ�$���lBJ���7'�5KXꀜ˕�ZnYs���d>����B��~������ ��zA�eӷ�p����^�s���`Lqe��_t7̴�-��!�"�Ǭ_ 26m@�9�)]�a6pby!�v�&>ڔ��c�U��p�<�f�Lf����^a����Rt�7U�Ęyϯ{>�^O��$��G 8�#���_ �����h��RF�/!�wo�������Q���6�5|�)�)��4H<#�?����`8$�m��n�l!��n	�;��6\�Tk��X|���W��d�^��2#��Q�y��/�Z1�dz���>c ��k1��冿Ѐ㉵��kti��Հ� ���
F��do�ɬĀ�N�=IhE�����u>�����m��l:��M�)�藅�@�PHN�_���k7��`M�[6�t�M�b��|�v����gi���Ec�w�φ�b�r$�m|����C�FV��0�@=v*fy !Xp��-�nPMv-R-͞�@<���S{�^��x��o������{\%*������?���8'���[���k])��/pM7jĈ_�5�ĞL�׀����l������mj�O�)^
��ki`��V�6�6]�T9ۘ+Q@8��KZ�D�
��nB]�]Y�j3��!��9�iV�J�.�R�U�}��t6~{#���w]N�V���TNh��	|�9��"�k�!���s��%�%C��M�顱���4Mv�n�����A���L��lО��"W��˔��#�.ֆv�qC'��ze�(��ffw.�xlL��P�N.�Gg4���-�k�
���L����
�R�:��f�-�}��ÉN>�_��X@�<�$C�ϒ*��$N���r��1g�`@M�^a�A��vA�9OG���7'5j8�����E2Rg�P)v�[���Cۚ��1�6��k���n��H�ܒ�=�����4�E�<��D�ll����6C�����]]�A�a�99u!0k!7���ݍ�D����4��gh���{�����6#�V"JF&�Q\v:�P�lk3�x� HPvL~+�������"R�u�H3�a�<=�(�B,�����:A�dMtnx)�z���Űl��tĄJ����<��0�h���w.��Ԙh��Xnja��U�JGޢ�;/Lެ���1�ae�9����б�r�>78$ȏ�v\ě�f��m�� �@PkX�kk�i���B����]����.ѥ0�!��:�7v(��`��]��>w���:K�'9��Ţ v�&&%�������r_d�#pV�K��j��=�#T^�d`���;֍U@�ꋨ����=x΅I��*]=���}��̎H�kI���W�Z�i�u�4AI�x���@v^�BÁ(�6��|*XNp���t@s��]g��Mp��U�K�v:H�4u�Z����\����ͨ<m�E�����`$�d�T`�f�B��_fHF�k���i',����Y.iu�x7�蠟-^��∰�2Z[�)����N�Oz�1�@�tz�""��2\���V$g����'�|jp�my[��c�X(�|����Ys����5����Hm�E[8�6�����0��X�0-Hf��������?�ER��Pa)p�u,�Z��5�zH��J�D����I�?�)�uV�
���sx�g4L��`����N�$�����y��
���Z�Y>��,롨T�B&�@4���ґ��QD%-�*Q�ЀI����ox�$?-��Gm�l�ۻ�0�'�9!b��C��xy�]��ӻ��N����'� 8�?���"��@%�MFy3N��y��4$�onpL*�Q�N�
��Z�ź5CR��P^�~�u�9)�2o�"Q���5�X}�ӧ����\��ʽ�{�`�?�%�W�C��h13S���-Y�ͽ�ٞ�-/ׇ?r�,
�[�n%.�УV+Fw����j�2Zx ��P�5w�Nq#HBa1c0Y���[z��������=�"�4���fZɖ��L�r��THƀ��x3��*=�\So�l N���ף4���rk�pBhP�%�-�Ay�P��̐�Z�N.�i�ʻdQ��I��~����4�����F�ڂA̝�����R<�Q�VJ�kr%W����]�6��܂fi�����	[@�΀�BY3����ٍ�������|�9���DO��j�X��M�u$ޢ8��c���)ѮPH][F}��-��lG�ZwP�!��%:��0X��t_y����-W��jrwn����4�o������-��x�S�$/FAK�pΖ�X��g$H���d�p�s�4�q�ϙ.$#~���#�����{��V0���M��b�G�F�w�iU�Adv��z�rM���vu��1���m�̄�F�9L ����p̥tS�bޭ�o�YvoS��.���&i>�M;������_�kT`��;J�ވ`͉�8]}�a�\3��UO�<�B���jq�^�p9��9��h+7��IJ)oS�I���.�:SЀѠ�y��-�[�2�I.��!&g	���qC���`CG
֍�g�m�样(���3�d/�ewgbT@�o�����d���C�x h��:�<��97y����c΋Y�Q<75�u.ۀ1�5�w;0͞z~˃o�lσ3�*$ô.o�W�f�?� �_^�w�\���E��`��i<���G�)���Q�a@K]��U0�RNT�nХ�|,@�o��f*�.�e�8��N��7�s=��vr���/!���2�v�S_��U�?}�)_���֧��8����&���T+�|���
[4#��ϸ�.���|����+� �_���G��H���h2�%��2��VZLj}Њ�L(��znI�ӗ��%|�To�\�%#��1�o-���K~c��lE�;_��^����G�g𺜜�+^hydq5n���>�$��o�*l=�҄p����o	c ��Sl��1p�z�8p4�Oo�=�-4ML*�k���>S�����y�G�Ő݀��F����9J��7u��ޤ�	�	%�c!��q��".����0�MD�T�.{Sd�7ɝ<&@�aiq�g��I��]��.	)�.I�}}�{V-�=��{cEfg�g�2�(@dPdB�@[��I����|t߮��ѥ܉]�4��4"i����M�[��r�m��u⵨x�J�i�U$l�k�i5�*:Ʈ��߂yr��������������ԜgcY�������.��ݵ��ƚ��F+�5䆊�9�$&�GK$��(a*�Gz�C��@��ϥ�5�� ~�.�J͡]������h~���������h�IX�K����;yH�x���@N��m܊Lj�P��Fh�c!��4����Vb$�k��NMs~���+��S�0��  ��;�5�֫9G9��S��9�k��J��w���)*f�n��o��A:����4!��<T�r���°iǟ�tF0��K/S����O��"`���B+��Pz�S���f�ɔv��H��}�+�q>>2s���J�^?V��|m|����p�@��!���[�2�3���|�'�Ԓ|������Y��]S@�9	��Z�G�S<\.��zr:z�SbW�ț������z;��
�@\3ϧ����!j��?���I
�
��Jl3��O�1�d�ŶՉ:���"��v�i���e� D�����Sx�a��g(ѿ�V\Ҩw�ȵ�"nEO_-2�����ke�q�����i�t�PdKz����(g$d��=e�w��!m:��;�B+zk�&W4Ԫ�Ѓ��O<n�_Sm���cƬ��j"co���+�t���s��s�9s��}���2�i^���� �w�2���/9��HaR�ZSr�6����A�
5;�{�8���~�_�Y�;�۬��:���[�S�	E���ZZJ�~0���%��` *?�ڵ^:��6\ʖ��`�� �q,r&�Rb'�1s�ϟ"��=��^1=/brΔM��*&1��ͿJӂ���JZd)��g,�9M��*}���vC�E���X�@FtG��+�e��*�R�	\�ǽ� $.^Ħ���v6׎6�Y�Y���B��{�I��K�A\xs��Y�=�eSc���gbA� 6���b�2UO\а4��_�U
UܦG:CkL����~�ΪH�F��Pp�;/'���AD�T\x����):B��Xc�V�}o/������:u ��cʴ��v��������K�F�M@��0���x�-��4Kc�zb5R�G��:qTU��3<x�c����]Evyu���5�i*���"(����r�f����'�~-��T�u���!2p]�l�Kvs�<G�ײ��/���tc�B��M��/�N�ye�[��A��C���'�,<ۗ��y�v��0U���~�wԶ�����>�F
Z*�ׄm���f�pN��z_�7������my����B=�J�0�C�gRrj�>��dW�E>����ǈe#�N5���_�)���E���=G�V�7��I��3��\M��km�L �OC���?/�`��@FQ)J�cT�g�4�� ����I���w�c싅����Z>���z��R��èϹ���xW�DM�`(�&ց��z�{��)���������5��XL���d\��ƧiY[��8e^@Mc�`�� ٞWY� }	����C�N�L�z]�g%	����#C#��� W�{lPB�����=�3��.��ЩX&���ͼ�L$�su/�ZXX���s�ͫR`��W�=���z�Cj�-s!�^����f���$P���#�=1�Oe��/�M`�h��a���Pܺ��������^뀕�� 3)Ek�X}�bYe�����h�8ݰE�1vE*�����lw��d��� B-�®0n����rR���{�!��3��O0�ؖԹϭ��7�*�Y7����A)��	*�N<9t��Y���~��TuP�uW��Kè�x�����l�#�9��AG�PE��A�8���L��δ��s��e�IgD��{��.M��k?������a(�� BD}��0��W�A���)VϱIQ�����"q0��6�=�8�N�w��f������W%�Lޔ�x��x��e7SG�D*(T\��R��|�p���*�dce��f��=<7s�f�ljz	�fD��hؔZIRL/ƚ��c���~��b��mY�$�ek�i�1��	�\r{��3-2ɰr:�(ke6ސ��k��`�\V��=a����`TB��i�`��=����um
prz]���O�v���\�J:��-.��V��_>������s��q�On1:.�!�������#6v�\z������d���x�3��4шt<�9.bi'I#X�X(FR�bm� n����`��p��"*�s��-���bYퟣ�wo& ���0[�SԞRo��B Ԧ�}>ybF�����U��j���Dha�)�������T+q�<���|��r�H��#��0��7zXx2C���F.>�LW�m�?"{~w�~0EW$O�C���?]t֦��{&-�䆊����lg�oH���)������%BC�LTʋ�t"t@���i0��~������aTE⌘�	B���~ѐ�TT;��i^��e����k��=[�Ь6��	�j�1�:�h���k_�z���Lw����.��� �j��4�����u��%�n�׀�k�]>���<z�N�ss^�^'s
���5F�&�#�MX*N۠���:|Ȭ|�A���FF�t
�H��l�@��O/.8���6�{���nf�R���Ztn���58	�,k���P|k��">8�kı�����%o�g�!�Au�>!���f��$M�!0^�1�j�甞G������*i��K���Q�������t�v:W��h�2��'�1p�j�o�k!+�k���+#qk���}��2�aF&����Fz���뉎��er��!ɪn�w�сL�v�Fe�s&{?�:����f�*P��q�����dԟ��u����w��Tƈr��ĩ��[�1��d�����ͽN�3���1H�{�X�~-��n�/�?�O��Hw���fCm�.����]p̹�Ň흒k���f��AhZ��VeIh~�TS�y7g�'/ BfgV5��2�ubh�LK0t��(��Z�v°�]�K�k�븦�c�"��k�m{��L���:?	6�ލ����9����	V���&?Wo�w	*�6C�`;�|%����ܓ��h.$��H�J>|E5���\i`cu;���)�xZ6�p1d.�TN�9+>:A�	ND��7�a���J�ex��qWLQ9�k��]>r�y��ѥ ����F|��+Q�:���O�]�'�\�|*�Z-<�i>As��� 0��`'w����h�lI�'��� ����E)�������a�+���Հ02ƽ��N��˙4�8n����}۟�={�\��,�t?�(`����!��C��t1���9@�AO71}
Ur����^�Nc�7��H�Gf֚��xq���ƘP��diDT�"L�kr�m�Wbr�)����0G1����
�F�R�5F��'Q<l�Uٜm�s��/���;ۥ6�w�W�,,�.kϢ��!�]�X)�O6K�+����0�O��q�Db���ALr���UHW�to;��W����4Ğ�m���9��w���cA�s=/��v��$�� ��e�����	�7(�]?� b���CY�4ee��x��=�6�̙�s� ǉ��%C+�?���Ҕ�=3�9�P	�+Н����Fh�f�t�b��g�.%���T+�u��4
�I�G��s1ѷ�`a�D���Mj\����M�]{�	�(���"y;OE�0�.��J�"��P �R��͂_ӘX���G2�o:.����r� ��8�����⯋ -k�gO�n\Y���[3R��L���Dl��xl��z��Nba�PPlJk�n���:f[�t!���NlЕz�S�K�\42�6��ќ����_�jѷ+�\(�f����z�yJ@K7��Y�xEI�2p��H��HKm#h��Y	�����X=/�W���	8�r���vώK0�^tV���i�h�r=����&b���`-��dN<�f��!�B��_�q'�&^�\�I+�~���d�Si,<$z;��?"�;7��M>!�f�|��P��X Xy~;�n
_����M9��"�_ֳ��kO�ʙad.����i�3E�M/Z��a��p�Q��*����-T)Q8�Π�ꨱ%��g��BYN�qhX��ș�(�*��tP&r���#�$��D~u�8���E���,�XX@����͡_
�����0O�D&��G@~��I#��W1�C+�R�lQ�%`�nb>��:*q3m)�+I�͉�묐�DI�\	~�/��%~��R��u�w��&*A+�������p��
6���}4�.<?#�������W��6|ɦ�{��7����(-񑉨Ø�'[����7]f��F7�t��l��O54e��O�u�V�1wr�I���_�t��GR�CYvk|1D>�J?C)��樸�M�J������,�됐�(��Cа)Ȳ�1T��&�$_��	r4y�/����ܟ�Y+z�q	E�8����h�!�'Q�<��/�5Ó�T������9�t��8:I��q�n�ߑ��g�k�������cB�l�"�ׁR�yYL��(�t�1�>�h������68��7���(HAho� ))������<Gsz��x���P���g^n��z�h�e>r�u��Ça^���hS��
_/ӂQVn��*�Gav��ٍ������)���P:%	�1�Lx2�a�2����A����׷w�����#�Y�\�\�Gv�m3���z���>̷���rC����%���<��؂	 {5B�2.wTݧJ9��R"Ys|���P3嘜�);�ljtѯI_��U�;��Q	�M7���<�a�+2�����<(���1�;��R�3{fO�rǷ��?�.�O
eyz;#HZ_`�M�g�����23Eb(��^���,�^c<��aq�U�Ϲ�rb"R�-�x���]2w���mi�#�<��?y×�Bv��
B|�[?.�
�`�eѡ�eX!M�*��~�9G掛IFv���Ȁ˒a��\<hM�F�H�ej2��D<���K�n�0���Ы;�¨��:I0�d���?��sβG�M��D�p^�-�jٔn��m@$nG
"4�ғ��Z�͠r_�V-�ٝ��R���Qn��@��6V��o@=c�&�����L��E���t�N?�<�E�a�Z�n�QY���@�?R�J��M���)d��RJX�ʢB��dVC�{i��>W�:A��"2�R?(b�Rz!�����Wl�I�kje/����6��.�Ϳs��][WN�ȋ91��Â�M�L�o�̄I�D?ߩ�G�9�^�Fk��۫��H�K���-�T ��`aIU�\k3�6�c�<���U2�QQ[XHJ+
K|�7cЇb�諂�*��]��[p�MZ�C�WS����
	�kI9�o�Bq��P��p%d���`9���ʵE�m���*�,M���e�CHi���� @��ٽ�naW+Vs�Zu�M�q}�V&"��I¨@����������er������: ��F)�d�Ñױ|gG�lJ�
Nd�[1�@g�a��՛dt���7�U�j4%B��Y��i�k��A ˧���)�,x��ƒ�rEK+�(��&6�>��#��OG��dh@��e,�o,)D'cz_��������xRVf.�)o��j f�|���&��v ���"�>p�q����h8o�թN[��9����o�T-�4/��?�C���4��&��s��I>���:�0A�ոd�f�a��뇿�P3�8�\m���Ipe�*C�$�����C[\��Į�U��R^��|iN�7DO�\L�n}���ֲЖ��!��\}�����8���P�F�k2��:���c��o�ܸ�C55/K�D����߾��#H���z-��:�J���������7Tn"� A�RHl�w�R��L�&ˌ~~
h���2���;lS�'):��v3(G��	�e)-� ��������[�Xn�ZcN	ϼ2��ȑ$�)��E'�z�������
Do�(�d��n9�����d�O`���`="USK|v��([Q��k��}$eB���5���z������t71���(U�c��X�EC�1���m���yq�@#�ݭ(岗iA�Z"�I���7pd�F��L��b����) !p��|e�ˈlL2^3�E	� pڽ�!��S�݀ �Olg�������j�OĆ�~�N��GiCz�l�6�*郥��o���@���t�WT�7��+���[s�n�F��TZ��Im���ז �Z�P�'��@/�9ۓ됓��@\�t��P5���/dr(�{-�֍��ëQ���ͽ푡j6���^f�G^�{jQ���RJ�]F�t�V�л4�0ɟCG�=�P�;�>�&�zE9�>jJkc��!	�͖���9Z��H`���r��:������d�D�)�:-�M �F���s#�k ����>_�͎��Z*�EUd� ����]�Q��d��:�N��pI�g89;�R�x�q�������,9c��1n� [�T�'R���m	W�8��O�6��i�n�u����j���)[Y2��I��dJ�|o�FUy��U:�+-���	Q�'4"%!�eI9K7�,���t����msO���R]u��� Ԛ�J[PA�ٜ}Pce�oj��c/nv�"iA<��$^�"�F[Hc�<�C1����-�<�[o=�B�.D �;Ĭ���E��38����Kn�w�� F�]��F��`z���``=ns�%Ϳ��یa�wh���?��t>3�F�����2n�vq�bI9,��:�A��mD�a}2"�ע>�Բ-��0��V� �̜�Q�i�k�3_�.m�>R��Sw���\�r��ɢYk䍇y͗�&V��7􌺰�=���9�<ē���R�*������@}�<+�����o�Gˬ~�:����kgI�2���p�罥!h�[���7�L='Ge���O����$ǿ(��^�6���>����y�XkѩBW���g��LP�H5��K�5q��7�s )F�~� Bd�@�H^ !T�@��ÖL�]����"�������l.I�Z��~�/g�?[;�����p��(K�5�����hB����y��?�\J�?,m!��̈�E#�6��P�37.K�@9���1��G�-bǂqϖ��%\=o3�\��j
Ǩ���}�1��$���!DC�G7���M���$����9��1
��\�5sO�*�֋m�1���A흺�X�1����m=���Š���a��Nt����g�k�!B�#Bk����)�w�2lU&n�W�R�-Ӑ�<��C�����ᅣ�h��U4"o�֣� Bye�C���ئ�e����Q�:�3��������2��XG�N�W��&{�����9
i��
��e�fq+@1<������4�|�5�5�y�?�|���ƿ�ZWPw���}����w
1��*I"Ɂ+�ƽ��c7�s�	�d{�p�Ք��@э]G��^��o�>����f�\���Q@�O� �K�W��~
t_��{�/�ӥMa�r�ne'0m�A��iy1�{8����[;��^c�b6�u���ɳ1S��=�?Y3s��ch�-!6�$n6O�~n��[�K�M�Dm)�CӸ��F�MX7Gn��|��B1H���T�f)�	��R�G&�~��
�H>�Z"��ܭ����>ﱣ�5m:��HwI���.,x��<�����>ΡK
s��g:��Ph_��
���N-5�dp��H���T&�V���1)�S� �p]��!~\`yc��7R�^־���^��(�4Y(�ۇ�� �AI/!$(6\��ɚk��}���d���׬�9:N������s�w�JqTǳ�d q͆��
u>��6�+*��`��S��7�+����Ńٕ��δ#B��'R��?�+,Vo?��ӄ�
U�-�����m���K�ꘅ�ε��#��1� H1b��L��}����XV�?Pc(T�vL+���(���L
,�d�h�(?d� ����iY�Rm����6�ϼh�UtB��~x$$ggZkGD�i�f =��9T+I����h�W��x�M�T������{m-�ζxP�!cu�A�Y[�^��4H��8��Ը�� :�M$,��G(�(��5����w���d�EjA�V�.��(Hй�$��6N��g�oƓ��c� ����&L=�U�s;��ì��Y��?򓲞��{N�S6�Ꞧ��v1��5��SB6N{�9|Cp�n�����W9��7~�JA� Xe���x�s{���#�� �(��i�,�K�q����P;���:K�����~V������;PFjj#���Ǎ#`b?yR
𥴂��=b��"�7���{��W�/�)\��~L���{�D=�B8��|�gL�؃F�ѕ`��5�@�������9ɹBP&�}-��QT�M�"X4�R_�砹�%RN|�6�i#u𶈭D�(�����_9ocC�1a���1��R,c�-"ߩV@�E��]��zdL �T�G���`��讌�|"�L��d�gp���D��2)�z��`<��Xt�����vWN��
�9g�T�� ��`zO��F*1�\U�h6x���TG�ņ�v�	�bR�G�K�lY���Ϋ�Ab�c������V��6+<Sɲ��¥��W?�D@���|B�f�Y���U�K�yD��\�:�1+)��H9�2��ި�qg4@ܶ��e7��yE୲���4������"�-C��`��k��isKe�eY�5�M{:
>k+��$�R�+����V̂�m�\g�Z�{N�i$������Z�%��;��JN�z�.l���,>N���9��/�"1�| �+ڵ��L����f:�e4'G�K���h��"�k톄�{��?EN'��9�*�q�H {�u,��i��T�0[}�*���$����P�����k���di�/�h�h��ԑ���ã��#�*�HJ� ��Ùu�L��+E�^�-v9�%3,�Q�i�\>Y&9:��z��C��ʄ�U�C"�%*��RI;U�B$��[j^�����AF��
�!z��+������g�_S�2�?�Q�V�9��@�4t� �a��8�r�d)�
�	��3d���K�8XdO�|6^�
��̣g���i
�H��f�~�`�J��[�r2DK+^��1	4P+~�n��+�7��*IJ�v�4�`�^��鋝|r5Z��;f*��{�P/a;?ؾ!�zI���VR�T�k{7N.7Z�o_BٕƜ4rB�εX:�_�t�Ֆh��x%S��\�KpB�4���p-/��m1J#��n���Wby{U�|m^u�=qo ���x�8�yjI;ޢLۦ���r����Q���b|�:���c*�
������x<Q?�\4�h�D| ��o���ؓH�c��G�Q ǱP�1���ѪA��>���Qx�j�!����*��/�[��2���W��n�]-C�:�U����}�"��U`;��Zv���?�Pf�+�"j�����n��(�7�h-�/�3��	C}�},�d �+�?��M�$n��coe��o:�$�<%j���QWd�*gk�j��[T�%�m�e���$u�狧��h}rqA�G����H;����N�ՈkM9�g�»:v$b�엲��{W�\5.�����hO������|Z�/b��a0ߴ 4��to9��n����I�����*�JA�(P��T��>>�UNT!(
�,�U��C�a��ޕa`%��A��0	�Re�v�!ܟ��|_�n'��FY����S� �K�<:���i��WHGU��6�,?�]Kgp�g���4��m�a�P2�id�@����{��Z�2��T:���o�oރo�|��ͳ�ߌe����}��?U���l�ѽ'x��Z��7)�Ɩ�kΗ������>`�{�����ŔL̼���&�9o�װ�9���5Q�����o݀D�~�Rp�k�Er=�<�-��P-8���ފ�I����������/*��e{D	�w�0��n��Q���� 2CDbq���'U���P��؎9�*۵1�j�S��u\���0��w�/"ޔ��̣��>���_��HQ5֙�0�h�Aԍ"jG�`"bE���X@˃x���>xr�j%�iY��Ac@a�X7ܕ�th
�o�A�U��h��ŉ���Y+^���v����"��3��|U�.��V��ѭ{��c!��(E�1 W���8k�=Wp������Jb����`��َSl1���?��1n��F��(�bӴf�+��9�-�vfU�/X4�g"�$�f��2+�!T��=L���X����7�a:.����4���;��qQ��ʲ�?"�G�j�oQ����P_9�b�#hz�y�����U���&?�l�s��I��vL�_f��J��*��h�XP,��Eɩ��f��2��x��2��T�k+�35��t���%[��n�&�6Tb���U"g�cf���T�|_�t���z����HiA���d�I�Y{yb=�b�9�P�%s��n��'�}�v�FL��
�6��t��d!�Һ���x��8KUo��s�V�N$�Ǘ�!I������Lz�Uǌ.�MI|�����(0��v��p����P%б��֠{�Ov%�E�g��la(T���b9��O�� =�>^���׻�%�3MaM-��:(H�q��5̺��*8V��y�������1��4����*�$�+r=`j���ܵ����Ko�&�%߄ҏ�aE�c+U=�D��s�T%��hc���x��:�=�ڝ4�ђF�v�7\`z����3o_é�D��o��E@,�Ƹ�UQ�}O�5�����W^$ߕz���lU�vO�kC=��~\�U?�lg���S�oέ����bٍ�|�E���}�{�)6�>�a�`��7�޼P�8�M���ǿ�,�/:G������W���}i�� F���Z���iJ8�S�K���&6[�|��z��+���N��e-�_�)�5�����x ��n�mٝ�!���G<�����?�w
��X �B%t�z/�ܥ#h@7J�Ks0�4d��P�e�|����c���3~l�*p�(�\����R���G W\��_j�P� e5;�!'�����?���ʭ�-X��5^R������u�ePk2log�0󚀄�$wDr�x*{��u'VЁ��WYGP��Nd���������l�F�/r2u�~���vַ��B�kݥf'I��@��n�C���TV6V����XBvS��a�F��~'B�9
��g��ń�j�M�� ��Y*���U�m0|���Apj����A��N�P����V�zX m��4�w�������a��+�J�o~�k(���$��/���A9m*�F_�U����7.�(��9�1g+��c�j��
Ɂw�҂��;��*�R�`;������4G�m�Kl`�h5��jK B� �
 ��M��%i{�D�8�a�'����U|(ﺗ]�گ���� ��@�}����(� �Ku^�����\�`d3�*�RQp��մ�����a�c��J3���|�\x��+n�Y�.��-�9��ؒc���rI���މ�<'$�v�A��*��@1��1�`��盧C�&���HzS����v�V���k��L�C���y�|9`��g
�V�@1E����`^�v���`\z��G)�Z}�~˻�O[r޶�Jc�I���)���Q�;�`H `:�Ӕ���v�������&e۠i!_�1��E��9�L�z���d �舶%wfw�ڴ��B�[@$���̙�KQ����$2��eu�_U'�*x��L�S�V*�L��$�9�˨�
^n��h�c�ah2uw}:��`���(���`1��N�mV��
�\�������TF69*��%���o#s��t��{�[��_Ƙ�)l��������Y�;5��m�8������ಅّ+pRښ&I���lO�T ��q\������8�"{�n1�dH_���l����7<$HH��L��>]�}�Xc���������{��B�a�T����{�2yO5;�-<6��>��H����+�ה����l�=k� �=o�z!7%��,q���Q��%1���ɐ����m���,�[���nU���9�͚+����kY�^�'<�Z٦�z4�j0��g�		\���0���h.Χ�!w��4�φ�R������ڌI��ZL���������0��B}sB�������5�����"d_���ӿM§3n�v��4������Ԝ��� :_?��3oJ�jp�}��$�Ei�ё��KVN�x��E>�z��_q���eT�ᎰqX%L�A�'����L����#^��}( � O:�D��y�z`f�,��T��<���(n�/��WUV��-���$z�w�-f�˰��B&�|�t�� 7*HN�6d��^Z@L&�ppۭW���:�^�p�Hq�Ѕ�O0�[���������vBވP&�Uxr��!\��(���ј^��IL[IE��!'��a>�[~����U�g���ޠ�طB���� ��
qp tI�d�V�'Dx�v����~"�{�t?�a��5�gћ�}�W���*��6w�S�m���?��czf��$�٘M:g�b�z�EW�1����|ǹ���Z��4�����<H@2�J�IR�?���>���O��~�Љ`�+��"T�
���nB�����y?���	)[C�0N���%>��T6Ԩ��?/B��bpR��d���.c>0s>��'�ŬV����r`�#P�D�؀�7ٙ�96Vʤz>� ��W�T^`�V���d�C3�4bb��S�Z5�g�::Q������'��hK���ϫ��Z�0T�6�R��9�&�����Rh�
�}9�\�Ɇ�m9Z/X
*!�q�v��!P5 ��1<��� �[���I���ʟ��5���z5�;۳4�v1�3�1�g�9ģvE/�x��綎�F��oj�R���p���g�W}N2�z(Xų�ծ�a1��������/�;���ס�@#��/H;A���
,~u�f!բ�!�p0S���'g"��a��K���
9ǩ�E��M��W�U���ph�`]��â�eR"�$��3��ͱ��9s����YUҋ	���L�ev�+��6��(�qZ���yx��(ǌ:��⼱4�V�e�2�Hٙ�8ǭ�H����w׵}a6���-nȲx]�8\���1��`҂-��x{�	�qU�` �T�@ܭk}�%T!P�����q:�,��?3%5����VY������� KY���C��@����SW��CH!���t_id,msg.id,'*  ⌔︙ليس لدي صلاحيات تغيير المعلومات*',"md",true)  
return false
end
bot.setChatDescription(msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الوصف بنجاح*","md", true)
end
if BasicConstructor(msg) then
if text == 'تغيير اسم المجموعة' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":nameGr:add",true)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم بارسال الاسم الجديد الان*","md", true)
end
if text == 'تغيير الوصف' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":decGr:add",true)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم بارسال الوصف الجديد الان*","md", true)
end
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":law:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":law:add")
redis:set(bot_id..":"..msg.chat_id..":Law",text)
bot.sendText(msg.chat_id,msg.id,"*- تم حفظ القوانين بنجاح .*","md", true)
end
if Owner(msg) then
if text == 'تعين قوانين' or text == 'تعيين قوانين' or text == 'وضع قوانين' or text == 'اضف قوانين' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":law:add",true)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم بأرسال قائمة القوانين الان*","md", true)
end
if text == 'مسح القوانين' or text == 'حذف القوانين' then
redis:del(bot_id..":"..msg.chat_id..":Law")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." الجديد بنجاح *","md", true)
end
if text == "تنظيف التعديل" or text == "مسح التعديل" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙يتم البحث عن الرسائل المعدله*","md",true)
msgid = (msg.id - (1048576*250))
y = 0
r = 1048576
for i=1,250 do
r = r + 1048576
Delmsg = bot.getMessage(msg.chat_id,msgid + r)
if Delmsg and Delmsg.edit_date and Delmsg.edit_date ~= 0 then
bot.deleteMessages(msg.chat_id,{[1]= Delmsg.id}) 
y = y + 1
end
end
if y == 0 then 
t = "*  ⌔︙لم يتم العثور على رسائل معدله ضمن 250 رسالة السابقه*"
else
t = "*  ⌔︙تم حذف ( "..y.." ) من الرسائل المعدله *"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == "تنظيف الميديا" or text == "مسح الميديا" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙يتم البحث عن الميديا*","md",true)
msgid = (msg.id - (1048576*250))
y = 0
r = 1048576
for i=1,250 do
r = r + 1048576
Delmsg = bot.getMessage(msg.chat_id,msgid + r)
if Delmsg and Delmsg.content and Delmsg.content.luatele ~= "messageText" then
bot.deleteMessages(msg.chat_id,{[1]= Delmsg.id}) 
y = y + 1
end
end
if y == 0 then 
t = "*  ⌔︙لم يتم العثور على ميديا ضمن 250 رسالة السابقه*"
else
t = "*  ⌔︙تم حذف ( "..y.." ) من الميديا *"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'رفع الادامن' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙البوت لا يمتلك صلاحية*","md",true)  
return false
end
local info_ = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
local list_ = info_.members
y = 0
for k, v in pairs(list_) do
if info_.members[k].bot_info == nil then
if info_.members[k].status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",v.member_id.user_id) 
else
redis:sadd(bot_id..":"..msg.chat_id..":Status:Administrator",v.member_id.user_id) 
y = y + 1
end
end
end
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙تم رفع  ('..y..') ادمن بالمجموعة*',"md",true)  
end
if text == 'تعين ترحيب' or text == 'تعيين ترحيب' or text == 'وضع ترحيب' or text == 'اضف ترحيب' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":we:add",true)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل الان الترحيب الجديد\n  ⌔︙يمكنك اضافة :*\n  ⌔︙`user` > *يوزر المستخدم*\n  ⌔︙`name` > *اسم المستخدم*","md", true)
end
if text == 'الترحيب' then
if redis:get(bot_id..":"..msg.chat_id..":Welcome") then
t = redis:get(bot_id..":"..msg.chat_id..":Welcome")
else 
t = "*  ⌔︙لم يتم وضع ترحيب*"
end
bot.sendText(msg.chat_id,msg.id,t,"md", true)
end
if text == 'مسح الترحيب' or text == 'حذف الترحيب' then
redis:del(bot_id..":"..msg.chat_id..":Welcome")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." الجديد بنجاح*","md", true)
end
if text == 'مسح الايدي' or text == 'حذف الايدي' then
redis:del(bot_id..":"..msg.chat_id..":id")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." الجديد بنجاح*","md", true)
end
if text == 'تعين الايدي' or text == 'تعيين الايدي' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":id:add",true)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل الان النص\n  ⌔︙يمكنك اضافة :*\n  ⌔︙`#username` > *اسم المستخدم*\n  ⌔︙`#msgs` > *عدد رسائل المستخدم*\n  ⌔︙`#photos` > *عدد صور المستخدم*\n  ⌔︙`#id` > *ايدي المستخدم*\n  ⌔︙`#auto` > *تفاعل المستخدم*\n  ⌔︙`#stast` > *موقع المستخدم* \n  ⌔︙`#edit` > *عدد التعديلات*\n  ⌔︙`#AddMem` > *عدد الجهات*\n  ⌔︙`#Description` > *تعليق الصورة*","md", true)
end
if text == "تغيير الايدي" or text == "تغير الايدي" then 
local List = {'◇︰𝘜𝘴𝘌𝘳 - #username \n◇︰𝘪𝘋 - #id\n◇︰𝘚𝘵𝘈𝘴𝘵 - #stast\n◇︰𝘈𝘶𝘛𝘰 - #cont \n◇︰𝘔𝘴𝘎𝘴 - #msgs','◇︰Msgs : #msgs .\n◇︰ID : #id .\n◇︰Stast : #stast .\n◇︰UserName : #username .','˛ َ𝖴ᥱ᥉ : #username  .\n˛ َ𝖲𝗍ُɑِ  : #stast   . \n˛ َ𝖨ժ : #id  .\n˛ َ𝖬⁪⁬⁮᥉𝗀ِ : #msgs   .','⚕ 𓆰 𝑾𝒆𝒍𝒄𝒐𝒎𝒆 ??𝒐 𝑮𝒓𝒐𝒖𝒑 ★\n- 🖤 | 𝑼𝑬𝑺 : #username ‌‌‏\n- 🖤 | 𝑺𝑻𝑨 : #stast \n- 🖤 | 𝑰𝑫 : #id ‌‌‏\n- 🖤 | 𝑴𝑺𝑮 : #msgs','◇︰𝖬𝗌𝗀𝗌 : #msgs  .\n◇︰𝖨𝖣 : #id  .\n◇︰𝖲𝗍𝖺𝗌𝗍 : #stast .\n◇︰𝖴𝗌𝖾𝗋??𝖺𝗆𝖾 : #username .','⌁ Use ⇨{#username} \n⌁ Msg⇨ {#msgs} \n⌁ Sta ⇨ {#stast} \n⌁ iD ⇨{#id} \n▿▿▿','゠𝚄𝚂𝙴𝚁 𖨈 #username 𖥲 .\n゠𝙼𝚂𝙶 𖨈 #msgs 𖥲 .\n゠𝚂𝚃𝙰 𖨈 #stast 𖥲 .\n゠𝙸𝙳 𖨈 #id 𖥲 .','▹ 𝙐SE?? 𖨄 #username  𖤾.\n▹ 𝙈𝙎𝙂 𖨄 #msgs  𖤾.\n▹ 𝙎𝙏?? 𖨄 #stast  𖤾.\n▹ 𝙄𝘿 𖨄 #id 𖤾.','➼ : 𝐼𝐷 𖠀 #id\n➼ : 𝑈𝑆𝐸𝑅 𖠀 #username\n➼ : 𝑀𝑆𝐺𝑆 𖠀 #msgs\n➼ : 𝑆𝑇𝐴S𝑇 𖠀 #stast\n➼ : 𝐸𝐷𝐼𝑇  𖠀 #edit\n','┌ 𝐔𝐒𝐄𝐑 𖤱 #username 𖦴 .\n├ 𝐌𝐒?? 𖤱 #msgs 𖦴 .\n├ 𝐒𝐓𝐀 𖤱 #stast 𖦴 .\n└ 𝐈𝐃 𖤱 #id 𖦴 .','୫ 𝙐𝙎𝙀𝙍𝙉𝘼𝙈𝙀 ➤ #username\n୫ 𝙈𝙀𝙎𝙎𝘼𝙂𝙀𝙎 ➤ #msgs\n୫ 𝙎𝙏𝘼𝙏𝙎 ➤ #stast\n୫ 𝙄𝘿 ➤ #id','☆-𝐮𝐬𝐞𝐫 : #username 𖣬  \n☆-𝐦𝐬𝐠  : #msgs 𖣬 \n☆-𝐬𝐭𝐚 : #stast 𖣬 \n☆-𝐢𝐝  : #id 𖣬','𝐘𝐨𝐮𝐫 𝐈𝐃 ☤🇮🇶- #id \n𝐔𝐬𝐞𝐫𝐍𝐚☤🇮🇶- #username \n𝐒𝐭𝐚𝐬𝐓 ☤🇮🇶- #stast \n𝐌𝐬𝐠𝐒☤🇮🇶 - #msgs','.𖣂 𝙪𝙨𝙚𝙧𝙣𝙖𝙢𝙚 , #username  \n.𖣂 𝙨𝙩𝙖𝙨𝙩 , #stast\n.𖣂 𝙡𝘿 , #id  \n.𖣂 𝙂𝙖𝙢𝙨 , #game  \n.𖣂 𝙢𝙨𝙂𝙨 , #msgs'}
local Text_Rand = List[math.random(#List)]
redis:set(bot_id..":"..msg.chat_id..":id",Text_Rand)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغير رسالة الايدي*","md",true)  
end
if text == 'مسح الرابط' or text == 'حذف الرابط' then
redis:del(bot_id..":"..msg.chat_id..":link")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." الجديد بنجاح*","md", true)
end
if text == 'تعين الرابط' or text == 'تعيين الرابط' or text == 'وضع رابط' or text == 'تغيير الرابط' or text == 'تغير الرابط' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":link:add",true)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم بارسال الرابط الجديد الان*","md", true)
end
if text == 'فحص البوت' then 
local StatusMember = bot.getChatMember(msg.chat_id,bot_id).status.luatele
if (StatusMember ~= "chatMemberStatusAdministrator") then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت عضو في المجموعة*',"md",true) 
return false
end
local GetMemberStatus = bot.getChatMember(msg.chat_id,bot_id).status
if GetMemberStatus.can_change_info then
change_info = '✔️' else change_info = '❌'
end
if GetMemberStatus.can_delete_messages then
delete_messages = '✔️' else delete_messages = '❌'
end
if GetMemberStatus.can_invite_users then
invite_users = '✔️' else invite_users = '❌'
end
if GetMemberStatus.can_pin_messages then
pin_messages = '✔️' else pin_messages = '❌'
end
if GetMemberStatus.can_restrict_members then
restrict_members = '✔️' else restrict_members = '❌'
end
if GetMemberStatus.can_promote_members then
promote = '✔️' else promote = '❌'
end
PermissionsUser = '*\n  ⌔︙صلاحيات البوت في المجموعة :\nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ '..'\n  ⌔︙تغيير المعلومات : '..change_info..'\n  ⌔︙تثبيت الرسائل : '..pin_messages..'\n  ⌔︙اضافة مستخدمين : '..invite_users..'\n  ⌔︙مسح الرسائل : '..delete_messages..'\n  ⌔︙حظر المستخدمين : '..restrict_members..'\n  ⌔︙اضافة المشرفين : '..promote..'\n\n*'
bot.sendText(msg.chat_id,msg.id,PermissionsUser,"md",true) 
return false
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:delmsg") then
if text == ("امسح") and BasicConstructor(msg) then  
local list = redis:smembers(bot_id..":"..msg.chat_id..":mediaAude:ids")
for k,v in pairs(list) do
local Message = v
if Message then
t = "  ⌔︙تم مسح "..k.." من الوسائط الموجوده"
bot.deleteMessages(msg.chat_id,{[1]= Message})
redis:del(bot_id..":"..msg.chat_id..":mediaAude:ids")
end
end
if #list == 0 then
t = "  ⌔︙لا يوجد ميديا في المجموعة"
end
Text = Reply_Status(msg.sender.user_id,"*"..t.."*").by
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text and text:match('^تنظيف (%d+)$') then
local NumMessage = text:match('^تنظيف (%d+)$')
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙البوت ليس ادمن في المجموعة*","md",true)  
return false
end
if GetInfoBot(msg).Delmsg == false then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙البوت لا يمتلك صلاحية حذف الرسائل*","md",true)  
return false
end
if tonumber(NumMessage) > 1000 then
bot.sendText(msg.chat_id,msg.id,'* لا تستطيع حذف اكثر من 1000 رسالة*',"md",true)  
return false
end
local Message = msg.id
for i=1,tonumber(NumMessage) do
bot.deleteMessages(msg.chat_id,{[1]= Message})
Message = Message - 1048576
end
bot.sendText(msg.chat_id, msg.id,"*  ⌔︙تم تنظيف ( "..NumMessage.." ) رسالة *", 'md')
end
end
if text == 'مسح الرتب' or text == 'حذف الرتب' then
redis:del(bot_id.."Reply:developer"..msg.chat_id)
redis:del(bot_id..":Reply:mem"..msg.chat_id)
redis:del(bot_id..":Reply:Vips"..msg.chat_id)
redis:del(bot_id..":Reply:Administrator"..msg.chat_id)
redis:del(bot_id..":Reply:BasicConstructor"..msg.chat_id)
redis:del(bot_id..":Reply:Constructor"..msg.chat_id)
redis:del(bot_id..":Reply:Owner"..msg.chat_id)
redis:del(bot_id..":Reply:Creator"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*","md", true)
end
if text and text:match("^تغير رد المطور (.*)$") then
local Teext = text:match("^تغير رد المطور (.*)$") 
redis:set(bot_id.."Reply:developer"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الرد بنجاح الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المالك (.*)$") then
local Teext = text:match("^تغير رد المالك (.*)$") 
redis:set(bot_id..":Reply:Creator"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الرد بنجاح الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المنشئ الاساسي (.*)$") then
local Teext = text:match("^تغير رد المنشئ الاساسي (.*)$") 
redis:set(bot_id..":Reply:BasicConstructor"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الرد بنجاح الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المنشئ (.*)$") then
local Teext = text:match("^تغير رد المنشئ (.*)$") 
redis:set(bot_id..":Reply:Constructor"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الرد بنجاح الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المدير (.*)$") then
local Teext = text:match("^تغير رد المدير (.*)$") 
redis:set(bot_id..":Reply:Owner"..msg.chat_id,Teext) 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الرد بنجاح الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد الادمن (.*)$") then
local Teext = text:match("^تغير رد الادمن (.*)$") 
redis:set(bot_id..":Reply:Administrator"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الرد بنجاح الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المميز (.*)$") then
local Teext = text:match("^تغير رد المميز (.*)$") 
redis:set(bot_id..":Reply:Vips"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الرد بنجاح الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد العضو (.*)$") then
local Teext = text:match("^تغير رد العضو (.*)$") 
redis:set(bot_id..":Reply:mem"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الرد بنجاح الى : *"..Teext.. "", 'md')
elseif text == 'حذف رد المطور' then
redis:del(bot_id..":Reply:developer"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*", 'md')
elseif text == 'حذف رد المالك' then
redis:del(bot_id..":Reply:Creator"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*", 'md')
elseif text == 'حذف رد المنشئ الاساسي' then
redis:del(bot_id..":Reply:BasicConstructor"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*", 'md')
elseif text == 'حذف رد المنشئ' then
redis:del(bot_id..":Reply:Constructor"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*", 'md')
elseif text == 'حذف رد المدير' then
redis:del(bot_id..":Reply:Owner"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*", 'md')
elseif text == 'حذف رد الادمن' then
redis:del(bot_id..":Reply:Administrator"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*", 'md')
elseif text == 'حذف رد المميز' then
redis:del(bot_id..":Reply:Vips"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*", 'md')
elseif text == 'حذف رد العضو' then
redis:del(bot_id..":Reply:mem"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*", 'md')
end
if text == 'الغاء تثبيت الكل' or text == 'الغاء التثبيت' then
if GetInfoBot(msg).PinMsg == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙ليس لدي صلاحية تثبيت رسائل*',"md",true)  
return false
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم الغاء تثبيت جميع الرسائل المثبته*","md",true)
bot.unpinAllChatMessages(msg.chat_id) 
end
end
if BasicConstructor(msg) then
----------------------------------------------------------------------------------------------------
if text == "قائمة المنع" or text == "الممنوعات" or text == "قائمة المنع" then
local Photo =redis:scard(bot_id.."mn:content:Photo"..msg.chat_id) 
local Animation =redis:scard(bot_id.."mn:content:Animation"..msg.chat_id)  
local Sticker =redis:scard(bot_id.."mn:content:Sticker"..msg.chat_id)  
local Text =redis:scard(bot_id.."mn:content:Text"..msg.chat_id)  
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = 'الصور الممنوعه', data="mn_"..msg.sender.user_id.."_ph"},{text = 'الكلمات الممنوعه', data="mn_"..msg.sender.user_id.."_tx"}},
{{text = 'المتحركات الممنوعه', data="mn_"..msg.sender.user_id.."_gi"},{text = 'الملصقات الممنوعه',data="mn_"..msg.sender.user_id.."_st"}},
{{text = 'تحديث',data="mn_"..msg.sender.user_id.."_up"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*   ⌔︙تحوي قائمة المنع على\n  ⌔︙الصور ( "..Photo.." )\n  ⌔︙الكلمات ( "..Text.." )\n  ⌔︙الملصقات ( "..Sticker.." )\n  ⌔︙المتحركات ( "..Animation.." ) .\n  ⌔︙اضغط على القائمة المراد حذفها*","md",true, false, false, false, reply_markup)
return false
end
if text == "مسح قائمة المنع" or text == "مسح الممنوعات" then
bot.sendText(msg.chat_id,msg.id,"*- تم "..text.." بنجاح *","md",true)  
redis:del(bot_id.."mn:content:Text"..msg.chat_id) 
redis:del(bot_id.."mn:content:Sticker"..msg.chat_id) 
redis:del(bot_id.."mn:content:Animation"..msg.chat_id) 
redis:del(bot_id.."mn:content:Photo"..msg.chat_id) 
end
if text == "منع" and msg.reply_to_message_id == 0 then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم الان بارسال ( نص او الميديا ) لمنعه من المجموعة*","md",true)  
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":mn:set",true)
end
if text == "منع" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if Remsg.content.text then   
if redis:sismember(bot_id.."mn:content:Text"..msg.chat_id,Remsg.content.text.text) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع الكلمه سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Text"..msg.chat_id,Remsg.content.text.text)  
ty = "الرسالة"
elseif Remsg.content.sticker then   
if redis:sismember(bot_id.."mn:content:Sticker"..msg.chat_id,Remsg.content.sticker.sticker.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع الملصق سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Sticker"..msg.chat_id, Remsg.content.sticker.sticker.remote.unique_id)  
ty = "الملصق"
elseif Remsg.content.animation then
if redis:sismember(bot_id.."mn:content:Animation"..msg.chat_id,Remsg.content.animation.animation.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع المتحركة سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Animation"..msg.chat_id, Remsg.content.animation.animation.remote.unique_id)  
ty = "المتحركة"
elseif Remsg.content.photo then
if redis:sismember(bot_id.."mn:content:Photo"..msg.chat_id,Remsg.content.photo.sizes[1].photo.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع الصورة سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Photo"..msg.chat_id,Remsg.content.photo.sizes[1].photo.remote.unique_id)  
ty = "الصورة"
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع "..ty.." بنجاح*","md",true)  
end
if text == "الغاء منع" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if Remsg.content.text then   
redis:srem(bot_id.."mn:content:Text"..msg.chat_id,Remsg.content.text.text)  
ty = "الرسالة"
elseif Remsg.content.sticker then   
redis:srem(bot_id.."mn:content:Sticker"..msg.chat_id, Remsg.content.sticker.sticker.remote.unique_id)  
ty = "الملصق"
elseif Remsg.content.animation then
redis:srem(bot_id.."mn:content:Animation"..msg.chat_id, Remsg.content.animation.animation.remote.unique_id)  
ty = "المتحركة"
elseif Remsg.content.photo then
redis:srem(bot_id.."mn:content:Photo"..msg.chat_id,Remsg.content.photo.sizes[1].photo.remote.unique_id)  
ty = "الصورة"
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم الغاء منع "..ty.." بنجاح*","md",true)  
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if msg and msg.content.text and msg.content.text.entities[1] and (msg.content.text.entities[1].luatele == "textEntity") and (msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName") then
if text and text:match('^كشف (.*)$') or text and text:match('^ايدي (.*)$') then
local UserName = text:match('^كشف (.*)$') or text:match('^ايدي (.*)$')
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
sm = bot.getChatMember(msg.chat_id,usetid)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المنشئ"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "المشرف"
else
gstatus = "العضو"
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙الايدي : *( `"..(usetid).."` *)*\n*  ⌔︙الرتبه : *( `"..(Get_Rank(usetid,msg.chat_id)).."` *)*\n*  ⌔︙الموقع : *( `"..(gstatus).."` *)*\n*  ⌔︙عدد الرسائل : *( `"..(redis:get(bot_id..":"..msg.chat_id..":"..usetid..":message") or 1).."` *)*" ,"md",true)  
end
end
if Administrator(msg)  then
if text and text:match('^طرد (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الطرد معطل بواسطة المنشئين الاساسيين*").yu,"md",true)
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية طرد الاعضاء* ',"md",true)  
return false
end
if not Norank(usetid,msg.chat_id) then
t = "*  ⌔︙لا يمكنك طرد "..Get_Rank(usetid,msg.chat_id).."*"
else
t = "*  ⌔︙تم طرده بنجاح*"
bot.setChatMemberStatus(msg.chat_id,usetid,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).i,"md",true)    
end
end
if text and text:match("^تنزيل (.*) (.*)") and tonumber(msg.reply_to_message_id) == 0 then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
local infotxt = {text:match("^تنزيل (.*) (.*)")}
TextMsg = infotxt[1]
if msg.content.text then 
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not redis:sismember(bot_id..srt1.."Status:"..srt,usetid) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*  ⌔︙لا يمتلك رتبه بالفعل*").yu,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*  ⌔︙تم تنزيله بنجاح*").i,"md",true)  
return false
end
end
end
if text and text:match("^رفع (.*) (.*)") and tonumber(msg.reply_to_message_id) == 0 then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
local infotxt = {text:match("^رفع (.*) (.*)")}
TextMsg = infotxt[1]
if msg.content.text then 
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:Up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الرفع معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if redis:sismember(bot_id..srt1.."Status:"..srt,usetid) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*  ⌔︙تم رفعه سابقا*").i,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*  ⌔︙تم رفعه بنجاح*").i,"md",true)  
return false
end
end
end
if text and text:match("^تنزيل الكل (.*)") and tonumber(msg.reply_to_message_id) == 0 then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if Get_Rank(usetid,msg.chat_id)== "العضو" then
tt = "لا يمتلك رتبه بالفعل"
else
tt = "تم تنزيله من جميع الرتب بنجاح"
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..":Status:programmer",usetid)
redis:srem(bot_id..":Status:developer",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,usetid).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",usetid)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*  ⌔︙"..tt.."*").yu,"md",true)  
return false
end
end
if text and text:match('^الغاء كتم (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*  ⌔︙تم الغاء كتمك بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":silent",usetid)
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).yu,"md",true)  
end
end
if text and text:match('^كتم (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الكتم معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if not Norank(usetid,msg.chat_id) then
t = "*  ⌔︙لا يمكنك كتم "..Get_Rank(usetid,msg.chat_id).."*"
else
t = "*  ⌔︙تم كتمه بنجاح*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",usetid)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).i,"md",true)    
end
end
if text and text:match('^الغاء حظر (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء حظره بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":Ban",usetid)
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,usetid,'restricted',{1,1,1,1,1,1,1,1,1})
end
end
if text and text:match('^حظر (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الحظر معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية حظر الاعضاء* ',"md",true)  
return false
end
if not Norank(usetid,msg.chat_id) then
t = "*  ⌔︙لا يمكنك حظر "..Get_Rank(usetid,msg.chat_id).."*"
else
t = "*  ⌔︙تم حظره بنجاح*"
bot.setChatMemberStatus(msg.chat_id,usetid,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",usetid)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).i,"md",true)    
end
end
end
end
----------------------------------------------------------------------------------------------------
if Administrator(msg)  then
----------------------------------------------------------------------------------------------------
if text and text:match('^رفع القيود @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^رفع القيود @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserId_Info.id) then
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserId_Info.id)
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserId_Info.id) then
redis:srem(bot_id..":"..msg.chat_id..":silent",UserId_Info.id)
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserId_Info.id) then
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserId_Info.id)
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*  ⌔︙تم رفع القيود عنه*").i,"md",true)  
return false
end
if text and text:match('^رفع القيود (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^رفع القيود (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserName) then
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserName)
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserName) then
redis:srem(bot_id..":"..msg.chat_id..":silent",UserName)
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserName) then
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserName)
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*  ⌔︙تم رفع القيود عنه*").i,"md",true)  
return false
end
if text == "رفع القيود" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", Remsg.sender.user_id) then
redis:srem(bot_id..":"..msg.chat_id..":restrict",Remsg.sender.user_id)
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", Remsg.sender.user_id) then
redis:srem(bot_id..":"..msg.chat_id..":silent",Remsg.sender.user_id)
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", Remsg.sender.user_id) then
redis:srem(bot_id..":"..msg.chat_id..":Ban",Remsg.sender.user_id)
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*  ⌔︙تم رفع القيود عنه*").i,"md",true)  
return false
end
if text and text:match('^كشف القيود @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كشف القيود @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if redis:sismember(bot_id..":bot:Ban", UserId_Info.id) then
Banal = "  ⌔︙الحظر العام : محظور بالفعل"
else
Banal = "  ⌔︙الحظر العام : غير محظور"
end
if redis:sismember(bot_id..":bot:silent", UserId_Info.id) then
silental  = "  ⌔︙كتم العام : مكتوم بالفعل"
else
silental = "  ⌔︙كتم العام : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserId_Info.id) then
rict = "  ⌔︙التقييد : مقيد بالفعل"
else
rict = "  ⌔︙التقييد : غير مقيد"
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserId_Info.id) then
sent = "\n  ⌔︙الكتم : مكتوم بالفعل"
else
sent = "\n  ⌔︙الكتم : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserId_Info.id) then
an = "\n  ⌔︙الحظر : محظور بالفعل"
else
an = "\n  ⌔︙الحظر : غير محظور"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id," *ٴ─━─━─━─×─━─━─━─\n"..Banal.."\n"..silental.."\n"..rict..""..sent..""..an.."*").i,"md",true)  
return false
end
if text and text:match('^كشف القيود (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كشف القيود (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if redis:sismember(bot_id..":bot:Ban", UserName) then
Banal = "  ⌔︙الحظر العام : محظور بالفعل"
else
Banal = "  ⌔︙الحظر العام : غير محظور"
end
if redis:sismember(bot_id..":bot:silent", UserName) then
silental  = "  ⌔︙كتم العام : مكتوم بالفعل"
else
silental = "  ⌔︙كتم العام : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserName) then
rict = "  ⌔︙التقييد : مقيد بالفعل"
else
rict = "  ⌔︙التقييد : غير مقيد"
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserName) then
sent = "\n  ⌔︙الكتم : مكتوم بالفعل"
else
sent = "\n  ⌔︙الكتم : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserName) then
an = "\n  ⌔︙الحظر : محظور بالفعل"
else
an = "\n  ⌔︙الحظر : غير محظور"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*ٴ─━─━─━─×─━─━─━─\n"..Banal.."\n"..silental.."\n"..rict..""..sent..""..an.."*").i,"md",true)  
return false
end
if text == "كشف القيود" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if redis:sismember(bot_id..":bot:Ban", Remsg.sender.user_id) then
Banal = "  ⌔︙الحظر العام : محظور بالفعل"
else
Banal = "  ⌔︙الحظر العام : غير محظور"
end
if redis:sismember(bot_id..":bot:silent", Remsg.sender.user_id) then
silental  = "  ⌔︙كتم العام : مكتوم بالفعل"
else
silental = "  ⌔︙كتم العام : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", Remsg.sender.user_id) then
rict = "  ⌔︙التقييد : مقيد بالفعل"
else
rict = "  ⌔︙التقييد : غير مقيد"
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", Remsg.sender.user_id) then
sent = "\n  ⌔︙الكتم : مكتوم بالفعل"
else
sent = "\n  ⌔︙الكتم : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", Remsg.sender.user_id) then
an = "\n  ⌔︙الحظر : محظور بالفعل"
else
an = "\n  ⌔︙الحظر : غير محظور"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*ٴ─━─━─━─×─━─━─━─\n"..Banal.."\n"..silental.."\n"..rict..""..sent..""..an.."*").i,"md",true)  
return false
end
if text and text:match('^تقييد (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^تقييد (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية تقييد الاعضاء* ',"md",true)  
return false
end
if not Norank(UserName,msg.chat_id) then
t = "*  ⌔︙لا يمكنك تقييد "..Get_Rank(UserName,msg.chat_id).."*"
else
t = "*  ⌔︙تم تقييده بنجاح*"
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":restrict",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^تقييد @(%S+)$') then
local UserName = text:match('^تقييد @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية تقييد الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك تقييد "..Get_Rank(UserId_Info.id,msg.chat_id).."*"
else
t = "*  ⌔︙تم تقييده بنجاح*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":restrict",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "تقييد" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية تقييد الاعضاء* ',"md",true)  
return false
end
if not Norank(Remsg.sender.user_id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك تقييد "..Get_Rank(Remsg.sender.user_id,msg.chat_id).."*"
else
t = "*  ⌔︙تم تقييده بنجاح*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":restrict",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء تقييد (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء تقييد (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*  ⌔︙تم الغاء تقييده بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء تقييد @(%S+)$') then
local UserName = text:match('^الغاء تقييد @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء تقييده بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)  
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == "الغاء تقييد" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء تقييده بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":restrict",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^طرد (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^طرد (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الطرد معطل بواسطة المنشئين الاساسيين*").yu,"md",true)
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية طرد الاعضاء* ',"md",true)  
return false
end
if not Norank(UserName,msg.chat_id) then
t = "*  ⌔︙لا يمكنك طرد "..Get_Rank(UserName,msg.chat_id).."*"
else
t = "*  ⌔︙تم طرده بنجاح*"
bot.setChatMemberStatus(msg.chat_id,UserName,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^طرد @(%S+)$') then
local UserName = text:match('^طرد @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*- اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الطرد معطل بواسطة المنشئين الاساسيين*").yu,"md",true)
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية طرد الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك طرد "..Get_Rank(UserId_Info.id,msg.chat_id).."*"
else
t = "*  ⌔︙تم طرده بنجاح*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "طرد" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الطرد معطل بواسطة المنشئين الاساسيين*").yu,"md",true)
return false
end
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية طرد الاعضاء* ',"md",true)  
return false
end
if not Norank(Remsg.sender.user_id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك طرد "..Get_Rank(Remsg.sender.user_id,msg.chat_id).."*"
else
t = "*  ⌔︙تم طرده بنجاح*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^حظر (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^حظر (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الحظر معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية حظر الاعضاء* ',"md",true)  
return false
end
if not Norank(UserName,msg.chat_id) then
t = "*  ⌔︙لا يمكنك حظر "..Get_Rank(UserName,msg.chat_id).."*"
else
t = "*  ⌔︙تم حظره بنجاح*"
bot.setChatMemberStatus(msg.chat_id,UserName,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^حظر @(%S+)$') then
local UserName = text:match('^حظر @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الحظر معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية حظر الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك حظر "..Get_Rank(UserId_Info.id,msg.chat_id).."*"
else
t = "*  ⌔︙تم حظره بنجاح*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "حظر" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الحظر معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية حظر الاعضاء* ',"md",true)  
return false
end
if not Norank(Remsg.sender.user_id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك حظر "..Get_Rank(Remsg.sender.user_id,msg.chat_id).."*"
else
t = "*  ⌔︙تم حظره بنجاح*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء حظر (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء حظر (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*  ⌔︙تم الغاء حظره بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء حظر @(%S+)$') then
local UserName = text:match('^الغاء حظر @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء حظره بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)  
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == "الغاء حظر" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء حظره بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":Ban",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^كتم (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كتم (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الكتم معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if not Norank(UserName,msg.chat_id) then
t = "*  ⌔︙لا يمكنك كتم "..Get_Rank(UserName,msg.chat_id).."*"
else
t = "*  ⌔︙تم كتمه بنجاح*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^كتم @(%S+)$') then
local UserName = text:match('^كتم @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الكتم معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك كتم "..Get_Rank(UserId_Info.id,msg.chat_id).."*"
else
t = "*  ⌔︙تم كتمه بنجاح*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "كتم" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الكتم معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if not Norank(Remsg.sender.user_id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك كتم "..Get_Rank(Remsg.sender.user_id,msg.chat_id).."*"
else
t = "*  ⌔︙تم كتمه بنجاح*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء كتم (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء كتم (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*  ⌔︙تم الغاء كتمه بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":silent",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^الغاء كتم @(%S+)$') then
local UserName = text:match('^الغاء كتم @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء كتمه بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":silent",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)  
end
if text == "الغاء كتم" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء كتمه بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":silent",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).i,"md",true)  
end
if text == 'المكتومين' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المقيدين' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":restrict") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المحظورين' then
t = '\n*  ⌔︙قائمة '..text..'  \nٴ─━─━─━─×─━─━─━─ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'مسح المحظورين' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
bot.setChatMemberStatus(msg.chat_id,v,'restricted',{1,1,1,1,1,1,1,1,1})
end
redis:del(bot_id..":"..msg.chat_id..":Ban") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح المكتومين' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":silent") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح المقيدين' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":restrict") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
bot.setChatMemberStatus(msg.chat_id,v,'restricted',{1,1,1,1,1,1,1,1,1})
end
redis:del(bot_id..":"..msg.chat_id..":restrict") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
end
if programmer(msg)  then
if text and text:match('^كتم عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كتم عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not Isrank(UserName,msg.chat_id) then
t = "*  ⌔︙لا يمكنك كتم "..Get_Rank(UserName,msg.chat_id).."*"
else
t = "*  ⌔︙تم كتمه بنجاح*"
redis:sadd(bot_id..":bot:silent",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^كتم عام @(%S+)$') then
local UserName = text:match('^كتم عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Isrank(UserId_Info.id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك كتم "..Get_Rank(UserId_Info.id,msg.chat_id).."*"
else
t = "*  ⌔︙تم كتمه بنجاح*"
redis:sadd(bot_id..":bot:silent",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "كتم عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not Isrank(Remsg.sender.user_id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك كتم "..Get_Rank(Remsg.sender.user_id,msg.chat_id).."*"
else
t = "*  ⌔︙تم كتمه بنجاح*"
redis:sadd(bot_id..":bot:silent",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء كتم عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء كتم عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*  ⌔︙تم الغاء كتم العام بنجاح*"
redis:srem(bot_id..":bot:silent",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^الغاء كتم عام @(%S+)$') then
local UserName = text:match('^الغاء كتم عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء كتم العام بنجاح*"
redis:srem(bot_id..":bot:silent",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)  
end
if text == "الغاء كتم عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء كتم العام بنجاح*"
redis:srem(bot_id..":bot:silent",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).i,"md",true)  
end
if text == 'المكتومين عام' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":bot:silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'مسح المكتومين عام' then
local Info_ = redis:smembers(bot_id..":bot:silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":bot:silent") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text and text:match('^حظر عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^حظر عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية حظر عام الاعضاء* ',"md",true)  
return false
end
if not Isrank(UserName,msg.chat_id) then
t = "*  ⌔︙لا يمكنك حظر عام "..Get_Rank(UserName,msg.chat_id).."*"
else
t = "*  ⌔︙تم حظر العام بنجاح*"
bot.setChatMemberStatus(msg.chat_id,UserName,'banned',0)
redis:sadd(bot_id..":bot:Ban",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^حظر عام @(%S+)$') then
local UserName = text:match('^حظر عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية حظر عام الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Isrank(UserId_Info.id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك حظر عام "..Get_Rank(UserId_Info.id,msg.chat_id).."*"
else
t = "*  ⌔︙تم حظر العام بنجاح*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'banned',0)
redis:sadd(bot_id..":bot:Ban",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "حظر عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية حظر عام الاعضاء* ',"md",true)  
return false
end
if not Isrank(Remsg.sender.user_id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك حظر عام "..Get_Rank(Remsg.sender.user_id,msg.chat_id).."*"
else
t = "*  ⌔︙تم حظر العام بنجاح*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'banned',0)
redis:sadd(bot_id..":bot:Ban",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء حظر عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء حظر عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*  ⌔︙تم الغاء حظر العام بنجاح*"
redis:srem(bot_id..":bot:Ban",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء حظر عام @(%S+)$') then
local UserName = text:match('^الغاء حظر عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء حظر العام بنجاح*"
redis:srem(bot_id..":bot:Ban",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)  
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == "الغاء حظر عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء حظر العام بنجاح*"
redis:srem(bot_id..":bot:Ban",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == 'المحظورين عام' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":bot:Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'مسح المحظورين عام' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":bot:Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
bot.setChatMemberStatus(msg.chat_id,v,'restricted',{1,1,1,1,1,1,1,1,1})
end
redis:del(bot_id..":bot:Ban") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
end
----------------------------------------------------------------------------------------------------
if not redis:get(bot_id..":"..msg.chat_id..":settings:all") then
if text == '@all' and BasicConstructor(msg) then
if redis:get(bot_id..':'..msg.chat_id..':all') then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم عمل تاك في المجموعة قبل قليل انتظر من فضلك*","md",true) 
end
redis:setex(bot_id..':'..msg.chat_id..':all',300,true)
x = 0
tags = 0
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
if #members <= 9 then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لا يوجد عدد كافي من الاعضاء*","md",true) 
end
for k, v in pairs(members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if x == 10 or x == tags or k == 0 then
tags = x + 10
t = "#all"
end
x = x + 1
tagname = UserInfo.first_name.."ْ"
tagname = tagname:gsub('"',"")
tagname = tagname:gsub('"',"")
tagname = tagname:gsub("`","")
tagname = tagname:gsub("*","") 
tagname = tagname:gsub("_","")
tagname = tagname:gsub("]","")
tagname = tagname:gsub("[[]","")
t = t.." ~ ["..tagname.."](tg://user?id="..v.member_id.user_id..")"
if x == 10 or x == tags or k == 0 then
local Text = t:gsub('#all,','#all\n')
bot.sendText(msg.chat_id,0,Text,"md",true)  
end
end
end
if text and text:match("^@all (.*)$") and BasicConstructor(msg) then
if text:match("^@all (.*)$") ~= nil and text:match("^@all (.*)$") ~= "" then
TextMsg = text:match("^@all (.*)$")
if redis:get(bot_id..':'..msg.chat_id..':all') then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم عمل تاك في المجموعة قبل قليل انتظر من فضلك*","md",true) 
end
redis:setex(bot_id..':'..msg.chat_id..':all',300,true)
x = 0
tags = 0
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
if #members <= 9 then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لا يوجد عدد كافي من الاعضاء*","md",true) 
end
for k, v in pairs(members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if x == 10 or x == tags or k == 0 then
tags = x + 10
t = "#all"
end
x = x + 1
tagname = UserInfo.first_name.."ْ"
tagname = tagname:gsub('"',"")
tagname = tagname:gsub('"',"")
tagname = tagname:gsub("`","")
tagname = tagname:gsub("*","") 
tagname = tagname:gsub("_","")
tagname = tagname:gsub("]","")
tagname = tagname:gsub("[[]","")
t = t.." ~ ["..tagname.."](tg://user?id="..v.member_id.user_id..")"
if x == 10 or x == tags or k == 0 then
local Text = t:gsub('#all,','#all\n')
TextMsg = TextMsg
TextMsg = TextMsg:gsub('"',"")
TextMsg = TextMsg:gsub('"',"")
TextMsg = TextMsg:gsub("`","")
TextMsg = TextMsg:gsub("*","") 
TextMsg = TextMsg:gsub("_","")
TextMsg = TextMsg:gsub("]","")
TextMsg = TextMsg:gsub("[[]","")
bot.sendText(msg.chat_id,0,TextMsg.."\nٴ─━─━─━─×─━─━─━─ \n"..Text,"md",true)  
end
end
end
end
end
--
if msg and msg.content then
if text == 'تنزيل جميع الرتب' and Creator(msg) then   
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Owner")
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator")
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*","md", true)
end
if msg.content.luatele == "messageSticker" or msg.content.luatele == "messageContact" or msg.content.luatele == "messageVideoNote" or msg.content.luatele == "messageDocument" or msg.content.luatele == "messageVideo" or msg.content.luatele == "messageAnimation" or msg.content.luatele == "messagePhoto" then
redis:sadd(bot_id..":"..msg.chat_id..":mediaAude:ids",msg.id)  
end
if redis:get(bot_id..":"..msg.chat_id..":settings:mediaAude") then
local gmedia = redis:scard(bot_id..":"..msg.chat_id..":mediaAude:ids")  
if gmedia >= tonumber(redis:get(bot_id..":mediaAude:utdl"..msg.chat_id) or 200) then
local liste = redis:smembers(bot_id..":"..msg.chat_id..":mediaAude:ids")
for k,v in pairs(liste) do
local Mesge = v
if Mesge then
t = "*  ⌔︙تم مسح "..k.." من الوسائط تلقائيا\n  ⌔︙يمكنك تعطيل الميزه بستخدام الامر* ( `تعطيل المسح التلقائي` )"
bot.deleteMessages(msg.chat_id,{[1]= Mesge})
end
end
bot.sendText(msg.chat_id,msg.id,t,"md",true)
redis:del(bot_id..":"..msg.chat_id..":mediaAude:ids")
end
end
end
if text == 'تفعيل المسح التلقائي' and BasicConstructor(msg) then   
if redis:get(bot_id..":"..msg.chat_id..":settings:mediaAude") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:set(bot_id..":"..msg.chat_id..":settings:mediaAude",true)  
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل المسح التلقائي' and BasicConstructor(msg) then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:mediaAude") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:mediaAude")  
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل all' and Creator(msg) then   
if redis:get(bot_id..":"..msg.chat_id..":settings:all") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:all")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل all' and Creator(msg) then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:all") then
redis:set(bot_id..":"..msg.chat_id..":settings:all",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if BasicConstructor(msg) then
if text == 'تفعيل الرفع' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:up")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الرفع' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:up") then
redis:set(bot_id..":"..msg.chat_id..":settings:up",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الكتم' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:ktm")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الكتم' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
redis:set(bot_id..":"..msg.chat_id..":settings:ktm",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الحظر' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:bn")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الحظر' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
redis:set(bot_id..":"..msg.chat_id..":settings:bn",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الطرد' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:kik")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الطرد' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
redis:set(bot_id..":"..msg.chat_id..":settings:kik",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
end
--
if Owner(msg) then
if text and text:match("^وضع عدد المسح (.*)$") then
local Teext = text:match("^وضع عدد المسح (.*)$") 
if Teext and Teext:match('%d+') then
t = "*  ⌔︙تم تعيين  ( "..Teext.." ) كعدد للحذف التلقائي*"
redis:set(bot_id..":mediaAude:utdl"..msg.chat_id,Teext)
else
t = "  ⌔︙عذرا يجب كتابه ( وضع عدد المسح + رقم )"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)
end
if text == ("عدد الميديا") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙عدد الميديا هو :  "..redis:scard(bot_id..":"..msg.chat_id..":mediaAude:ids").."*").yu,"md",true)
end
--
if text == 'تفعيل اطردني' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:kickme") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:kickme")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل اطردني' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:kickme") then
redis:set(bot_id..":"..msg.chat_id..":settings:kickme",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل المميزات' then   
if redis:get(bot_id..":"..msg.chat_id..":Features") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":Features")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل المميزات' then  
if not redis:get(bot_id..":"..msg.chat_id..":Features") then
redis:set(bot_id..":"..msg.chat_id..":Features",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الالعاب' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:game") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:game")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الالعاب' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:game") then
redis:set(bot_id..":"..msg.chat_id..":settings:game",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل صورتي' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:phme") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:phme")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل صورتي' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:phme") then
redis:set(bot_id..":"..msg.chat_id..":settings:phme",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل البايو' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:GetBio") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:GetBio")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل البايو' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:GetBio") then
redis:set(bot_id..":"..msg.chat_id..":settings:GetBio",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الرابط' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:link") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:link")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الرابط' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:link") then
redis:set(bot_id..":"..msg.chat_id..":settings:link",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الترحيب' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:Welcome") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:Welcome")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الترحيب' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:Welcome") then
redis:set(bot_id..":"..msg.chat_id..":settings:Welcome",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل التنظيف' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:delmsg") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:delmsg")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل التنظيف' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:delmsg") then
redis:set(bot_id..":"..msg.chat_id..":settings:delmsg",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الايدي' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:id") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:id")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الايدي' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:id") then
redis:set(bot_id..":"..msg.chat_id..":settings:id",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الايدي بالصورة' and BasicConstructor(msg) then     
if redis:get(bot_id..":"..msg.chat_id..":settings:id:ph") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:id:ph")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الايدي بالصورة' and BasicConstructor(msg) then    
if not redis:get(bot_id..":"..msg.chat_id..":settings:id:ph") then
redis:set(bot_id..":"..msg.chat_id..":settings:id:ph",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الردود' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:Reply") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:Reply")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الردود' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:Reply") then
redis:set(bot_id..":"..msg.chat_id..":settings:Reply",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل منو ضافني' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:addme") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:addme")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل منو ضافني' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:addme") then
redis:set(bot_id..":"..msg.chat_id..":settings:addme",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الالعاب الاحترافية' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:gameVip") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:gameVip")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الالعاب الاحترافية' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:gameVip") then
redis:set(bot_id..":"..msg.chat_id..":settings:gameVip",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل اوامر التسلية' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:entertainment") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:entertainment")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل اوامر التسلية' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:entertainment") then
redis:set(bot_id..":"..msg.chat_id..":settings:entertainment",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if text and text:match('^تنزيل الكل (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^تنزيل الكل (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if Get_Rank(UserName,msg.chat_id)== "العضو" then
tt = "لا يمتلك رتبه بالفعل"
else
tt = "تم تنزيله من جميع الرتب بنجاح"
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..":Status:programmer",UserName)
redis:srem(bot_id..":Status:developer",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,UserName).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*  ⌔︙"..tt.."*").yu,"md",true)  
return false
end
if text and text:match('^تنزيل الكل @(%S+)$') then
local UserName = text:match('^تنزيل الكل @(%S+)$') 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if Get_Rank(UserId_Info.id,msg.chat_id)== "العضو" then
tt = "لا يمتلك رتبه بالفعل"
else
tt = "تم تنزيله من جميع الرتب بنجاح"
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..":Status:programmer",UserId_Info.id)
redis:srem(bot_id..":Status:developer",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,UserId_Info.id).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*  ⌔︙"..tt.."*").yu,"md",true)  
return false
end
if text == "تنزيل الكل" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if Get_Rank(Remsg.sender.user_id,msg.chat_id)== "العضو" then
tt = "لا يمتلك رتبه بالفعل"
else
tt = "تم تنزيله من جميع الرتب بنجاح"
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..":Status:programmer",Remsg.sender.user_id)
redis:srem(bot_id..":Status:developer",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,Remsg.sender.user_id).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*  ⌔︙"..tt.."*").yu,"md",true)  
return false
end
if text and text:match('^رفع (.*) (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^رفع (.*) (%d+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الرفع معطل بواسطة المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if redis:sismember(bot_id..srt1.."Status:"..srt,UserName) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*  ⌔︙تم رفعه سابقا*").i,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*  ⌔︙تم رفعه بنجاح*").i,"md",true)  
return false
end
end
if text and text:match('^رفع (.*) @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^رفع (.*) @(%S+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الرفع معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if redis:sismember(bot_id..srt1.."Status:"..srt,UserId_Info.id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*  ⌔︙تم رفعه سابقا*").i,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*  ⌔︙تم رفعه بنجاح*").i,"md",true)  
return false
end
end
if text and text:match("^رفع (.*)$") and tonumber(msg.reply_to_message_id) ~= 0 then
local TextMsg = text:match("^رفع (.*)$")
if msg.content.text then 
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الرفع معطل بواسطة المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if redis:sismember(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*  ⌔︙تم رفعه سابقا*").i,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*  ⌔︙تم رفعه بنجاح*").i,"md",true)  
return false
end
end
if text and text:match('^تنزيل (.*) (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^تنزيل (.*) (%d+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not redis:sismember(bot_id..srt1.."Status:"..srt,UserName) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*  ⌔︙لا يمتلك رتبه بالفعل*").yu,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*  ⌔︙تم تنزيله بنجاح*").i,"md",true)  
return false
end
end
if text and text:match('^تنزيل (.*) @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^تنزيل (.*) @(%S+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not redis:sismember(bot_id..srt1.."Status:"..srt,UserId_Info.id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*  ⌔︙لا يمتلك رتبه بالفعل*").yu,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*  ⌔︙تم تنزيله بنجاح*").i,"md",true)  
return false
end
end
if text and text:match("^تنزيل (.*)$") and tonumber(msg.reply_to_message_id) ~= 0 then
local TextMsg = text:match("^تنزيل (.*)$")
if msg.content.text then 
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not redis:sismember(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*  ⌔︙لا يمتلك رتبه بالفعل*").yu,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*  ⌔︙تم تنزيله بنجاح*").i,"md",true)  
return false
end
end
----------------------------------------------------------------------------------------------------
if Administrator(msg) then
if text == 'الثانويين' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المطورين' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المالكين' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد المالكين*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المنشئين الاساسيين' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المنشئين' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Constructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المدراء' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Owner") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'الادامن' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Administrator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المميزين' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Vips") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
----------------------------------------------------------------------------------------------------
end
if text == 'مسح الثانويين' and devB(msg.sender.user_id) then
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":Status:programmer") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح المطورين' and programmer(msg) then
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":Status:developer") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح المالكين' and developer(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Creator") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح المنشئين الاساسيين' and Creator(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح المنشئين' and BasicConstructor(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Constructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح المدراء' and Constructor(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Owner") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Owner") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح الادامن' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Administrator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح المميزين' and Administrator(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Vips") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Vips") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
----------------------------------------------------------------------------------------------------
if text and not redis:get(bot_id..":"..msg.chat_id..":settings:Reply") then
if text and redis:sismember(bot_id..'List:array'..msg.chat_id,text) then
local list = redis:smembers(bot_id.."Add:Rd:array:Text"..text..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"["..list[math.random(#list)].."]","md",true)  
end  
if not redis:sismember(bot_id..'Spam:Group'..msg.sender.user_id,text) then
local Text = redis:get(bot_id.."Rp:content:Text"..msg.chat_id..":"..text)
local VoiceNote = redis:get(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..text) 
local photo = redis:get(bot_id.."Rp:content:Photo"..msg.chat_id..":"..text)
local document = redis:get(bot_id.."Rp:Manager:File"..msg.chat_id..":"..text)
local audio = redis:get(bot_id.."Rp:content:Audio"..msg.chat_id..":"..text)
local Video = redis:get(bot_id.."Rp:content:Video"..msg.chat_id..":"..text)
local VoiceNotecaption = redis:get(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..text) or ""
local photocaption = redis:get(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..text) or ""
local documentcaption = redis:get(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..text) or ""
local audiocaption = redis:get(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..text) or ""
local Videocaption = redis:get(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..text) or ""
if Text  then
local UserInfo = bot.getUser(msg.sender.user_id)
local countMsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1
local totlmsg = Total_message(countMsg) 
local getst = Get_Rank(msg.sender.user_id,msg.chat_id)
local countedit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0
local Text = Text:gsub('#username',(UserInfo.username or 'لا يوجد')):gsub('#name',UserInfo.first_name):gsub('#id',msg.sender.user_id):gsub('#edit',countedit):gsub('#msgs',countMsg):gsub('#stast',getst)
bot.sendText(msg.chat_id,msg.id,"["..Text.."]","md",true)  
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end
if photo  then
bot.sendPhoto(msg.chat_id, msg.id, photo,photocaption)
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if VoiceNote then
bot.sendVoiceNote(msg.chat_id, msg.id, VoiceNote,"["..VoiceNotecaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end
if document  then
bot.sendDocument(msg.chat_id, msg.id, document,"["..documentcaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if audio  then
bot.sendAudio(msg.chat_id, msg.id, audio,"["..audiocaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end
if Video then
bot.sendVideo(msg.chat_id, msg.id, Video,"["..Videocaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end
end 
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
if msg.content.text then
if msg.content.text.text == "غنيلي" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تعطيل المميزات بواسطة المدراء*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ', url="t.me/xXStrem"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendVoice?chat_id="..msg.chat_id.."&voice=https://t.me/Teamsulta/"..math.random(2,552).."&caption="..URL.escape(" ⌔︙ تم اختيار الاغنية لك").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "فيديو" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تعطيل المميزات بواسطة المدراء*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ', url="t.me/xXStrem"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendVideo?chat_id="..msg.chat_id.."&video=https://t.me/FFF3KK/"..math.random(2,80).."&caption="..URL.escape(" ⌔︙ تم ختيار الفيديو لك .").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "متحركة" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تعطيل المميزات بواسطة المدراء*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ', url="t.me/xXStrem"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendAnimation?chat_id="..msg.chat_id.."&animation=https://t.me/FFF4KK/"..math.random(2,300).."&caption="..URL.escape(" ⌔︙ تم اختيار المتحركة لك").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "فلم" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تعطيل المميزات بواسطة المدراء*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ', url="t.me/xXStrem"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendVideo?chat_id="..msg.chat_id.."&video=https://t.me/RRRRRTQ/"..math.random(2,86).."&caption="..URL.escape(" ⌔︙ تم اختيار الفلم لك").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "رمزية" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تعطيل المميزات بواسطة المدراء*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ', url="t.me/xXStrem"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendPhoto?chat_id="..msg.chat_id.."&photo=https://t.me/FFF6KK/"..math.random(2,135).."&caption="..URL.escape(" ⌔︙ تم اختيار الرمزية لك").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "انمي" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تعطيل المميزات بواسطة المدراء*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ', url="t.me/xXStrem"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendPhoto?chat_id="..msg.chat_id.."&photo=https://t.me/AnimeDavid/"..math.random(2,135).."&caption="..URL.escape(" ⌔︙ تم اختيار انمي لك").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "شعر" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تعطيل المميزات بواسطة المدراء*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ', url="t.me/xXStrem"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendVideo?chat_id="..msg.chat_id.."&video=https://t.me/shaarshahum/"..math.random(2,86).."&caption="..URL.escape(" ⌔︙ تم اختيار الشعر لك").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "راب" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تعطيل المميزات بواسطة المدراء*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ', url="t.me/xXStrem"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendmessage?chat_id="..msg.chat_id.."&message=https://t.me/EKKKK9/"..math.random(2,86).."&caption="..URL.escape(" ⌔︙ تم اختيار راب لك").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end

if data and data.luatele and data.luatele == "updateNewInlineQuery" then
local Text = data.query 
if Text == '' then
local input_message_content = {message_text = " • اهلا بك عزيزي\n • لارسال الهمسه اكتب يوزر البوت + الهمسه + يوزر العضو\n • مثال @H6CBoT هلا @F_T_Y"} 
local resuult = {{
type = 'article',
id = math.random(1,64),
title = 'اضغط هنا لمعرفه كيفيه ارسال الهمسه',
input_message_content = input_message_content,
reply_markup = {
inline_keyboard ={
{{text ="❲ Developer AhMeD .  ❳", url= "https://t.me/F_T_Y"}},
}
},
},
}
https.request("https://api.telegram.org/bot"..Token..'/answerInlineQuery?inline_query_id='..data.id..'&switch_pm_text=اضغط لارسال الهمسه&switch_pm_parameter=start&results='..JSON.encode(resuult))
end
if Text and Text:match("(.*)@(.*)") then
local hm = {string.match(Text,"(.*)@(.*)")}
local user = hm[2]
local hms = hm[1]
UserId_Info = LuaTele.searchPublicChat(user)
local idd = UserId_Info.id
local key = math.random(1,999999)
redis:set(idd..key.."hms",hms)
local us = LuaTele.getUser(idd)
local name = us.first_name
local input_message_content = {message_text = "- الهمسة إلى  ["..name.."](tg://user?id="..idd..")  ", parse_mode = 'Markdown'} 
local resuult = {{
type = 'article',
id = math.random(1,64),
title = 'هذه همسه سريه الى '..name..'',
input_message_content = input_message_content,
reply_markup = {
inline_keyboard ={
{{text ="فتح الهمسه  ", callback_data = idd.."hmsaa"..data.sender_user_id.."/"..key}},
}
},
},
}
https.request("https://api.telegram.org/bot"..Token..'/answerInlineQuery?inline_query_id='..data.id..'&switch_pm_text=اضغط لارسال الهمسه&switch_pm_parameter=start&results='..JSON.encode(resuult))
end
end
if data and data.luatele and data.luatele == "updateNewInlineCallbackQuery" then
var(data)
local Text = LuaTele.base64_decode(data.payload.data)
if Text and Text:match('(.*)hmsaa(.*)/(.*)')  then
local mk = {string.match(Text,"(.*)hmsaa(.*)/(.*)")}
local hms = redis:get(mk[1]..mk[3].."hms")
if tonumber(mk[1]) == tonumber(data.sender_user_id) or tonumber(mk[2]) == tonumber(data.sender_user_id) then
https.request("https://api.telegram.org/bot"..Token.."/answerCallbackQuery?callback_query_id="..data.id.."&text="..URL.escape(hms).."&show_alert=true")
end
if tonumber(mk[1]) ~= tonumber(data.sender_user_id) or tonumber(mk[2]) ~= tonumber(data.sender_user_id) then
https.request("https://api.telegram.org/bot"..Token.."/answerCallbackQuery?callback_query_id="..data.id.."&text="..URL.escape("الهمسه ليست لك").."&show_alert=true")
end
end
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
-- نهايه التفعيل
if text == 'السورس' or text == 'سورس' or text == 'ياسورس' or text == 'يا سورس' then 
local Text = "*𝗐𝖾lc𝗈𝗆𝖾 𝗍𝗈 𝗍𝗁𝖾 𝖲𝗈𝗎𝗋c𝖾 𝖲𝗍𝗋𝖾𝗆\n\n*[ ⌔︙ - 𝖥𝖾𝖾l𝗂𝗇g 🪐 . ](https://t.me/D8BB8)*\n\n*[ ⌔︙ - 𝖲𝗈𝗎𝗋c𝖾 xX𝖲𝗍𝗋𝖾𝗆 . ](http://t.me/xXStrem)*\n\n*[ ⌔︙ - Developer . ](http://t.me/F_T_Y)*\n\n*[ ⌔︙ - Bot AhMeD . ](http://t.me/H6CBoT)*\n*"
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}
},
}
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. msg.chat_id .. "&photo=https://t.me/xXStrem&caption=".. URL.escape(Text).."&photo=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--بداية البنك
----------------------------------------------------
if text == 'بنك' or text == 'البنك' then
bot.sendText(msg.chat_id,msg.id,[[
✠ اوامر البنك

  ⌔︙ انشاء حساب بنكي  › تفتح حساب وتقدر تحول فلوس مع مزايا ثانيه

  ⌔︙ مسح حساب بنكي  › تلغي حسابك البنكي

  ⌔︙ تحويل › تطلب رقم حساب الشخص وتحول له فلوس

  ⌔︙ حسابي  › يطلع لك رقم حسابك عشان تعطيه للشخص اللي بيحول لك

  ⌔︙ فلوسي › يعلمك كم فلوسك

  ⌔︙ راتب › يعطيك راتب كل ١٠ دقائق

  ⌔︙ بخشيش › يعطيك بخشيش كل ١٠ دقايق

  ⌔︙ سرقة › تسرق فلوس اشخاص كل ١٠ دقايق

  ⌔︙ استثمار › تستثمر بالمبلغ اللي تبيه مع نسبة ربح مضمونه من ١٪؜ الى ١٥٪؜

  ⌔︙ حظ › تلعبها بأي مبلغ ياتدبله ياتخسره انت وحظك

  ⌔︙ مضاربه › تضارب بأي مبلغ تبيه والنسبة من ٩٠٪؜ الى -٩٠٪؜ انت وحظك

  ⌔︙ قرض › تاخذ قرض من البنك

  ⌔︙ تسديد القرض › بتسدد القرض اذا عليك 

  ⌔︙ هجوم › تهجم عالخصم مع زيادة نسبة كل هجوم

  ⌔︙ كنز › يعطيك كنز بسعر مختلف انت وحظك

  ⌔︙ مراهنه › تحط مبلغ وتراهن عليه

  ⌔︙ توب الفلوس › يطلع توب اكثر ناس معهم فلوس بكل الكروبات

  ⌔︙ توب الحراميه › يطلع لك اكثر ناس سرقوا

  ⌔︙ زواج  › تكتبه بالرد على رسالة شخص مع المهر ويزوجك

  ⌔︙ زواجي  › يطلع وثيقة زواجك اذا متزوج

  ⌔︙ طلاق › يطلقك اذا متزوج

  ⌔︙ خلع  › يخلع زوجك ويرجع له المهر

  ⌔︙ زواجات › يطلع اغلى ٣٠ زواجات

  ⌔︙ ترتيبي › يطلع ترتيبك باللعبة


]],"md",true)  
return false
end

if text == 'انشاء حساب بنكي' or text == 'انشاء حساب البنكي' or text =='انشاء الحساب بنكي' or text =='انشاء الحساب البنكي' or text == "انشاء حساب" or text == "فتح حساب بنكي" then
cobnum = tonumber(redis:get("bandid"..msg.sender.user_id))
if cobnum == msg.sender.user_id then
return bot.sendText(msg.chat_id,msg.id, "⇜ حسابك محظور من لعبة البنك","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
creditcc = math.random(500000000000,599999999999);
creditvi = math.random(400000000000,499999999999);
creditex = math.random(600000000000,699999999999);
balas = 50
if redis:sismember("booob",msg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id, "⇜ لديك حساب بنكي مسبقاً\n\n⇜ لعرض معلومات حسابك اكتب\n⇠ `حسابي`","md",true)
end
redis:setex(bot_id..msg.chat_id .. ":" .. msg.sender.user_id,60, true)
bot.sendText(msg.chat_id,msg.id,[[
✠┊عليك اختيار نوع البطاقة للحفاظ على فلوسك 

• `بنك الرشيد`
• `بنك الرافدين`
• `بنك الدولي`

- اضغط للنسخ

- اختر اسم البنك اضغط للنسخ بعدها ارسل :
]],"md",true)  
return false
end
if redis:get(bot_id..msg.chat_id .. ":" .. msg.sender.user_id) then
if text == "بنك الرشيد" then
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
local banid = msg.sender.user_id
redis:set("bobna"..msg.sender.user_id,news)
redis:set("boob"..msg.sender.user_id,balas)
redis:set("boobb"..msg.sender.user_id,creditcc)
redis:set("bbobb"..msg.sender.user_id,text)
redis:set("boballname"..creditcc,news)
redis:set("boballbalc"..creditcc,balas)
redis:set("boballcc"..creditcc,creditcc)
redis:set("boballban"..creditcc,text)
redis:set("boballid"..creditcc,banid)
redis:sadd("booob",msg.sender.user_id)
redis:del(bot_id..msg.chat_id .. ":" .. msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id, "\n• وعملنالك لك حساب في بنك فلاش 🏦\n• وشحنالك 50 دينار 💵 هدية\n\n⇜ رقم حسابك › ( `"..creditcc.."` )\n⇜ نوع البطاقة › ( بنك الرشيد 💳 )\n⇜ فلوسك › ( 50 دينار 💵 )  ","md",true)  
end 
if text == "بنك الرافدين" then
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
local banid = msg.sender.user_id
redis:set("bobna"..msg.sender.user_id,news)
redis:set("boob"..msg.sender.user_id,balas)
redis:set("boobb"..msg.sender.user_id,creditvi)
redis:set("bbobb"..msg.sender.user_id,text)
redis:set("boballname"..creditvi,news)
redis:set("boballbalc"..creditvi,balas)
redis:set("boballcc"..creditvi,creditvi)
redis:set("boballban"..creditvi,text)
redis:set("boballid"..creditvi,banid)
redis:sadd("booob",msg.sender.user_id)
redis:del(bot_id..msg.chat_id .. ":" .. msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id, "\n• وعملنالك لك حساب في بنك فلاش 🏦\n• وشحنالك 50 دينار 💵 هدية\n\n⇜ رقم حسابك › ( `"..creditvi.."` )\n⇜ نوع البطاقة › ( بنك الرافدين 💳 )\n⇜ فلوسك › ( 50 دينار 💵 )  ","md",true)   
end 
if text == "بنك الدولي" then
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
local banid = msg.sender.user_id
redis:set("bobna"..msg.sender.user_id,news)
redis:set("boob"..msg.sender.user_id,balas)
redis:set("boobb"..msg.sender.user_id,creditex)
redis:set("bbobb"..msg.sender.user_id,text)
redis:set("boballname"..creditex,news)
redis:set("boballbalc"..creditex,balas)
redis:set("boballcc"..creditex,creditex)
redis:set("boballban"..creditex,text)
redis:set("boballid"..creditex,banid)
redis:sadd("booob",msg.sender.user_id)
redis:del(bot_id..msg.chat_id .. ":" .. msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id, "\n• وعملنالك لك حساب في بنك فلاش 🏦\n• وشحنالك 50 دينار 💵 هدية\n\n⇜ رقم حسابك › ( `"..creditex.."` )\n⇜ نوع البطاقة › ( بنك الدولي💳 )\n⇜ فلوسك › ( 50 دينار 💵 )  ","md",true)   
end 
end
if text == 'مسح حساب بنكي' or text == 'مسح حساب البنكي' or text =='مسح الحساب بنكي' or text =='مسح الحساب البنكي' or text == "مسح حسابي البنكي" or text == "مسح حسابي بنكي" or text == "مسح حسابي" then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("booob",msg.sender.user_id) then
redis:srem("booob", msg.sender.user_id)
redis:del("boob"..msg.sender.user_id)
redis:del("boobb"..msg.sender.user_id)
redis:del("rrfff"..msg.sender.user_id)
redis:srem("rrfffid", msg.sender.user_id)
redis:srem("roogg1", msg.sender.user_id)
redis:srem("roogga1", msg.sender.user_id)
redis:del("roog1"..msg.sender.user_id)
redis:del("rooga1"..msg.sender.user_id)
redis:del("rahr1"..msg.sender.user_id)
redis:del("rahrr1"..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id, "⇜ مسحت حسابك البنكي 🏦","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'تثبيت النتائج' or text == 'تثبيت نتائج' then
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
time = os.date("*t")
month = time.month
day = time.day
local_time = month.."/"..day
local bank_users = redis:smembers("booob")
if #bank_users == 0 then
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يوجد حسابات في البنك","md",true)
end
mony_list = {}
for k,v in pairs(bank_users) do
local mony = redis:get("boob"..v)
table.insert(mony_list, {tonumber(mony) , v})
end
table.sort(mony_list, function(a, b) return a[1] > b[1] end)
num = 1
emoji ={ 
"🥇",
"🥈",
"🥉"
}
for k,v in pairs(mony_list) do
local user_name = bot.getUser(v[2]).first_name or redis:get(v[2].."first_name:") or "لا يوجد اسم"
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = emoji[k]
num = num + 1
redis:set("medal"..v[2],convert_mony)
redis:set("medal2"..v[2],emo)
redis:set("medal3"..v[2],local_time)
redis:sadd("medalid",v[2])
redis:set("medal"..v[2],convert_mony)
redis:set("medal2"..v[2],emo)
redis:set("medal3"..v[2],local_time)
redis:sadd("medalid",v[2])
local user_name = bot.getUser(v[2]).first_name or redis:get(v[2].."first_name:") or "لا يوجد اسم"
local user_tag = '['..user_name..'](tg://user?id='..v[2]..')'
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = emoji[k]
num = num + 1
redis:set("medal"..v[2],convert_mony)
redis:set("medal2"..v[2],emo)
redis:set("medal3"..v[2],local_time)
redis:sadd("medalid",v[2])
if num == 4 then
return end
end
bot.sendText(msg.chat_id,msg.id, "⇜ ثبتت النتائج","md",true)
end
end
if text == 'مسح كل الفلوس' or text == 'مسح كل فلوس' then
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
local bank_users = redis:smembers("booob")
for k,v in pairs(bank_users) do
redis:del("boob"..v)
redis:del("kreednum"..v)
redis:del("kreed"..v)
redis:del("rrfff"..v)
end
local bank_usersr = redis:smembers("rrfffid")
for k,v in pairs(bank_usersr) do
redis:del("boob"..v)
redis:del("rrfff"..v)
end
bot.sendText(msg.chat_id,msg.id, "⇜ مسحت كل فلوس اللعبة 🏦","md",true)
end
end

if text == 'تصفير النتائج' or text == 'مسح لعبه البنك' then
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
local bank_users = redis:smembers("booob")
for k,v in pairs(bank_users) do
redis:del("boob"..v)
redis:del("kreednum"..v)
redis:del("kreed"..v)
redis:del("rrfff"..v)
redis:del("numattack"..v)
end
local bank_usersr = redis:smembers("rrfffid")
for k,v in pairs(bank_usersr) do
redis:del("boob"..v)
redis:del("rrfff"..v)
end
redis:del("rrfffid")
redis:del("booob")
bot.sendText(msg.chat_id,msg.id, "⇜ مسحت لعبه البنك 🏦","md",true)
end
end
if text == 'ميدالياتي' or text == 'ميداليات' then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("medalid",msg.sender.user_id) then
local medaa2 = redis:get("medal2"..msg.sender.user_id)
if medaa2 == "🥇" then
local medaa = redis:get("medal"..msg.sender.user_id)
local medaa2 = redis:get("medal2"..msg.sender.user_id)
local medaa3 = redis:get("medal3"..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id, "ميدالياتك :\n\nالتاريخ : "..medaa3.." \nالفلوس : "..medaa.." 💵\nالمركز : "..medaa2.." كونكر "..medaa2.."\n","md",true)
elseif medaa2 == "🥈" then
local medaa = redis:get("medal"..msg.sender.user_id)
local medaa2 = redis:get("medal2"..msg.sender.user_id)
local medaa3 = redis:get("medal3"..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id, "ميدالياتك :\n\nالتاريخ : "..medaa3.." \nالفلوس : "..medaa.." 💵\nالمركز : "..medaa2.." ايس "..medaa2.."\n","md",true)
else
local medaa = redis:get("medal"..msg.sender.user_id)
local medaa2 = redis:get("medal2"..msg.sender.user_id)
local medaa3 = redis:get("medal3"..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id, "ميدالياتك :\n\nالتاريخ : "..medaa3.." \nالفلوس : "..medaa.." 💵\nالمركز : "..medaa2.." تاج "..medaa2.."\n","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك ميداليات","md",true)
end
end

if text == 'فلوسي' or text == 'فلوس' and tonumber(msg.reply_to_message_id) == 0 then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("booob",msg.sender.user_id) then
ballancee = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(ballancee) < 1 then
return bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك فلوس ارسل الالعاب وابدأ بجمع الفلوس \n","md",true)
end
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك `"..convert_mony.."` دينار 💵","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'فلوسه' or text == 'فلوس' and tonumber(msg.reply_to_message_id) ~= 0 then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ لا يمتلك حسب في البنك*","md",true)  
return false
end
if redis:sismember("booob",Remsg.sender.user_id) then
ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballanceed)
bot.sendText(msg.chat_id,msg.id, "⇜ فلوسه `"..convert_mony.."` دينار 💵","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يمتلك حساب بنكي ","md",true)
end
end

if text == 'حسابي' or text == 'حسابي البنكي' or text == 'رقم حسابي' then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
if redis:sismember("booob",msg.sender.user_id) then
cccc = redis:get("boobb"..msg.sender.user_id)
uuuu = redis:get("bbobb"..msg.sender.user_id)
pppp = redis:get("rrfff"..msg.sender.user_id) or 0
ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id, "⇜ الاسم › "..news.."\n⇜ الحساب › `"..cccc.."`\n⇜ بنك › ( فلاش )\n⇜ نوع › ( "..uuuu.." )\n⇜ الرصيد › ( "..convert_mony.." دينار 💵 )\n⇜ السرقة ( "..pppp.." دينار 💵 )\n","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'مسح حسابه' and tonumber(msg.reply_to_message_id) ~= 0 then
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ لا يمتلك حسب في البنك*","md",true)  
return false
end
local ban = bot.getUser(Remsg.sender.user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
if redis:sismember("booob",Remsg.sender.user_id) then
ccccc = redis:get("boobb"..Remsg.sender.user_id)
uuuuu = redis:get("bbobb"..Remsg.sender.user_id)
ppppp = redis:get("rrfff"..Remsg.sender.user_id) or 0
ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballanceed)
redis:srem("booob", Remsg.sender.user_id)
redis:del("boob"..Remsg.sender.user_id)
redis:del("boobb"..Remsg.sender.user_id)
redis:del("rrfff"..Remsg.sender.user_id)
redis:del("numattack"..Remsg.sender.user_id)
redis:srem("rrfffid", Remsg.sender.user_id)
redis:srem("roogg1", Remsg.sender.user_id)
redis:srem("roogga1", Remsg.sender.user_id)
redis:del("roog1"..Remsg.sender.user_id)
redis:del("rooga1"..Remsg.sender.user_id)
redis:del("rahr1"..Remsg.sender.user_id)
redis:del("rahrr1"..Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id, "⇜ الاسم › "..news.."\n⇜ الحساب › `"..ccccc.."`\n⇜ بنك › ( فلاش )\n⇜ نوع › ( "..uuuuu.." )\n⇜ الرصيد › ( "..convert_mony.." دينار 💵 )\n⇜ السرقة › ( "..ppppp.." دينار 💵 )\n⇜ مسكين مسحت حسابه \n","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يمتلك حساب بنكي اصلاً ","md",true)
end
end
end

if text == 'حسابه' and tonumber(msg.reply_to_message_id) ~= 0 then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ لا يمتلك حسب في البنك*","md",true)  
return false
end
local ban = bot.getUser(Remsg.sender.user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
if redis:sismember("booob",Remsg.sender.user_id) then
ccccc = redis:get("boobb"..Remsg.sender.user_id)
uuuuu = redis:get("bbobb"..Remsg.sender.user_id)
ppppp = redis:get("rrfff"..Remsg.sender.user_id) or 0
ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballanceed)
bot.sendText(msg.chat_id,msg.id, "⇜ الاسم › "..news.."\n⇜ الحساب › `"..ccccc.."`\n⇜ بنك › ( فلاش )\n⇜ نوع › ( "..uuuuu.." )\n⇜ الرصيد › ( "..convert_mony.." دينار 💵 )\n⇜ السرقة › ( "..ppppp.." دينار 💵 )\n","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يمتلك حساب بنكي ","md",true)
end
end

if text and text:match('^مسح حساب (.*)$') or text and text:match('^مسح حسابه (.*)$') then
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
local UserName = text:match('^مسح حساب (.*)$') or text:match('^مسح حسابه (.*)$')
local coniss = coin(UserName)
local ban = bot.getUser(coniss)
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد "
end
if redis:sismember("booob",coniss) then
ccccc = redis:get("boobb"..coniss)
uuuuu = redis:get("bbobb"..coniss)
ppppp = redis:get("rrfff"..coniss) or 0
ballanceed = redis:get("boob"..coniss) or 0
local convert_mony = string.format("%.0f",ballanceed)
redis:srem("booob", coniss)
redis:del("boob"..coniss)
redis:del("boobb"..coniss)
redis:del("rrfff"..coniss)
redis:srem("roogg1", coniss)
redis:srem("roogga1", coniss)
redis:del("roog1"..coniss)
redis:del("rooga1"..coniss)
redis:del("rahr1"..coniss)
redis:del("rahrr1"..coniss)
redis:del("numattack"..coniss)
redis:srem("rrfffid", coniss)
bot.sendText(msg.chat_id,msg.id, "⇜ الاسم › "..news.."\n⇜ الحساب › `"..ccccc.."`\n⇜ بنك › ( فلاش )\n⇜ نوع › ( "..uuuuu.." )\n⇜ الرصيد › ( "..convert_mony.." دينار 💵 )\n⇜ السرقة › ( "..ppppp.." دينار 💵 )\n⇜ مسكين مسحت حسابه \n","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يمتلك حساب بنكي اصلاً ","md",true)
end
end
end

if text and text:match('^حساب (.*)$') or text and text:match('^حسابه (.*)$') then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local UserName = text:match('^حساب (.*)$') or text:match('^حسابه (.*)$')
local coniss = coin(UserName)
if redis:get("boballcc"..coniss) then
local yty = redis:get("boballname"..coniss)
local bobpkh = redis:get("boballid"..coniss)
ballancee = redis:get("boob"..bobpkh) or 0
local convert_mony = string.format("%.0f",ballancee)
local dfhb = redis:get("boballbalc"..coniss)

local fsvhh = redis:get("boballban"..coniss)
bot.sendText(msg.chat_id,msg.id, "⇜ الاسم › "..yty.."\n⇜ الحساب › `"..coniss.."`\n⇜ بنك › ( فلاش )\n⇜ نوع › ( "..fsvhh.." )\n⇜ الرصيد › ( "..convert_mony.." دينار 💵 )\n","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يوجده حساب بنكي كذا","md",true)
end
end

if text == 'مضاربه' then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
if redis:ttl("iiooooo" .. msg.sender.user_id) >= 60 then
local time = redis:ttl("iiooooo" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يمكنك تضارب حاليا\n⇜ تعال بعد ( "..time.." دقيقة )","md",true)
end
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`مضاربه` المبلغ","md",true)
end

if text and text:match('^مضاربه (.*)$') or text and text:match('^مضاربة (.*)$') then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local UserName = text:match('^مضاربه (.*)$') or text:match('^مضاربة (.*)$')
local coniss = coin(UserName)
if redis:sismember("booob",msg.sender.user_id) then
if redis:ttl("iiooooo" .. msg.sender.user_id) >= 60 then
  local time = redis:ttl("iiooooo" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يمكنك تضارب حاليا\n⇜ تعال بعد ( "..time.." دقيقة )","md",true)
end
ballancee = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(coniss) < 99 then
return bot.sendText(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح هو 100 دينار 💵\n","md",true)
end
if tonumber(ballancee) < tonumber(coniss) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
local modarba = {"1", "2", "3", "4️",}
local Descriptioontt = modarba[math.random(#modarba)]
local modarbaa = math.random(1,90);
if Descriptioontt == "1" or Descriptioontt == "3" then
ballanceekku = coniss / 100 * modarbaa
ballanceekkku = ballancee - ballanceekku
local convert_mony = string.format("%.0f",ballanceekku)
local convert_mony1 = string.format("%.0f",ballanceekkku)
redis:set("boob"..msg.sender.user_id , math.floor(ballanceekkku))
redis:setex("iiooooo" .. msg.sender.user_id,900, true)
bot.sendText(msg.chat_id,msg.id, "⇜ مضاربة فاشلة 📉\n⇜ نسبة الخسارة › "..modarbaa.."%\n⇜ المبلغ الذي خسرته › ( "..convert_mony.." دينار 💵 )\n⇜ فلوسك صارت › ( "..convert_mony1.." دينار 💵 )\n","md",true)
elseif Descriptioontt == "2" or Descriptioontt == "4" then
ballanceekku = coniss / 100 * modarbaa
ballanceekkku = ballancee + ballanceekku
local convert_mony = string.format("%.0f",ballanceekku)
local convert_mony1 = string.format("%.0f",ballanceekkku)
redis:set("boob"..msg.sender.user_id , math.floor(ballanceekkku))
redis:setex("iiooooo" .. msg.sender.user_id,900, true)
bot.sendText(msg.chat_id,msg.id, "⇜ مضاربة ناجحة 📈\n⇜ نسبة الربح › "..modarbaa.."%\n⇜ المبلغ الذي ربحته › ( "..convert_mony.." دينار 💵 )\n⇜ فلوسك صارت › ( "..convert_mony1.." دينار 💵 )\n","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'استثمار' then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
if redis:ttl("iioooo" .. msg.sender.user_id) >= 60 then
local time = redis:ttl("iioooo" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يمكنك تستثمر حاليا\n⇜ تعال بعد ( "..time.." دقيقة )","md",true)
end
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`استثمار` المبلغ","md",true)
end

if text and text:match('^استثمار (.*)$') then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local UserName = text:match('^استثمار (.*)$')
local coniss = coin(UserName)
if redis:sismember("booob",msg.sender.user_id) then
if redis:ttl("iioooo" .. msg.sender.user_id) >= 60 then
local time = redis:ttl("iioooo" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يمكنك تستثمر حاليا\n⇜ تعال بعد ( "..time.." دقيقة )","md",true)
end
ballancee = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(coniss) < 99 then
return bot.sendText(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح هو 100 دينار 💵\n","md",true)
end
if tonumber(ballancee) < tonumber(coniss) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
if tonumber(ballancee) < 100000 then
local hadddd = math.random(10,15);
ballanceekk = coniss / 100 * hadddd
ballanceekkk = ballancee + ballanceekk
local convert_mony = string.format("%.0f",ballanceekk)
local convert_mony1 = string.format("%.0f",ballanceekkk)
redis:set("boob"..msg.sender.user_id , math.floor(ballanceekkk))
redis:setex("iioooo" .. msg.sender.user_id,1200, true)
bot.sendText(msg.chat_id,msg.id, "⇜ استثمار ناجح ??\n⇜ نسبة الربح › "..hadddd.."%\n⇜ مبلغ الربح › ( "..convert_mony.." دينار 💵 )\n⇜ فلوسك صارت › ( "..convert_mony1.." دينار 💵 )\n","md",true)
else
local hadddd = math.random(1,9);
ballanceekk = coniss / 100 * hadddd
ballanceekkk = ballancee + ballanceekk
local convert_mony = string.format("%.0f",ballanceekk)
local convert_mony1 = string.format("%.0f",ballanceekkk)
redis:set("boob"..msg.sender.user_id , math.floor(ballanceekkk))
redis:setex("iioooo" .. msg.sender.user_id,1200, true)
bot.sendText(msg.chat_id,msg.id, "⇜ استثمار ناجح 💰\n⇜ نسبة الربح › "..hadddd.."%\n⇜ مبلغ الربح › ( "..convert_mony.." دينار 💵 )\n⇜ فلوسك صارت › ( "..convert_mony1.." دينار 💵 )\n","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'حظ' then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
if redis:ttl("iiooo" .. msg.sender.user_id) >= 60 then
local time = redis:ttl("iiooo" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يمكنك تلعب لعبة الحظ حاليا\n⇜ تعال بعد ( "..time.." دقيقة )","md",true)
end
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`حظ` المبلغ","md",true)
end

if text and text:match('^حظ (.*)$') then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local UserName = text:match('^حظ (.*)$')
local coniss = coin(UserName)
if redis:sismember("booob",msg.sender.user_id) then
if redis:ttl("iiooo" .. msg.sender.user_id) >= 60 then
local time = redis:ttl("iiooo" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يمكنك تلعب لعبة الحظ حاليا\n⇜ تعال بعد ( "..time.." دقيقة )","md",true)
end
ballancee = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(ballancee) < tonumber(coniss) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
local daddd = {"1", "2",}
local haddd = daddd[math.random(#daddd)]
if haddd == "1" then
local ballanceek = ballancee + coniss
local convert_mony = string.format("%.0f",ballancee)
local convert_mony1 = string.format("%.0f",ballanceek)
redis:set("boob"..msg.sender.user_id , math.floor(ballanceek))
redis:setex("iiooo" .. msg.sender.user_id,900, true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك فزت بالحظ 🎉\n⇜ فلوسك قبل › ( "..convert_mony.." دينار 💵 )\n⇜ فلوسك حاليا › ( "..convert_mony1.." دينار 💵 )\n","md",true)
else
local ballanceekk = ballancee - coniss
local convert_mony = string.format("%.0f",ballancee)
local convert_mony1 = string.format("%.0f",ballanceekk)
redis:set("boob"..msg.sender.user_id , math.floor(ballanceekk))
redis:setex("iiooo" .. msg.sender.user_id,900, true)
bot.sendText(msg.chat_id,msg.id, "⇜ للاسف خسرت بالحظ 😬\n⇜ فلوسك قبل › ( "..convert_mony.." دينار 💵 )\n⇜ فلوسك حاليا › ( "..convert_mony1.." دينار 💵 )\n","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'تحويل' then
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`تحويل` المبلغ","md",true)
end

if text and text:match('^تحويل (.*)$') then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` لكي تستطيع التحويل","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local UserName = text:match('^تحويل (.*)$')
local coniss = coin(UserName)
if not redis:sismember("booob",msg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ","md",true)
end
if tonumber(coniss) < 100 then
return bot.sendText(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح به هو 100 دينار \n","md",true)
end
ballancee = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(ballancee) < 100 then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end

if tonumber(coniss) > tonumber(ballancee) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي\n","md",true)
end

redis:set("transn"..msg.sender.user_id,coniss)
redis:setex("trans" .. msg.chat_id .. ":" .. msg.sender.user_id,60, true)
bot.sendText(msg.chat_id,msg.id,[[
⇜ ارسل حاليا رقم الحساب البنكي الي تبي تحول له

– معاك دقيقة وحدة والغي طلب التحويل .

]],"md",true)  
return false
end
if redis:get("trans" .. msg.chat_id .. ":" .. msg.sender.user_id) then
cccc = redis:get("boobb"..msg.sender.user_id)
uuuu = redis:get("bbobb"..msg.sender.user_id)
if text ~= text:match('^(%d+)$') then
redis:del("trans" .. msg.chat_id .. ":" .. msg.sender.user_id) 
redis:del("transn" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ ارسل رقم حساب بنكي ","md",true)
end
if text == cccc then
redis:del("trans" .. msg.chat_id .. ":" .. msg.sender.user_id) 
redis:del("transn" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يمكنك تحول لنفسك ","md",true)
end
if redis:get("boballcc"..text) then
local UserNamey = redis:get("transn"..msg.sender.user_id)
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد "
end
local fsvhhh = redis:get("boballid"..text)
local bann = bot.getUser(fsvhhh)
if bann.first_name then
newss = "["..bann.first_name.."](tg://user?id="..bann.id..")"
else
newss = " لا يوجد "
end
local fsvhh = redis:get("boballban"..text)
UserNameyr = UserNamey / 10
UserNameyy = UserNamey - UserNameyr
local convert_mony = string.format("%.0f",UserNameyy)
ballancee = redis:get("boob"..msg.sender.user_id) or 0
deccde = ballancee - UserNamey
redis:set("boob"..msg.sender.user_id , math.floor(deccde))
-----------
decdecb = redis:get("boob"..fsvhhh) or 0
deccde2 = decdecb + UserNameyy
redis:set("boob"..fsvhhh , math.floor(deccde2))

bot.sendText(msg.chat_id,msg.id, "حوالة صادرة من بنك فلاش\n\nالمرسل : "..news.."\nالحساب رقم : `"..cccc.."`\nنوع البطاقة : "..uuuu.."\nالمستلم : "..newss.."\nالحساب رقم : `"..text.."`\nنوع البطاقة : "..fsvhh.."\nخصمت 10% رسوم تحويل\nالمبلغ : "..convert_mony.." دينار 💵","md",true)
bot.sendText(fsvhhh,0, "حوالة واردة من بنك فلاش\n\nالمرسل : "..news.."\nالحساب رقم : `"..cccc.."`\nنوع البطاقة : "..uuuu.."\nالمبلغ : "..convert_mony.." دينار 💵","md",true)
redis:del("trans" .. msg.chat_id .. ":" .. msg.sender.user_id) 
redis:del("transn" .. msg.sender.user_id)
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يوجده حساب بنكي كذا","md",true)
redis:del("trans" .. msg.chat_id .. ":" .. msg.sender.user_id) 
redis:del("transn" .. msg.sender.user_id)
end
end


if text == "ترتيبي" then
if redis:sismember("booob",msg.sender.user_id) then
local bank_users = redis:smembers("booob")
my_num_in_bank = {}
for k,v in pairs(bank_users) do
local mony = redis:get("boob"..v)
table.insert(my_num_in_bank, {math.floor(tonumber(mony)) , v})
end
table.sort(my_num_in_bank, function(a, b) return a[1] > b[1] end)
for k,v in pairs(my_num_in_bank) do
if tonumber(v[2]) == tonumber(msg.sender.user_id) then
local mony = v[1]
return bot.sendText(msg.chat_id,msg.id,"⇜ ترتيبك ( "..k.." )","md",true)
end
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == "توب فلوس" or text == "توب الفلوس" then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local bank_users = redis:smembers("booob")
if #bank_users == 0 then
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يوجد حسابات في البنك","md",true)
end
top_mony = "توب اغنى 30 شخص :\n\n"
mony_list = {}
for k,v in pairs(bank_users) do
local mony = redis:get("boob"..v)
table.insert(mony_list, {tonumber(mony) , v})
end
table.sort(mony_list, function(a, b) return a[1] > b[1] end)
num = 1
emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)",
"21)",
"22)",
"23)",
"24)",
"25)",
"26)",
"27)",
"28)",
"29)",
"30)"
}
for k,v in pairs(mony_list) do
if num <= 30 then
local user_name = bot.getUser(v[2]).first_name or redis:get(v[2].."first_name:") or "لا يوجد اسم"
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = emoji[k]
num = num + 1
top_mony = top_mony..emo.." "..convert_mony.." 💵 ꗝ "..user_name.."\n"
end
end
top_monyy = top_mony.."\n\nاي اسم مخالف او غش باللعب راح يتصفر وينحظر اللاعب"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '𝖲𝗈𝗎𝗋c𝖾 xX𝖲𝗍𝗋𝖾𝗆', url="t.me/xXStrem"},
},
}
}
return bot.sendText(msg.chat_id,msg.id,top_monyy,"html",false, false, false, false, reply_markup)
end

if text == "توب الحراميه" or text == "توب الحرامية" or text == "توب حراميه" or text == "توب السرقة" or text == "توب زرف" then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local ty_users = redis:smembers("rrfffid")
if #ty_users == 0 then
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يوجد احد","md",true)
end
ty_anubis = "توب 20 شخص سرقوا فلوس :\n\n"
ty_list = {}
for k,v in pairs(ty_users) do
local mony = redis:get("rrfff"..v)
table.insert(ty_list, {tonumber(mony) , v})
end
table.sort(ty_list, function(a, b) return a[1] > b[1] end)
num_ty = 1
emojii ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)"
}
for k,v in pairs(ty_list) do
if num_ty <= 20 then
local user_name = bot.getUser(v[2]).first_name or redis:get(v[2].."first_name:") or "لا يوجد اسم"
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emoo = emojii[k]
num_ty = num_ty + 1
ty_anubis = ty_anubis..emoo.." "..convert_mony.." 💵 ꗝ "..user_name.."\n"
end
end
ty_anubiss = ty_anubis.."\n\nاي اسم مخالف او غش باللعب راح يتصفر وينحظر اللاعب"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '𝖲𝗈𝗎𝗋c𝖾 xX𝖲𝗍𝗋𝖾𝗆', url="t.me/xXStrem"},
},
}
}
return bot.sendText(msg.chat_id,msg.id,ty_anubiss,"html",false, false, false, false, reply_markup)
end

if text == 'تسديد قرضه' and tonumber(msg.reply_to_message_id) ~= 0 then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ لا يمتلك حسب في البنك*","md",true)  
return false
end
if redis:sismember("booob",Remsg.sender.user_id) then
if redis:get("kreed"..msg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id, "⇜ سدد قرضك اول شي بعدين اعمل راعي النشامى ","md",true)
end
if not redis:get("kreed"..Remsg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id, "⇜ ماعليه قرض","md",true)
else
local ban = bot.getUser(Remsg.sender.user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..Remsg.sender.user_id))
if tonumber(ballanceed) < tonumber(krses) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
nshme = ballanceed - krses
redis:set("boob"..msg.sender.user_id,math.floor(nshme))
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
redis:del("kreed"..Remsg.sender.user_id)
redis:del("kreednum"..Remsg.sender.user_id)
local convert_mony = string.format("%.0f",ballanceed)
bot.sendText(msg.chat_id,msg.id, "⇜ اشعار تسديد قرض عن "..news.."\n\nالقرض : "..krses.." دينار 💵\nتم اقتطاع المبلغ من فلوسك\nفلوسك حاليا : "..convert_mony.." دينار 💵 ","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يمتلك حساب بنكي ","md",true)
end
end

if text == 'تسديد قرض' or text == 'تسديد القرض' or text == 'تسديد قرضي' and tonumber(msg.reply_to_message_id) == 0 then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("booob",msg.sender.user_id) then
if not redis:get("kreed"..msg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id, "⇜ ماعليك قرض ","md",true)
end
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if tonumber(ballanceed) < tonumber(krses) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
tsded = ballanceed - krses
redis:set("boob"..msg.sender.user_id,math.floor(tsded))
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
redis:del("kreed"..msg.sender.user_id)
redis:del("kreednum"..msg.sender.user_id)
local convert_mony = string.format("%.0f",ballanceed)
bot.sendText(msg.chat_id,msg.id, "⇜ اشعار تسديد قرض\n\nالقرض : "..krses.." دينار 💵\nتم اقتطاع المبلغ من فلوسك\nفلوسك حاليا : "..convert_mony.." دينار 💵","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'القرض' or text == 'قرض' then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id, "⇜ سحبت قرض قبل بقيمة "..krses.." دينار 💵","md",true)
end
if redis:sismember("booob",msg.sender.user_id) then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(ballanceed) < 100000 then
kredd = tonumber(ballanceed) + 900000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,900000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 900000 دينار 💵","md",true)
elseif tonumber(ballanceed) < 200000 then
kredd = tonumber(ballanceed) + 800000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,800000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 800000 دينار 💵","md",true)
elseif tonumber(ballanceed) < 300000 then
kredd = tonumber(ballanceed) + 700000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,700000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 700000 دينار 💵","md",true)
elseif tonumber(ballanceed) < 400000 then
kredd = tonumber(ballanceed) + 600000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,600000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 600000 دينار 💵","md",true)
elseif tonumber(ballanceed) < 500000 then
kredd = tonumber(ballanceed) + 500000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,500000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 500000 دينار 💵","md",true)
elseif tonumber(ballanceed) < 600000 then
kredd = tonumber(ballanceed) + 400000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,400000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 400000 دينار 💵","md",true)
elseif tonumber(ballanceed) < 700000 then
kredd = tonumber(ballanceed) + 300000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,300000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 300000 دينار 💵","md",true)
elseif tonumber(ballanceed) < 800000 then
kredd = tonumber(ballanceed) + 200000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,200000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 200000 دينار 💵","md",true)
elseif tonumber(ballanceed) < 900000 then
kredd = tonumber(ballanceed) + 100000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,100000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 100000 دينار 💵","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك فوق المليون مايطلعلك قرض","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'بخشيش' or text == 'بقشيش' then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("booob",msg.sender.user_id) then
if redis:ttl("iioo" .. msg.sender.user_id) >=1 then
local hours = redis:ttl("iioo" .. msg.sender.user_id) / 60
return bot.sendText(msg.chat_id,msg.id,"⇜ من شوي اخذت بخشيش انتظر "..math.floor(hours).." دقيقة","md",true)
end

local jjjo = math.random(200,1000);
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
bakigcj = ballanceed + jjjo
redis:set("boob"..msg.sender.user_id , bakigcj)
bot.sendText(msg.chat_id,msg.id,"⇜ دلعتك اعطيتك بخشيش "..jjjo.." دينار 💵","md",true)
redis:setex("iioo" .. msg.sender.user_id,600, true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'زرف' and tonumber(msg.reply_to_message_id) == 0 then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`زرف` بالرد","md",true)
end

if text == 'زرف' or text == 'سرقة' or text == 'قطه' and tonumber(msg.reply_to_message_id) ~= 0 then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("booob",msg.sender.user_id) then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ لا يمتلك حسب في البنك*","md",true)  
return false
end
if Remsg.sender.user_id == msg.sender.user_id then
bot.sendText(msg.chat_id,msg.id,"\n*⇜انت غبي؟ *","md",true)  
return false
end
if redis:ttl("polic" .. msg.sender.user_id) >= 280 then
return bot.sendText(msg.chat_id,msg.id,"⇜ انت بالسجن 🏤 انتظر ( 5 دقائق )","md",true)
elseif redis:ttl("polic" .. msg.sender.user_id) >= 240 then
return bot.sendText(msg.chat_id,msg.id,"⇜ انت بالسجن 🏤 انتظر ( 4 دقائق )","md",true)
elseif redis:ttl("polic" .. msg.sender.user_id) >= 180 then
return bot.sendText(msg.chat_id,msg.id,"⇜ انت بالسجن 🏤 انتظر ( 3 دقائق )","md",true)
elseif redis:ttl("polic" .. msg.sender.user_id) >= 120 then
return bot.sendText(msg.chat_id,msg.id,"⇜ انت بالسجن 🏤 انتظر ( 2 دقيقة )","md",true)
elseif redis:ttl("polic" .. msg.sender.user_id) >= 60 then
return bot.sendText(msg.chat_id,msg.id,"⇜ انت بالسجن 🏤 انتظر ( 1 دقيقة )","md",true)
end
if redis:ttl("hrame" .. Remsg.sender.user_id) >= 60 then
local time = redis:ttl("hrame" .. Remsg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ الشخص مسروق من شويه\n⇜ يمكنك تسرقة بعد ( "..time.." ثانية)","md",true)
end
if redis:sismember("booob",Remsg.sender.user_id) then
ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
if tonumber(ballanceed) < 199 then
return bot.sendText(msg.chat_id,msg.id, "⇜ لا يمكنك تسرقة فلوسه اقل من 200 دينار 💵","md",true)
end
local hrame = math.floor(math.random() * 200) + 1;
local hramee = math.floor(math.random() * 5) + 1;
if hramee == 1 or hramee == 2 or hramee == 3 or hramee == 4 then
local ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
local ballancope = redis:get("boob"..msg.sender.user_id) or 0
zrfne = ballanceed - hrame
zrfnee = ballancope + hrame
redis:set("boob"..msg.sender.user_id , math.floor(zrfnee))
redis:set("boob"..Remsg.sender.user_id , math.floor(zrfne))
redis:setex("hrame" .. Remsg.sender.user_id,900, true)
local zoropeo = redis:get("rrfff"..msg.sender.user_id) or 0
zoroprod = zoropeo + hrame
redis:set("rrfff"..msg.sender.user_id,zoroprod)
redis:sadd("rrfffid",msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id, "⇜ خذ يالحرامي سرقته "..hrame.." دينار 💵\n","md",true)
else
redis:setex("polic" .. msg.sender.user_id,300, true)
bot.sendText(msg.chat_id,msg.id, "⇜ مسكتك الشرطة وانت تسرق 🚔\n","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يمتلك حساب بنكي ","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'راتب' or text == 'راتبي' then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("booob",msg.sender.user_id) then
if redis:ttl("iiioo" .. msg.sender.user_id) >= 60 then
local time = redis:ttl("iiioo" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ راتبك بينزل بعد ( "..time.." ثانية )","md",true)
end

local Textinggt = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
neews = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
neews = " لا يوجد "
end
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
if Descriptioont == "1" then
local ratpep = ballancee + 3000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3000 دينار 💵\nوظيفتك : كابتن كريم 🚙\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "2" then
local ratpep = ballancee + 3500
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3500 دينار 💵\nوظيفتك : شرطي 👮🏻‍♂️\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "3" then
local ratpep = ballancee + 3500
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3500 دينار 💵\nوظيفتك : بياع حبوب 🍻\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "4" then
local ratpep = ballancee + 3000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3000 دينار 💵\nوظيفتك : سواق تاكسي 🚕\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "5" then
local ratpep = ballancee + 5000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 5000 دينار 💵\nوظيفتك : قاضي 👨\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "6" then
local ratpep = ballancee + 2500
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2500 دينار 💵\nوظيفتك : نوم 🛌\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "7" then
local ratpep = ballancee + 2700
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2700 دينار 💵\nوظيفتك : مغني 🎤\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "8" then
local ratpep = ballancee + 2900
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2900 دينار 💵\nوظيفتك : كوفيره 💆\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "9" then
local ratpep = ballancee + 2500
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2500 دينار 💵\nوظيفتك : ربة منزل 🤷\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "10" then
local ratpep = ballancee + 2900
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2900 دينار 💵\nوظيفتك : مربيه اطفال 💁\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "11" then
local ratpep = ballancee + 3700
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3700 دينار 💵\nوظيفتك : كهربائي 💡\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "12" then
local ratpep = ballancee + 3600
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3600 دينار 💵\nوظيفتك : نجار ⛏\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "13" then
local ratpep = ballancee + 2400
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2400 دينار 💵\nوظيفتك : متذوق طعام 🍕\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "14" then
local ratpep = ballancee + 3000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3000 دينار 💵\nوظيفتك : فلاح 👨\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "15" then
local ratpep = ballancee + 5000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 5000 دينار 💵\nوظيفتك : كاشير بنده 🙋\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "16" then
local ratpep = ballancee + 6000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 6000 دينار 💵\nوظيفتك : ممرض 👨\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "17" then
local ratpep = ballancee + 3100
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3100 دينار 💵\nوظيفتك : مهرج 🤹\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "18" then
local ratpep = ballancee + 3300
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3300 دينار 💵\nوظيفتك : عامل توصيل 🚴\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "19" then
local ratpep = ballancee + 4800
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 4800 دينار 💵\nوظيفتك : عسكري 👮\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "20" then
local ratpep = ballancee + 6000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 6000 دينار 💵\nوظيفتك : مهندس 👨\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "21" then
local ratpep = ballancee + 8000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 8000 دينار 💵\nوظيفتك : وزير 👨\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "22" then
local ratpep = ballancee + 5500
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 5500 دينار 💵\nوظيفتك : محامي ⚖️\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "23" then
local ratpep = ballancee + 5500
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 5500 دينار 💵\nوظيفتك : تاجر 💵\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "24" then
local ratpep = ballancee + 7000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 7000 دينار 💵\nوظيفتك : دكتور 👨\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "25" then
local ratpep = ballancee + 2600
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2600 دينار 💵\nوظيفتك : حفار قبور ⚓\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "26" then
local ratpep = ballancee + 3000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3000 دينار 💵\nوظيفتك : حلاق ✂\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "27" then
local ratpep = ballancee + 5000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 5000 دينار 💵\nوظيفتك : إمام مسجد 📿\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "28" then
local ratpep = ballancee + 3000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3000 دينار 💵\nوظيفتك : صياد 🎣\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "29" then
local ratpep = ballancee + 2300
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2300 دينار 💵\nوظيفتك : خياط 🧵\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "30" then
local ratpep = ballancee + 7100
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 7100 دينار 💵\nوظيفتك : طيار 🛩\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "31" then
local ratpep = ballancee + 5300
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 5300 دينار 💵\nوظيفتك : مودل 🕴\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "32" then
local ratpep = ballancee + 10000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 10000 دينار 💵\nوظيفتك : ملك 👑\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "33" then
local ratpep = ballancee + 2700
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2700 دينار 💵\nوظيفتك : سباك 🔧\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "34" then
local ratpep = ballancee + 3900
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3900 دينار 💵\nوظيفتك : موزع 🗺\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "35" then
local ratpep = ballancee + 4100
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 4100 دينار 💵\nوظيفتك : سكيورتي 👮\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "36" then
local ratpep = ballancee + 3500
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3500 دينار 💵\nوظيفتك : معلم شاورما 🌯\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار ??","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "37" then
local ratpep = ballancee + 6700
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 6700 دينار 💵\nوظيفتك : دكتور ولاده 👨\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "38" then
local ratpep = ballancee + 6600
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 6600 دينار 💵\nوظيفتك : مذيع 🗣\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "39" then
local ratpep = ballancee + 3400
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3400 دينار 💵\nوظيفتك : عامل مساج 💆\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "40" then
local ratpep = ballancee + 6300
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 6300 دينار 💵\nوظيفتك : ممثل 🤵\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "41" then
local ratpep = ballancee + 3000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3000 دينار 💵\nوظيفتك : جزار 🥩\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "42" then
local ratpep = ballancee + 7000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 7000 دينار 💵\nوظيفتك : مدير بنك 💳\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "43" then
local ratpep = ballancee + 6000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 6000 دينار 💵\nوظيفتك : مبرمج 👨\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "44" then
local ratpep = ballancee + 5000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 5000 دينار 💵\nوظيفتك : رقاصه 💃\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "45" then
local ratpep = ballancee + 4900
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 4900 دينار 💵\nوظيفتك : 👩🏼‍💻 صحفي\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "46" then
local ratpep = ballancee + 5300
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 5300 دينار 💵\nوظيفتك : 🥷 حرامي\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "47" then
local ratpep = ballancee + 6000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 6000 دينار 💵\nوظيفتك : 🔮 ساحر\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "48" then
local ratpep = ballancee + 6500
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 6500 دينار 💵\nوظيفتك : ⚽ لاعب️\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "49" then
local ratpep = ballancee + 4000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 4000 دينار 💵\nوظيفتك : 🖼 مصور\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "50" then
local ratpep = ballancee + 3000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3000 دينار 💵\nوظيفتك : ☎️ عامل مقسم\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "51" then
local ratpep = ballancee + 3200
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3200 دينار 💵\nوظيفتك : 📖 كاتب\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "52" then
local ratpep = ballancee + 4000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 4000 دينار 💵\nوظيفتك : 🧪 مخبري\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'هجوم' then
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`هجوم` المبلغ ( بالرد )","md",true)
end
if text and text:match("^هجوم (%d+)$") and msg.reply_to_message_id == 0 then
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`هجوم` المبلغ ( بالرد )","md",true)
end

if text and text:match('^هجوم (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then
local UserName = text:match('^هجوم (.*)$')
local coniss = coin(UserName)
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("booob",msg.sender.user_id) then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ لا يمتلك حسب في البنك*","md",true)  
return false
end
if Remsg.sender.user_id == msg.sender.user_id then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ تهاجم نفسك 🤡*","md",true)  
return false
end
if redis:ttl("attack" .. msg.sender.user_id) >= 60 then
  local time = redis:ttl("attack" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ خسرت بأخر معركة انتظر ( "..time.." دقيقة )","md",true)
end
if redis:ttl("defen" .. Remsg.sender.user_id) >= 60 then
local time = redis:ttl("defen" .. Remsg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ الخصم خسر بأخر معركة\n⇜ يمكنك تهاجمه بعد ( "..time.." دقيقة )","md",true)
end
if redis:sismember("booob",Remsg.sender.user_id) then
ballancope = redis:get("boob"..msg.sender.user_id) or 0
ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
if tonumber(ballancope) < 100000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ لا يمكنك تهجم فلوسك اقل من 100000 دينار 💵","md",true)
end
if tonumber(ballanceed) < 100000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ لا يمكنك تهجم عليه فلوسه اقل من 100000 دينار 💵","md",true)
end
if tonumber(coniss) < 9999 then
return bot.sendText(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح هو 10000 دينار 💵\n","md",true)
end
if tonumber(ballancope) < tonumber(coniss) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
if tonumber(ballanceed) < tonumber(coniss) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسه لا تكفي \n","md",true)
end
local Textinggt = {"1", "2", "3", "4", "5", "6", "7", "8",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
neews = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
neews = " لا يوجد "
end
local bann = bot.getUser(Remsg.sender.user_id)
if bann.first_name then
neewss = "["..bann.first_name.."](tg://user?id="..bann.id..")"
else
neewss = " لا يوجد "
end
if Descriptioont == "1" or Descriptioont == "3" then
local ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
local ballancope = redis:get("boob"..msg.sender.user_id) or 0
zrfne = ballancope - coniss
zrfnee = ballanceed + coniss
redis:set("boob"..msg.sender.user_id , math.floor(zrfne))
redis:set("boob"..Remsg.sender.user_id , math.floor(zrfnee))
redis:setex("attack" .. msg.sender.user_id,600, true)
local convert_mony = string.format("%.0f",coniss)
bot.sendText(msg.chat_id,msg.id, "⇜ لقد خسرت في المعركة "..neews.." 🛡\nالفائز : "..neewss.."\nالخاسر : "..neews.."\nالجائزة : "..convert_mony.." دينار 💵\n","md",true)
elseif Descriptioont == "2" or Descriptioont == "4" or Descriptioont == "5" or  Descriptioont == "6" or Descriptioont == "8" then
local ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
local ballancope = redis:get("boob"..msg.sender.user_id) or 0
begaatt = redis:get("numattack"..msg.sender.user_id) or 1000
numattackk = tonumber(begaatt) - 1
if numattackk == 0 then
numattackk = 1
end
attack = coniss / numattackk
zrfne = ballancope + math.floor(attack)
zrfnee = ballanceed - math.floor(attack)
redis:set("boob"..msg.sender.user_id , math.floor(zrfne))
redis:set("boob"..Remsg.sender.user_id , math.floor(zrfnee))
redis:setex("defen" .. Remsg.sender.user_id,1800, true)
redis:set("numattack"..msg.sender.user_id , math.floor(numattackk))
local convert_mony = string.format("%.0f",math.floor(attack))
bot.sendText(msg.chat_id,msg.id, "⇜ لقد فزت في المعركة\nودمرت قلعة "..neewss.." 🏰\nالفائز : "..neews.."\nالخاسر : "..neewss.."\nالجائزة : "..convert_mony.." دينار 💵\nنسبة قوة المهاجم اصبحت "..numattackk.." 🩸\n","md",true)
elseif Descriptioont == "7" then
local ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
local ballancope = redis:get("boob"..msg.sender.user_id) or 0
halfzrf = coniss / 2
zrfne = ballancope - halfzrf
zrfnee = ballanceed + halfzrf
redis:set("boob"..msg.sender.user_id , math.floor(zrfne))
redis:set("boob"..Remsg.sender.user_id , math.floor(zrfnee))
redis:setex("attack" .. msg.sender.user_id,600, true)
local convert_mony = string.format("%.0f",math.floor(halfzrf))
bot.sendText(msg.chat_id,msg.id, "⇜ لقد خسرت في المعركة "..neews.." 🛡\nولكن استطعت اعادة نصف الموارد\nالفائز : "..neewss.."\nالخاسر : "..neews.."\nالجائزة : "..convert_mony.." دينار 💵\n","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يمتلك حساب بنكي ","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'مسح لعبه الزواج' then
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
local zwag_users = redis:smembers("roogg1")
for k,v in pairs(zwag_users) do
redis:del("roog1"..v)
redis:del("rooga1"..v)
redis:del("rahr1"..v)
redis:del("rahrr1"..v)
redis:del("roogte1"..v)
end
local zwaga_users = redis:smembers("roogga1")
for k,v in pairs(zwaga_users) do
redis:del("roog1"..v)
redis:del("rooga1"..v)
redis:del("rahr1"..v)
redis:del("rahrr1"..v)
redis:del("roogte1"..v)
end
redis:del("roogga1")
redis:del("roogg1")
bot.sendText(msg.chat_id,msg.id, "⇜ مسحت لعبه الزواج","md",true)
end
end
if text == 'زواج' then
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`زواج` المهر","md",true)
end
if text and text:match("^زواج (%d+)$") and msg.reply_to_message_id == 0 then
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`زواج` المهر ( بالرد )","md",true)
end
if text and text:match("^زواج (.*)$") and msg.reply_to_message_id ~= 0 then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local UserName = text:match('^زواج (.*)$')
local coniss = coin(UserName)
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if msg.sender.user_id == Remsg.sender.user_id then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ زوجتك نفسي 🤣😒*","md",true)  
return false
end
if tonumber(coniss) < 10000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح به هو 10000 دينار \n","md",true)
end
ballancee = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(ballancee) < 10000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
if tonumber(coniss) > tonumber(ballancee) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي\n","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ ماني حق زواجات وخرابيط*","md",true)  
return false
end
if redis:get("roog1"..msg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id, "⇜ انت بالفعل متزوج !!","md",true)
return false
end
if redis:get("rooga1"..msg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id, "⇜ انت بالفعل متزوج !!","md",true)
return false
end
if redis:get("roog1"..Remsg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id, "⇜ اترك المتزوجين ياخي","md",true)
return false
end
if redis:get("rooga1"..Remsg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id, "⇜ اترك المتزوجين ياخي","md",true)
return false
end
local bandd = bot.getUser(msg.sender.user_id)
if bandd.first_name then
neews = "["..bandd.first_name.."](tg://user?id="..bandd.id..")"
else
neews = " لا يوجد"
end
local ban = bot.getUser(Remsg.sender.user_id)
if ban.first_name then
newws = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
newws = " لا يوجد"
end
if redis:sismember("booob",msg.sender.user_id) then
local hadddd = tonumber(coniss)
ballanceekk = tonumber(coniss) / 100 * 15
ballanceekkk = tonumber(coniss) - ballanceekk
local convert_mony = string.format("%.0f",ballanceekkk)
ballancee = redis:get("boob"..msg.sender.user_id) or 0
ballanceea = redis:get("boob"..Remsg.sender.user_id) or 0
zogtea = ballanceea + ballanceekkk
zeugh = ballancee - tonumber(coniss)
redis:set("boob"..msg.sender.user_id , math.floor(zeugh))
redis:set("boob"..Remsg.sender.user_id , math.floor(zogtea))
redis:sadd("roogg1",msg.sender.user_id)
redis:sadd("roogga1",Remsg.sender.user_id)
redis:set("roog1"..msg.sender.user_id,msg.sender.user_id)
redis:set("rooga1"..msg.sender.user_id,Remsg.sender.user_id)
redis:set("roogte1"..Remsg.sender.user_id,Remsg.sender.user_id)
redis:set("rahr1"..msg.sender.user_id,tonumber(coniss))
redis:set("rahr1"..Remsg.sender.user_id,tonumber(coniss))
redis:set("roog1"..Remsg.sender.user_id,msg.sender.user_id)
redis:set("rahrr1"..msg.sender.user_id,math.floor(ballanceekkk))
redis:set("rooga1"..Remsg.sender.user_id,Remsg.sender.user_id)
redis:set("rahrr1"..Remsg.sender.user_id,math.floor(ballanceekkk))
bot.sendText(msg.chat_id,msg.id, "كولولولولويششش\nاليوم عقدنا قران :\n\nالزوج "..neews.." 🤵🏻\n   💗\nالزوجة "..newws.." 👰🏻‍♀️\nالمهر : "..convert_mony.." دينار بعد الضريبة 15%\nعشان تشوفون وثيقة زواجكم اكتبوا : *زواجي*","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == "توب زواج" or text == "توب متزوجات" or text == "توب زوجات" or text == "توب زواجات" or text == "زواجات" or text == "الزواجات" then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
  local zwag_users = redis:smembers("roogg1")
  if #zwag_users == 0 then
  return bot.sendText(msg.chat_id,msg.id,"⇜ لا يوجد زواجات حاليا","md",true)
  end
  top_zwag = "توب 30 اغلى زواجات :\n\n"
  zwag_list = {}
  for k,v in pairs(zwag_users) do
  local mahr = redis:get("rahr1"..v)
  local zwga = redis:get("rooga1"..v)
  table.insert(zwag_list, {tonumber(mahr) , v , zwga})
  end
  table.sort(zwag_list, function(a, b) return a[1] > b[1] end)
  znum = 1
  zwag_emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)",
"21)",
"22)",
"23)",
"24)",
"25)",
"26)",
"27)",
"28)",
"29)",
"30)"
  }
  for k,v in pairs(zwag_list) do
  if znum <= 30 then
  local zwg_name = bot.getUser(v[2]).first_name or redis:get(v[2].."first_name:") or "لا يوجد اسم"
  local zwga_name = bot.getUser(v[3]).first_name or redis:get(v[3].."first_name:") or "لا يوجد اسم"
  local mahr = v[1]
  local convert_mony = string.format("%.0f",mahr)
  local emo = zwag_emoji[k]
  znum = znum + 1
  top_zwag = top_zwag..emo.." "..convert_mony.." 💵 ꗝ "..zwg_name.." 👫 "..zwga_name.."\n"
  end
  end
  local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '𝖲𝗈𝗎𝗋c𝖾 xX𝖲𝗍𝗋𝖾𝗆', url="t.me/xXStrem"},
},
}
}
return bot.sendText(msg.chat_id,msg.id,top_zwag,"html",false, false, false, false, reply_markup)
  end

if text == 'زواجي' then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("roogg1",msg.sender.user_id) or redis:sismember("roogga1",msg.sender.user_id) then
local zoog = redis:get("roog1"..msg.sender.user_id)
local zooga = redis:get("rooga1"..msg.sender.user_id)
local mahr = redis:get("rahr1"..msg.sender.user_id)
local convert_mony = string.format("%.0f",mahr)
local bandd = bot.getUser(zoog)
if bandd.first_name then
neews = "["..bandd.first_name.."](tg://user?id="..bandd.id..")"
else
neews = " لا يوجد"
end
local ban = bot.getUser(zooga)
if ban.first_name then
newws = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
newws = " لا يوجد"
end
bot.sendText(msg.chat_id,msg.id, "وثيقة الزواج حقتك :\n\nالزوج "..neews.." 🤵🏻\nالزوجة "..newws.." 👰🏻‍♀️\nالمهر : "..convert_mony.." دينار 💵","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت اعزب","md",true)
end
end

if text == 'زوجها' or text == "زوجته" or text == "جوزها" or text == "زوجتو" or text == "زواجه" and msg.reply_to_message_id ~= 0 then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if msg.sender.user_id == Remsg.sender.user_id then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ لا تكشف نفسك وتخسر فلوس عالفاضي\n اكتب `زواجي`*","md",true)  
return false
end
if redis:sismember("roogg1",Remsg.sender.user_id) or redis:sismember("roogga1",Remsg.sender.user_id) then
if redis:sismember("booob",msg.sender.user_id) then
ballancee = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(ballancee) < 100 then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ هذا الشخص غير متزوج*","md",true)  
return false
end
local zoog = redis:get("roog1"..Remsg.sender.user_id)
local zooga = redis:get("rooga1"..Remsg.sender.user_id)
local mahr = redis:get("rahr1"..Remsg.sender.user_id)
local bandd = bot.getUser(zoog)
if bandd.first_name then
neews = "["..bandd.first_name.."](tg://user?id="..bandd.id..")"
else
neews = " لا يوجد"
end
local ban = bot.getUser(zooga)
if ban.first_name then
newws = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
newws = " لا يوجد"
end
local otheka = ballancee - 100
local convert_mony = string.format("%.0f",mahr)
redis:set("boob"..msg.sender.user_id , math.floor(otheka))
bot.sendText(msg.chat_id,msg.id, "وثيقة الزواج حقته :\n\nالزوج "..neews.." 🤵🏻\nالزوجة "..newws.." 👰🏻‍♀️\nالمهر : "..convert_mony.." دينار 💵","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ مسكين اعزب مش متزوج","md",true)
end
end

if text == 'طلاق' then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("roogg1",msg.sender.user_id) or redis:sismember("roogga1",msg.sender.user_id) then
local zoog = redis:get("roog1"..msg.sender.user_id)
local zooga = tonumber(redis:get("rooga1"..msg.sender.user_id))
if tonumber(zoog) == msg.sender.user_id then
local bandd = bot.getUser(zoog)
if bandd.first_name then
neews = "["..bandd.first_name.."](tg://user?id="..bandd.id..")"
else
neews = " لا يوجد"
end
local ban = bot.getUser(zooga)
if ban.first_name then
newws = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
newws = " لا يوجد"
end
redis:srem("roogg1", msg.sender.user_id)
redis:srem("roogga1", msg.sender.user_id)
redis:del("roog1"..msg.sender.user_id)
redis:del("rooga1"..msg.sender.user_id)
redis:del("rahr1"..msg.sender.user_id)
redis:del("rahrr1"..msg.sender.user_id)
redis:srem("roogg1", zooga)
redis:srem("roogga1", zooga)
redis:del("roog1"..zooga)
redis:del("rooga1"..zooga)
redis:del("rahr1"..zooga)
redis:del("rahrr1"..zooga)
return bot.sendText(msg.chat_id,msg.id, "⇜ تم طلاقك من زوجتك "..newws.."","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ الطلاق للزوج فقط","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت اعزب","md",true)
end
end
if text == 'خلع' then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("roogg1",msg.sender.user_id) or redis:sismember("roogga1",msg.sender.user_id) then
local zoog = redis:get("roog1"..msg.sender.user_id)
local zooga = redis:get("rooga1"..msg.sender.user_id)
if tonumber(zooga) == msg.sender.user_id then
local mahrr = redis:get("rahrr1"..msg.sender.user_id)
local bandd = bot.getUser(zoog)
if bandd.first_name then
neews = "["..bandd.first_name.."](tg://user?id="..bandd.id..")"
else
neews = " لا يوجد"
end
local ban = bot.getUser(zooga)
if ban.first_name then
newws = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
newws = " لا يوجد"
end
ballancee = redis:get("boob"..zoog) or 0
kalea = ballancee + mahrr
redis:set("boob"..zoog , kalea)
local convert_mony = string.format("%.0f",mahrr)
bot.sendText(msg.chat_id,msg.id, "⇜ خلعت زوجك "..neews.."\n⇜ ورجعت له المهر ( "..convert_mony.." دينار 💵 )","md",true)
redis:srem("roogg1", zoog)
redis:srem("roogga1", zoog)
redis:del("roog1"..zoog)
redis:del("rooga1"..zoog)
redis:del("rahr1"..zoog)
redis:del("rahrr1"..zoog)
redis:srem("roogg1", msg.sender.user_id)
redis:srem("roogga1", msg.sender.user_id)
redis:del("roog1"..msg.sender.user_id)
redis:del("rooga1"..msg.sender.user_id)
redis:del("rahr1"..msg.sender.user_id)
redis:del("rahrr1"..msg.sender.user_id)
else
bot.sendText(msg.chat_id,msg.id, "⇜ الخلع للزوجات فقط","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "• الخلع للمتزوجات فقط","md",true)
end
end
if text == 'مراهنه' or text == 'مراهنة' then
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`مراهنه` المبلغ","md",true)
end
if text and text:match('^مراهنه (.*)$') or text and text:match('^مراهنة (.*)$') then
local UserName = text:match('^مراهنه (.*)$') or text:match('^مراهنة (.*)$')
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local coniss = coin(UserName)
ballancee = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(ballancee) < tonumber(coniss) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
redis:del(MisTiri..'List_rhan'..msg.chat_id)  
redis:set(MisTiri.."playerrhan"..msg.chat_id,msg.sender.user_id)
redis:set(MisTiri.."playercoins"..msg.chat_id..msg.sender.user_id,coniss)
redis:set(MisTiri.."raeahkam"..msg.chat_id,msg.sender.user_id)
redis:sadd(MisTiri..'List_rhan'..msg.chat_id,msg.sender.user_id)
redis:setex(MisTiri.."Start_rhan"..msg.chat_id,3600,true)
redis:set(MisTiri.."allrhan"..msg.chat_id..12345 , coniss)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
rehan = tonumber(ballancee) - tonumber(coniss)
redis:set("boob"..msg.sender.user_id , rehan)
return bot.sendText(msg.chat_id,msg.id,"• تم بدء المراهنة وتم تسجيلك \n• اللي بده يشارك يرسل ( انا والمبلغ ) .","md",true)
end
if text == 'نعم' and redis:get(MisTiri.."Witting_Startrhan"..msg.chat_id) then
rarahkam = redis:get(MisTiri.."raeahkam"..msg.chat_id)
if tonumber(rarahkam) == msg.sender.user_id then
local list = redis:smembers(MisTiri..'List_rhan'..msg.chat_id) 
if #list == 1 then 
return bot.sendText(msg.chat_id,msg.id,"• عذراً لم يشارك احد بالرهان","md",true)  
end 
local UserName = list[math.random(#list)]
local UserId_Info = bot.getUser(UserName)
if UserId_Info.username and UserId_Info.username ~= "" then
ls = '['..UserId_Info.first_name..'](tg://user?id='..UserName..')'
else
ls = '@['..UserId_Info.username..']'
end
benrahan = redis:get(MisTiri.."allrhan"..msg.chat_id..12345) or 0
local ballancee = redis:get("boob"..UserName) or 0
rehan = tonumber(ballancee) + tonumber(benrahan)
redis:set("boob"..UserName , rehan)

local rhan_users = redis:smembers(MisTiri.."List_rhan"..msg.chat_id)
for k,v in pairs(rhan_users) do
redis:del(MisTiri..'playercoins'..msg.chat_id..v)
end
redis:del(MisTiri..'allrhan'..msg.chat_id..12345) 
redis:del(MisTiri..'playerrhan'..msg.chat_id) 
redis:del(MisTiri..'raeahkam'..msg.chat_id) 
redis:del(MisTiri..'List_rhan'..msg.chat_id) 
redis:del(MisTiri.."Witting_Startrhan"..msg.chat_id)
redis:del(MisTiri.."Start_rhan"..msg.chat_id)
local ballancee = redis:get("boob"..UserName) or 0
local convert_mony = string.format("%.0f",benrahan)
local convert_monyy = string.format("%.0f",ballancee)
return bot.sendText(msg.chat_id,msg.id,'⇜ فاز '..ls..' بالرهان 🎊\nالمبلغ : '..convert_mony..' دينار 💵\nرصيدك حاليا : '..convert_monyy..' دينار 💵\n',"md",true)
end
end
if text == 'كنز' then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("booob",msg.sender.user_id) then
if redis:ttl("yiioooo" .. msg.sender.user_id) >= 60 then
local time = redis:ttl("yiioooo" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ فرصة ايجاد كنز آخر بعد ( "..time.." ثانية )","md",true)
end
local Textinggt = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22","23",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
neews = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
neews = " لا يوجد "
end
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
if Descriptioont == "1" then
local knez = ballancee + 40000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : قطعة اثرية 🗳\nسعره : 40000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "2" then
local knez = ballancee + 35000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : حجر الليدري 💎\nسعره : 35000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "3" then
local knez = ballancee + 10000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : لباس قديم 🥻\nسعره : 10000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "4" then
local knez = ballancee + 23000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : عصى سحرية 🪄\nسعره : 23000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "5" then
local knez = ballancee + 8000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : جوال نوكيا 📱\nسعره : 8000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "6" then
local knez = ballancee + 27000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : صدف 🏝\nسعره : 27000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "7" then
local knez = ballancee + 18000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : ابريق صدئ ⚗️\nسعره : 18000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "8" then
local knez = ballancee + 100000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : قناع فرعوني 🗿\nسعره : 100000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "9" then
local knez = ballancee + 50000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : جرة ذهب 💰\nسعره : 50000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "10" then
local knez = ballancee + 36000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : مصباح فضي 🔦\nسعره : 36000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "11" then
local knez = ballancee + 29000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : لوحة نحاسية 🌇\nسعره : 29000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "12" then
local knez = ballancee + 1000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : جوارب قديمة 🧦\nسعره : 1000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "13" then
local knez = ballancee + 16000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : اناء فخاري ⚱️\nسعره : 16000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "14" then
local knez = ballancee + 12000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : خوذة محارب 🪖\nسعره : 12000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "15" then
local knez = ballancee + 19000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : سيف جدي مرزوق 🗡\nسعره : 19000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "16" then
local knez = ballancee + 14000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : مكنسة جدتي رقية 🧹\nسعره : 14000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "17" then
local knez = ballancee + 26000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : فأس ارطغرل 🪓\nسعره : 26000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "18" then
local knez = ballancee + 22000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : بندقية 🔫\nسعره : 22000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "19" then
local knez = ballancee + 11000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : كبريت ناري 🪔\nسعره : 11000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "20" then
local knez = ballancee + 33000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : فرو ثعلب 🦊\nسعره : 33000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "21" then
local knez = ballancee + 40000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : جلد تمساح 🐊\nسعره : 40000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "22" then
local knez = ballancee + 17000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : باقة ورود 💐\nسعره : 17000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "23" then
local Textinggtt = {"1", "2",}
local Descriptioontt = Textinggtt[math.random(#Textinggtt)]
if Descriptioontt == "1" then
local knez = ballancee + 17000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : باقة ورود 💐\nسعره : 17000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioontt == "2" then
local Textinggttt = {"1", "2",}
local Descriptioonttt = Textinggttt[math.random(#Textinggttt)]
if Descriptioonttt == "1" then
local knez = ballancee + 40000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : جلد تمساح 🐊\nسعره : 40000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioonttt == "2" then
local knez = ballancee + 10000000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : حقيبة محاسب البنك 💼\nسعره : 10000000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
end
end
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^حظر حساب (.*)$') then
local UserName = text:match('^حظر حساب (.*)$')
local coniss = coin(UserName)
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
redis:set("bandid"..coniss,coniss)
bot.sendText(msg.chat_id,msg.id, "⇜ تم حظر الحساب "..coniss.." من لعبة البنك\n","md",true)
end
end
if text and text:match('^الغاء حظر حساب (.*)$') then
local UserName = text:match('^الغاء حظر حساب (.*)$')
local coniss = coin(UserName)
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
redis:del("bandid"..coniss)
bot.sendText(msg.chat_id,msg.id, "⇜ تم الغاء حظر الحساب "..coniss.." من لعبة البنك\n","md",true)
end
end
if text and text:match('^اضف كوبون (.*)$') then
local UserName = text:match('^اضف كوبون (.*)$')
local coniss = coin(UserName)
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
numcobo = math.random(1000000000000,9999999999999);
redis:set("cobonum"..numcobo,numcobo)
redis:set("cobon"..numcobo,coniss)
bot.sendText(msg.chat_id,msg.id, "⇜ وصل كوبون \n\nالمبلغ : "..coniss.." دينار 💵\nرقم الكوبون : `"..numcobo.."`\n\n⇜ طريقة استخدام الكوبون :\nتكتب ( كوبون + رقمه )\nمثال : كوبون 4593875\n","md",true)
end
end
if text == "كوبون" or text == "الكوبون" then
bot.sendText(msg.chat_id,msg.id, "⇜ طريقة استخدام الكوبون :\nتكتب ( كوبون + رقمه )\nمثال : كوبون 4593875\n\n- ملاحظة : الكوبون يستخدم لمرة واحدة ولشخص واحد\n","md",true)
end
if text and text:match('^كوبون (.*)$') then
local UserName = text:match('^كوبون (.*)$')
local coniss = coin(UserName)
if redis:sismember("booob",msg.sender.user_id) then
cobnum = redis:get("cobonum"..coniss)
if coniss == tonumber(cobnum) then
cobblc = redis:get("cobon"..coniss)
ballancee = redis:get("boob"..msg.sender.user_id) or 0
cobonplus = ballancee + cobblc
redis:set("boob"..msg.sender.user_id , cobonplus)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
redis:del("cobon"..coniss)
redis:del("cobonum"..coniss)
bot.sendText(msg.chat_id,msg.id, "⇜ وصل كوبون \n\nالمبلغ : "..cobblc.." دينار 💵\nرقم الكوبون : `"..coniss.."`\nفلوسك حاليا : "..convert_mony.." دينار 💵\n","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يوجد كوبون بهذا الرقم `"..coniss.."`\n","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ","md",true)
end
end
if text == "توب" or text == "التوب" then
local toptop = "⇜ أهلاً بك في قوائم التوب\nللمزيد من التفاصيل - [@xXStrem]\n"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'السرقة', data = msg.sender.user_id..'/topzrf'},{text = 'الفلوس', data = msg.sender.user_id..'/topmon'},
},
{
{text = '𝖲𝗈𝗎𝗋c𝖾 xX𝖲𝗍𝗋𝖾𝗆', url="t.me/xXStrem"},
},
}
}
return bot.sendText(msg.chat_id,msg.id,toptop,"md",false, false, false, false, reply_markup)
end
----------------------------------------------------
--نهاية البنك
----------------------------------------------------------------------------------------------------
if text == 'تفعيل' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذراً البوت ليس ادمن في المجموعة*","md",true)  
return false
end
sm = bot.getChatMember(msg.chat_id,msg.sender.user_id)
if not developer(msg) then
if sm.status.luatele ~= "chatMemberStatusCreator" and sm.status.luatele ~= "chatMemberStatusAdministrator" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذراً يجب أنْ تكون مشرف او مالك المجموعة*","md",true)  
return false
end
end
if sm.status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",msg.sender.user_id)
else
redis:sadd(bot_id..":"..msg.chat_id..":Status:Administrator",msg.sender.user_id)
end
if redis:sismember(bot_id..":Groups",msg.chat_id) then
 bot.sendText(msg.chat_id,msg.id,'*  ⌔︙تم تفعيل المجموعة سابقا*',"md",true)  
return false
else
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
UserInfo = bot.getUser(msg.sender.user_id).first_name
bot.sendText(sudoid,0,'*\n  ⌔︙تم تفعيل مجموعة جديده \n  ⌔︙بواسطة : (*['..UserInfo..'](tg://user?id='..msg.sender.user_id..')*)\n  ⌔︙معلومات المجموعة :\n  ⌔︙عدد الاعضاء : '..Info_Chats.member_count..'\n  ⌔︙عدد الادامن : '..Info_Chats.administrator_count..'\n  ⌔︙عدد المطرودين : '..Info_Chats.banned_count..'\n  ⌔︙عدد المقيدين : '..Info_Chats.restricted_count..'\n  ⌔︙الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md", true, false, false, false, reply_markup)
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙تم تفعيل المجموعة بنجاح*',"md", true, false, false, false, reply_markup)
redis:sadd(bot_id..":Groups",msg.chat_id)
end
end
if text == 'تعطيل' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذراً البوت ليس ادمن في المجموعة .*","md",true)  
return false
end
sm = bot.getChatMember(msg.chat_id,msg.sender.user_id)
if not developer(msg) then
if sm.status.luatele ~= "chatMemberStatusCreator" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذراً يجب أنْ تكون مالك المجموعة فقط*","md",true)  
return false
end
end
if redis:sismember(bot_id..":Groups",msg.chat_id) then
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}},
}
}
UserInfo = bot.getUser(msg.sender.user_id).first_name
bot.sendText(sudoid,0,'*\n  ⌔︙تم تعطيل المجموعة التاليه : \n  ⌔︙بواسطة : (*['..UserInfo..'](tg://user?id='..msg.sender.user_id..')*)\n  ⌔︙معلومات المجموعة :\n  ⌔︙عدد الاعضاء : '..Info_Chats.member_count..'\n  ⌔︙عدد الادامن : '..Info_Chats.administrator_count..'\n  ⌔︙عدد المطرودين : '..Info_Chats.banned_count..'\n  ⌔︙عدد المقيدين : '..Info_Chats.restricted_count..'\n  ⌔︙الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md", true, false, false, false, reply_markup)
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙تم تعطيل المجموعة بنجاح*',"md",true, false, false, false, reply_markup)
redis:srem(bot_id..":Groups",msg.chat_id)
local keys = redis:keys(bot_id..'*'..'-100'..data.supergroup.id..'*')
redis:del(bot_id..":"..msg.chat_id..":Status:Creator")
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Owner")
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator")
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
redis:del(bot_id.."List:Command:"..msg.chat_id)
for i = 1, #keys do 
redis:del(keys[i])
end
return false
else
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙المجموعة معطلة بالفعل*',"md", true)
end
end
----------------------------------------------------------------------------------------------------
end --- end Run
end --- end Run
----------------------------------------------------------------------------------------------------
function Call(data)
if redis:get(bot_id..":Notice") then
if data and data.luatele and data.luatele == "updateSupergroup" then
local Get_Chat = bot.getChat('-100'..data.supergroup.id)
if data.supergroup.status.luatele == "chatMemberStatusBanned" then
redis:srem(bot_id..":Groups",'-100'..data.supergroup.id)
local keys = redis:keys(bot_id..'*'..'-100'..data.supergroup.id..'*')
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Creator")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:BasicConstructor")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Constructor")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Owner")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Administrator")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Vips")
redis:del(bot_id.."List:Command:"..'-100'..data.supergroup.id)
for i = 1, #keys do 
redis:del(keys[i])
end
Get_Chat = bot.getChat('-100'..data.supergroup.id)
Info_Chats = bot.getSupergroupFullInfo('-100'..data.supergroup.id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}},
}
}
return bot.sendText(sudoid,0,'  ⌔︙تم طرد البوت من مجموعة جديده\n  ⌔︙معلومات المجموعة :\n  ⌔︙الايدي : ( -100'..data.supergroup.id..' )\n*  ⌔︙عدد الاعضاء : '..Info_Chats.member_count..'\n  ⌔︙عدد الادامن : '..Info_Chats.administrator_count..'\n  ⌔︙عدد المطرودين : '..Info_Chats.banned_count..'\n  ⌔︙عدد المقيدين : '..Info_Chats.restricted_count..'\n  ⌔︙الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md",true, false, false, false, reply_markup)
end
end
end
print(serpent.block(data, {comment=false}))   
if data and data.luatele and data.luatele == "updateNewMessage" then
if data.message.sender.luatele == "messageSenderChat" then
if redis:get(bot_id..":"..data.message.chat_id..":settings:messageSenderChat") == "del" then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
return false
end
end
if data.message.sender.luatele ~= "messageSenderChat" then
if tonumber(data.message.sender.user_id) ~= tonumber(bot_id) then  
if data.message.content.text and data.message.content.text.text:match("^(.*)$") then
if redis:get(bot_id..":"..data.message.chat_id..":"..data.message.sender.user_id..":Command:del") == "true" then
redis:del(bot_id..":"..data.message.chat_id..":"..data.message.sender.user_id..":Command:del")
if redis:get(bot_id..":"..data.message.chat_id..":Command:"..data.message.content.text.text) then
redis:del(bot_id..":"..data.message.chat_id..":Command:"..data.message.content.text.text)
redis:srem(bot_id.."List:Command:"..data.message.chat_id,data.message.content.text.text)
t = "  ⌔︙تم حذف الامر بنجاح"
else
t = "   ⌔︙عذراً الامر  ( "..data.message.content.text.text.." ) غير موجود "
end
bot.sendText(data.message.chat_id,data.message.id,"*"..t.."*","md",true)  
end
end
if data.message.content.text then
local NewCmd = redis:get(bot_id..":"..data.message.chat_id..":Command:"..data.message.content.text.text)
if NewCmd then
data.message.content.text.text = (NewCmd or data.message.content.text.text)
end
end
if data.message.content.text then
td = data.message.content.text.text
if redis:get(bot_id..":TheCh") then
infokl = bot.getChatMember(redis:get(bot_id..":TheCh"),bot_id)
if infokl and infokl.status and infokl.status.luatele == "chatMemberStatusAdministrator" then
if not devS(data.message.sender.user_id) then
if td == "/start" or  td == "ايدي" or  td == "الرابط" or  td == "قفل الكل" or  td == "فتح الكل" or  td == "الاوامر" or  td == "م1" or  td == "م2" or  td == "م3" or  td == "كشف" or  td == "رتبتي" or  td == "المنشئ" or  td == "قفل الصور" or  td == "قفل الالعاب" or  td == "الالعاب" or  td == "العكس" or  td == "روليت" or  td == "كت" or  td == "تنزيل الكل" or  td == "رفع ادمن" or  td == "رفع مميز" or  td == "رفع منشئ" or  td == "المكتومين" or  td == "قفل المتحركات"  then
if bot.getChatMember(redis:get(bot_id..":TheCh"),data.message.sender.user_id).status.luatele == "chatMemberStatusLeft" then
Get_Chat = bot.getChat(redis:get(bot_id..":TheCh"))
Info_Chats = bot.getSupergroupFullInfo(redis:get(bot_id..":TheCh"))
if Info_Chats and Info_Chats.invite_link and Info_Chats.invite_link.invite_link and  Get_Chat and Get_Chat.title then 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = Get_Chat.title,url=Info_Chats.invite_link.invite_link}},
}
}
return bot.sendText(data.message.chat_id,data.message.id,Reply_Status(data.message.sender.user_id,"*  ⌔︙عليك الاشتراك في قناة البوت اولاً !*").yu,"md", true, false, false, false, reply_dev)
end
end
end
end
end
end
end
if redis:sismember(bot_id..":bot:Ban", data.message.sender.user_id) then    
if GetInfoBot(data.message).BanUser then
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif GetInfoBot(data.message).BanUser == false then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
end
end  
if redis:sismember(bot_id..":bot:silent", data.message.sender.user_id) then    
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
end  
if redis:sismember(bot_id..":"..data.message.chat_id..":silent", data.message.sender.user_id) then    
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})  
end
if redis:sismember(bot_id..":"..data.message.chat_id..":Ban", data.message.sender.user_id) then    
if GetInfoBot(data.message).BanUser then
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif GetInfoBot(data.message).BanUser == false then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
end
end 
if redis:sismember(bot_id..":"..data.message.chat_id..":restrict", data.message.sender.user_id) then    
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
end  
if not Administrator(msg) then
if data.message.content.text then
hash = redis:sismember(bot_id.."mn:content:Text"..data.message.chat_id, data.message.content.text.text)
tu = "الرسالة"
ut = "ممنوعه"
elseif data.message.content.sticker then
hash = redis:sismember(bot_id.."mn:content:Sticker"..data.message.chat_id, data.message.content.sticker.sticker.remote.unique_id)
tu = "الملصق"
ut = "ممنوع"
elseif data.message.content.animation then
hash = redis:sismember(bot_id.."mn:content:Animation"..data.message.chat_id, data.message.content.animation.animation.remote.unique_id)
tu = "المتحركة"
ut = "ممنوعه"
elseif data.message.content.photo then
hash = redis:sismember(bot_id.."mn:content:Photo"..data.message.chat_id, data.message.content.photo.sizes[1].photo.remote.unique_id)
tu = "الصورة"
ut = "ممنوعه"
end
if hash then    
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
bot.sendText(data.message.chat_id,data.message.id,Reply_Status(data.message.sender.user_id,"*  ⌔︙"..tu.." "..ut.." من المجموعة*").yu,"md",true)  
end
end
if data.message and data.message.content then
if data.message.content.luatele == "messageSticker" or data.message.content.luatele == "messageContact" or data.message.content.luatele == "messageVideoNote" or data.message.content.luatele == "messageDocument" or data.message.content.luatele == "messageVideo" or data.message.content.luatele == "messageAnimation" or data.message.content.luatele == "messagePhoto" then
redis:sadd(bot_id..":"..data.message.chat_id..":mediaAude:ids",data.message.id)  
end
end
Run(data.message,data)
if data.message.content.text then
if data.message.content.text and not redis:sismember(bot_id..'Spam:Group'..data.message.sender.user_id,data.message.content.text.text) then
redis:del(bot_id..'Spam:Group'..data.message.sender.user_id) 
end
end
if data.message.content.luatele == "messageChatJoinByLink" then
if redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink")== "del" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink")== "ked" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink") == "ktm" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink")== "kick" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
end
end
if data.message.content.luatele == "messageChatDeleteMember" or data.message.content.luatele == "messageChatAddMembers" or data.message.content.luatele == "messagePinMessage" or data.message.content.luatele == "messageChatChangeTitle" or data.message.content.luatele == "messageChatJoinByLink" then
if redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr")== "del" then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr")== "ked" then
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr") == "ktm" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr")== "kick" then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
end
end 
end
if data.message.content.luatele == "messageChatAddMembers" and redis:get(bot_id..":infobot") then 
if data.message.content.member_user_ids[1] == tonumber(bot_id) then 
local photo = bot.getUserProfilePhotos(bot_id)
kup = bot.replyMarkup{
type = 'inline',data = {
{{text =" ⌔︙ اضفني الى مجموعتك",url="https://t.me/"..bot.getMe().username.."?startgroup=new"}},
}
}
if photo.total_count > 0 then
bot.sendPhoto(data.message.chat_id, data.message.id, photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id,"*  ⌔︙اهلا بك في بوت الحماية\n  ⌔︙وضيفتي حماية المجموعات من السبام والتفليش والخ..\n  ⌔︙لتفعيل البوت ارسل كلمه *تفعيل", 'md', nil, nil, nil, nil, nil, nil, nil, nil, nil, kup)
else
bot.sendText(data.message.chat_id,data.message.id,"*  ⌔︙اهلا بك في بوت الحماية \n  ⌔︙وضيفتي حماية المجموعات من السبام والتفليش والخ..\n  ⌔︙لتفعيل البوت ارسل كلمه *تفعيل","md",true, false, false, false, kup)
end
end
end
end
elseif data and data.luatele and data.luatele == "updateMessageEdited" then
local msg = bot.getMessage(data.chat_id, data.message_id)
if tonumber(msg.sender.user_id) ~= tonumber(bot_id) then  
if redis:sismember(bot_id..":bot:silent", msg.sender.user_id) then    
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end  
if redis:sismember(bot_id..":"..msg.chat_id..":silent", msg.sender.user_id) then    
bot.deleteMessages(msg.chat_id,{[1]= msg.id})  
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", msg.sender.user_id) then    
if GetInfoBot(msg).BanUser then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif GetInfoBot(msg).BanUser == false then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
end  
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", msg.sender.user_id) then    
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
end  
if not Administrator(msg) then
if msg.content.text then
hash = redis:sismember(bot_id.."mn:content:Text"..msg.chat_id, msg.content.text.text)
tu = "الرسالة"
ut = "ممنوعه"
elseif msg.content.sticker then
hash = redis:sismember(bot_id.."mn:content:Sticker"..msg.chat_id, msg.content.sticker.sticker.remote.unique_id)
tu = "الملصق"
ut = "ممنوع"
elseif msg.content.animation then
hash = redis:sismember(bot_id.."mn:content:Animation"..msg.chat_id, msg.content.animation.animation.remote.unique_id)
tu = "المتحركة"
ut = "ممنوعه"
elseif msg.content.photo then
hash = redis:sismember(bot_id.."mn:content:Photo"..msg.chat_id, msg.content.photo.sizes[1].photo.remote.unique_id)
tu = "الصورة"
ut = "ممنوعه"
end
if hash then    
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙"..tu.." "..ut.." من المجموعة*").yu,"md",true)  
end
end
Run(msg,data)
redis:incr(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") 
----------------------------------------------------------------------------------------------------
if not BasicConstructor(msg) then
if msg.content.luatele == "messageContact" or msg.content.luatele == "messageVideoNote" or msg.content.luatele == "messageDocument" or msg.content.luatele == "messageAudio" or msg.content.luatele == "messageVideo" or msg.content.luatele == "messageVoiceNote" or msg.content.luatele == "messageAnimation" or msg.content.luatele == "messagePhoto" then
if redis:get(bot_id..":"..msg.chat_id..":settings:Edited") then
if redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
ued = bot.getUser(msg.sender.user_id)
ues = " المستخدم : ["..ued.first_name.."](tg://user?id="..msg.sender.user_id..") "
infome = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
lsme = infome.members
t = "*  ⌔︙قام ( *"..ues.."* ) بتعديل رسالته \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ \n*"
for k, v in pairs(lsme) do
if infome.members[k].bot_info == nil then
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.username ~= "" then
t = t..""..k.."- [@"..UserInfo.username.."]\n"
else
t = t..""..k.."- ["..UserInfo.first_name.."](tg://user?id="..v.member_id.user_id..")\n"
end
end
end
if #lsme == 0 then
t = "*  ⌔︙لا يوجد مشرفين في المجموعة*"
end
bot.sendText(msg.chat_id,msg.id,t,"md", true)
end
end
end
end
elseif data and data.luatele and data.luatele == "updateNewCallbackQuery" then
Callback(data)
elseif data and data.luatele and data.luatele == "updateMessageSendSucceeded" then
if data.message and data.message.content then
if data.message.content.luatele == "messageSticker" or data.message.content.luatele == "messageContact" or data.message.content.luatele == "messageVideoNote" or data.message.content.luatele == "messageDocument" or data.message.content.luatele == "messageVideo" or data.message.content.luatele == "messageAnimation" or data.message.content.luatele == "messagePhoto" then
redis:sadd(bot_id..":"..data.message.chat_id..":mediaAude:ids",data.message.id)  
end
end
--
end
----------------------------------------------------------------------------------------------------
end
Runbot.run(Call)
